#pragma context server

// Converted from ms_wicardoven/maldora_dead.script by msc_transpiler.

#include "runtime/ScriptEntity.as"

[script "ms_wicardoven/maldora_dead"]
class MaldoraDead : ScriptEntity
{
	// Constants
	string SOUND_LAUGH = "monsters/skeleton/cal_laugh.wav";
	string MONSTER_MODEL = "monsters/maldora.mdl";
	bool I_AM_TURNABLE = false;

	// Variables (an unset .script variable reads as its own name)
	string ANIM_IDLE = "idle";
	bool NO_SPAWN_STUCK_CHECK = false;
	string BARRIER_ID = "BARRIER_ID";
	int DEATH_ACCEL = 0;
	string AXE_TYPE = "AXE_TYPE";
	string AXE_ITEM = "AXE_ITEM";
	float FLY_COUNT = 0.0f;
	float ROOF_HEIGHT = 0.0f;
	float MY_Z = 0.0f;

	// unnamed block (first think)
	void MaldoraDead_FirstThink()
	{
		ANIM_IDLE = "idle";

		NO_SPAWN_STUCK_CHECK = true;
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		SetName("Fragment of Maldora");
		SetHealth(3000);
		SetRace("demon");
		SetInvincible(true);
		SetModel(MONSTER_MODEL);
		SetProp(ENT_ME, "rendermode", 5);
		SetProp(ENT_ME, "renderamt", 255);

		SetSolid("none");
		SetWidth(32);
		SetHeight(86);

		SetBlood("none");

		SetRoam(false);

		SetSayTextRange(2048);

		SetUniqueName("dead_maldora");

		SetIdleAnim(ANIM_IDLE);
		SetMoveAnim(ANIM_IDLE);
	}

	// game_precache
	void OnGamePrecache()
	{
		PrecacheFile("monsters/summon/barrier");
	}

	// make_barrier
	void OnMakeBarrier()
	{
		CreateNpc("monsters/summon/barrier", RelativePosition(Vector3(0, 0, 0)), self, 128, 1, 0);
		BARRIER_ID = EntityId(EntityOf(ENT_LASTCREATED));
		CallEventDelayed(0.25f, "get_orc_ids");
	}

	// game_dynamically_created
	// PARAM1=type
	void OnGameDynamicallyCreated(string creatorValue1 = "", string creatorValue2 = "", string damage = "", string skill = "", string extraValue5 = "", string extraValue6 = "", float alwaysPush = 0.0f, string duration = "", string extraValue9 = "")
	{
		DEATH_ACCEL = 20; // fly out faster for Voldar, as ceiling higher

		if (creatorValue1 != "crow" && creatorValue1 != "crow_final")
			CallEventDelayed(0.1f, "make_barrier");

		if (creatorValue1 == "death")
		{
			DEATH_ACCEL = 10;
			OnDeathExit();
		}

		if (creatorValue1 == "crow")
		{
			DEATH_ACCEL = 10;
			OnFlyOut();
		}

		if (creatorValue1 == "crow_final")
		{
			DEATH_ACCEL = 10;
			SetProp(ENT_ME, "rendermode", 0);
			SetProp(ENT_ME, "renderamt", 255);
			OnFlyOut();
			DebugPrint("drop_axe " + creatorValue2);
			if (Float(creatorValue2) > -1.0f)
			{
				CallEventDelayed(0.5f, "spawn_axe");
				AXE_TYPE = creatorValue2;
			}
		}
	}

	// spawn_axe
	void OnSpawnAxe()
	{
		SayText("Here fools, you've earned a gift...");
		PlaySound(0, 10, "voices/lodagond-4/maldora_reward.wav");
		if (Float(AXE_TYPE) == 0.0f)
			AXE_ITEM = "axes_tf";
		if (Float(AXE_TYPE) == 1.0f)
			AXE_ITEM = "axes_td";
		if (Float(AXE_TYPE) == 2.0f)
			AXE_ITEM = "axes_ti";
		if (Float(AXE_TYPE) == 3.0f)
			AXE_ITEM = "axes_tp";
		if (Float(AXE_TYPE) == 4.0f)
			AXE_ITEM = "axes_tl";
		SetProp(ENT_ME, "skin", 5);
		// createitem AXE_ITEM $relpos(0,0,0)
		CallExternal(GetVar("GAME_MASTER"), "gm_drop_item", 1.0f, AXE_ITEM, OriginOf(ENT_ME), 1);
	}

	// say_gaveyou1
	// Externals called from Voldar
	void OnSayGaveyou1()
	{
		PlayAnim("critical", "ref_shoot_squeak");
		SayText("I've empowered your shamans. I've given your troops all the poison they could ever use...");
		PlaySound(0, 10, "voices/ms_wicardoven/fmaldora_2voldar1.wav");
	}

	// say_gaveyou2
	void OnSayGaveyou2()
	{
		SayText("...and I've granted you your own magical powers... Just as we agreed.");
		PlaySound(0, 10, "voices/ms_wicardoven/fmaldora_2voldar2.wav");
	}

	// say_gaveyou3
	void OnSayGaveyou3()
	{
		PlayAnim("critical", "look_idle");
		if (PlayerCount() == 1)
			SayText("But if you can't stop one pathetic human, with all of that power...");
		if (PlayerCount() == 2)
			SayText("But if you can't stop a pair of puny humans, with all of that power...");
		if (PlayerCount() == 3)
			SayText("But if you can't stop a three puny humans, with all of that power...");
		if (PlayerCount() == 4)
			SayText("But if you can't stop a four puny humans, with all of that power...");
		if (PlayerCount() == 5)
			SayText("But if you can't stop a five puny humans, with all of that power...");
		if (PlayerCount() == 6)
			SayText("But if you can't stop a six puny humans, with all of that power...");
		if (PlayerCount() > 6)
			SayText("But if you can't stop a couple of puny humans, with all of that power...");
		PlaySound(0, 10, "voices/ms_wicardoven/fmaldora_2voldar3.wav");
	}

	// say_gaveyou4
	void OnSayGaveyou4()
	{
		SayText("...then you aren't of much use to me, are you?");
		PlaySound(0, 10, "voices/ms_wicardoven/fmaldora_2voldar4.wav");
	}

	// remove_me
	void OnRemoveMe(string caller = "")
	{
		DeleteEntity(ENT_ME);
	}

	// face_me
	void OnFaceMe(CBaseEntity@ target = null)
	{
		SetAngle("face_origin", OriginOf(target));
		CallEventDelayed(0.1f, "straighten_up");
	}

	// straighten_up
	void OnStraightenUp()
	{
		SetAngle("face", Vector3(0, MyAngles().y, 0));
	}

	// fly_out
	void OnFlyOut()
	{
		CallExternal(BARRIER_ID, "remove_barrier");
		PlaySound(0, 10, "voices/ms_wicardoven/fmaldora_exit4.wav");
		SetFly(true);
		FLY_COUNT = 0.0f;
		Vector3 traceOrg = MyOrigin();
		Vector3 traceEnd = RelativePosition(Vector3(0, 0, 0), Vector3(0, 0, 2000));
		string traceLine = LegacyFunction("get_traceline", traceOrg, traceEnd, "worldonly");
		ROOF_HEIGHT = Vec(traceLine).z + 128.0f;
		// playsound 0 10 SOUND_LAUGH
		CallEventDelayed(0.1f, "fly_out_loop");
	}

	// fly_out_loop
	void OnFlyOutLoop()
	{
		float myX = MyOrigin().x;
		float myY = MyOrigin().y;
		MY_Z = MyOrigin().z + DEATH_ACCEL;

		SetOrigin(ENT_ME, Vector3(myX, myY, MY_Z));
		if (MY_Z > ROOF_HEIGHT)
			OnRemoveMe();
		if (MY_Z <= ROOF_HEIGHT)
			CallEventDelayed(0.1f, "fly_out_loop");
	}

	// death_exit
	void OnDeathExit()
	{
		SayText("Well, it seems what my master said maybe true... Maybe you are amongst the chosen ones.");
		PlaySound(0, 10, "voices/ms_wicardoven/fmaldora_exit1.wav");
		CallEventDelayed(5.7f, "death_exit2");
	}

	// death_exit2
	void OnDeathExit2()
	{
		SayText("If so, you maybe useful. We will meet again one day, to put that to the test.");
		PlaySound(0, 10, "voices/ms_wicardoven/fmaldora_exit2.wav");
		string mapName = ToLowerCase(MapName());
		if (mapName == "ms_wicardoven")
			CallEventDelayed(5.9f, "death_exit3");
		if (mapName != "ms_wicardoven")
			CallEventDelayed(1.0f, "fly_out");
	}

	// death_exit3
	void OnDeathExit3()
	{
		SayText("That is, if you even survive the desert beyond.");
		PlaySound(0, 10, "voices/ms_wicardoven/fmaldora_exit3.wav");
		CallEventDelayed(3.9f, "fly_out");
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/maldora.mdl");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		MaldoraDead_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "death_exit") { OnDeathExit(); return true; }
		if (name == "death_exit2") { OnDeathExit2(); return true; }
		if (name == "death_exit3") { OnDeathExit3(); return true; }
		if (name == "face_me") { OnFaceMe(EntityParam(params, 0)); return true; }
		if (name == "fly_out") { OnFlyOut(); return true; }
		if (name == "fly_out_loop") { OnFlyOutLoop(); return true; }
		if (name == "game_dynamically_created") { OnGameDynamicallyCreated(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Float(Param(params, 6)), Param(params, 7), Param(params, 8)); return true; }
		if (name == "game_precache") { OnGamePrecache(); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "make_barrier") { OnMakeBarrier(); return true; }
		if (name == "remove_me") { OnRemoveMe(Param(params, 0)); return true; }
		if (name == "say_gaveyou1") { OnSayGaveyou1(); return true; }
		if (name == "say_gaveyou2") { OnSayGaveyou2(); return true; }
		if (name == "say_gaveyou3") { OnSayGaveyou3(); return true; }
		if (name == "say_gaveyou4") { OnSayGaveyou4(); return true; }
		if (name == "spawn_axe") { OnSpawnAxe(); return true; }
		if (name == "straighten_up") { OnStraightenUp(); return true; }
		return false;
	}
}
