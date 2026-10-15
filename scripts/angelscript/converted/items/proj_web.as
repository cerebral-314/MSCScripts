#pragma context server

// Converted from items/proj_web.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/items/proj_base.as"

[script "items/proj_web"]
class ProjWeb : ProjBaseScript
{
	// Constants
	string SOUND_HITWALL1 = "none";
	string SOUND_HITWALL2 = "none";
	string MODEL_BODY_OFS = "62";
	string PROJ_ANIM_IDLE = "axis_spin";
	string CLFX_ARROW = "0";
	bool CLFX_ARROW_NOSTICK = true;
	int PROJ_STICK_DURATION = 0;
	bool PROJ_STICK_ON_WALL_NEW = false;

	// Variables (an unset .script variable reads as its own name)
	float SCALE_SIZE = 0.0f;

	// Variables declared by included files, with the value they start with in this script
	ProjWeb()
	{
		MODEL_HANDS = "none";
		MODEL_WORLD = "weapons/projectiles.mdl";
		PROJ_DAMAGE_TYPE = "magic";
		PROJ_DAMAGE = "100";
		PROJ_STICK_ON_NPC = false;
		PROJ_MOTIONBLUR = false;
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseItemExtras_OnGameSpawn(playerRace, playerGender); // items/base_item_extras
		ProjBase_OnGameSpawn(playerRace, playerGender); // items/proj_base
		SetName("Web");
		SetDescription("Ew, it's sticky");

		SetGravity(0.07f);
		SCALE_SIZE = 0.1f;
		SetProp(ENT_ME, "scale", 0.1f);
	}

	// game_tossprojectile
	void OnGameTossprojectile()
	{
		ProjBase_OnGameTossprojectile(); // items/proj_base

		// playanim loop PROJ_ANIM_IDLE
		// setidleanim PROJ_ANIM_IDLE
		OnExpandLoop();
	}

	// game_projectile_hitnpc
	void OnGameProjectileHitnpc(CBaseEntity@ target = null)
	{
		ProjBase_OnGameProjectileHitnpc(target); // items/proj_base
		float dur;

		if (IsPlayer(ENT_EXPOWNER))
		{
			dur = Clamp(Divide(SkillOf(ENT_EXPOWNER, "spellcasting.affliction"), 30.0f), 0.0f, 1.0f);
			dur = Ratio(dur, 1.5f, 2.5f);

			if (IsPlayer(target) && !IsPvp())
				return;
		}
		else
		{
			dur = 2.5f;
		}

		string relationship = RelationshipOf(ENT_EXPOWNER, @target);
		if (relationship == "ally")
			return;
		if (relationship == "neutral")
			return;
		if (relationship == "none")
			return;

		ApplyEffect(target, "effects/webbed", dur, @EntityOf(ENT_EXPOWNER));
	}

	// expand_loop
	void OnExpandLoop()
	{
		if (!(SCALE_SIZE < 1.0f))
			return;
		SCALE_SIZE += 0.01f;
		SetProp(ENT_ME, "scale", SCALE_SIZE);
		CallEventDelayed(0.1f, "expand_loop");
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
		if (name == "expand_loop") { OnExpandLoop(); return true; }
		if (name == "game_projectile_hitnpc") { OnGameProjectileHitnpc(EntityParam(params, 0)); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "game_tossprojectile") { OnGameTossprojectile(); return true; }
		return ProjBaseScript::DispatchEvent(name, params);
	}
}
