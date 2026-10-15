#pragma context server

// Converted from monsters/base_npc_vendor_confirm.script by msc_transpiler.
// This is a seperate include as some vendors do not use base_npc_vendor
// It requires base_chat to function
// I would have included base chat into this script, but it'd mess with a lot of existing venders
// flags:
// VEND_NEWBIE - (sevard plz) offers basic info on items:
// VEND_ARMORER - for vendors that sell armor
// VEND_WEAPONS - for vendors that sell weapons
// VEND_CONTAINERS - for vendors that sell containers or sheaths
// VEND_SPEC_SHEATHS - for vendors that still sell the specialist sheaths
// - multiple flags can be enabled

#include "runtime/ScriptEntity.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class BaseNpcVendorConfirm
{
	// Constants
	float FREQ_HINT_TEXT = 120.0f;

	// Variables (an unset .script variable reads as its own name)
	bool HAS_INCLUDE_VENDOR_CONFIRM = true;
	bool NPC_CHECK_LEVEL = false;
	string VEND_NEWBIE = "VEND_NEWBIE";
	string VEND_CHAT_MODE = "VEND_CHAT_MODE";
	float NEXT_HINT_TEXT = 0.0f;
	CBaseEntity@ VEND_USER = null;
	int CHAT_STEPS = 0;
	string CHAT_STEP1 = "CHAT_STEP1";
	string CHAT_STEP2 = "CHAT_STEP2";
	string CHAT_STEP3 = "CHAT_STEP3";
	string CHAT_STEP4 = "CHAT_STEP4";

	// unnamed block (first think)
	void BaseNpcVendorConfirm_FirstThink()
	{
		HAS_INCLUDE_VENDOR_CONFIRM = true;

		NPC_CHECK_LEVEL = true;

		// ^ tells the code to check level of items purchased
		// if the player lacks the skill to use the item, purchase is aborted, and a notice is given
		string mapName = ToLowerCase(MapName());

		// potential const/setvard confict - embarassing in a new function ><
		if (VEND_NEWBIE == "VEND_NEWBIE")
		{
			if (mapName == "edana")
				VEND_NEWBIE = "1";
			if (mapName == "deralia")
				VEND_NEWBIE = "1";
			if (mapName == "gatecity")
				VEND_NEWBIE = "1";
			if (mapName == "helena")
				VEND_NEWBIE = "1";
		}
	}

	// game_spawn
	void BaseNpcVendorConfirm_OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		CallEventDelayed(1.0f, "player_scan");
		CallEventDelayed(2.0f, "vend_post_spawn");
	}

	// vend_post_spawn
	void BaseNpcVendorConfirm_OnVendPostSpawn()
	{
		if (Truthy(GetVar("VEND_WEAPONS")))
			CatchSpeech("say_weapons", "weapon");
		if (Truthy(GetVar("VEND_CONTAINERS")))
			CatchSpeech("say_containers", "sheath", "pack", "container");
		VEND_CHAT_MODE = "none";
	}

	// player_scan
	void BaseNpcVendorConfirm_OnPlayerScan()
	{
		if (Truthy(GetVar("NPC_REACTS")))
			return;
		CallEventDelayed(1.0f, "player_scan");
		if (!Truthy(LegacyFunction("cansee", "player", 128)))
			return;
		if (!(MaxHealthOf(ENT_LASTSEEN) < 100.0f))
			return;
		OnVendorOfferHelp();
	}

	// vendor_offerstore
	// <player>
	void BaseNpcVendorConfirm_OnVendorOfferstore(CBasePlayer@ player = null)
	{
		OnVendorOfferHelp(player);
	}

	// vendor_offer_help
	void BaseNpcVendorConfirm_OnVendorOfferHelp(CBaseEntity@ player = null)
	{
		if (Truthy(GetVar("BUSY_CHATTING")))
			return;
		if (!(GameTime() > NEXT_HINT_TEXT))
			return;
		NEXT_HINT_TEXT = GameTime() + FREQ_HINT_TEXT;

		if (!(MaxHealthOf(player) < 200.0f)) // don't bother vets
			return;

		if (Truthy(GetVar("VEND_WEAPONS")))
		{
			CatchSpeech("say_weapons", "weapon");
			if (!Truthy(GetVar("VEND_CONTAINERS")))
			{
				SayText("I can tell you about the [weapons] I have for sale.");
				OnBchatMouthMove();
			}
		}
		if (Truthy(GetVar("VEND_CONTAINERS")))
		{
			CatchSpeech("say_containers", "sheath", "pack", "container");
			OnBchatMouthMove();

			if (!Truthy(GetVar("VEND_WEAPONS")))
				SayText("I can tell you about the [containers] I have for sale.");
			if (Truthy(GetVar("VEND_WEAPONS")))
				SayText("I can tell you about the types [weapons] and [containers] I have for sale, if you like.");
		}
		if (Truthy(GetVar("VEND_ARMORER")))
		{
			if (Float(GetProp(player, "strength")) < 10.0f)
			{
				SayText("You might want to bulk up a bit before you try wearing any of my armors.");
				OnBchatMouthMove();
			}
			else if (Float(GetProp(player, "strength")) < 20.0f)
			{
				SayText("You look like you have enough muscle on you to handle my leather armors.");
				SayText("Still, I'd bulk up a bit more before trying the platemail, if I were you.");
				OnBchatMouthMove();
			}
		}
	}

	// game_menu_getoptions
	void BaseNpcVendorConfirm_OnGameMenuGetoptions(CBasePlayer@ player = null)
	{
		MenuItem menuItem;
		bool offerHelp = false;
		if (!Truthy(VEND_NEWBIE))
			return;

		if (VEND_CHAT_MODE == "none")
		{
			if (Truthy(GetVar("VEND_WEAPONS")))
			{
				menuItem.title = "About Weapons";
				menuItem.type = "callback";
				menuItem.callback = "say_weapons";
				RegisterMenuItem(menuItem);
				offerHelp = true;
			}
			if (Truthy(GetVar("VEND_CONTAINERS")))
			{
				menuItem.title = "About Containers";
				menuItem.type = "callback";
				menuItem.callback = "say_containers";
				RegisterMenuItem(menuItem);
				offerHelp = true;
			}
			if (offerHelp)
				OnVendorOfferHelp(player);
		}

		if (VEND_CHAT_MODE == "weapons")
		{
			SayText("Which sort of weapon would you like to know about?");
			menuItem.title = "Bows";
			menuItem.type = "callback";
			menuItem.data = "archery";
			menuItem.callback = "say_weapon_desc";
			RegisterMenuItem(menuItem);

			menuItem.title = "Axes";
			menuItem.type = "callback";
			menuItem.data = "axehandling";
			menuItem.callback = "say_weapon_desc";
			RegisterMenuItem(menuItem);

			menuItem.title = "Blunt Arms";
			menuItem.type = "callback";
			menuItem.data = "bluntarms";
			menuItem.callback = "say_weapon_desc";
			RegisterMenuItem(menuItem);

			menuItem.title = "Gauntlets";
			menuItem.type = "callback";
			menuItem.data = "martialarts";
			menuItem.callback = "say_weapon_desc";
			RegisterMenuItem(menuItem);

			menuItem.title = "Smallarms";
			menuItem.type = "callback";
			menuItem.data = "smallarms";
			menuItem.callback = "say_weapon_desc";
			RegisterMenuItem(menuItem);

			menuItem.title = "Swords";
			menuItem.type = "callback";
			menuItem.data = "swordsmanship";
			menuItem.callback = "say_weapon_desc";
			RegisterMenuItem(menuItem);

			menuItem.title = "Polearms";
			menuItem.type = "callback";
			menuItem.data = "polearms";
			menuItem.callback = "say_weapon_desc";
			RegisterMenuItem(menuItem);

			menuItem.title = "Scrolls and Tomes";
			menuItem.type = "callback";
			menuItem.data = "spellcasting";
			menuItem.callback = "say_weapon_desc";
			RegisterMenuItem(menuItem);
		}

		OnBchatMouthMove();
	}

	// game_menu_cancel
	void BaseNpcVendorConfirm_OnGameMenuCancel(CBasePlayer@ player = null)
	{
		VEND_CHAT_MODE = "none";
	}

	// say_weapons
	void BaseNpcVendorConfirm_OnSayWeapons(CBasePlayer@ player = null)
	{
		VEND_CHAT_MODE = "weapons";
		@VEND_USER = player;
		if (!IsAlive(VEND_USER))
			@VEND_USER = EntityOf(ENT_LASTSPOKE);
		CallEventDelayed(0.1f, "send_chat_menu");
	}

	// send_chat_menu
	void BaseNpcVendorConfirm_OnSendChatMenu()
	{
		OpenMenu(VEND_USER);
	}

	// say_weapon_desc
	void BaseNpcVendorConfirm_OnSayWeaponDesc(CBasePlayer@ value = null, string skillType = "")
	{
		VEND_CHAT_MODE = "none";

		if (Truthy(GetVar("BUSY_CHATTING")))
			return;

		if (skillType == "archery")
		{
			CHAT_STEPS = 4;
			CHAT_STEP1 = "Bows are excellent for wearing down opponents from a distance, before they can reach you.";
			CHAT_STEP2 = "Basic arrows are always available, but for that extra kick, you'll want to purchase more specialized arrows.";
			CHAT_STEP3 = "Training with bows doesn't bulk one up much, but aids in awareness and concentration, honing the mind for other tasks.";
			CHAT_STEP4 = "Such mental discipline can also aid in the working of magic. But one does not live by bow and spell alone.";
		}

		if (skillType == "axehandling")
		{
			CHAT_STEPS = 3;
			CHAT_STEP1 = "Smaller axes offer quick and steady damage. The large ones are slow and difficult to strike with, but can inflict massive wounds.";
			CHAT_STEP2 = "Either way, axe training offers rapid gains in both strength and endurance.";
			CHAT_STEP3 = "Nonetheless, the wise adventure always trains in as wide a range of weaponry as possible.";
		}

		if (skillType == "bluntarms")
		{
			CHAT_STEPS = 2;
			CHAT_STEP1 = "Maces and hammers can be used to stun opponents, in addition to offering formidable strength.";
			CHAT_STEP2 = "It's a good idea, however, to balance the brute strength they offer with the other weapon disciplines as well.";
		}

		if (skillType == "martialarts")
		{
			CHAT_STEPS = 3;
			CHAT_STEP1 = "Gauntlets are for aiding in brawling and martial arts training.";
			CHAT_STEP2 = "Virtually unarmed combat of this sort can get you out of a pinch!";
			CHAT_STEP3 = "But you'll have to learn all the combat skills you can, or risk always being in one!";
		}

		if (skillType == "smallarms")
		{
			CHAT_STEPS = 3;
			CHAT_STEP1 = "Knives and daggers require that you get in close with your opponent.";
			CHAT_STEP2 = "But they offer swift attack speeds and thus are not to be underestimated.";
			CHAT_STEP3 = "Training in smallarms offers little endurance, but great speed and agility.";
		}

		if (skillType == "swordsmanship")
		{
			CHAT_STEPS = 3;
			CHAT_STEP1 = "Swordsmanship training is a balanced art, offering moderate gains in most all physical abilities.";
			CHAT_STEP2 = "While it is good to be a well rounded warrior, however, it is wise to learn all one can of all the weapons.";
			CHAT_STEP3 = "This ensures one doesn't fall behind the extremists by taking the moderate approach!";
		}

		if (skillType == "spellcasting")
		{
			CHAT_STEPS = 3;
			CHAT_STEP1 = "Memorizing tomes, or invoking scrolls, allows access to a wide range of magical abilities.";
			CHAT_STEP2 = "It's an entirely mental activity though, and does nothing for the physique.";
			CHAT_STEP3 = "So while magical ability is cruicial for the adventurer, to be sure, man cannot live by magic alone.";
		}

		if (skillType == "polearms")
		{
			CHAT_STEPS = 4;
			CHAT_STEP1 = "Polearms are tricky to employ effectively in one on one combat, but deadly in the hands of an agile warrior.";
			CHAT_STEP2 = "They are very dynamic weapons, but you need to keep you enemy at a fair distance to optimize the damage.";
			CHAT_STEP3 = "While they aren't very effective at close range, the careful warrior can hold his opponent at bay, for a solid strike.";
			CHAT_STEP4 = "They do little to train robustness, but the footwork involved favors speed, concentration, and the like.";
		}

		OnChatLoop();
	}

	// say_containers
	void BaseNpcVendorConfirm_OnSayContainers()
	{
		CHAT_STEPS = 3;
		CHAT_STEP1 = "Weapon straps hold any type of weapon. Quivers hold amunition. Big sacks hold nearly everything else.";
		CHAT_STEP2 = "Backpacks can hold nearly anything, useful for more a more generalized inventory.";
		CHAT_STEP3 = "Spellbooks hold magic scrolls. The small sack can hold most items, but has very little room, so it can't hold very many.";

		if (Truthy(GetVar("VEND_SPEC_SHEATHS")))
		{
			CHAT_STEP4 = "I also offer more specialized sheaths, that can only hold specific weapon types.";
			CHAT_STEPS = 4;
		}
		OnChatLoop();
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)
	void OnGameSpawn(string playerRace = "", string playerGender = "") { BaseNpcVendorConfirm_OnGameSpawn(playerRace, playerGender); } // game_spawn
	void OnVendPostSpawn() { BaseNpcVendorConfirm_OnVendPostSpawn(); } // vend_post_spawn
	void OnPlayerScan() { BaseNpcVendorConfirm_OnPlayerScan(); } // player_scan
	void OnVendorOfferstore(CBasePlayer@ player = null) { BaseNpcVendorConfirm_OnVendorOfferstore(player); } // vendor_offerstore
	void OnVendorOfferHelp(CBaseEntity@ player = null) { BaseNpcVendorConfirm_OnVendorOfferHelp(player); } // vendor_offer_help
	void OnGameMenuGetoptions(CBasePlayer@ player = null) { BaseNpcVendorConfirm_OnGameMenuGetoptions(player); } // game_menu_getoptions
	void OnGameMenuCancel(CBasePlayer@ player = null) { BaseNpcVendorConfirm_OnGameMenuCancel(player); } // game_menu_cancel
	void OnSayWeapons(CBasePlayer@ player = null) { BaseNpcVendorConfirm_OnSayWeapons(player); } // say_weapons
	void OnSendChatMenu() { BaseNpcVendorConfirm_OnSendChatMenu(); } // send_chat_menu
	void OnSayWeaponDesc(CBasePlayer@ value = null, string skillType = "") { BaseNpcVendorConfirm_OnSayWeaponDesc(value, skillType); } // say_weapon_desc
	void OnSayContainers() { BaseNpcVendorConfirm_OnSayContainers(); } // say_containers
	void OnBchatMouthMove() {} // bchat_mouth_move
	void OnChatLoop() {} // chat_loop

	// This file's events and timers by their .script names
	bool BaseNpcVendorConfirm_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "game_menu_cancel") { OnGameMenuCancel(PlayerParam(params, 0)); return true; }
		if (name == "game_menu_getoptions") { OnGameMenuGetoptions(PlayerParam(params, 0)); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "player_scan") { OnPlayerScan(); return true; }
		if (name == "say_containers") { OnSayContainers(); return true; }
		if (name == "say_weapon_desc") { OnSayWeaponDesc(PlayerParam(params, 0), Param(params, 1)); return true; }
		if (name == "say_weapons") { OnSayWeapons(PlayerParam(params, 0)); return true; }
		if (name == "send_chat_menu") { OnSendChatMenu(); return true; }
		if (name == "vend_post_spawn") { OnVendPostSpawn(); return true; }
		if (name == "vendor_offer_help") { OnVendorOfferHelp(EntityParam(params, 0)); return true; }
		if (name == "vendor_offerstore") { OnVendorOfferstore(PlayerParam(params, 0)); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "monsters/base_npc_vendor_confirm"]
shared class BaseNpcVendorConfirmScript : ScriptEntity, BaseNpcVendorConfirm
{
	// Variables every script that includes this file declares
	float CHAT_DELAY = 0.0f;
	string SOUND_DEATH = "SOUND_DEATH";
	string STORE_BUYMENU = "STORE_BUYMENU";
	string STORE_NAME = "STORE_NAME";
	bool STORE_RESTOCK = false;
	string STORE_TRADEEXT = "STORE_TRADEEXT";
	bool VEND_NO_GOODBYE = false;

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		BaseNpcVendorConfirm_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return BaseNpcVendorConfirm_DispatchEvent(name, params);
	}
}
