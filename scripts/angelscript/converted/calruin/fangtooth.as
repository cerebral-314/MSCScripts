#pragma context server

// Converted from calruin/fangtooth.script by msc_transpiler.
// Standard Giant Rat

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_monster.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class CalruinFangtooth
{
	// Constants
	string SOUND_DEATH = "monsters/rat/squeak3.wav";

	// Variables (an unset .script variable reads as its own name)
	string ANIM_IDLE = "idle1";
	string ANIM_RUN = "run";
	string ANIM_WALK = "walk";
	string ATTACK_DAMAGE = "5";
	string ATTACK_HITCHANCE = "65%";
	string SOUND_STRUCK1 = "weapons/cbar_hitbod1.wav";
	string SOUND_STRUCK2 = "weapons/cbar_hitbod2.wav";
	string SOUND_STRUCK3 = "weapons/cbar_hitbod3.wav";
	string SOUND_PAIN = "monsters/rat/squeak1.wav";
	string SOUND_ATTACK1 = "monsters/rat/squeak2.wav";
	string SOUND_ATTACK2 = "monsters/orc/attack2.wav";
	string SOUND_ATTACK3 = "monsters/orc/attack3.wav";
	string SOUND_IDLE1 = "monsters/rat/squeak2.wav";
	int FLEE_HEALTH = 2;
	string FLEE_CHANCE = "30%";
	string ANIM_ATTACK = "ANIM_ATTACK";
	string ANIM_DEATH = "ANIM_DEATH";
	float ATTACK_RANGE = 0.0f;
	string NPC_MOVE_TARGET = "NPC_MOVE_TARGET";
	string CAN_FLEE = "CAN_FLEE";
	string DROP_ITEM1 = "DROP_ITEM1";
	string DROP_ITEM1_CHANCE = "DROP_ITEM1_CHANCE";
	float NPC_GIVE_EXP = 0.0f;
	string BASE_FRAMERATE = "BASE_FRAMERATE";
	float BASE_MOVESPEED = 0.0f;

	// unnamed block (first think)
	void CalruinFangtooth_FirstThink()
	{
		ANIM_IDLE = "idle1";
		ANIM_RUN = "run";
		ANIM_WALK = "walk";
		ANIM_ATTACK = "attack";
		ANIM_DEATH = "die";
		ATTACK_DAMAGE = "5";
		ATTACK_RANGE = 90.0f;
		ATTACK_HITCHANCE = "65%";
		SOUND_STRUCK1 = "weapons/cbar_hitbod1.wav";
		SOUND_STRUCK2 = "weapons/cbar_hitbod2.wav";
		SOUND_STRUCK3 = "weapons/cbar_hitbod3.wav";
		SOUND_PAIN = "monsters/rat/squeak1.wav";
		SOUND_ATTACK1 = "monsters/rat/squeak2.wav";
		SOUND_ATTACK2 = "monsters/orc/attack2.wav";
		SOUND_ATTACK3 = "monsters/orc/attack3.wav";
		SOUND_IDLE1 = "monsters/rat/squeak2.wav";
		NPC_MOVE_TARGET = "enemy";
		CAN_FLEE = "1"; // Used by base_npc_attack
		FLEE_HEALTH = 2; // Used by base_npc_attack
		FLEE_CHANCE = "30%"; // Used by base_npc_attack
		DROP_ITEM1 = "smallarms_fangstooth"; // Used by base_monster
		DROP_ITEM1_CHANCE = "3%"; // Used by base_monster
	}

	// npc_spawn
	void CalruinFangtooth_OnNpcSpawn(string npc = "")
	{
		SetHealth(65);
		SetWidth(32);
		SetHeight(32);
		SetName("Fang Tooth");
		SetRoam(true);
		SetHearingSensitivity(3);
		NPC_GIVE_EXP = 30.0f;
		SetRace("vermin");

		SetModel("monsters/giant_rat.mdl");
		SetModelBody(1, 0);
		SetIdleAnim(ANIM_IDLE);
		SetMoveAnim(ANIM_WALK);

		SetAnimMoveSpeed(2);
		SetAnimFrameRate(2);

		BASE_FRAMERATE = "2.0";
		BASE_MOVESPEED = 2.0f;
	}

	// bite1
	void CalruinFangtooth_OnBite1()
	{
		// Deal damage
		DoDamage(ENT_LASTSEEN, ATTACK_RANGE, Random(4.5f, 6), ATTACK_HITCHANCE);
		int random = RandomInt(1, 3);
		if (random == 1)
			ApplyEffect(ENT_LASTSTRUCKBYME, "effects/dot_poison", 5, self, RandomInt(3, 5));
	}

	// npc_struck
	// Hit by someone
	void CalruinFangtooth_OnNpcStruck(float damage = 0.0f)
	{
		PlayRandomSound(2, 5, SOUND_PAIN, SOUND_STRUCK2, SOUND_STRUCK1, SOUND_STRUCK3, SOUND_PAIN);
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck
		CalruinFangtooth_OnNpcSpawn(npc);
	}

	void OnBite1() { CalruinFangtooth_OnBite1(); } // bite1
	void OnNpcStruck(float damage = 0.0f) { CalruinFangtooth_OnNpcStruck(damage); } // npc_struck

	// This file's events and timers by their .script names
	bool CalruinFangtooth_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "bite1") { OnBite1(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "npc_struck") { OnNpcStruck(Float(Param(params, 0))); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "calruin/fangtooth"]
shared class CalruinFangtoothScript : BaseMonsterScript, CalruinFangtooth
{
	// Variables declared by included files, with the value they start with in this script
	CalruinFangtoothScript()
	{
		ANIM_IDLE = "idle1";
		ANIM_RUN = "run";
		ANIM_WALK = "walk";
		SOUND_DEATH = "monsters/rat/squeak3.wav";
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/giant_rat.mdl");
		CallEventDelayed(Float(CYCLE_TIME), "hunting_mode_go");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		BaseNpcAttack_FirstThink();
		BaseNpc_FirstThink();
		MonstersExternals_FirstThink();
		BaseMonsterShared_FirstThink();
		CalruinFangtooth_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return CalruinFangtooth_DispatchEvent(name, params)
			|| BaseMonsterScript::DispatchEvent(name, params);
	}
}
