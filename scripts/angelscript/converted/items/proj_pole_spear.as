#pragma context server

// Converted from items/proj_pole_spear.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/items/proj_arrow_base.as"

[script "items/proj_pole_spear"]
class ProjPoleSpear : ProjArrowBaseScript
{
	// Constants
	string MODEL_BODY_OFS = "57";
	int ARROW_BODY_OFS = 57;
	int ARROW_STICK_DURATION = 5;
	bool ARROW_SOLIDIFY_ON_WALL = false;
	string ARROW_BREAK_CHANCE = "100%";
	string ITEM_NAME = "watermana";
	string PROJ_DAMAGESTAT = "spellcasting.ice";
	string PROJ_ANIM_IDLE = "idle_icebolt";
	int PROJ_AOE_RANGE = 0;
	float PROJ_AOE_FALLOFF = 0.0f;
	int PROJ_STICK_DURATION = 0;
	bool PROJ_COLLIDE = true;

	// Variables declared by included files, with the value they start with in this script
	ProjPoleSpear()
	{
		MODEL_HANDS = "none";
		MODEL_WORLD = "weapons/projectiles.mdl";
		SOUND_HITWALL1 = "weapons/xbow_hit1.wav";
		SOUND_HITWALL2 = "weapons/xbow_hit1.wav";
		PROJ_DAMAGE = "1";
	}

	// game_projectile_hitnpc
	void OnGameProjectileHitnpc(CBaseEntity@ target = null)
	{
		ProjBase_OnGameProjectileHitnpc(target); // items/proj_base
		ProjArrowBase_OnGameProjectileHitnpc(target); // items/proj_arrow_base

		float dmg = 75.0f;
		float ownerSkillRatio = SkillOf(ENT_EXPOWNER, "polearms") * 0.01f;
		dmg *= ownerSkillRatio;

		float chargeLevel = Float(ScriptVarOf(ENT_EXPOWNER, "PLR_SPEAR_CHARGE_LEVEL"));
		DebugPrint("game_projectile_hitnpc " + Text(chargeLevel));
		chargeLevel *= 2.0f; // boost value of charge level
		chargeLevel += 1.0f;

		dmg *= chargeLevel;

		Vector3 targOrg = OriginOf(target);
		Vector3 ownerOrg = OriginOf(ENT_EXPOWNER);
		float targDist = Distance(ownerOrg, targOrg);
		if (targDist < 256.0f)
		{
			// reduce damage if in melee range
			float distRatio = targDist;
			string distRatioText;
			distRatio = Divide(distRatio, 256.0f);
			distRatioText = Text(distRatio);
			DebugPrint("too_close " + distRatioText + " ( dist " + Text(targDist) + " )");
			dmg *= distRatio;
		}

		DoDamageEx(@target, "direct", dmg, "100%", ENT_EXPOWNER, ENT_ME, "polearms", "pierce");
	}

	// arrow_spawn
	void OnArrowSpawn()
	{
		SetName("Wooden Spear");
		SetDescription("A pointy ended stick that someone threw");
		SetWeight(0.1f);
		SetValue(0);
		SetGravity(0.8f);
		SetGroupable(25);
	}

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
		if (name == "game_projectile_hitnpc") { OnGameProjectileHitnpc(EntityParam(params, 0)); return true; }
		return ProjArrowBaseScript::DispatchEvent(name, params);
	}
}
