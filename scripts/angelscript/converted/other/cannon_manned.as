#pragma context server

// Converted from other/cannon_manned.script by msc_transpiler.
// attach to func_rotating by adding scriptname parameter and this scriptfile

#include "runtime/ScriptEntity.as"

[script "other/cannon_manned"]
class CannonManned : ScriptEntity
{
	// Constants
	string SPRITE_EXPLODE = "bigsmoke.spr";
	string SOUND_CANNON = "weapons/explode3.wav";
	float FREQ_FIRE = 30.0f;
	int DMG_CANNON = 1000;

	// Variables (an unset .script variable reads as its own name)
	float SRC_YAW = 0.0f;
	bool AM_AIMING = false;
	CBasePlayer@ AIMER_ID = null;
	float FIRE_DELAY = 0.0f;

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		SetName("Cannon");
		SetModel("props/cannon.mdl");
		SetInvincible(true);
		SetBlood("none");
		SetWidth(32);
		SetHeight(48);
		SetHealth(20);
		SetRoam(false);
		SetMenuAutoOpen(true);
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
		SRC_YAW = AnglesOf(ENT_ME).y;

		if (int(FIRE_DELAY) == 0)
		{
			if (!AM_AIMING)
			{
				AM_AIMING = true;
				OnAimLoop();
				@AIMER_ID = player;
			}
			menuItem.title = "Fire!";
			menuItem.type = "callback";
			menuItem.callback = "fire_cannon";
			RegisterMenuItem(menuItem);

			menuItem.title = "Aim";
			menuItem.type = "callback";
			menuItem.callback = "aim_cannon";
			RegisterMenuItem(menuItem);
		}

		if (int(FIRE_DELAY) != 0)
		{
			menuItem.title = "Reloading...";
			menuItem.type = "disabled";
			menuItem.callback = "none";
			RegisterMenuItem(menuItem);
		}
	}

	// game_menu_cancel
	void OnGameMenuCancel(CBasePlayer@ player = null)
	{
		AM_AIMING = false;
	}

	// aim_cannon
	void OnAimCannon(CBasePlayer@ aimer = null)
	{
		AM_AIMING = true;
		@AIMER_ID = aimer;
		OnAimLoop();
	}

	// aim_loop
	void OnAimLoop()
	{
		if (!AM_AIMING)
			return;
		if (RangeTo(AIMER_ID) > 64.0f)
		{
			bool exitSub = true;
			AM_AIMING = false;
		}
		CallEventDelayed(0.1f, "aim_loop");
		float aimerYaw = AnglesOf(AIMER_ID).y;
		float angDiff = AngleDifference(aimerYaw, SRC_YAW);
		DebugPrint("aim_loop " + Text(angDiff));
		bool aimOkay = false;
		if (angDiff >= -45.0f && angDiff <= 45.0f)
			aimOkay = true;
		if (!aimOkay)
			return;
		SetAngle("face", Vector3(0, aimerYaw, 0));
	}

	// fire_cannon
	void OnFireCannon()
	{
		AM_AIMING = false;
		PlaySound(0, 10, SOUND_CANNON);

		if (ToLowerCase(MapName()) != "oceancrossing")
		{
			SetAngle("add_view.x", 20); // wtf?
		}

		// <projectile scriptname> <"view"|(src_origin)> <target|(targ_origin)|none> <speed> <damage> <cof> <skill|none> //Converted to use new tossprojectile //greatguys1@FEB2022
		TossProjectile("proj_cannon_ball", RelativePosition(Vector3(0, 32, 32)), "none", 400, DMG_CANNON, 0, "none");

		Effect("tempent", "spray", SPRITE_EXPLODE, RelativePosition(Vector3(0, 0, 0)), 0, 1, 0, 0);
		Effect("screenshake", RelativePosition(Vector3(0, 0, 0)), 380, 20, 1, 512);
		FIRE_DELAY = 1.0f;
		CallEventDelayed(FREQ_FIRE, "reset_fire_delay");
		UseTrigger("cannon_fired");
		PlayAnim("critical", "shoot");
	}

	// reset_fire_delay
	void OnResetFireDelay()
	{
		FIRE_DELAY = 0.0f;
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

	// Events whose included handlers run differently here than in the included files
	void OnFreqFire() {} // FREQ_FIRE

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
		if (name == "aim_cannon") { OnAimCannon(PlayerParam(params, 0)); return true; }
		if (name == "aim_loop") { OnAimLoop(); return true; }
		if (name == "fire_cannon") { OnFireCannon(); return true; }
		if (name == "game_death") { OnGameDeath(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_menu_cancel") { OnGameMenuCancel(PlayerParam(params, 0)); return true; }
		if (name == "game_menu_getoptions") { OnGameMenuGetoptions(PlayerParam(params, 0)); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "game_struck") { OnGameStruck(Float(Param(params, 0)), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "get_src_yaw") { OnGetSrcYaw(); return true; }
		if (name == "reset_fire_delay") { OnResetFireDelay(); return true; }
		return false;
	}
}
