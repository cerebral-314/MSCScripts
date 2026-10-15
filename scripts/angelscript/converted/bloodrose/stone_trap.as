#pragma context server

// Converted from bloodrose/stone_trap.script by msc_transpiler.

#include "runtime/ScriptEntity.as"

[script "bloodrose/stone_trap"]
class StoneTrap : ScriptEntity
{
	// Constants
	int TRIGGER_RANGE = 256;

	// Variables (an unset .script variable reads as its own name)
	int DID_INTRO = 0;
	bool GAVE_ANSWER = false;
	bool SKELS_ON = false;

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		SetRace("beloved");
		SetBlood("none");
		SetModel("null.mdl");
		SetInvincible(true);
		SetHealth(1);
		SetFly(true);
		SetWidth(32);
		SetHeight(32);
		SetSolid("none");
		SetHearingSensitivity(11);

		// dbg temp stone trap spawned
		CallEventDelayed(0.1f, "scan_for_players");

		SetIdleAnim("");
		SetMoveAnim("");
	}

	// scan_for_players
	void OnScanForPlayers()
	{
		if (DID_INTRO != 0)
			return;
		CallEventDelayed(0.25f, "scan_for_players");
		if (FindInSphere("player", TRIGGER_RANGE) == "none")
			return;
		OnDoIntro();
	}

	// game_heardsound
	void OnGameHeardsound(string soundType = "", Vector3 origin = Vector3(), float dangerRadius = 0.0f)
	{
		if (DID_INTRO != 0)
			return;
		if (!IsPlayer(ENT_LASTHEARD))
			return;
		if (!(RangeTo(ENT_LASTHEARD) < TRIGGER_RANGE))
			return;
		// dbg temp Heard $get(ent_lastheard,name) at $get(ent_lastheard,range) vs TRIGGER_RANGE
		OnDoIntro();
	}

	// do_intro
	void OnDoIntro()
	{
		if (DID_INTRO != 0)
			return;
		DID_INTRO = 1;

		SetName("The Skeletal Statue");

		SetSayTextRange(2048);
		SayText("Identify yourself mortal! Only our masters may pass!");

		PlaySound(0, 10, "monsters/stoners/identify.wav");

		CatchSpeech("say_smart", "slithar");
		CatchSpeech("say_dumb", "venevus");
		CallEventDelayed(30.0f, "times_up");

		string outSound = "monsters/stoners/identify.wav";
		CallExternal("all", "ext_playsound", outSound, MyOrigin(), 1024);
	}

	// say_dumb
	void OnSayDumb()
	{
		if (SKELS_ON)
			return;
		if (GAVE_ANSWER)
			return;
		SetSayTextRange(2048);
		SayText("Venevus is already in his chamber! Imposter!");
		PlaySound(0, 10, "monsters/stoners/alreadyin.wav");

		CallEventDelayed(3.0f, "kill_intruder");
		CallEventDelayed(4.0f, "clear_out");

		string outSound = "monsters/stoners/alreadyin.wav";
		CallExternal("all", "ext_playsound", outSound, MyOrigin(), 1024);
	}

	// times_up
	void OnTimesUp()
	{
		if (SKELS_ON)
			return;
		if (GAVE_ANSWER)
			return;
		SetSayTextRange(2048);
		PlaySound(0, 10, "monsters/stoners/killtheintruder.wav");

		SayText("Your time has expired, and now, so shall you.");
		CallEventDelayed(1.0f, "kill_intruder");
		CallEventDelayed(2.0f, "clear_out");

		string outSound = "monsters/stoners/killtheintruder.wav";
		CallExternal("all", "ext_playsound", outSound, MyOrigin(), 1024);
	}

	// say_smart
	void OnSaySmart()
	{
		GAVE_ANSWER = true;
		UseTrigger("player_smart");
		PlaySound(0, 10, "monsters/stoners/youmaypass.wav");

		SetSayTextRange(2048);
		SayText("You may pass.");
		CallEventDelayed(1.0f, "clear_out");

		string outSound = "monsters/stoners/youmaypass.wav";
		CallExternal("all", "ext_playsound", outSound, MyOrigin(), 1024);
	}

	// clear_out
	void OnClearOut()
	{
		// dbg temp suiciding
		CallEventDelayed(0.1f, "suicide_debug");

		SetInvincible(false);
		SetRace("hated");
		CallEventDelayed(0.2f, "clear_out2");
	}

	// clear_out2
	void OnClearOut2()
	{
		DoDamage(self, "direct", 1000, "100%", self, "magic");
	}

	// suicide_debug
	void OnSuicideDebug()
	{
		// dbg still here
		CallEventDelayed(2.0f, "suicide_debug");
	}

	// kill_intruder
	void OnKillIntruder()
	{
		if (SKELS_ON)
			return;
		SKELS_ON = true;
		UseTrigger("player_dumb");
		Effect("screenshake", RelativePosition(Vector3(0, 0, 0)), 256, 50, 3.0f, 512);
		PlaySound(0, 10, "ambience/rocketrumble1.wav");
		CallEventDelayed(0.1f, "rumble_sound2");
		CallEventDelayed(0.3f, "wakie_wakie");
	}

	// rumble_sound2
	void OnRumbleSound2()
	{
		PlaySound(0, 10, "ambience/rocket_groan1.wav");
	}

	// wakie_wakie
	void OnWakieWakie()
	{
		PlaySound(0, 10, "monsters/stoners/dieintruder.wav");

		CallEventDelayed(0.1f, "wakie_wakie2");

		string outSound = "monsters/stoners/dieintruder.wav";
		CallExternal("all", "ext_playsound", outSound, MyOrigin(), 1024);
	}

	// wakie_wakie2
	void OnWakieWakie2()
	{
		CallExternal("all", "skeleton_wakeup_call");
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("null.mdl");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "clear_out") { OnClearOut(); return true; }
		if (name == "clear_out2") { OnClearOut2(); return true; }
		if (name == "do_intro") { OnDoIntro(); return true; }
		if (name == "game_heardsound") { OnGameHeardsound(Param(params, 0), Vec(Param(params, 1)), Float(Param(params, 2))); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "kill_intruder") { OnKillIntruder(); return true; }
		if (name == "rumble_sound2") { OnRumbleSound2(); return true; }
		if (name == "say_dumb") { OnSayDumb(); return true; }
		if (name == "say_smart") { OnSaySmart(); return true; }
		if (name == "scan_for_players") { OnScanForPlayers(); return true; }
		if (name == "suicide_debug") { OnSuicideDebug(); return true; }
		if (name == "times_up") { OnTimesUp(); return true; }
		if (name == "wakie_wakie") { OnWakieWakie(); return true; }
		if (name == "wakie_wakie2") { OnWakieWakie2(); return true; }
		return false;
	}
}
