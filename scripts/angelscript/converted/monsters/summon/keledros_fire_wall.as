#pragma context server

// Converted from monsters/summon/keledros_fire_wall.script by msc_transpiler.
// Thothie - Can't control client fade time on real fire wall, so Keledros has his own 10 sec ver
// Fire Wall

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_npc.as"

[script "monsters/summon/keledros_fire_wall"]
class KeledrosFireWall : BaseNpcScript
{
	// Constants
	string TIME_LIVE = "10";

	// Variables (an unset .script variable reads as its own name)
	bool I_DO_FIRE_DAMAGE = false;
	bool FLAMING = false;
	string MY_OWNER = "MY_OWNER";
	float MY_BASE_DMG = 0.0f;
	float FIRE_DURATION = 0.0f;

	// unnamed block (first think)
	// Shared
	// ======
	void KeledrosFireWall_FirstThink()
	{
		I_DO_FIRE_DAMAGE = true;
	}

	// flames_start
	// Start shooting
	void OnFlamesStart()
	{
		PlaySound(Int(GetVar("CHAN_ITEM")), 7, "items/torch1.wav");
		FLAMING = true;
	}

	// game_dynamically_created
	void OnGameDynamicallyCreated(string creatorValue1 = "", string creatorValue2 = "", string damage = "", string skill = "", string extraValue5 = "", string extraValue6 = "", float alwaysPush = 0.0f, string duration = "", string extraValue9 = "")
	{
		BaseSelfAdjust_OnGameDynamicallyCreated(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/base_self_adjust
		BaseSelfAdjust_OnGameDynamicallyCreated_2(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/base_self_adjust

		MY_OWNER = creatorValue1;
		MY_BASE_DMG = Float(damage);
		FIRE_DURATION = 10.0f;

		// dbg k_firewall Owner $get(MY_OWNER,name) Dmg MY_BASE_DMG Duration FIRE_DURATION
		CallEventDelayed(FIRE_DURATION, "firewall_death"); // Die after a delay

		LegacyCommand("storeentity", ENT_EXPOWNER, creatorValue1); // Give any gained exp to the player
		SetAngle("face.y", creatorValue2);

		ClientEvent("new", "all", "monsters/summon/keledros_fire_wall", OriginOf(ENT_ME), creatorValue2); // Send to client immediately - calls client_activate on client
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseNpc_OnGameSpawn(playerRace, playerGender); // monsters/base_npc

		PLAYING_DEAD = "1"; // not valid target

		SetName("Fire Wall");
		SetHealth(1);
		SetInvincible(true);
		SetSolid("none");
		SetBoundingBox("none");
		SetFieldOfView(90);
		SetWidth(32);
		SetHeight(32);
		SetRoam(false);
		SetSkillLevel(0);
		SetHearingSensitivity(0);
		SetBlood("none");
		SetModel("none");

		CallEventDelayed(2.0f, "flames_start"); // Start doing damage after a delay

		LegacyCommand("emitsound", ENT_ME, OriginOf(ENT_ME), 192, TIME_LIVE, "danger", 192);
	}

	// flames_attack
	// Deal damage
	void OnFlamesAttack()
	{
		CallEventDelayed(0.5f, "flames_attack");

		if (!FLAMING)
			return;
		DoDamage(Text(RelativePosition(Vector3(0, 0, 0))), 96, MY_BASE_DMG, "100%", 0, "reflective", "fire");
		DoDamage(Text(RelativePosition(Vector3(0, 96, 0))), 96, MY_BASE_DMG, "100%", 0, "reflective", "fire");
		DoDamage(Text(RelativePosition(Vector3(0, -96, 0))), 96, MY_BASE_DMG, "100%", 0, "reflective", "fire");
	}

	// firewall_death
	// Pewf
	void OnFirewallDeath()
	{
		FLAMING = false;
		OnFirewallEndCl();
		SetAlive(false);
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
		CallEventDelayed(0.5f, "flames_attack");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		KeledrosFireWall_FirstThink();
		BaseNpc_FirstThink();
		MonstersExternals_FirstThink();
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
		return BaseNpcScript::DispatchEvent(name, params);
	}
}
