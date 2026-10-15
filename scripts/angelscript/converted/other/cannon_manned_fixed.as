#pragma context server

// Converted from other/cannon_manned_fixed.script by msc_transpiler.
// attach to func_rotating by adding scriptname parameter and this scriptfile

#include "runtime/ScriptEntity.as"

[script "other/cannon_manned_fixed"]
class CannonMannedFixed : ScriptEntity
{
	// Constants
	string SPRITE_EXPLODE = "bigsmoke.spr";
	string SOUND_CANNON = "weapons/explode3.wav";
	float FREQ_FIRE = 30.0f;
	int DMG_CANNON = 1000;

	// Variables (an unset .script variable reads as its own name)
	float SRC_YAW = 0.0f;
	bool AM_LOADED = false;
	bool AM_AIMING = false;
	float FIRE_DELAY = 0.0f;

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		SetName("Cannon");
		SetModel("props/cannon.mdl");
		SetBlood("none");
		SetWidth(32);
		SetHeight(48);
		SetHealth(20);
		SetRace("human");
		SetRoam(false);
		SetMenuAutoOpen(true);
		SetDamageTaken("stun", 0);
		SetDamageTaken("poison", 0);
		SetDamageTaken("cold", 0);
		SetDamageTaken("lightning", 0.5f);
		SetNoPush(true);
		CallEventDelayed(0.1f, "get_src_yaw");
	}

	// get_src_yaw
	void OnGetSrcYaw()
	{
		SRC_YAW = AnglesOf(ENT_ME).y;
	}

	// game_menu_getoptions
	void OnGameMenuGetoptions(CBasePlayer@ player = null)
	{
		MenuItem menuItem;

		if (!IsAlive(ENT_ME))
			return;

		if (!AM_LOADED)
		{
			if (!Truthy(ItemExists(player, "item_cannon_ball")))
			{
				menuItem.title = "Load Cannon";
				menuItem.type = "disabled";
				RegisterMenuItem(menuItem);
			}
			else
			{
				menuItem.title = "Load Cannon";
				menuItem.type = "payment";
				menuItem.data = "item_cannon_ball";
				menuItem.cb_failed = "no_balls";
				menuItem.callback = "load_cannon";
				RegisterMenuItem(menuItem);
			}
		}
		else
		{
			menuItem.title = "Fire!";
			menuItem.type = "callback";
			menuItem.callback = "fire_cannon";
			RegisterMenuItem(menuItem);
		}
	}

	// no_balls
	void OnNoBalls(CBasePlayer@ player = null)
	{
		PlayerMessageDark(player, "You need a cannon ball to load this weapon.");
	}

	// load_cannon
	void OnLoadCannon()
	{
		AM_LOADED = true;
	}

	// game_menu_cancel
	void OnGameMenuCancel(CBasePlayer@ player = null)
	{
		AM_AIMING = false;
	}

	// fire_cannon
	void OnFireCannon()
	{
		AM_LOADED = false;
		PlaySound(0, 10, SOUND_CANNON);
		SetAngle("view", Vector3(20, Float(Eval("game.monster.angles.yaw")), 0));

		// <projectile scriptname> <"view"|(src_origin)> <target|(targ_origin)|none> <speed> <damage> <cof> <skill|none> //Converted to use new tossprojectile //greatguys1@FEB2022
		TossProjectile("proj_cannon_ball", RelativePosition(Vector3(0, 16, -16)), "none", 400, DMG_CANNON, 0, "none");
		Effect("tempent", "spray", SPRITE_EXPLODE, RelativePosition(Vector3(0, 0, 0)), 0, 1, 0, 0);
		Effect("screenshake", RelativePosition(Vector3(0, 0, 0)), 380, 20, 1, 512);
		FIRE_DELAY = 1.0f;
		UseTrigger("cannon_fired");
		PlayAnim("critical", "shoot");
	}

	// game_death
	void OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		SetMenuAutoOpen(false);
		PlaySound(0, 10, "debris/bustcrate3.wav");
		PlayAnim("critical", "die");
	}

	// game_struck
	void OnGameStruck(float damage = 0.0f, string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		PlayRandomSound(0, 10, "debris/wood1.wav", "debris/wood2.wav");
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("props/cannon.mdl");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "fire_cannon") { OnFireCannon(); return true; }
		if (name == "game_death") { OnGameDeath(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_menu_cancel") { OnGameMenuCancel(PlayerParam(params, 0)); return true; }
		if (name == "game_menu_getoptions") { OnGameMenuGetoptions(PlayerParam(params, 0)); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "game_struck") { OnGameStruck(Float(Param(params, 0)), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "get_src_yaw") { OnGetSrcYaw(); return true; }
		if (name == "load_cannon") { OnLoadCannon(); return true; }
		if (name == "no_balls") { OnNoBalls(PlayerParam(params, 0)); return true; }
		return false;
	}
}
