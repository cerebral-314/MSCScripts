#pragma context server

// Converted from items/proj_fire_dart.script by msc_transpiler.
// Thothie - burn damage increase with spell casting ability
// fireball projectile

#include "runtime/ScriptEntity.as"
#include "converted/items/proj_base.as"

[script "items/proj_fire_dart"]
class ProjFireDart : ProjBaseScript
{
	// Constants
	string SOUND_HITWALL1 = "weapons/bow/arrowhit1.wav";
	string SOUND_HITWALL2 = "weapons/bow/arrowhit1.wav";
	string SOUND_BURN = "items/torch1.wav";
	string SPRITE_FIRE = "3dmflaora.spr";
	string SPRITE_BURN = "fire1_fixed.spr";
	string ITEM_NAME = "firemana";
	string PROJ_DAMAGESTAT = "spellcasting";
	int PROJ_AOE_RANGE = 75;
	float PROJ_AOE_FALLOFF = 0.0f;
	int PROJ_STICK_DURATION = 0;
	bool PROJ_SOLIDIFY_ON_WALL = false;
	string BURN_DAMAGE = "BURN_DAMAGE";
	string CL_SCRIPT = "items/proj_fire_dart_cl";

	// Variables (an unset .script variable reads as its own name)
	string CL_SCRIPT_ID = "CL_SCRIPT_ID";

	// Variables declared by included files, with the value they start with in this script
	ProjFireDart()
	{
		MODEL_HANDS = "none";
		MODEL_WORLD = "weapons/projectiles.mdl";
		PROJ_DAMAGE_TYPE = "fire";
	}

	// unnamed block (first think)
	void ProjFireDart_FirstThink()
	{
		PrecacheFile(CL_SCRIPT);
	}

	// game_tossprojectile
	void OnGameTossprojectile()
	{
		ProjBase_OnGameTossprojectile(); // items/proj_base

		// Called here because the origin isn't set in spawn
		CL_SCRIPT_ID = LastClientScriptId();
	}

	// projectile_spawn
	void OnProjectileSpawn()
	{
		SetName("Fireball");
		SetWeight(500);
		SetValue(5);
		SetGravity(0.7f);
		SetGroupable(25);

		SetModelBody(0, 0);

		SetHudSprite("hand", "arrows");
		SetHudSprite("trade", ITEM_NAME);
		SetHand("any");
		Effect("glow", ENT_ME, Vector3(255, 75, 0), 128, 1, 1);
	}

	// projectile_landed
	void OnProjectileLanded()
	{
		Effect("screenshake", RelativePosition(Vector3(0, 0, 0)), 50, 20, "DURATION", 256);
	}

	// game_hitnpc
	void OnGameHitnpc()
	{
		// experimental
		CBaseEntity@ myOwner = EntityOf(ENT_EXPOWNER);
		// add BURN_DAMAGE $get(ent_owner,skill.spellcasting.fire)
		// dbg Damage BURN_DAMAGE OwnerRatio $get(ent_owner,skill.spellcasting.fire.ratio)
		ApplyEffect(ENT_LASTSTRUCKBYME, "effects/dot_fire", 5, @myOwner, BURN_DAMAGE, "spellcasting.fire");
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("fire1_fixed.spr");
		Precache("weapons/projectiles.mdl");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		ProjFireDart_FirstThink();
		BaseItemExtras_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "game_hitnpc") { OnGameHitnpc(); return true; }
		if (name == "game_tossprojectile") { OnGameTossprojectile(); return true; }
		if (name == "projectile_landed") { OnProjectileLanded(); return true; }
		if (name == "projectile_spawn") { OnProjectileSpawn(); return true; }
		return ProjBaseScript::DispatchEvent(name, params);
	}
}
