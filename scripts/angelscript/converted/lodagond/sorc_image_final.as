#pragma context server

// Converted from lodagond/sorc_image_final.script by msc_transpiler.

#include "runtime/ScriptEntity.as"

[script "lodagond/sorc_image_final"]
class SorcImageFinal : ScriptEntity
{
	// Constants
	string SOUND_TELE = "magic/teleport.wav";

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		SetModel("monsters/sorc.mdl");
		SetWidth(32);
		SetHeight(72);
		SetModelBody(0, 2); // body: 0=bare 1=bloody_shirt 2=gold_armor 3=archer
		SetModelBody(1, 3); // head: 0=hat_horns 1=hat_spiked 2=lizardskin_horned 3=gold_chieften 4=lizard_cap
		SetModelBody(2, 8); // weapon: 0=unarmed 1=axe 2=bow 3=steel_bow 4=sword 5=great_axe 6=sword_sheild 8=yellow_axe 9=blooddrinker

		SetNoPush(true);

		SetInvincible(true);
		SetRace("demon");

		SetName("Runegahr, Shadahar Orc Chieftain");

		SetSayTextRange(2048);

		SetMenuAutoOpen(true);

		CatchSpeech("say_hi", "hail", "hi", "hello", "wassup", "j0", "yo");
	}

	// say_hi
	void OnSayHi(CBasePlayer@ talkingPlayer = null)
	{
		SayText("I got something you want, human?");
		OpenMenu(EntityOf(ENT_LASTSPOKE));
	}

	// game_menu_getoptions
	void OnGameMenuGetoptions(CBasePlayer@ player = null)
	{
		MenuItem menuItem;
		menuItem.title = "Demand Reward";
		menuItem.type = "callback";
		menuItem.callback = "say_sword";
		RegisterMenuItem(menuItem);
	}

	// say_sword
	void OnSaySword(CBasePlayer@ target = null)
	{
		SayText("Since you were the first to have the guts to ask, here you are, as promised.");
		SetModelBody(2, 0);
		CallEventDelayed(4.0f, "say_sword2");
		Offer(target, "swords_blooddrinker");
	}

	// say_sword2
	void OnSaySword2()
	{
		SayText("Worry not, I have a spare back at the Palace... A couple spares, actually.");
		CallEventDelayed(4.0f, "say_sword3");
	}

	// say_sword3
	void OnSaySword3()
	{
		SayText("If you ever dare to step foot within the walls of the palace, be sure to find me.");
		CallEventDelayed(4.0f, "say_sword4");
	}

	// say_sword4
	void OnSaySword4()
	{
		SayText("You maybe lowly human's, but you've proven yourself mighty warriors all. Our doors are always open to true warriors.");
		CallEventDelayed(4.0f, "say_sword4b");
	}

	// say_sword4b
	void OnSaySword4b()
	{
		SayText("...and when you do visit us, be sure to show me that sword. All you human's look alike to me.");
		CallEventDelayed(4.0f, "say_sword5");
	}

	// say_sword5
	void OnSaySword5()
	{
		SayText("That having been said, I must leave before this citidel comes crashing down - I suggest you do the same.");
		CallEventDelayed(4.0f, "tele_out");
	}

	// tele_out
	void OnTeleOut()
	{
		SayText("Sorry I can't take you with me...");
		PlayAnim("once", "warcry");
		PlaySound(0, 10, SOUND_TELE);
		CreateNpc("monsters/summon/ibarrier", RelativePosition(Vector3(0, 0, 0)), self, 64, 2, 0, 0, 0, 1); // <owner> <rad> <duration> [invisible:0|1] [silent:0|1] [dmg] [push_allys:0|1]
		CallEventDelayed(0.1f, "fade_away");
	}

	// fade_away
	void OnFadeAway()
	{
		DeleteEntity(ENT_ME, "fade");
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/sorc.mdl");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "fade_away") { OnFadeAway(); return true; }
		if (name == "game_menu_getoptions") { OnGameMenuGetoptions(PlayerParam(params, 0)); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "say_hi") { OnSayHi(PlayerParam(params, 0)); return true; }
		if (name == "say_sword") { OnSaySword(PlayerParam(params, 0)); return true; }
		if (name == "say_sword2") { OnSaySword2(); return true; }
		if (name == "say_sword3") { OnSaySword3(); return true; }
		if (name == "say_sword4") { OnSaySword4(); return true; }
		if (name == "say_sword4b") { OnSaySword4b(); return true; }
		if (name == "say_sword5") { OnSaySword5(); return true; }
		if (name == "tele_out") { OnTeleOut(); return true; }
		return false;
	}
}
