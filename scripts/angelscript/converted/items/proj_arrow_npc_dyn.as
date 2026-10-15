#pragma context server

// Converted from items/proj_arrow_npc_dyn.script by msc_transpiler.
// Thothie SEP2009_15
// Basic NPC arrow with some extra features
// (no need to tack these onto the original npc arrow, just more overhead for all the beasts who don't use the features)

#include "runtime/ScriptEntity.as"
#include "converted/items/proj_arrow_npc.as"

[script "items/proj_arrow_npc_dyn"]
class ProjArrowNpcDyn : ProjArrowNpcScript
{
	// game_dodamage
	// PARAM1=hit:0|1 PARAM2=ent_hit PARAM3=(start) PARAM4=(end)
	string ProjArrowNpcDyn_OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";

		// if PARAM1 //in case hit canceled by special defense
		CallExternal(ENT_EXPOWNER, "ext_arrow_hit", hit, @target, start, end);
		return result;
	}

	// ext_lighten
	// <gravity> [glow:0|1] [glow_color] [scale]
	void OnExtLighten(string gravity = "", int glowFlag = 0, Vector3 glowColor = Vector3(), string scale = "")
	{
		ProjBase_OnExtLighten(gravity, glowFlag, glowColor, scale); // items/proj_base
		SetGravity(Float(gravity));
		if (!scale.isEmpty())
			SetProp(ENT_ME, "scale", scale);
		if (glowFlag == 0)
			return;
		Effect("glow", ENT_ME, glowColor, 64, -1, -1);
		ClientEvent("new", "all", "effects/sfx_follow_glow_cl", IndexOf(ENT_ME), glowColor, 96, 3.0f);
	}

	// projectile_landed
	void OnProjectileLanded()
	{
		ProjArrowBase_OnProjectileLanded(); // items/proj_arrow_base
		CallExternal(ENT_EXPOWNER, "ext_arrow_landed", OriginOf(ENT_ME));
	}

	string OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "") { return ProjArrowNpcDyn_OnGameDodamage(hit, target, start, end, damageType, damageText); } // game_dodamage

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "ext_lighten") { OnExtLighten(Param(params, 0), Int(Param(params, 1)), Vec(Param(params, 2)), Param(params, 3)); return true; }
		if (name == "game_dodamage") { Return(OnGameDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5))); return true; }
		if (name == "projectile_landed") { OnProjectileLanded(); return true; }
		return ProjArrowNpcScript::DispatchEvent(name, params);
	}
}
