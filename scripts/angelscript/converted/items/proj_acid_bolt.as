#pragma context server

// Converted from items/proj_acid_bolt.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/items/proj_arrow_base.as"

[script "items/proj_acid_bolt"]
class ProjAcidBolt : ProjArrowBaseScript
{
	// Constants
	string POISON_SPRITE1 = "poison.spr";
	string TRAIL_SPRITE = "blood.spr";
	int ARROW_BODY_OFS = 6;
	string MODEL_BODY_OFS = "6";
	string ITEM_NAME = "watermana";
	string PROJ_DAMAGESTAT = "spellcasting.affliction";
	string PROJ_ANIM_IDLE = "idle_icebolt";
	int PROJ_AOE_RANGE = 40;
	float PROJ_AOE_FALLOFF = 0.1f;
	int PROJ_STICK_DURATION = 0;

	// Variables declared by included files, with the value they start with in this script
	ProjAcidBolt()
	{
		MODEL_HANDS = "weapons/projectiles.mdl";
		MODEL_WORLD = "weapons/projectiles.mdl";
		PROJ_DAMAGE_TYPE = "acid";
		PROJ_DAMAGE = "600";
		PROJ_COLLIDEHITBOX = 32;
	}

	// game_tossprojectile
	// end projectile_spawn
	void OnGameTossprojectile()
	{
		ProjBase_OnGameTossprojectile(); // items/proj_base
		ProjArrowBase_OnGameTossprojectile(); // items/proj_arrow_base

		SetGravity(0);
		OnFlyFx();
	}

	// projectile_spawn
	void OnProjectileSpawn()
	{
		ProjArrowBase_OnProjectileSpawn(); // items/proj_arrow_base

		SetName("Acidic Bolt");
		SetWeight(1);
		SetValue(5);
		SetGravity(0);
		SetGroupable(25);

		SetModelBody(0, Int(MODEL_BODY_OFS));

		SetHudSprite("hand", "arrows");
		SetHudSprite("trade", ITEM_NAME);
		SetHand("any");
	}

	// projectile_landed
	void OnProjectileLanded()
	{
		ProjArrowBase_OnProjectileLanded(); // items/proj_arrow_base

		Effect("tempent", "trail", POISON_SPRITE1, RelativePosition(Vector3(0, 0, 0)), RelativePosition(Vector3(0, 0, 30)), 10, 1, 5, 10, 5); // more nifty effects
	}

	// fly_fx
	void OnFlyFx()
	{
		Effect("tempent", "spray", TRAIL_SPRITE, RelativePosition(Vector3(0, 0, 0)), RelativeVelocity(Vector3(0, -30, 0)), 10, 3, 50); // more nifty effects
		CallEventDelayed(0.25f, "fly_fx");
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
		if (name == "fly_fx") { OnFlyFx(); return true; }
		if (name == "game_tossprojectile") { OnGameTossprojectile(); return true; }
		if (name == "projectile_landed") { OnProjectileLanded(); return true; }
		if (name == "projectile_spawn") { OnProjectileSpawn(); return true; }
		return ProjArrowBaseScript::DispatchEvent(name, params);
	}
}
