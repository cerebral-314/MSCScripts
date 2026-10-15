#pragma context server

// Converted from aleyesu/death_image.script by msc_transpiler.

#include "runtime/ScriptEntity.as"

[script "aleyesu/death_image"]
class DeathImage : ScriptEntity
{
	// Variables (an unset .script variable reads as its own name)
	string PLAYING_DEAD = "PLAYING_DEAD";
	bool IS_ACTIVE = false;
	bool SPEECH_DONE = false;
	float DIST_VORTEX = 0.0f;
	float ROT = 0.0f;
	bool REND_COUNT = false;
	Vector3 VEC_DEST = Vector3();
	string VORTEX_CENTER = "VORTEX_CENTER";
	string MY_CL_IDX = "MY_CL_IDX";

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		SetName("Younger Keledros");
		SetModel("monsters/venevus.mdl");
		SetWidth(32);
		SetHeight(80);
		SetRoam(false);
		SetInvincible(true);
		PLAYING_DEAD = "1";
		SetIdleAnim("idle1");
		SetMoveAnim("idle1");
		SetSayTextRange(2048);
		SetSolid("none");
		SetProp(ENT_ME, "rendermode", 5);
		SetProp(ENT_ME, "renderamt", 255);
		SetProp(ENT_ME, "renderfx", 16); // this works, schweet!
		CallEventDelayed(0.1f, "say_stuff1");
		IS_ACTIVE = true;
		OnSetupSpinout();

		ServerPlaySound(2, 10, "ambience/alien_chatter.wav");
	}

	// say_stuff1
	void OnSayStuff1()
	{
		SayText("Ahck! No! I'm too weak to maintain phase in this time!");

		UseTrigger("timeroom_death");

		CallEventDelayed(3.0f, "say_stuff2");
	}

	// say_stuff2
	void OnSayStuff2()
	{
		SayText("Mark my words, this isn't the first time you had seen of meeeee...!");
		SPEECH_DONE = true;
	}

	// spinout_done
	void OnSpinoutDone()
	{
		ServerPlaySound(2, 0, "ambience/alien_chatter.wav");
		PlaySound(0, 10, "ambience/alien_humongo.wav");
		SetProp(ENT_ME, "renderamt", 0);
		ClientEvent("update", "all", MY_CL_IDX, "do_explode");
		Effect("screenfade", "all", 3, 1, Vector3(255, 255, 255), 200, "fadein");
		CallEventDelayed(1.0f, "remove_me1");
		if (Truthy(ScriptVarOf(GetVar("GAME_MASTER"), "GM_CHEST")))
			return;
		CreateNpc("aleyesu/final_chest", Vec(VORTEX_CENTER));
	}

	// remove_me1
	void OnRemoveMe1()
	{
		ClientEvent("remove", "all", MY_CL_IDX);
		CallEventDelayed(0.1f, "remove_me2");
	}

	// remove_me2
	void OnRemoveMe2()
	{
		if (!SPEECH_DONE)
			CallEventDelayed(1.0f, "remove_me2");
		if (!SPEECH_DONE)
			return;
		DeleteEntity(ENT_ME);
	}

	// setup_spinout
	void OnSetupSpinout()
	{
		DIST_VORTEX = Distance(MyOrigin(), Vec(VORTEX_CENTER));
		ROT = AnglesTo(MyOrigin(), Vec(VORTEX_CENTER));
		REND_COUNT = false;
		CallEventDelayed(0.1f, "spinout_loop");
	}

	// spinout_loop
	void OnSpinoutLoop()
	{
		if (!IS_ACTIVE)
			return;
		CallEventDelayed(0.1f, "spinout_loop");
		VEC_DEST = Vec(VORTEX_CENTER);
		VEC_DEST += RelativePosition(Vector3(0, ROT, 0), Vector3(0, DIST_VORTEX, 0));
		ROT += 10.0f;
		if (ROT > 359.0f)
			ROT -= 359.0f;
		if (DIST_VORTEX > 0.0f)
			DIST_VORTEX -= 5.0f;
		if (DIST_VORTEX > 1024.0f)
			DIST_VORTEX = 1024.0f;

		if (DIST_VORTEX <= 0.0f)
		{
			IS_ACTIVE = false;
			OnSpinoutDone();
		}

		// flicker, but fade when near vortex center
		int rndAmt = RandomInt(128, 255);
		SetProp(ENT_ME, "renderamt", rndAmt);
		SetOrigin(ENT_ME, VEC_DEST);
	}

	// game_dynamically_created
	void OnGameDynamicallyCreated(string creatorValue1 = "", string creatorValue2 = "", string damage = "", string skill = "", string extraValue5 = "", string extraValue6 = "", float alwaysPush = 0.0f, string duration = "", string extraValue9 = "")
	{
		VORTEX_CENTER = creatorValue1;
		ClientEvent("new", "all", "aleyesu/death_image", VORTEX_CENTER);
		MY_CL_IDX = LastClientScriptId();
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/venevus.mdl");
		Precache("ambience/alien_chatter.wav");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "game_dynamically_created") { OnGameDynamicallyCreated(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Float(Param(params, 6)), Param(params, 7), Param(params, 8)); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "remove_me1") { OnRemoveMe1(); return true; }
		if (name == "remove_me2") { OnRemoveMe2(); return true; }
		if (name == "say_stuff1") { OnSayStuff1(); return true; }
		if (name == "say_stuff2") { OnSayStuff2(); return true; }
		if (name == "setup_spinout") { OnSetupSpinout(); return true; }
		if (name == "spinout_done") { OnSpinoutDone(); return true; }
		if (name == "spinout_loop") { OnSpinoutLoop(); return true; }
		return false;
	}
}
