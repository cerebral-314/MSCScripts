#pragma context server

// Converted from shender_east/telf_win.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_chat_array.as"

[script "shender_east/telf_win"]
class TelfWin : BaseChatArrayScript
{
	// Constants
	string ATTACH_LHAND = "3";
	string ATTACH_RHAND = "0";

	// Variables (an unset .script variable reads as its own name)
	bool MENTIONED_SEEKERS = false;

	// Variables declared by included files, with the value they start with in this script
	TelfWin()
	{
		CHAT_USE_CONV_ANIMS = false;
	}

	// unnamed block (timer)
	void TelfWin_Timer()
	{
		CallEventDelayed(10.0f, "TelfWin_Timer");
		ClientEvent("new", "all", "effects/sfx_follow_glow_cl", IndexOf(ENT_ME), Vector3(128, 128, 255), 32, 9.9f);
	}

	// unnamed block (timer)
	void TelfWin_Timer2()
	{
		CallEventDelayed(90.0f, "TelfWin_Timer2");
		CallExternal(FindByName("telf_chest"), "chest_glow");
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseChatArray_OnGameSpawn(playerRace, playerGender); // monsters/base_chat_array
		SetName("Fedrosh the Rammata");
		SetRace("human");
		SetHealth(2000);
		SetWidth(32);
		SetHeight(96);
		SetModel("npc/elf_m_wizard.mdl");
		SetIdleAnim("deep_idle");
		SetMoveAnim("deep_idle");
		SetNoPush(true);
		SetInvincible(true);
		SetMenuAutoOpen(true);
		SetSayTextRange(640);

		SetUniqueName("telf_win");

		CallEventDelayed(2.0f, "win_speech");
		CallEventDelayed(0.1f, "pre_glow");
	}

	// game_menu_getoptions
	void OnGameMenuGetoptions(CBasePlayer@ player = null)
	{
		BaseChatArray_OnGameMenuGetoptions(player); // monsters/base_chat_array
		MenuItem menuItem;
		menuItem.title = "Who are you, exactly?";
		menuItem.type = "callback";
		menuItem.callback = "say_hi";
		RegisterMenuItem(menuItem);

		menuItem.title = "What do you know of this place?";
		menuItem.type = "callback";
		menuItem.callback = "say_detail";
		RegisterMenuItem(menuItem);

		menuItem.title = "Where is the enclave?";
		menuItem.type = "callback";
		menuItem.callback = "say_stronghold";
		RegisterMenuItem(menuItem);

		if (MENTIONED_SEEKERS)
		{
			menuItem.title = "Seekers?";
			menuItem.type = "callback";
			menuItem.callback = "say_seeker";
			RegisterMenuItem(menuItem);
		}
	}

	// pre_glow
	void OnPreGlow()
	{
		ClientEvent("new", "all", "effects/sfx_follow_glow_cl", IndexOf(ENT_ME), Vector3(128, 128, 255), 32, 9.9f);
	}

	// win_speech
	void OnWinSpeech()
	{
		CallExternal(FindByName("telf_chest"), "ext_unlock");
		OnChatNow("By Torkalath! You did it! You broke the curse!", "3.0", "convo_unarmed_norm", "none", "add_to_que");
		OnChatNow("Please, take anything from my lock box over there, it's all yours.", "5.0", "none", "none", "add_to_que");
		OnChatNow("Be sure to take the amulet. With that, you can enter our Melanion enclave.", "5.0", "convo_unarmed_norm", "none", "add_to_que");
		OnChatNow("I can't promise how hospitable the refugees there will be, to anyone without one.", "5.0", "none", "none", "add_to_que");
	}

	// say_hi
	void OnSayHi(CBasePlayer@ talkingPlayer = null)
	{
		MENTIONED_SEEKERS = true;
		// callevent chat_clear_que
		OnChatNow("Sorry, my introduction in the dream was a bit rushed, I suppose...", "4.0", "convo_unarmed_norm", "clear_que", "add_to_que");
		OnChatNow("I am Fedrosh, a follower of Torkalath. I watch over this particular Melenion entrance to the enclave, to keep it safe.", "5.0", "none", "none", "add_to_que");
		OnChatNow("A few moons ago, I caught a group of Seekers, searching for the entrance.", "3.0", "convo_unarmed_norm", "none", "add_to_que");
		OnChatNow("I drove them off, but not before one of them placed that nightmare curse on me.", "4.0", "none", "none", "add_to_que");
		OnChatNow("It seems your efforts broke that curse. My magic is restored, so I should be fine now.", "4.0", "none", "do_spell_trick", "add_to_que");
	}

	// do_spell_trick
	void OnDoSpellTrick()
	{
		// play an anim and do some hand sparks here
		PlayAnim("critical", "ref_aim_trip");
		ClientEvent("new", "all", "effects/sfx_beam_sparks", IndexOf(ENT_ME), IndexOf(ENT_ME), ATTACH_LHAND, Vector3(255, 255, 0), 1.0f);
		PlaySound(0, 5, "debris/zap1.wav");
	}

	// say_seeker
	void OnSaySeeker()
	{
		OnChatNow("I suppose we elves have been isolated for quite some time, so you may not aware of our... Political situation.", "4.0", "convo_unarmed_norm", "clear_que", "add_to_que");
		OnChatNow("The elven empire, or rather, what remains of it, is essentially divided into three factions:", "4.0", "none", "none", "add_to_que");
		OnChatNow("The Felewyn elves, who maintain the old traditions, and retain exclusive control over the capital city and the military...", "5.0", "none", "none", "add_to_que");
		OnChatNow("Those that follow Urdual, also known as the Eshu, who are still somewhat tollerated, and live in the surrounding forests...", "5.0", "none", "none", "add_to_que");
		OnChatNow("And those such as myself, who follow the God of Strength, Torkalath, also known as the Ramatta.", "4.0", "convo_unarmed_norm", "none", "add_to_que");
		OnChatNow("Elves from the capital revile Ramatta. They send murderous squads of Seekers: wizards, warriors, and priests, trained to hunt us down.", "5.0", "none", "none", "add_to_que");
		OnChatNow("They've been seeking our enclave for quite some time. But thus far, I've kept this entrance secure.", "5.0", "none", "none", "add_to_que");
		OnChatNow("We've children and elderly housed there, but the Seekers are relentless, and would murder them, one and all.", "5.0", "convo_unarmed_panic", "none", "add_to_que");
	}

	// say_stronghold
	void OnSayStronghold()
	{
		OnChatNow("Grateful as I am for your assistance, I'm afraid I'm under an oath, and cannot be very specific about that.", "5.0", "convo_unarmed_norm", "clear_que", "add_to_que");
		OnChatNow("I can only go so far as to say that one entrance is nearby, and no, it is not inside this house.", "4.0", "none", "none", "add_to_que");
	}

	// say_detail
	void OnSayDetail()
	{
		OnChatNow("We're fairly close to the south side of The Wall...", "3.0", "convo_unarmed_norm", "clear_que", "add_to_que");
		OnChatNow("I'm afraid you can't pass beyond it, without going through it - which is quite dangerous, of course.", "5.0", "none", "none", "add_to_que");
		OnChatNow("Additionally, there are tribes of ice orcs, Marogar, wandering about, no doubt attempting to probe the fortresses for a safe path.", "5.0", "convo_unarmed_norm", "none", "add_to_que");
		OnChatNow("Oh! And there's also a giant ice construct, of some sort, wandering about the western lake!", "5.0", "convo_unarmed_panic", "none", "add_to_que");
		OnChatNow("However, it seems it will not accost you, provided you don't wander too close.", "5.0", "none", "none", "add_to_que");
		OnChatNow("No doubt, it's some ancient creation of a previous age, set to guard something that has long since sunk beneath the ice.", "5.0", "convo_unarmed_norm", "none", "add_to_que");
		OnChatNow("If you are unfortunate enough to accidentally gain the thing's attention, just keep running. It will tire of chasing you, eventually.", "5.0", "none", "none", "add_to_que");
	}

	// ext_bunny_comment
	void OnExtBunnyComment()
	{
		OnChatNow("Now... Where has my bunny Hazel run off to?", "5.0", "convo_unarmed_norm", "none", "add_to_que");
		PlaySound(0, 10, "scientist/cough.wav");
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("npc/elf_m_wizard.mdl");
		CallEventDelayed(10.0f, "TelfWin_Timer");
		CallEventDelayed(90.0f, "TelfWin_Timer2");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "do_spell_trick") { OnDoSpellTrick(); return true; }
		if (name == "ext_bunny_comment") { OnExtBunnyComment(); return true; }
		if (name == "game_menu_getoptions") { OnGameMenuGetoptions(PlayerParam(params, 0)); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "pre_glow") { OnPreGlow(); return true; }
		if (name == "say_detail") { OnSayDetail(); return true; }
		if (name == "say_hi") { OnSayHi(PlayerParam(params, 0)); return true; }
		if (name == "say_seeker") { OnSaySeeker(); return true; }
		if (name == "say_stronghold") { OnSayStronghold(); return true; }
		if (name == "win_speech") { OnWinSpeech(); return true; }
		if (name == "TelfWin_Timer") { TelfWin_Timer(); return true; }
		if (name == "TelfWin_Timer2") { TelfWin_Timer2(); return true; }
		return BaseChatArrayScript::DispatchEvent(name, params);
	}
}
