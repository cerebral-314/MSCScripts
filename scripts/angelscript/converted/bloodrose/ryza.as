#pragma context server

// Converted from bloodrose/ryza.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_chat_array.as"

[script "bloodrose/ryza"]
class Ryza : BaseChatArrayScript
{
	// Constants
	string MONSTER_MODEL = "npc/femhuman2.mdl";
	bool NO_RUMOR = true;
	bool NO_JOB = true;
	float EMOTE_FREQ = 20.0f;
	string PORTAL_FX_POS = "(175,-605,-3503)";

	// Variables (an unset .script variable reads as its own name)
	bool EMOTE_COUNT = false;
	float FLICK_COUNT = 0.0f;
	float GAVE_CRYSTALS = 0.0f;
	bool ASKED_ATHOLO = false;
	int TRIGGER_RANGE = 0;
	int DID_INTRO = 0;
	bool EMOTE_DELAY = false;
	bool JUST_MENTION_LOCATION = false;
	bool CHAT_TEMP_NO_AUTO_FACE = false;
	string CL_FX = "CL_FX";
	bool ATHOLO_DEAD = false;
	bool EMOTES_ENABLED = false;
	float FADE_COUNT = 0.0f;

	// Variables declared by included files, with the value they start with in this script
	Ryza()
	{
		CHAT_DELAY = 3.5f;
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseChatArray_OnGameSpawn(playerRace, playerGender); // monsters/base_chat_array

		SetName("Ghost of|Ryza, Priestess of Felewyn");

		SetUniqueName("ryza");

		SetHealth(9999); // mass hp prevents xplode bolts
		SetInvincible(true);
		SetRoam(false);
		SetRace("beloved");
		SetModel(MONSTER_MODEL);
		SetProp(ENT_ME, "rendermode", 5);
		SetProp(ENT_ME, "renderamt", 255);
		SetHearingSensitivity(10);
		SetMoveSpeed(0);

		SetIdleAnim("idle1");
		SetMoveAnim("idle1");

		CatchSpeech("say_atholo", "atholo", "beat", "defeat");
		CatchSpeech("say_felewyn", "felewyn");
		CatchSpeech("say_ring", "ring");

		CallEventDelayed(0.1f, "scan_for_players");

		EMOTE_COUNT = false;
		FLICK_COUNT = 0.0f;
		GAVE_CRYSTALS = 0.0f;
		ASKED_ATHOLO = false;

		TRIGGER_RANGE = 128;

		UseTrigger("ryza_shield");

		SetSayTextRange(1024);

		OnMakeSpeech();
	}

	// game_menu_getoptions
	void OnGameMenuGetoptions(CBasePlayer@ player = null)
	{
		BaseChatArray_OnGameMenuGetoptions(player); // monsters/base_chat_array
		MenuItem menuItem;

		if (DID_INTRO == 0)
			return;
		if (!ATHOLO_DEAD)
		{
			if (GAVE_CRYSTALS < 4.0f)
				OnChatStartSequence("crystal_mention");

			if (Truthy(ItemExists(player, "item_crystal_return")))
			{
				menuItem.title = "Enchant my crystal";
				menuItem.type = "payment";
				menuItem.data = "item_crystal_return";
				menuItem.callback = "got_crystal";
				RegisterMenuItem(menuItem);
			}
		}
		else
		{
			string quest = GetQuestData(player, "manaring");
			if (Truthy(ItemExists(player, "item_ring_ryza")))
			{
				if (quest == "0") // must be incomplete
				{
					if (!JUST_MENTION_LOCATION)
					{
						menuItem.title = "Show Ryza's Trinket";
						menuItem.type = "callback";
						menuItem.callback = "say_trinket";
						RegisterMenuItem(menuItem);
					}
					else
					{
						menuItem.title = "Ask about Ring";
						menuItem.type = "callback";
						menuItem.callback = "say_ring";
						RegisterMenuItem(menuItem);
					}
				}
			}
		}
	}

	// make_speech
	void OnMakeSpeech()
	{
		OnChatAddText("hi", "Greetings, I am the priestess Ryza...", Text(CHAT_DELAY), "pull_needle");
		OnChatAddText("hi", "My soul was bound here, for we knew one day Venevus would awaken Atholo.", Text(CHAT_DELAY), "none", "1");
		OnChatAddText("hi", "We also knew that one day heroes, who could defeat both Venvus and Atholo, would come!");
		OnChatAddText("hi", "I pray you are they, for my magic can only hold Atholo in his tomb for so long.");
		OnChatAddText("hi", "Use the portals quickly, for there is not much time before the magic that holds me to this mortal plane fails!", Text(CHAT_DELAY), "eye_wipe", "1");

		OnChatAddText("emote1", "Atholo is protected by ancient magics, but this source of his power is sealed in that tomb with him!", Text(CHAT_DELAY), "pondering2");
		OnChatAddText("emote2", "You must hurry, my magic cannot last forever!", Text(CHAT_DELAY), "retina", "1");
		OnChatAddText("emote3", "Do not hesitate! Hurry through the portals!", Text(CHAT_DELAY), "gluonshow");
		OnChatAddText("emote4", "If that beast escapes, all of Daragoth is doomed!", Text(CHAT_DELAY), "fear1");
		OnChatAddText("emote5", "Hurry! I cannot hold on much longer!", Text(CHAT_DELAY), "checktie", "1");
		OnChatAddText("emote6", "You CAN defeat him! It has been foretold!", Text(CHAT_DELAY), "lean");
		OnChatAddText("emote7", "You are amongst the chosen ones... you must not be defeated, or all is lost!", Text(CHAT_DELAY), "yes");
		OnChatAddText("emote8", "Continue the battle! I shall hold the beast inside for as long as I can!", Text(CHAT_DELAY), "quicklook");
		OnChatAddText("emote9", "Remember! I can use some of my magic to change your Return Crystals to Crystals of Relocation!", Text(CHAT_DELAY), "pondering3");
		OnChatAddText("emote10", "Great Felewyn, I beseech thee, watch over these heroes who fight so valiantly!", Text(CHAT_DELAY), "kneel");

		OnChatAddText("atholo", "Atholo is the one of the great lords of darkness that fought along side Lor Malgoriand, servant of the Fallen.", Text(CHAT_DELAY), "converse2");
		OnChatAddText("atholo", "Atholo was sealed here at the end of the war, but Venevus made his home here, and my order could not defeat the wizard.", Text(CHAT_DELAY), "converse2");
		OnChatAddText("atholo", "We knew what was to come, so my soul was bound here to prevent the release of Atholo. But both he, and his magic, remain within.", Text(CHAT_DELAY), "converse2");
		OnChatAddText("atholo", "Atholo's magic, like mine, is bound up in crystals and the elements.", Text(CHAT_DELAY), "converse2");
		OnChatAddText("atholo", "That is all I know of The Beast, you MUST defeat him!", Text(CHAT_DELAY), "converse2");

		OnChatAddText("crystal_got", "This will aid you in your battle, but use it wisely. I can only enchant so many.", Text(CHAT_DELAY), "dryhands");
		OnChatAddText("crystal_no", "I am sorry, the last of my magic MUST be used to maintain this barrier!", Text(CHAT_DELAY), "no", "1");
		OnChatAddText("crystal_mention", "I can use some of my magic to convert your Crystals of Return to those of Relocation.", Text(CHAT_DELAY), "yes");

		OnChatAddText("felewyn_no", "There is not enough time to explain the grandeur of my goddess, just know that she watches over you and your valiant battle!", Text(CHAT_DELAY), "push_button", "1");

		OnChatAddText("dying", "I salute you all for defeating the great evil, it is indeed as foretold!", Text(CHAT_DELAY), "franticbutton");
		OnChatAddText("dying", "This is but the first of the Great Evils you shall encounter in your lives.", Text(CHAT_DELAY), "no");
		OnChatAddText("dying", "But I can say no more...");
		OnChatAddText("dying", "I will pray for you, great adventurers! Take heart, for Felewyn watches over you all!", Text(CHAT_DELAY), "kneel", "do_fade");

		OnChatAddText("player_has_ring", "That was the magical trinket used to bind me to your realm to ensure Atholo's defeat.", "4.7", "franticbutton");
		OnChatAddText("player_has_ring", "The magics have long since dissipated as the focusing lenses have gone missing, alongside its base structure.", "6.2");
		OnChatAddText("player_has_ring", "Perhaps you may find them and restore the [ring] to its former glory?", Text(CHAT_DELAY), "4.5", "1");

		OnChatAddText("artifact_locations", "I fear Venevus has removed the focusing lenses and its original base, and scattered them across the world.", "5.5");
		OnChatAddText("artifact_locations", "Give me a moment, I may be able to channel the last remaining energy in the ring to find the missing artifacts.", "7", "none", "say_locations"); // call event to play fx or something

		OnChatAddText("artifact_locations2", "It seems one has made its way into the cursed coffers of a crystal-protected bandit's stronghold, nestled deep in a lush grove.", "9.1", "pondering"); // (Cursed bludgeon method, Kroush – Drops: The Amplifying Gem)
		OnChatAddText("artifact_locations2", "You may need to find yet more crystals, however.", "4", "yes", "swap_portal");

		OnChatAddText("artifact_locations2", "Another was given to a powerful crystalline wizard who was so apt at the arcane, they could split their very being into elemental fragments.", "8.1", "none", "swap_portal"); // (Culrak, Hemlock – Drops: The Focusing Stone)

		OnChatAddText("artifact_locations2", "The final jewel has recessed deep under the cliffs, to the possession of a dimensional arachnid.", "8.5", "no", "swap_portal"); // (Undercliffs, crystalline spider – Drops: The Magnifying Jewel)

		OnChatAddText("artifact_locations2", "Lastly, the base of the trinket was once a gift to Felewyn's devout followers to light their way during dark times.", "8", "none", "swap_portal"); // (Chapel, Felewyns Light from the dark forest chest)

		OnChatAddText("artifact_locations2", "Even if you were able to retrieve all these lost ancient artifacts...", "4.5", "none", "swap_portal"); // final portal swap kills it.
		OnChatAddText("artifact_locations2", "I fear those with the knowledge of attuning such powerful relics have been lost to time.");
		OnChatAddText("artifact_locations2", "If you were able to find someone so attuned to Felewyn's influence, perhaps you may be able to restore the latent energies within the leyline ring.");
		OnChatAddText("artifact_locations2", "Good luck, heroes. May Felewyn's grace, and Idemark's guidance, bless you once more.");
	}

	// scan_for_players
	void OnScanForPlayers()
	{
		CallEventDelayed(0.7f, "scan_for_players");

		if (Truthy(LegacyFunction("cansee", "player", TRIGGER_RANGE)))
			OnPlayerSpotted();
	}

	// game_heardsound
	void OnGameHeardsound(string soundType = "", Vector3 origin = Vector3(), float dangerRadius = 0.0f)
	{
		if (!(RangeTo(ENT_LASTHEARD) < TRIGGER_RANGE))
			return;
		if (!IsPlayer(ENT_LASTHEARD))
			return;
		OnPlayerSpotted();
	}

	// player_spotted
	// auto talk
	void OnPlayerSpotted()
	{
		if (DID_INTRO == 0)
		{
			if (!ATHOLO_DEAD)
				OnSayHi();
			DID_INTRO = 1;
		}

		if (DID_INTRO != 0 && !ATHOLO_DEAD && !EMOTE_DELAY)
		{
			EMOTE_DELAY = true;
			CallEventDelayed(EMOTE_FREQ, "emote_reset");
			OnSayEmote();
		}
	}

	// emote_reset
	void OnEmoteReset()
	{
		EMOTE_DELAY = false;
	}

	// say_hi
	void OnSayHi(CBasePlayer@ talkingPlayer = null)
	{
		OnChatStartSequence("hi");
	}

	// say_emote
	void OnSayEmote()
	{
		int rand = RandomInt(1, 10);
		if (rand == 9 && GAVE_CRYSTALS >= 4.0f)
			rand = 10;

		string str = "emote" + rand;
		OnChatStartSequence(str);
	}

	// say_trinket
	void OnSayTrinket()
	{
		if (CHAT_BUSY)
			return;
		if (!JUST_MENTION_LOCATION)
		{
			OnChatStartSequence("player_has_ring");
			JUST_MENTION_LOCATION = true;
		}
	}

	// say_ring
	void OnSayRing()
	{
		if (CHAT_BUSY)
			return;
		if (!JUST_MENTION_LOCATION)
			return;
		OnChatStartSequence("artifact_locations");
	}

	// say_locations
	// starts sequences for spawning portal
	void OnSayLocations()
	{
		CHAT_TEMP_NO_AUTO_FACE = true;
		SetAngle("face_origin", Vector3(0, Vec(PORTAL_FX_POS).y, 0));
		SetAngle("face", Vector3(0, Float(Eval("game.monster.angles.yaw")) + 180.0f, 0));

		PlayAnim("critical", "writeboard");

		CallEventDelayed(4.0f, "create_portal");
		CallEventDelayed(7.0f, "say_locations_delay");
	}

	// create_portal
	void OnCreatePortal()
	{
		ClientEvent("new", "all", "effects/manaring_portals", PORTAL_FX_POS, 1);
		CL_FX = LastClientScriptId();
	}

	// swap_portal
	void OnSwapPortal()
	{
		ClientEvent("update", "all", CL_FX, "spawn_a_portal");
	}

	// say_locations_delay
	void OnSayLocationsDelay()
	{
		CHAT_TEMP_NO_AUTO_FACE = false;
		OnChatStartSequence("artifact_locations2");
	}

	// got_crystal
	void OnGotCrystal(CBasePlayer@ giver = null)
	{
		if (ATHOLO_DEAD)
			return;
		if (GAVE_CRYSTALS >= 4.0f)
		{
			Offer(giver, "item_crystal_return");
			OnChatStartSequence("crystal_no");
		}

		if (GAVE_CRYSTALS < 4.0f)
		{
			Offer(giver, "item_crystal_reloc");
			OnChatStartSequence("crystal_got");
			GAVE_CRYSTALS += 1.0f;
		}
	}

	// atholo_done
	void OnAtholoDone()
	{
		TRIGGER_RANGE = 64;
		ATHOLO_DEAD = true;
		EMOTES_ENABLED = false;
		UseTrigger("ryza_shield");
	}

	// do_flicker
	void OnDoFlicker()
	{
		FLICK_COUNT += 1.0f;
		if (FLICK_COUNT < 20.0f)
		{
			int flickerAmt = RandomInt(10, 180);
			SetProp(ENT_ME, "renderamt", flickerAmt);
			CallEventDelayed(0.1f, "do_flicker");
		}
		if (FLICK_COUNT != 20.0f)
			return;
		FLICK_COUNT = 0.0f;
		SetProp(ENT_ME, "renderamt", 255);
	}

	// say_felewyn
	void OnSayFelewyn()
	{
		OnChatStartSequence("felewyn_no");
	}

	// say_atholo
	void OnSayAtholo()
	{
		OnChatStartSequence("atholo");
	}

	// do_exit
	void OnDoExit()
	{
		SetMenuAutoOpen(false);
		OnChatStartSequence("dying");
	}

	// do_fade
	void OnDoFade()
	{
		SetSolid("none");
		FADE_COUNT = 200.0f;
		OnFadeLoop();
	}

	// fade_loop
	void OnFadeLoop()
	{
		// dbg temp FADE_COUNT
		FADE_COUNT -= 3.0f;
		float fade = FADE_COUNT;
		if (FADE_COUNT >= 0.0f)
			SetProp(ENT_ME, "renderamt", fade);
		if (FADE_COUNT <= 0.0f)
			CallEventDelayed(0.2f, "remove_me");
		if (!(FADE_COUNT > 0.0f))
			return;
		CallEventDelayed(0.1f, "fade_loop");
	}

	// remove_me
	void OnRemoveMe(string caller = "")
	{
		DeleteEntity(ENT_ME);
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files
	void OnEmoteFreq() {} // EMOTE_FREQ

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("npc/femhuman2.mdl");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "atholo_done") { OnAtholoDone(); return true; }
		if (name == "create_portal") { OnCreatePortal(); return true; }
		if (name == "do_exit") { OnDoExit(); return true; }
		if (name == "do_fade") { OnDoFade(); return true; }
		if (name == "do_flicker") { OnDoFlicker(); return true; }
		if (name == "emote_reset") { OnEmoteReset(); return true; }
		if (name == "fade_loop") { OnFadeLoop(); return true; }
		if (name == "game_heardsound") { OnGameHeardsound(Param(params, 0), Vec(Param(params, 1)), Float(Param(params, 2))); return true; }
		if (name == "game_menu_getoptions") { OnGameMenuGetoptions(PlayerParam(params, 0)); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "got_crystal") { OnGotCrystal(PlayerParam(params, 0)); return true; }
		if (name == "make_speech") { OnMakeSpeech(); return true; }
		if (name == "player_spotted") { OnPlayerSpotted(); return true; }
		if (name == "remove_me") { OnRemoveMe(Param(params, 0)); return true; }
		if (name == "say_atholo") { OnSayAtholo(); return true; }
		if (name == "say_emote") { OnSayEmote(); return true; }
		if (name == "say_felewyn") { OnSayFelewyn(); return true; }
		if (name == "say_hi") { OnSayHi(PlayerParam(params, 0)); return true; }
		if (name == "say_locations") { OnSayLocations(); return true; }
		if (name == "say_locations_delay") { OnSayLocationsDelay(); return true; }
		if (name == "say_ring") { OnSayRing(); return true; }
		if (name == "say_trinket") { OnSayTrinket(); return true; }
		if (name == "scan_for_players") { OnScanForPlayers(); return true; }
		if (name == "swap_portal") { OnSwapPortal(); return true; }
		return BaseChatArrayScript::DispatchEvent(name, params);
	}
}
