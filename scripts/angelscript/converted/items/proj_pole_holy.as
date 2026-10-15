#pragma context server

// Converted from items/proj_pole_holy.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/items/proj_arrow_base.as"

[script "items/proj_pole_holy"]
class ProjPoleHoly : ProjArrowBaseScript
{
	// Constants
	string MODEL_BODY_OFS = "61";
	int ARROW_BODY_OFS = 61;
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

	// Variables (an unset .script variable reads as its own name)
	int GAME_PVP = 0;

	// Variables declared by included files, with the value they start with in this script
	ProjPoleHoly()
	{
		MODEL_HANDS = "none";
		MODEL_WORLD = "weapons/projectiles.mdl";
		ARROW_EXPIRE_DELAY = 2;
		SOUND_HITWALL1 = "weapons/xbow_hit1.wav";
		SOUND_HITWALL2 = "weapons/xbow_hit1.wav";
		PROJ_DAMAGE_TYPE = "holy";
		PROJ_MOTIONBLUR = false;
		PROJ_DAMAGE = "0";
	}

	// game_tossprojectile
	void OnGameTossprojectile()
	{
		ProjBase_OnGameTossprojectile(); // items/proj_base
		ProjArrowBase_OnGameTossprojectile(); // items/proj_arrow_base
		GAME_PVP = (IsPvp() ? 1 : 0);
		ClientEvent("new", "all", "effects/sfx_follow_glow_cl", IndexOf(ENT_ME), Vector3(255, 255, 255), 128, 1.5f);
	}

	// game_projectile_hitnpc
	void OnGameProjectileHitnpc(CBaseEntity@ target = null)
	{
		ProjBase_OnGameProjectileHitnpc(target); // items/proj_base
		ProjArrowBase_OnGameProjectileHitnpc(target); // items/proj_arrow_base
		bool exitSub = false;

		if (IsPlayer(target) && GAME_PVP == 0)
			exitSub = true;
		if (exitSub)
			return;

		if (RelationshipOf(target, ENT_EXPOWNER) != "enemy")
			return;

		float dmg = 800.0f;
		float ownerSkillRatio = SkillOf(ENT_EXPOWNER, "polearms") * 0.01f;
		dmg *= ownerSkillRatio;

		int pushStr = 800;

		Vector3 targOrg = OriginOf(target);
		Vector3 myOrg = OriginOf(ENT_EXPOWNER);
		float targAng = AnglesTo(myOrg, targOrg);
		int newYaw = int(targAng);
		SetVelocity(target, RelativeVelocity(Vector3(0, newYaw, 0), Vector3(0, pushStr, 0)));

		float holyDmg = SkillOf(ENT_EXPOWNER, "spellcasting.divination") * 5.0f;
		CallExternal(target, "turn_undead", holyDmg, @EntityOf(ENT_EXPOWNER));

		if (!IsAlive(target))
			return;
		DoDamageEx(@target, "direct", dmg, "100%", ENT_EXPOWNER, ENT_ME, "polearms", "holy");
	}

	// arrow_spawn
	void OnArrowSpawn()
	{
		SetName("Holy Lance");
		SetDescription("This holy weapon has made you holie");
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
		if (name == "game_tossprojectile") { OnGameTossprojectile(); return true; }
		return ProjArrowBaseScript::DispatchEvent(name, params);
	}
}
