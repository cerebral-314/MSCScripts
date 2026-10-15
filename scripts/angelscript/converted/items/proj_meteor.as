#pragma context server

// Converted from items/proj_meteor.script by msc_transpiler.
// Thothie - fireball from Firedart
// fireball projectile

#include "runtime/ScriptEntity.as"
#include "converted/items/proj_arrow_base.as"

[script "items/proj_meteor"]
class ProjMeteor : ProjArrowBaseScript
{
	// Constants
	int ARROW_BODY_OFS = 41;
	string PROJ_ANIM_IDLE = "idle_icebolt";
	int PROJ_STICK_DURATION = 0;
	bool ARROW_SOLIDIFY_ON_WALL = false;
	string ARROW_BREAK_CHANCE = "100%";
	string PROJ_DAMAGESTAT = "spellcasting.fire";
	int PROJ_AOE_RANGE = 512;
	float PROJ_AOE_FALLOFF = 0.4f;

	// Variables declared by included files, with the value they start with in this script
	ProjMeteor()
	{
		MODEL_WORLD = "weapons/projectiles.mdl";
		PROJ_DAMAGE_TYPE = "fire";
	}

	// projectile_spawn
	void OnProjectileSpawn()
	{
		ProjArrowBase_OnProjectileSpawn(); // items/proj_arrow_base

		SetName("Fireball");
		SetWeight(500);
		// attempting adding size for larger collision box
		SetValue(5);
		SetGravity(0);

		SetModelBody(0, 0);

		SetHudSprite("hand", "arrows");
		SetHudSprite("trade", "ITEM_NAME");
		SetHand("any");

		ServerPlaySound(0, 10, "weapons/mortar.wav");
	}

	// projectile_landed
	void OnProjectileLanded()
	{
		ProjArrowBase_OnProjectileLanded(); // items/proj_arrow_base

		Effect("screenshake", OriginOf(ENT_ME), 512, 10, 3.0f, 512);
		Effect("tempent", "spray", "bigsmoke.spr", RelativePosition(Vector3(0, 0, 0)), 0, 4, 0, 0);
		PlaySound(0, 10, "weapons/mortarhit.wav");
	}

	// game_hitnpc
	void OnGameHitnpc()
	{
		CBaseEntity@ myOwner = EntityOf(ENT_EXPOWNER);
		float burnDamage = SkillOf(ENT_EXPOWNER, "spellcasting.fire") * 0.25f;
		if (!IsPlayer(myOwner))
			burnDamage = Float(ScriptVarOf(myOwner, "DOT_NUKE"));
		ApplyEffect(ENT_LASTSTRUCKBYME, "effects/dot_fire", 5, @myOwner, burnDamage, "spellcasting.fire");
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("weapons/projectiles.mdl");
		Precache("weapons/bows/arrows.mdl");
		Precache("weapons/mortar.wav");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "game_hitnpc") { OnGameHitnpc(); return true; }
		if (name == "projectile_landed") { OnProjectileLanded(); return true; }
		if (name == "projectile_spawn") { OnProjectileSpawn(); return true; }
		return ProjArrowBaseScript::DispatchEvent(name, params);
	}
}
