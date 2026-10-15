#pragma context server

// Converted from items/proj_troll_lightning.script by msc_transpiler.
// Thothie - Troll Rock from proj_catapult
// - monsters/summon/rock_storm also uses this projectile
// - When Rock Storm becomes a player spell, you'll have to zero the damage on this and
// - create an AOE damage that grabs the XP owner via the scriptvar ROCK_OWNER on the caster

#include "runtime/ScriptEntity.as"
#include "converted/items/proj_arrow_base.as"

[script "items/proj_troll_lightning"]
class ProjTrollLightning : ProjArrowBaseScript
{
	// Constants
	int ARROW_BODY_OFS = 20;
	string MODEL_BODY_OFS = "20";
	string PROJ_ANIM_IDLE = "idle_standard";
	int PROJ_STICK_DURATION = 0;
	bool ARROW_SOLIDIFY_ON_WALL = false;
	string ARROW_BREAK_CHANCE = "100%";
	int PROJ_AOE_RANGE = 200;
	float PROJ_AOE_FALLOFF = 0.0f;

	// Variables (an unset .script variable reads as its own name)
	string SHOCK_TARGETS = "SHOCK_TARGETS";

	// Variables declared by included files, with the value they start with in this script
	ProjTrollLightning()
	{
		MODEL_WORLD = "weapons/projectiles.mdl";
		PROJ_MOTIONBLUR = false;
		PROJ_DAMAGE_TYPE = "lightning";
		PROJ_IGNORENPC = true;
	}

	// game_precache
	void OnGamePrecache()
	{
		PrecacheFile("effects/sfx_shock_burst");
	}

	// game_projectile_hitwall
	void OnGameProjectileHitwall()
	{
		ProjBase_OnGameProjectileHitwall(); // items/proj_base
		ProjArrowBase_OnGameProjectileHitwall(); // items/proj_arrow_base

		Vector3 myOrg = OriginOf(ENT_ME);
		Effect("screenshake", RelativePosition(Vector3(0, 0, 0)), 100, 5, 3, 500);
		ClientEvent("new", "all", "effects/sfx_shock_burst", myOrg, 256, 1, Vector3(255, 255, 0));
		string myDmg = ScriptVarOf(ENT_EXPOWNER, "PROJ_SHOCK_DMG");
		DoDamageEx(myOrg, 256, myDmg, 0, ENT_EXPOWNER, ENT_EXPOWNER, "none", "lightning");
		SHOCK_TARGETS = LegacyFunction("get_tsphere", "any", 256, myOrg);
		DebugPrint("game_projectile_hitwall " + myDmg + " " + SHOCK_TARGETS);
		if (SHOCK_TARGETS == "none")
			return;
		int count = GetTokenCount(SHOCK_TARGETS);
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnApplyEffect();
		}
	}

	// arrow_spawn
	void OnArrowSpawn()
	{
		SetName("Big Ball o Lightning");
		SetDescription("Big zappy thang");
		SetWeight(0.1f);
		SetValue(0);
		SetGravity(0.4f);
		SetGroupable(25);
	}

	// apply_effect
	void OnApplyEffect()
	{
		CBaseEntity@ curTarg = FindEntity(GetToken(SHOCK_TARGETS, loopIteration));
		if (RelationshipOf(ENT_EXPOWNER, @curTarg) != "enemy")
			return;
		ApplyEffect(curTarg, "effects/dot_lightning", 8.0f, @EntityOf(ENT_EXPOWNER), ScriptVarOf(ENT_EXPOWNER, "PROJ_SHOCK_DOT"));
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("weapons/projectiles.mdl");
		Precache("weapons/bows/arrows.mdl");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "apply_effect") { OnApplyEffect(); return true; }
		if (name == "arrow_spawn") { OnArrowSpawn(); return true; }
		if (name == "game_precache") { OnGamePrecache(); return true; }
		if (name == "game_projectile_hitwall") { OnGameProjectileHitwall(); return true; }
		return ProjArrowBaseScript::DispatchEvent(name, params);
	}
}
