#pragma context server

// Converted from items/proj_arrow_frost.script by msc_transpiler.
// Frost Arrow by Thothie (From Poison Arrow)

#include "runtime/ScriptEntity.as"
#include "converted/items/proj_arrow_base.as"

[script "items/proj_arrow_frost"]
class ProjArrowFrost : ProjArrowBaseScript
{
	// Constants
	string CLFX_ARROW = "1";
	string MODEL_BODY_OFS = "6";
	int ARROW_STICK_DURATION = 25;
	bool ARROW_SOLIDIFY_ON_WALL = false;
	string ARROW_BREAK_CHANCE = "50%";

	// Variables declared by included files, with the value they start with in this script
	ProjArrowFrost()
	{
		SPRITE_ARROW_TRADE = "silverarrow";
		PROJ_DAMAGE_TYPE = "cold";
		PROJ_DAMAGE = "$rand(60,100)";
	}

	// game_dodamage
	string ProjArrowFrost_OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		float dot;
		string result = "";

		if (!hit)
			return result;

		CBaseEntity@ myOwner = EntityOf(ENT_EXPOWNER);

		if (IsPlayer(myOwner))
		{
			dot = SkillOf(myOwner, "spellcasting.ice") * 0.5f;
			if (dot < 5.0f)
				dot = RandomInt(5, 10);
		}
		else
		{
			dot = RandomInt(5, 10);
		}

		ApplyEffect(target, "effects/dot_cold", dot, @myOwner, 5, "archery");
		return result;
	}

	// arrow_spawn
	void OnArrowSpawn()
	{
		SetName("Frost Arrow");
		SetDescription("These arrows have been enchanted with ice magics.");
		SetWeight(0.125f);
		SetValue(150);
		SetGravity(0.8f);
		SetGroupable(25);
		LegacyCommand("useable", 1);
	}

	string OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "") { return ProjArrowFrost_OnGameDodamage(hit, target, start, end, damageType, damageText); } // game_dodamage

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
