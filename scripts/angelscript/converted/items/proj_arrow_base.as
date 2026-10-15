#pragma context server

// Converted from items/proj_arrow_base.script by msc_transpiler.
// Removed CLIENT_PROJECTILE support. (Client side arrows that used "cleffect ce") //greatguys1@JAN2022
// Base Arrow
// Req. Variables
// ARROW_BODY_OFS
// ARROW_EXPIRE_DELAY
// ARROW_SOLIDIFY_ON_WALL
// ARROW_BREAK_CHANCE

#include "runtime/ScriptEntity.as"
#include "converted/items/proj_base.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class ProjArrowBase
{
	// Constants
	string MODEL_HANDS = "weapons/bows/arrows.mdl";
	string MODEL_WORLD = "weapons/bows/arrows.mdl";
	string BASE_MODEL_WORLD = "weapons/bows/arrows.mdl";
	string SOUND_HITWALL1 = "weapons/bow/arrowhit1.wav";
	string SOUND_HITWALL2 = "weapons/bow/arrowhit2.wav";
	string SPRITE_ARROW_TRADE = "woodenarrow";
	string SPRITE_ARROW_HAND = "arrows";
	int HITWALL_VOL = 5;
	int ARROW_EXPIRE_DELAY = 10;
	string PROJ_DAMAGE_TYPE = "pierce";
	int PROJ_COLLIDEHITBOX = 1;

	// Variables (an unset .script variable reads as its own name)
	string ANIM_DEPLOY = "ANIM_DEPLOY";
	string ANIM_DROPPED = "ANIM_DROPPED";
	bool BARROW_HIT_NPC = false;

	// projectile_spawn
	void ProjArrowBase_OnProjectileSpawn()
	{
		if (GetVar("PROJ_ANIM_IDLE") == "PROJ_ANIM_IDLE")
		{
			if (MODEL_WORLD == BASE_MODEL_WORLD)
			{
				ANIM_DEPLOY = "idle2";
				ANIM_DROPPED = "idle1";
			}
			else
			{
				ANIM_DEPLOY = "idle_standard";
				ANIM_DROPPED = "idle_standard";
			}
		}
		else
		{
			ANIM_DEPLOY = GetVar("PROJ_ANIM_IDLE");
			ANIM_DROPPED = GetVar("PROJ_ANIM_IDLE");
		}

		SetGroupable(25);

		SetWorldModel(MODEL_WORLD);
		SetHudSprite("hand", SPRITE_ARROW_HAND);
		SetHudSprite("trade", SPRITE_ARROW_TRADE);
		SetHand("left");

		OnArrowSpawn();
	}

	// game_deploy
	void ProjArrowBase_OnGameDeploy()
	{
		SetModel(MODEL_HANDS);
		if (ANIM_DEPLOY != "none")
			PlayAnim(ANIM_DEPLOY);

		float mbTemp = ItemHandIndex() + 1.0f + Float(GetVar("ARROW_BODY_OFS"));
		SetModelBody(0, int(mbTemp));
		OnArrowDeploy();
		SetGravity(1);
	}

	// game_tossprojectile
	void ProjArrowBase_OnGameTossprojectile()
	{
		// clientevent new all_in_sight effects/sfx_motionblur $get(ent_me,index)
		if (Truthy(GetVar("CLFX_ARROW")))
			return;
		SetModelBody(0, Int(GetVar("ARROW_BODY_OFS")));
		if (ANIM_DROPPED != "none")
			PlayAnim(ANIM_DROPPED);
	}

	// game_fall
	void ProjArrowBase_OnGameFall()
	{
		if (!Truthy(GetVar("CLFX_ARROW")))
			SetModelBody(0, Int(GetVar("ARROW_BODY_OFS")));
		if (ANIM_DROPPED != "none")
			PlayAnim(ANIM_DROPPED);
	}

	// game_projectile_hitwall
	// <origin before removal>
	void ProjArrowBase_OnGameProjectileHitwall()
	{
		PlayRandomSound(4, HITWALL_VOL, SOUND_HITWALL1, SOUND_HITWALL2);
	}

	// game_projectile_hitnpc
	void ProjArrowBase_OnGameProjectileHitnpc(CBaseEntity@ target = null)
	{
		BARROW_HIT_NPC = true;

		if (PROJ_STICK_ON_NPC)
			return;
		if (PROJ_IGNORENPC)
			return;
		OnRemoveProjectile("barrow_hitnpc");
	}

	// projectile_landed
	void ProjArrowBase_OnProjectileLanded()
	{
		if (BARROW_HIT_NPC)
			return;
		if (Truthy(GetVar("PROJ_STICK_ON_WALL_NEW")))
			return;
		// expiretime 1 //ARROW_EXPIRE_DELAY	//Let the fired arrows stay around for a bit
		CallEventDelayed(ARROW_EXPIRE_DELAY, "remove_projectile");
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)

	// game_fall
	void OnGameFall()
	{
		BaseItemExtras_OnGameFall(); // items/base_item_extras
		BaseItemExtras_OnGameFall_2(); // items/base_item_extras
		ProjBase_OnGameFall(); // items/proj_base
		ProjArrowBase_OnGameFall();
	}

	// game_deploy
	void OnGameDeploy()
	{
		BaseItemExtras_OnGameDeploy(); // items/base_item_extras
		BaseItemExtras_OnGameDeploy_2(); // items/base_item_extras
		BaseItemExtras_OnGameDeploy_3(); // items/base_item_extras
		ProjArrowBase_OnGameDeploy();
	}

	// game_tossprojectile
	void OnGameTossprojectile()
	{
		ProjBase_OnGameTossprojectile(); // items/proj_base
		ProjArrowBase_OnGameTossprojectile();
	}

	// game_projectile_hitwall
	void OnGameProjectileHitwall()
	{
		ProjBase_OnGameProjectileHitwall(); // items/proj_base
		ProjArrowBase_OnGameProjectileHitwall();
	}

	// game_projectile_hitnpc
	void OnGameProjectileHitnpc(CBaseEntity@ target = null)
	{
		ProjBase_OnGameProjectileHitnpc(target); // items/proj_base
		ProjArrowBase_OnGameProjectileHitnpc(target);
	}

	void OnProjectileSpawn() { ProjArrowBase_OnProjectileSpawn(); } // projectile_spawn
	void OnProjectileLanded() { ProjArrowBase_OnProjectileLanded(); } // projectile_landed
	void OnArrowExpireDelay() {} // ARROW_EXPIRE_DELAY
	void OnArrowDeploy() {} // arrow_deploy
	void OnArrowSpawn() {} // arrow_spawn

	// This file's events and timers by their .script names
	bool ProjArrowBase_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "game_deploy") { OnGameDeploy(); return true; }
		if (name == "game_fall") { OnGameFall(); return true; }
		if (name == "game_projectile_hitnpc") { OnGameProjectileHitnpc(EntityParam(params, 0)); return true; }
		if (name == "game_projectile_hitwall") { OnGameProjectileHitwall(); return true; }
		if (name == "game_tossprojectile") { OnGameTossprojectile(); return true; }
		if (name == "projectile_landed") { OnProjectileLanded(); return true; }
		if (name == "projectile_spawn") { OnProjectileSpawn(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "items/proj_arrow_base"]
shared class ProjArrowBaseScript : ProjBaseScript, ProjArrowBase
{
	// Variables declared by included files, with the value they start with in this script
	ProjArrowBaseScript()
	{
		MODEL_HANDS = "weapons/bows/arrows.mdl";
		MODEL_WORLD = "weapons/bows/arrows.mdl";
		PROJ_DAMAGE_TYPE = "pierce";
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("weapons/bows/arrows.mdl");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return ProjArrowBase_DispatchEvent(name, params)
			|| ProjBaseScript::DispatchEvent(name, params);
	}
}
