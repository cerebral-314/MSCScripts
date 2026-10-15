#pragma context server

// Converted from traps/fire_wall.script by msc_transpiler.
// Fire Wall

#include "runtime/ScriptEntity.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class FireWall
{
	// Constants
	string TIME_LIVE = "14";
	float FIRE_DURATION = 15.0f;

	// Variables (an unset .script variable reads as its own name)
	string ANIM_DEATH = "ANIM_DEATH";
	bool FLAMING = false;
	string PLAYING_DEAD = "PLAYING_DEAD";
	string MY_OWNER = "MY_OWNER";
	float MY_BASE_DMG = 0.0f;
	string FLAME_ID = "FLAME_ID";

	// unnamed block (first think)
	void FireWall_FirstThink()
	{
		ANIM_DEATH = "";
	}

	// flames_start
	// Start shooting
	void FireWall_OnFlamesStart()
	{
		PlaySound(Int(GetVar("CHAN_ITEM")), 7, "items/torch1.wav");
		FLAMING = true;
	}

	// game_spawn
	// Server
	// ======
	void FireWall_OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		PLAYING_DEAD = "1"; // not valid target

		SetName("Fire Wall Trap");
		SetHealth(1);
		// race hated
		SetInvincible(true);
		SetRoam(false);
		SetSkillLevel(0);
		SetHearingSensitivity(0);
		SetModel("null.mdl");
		PLAYING_DEAD = "1";

		CallEventDelayed(0.1f, "flames_start");

		LegacyCommand("emitsound", ENT_ME, OriginOf(ENT_ME), 192, TIME_LIVE, "danger", 192);

		MY_OWNER = EntityId(self);
		MY_BASE_DMG = 300.0f;

		CallEventDelayed(FIRE_DURATION, "firewall_death"); // Die after a delay

		float removeTime = FIRE_DURATION - 0.2f;
		CallEventDelayed(removeTime, "remove_invul");

		SetAngle("face.y", AnglesOf(ENT_ME).y);
		ClientEvent("new", "all", "traps/fire_wall", OriginOf(ENT_ME), AnglesOf(ENT_ME).y); // Send to client immediately - calls client_activate on client
		FLAME_ID = LastClientScriptId();
	}

	// remove_invul
	void FireWall_OnRemoveInvul()
	{
		SetRace("hated");
		SetInvincible(false);
	}

	// game_dynamically_created
	void FireWall_OnGameDynamicallyCreated(string creatorValue1 = "", string creatorValue2 = "", string damage = "", string skill = "", string extraValue5 = "", string extraValue6 = "", float alwaysPush = 0.0f, string duration = "", string extraValue9 = "")
	{
	}

	// flames_attack
	// Deal damage
	void FireWall_OnFlamesAttack()
	{
		CallEventDelayed(0.5f, "flames_attack");

		if (!FLAMING)
			return;
		float attackDamage = MY_BASE_DMG;
		DoDamage(Text(RelativePosition(Vector3(0, 0, 0))), 96, 0, "100%", 0, "reflective", "target");
		DoDamage(Text(RelativePosition(Vector3(0, 96, 0))), 96, 0, "100%", 0, "reflective", "target");
		DoDamage(Text(RelativePosition(Vector3(0, -96, 0))), 96, 0, "100%", 0, "reflective", "target");
	}

	// game_dodamage
	// 1: Attack Hit (1/0)  2: Entity Attack hit  3:  Start Position  4:  End Position
	string FireWall_OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";

		if (IsPlayer(target))
			ApplyEffect(target, "effects/dot_fire", 2, self, MY_BASE_DMG);
		if (IsAlive(target))
			ApplyEffect(target, "effects/dot_fire", 2, self, MY_BASE_DMG);
		return result;
	}

	// firewall_death
	// Pewf
	void FireWall_OnFirewallDeath()
	{
		FLAMING = false;
		OnFirewallEndCl();
		PlaySound(Int(GetVar("CHAN_ITEM")), Eval("game.sound.silentvol"), "items/torch1.wav");
		ClientEvent("remove", "all", FLAME_ID);
		DoDamage(ENT_ME, "direct", 6000, 100, ENT_ME);
		SetAlive(false);
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)
	void OnFlamesStart() { FireWall_OnFlamesStart(); } // flames_start
	void OnGameSpawn(string playerRace = "", string playerGender = "") { FireWall_OnGameSpawn(playerRace, playerGender); } // game_spawn
	void OnRemoveInvul() { FireWall_OnRemoveInvul(); } // remove_invul
	void OnGameDynamicallyCreated(string creatorValue1 = "", string creatorValue2 = "", string damage = "", string skill = "", string extraValue5 = "", string extraValue6 = "", float alwaysPush = 0.0f, string duration = "", string extraValue9 = "") { FireWall_OnGameDynamicallyCreated(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); } // game_dynamically_created
	void OnFlamesAttack() { FireWall_OnFlamesAttack(); } // flames_attack
	string OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "") { return FireWall_OnGameDodamage(hit, target, start, end, damageType, damageText); } // game_dodamage
	void OnFirewallDeath() { FireWall_OnFirewallDeath(); } // firewall_death
	void OnFireDuration() {} // FIRE_DURATION
	void OnRemoveTime() {} // REMOVE_TIME
	void OnFirewallEndCl() {} // firewall_end_cl

	// This file's events and timers by their .script names
	bool FireWall_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "firewall_death") { OnFirewallDeath(); return true; }
		if (name == "flames_attack") { OnFlamesAttack(); return true; }
		if (name == "flames_start") { OnFlamesStart(); return true; }
		if (name == "game_dodamage") { Return(OnGameDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5))); return true; }
		if (name == "game_dynamically_created") { OnGameDynamicallyCreated(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Float(Param(params, 6)), Param(params, 7), Param(params, 8)); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "remove_invul") { OnRemoveInvul(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "traps/fire_wall"]
shared class FireWallScript : ScriptEntity, FireWall
{
	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("fire1_fixed.spr");
		Precache("null.mdl");
		CallEventDelayed(0.5f, "flames_attack");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		FireWall_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return FireWall_DispatchEvent(name, params);
	}
}
