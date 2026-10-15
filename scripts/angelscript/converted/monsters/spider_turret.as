#pragma context server

// Converted from monsters/spider_turret.script by msc_transpiler.
// Spider Turret by Thothie ( From Spitting Spider + Horror )
// - This is basically a turret - it does not move, just shoots

#include "runtime/ScriptEntity.as"
#include "converted/monsters/spider_base.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class SpiderTurret
{
	// Constants
	string PROJ_TYPE = "proj_poison";
	string SOUND_PAIN = "monsters/spider/spiderhiss.wav";
	string SOUND_IDLE1 = "monsters/spider/spideridle.wav";
	string SOUND_DEATH = "monsters/spider/spiderdie.wav";
	string SND_STRUCK1 = "body/flesh1.wav";
	string SND_STRUCK2 = "body/flesh2.wav";
	string SND_STRUCK3 = "body/flesh3.wav";
	string SND_STRUCK4 = "SND_STRUCK4";
	string SND_STRUCK5 = "SND_STRUCK5";
	string SOUND_ATTACK1 = "zombie/claw_miss1.wav";
	string SOUND_ATTACK2 = "zombie/claw_miss2.wav";
	string ANIM_DODGE = "dodge";
	int ATTACK_SPEED = 650;
	float ATTACK_DAMAGE_LOW = 12.0f;
	float ATTACK_DAMAGE_HIGH = 24.0f;
	string ATTACK_ACCURACY = "60%";
	int SPIDER_IDLE_VOL = 3;
	float SPIDER_IDLE_DELAY = 3.6f;
	int SPIDER_VOLUME = 10;
	float SPIT_FREQ = 1.0f;
	int AIM_RATIO = 50;

	// Variables (an unset .script variable reads as its own name)
	string ANIM_IDLE = "idle";
	string ANIM_WALK = "walk";
	string ANIM_RUN = "run";
	string ANIM_ATTACK = "ANIM_ATTACK";
	string ANIM_DEATH = "ANIM_DEATH";
	float ATTACK_RANGE = 0.0f;
	string MOVE_RANGE = "MOVE_RANGE";
	bool NO_STEP_ADJ = false;
	string NO_STUCK_CHECKS = "NO_STUCK_CHECKS";
	string NPC_MOVE_TARGET = "NPC_MOVE_TARGET";
	string RETALIATE_CHANCE = "RETALIATE_CHANCE";
	float NPC_GIVE_EXP = 0.0f;
	float FIRE_DELAY = 0.0f;

	// unnamed block (first think)
	void SpiderTurret_FirstThink()
	{
		ANIM_IDLE = "idle";
		ANIM_WALK = "walk";
		ANIM_RUN = "run";
		ANIM_ATTACK = "attack";
		ANIM_DEATH = "die";

		ATTACK_RANGE = 128.0f;

		ATTACK_RANGE = 128.0f;
		MOVE_RANGE = "75";

		NO_STEP_ADJ = true; // maybe causing aiming issues

		NO_STUCK_CHECKS = "1"; // not stuck, I just don't move

		NPC_MOVE_TARGET = "enemy"; // base_npc_attack - Premptive attack
		RETALIATE_CHANCE = "75%"; // base_npc_attack - Automatically switch targets to the last damaging player
	}

	// npc_spawn
	void SpiderTurret_OnNpcSpawn(string npc = "")
	{
		OnSpiderSpawn();
	}

	// spider_spawn
	void SpiderTurret_OnSpiderSpawn()
	{
		SetHealth(150);
		// ov 359
		SetWidth(64);
		SetHeight(64);
		SetRoam(false);
		SetMoveSpeed(0);
		SetName("Spitting Spider");
		SetHearingSensitivity(10);
		SetModel("monsters/fer_spider_large.mdl");
		SetModelBody(0, 1);

		SetDamageTaken("all", 0.8f);
		NPC_GIVE_EXP = 80.0f;
	}

	// debug_props
	void SpiderTurret_OnDebugProps()
	{
		SetSayTextRange(1024);

		if (CanSee("enemy"))
			SayText("I see enemy: ( " + NameOf(ENT_LASTSEEN) + " )");
		if (IS_HUNTING)
			SayText("I am hunting: " + NameOf(ENTITY_ENEMY));
		if (HUNTING_PLAYER)
			SayText("I am hunting a player.");

		if (!CanSee("enemy"))
			SayText("I see NO enemy.");
		if (!IS_HUNTING)
			SayText("I am NOT hunting.");
		if (!HUNTING_PLAYER)
			SayText("I am NOT hunting a player.");

		SayText("My cycle time is " + CYCLE_TIME);
	}

	// bite1
	// called from modelanim attack @frame 12
	void SpiderTurret_OnBite1()
	{
		PlayRandomSound(Int(GetVar("CHAN_VOICE")), SOUND_ATTACK1, SOUND_ATTACK2);
		DoDamage(ENTITY_ENEMY, ATTACK_HITRANGE, Random(ATTACK_DAMAGE_LOW, ATTACK_DAMAGE_HIGH), ATTACK_ACCURACY);

		SetMoveDest(ENTITY_ENEMY, 9999);

		// <projectile scriptname> <"view"|(src_origin)> <target|(targ_origin)|none> <speed> <damage> <cof> <skill|none> //Converted to use new tossprojectile //greatguys1@FEB2022
		TossProjectile(PROJ_TYPE, RelativePosition(Vector3(0, 48, 0)), HUNT_LASTTARGET, ATTACK_SPEED, Random(ATTACK_DAMAGE_LOW, ATTACK_DAMAGE_HIGH), 2, "none");
	}

	// reset_fire_delay
	void SpiderTurret_OnResetFireDelay()
	{
		FIRE_DELAY = 0.0f;
	}

	// npcatk_targetvalidate
	void SpiderTurret_OnNpcatkTargetvalidate(string target = "")
	{
		if (int(FIRE_DELAY) != 0)
			return;
		FIRE_DELAY = 1.0f;
		CallEventDelayed(SPIT_FREQ, "reset_fire_delay");

		if (!CanSee("enemy"))
			return;
		PlayAnim("once", ANIM_ATTACK);
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)

	// npcatk_targetvalidate
	void OnNpcatkTargetvalidate(string target = "")
	{
		BaseNpcAttack_OnNpcatkTargetvalidate(target); // monsters/base_npc_attack
		SpiderTurret_OnNpcatkTargetvalidate(target);
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck
		SpiderBase_OnNpcSpawn(npc); // monsters/spider_base
		SpiderTurret_OnNpcSpawn(npc);
	}

	void OnSpiderSpawn() { SpiderTurret_OnSpiderSpawn(); } // spider_spawn
	void OnDebugProps() { SpiderTurret_OnDebugProps(); } // debug_props
	void OnBite1() { SpiderTurret_OnBite1(); } // bite1
	void OnResetFireDelay() { SpiderTurret_OnResetFireDelay(); } // reset_fire_delay
	void OnSpitFreq() {} // SPIT_FREQ

	// This file's events and timers by their .script names
	bool SpiderTurret_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "bite1") { OnBite1(); return true; }
		if (name == "debug_props") { OnDebugProps(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "npcatk_targetvalidate") { OnNpcatkTargetvalidate(Param(params, 0)); return true; }
		if (name == "reset_fire_delay") { OnResetFireDelay(); return true; }
		if (name == "spider_spawn") { OnSpiderSpawn(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "monsters/spider_turret"]
shared class SpiderTurretScript : SpiderBaseScript, SpiderTurret
{
	// Variables every script that includes this file declares
	float DOT_FIRE = 0.0f;
	Vector3 PROJ_OFS = Vector3();

	// Variables declared by included files, with the value they start with in this script
	SpiderTurretScript()
	{
		SOUND_PAIN = "monsters/spider/spiderhiss.wav";
		SOUND_IDLE1 = "monsters/spider/spideridle.wav";
		SOUND_DEATH = "monsters/spider/spiderdie.wav";
		SND_STRUCK1 = "body/flesh1.wav";
		SND_STRUCK2 = "body/flesh2.wav";
		SND_STRUCK3 = "body/flesh3.wav";
		ANIM_IDLE = "idle";
		ANIM_WALK = "walk";
		ANIM_RUN = "run";
		ATTACK_DAMAGE_LOW = 12.0f;
		ATTACK_DAMAGE_HIGH = 24.0f;
		ATTACK_ACCURACY = "60%";
		SPIDER_IDLE_VOL = 3;
		SPIDER_IDLE_DELAY = 3.6f;
		SPIDER_VOLUME = 10;
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/fer_spider_large.mdl");
		CallEventDelayed(SPIDER_IDLE_DELAY, "SpiderBase_Timer");
		CallEventDelayed(Float(CYCLE_TIME), "hunting_mode_go");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		SpiderTurret_FirstThink();
		SpiderBase_FirstThink();
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
		return SpiderTurret_DispatchEvent(name, params)
			|| SpiderBaseScript::DispatchEvent(name, params);
	}
}
