#pragma context server

// Converted from monsters/scorpion2.script by msc_transpiler.
// Thothie - had no death anim
// Mid-sized Scorpian

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_monster.as"

[script "monsters/scorpion2"]
class Scorpion2 : BaseMonsterScript
{
	// Constants
	bool DELETE_ON_DEATH = true;

	// Variables (an unset .script variable reads as its own name)
	string SOUND_STRUCK1 = "body/flesh1.wav";
	string SOUND_STRUCK2 = "body/flesh2.wav";
	string SOUND_STRUCK3 = "body/flesh3.wav";
	string SOUND_PAIN = "monsters/spider/spiderhiss.wav";
	string SOUND_IDLE1 = "monsters/spider/spideridle.wav";
	string ATTACK_HITCHANCE = "60%";
	string ATTACK_DAMAGE = "5";
	int FLEE_HEALTH = 0;
	string FLEE_CHANCE = "100%";
	string ANIM_ATTACK = "ANIM_ATTACK";

	// Variables declared by included files, with the value they start with in this script
	Scorpion2()
	{
		ANIM_IDLE = "idle_b";
		SOUND_DEATH = "monsters/spider/spiderdie.wav";
		ANIM_RUN = "run";
		ANIM_WALK = "walk";
	}

	// unnamed block (first think)
	void Scorpion2_FirstThink()
	{
		ANIM_IDLE = "idle_b";
		SOUND_STRUCK1 = "body/flesh1.wav";
		SOUND_STRUCK2 = "body/flesh2.wav";
		SOUND_STRUCK3 = "body/flesh3.wav";
		SOUND_PAIN = "monsters/spider/spiderhiss.wav";
		SOUND_IDLE1 = "monsters/spider/spideridle.wav";
		ANIM_RUN = "run";
		ANIM_WALK = "walk";
		ANIM_ATTACK = "attackb";
		ANIM_DEATH = "die";
		ATTACK_RANGE = 75.0f;
		ATTACK_HITRANGE = 100.0f;
		ATTACK_HITCHANCE = "60%";
		ATTACK_DAMAGE = "5";
		CAN_FLEE = "0"; // Used by base_monster
		FLEE_HEALTH = 0; // Used by base_monster
		FLEE_CHANCE = "100%"; // Used by base_monster
		CAN_HUNT = "1";
		HUNT_AGRO = "1";
		NPC_MOVE_TARGET = "enemy";

		// Precache
		// the play command for it isn't in this file (it's
		// in base_monster.script)
		// something is generating SOUND_IDLE1 not precached error in daragoth
		// General Precache
		PrecacheFile("monsters/base_monster");
		PrecacheFile("monsters/base_npc_attack");
		PrecacheFile("monsters/base_npc");
	}

	// unnamed block (timer)
	// Idling
	void Scorpion2_Timer()
	{
		CallEventDelayed(10.0f, "Scorpion2_Timer");
		SetVolume(5);
		PlayRandomSound(2, 5, SOUND_IDLE1);
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck

		SetHealth(75);
		// ov 360
		SetWidth(40);
		SetHeight(40);
		SetRace("spider");
		SetName("Large Scorpion");
		SetRoam(true);
		SetHearingSensitivity(3);
		NPC_GIVE_EXP = 15.0f;

		SetDamageTaken("all", 0.8f);

		SetModel("monsters/scorp2.mdl");
		SetModelBody(1, 0);
		SetIdleAnim("idle_a");
		SetMoveAnim("walk");

		// make absolutely sure SOUND_IDLE1 is loading
		PlayRandomSound(2, SOUND_IDLE1);
	}

	// strike
	void OnStrike()
	{
		// Deal damage
		DoDamage(ENT_LASTSEEN, ATTACK_RANGE, ATTACK_DAMAGE, ATTACK_HITCHANCE);
	}

	// npc_struck
	// Hit by someone
	void OnNpcStruck(float damage = 0.0f)
	{
		SetVolume(5);
		PlayRandomSound(2, 5, SOUND_PAIN, SOUND_STRUCK2, SOUND_STRUCK1);
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/scorp2.mdl");
		CallEventDelayed(10.0f, "Scorpion2_Timer");
		CallEventDelayed(Float(CYCLE_TIME), "hunting_mode_go");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		Scorpion2_FirstThink();
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
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "npc_struck") { OnNpcStruck(Float(Param(params, 0))); return true; }
		if (name == "strike") { OnStrike(); return true; }
		if (name == "Scorpion2_Timer") { Scorpion2_Timer(); return true; }
		return BaseMonsterScript::DispatchEvent(name, params);
	}
}
