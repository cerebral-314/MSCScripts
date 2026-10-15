#pragma context server

// Converted from monsters/dragonfly_queen.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_monster.as"
#include "converted/monsters/attack_hack.as"
#include "converted/monsters/base_flyer.as"

[script "monsters/dragonfly_queen"]
class DragonflyQueen : BaseMonsterScript, AttackHack, BaseFlyer
{
	// Constants
	string ATTACK_HITCHANCE = "80%";
	float DMG_BITE = 0.0f;
	string ANIM_IDLE_HANG = "flapping";
	string ANIM_IDLE_FLY = "fly";
	float FREQ_RETURN = 0.0f;
	float FREQ_SUMMON = 0.0f;
	int ROAM_RADIUS = 1024;
	int SUMMON_HEALTH = 30;
	string SUMMON_SCRIPT = "monsters/summon/dragonfly";
	float DMG_SUMMON = 0.0f;
	float SUMMON_LIFETIME = 15.0f;
	int BAT_SUMMON_HEIGHT = 300;
	int BAT_SUMMON_AMT = 8;
	string SOUND_STRUCK1 = "weapons/cbar_hitbod1.wav";
	string SOUND_STRUCK2 = "weapons/cbar_hitbod2.wav";
	string SOUND_STRUCK3 = "weapons/cbar_hitbod3.wav";
	string SOUND_HOVER = "monsters/dragonfly_queen.wav";
	float FREQ_SOUND_HOVER = 9.5f;

	// Variables (an unset .script variable reads as its own name)
	string ANIM_ATTACK = "ANIM_ATTACK";
	int MOVE_RAGE = 0;
	bool STARTED_CYCLES = false;
	bool RETURNING_HOME = false;
	float FLIGHT_STUCK = 0.0f;
	float LAST_PROG = 0.0f;
	Vector3 LAST_POS = Vector3();
	string OLD_TARG = "OLD_TARG";
	float BAT_SUMMON_NUM = 0.0f;

	// Variables declared by included files, with the value they start with in this script
	DragonflyQueen()
	{
		ANIM_RUN = "fly";
		ANIM_WALK = "fly";
		ANIM_IDLE = "flapping";
	}

	// unnamed block (first think)
	void DragonflyQueen_FirstThink()
	{
		// base anims
		ANIM_RUN = "fly";
		ANIM_WALK = "fly";
		ANIM_ATTACK = "attack";
		ANIM_IDLE = "flapping";

		// standard stats
		NPC_GIVE_EXP = 150.0f;
		ATTACK_RANGE = 100.0f;
		ATTACK_HITRANGE = 125.0f;
		MOVE_RAGE = 40;
	}

	// unnamed block (timer)
	void DragonflyQueen_Timer()
	{
		CallEventDelayed(FREQ_RETURN, "DragonflyQueen_Timer");
		if (Distance(MyOrigin(), Vec(NPC_HOME_LOC)) > ROAM_RADIUS)
			OnReturnHome();
	}

	// unnamed block (timer)
	// =========================== custom flyer mods - BEGIN
	void DragonflyQueen_Timer2()
	{
		CallEventDelayed(0.5f, "DragonflyQueen_Timer2");
		if (RETURNING_HOME)
		{
			SetMoveDest(NPC_HOME_LOC, MOVE_RANGE);
			if (Distance(MyOrigin(), Vec(NPC_HOME_LOC)) < 0.0f)
			{
				RETURNING_HOME = false;
				OnNpcatkResumeAi();
			}
		}

		if (!IS_HUNTING)
			return;
		OnNpcatkFaceattacker();
		if (RangeTo(NPCATK_TARGET) > Float(MOVE_RANGE))
			SetVelocity(ENT_ME, RelativeVelocity(Vector3(0, 200, 0)));
		if (RangeTo(NPCATK_TARGET) < Float(MOVE_RANGE))
			SetVelocity(ENT_ME, Vector3(0, 0, 0));

		if (FLIGHT_STUCK > 4.0f)
		{
			// callevent chicken_run 1.0
			OnDoRandTweedee(); // do_rand_tweedee
			OnNpcatkSuspendAi(Text(Random(0.3f, 0.9f)));
			SetMoveDest(NEW_DEST, Eval("game.monster.moveprox"));
			CallEventDelayed(0.1f, "horror_boost");
			FLIGHT_STUCK = 0.0f;
		}

		AS_ATTACKING -= 2.0f;

		Vector3 targPos = OriginOf(NPCATK_TARGET);
		if (!SUSPEND_AI)
			SetAngle("face_origin", targPos);

		if (!(AS_ATTACKING <= 0.0f))
			return;
		AS_ATTACKING = 0.0f;
		if (IS_FLEEING)
			return;
		if (!(RangeTo(NPCATK_TARGET) > ATTACK_RANGE))
			return;
		float curProg = Distance(MyOrigin(), targPos);
		if (LAST_PROG >= curProg)
			FLIGHT_STUCK += 1.0f;
		LAST_PROG = Distance(MyOrigin(), targPos);
		LAST_POS = MyOrigin();
	}

	// unnamed block (timer)
	// sound loop
	void DragonflyQueen_Timer3()
	{
		CallEventDelayed(FREQ_SOUND_HOVER, "DragonflyQueen_Timer3");

		ServerPlaySound(2, 10, SOUND_HOVER);
	}

	// game_death
	void OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		DqMonsterExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // dq/externals/dq_monster_externals
		MonstersExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/externals
		BaseSelfAdjust_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_self_adjust
		BaseNpc_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseMonsterShared_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared
		ServerPlaySound(2, 0, SOUND_HOVER);
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

		SetIdleAnim(ANIM_IDLE);
		SetMoveAnim(ANIM_WALK);
	}

	// chicken_run
	void OnChickenRun(float duration = 0.0f)
	{
		BaseNpcAttack_OnChickenRun(duration); // monsters/base_npc_attack
		CallEventDelayed(0.1f, "horror_boost");
	}

	// cycle_up
	void OnCycleUp(string reason = "")
	{
		BaseNpcAttack_OnCycleUp(reason); // monsters/base_npc_attack

		if (STARTED_CYCLES)
			return;
		STARTED_CYCLES = true;
		CallEventDelayed(FREQ_SUMMON, "make_babies");
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck

		SetName("Dread Dragonfly");
		SetRace("demon");
		SetHealth(400);
		SetRoam(true);

		SetModel("monsters/dragonfly_queen.mdl");
		SetHearingSensitivity(10);
		SetMonsterClip(false);
		SetFly(true);
		SetWidth(32);
		SetHeight(32);
	}

	// return_home
	void OnReturnHome()
	{
		OnNpcatkSuspendAi();
		RETURNING_HOME = true;
		SetMoveDest(NPC_HOME_LOC, MOVE_RANGE);
	}

	// horror_boost
	void OnHorrorBoost()
	{
		SetVelocity(ENT_ME, RelativeVelocity(Vector3(0, 200, 0)));
	}

	// npcatk_setmovedest
	// =========================== custom flyer mods - END
	// =========================== Borrowed from bat_giant - BEGIN
	void OnNpcatkSetmovedest(string destination = "", string range = "")
	{
		// fly above target
		if (RETURNING_HOME)
			return;

		if (EntityId(EntityOf(destination)) != NPCATK_TARGET)
			SetMoveDest(destination, range);

		if (EntityId(EntityOf(destination)) == NPCATK_TARGET)
		{
			// attack from above
			Vector3 targOrg = OriginOf(NPCATK_TARGET) + RelativePosition(Vector3(0, 0, 0), Vector3(0, 0, 64));
			SetMoveDest(targOrg, 10);
		}
	}

	// make_babies
	void OnMakeBabies()
	{
		CallEventDelayed(FREQ_SUMMON, "make_babies");
		OLD_TARG = NPCATK_TARGET;
		OnNpcatkSuspendAi("2.0");
		Vector3 destPos = MyOrigin();
		destPos.z += 1024.0f;
		SetMoveDest(destPos, 10);
		AddVelocity(ENT_ME, Vector3(0, -50, 900));
		CallEventDelayed(0.5f, "make_babies2");
	}

	// make_babies2
	void OnMakeBabies2()
	{
		AddVelocity(ENT_ME, Vector3(0, -50, 900));
		SetMoveDest(OLD_TARG, 9999);
		// face targ, straighten
		SetVelocity(ENT_ME, Vector3(0, 0, 0));
		CallEventDelayed(0.1f, "make_babies3");
	}

	// make_babies3
	void OnMakeBabies3()
	{
		float myYaw = MyAngles().y;
		SetAngle("face", Vector3(0, myYaw, 0));
		PlayAnim("critical", ANIM_ATTACK);
		CallEventDelayed(0.1f, "bat_summon_all");
	}

	// bat_summon_all
	void OnBatSummonAll()
	{
		PlaySound(0, 10, "BAT_SUMMON_SND_SUMMON");
		PlayAnim("once", "attack2");
		BAT_SUMMON_NUM = BAT_SUMMON_AMT;
		CallEventDelayed(0.1f, "bat_summon_loop");
		CallEventDelayed(FREQ_SUMMON, "make_babies");
	}

	// bat_summon_loop
	void OnBatSummonLoop()
	{
		if (int(BAT_SUMMON_NUM) == 0)
			return;
		BAT_SUMMON_NUM -= 1.0f;
		Vector3 targetpos = OriginOf(ENT_ME);
		int ofsX = RandomInt(-100, 100);
		int ofsY = RandomInt(-100, 100);
		targetpos += Vector3(ofsX, ofsY, -64);
		CreateNpc(SUMMON_SCRIPT, targetpos, self, DMG_SUMMON, SUMMON_HEALTH, SUMMON_LIFETIME, HUNT_LASTTARGET);
		CallEventDelayed(0.1f, "bat_summon_loop");
	}

	// bite1
	// =========================== Borrowed from bat_giant - END
	// Anim Events
	void OnBite1()
	{
		DoDamage(HUNT_LASTTARGET, ATTACK_HITRANGE, DMG_BITE, ATTACK_HITCHANCE, "pierce");
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseNpc_OnGameSpawn(playerRace, playerGender); // monsters/base_npc
		BaseNpcAttack_OnGameSpawn(playerRace, playerGender); // monsters/base_npc_attack
		BaseMonsterShared_OnGameSpawn(playerRace, playerGender); // monsters/base_monster_shared
		BaseFlyer_OnGameSpawn(playerRace, playerGender); // monsters/base_flyer
	}

	// npcatk_targetvalidate
	void OnNpcatkTargetvalidate(string target = "")
	{
		BaseNpcAttack_OnNpcatkTargetvalidate(target); // monsters/base_npc_attack
		BaseFlyer_OnNpcatkTargetvalidate(target); // monsters/base_flyer
	}

	// npcatk_suspend_ai
	void OnNpcatkSuspendAi(string seconds = "", string debugTag = "")
	{
		BaseNpcAttack_OnNpcatkSuspendAi(seconds, debugTag); // monsters/base_npc_attack
		BaseMonsterShared_OnNpcatkSuspendAi(seconds, debugTag); // monsters/base_monster_shared
	}

	// npc_selectattack
	void OnNpcSelectattack()
	{
		BaseAntiStuck_OnNpcSelectattack(); // monsters/base_anti_stuck
		BaseMonsterShared_OnNpcSelectattack(); // monsters/base_monster_shared
		BaseFlyer_OnNpcSelectattack(); // monsters/base_flyer
	}

	void OnFreqSummon() {} // FREQ_SUMMON

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/dragonfly_queen.mdl");
		Precache("monsters/dragonfly_queen.wav");
		CallEventDelayed(FREQ_RETURN, "DragonflyQueen_Timer");
		CallEventDelayed(0.5f, "DragonflyQueen_Timer2");
		CallEventDelayed(FREQ_SOUND_HOVER, "DragonflyQueen_Timer3");
		CallEventDelayed(Float(CYCLE_TIME), "hunting_mode_go");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		DragonflyQueen_FirstThink();
		BaseNpcAttack_FirstThink();
		BaseNpc_FirstThink();
		MonstersExternals_FirstThink();
		BaseMonsterShared_FirstThink();
		BaseFlyer_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "bat_summon_all") { OnBatSummonAll(); return true; }
		if (name == "bat_summon_loop") { OnBatSummonLoop(); return true; }
		if (name == "bite1") { OnBite1(); return true; }
		if (name == "chicken_run") { OnChickenRun(Float(Param(params, 0))); return true; }
		if (name == "cycle_up") { OnCycleUp(Param(params, 0)); return true; }
		if (name == "game_death") { OnGameDeath(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "horror_boost") { OnHorrorBoost(); return true; }
		if (name == "make_babies") { OnMakeBabies(); return true; }
		if (name == "make_babies2") { OnMakeBabies2(); return true; }
		if (name == "make_babies3") { OnMakeBabies3(); return true; }
		if (name == "npc_post_spawn") { OnNpcPostSpawn(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "npcatk_setmovedest") { OnNpcatkSetmovedest(Param(params, 0), Param(params, 1)); return true; }
		if (name == "return_home") { OnReturnHome(); return true; }
		if (name == "DragonflyQueen_Timer") { DragonflyQueen_Timer(); return true; }
		if (name == "DragonflyQueen_Timer2") { DragonflyQueen_Timer2(); return true; }
		if (name == "DragonflyQueen_Timer3") { DragonflyQueen_Timer3(); return true; }
		return AttackHack_DispatchEvent(name, params)
			|| BaseFlyer_DispatchEvent(name, params)
			|| BaseMonsterScript::DispatchEvent(name, params);
	}
}
