#pragma context server

// Converted from idemarks_tower/fragment_idemark.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_chat_array.as"

[script "idemarks_tower/fragment_idemark"]
class FragmentIdemark : BaseChatArrayScript
{
	// Variables (an unset .script variable reads as its own name)
	float RING_STEP = 0.0f;
	CBaseEntity@ CHAPEL_WALK_POINT = null;
	string MANARING_TARGET = "MANARING_TARGET";
	CBaseEntity@ ISHMEEA_ID = null;
	float CHAPEL_CHAT_STEP = 0.0f;

	// Variables declared by included files, with the value they start with in this script
	FragmentIdemark()
	{
		CHAT_AUTO_HAIL = true;
		CHAT_USE_CONV_ANIMS = false;
		CHAT_FACE_ON_USE = false;
		CHAT_AUTO_FACE = false;
	}

	// unnamed block (first think)
	void FragmentIdemark_FirstThink()
	{
		RING_STEP = 0.0f;
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseChatArray_OnGameSpawn(playerRace, playerGender); // monsters/base_chat_array

		SetName("a fragment of|Idemark");
		SetUniqueName("idemark");

		SetHealth(100);
		SetNoPush(true);

		SetSayTextRange(1000);

		SetInvincible(true);
		SetRace("beloved");

		SetModel("npc/femhuman2.mdl");
		SetWidth(32);
		SetHeight(72);

		SetProp(ENT_ME, "rendermode", 5);
		SetProp(ENT_ME, "renderfx", 3);
		SetProp(ENT_ME, "renderamt", 225);

		// playanim hold 71
		SetIdleAnim("sitting2");
		SetMoveAnim("walk");

		CatchSpeech("say_gems", "gem", "lens");
		CatchSpeech("say_ring", "ring");

		SetMenuAutoOpen(true);

		@CHAPEL_WALK_POINT = FindByName("chapel_target2");
	}

	// game_menu_getoptions
	void OnGameMenuGetoptions(CBasePlayer@ player = null)
	{
		BaseChatArray_OnGameMenuGetoptions(player); // monsters/base_chat_array
		MenuItem menuItem;

		if (!CHAT_MENU_ON)
			return;

		string quest = GetQuestData(player, "manaring");
		int item = Int(ItemExists(player, "item_ring_ryza"));

		if (quest != "0")
			return;
		if (item == 0)
			return;

		float gemCount = Float(ItemExists(player, "item_ring_ryza_gem1"));
		gemCount += Float(ItemExists(player, "item_ring_ryza_gem2"));
		gemCount += Float(ItemExists(player, "item_ring_ryza_gem3"));
		gemCount += Float(ItemExists(player, "ring_light2"));

		if (gemCount == 0.0f)
		{
			menuItem.title = "Show Ryza's Trinket";
			menuItem.type = "callback";
			menuItem.callback = "say_ring_nogems";
			RegisterMenuItem(menuItem);
		}
		else if (gemCount < 4.0f)
		{
			menuItem.title = "Show Ryza's Artifacts";
			menuItem.type = "callback";
			menuItem.callback = "say_not_enough_gem";
			RegisterMenuItem(menuItem);
		}
		else
		{
			menuItem.title = "Give Ryza's Artifacts";
			menuItem.type = "callback";
			menuItem.callback = "fix_ring_and_return";
			RegisterMenuItem(menuItem);
		}
	}

	// say_hi
	void OnSayHi(CBasePlayer@ talkingPlayer = null)
	{
		if (CHAT_BUSY)
			return;
		if (!CHAT_MENU_ON)
			return;
		OnChatNow("Who goes there? Are you of the Lost?", "3");
		OnChatNow("I have retreated to the confines of this chapel, where I have just enough power to keep their leader sealed in another plane of reality.", "7");
		OnChatNow("You must seek out one of my guard, should they still exist among us. They have each sworn an oath to me, serving me even in death. They can help you.", "9");
	}

	// say_ring_nogems
	void OnSayRingNogems()
	{
		if (CHAT_BUSY)
			return;
		if (!CHAT_MENU_ON)
			return;
		OnChatNow("Is that?... no. Not here. It wouldn't make sense.");
		OnChatNow("Please tell me the magical bindings of Atholo have not failed! Unless...");
		OnChatNow("You've defeated him? It has been centuries since I devised the ensorcelled device.");
		OnChatNow("To allow a great power to remain on your plane whose sole purpose was to bind Atholo.");
		OnChatNow("Ryza was a devoted supporter and believed in the strength of humanity. Her sacrifice will echo in eternity. I am forever grateful of her divine act to preserve this plane.");
		OnChatNow("The device, however, seems to be missing its three focusing [lenses], as well as the empowering body to which it is attuned.");
		OnChatNow("If you are able to find such and return them to me, I may be able to scrounge up the arcane power of this tower to restore this artifact to its former glory.");
	}

	// say_not_enough_gem
	void OnSayNotEnoughGem()
	{
		if (CHAT_BUSY)
			return;
		if (!CHAT_MENU_ON)
			return;
		OnChatNow("It seems you are on the right track, seeker. However, the device, the ring, and its focusing gems are useless without each other.");
		OnChatNow("Return to me with the [ring] and all three [gems] and I will attempt to restore its power for you.");
	}

	// say_gems
	void OnSayGems()
	{
		if (CHAT_BUSY)
			return;
		if (!CHAT_MENU_ON)
			return;
		OnChatNow("It seems one has made its way into the cursed coffers of a crystal-protected bandit's stronghold, nestled deep in a lush grove.");
		OnChatNow("You may need to find yet more crystals, however.");
		OnChatNow("Another was given to a powerful crystalline wizard who was so apt at the arcane, they could split their very being into elemental fragments.");
		OnChatNow("The final jewel has recessed deep under the cliffs, to the possession of a dimensional arachnid.");
		OnChatNow("The base of the trinket was once a gift to Felewyn's devout followers to light their way during dark times.");
	}

	// say_ring
	void OnSayRing()
	{
		OnSayGems();
	}

	// fix_ring_and_return
	void OnFixRingAndReturn(CBasePlayer@ player = null)
	{
		if (CHAT_BUSY)
			return;
		if (!CHAT_MENU_ON)
			return;

		float gemCount = Float(ItemExists(player, "item_ring_ryza"));
		gemCount += Float(ItemExists(player, "item_ring_ryza_gem1"));
		gemCount += Float(ItemExists(player, "item_ring_ryza_gem2"));
		gemCount += Float(ItemExists(player, "item_ring_ryza_gem3"));
		gemCount += Float(ItemExists(player, "ring_light2"));

		if (gemCount == 5.0f)
		{
			gemCount += Float(LegacyFunction("item_exists", @player, "item_ring_ryza", "remove"));
			gemCount += Float(LegacyFunction("item_exists", @player, "item_ring_ryza_gem1", "remove"));
			gemCount += Float(LegacyFunction("item_exists", @player, "item_ring_ryza_gem2", "remove"));
			gemCount += Float(LegacyFunction("item_exists", @player, "item_ring_ryza_gem3", "remove")); // doesn't add? but will remove them.
			gemCount += Float(LegacyFunction("item_exists", @player, "ring_light2", "remove"));

			MANARING_TARGET = EntityId(player);

			OnChatNow("By Felewyn's Light. You've done it! The awe-inspiring power of this magical construct shall resonate once again.", "6.5");
			OnChatNow("Give me a moment, as I attempt to restore the ring to its former glory.", "4.5");
			OnChatNow("Just need to recall the ancient incantations...", "3", "none", "make_ring");
		}
	}

	// give_manaring
	void OnGiveManaring()
	{
		Quest("set", MANARING_TARGET, "manaring", 1);
		Offer(MANARING_TARGET, "item_ring_mana");
		MANARING_TARGET = "MANARING_TARGET";
	}

	// make_ring
	void OnMakeRing()
	{
		PlaySound(0, 10, "magic/energy1_loud.wav");

		if (int(RING_STEP) == 0)
		{
			PlayAnim("critical", "sitting3");
			PlaySound(0, 10, "magic/shock_noloop.wav");
			ClientEvent("new", "all", "effects/sfx_light_fade", BonePositionOf(ENT_ME, 19), "(255,0,0)", 200, 0);
		}
		else if (RING_STEP == 1.0f)
		{
			ClientEvent("new", "all", "effects/sfx_light_fade", BonePositionOf(ENT_ME, 19), "(255,0,255)", 200, 0);
		}
		else if (RING_STEP == 2.0f)
		{
			ClientEvent("new", "all", "effects/sfx_light_fade", BonePositionOf(ENT_ME, 19), "(0,255,0)", 200, 0);
		}
		else if (RING_STEP == 3.0f)
		{
			ClientEvent("new", "all", "effects/sfx_light_fade", BonePositionOf(ENT_ME, 19), "(255,255,255)", 200, 0);
			RING_STEP = 0.0f;
			OnDoneRing();
			return;
		}

		RING_STEP += 1.0f;
		CallEventDelayed(2.4f, "make_ring");
	}

	// done_ring
	void OnDoneRing()
	{
		if (!Exists(MANARING_TARGET)) // Chat can end early if someone starts the maps end sequence. Just check that the ring wasnt given away already
			return;

		OnChatNow("...there it is. A wonder to behold. An ancient artifact born anew. Its latent energies manifest once more! The arcane shall now flow through you readily.", "none", "none", "1");
		OnChatNow("Thank you, adventurer, for restoring this great power. For being a champion of its rebirth. Its mana stones shall restore your magical powers, just as you have done for it.");
		OnChatNow("May Felewyn forever be by your side.");
	}

	// ext_chapel_start
	void OnExtChapelStart()
	{
		OnChatClearQue(); // Stop talking

		if (Exists(MANARING_TARGET)) // Someone was in the middle of making a ring
		{
			OnGiveManaring(); // Just give it to them. We don't need to finish speaking.
		}

		SetSayTextRange(2000);

		// local L_ORIGIN $get(ent_me,origin)
		// vectoradd L_ORIGIN $relpos($get(ent_me,angles),$vec(0,25,25))
		// setorigin ent_me L_ORIGIN
		SetIdleAnim("idle1");

		SetMoveDest(@CHAPEL_WALK_POINT, 5);
		PlayAnim("critical", "sitstand");

		@ISHMEEA_ID = FindByName("ishmeea");
		CHAT_MENU_ON = false;
	}

	// game_reached_dest
	void OnGameReachedDest()
	{
		Vector3 origin = OriginOf(CHAPEL_WALK_POINT);
		origin.z = OriginOf(ENT_ME).z;

		SetOrigin(ENT_ME, origin);
		SetAngle("face", AnglesOf(CHAPEL_WALK_POINT));
	}

	// ext_chapel_speech
	void OnExtChapelSpeech()
	{
		if (int(CHAPEL_CHAT_STEP) == 0)
			OnChatNow("Ishme'Ea. No, I played a small part in all this. I am just as much a prisoner in this chapel as the monstrosity that I restrain.", "8", "none", "ext_chapel_speech");
		if (CHAPEL_CHAT_STEP == 1.0f)
			OnChatNow("Yourself and Leofing were essential parts of the series of protective rituals that I have cast in and around the tower.", "6", "none", "ext_chapel_speech");
		if (CHAPEL_CHAT_STEP == 2.0f)
			OnChatNow("I also counted on your curiosity and eagerness to help the world. In hopes that you would return with the knowledge to aid us.", "7", "none", "do_ishmeea_line");
		if (CHAPEL_CHAT_STEP == 3.0f)
			OnChatNow("Goodbye, Ishme'Ea. I will not survive the ritual. It was an honor to serve as Apostle to Pathos.", "6", "none", "ext_chapel_speech");
		if (CHAPEL_CHAT_STEP == 4.0f)
		{
			OnChatNow("And an honor to be your first teacher. Benevolent visitor, may your steel strike true, and your magic flow freely.", "7", "none", "do_ishmeea_line");
			CallEventDelayed(10.0f, "ded");
		}

		CHAPEL_CHAT_STEP += 1.0f;
	}

	// do_ishmeea_line
	void OnDoIshmeeaLine()
	{
		CallExternal(ISHMEEA_ID, "ext_chapel_start");
	}

	// ded
	void OnDed()
	{
		DeleteEntity(ENT_ME, "fade");
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("npc/femhuman2.mdl");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		FragmentIdemark_FirstThink();
		BaseChatArray_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "ded") { OnDed(); return true; }
		if (name == "do_ishmeea_line") { OnDoIshmeeaLine(); return true; }
		if (name == "done_ring") { OnDoneRing(); return true; }
		if (name == "ext_chapel_speech") { OnExtChapelSpeech(); return true; }
		if (name == "ext_chapel_start") { OnExtChapelStart(); return true; }
		if (name == "fix_ring_and_return") { OnFixRingAndReturn(PlayerParam(params, 0)); return true; }
		if (name == "game_menu_getoptions") { OnGameMenuGetoptions(PlayerParam(params, 0)); return true; }
		if (name == "game_reached_dest") { OnGameReachedDest(); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "give_manaring") { OnGiveManaring(); return true; }
		if (name == "make_ring") { OnMakeRing(); return true; }
		if (name == "say_gems") { OnSayGems(); return true; }
		if (name == "say_hi") { OnSayHi(PlayerParam(params, 0)); return true; }
		if (name == "say_not_enough_gem") { OnSayNotEnoughGem(); return true; }
		if (name == "say_ring") { OnSayRing(); return true; }
		if (name == "say_ring_nogems") { OnSayRingNogems(); return true; }
		return BaseChatArrayScript::DispatchEvent(name, params);
	}
}
