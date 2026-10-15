#pragma context server

// Converted from monsters/scorpion3.script by msc_transpiler.
// Thothie - no death anim
// - Hit range was smaller than width
// - added poison% - it's a pretty dynamic model, should make use of it
// Large Scorpian

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_monster.as"

[script "monsters/scorpion3"]
class Scorpion3 : BaseMonsterScript
{
	// Constants
	bool DELETE_ON_DEATH = true;

	// Variables (an unset .script variable reads as its own name)
	string SOUND_STRUCK1 = "body/flesh1.wav";
	string SOUND_STRUCK2 = "body/flesh2.wav";
	string SOUND_STRUCK3 = "body/flesh3.wav";
	string SOUND_PAIN = "monsters/spider/spiderhiss.wav";
	string SOUND_IDLE1 = "monsters/spider/spideridle.wav";
	string ANIM_POISON = "attacka";
	string ATTACK_HITCHANCE = "60%";
	string ATTACK_DAMAGE = "7";
	int FLEE_HEALTH = 0;
	string FLEE_CHANCE = "100%";
	string ANIM_ATTACK = "ANIM_ATTACK";

	// Variables declared by included files, with the value they start with in this script
	Scorpion3()
	{
		ANIM_IDLE = "idle_a";
		SOUND_DEATH = "monsters/spider/spiderdie.wav";
		ANIM_RUN = "run";
		ANIM_WALK = "walk";
	}

	// unnamed block (first think)
	void Scorpion3_FirstThink()
	{
		ANIM_IDLE = "idle_a";
		SOUND_STRUCK1 = "body/flesh1.wav";
		SOUND_STRUCK2 = "body/flesh2.wav";
		SOUND_STRUCK3 = "body/flesh3.wav";
		SOUND_PAIN = "monsters/spider/spiderhiss.wav";
		SOUND_IDLE1 = "monsters/spider/spideridle.wav";
		ANIM_IDLE = "idle_b";
		ANIM_RUN = "run";
		ANIM_WALK = "walk";
		ANIM_ATTACK = "attackb";
		ANIM_DEATH = "die";
		ANIM_POISON = "attacka";
		ATTACK_RANGE = 75.0f;
		ATTACK_HITRANGE = 100.0f;
		ATTACK_HITCHANCE = "60%";
		ATTACK_DAMAGE = "7";
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
	void Scorpion3_Timer()
	{
		CallEventDelayed(10.0f, "Scorpion3_Timer");
		SetVolume(5);
		PlayRandomSound(2, 5, SOUND_IDLE1);
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck

		SetHealth(175);
		// ov 360
		SetWidth(40);
		SetHeight(50);
		SetRace("spider");
		SetName("Huge Scorpion");
		SetRoam(true);
		SetHearingSensitivity(3);
		NPC_GIVE_EXP = 35.0f;

		SetModel("monsters/scorp3.mdl");
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

		if (RandomInt(1, 10) == 1)
		{
			PlayAnim("critical", ANIM_POISON);
			ApplyEffect(ENT_LASTSTRUCKBYME, "effects/dot_poison", 5, ENT_ME, RandomInt(5, 8));
		}
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
		Precache("monsters/scorp3.mdl");
		CallEventDelayed(10.0f, "Scorpion3_Timer");
		CallEventDelayed(Float(CYCLE_TIME), "hunting_mode_go");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		Scorpion3_FirstThink();
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
		if (name == "Scorpion3_Timer") { Scorpion3_Timer(); return true; }
		return BaseMonsterScript::DispatchEvent(name, params);
	}
}
