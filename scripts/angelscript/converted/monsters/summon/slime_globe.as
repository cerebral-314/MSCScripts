#pragma context server

// Converted from monsters/summon/slime_globe.script by msc_transpiler.
// Big ball of slime, grows, tosses out semi-guided slime balls at great distances

#include "runtime/ScriptEntity.as"

[script "monsters/summon/slime_globe"]
class SlimeGlobe : ScriptEntity
{
	// Constants
	string ORBIT_SOUND1 = "tentacle/te_move1.wav";
	string ORBIT_SOUND2 = "tentacle/te_move2.wav";
	string SOUND_SHOOT = "magic/blackhole.wav";

	// Variables (an unset .script variable reads as its own name)
	string PLAYING_DEAD = "PLAYING_DEAD";
	string MY_OWNER = "MY_OWNER";
	string MY_DMG = "MY_DMG";
	bool IS_ACTIVE = false;
	float NEXT_ORBIT_SOUND = 0.0f;
	string MY_CL_IDX = "MY_CL_IDX";
	string GLOB_TARG = "GLOB_TARG";

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		SetName("Globe of Slime");
		SetInvincible(true);
		SetNoPush(true);
		SetGravity(0);
		SetFly(true);
		SetModel("null.mdl");
		SetWidth(2);
		SetHeight(2);
		PLAYING_DEAD = "1";
		SetSolid("none");
		SetBoundingBox("none");
	}

	// game_dynamically_created
	// <owner> <dmg> <dot>
	void OnGameDynamicallyCreated(string creatorValue1 = "", string creatorValue2 = "", string damage = "", string skill = "", string extraValue5 = "", string extraValue6 = "", float alwaysPush = 0.0f, string duration = "", string extraValue9 = "")
	{
		DebugPrint("game_dynamically_created " + creatorValue1 + " " + creatorValue2 + " " + damage);
		// DOT handled owner side via glob_dodamage
		MY_OWNER = creatorValue1;
		MY_DMG = creatorValue2;
		SetRace(RaceOf(MY_OWNER));
		CallEventDelayed(0.1f, "setup_cl");
		IS_ACTIVE = true;
		CallEventDelayed(3.0f, "shoot_slime");
		CallEventDelayed(13.0f, "end_slime");
		PlayRandomSound(1, 10, ORBIT_SOUND1, ORBIT_SOUND2);
		NEXT_ORBIT_SOUND = GameTime() + 3.0f;
	}

	// setup_cl
	void OnSetupCl()
	{
		ClientEvent("new", "all", "monsters/summon/slime_globe_cl", OriginOf(ENT_ME), 13.0f);
		MY_CL_IDX = LastClientScriptId();
	}

	// shoot_slime
	void OnShootSlime()
	{
		if (!IS_ACTIVE)
			return;
		CallEventDelayed(1.0f, "shoot_slime");
		GLOB_TARG = "none";
		string targList = FindInSphere("enemy", 1200);
		if (targList == "none")
			return;
		targList = TokenShuffle(targList);
		CBaseEntity@ curTarg = FindEntity(GetToken(targList, 0));
		GLOB_TARG = EntityId(curTarg); // for use by projectile
		SetMoveDest(@curTarg, 9999);

		// <projectile scriptname> <"view"|(src_origin)> <target|(targ_origin)|none> <speed> <damage> <cof> <skill|none> //Converted to use new tossprojectile //greatguys1@FEB2022
		TossProjectile("proj_glob_guided", "view", @curTarg, 400, 0, 1, "none");

		if (!(GameTime() > NEXT_ORBIT_SOUND))
			return;
		PlayRandomSound(1, 10, ORBIT_SOUND1, ORBIT_SOUND2);
		PlaySound(2, 10, SOUND_SHOOT);
		NEXT_ORBIT_SOUND = GameTime() + 3.0f;
	}

	// end_slime
	void OnEndSlime()
	{
		IS_ACTIVE = false;
		CallEventDelayed(5.0f, "remove_me"); // give some time for projectiles to land / DOTs to finish
	}

	// remove_me
	void OnRemoveMe(string caller = "")
	{
		DeleteEntity(ENT_ME);
	}

	// ext_glob_landed
	// <origin> - from items/proj_glob_dynamic
	void OnExtGlobLanded(string origin = "")
	{
		DoDamageEx(origin, 96, MY_DMG, 0.2f, MY_OWNER, MY_OWNER, "none", "acid_effect", "dmgevent:glob");
	}

	// early_remove
	void OnEarlyRemove()
	{
		ClientEvent("update", "all", MY_CL_IDX, "early_remove");
		OnEndSlime();
	}

	// ext_mommy_died
	void OnExtMommyDied(string deathPosition = "")
	{
		OnEarlyRemove();
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("xfireball3.spr");
		Precache("null.mdl");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "early_remove") { OnEarlyRemove(); return true; }
		if (name == "end_slime") { OnEndSlime(); return true; }
		if (name == "ext_glob_landed") { OnExtGlobLanded(Param(params, 0)); return true; }
		if (name == "ext_mommy_died") { OnExtMommyDied(Param(params, 0)); return true; }
		if (name == "game_dynamically_created") { OnGameDynamicallyCreated(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Float(Param(params, 6)), Param(params, 7), Param(params, 8)); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "remove_me") { OnRemoveMe(Param(params, 0)); return true; }
		if (name == "setup_cl") { OnSetupCl(); return true; }
		if (name == "shoot_slime") { OnShootSlime(); return true; }
		return false;
	}
}
