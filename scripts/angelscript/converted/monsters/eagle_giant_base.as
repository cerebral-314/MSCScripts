#pragma context server

// Converted from monsters/eagle_giant_base.script by msc_transpiler.
// These birds usually hover in the air, well above their targets, raining down various sorts of terror
// Maybe I'll try to work out a dive attack

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_propelled.as"
#include "converted/monsters/base_monster.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class EagleGiantBase
{
	// Constants
	bool NPC_NO_END_FLY = true;
	string ANIM_PERCH1 = "idle";
	string ANIM_FIGIT = "idle2";
	string ANIM_IDLE_FLIGHT = "flapping";
	float DMG_ATTACK = 0.0f;
	int DMG_DIVE = 0;
	int FREQ_DIVE = 0;
	int SPEED_STANDARD = 200;
	int SPEED_DIVE = 400;
	float FLEE_COUNT = 10.0f;
	int ATTACK_RANGE_STANDARD = 64;
	int FLY_VSPEED_UP = 25;
	int FLY_VSPEED_DOWN = -25;
	int FLY_VRANGE = 50;
	string SOUND_FLAP1 = "monsters/bat/flap_big1.wav";
	string SOUND_FLAP2 = "monsters/bat/flap_big2.wav";
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
	CBaseEntity@ NPC_PROXACT_PLAYERID = null;
	bool NPC_PROXACT_TRIPPED = false;

	// unnamed block (first think)
	void EagleGiantBase_FirstThink()
	{
		// standard anims
		ANIM_IDLE = "flapping";
		ANIM_ATTACK = "attack";
		ANIM_DEATH = "crash";
		ANIM_WALK = "flapping";
		ANIM_RUN = "flapping";

		// standard stats
		MOVE_RANGE = "20";
		ATTACK_RANGE = 64.0f;
		ATTACK_HITRANGE = 72.0f;
		NPC_HACKED_MOVE_SPEED = 200.0f;
	}

	// npc_spawn
	void EagleGiantBase_OnNpcSpawn(string npc = "")
	{
		SetName("Giant Eagle");
		SetRace("wildanimal");
		SetHealth(1000);
		SetWidth(64);
		SetHeight(64);
		SetModel("monsters/eagle_large.mdl");
		SetIdleAnim("flapping");
		SetMoveAnim("flapping");
		SetHearingSensitivity(8);
		SetRoam(true);
		SetGravity(0);
		SetDamageTaken("poison", 2);

		COUNT_ATK = 0.0f;
	}

	// npc_targetsighted
	void EagleGiantBase_OnNpcTargetsighted(string target = "")
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
	void EagleGiantBase_OnStartPerched()
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
	void EagleGiantBase_OnUnPerch()
	{
		SetHearingSensitivity(8);
		AM_PERCHED = false;

		SetIdleAnim(ANIM_WALK);
		SetMoveAnim(ANIM_WALK);
		OnNpcatkSuspendAi();
		NPC_HACKED_MOVE_SPEED = SPEED_STANDARD;
		PlayAnim("critical", "divestart");
		SetVelocity(ENT_ME, RelativeVelocity(Vector3(0, 0, 100))); // pop up
		SetMoveDest("DIVE_START", 0);
		CallEventDelayed(1.0f, "npcatk_resume_ai");
		CallEventDelayed(1.1f, "target_invader");
	}

	// target_invader
	void EagleGiantBase_OnTargetInvader()
	{
		OnNpcatkTarget2(EntityId(NPC_PROXACT_PLAYERID));
	}

	// cycle_up
	void EagleGiantBase_OnCycleUp(string reason = "")
	{
		PlaySound(0, 10, SOUND_WARCRY);
	}

	// game_struck
	void EagleGiantBase_OnGameStruck(float damage = 0.0f, string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		if (AM_PERCHED)
		{
			@NPC_PROXACT_PLAYERID = EntityOf(ENT_LASTSTRUCK);
			NPC_PROXACT_TRIPPED = true;
			OnUnPerch();
		}
	}

	// attack1
	// anim event from attack
	void EagleGiantBase_OnAttack1()
	{
		PlaySound(0, 5, SOUND_ATTACK);
		DoDamage(HUNT_LASTTARGET, ATTACK_HITRANGE, DMG_ATTACK, "90%", "slash");
	}

	// attack2
	// anim event from attack
	void EagleGiantBase_OnAttack2()
	{
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
	void EagleGiantBase_OnFlapSound()
	{
		PlayRandomSound(0, 5, SOUND_FLAP1, SOUND_FLAP2);
	}

	// game_death
	void EagleGiantBase_OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		// addvelocity ent_me $relvel(0,0,-200)
		SetGravity(1);
	}

	// my_target_died
	void EagleGiantBase_OnMyTargetDied(string offender = "")
	{
		PlaySound(0, 10, SOUND_VICTORY);
	}

	// npcatk_hunt
	void EagleGiantBase_OnNpcatkHunt()
	{
		float zDiff = 0.0f;

		if (I_R_FROZEN)
			return;

		if (!IsAlive(ENT_ME))
			return;

		float moveDestZ = GroundHeight(Vec(Eval("game.monster.movedest.origin"))) + 256.0f;

		float myZ = OriginOf(ENT_ME).z;

		if (moveDestZ > myZ)
		{
			zDiff = moveDestZ - myZ;
			if (zDiff > FLY_VRANGE)
				AddVelocity(ENT_ME, RelativeVelocity(Vector3(0, 0, FLY_VSPEED_UP)));
		}

		if (moveDestZ < myZ)
		{
			zDiff = myZ - moveDestZ;
			if (zDiff > FLY_VRANGE)
				AddVelocity(ENT_ME, RelativeVelocity(Vector3(0, 0, FLY_VSPEED_DOWN)));
		}
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)

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
		EagleGiantBase_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4);
	}

	// game_struck
	void OnGameStruck(float damage = 0.0f, string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		BaseNpc_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseNpcAttack_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc_attack
		BaseMonsterShared_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared
		EagleGiantBase_OnGameStruck(damage, extraValue2, extraValue3, extraValue4);
	}

	// my_target_died
	void OnMyTargetDied(string offender = "")
	{
		BaseNpcAttack_OnMyTargetDied(offender); // monsters/base_npc_attack
		EagleGiantBase_OnMyTargetDied(offender);
	}

	// cycle_up
	void OnCycleUp(string reason = "")
	{
		BaseNpcAttack_OnCycleUp(reason); // monsters/base_npc_attack
		EagleGiantBase_OnCycleUp(reason);
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck
		EagleGiantBase_OnNpcSpawn(npc);
	}

	// npcatk_hunt
	void OnNpcatkHunt()
	{
		BaseAntiStuck_OnNpcatkHunt(); // monsters/base_anti_stuck
		EagleGiantBase_OnNpcatkHunt();
	}

	// npc_targetsighted
	void OnNpcTargetsighted(string target = "")
	{
		BaseMonsterShared_OnNpcTargetsighted(target); // monsters/base_monster_shared
		EagleGiantBase_OnNpcTargetsighted(target);
	}

	void OnStartPerched() { EagleGiantBase_OnStartPerched(); } // start_perched
	void OnUnPerch() { EagleGiantBase_OnUnPerch(); } // un_perch
	void OnTargetInvader() { EagleGiantBase_OnTargetInvader(); } // target_invader
	void OnAttack1() { EagleGiantBase_OnAttack1(); } // attack1
	void OnAttack2() { EagleGiantBase_OnAttack2(); } // attack2
	void OnFlapSound() { EagleGiantBase_OnFlapSound(); } // flap_sound

	// This file's events and timers by their .script names
	bool EagleGiantBase_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "attack1") { OnAttack1(); return true; }
		if (name == "attack2") { OnAttack2(); return true; }
		if (name == "cycle_up") { OnCycleUp(Param(params, 0)); return true; }
		if (name == "flap_sound") { OnFlapSound(); return true; }
		if (name == "game_death") { OnGameDeath(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_struck") { OnGameStruck(Float(Param(params, 0)), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "my_target_died") { OnMyTargetDied(Param(params, 0)); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "npc_targetsighted") { OnNpcTargetsighted(Param(params, 0)); return true; }
		if (name == "npcatk_hunt") { OnNpcatkHunt(); return true; }
		if (name == "start_perched") { OnStartPerched(); return true; }
		if (name == "target_invader") { OnTargetInvader(); return true; }
		if (name == "un_perch") { OnUnPerch(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "monsters/eagle_giant_base"]
shared class EagleGiantBaseScript : BaseMonsterScript, EagleGiantBase, BasePropelled
{
	// Variables every script that includes this file declares
	float BEAMS_ON = 0.0f;
	string BEAM_LIST = "BEAM_LIST";
	string BEAM_TARGETS = "BEAM_TARGETS";
	float DOT_SHOCK = 0.0f;
	float FREQ_STORM = 0.0f;
	float FREQ_ZAP = 0.0f;
	string SOUND_STORM = "SOUND_STORM";
	string SOUND_ZAP = "SOUND_ZAP";
	string SOUND_ZAP_WARMUP = "SOUND_ZAP_WARMUP";

	// Variables declared by included files, with the value they start with in this script
	EagleGiantBaseScript()
	{
		SOUND_DEATH = "monsters/birds/hawk.wav";
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/eagle_large.mdl");
		CallEventDelayed(Float(CYCLE_TIME), "hunting_mode_go");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		EagleGiantBase_FirstThink();
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
		return EagleGiantBase_DispatchEvent(name, params)
			|| BasePropelled_DispatchEvent(name, params)
			|| BaseMonsterScript::DispatchEvent(name, params);
	}
}
