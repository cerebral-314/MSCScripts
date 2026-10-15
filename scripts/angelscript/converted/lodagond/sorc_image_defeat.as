#pragma context server

// Converted from lodagond/sorc_image_defeat.script by msc_transpiler.

#include "runtime/ScriptEntity.as"

[script "lodagond/sorc_image_defeat"]
class SorcImageDefeat : ScriptEntity
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

		SetHearingSensitivity(11);

		SetName("Runegahr, Shadahar Orc Chieftain");

		SetSayTextRange(2048);

		SetMenuAutoOpen(true);

		CatchSpeech("say_hi", "hail", "hi", "hello", "wassup", "j0", "yo");
		CatchSpeech("offer_accepted", "yes", "accept");
		CatchSpeech("offer_denied", "no", "die");

		CallEventDelayed(0.1f, "say_stop");
	}

	// game_heardsound
	void OnGameHeardsound(string soundType = "", Vector3 origin = Vector3(), float dangerRadius = 0.0f)
	{
		CBaseEntity@ lastHeard = EntityOf(ENT_LASTHEARD);
		if (!IsPlayer(lastHeard))
			return;
		SetMoveDest(@lastHeard, 9999);
	}

	// say_hi
	void OnSayHi(CBasePlayer@ talkingPlayer = null)
	{
		OnSayStop();
		OpenMenu(EntityOf(ENT_LASTSPOKE));
	}

	// say_stop
	void OnSayStop()
	{
		SayText("ENOUGH! Maybe you aren't the pathetic creatures I took you for...");
		CallEventDelayed(4.0f, "say_stop2");
	}

	// say_stop2
	void OnSayStop2()
	{
		SayText("However, defeating me alone is not enough to prove yourselves worthy of alliance.");
		CallEventDelayed(4.0f, "say_stop3");
	}

	// say_stop3
	void OnSayStop3()
	{
		SayText("For humans are treacherous, and fall easily to temptation and despair.");
		CallEventDelayed(4.0f, "say_stop4");
	}

	// say_stop4
	void OnSayStop4()
	{
		SayText("If you can reach Maldora's lair, at the heart of Lodagond, I swear upon this sword, that I will join you and aid in his defeat!");
		CallEventDelayed(4.0f, "say_stop5");
	}

	// say_stop5
	void OnSayStop5()
	{
		SayText("Do you [accept] this offer? Or would you rather [die] at my hand here and now?");
	}

	// game_menu_getoptions
	void OnGameMenuGetoptions(CBasePlayer@ player = null)
	{
		MenuItem menuItem;
		menuItem.title = "I accept.";
		menuItem.type = "callback";
		menuItem.callback = "offer_accepted";
		RegisterMenuItem(menuItem);

		menuItem.title = "Die evil orc!";
		menuItem.type = "callback";
		menuItem.callback = "offer_denied";
		RegisterMenuItem(menuItem);
	}

	// offer_accepted
	void OnOfferAccepted()
	{
		PlaySound(0, 10, SOUND_TELE);
		CreateNpc("monsters/summon/ibarrier", RelativePosition(Vector3(0, 0, 0)), self, 64, 2, 0, 0, 0, 1); // <owner> <rad> <duration> [invisible:0|1] [silent:0|1] [dmg] [push_allys:0|1]
		SayText("Very well. When the time comes, I will be there, and in exchange for your aid, I will give one of you this sword.");
		PlayAnim("critical", "warcry");
		CallEventDelayed(1.0f, "do_fadeout");
		SetGlobal("G_SHAD_ORC", 1);
	}

	// offer_denied
	void OnOfferDenied()
	{
		PlaySound(0, 10, SOUND_TELE);
		CreateNpc("monsters/summon/ibarrier", RelativePosition(Vector3(0, 0, 0)), self, 64, 2, 0, 0, 0, 1); // <owner> <rad> <duration> [invisible:0|1] [silent:0|1] [dmg] [push_allys:0|1]
		PlayAnim("critical", "warcry");
		SayText("Impudent fools! You stand no chance against the charlatan without my help. So be it, die at his hands - you'll wish you'd done so at mine.");
		CallEventDelayed(1.0f, "do_fadeout");
		SetGlobal("G_SHAD_ORC", 0);
	}

	// do_fadeout
	void OnDoFadeout()
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
		if (name == "do_fadeout") { OnDoFadeout(); return true; }
		if (name == "game_heardsound") { OnGameHeardsound(Param(params, 0), Vec(Param(params, 1)), Float(Param(params, 2))); return true; }
		if (name == "game_menu_getoptions") { OnGameMenuGetoptions(PlayerParam(params, 0)); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "offer_accepted") { OnOfferAccepted(); return true; }
		if (name == "offer_denied") { OnOfferDenied(); return true; }
		if (name == "say_hi") { OnSayHi(PlayerParam(params, 0)); return true; }
		if (name == "say_stop") { OnSayStop(); return true; }
		if (name == "say_stop2") { OnSayStop2(); return true; }
		if (name == "say_stop3") { OnSayStop3(); return true; }
		if (name == "say_stop4") { OnSayStop4(); return true; }
		if (name == "say_stop5") { OnSayStop5(); return true; }
		return false;
	}
}
