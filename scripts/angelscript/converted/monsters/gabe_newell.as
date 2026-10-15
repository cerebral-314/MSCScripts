#pragma context server

// Converted from monsters/gabe_newell.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_flyer_grav.as"
#include "converted/monsters/base_propelled.as"

[script "monsters/gabe_newell"]
class GabeNewell : BaseFlyerGravScript, BasePropelled
{
	// Variables (an unset .script variable reads as its own name)
	float NPC_HACKED_MOVE_SPEED = 0.0f;
	bool IS_ACTIVE = false;
	string CHOSEN_PLAYER = "CHOSEN_PLAYER";
	float NEXT_WARN = 0.0f;
	string AS_LAST_POS = "AS_LAST_POS";
	bool AS_LAST_POS_SET = false;
	float NEXT_MUSAK = 0.0f;

	// unnamed block (first think)
	void GabeNewell_FirstThink()
	{
		NPC_HACKED_MOVE_SPEED = 75.0f;
	}

	// unnamed block (timer)
	void GabeNewell_Timer()
	{
		CallEventDelayed(5.0f, "GabeNewell_Timer");
		if (!IsAlive(ENT_ME))
			return;

		if (!IS_ACTIVE)
			return;

		// setprop ent_me rendermode 5
		// setprop ent_me renderamt 255
		PlayAnim("once", "spin_horizontal_slow");

		SetAnimFrameRate(0.25f);

		if (GameTime() > NEXT_MUSAK)
		{
			PlaySound(1, 10, "gabe_loop.wav");
			NEXT_MUSAK = GameTime() + 15.0f;
		}

		ClientEvent("new", "all", "monsters/gabe_newell_cl", IndexOf(ENT_ME), 4.9f);
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseFlyerGrav_OnGameSpawn(playerRace, playerGender); // monsters/base_flyer_grav
		SetName("Gabe Newell");
		SetRace("demon");
		PLAYING_DEAD = "1";
		SetModel("weapons/projectiles.mdl");
		SetModelBody(0, 65);
		SetWidth(8);
		SetHeight(8);
		// setprop ent_me rendermode 5
		// setprop ent_me renderamt 255
		IS_ACTIVE = true;
		SetInvincible(true);
		SetHealth(9999);
		SetIdleAnim("spin_horizontal_slow");
		SetMoveAnim("spin_horizontal_slow");
		PlayAnim("once", "spin_horizontal_slow");
		SetAnimFrameRate(0.25f);

		SetMonsterClip(false);

		PlaySound(1, 10, "gabe_loop.wav");

		ClientEvent("new", "all", "monsters/gabe_newell_cl", IndexOf(ENT_ME), 4.9f);

		CallEventDelayed(0.1f, "pick_player");

		CallEventDelayed(5.0f, "npcatk_hunt");
	}

	// npcatk_hunt
	void OnNpcatkHunt()
	{
		BaseFlyerGrav_OnNpcatkHunt(); // monsters/base_flyer_grav
		if (!IsAlive(ENT_ME))
			return;
		if (!IS_ACTIVE)
			return;
		CallEventDelayed(0.1f, "npcatk_hunt");

		if (!Exists(CHOSEN_PLAYER))
			OnPickPlayer();

		if (!Exists(CHOSEN_PLAYER))
			return;

		SetMoveDest(CHOSEN_PLAYER, 16);

		if (RangeTo(CHOSEN_PLAYER) < 512.0f && GameTime() > NEXT_WARN)
		{
			NEXT_WARN = GameTime() + 15.0f;
			InfoMessage(CHOSEN_PLAYER, "GABE NEWELL IS TRYING TO EAT YOU!", "Run you fool! He'll delete your character!");
			CallExternal("players", "ext_gabe_musak");
		}

		if (RangeTo(CHOSEN_PLAYER) < 64.0f)
			OnDoOmnomnom();

		if (NPC_HACKED_MOVE_SPEED < 250.0f && RangeTo(CHOSEN_PLAYER) < 1024.0f)
			NPC_HACKED_MOVE_SPEED += 0.02f;

		if (!IS_ACTIVE) // in case did omnomnom above
			return;

		// //anti-stuck
		Vector3 myOrg = OriginOf(ENT_ME);
		if (Distance(Vec(AS_LAST_POS), myOrg) < 1.0f)
		{
			DebugPrint("anti-stuck");
			if (AS_LAST_POS_SET)
			{
				float rndDir = Random(0, 359.99f);
				float rndUd = Random(-200, 200);
				AddVelocity(ENT_ME, RelativePosition(Vector3(0, rndDir, 0), Vector3(0, 500, rndUd)));
			}
		}

		AS_LAST_POS = Text(myOrg);
		AS_LAST_POS_SET = true;
	}

	// pick_player
	void OnPickPlayer()
	{
		SetVar("PLAYER_LIST", GetActivePlayers());
		float nPlayers = GetTokenCount("PLAYER_LIST") - 1.0f;
		int rndPlayer = RandomInt(0, int(nPlayers));
		CHOSEN_PLAYER = GetToken("PLAYER_LIST", rndPlayer);
		if (CHOSEN_PLAYER == GetVar("G_LAST_GABE_TARGET"))
			CHOSEN_PLAYER = "unset";

		if (CHOSEN_PLAYER == "unset")
			return;
		string outTitle = "Gabe Newell is out to eat " + NameOf(CHOSEN_PLAYER);
		string outMsg = "If he catches you, he will deleted your character!";
		InfoMessage("all", outMsg, outTitle);

		SetGlobal("G_LAST_GABE_TARGET", CHOSEN_PLAYER);

		CallExternal("players", "ext_gabe_musak");
	}

	// do_omnomnom
	void OnDoOmnomnom()
	{
		IS_ACTIVE = false;
		PlaySound(1, 0, "gabe_loop.wav");
		SetProp(ENT_ME, "renderamt", 0);
		SetOrigin(ENT_ME, Vector3(20000, 20000, -20000));
		LegacyCommand("hud.addimgicon", CHOSEN_PLAYER, "gabe1", "gabe1", 15, 20, 75, 60, 9.0f);
		PlayerMessageGreen(CHOSEN_PLAYER, "OMG! Character gonna delete!");
		CallEventDelayed(10.1f, "do_omnomnom2");
	}

	// do_omnomnom2
	void OnDoOmnomnom2()
	{
		SetGlobal("G_APRIL_FOOLS_MODE", 0);
		CallExternal("players", "ext_gabe_musak", "stop");
		LegacyCommand("hud.addimgicon", CHOSEN_PLAYER, "gabe2", "gabe2", 15, 20, 75, 60, 10.0f);
		PlayerMessageGreen(CHOSEN_PLAYER, "OMG! APRIL FOOLS! (- The RKS Crew)");
		CallEventDelayed(1.0f, "do_omnomnom3");
	}

	// do_omnomnom3
	void OnDoOmnomnom3()
	{
		DeleteEntity(ENT_ME);
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("weapons/projectiles.mdl");
		CallEventDelayed(5.0f, "GabeNewell_Timer");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		GabeNewell_FirstThink();
		BaseFlyerGrav_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "do_omnomnom") { OnDoOmnomnom(); return true; }
		if (name == "do_omnomnom2") { OnDoOmnomnom2(); return true; }
		if (name == "do_omnomnom3") { OnDoOmnomnom3(); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "npcatk_hunt") { OnNpcatkHunt(); return true; }
		if (name == "pick_player") { OnPickPlayer(); return true; }
		if (name == "GabeNewell_Timer") { GabeNewell_Timer(); return true; }
		return BasePropelled_DispatchEvent(name, params)
			|| BaseFlyerGravScript::DispatchEvent(name, params);
	}
}
