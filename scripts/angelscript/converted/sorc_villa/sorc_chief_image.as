#pragma context server

// Converted from sorc_villa/sorc_chief_image.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_chat_array.as"

[script "sorc_villa/sorc_chief_image"]
class SorcChiefImage : BaseChatArrayScript
{
	// Variables (an unset .script variable reads as its own name)
	CBaseEntity@ POT_GUY_ID = null;
	float FADE_COUNT = 0.0f;
	string NEAREST_PLAYER = "NEAREST_PLAYER";

	// Variables declared by included files, with the value they start with in this script
	SorcChiefImage()
	{
		CHAT_USE_CONV_ANIMS = false;
		CHAT_AUTO_FACE = false;
		CHAT_NO_CLOSE_MOUTH = true;
	}

	// unnamed block (first think)
	void SorcChiefImage_FirstThink()
	{
		CHAT_MENU_ON = false;
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseChatArray_OnGameSpawn(playerRace, playerGender); // monsters/base_chat_array

		SetName("Runegahr the Warchief");
		SetRace("orc");
		SetNoPush(true);

		SetInvincible(true);

		SetModel("monsters/sorc.mdl");
		SetModelBody(0, 2); // body: 0=bare 1=bloody_shirt 2=gold_armor 3=archer
		SetModelBody(1, 3); // head: 0=hat_horns 1=hat_spiked 2=lizardskin_horned 3=gold_chieften 4=lizard_cap
		SetModelBody(2, 0); // weapon: 0=unarmed 1=axe 2=bow 3=steel_bow 4=sword 5=great_axe 6=sword_sheild 8=yellow_axe 9=blooddrinker
		SetStat("parry", 150);
		SetWidth(32);
		SetHeight(96);

		SetIdleAnim("idle1");
		SetMoveAnim("idle1");

		SetProp(ENT_ME, "rendermode", 5);
		SetProp(ENT_ME, "renderamt", 0);

		SetRoam(false);

		SetSayTextRange(1024);
	}

	// game_dynamically_created
	void OnGameDynamicallyCreated(string creatorValue1 = "", string creatorValue2 = "", string damage = "", string skill = "", string extraValue5 = "", string extraValue6 = "", float alwaysPush = 0.0f, string duration = "", string extraValue9 = "")
	{
		@POT_GUY_ID = EntityOf(creatorValue1);
		CallExternal(POT_GUY_ID, "ext_face_chief");
		CallEventDelayed(0.01f, "tele_in");
	}

	// tele_in
	void OnTeleIn()
	{
		ClientEvent("new", "all", "effects/sfx_repulse_burst", OriginOf(ENT_ME), 64, 1.0f);
		PlaySound(1, 10, "weather/Storm_exclamation.wav");
		SetMoveDest(@POT_GUY_ID, 9999);
		FADE_COUNT = 0.0f;
		OnFadeIn();

		// bchat array causing odd stuff here
		// callevent chat_add_text rant_off "Easkhar! You sniveling swine! These are MY guests, and you WILL treat them as such!" 3.0 swordswing1_L berate_done1
		// callevent chat_add_text done_here "My apologies, this unenlightened thakwaw will aid you now, should you wish it." 3.0 nod_yes tele_out1
		CallEventDelayed(0.5f, "do_rant");
	}

	// fade_in
	void OnFadeIn()
	{
		if (FADE_COUNT <= 255.0f)
		{
			FADE_COUNT += 25.0f;
			SetProp(ENT_ME, "renderamt", FADE_COUNT);
			CallEventDelayed(0.1f, "fade_in");
		}
		else
		{
			SetProp(ENT_ME, "renderamt", 255);
			SetProp(ENT_ME, "rendermode", 1);
		}
	}

	// do_rant
	void OnDoRant()
	{
		SetMoveDest(@POT_GUY_ID, 9999);
		CallEventDelayed(1.0f, "do_rant2");
	}

	// do_rant2
	void OnDoRant2()
	{
		SetMoveDest(@POT_GUY_ID, 9999);
		OnChatNow("Easkhar! You sniveling swine! These are MY guests, and you WILL treat them as such!", "3.0", "swordswing1_L");
		CallEventDelayed(3.0f, "get_response");
	}

	// get_response
	void OnGetResponse()
	{
		CallExternal(POT_GUY_ID, "ext_chief_done_berating");
		CallEventDelayed(8.0f, "says_sorries");
	}

	// says_sorries
	void OnSaysSorries()
	{
		NEAREST_PLAYER = FindOneInSphere("player", 512);
		SetMoveDest(NEAREST_PLAYER, 9999);

		OnChatNow("My apologies, this unenlightened thakwaw will aid you now, should you wish it.", "3.0", "nod_yes");
		CallEventDelayed(3.0f, "tele_out1");
	}

	// tele_out1
	void OnTeleOut1()
	{
		ClientEvent("new", "all", "effects/sfx_repulse_burst", OriginOf(ENT_ME), 64, 1.0f);
		SetProp(ENT_ME, "rendermode", 5);
		OnFadeOut();
		CallEventDelayed(3.5f, "tele_out_done");
	}

	// tele_out_done
	void OnTeleOutDone()
	{
		DebugPrint("tele_out2 sending event to " + NameOf(POT_GUY_ID));
		CallExternal(POT_GUY_ID, "ext_chief_gone");
	}

	// fade_out
	void OnFadeOut()
	{
		if (FADE_COUNT > 0.0f)
		{
			FADE_COUNT -= 25.0f;
			SetProp(ENT_ME, "renderamt", FADE_COUNT);
			CallEventDelayed(0.1f, "fade_out");
		}
		else
		{
			SetProp(ENT_ME, "renderamt", 0);
			CallEventDelayed(5.0f, "remove_script");
		}
	}

	// remove_script
	void OnRemoveScript()
	{
		DeleteEntity(ENT_ME);
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/sorc.mdl");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		SorcChiefImage_FirstThink();
		BaseChatArray_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "do_rant") { OnDoRant(); return true; }
		if (name == "do_rant2") { OnDoRant2(); return true; }
		if (name == "fade_in") { OnFadeIn(); return true; }
		if (name == "fade_out") { OnFadeOut(); return true; }
		if (name == "game_dynamically_created") { OnGameDynamicallyCreated(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Float(Param(params, 6)), Param(params, 7), Param(params, 8)); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "get_response") { OnGetResponse(); return true; }
		if (name == "remove_script") { OnRemoveScript(); return true; }
		if (name == "says_sorries") { OnSaysSorries(); return true; }
		if (name == "tele_in") { OnTeleIn(); return true; }
		if (name == "tele_out1") { OnTeleOut1(); return true; }
		if (name == "tele_out_done") { OnTeleOutDone(); return true; }
		return BaseChatArrayScript::DispatchEvent(name, params);
	}
}
