#pragma context server

// Converted from old_helena/dr_who1.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_npc_vendor.as"

[script "old_helena/dr_who1"]
class DrWho1 : BaseNpcVendorScript
{
	// Constants
	bool NO_JOB = true;
	bool NO_RUMOR = true;
	float CHAT_DELAY = 4.0f;
	bool VEND_INDIVIDUAL = true;

	// Variables (an unset .script variable reads as its own name)
	bool VENDOR_NOT_ON_USE = false;
	int DID_INTRO = 0;
	int CHAT_STEPS = 0;
	float CHAT_STEP = 0.0f;
	bool BUSY_CHATTING = false;
	string CHAT_STEP1 = "CHAT_STEP1";
	string CHAT_STEP2 = "CHAT_STEP2";
	string ANIM_STEP2 = "ANIM_STEP2";
	string CHAT_STEP3 = "CHAT_STEP3";
	string CHAT_STEP4 = "CHAT_STEP4";
	bool NO_HAIL = false;
	bool VENDOR_MENU_OFF = false;
	bool DOING_VOTE = false;
	float TALLY_VOTES = 0.0f;
	float TALLY_YES_VOTES = 0.0f;
	float TALLY_NO_VOTES = 0.0f;
	string ANIM_STEP3 = "ANIM_STEP3";
	int STORE_CLOSED = 0;
	bool NO_TALKIE = false;

	// Variables declared by included files, with the value they start with in this script
	DrWho1()
	{
		STORE_NAME = "tom_bakers_shop";
	}

	// unnamed block (first think)
	void DrWho1_FirstThink()
	{
		STORE_NAME = "tom_bakers_shop";
		VENDOR_NOT_ON_USE = true;
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseNpcVendor_OnGameSpawn(playerRace, playerGender); // monsters/base_npc_vendor
		SetName("Torwhodoc Sa'thraz, Keeper of Time");
		SetHealth(1);
		SetInvincible(true);
		SetRace("human");
		SetRoam(false);
		SetModel("npc/balancepriest2.mdl"); // need new wizard
		SetWidth(32);
		SetHeight(72);
		SetBoundingBox("npcsize");

		SetIdleAnim("idle1");

		SetSayTextRange(512);

		CatchSpeech("say_hi", "hail", "hi", "howdy", "hello", "greet", "gweet", "j0", "waddup", "wassup");
		CatchSpeech("start_helena_vote", "helena", "back", "future");

		SetMenuAutoOpen(true);

		CallEventDelayed(1.0f, "scan_for_ally");
	}

	// game_menu_getoptions
	void OnGameMenuGetoptions(CBasePlayer@ player = null)
	{
		BaseNpcVendor_OnGameMenuGetoptions(player); // monsters/base_npc_vendor
		MenuItem menuItem;

		if (NO_TALKIE)
			return;

		if (!DOING_VOTE)
		{
			menuItem.title = "Return to the Future";
			menuItem.type = "callback";
			menuItem.callback = "start_helena_vote";
			RegisterMenuItem(menuItem);
		}

		if (DOING_VOTE)
		{
			menuItem.title = "VOTE: Return to the Future?";
			menuItem.type = "disabled";
			RegisterMenuItem(menuItem);

			menuItem.title = "Yes!";
			menuItem.type = "callback";
			menuItem.callback = "wtf_vote_yes";
			RegisterMenuItem(menuItem);

			menuItem.title = "No!";
			menuItem.type = "callback";
			menuItem.callback = "wtf_vote_no";
			RegisterMenuItem(menuItem);
		}
	}

	// scan_for_ally
	void OnScanForAlly()
	{
		if (DID_INTRO != 0)
			return;
		CallEventDelayed(2.0f, "scan_for_ally");
		if (!CanSee("ally"))
			return;
		if (!(RangeTo(ENT_LASTSEEN) < 512.0f))
			return;
		DID_INTRO = 1;
		OnSayHi();
	}

	// say_hi
	void OnSayHi(CBasePlayer@ talkingPlayer = null)
	{
		if (BUSY_CHATTING)
			return;

		CHAT_STEPS = 4;
		CHAT_STEP = 0.0f;
		BUSY_CHATTING = true;
		CHAT_STEP1 = "Excellent work! Gave those orcs what for, you did! Just like last time!";
		CHAT_STEP2 = "...although, not like that one other time, but, that's no longer an issue, I suppose.";
		ANIM_STEP2 = "lean";
		CHAT_STEP3 = "In anycase, I've those items I told you about, for that fee I told you about. Feel free to pick!";
		CHAT_STEP4 = "When you're ready to go back to the fut... [Helena], just say so.";
		OnChatLoop();
	}

	// payment_failed
	void OnPaymentFailed()
	{
		PlayAnim("critical", "no");
		SayText("Come now, the last of the time wizards deserves better food than that will buy.");
	}

	// vendor_addstoreitems
	void OnVendorAddstoreitems()
	{
		// dstoreitem STORE_NAME item				|#|	|cost%|	|Sellx| |Bundle amt|
		AddStoreItem(STORE_NAME, "mana_forget", 2, 100, 0.0f);
		AddStoreItem(STORE_NAME, "mana_speed", 1, 100, 0.0f);
		AddStoreItem(STORE_NAME, "mana_gprotection", 1, 100, 0.0f);
		AddStoreItem(STORE_NAME, "mana_protection", 1, 100, 0.0f);
		AddStoreItem(STORE_NAME, "mana_resist_cold", 1, 100, 0.0f);
		AddStoreItem(STORE_NAME, "mana_immune_cold", 1, 100, 0.0f);
		AddStoreItem(STORE_NAME, "mana_resist_fire", 1, 100, 0.0f);
		AddStoreItem(STORE_NAME, "mana_immune_fire", 1, 100, 0.0f);
		AddStoreItem(STORE_NAME, "mana_immune_poison", 1, 100, 0.0f);
		AddStoreItem(STORE_NAME, "mana_demon_blood", 1, 100, 0.0f);
		AddStoreItem(STORE_NAME, "mana_vampire", 1, 100, 0.0f);
		AddStoreItem(STORE_NAME, "mana_prot_spiders", 1, 100, 0.0f);
	}

	// start_helena_vote
	void OnStartHelenaVote()
	{
		// if ( game.players == 1 ) changelevel helena
		// if game.players > 1
		NO_HAIL = true;
		VENDOR_MENU_OFF = true;
		SetVar("PLAYER_LIST", GetActivePlayers());
		DOING_VOTE = true;
		SayText("Just a moment, while we get a consensus amongst our heros.");
		TALLY_VOTES = 0.0f;
		TALLY_YES_VOTES = 0.0f;
		TALLY_NO_VOTES = 0.0f;
		CallEventDelayed(3.0f, "zomg_stupid_error");
	}

	// zomg_stupid_error
	void OnZomgStupidError()
	{
		int count = GetTokenCount("PLAYER_LIST");
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnWtfAskPlayers();
		}
		float wtfVoteDelay = 10.0f;
		if (PlayerCount() > 1)
			wtfVoteDelay = 20.0f;
		CallEventDelayed(wtfVoteDelay, "wtf_count_votes");
	}

	// wtf_ask_players
	void OnWtfAskPlayers()
	{
		string curPlayer = GetToken("PLAYER_LIST", loopIteration);
		OpenMenu(curPlayer);
	}

	// wtf_vote_yes
	void OnWtfVoteYes(CBasePlayer@ player = null)
	{
		DebugPrint(NameOf(player) + " voted yes");

		TALLY_YES_VOTES += 1.0f;
		TALLY_VOTES += 1.0f;
		PlayAnim("critical", "yes");
		SayText(NameOf(player) + " seems ready to go.");
	}

	// wtf_vote_no
	void OnWtfVoteNo(CBasePlayer@ player = null)
	{
		DebugPrint(NameOf(player) + " voted no");

		TALLY_NO_VOTES += 1.0f;
		TALLY_VOTES += 1.0f;
		PlayAnim("critical", "no");
		SayText(NameOf(player) + " seems to still be shopping, or... Looting corpses.");
	}

	// wtf_count_votes
	void OnWtfCountVotes()
	{
		bool wtfVoteFail = false;

		if (TALLY_NO_VOTES > 0.0f)
			wtfVoteFail = true;
		if (TALLY_VOTES == 0.0f)
			wtfVoteFail = true;
		if ((wtfVoteFail ? 1 : 0) == 1)
		{
			NO_HAIL = false;
			VENDOR_MENU_OFF = false;
			DOING_VOTE = false;

			CHAT_STEPS = 3;
			CHAT_STEP = 0.0f;
			BUSY_CHATTING = true;
			CHAT_STEP1 = "Seems some people want to look around before we leave.";
			CHAT_STEP2 = "It's not a problem. The temporal stasus feild prevents you from interfering with events beyond this area.";
			CHAT_STEP3 = "So it's not as if you can get into any real trouble... This time.";
			ANIM_STEP3 = "lean";
			OnChatLoop();
		}

		if ((wtfVoteFail ? 1 : 0) != 0)
			return;
		STORE_CLOSED = 1;
		NO_HAIL = true;
		VENDOR_MENU_OFF = true;

		SetSayTextRange(9999);
		CHAT_STEPS = 3;
		CHAT_STEP = 0.0f;
		BUSY_CHATTING = true;
		CHAT_STEP1 = "Alright, get into the blue box and hold onto your hats! We're going home!";
		CHAT_STEP2 = "It's an old type 40 I just borrowed... Give it a bit to warm up.";
		CHAT_STEP3 = "Kick that flux capacitor over there and we'll be on our way.";
		OnChatLoop();

		PlayAnim("critical", "studycart");
		NO_TALKIE = true;
		UseTrigger("engine_tardis");

		CallEventDelayed(4.0f, "amx_mapchange");
		CallEventDelayed(10.0f, "manual_mapchange");
	}

	// amx_mapchange
	void OnAmxMapchange()
	{
		UseTrigger("force_map_helena");
	}

	// manual_mapchange
	void OnManualMapchange()
	{
		CallExternal(GetVar("GAME_MASTER"), "gm_manual_map_change", "helena");
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files
	void OnWtfVoteDelay() {} // WTF_VOTE_DELAY
	void OnChatLoop() {} // chat_loop

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("npc/balancepriest2.mdl");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		DrWho1_FirstThink();
		BaseNpcVendor_FirstThink();
		BaseNpcVendor_FirstThink2();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "amx_mapchange") { OnAmxMapchange(); return true; }
		if (name == "game_menu_getoptions") { OnGameMenuGetoptions(PlayerParam(params, 0)); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "manual_mapchange") { OnManualMapchange(); return true; }
		if (name == "payment_failed") { OnPaymentFailed(); return true; }
		if (name == "say_hi") { OnSayHi(PlayerParam(params, 0)); return true; }
		if (name == "scan_for_ally") { OnScanForAlly(); return true; }
		if (name == "start_helena_vote") { OnStartHelenaVote(); return true; }
		if (name == "vendor_addstoreitems") { OnVendorAddstoreitems(); return true; }
		if (name == "wtf_ask_players") { OnWtfAskPlayers(); return true; }
		if (name == "wtf_count_votes") { OnWtfCountVotes(); return true; }
		if (name == "wtf_vote_no") { OnWtfVoteNo(PlayerParam(params, 0)); return true; }
		if (name == "wtf_vote_yes") { OnWtfVoteYes(PlayerParam(params, 0)); return true; }
		if (name == "zomg_stupid_error") { OnZomgStupidError(); return true; }
		return BaseNpcVendorScript::DispatchEvent(name, params);
	}
}
