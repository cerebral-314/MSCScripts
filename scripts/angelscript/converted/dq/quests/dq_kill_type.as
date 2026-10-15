#pragma context server

// Converted from dq/quests/dq_kill_type.script by msc_transpiler.
// By greatguys1
// Best viewed in EditPlus with the ms.stx applied
// This quest is kill_type. The player must kill a certain amount of a monster type. If the quest giver dies, the quest fails. Once the required enemies are dead, the quest is complete.
// Vars:
// const QUEST_DATA1		- <"#;monster name|all"> How many monsters do you need to kill? Which monsters count towards the death counter?
// const DQ_KILL_NUM		- How many monsters are required to be killed?
// const DQ_KILL_WHO		- Who counts towards DQ_KILLED?
// setvard DQ_KILLED		- How many enemies were killed?
// Functions:
// quest_activate			- Adds itself to the game_masters monster death callback list.
// ext_quest_monster_killed	- Called from the game_master when a monster is killed.
// do_the_monster_killed_bit	- If the recently killed monster was who we were looking for, add it to the counter.
// game_death			- Remove ourselves from the game_master's monster death callback list if we die.

#include "runtime/ScriptEntity.as"
#include "converted/dq/quests/bases/dq_base_quests.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class DqKillType
{
	// Constants
	string DQ_KILL_WHO = "DQ_KILL_WHO";

	// Variables (an unset .script variable reads as its own name)
	float DQ_KILL_NUM = 0.0f;
	float DQ_KILLED = 0.0f;

	// unnamed block (first think)
	void DqKillType_FirstThink()
	{
		DQ_KILL_NUM = Float(GetToken(QUEST_DATA1, 0)); // setvard because higher scripts cant see lower script cosnts.

		DQ_KILLED = 0.0f;
	}

	// quest_activate
	void DqKillType_OnQuestActivate(CBasePlayer@ menuOwner = null)
	{
		CallExternal(GetVar("GAME_MASTER"), "gm_dq_add_counter", self); // This tells the game_master to add this id to the monster death callback list
	}

	// ext_quest_monster_killed
	void DqKillType_OnExtQuestMonsterKilled()
	{
		string monsterKilledName = ToLowerCase(ScriptVarOf(GetVar("GAME_MASTER"), "DQ_MONSTER_KILLED_NAME"));

		if (Contains(monsterKilledName, DQ_KILL_WHO))
			OnDoTheMonsterKilledBit();
		else if (DQ_KILL_WHO == "all")
			OnDoTheMonsterKilledBit();
	}

	// do_the_monster_killed_bit
	void DqKillType_OnDoTheMonsterKilledBit()
	{
		DQ_KILLED = DQ_KILLED + 1.0f;

		if (DQ_KILLED >= DQ_KILL_NUM)
		{
			OnQuestFinished(); // To say the text for "you're done m8"
			CallExternal(GetVar("GAME_MASTER"), "gm_dq_perish_counter", self);
		}
	}

	// game_death
	void DqKillType_OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		CallExternal(GetVar("GAME_MASTER"), "gm_dq_perish_counter", self); // If the counter was already perished, the game_master won't perish a counter it shouldn't
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)

	// quest_activate
	void OnQuestActivate(CBasePlayer@ menuOwner = null)
	{
		DqBaseQuests_OnQuestActivate(menuOwner); // dq/quests/bases/dq_base_quests
		DqKillType_OnQuestActivate(menuOwner);
	}

	// game_death
	void OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		DqBaseQuests_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // dq/quests/bases/dq_base_quests
		DqKillType_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4);
	}

	void OnExtQuestMonsterKilled() { DqKillType_OnExtQuestMonsterKilled(); } // ext_quest_monster_killed
	void OnDoTheMonsterKilledBit() { DqKillType_OnDoTheMonsterKilledBit(); } // do_the_monster_killed_bit

	// This file's events and timers by their .script names
	bool DqKillType_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "do_the_monster_killed_bit") { OnDoTheMonsterKilledBit(); return true; }
		if (name == "ext_quest_monster_killed") { OnExtQuestMonsterKilled(); return true; }
		if (name == "game_death") { OnGameDeath(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "quest_activate") { OnQuestActivate(PlayerParam(params, 0)); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "dq/quests/dq_kill_type"]
shared class DqKillTypeScript : DqBaseQuestsScript, DqKillType
{
	// Variables every script that includes this file declares
	string QUEST_ACTIVATE_CHAT = "QUEST_ACTIVATE_CHAT";
	string QUEST_ACTIVATE_SOUND = "QUEST_ACTIVATE_SOUND";
	string QUEST_COMPLETE_CHAT = "QUEST_COMPLETE_CHAT";
	string QUEST_COMPLETE_SOUND = "QUEST_COMPLETE_SOUND";
	string QUEST_FINISHED_CHAT = "QUEST_FINISHED_CHAT";
	string QUEST_FINISHED_SOUND = "QUEST_FINISHED_SOUND";
	string QUEST_INTRO_CHAT = "QUEST_INTRO_CHAT";
	string QUEST_INTRO_SOUND = "QUEST_INTRO_SOUND";
	float QUEST_PROGRESS_MAX = 0.0f;
	float QUEST_PROGRESS_VAR = 0.0f;
	bool QUEST_REWARD_TAKEN = false;
	bool QUEST_SHOW_PROGRESS = false;
	bool USING_GENERIC_REWARD = false;

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		DqKillType_FirstThink();
		DqBaseQuests_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return DqKillType_DispatchEvent(name, params)
			|| DqBaseQuestsScript::DispatchEvent(name, params);
	}
}
