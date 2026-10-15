#pragma context server

// Converted from monsters/base_react.script by msc_transpiler.
// This is semi-defunct, only for NPCs that do not have base_npc or base_npc_vendor
// Monsters that react to common events, such
// as seeing the player

#include "runtime/ScriptEntity.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class BaseReact
{
	// Constants
	string NPC_REACT_SEETARGET = "player";
	int NPC_REACT_SEETARGET_RANGE = 128;

	// Variables (an unset .script variable reads as its own name)
	bool NPC_REACTS = false;
	CBaseEntity@ NPC_REACT_LAST_TARGET = null;
	float NPC_REACT_RESET_TARGET_TIME = 0.0f;
	bool NPC_REACT_CANSEETARGET = false;

	// unnamed block (first think)
	void BaseReact_FirstThink()
	{
		NPC_REACTS = true;
	}

	// unnamed block (timer)
	void BaseReact_Timer()
	{
		CallEventDelayed(1.0f, "BaseReact_Timer");

		if (Truthy(LegacyFunction("cansee", NPC_REACT_SEETARGET, NPC_REACT_SEETARGET_RANGE)))
		{
			// don't scream at the same player repeatedly, annoying
			if (EntityOf(ENT_LASTSEEN) !is NPC_REACT_LAST_TARGET)
			{
				@NPC_REACT_LAST_TARGET = EntityOf(ENT_LASTSEEN);
				NPC_REACT_RESET_TARGET_TIME = GameTime() + 60.0f;
				if (!NPC_REACT_CANSEETARGET)
					OnNpcreactTargetsighted(NPC_REACT_LAST_TARGET);
				NPC_REACT_CANSEETARGET = true;
			}
		}
		else
		{
			if (NPC_REACT_CANSEETARGET)
				OnNpcReactSightlost();
			NPC_REACT_CANSEETARGET = false;
			if (GameTime() > NPC_REACT_RESET_TARGET_TIME)
				@NPC_REACT_LAST_TARGET = null;
		}
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)
	void OnNpcReactSightlost() {} // npc_react_sightlost
	void OnNpcreactTargetsighted(CBaseEntity@ player = null) {} // npcreact_targetsighted

	// This file's events and timers by their .script names
	bool BaseReact_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "BaseReact_Timer") { BaseReact_Timer(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "monsters/base_react"]
shared class BaseReactScript : ScriptEntity, BaseReact
{
	// Variables every script that includes this file declares
	string ANIM_STEP1 = "ANIM_STEP1";
	string ANIM_STEP10 = "ANIM_STEP10";
	string ANIM_STEP2 = "ANIM_STEP2";
	string ANIM_STEP3 = "ANIM_STEP3";
	string ANIM_STEP4 = "ANIM_STEP4";
	string ANIM_STEP5 = "ANIM_STEP5";
	string ANIM_STEP6 = "ANIM_STEP6";
	string ANIM_STEP7 = "ANIM_STEP7";
	string ANIM_STEP8 = "ANIM_STEP8";
	string ANIM_STEP9 = "ANIM_STEP9";
	float BC_END_AUTO_MOUTH_MOVE = 0.0f;
	float BC_TOTAL_MOUTH_TIME = 0.0f;
	bool BUSY_CHATTING = false;
	float CHAT_DELAY = 0.0f;
	string CHAT_DELAY_STEP1 = "CHAT_DELAY_STEP1";
	string CHAT_DELAY_STEP10 = "CHAT_DELAY_STEP10";
	string CHAT_DELAY_STEP2 = "CHAT_DELAY_STEP2";
	string CHAT_DELAY_STEP3 = "CHAT_DELAY_STEP3";
	string CHAT_DELAY_STEP4 = "CHAT_DELAY_STEP4";
	string CHAT_DELAY_STEP5 = "CHAT_DELAY_STEP5";
	string CHAT_DELAY_STEP6 = "CHAT_DELAY_STEP6";
	string CHAT_DELAY_STEP7 = "CHAT_DELAY_STEP7";
	string CHAT_DELAY_STEP8 = "CHAT_DELAY_STEP8";
	string CHAT_DELAY_STEP9 = "CHAT_DELAY_STEP9";
	string CHAT_EVENT_STEP1 = "CHAT_EVENT_STEP1";
	string CHAT_EVENT_STEP10 = "CHAT_EVENT_STEP10";
	string CHAT_EVENT_STEP2 = "CHAT_EVENT_STEP2";
	string CHAT_EVENT_STEP3 = "CHAT_EVENT_STEP3";
	string CHAT_EVENT_STEP4 = "CHAT_EVENT_STEP4";
	string CHAT_EVENT_STEP5 = "CHAT_EVENT_STEP5";
	string CHAT_EVENT_STEP6 = "CHAT_EVENT_STEP6";
	string CHAT_EVENT_STEP7 = "CHAT_EVENT_STEP7";
	string CHAT_EVENT_STEP8 = "CHAT_EVENT_STEP8";
	string CHAT_EVENT_STEP9 = "CHAT_EVENT_STEP9";
	bool CHAT_GREET = false;
	string CHAT_SOUND1 = "CHAT_SOUND1";
	string CHAT_SOUND10 = "CHAT_SOUND10";
	string CHAT_SOUND2 = "CHAT_SOUND2";
	string CHAT_SOUND3 = "CHAT_SOUND3";
	string CHAT_SOUND4 = "CHAT_SOUND4";
	string CHAT_SOUND5 = "CHAT_SOUND5";
	string CHAT_SOUND6 = "CHAT_SOUND6";
	string CHAT_SOUND7 = "CHAT_SOUND7";
	string CHAT_SOUND8 = "CHAT_SOUND8";
	string CHAT_SOUND9 = "CHAT_SOUND9";
	float CHAT_STEP = 0.0f;
	string CHAT_STEP1 = "CHAT_STEP1";
	string CHAT_STEP10 = "CHAT_STEP10";
	string CHAT_STEP2 = "CHAT_STEP2";
	string CHAT_STEP3 = "CHAT_STEP3";
	string CHAT_STEP4 = "CHAT_STEP4";
	string CHAT_STEP5 = "CHAT_STEP5";
	string CHAT_STEP6 = "CHAT_STEP6";
	string CHAT_STEP7 = "CHAT_STEP7";
	string CHAT_STEP8 = "CHAT_STEP8";
	string CHAT_STEP9 = "CHAT_STEP9";
	int CHAT_STEPS = 0;
	string CONV_ANIMS = "CONV_ANIMS";
	int ENTRY_GOLD = 0;
	bool HAS_BASE_CHAT_INCLUDE = false;
	string RQUEST_NAMES = "RQUEST_NAMES";
	int STORE_CLOSED = 0;
	bool TRADE_RING = false;

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		CallEventDelayed(1.0f, "BaseReact_Timer");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		BaseReact_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return BaseReact_DispatchEvent(name, params);
	}
}
