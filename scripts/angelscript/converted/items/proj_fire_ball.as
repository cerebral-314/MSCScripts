#pragma context server

// Converted from items/proj_fire_ball.script by msc_transpiler.
// Thothie - fireball from Firedart
// fireball projectile

#include "runtime/ScriptEntity.as"
#include "converted/items/proj_base.as"

[script "items/proj_fire_ball"]
class ProjFireBall : ProjBaseScript
{
	// Constants
	string SOUND_BURN = "items/torch1.wav";
	string SPRITE_FIRE = "3dmflaora.spr";
	string SPRITE_BURN = "fire1_fixed.spr";
	string ITEM_NAME = "firemana";
	string PROJ_DAMAGESTAT = "spellcasting";
	int PROJ_AOE_RANGE = 250;
	float PROJ_AOE_FALLOFF = 0.0f;
	int PROJ_STICK_DURATION = 0;
	bool PROJ_SOLIDIFY_ON_WALL = false;
	string SCRIPT_1 = "items/proj_fire_dart_cl";

	// Variables (an unset .script variable reads as its own name)
	string SCRIPT_1_ID = "SCRIPT_1_ID";
	string MY_OWNER = "MY_OWNER";
	string LOCK_BURN_DAMAGE = "LOCK_BURN_DAMAGE";

	// Variables declared by included files, with the value they start with in this script
	ProjFireBall()
	{
		MODEL_HANDS = "none";
		MODEL_WORLD = "weapons/projectiles.mdl";
		PROJ_DAMAGE_TYPE = "fire";
		PROJ_COLLIDEHITBOX = 64;
	}

	// unnamed block (first think)
	void ProjFireBall_FirstThink()
	{
		PrecacheFile(SCRIPT_1);
	}

	// game_tossprojectile
	void OnGameTossprojectile()
	{
		ProjBase_OnGameTossprojectile(); // items/proj_base

		// Called here because the origin isn't set in spawn
		SCRIPT_1_ID = LastClientScriptId();
	}

	// projectile_spawn
	void OnProjectileSpawn()
	{
		SetName("Fireball");
		SetWeight(500);
		// attempting adding size for larger collision box
		SetValue(5);
		SetGravity(0.7f);

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
		if (Truthy(ScriptVarOf(ENT_EXPOWNER, "PROJ_NO_SPRITES")))
			return;
		Effect("tempent", "trail", "rjet1.spr", RelativePosition(Vector3(0, 0, 0)), RelativePosition(Vector3(0, 0, 10)), 10, 2, 5, 10, 20); // more nifty effects
	}

	// game_hitnpc
	void OnGameHitnpc()
	{
		float burnDamage = 0.0f;
		// experimental
		MY_OWNER = EntityId(EntityOf(ENT_EXPOWNER));
		if (LOCK_BURN_DAMAGE == "LOCK_BURN_DAMAGE")
		{
			burnDamage = SkillOf(ENT_EXPOWNER, "spellcasting.fire") * 0.25f;
			if (!IsPlayer(MY_OWNER))
				burnDamage = 10.0f;
		}
		if (LOCK_BURN_DAMAGE != "LOCK_BURN_DAMAGE")
			burnDamage = Float(LOCK_BURN_DAMAGE);
		// dbg BurnDamage BURN_DAMAGE
		ApplyEffect(ENT_LASTSTRUCKBYME, "effects/dot_fire", 5, MY_OWNER, burnDamage, "spellcasting.fire");
	}

	// lighten
	// param1 = fire dmg
	void OnLighten(string fireDamage = "", string gravity = "")
	{
		if (gravity.isEmpty())
			gravity = "0.4";
		SetGravity(Float(gravity));
		LOCK_BURN_DAMAGE = fireDamage;
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("fire1_fixed.spr");
		Precache("rjet1.spr");
		Precache("weapons/projectiles.mdl");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		ProjFireBall_FirstThink();
		BaseItemExtras_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "game_hitnpc") { OnGameHitnpc(); return true; }
		if (name == "game_tossprojectile") { OnGameTossprojectile(); return true; }
		if (name == "lighten") { OnLighten(Param(params, 0), Param(params, 1)); return true; }
		if (name == "projectile_landed") { OnProjectileLanded(); return true; }
		if (name == "projectile_spawn") { OnProjectileSpawn(); return true; }
		return ProjBaseScript::DispatchEvent(name, params);
	}
}
