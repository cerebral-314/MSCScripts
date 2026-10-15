#pragma context server

// Converted from dq/quests/dq_kill_target.script by msc_transpiler.
// By greatguys1
// Best viewed in EditPlus with the ms.stx applied
// This quest is kill_target. When the quest is activated, it will spawn a buffed version of a monster. When the monster is killed, the quest is complete. If the quest giver dies, the quest is
// failed.
// Vars:
// const QUEST_DATA1			- <"scriptname;Custom boss name"> Which monster will become a miniboss, and what should I name it?
// const QUEST_DATA2			- <"info_target name"|"(x,y,z)"> Where do I spawn the monster? At this info target, or at a vector?
// const QUEST_DATA3			- <0|1> Should I adjust the monsters stats depending on who took the quest?
// const QUEST_MONSTER_SCRIPT		- The scriptname of the miniboss.
// const QUEST_MONSTER_NAME		- The miniboss' name.
// const QUEST_INFO_TARGET_NAME		- QUEST_DATA2
// const DQ_SELF_ADJUST			- QUEST_DATA3, used to see if the monster should adjust based on the quest taker's maxhp
// const QUEST_TARGET_HP_MULT		- Multiply QUEST_TAKER_MAXHP by this and set it to the miniboss' hp.
// const QUEST_TARGET_XP_MULT		- Multiply QUEST_TAKER_MAXHP by this and set it to the miniboss' xp.
// setvard QUEST_INFO_TARGET_ID		- The ID of the info_target, if it exists.
// setvard QUEST_MONSTER_SPAWN_POINT	- The origin at where the miniboss spawns. Not always the info_target origin.
// setvard QUEST_MONSTER_ID		- The id of the miniboss.
// Functions:
// quest_activate				- Handles the spawn point, applies externals to the miniboss, and calls dq_apply_externals
// dq_apply_externals			- Applies various effects and/or externals to the monster.
// ext_effected_monster_killed		- Called from dq/externals/dq_apply_callback_on_death when the monster it's applied to dies.

#include "runtime/ScriptEntity.as"
#include "converted/dq/quests/bases/dq_base_quests.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class DqKillTarget
{
	// Constants
	string QUEST_MONSTER_SCRIPT = "QUEST_MONSTER_SCRIPT";
	string QUEST_MONSTER_NAME = "QUEST_MONSTER_NAME";
	string QUEST_INFO_TARGET_NAME = "QUEST_INFO_TARGET_NAME";
	float DQ_SELF_ADJUST = 0.0f;
	bool DQ_MONSTER_PARAMS = false;
	int QUEST_TARGET_HP_MULT = 5;
	int QUEST_TARGET_XP_MULT = 2;

	// Variables (an unset .script variable reads as its own name)
	string QUEST_INFO_TARGET_YAW = "QUEST_INFO_TARGET_YAW";
	CBaseEntity@ QUEST_INFO_TARGET_ID = null;
	string QUEST_MONSTER_SPAWN_POINT = "QUEST_MONSTER_SPAWN_POINT";
	CBaseEntity@ QUEST_MONSTER_ID = null;

	// unnamed block (first think)
	void DqKillTarget_FirstThink()
	{
		QUEST_INFO_TARGET_YAW = Text(Vector3(0, 0, 0));
	}

	// quest_activate
	void DqKillTarget_OnQuestActivate(CBasePlayer@ menuOwner = null)
	{
		if (Exists(FindByName(QUEST_INFO_TARGET_NAME)))
		{
			@QUEST_INFO_TARGET_ID = FindByName(QUEST_INFO_TARGET_NAME);
			QUEST_MONSTER_SPAWN_POINT = Text(OriginOf(QUEST_INFO_TARGET_ID));
			QUEST_INFO_TARGET_YAW = Text(AnglesOf(QUEST_INFO_TARGET_ID).y);
		}
		else
		{
			QUEST_MONSTER_SPAWN_POINT = QUEST_INFO_TARGET_NAME;
		}

		if (DQ_MONSTER_PARAMS)
		{
			CreateNpc(QUEST_MONSTER_SCRIPT, Vec(QUEST_MONSTER_SPAWN_POINT), "addparams", DQ_MONSTER_PARAMS); // Create the monster at the correct position
		}
		else
		{
			CreateNpc(QUEST_MONSTER_SCRIPT, Vec(QUEST_MONSTER_SPAWN_POINT)); // Just in case empty add params would cause issues, though I hardly think they would.
		}

		@QUEST_MONSTER_ID = EntityOf(ENT_LASTCREATED); // Get monster id

		CallExternal(QUEST_MONSTER_ID, "ext_setangle", Vector3(0, Float(QUEST_INFO_TARGET_YAW), 0));

		CallExternal(QUEST_MONSTER_ID, "set_name", QUEST_MONSTER_NAME); // Set monster name

		CallExternal(QUEST_MONSTER_ID, "make_boss"); // Call the event to make the monster a boss

		CallExternal(QUEST_MONSTER_ID, "set_quest_miniboss", 1); // Flag the entity as a miniboss for DOT adjustments

		CallEventDelayed(1.1f, "dq_apply_externals"); // Because I *think* applying effects will only work after 1.1 seconds after the monster is created. I don't remember how I came to that conclusion
	}

	// dq_apply_externals
	// Everything event in this will only work after the monster is initialized
	void DqKillTarget_OnDqApplyExternals()
	{
		// The DOT adjustments are done via effects/base_effect. All it requires is the QUEST_MINIBOSS var set to 1, done via
		// callexternal MONSTERID set_quest_miniboss 1
		ApplyEffect(QUEST_MONSTER_ID, "dq/externals/dq_apply_callback_on_death", self);

		if (int(DQ_SELF_ADJUST) != 0)
		{
			ApplyEffect(QUEST_MONSTER_ID, "dq/externals/dq_adjust_damage");

			float questMonsterHp = QUEST_TAKER_MAXHP * QUEST_TARGET_HP_MULT; // Get the monster hp to set
			CallExternal(QUEST_MONSTER_ID, "ext_set_health", questMonsterHp, questMonsterHp); // Set the monster hp

			float questMonsterXp = QUEST_TAKER_MAXHP * QUEST_TARGET_XP_MULT; // Get the monster xp to set
			CallExternal(QUEST_MONSTER_ID, "set_xp", questMonsterXp); // Set the monster xp
		}
	}

	// ext_effected_monster_killed
	// Called from dq/externals/dq_apply_callback_on_death
	void DqKillTarget_OnExtEffectedMonsterKilled()
	{
		OnQuestFinishedCheck();
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)

	// quest_activate
	void OnQuestActivate(CBasePlayer@ menuOwner = null)
	{
		DqBaseQuests_OnQuestActivate(menuOwner); // dq/quests/bases/dq_base_quests
		DqKillTarget_OnQuestActivate(menuOwner);
	}

	void OnDqApplyExternals() { DqKillTarget_OnDqApplyExternals(); } // dq_apply_externals
	void OnExtEffectedMonsterKilled() { DqKillTarget_OnExtEffectedMonsterKilled(); } // ext_effected_monster_killed

	// This file's events and timers by their .script names
	bool DqKillTarget_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "dq_apply_externals") { OnDqApplyExternals(); return true; }
		if (name == "ext_effected_monster_killed") { OnExtEffectedMonsterKilled(); return true; }
		if (name == "quest_activate") { OnQuestActivate(PlayerParam(params, 0)); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "dq/quests/dq_kill_target"]
shared class DqKillTargetScript : DqBaseQuestsScript, DqKillTarget
{
	// Variables every script that includes this file declares
	string QUEST_ACTIVATE_CHAT = "QUEST_ACTIVATE_CHAT";
	string QUEST_ACTIVATE_SOUND = "QUEST_ACTIVATE_SOUND";
	string QUEST_COMPLETE_CHAT = "QUEST_COMPLETE_CHAT";
	string QUEST_COMPLETE_SOUND = "QUEST_COMPLETE_SOUND";
	string QUEST_DATA2 = "QUEST_DATA2";
	string QUEST_DATA3 = "QUEST_DATA3";
	bool QUEST_DATA4 = false;
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
		DqKillTarget_FirstThink();
		DqBaseQuests_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return DqKillTarget_DispatchEvent(name, params)
			|| DqBaseQuestsScript::DispatchEvent(name, params);
	}
}
