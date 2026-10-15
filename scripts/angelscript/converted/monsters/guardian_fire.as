#pragma context server

// Converted from monsters/guardian_fire.script by msc_transpiler.
// https://www.youtube.com/watch?v=4mJuOTTyobM

#include "runtime/ScriptEntity.as"
#include "converted/monsters/guardian_iron.as"

[script "monsters/guardian_fire"]
class GuardianFire : GuardianIronScript
{
	// Variables declared by included files, with the value they start with in this script
	GuardianFire()
	{
		GUARDIAN_TYPE = 2;
		GUARDIAN_BEAM_SWORD = false;
		DMG_ELEF_TYPE = "fire_effect";
		SOUND_SWORD_IDLE = "none";
		SOUND_SWORD_DRAW = "magic/dragon_fire.wav";
		SOUND_SWORD_OFF = "weapons/swords/sworddraw.wav";
		PITCH_SWORD_OFF = 50;
		SOUND_RECHARGE_START = "magic/sff_explsonic.wav";
		SOUND_REACH = "magic/dragon_fire.wav";
		SOUND_SWING = "magic/fireball_large.wav";
		GUARDIAN_CL_SCRIPT = "monsters/guardian_fire_cl";
		DOT_DMG = 100.0f;
	}

	// game_precache
	void GuardianFire_OnGamePrecache()
	{
	}

	// game_damaged_other
	// PARAM1=target_hit PARAM2=dmg PARAM3=dmg_type
	string GuardianFire_OnGameDamagedOther(CBaseEntity@ target = null, float damage = 0.0f, string damageType = "", string damageEvent = "")
	{
		string result = "";
		if (!MELEEING)
			return result;
		ApplyEffect(target, "effects/dot_fire", 5.0f, self, DOT_DMG);
		return result;
	}

	// game_precache
	void OnGamePrecache()
	{
		GuardianFire_OnGamePrecache();
		GuardianIron_OnGamePrecache(); // monsters/guardian_iron
	}

	// game_damaged_other
	string OnGameDamagedOther(CBaseEntity@ target = null, float damage = 0.0f, string damageType = "", string damageEvent = "")
	{
		string result = "";
		result = AppendResult(result, MonstersExternals_OnGameDamagedOther(target, damage, damageType, damageEvent));
		result = AppendResult(result, BaseAntiStuck_OnGameDamagedOther(target, damage, damageType, damageEvent));
		result = AppendResult(result, BaseMonsterShared_OnGameDamagedOther(target, damage, damageType, damageEvent));
		result = AppendResult(result, GuardianFire_OnGameDamagedOther(target, damage, damageType, damageEvent));
		return result;
	}

	// npcatk_hunt
	void OnNpcatkHunt()
	{
		BaseNpcAttackNew_OnNpcatkHunt(); // monsters/base_npc_attack_new
		BaseAntiStuck_OnNpcatkHunt(); // monsters/base_anti_stuck
		GuardianIron_OnNpcatkHunt(); // monsters/guardian_iron
		if (!(GameTime() > NEXT_SWBEAMS_REFRESH))
			return;
		if (!SWORD_STATE)
			return;
		NEXT_SWBEAMS_REFRESH = GameTime() + 10.2f;
		Effect("beam", "follow", "lgtning.spr", ENT_ME, 2, 30, 10.0f, 200, Vector3(255, 0, 0));
		Effect("beam", "follow", "lgtning.spr", ENT_ME, 2, 10, 10.0f, 200, Vector3(255, 128, 0));
	}

	// guardian_spawn
	void OnGuardianSpawn()
	{
		GuardianIron_OnGuardianSpawn(); // monsters/guardian_iron
		SetName("Molten Guardian");
		SetHealth(10000);
		SetModel("monsters/guardian_fire.mdl");
		SetWidth(75);
		SetHeight(200);

		SetBoundingBox("npcsize");

		SetDamageTaken("all", 0.5f);
		SetDamageTaken("poison", 0);
		SetDamageTaken("holy", 1.25f);
		SetDamageTaken("fire", 0);
		SetDamageTaken("cold", 1.25f);
		SetDamageTaken("stun", 0);
		IMMUNE_VAMPIRE = true;
		IS_BLOODLESS = true;
		SetModelBody(0, 0);
		SetRace("demon");

		SetBlood("none");

		SetHearingSensitivity(1);

		SetMoveAnim(ANIM_WALK);
		SetIdleAnim(ANIM_IDLE);
		SetRoam(true);

		if (GetVar("G_GUARDIAN_CHARGER") != "G_GUARDIAN_CHARGER")
		{
			CHARGER_ORG = GetVar("G_GUARDIAN_CHARGER");
			NEEDS_CHARGER = true;
		}

		CHARGE_LEVEL = MAX_CHARGE_LEVEL;
		ANIM_RATE = 1.0f;

		ClientEvent("new", "all", GUARDIAN_CL_SCRIPT, IndexOf(ENT_ME));
		CL_SCRIPT_IDX = LastClientScriptId();
	}

	// frame_attack1_start
	void OnFrameAttack1Start()
	{
		GuardianIron_OnFrameAttack1Start(); // monsters/guardian_iron
		DebugPrint("frame_attack2_start");
	}

	// frame_attack2_start
	void OnFrameAttack2Start()
	{
		GuardianIron_OnFrameAttack2Start(); // monsters/guardian_iron
		DebugPrint("frame_attack2_start");
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("fire1_fixed.spr");
		Precache("c-tele1.spr");
		Precache("flare1.spr");
		Precache("monsters/guardian.mdl");
		Precache("monsters/guardian_fire.mdl");
		CallEventDelayed(CHARGE_DROP_RATE, "GuardianIron_Timer");
		CallEventDelayed(5.0f, "GuardianIron_Timer2");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "frame_attack1_start") { OnFrameAttack1Start(); return true; }
		if (name == "frame_attack2_start") { OnFrameAttack2Start(); return true; }
		if (name == "game_damaged_other") { Return(OnGameDamagedOther(EntityParam(params, 0), Float(Param(params, 1)), Param(params, 2), Param(params, 3))); return true; }
		if (name == "game_precache") { OnGamePrecache(); return true; }
		if (name == "guardian_spawn") { OnGuardianSpawn(); return true; }
		if (name == "npcatk_hunt") { OnNpcatkHunt(); return true; }
		return GuardianIronScript::DispatchEvent(name, params);
	}
}
