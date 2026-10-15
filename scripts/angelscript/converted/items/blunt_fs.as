#pragma context server

// Converted from items/blunt_fs.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/items/blunt_base_onehanded.as"

[script "items/blunt_fs"]
class BluntFs : BluntBaseOnehandedScript
{
	// Constants
	string BASE_LEVEL_REQ = "20";
	int FIRE_BURST_MP = 30;
	int MODEL_VIEW_IDX = 8;

	// Variables (an unset .script variable reads as its own name)
	string FIRE_BURST_TARGS = "FIRE_BURST_TARGS";
	Vector3 BURST_POS = Vector3();
	float BURST_DOT_BURN = 0.0f;

	// Variables declared by included files, with the value they start with in this script
	BluntFs()
	{
		MODEL_VIEW = "viewmodels/v_1hblunts.mdl";
		MODEL_WORLD = "weapons/p_weapons3.mdl";
		MODEL_BODY_OFS = "90";
		ANIM_PREFIX = "standard";
		MELEE_RANGE = "60";
		MELEE_DMG_DELAY = 0.6f;
		MELEE_ATK_DURATION = 1.1f;
		MELEE_ENERGY = 8.0f;
		MELEE_DMG = 250;
		MELEE_DMG_RANGE = 140;
		MELEE_DMG_TYPE = "fire";
		MELEE_ACCURACY = "80%";
	}

	// game_dodamage
	// 1: Attack Hit (1/0)  2: Entity Attack hit  3:  Start Position  4:  End Position
	string BluntFs_OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";

		if (!hit)
			return result;

		if (RandomInt(1, 5) != 1)
			return result;

		float burnDamage = Divide(SkillOf(ENT_OWNER, "spellcasting.fire"), 2.0f) + Random(1, 3);
		if (burnDamage < 5.0f)
			burnDamage = 5.0f;

		ApplyEffect(target, "effects/dot_fire", 5, @EntityOf(ENT_OWNER), burnDamage, "bluntarms");
		return result;
	}

	// weapon_spawn
	void OnWeaponSpawn()
	{
		BaseMelee_OnWeaponSpawn(); // items/base_melee
		BluntBaseOnehanded_OnWeaponSpawn(); // items/blunt_base_onehanded

		SetName("Fire Star");
		SetDescription("A morning star forged with elemental fire");
		SetWeight(35);
		SetValue(2000);
		SetHudSprite("hand", "mace");
		SetHudSprite("trade", "188");
	}

	// special_02_damaged_other
	void OnSpecial02DamagedOther(CBaseEntity@ target = null, float damage = 0.0f, string damageType = "", string damageEvent = "")
	{
		BluntBaseOnehanded_OnSpecial02DamagedOther(target, damage, damageType, damageEvent); // items/blunt_base_onehanded

		float burnDamage = Divide(SkillOf(ENT_OWNER, "spellcasting.fire"), 2.0f) + Random(1, 3);
		ApplyEffect(target, "effects/dot_fire", 5, @EntityOf(ENT_OWNER), burnDamage, "bluntarms");
	}

	string OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "") { return BluntFs_OnGameDodamage(hit, target, start, end, damageType, damageText); } // game_dodamage

	// special_02_strike
	void OnSpecial02Strike(string hitType = "", Vector3 endPos = Vector3(), CBaseEntity@ hitEntity = null, bool hit = false)
	{
		string noGoMsg = "NO_GO_MSG";
		if (endPos.z != GroundHeight(endPos))
			return;
		if (ManaOf(ENT_OWNER) < FIRE_BURST_MP)
			noGoMsg = "Fire Star: Insufficient Mana for Flame Burst";
		if (SkillOf(ENT_OWNER, "spellcasting.fire") < 20.0f)
			noGoMsg = "Fire Star: Insufficient Fire Skill for Flame Burst";
		if (noGoMsg != "NO_GO_MSG")
			PlayerMessageDark(ENT_OWNER, noGoMsg);
		if (noGoMsg != "NO_GO_MSG")
			return;
		PlaySound(0, 10, "ambience/steamburst1.wav");
		GiveMana(ENT_OWNER, -FIRE_BURST_MP);
		ClientEvent("new", "all", "effects/sfx_fire_burst", endPos, 128, 1, Vector3(255, 0, 0));
		CallExternal(ENT_OWNER, "ext_sphere_token", "enemy", 128, endPos);
		FIRE_BURST_TARGS = ScriptVarOf(ENT_OWNER, "PLR_SCAN_TOKEN");
		DebugPrint(FIRE_BURST_TARGS);
		BURST_POS = endPos;
		if (FIRE_BURST_TARGS == "none")
			return;
		BURST_DOT_BURN = SkillOf(ENT_OWNER, "spellcasting.fire") * 0.5f;
		int count = GetTokenCount(FIRE_BURST_TARGS);
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnFireBurstAffectTargs();
		}
	}

	// fire_burst_affect_targs
	void OnFireBurstAffectTargs()
	{
		bool exitSub = false;
		string curTarg = GetToken(FIRE_BURST_TARGS, loopIteration);

		if (IsPlayer(curTarg))
			exitSub = true;
		if (exitSub)
			return;

		Vector3 targOrg = OriginOf(curTarg);
		Vector3 traceStart = BURST_POS;
		string traceEnd = Text(targOrg);
		string traceLine = LegacyFunction("get_traceline", traceStart, traceEnd, "worldonly");
		if (traceLine != traceEnd)
			return;

		if (HealthOf(curTarg) < 1500.0f)
		{
			targOrg = OriginOf(curTarg);
			Vector3 myOrg = OriginOf(ENT_OWNER);
			float targAng = AnglesTo(myOrg, targOrg);
			int newYaw = int(targAng);
			AddVelocity(curTarg, RelativeVelocity(Vector3(0, newYaw, 0), Vector3(0, 800, 0)));
		}

		ApplyEffect(curTarg, "effects/dot_fire", 5.0f, @EntityOf(ENT_OWNER), BURST_DOT_BURN, "bluntarms");
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("weapons/p_weapons3.mdl");
		Precache("viewmodels/v_1hblunts.mdl");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "fire_burst_affect_targs") { OnFireBurstAffectTargs(); return true; }
		if (name == "game_dodamage") { Return(OnGameDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5))); return true; }
		if (name == "special_02_damaged_other") { OnSpecial02DamagedOther(EntityParam(params, 0), Float(Param(params, 1)), Param(params, 2), Param(params, 3)); return true; }
		if (name == "special_02_strike") { OnSpecial02Strike(Param(params, 0), Vec(Param(params, 1)), EntityParam(params, 2), Truthy(Param(params, 3))); return true; }
		if (name == "weapon_spawn") { OnWeaponSpawn(); return true; }
		return BluntBaseOnehandedScript::DispatchEvent(name, params);
	}
}
