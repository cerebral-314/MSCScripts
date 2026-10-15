#pragma context server

// Converted from old_helena/serrold.script by msc_transpiler.
// Thothie - for compatability - from old beta scripts
// Spawn properties

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_chat.as"
#include "converted/monsters/base_npc.as"
#include "converted/old_helena/base_old_helena_npc.as"

[script "old_helena/serrold"]
class OldHelenaSerrold : BaseNpcScript, BaseChat, BaseOldHelenaNpc
{
	// Constants
	bool NO_JOB = true;
	Vector3 PREF_LOCATION = Vector3();

	// Variables (an unset .script variable reads as its own name)
	bool INN_CLOSED = false;
	bool SEE_ENEMY = false;
	bool CAN_SCREAM = true;
	bool CAN_RUN = true;
	bool GAVE_MONEY = false;
	bool DID_GREET = false;
	bool RETURN_PREF = false;
	bool HELENA_SAVED = false;
	bool GAVE_REWARD = false;
	bool DID_CATAPULT_COMMENT = false;

	// unnamed block (timer)
	// Thothie - these bits use old conventions that no longer function
	// ///////////////////////////////////////////////////////////////////////////////////////////////
	// {
	// eventname robbed
	// playanim once beatdoor
	// }
	// {
	// eventname recvoffer_gold
	// callevent recv_enoughgold
	// callevent recv_notenoughgold
	// }
	// {
	// eventname recv_enoughgold
	// var OFFER_AMT >= 100
	// DLLFunc recvoffer accept
	// saytext I know Harry knows something...
	// playanim once yes
	// }
	// {
	// eventname recv_notenoughgold
	// var OFFER_AMT < 100
	// DLLFunc recvoffer reject
	// saytext I am quite well off without your charity.
	// playanim once no
	// }
	// -------------------------------------------------------------
	// Flee from monsters
	// -------------------------------------------------------------
	// {
	// repeatdelay 0.2
	// see enemy 300
	// if SEE_ENEMY equals 0
	// callevent flee
	// callevent shiver
	// callevent scream
	// }
	// {
	// eventname flee
	// if CAN_RUN equals 1
	// setmoveanim run1
	// setmovedest flee ent_lastseen 128
	// setvar SEE_ENEMY 1
	// setvar CAN_RUN 1
	// calleventtimed $rand(0,4) resetflee
	// }
	// {
	// eventname shiver
	// playanim once crouch_idle3
	// if CAN_SCREAM equals 1
	// volume 8
	// playsound 1 player/fallpain4.wav
	// //say *[100]
	// calleventtimed 2 flee
	// }
	// {
	// eventname stopmoving
	// if SEE_ENEMY equals 1
	// setvar SEE_ENEMY 0
	// }
	// {
	// eventname scream
	// if CAN_SCREAM equals 1
	// volume 8
	// playrandomsound 2 scientist/scream07.wav scientist/scream10.wav scientist/scream12.wav scientist/scream13.wav
	// setvar CAN_SCREAM 0
	// //say *[200]
	// calleventtimed $rand(2,6) resetscream
	// }
	// {
	// eventname resetscream
	// setvar CAN_SCREAM 1
	// }
	// {
	// eventname resetflee
	// setvar CAN_RUN 1
	// }
	// {
	// eventname struck
	// roam 1
	// volume 8
	// playsound 1 player/fallpain4.wav
	// callevent flee
	// }
	// {
	// eventname parry
	// playanim once flinch
	// callevent flee
	// }
	void OldHelenaSerrold_Timer()
	{
		CallEventDelayed(20.0f, "OldHelenaSerrold_Timer");

		if (!DID_GREET && CanSee("player"))
		{
			SetMoveDest(ENT_LASTSEEN, 30);
			CallEventDelayed(1.0f, "greet_players");
		}

		if (!RETURN_PREF)
			return;
		if (HELENA_SAVED)
			return;
		DebugPrint("moving to " + Text(PREF_LOCATION));
		SetMoveAnim("run1");
		SetIdleAnim("crouch_idle");
		SetMoveDest(PREF_LOCATION, 10);
	}

	// game_menu_getoptions
	void OnGameMenuGetoptions(CBasePlayer@ player = null)
	{
		BaseChat_OnGameMenuGetoptions(player); // monsters/base_chat
		MenuItem menuItem;

		if (!HELENA_SAVED)
			return;
		if (GAVE_REWARD)
			return;

		menuItem.title = "Hail";
		menuItem.type = "callback";
		menuItem.callback = "give_reward";
		RegisterMenuItem(menuItem);
	}

	// say_rumor
	void OnSayRumor(CBasePlayer@ talkingPlayer = null)
	{
		BaseChat_OnSayRumor(talkingPlayer); // monsters/base_chat
		if (HELENA_SAVED)
			return;
		PlayAnim("once", "idle3");
		SayText("[Dorfgan], [Erkold], and myself are the only ones who can run this village! If we all die, the village will die with us!");
	}

	// game_postspawn
	void OnGamePostspawn(string title = "", string damageMultiplier = "", string healthMultiplier = "", string params = "")
	{
		BaseSelfAdjust_OnGamePostspawn(title, damageMultiplier, healthMultiplier, params); // monsters/base_self_adjust
		BaseNpc_OnGamePostspawn(title, damageMultiplier, healthMultiplier, params); // monsters/base_npc
		SetGlobal("G_SIEGE_MAP", 1);
		SetGlobal("G_NPC_REMAIN", 5);
	}

	// old_helena_warboss_died
	// Add winning items
	// Add winning items
	void OnOldHelenaWarbossDied()
	{
		BaseOldHelenaNpc_OnOldHelenaWarbossDied(); // old_helena/base_old_helena_npc

		SetMenuAutoOpen(true);
		HELENA_SAVED = true;
		SetIdleAnim("idle1");
	}

	// spawn
	void OnSpawn()
	{
		// eventname MUST be the first field!
		SetHealth(800);
		SetGold(2);
		SetName("Serrold");
		// ov 360
		SetWidth(32);
		SetHeight(72);
		SetRace("human");
		SetRoam(false); // Don't go roaming around
		SetModel("npc/human1.mdl");
		SetModelBody(1, 0);
		INN_CLOSED = false;
		SEE_ENEMY = false;
		CAN_SCREAM = true;
		CAN_RUN = true;
		GAVE_MONEY = false;

		CatchSpeech("say_hi", "hi");
		CatchSpeech("say_hi", "hello");
		CatchSpeech("say_hi", "hail");
		CatchSpeech("say_hi", "greet");

		CatchSpeech("say_orcs", "orcs");
		CatchSpeech("say_rumor", "people");
		CatchSpeech("say_dorfgan", "dorfgan");
		CatchSpeech("say_erkold", "erkold");
		CatchSpeech("say_serrold", "serrold");
		CatchSpeech("say_harry", "harry");

		// catchspeech say_innopen open
		// catchspeech say_innopen hole
		CatchSpeech("say_thanks", "ok");
		CatchSpeech("say_thanks", "okay");
		CatchSpeech("say_thanks", "sure");
	}

	// greet_players
	void OnGreetPlayers()
	{
		DID_GREET = true;

		SetVolume(10);
		CallEventDelayed(0.1f, "bchat_mouth_move");
		CallEventDelayed(1.0f, "bchat_mouth_move");
		CallEventDelayed(4.0f, "bchat_mouth_move");
		CallEventDelayed(6.0f, "bchat_mouth_move");
		CallEventDelayed(8.0f, "bchat_mouth_move");
		CallEventDelayed(10.0f, "goto_pref");
		CallEventDelayed(5.0f, "map_go");
	}

	// map_go
	void OnMapGo()
	{
		UseTrigger("MSmm");
	}

	// goto_pref
	void OnGotoPref()
	{
		RETURN_PREF = true;
		SetMoveAnim("run1");
		SetIdleAnim("crouch_idle");
		CallEventDelayed(20.0f, "tele_pref"); // teleport to def loc, if can't get there in 20 seconds (prevents sploits)
	}

	// talksound1
	void OnTalksound1()
	{
		PlaySound(0, 10, "npc/oldvillager1.wav");
	}

	// say_hi
	void OnSayHi(CBasePlayer@ talkingPlayer = null)
	{
		if (HELENA_SAVED)
			return;

		PlayAnim("once", "panic");
		SayText("Please help our town! The [orcs] are attacking!");
		CallEventDelayed(0.0f, "2");
	}

	// say_hi2
	void OnSayHi2()
	{
		SayText("Even if we survive the attack, we still need [people] to keep order in the town!");
	}

	// say_orcs
	void OnSayOrcs()
	{
		PlayAnim("once", "fear1");
		SayText("Evil creatures spawned from hell!");
	}

	// say_dorfgan
	void OnSayDorfgan()
	{
		PlayAnim("once", "yes");
		SayText("The blacksmith. He is a good man, not even in times like this does he stop forgeing!");
	}

	// say_erkold
	void OnSayErkold()
	{
		PlayAnim("once", "yes");
		SayText("The man at the burnt down house. He and his family used to supply the village with food, but I am not sure how it will go now when the family has been kidnapped..");
	}

	// say_serrold
	void OnSaySerrold()
	{
		PlayAnim("once", "yes");
		SayText("I am Serrold, the town elder.");
	}

	// say_harry
	void OnSayHarry()
	{
		PlayAnim("once", "no");
		SayText("That man is good for nothing. I closed down his Inn but I still get the feeling that something is going on in there..");
	}

	// say_thanks
	// Thothie - the town's under siege - what does Serrold care if Harry is violating Prohibition!?
	// {
	// eventname say_innopen
	// var INN_CLOSED equals 0
	// if GAVE_GOLD equals 0
	// playanim once no
	// saytext What! He opened it up again! Well.. I guess I can't stop him. Here's some gold for telling me.
	// setvar GAVE_GOLD 1
	// offer ent_lastspoke gold $rand(1,3)
	// //Not a huge amount since people can just rezone and tell him over and over again
	// }
	void OnSayThanks()
	{
		PlayAnim("once", "yes");
		SayText("Thank you! Now go out and kick some green butt!");
	}

	// give_reward
	void OnGiveReward(CBasePlayer@ player = null)
	{
		if (GAVE_REWARD)
		{
			PlayAnim("critical", "lean");
			OnBchatMouthMove();
			SayText("I wish I had more to give, but I'll need what's left to help rebuild the town.");
		}

		if (GAVE_REWARD)
			return;
		GAVE_REWARD = true;
		OnBchatMouthMove();
		SayText("I can't believe it! You saved us! Take this as a reward!");
		Offer(player, "pack_boh_lesser");
	}

	// catapults_fire
	void OnCatapultsFire()
	{
		if (!DID_CATAPULT_COMMENT)
			return;
		DID_CATAPULT_COMMENT = true;
		SayText("By the gods! They've brought siege weapons!");
	}

	// game_reached_dest
	void OnGameReachedDest()
	{
		SetAngle("face", Vector3(0, 90, 0));
	}

	// tele_pref
	void OnTelePref()
	{
		SetOrigin(ENT_ME, PREF_LOCATION);
		SetIdleAnim("crouch_idle");
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseChat_OnGameSpawn(playerRace, playerGender); // monsters/base_chat
		BaseNpc_OnGameSpawn(playerRace, playerGender); // monsters/base_npc
		BaseOldHelenaNpc_OnGameSpawn(playerRace, playerGender); // old_helena/base_old_helena_npc
	}

	// game_death
	void OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		DqMonsterExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // dq/externals/dq_monster_externals
		MonstersExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/externals
		BaseSelfAdjust_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_self_adjust
		BaseNpc_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseOldHelenaNpc_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // old_helena/base_old_helena_npc
	}

	// game_struck
	void OnGameStruck(float damage = 0.0f, string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		BaseNpc_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseOldHelenaNpc_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // old_helena/base_old_helena_npc
	}

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("npc/human1.mdl");
		CallEventDelayed(20.0f, "OldHelenaSerrold_Timer");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		BaseChat_FirstThink();
		BaseNpc_FirstThink();
		MonstersExternals_FirstThink();
		BaseOldHelenaNpc_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "catapults_fire") { OnCatapultsFire(); return true; }
		if (name == "game_menu_getoptions") { OnGameMenuGetoptions(PlayerParam(params, 0)); return true; }
		if (name == "game_postspawn") { OnGamePostspawn(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_reached_dest") { OnGameReachedDest(); return true; }
		if (name == "give_reward") { OnGiveReward(PlayerParam(params, 0)); return true; }
		if (name == "goto_pref") { OnGotoPref(); return true; }
		if (name == "greet_players") { OnGreetPlayers(); return true; }
		if (name == "map_go") { OnMapGo(); return true; }
		if (name == "old_helena_warboss_died") { OnOldHelenaWarbossDied(); return true; }
		if (name == "say_dorfgan") { OnSayDorfgan(); return true; }
		if (name == "say_erkold") { OnSayErkold(); return true; }
		if (name == "say_harry") { OnSayHarry(); return true; }
		if (name == "say_hi") { OnSayHi(PlayerParam(params, 0)); return true; }
		if (name == "say_hi2") { OnSayHi2(); return true; }
		if (name == "say_orcs") { OnSayOrcs(); return true; }
		if (name == "say_rumor") { OnSayRumor(PlayerParam(params, 0)); return true; }
		if (name == "say_serrold") { OnSaySerrold(); return true; }
		if (name == "say_thanks") { OnSayThanks(); return true; }
		if (name == "spawn") { OnSpawn(); return true; }
		if (name == "talksound1") { OnTalksound1(); return true; }
		if (name == "tele_pref") { OnTelePref(); return true; }
		if (name == "OldHelenaSerrold_Timer") { OldHelenaSerrold_Timer(); return true; }
		return BaseChat_DispatchEvent(name, params)
			|| BaseOldHelenaNpc_DispatchEvent(name, params)
			|| BaseNpcScript::DispatchEvent(name, params);
	}
}
