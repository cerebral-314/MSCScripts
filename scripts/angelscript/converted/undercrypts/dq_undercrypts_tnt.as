#pragma context server

// Converted from undercrypts/dq_undercrypts_tnt.script by msc_transpiler.
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
// This quest is fetch_items. When the quest is activated, you either must look for a bunch of items, or one item in a randomly spawned location. Bringing back the items will complete the quest.

#include "runtime/ScriptEntity.as"
#include "converted/dq/quest_dwarf.as"
#include "converted/dq/quests/dq_fetch_items.as"
#include "converted/dq/dq_base_menus.as"

[script "undercrypts/dq_undercrypts_tnt"]
class DqUndercryptsTnt : QuestDwarfScript, DqFetchItems, DqBaseQuests, DqBaseMenus
{
	// Constants
	string QUEST_DATA2 = "tnt;Blasted Blasting Sticks";
	string QUEST_DATA3 = "0";

	// Variables (an unset .script variable reads as its own name)
	bool DID_TNT_COMMENT = false;

	// Variables declared by included files, with the value they start with in this script
	DqUndercryptsTnt()
	{
		QUEST_TYPE = "fetch_items";
		QUEST_DATA1 = "qst_tnt_";
		QUEST_REWARD_TYPE = "script";
		QUEST_REWARD_EVENT = "quest_tnt_complete";
		QUEST_WAITING_TEXT = "Hail.";
		QUEST_ASKING_TEXT = "I will find those explosives.";
		QUEST_ACTIVE_TEXT = "(Explosives found: %n/%r)";
		QUEST_COMPLETE_TEXT = "(Collect Reward)";
		QUEST_FADE_ON_COMPLETE = "fade";
		QUEST_GIVER_NAME = "Halsof";
		NEW_RACE = "beloved";
		AM_INVINCIBLE = true;
		NEW_WIDTH = 32;
		NEW_HEIGHT = 32;
		MONSTER_MODEL = "0";
		SUBMODEL_GROUPS = "0;0;1";
		USE_SKIN = "4";
		USE_LANTERN = true;
		INIT_IDLE_MODE = "sitting";
		CHAT_AUTO_FACE = false;
		CHAT_FACE_ON_USE = false;
		CHAT_NEVER_INTERRUPT = true;
		CHAT_CONV_ANIMS = "anim_sit_convo;anim_sit_idle_lantern";
		QUEST_WAITING = "waiting"; // from dq/quests/bases/dq_base_quests
		QUEST_ASKING = "asking"; // from dq/quests/bases/dq_base_quests
		QUEST_ACTIVE = "active"; // from dq/quests/bases/dq_base_quests
		QUEST_COMPLETE = "complete"; // from dq/quests/bases/dq_base_quests
		QUEST_FAILED = "failed"; // from dq/quests/bases/dq_base_quests
	}

	// unnamed block (first think)
	void DqUndercryptsTnt_FirstThink()
	{
		// <"(R,G,B)"> The color of the lantern using red green and blue. Defaults to (128,64,0)
		// Ex: const LANTERN_COLOR "(128,64,0)"
		INIT_IDLE_MODE = "sitting";
	}

	// game_spawn
	void DqUndercryptsTnt_OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		// custom (some possibly redundant)
		SetNoPush(true);
		SetInvincible(true);
		SetRace("beloved");
		SetMonsterClip(false);
		SetUniqueName("halsof");

		// setmodelbody 0 0
		// setmodelbody 1 0
		SetModelBody(2, 1);
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		DqUndercryptsTnt_OnGameSpawn(playerRace, playerGender);
		BaseNpc_OnGameSpawn(playerRace, playerGender); // monsters/base_npc
		BaseMonsterShared_OnGameSpawn(playerRace, playerGender); // monsters/base_monster_shared
		BaseChatArray_OnGameSpawn(playerRace, playerGender); // monsters/base_chat_array
		BaseStruck_OnGameSpawn(playerRace, playerGender); // monsters/base_struck
		QuestDwarf_OnGameSpawn(playerRace, playerGender); // dq/quest_dwarf
		DqBaseQuests_OnGameSpawn(playerRace, playerGender); // dq/quests/bases/dq_base_quests
	}

	// quest_activate
	void OnQuestActivate(CBasePlayer@ menuOwner = null)
	{
		QuestDwarf_OnQuestActivate(menuOwner); // dq/quest_dwarf
		DqBaseQuests_OnQuestActivate(menuOwner); // dq/quests/bases/dq_base_quests
		DqFetchItems_OnQuestActivate(menuOwner); // dq/quests/dq_fetch_items

		OnChatNow("Thanks. Think we'll be fine waitin here for awhile, got this place borded up pretty good.");

		// <"Quest accepted text"> The npc speaks what the input is. This specific part is what the npc says after you accept the quest. You may add more callevent chat_now lines if
		// you want the npc to say more that just one line of dialogue.
		// Ex: callevent chat_now "Come back here once you're done."
		PlaySound(2, 10, "voices/dwarf/vs_nx0drogm_yes.wav");
	}

	// quest_intro
	void OnQuestIntro()
	{
		DqBaseQuests_OnQuestIntro(); // dq/quests/bases/dq_base_quests

		OnChatNow("Ooohh... Hail there yourself. Finally, something that isn't bleedin' mad or undead.");
		OnChatNow("The three of us apparently dug a wrong path, fell, and got outselves stuck down here.");
		OnChatNow("Well, the two of us now... We woulda blown our way out through that old cart tunnel and been half way back to Gate City by now, but...");
		OnChatNow("...our 'explosives expert' Brynkahd, bloody blast powder sniffer that he is, just came apart after seeing all the horrors lurking around here.");
		OnChatNow("Thought he was workin on setting the bombs up, but apparently he was just sniffing powder until he finally blew his brains out!");
		OnChatNow("He attacked me, and Gesoth over there, and then ran off with all the blasted blasting sticks.");
		OnChatNow("Tried to chase him, but the beasts got between him and us, and... We had to run back here for cover.");
		OnChatNow("If ya find his corpse, or our explosives out there, maybe ya could bring em back to us?");
		OnChatNow("I mean just the boom sticks - Brynkahd can rot out there for all I care.", "3.0", "anim_sit_convo", "resend_menu");

		// <"Intro Text"> The npc speaks what the input is. This specific part is what the npc says after you say hi to him. You may add more callevent chat_now lines if you want
		// the npc to say more that just one line of dialogue.
		// Ex: callevent chat_now "I need help with something!"
		PlaySound(2, 10, "voices/dwarf/vs_nx0drogm_hi.wav");
	}

	// ext_receive_quest_item
	// Don't touch this
	void OnExtReceiveQuestItem(string itemCode = "")
	{
		DqFetchItems_OnExtReceiveQuestItem(itemCode); // dq/quests/dq_fetch_items

		CallEventDelayed(0.1f, "do_chat_ext_recieve_quest_item");
	}

	// resend_menu
	void OnResendMenu()
	{
		OpenMenu(OFFER_MENU_ID);
	}

	// quest_complete
	void OnQuestComplete(CBasePlayer@ questPlayer = null)
	{
		OnChatNow("Thank ye! That'll do us just fine. Take this for yer troubles...");

		// <"Quest completed text"> The npc speaks what the input is. This specific part is what the npc says after you complete the quest. You may add more callevent chat_now lines if
		// you want the npc to say more that just one line of dialogue.
		// Ex: callevent chat_now "Thank you. Take this, for your troubles."
		PlaySound(2, 10, "voices/dwarf/vs_nx0drogm_vict.wav");

		OnCustomQuestComplete();
	}

	// do_chat_ext_recieve_quest_item
	void OnDoChatExtRecieveQuestItem()
	{
		if (QUEST_MODE == "active" && !CHAT_BUSY)
		{
			OnChatNow("Yup, that's what we're lookin for. Keep em coming! We'll need at least a dozen bundles.");

			// <"NPC recieved item text"> The npc speaks what the input is. This specific part is what the npc says after you turn in a quest item. You may add more callevent
			// chat_now lines if you want the npc to say more that just one line of dialogue.
			// Ex: callevent chat_now "Thank you. Send over your friends if they have anything for me."
			PlaySound(2, 10, "none");
		}
	}

	// custom_quest_complete
	void OnCustomQuestComplete()
	{
		UseTrigger("mm_qminers_done");
		CallExternal(FindByName("gesoth"), "ext_remove");
	}

	// ext_found_nearby_tnt
	void OnExtFoundNearbyTnt()
	{
		if (DID_TNT_COMMENT)
			return;
		DID_TNT_COMMENT = true;

		PlaySound(2, 10, "voices/dwarf/vs_nx0drogm_haha.wav");

		OnChatNow("By Urdual's left nostril! How'd we miss that one!?");
		CallEventDelayed(3.0f, "found_nearby_tnt2");
	}

	// found_nearby_tnt2
	void OnFoundNearbyTnt2()
	{
		CallExternal(FindByName("gesoth"), "ext_found_tnt");
		CallEventDelayed(3.0f, "found_nearby_tnt3");
	}

	// found_nearby_tnt3
	void OnFoundNearbyTnt3()
	{
		OnChatNow("Bloody... Bah. Bring it down and I'll add it to the collection.");
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files

	// game_death
	void OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		DqMonsterExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // dq/externals/dq_monster_externals
		MonstersExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/externals
		BaseSelfAdjust_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_self_adjust
		BaseNpc_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseMonsterShared_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared
		BaseChatArray_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_chat_array
		DwarfLanternBase_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // NPCs/dwarf_lantern_base
		DqBaseQuests_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // dq/quests/bases/dq_base_quests
	}

	void OnCriticalNpc() { MonstersExternals_OnCriticalNpc(); } // critical_npc

	// game_dynamically_created
	void OnGameDynamicallyCreated(string creatorValue1 = "", string creatorValue2 = "", string damage = "", string skill = "", string extraValue5 = "", string extraValue6 = "", float alwaysPush = 0.0f, string duration = "", string extraValue9 = "")
	{
		BaseSelfAdjust_OnGameDynamicallyCreated(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/base_self_adjust
		BaseSelfAdjust_OnGameDynamicallyCreated_2(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/base_self_adjust
		BaseAntiStuck_OnGameDynamicallyCreated(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/base_anti_stuck
		BaseAntiStuck_OnGameDynamicallyCreated_2(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/base_anti_stuck
		DqBaseQuests_OnGameDynamicallyCreated(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // dq/quests/bases/dq_base_quests
	}

	// npcatk_clear_targets
	void OnNpcatkClearTargets(string reason = "")
	{
		BaseNpcAttackNew_OnNpcatkClearTargets(reason); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcatkClearTargets(reason); // monsters/base_monster_shared
		BaseMonsterShared_OnNpcatkClearTargets_2(reason); // monsters/base_monster_shared
	}

	// npc_targetvalidate
	void OnNpcTargetvalidate(CBaseEntity@ target = null)
	{
		BaseMonsterShared_OnNpcTargetvalidate(target); // monsters/base_monster_shared
		DqBaseQuests_OnNpcTargetvalidate(target); // dq/quests/bases/dq_base_quests
	}

	// set_leader
	void OnSetLeader(int isLeader = 0)
	{
		BaseBattleAlly_OnSetLeader(isLeader); // monsters/base_battle_ally
		QuestDwarf_OnSetLeader(isLeader); // dq/quest_dwarf
	}

	void OnSetFollower() { BaseBattleAlly_OnSetFollower(); } // set_follower

	// game_menu_getoptions
	void OnGameMenuGetoptions(CBasePlayer@ player = null)
	{
		BaseChatArray_OnGameMenuGetoptions(player); // monsters/base_chat_array
		DqBaseQuests_OnGameMenuGetoptions(player); // dq/quests/bases/dq_base_quests
		DqFetchItems_OnGameMenuGetoptions(player); // dq/quests/dq_fetch_items
		DqBaseMenus_OnGameMenuGetoptions(player); // dq/dq_base_menus
	}

	// game_precache
	void OnGamePrecache()
	{
		DwarfLanternBase_OnGamePrecache(); // NPCs/dwarf_lantern_base
		DqFetchItems_OnGamePrecache(); // dq/quests/dq_fetch_items
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		DqUndercryptsTnt_FirstThink();
		QuestDwarf_FirstThink();
		BaseNpc_FirstThink();
		MonstersExternals_FirstThink();
		BaseNpcAttackNew_FirstThink();
		BaseMonsterShared_FirstThink();
		BaseBattleAlly_FirstThink();
		BaseChatArray_FirstThink();
		BaseStruck_FirstThink();
		DqFetchItems_FirstThink();
		DqBaseQuests_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "custom_quest_complete") { OnCustomQuestComplete(); return true; }
		if (name == "do_chat_ext_recieve_quest_item") { OnDoChatExtRecieveQuestItem(); return true; }
		if (name == "ext_found_nearby_tnt") { OnExtFoundNearbyTnt(); return true; }
		if (name == "ext_receive_quest_item") { OnExtReceiveQuestItem(Param(params, 0)); return true; }
		if (name == "found_nearby_tnt2") { OnFoundNearbyTnt2(); return true; }
		if (name == "found_nearby_tnt3") { OnFoundNearbyTnt3(); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "quest_activate") { OnQuestActivate(PlayerParam(params, 0)); return true; }
		if (name == "quest_complete") { OnQuestComplete(PlayerParam(params, 0)); return true; }
		if (name == "quest_intro") { OnQuestIntro(); return true; }
		if (name == "resend_menu") { OnResendMenu(); return true; }
		return DqFetchItems_DispatchEvent(name, params)
			|| DqBaseQuests_DispatchEvent(name, params)
			|| DqBaseMenus_DispatchEvent(name, params)
			|| QuestDwarfScript::DispatchEvent(name, params);
	}
}
