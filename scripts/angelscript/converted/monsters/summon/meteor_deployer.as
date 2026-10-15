#pragma context server

// Converted from monsters/summon/meteor_deployer.script by msc_transpiler.

#include "runtime/ScriptEntity.as"

[script "monsters/summon/meteor_deployer"]
class MeteorDeployer : ScriptEntity
{
	// Variables (an unset .script variable reads as its own name)
	string PLAYING_DEAD = "PLAYING_DEAD";
	int GAME_PVP = 0;
	string MY_OWNER = "MY_OWNER";
	string OWNER_WEAPON = "OWNER_WEAPON";
	float AUTO_DESTRUCT = 0.0f;

	// game_dodamage
	string MeteorDeployer_OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		bool exitSub = false;
		float dotFire;
		string result = "";
		DebugPrint("game_dodamage " + Text(hit) + " " + NameOf(target));

		if (HasEffect(target, "DOT_fire"))
			return result;
		// if PARAM1
		if (GAME_PVP == 0 && IsPlayer(target))
			exitSub = true;
		if (exitSub)
			return result;
		if (RelationshipOf(target, MY_OWNER) != "enemy")
			return result;

		if (IsPlayer(MY_OWNER))
			dotFire = SkillOf(MY_OWNER, "spellcasting.fire") * 0.75f;
		else
			dotFire = Float(ScriptVarOf(MY_OWNER, "DOT_METEOR"));
		ApplyEffect(target, "effects/dot_fire", 5.0f, MY_OWNER, dotFire);
		return result;
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		SetName("Meteor Deployer");
		DebugPrint("game_spawn");
		SetModel("weapons/projectiles.mdl"); // prob could use null, but not sure if can set view angles on it
		SetModelBody(0, 22);
		// setprop ent_me rendermode 5
		// setprop ent_me renderamt 0
		SetWidth(2);
		SetHeight(2);
		SetSolid("none");
		SetBoundingBox("none");
		SetGravity(0);
		SetRace("beloved");
		SetInvincible(true);
		SetNoPush(true);
		PLAYING_DEAD = "1";
		GAME_PVP = (IsPvp() ? 1 : 0);

		CallEventDelayed(0.1f, "nuke_it");
		CallEventDelayed(3.0f, "remove_me");
	}

	// game_dynamically_created
	// { check_pos
	// local L_POS $get(ent_me,origin)
	// vectoradd L_POS z -16
	// local reg.npcmove.endpos	L_POS
	// local reg.npcmove.testonly	1
	// npcmove ent_me TEST_PLAYER
	// //10 seconds, and still couldn't find a spawn spot
	// if ( game.time > AUTO_DESTRUCT )
	// {
	// callevent remove_me
	// local EXIT_SUB 1
	// }
	// if !EXIT_SUB
	// if ( game.ret.npcmove.dist <= 0 )
	// {
	// dbg failed, moving down $vec.z(L_POS)
	// setorigin ent_me L_POS
	// callevent 0.01 check_pos
	// }
	// else
	// {
	// dbg fire!
	// callevent nuke_it
	// }
	// }
	void OnGameDynamicallyCreated(string creatorValue1 = "", string creatorValue2 = "", string damage = "", string skill = "", string extraValue5 = "", string extraValue6 = "", float alwaysPush = 0.0f, string duration = "", string extraValue9 = "")
	{
		MY_OWNER = creatorValue1;
		OWNER_WEAPON = creatorValue2;
		AUTO_DESTRUCT = GameTime() + 10.0f;
		DebugPrint("game_dynamically_created " + NameOf(MY_OWNER));
	}

	// nuke_it
	void OnNukeIt()
	{
		DebugPrint("nuke_it");
		Vector3 myDest = OriginOf(ENT_ME);
		myDest.z = GroundHeight(myDest);
		SetMoveDest(myDest, 99999);
		// setangle view.pitch 90
		// <projectile scriptname> <"view"|(src_origin)> <target|(targ_origin)|none> <speed> <damage> <cof> <skill|none> //Converted to use new tossprojectile //greatguys1@FEB2022
		TossProjectile("proj_staff_fire_bomb", RelativePosition(Vector3(0, 0, -17)), "none", 300, 0, 0, "none");
		ClientEvent("new", "all", "effects/sfx_seal", myDest, 256, 2, 2.0f);
		ClientEvent("new", "all", "effects/sfx_sprite_in", OriginOf(ENT_ME), "xflare1.spr", 20, 4.0f);
	}

	// ext_fire_bomb
	// <origin>
	void OnExtFireBomb(Vector3 landPosition = Vector3())
	{
		float dmg;
		float fallOff;
		DebugPrint("ext_fire_bomb");

		if (IsPlayer(MY_OWNER))
		{
			dmg = SkillOf(MY_OWNER, "spellcasting.fire") * 4.5f;
			fallOff = 0.1f;
		}
		else
		{
			dmg = Float(ScriptVarOf(MY_OWNER, "DMG_METEOR"));
			fallOff = 0.2f;
		}
		// callexternal OWNER_WEAPON ext_set_fire_bomb
		if (IsPlayer(MY_OWNER))
			DoDamageEx(landPosition, 350, dmg, fallOff, MY_OWNER, OWNER_WEAPON, "spellcasting.fire", "fire_effect");
		else
			DoDamageEx(landPosition, 350, dmg, fallOff, MY_OWNER, MY_OWNER, "none", "fire_effect");
		CallEventDelayed(2.0f, "remove_me");
	}

	// remove_me
	void OnRemoveMe(string caller = "")
	{
		DeleteEntity(ENT_ME);
	}

	string OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "") { return MeteorDeployer_OnGameDodamage(hit, target, start, end, damageType, damageText); } // game_dodamage

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("weapons/projectiles.mdl");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "ext_fire_bomb") { OnExtFireBomb(Vec(Param(params, 0))); return true; }
		if (name == "game_dodamage") { Return(OnGameDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5))); return true; }
		if (name == "game_dynamically_created") { OnGameDynamicallyCreated(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Float(Param(params, 6)), Param(params, 7), Param(params, 8)); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "nuke_it") { OnNukeIt(); return true; }
		if (name == "remove_me") { OnRemoveMe(Param(params, 0)); return true; }
		return false;
	}
}
