#pragma context server

// Converted from monsters/eagle_base.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_flyer.as"
#include "converted/monsters/base_propelled.as"
#include "converted/monsters/base_monster.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class EagleBase
{
	// Constants
	string ANIM_PERCH1 = "idle";
	string ANIM_FIGIT = "idle2";
	string ANIM_IDLE_FLIGHT = "flapping";
	string ANIM_DIVE = "dive";
	bool NPC_NO_END_FLY = true;
	float DMG_ATTACK = 0.0f;
	int DMG_DIVE = 0;
	int FREQ_DIVE = 0;
	int SPEED_STANDARD = 200;
	int SPEED_DIVE = 400;
	float FLEE_COUNT = 10.0f;
	int ATTACK_RANGE_STANDARD = 64;
	string SOUND_FLAP = "monsters/birds/hawkidle.wav";
	string SOUND_WARCRY = "monsters/birds/bird.wav";
	string SOUND_DEATH = "monsters/birds/hawk.wav";
	string SOUND_ATTACK = "monsters/birds/flutter.wav";
	string SOUND_STRUCK = "debris/flesh2.wav";
	string SOUND_PAIN = "monsters/birds/vulture.wav";
	string SOUND_PAIN2 = "monsters/birds/cry.wav";
	string SOUND_VICTORY = "monsters/birds/hawkcaw.wav";

	// Variables (an unset .script variable reads as its own name)
	string ANIM_IDLE = "ANIM_IDLE";
	string ANIM_ATTACK = "ANIM_ATTACK";
	string ANIM_DEATH = "ANIM_DEATH";
	string ANIM_WALK = "ANIM_WALK";
	string ANIM_RUN = "ANIM_RUN";
	string MOVE_RANGE = "MOVE_RANGE";
	float ATTACK_RANGE = 0.0f;
	float ATTACK_HITRANGE = 0.0f;
	float NPC_HACKED_MOVE_SPEED = 0.0f;
	float COUNT_ATK = 0.0f;
	bool AM_PERCHED = false;
	bool NPC_PROX_ACTIVATE = false;
	string NPC_PROXACT_RANGE = "NPC_PROXACT_RANGE";
	string NPC_PROXACT_EVENT = "NPC_PROXACT_EVENT";
	bool NPC_PROXACT_FOV = false;
	int NPC_PROXACT_CONE = 0;
	Vector3 DIVE_POS = Vector3();
	Vector3 DIVE_START = Vector3();
	bool IN_DIVE = false;
	CBaseEntity@ NPC_PROXACT_PLAYERID = null;
	bool NPC_PROXACT_TRIPPED = false;
	bool MELEE_ATTACK = false;
	float FLIGHT_STUCK = 0.0f;
	float LAST_PROG = 0.0f;
	Vector3 LAST_POS = Vector3();
	bool AM_SUMMONED = false;

	// unnamed block (first think)
	void EagleBase_FirstThink()
	{
		// standard anims
		ANIM_IDLE = "flapping";
		ANIM_ATTACK = "attack";
		ANIM_DEATH = "fall";
		ANIM_WALK = "flapping";
		ANIM_RUN = "flapping";

		// standard stats
		MOVE_RANGE = "20";
		ATTACK_RANGE = 64.0f;
		ATTACK_HITRANGE = 72.0f;
		NPC_HACKED_MOVE_SPEED = 200.0f;
	}

	// npc_spawn
	void EagleBase_OnNpcSpawn(string npc = "")
	{
		bool keepClip = false;

		SetName("Eagle");
		SetRace("wildanimal");
		SetHealth(300);
		SetWidth(32);
		SetHeight(32);
		SetModel("monsters/eagle.mdl");
		SetIdleAnim("flapping");
		SetMoveAnim("flapping");
		SetHearingSensitivity(11);
		SetRoam(true);
		SetFly(true);
		SetDamageTaken("poison", 2);

		if (ToLowerCase(MapName()) == "thanatos")
			keepClip = true;
		if (ToLowerCase(MapName()) == "the_wall")
			keepClip = true;
		if (!keepClip)
			SetMonsterClip(false);

		COUNT_ATK = 0.0f;
	}

	// npc_targetsighted
	void EagleBase_OnNpcTargetsighted(string target = "")
	{
		// eagle cannot hit NPC's taller than 64 units without this bit
		if (!IsPlayer(HUNT_LASTTARGET))
		{
			ATTACK_RANGE = HeightOf(HUNT_LASTTARGET);
			if (!CYCLED_UP)
				OnCycleUp();
		}
		else
		{
			ATTACK_RANGE = ATTACK_RANGE_STANDARD;
		}
	}

	// start_perched
	// additional param
	void EagleBase_OnStartPerched()
	{
		SetIdleAnim("idle");
		SetMoveAnim("idle");
		SetRoam(false);
		AM_PERCHED = true;

		SetHearingSensitivity(0);

		OnNpcatkSuspendAi();

		NPC_PROX_ACTIVATE = true;
		NPC_PROXACT_RANGE = "384";
		NPC_PROXACT_EVENT = "un_perch";
		NPC_PROXACT_FOV = true;
		NPC_PROXACT_CONE = 90;
		CallEventDelayed(0.1f, "npcatk_proxact_scan");
	}

	// un_perch
	void EagleBase_OnUnPerch()
	{
		SetHearingSensitivity(8);
		AM_PERCHED = false;

		SetIdleAnim(ANIM_WALK);
		SetMoveAnim(ANIM_WALK);
		OnNpcatkSuspendAi();
		NPC_HACKED_MOVE_SPEED = SPEED_STANDARD;
		PlayAnim("critical", "divestart");
		SetVelocity(ENT_ME, RelativeVelocity(Vector3(0, 0, 100))); // pop up
		SetMoveDest(DIVE_START, 0);
		CallEventDelayed(1.0f, "npcatk_resume_ai");
		CallEventDelayed(1.1f, "target_invader");
	}

	// target_invader
	void EagleBase_OnTargetInvader()
	{
		OnNpcatkTarget2(EntityId(NPC_PROXACT_PLAYERID));
	}

	// cycle_up
	void EagleBase_OnCycleUp(string reason = "")
	{
		PlaySound(0, 10, SOUND_WARCRY);
		CallEventDelayed(1.0f, "dive_check");
	}

	// dive_check
	void EagleBase_OnDiveCheck()
	{
		// dive sequence no workie so far
		if (NO_DIVE)
			return;

		CallEventDelayed(FREQ_DIVE, "dive_check");
		if (!IsAlive(HUNT_LASTTARGET))
			return;
		if (!CanSee(HUNT_LASTTARGET))
			return;

		DIVE_POS = OriginOf(HUNT_LASTTARGET);
		DIVE_START = MyOrigin();
		IN_DIVE = true;
		NPC_HACKED_MOVE_SPEED = SPEED_DIVE;
		OnNpcatkSuspendAi();
		PlayAnim("critical", "divestart");
		SetVelocity(ENT_ME, RelativeVelocity(Vector3(0, 0, -200)));
		CallEventDelayed(1.0f, "dive_go");
	}

	// dive_go
	void EagleBase_OnDiveGo()
	{
		PlaySound(0, 10, SOUND_WARCRY);
		SetMoveAnim("dive");
		SetIdleAnim("dive");
		SetMoveDest(DIVE_POS, 10);
		OnDiveDmgLoop();
	}

	// dive_dmg_loop
	void EagleBase_OnDiveDmgLoop()
	{
		if (!IN_DIVE)
			return;
		CallEventDelayed(0.1f, "dive_dmg_loop");
		SetMoveDest(DIVE_POS, 10);
		DoDamage(Text(RelativePosition(Vector3(0, 0, 0))), 64, DMG_DIVE, "100%", 0, "reflective", "pierce");
		Vector3 myOrg = OriginOf(ENT_ME);
		float grndLevel = GroundHeight(myOrg);
		if (grndLevel <= 32.0f)
			OnDiveEnd();
		if (!(Distance(myOrg, DIVE_POS) < 32.0f))
			return;
		OnDiveEnd();
	}

	// dive_end
	void EagleBase_OnDiveEnd()
	{
		IN_DIVE = false;
		SetIdleAnim(ANIM_WALK);
		SetMoveAnim(ANIM_WALK);
		NPC_HACKED_MOVE_SPEED = SPEED_STANDARD;
		PlayAnim("critical", "divestart");
		SetVelocity(ENT_ME, RelativeVelocity(Vector3(0, -400, -200))); // pop up and back a bit
		SetMoveDest(DIVE_START, 0);
		CallEventDelayed(1.0f, "npcatk_resume_ai");
	}

	// game_dodamage
	string EagleBase_OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";
		if (!IN_DIVE)
			return result;
		AddVelocity(target, RelativeVelocity(Vector3(Random(-20, 20), 200, 10)));
		return result;
	}

	// game_struck
	void EagleBase_OnGameStruck(float damage = 0.0f, string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		if (AM_PERCHED)
		{
			@NPC_PROXACT_PLAYERID = EntityOf(ENT_LASTSTRUCK);
			NPC_PROXACT_TRIPPED = true;
			OnUnPerch();
		}

		// push about a bit
		PlayRandomSound(0, 10, SOUND_STRUCK, SOUND_STRUCK, SOUND_STRUCK, SOUND_STRUCK, SOUND_STRUCK, SOUND_PAIN, SOUND_PAIN2);
		if (!(damage > 30.0f))
			return;
		float rndRl = Random(-40, 40);
		float rndFb = Random(-40, 40);
		float rndUd = Random(-40, 40);
		AddVelocity(ENT_ME, Vector3(rndRl, rndFb, rndUd));
	}

	// attack1
	// anim event from attack
	void EagleBase_OnAttack1()
	{
		MELEE_ATTACK = true;
		PlaySound(0, 5, SOUND_ATTACK);
		DoDamage(HUNT_LASTTARGET, ATTACK_HITRANGE, DMG_ATTACK, "90%", "slash");
	}

	// attack2
	// anim event from attack
	void EagleBase_OnAttack2()
	{
		MELEE_ATTACK = true;
		PlaySound(0, 5, SOUND_ATTACK);
		DoDamage(HUNT_LASTTARGET, ATTACK_HITRANGE, DMG_ATTACK, "90%", "slash");
		COUNT_ATK += 1.0f;

		if (COUNT_ATK > FLEE_COUNT)
		{
			COUNT_ATK = 0.0f;
			OnNpcatkSuspendAi("3.0");
			SetMoveDest(HUNT_LASTTARGET, 1000, "flee");
		}
	}

	// flap_sound
	// anim event from flapping
	void EagleBase_OnFlapSound()
	{
		PlaySound(0, 5, SOUND_FLAP);
	}

	// game_death
	void EagleBase_OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		AddVelocity(ENT_ME, RelativeVelocity(Vector3(0, 0, -200)));
	}

	// unnamed block (timer)
	// ========= ADV FLIGHT AI
	void EagleBase_Timer()
	{
		bool exitSub = false;
		CallEventDelayed(0.5f, "EagleBase_Timer");

		if (I_R_FROZEN)
			return;

		if (AM_PERCHED)
		{
			if (RandomInt(1, 50) == 1)
				PlayAnim("once", ANIM_FIGIT);
			exitSub = true;
		}
		if (exitSub)
			return;

		if (SUSPEND_AI)
			return;

		float myGround = GroundHeight(MyOrigin());
		float myAlti = Float(Eval("game.monster.origin.z"));
		myAlti -= myGround;

		if (myAlti < 32.0f)
		{
			// too close to ground, fly up
			SetVelocity(ENT_ME, RelativeVelocity(Vector3(0, 0, 300)));
			exitSub = true;
		}
		if (exitSub)
			return;

		if (!IS_HUNTING)
			return;
		if (SUSPEND_AI)
			return;
		OnNpcatkFaceattacker();
		if (RangeTo(HUNT_LASTTARGET) > Float(MOVE_RANGE))
			SetVelocity(ENT_ME, RelativeVelocity(Vector3(0, 200, 0)));
		if (RangeTo(HUNT_LASTTARGET) <= Float(MOVE_RANGE))
			SetVelocity(ENT_ME, Vector3(0, 0, 0));

		// if ( SPITTING ) setvelocity ent_me $vec(0,0,0)
		if (FLIGHT_STUCK > 2.0f)
		{
			// callevent chicken_run 1.0
			PlayAnim("once", ANIM_DIVE);
			OnDoRandTweedee();
			OnNpcatkSuspendAi(Text(Random(0.3f, 0.9f)));
			SetMoveDest(NEW_DEST, Eval("game.monster.moveprox"));
			CallEventDelayed(0.1f, "horror_boost");
			FLIGHT_STUCK = 0.0f;
		}

		Vector3 targPos = OriginOf(NPCATK_TARGET);
		if (!SUSPEND_AI)
			SetAngle("face_origin", targPos);

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

	// chicken_run
	void EagleBase_OnChickenRun(float duration = 0.0f)
	{
		CallEventDelayed(0.1f, "horror_boost");
	}

	// horror_boost
	void EagleBase_OnHorrorBoost()
	{
		SetVelocity(ENT_ME, RelativeVelocity(Vector3(0, 500, 0)));
	}

	// my_target_died
	void EagleBase_OnMyTargetDied(string offender = "")
	{
		PlaySound(0, 10, SOUND_VICTORY);
	}

	// summon_eagle_vanish
	void EagleBase_OnSummonEagleVanish()
	{
		if (!AM_SUMMONED)
			return;
		OnNpcFadeAway();
	}

	// game_dynamically_created
	void EagleBase_OnGameDynamicallyCreated(string creatorValue1 = "", string creatorValue2 = "", string damage = "", string skill = "", string extraValue5 = "", string extraValue6 = "", float alwaysPush = 0.0f, string duration = "", string extraValue9 = "")
	{
		AM_SUMMONED = true;
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseFlyer_OnGameSpawn(playerRace, playerGender); // monsters/base_flyer
		BaseNpc_OnGameSpawn(playerRace, playerGender); // monsters/base_npc
		BaseNpcAttack_OnGameSpawn(playerRace, playerGender); // monsters/base_npc_attack
		BaseMonsterShared_OnGameSpawn(playerRace, playerGender); // monsters/base_monster_shared
	}

	// npcatk_targetvalidate
	void OnNpcatkTargetvalidate(string target = "")
	{
		BaseFlyer_OnNpcatkTargetvalidate(target); // monsters/base_flyer
		BaseNpcAttack_OnNpcatkTargetvalidate(target); // monsters/base_npc_attack
	}

	// npc_selectattack
	void OnNpcSelectattack()
	{
		BaseFlyer_OnNpcSelectattack(); // monsters/base_flyer
		BaseAntiStuck_OnNpcSelectattack(); // monsters/base_anti_stuck
		BaseMonsterShared_OnNpcSelectattack(); // monsters/base_monster_shared
	}

	// npc_post_spawn
	void OnNpcPostSpawn()
	{
		BasePropelled_OnNpcPostSpawn(); // monsters/base_propelled
		MonstersExternals_OnNpcPostSpawn(); // monsters/externals
		MonstersExternals_OnNpcPostSpawn_2(); // monsters/externals
		MonstersExternals_OnNpcPostSpawn_3(); // monsters/externals
		BaseSelfAdjust_OnNpcPostSpawn(); // monsters/base_self_adjust
		BaseNpc_OnNpcPostSpawn(); // monsters/base_npc
		BaseMonsterShared_OnNpcPostSpawn(); // monsters/base_monster_shared
	}

	// game_death
	void OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		DqMonsterExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // dq/externals/dq_monster_externals
		MonstersExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/externals
		BaseSelfAdjust_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_self_adjust
		BaseNpc_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseMonsterShared_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared
		EagleBase_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4);
	}

	// game_dynamically_created
	void OnGameDynamicallyCreated(string creatorValue1 = "", string creatorValue2 = "", string damage = "", string skill = "", string extraValue5 = "", string extraValue6 = "", float alwaysPush = 0.0f, string duration = "", string extraValue9 = "")
	{
		BaseSelfAdjust_OnGameDynamicallyCreated(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/base_self_adjust
		BaseSelfAdjust_OnGameDynamicallyCreated_2(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/base_self_adjust
		BaseAntiStuck_OnGameDynamicallyCreated(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/base_anti_stuck
		BaseAntiStuck_OnGameDynamicallyCreated_2(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/base_anti_stuck
		EagleBase_OnGameDynamicallyCreated(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9);
	}

	// game_struck
	void OnGameStruck(float damage = 0.0f, string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		BaseNpc_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseNpcAttack_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc_attack
		BaseMonsterShared_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared
		EagleBase_OnGameStruck(damage, extraValue2, extraValue3, extraValue4);
	}

	// my_target_died
	void OnMyTargetDied(string offender = "")
	{
		BaseNpcAttack_OnMyTargetDied(offender); // monsters/base_npc_attack
		EagleBase_OnMyTargetDied(offender);
	}

	// chicken_run
	void OnChickenRun(float duration = 0.0f)
	{
		BaseNpcAttack_OnChickenRun(duration); // monsters/base_npc_attack
		EagleBase_OnChickenRun(duration);
	}

	// npcatk_suspend_ai
	void OnNpcatkSuspendAi(string seconds = "", string debugTag = "")
	{
		BaseNpcAttack_OnNpcatkSuspendAi(seconds, debugTag); // monsters/base_npc_attack
		BaseMonsterShared_OnNpcatkSuspendAi(seconds, debugTag); // monsters/base_monster_shared
	}

	// cycle_up
	void OnCycleUp(string reason = "")
	{
		BaseNpcAttack_OnCycleUp(reason); // monsters/base_npc_attack
		EagleBase_OnCycleUp(reason);
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck
		EagleBase_OnNpcSpawn(npc);
	}

	// game_dodamage
	string OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";
		result = AppendResult(result, BaseAntiStuck_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BaseMonsterShared_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, EagleBase_OnGameDodamage(hit, target, start, end, damageType, damageText));
		return result;
	}

	// npc_targetsighted
	void OnNpcTargetsighted(string target = "")
	{
		BaseMonsterShared_OnNpcTargetsighted(target); // monsters/base_monster_shared
		EagleBase_OnNpcTargetsighted(target);
	}

	void OnStartPerched() { EagleBase_OnStartPerched(); } // start_perched
	void OnUnPerch() { EagleBase_OnUnPerch(); } // un_perch
	void OnTargetInvader() { EagleBase_OnTargetInvader(); } // target_invader
	void OnDiveCheck() { EagleBase_OnDiveCheck(); } // dive_check
	void OnDiveGo() { EagleBase_OnDiveGo(); } // dive_go
	void OnDiveDmgLoop() { EagleBase_OnDiveDmgLoop(); } // dive_dmg_loop
	void OnDiveEnd() { EagleBase_OnDiveEnd(); } // dive_end
	void OnAttack1() { EagleBase_OnAttack1(); } // attack1
	void OnAttack2() { EagleBase_OnAttack2(); } // attack2
	void OnFlapSound() { EagleBase_OnFlapSound(); } // flap_sound
	void OnHorrorBoost() { EagleBase_OnHorrorBoost(); } // horror_boost
	void OnSummonEagleVanish() { EagleBase_OnSummonEagleVanish(); } // summon_eagle_vanish
	void OnFreqDive() {} // FREQ_DIVE

	// This file's events and timers by their .script names
	bool EagleBase_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "attack1") { OnAttack1(); return true; }
		if (name == "attack2") { OnAttack2(); return true; }
		if (name == "chicken_run") { OnChickenRun(Float(Param(params, 0))); return true; }
		if (name == "cycle_up") { OnCycleUp(Param(params, 0)); return true; }
		if (name == "dive_check") { OnDiveCheck(); return true; }
		if (name == "dive_dmg_loop") { OnDiveDmgLoop(); return true; }
		if (name == "dive_end") { OnDiveEnd(); return true; }
		if (name == "dive_go") { OnDiveGo(); return true; }
		if (name == "flap_sound") { OnFlapSound(); return true; }
		if (name == "game_death") { OnGameDeath(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_dodamage") { Return(OnGameDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5))); return true; }
		if (name == "game_dynamically_created") { OnGameDynamicallyCreated(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Float(Param(params, 6)), Param(params, 7), Param(params, 8)); return true; }
		if (name == "game_struck") { OnGameStruck(Float(Param(params, 0)), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "horror_boost") { OnHorrorBoost(); return true; }
		if (name == "my_target_died") { OnMyTargetDied(Param(params, 0)); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "npc_targetsighted") { OnNpcTargetsighted(Param(params, 0)); return true; }
		if (name == "start_perched") { OnStartPerched(); return true; }
		if (name == "summon_eagle_vanish") { OnSummonEagleVanish(); return true; }
		if (name == "target_invader") { OnTargetInvader(); return true; }
		if (name == "un_perch") { OnUnPerch(); return true; }
		if (name == "EagleBase_Timer") { EagleBase_Timer(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "monsters/eagle_base"]
shared class EagleBaseScript : BaseMonsterScript, EagleBase, BaseFlyer, BasePropelled
{
	// Variables every script that includes this file declares
	bool NO_DIVE = false;

	// Variables declared by included files, with the value they start with in this script
	EagleBaseScript()
	{
		SOUND_DEATH = "monsters/birds/hawk.wav";
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/eagle.mdl");
		CallEventDelayed(0.5f, "EagleBase_Timer");
		CallEventDelayed(Float(CYCLE_TIME), "hunting_mode_go");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		EagleBase_FirstThink();
		BaseFlyer_FirstThink();
		BaseNpcAttack_FirstThink();
		BaseNpc_FirstThink();
		MonstersExternals_FirstThink();
		BaseMonsterShared_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return EagleBase_DispatchEvent(name, params)
			|| BaseFlyer_DispatchEvent(name, params)
			|| BasePropelled_DispatchEvent(name, params)
			|| BaseMonsterScript::DispatchEvent(name, params);
	}
}
