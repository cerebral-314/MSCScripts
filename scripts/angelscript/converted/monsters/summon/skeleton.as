#pragma context server

// Converted from monsters/summon/skeleton.script by msc_transpiler.
// Thothie Added speech feedback, HP/ATK determined magic hand side
// Summoned Skeleton

#include "runtime/ScriptEntity.as"
#include "converted/monsters/summon/base_summon.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class MonstersSummonSkeleton
{
	// Constants
	int SUMMON_CIRCLE_INDEX = 30;
	string SUM_SAY_COME = "Yes, my master.";
	string SUM_SAY_ATTACK = "It shall be more dead than I, my master.";
	string SUM_SAY_HUNT = "Seeking prey for my master...";
	string SUM_SAY_DEFEND = "I shall defend you with my unlife, my master.";
	string SUM_SAY_DEATH = "No! I have failed my master!";
	string SUM_SAY_GUARD = "I shall be as unmovable as the dead!";
	string SUM_REPORT_SUFFIX = ", my master.";
	int HOVER_FAR = 128;
	int HOVER_CLOSE = 64;
	string ANIM_WALK_BASE = "walk";
	string ANIM_RUN_BASE = "walk";
	string ATTACK_HITCHANCE = "90%";
	string SOUND_STRUCK1 = "weapons/cbar_hitbod1.wav";
	string SOUND_STRUCK2 = "weapons/cbar_hitbod2.wav";
	string SOUND_STRUCK3 = "weapons/cbar_hitbod3.wav";
	string SOUND_STRUCK4 = "zombie/zo_pain2.wav";
	string SOUND_ATTACK1 = "zombie/claw_miss1.wav";
	string SOUND_ATTACK2 = "zombie/claw_miss2.wav";
	string SOUND_DEATH = "zombie/zo_pain1.wav";

	// Variables (an unset .script variable reads as its own name)
	string ANIM_IDLE = "idle1";
	string ANIM_WALK = "walk";
	string ANIM_RUN = "walk";
	int I_R_PET = 0;
	string ANIM_DEATH = "ANIM_DEATH";
	string ANIM_ATTACK = "ANIM_ATTACK";
	string MOVE_RANGE = "MOVE_RANGE";
	float ATTACK_RANGE = 0.0f;
	float ATTACK_HITRANGE = 0.0f;
	string RETALIATE_CHANCE = "RETALIATE_CHANCE";
	string CAN_FLEE = "CAN_FLEE";
	string CAN_HUNT = "CAN_HUNT";
	string CAN_HEAR = "CAN_HEAR";
	string CAN_FLINCH = "CAN_FLINCH";
	float OWNER_SKILL = 0.0f;
	string ATK_MIN = "ATK_MIN";

	// unnamed block (first think)
	void MonstersSummonSkeleton_FirstThink()
	{
		I_R_PET = 1;

		ANIM_IDLE = "idle1";
		ANIM_DEATH = "dieheadshot";
		ANIM_WALK = "walk";
		ANIM_RUN = "walk";
		ANIM_ATTACK = "attack1";
		MOVE_RANGE = "32";
		ATTACK_RANGE = 75.0f;
		ATTACK_HITRANGE = 125.0f;

		RETALIATE_CHANCE = "75%"; // base_npc_attack - Automatically switch targets to the last damaging player
		CAN_FLEE = "0"; // base_npc_attack - Whether I run away at low health
		CAN_HUNT = "1";
		CAN_HEAR = "0";
		CAN_FLINCH = "0";
	}

	// summon_spawn
	void MonstersSummonSkeleton_OnSummonSpawn()
	{
		SetName("Skeleton");
		SetFieldOfView(359);
		SetWidth(32);
		SetHeight(72);
		SetRoam(true);
		SetHearingSensitivity(3);
		SetSkillLevel(0);
		SetRace("human");
		SetModel("monsters/skeleton.mdl");
		SetModelBody(1, 0);
		SetIdleAnim(ANIM_IDLE);
		SetMoveAnim(ANIM_WALK);

		SetBlood("none");

		SetDamageTaken("slash", 0.7f);
		SetDamageTaken("pierce", 0.5f);
		SetDamageTaken("blunt", 1.2f);
		SetDamageTaken("fire", 1.5f);
		SetDamageTaken("holy", 3);
		SetDamageTaken("cold", 0.1f);
		SetDamageTaken("poison", 0);

		CatchSpeech("skeleton_no", "play dead");
		CatchSpeech("skeleton_grave", "roll over");

		OnBasesummonAttackall(); // Premptive attack
	}

	// pre_name_set
	void MonstersSummonSkeleton_OnPreNameSet()
	{
		OWNER_SKILL = SkillOf(SUMMON_MASTER, "spellcasting");
		if (OWNER_SKILL == 8.0f)
			SetModelBody(0, 6);
		if (OWNER_SKILL == 9.0f)
		{
			SetModelBody(0, 6);
			SetModelBody(1, 1);
		}
		if (OWNER_SKILL == 10.0f)
		{
			SetModelBody(0, 1);
			SetModelBody(1, 1);
		}
		if (OWNER_SKILL == 11.0f)
		{
			SetModelBody(0, 1);
			SetModelBody(1, 4);
		}
		if (OWNER_SKILL == 12.0f)
		{
			SetModelBody(0, 1);
			SetModelBody(1, 2);
		}
		if (OWNER_SKILL == 13.0f)
		{
			SetModelBody(0, 5);
			SetModelBody(1, 0);
		}
		if (OWNER_SKILL == 14.0f)
		{
			SetModelBody(0, 5);
			SetModelBody(1, 1);
		}
		if (OWNER_SKILL == 15.0f)
		{
			SetModelBody(0, 3);
			SetModelBody(1, 4);
		}
		if (OWNER_SKILL == 16.0f)
		{
			SetModelBody(0, 3);
			SetModelBody(1, 3);
		}
		if (OWNER_SKILL == 17.0f)
		{
			SetModelBody(0, 4);
			SetModelBody(1, 1);
		}
		if (OWNER_SKILL == 18.0f)
		{
			SetModelBody(0, 4);
			SetModelBody(1, 2);
		}
		if (OWNER_SKILL == 19.0f)
		{
			SetModelBody(0, 4);
			SetModelBody(1, 4);
		}
		if (OWNER_SKILL >= 20.0f)
		{
			SetModelBody(0, 8);
			SetModelBody(1, 0);
		}
	}

	// summon_summoned
	void MonstersSummonSkeleton_OnSummonSummoned(string value = "", float lifetime = 0.0f, string minAttack = "")
	{
		float timeLive = lifetime + 20.0f;
		ATK_MIN = minAttack;

		SetHealth(lifetime);
		PlayAnim("critical", "getup");
		CallEventDelayed(0.0f, Text(timeLive));
	}

	// attack_1
	// Deal damage
	void MonstersSummonSkeleton_OnAttack12()
	{
		SetVolume(5);
		PlayRandomSound(2, 5, SOUND_ATTACK1, "none");

		DoDamage(ENT_LASTSEEN, ATTACK_HITRANGE, ATK_MIN, ATTACK_HITCHANCE);
	}

	// npc_struck
	// Hit by someone
	void MonstersSummonSkeleton_OnNpcStruck(float damage = 0.0f)
	{
		SetVolume(5);
		PlayRandomSound(2, 5, SOUND_STRUCK4, SOUND_STRUCK1, SOUND_STRUCK2, SOUND_STRUCK3);
	}

	// skeleton_no
	void MonstersSummonSkeleton_OnSkeletonNo()
	{
		// dbg MyMaster SUMMON_MASTER
		if (EntityId(EntityOf(ENT_LASTSPOKE)) != SUMMON_MASTER)
			return;

		OnNpcatkSuspendAi("3.0");
		PlayAnim("once", "throw_scientist");
		SetSayTextRange(1024);
		SayText("Not funny, master.");
	}

	// skeleton_grave
	void MonstersSummonSkeleton_OnSkeletonGrave()
	{
		// dbg MyMaster SUMMON_MASTER
		if (EntityId(EntityOf(ENT_LASTSPOKE)) != SUMMON_MASTER)
			return;

		OnNpcatkSuspendAi("1.0");
		SetMoveDest(SUMMON_MASTER, 9999);
		SetSayTextRange(1024);
		SayText("In who's grave?");
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)

	// summon_summoned
	void OnSummonSummoned(string value = "", float lifetime = 0.0f, string minAttack = "")
	{
		BaseSummon_OnSummonSummoned(value, lifetime, minAttack); // monsters/summon/base_summon
		MonstersSummonSkeleton_OnSummonSummoned(value, lifetime, minAttack);
	}

	void OnSummonSpawn() { MonstersSummonSkeleton_OnSummonSpawn(); } // summon_spawn
	void OnPreNameSet() { MonstersSummonSkeleton_OnPreNameSet(); } // pre_name_set
	void OnAttack12() { MonstersSummonSkeleton_OnAttack12(); } // attack_1
	void OnNpcStruck(float damage = 0.0f) { MonstersSummonSkeleton_OnNpcStruck(damage); } // npc_struck
	void OnSkeletonNo() { MonstersSummonSkeleton_OnSkeletonNo(); } // skeleton_no
	void OnSkeletonGrave() { MonstersSummonSkeleton_OnSkeletonGrave(); } // skeleton_grave
	void OnBasesummonAttackall() {} // basesummon_attackall

	// This file's events and timers by their .script names
	bool MonstersSummonSkeleton_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "attack_1") { OnAttack12(); return true; }
		if (name == "npc_struck") { OnNpcStruck(Float(Param(params, 0))); return true; }
		if (name == "pre_name_set") { OnPreNameSet(); return true; }
		if (name == "skeleton_grave") { OnSkeletonGrave(); return true; }
		if (name == "skeleton_no") { OnSkeletonNo(); return true; }
		if (name == "summon_spawn") { OnSummonSpawn(); return true; }
		if (name == "summon_summoned") { OnSummonSummoned(Param(params, 0), Float(Param(params, 1)), Param(params, 2)); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "monsters/summon/skeleton"]
shared class MonstersSummonSkeletonScript : BaseSummonScript, MonstersSummonSkeleton
{
	// Variables every script that includes this file declares
	string GUARD_STRUCK1 = "GUARD_STRUCK1";
	string GUARD_STRUCK2 = "GUARD_STRUCK2";
	string GUARD_STRUCK3 = "GUARD_STRUCK3";

	// Variables declared by included files, with the value they start with in this script
	MonstersSummonSkeletonScript()
	{
		SUMMON_CIRCLE_INDEX = 30;
		SUM_SAY_COME = "Yes, my master.";
		SUM_SAY_ATTACK = "It shall be more dead than I, my master.";
		SUM_SAY_HUNT = "Seeking prey for my master...";
		SUM_SAY_DEFEND = "I shall defend you with my unlife, my master.";
		SUM_SAY_DEATH = "No! I have failed my master!";
		SUM_SAY_GUARD = "I shall be as unmovable as the dead!";
		SUM_REPORT_SUFFIX = ", my master.";
		ANIM_RUN_BASE = "walk";
		ANIM_IDLE = "idle1";
		ANIM_WALK = "walk";
		ANIM_RUN = "walk";
		SOUND_STRUCK1 = "weapons/cbar_hitbod1.wav";
		SOUND_STRUCK2 = "weapons/cbar_hitbod2.wav";
		SOUND_DEATH = "zombie/zo_pain1.wav";
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("xflare1.spr");
		Precache("monsters/skeleton.mdl");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		MonstersSummonSkeleton_FirstThink();
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
		return MonstersSummonSkeleton_DispatchEvent(name, params)
			|| BaseSummonScript::DispatchEvent(name, params);
	}
}
