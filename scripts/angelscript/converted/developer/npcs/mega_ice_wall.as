#pragma context server

// Converted from developer/npcs/mega_ice_wall.script by msc_transpiler.
// Ice Wall

#include "runtime/ScriptEntity.as"

[script "developer/npcs/mega_ice_wall"]
class MegaIceWall : ScriptEntity
{
	// Constants
	string CANT_TURN = "1";

	// Variables (an unset .script variable reads as its own name)
	string ANIM_DEATH = "ANIM_DEATH";
	string CAN_ATTACK = "CAN_ATTACK";
	string CAN_HUNT = "CAN_HUNT";

	// unnamed block (first think)
	void MegaIceWall_FirstThink()
	{
		ANIM_DEATH = "";
		CAN_ATTACK = "0";
		CAN_HUNT = "0";
	}

	// game_spawn
	// #include monsters/base_npc
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		SetHealth(2999);
		SetName("Mega Ice Wall");

		SetRoam(false);
		SetSkillLevel(0);
		SetHearingSensitivity(0);

		SetModel("misc/icewall.mdl");
		SetWidth(140);
		SetHeight(170);
		SetProp(ENT_ME, "scale", 2.5f);

		SetBlood("none");
		SetRace("hated");

		LegacyCommand("setturnrate", 0.01f);

		OnIcewallUp(); // Plays the up animation

		SetDamageTaken("all", 1.2f);
		SetDamageTaken("fire", 1.2f);
		SetDamageTaken("cold", 1.2f);
		SetDamageTaken("poison", 1.2f);
		SetDamageTaken("acid", 1.2f);
		SetDamageTaken("lightning", 1.2f);
		SetDamageTaken("holy", 1.2f);
		SetDamageTaken("blunt", 1.2f);
		SetDamageTaken("pierce", 1.2f);
		SetDamageTaken("slash", 1.2f);
	}

	// icewall_up
	void OnIcewallUp()
	{
		PlayAnim("hold", "up");
	}

	// game_death
	void OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		OnIceDeathFx();
	}

	// ice_death
	void OnIceDeath()
	{
		DeleteMe();
		OnIceDeathFx();
	}

	// ice_death_fx
	void OnIceDeathFx()
	{
		// originally waterball1.spr - merged with blueflare1.spr for item limit
		SetCallback("touch", "disable");
		Effect("tempent", "trail", "blueflare1.spr", RelativePosition(Vector3(0, 0, 0)), RelativePosition(Vector3(0, 0, 32)), 2, 0.1f, 3, 30, 0);
		Effect("tempent", "trail", "blueflare1.spr", RelativePosition(Vector3(0, 0, 32)), RelativePosition(Vector3(0, 0, 64)), 2, 0.1f, 3, 30, 0);
		Effect("tempent", "trail", "blueflare1.spr", RelativePosition(Vector3(0, 0, 64)), RelativePosition(Vector3(0, 0, 96)), 5, 0.1f, 3, 30, 0);
	}

	// game_menu_getoptions
	void OnGameMenuGetoptions(CBasePlayer@ player = null)
	{
		MenuItem menuItem;

		menuItem.title = "stun resist 33";
		menuItem.type = "callback";
		menuItem.callback = "stun_resist";
		menuItem.data = "0.66";

		RegisterMenuItem(menuItem);
		menuItem.title = "stun resist 66";
		menuItem.type = "callback";
		menuItem.callback = "stun_resist";
		menuItem.data = "0.33";
		RegisterMenuItem(menuItem);

		menuItem.title = "stun resist 100";
		menuItem.type = "callback";
		menuItem.callback = "stun_resist";
		menuItem.data = "0";
		RegisterMenuItem(menuItem);

		menuItem.title = "Die";
		menuItem.type = "callback";
		menuItem.callback = "ice_death";
		RegisterMenuItem(menuItem);
	}

	// stun_resist
	void OnStunResist(CBasePlayer@ value = null, float stunMultiplier = 0.0f)
	{
		SetDamageTaken("stun", stunMultiplier);
		InfoMessage("all", "Stun takedmg", Text(DamageTakenOf(ENT_ME, "stun")));
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("blueflare1.spr");
		Precache("misc/icewall.mdl");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		MegaIceWall_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "game_death") { OnGameDeath(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_menu_getoptions") { OnGameMenuGetoptions(PlayerParam(params, 0)); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "ice_death") { OnIceDeath(); return true; }
		if (name == "ice_death_fx") { OnIceDeathFx(); return true; }
		if (name == "icewall_up") { OnIcewallUp(); return true; }
		if (name == "stun_resist") { OnStunResist(PlayerParam(params, 0), Float(Param(params, 1))); return true; }
		return false;
	}
}
