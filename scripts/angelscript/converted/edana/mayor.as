#pragma context server

// Converted from edana/mayor.script by msc_transpiler.
// Mayor of Edana

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_chat.as"

[script "edana/mayor"]
class EdanaMayor : BaseChatScript
{
	// Constants
	bool NO_RUMOR = true;

	// Variables (an unset .script variable reads as its own name)
	int ASKED_GUILD = 0;
	int OVER = 0;
	string SOUND_HELP = "SOUND_HELP";
	CBaseEntity@ IMPOSTER = null;

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseChat_OnGameSpawn(playerRace, playerGender); // monsters/base_chat

		SetHealth(30);
		SetGold(15);
		SetName("Zerkold, the Mayor");
		// ov		30
		SetWidth(32);
		SetHeight(72);
		SetRace("neutral");
		SetRoam(false);
		SetModel("npc/human1.mdl");
		SetInvincible(true);
		SetModelBody(1, 3);
		ASKED_GUILD = 2;
		OVER = 0;

		SOUND_HELP = "voices/human/male_help_guards.wav";

		CatchSpeech("say_hi", "hi", "hello", "hail", "greet");
		CatchSpeech("say_yes", "yes", "yep", "yup", "aye", "yeah");
		CatchSpeech("say_no", "no", "nope", "not");
		CatchSpeech("say_know", "orcs", "traitor");

		CatchSpeech("say_suliban", "suliban");
		CatchSpeech("say_job", "job", "work", "money", "gold");
		PrecacheFile("edana/guard");
	}

	// say_hi
	void OnSayHi(CBasePlayer@ talkingPlayer = null)
	{
		SayText("Yes? What do you want? Who are you?");
		ASKED_GUILD = RandomInt(0, 1);
	}

	// say_suliban
	void OnSaySuliban()
	{
		if (OVER != 0)
			return;
		if (ASKED_GUILD > 0)
		{
			PlayAnim("once", "panic1");
			SayText("Suliban was here an hour ago! You're not him!");
			ASKED_GUILD = 3;
			@IMPOSTER = EntityOf(ENT_LASTSPOKE);
			CallEventDelayed(0.0f, "120");
			CallEventDelayed(0.0f, "1.5");
		}
		else
		{
			PlayAnim("once", "talkleft");
			SayText("You're here again? You forgot to take the letter with you?");
			CallEventDelayed(0.0f, "3");
		}
		OVER = 1;
	}

	// guards
	void OnGuards()
	{
		// local IMPOSTER $get(IMPOSTER,id)
		string thiername = NameOf(IMPOSTER) + "!";
		CreateNpc("edana/guard", Vector3(-137, -1131, -250), @IMPOSTER);
		CreateNpc("edana/guard", Vector3(1038, -284, -60), @IMPOSTER);
		CreateNpc("edana/guard", Vector3(2428, -1092, -250), @IMPOSTER);
		SayText("Guards! Apprehend " + thiername);
		PlaySound(2, 10, SOUND_HELP);
	}

	// reset
	void OnReset()
	{
		ASKED_GUILD = 0;
	}

	// say_suliban2
	void OnSaySuliban2()
	{
		SayText("It's hidden in the secret compartment in my chest. Make sure nobody sees you with it.");
		CallExternal(FindByName("mayor_chest"), "showletter");
		ASKED_GUILD = 3;
	}

	// say_know
	void OnSayKnow()
	{
		PlayAnim("once", "eye_wipe");
		SayText("You know nothing!");
		LegacyCommand("removeitem", "letter");
	}

	// worldevent_evidence_found
	void OnWorldeventEvidenceFound()
	{
		DeleteMe();
	}

	// robbed
	// ///////////////////////////////////////////////////////////////////////////////////////////////
	void OnRobbed()
	{
		SayText("Help! Help! I'm being robbed!");
		PlayAnim("once", "beatdoor");
		UseTrigger("spawnguards");
	}

	// attack_1
	void OnAttack12()
	{
		DoDamage(ENT_LASTSTOLE, 100, 7, "75%");
	}

	// game_recvoffer_gold
	void OnGameRecvofferGold()
	{
		ReceiveOffer("accept");
		SayText("Come to donate eh? Well, that's what you should be doing!");
		PlayAnim("once", "pondering3");
	}

	// say_job
	void OnSayJob(CBasePlayer@ player = null)
	{
		SayText("What? No. I don't need help, It's not like I'm planning anything...");
		PlayAnim("once", "quicklook");
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("npc/human1.mdl");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "attack_1") { OnAttack12(); return true; }
		if (name == "game_recvoffer_gold") { OnGameRecvofferGold(); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "guards") { OnGuards(); return true; }
		if (name == "reset") { OnReset(); return true; }
		if (name == "robbed") { OnRobbed(); return true; }
		if (name == "say_hi") { OnSayHi(PlayerParam(params, 0)); return true; }
		if (name == "say_job") { OnSayJob(PlayerParam(params, 0)); return true; }
		if (name == "say_know") { OnSayKnow(); return true; }
		if (name == "say_suliban") { OnSaySuliban(); return true; }
		if (name == "say_suliban2") { OnSaySuliban2(); return true; }
		if (name == "worldevent_evidence_found") { OnWorldeventEvidenceFound(); return true; }
		return BaseChatScript::DispatchEvent(name, params);
	}
}
