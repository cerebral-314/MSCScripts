#pragma context server

// Converted from sfor/wizard1.script by msc_transpiler.
// For sake of simplicity, we'll have this wizard manage the other four
// Need five such wizards, need to think of names... Hrmmm...
// we're going to do all the saytext from this central script via callexternals
// wizards names:
// Unum
// Duae
// Tres
// Quattuor
// Quinque

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_chat.as"

[script "sfor/wizard1"]
class Wizard1 : BaseChatScript
{
	// Constants
	string SYM_QUEST_NAME = "sym1";
	float CHAT_DELAY_SHORT = 3.0f;
	float CHAT_DELAY_LONG = 7.0f;
	bool NO_RUMOR = true;
	bool NO_JOB = true;
	string SYMB_ITEM = "item_s1";
	string SOUND_DEATH1 = "scientist/scream1.wav";
	string SOUND_DEATH2 = "scientist/scream2.wav";
	string SOUND_DEATH3 = "scientist/scream3.wav";
	string SOUND_DEATH4 = "scientist/scream4.wav";

	// Variables (an unset .script variable reads as its own name)
	float N_SYMBOLS = 0.0f;
	string BEAM_SET = "BEAM_SET";
	CBaseEntity@ WIZARD2_ID = null;
	CBaseEntity@ WIZARD3_ID = null;
	CBaseEntity@ WIZARD4_ID = null;
	CBaseEntity@ WIZARD5_ID = null;
	int DID_INTRO = 0;
	int N_PLAYERS = 0;
	bool OMG_WTF = false;
	bool DID_WARN = false;
	bool UNDI_SPAWN = false;
	float REMOVE_DELAY = 0.0f;
	bool HAS_SYMBOL = false;
	string MY_CL_IDX = "MY_CL_IDX";

	// Variables declared by included files, with the value they start with in this script
	Wizard1()
	{
		CHAT_DELAY = 5.0f;
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseChat_OnGameSpawn(playerRace, playerGender); // monsters/base_chat

		SetUniqueName("wizard1");

		SetName("Brother Unum");
		SetRace("human");
		SetHealth(60);
		SetModel("npc/balancepriest2.mdl"); // reskin one of the balance priests
		SetWidth(32);
		SetHeight(48); // crouched
		SetSayTextRange(1024);
		SetIdleAnim("idle1");
		PlayAnim("once", "idle1");
		LegacyCommand("blind", 1); // doesn't really need to "see"

		CatchSpeech("say_hi", "Hail", "hi", "greet", "gweets", "j0", "yo");

		N_SYMBOLS = 0.0f;
		BEAM_SET = "";

		CallEventDelayed(4.0f, "scan_for_players");
		CallEventDelayed(3.0f, "gather_wizard_ids");
	}

	// game_menu_getoptions
	void OnGameMenuGetoptions(CBasePlayer@ player = null)
	{
		BaseChat_OnGameMenuGetoptions(player); // monsters/base_chat
		MenuItem menuItem;

		if (HAS_SYMBOL)
			return;
		if (Truthy(GetVar("FSHARD_STARTED")))
			return;

		if (!Truthy(ScriptFlag(player, "fwarn", "type_exists")))
		{
			ScriptFlags(player, "add", "fwarn", "fwarn");
			HelpTip(player, "generic", "Repeatable Quest", "Only the person who gave the symbols can get the Felewyn Shard!");
		}

		if (MaxHealthOf(player) >= 700.0f)
		{
			if (Truthy(ItemExists(player, SYMB_ITEM)))
			{
				menuItem.title = "Offer the first symbol";
				menuItem.type = "payment";
				menuItem.data = SYMB_ITEM;
				menuItem.callback = "add_symbol_me";
				RegisterMenuItem(menuItem);
			}
			else
			{
				menuItem.title = "Offer the first symbol";
				menuItem.type = "disabled";
				menuItem.callback = "none";
				RegisterMenuItem(menuItem);
			}
		}
		else
		{
			HelpTip(player, "generic", "Felewyn Shard Quest", "You must have above 700 HP!");

			menuItem.title = "Offer the first symbol";
			menuItem.type = "disabled";
			menuItem.callback = "none";
			RegisterMenuItem(menuItem);
		}
	}

	// gather_wizard_ids
	void OnGatherWizardIds()
	{
		@WIZARD2_ID = FindByName("wizard2");
		@WIZARD3_ID = FindByName("wizard3");
		@WIZARD4_ID = FindByName("wizard4");
		@WIZARD5_ID = FindByName("wizard5");
		CallEventDelayed(0.1f, "init_beams");
	}

	// scan_for_players
	void OnScanForPlayers()
	{
		if (DID_INTRO != 0)
			return;
		CallEventDelayed(1.0f, "scan_for_players");

		string tBox = FindInBox("player", 512); // check player syntax in code
		if (tBox == "none")
			return;
		tBox = SortEntities(tBox, "range");
		CBaseEntity@ targId = FindEntity(GetToken(tBox, 0));
		Vector3 targOrg = OriginOf(targId);
		string targTrace = LegacyFunction("get_traceline", MyOrigin(), targOrg, "worldonly"); // make sure player really within range
		if (targTrace != Text(targOrg))
			return;
		DID_INTRO = 1;
		OnDoIntro();
	}

	// do_intro
	void OnDoIntro()
	{
		if (!(DID_INTRO < 2))
			return;
		DID_INTRO = 2; // above function could trip twice

		N_PLAYERS = PlayerCount();
		if (N_PLAYERS > 1)
			SayText("By the... How'd they'd get in here?");
		OnConvoAnim();

		CallEventDelayed(CHAT_DELAY, "do_intro2");
	}

	// do_intro2
	void OnDoIntro2()
	{
		if (OMG_WTF)
			return;
		CallExternal(WIZARD2_ID, "anim_text", "I warned you the seals were failing.");
		CallEventDelayed(CHAT_DELAY_SHORT, "do_intro3");
	}

	// do_intro3
	void OnDoIntro3()
	{
		if (OMG_WTF)
			return;
		SayText("Brother Tress, did not you destroy the bridge?");
		OnConvoAnim();
		CallEventDelayed(CHAT_DELAY_SHORT, "do_intro4");
	}

	// do_intro4
	void OnDoIntro4()
	{
		if (OMG_WTF)
			return;
		CallExternal(WIZARD3_ID, "anim_text", "Yes, but that alone would hardly stop an intrepid explorer who could brave The Dark Forest.");
		CallEventDelayed(CHAT_DELAY, "do_intro5");
	}

	// do_intro5
	void OnDoIntro5()
	{
		if (OMG_WTF)
			return;
		SayText("...then what of the door?");
		OnConvoAnim();
		CallEventDelayed(CHAT_DELAY_SHORT, "do_intro6");
	}

	// do_intro6
	void OnDoIntro6()
	{
		if (OMG_WTF)
			return;
		CallExternal(WIZARD4_ID, "anim_text", "May I remind you, brother Unum, we've been here, maintaining this seal, for over two hundred years now?");
		CallEventDelayed(CHAT_DELAY, "do_intro7");
	}

	// do_intro7
	void OnDoIntro7()
	{
		if (OMG_WTF)
			return;
		CallExternal(WIZARD5_ID, "anim_text", "Yes, between the negative energy of the forest, and the rust... I'd surprised if it were still there.");
		CallEventDelayed(CHAT_DELAY, "do_intro8");
	}

	// do_intro8
	void OnDoIntro8()
	{
		if (OMG_WTF)
			return;
		SayText("Well, they don't appear to be our apprentices. Perhaps they bring news?");
		OnConvoAnim();
	}

	// say_hi
	void OnSayHi(CBasePlayer@ talkingPlayer = null)
	{
		OMG_WTF = false;
		if (UNDI_SPAWN)
			return;
		SayText("Umm... Hail traveler. We five wizards are The Bretheren of Zahlon.");
		OnConvoAnim();
		CallEventDelayed(CHAT_DELAY, "say_hi2");

		CallExternal("players", "ext_set_fquest");
	}

	// say_hi2
	void OnSayHi2()
	{
		if (OMG_WTF)
			return;
		SayText("This chamber was once the meeting place of Undamael and his minions.");
		OnConvoAnim();
		CallEventDelayed(CHAT_DELAY, "say_hi3");
	}

	// say_hi3
	void OnSayHi3()
	{
		if (OMG_WTF)
			return;
		SayText("It was an arena of sorts, where Undamael would judge enemies which his forces had captured.");
		OnConvoAnim();
		CallEventDelayed(CHAT_DELAY, "say_hi4");
	}

	// say_hi4
	void OnSayHi4()
	{
		if (OMG_WTF)
			return;
		CallExternal(WIZARD4_ID, "anim_text", "You mean where he would EAT them, as his minions looked on.");
		CallEventDelayed(CHAT_DELAY, "say_hi5");
	}

	// say_hi5
	void OnSayHi5()
	{
		if (OMG_WTF)
			return;
		SayText("Umm, yes, quite, brother Quatra. *cough* In anycase, while the armies of elvenkind were combatting Lor Malgoriand's forces outside...");
		OnConvoAnim();
		CallEventDelayed(CHAT_DELAY_LONG, "say_hi6");
	}

	// say_hi6
	void OnSayHi6()
	{
		if (OMG_WTF)
			return;
		CallExternal(WIZARD3_ID, "anim_text", "We were here, sealing Undamael, the right hand of Lor Malgoriand, in his pit.");
		CallEventDelayed(CHAT_DELAY, "say_hi7");
	}

	// say_hi7
	void OnSayHi7()
	{
		if (OMG_WTF)
			return;
		CallExternal(WIZARD2_ID, "anim_text", "Unfortunately, we could only seal him, not defeat him, with what power we have.");
		CallEventDelayed(CHAT_DELAY, "say_hi8");
	}

	// say_hi8
	void OnSayHi8()
	{
		if (OMG_WTF)
			return;
		CallExternal(WIZARD5_ID, "anim_text", "Even then, we cannot hold him forever.");
		CallEventDelayed(CHAT_DELAY_SHORT, "say_hi9");
	}

	// say_hi9
	void OnSayHi9()
	{
		if (OMG_WTF)
			return;
		CallExternal(WIZARD4_ID, "anim_text", "You see, our apprentices were supposed to bring us five symbols of power, forged by the Felewyn priestesses.");
		CallEventDelayed(CHAT_DELAY_LONG, "say_hi10");
	}

	// say_hi10
	void OnSayHi10()
	{
		if (OMG_WTF)
			return;
		SayText("Sadly, we can only assume our apprentices were slain during the war.");
		OnConvoAnim();
		CallEventDelayed(CHAT_DELAY, "say_hi11");
	}

	// say_hi11
	void OnSayHi11()
	{
		if (OMG_WTF)
			return;
		CallExternal(WIZARD3_ID, "anim_text", "In which case, the symbols would now be in the hands of the remains of Lor Malgoriand's armies.");
		CallEventDelayed(CHAT_DELAY_LONG, "say_hi12");
	}

	// say_hi12
	void OnSayHi12()
	{
		if (OMG_WTF)
			return;
		if (PlayerCount() > 1)
			SayText("You seem strong warriors. If you could bring us those symbols, we could put an end to Lord Undamael's evil once and for all.");
		if (PlayerCount() == 1)
			SayText("You seem a strong warrior. If you could bring us those symbols, we could put an end to Lord Undamael's evil once and for all.");
		OnConvoAnim();
		CallEventDelayed(CHAT_DELAY_LONG, "say_hi13");
	}

	// say_hi13
	void OnSayHi13()
	{
		if (OMG_WTF)
			return;
		SayText("Even weakened by the power of the symbols, Lord Undamael will still be a force to be feared.");
		OnConvoAnim();
		CallEventDelayed(CHAT_DELAY, "say_hi14");
	}

	// say_hi14
	void OnSayHi14()
	{
		if (OMG_WTF)
			return;
		CallExternal(WIZARD5_ID, "anim_text", "Indeed, it will take the most powerful warriors in the land to defeat him, even in his weakened state.");
		CallEventDelayed(CHAT_DELAY_LONG, "say_hi15");
	}

	// say_hi15
	void OnSayHi15()
	{
		if (OMG_WTF)
			return;
		SayText("Please, go forth and seek - return to us the symbols of Felewyn and bring great warriors, that we may bring an end to this evil!");
		OnConvoAnim();
	}

	// game_struck
	void OnGameStruck(float damage = 0.0f, string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		if (UNDI_SPAWN)
			return;

		OMG_WTF = true;

		if (DID_WARN)
			return;
		DID_WARN = true;
		SayText("What sort of maniac are you!? If any one of us dies Undamael will be freed!");
	}

	// game_death
	void OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		PlayRandomSound(0, 10, SOUND_DEATH1, SOUND_DEATH2, SOUND_DEATH3, SOUND_DEATH4);
		if (UNDI_SPAWN)
			return;
		UseTrigger("mm_undi_spawn");
		UNDI_SPAWN = true;
		REMOVE_DELAY = 0.5f;
		OnRemoveBeams();
		CallExternal(WIZARD2_ID, "do_oshi");
		CallExternal(WIZARD3_ID, "do_oshi");
		CallExternal(WIZARD4_ID, "do_oshi");
		CallExternal(WIZARD5_ID, "do_oshi");
		SetIdleAnim("crouch_idle");
		PlayAnim("once", "crouch_idle");
	}

	// wizard_died
	void OnWizardDied()
	{
		if (UNDI_SPAWN)
			return;
		UseTrigger("mm_undi_spawn");
		UNDI_SPAWN = true;
		REMOVE_DELAY = 0.5f;
		OnRemoveBeams();
		CallExternal(WIZARD2_ID, "do_oshi");
		CallExternal(WIZARD3_ID, "do_oshi");
		CallExternal(WIZARD4_ID, "do_oshi");
		CallExternal(WIZARD5_ID, "do_oshi");
		SetIdleAnim("crouch_idle");
		PlayAnim("once", "crouch_idle");
	}

	// add_symbol_me
	void OnAddSymbolMe(CBasePlayer@ player = null)
	{
		SetGlobal("FSHARD_STARTED", @player); // store who started the quest.

		SayText("Thank you warrior " + NameOf(player) + " Remember we'll need all five at the same time.");
		HAS_SYMBOL = true;
		OnAddSymbol();
		SetIdleAnim("kneel_idle");
		SetMoveAnim("kneel_idle");
		PlayAnim("critical", "kneel");

		// dont reset quest data, you only get to do this once
		Quest("set", player, "f", 0); // quest data to 0 since it's defunct
	}

	// add_symbol
	void OnAddSymbol()
	{
		N_SYMBOLS += 1.0f;
		if (N_SYMBOLS != 5.0f)
			return;
		OnStartSpell();
	}

	// init_beams
	void OnInitBeams()
	{
		Effect("beam", "ents", "lgtning.spr", 100, self, 1, @WIZARD3_ID, 1, Vector3(255, 0, 0), 200, 10, -1);
		BEAM_SET = TokenAdd(BEAM_SET, EntityId(EntityOf(ENT_LASTCREATED)));
		CallEventDelayed(0.5f, "init_beam2");
	}

	// init_beam2
	void OnInitBeam2()
	{
		Effect("beam", "ents", "lgtning.spr", 100, @WIZARD3_ID, 1, @WIZARD5_ID, 1, Vector3(255, 0, 0), 200, 10, -1);
		BEAM_SET = TokenAdd(BEAM_SET, EntityId(EntityOf(ENT_LASTCREATED)));
		CallEventDelayed(0.5f, "init_beam3");
	}

	// init_beam3
	void OnInitBeam3()
	{
		Effect("beam", "ents", "lgtning.spr", 100, @WIZARD5_ID, 1, @WIZARD2_ID, 1, Vector3(255, 0, 0), 200, 10, -1);
		BEAM_SET = TokenAdd(BEAM_SET, EntityId(EntityOf(ENT_LASTCREATED)));
		CallEventDelayed(0.5f, "init_beam4");
	}

	// init_beam4
	void OnInitBeam4()
	{
		Effect("beam", "ents", "lgtning.spr", 100, @WIZARD2_ID, 1, @WIZARD4_ID, 1, Vector3(255, 0, 0), 200, 10, -1);
		BEAM_SET = TokenAdd(BEAM_SET, EntityId(EntityOf(ENT_LASTCREATED)));
		CallEventDelayed(0.5f, "init_beam5");
	}

	// init_beam5
	void OnInitBeam5()
	{
		Effect("beam", "ents", "lgtning.spr", 100, @WIZARD4_ID, 0, self, 1, Vector3(255, 0, 0), 200, 10, -1);
		BEAM_SET = TokenAdd(BEAM_SET, EntityId(EntityOf(ENT_LASTCREATED)));
	}

	// remove_beams
	void OnRemoveBeams()
	{
		int count = GetTokenCount(BEAM_SET);
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnRemoveBeamsLoop();
		}
	}

	// remove_beams_loop
	void OnRemoveBeamsLoop()
	{
		Effect("beam", "update", GetToken(BEAM_SET, loopIteration), "remove", REMOVE_DELAY);
	}

	// start_spell
	void OnStartSpell()
	{
		// frilly special effects followed by spawning undmael
		// use a global to tell undi he's to spawn vulnerable
		// wizards fade
		// use map effects instead
		// local WIZ_CENTER $get(GAME_MASTER,scriptvar,WIZARD_CENTER)	//defined by sfor/wizard_center
		// clientevent new all sfor/wizard_cl WIZARD_CENTER
		MY_CL_IDX = LastClientScriptId();
		SetGlobal("G_UNDAMAEL_VULNERABLE", 1);
		CallEventDelayed(0.1f, "color_beams");
		UNDI_SPAWN = true;
		CallEventDelayed(1.0f, "splodie_fx");
		UseTrigger("mm_undi_fx");
	}

	// color_beams
	void OnColorBeams()
	{
		int count = GetTokenCount(BEAM_SET);
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnColorBeamsLoop();
		}
	}

	// color_beams_loop
	void OnColorBeamsLoop()
	{
		Effect("beam", "update", GetToken(BEAM_SET, loopIteration), "color", Vector3(0, 255, 0));
		Effect("beam", "update", GetToken(BEAM_SET, loopIteration), "remove", 10.0f);
	}

	// splodie_fx
	void OnSplodieFx()
	{
		UseTrigger("mm_undi_spawn");
		// clientevent update all MY_CL_IDX do_explode
		CallEventDelayed(0.1f, "remove_us");
	}

	// remove_us
	void OnRemoveUs()
	{
		CallExternal(WIZARD2_ID, "fade_away");
		CallExternal(WIZARD3_ID, "fade_away");
		CallExternal(WIZARD4_ID, "fade_away");
		CallExternal(WIZARD5_ID, "fade_away");
		SayText("That's the last of our power - it is up to you to defeat him now. Aim for the horn atop his head! That's his weak point!");
		CallEventDelayed(0.1f, "fade_away");
	}

	// fade_away
	void OnFadeAway()
	{
		DeleteEntity(ENT_ME, "fade");
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files
	void OnChatDelay() {} // CHAT_DELAY
	void OnChatDelayLong() {} // CHAT_DELAY_LONG
	void OnChatDelayShort() {} // CHAT_DELAY_SHORT

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("npc/balancepriest2.mdl");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "add_symbol") { OnAddSymbol(); return true; }
		if (name == "add_symbol_me") { OnAddSymbolMe(PlayerParam(params, 0)); return true; }
		if (name == "color_beams") { OnColorBeams(); return true; }
		if (name == "color_beams_loop") { OnColorBeamsLoop(); return true; }
		if (name == "do_intro") { OnDoIntro(); return true; }
		if (name == "do_intro2") { OnDoIntro2(); return true; }
		if (name == "do_intro3") { OnDoIntro3(); return true; }
		if (name == "do_intro4") { OnDoIntro4(); return true; }
		if (name == "do_intro5") { OnDoIntro5(); return true; }
		if (name == "do_intro6") { OnDoIntro6(); return true; }
		if (name == "do_intro7") { OnDoIntro7(); return true; }
		if (name == "do_intro8") { OnDoIntro8(); return true; }
		if (name == "fade_away") { OnFadeAway(); return true; }
		if (name == "game_death") { OnGameDeath(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_menu_getoptions") { OnGameMenuGetoptions(PlayerParam(params, 0)); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "game_struck") { OnGameStruck(Float(Param(params, 0)), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "gather_wizard_ids") { OnGatherWizardIds(); return true; }
		if (name == "init_beam2") { OnInitBeam2(); return true; }
		if (name == "init_beam3") { OnInitBeam3(); return true; }
		if (name == "init_beam4") { OnInitBeam4(); return true; }
		if (name == "init_beam5") { OnInitBeam5(); return true; }
		if (name == "init_beams") { OnInitBeams(); return true; }
		if (name == "remove_beams") { OnRemoveBeams(); return true; }
		if (name == "remove_beams_loop") { OnRemoveBeamsLoop(); return true; }
		if (name == "remove_us") { OnRemoveUs(); return true; }
		if (name == "say_hi") { OnSayHi(PlayerParam(params, 0)); return true; }
		if (name == "say_hi10") { OnSayHi10(); return true; }
		if (name == "say_hi11") { OnSayHi11(); return true; }
		if (name == "say_hi12") { OnSayHi12(); return true; }
		if (name == "say_hi13") { OnSayHi13(); return true; }
		if (name == "say_hi14") { OnSayHi14(); return true; }
		if (name == "say_hi15") { OnSayHi15(); return true; }
		if (name == "say_hi2") { OnSayHi2(); return true; }
		if (name == "say_hi3") { OnSayHi3(); return true; }
		if (name == "say_hi4") { OnSayHi4(); return true; }
		if (name == "say_hi5") { OnSayHi5(); return true; }
		if (name == "say_hi6") { OnSayHi6(); return true; }
		if (name == "say_hi7") { OnSayHi7(); return true; }
		if (name == "say_hi8") { OnSayHi8(); return true; }
		if (name == "say_hi9") { OnSayHi9(); return true; }
		if (name == "scan_for_players") { OnScanForPlayers(); return true; }
		if (name == "splodie_fx") { OnSplodieFx(); return true; }
		if (name == "start_spell") { OnStartSpell(); return true; }
		if (name == "wizard_died") { OnWizardDied(); return true; }
		return BaseChatScript::DispatchEvent(name, params);
	}
}
