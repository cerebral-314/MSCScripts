#pragma context server

// Converted from monsters/summon/bludgeon_axe.script by msc_transpiler.
// spinning axe thrown by bludgeon

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_noclip.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class BludgeonAxe
{
	// Constants
	float FWD_SPEED = 50.0f;
	string SOUND_SPIN = "zombie/claw_miss2.wav";
	float FREQ_SOUND = 0.3f;
	string DMG_TYPE = "slash";
	int SCAN_RAD = 72;

	// Variables (an unset .script variable reads as its own name)
	float ATTACK_MOVERANGE = 0.0f;
	string MY_OWNER = "MY_OWNER";
	Vector3 MY_DEST = Vector3();
	float DMG_BASE = 0.0f;
	int GAME_PVP = 0;
	string OWNER_ISPLAYER = "OWNER_ISPLAYER";
	string ITEM_ID = "ITEM_ID";
	float OWNER_HALFHEIGHT = 0.0f;
	Vector3 NPC_NOCLIP_DEST = Vector3();
	bool IS_ACTIVE = false;
	float END_FLIGHT_TIME = 0.0f;
	string PLAYING_DEAD = "PLAYING_DEAD";
	bool AM_RETURNING = false;

	// unnamed block (first think)
	void BludgeonAxe_FirstThink()
	{
		ATTACK_MOVERANGE = 80.0f;
	}

	// game_dynamically_created
	void BludgeonAxe_OnGameDynamicallyCreated(string creatorValue1 = "", string creatorValue2 = "", string damage = "", string skill = "", string extraValue5 = "", string extraValue6 = "", float alwaysPush = 0.0f, string duration = "", string extraValue9 = "")
	{
		MY_OWNER = creatorValue1;
		MY_DEST = Vec(creatorValue2);
		DMG_BASE = Float(damage);
		GAME_PVP = (IsPvp() ? 1 : 0);
		OWNER_ISPLAYER = Text(IsPlayer(MY_OWNER)); // players can't throw this, but they can throw items that use this as a base
		ITEM_ID = MY_OWNER;
		if (Truthy(OWNER_ISPLAYER))
			ITEM_ID = skill;
		OWNER_HALFHEIGHT = HeightOf(MY_OWNER);
		SetRace(RaceOf(MY_OWNER));
		if (!Truthy(OWNER_ISPLAYER))
			OWNER_HALFHEIGHT = Divide(OWNER_HALFHEIGHT, 2.0f);
		NPC_NOCLIP_DEST = MY_DEST;
		IS_ACTIVE = true;
		LegacyCommand("storeentity", ENT_EXPOWNER, MY_OWNER);
		CallEventDelayed(0.1f, "damage_loop");
		END_FLIGHT_TIME = GameTime() + 10.0f;
	}

	// game_spawn
	void BludgeonAxe_OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		SetName("Bludgeon Axe");
		SetModel("weapons/projectiles.mdl");
		SetModelBody(0, 32);
		SetIdleAnim("spin_vertical_norm");
		SetMoveAnim("spin_vertical_norm");
		SetSolid("none");
		SetWidth(32);
		SetFly(true);
		SetHeight(32);
		SetBlood("none");
		SetInvincible(true);
		SetMonsterClip(false);
		PLAYING_DEAD = "1"; // not a valid attack target
	}

	// damage_loop
	void BludgeonAxe_OnDamageLoop()
	{
		CallEventDelayed(0.1f, "damage_loop");
		DoDamage(Text(RelativePosition(Vector3(0, 0, 0))), SCAN_RAD, DMG_BASE, "100%", 0.0f, "reflective", DMG_TYPE);
	}

	// unnamed block (timer)
	void BludgeonAxe_Timer()
	{
		CallEventDelayed(FREQ_SOUND, "BludgeonAxe_Timer");
		if (!IS_ACTIVE)
			return;
		PlaySound(0, 10, "zombie/claw_miss2.wav");
	}

	// unnamed block (timer)
	void BludgeonAxe_Timer2()
	{
		CallEventDelayed(0.1f, "BludgeonAxe_Timer2");
		if (!IS_ACTIVE)
			return;
		if (!AM_RETURNING && Distance(MyOrigin(), NPC_NOCLIP_DEST) <= ATTACK_MOVERANGE)
			AM_RETURNING = true;
		if (AM_RETURNING)
		{
			NPC_NOCLIP_DEST = OriginOf(MY_OWNER);
			if (IsPlayer(MY_OWNER))
				NPC_NOCLIP_DEST = AttachmentPositionOf(MY_OWNER, 0);
			else
				NPC_NOCLIP_DEST.z += OWNER_HALFHEIGHT;

			if (Distance(MyOrigin(), NPC_NOCLIP_DEST) <= ATTACK_MOVERANGE)
			{
				IS_ACTIVE = false;
				CallExternal(ITEM_ID, "catch_axe");
				CallEventDelayed(0.1f, "remove_me");
			}
		}

		if (Truthy(OWNER_ISPLAYER))
			return;
		if (GameTime() > END_FLIGHT_TIME)
		{
			// in air too long, force return
			IS_ACTIVE = false;
			CallExternal(ITEM_ID, "catch_axe");
			CallEventDelayed(0.1f, "remove_me");
		}
	}

	// remove_me
	void BludgeonAxe_OnRemoveMe(string caller = "")
	{
		DeleteEntity(ENT_ME);
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseNoclip_OnGameSpawn(playerRace, playerGender); // monsters/base_noclip
		BludgeonAxe_OnGameSpawn(playerRace, playerGender);
	}

	void OnGameDynamicallyCreated(string creatorValue1 = "", string creatorValue2 = "", string damage = "", string skill = "", string extraValue5 = "", string extraValue6 = "", float alwaysPush = 0.0f, string duration = "", string extraValue9 = "") { BludgeonAxe_OnGameDynamicallyCreated(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); } // game_dynamically_created
	void OnDamageLoop() { BludgeonAxe_OnDamageLoop(); } // damage_loop
	void OnRemoveMe(string caller = "") { BludgeonAxe_OnRemoveMe(caller); } // remove_me

	// This file's events and timers by their .script names
	bool BludgeonAxe_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "damage_loop") { OnDamageLoop(); return true; }
		if (name == "game_dynamically_created") { OnGameDynamicallyCreated(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Float(Param(params, 6)), Param(params, 7), Param(params, 8)); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "remove_me") { OnRemoveMe(Param(params, 0)); return true; }
		if (name == "BludgeonAxe_Timer") { BludgeonAxe_Timer(); return true; }
		if (name == "BludgeonAxe_Timer2") { BludgeonAxe_Timer2(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "monsters/summon/bludgeon_axe"]
shared class BludgeonAxeScript : BaseNoclipScript, BludgeonAxe
{
	// Variables declared by included files, with the value they start with in this script
	BludgeonAxeScript()
	{
		FWD_SPEED = 50.0f;
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("weapons/projectiles.mdl");
		CallEventDelayed(FREQ_SOUND, "BludgeonAxe_Timer");
		CallEventDelayed(0.1f, "BludgeonAxe_Timer2");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		BludgeonAxe_FirstThink();
		BaseNoclip_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return BludgeonAxe_DispatchEvent(name, params)
			|| BaseNoclipScript::DispatchEvent(name, params);
	}
}
