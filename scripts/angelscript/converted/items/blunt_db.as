#pragma context server

// Converted from items/blunt_db.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/items/blunt_mithral.as"

[script "items/blunt_db"]
class BluntDb : BluntMithralScript
{
	// Variables declared by included files, with the value they start with in this script
	BluntDb()
	{
		BASE_LEVEL_REQ = "30";
		FIRE_WAVE_MP = 40;
		DEMON_CHARGES = 6;
		DEMON_DURATION = 40.0f;
		MELEE_RANGE = "90";
		MELEE_DMG = 450;
		DEMON_DMG = 800;
		MELEE_ACCURACY = "80%";
		MELEE_DMG_TYPE = "dark";
		MODEL_VIEW_IDX = 7;
		MODEL_BODY_OFS = "71";
	}

	// game_dodamage
	// PARAM1=hit:0|1 PARAM2=ent_hit PARAM3=(start) PARAM4=(end) PARAM5=DmgType PARAM6=DmgAmt
	string BluntDb_OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		bool exitSub = false;
		string result = "";
		if (!hit)
			return result;
		if (IsPlayer(target) && GAME_PVP == 0)
			exitSub = true;
		if (exitSub)
			return result;

		float dotBurn = SkillOf(ENT_OWNER, "spellcasting.fire") * 0.5f;
		ApplyEffect(target, "effects/dot_fire", 5.0f, @EntityOf(ENT_OWNER), dotBurn, "bluntarms");
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
		BluntBaseOnehanded_OnWeaponSpawn(); // items/blunt_base_onehanded
		BluntBaseTwohanded_OnWeaponSpawn(); // items/blunt_base_twohanded
		BluntMithral_OnWeaponSpawn(); // items/blunt_mithral

		SetName("Demon Bludgeon Hammer");
		SetDescription("A massive Bludgeon Demon hammer powered by an infernal soul");
		SetWeight(80);
		SetValue(6000);
		SetHudSprite("hand", "hammer");
		SetHudSprite("trade", "144");

		M_ATTACK = 1.0f;
	}

	// game_dodamage
	string OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";
		result = AppendResult(result, BluntMithral_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BluntDb_OnGameDodamage(hit, target, start, end, damageType, damageText));
		return result;
	}

	// special_02_strike
	void OnSpecial02Strike(string hitType = "", Vector3 endPos = Vector3(), CBaseEntity@ hitEntity = null, bool hit = false)
	{
		if (hitType != "world")
			return;

		if (endPos.z != GroundHeight(endPos))
			return;

		if (!(SkillOf(ENT_OWNER, "spellcasting.fire") >= 25.0f))
			return;

		if (ManaOf(ENT_OWNER) < FIRE_WAVE_MP)
			PlayerMessageDark(ENT_OWNER, "Demon Bludgeon Hammer: Insufficient MP for Fire Wave");

		if (!(ManaOf(ENT_OWNER) >= FIRE_WAVE_MP))
			return;

		GiveMana(ENT_OWNER, -FIRE_WAVE_MP);

		OnDoFireWave(OriginOf(ENT_OWNER));
	}

	// do_fire_wave
	void OnDoFireWave(Vector3 startPosition = Vector3())
	{
		PlaySound(0, 7, "magic/flame_loop_start.wav");

		FIRE_WAVE_START_POS = startPosition;
		FIRE_WAVE_YAW = AnglesOf(ENT_OWNER).y;
		ClientEvent("new", "all", "effects/sfx_fire_wave", FIRE_WAVE_START_POS, FIRE_WAVE_YAW);

		Vector3 fireWaveScanPos = FIRE_WAVE_START_POS;
		fireWaveScanPos += RelativePosition(Vector3(0, FIRE_WAVE_YAW, 0), Vector3(0, 128, 32));

		CallExternal(ENT_OWNER, "ext_sphere_token", "enemy", 1024, fireWaveScanPos);
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

		string curTarg = GetToken(FIRE_WAVE_TARGS, loopIteration);

		if (IsPlayer(curTarg) && GAME_PVP == 0)
			exitSub = true;
		if (exitSub)
			return;

		Vector3 ownerOrg = FIRE_WAVE_START_POS;
		Vector3 ownerAng = Vector3(0, FIRE_WAVE_YAW, 0);
		Vector3 targOrg = OriginOf(curTarg);

		DebugPrint("fire_wave_affect_targs " + Text(WithinCone2D(targOrg, ownerOrg, ownerAng, 100)) + " " + NameOf(curTarg));

		if (!WithinCone2D(targOrg, ownerOrg, ownerAng, 100))
			return;

		Vector3 traceStart = FIRE_WAVE_START_POS;
		string traceEnd = Text(targOrg);
		string traceLine = LegacyFunction("get_traceline", traceStart, traceEnd, "worldonly");
		if (traceLine != traceEnd)
			return;

		float dotBurn = SkillOf(ENT_OWNER, "spellcasting.fire");
		ApplyEffect(curTarg, "effects/dot_fire", 5.0f, @EntityOf(ENT_OWNER), dotBurn, "bluntarms");
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "do_fire_wave") { OnDoFireWave(Vec(Param(params, 0))); return true; }
		if (name == "fire_wave_affect_targs") { OnFireWaveAffectTargs(); return true; }
		if (name == "game_deploy") { OnGameDeploy(); return true; }
		if (name == "game_dodamage") { Return(OnGameDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5))); return true; }
		if (name == "special_02_strike") { OnSpecial02Strike(Param(params, 0), Vec(Param(params, 1)), EntityParam(params, 2), Truthy(Param(params, 3))); return true; }
		if (name == "weapon_spawn") { OnWeaponSpawn(); return true; }
		return BluntMithralScript::DispatchEvent(name, params);
	}
}
