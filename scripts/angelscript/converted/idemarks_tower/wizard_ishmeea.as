#pragma context server

// Converted from idemarks_tower/wizard_ishmeea.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_chat_array.as"

[script "idemarks_tower/wizard_ishmeea"]
class WizardIshmeea : BaseChatArrayScript
{
	// Variables (an unset .script variable reads as its own name)
	float COLLECTED_ITEMS = 0.0f;
	int SAID_HI = 0;
	bool SAID_LEOFING = false;
	bool MET_LEOFING = false;
	CBaseEntity@ IDEMARK_ID = null;
	float CHAPEL_CHAT_STEP = 0.0f;

	// Variables declared by included files, with the value they start with in this script
	WizardIshmeea()
	{
		CHAT_NEVER_INTERRUPT = true;
		CHAT_AUTO_HAIL = true;
	}

	// unnamed block (first think)
	void WizardIshmeea_FirstThink()
	{
		COLLECTED_ITEMS = 0.0f;
	}

	// game_precache
	void OnGamePrecache()
	{
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseChatArray_OnGameSpawn(playerRace, playerGender); // monsters/base_chat_array

		SetName("The Wizard|Ishme'Ea");
		SetUniqueName("ishmeea");

		SetInvincible(true);
		SetRace("beloved");

		SetModel("npc/elf_f_warrior.mdl");
		SetWidth(32);
		SetHeight(72);

		SetNoPush(true);

		SetModelBody(1, 7); // no body #7?
		SetProp(ENT_ME, "skin", 1);

		PlayAnim("hold", 3);

		SetMenuAutoOpen(true);
		SetSayTextRange(1000);

		OnCreateConversations();
	}

	// game_menu_getoptions
	void OnGameMenuGetoptions(CBasePlayer@ player = null)
	{
		BaseChatArray_OnGameMenuGetoptions(player); // monsters/base_chat_array
		MenuItem menuItem;

		if (SAID_HI == 0)
			return;
		if (MET_LEOFING)
		{
			menuItem.title = "Met Leofing";
			menuItem.type = "callback";
			menuItem.callback = "say_met_leofing";
			RegisterMenuItem(menuItem);
		}

		if (COLLECTED_ITEMS == 3.0f)
		{
			menuItem.title = "Give items";
			menuItem.type = "callback";
			menuItem.callback = "say_gave_items";
			RegisterMenuItem(menuItem);
		}
	}

	// create_conversations
	void OnCreateConversations()
	{
		CatchSpeech("say_met_leofing", "leofing");
		CatchSpeech("say_gave_items", "give", "item");

		// say_hi
		OnChatAddText("say_hi", "WHAT was that? I heard you crashing down here like a bag of hammers. Do you not understand the situation here?", "7.0", "none", "flag_said_hi");
		OnChatAddText("say_hi", "*sigh* Pardon me, it's been so long since I had proper visitors that I forget myself down here, sometimes.", "7", "none", "none");
		OnChatAddText("say_hi", "Something at the tower emits a powerful aura, it speaks to me in my dreams. In nightmares that I wouldn't wish on Lor Malgoriand himself.", "9", "none", "none");
		OnChatAddText("say_hi", "Do try and keep the noise down, darling.", "2", "none", "none");

		// say_hi_alt -alt is for looping after initial intro. It would be odd to have the npc to keep remarking the noise the player is supposedly making
		OnChatAddText("say_hi_alt", "It's been so long since I had proper visitors that I forget myself down here, sometimes.", "6", "none", "none");
		OnChatAddText("say_hi_alt", "Something at the tower emits a powerful aura, it speaks to me in my dreams. In nightmares that I wouldn't wish on Lor Malgoriand himself.", "9", "none", "none");
		OnChatAddText("say_hi_alt", "Do try and keep the noise down, darling.", "2", "none", "none");

		// say_met_leofing
		OnChatAddText("say_met_leofing", "Leofing? Alive? Well, in a manner of speaking. Good to know he has not changed in a few hundred years.", "8", "none", "none");
		OnChatAddText("say_met_leofing", "You see, I am studying the phenomenon here at Idemark's Tower. It is highly unusual, to say the least, that the lands themselves fight the Lost.", "10", "none", "none");
		OnChatAddText("say_met_leofing", "These purple crystals are the most reactive samples that I have found in all of Daragoth, by far!", "6", "none", "none");
		OnChatAddText("say_met_leofing", "The crystal rods are remnants of the great ballistae bolts that rained down here at the start of the Age of War.", "6", "none", "none");
		OnChatAddText("say_met_leofing", "The megalithic ammunition must have been cursed by The Lost to spread their influence upon strategic locations.", "6", "none", "none");
		OnChatAddText("say_met_leofing", "I have been busy in the years since, traveling to different Elvish enclaves to further my arcane knowledge.", "6", "none", "none");
		OnChatAddText("say_met_leofing", "Arcane scholars I studied with at our capital city, Kray Eldorad, claim that this energy can be re-cast.", "7", "none", "none");
		OnChatAddText("say_met_leofing", "It could be used as a conduit to purge The Lost from this area, allowing me to enter the Tower proper.", "7", "none", "none");
		OnChatAddText("say_met_leofing", "A few ingredients are required for this. We will need the remains from a powerful leader of The Lost to counteract its influence.", "7", "none", "none");
		OnChatAddText("say_met_leofing", "The remains of Leofing himself are needed, his unwavering devotion will power the connection.", "6", "none", "none");
		OnChatAddText("say_met_leofing", "And finally a sample of the purple crystal itself, the physical connection needed to bridge my mind to the ether.", "7", "none", "flag_said_leofing");

		// say_met_leofing_alt
		OnChatAddText("say_met_leofing_alt", "I can use the energy here to purge The Lost from this area, allowing me to enter the Tower.", "6", "none", "none");
		OnChatAddText("say_met_leofing_alt", "A few ingredients are required for this.", "3", "none", "none");
		OnChatAddText("say_met_leofing_alt", "We will need the remains from a powerful leader of The Lost to counteract its influence.", "5", "none", "none");
		OnChatAddText("say_met_leofing_alt", "The remains of Leofing himself are needed, his unwavering devotion will power the connection.", "6", "none", "none");
		OnChatAddText("say_met_leofing_alt", "And finally a sample of the purple crystal itself, the physical connection needed to bridge my mind to the ether.", "7", "none", "none");

		// say_gave_items
		OnChatAddText("say_gave_items", "Incredible. To play a part in the fates, however minor, is beyond our wildest dreams. Thank you, Leofing, for this last gift.", "8", "none", "1");
		OnChatAddText("say_gave_items", "You know not the depths of your power, I would not be surprised if your path is guided by Pathos themself.", "6", "none", "none");
		OnChatAddText("say_gave_items", "Meet me in the chapel. It can be found high up on the mighty stone walls, near the front gate.", "5", "none", "tele_out");

		// say_boss_died
		OnChatAddText("say_boss_died", "All of Daragoth should be cheering your name right now, hero.", "3", "none", "none");
		OnChatAddText("say_boss_died", "A victory of this scale against The Lost has not happened in a long, long time.", "5", "none", "none");
		OnChatAddText("say_boss_died", "The Idemark you met in this chapel is a fragment of herself, a pool of magic that could only react to certain stimuli.", "7", "none", "none");
		OnChatAddText("say_boss_died", "Being in her study for so long, I can tell you that Idemark has left many more surprises for us inside that Tower.", "7", "none", "none");
		OnChatAddText("say_boss_died", "Rest your muscles and mind for now, adventurer, you will need your strength for what lies ahead.", "5", "none", "none");
	}

	// say_hi
	void OnSayHi(CBasePlayer@ talkingPlayer = null)
	{
		if (!CHAT_BUSY)
			if (CHAT_MENU_ON) {}

		if (SAID_HI == 0)
			OnChatStartSequence("say_hi");
		else
			OnChatStartSequence("say_hi_alt");
	}

	// flag_said_hi
	void OnFlagSaidHi()
	{
		SAID_HI = 1;
		if (MET_LEOFING)
			CHAT_MENU_ON = false;
	}

	// say_met_leofing
	void OnSayMetLeofing()
	{
		if (!SAID_LEOFING)
			OnChatStartSequence("say_met_leofing");
		else
			OnChatStartSequence("say_met_leofing_alt");
	}

	// flag_said_leofing
	void OnFlagSaidLeofing()
	{
		UseTrigger("cv_met");
		SAID_LEOFING = true;
	}

	// say_gave_items
	// teleports away after
	void OnSayGaveItems()
	{
		if (COLLECTED_ITEMS != 3.0f)
			return;
		OnChatStartSequence("say_gave_items");
	}

	// flag_gave_items
	void OnFlagGaveItems()
	{
		MET_LEOFING = false;
		COLLECTED_ITEMS = 0.0f;

		@IDEMARK_ID = FindByName("idemark");
	}

	// ext_chapel_start
	void OnExtChapelStart()
	{
		SetSayTextRange(2000);

		if (int(CHAPEL_CHAT_STEP) == 0)
			OnChatNow("Idemark... all this time, it was you? Of course, there was no other explanation for all of this.", "7", "none", "ext_chapel_start");
		else if (CHAPEL_CHAT_STEP == 1.0f)
			OnChatNow("The years that passed, the thousands of allies slain by the hordes of The Lost, the chosen Apostles now fallen.", "7", "none", "ext_chapel_start");
		else if (CHAPEL_CHAT_STEP == 2.0f)
			OnChatNow("And your inner sanctum was the only one standing intact?", "4", "none", "do_idemark_line");
		else if (CHAPEL_CHAT_STEP == 3.0f)
			OnChatNow("I am beyond impressed, in all my travels this type of magic has never been proven successful.", "6", "none", "ext_chapel_start");
		else if (CHAPEL_CHAT_STEP == 4.0f)
			OnChatNow("The power of ritual. A type of magic that can be practiced by the young, the old; the sick, the healthy; the stupid, and gifted alike.", "9", "none", "ext_chapel_start");
		else if (CHAPEL_CHAT_STEP == 5.0f)
			OnChatNow("To ritualize a mass sacrifice like this is unprecedented, even Leofing was unaware, I believe he was just acting in devotion to you.", "8", "none", "ext_chapel_start");
		else if (CHAPEL_CHAT_STEP == 6.0f)
			OnChatNow("One last powerful ritual is what's needed to drain the pus from this festering wound that The Lost occupy.", "7", "none", "ext_chapel_start");
		else if (CHAPEL_CHAT_STEP == 7.0f)
			OnChatNow("Warrior of Fate, be ready, the evil is about to manifest itself!", "6", "none", "do_idemark_line");
		else if (CHAPEL_CHAT_STEP == 8.0f)
			OnChatNow("Oh, Idemark. Even in your diminished form you make time for pleasantries. I carry your spirit with me everywhere I go.", "8", "none", "ext_chapel_start");
		else if (CHAPEL_CHAT_STEP == 9.0f)
			OnChatNow("Goodbye, dear friend and mentor.", "3", "none", "none");

		CHAPEL_CHAT_STEP += 1.0f;
	}

	// do_idemark_line
	void OnDoIdemarkLine()
	{
		CallExternal(IDEMARK_ID, "ext_chapel_speech");
	}

	// ext_boss_died
	void OnExtBossDied()
	{
		OnChatStartSequence("say_boss_died");
	}

	// tele_out
	void OnTeleOut()
	{
		float height = HeightOf(ENT_ME);
		Vector3 origin = OriginOf(ENT_ME);
		origin.z += height;

		ClientEvent("new", "all", "effects/sfx_sprite_in", origin, "c-tele1.spr", 24, 2);

		CBaseEntity@ target = FindByName("chapel_target1");
		SetOrigin(ENT_ME, OriginOf(target));
		SetAngle("face", AnglesOf(target));
	}

	// ext_met_leofing
	void OnExtMetLeofing()
	{
		MET_LEOFING = true;
		if (SAID_HI != 0)
			CHAT_MENU_ON = false;
	}

	// ext_collected
	void OnExtCollected()
	{
		COLLECTED_ITEMS += 1.0f;
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("c-tele1.spr");
		Precache("npc/elf_f_warrior.mdl");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		WizardIshmeea_FirstThink();
		BaseChatArray_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "create_conversations") { OnCreateConversations(); return true; }
		if (name == "do_idemark_line") { OnDoIdemarkLine(); return true; }
		if (name == "ext_boss_died") { OnExtBossDied(); return true; }
		if (name == "ext_chapel_start") { OnExtChapelStart(); return true; }
		if (name == "ext_collected") { OnExtCollected(); return true; }
		if (name == "ext_met_leofing") { OnExtMetLeofing(); return true; }
		if (name == "flag_gave_items") { OnFlagGaveItems(); return true; }
		if (name == "flag_said_hi") { OnFlagSaidHi(); return true; }
		if (name == "flag_said_leofing") { OnFlagSaidLeofing(); return true; }
		if (name == "game_menu_getoptions") { OnGameMenuGetoptions(PlayerParam(params, 0)); return true; }
		if (name == "game_precache") { OnGamePrecache(); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "say_gave_items") { OnSayGaveItems(); return true; }
		if (name == "say_hi") { OnSayHi(PlayerParam(params, 0)); return true; }
		if (name == "say_met_leofing") { OnSayMetLeofing(); return true; }
		if (name == "tele_out") { OnTeleOut(); return true; }
		return BaseChatArrayScript::DispatchEvent(name, params);
	}
}
