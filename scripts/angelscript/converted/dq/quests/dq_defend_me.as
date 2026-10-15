#pragma context server

// Converted from dq/quests/dq_defend_me.script by msc_transpiler.
// By greatguys1
// Best viewed in EditPlus with the ms.stx applied
// This quest is defend_me. This quest, when activated, spawns a series of enemies around an npc. The npc must live throughout the horde of enemies. The npc becomes a critical npc,
// and will be targeted by monsters. If he lives though a certain amount of enemies, the quest is completed. If he dies, the quest is lost.
// Vars:
// const QUEST_DATA1			- <"scriptname;scriptname"> The scriptnames of all the monsters you want sieging the npc are all put here.
// const QUEST_DATA2			- <"#;0|1"> How many enemies must be slain before the siege stops, and should I adjust the monsters stats depending on who took the quest?
// const QUEST_DATA3			- <"random"|"info_target prefix"|"(x,y,z);(x,y,z)"> Where do the enemies spawn?
// const DQ_DEFEND_ME_DEFENSE_POINT	- The point enemies spawn around if spawning is random.
// const DQ_MONSTER_LIST			- The token of monster scriptnames from the template.
// const DQ_MONSTER_LIMIT			- Monsters required to be killed to finish the quest.
// const DQ_SELF_ADJUST			- Force the monsters to adjust their health and xp according to whoever took the quest.
// const DQ_SPAWN_POINTS			- Contains the info_target prefix or vectors or "random" for the spawn points
// const DQ_MOSNTER_HP_MULT		- Multiply this by QUEST_TAKER_MAXHP and set the result to the health of the spawned enemies.
// const DQ_MONSTER_XP_MULT		- Multiply this by QUEST_TAKER_MAXHP and set the result to the xp of the spawned enemies.
// const DQ_MONSTER_SPAWN_TIME		- Time it takes for another monster to be allowed to spawn.
// setvard DQ_MONSTERS_AVAILABLE		- How many monsters are you allowed to spawn right now?
// setvard DQ_MONSTERS_KILLED		- How many monsters killed.
// array MONSTER_SPAWN_ORIGINS		- Contains the coordinates of several points monsters are allowed to spawn at if the spawning isn't random.
// setvard MONSTER_ORIGIN_AMT		- How many different points are there to spawn monsters at?
// setvard EFFECT_ME			- Current enemy targeted to apply various effects or externals on.
// setvard CAN_POPULATE_AGAIN		- Checks if CAN_POPULATE_AGAIN <= game.time assuming CAN_POPULATE_AGAIN is game.time + DQ_MOSNTER_SPAWN_TIME
// Functions:
// quest_activate				- Starts spawning the monsters, changes the race to "human", invinvible to 0, and if spawning isn't random, callevent to check origins or info_targets
// quest_begin_handle_origins		- Decides whether vectors or info_targets are being used as spawn points.
// quest_handle_info_targets		- Adds the info_target vectors into the MONSTER_SPAWN_ORIGINS array.
// quest_handle_vectors			- Adds the vectors directly from QUEST_DATA3 into the MONSTER_SPAWN_ORIGINS array.
// populate_area				- Selects and spawns the enemies onto either the pre-defined spawn points or in a random area around DQ_DEFEND_ME_DEFENSE_POINT. Also calls dq_apply_externals and as_tele_stuck_check to the monsters.
// dq_apply_externals			- Applies various effects and/or externals onto the monster.
// ext_effected_monster_killed		- Called from the effect dq/externals/dq_apply_callback_on_death

#include "runtime/ScriptEntity.as"
#include "converted/dq/quests/bases/dq_base_quests.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class DqDefendMe
{
	// Constants
	Vector3 DQ_DEFEND_ME_DEFENSE_POINT = Vector3();
	string DQ_MONSTER_LIST = "DQ_MONSTER_LIST";
	float DQ_MONSTER_LIMIT = 0.0f;
	float DQ_SELF_ADJUST = 0.0f;
	string DQ_SPAWN_POINTS = "DQ_SPAWN_POINTS";
	float DQ_MONSTER_HP_MULT = 0.5f;
	float DQ_MONSTER_XP_MULT = 0.5f;
	float DQ_MONSTER_SPAWN_TIME = 2.0f;

	// Variables (an unset .script variable reads as its own name)
	float DQ_MONSTERS_AVAILABLE = 0.0f;
	float DQ_MONSTERS_KILLED = 0.0f;
	float MONSTER_ORIGIN_AMT = 0.0f;
	CBaseEntity@ EFFECT_ME = null;
	float CAN_POPULATE_AGAIN = 0.0f;

	// unnamed block (first think)
	void DqDefendMe_FirstThink()
	{
		DQ_MONSTERS_AVAILABLE = 5.0f;
		DQ_MONSTERS_KILLED = 0.0f;
	}

	// quest_activate
	void DqDefendMe_OnQuestActivate(CBasePlayer@ menuOwner = null)
	{
		CallEventDelayed(DQ_MONSTER_SPAWN_TIME, "populate_area"); // To get it started. Spawn time is so the origin handler thingy has time to work at first.
		SetInvincible(false); // So the npc is allowed to die. You're welcome
		SetRace("human");

		if (DQ_SPAWN_POINTS != "random")
		{
			OnQuestBeginHandleOrigins(); // Ripped from fetch_items which is (mostly) ripped from Thothie's fire wyrm pit getter. Inception.jpeg
		}
	}

	// quest_begin_handle_origins
	// Most of the function is influenced from Thothie's fire wyrm pit getter. Thenks bruh
	void DqDefendMe_OnQuestBeginHandleOrigins()
	{
		int count;

		ArrayCreate("MONSTER_SPAWN_ORIGINS");

		string infoTargetName = DQ_SPAWN_POINTS + "1"; // This is just a tester to see if it should look for info targets or just take vectors

		CBaseEntity@ infoTargetId = FindByName(infoTargetName);

		if (Exists(infoTargetId))
		{
			OnQuestHandleInfoTargets(); // This cant be on a loop because we don't know exactly how much info_targets they are until we find one that doesn't exist
		}
		else if (StartsWith(DQ_SPAWN_POINTS, "(")) // If it starts with that it has to be vectors
		{
			MONSTER_ORIGIN_AMT = GetTokenCount(DQ_SPAWN_POINTS);
			count = int(MONSTER_ORIGIN_AMT); // I can call this on a loop because I can see how many tokens are in DQ_SPAWN_POINTS
			for (int i = 0; i < count; i++)
			{
				loopIteration = i;
				OnQuestHandleVectors();
			}
		}
		else
		{
			DebugPrint("No proper origins were found, defend_me cannot spawn enemies!");
		}
	}

	// quest_handle_info_targets
	// For organization
	void DqDefendMe_OnQuestHandleInfoTargets()
	{
		string infoTargetName = DQ_SPAWN_POINTS;
		float monsterOriginAmt = MONSTER_ORIGIN_AMT;
		monsterOriginAmt = int(monsterOriginAmt + 1.0f); // $math tends to add .00 at the end. It'll try to look for .00 in the info target if I don't do $int
		infoTargetName += Text(monsterOriginAmt);

		CBaseEntity@ infoTargetId = FindByName(infoTargetName);

		if (Exists(infoTargetId))
		{
			ArrayAdd("MONSTER_SPAWN_ORIGINS", OriginOf(infoTargetId));
			MONSTER_ORIGIN_AMT = MONSTER_ORIGIN_AMT + 1.0f;

			CallEventDelayed(0.1f, "quest_handle_info_targets");
		}
	}

	// quest_handle_vectors
	// For organization
	void DqDefendMe_OnQuestHandleVectors()
	{
		ArrayAdd("MONSTER_SPAWN_ORIGINS", GetToken(DQ_SPAWN_POINTS, loopIteration));
	}

	// populate_area
	// This starts spawning the monsters around the npc
	void DqDefendMe_OnPopulateArea()
	{
		Vector3 pos = Vec("L_POS");

		if (QUEST_MODE == "active")
		{
			if (DQ_MONSTERS_AVAILABLE > 0.0f)
			{
				if (DQ_SPAWN_POINTS == "random")
				{
					float rDist = Random(128, 256); // Thanks Thothie for the vecrors
					float rYaw = Random(0, 359.99f);

					pos = DQ_DEFEND_ME_DEFENSE_POINT + RelativePosition(Vector3(0, rYaw, 0), Vector3(0, rDist, 0));
				}
				else
				{
					int idx = RandomInt(0, int(GetArrayCount("MONSTER_SPAWN_ORIGINS") - 1.0f)); // Starts indexing at 0, so we'd have an extra index if we didn't subtract 1
					pos = Vec(GetArray("MONSTER_SPAWN_ORIGINS", Text(idx)));
				}

				int rScript = RandomInt(0, int(GetTokenCount(DQ_MONSTER_LIST) - 1.0f)); // Starts indexing at 0, so we'd have an extra index if we didn't subtract 1

				CreateNpc(GetToken(DQ_MONSTER_LIST, rScript), pos);
				@EFFECT_ME = EntityOf(ENT_LASTCREATED);

				if (DQ_SPAWN_POINTS == "random") // Random should have the only chance of ever spawning an npc in a wall
					CallExternal(EFFECT_ME, "as_tele_stuck_check");
				CallEventDelayed(1.1f, "dq_apply_externals"); // Monsters should never not get the effect as long as the spawn time is greater than 1.1 seconds

				// I really dont like this.
				DQ_MONSTERS_AVAILABLE = DQ_MONSTERS_AVAILABLE - 1.0f;
			}
			if (CAN_POPULATE_AGAIN <= GameTime())
			{
				CAN_POPULATE_AGAIN = GameTime() + DQ_MONSTER_SPAWN_TIME;
				CallEventDelayed(DQ_MONSTER_SPAWN_TIME, "populate_area");
			}
		}
	}

	// dq_apply_externals
	// Because I *think* applying effects will only work after 1.1 seconds after the monster is created. I don't remember how I came to that conclusion
	void DqDefendMe_OnDqApplyExternals()
	{
		CallExternal(EFFECT_ME, "set_quest_miniboss", 1); // For the DOT adjustments

		// The DOT adjustments are done via effects/base_effect. All it requires is the QUEST_MINIBOSS var set to 1, done via
		// callexternal MONSTERID set_quest_miniboss 1
		ApplyEffect(EFFECT_ME, "dq/externals/dq_apply_callback_on_death", self);

		if (int(DQ_SELF_ADJUST) != 0)
		{
			ApplyEffect(EFFECT_ME, "dq/externals/dq_adjust_damage", self);

			CallExternal(EFFECT_ME, "set_xp", QUEST_TAKER_MAXHP * DQ_MONSTER_XP_MULT);

			float health = QUEST_TAKER_MAXHP * DQ_MONSTER_HP_MULT;
			CallExternal(EFFECT_ME, "ext_set_health", health, health);
		}
	}

	// ext_effected_monster_killed
	// Called from dq/externals/dq_apply_callback_on_death
	void DqDefendMe_OnExtEffectedMonsterKilled()
	{
		DQ_MONSTERS_KILLED = DQ_MONSTERS_KILLED + 1.0f;
		DQ_MONSTERS_AVAILABLE = DQ_MONSTERS_AVAILABLE + 1.0f;

		if (DQ_MONSTERS_KILLED >= DQ_MONSTER_LIMIT)
		{
			OnQuestFinishedCheck();
		}
		else if (CAN_POPULATE_AGAIN < GameTime())
		{
			CAN_POPULATE_AGAIN = GameTime() + DQ_MONSTER_SPAWN_TIME;
			CallEventDelayed(DQ_MONSTER_SPAWN_TIME, "populate_area");
		}
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)

	// quest_activate
	void OnQuestActivate(CBasePlayer@ menuOwner = null)
	{
		DqBaseQuests_OnQuestActivate(menuOwner); // dq/quests/bases/dq_base_quests
		DqDefendMe_OnQuestActivate(menuOwner);
	}

	void OnQuestBeginHandleOrigins() { DqDefendMe_OnQuestBeginHandleOrigins(); } // quest_begin_handle_origins
	void OnQuestHandleInfoTargets() { DqDefendMe_OnQuestHandleInfoTargets(); } // quest_handle_info_targets
	void OnQuestHandleVectors() { DqDefendMe_OnQuestHandleVectors(); } // quest_handle_vectors
	void OnPopulateArea() { DqDefendMe_OnPopulateArea(); } // populate_area
	void OnDqApplyExternals() { DqDefendMe_OnDqApplyExternals(); } // dq_apply_externals
	void OnExtEffectedMonsterKilled() { DqDefendMe_OnExtEffectedMonsterKilled(); } // ext_effected_monster_killed
	void OnDqMonsterSpawnTime() {} // DQ_MONSTER_SPAWN_TIME

	// This file's events and timers by their .script names
	bool DqDefendMe_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "dq_apply_externals") { OnDqApplyExternals(); return true; }
		if (name == "ext_effected_monster_killed") { OnExtEffectedMonsterKilled(); return true; }
		if (name == "populate_area") { OnPopulateArea(); return true; }
		if (name == "quest_activate") { OnQuestActivate(PlayerParam(params, 0)); return true; }
		if (name == "quest_begin_handle_origins") { OnQuestBeginHandleOrigins(); return true; }
		if (name == "quest_handle_info_targets") { OnQuestHandleInfoTargets(); return true; }
		if (name == "quest_handle_vectors") { OnQuestHandleVectors(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "dq/quests/dq_defend_me"]
shared class DqDefendMeScript : DqBaseQuestsScript, DqDefendMe
{
	// Variables every script that includes this file declares
	string QUEST_ACTIVATE_CHAT = "QUEST_ACTIVATE_CHAT";
	string QUEST_ACTIVATE_SOUND = "QUEST_ACTIVATE_SOUND";
	string QUEST_COMPLETE_CHAT = "QUEST_COMPLETE_CHAT";
	string QUEST_COMPLETE_SOUND = "QUEST_COMPLETE_SOUND";
	string QUEST_DATA2 = "QUEST_DATA2";
	string QUEST_DATA3 = "QUEST_DATA3";
	string QUEST_FINISHED_CHAT = "QUEST_FINISHED_CHAT";
	string QUEST_FINISHED_SOUND = "QUEST_FINISHED_SOUND";
	string QUEST_INTRO_CHAT = "QUEST_INTRO_CHAT";
	string QUEST_INTRO_SOUND = "QUEST_INTRO_SOUND";
	bool QUEST_REWARD_TAKEN = false;
	bool USING_GENERIC_REWARD = false;

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		DqDefendMe_FirstThink();
		DqBaseQuests_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return DqDefendMe_DispatchEvent(name, params)
			|| DqBaseQuestsScript::DispatchEvent(name, params);
	}
}
