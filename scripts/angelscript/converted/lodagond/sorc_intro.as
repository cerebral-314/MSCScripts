#pragma context server

// Converted from lodagond/sorc_intro.script by msc_transpiler.
// use this to track ice mage deaths and spawn cheiften as well

#include "runtime/ScriptEntity.as"

[script "lodagond/sorc_intro"]
class SorcIntro : ScriptEntity
{
	// Constants
	string IMG_SORC = "lodagond/sorc_image";
	string IMG_ICE_MAGE = "lodagond/ice_mage_image";
	int MAGE_RADIUS = 164;
	int DETECT_RADIUS = 256;
	float SPAWN_DELAY = 0.25f;
	float CONV_DELAY = 3.0f;

	// Variables (an unset .script variable reads as its own name)
	float DEAD_MAGES = 0.0f;
	CBaseEntity@ ID_SORC = null;
	string BARRIER_ID = "BARRIER_ID";
	CBaseEntity@ ID_MAGE1 = null;
	CBaseEntity@ ID_MAGE2 = null;
	CBaseEntity@ ID_MAGE3 = null;
	CBaseEntity@ ID_MAGE4 = null;
	bool STARTED_INTRO = false;
	bool INTRO_COMPLETE = false;

	// unnamed block (timer)
	void SorcIntro_Timer()
	{
		CallEventDelayed(0.0f, "SorcIntro_Timer");

		if (INTRO_COMPLETE)
			return;
		Effect("tempent", "trail", "3dmflaora.spr", RelativePosition(Vector3(0, 0, 64)), RelativePosition(Vector3(0, 0, 128)), 10, 1, 1, 5, 12);
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		SetName("Runegahr, Shadahar Orc Chieftain");
		SetFly(true);
		SetGravity(0);
		SetInvincible(true);
		SetModel("null.mdl");
		SetNoPush(true);
		SetRace("demon");
		SetWidth(20);
		SetHeight(20);
		SetModel("none");
		SetDamageTaken("stun", 0);
		SetGravity(0);
		SetUniqueName("sorc_intro");
		CallEventDelayed(0.1f, "spawn_image_sorc");
		DEAD_MAGES = 0.0f;
	}

	// game_precache
	void OnGamePrecache()
	{
		// holy crap this works here!
		PrecacheFile("monsters/sorc_chief1");
		PrecacheFile("monsters/ice_mage");
		PrecacheFile("lodagond/sorc_image");
		PrecacheFile("lodagond/ice_mage_image");
	}

	// spawn_image_sorc
	void OnSpawnImageSorc()
	{
		CreateNpc(IMG_SORC, RelativePosition(Vector3(0, 0, 64)), MyAngles().y);
		@ID_SORC = EntityOf(ENT_LASTCREATED);
		CallEventDelayed(SPAWN_DELAY, "spawn_image1");
	}

	// spawn_image1
	void OnSpawnImage1()
	{
		Vector3 spawnLoc = MyOrigin() + RelativePosition(Vector3(0, 45, 0), Vector3(0, MAGE_RADIUS, 0));
		CreateNpc(IMG_ICE_MAGE, spawnLoc, self, "mage1");
		CallEventDelayed(SPAWN_DELAY, "spawn_image2");
	}

	// spawn_image2
	void OnSpawnImage2()
	{
		Vector3 spawnLoc = MyOrigin() + RelativePosition(Vector3(0, 135, 0), Vector3(0, MAGE_RADIUS, 0));
		CreateNpc(IMG_ICE_MAGE, spawnLoc, self, "mage2");
		CallEventDelayed(SPAWN_DELAY, "spawn_image3");
	}

	// spawn_image3
	void OnSpawnImage3()
	{
		Vector3 spawnLoc = MyOrigin() + RelativePosition(Vector3(0, 225, 0), Vector3(0, MAGE_RADIUS, 0));
		CreateNpc(IMG_ICE_MAGE, spawnLoc, self, "mage3");
		CallEventDelayed(SPAWN_DELAY, "spawn_image4");
	}

	// spawn_image4
	void OnSpawnImage4()
	{
		Vector3 spawnLoc = MyOrigin() + RelativePosition(Vector3(0, 315, 0), Vector3(0, MAGE_RADIUS, 0));
		CreateNpc(IMG_ICE_MAGE, spawnLoc, self, "mage4");
		CallEventDelayed(SPAWN_DELAY, "spawn_barrier");
	}

	// spawn_barrier
	void OnSpawnBarrier()
	{
		float barrierRadius = MAGE_RADIUS + 32.0f;
		// createnpc monsters/summon/barrier $relpos(0,0,0) $get(ent_me,id) BARRIER_RADIUS 1 0
		BARRIER_ID = EntityId(EntityOf(ENT_LASTCREATED));
		OnScanForPlayers();

		// gather ID's
		// - if this doens't work, use callexternal all
		@ID_MAGE1 = FindByName("mage1");
		@ID_MAGE2 = FindByName("mage2");
		@ID_MAGE3 = FindByName("mage3");
		@ID_MAGE4 = FindByName("mage4");
	}

	// scan_for_players
	void OnScanForPlayers()
	{
		if (STARTED_INTRO)
			return;
		CallEventDelayed(0.25f, "scan_for_players");

		SetVar("L_PLAYERS", GetActivePlayers());
		int count = GetTokenCount("L_PLAYERS");
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnScanLoop();
			if (breakLoop)
			{
				breakLoop = false;
				break;
			}
		}
	}

	// scan_loop
	void OnScanLoop()
	{
		if (STARTED_INTRO)
			return;
		CBasePlayer@ curPlayer = FindPlayer(GetToken("L_PLAYERS", loopIteration));
		if (!(RangeTo("CU_PLAYER") < DETECT_RADIUS))
			return;
		STARTED_INTRO = true;
		OnDoIntro1();
	}

	// do_intro1
	void OnDoIntro1()
	{
		CallExternal(ID_SORC, "ext_convo1");
		CallEventDelayed(2.1f, "do_intro2");
		UseTrigger("ice_crystal1");
	}

	// do_intro2
	void OnDoIntro2()
	{
		CallExternal(ID_MAGE1, "ext_convo2");
		CallEventDelayed(4.3f, "do_intro3");
		UseTrigger("ice_crystal2");
	}

	// do_intro3
	void OnDoIntro3()
	{
		CallExternal(ID_MAGE2, "ext_convo3");
		CallEventDelayed(4.0f, "do_intro4");
		UseTrigger("ice_crystal3");
	}

	// do_intro4
	void OnDoIntro4()
	{
		CallExternal(ID_MAGE3, "ext_convo4");
		CallEventDelayed(6.3f, "do_intro5");
		UseTrigger("ice_crystal4");
	}

	// do_intro5
	void OnDoIntro5()
	{
		CallExternal(ID_SORC, "ext_convo5");
		CallEventDelayed(7.1f, "do_intro6");
		UseTrigger("ice_crystal5");
	}

	// do_intro6
	void OnDoIntro6()
	{
		CallExternal(ID_MAGE4, "ext_convo6");
		CallEventDelayed(3.5f, "do_intro_oops");
		UseTrigger("ice_crystal6");
	}

	// do_intro_oops
	// oops
	void OnDoIntroOops()
	{
		CallExternal(ID_MAGE3, "ext_convo7");
		CallEventDelayed(5.7f, "do_intro7");
		UseTrigger("ice_crystal7");
	}

	// do_intro7
	void OnDoIntro7()
	{
		CallExternal(ID_SORC, "ext_convo8");
		CallEventDelayed(7.1f, "do_intro8");
		UseTrigger("ice_crystal8");
	}

	// do_intro8
	void OnDoIntro8()
	{
		CallExternal(ID_MAGE2, "ext_convo9");
		CallEventDelayed(3.7f, "do_intro9");
		UseTrigger("ice_crystal9");
	}

	// do_intro9
	void OnDoIntro9()
	{
		CallExternal(ID_MAGE3, "ext_convo10");
		CallEventDelayed(5.6f, "intro_complete");
	}

	// ext_ice_mage_died
	void OnExtIceMageDied()
	{
		DEAD_MAGES += 1.0f;
		if (DEAD_MAGES != 4.0f)
			return;
		OnSpawnSorc();
	}

	// spawn_sorc
	void OnSpawnSorc()
	{
		CallExternal(ID_SORC, "sorc_in");
		CallEventDelayed(0.1f, "remove_me");
	}

	// remove_me
	void OnRemoveMe(string caller = "")
	{
		DeleteEntity(ENT_ME);
	}

	// intro_complete
	void OnIntroComplete()
	{
		INTRO_COMPLETE = true;
		CallExternal(BARRIER_ID, "remove_barrier");
		CallExternal(ID_MAGE1, "ext_mage_go");
		CallEventDelayed(0.2f, "intro_complete2");
	}

	// intro_complete2
	void OnIntroComplete2()
	{
		CallExternal(ID_MAGE2, "ext_mage_go");
		CallEventDelayed(0.2f, "intro_complete3");
	}

	// intro_complete3
	void OnIntroComplete3()
	{
		CallExternal(ID_MAGE3, "ext_mage_go");
		CallEventDelayed(0.2f, "intro_complete4");
	}

	// intro_complete4
	void OnIntroComplete4()
	{
		CallExternal(ID_MAGE4, "ext_mage_go");
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files
	void OnSpawnDelay() {} // SPAWN_DELAY

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("null.mdl");
		CallEventDelayed(Float(Eval("FREQ_BEAM")), "SorcIntro_Timer");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "do_intro1") { OnDoIntro1(); return true; }
		if (name == "do_intro2") { OnDoIntro2(); return true; }
		if (name == "do_intro3") { OnDoIntro3(); return true; }
		if (name == "do_intro4") { OnDoIntro4(); return true; }
		if (name == "do_intro5") { OnDoIntro5(); return true; }
		if (name == "do_intro6") { OnDoIntro6(); return true; }
		if (name == "do_intro7") { OnDoIntro7(); return true; }
		if (name == "do_intro8") { OnDoIntro8(); return true; }
		if (name == "do_intro9") { OnDoIntro9(); return true; }
		if (name == "do_intro_oops") { OnDoIntroOops(); return true; }
		if (name == "ext_ice_mage_died") { OnExtIceMageDied(); return true; }
		if (name == "game_precache") { OnGamePrecache(); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "intro_complete") { OnIntroComplete(); return true; }
		if (name == "intro_complete2") { OnIntroComplete2(); return true; }
		if (name == "intro_complete3") { OnIntroComplete3(); return true; }
		if (name == "intro_complete4") { OnIntroComplete4(); return true; }
		if (name == "remove_me") { OnRemoveMe(Param(params, 0)); return true; }
		if (name == "scan_for_players") { OnScanForPlayers(); return true; }
		if (name == "scan_loop") { OnScanLoop(); return true; }
		if (name == "spawn_barrier") { OnSpawnBarrier(); return true; }
		if (name == "spawn_image1") { OnSpawnImage1(); return true; }
		if (name == "spawn_image2") { OnSpawnImage2(); return true; }
		if (name == "spawn_image3") { OnSpawnImage3(); return true; }
		if (name == "spawn_image4") { OnSpawnImage4(); return true; }
		if (name == "spawn_image_sorc") { OnSpawnImageSorc(); return true; }
		if (name == "spawn_sorc") { OnSpawnSorc(); return true; }
		if (name == "SorcIntro_Timer") { SorcIntro_Timer(); return true; }
		return false;
	}
}
