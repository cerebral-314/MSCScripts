#pragma context server

// Converted from monsters/summon/giant_rat.script by msc_transpiler.
// Thothie Rat becomes Giant Rat at SC8+

#include "runtime/ScriptEntity.as"
#include "converted/monsters/summon/base_summon.as"
#include "converted/monsters/summon/rat.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class MonstersSummonGiantRat
{
	// Constants
	int SUMMON_CIRCLE_INDEX = 12;
	string SUM_SAY_COME = "*squeek!*";
	string SUM_SAY_ATTACK = "*squeek!* *squeek!*";
	string SUM_SAY_HUNT = "*squeek...*";
	string SUM_SAY_DEFEND = "*squeekie!*";
	string SUM_SAY_DEATH = "*SQUEEK!*";
	string SUM_SAY_GUARD = "*squeek!*";
	string SUM_REPORT_SUFFIX = "..er, I mean, *squeek*!?";
	string ANIM_WALK_BASE = "walk";
	string ANIM_RUN_BASE = "run";
	string SOUND_DEATH = "monsters/rat/squeak3.wav";

	// Variables (an unset .script variable reads as its own name)
	string ANIM_IDLE = "idle1";
	string ANIM_WALK = "walk";
	string ANIM_RUN = "run";
	string ATTACK_HITCHANCE = "90%";
	string TRICK_ANIM = "attack";
	string SOUND_STRUCK1 = "weapons/cbar_hitbod1.wav";
	string SOUND_STRUCK2 = "weapons/cbar_hitbod1.wav";
	string SOUND_STRUCK3 = "weapons/cbar_hitbod1.wav";
	string SOUND_PAIN = "monsters/rat/squeak1.wav";
	string SOUND_ATTACK1 = "monsters/rat/squeak2.wav";
	string SOUND_IDLE1 = "monsters/rat/squeak2.wav";
	int I_R_PET = 0;
	string ANIM_ATTACK = "ANIM_ATTACK";
	string ANIM_DEATH = "ANIM_DEATH";
	string MOVE_RANGE = "MOVE_RANGE";
	float ATTACK_RANGE = 0.0f;
	float ATTACK_HITRANGE = 0.0f;
	string RETALIATE_CHANCE = "RETALIATE_CHANCE";
	string CAN_FLEE = "CAN_FLEE";
	string CAN_HUNT = "CAN_HUNT";
	string CAN_HEAR = "CAN_HEAR";
	string CAN_FLINCH = "CAN_FLINCH";

	// unnamed block (first think)
	void MonstersSummonGiantRat_FirstThink()
	{
		I_R_PET = 1;

		ANIM_IDLE = "idle1";
		ANIM_WALK = "walk";
		ANIM_RUN = "run";
		ANIM_ATTACK = "attack";
		ANIM_DEATH = "die";
		MOVE_RANGE = "60";
		ATTACK_RANGE = 75.0f;
		ATTACK_HITRANGE = 100.0f;
		ATTACK_HITCHANCE = "90%";
		TRICK_ANIM = "attack";

		SOUND_STRUCK1 = "weapons/cbar_hitbod1.wav";
		SOUND_STRUCK2 = "weapons/cbar_hitbod1.wav";
		SOUND_STRUCK3 = "weapons/cbar_hitbod1.wav";
		SOUND_PAIN = "monsters/rat/squeak1.wav";
		SOUND_ATTACK1 = "monsters/rat/squeak2.wav";
		SOUND_IDLE1 = "monsters/rat/squeak2.wav";

		RETALIATE_CHANCE = "75%"; // base_npc_attack - Automatically switch targets to the last damaging player
		CAN_FLEE = "0"; // base_npc_attack - Whether I run away at low health
		CAN_HUNT = "1";
		CAN_HEAR = "0";
		CAN_FLINCH = "0";
	}

	// summon_spawn
	void MonstersSummonGiantRat_OnSummonSpawn()
	{
		SetName("Giant Rat");
		SetFieldOfView(359);
		SetWidth(32);
		SetHeight(20);
		SetRoam(true);
		SetHearingSensitivity(3);
		SetSkillLevel(0);
		SetRace("human");
		SetModel("monsters/giant_rat.mdl");
		SetIdleAnim("idle1");
		SetMoveAnim("run");

		OnBasesummonAttackall(); // Premptive attack

		CatchSpeech("rat_standup", "stand", "shake", "trick");
		CatchSpeech("rat_rollover", "rollover", "roll over");
		CatchSpeech("rat_playdead", "play dead");
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)

	// summon_summoned
	void OnSummonSummoned(string value = "", float lifetime = 0.0f, string minAttack = "")
	{
		BaseSummon_OnSummonSummoned(value, lifetime, minAttack); // monsters/summon/base_summon
		MonstersSummonRat_OnSummonSummoned(value, lifetime, minAttack); // monsters/summon/rat
	}

	// summon_spawn
	void OnSummonSpawn()
	{
		MonstersSummonRat_OnSummonSpawn(); // monsters/summon/rat
		MonstersSummonGiantRat_OnSummonSpawn();
	}

	void OnNpcStruck(float damage = 0.0f) { MonstersSummonRat_OnNpcStruck(damage); } // npc_struck

	// This file's events and timers by their .script names
	bool MonstersSummonGiantRat_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "summon_spawn") { OnSummonSpawn(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "monsters/summon/giant_rat"]
shared class MonstersSummonGiantRatScript : MonstersSummonRatScript, MonstersSummonGiantRat
{
	// Variables declared by included files, with the value they start with in this script
	MonstersSummonGiantRatScript()
	{
		TRICK_ANIM = "attack";
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("xflare1.spr");
		Precache("monsters/rat.mdl");
		Precache("monsters/giant_rat.mdl");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		MonstersSummonGiantRat_FirstThink();
		BaseSummon_FirstThink();
		BaseNpc_FirstThink();
		MonstersExternals_FirstThink();
		BaseNpcAttackNew_FirstThink();
		BaseMonsterShared_FirstThink();
		MonstersSummonRat_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return MonstersSummonGiantRat_DispatchEvent(name, params)
			|| MonstersSummonRatScript::DispatchEvent(name, params);
	}
}
