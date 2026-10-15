#pragma context server

// Converted from monsters/summon/summon_fire_wall.script by msc_transpiler.
// Fire Wall

#include "runtime/ScriptEntity.as"

[script "monsters/summon/summon_fire_wall"]
class SummonFireWall : ScriptEntity
{
	// Constants
	string TIME_LIVE = "14";

	// Variables (an unset .script variable reads as its own name)
	bool I_DO_FIRE_DAMAGE = false;
	bool FLAMING = false;
	string PLAYING_DEAD = "PLAYING_DEAD";
	string MY_OWNER = "MY_OWNER";
	string OWNER_ISPLAYER = "OWNER_ISPLAYER";
	int GAME_PVP = 0;
	float MY_BASE_DMG = 0.0f;
	float FIRE_DURATION = 0.0f;
	string ACTIVE_SKILL = "ACTIVE_SKILL";
	float SCAN_PASS = 0.0f;

	// unnamed block (first think)
	// Shared
	// ======
	void SummonFireWall_FirstThink()
	{
		I_DO_FIRE_DAMAGE = true;
	}

	// flames_start
	// Start shooting
	void OnFlamesStart()
	{
		PlaySound(Int(GetVar("CHAN_ITEM")), 7, "items/torch1.wav");
		FLAMING = true;
		OnFlamesAttack();
	}

	// game_spawn
	// Server
	// ======
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		PLAYING_DEAD = "1"; // not valid target

		SetName("Fire Wall");
		SetHealth(1);
		// race beloved
		SetInvincible(true);
		// setsolid none
		// ov 90
		// width 32
		// height 32
		SetRoam(false);
		SetSkillLevel(0);
		SetHearingSensitivity(0);
		SetBlood("none");

		// setmodel null.mdl
		CallEventDelayed(2.0f, "flames_start"); // Start doing damage after a delay

		LegacyCommand("emitsound", ENT_ME, OriginOf(ENT_ME), 192, TIME_LIVE, "danger", 192);
	}

	// game_dynamically_created
	void OnGameDynamicallyCreated(string creatorValue1 = "", string creatorValue2 = "", string damage = "", string skill = "", string extraValue5 = "", string extraValue6 = "", float alwaysPush = 0.0f, string duration = "", string extraValue9 = "")
	{
		MY_OWNER = creatorValue1;
		OWNER_ISPLAYER = Text(IsPlayer(MY_OWNER));
		GAME_PVP = (IsPvp() ? 1 : 0);
		MY_BASE_DMG = Float(damage);
		MY_BASE_DMG *= 3.0f; // upping damage for method change
		FIRE_DURATION = Float(skill);
		ACTIVE_SKILL = extraValue5;
		if (ACTIVE_SKILL.isEmpty())
			ACTIVE_SKILL = "spellcasting.fire";

		// dbg Owner MY_OWNER Dmg MY_BASE_DMG Duration FIRE_DURATION
		CallEventDelayed(FIRE_DURATION, "firewall_death"); // Die after a delay

		LegacyCommand("storeentity", ENT_EXPOWNER, MY_OWNER); // Give any gained exp to the player (doesnt work - but stops from frying himself)
		SetAngle("face.y", creatorValue2);
		ClientEvent("new", "all", "monsters/summon/summon_fire_wall", OriginOf(ENT_ME), creatorValue2); // Send to client immediately - calls client_activate on client
		SCAN_PASS = 0.0f;
	}

	// flames_attack
	// Deal damage
	void OnFlamesAttack()
	{
		Vector3 scanPos = Vec("SCAN_POS");
		bool exitSub = false;

		if (!FLAMING)
			return;

		CallEventDelayed(0.1f, "flames_attack");

		// local FINAL_DMG MY_BASE_DMG
		// divide FINAL_DMG 3
		// dodamage $relpos(0,0,0) 72 FINAL_DMG 100% 0 reflective fire
		// dodamage $relpos(0,96,0) 72 FINAL_DMG 100% 0 reflective fire
		// dodamage $relpos(0,-96,0) 72 FINAL_DMG 100% 0 reflective fire
		SCAN_PASS += 1.0f;
		if (SCAN_PASS > 3.0f)
			SCAN_PASS = 0.0f;

		if (SCAN_PASS == 1.0f)
			scanPos = RelativePosition(Vector3(0, 0, 0));
		if (SCAN_PASS == 2.0f)
			scanPos = RelativePosition(Vector3(0, 96, 0));
		if (SCAN_PASS == 3.0f)
			scanPos = RelativePosition(Vector3(0, -96, 0));
		string scanResult = LegacyFunction("get_insphere", "any", 48, scanPos);
		if (RelationshipOf(scanResult, MY_OWNER) != "enemy")
			return;
		if (IsPlayer(scanResult) && Truthy(OWNER_ISPLAYER) && GAME_PVP < 1)
			exitSub = true;
		if (exitSub)
			return;
		ApplyEffect(scanResult, "effects/dot_fire", 10, MY_OWNER, MY_BASE_DMG, ACTIVE_SKILL);
	}

	// firewall_death
	// { game_dodamage //1: Attack Hit (1/0)  2: Entity Attack hit  3:  Start Position 4:  End Position
	// ////dbg Did Damage
	// //if PARAM1
	// ////dbg DoingDam to $get(PARAM2,id) from MY_OWNER at MY_BASE_DMG hp/sec
	// if $get(PARAM2,id) isnot $get(ent_me,id)
	// if $get(MY_OWNER,relationship,PARAM2) isnot ally
	// applyeffect PARAM2 effects/dot_fire 2 MY_OWNER MY_BASE_DMG 1 0 ACTIVE_SKILL
	// }
	// Pewf
	void OnFirewallDeath()
	{
		FLAMING = false;
		OnFirewallEndCl();
		DeleteEntity(ENT_ME);
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files
	void OnFireDuration() {} // FIRE_DURATION
	void OnFirewallEndCl() {} // firewall_end_cl

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("fire1_fixed.spr");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		SummonFireWall_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "firewall_death") { OnFirewallDeath(); return true; }
		if (name == "flames_attack") { OnFlamesAttack(); return true; }
		if (name == "flames_start") { OnFlamesStart(); return true; }
		if (name == "game_dynamically_created") { OnGameDynamicallyCreated(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Float(Param(params, 6)), Param(params, 7), Param(params, 8)); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		return false;
	}
}
