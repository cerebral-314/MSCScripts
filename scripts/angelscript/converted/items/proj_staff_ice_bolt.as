#pragma context server

// Converted from items/proj_staff_ice_bolt.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/items/proj_arrow_base.as"

[script "items/proj_staff_ice_bolt"]
class ProjStaffIceBolt : ProjArrowBaseScript
{
	// Constants
	string MODEL_BODY_OFS = "7";
	int ARROW_BODY_OFS = 7;
	string SOUND_BURN = "magic/ice_powerup.wav";
	bool ARROW_SOLIDIFY_ON_WALL = false;
	string ARROW_BREAK_CHANCE = "100%";
	string ITEM_NAME = "watermana";
	string PROJ_DAMAGESTAT = "spellcasting.ice";
	string PROJ_ANIM_IDLE = "idle_icebolt";
	int PROJ_STICK_DURATION = 0;

	// Variables declared by included files, with the value they start with in this script
	ProjStaffIceBolt()
	{
		MODEL_HANDS = "none";
		MODEL_WORLD = "weapons/projectiles.mdl";
		SOUND_HITWALL1 = "weapons/axemetal1.wav";
		SOUND_HITWALL2 = "weapons/axemetal1.wav";
		PROJ_DAMAGE_TYPE = "cold";
		PROJ_MOTIONBLUR = false;
		PROJ_DAMAGE = "0";
		PROJ_COLLIDEHITBOX = 0;
	}

	// game_projectile_hitnpc
	void OnGameProjectileHitnpc(CBaseEntity@ target = null)
	{
		ProjBase_OnGameProjectileHitnpc(target); // items/proj_base
		ProjArrowBase_OnGameProjectileHitnpc(target); // items/proj_arrow_base
		bool exitSub = false;

		CBaseEntity@ myOwner = EntityOf(ENT_EXPOWNER);
		bool ownerIsplayer = IsPlayer(myOwner);

		if ((ownerIsplayer ? 1 : 0) == 1 && !IsPvp() && IsPlayer(target))
			exitSub = true;
		if (exitSub)
			return;

		if (RelationshipOf(myOwner, @target) != "enemy")
			return;

		DoDamageEx(@target, "direct", SkillOf(myOwner, "spellcasting.ice"), "100%", @myOwner, ENT_ME, "spellcasting.ice", "cold");

		float effectDuration = SkillOf(myOwner, "spellcasting.ice");
		float dotIce = SkillOf(myOwner, "spellcasting.ice");
		effectDuration *= 0.5f;
		dotIce *= 0.5f;
		effectDuration = Clamp(effectDuration, 3.0f, 5.0f);

		ApplyEffect(target, "effects/dot_cold", effectDuration, @myOwner, dotIce, "spellcasting.ice");
	}

	// arrow_spawn
	void OnArrowSpawn()
	{
		SetName("Ice Bolt");
		SetDescription("A sharp bolt of ice");
		SetWeight(0.1f);
		SetValue(0);
		SetGravity(0);
		SetGroupable(25);
		SetProp(ENT_ME, "rendermode", 5);
		SetProp(ENT_ME, "renderamt", 255);
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
