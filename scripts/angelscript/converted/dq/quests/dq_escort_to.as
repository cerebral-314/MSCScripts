#pragma context server

// Converted from dq/quests/dq_escort_to.script by msc_transpiler.
// By greatguys1
// Best viewed in EditPlus with the ms.stx applied
// This quest is escort_to. You must guide an npc to a certain spot. The quest is complete when the npc arrives at the certain spot. The quest is failed if the npc dies.
// Vars:
// const QUEST_DATA1		- <"(x,y,z)"|"info_target name"> Either the info_target name or the vector at which you must guide the npc.
// setvard DQ_ARRIVAL_POINT	- At what point do you have to guide the npc to beat the quest?
// const DQ_CHECK_POS_INTERVAL	- How often do you wanna check the npc position in relation to DQ_ARRIVAL_POINT?
// Functions:
// quest_activate			- Sets the npc to be able to die, and calls handle_pos and check_pos.
// handle_pos			- Checks to see if an info_target is being used as DQ_ARRIVAL_POINT.
// check_pos			- Checks the npc's position in relation to DQ_ARRIVAL_POINT. If he's close enough, finish the quest, otherwise try again in DQ_CHECK_POS_INTERVAL

#include "runtime/ScriptEntity.as"
#include "converted/dq/quests/bases/dq_base_quests.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class DqEscortTo
{
	// Constants
	float DQ_CHECK_POS_INTERVAL = 2.0f;

	// Variables (an unset .script variable reads as its own name)
	string DQ_ARRIVAL_POINT = "DQ_ARRIVAL_POINT";

	// unnamed block (first think)
	void DqEscortTo_FirstThink()
	{
		DQ_ARRIVAL_POINT = QUEST_DATA1;
	}

	// quest_activate
	void DqEscortTo_OnQuestActivate(CBasePlayer@ menuOwner = null)
	{
		SetInvincible(false); // So he can die. You're welcome
		SetRace("human"); // So he can die. You're welcome
		OnHandlePos();
		OnCheckPos();
	}

	// handle_pos
	void DqEscortTo_OnHandlePos()
	{
		CBaseEntity@ infoTarget = FindByName(DQ_ARRIVAL_POINT);

		if (Exists(infoTarget))
			DQ_ARRIVAL_POINT = Text(OriginOf(infoTarget));
	}

	// check_pos
	void DqEscortTo_OnCheckPos()
	{
		if (QUEST_MODE == QUEST_ACTIVE)
		{
			if (Distance(OriginOf(ENT_ME), Vec(DQ_ARRIVAL_POINT)) <= 128.0f)
				OnQuestFinished();
			else
				CallEventDelayed(DQ_CHECK_POS_INTERVAL, "check_pos");
		}
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)

	// quest_activate
	void OnQuestActivate(CBasePlayer@ menuOwner = null)
	{
		DqBaseQuests_OnQuestActivate(menuOwner); // dq/quests/bases/dq_base_quests
		DqEscortTo_OnQuestActivate(menuOwner);
	}

	void OnHandlePos() { DqEscortTo_OnHandlePos(); } // handle_pos
	void OnCheckPos() { DqEscortTo_OnCheckPos(); } // check_pos
	void OnDqCheckPosInterval() {} // DQ_CHECK_POS_INTERVAL

	// This file's events and timers by their .script names
	bool DqEscortTo_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "check_pos") { OnCheckPos(); return true; }
		if (name == "handle_pos") { OnHandlePos(); return true; }
		if (name == "quest_activate") { OnQuestActivate(PlayerParam(params, 0)); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "dq/quests/dq_escort_to"]
shared class DqEscortToScript : DqBaseQuestsScript, DqEscortTo
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
	bool QUEST_REWARD_TAKEN = false;
	bool USING_GENERIC_REWARD = false;

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		DqEscortTo_FirstThink();
		DqBaseQuests_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return DqEscortTo_DispatchEvent(name, params)
			|| DqBaseQuestsScript::DispatchEvent(name, params);
	}
}
