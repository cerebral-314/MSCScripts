#pragma context server

// Converted from hall_of_deralia/king_of_deralia.script by msc_transpiler.
// hall of deralia idears
// -
// - daughter kidnapped by cursed jester
// -- accepting job spawns jester and daughter in basement
// - Maldora pays a visit
// -- guards should be able to handle the minions he leaves behind
// - Smith with smithing guide (tga pages)
// -- should have some formula's he can do without new items
// -- also should sell some spec materials for bunk prices
// -- add said materials to the random treasure lists
// - Brewer with some potions for sale that give short-lived bonuses such as
// -- speed, resist fire, resist cold, fire breath
// - Title master
// -- atm does nothing, later offers some advanced title
// - Noble Title Master
// -- Same difference, more advanced titles
// - Necromancer in basement
// -- Appears after jester is killed, offers potions, titles, pets
// - cover cross in chapel with portal to throne room
// - Add portal to deralia_dungeons
// - Add random nobles and guards
// - add a dwarven and elven embassador with quests (letters) for gatecity and findlebind

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_chat.as"

[script "hall_of_deralia/king_of_deralia"]
class KingOfDeralia : BaseChatScript
{
	// Constants
	float FREQ_MOURN = 0.0f;
	bool NO_RUMOR = true;
	bool NO_HAIL = true;
	bool NO_JOB = true;
	string KING_MODEL = "npc/king.mdl";

	// Variables (an unset .script variable reads as its own name)
	bool IN_MOURNING = false;
	CBaseEntity@ GUARD1_ID = null;
	CBaseEntity@ GUARD2_ID = null;
	CBaseEntity@ CURRENT_SPEAKER = null;

	// Variables declared by included files, with the value they start with in this script
	KingOfDeralia()
	{
		CHAT_DELAY = 5.0f;
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseChat_OnGameSpawn(playerRace, playerGender); // monsters/base_chat

		SetUniqueName("da_king");

		SetName("The King of Deralia"); // bugger needs a name, check with Lanethan
		SetHealth(1);
		SetInvincible(true); // it's good to be the king ^_^
		SetModel(KING_MODEL);
		SetWidth(32);
		SetHeight(96);
		SetSayTextRange(640);
		SetIdleAnim("idle1");
		PlayAnim("once", "idle1");

		CatchSpeech("say_hi", "hail", "j0", "wassup", "greet", "hello", "waddup", "daughter", "princess");

		CallEventDelayed(5.0f, "get_guard_id"); // give time for guards to spawn

		IN_MOURNING = true;
		CallEventDelayed(FREQ_MOURN, "do_mourn");
	}

	// game_menu_getoptions
	void OnGameMenuGetoptions(CBasePlayer@ player = null)
	{
		BaseChat_OnGameMenuGetoptions(player); // monsters/base_chat
		MenuItem menuItem;

		menuItem.title = "Hail";
		menuItem.type = "callback";
		menuItem.callback = "say_hi";
		RegisterMenuItem(menuItem);
	}

	// get_guard_id
	void OnGetGuardId()
	{
		@GUARD1_ID = FindByName("king_guard1");
		@GUARD2_ID = FindByName("king_guard2");
	}

	// do_mourn
	void OnDoMourn()
	{
		CallEventDelayed(FREQ_MOURN, "do_mourn");
		if (BUSY_CHATTING)
			return;

		int rndMourn = RandomInt(1, 3);
		if (rndMourn == 1)
		{
			SayText("Oh woe is me! My princess is lost!");
			CallExternal(GUARD1_ID, "ext_comfort_king"); // random comfort line and anim
		}

		if (rndMourn == 2)
		{
			SayText("My precious daughter! Where for art thou!");
			CallExternal(GUARD2_ID, "ext_comfort_king"); // random comfort line and anim
		}

		if (rndMourn == 3)
			SayText("Gone is my reason for living! Missing is my beloved daughter!");
	}

	// say_hi
	void OnSayHi(CBasePlayer@ talkingPlayer = null)
	{
		if (BUSY_CHATTING)
			return;
		BUSY_CHATTING = true;
		if (IsPlayer(talkingPlayer))
		{
			@CURRENT_SPEAKER = talkingPlayer;
			OnFaceSpeaker(EntityId(CURRENT_SPEAKER));
		}
		if (IsPlayer(ENT_LASTSPOKE))
		{
			@CURRENT_SPEAKER = EntityOf(ENT_LASTSPOKE);
			OnFaceSpeaker(EntityId(CURRENT_SPEAKER));
		}

		BUSY_CHATTING = true;
		CallExternal(GUARD1_ID, "ext_warn_address", @CURRENT_SPEAKER); // face player: "How dare you address the king directly!"
		CallEventDelayed(CHAT_DELAY, "say_daughter1");
	}

	// say_daughter1
	void OnSayDaughter1()
	{
		// make this work by gender - check gender $get lookup in MSC++
		SayText("No! No... It's alright, he looks as though he maybe able to help.");
		CallEventDelayed(CHAT_DELAY, "say_daughter2");
	}

	// say_daughter2
	void OnSayDaughter2()
	{
		PlayAnim("critical", "fear");
		SayText("The jester! You understand!? He's gone mad! He's kidnapped my beautiful young daughter!");
		CallEventDelayed(CHAT_DELAY, "say_daughter3");
	}

	// say_daughter3
	void OnSayDaughter3()
	{
		SayText("They say he was seen scurrying off to the dungeons! But these fools won't go after him!");
		CallEventDelayed(10.0f, "say_daughter4");
		CallExternal(GUARD1_ID, "ext_sworn"); // We are sworn to stay by your side at all times.
	}

	// say_daughter4
	void OnSayDaughter4()
	{
		SayText("...And I can't go down into the dungeons, why!?");
		PlayAnim("critical", "ANIM_PLEADE");
		CallExternal(GUARD2_ID, "ext_no_place_for"); // The dungeons are no place for a king!
		SetMoveDest(@GUARD2_ID, 9999);
		CallEventDelayed(10.0f, "say_daughter5");
	}

	// say_daughter5
	void OnSayDaughter5()
	{
		PlayAnim("critical", "ANIM_ANGRY");
		OnFaceSpeaker(EntityId(CURRENT_SPEAKER));
		SayText("See these useless fools I am surrounded by!?");
		CallEventDelayed(CHAT_DELAY, "say_daughter6");
	}

	// say_daughter6
	void OnSayDaughter6()
	{
		SayText("Captain Agarath could be trusted with the job, but he's not here, and won't be back for weeks.");
		// This is in reference to the Gloam Slayer
		CallEventDelayed(CHAT_DELAY, "say_daughter7");
	}

	// say_daughter7
	void OnSayDaughter7()
	{
		PlayAnim("critical", "ANIM_CRY");
		SayText("Please, for pity's sake, rescue my daughter from that madman!");
		CallEventDelayed(10.0f, "resume_morning");
	}

	// resume_morning
	void OnResumeMorning()
	{
		BUSY_CHATTING = false;
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files
	void OnChatDelay() {} // CHAT_DELAY
	void OnFreqMourn() {} // FREQ_MOURN

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("npc/king.mdl");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "do_mourn") { OnDoMourn(); return true; }
		if (name == "game_menu_getoptions") { OnGameMenuGetoptions(PlayerParam(params, 0)); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "get_guard_id") { OnGetGuardId(); return true; }
		if (name == "resume_morning") { OnResumeMorning(); return true; }
		if (name == "say_daughter1") { OnSayDaughter1(); return true; }
		if (name == "say_daughter2") { OnSayDaughter2(); return true; }
		if (name == "say_daughter3") { OnSayDaughter3(); return true; }
		if (name == "say_daughter4") { OnSayDaughter4(); return true; }
		if (name == "say_daughter5") { OnSayDaughter5(); return true; }
		if (name == "say_daughter6") { OnSayDaughter6(); return true; }
		if (name == "say_daughter7") { OnSayDaughter7(); return true; }
		if (name == "say_hi") { OnSayHi(PlayerParam(params, 0)); return true; }
		return BaseChatScript::DispatchEvent(name, params);
	}
}
