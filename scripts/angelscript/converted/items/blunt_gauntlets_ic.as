#pragma context server

// Converted from items/blunt_gauntlets_ic.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/items/blunt_gauntlets_demon.as"

[script "items/blunt_gauntlets_ic"]
class BluntGauntletsIc : BluntGauntletsDemonScript
{
	// Variables declared by included files, with the value they start with in this script
	BluntGauntletsIc()
	{
		BASE_LEVEL_REQ = "25";
		CUSTOM_CLAWS = true;
		FIRE_WAVE_MP = 20;
		MELEE_DMG = 200;
		DEMON_STRIKE_RATIO = 6.0f;
		MODEL_VIEW_IDX = 2;
		MODEL_HANDS = "weapons/p_weapons3.mdl";
		MODEL_WORLD = "weapons/p_weapons3.mdl";
		MODEL_BODY_OFS = "69";
		ANIM_PREFIX = "standard";
	}

	// game_dodamage
	string BluntGauntletsIc_OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		bool exitSub = false;
		string result = "";
		if (RandomInt(1, 3) != 1)
			return result;

		if (!hit)
			return result;
		if (IsPlayer(target) && GAME_PVP == 0)
			exitSub = true;
		if (exitSub)
			return result;

		float dotBurn = SkillOf(ENT_OWNER, "spellcasting.fire") * 0.5f;
		ApplyEffect(target, "effects/dot_fire", 5.0f, @EntityOf(ENT_OWNER), dotBurn, "martialarts");
		return result;
	}

	// game_deploy
	void OnGameDeploy()
	{
		BaseItemExtras_OnGameDeploy(); // items/base_item_extras
		BaseItemExtras_OnGameDeploy_2(); // items/base_item_extras
		BaseItemExtras_OnGameDeploy_3(); // items/base_item_extras
		BaseItem_OnGameDeploy(); // items/base_item
		BaseWeapon_OnGameDeploy(); // items/base_weapon
		BaseWeapon_OnGameDeploy_2(); // items/base_weapon
		BaseMelee_OnGameDeploy(); // items/base_melee
		GAME_PVP = (IsPvp() ? 1 : 0);
	}

	// weapon_spawn
	void OnWeaponSpawn()
	{
		BaseMelee_OnWeaponSpawn(); // items/base_melee
		BluntGauntletsDemon_OnWeaponSpawn(); // items/blunt_gauntlets_demon

		SetName("Infernal Claws");
		SetDescription("Demonic claws imbued with flame");
		SetWeight(3);
		SetValue(6000);
		SetHand("both");
		SetHudSprite("hand", "143");
		SetHudSprite("trade", "143");

		OnRegisterDemonToggle();
		DEMON_MODE = false;
	}

	// game_dodamage
	string OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";
		result = AppendResult(result, BaseKick_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BluntGauntletsIc_OnGameDodamage(hit, target, start, end, damageType, damageText));
		return result;
	}

	// demon_strike
	void OnDemonStrike(string hitType = "", Vector3 endPos = Vector3(), CBaseEntity@ hitEntity = null, bool hit = false)
	{
		BluntGauntletsDemon_OnDemonStrike(hitType, endPos, hitEntity, hit); // items/blunt_gauntlets_demon
		bool exitSub = false;

		if (hitType != "world")
			return;

		if (SkillOf(ENT_OWNER, "spellcasting.fire") < 25.0f)
		{
			PlayerMessageDark(ENT_OWNER, "Infernal Claws: Insufficient skill for Fire Wave.");
			exitSub = true;
		}
		if (exitSub)
			return;

		if (ManaOf(ENT_OWNER) < FIRE_WAVE_MP)
		{
			PlayerMessageDark(ENT_OWNER, "Infernal Claws: Insufficient mana for Fire Wave.");
			exitSub = true;
		}
		if (exitSub)
			return;

		GiveMana(ENT_OWNER, -FIRE_WAVE_MP);

		// vectorset ATTACK_END_POS z $get_ground_height(ATTACK_END_POS)
		OnDoFireWave(endPos);
	}

	// do_fire_wave
	void OnDoFireWave(Vector3 startPosition = Vector3())
	{
		PlaySound(0, 7, "magic/flame_loop_start.wav");

		FIRE_WAVE_START_POS = startPosition;
		FIRE_WAVE_YAW = AnglesOf(ENT_OWNER).y;
		ClientEvent("new", "all", "effects/sfx_fire_wave", FIRE_WAVE_START_POS, FIRE_WAVE_YAW);

		OWNER_ORG = Text(FIRE_WAVE_START_POS);
		OWNER_ANG = Vector3(0, FIRE_WAVE_YAW, 0);

		FIRE_WAVE_SCAN_POS = FIRE_WAVE_START_POS;
		FIRE_WAVE_SCAN_POS += RelativePosition(Vector3(0, FIRE_WAVE_YAW, 0), Vector3(0, 128, 32));

		CallEventDelayed(1.25f, "fire_wave2"); // simulates time flames remain better

		CallExternal(ENT_OWNER, "ext_sphere_token", "enemy", 768, FIRE_WAVE_SCAN_POS);
		FIRE_WAVE_TARGS = ScriptVarOf(ENT_OWNER, "PLR_SCAN_TOKEN");

		if (FIRE_WAVE_TARGS == "none")
			return;
		int count = GetTokenCount(FIRE_WAVE_TARGS);
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnFireWaveAffectTargs();
		}
	}

	// fire_wave2
	void OnFireWave2()
	{
		CallExternal(ENT_OWNER, "ext_sphere_token", "enemy", 1024, FIRE_WAVE_SCAN_POS);
		FIRE_WAVE_TARGS = ScriptVarOf(ENT_OWNER, "PLR_SCAN_TOKEN");

		if (FIRE_WAVE_TARGS == "none")
			return;
		int count = GetTokenCount(FIRE_WAVE_TARGS);
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnFireWaveAffectTargs();
		}
	}

	// fire_wave_affect_targs
	void OnFireWaveAffectTargs()
	{
		bool exitSub = false;
		Vector3 targOrg = Vec("TARG_ORG");

		string curTarg = GetToken(FIRE_WAVE_TARGS, loopIteration);

		if (IsPlayer(curTarg) && GAME_PVP == 0)
			exitSub = true;
		if (exitSub)
			return;

		DebugPrint("fire_wave_affect_targs " + Text(WithinCone2D(targOrg, Vec(OWNER_ORG), OWNER_ANG, 120)) + " " + NameOf(curTarg));

		targOrg = OriginOf(curTarg);

		if (!WithinCone2D(targOrg, Vec(OWNER_ORG), OWNER_ANG, 120))
			return;

		Vector3 traceStart = FIRE_WAVE_START_POS;
		string traceEnd = Text(targOrg);
		string traceLine = LegacyFunction("get_traceline", traceStart, traceEnd, "worldonly");
		if (traceLine != traceEnd)
			return;

		float dotBurn = SkillOf(ENT_OWNER, "spellcasting.fire");
		ApplyEffect(curTarg, "effects/dot_fire", 5.0f, @EntityOf(ENT_OWNER), dotBurn, "martialarts");
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("weapons/p_weapons3.mdl");
		Precache("viewmodels/v_martialarts_claws.mdl");
		Precache("weapons/martialarts/foot.mdl");
		CallEventDelayed(1.0f, "punch1_done");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "demon_strike") { OnDemonStrike(Param(params, 0), Vec(Param(params, 1)), EntityParam(params, 2), Truthy(Param(params, 3))); return true; }
		if (name == "do_fire_wave") { OnDoFireWave(Vec(Param(params, 0))); return true; }
		if (name == "fire_wave2") { OnFireWave2(); return true; }
		if (name == "fire_wave_affect_targs") { OnFireWaveAffectTargs(); return true; }
		if (name == "game_deploy") { OnGameDeploy(); return true; }
		if (name == "game_dodamage") { Return(OnGameDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5))); return true; }
		if (name == "weapon_spawn") { OnWeaponSpawn(); return true; }
		return BluntGauntletsDemonScript::DispatchEvent(name, params);
	}
}
