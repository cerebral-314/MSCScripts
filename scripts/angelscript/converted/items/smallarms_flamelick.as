#pragma context server

// Converted from items/smallarms_flamelick.script by msc_transpiler.
// Dagger

#include "runtime/ScriptEntity.as"
#include "converted/items/smallarms_base.as"

[script "items/smallarms_flamelick"]
class SmallarmsFlamelick : SmallarmsBaseScript
{
	// Constants
	string BASE_LEVEL_REQ = "20";
	string MELEE_ALIGN_BASE = "3.6,-6";
	string MELEE_ALIGN_TIP = "0,0";

	// Variables (an unset .script variable reads as its own name)
	float CHARGE_COUNTER = 0.0f;
	float BURST_DAMAGE = 0.0f;
	string TARG_LIST = "TARG_LIST";

	// Variables declared by included files, with the value they start with in this script
	SmallarmsFlamelick()
	{
		MODEL_VIEW = "viewmodels/v_smallarms.mdl";
		MODEL_VIEW_IDX = 5;
		ANIM_LIFT1 = 0;
		ANIM_IDLE1 = "1";
		ANIM_WIELD = 2;
		ANIM_UNWIELD = 3;
		ANIM_WIELDEDIDLE1 = 4;
		ANIM_ATTACK1 = "5";
		ANIM_ATTACK2 = "6";
		MODEL_HANDS = "weapons/p_weapons2.mdl";
		MODEL_WORLD = "weapons/p_weapons2.mdl";
		MELEE_RANGE = "50";
		MELEE_DMG_DELAY = 0.2f;
		MELEE_ATK_DURATION = 0.9f;
		MELEE_ENERGY = 0.6f;
		MELEE_DMG_TYPE = "fire";
		MELEE_DMG = 250;
		MELEE_DMG_RANGE = 50;
		MELEE_ACCURACY = "85%";
		MELEE_PARRY_CHANCE = "25%";
		SOUND_HITWALL2 = "ambience/steamburst1.wav";
		MODEL_BODY_OFS = "32";
		ANIM_PREFIX = "firedagger";
	}

	// game_dodamage
	// 1: Attack Hit (1/0)  2: Entity Attack hit  3:  Start Position  4:  End Position
	string SmallarmsFlamelick_OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";

		if (!hit)
			return result;

		if (RandomInt(1, 5) != 1)
			return result;

		float burnDamage = Divide(SkillOf(ENT_OWNER, "spellcasting.fire"), 3.0f) + Random(1, 3);
		if (burnDamage < 5.0f)
			burnDamage = 5.0f;

		ApplyEffect(target, "effects/dot_fire", 5, @EntityOf(ENT_OWNER), burnDamage, "smallarms");
		return result;
	}

	// weapon_spawn
	// Called whenever the dagger spawns
	// Setup the basic info specific to this weapon
	void OnWeaponSpawn()
	{
		BaseMelee_OnWeaponSpawn(); // items/base_melee
		SmallarmsBase_OnWeaponSpawn(); // items/smallarms_base

		SetName("Flamelick");
		SetDescription("A magical dagger forged from the tongue of an Efreeti");
		SetWeight(3);
		SetValue(1000);
		SetHudSprite("hand", "107");
		SetHudSprite("trade", "107");
	}

	string OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "") { return SmallarmsFlamelick_OnGameDodamage(hit, target, start, end, damageType, damageText); } // game_dodamage

	// register_secondary
	void OnRegisterSecondary()
	{
		SetLocal("reg.attack.type", "strike-land");
		SetLocal("reg.attack.keys", "-attack1");
		SetLocal("reg.attack.range", MELEE_RANGE);
		SetLocal("reg.attack.dmg", 1);
		SetLocal("reg.attack.dmg.range", 1);
		SetLocal("reg.attack.dmg.type", "fire");
		SetLocal("reg.attack.energydrain", 9999);
		SetLocal("reg.attack.stat", "spellcasting.fire");
		SetLocal("reg.attack.hitchance", MELEE_ACCURACY);
		SetLocal("reg.attack.priority", 2);
		SetLocal("reg.attack.delay.strike", 1.0f);
		SetLocal("reg.attack.delay.end", 1.2f);
		SetLocal("reg.attack.ofs.startpos", "MELEE_STARTPOS");
		SetLocal("reg.attack.ofs.aimang", "MELEE_AIMANGLE");
		SetLocal("reg.attack.callback", "special_02");
		SetLocal("reg.attack.noise", 1000);
		SetLocal("reg.attack.chargeamt", "200%");
		SetLocal("reg.attack.reqskill", 10);
		SetLocal("reg.attack.dmg.ignore", 1);

		RegisterAttack();
	}

	// special_02_start
	void OnSpecial02Start()
	{
		PlaySound(0, 10, "magic/fireball_powerup.wav");
		Effect("glow", ENT_ME, Vector3(255, 75, 0), 128, 5.0f, 5.0f);
	}

	// special_02_strike
	void OnSpecial02Strike(string hitType = "", Vector3 endPos = Vector3(), CBaseEntity@ hitEntity = null, bool hit = false)
	{
		if (Text(CHARGE_COUNTER) == "CHARGE_COUNTER")
			CHARGE_COUNTER = 10.0f;
		if (CHARGE_COUNTER <= 0.0f)
			OwnerMessage("The flamelick's magic is exhausted, for now.");
		if (!(CHARGE_COUNTER > 0.0f))
			return;
		CHARGE_COUNTER -= 1.0f;
		int intCounter = int(CHARGE_COUNTER);
		OwnerMessage("The flamelick has " + intCounter + " charges remaining.");

		// local FLAME_BURST_DAMAGE $get(ent_owner,skill.spellcasting.fire)
		// createnpc monsters/summon/flame_burst $relpos(0,0,-32) $get(ent_owner,id) FLAME_BURST_DAMAGE 0 smallarms
		ClientEvent("new", "all", "monsters/summon/flame_burst_cl", IndexOf(ENT_OWNER));

		BURST_DAMAGE = SkillOf(ENT_OWNER, "spellcasting.fire");
		CallExternal(ENT_OWNER, "ext_sphere_token_x", "enemy", 256);
		TARG_LIST = ScriptVarOf(ENT_OWNER, "PLR_SCAN_TOKEN");
		if (TARG_LIST == "none")
			return;
		int count = GetTokenCount(TARG_LIST);
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnBurstAffectTargets();
			if (breakLoop)
			{
				breakLoop = false;
				break;
			}
		}
	}

	// burst_affect_targets
	void OnBurstAffectTargets()
	{
		bool exitSub = false;
		string curTarg = GetToken(TARG_LIST, loopIteration);
		if (IsPlayer(curTarg))
			exitSub = true;
		if (exitSub)
			return;

		ApplyEffect(curTarg, "effects/dot_fire", 5, @EntityOf(ENT_OWNER), BURST_DAMAGE, "smallarms");
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("weapons/p_weapons2.mdl");
		Precache("viewmodels/v_smallarms.mdl");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "burst_affect_targets") { OnBurstAffectTargets(); return true; }
		if (name == "game_dodamage") { Return(OnGameDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5))); return true; }
		if (name == "register_secondary") { OnRegisterSecondary(); return true; }
		if (name == "special_02_start") { OnSpecial02Start(); return true; }
		if (name == "special_02_strike") { OnSpecial02Strike(Param(params, 0), Vec(Param(params, 1)), EntityParam(params, 2), Truthy(Param(params, 3))); return true; }
		if (name == "weapon_spawn") { OnWeaponSpawn(); return true; }
		return SmallarmsBaseScript::DispatchEvent(name, params);
	}
}
