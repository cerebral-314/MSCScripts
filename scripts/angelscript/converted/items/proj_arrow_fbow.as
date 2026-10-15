#pragma context server

// Converted from items/proj_arrow_fbow.script by msc_transpiler.
// Frost Bow Arrow by CrazyMonkeyDude (From Frost Arrow)
// Either frosts or freezes when it hits
// Freeze costs 10 Mana

#include "runtime/ScriptEntity.as"
#include "converted/items/proj_arrow_base.as"

[script "items/proj_arrow_fbow"]
class ProjArrowFbow : ProjArrowBaseScript
{
	// Constants
	string CLFX_ARROW = "1";
	int ARROW_BODY_OFS = 47;
	string MODEL_BODY_OFS = "47";
	int FREEZE_MANA_COST = 10;
	bool ARROW_SOLIDIFY_ON_WALL = false;

	// Variables declared by included files, with the value they start with in this script
	ProjArrowFbow()
	{
		MODEL_WORLD = "weapons/projectiles.mdl";
		MODEL_HANDS = "weapons/projectiles.mdl";
		SPRITE_ARROW_TRADE = "silverarrow";
		PROJ_DAMAGE_TYPE = "cold";
	}

	// game_dodamage
	string ProjArrowFbow_OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";

		if (!hit)
			return result;

		CBaseEntity@ myOwner = EntityOf(ENT_EXPOWNER);
		float cdotDmg = SkillOf(myOwner, "spellcasting.ice");
		float fdotDmg = cdotDmg;
		cdotDmg = Divide(cdotDmg, 1.8f);
		fdotDmg = Divide(fdotDmg, 2.0f);
		string fdotDmgText = Text(fdotDmg);

		int projType = 0;
		if (ManaOf(myOwner) >= FREEZE_MANA_COST)
			projType = RandomInt(0, 1);
		if (projType == 0)
		{
			ApplyEffect(target, "effects/dot_cold", RandomInt(5, 10), @myOwner, cdotDmg, "spellcasting.ice");
		}
		else
		{
			GiveMana(@myOwner, -FREEZE_MANA_COST);
			ApplyEffect(target, "effects/dot_cold_freeze", 8.0f, @myOwner, fdotDmgText, "spellcasting.ice");
		}
		return result;
	}

	// arrow_spawn
	void OnArrowSpawn()
	{
		SetName("Frosty");
		SetDescription("Brrrr!");
		SetWeight(0.1f);
		SetValue(150);
		SetGravity(0.8f);
		SetGroupable(25);
	}

	string OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "") { return ProjArrowFbow_OnGameDodamage(hit, target, start, end, damageType, damageText); } // game_dodamage

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
		if (name == "arrow_spawn") { OnArrowSpawn(); return true; }
		if (name == "game_dodamage") { Return(OnGameDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5))); return true; }
		return ProjArrowBaseScript::DispatchEvent(name, params);
	}
}
