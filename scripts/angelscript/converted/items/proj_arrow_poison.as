#pragma context server

// Converted from items/proj_arrow_poison.script by msc_transpiler.
// Thothie - Added based on fire arrow
// Poison Arrow

#include "runtime/ScriptEntity.as"
#include "converted/items/proj_arrow_base.as"

[script "items/proj_arrow_poison"]
class ProjArrowPoison : ProjArrowBaseScript
{
	// Constants
	string CLFX_ARROW = "1";
	string MODEL_BODY_OFS = "0";
	int ARROW_STICK_DURATION = 25;
	bool ARROW_SOLIDIFY_ON_WALL = false;
	string ARROW_BREAK_CHANCE = "50%";

	// Variables declared by included files, with the value they start with in this script
	ProjArrowPoison()
	{
		SPRITE_ARROW_TRADE = "firearrow";
	}

	// game_dodamage
	string ProjArrowPoison_OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";

		if (!hit)
			return result;

		CBaseEntity@ myOwner = EntityOf(ENT_EXPOWNER);

		ApplyEffect(target, "effects/dot_poison", 15, @myOwner, Random(2, 3), "archery");
		return result;
	}

	// arrow_spawn
	void OnArrowSpawn()
	{
		SetName("Envenomed Arrow");
		SetDescription("This sinister arrow has been laced with deadly poison.");
		SetWeight(0.125f);
		SetValue(100);
		SetGravity(0.8f);
		SetGroupable(25);
	}

	string OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "") { return ProjArrowPoison_OnGameDodamage(hit, target, start, end, damageType, damageText); } // game_dodamage

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "arrow_spawn") { OnArrowSpawn(); return true; }
		if (name == "game_dodamage") { Return(OnGameDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5))); return true; }
		return ProjArrowBaseScript::DispatchEvent(name, params);
	}
}
