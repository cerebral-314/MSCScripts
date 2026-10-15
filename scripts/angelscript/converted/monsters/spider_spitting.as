#pragma context server

// Converted from monsters/spider_spitting.script by msc_transpiler.
// Giant Spider

#include "runtime/ScriptEntity.as"
#include "converted/monsters/spider_base.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class SpiderSpitting
{
	// Constants
	string PROJ_TYPE = "proj_poison";
	Vector3 PROJ_OFS = Vector3();
	bool DELETE_ON_DEATH = true;
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
	float ATTACK_DAMAGE_LOW = 4.0f;
	float ATTACK_DAMAGE_HIGH = 6.0f;
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
	float ATTACK_HITRANGE = 0.0f;
	string MOVE_RANGE = "MOVE_RANGE";
	bool NO_STEP_ADJ = false;
	string RETALIATE_CHANCE = "RETALIATE_CHANCE";
	float NPC_GIVE_EXP = 0.0f;
	float AS_ATTACKING = 0.0f;

	// unnamed block (first think)
	void SpiderSpitting_FirstThink()
	{
		ANIM_IDLE = "idle";
		ANIM_WALK = "walk";
		ANIM_RUN = "run";
		ANIM_ATTACK = "attack";
		ANIM_DEATH = "die";
		ATTACK_RANGE = 64.0f;
		ATTACK_HITRANGE = 69.0f;

		MOVE_RANGE = "384";

		NO_STEP_ADJ = true; // maybe causing aiming issues

		// setvard NPC_MOVE_TARGET enemy	//base_npc_attack - Premptive attack
		RETALIATE_CHANCE = "75%"; // base_npc_attack - Automatically switch targets to the last damaging player
	}

	// npc_spawn
	void SpiderSpitting_OnNpcSpawn(string npc = "")
	{
		OnSpiderSpawn();
	}

	// spider_spawn
	void SpiderSpitting_OnSpiderSpawn()
	{
		SetHealth(80);
		// ov 359
		if (!Truthy(GetVar("AM_CLIPPED")))
		{
			SetWidth(64);
			SetHeight(64);
		}

		if (Truthy(GetVar("AM_CLIPPED")))
		{
			SetWidth(32);
			SetHeight(20);
			SetBoundingBox("npcsize");
		}

		SetName("Spitting Cave Spider");
		SetHearingSensitivity(7);
		SetModel("monsters/gspider.mdl");

		SetDamageTaken("all", 0.8f);
		NPC_GIVE_EXP = 70.0f;
	}

	// debug_props
	void SpiderSpitting_OnDebugProps()
	{
		SetSayTextRange(1024);
		SayText("I cansee ( nme " + Text(CanSee("enemy")) + " hunt " + Text(CanSee(HUNT_LASTTARGET)) + " cycl " + CYCLE_TIME + " is " + Text(IS_HUNTING) + " plr " + Text(HUNTING_PLAYER) + " )");
	}

	// bite1
	// Deal damage
	void SpiderSpitting_OnBite1()
	{
		// callevent npcatk_faceattacker
		AS_ATTACKING = GameTime();

		PlayRandomSound(Int(GetVar("CHAN_VOICE")), SOUND_ATTACK1, SOUND_ATTACK2);
		DoDamageEx(HUNT_LASTTARGET, ATTACK_HITRANGE, Random(ATTACK_DAMAGE_LOW, ATTACK_DAMAGE_HIGH), ATTACK_ACCURACY, ENT_ME, ENT_ME, "none", "pierce", "dmgevent:bite");

		if (!CanSee("enemy"))
			return;
		Vector3 pos = OriginOf(ENT_ME) + RelativePosition(AnglesOf(ENT_ME), PROJ_OFS);
		// <projectile scriptname> <"view"|(src_origin)> <target|(targ_origin)|none> <speed> <damage> <cof> <skill|none> //Converted to use new tossprojectile //greatguys1@FEB2022
		TossProjectile(PROJ_TYPE, pos, HUNT_LASTTARGET, ATTACK_SPEED, Random(ATTACK_DAMAGE_LOW, ATTACK_DAMAGE_HIGH), 2, "none");
	}

	// npc_targetsighted
	void SpiderSpitting_OnNpcTargetsighted(string target = "")
	{
		// //dbg Validating $get(PARAM1,name) ( Delay FIRE_DELAY Cansee $cansee(enemy) )
		if (!CanSee("enemy"))
			return;

		if (!(RangeTo(target) > ATTACK_RANGE))
			return;

		PlayAnim("once", ANIM_ATTACK);
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck
		SpiderBase_OnNpcSpawn(npc); // monsters/spider_base
		SpiderSpitting_OnNpcSpawn(npc);
	}

	// npc_targetsighted
	void OnNpcTargetsighted(string target = "")
	{
		BaseMonsterShared_OnNpcTargetsighted(target); // monsters/base_monster_shared
		SpiderSpitting_OnNpcTargetsighted(target);
	}

	void OnSpiderSpawn() { SpiderSpitting_OnSpiderSpawn(); } // spider_spawn
	void OnDebugProps() { SpiderSpitting_OnDebugProps(); } // debug_props
	void OnBite1() { SpiderSpitting_OnBite1(); } // bite1

	// This file's events and timers by their .script names
	bool SpiderSpitting_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "bite1") { OnBite1(); return true; }
		if (name == "debug_props") { OnDebugProps(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "npc_targetsighted") { OnNpcTargetsighted(Param(params, 0)); return true; }
		if (name == "spider_spawn") { OnSpiderSpawn(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "monsters/spider_spitting"]
shared class SpiderSpittingScript : SpiderBaseScript, SpiderSpitting
{
	// Variables declared by included files, with the value they start with in this script
	SpiderSpittingScript()
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
		ATTACK_DAMAGE_LOW = 4.0f;
		ATTACK_DAMAGE_HIGH = 6.0f;
		ATTACK_ACCURACY = "60%";
		SPIDER_IDLE_VOL = 3;
		SPIDER_IDLE_DELAY = 3.6f;
		SPIDER_VOLUME = 10;
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/gspider.mdl");
		CallEventDelayed(SPIDER_IDLE_DELAY, "SpiderBase_Timer");
		CallEventDelayed(Float(CYCLE_TIME), "hunting_mode_go");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		SpiderSpitting_FirstThink();
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
		return SpiderSpitting_DispatchEvent(name, params)
			|| SpiderBaseScript::DispatchEvent(name, params);
	}
}
