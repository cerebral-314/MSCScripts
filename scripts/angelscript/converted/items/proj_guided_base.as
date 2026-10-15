#pragma context server

// Converted from items/proj_guided_base.script by msc_transpiler.

#include "runtime/ScriptEntity.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class ProjGuidedBase
{
	// Variables (an unset .script variable reads as its own name)
	string GPROJ_TARGET = "GPROJ_TARGET";
	float GPROJ_TARG_HALF_HEIGHT = 0.0f;
	bool GPROJ_ACTIVE = false;

	// game_tossprojectile
	// Should be attachable to near any projectile
	// tempted to make universal, but would add to projectile load time
	void ProjGuidedBase_OnGameTossprojectile()
	{
		if (!Truthy(ScriptVarOf(ENT_EXPOWNER, "PROJ_GUIDED")))
			return;
		if (!IsPlayer(ENT_EXPOWNER))
			GPROJ_TARGET = ScriptVarOf(ENT_EXPOWNER, "NPCATK_TARGET");
		else
			GPROJ_TARGET = ScriptVarOf(ENT_EXPOWNER, "PROJ_GUIDED_TARGET");

		if (!IsPlayer(GPROJ_TARGET))
			GPROJ_TARG_HALF_HEIGHT = HeightOf(GPROJ_TARGET) * 0.5f;
		else
			GPROJ_TARG_HALF_HEIGHT = 0.0f;

		GPROJ_ACTIVE = true;
		CallEventDelayed(0.1f, "gproj_home");
	}

	// gproj_home
	void ProjGuidedBase_OnGprojHome()
	{
		if (!GPROJ_ACTIVE)
			return;
		if (!IsAlive(GPROJ_TARGET))
			return;
		CallEventDelayed(0.25f, "gproj_home");
		// dbg homing on $get(GPROJ_TARGET,name)
		Vector3 targOrg = OriginOf(GPROJ_TARGET);
		targOrg.z += GPROJ_TARG_HALF_HEIGHT;
		Vector3 myOrg = OriginOf(ENT_ME);
		Vector3 angToTarg = Angles3DTo(myOrg, targOrg);
		angToTarg.x = -angToTarg.x;
		SetProp(ENT_ME, "velocity", RelativeVelocity(angToTarg, Vector3(0, 300, 0)));
		SetProp(ENT_ME, "movedir", angToTarg);
	}

	// projectile_landed
	void ProjGuidedBase_OnProjectileLanded()
	{
		GPROJ_ACTIVE = false;
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)
	void OnGameTossprojectile() { ProjGuidedBase_OnGameTossprojectile(); } // game_tossprojectile
	void OnGprojHome() { ProjGuidedBase_OnGprojHome(); } // gproj_home
	void OnProjectileLanded() { ProjGuidedBase_OnProjectileLanded(); } // projectile_landed

	// This file's events and timers by their .script names
	bool ProjGuidedBase_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "game_tossprojectile") { OnGameTossprojectile(); return true; }
		if (name == "gproj_home") { OnGprojHome(); return true; }
		if (name == "projectile_landed") { OnProjectileLanded(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "items/proj_guided_base"]
shared class ProjGuidedBaseScript : ScriptEntity, ProjGuidedBase
{
	// Variables every script that includes this file declares
	string ANIM_DEPLOY = "ANIM_DEPLOY";
	string ANIM_DROPPED = "ANIM_DROPPED";
	int ARROW_BODY_OFS = 0;
	string ARROW_BREAK_CHANCE = "ARROW_BREAK_CHANCE";
	int ARROW_EXPIRE_DELAY = 0;
	bool ARROW_SOLIDIFY_ON_WALL = false;
	bool BARROW_HIT_NPC = false;
	string BASE_MODEL_WORLD = "BASE_MODEL_WORLD";
	string BITEM_DEBUG_CALLER = "BITEM_DEBUG_CALLER";
	string BITEM_DEBUG_OUT = "BITEM_DEBUG_OUT";
	string BOLT_TRACE_END = "BOLT_TRACE_END";
	bool BP_HIT_TARGET = false;
	float BWEAPON_BASE_ANIM_SPEED = 0.0f;
	string CLFX_ARROW_IDX = "CLFX_ARROW_IDX";
	bool CLFX_ARROW_INIT = false;
	bool CLFX_ARROW_IN_FLIGHT = false;
	string CLFX_ARROW_SCRIPT = "CLFX_ARROW_SCRIPT";
	float CLFX_ARROW_UPDATE_RATE = 0.0f;
	int HITWALL_VOL = 0;
	bool IS_RESERVED = false;
	string ITEM_BASE_SPEED = "ITEM_BASE_SPEED";
	string ITEM_BASE_STRIKE = "ITEM_BASE_STRIKE";
	bool ITEM_RESERVED = false;
	bool ITEM_SWIFT_BLADE = false;
	string MODEL_HANDS = "MODEL_HANDS";
	string MODEL_WORLD = "MODEL_WORLD";
	CBaseEntity@ MY_XBOW = null;
	string PROJ_ANIM_IDLE = "PROJ_ANIM_IDLE";
	float PROJ_AOE_FALLOFF = 0.0f;
	int PROJ_AOE_RANGE = 0;
	int PROJ_COLLIDEHITBOX = 0;
	string PROJ_DAMAGE = "PROJ_DAMAGE";
	string PROJ_DAMAGE_TYPE = "PROJ_DAMAGE_TYPE";
	bool PROJ_DELETING = false;
	bool PROJ_IGNORENPC = false;
	bool PROJ_MOTIONBLUR = false;
	int PROJ_STICK_DURATION = 0;
	bool PROJ_STICK_ON_NPC = false;
	string SOUND_EXPLODE1 = "SOUND_EXPLODE1";
	string SOUND_EXPLODE2 = "SOUND_EXPLODE2";
	string SOUND_EXPLODE3 = "SOUND_EXPLODE3";
	string SOUND_HITWALL1 = "SOUND_HITWALL1";
	string SOUND_HITWALL2 = "SOUND_HITWALL2";
	string SPRITE_ARROW_HAND = "SPRITE_ARROW_HAND";
	string SPRITE_ARROW_TRADE = "SPRITE_ARROW_TRADE";

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return ProjGuidedBase_DispatchEvent(name, params);
	}
}
