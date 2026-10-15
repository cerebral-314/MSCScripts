#pragma context server

// Converted from items/proj_volcano_fixed.script by msc_transpiler.
// Volcano with projectile locked at 50dmg for da novablade

#include "runtime/ScriptEntity.as"
#include "converted/items/proj_volcano.as"

[script "items/proj_volcano_fixed"]
class ProjVolcanoFixed : ProjVolcanoScript
{
	// game_dodamage
	string ProjVolcanoFixed_OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		bool exitSub = false;
		string result = "";

		if (!hit)
			return result;

		// effect glow ent_laststruckbyme (255,75,0) 128 1 1
		CBaseEntity@ fMyOwner = EntityOf(ENT_EXPOWNER);
		bool ownerIsplayer = IsPlayer(fMyOwner);

		if (IsPlayer(target) && ownerIsplayer && !IsPvp())
			exitSub = true;
		if (exitSub)
			return result;

		int dmgFire = 50;
		ApplyEffect(target, "effects/dot_fire", 5, @fMyOwner, dmgFire, "spellcasting.fire");
		return result;
	}

	string OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "") { return ProjVolcanoFixed_OnGameDodamage(hit, target, start, end, damageType, damageText); } // game_dodamage

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "game_dodamage") { Return(OnGameDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5))); return true; }
		return ProjVolcanoScript::DispatchEvent(name, params);
	}
}
