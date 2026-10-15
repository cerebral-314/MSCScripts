#pragma context server

// Converted from monsters/scorpion4.script by msc_transpiler.
// Thothie - no death anim
// - Hit range was smaller than width
// - added poison% - it's a pretty dynamic model, should make use of it
// Large Scorpian

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_monster.as"

[script "monsters/scorpion4"]
class Scorpion4 : BaseMonsterScript
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
	string ATTACK_DAMAGE = "14";
	int FLEE_HEALTH = 0;
	string FLEE_CHANCE = "100%";
	string ANIM_ATTACK = "ANIM_ATTACK";

	// Variables declared by included files, with the value they start with in this script
	Scorpion4()
	{
		ANIM_IDLE = "idle_a";
		SOUND_DEATH = "monsters/spider/spiderdie.wav";
		ANIM_RUN = "run";
		ANIM_WALK = "walk";
	}

	// unnamed block (first think)
	void Scorpion4_FirstThink()
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
		ATTACK_DAMAGE = "14";
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
	void Scorpion4_Timer()
	{
		CallEventDelayed(10.0f, "Scorpion4_Timer");
		SetVolume(5);
		PlayRandomSound(2, 5, SOUND_IDLE1);
	}

	// game_death
	void OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		DqMonsterExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // dq/externals/dq_monster_externals
		MonstersExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/externals
		BaseSelfAdjust_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_self_adjust
		BaseNpc_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseMonsterShared_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared
		PlayRandomSound(2, 0, SOUND_IDLE1);
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
		SetName("Huge Venomous Scorpion");
		SetRoam(true);
		SetHearingSensitivity(3);
		NPC_GIVE_EXP = 45.0f;

		SetModel("monsters/scorp3.mdl");
		SetModelBody(1, 0);
		SetIdleAnim("idle_a");
		SetMoveAnim("walk");

		SetAnimFrameRate(0.5f);
		SetAnimMoveSpeed(0.25f);
		BASE_FRAMERATE = "0.5";
		BASE_MOVESPEED = 0.25f;

		// make absolutely sure SOUND_IDLE1 is loading
		PlayRandomSound(2, SOUND_IDLE1);
	}

	// strike
	void OnStrike()
	{
		// Deal damage
		DoDamage(ENT_LASTSEEN, ATTACK_RANGE, ATTACK_DAMAGE, ATTACK_HITCHANCE);

		if (RandomInt(1, 2) == 1)
		{
			PlayAnim("critical", ANIM_POISON);
			if (RangeTo(HUNT_LASTTARGET) < ATTACK_RANGE)
				ApplyEffect(ENT_LASTSTRUCKBYME, "effects/dot_poison", 10, self, Random(2, 5));
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
		CallEventDelayed(10.0f, "Scorpion4_Timer");
		CallEventDelayed(Float(CYCLE_TIME), "hunting_mode_go");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		Scorpion4_FirstThink();
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
		if (name == "game_death") { OnGameDeath(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "npc_struck") { OnNpcStruck(Float(Param(params, 0))); return true; }
		if (name == "strike") { OnStrike(); return true; }
		if (name == "Scorpion4_Timer") { Scorpion4_Timer(); return true; }
		return BaseMonsterScript::DispatchEvent(name, params);
	}
}
