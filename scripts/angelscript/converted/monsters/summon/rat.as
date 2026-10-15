#pragma context server

// Converted from monsters/summon/rat.script by msc_transpiler.
// Thothie Added speech feedback, HP/ATK determined magic hand side
// - Becomes giant rat at SC 8 (basically, same monster, diff model/name)
// Summoned Rat

#include "runtime/ScriptEntity.as"
#include "converted/monsters/summon/base_summon.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class MonstersSummonRat
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
	string TRICK_ANIM = "idle2";
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
	float RAT_HP = 0.0f;
	string ATK_MIN = "ATK_MIN";

	// unnamed block (first think)
	void MonstersSummonRat_FirstThink()
	{
		I_R_PET = 1;

		ANIM_IDLE = "idle1";
		ANIM_WALK = "walk";
		ANIM_RUN = "run";

		ANIM_ATTACK = "attack";
		ANIM_DEATH = "die";
		MOVE_RANGE = "20";
		ATTACK_RANGE = 75.0f;
		ATTACK_HITRANGE = 100.0f;
		ATTACK_HITCHANCE = "90%";
		TRICK_ANIM = "idle2";

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
	void MonstersSummonRat_OnSummonSpawn()
	{
		SetName("Rat");
		SetFieldOfView(359);
		SetWidth(32);
		SetHeight(20);
		SetRoam(true);
		SetHearingSensitivity(3);
		SetSkillLevel(0);
		SetRace("human");
		SetModel("monsters/rat.mdl");
		SetModelBody(1, 0);
		SetIdleAnim(ANIM_IDLE);
		SetMoveAnim(ANIM_WALK);

		OnBasesummonAttackall(); // Premptive attack

		CatchSpeech("rat_standup", "stand", "shake", "trick");
		CatchSpeech("rat_rollover", "rollover", "roll over");
		CatchSpeech("rat_playdead", "play dead");
	}

	// summon_summoned
	void MonstersSummonRat_OnSummonSummoned(string value = "", float lifetime = 0.0f, string minAttack = "")
	{
		float timeLive = lifetime + 20.0f;
		ATK_MIN = minAttack;

		RAT_HP = Divide(lifetime, 2.0f);

		SetHealth(RAT_HP);

		CallEventDelayed(0.0f, Text(timeLive));
	}

	// bite1
	// Deal damage
	void MonstersSummonRat_OnBite1()
	{
		SetVolume(5);
		PlayRandomSound(2, SOUND_ATTACK1, "none");

		DoDamageEx(ENT_LASTSEEN, ATTACK_HITRANGE, ATK_MIN, ATTACK_HITCHANCE, ENT_ME, ENT_ME, "none", "pierce", "dmgevent:bite");
	}

	// npc_struck
	// Hit by someone
	void MonstersSummonRat_OnNpcStruck(float damage = 0.0f)
	{
		SetVolume(5);
		PlayRandomSound(2, SOUND_PAIN, SOUND_PAIN, SOUND_STRUCK1, SOUND_STRUCK2, SOUND_STRUCK3);
	}

	// rat_standup
	// Do a trick
	void MonstersSummonRat_OnRatStandup()
	{
		// dbg MyMaster SUMMON_MASTER
		if (EntityId(EntityOf(ENT_LASTSPOKE)) != SUMMON_MASTER)
			return;
		OnNpcatkSuspendAi("3.0");
		SetSayTextRange(1024);
		SayText("*squeek!* :D");
		PlaySound(2, 10, SOUND_IDLE1);
		SetAngle("face", ENT_LASTSPOKE);
		PlayAnim("hold", TRICK_ANIM);
	}

	// rat_rollover
	void MonstersSummonRat_OnRatRollover()
	{
		// dbg MyMaster SUMMON_MASTER
		if (EntityId(EntityOf(ENT_LASTSPOKE)) != SUMMON_MASTER)
			return;

		OnNpcatkSuspendAi("3.0");

		SetSayTextRange(1024);
		SayText("*squeek?*");
		SetAngle("face", ENT_LASTSPOKE);
		PlaySound(2, 10, SOUND_IDLE1);
		PlayAnim("once", TRICK_ANIM);
	}

	// rat_playdead
	void MonstersSummonRat_OnRatPlaydead()
	{
		// dbg MyMaster SUMMON_MASTER
		if (EntityId(EntityOf(ENT_LASTSPOKE)) != SUMMON_MASTER)
			return;

		OnNpcatkSuspendAi();

		SetSayTextRange(1024);
		SayText("*SQUEEK!*");
		PlaySound(2, 10, SOUND_DEATH);
		SetAngle("face", ENT_LASTSPOKE);
		PlayAnim("hold", ANIM_DEATH);
		CallEventDelayed(3.0f, "stop_playing_dead");
	}

	// stop_playing_dead
	void MonstersSummonRat_OnStopPlayingDead()
	{
		OnNpcatkResumeAi();
		PlayAnim("once", "run");
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)

	// summon_summoned
	void OnSummonSummoned(string value = "", float lifetime = 0.0f, string minAttack = "")
	{
		BaseSummon_OnSummonSummoned(value, lifetime, minAttack); // monsters/summon/base_summon
		MonstersSummonRat_OnSummonSummoned(value, lifetime, minAttack);
	}

	void OnSummonSpawn() { MonstersSummonRat_OnSummonSpawn(); } // summon_spawn
	void OnBite1() { MonstersSummonRat_OnBite1(); } // bite1
	void OnNpcStruck(float damage = 0.0f) { MonstersSummonRat_OnNpcStruck(damage); } // npc_struck
	void OnRatStandup() { MonstersSummonRat_OnRatStandup(); } // rat_standup
	void OnRatRollover() { MonstersSummonRat_OnRatRollover(); } // rat_rollover
	void OnRatPlaydead() { MonstersSummonRat_OnRatPlaydead(); } // rat_playdead
	void OnStopPlayingDead() { MonstersSummonRat_OnStopPlayingDead(); } // stop_playing_dead
	void OnBasesummonAttackall() {} // basesummon_attackall

	// This file's events and timers by their .script names
	bool MonstersSummonRat_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "bite1") { OnBite1(); return true; }
		if (name == "npc_struck") { OnNpcStruck(Float(Param(params, 0))); return true; }
		if (name == "rat_playdead") { OnRatPlaydead(); return true; }
		if (name == "rat_rollover") { OnRatRollover(); return true; }
		if (name == "rat_standup") { OnRatStandup(); return true; }
		if (name == "stop_playing_dead") { OnStopPlayingDead(); return true; }
		if (name == "summon_spawn") { OnSummonSpawn(); return true; }
		if (name == "summon_summoned") { OnSummonSummoned(Param(params, 0), Float(Param(params, 1)), Param(params, 2)); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "monsters/summon/rat"]
shared class MonstersSummonRatScript : BaseSummonScript, MonstersSummonRat
{
	// Variables declared by included files, with the value they start with in this script
	MonstersSummonRatScript()
	{
		SUMMON_CIRCLE_INDEX = 12;
		SUM_SAY_COME = "*squeek!*";
		SUM_SAY_ATTACK = "*squeek!* *squeek!*";
		SUM_SAY_HUNT = "*squeek...*";
		SUM_SAY_DEFEND = "*squeekie!*";
		SUM_SAY_DEATH = "*SQUEEK!*";
		SUM_SAY_GUARD = "*squeek!*";
		SUM_REPORT_SUFFIX = "..er, I mean, *squeek*!?";
		ANIM_IDLE = "idle1";
		ANIM_WALK = "walk";
		ANIM_RUN = "run";
		SOUND_STRUCK1 = "weapons/cbar_hitbod1.wav";
		SOUND_STRUCK2 = "weapons/cbar_hitbod1.wav";
		SOUND_DEATH = "monsters/rat/squeak3.wav";
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("xflare1.spr");
		Precache("monsters/rat.mdl");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		MonstersSummonRat_FirstThink();
		BaseSummon_FirstThink();
		BaseNpc_FirstThink();
		MonstersExternals_FirstThink();
		BaseNpcAttackNew_FirstThink();
		BaseMonsterShared_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return MonstersSummonRat_DispatchEvent(name, params)
			|| BaseSummonScript::DispatchEvent(name, params);
	}
}
