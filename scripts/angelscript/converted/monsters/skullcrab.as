#pragma context server

// Converted from monsters/skullcrab.script by msc_transpiler.
// Another test script from Dridje
// This is a SKULLCRAB

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_monster_new.as"

[script "monsters/skullcrab"]
class Skullcrab : BaseMonsterNewScript
{
	// Constants
	string ANIM_ATT1 = "jump";
	string ANIM_ATT2 = "jump_variation1";
	int DMG_ATT1 = 0;
	int DMG_CHEW = 0;
	string ATTACK_HITCHANCE = "75";
	string SOUND_ALERT1 = "headcrab/hc_alert1.wav";
	string SOUND_ALERT2 = "headcrab/hc_alert2.wav";
	string SOUND_ATTACK1 = "headcrab/hc_attack2.wav";
	string SOUND_ATTACK2 = "headcrab/hc_attack3.wav";
	string SOUND_DEATH1 = "headcrab/hc_die1.wav";
	string SOUND_DEATH2 = "headcrab/hc_die2.wav";
	string SOUND_PAIN1 = "headcrab/hc_pain1.wav";
	string SOUND_PAIN2 = "headcrab/hc_pain2.wav";
	string SOUND_PAIN3 = "headcrab/hc_pain3.wav";
	string SOUND_IDLE1 = "headcrab/hc_idle1.wav";
	string SOUND_IDLE2 = "headcrab/hc_idle2.wav";
	string SOUND_IDLE3 = "headcrab/hc_idle3.wav";
	string SOUND_IDLE4 = "headcrab/hc_idle4.wav";
	string SOUND_IDLE5 = "headcrab/hc_idle5.wav";
	string SOUND_CHEW = "headcrab/hc_attack1.wav";
	float FREQ_JUMP = 0.0f;

	// Variables (an unset .script variable reads as its own name)
	string ANIM_ATTACK = "ANIM_ATTACK";
	string ANIM_FLINCH = "ANIM_FLINCH";
	string FLINCH_CHANCE = "FLINCH_CHANCE";
	float NEXT_JUMP = 0.0f;
	float NEXT_IDLE = 0.0f;
	bool TOSS_JUMP = false;
	bool JUMP_SCAN_ACTIVE = false;
	string CHEW_TARGET = "CHEW_TARGET";
	bool STUCK_ON_FACE = false;
	float NEXT_CHEW_DMG = 0.0f;
	float UNSUMMON_TIME = 0.0f;
	string MY_OWNER = "MY_OWNER";
	bool AM_SUMMONED = false;

	// Variables declared by included files, with the value they start with in this script
	Skullcrab()
	{
		NPC_GIVE_EXP = 300.0f;
		ANIM_WALK = "walk";
		ANIM_RUN = "run";
		ANIM_IDLE = "idle1";
		SOUND_DEATH = "monsters/skeleton/skeldie.wav";
	}

	// unnamed block (first think)
	void Skullcrab_FirstThink()
	{
		NPC_GIVE_EXP = 300.0f;
		ANIM_ATTACK = "jump";

		ANIM_WALK = "walk";
		ANIM_RUN = "run";
		ANIM_IDLE = "idle1";

		MOVE_RANGE = "48";
		ATTACK_RANGE = 70.0f;

		ATTACK_HITRANGE = 90.0f;

		ANIM_FLINCH = "flinch";
		FLINCH_DAMAGE_THRESHOLD = 25.0f;
		FLINCH_CHANCE = "5";
		FLINCH_DELAY = "10.0";
	}

	// game_damaged
	string Skullcrab_OnGameDamaged(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float accuracyRoll = 0.0f, CBaseEntity@ inflictor = null, string skill = "")
	{
		string result = "";
		if (AM_SUMMONED)
			UNSUMMON_TIME = GameTime() + 20.0f;
		PlayRandomSound(0, 10, SOUND_PAIN1, SOUND_PAIN2, SOUND_PAIN3);
		return result;
	}

	// game_dodamage
	string Skullcrab_OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";
		if (AM_SUMMONED)
			UNSUMMON_TIME = GameTime() + 20.0f;
		return result;
	}

	// game_death
	void OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		DqMonsterExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // dq/externals/dq_monster_externals
		MonstersExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/externals
		BaseSelfAdjust_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_self_adjust
		BaseNpc_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseMonsterShared_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared
		if (!AM_SUMMONED)
			return;
		if (!IsAlive(MY_OWNER))
			return;
		CallExternal(MY_OWNER, "crab_died");
	}

	// npc_post_spawn
	void OnNpcPostSpawn()
	{
		MonstersExternals_OnNpcPostSpawn(); // monsters/externals
		MonstersExternals_OnNpcPostSpawn_2(); // monsters/externals
		MonstersExternals_OnNpcPostSpawn_3(); // monsters/externals
		BaseSelfAdjust_OnNpcPostSpawn(); // monsters/base_self_adjust
		BaseNpc_OnNpcPostSpawn(); // monsters/base_npc
		BaseMonsterShared_OnNpcPostSpawn(); // monsters/base_monster_shared

		SetMoveAnim(ANIM_WALK);
		SetIdleAnim(ANIM_IDLE);
	}

	// game_dynamically_created
	// <master> <target>
	void OnGameDynamicallyCreated(string creatorValue1 = "", string creatorValue2 = "", string damage = "", string skill = "", string extraValue5 = "", string extraValue6 = "", float alwaysPush = 0.0f, string duration = "", string extraValue9 = "")
	{
		BaseSelfAdjust_OnGameDynamicallyCreated(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/base_self_adjust
		BaseSelfAdjust_OnGameDynamicallyCreated_2(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/base_self_adjust
		BaseAntiStuck_OnGameDynamicallyCreated(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/base_anti_stuck
		BaseAntiStuck_OnGameDynamicallyCreated_2(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/base_anti_stuck
		MY_OWNER = creatorValue1;
		NPCATK_TARGET = creatorValue2;
		AM_SUMMONED = true;
		UNSUMMON_TIME = GameTime() + 20.0f;
		SetMoveDest(NPCATK_TARGET, 9999);
		TOSS_JUMP = true;
		CallEventDelayed(0.1f, "do_jump");
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseNpcAttackNew_OnNpcSpawn(npc); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck

		SetName("Skrab");

		SetRace("undead");

		SetHealth(500);

		SetRoam(true);

		SetModel("monsters/skullcrab.mdl");
		SetWidth(20);
		SetHeight(50);

		IMMUNE_VAMPIRE = true;
		SetBlood("none");
		SetDamageTaken("poison", 0);
		SetDamageTaken("holy", 2);

		SetHearingSensitivity(4);

		NEXT_JUMP = GameTime() + Random(1, 3);
	}

	// npcatk_hunt
	void OnNpcatkHunt()
	{
		BaseNpcAttackNew_OnNpcatkHunt(); // monsters/base_npc_attack_new
		BaseAntiStuck_OnNpcatkHunt(); // monsters/base_anti_stuck
		if (NPCATK_TARGET == "unset" && GameTime() > NEXT_IDLE)
		{
			NEXT_IDLE = GameTime() + Random(10, 20);
			PlayAnim("once", ANIM_ATTACK);
			PlayRandomSound(0, 10, SOUND_IDLE1, SOUND_IDLE2, SOUND_IDLE3, SOUND_IDLE4, SOUND_IDLE5);
		}

		if (!AM_SUMMONED)
			return;
		if (GameTime() > UNSUMMON_TIME)
			OnNpcSuicide("fade");
		if (!IsAlive(MY_OWNER))
			OnNpcSuicide("fade");
	}

	// game_dodamage
	string OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";
		result = AppendResult(result, BaseNpcAttackNew_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BaseAntiStuck_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BaseMonsterShared_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, Skullcrab_OnGameDodamage(hit, target, start, end, damageType, damageText));
		return result;
	}

	// npc_selectattack
	void OnNpcSelectattack()
	{
		BaseAntiStuck_OnNpcSelectattack(); // monsters/base_anti_stuck
		BaseMonsterShared_OnNpcSelectattack(); // monsters/base_monster_shared

		int rndAttack = RandomInt(1, 2);
		if (rndAttack == 1)
			ANIM_ATTACK = ANIM_ATT1;
		if (rndAttack == 2)
			ANIM_ATTACK = ANIM_ATT2;
	}

	// game_damaged - Return a damage multiplier to scale the damage
	string OnGameDamaged(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float accuracyRoll = 0.0f, CBaseEntity@ inflictor = null, string skill = "")
	{
		string result = "";
		result = AppendResult(result, BaseAntiStuck_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, BaseMonsterShared_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, BaseMonsterShared_OnGameDamaged_2(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, Skullcrab_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		return result;
	}

	// npc_targetsighted
	void OnNpcTargetsighted(string target = "")
	{
		BaseMonsterShared_OnNpcTargetsighted(target); // monsters/base_monster_shared
		if (JUMP_SCAN_ACTIVE)
			return;
		if (!(RangeTo(NPCATK_TARGET) < 512.0f))
			return;
		if (!(GameTime() > NEXT_JUMP))
			return;
		NEXT_JUMP = GameTime() + 20.0f;
		SetMoveDest(NPCATK_TARGET, 9999);
		PlayAnim("critical", ANIM_ATTACK);
		CallEventDelayed(0.01f, "do_jump");
	}

	// do_jump
	void OnDoJump()
	{
		bool vAdj = false;

		float targZ = OriginOf(NPCATK_TARGET).z;
		float myZ = MyOrigin().z;
		float zDiff = (targZ - myZ) * 4.0f;
		string zDiffText = Text(zDiff);

		if (zDiff < 200.0f)
		{
			zDiff = 200.0f;
			zDiffText = Text(zDiff);
			if (TOSS_JUMP)
			{
				TOSS_JUMP = false;
				zDiff = 0.0f;
				zDiffText = Text(zDiff);
			}
		}

		DebugPrint("do_jump " + zDiffText + " - " + Text(myZ) + " vs " + Text(targZ));

		PlayRandomSound(1, 10, SOUND_ATTACK1, SOUND_ATTACK2);
		SetRoam(false);
		AddVelocity(ENT_ME, RelativeVelocity(Vector3(0, 1000, zDiff)));
		JUMP_SCAN_ACTIVE = true;
		NPC_NO_ATTACK = true;
		NO_STUCK_CHECKS = "1";
		CHEW_TARGET = NPCATK_TARGET;
		CallEventDelayed(0.01f, "jump_scan");
		CallEventDelayed(1.5f, "end_jump_scan");
		CallEventDelayed(4.0f, "abort_chew");
	}

	// jump_scan
	void OnJumpScan()
	{
		if (!JUMP_SCAN_ACTIVE)
			return;
		if (!IsAlive(CHEW_TARGET))
			return;
		CallEventDelayed(0.1f, "jump_scan");
		float targRange = RangeTo(CHEW_TARGET);
		if (targRange > 96.0f)
			STUCK_ON_FACE = false;

		if (!(targRange < 96.0f))
			return;
		SetMoveDest(CHEW_TARGET, 9999);
		SetVelocity(ENT_ME, RelativeVelocity(Vector3(0, 1000, 10)));
		PlayAnim("once", "yaw_adjustment");
		if (targRange < 64.0f)
		{
			STUCK_ON_FACE = true;
			if (GameTime() > NEXT_CHEW_DMG)
			{
				NEXT_CHEW_DMG = GameTime() + 0.5f;
				DoDamage(CHEW_TARGET, ATTACK_HITRANGE, DMG_CHEW, "100%", "slash");
				PlaySound(2, 10, SOUND_CHEW);
			}
		}
		else
		{
			STUCK_ON_FACE = false;
		}
	}

	// end_jump_scan
	void OnEndJumpScan()
	{
		if (!STUCK_ON_FACE)
		{
			if (JUMP_SCAN_ACTIVE)
				OnDoDetatch();
		}
		else
		{
			CallEventDelayed(0.5f, "end_jump_scan");
		}
	}

	// do_detatch
	void OnDoDetatch()
	{
		JUMP_SCAN_ACTIVE = false;
		NPC_NO_ATTACK = false;
		NO_STUCK_CHECKS = "0";
		NEXT_JUMP = GameTime() + FREQ_JUMP;
		AddVelocity(ENT_ME, RelativeVelocity(Vector3(0, -2000, 110)));
		SetRoam(true);
	}

	// abort_chew
	void OnAbortChew()
	{
		// dbg abort_chew
		if (!JUMP_SCAN_ACTIVE)
			return;
		OnDoDetatch();
	}

	// npc_flinch
	void OnNpcFlinch(float damage = 0.0f)
	{
		PlaySound(0, 10, SOUND_PAIN1);
	}

	// frame_jump
	void OnFrameJump()
	{
		OnNpcatkDodamage(NPCATK_TARGET, Text(ATTACK_HITRANGE), Text(DMG_ATT1), ATTACK_HITCHANCE, "slash");
	}

	// frame_falloffend
	void OnFrameFalloffend()
	{
		OnNpcatkDodamage(NPCATK_TARGET, Text(ATTACK_HITRANGE), Text(DMG_ATT1), ATTACK_HITCHANCE, "slash");
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/skullcrab.mdl");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		Skullcrab_FirstThink();
		BaseNpc_FirstThink();
		MonstersExternals_FirstThink();
		BaseNpcAttackNew_FirstThink();
		BaseMonsterShared_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "abort_chew") { OnAbortChew(); return true; }
		if (name == "do_detatch") { OnDoDetatch(); return true; }
		if (name == "do_jump") { OnDoJump(); return true; }
		if (name == "end_jump_scan") { OnEndJumpScan(); return true; }
		if (name == "frame_falloffend") { OnFrameFalloffend(); return true; }
		if (name == "frame_jump") { OnFrameJump(); return true; }
		if (name == "game_damaged") { Return(OnGameDamaged(EntityParam(params, 0), Float(Param(params, 1)), Param(params, 2), Float(Param(params, 3)), EntityParam(params, 4), Param(params, 5))); return true; }
		if (name == "game_death") { OnGameDeath(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_dodamage") { Return(OnGameDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5))); return true; }
		if (name == "game_dynamically_created") { OnGameDynamicallyCreated(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Float(Param(params, 6)), Param(params, 7), Param(params, 8)); return true; }
		if (name == "jump_scan") { OnJumpScan(); return true; }
		if (name == "npc_flinch") { OnNpcFlinch(Float(Param(params, 0))); return true; }
		if (name == "npc_post_spawn") { OnNpcPostSpawn(); return true; }
		if (name == "npc_selectattack") { OnNpcSelectattack(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "npc_targetsighted") { OnNpcTargetsighted(Param(params, 0)); return true; }
		if (name == "npcatk_hunt") { OnNpcatkHunt(); return true; }
		return BaseMonsterNewScript::DispatchEvent(name, params);
	}
}
