#pragma context server

// Converted from dq/templates/dq_fetch_drop_template.script by msc_transpiler.
// By greatguys1
// Best viewed in EditPlus with the ms.stx applied
// Races: (If the npc must survive, he will become human once the quest is activated, and go back to your defined race once the quest is complete.)
// beloved	//Nothing will attack this race
// human //Will be targetable by hostile enemies, but cannot be damaged by friendies or players
// Qitem codes: (The ap, bs, bp, ect. are the codes. The things in the quotes are the default names to them. They are renameable in quests that use these)	Ripped from other/qitems
// ap - "Golden Apple"
// bs - "Bag of Salt"
// bp - "Bag of Pepper"
// km - "Barrel of Mead"
// la - "Sylphiel's Ladel"
// tnt - "a stick of|Dwarven Explosives"
// gen1 - "Package of Something" //(these use the generic item package model)
// gen2 - "Package of Something"
// gen3 - "Package of Something"
// ========================================================================vv Template editors, start here! vv========================================================================//
// A few things before you start. Anything after two slashes "//" makes the whole line a "comment." A comment is not executed by the game at all. It's for people like you and me to read
// so things don't get confusing. Anything contained in <> means that the options you have for certain settings are enclosed in that. You do not put the <> when filling out the template.
// Each option will have their own explanation. 1 or true always means on or active. 0 or false always means off or disabled. For those of you with the script archive, COPY THIS SOMEWHERE ELSE
// THEN START EDITING!
// Examples:
// Options:
// <1/2/3> Means you may only put either 1, 2, OR 3.
// <1|2|3> Means the same thing as ^
// <"">	Means you have to enclose your option in quotes.
// <''>	Same but with single quotes. It actually really shouldn't matter, if you don't know which one to use, or if you think it might cause issues, use single quotes.
// This quest is fetch_drop. You must pick up qitems dropped from specific npcs on their death.

#include "runtime/ScriptEntity.as"
#include "converted/dq/quests/dq_fetch_drop.as"
#include "converted/dq/templates/bases/dq_generic_reward.as"
#include "converted/dq/templates/bases/dq_generic_menus.as"
#include "converted/dq/templates/bases/dq_generic_chat.as"
#include "converted/dq/quest_dwarf.as"

[script "dq/templates/dq_fetch_drop_template"]
class DqFetchDropTemplate : QuestDwarfScript, DqFetchDrop, DqBaseQuests, DqGenericReward, DqGenericMenus, DqGenericChat
{
	// Constants
	string QUEST_DATA2 = "km;Barrel of Booze";
	bool QUEST_SHOW_PROGRESS = true;
	float QUEST_PROGRESS_VAR = 0.0f;
	float QUEST_PROGRESS_MAX = 0.0f;
	string QUEST_INTRO_CHAT = "DamnN spiderz getting- *hic* drunk on me booze aghain...";
	string QUEST_INTRO_SOUND = "0";
	string QUEST_ACTIVATE_CHAT = "Eh? I'll be heere... zzz";
	string QUEST_ACTIVATE_SOUND = "0";
	string QUEST_FINISHED_CHAT = "MY BOOZE!";
	string QUEST_FINISHED_SOUND = "0";
	string QUEST_COMPLETE_CHAT = "Here, you can have me beard... Wait...";
	string QUEST_COMPLETE_SOUND = "0";

	// Variables declared by included files, with the value they start with in this script
	DqFetchDropTemplate()
	{
		QUEST_TYPE = "fetch_drop";
		QUEST_DATA1 = "4;spider";
		QUEST_REWARD_TYPE = "gm";
		QUEST_REWARD_EVENT = "old_helena_warboss_died";
		QUEST_COMPLETE_TEXT = "(Collect Reward)";
		QUEST_WAITING_TEXT = "Hello?";
		QUEST_ASKING_TEXT = "You uh... Want it back?";
		QUEST_ACTIVE_TEXT = "(In Progress)";
		QUEST_FADE_ON_COMPLETE = "fade";
		QUEST_GIVER_NAME = "Drunk Dwarf";
		NEW_RACE = "beloved";
		NEW_WIDTH = 32;
		NEW_HEIGHT = 32;
		MONSTER_MODEL = "0";
		SUBMODEL_GROUPS = "0;0";
		USE_SKIN = "4";
		USE_LANTERN = true;
		INIT_IDLE_MODE = "sitting";
		QUEST_WAITING = "waiting"; // from dq/quests/bases/dq_base_quests
		QUEST_ASKING = "asking"; // from dq/quests/bases/dq_base_quests
		QUEST_ACTIVE = "active"; // from dq/quests/bases/dq_base_quests
		QUEST_COMPLETE = "complete"; // from dq/quests/bases/dq_base_quests
		QUEST_FAILED = "failed"; // from dq/quests/bases/dq_base_quests
	}

	// unnamed block (first think)
	void DqFetchDropTemplate_FirstThink()
	{
		// <"(R,G,B)"> The color of the lantern using red green and blue. Defaults to (128,64,0)
		// Ex: const LANTERN_COLOR "(128,64,0)"
		INIT_IDLE_MODE = "sitting";
	}

	// ext_receive_quest_item
	// Don't touch this
	void OnExtReceiveQuestItem(string itemCode = "")
	{
		DqFetchDrop_OnExtReceiveQuestItem(itemCode); // dq/quests/dq_fetch_drop

		CallEventDelayed(0.1f, "do_chat_ext_recieve_quest_item");
	}

	// do_chat_ext_recieve_quest_item
	// If you want a different npc to be handing out the quest, replace the dq/quest_dwarf with the directory of the preferred npc. Keep in mind though that some of the options up above
	// might not work as a result!
	void OnDoChatExtRecieveQuestItem()
	{
		if (QUEST_MODE == "active" && !CHAT_BUSY)
		{
			OnChatNow("For me? Yoo shouldn't have- *hic*", "1.0");

			// <"NPC recieved item text"> The npc speaks what the input is. This specific part is what the npc says after you turn in a quest item. You may add more callevent
			// chat_now lines if you want the npc to say more that just one line of dialogue.
			// Ex: callevent chat_now "Thank you. Send over your friends if they have anything for me." 1.0
			PlaySound(2, 10, "none");
		}
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		DqBaseQuests_OnGameSpawn(playerRace, playerGender); // dq/quests/bases/dq_base_quests
		BaseNpc_OnGameSpawn(playerRace, playerGender); // monsters/base_npc
		BaseMonsterShared_OnGameSpawn(playerRace, playerGender); // monsters/base_monster_shared
		BaseChatArray_OnGameSpawn(playerRace, playerGender); // monsters/base_chat_array
		BaseStruck_OnGameSpawn(playerRace, playerGender); // monsters/base_struck
		QuestDwarf_OnGameSpawn(playerRace, playerGender); // dq/quest_dwarf
	}

	// quest_intro
	void OnQuestIntro()
	{
		DqBaseQuests_OnQuestIntro(); // dq/quests/bases/dq_base_quests
		DqGenericChat_OnQuestIntro(); // dq/templates/bases/dq_generic_chat
	}

	// quest_activate
	void OnQuestActivate(CBasePlayer@ menuOwner = null)
	{
		DqBaseQuests_OnQuestActivate(menuOwner); // dq/quests/bases/dq_base_quests
		DqFetchDrop_OnQuestActivate(menuOwner); // dq/quests/dq_fetch_drop
		DqGenericReward_OnQuestActivate(menuOwner); // dq/templates/bases/dq_generic_reward
		DqGenericChat_OnQuestActivate(menuOwner); // dq/templates/bases/dq_generic_chat
		QuestDwarf_OnQuestActivate(menuOwner); // dq/quest_dwarf
	}

	// quest_finished
	void OnQuestFinished()
	{
		DqBaseQuests_OnQuestFinished(); // dq/quests/bases/dq_base_quests
		DqGenericChat_OnQuestFinished(); // dq/templates/bases/dq_generic_chat
	}

	// game_death
	void OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		DqBaseQuests_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // dq/quests/bases/dq_base_quests
		DqFetchDrop_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // dq/quests/dq_fetch_drop
		DqMonsterExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // dq/externals/dq_monster_externals
		MonstersExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/externals
		BaseSelfAdjust_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_self_adjust
		BaseNpc_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseMonsterShared_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared
		BaseChatArray_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_chat_array
		DwarfLanternBase_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // NPCs/dwarf_lantern_base
	}

	// game_menu_getoptions
	void OnGameMenuGetoptions(CBasePlayer@ player = null)
	{
		DqBaseQuests_OnGameMenuGetoptions(player); // dq/quests/bases/dq_base_quests
		DqFetchDrop_OnGameMenuGetoptions(player); // dq/quests/dq_fetch_drop
		DqGenericReward_OnGameMenuGetoptions(player); // dq/templates/bases/dq_generic_reward
		DqGenericMenus_OnGameMenuGetoptions(player); // dq/templates/bases/dq_generic_menus
		BaseChatArray_OnGameMenuGetoptions(player); // monsters/base_chat_array
	}

	// quest_taker_updated
	void OnQuestTakerUpdated()
	{
		DqBaseQuests_OnQuestTakerUpdated(); // dq/quests/bases/dq_base_quests
		DqGenericReward_OnQuestTakerUpdated(); // dq/templates/bases/dq_generic_reward
	}

	// npc_targetvalidate
	void OnNpcTargetvalidate(CBaseEntity@ target = null)
	{
		DqBaseQuests_OnNpcTargetvalidate(target); // dq/quests/bases/dq_base_quests
		BaseMonsterShared_OnNpcTargetvalidate(target); // monsters/base_monster_shared
	}

	// game_dynamically_created
	void OnGameDynamicallyCreated(string creatorValue1 = "", string creatorValue2 = "", string damage = "", string skill = "", string extraValue5 = "", string extraValue6 = "", float alwaysPush = 0.0f, string duration = "", string extraValue9 = "")
	{
		DqBaseQuests_OnGameDynamicallyCreated(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // dq/quests/bases/dq_base_quests
		BaseSelfAdjust_OnGameDynamicallyCreated(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/base_self_adjust
		BaseSelfAdjust_OnGameDynamicallyCreated_2(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/base_self_adjust
		BaseAntiStuck_OnGameDynamicallyCreated(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/base_anti_stuck
		BaseAntiStuck_OnGameDynamicallyCreated_2(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/base_anti_stuck
	}

	// game_precache
	void OnGamePrecache()
	{
		DqFetchDrop_OnGamePrecache(); // dq/quests/dq_fetch_drop
		DwarfLanternBase_OnGamePrecache(); // NPCs/dwarf_lantern_base
	}

	// quest_complete
	void OnQuestComplete(CBasePlayer@ questPlayer = null)
	{
		DqGenericReward_OnQuestComplete(questPlayer); // dq/templates/bases/dq_generic_reward
		DqGenericChat_OnQuestComplete(questPlayer); // dq/templates/bases/dq_generic_chat
	}

	void OnCriticalNpc() { MonstersExternals_OnCriticalNpc(); } // critical_npc

	// npcatk_clear_targets
	void OnNpcatkClearTargets(string reason = "")
	{
		BaseNpcAttackNew_OnNpcatkClearTargets(reason); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcatkClearTargets(reason); // monsters/base_monster_shared
		BaseMonsterShared_OnNpcatkClearTargets_2(reason); // monsters/base_monster_shared
	}

	// set_leader
	void OnSetLeader(int isLeader = 0)
	{
		BaseBattleAlly_OnSetLeader(isLeader); // monsters/base_battle_ally
		QuestDwarf_OnSetLeader(isLeader); // dq/quest_dwarf
	}

	void OnSetFollower() { BaseBattleAlly_OnSetFollower(); } // set_follower
	void OnChatConvoAnim() { BaseChatArray_OnChatConvoAnim(); } // chat_convo_anim
	void OnChatNow(string text = "", string displayTime = "", string animation = "", string eventName = "", string sound = "", string sound2 = "", string sound3 = "", string sound4 = "") { BaseChatArray_OnChatNow(text, displayTime, animation, eventName, sound, sound2, sound3, sound4); } // chat_now

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		DqFetchDropTemplate_FirstThink();
		DqFetchDrop_FirstThink();
		DqBaseQuests_FirstThink();
		DqGenericReward_FirstThink();
		QuestDwarf_FirstThink();
		BaseNpc_FirstThink();
		MonstersExternals_FirstThink();
		BaseNpcAttackNew_FirstThink();
		BaseMonsterShared_FirstThink();
		BaseBattleAlly_FirstThink();
		BaseChatArray_FirstThink();
		BaseStruck_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "do_chat_ext_recieve_quest_item") { OnDoChatExtRecieveQuestItem(); return true; }
		if (name == "ext_receive_quest_item") { OnExtReceiveQuestItem(Param(params, 0)); return true; }
		return DqFetchDrop_DispatchEvent(name, params)
			|| DqBaseQuests_DispatchEvent(name, params)
			|| DqGenericReward_DispatchEvent(name, params)
			|| DqGenericMenus_DispatchEvent(name, params)
			|| DqGenericChat_DispatchEvent(name, params)
			|| QuestDwarfScript::DispatchEvent(name, params);
	}
}
