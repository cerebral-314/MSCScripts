#pragma context server

// Converted from monsters/companion/bear_image.script by msc_transpiler.

#include "runtime/ScriptEntity.as"

[script "monsters/companion/bear_image"]
class BearImage : ScriptEntity
{
	// Variables (an unset .script variable reads as its own name)
	string ANIM_IDLE = "bear_standingidle02";
	string ANIM_ATTACK = "ANIM_ATTACK";
	string PLAYING_DEAD = "PLAYING_DEAD";
	string MY_OWNER = "MY_OWNER";
	bool DID_DEATH = false;

	// unnamed block (first think)
	void BearImage_FirstThink()
	{
		ANIM_ATTACK = "bear_claw";
		ANIM_IDLE = "bear_standingidle02";
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		SetModel("monsters/giant_rat.mdl");
		SetModelBody(0, 5);
		PLAYING_DEAD = "1";
		SetSolid("none");
		SetBoundingBox(Vector3(0, 0, 0), Vector3(0, 0, 0));
		SetIdleAnim(ANIM_IDLE);
		SetMoveAnim(ANIM_IDLE);
		SetInvincible(true);
		SetGravity(0);
		SetRoam(false);
		SetRace("beloved");
	}

	// game_dynamically_created
	void OnGameDynamicallyCreated(string creatorValue1 = "", string creatorValue2 = "", string damage = "", string skill = "", string extraValue5 = "", string extraValue6 = "", float alwaysPush = 0.0f, string duration = "", string extraValue9 = "")
	{
		MY_OWNER = creatorValue1;
		// setprop ent_me movetype 12
		// setprop ent_me aiment MY_OWNER
		float ownerYaw = AnglesOf(MY_OWNER).y;
		SetAngle("face", Vector3(0, ownerYaw, 0));
		LegacyCommand("setfollow", MY_OWNER, "align_bottom");
	}

	// ext_attack
	void OnExtAttack()
	{
		PlayAnim("once", ANIM_ATTACK);
	}

	// player_left
	void OnPlayerLeft(CBaseEntity@ player = null)
	{
		DebugPrint("bear_delete player_left");
		DeleteEntity(ENT_ME);
	}

	// remove_bear
	void OnRemoveBear()
	{
		DebugPrint("bear_delete remove_bear");
		DeleteEntity(ENT_ME);
	}

	// ext_bear_die
	void OnExtBearDie(string reason = "")
	{
		DebugPrint("bear_delete ext_bear_die " + reason);
		if (DID_DEATH)
			return;
		DID_DEATH = true;
		LegacyCommand("setfollow", "none");
		Vector3 ownerPos = OriginOf(MY_OWNER);
		ownerPos.z = GroundHeight(ownerPos);
		SetOrigin(ENT_ME, ownerPos);
		float ownerYaw = AnglesOf(MY_OWNER).y;
		SetAngle("face", Vector3(0, ownerYaw, 0));
		SetIdleAnim("bear_diestanding");
		SetMoveAnim("bear_diestanding");
		PlayAnim("break");
		PlayAnim("hold", "bear_diestanding");
		CallEventDelayed(3.0f, "bear_fade");
	}

	// bear_fade
	void OnBearFade()
	{
		DeleteEntity(ENT_ME, "fade");
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/giant_rat.mdl");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		BearImage_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "bear_fade") { OnBearFade(); return true; }
		if (name == "ext_attack") { OnExtAttack(); return true; }
		if (name == "ext_bear_die") { OnExtBearDie(Param(params, 0)); return true; }
		if (name == "game_dynamically_created") { OnGameDynamicallyCreated(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Float(Param(params, 6)), Param(params, 7), Param(params, 8)); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "player_left") { OnPlayerLeft(EntityParam(params, 0)); return true; }
		if (name == "remove_bear") { OnRemoveBear(); return true; }
		return false;
	}
}
