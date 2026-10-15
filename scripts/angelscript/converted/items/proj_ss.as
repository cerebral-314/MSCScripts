#pragma context server

// Converted from items/proj_ss.script by msc_transpiler.
// Spiral arrow - does damage as it flies

#include "runtime/ScriptEntity.as"
#include "converted/items/proj_arrow_base.as"

[script "items/proj_ss"]
class ProjSs : ProjArrowBaseScript
{
	// Constants
	int ARROW_BODY_OFS = 55;
	string PROJ_ANIM_IDLE = "spin_horizontal_fast";
	bool ARROW_SOLIDIFY_ON_WALL = false;
	string MODEL_BODY_OFS = "55";
	int PROJ_STICK_DURATION = 0;
	bool PROJ_SOLIDIFY_ON_WALL = false;
	int PROJ_DAMAGE_AOE_RANGE = 0;
	bool PROJ_DAMAGE_AOE_FALLOFF = false;
	int SCAN_RANGE = 64;

	// Variables (an unset .script variable reads as its own name)
	float DMG_AMT = 0.0f;
	string WEAPON_ID = "WEAPON_ID";
	string ACTIVE_SKILL = "ACTIVE_SKILL";
	bool IS_ACTIVE = false;

	// Variables declared by included files, with the value they start with in this script
	ProjSs()
	{
		MODEL_HANDS = "weapons/projectiles.mdl";
		MODEL_WORLD = "weapons/projectiles.mdl";
		HITWALL_VOL = 2;
		PROJ_MOTIONBLUR = false;
		PROJ_DAMAGE = "0";
		PROJ_DAMAGE_TYPE = "dark";
		PROJ_IGNORENPC = true;
	}

	// game_projectile_hitwall
	void ProjSs_OnGameProjectileHitwall()
	{
		OnRemoveMe();
	}

	// game_tossprojectile
	void OnGameTossprojectile()
	{
		ProjBase_OnGameTossprojectile(); // items/proj_base
		ProjArrowBase_OnGameTossprojectile(); // items/proj_arrow_base

		CallEventDelayed(10.0f, "remove_me"); // max dist

		if (!IsPlayer(ENT_EXPOWNER))
		{
			DMG_AMT = Float(ScriptVarOf(ENT_EXPOWNER, "DMG_SCYTHE_THROW"));
			WEAPON_ID = EntityId(EntityOf(ENT_EXPOWNER));
			ACTIVE_SKILL = "none";
		}
		else
		{
			DMG_AMT = SkillOf(ENT_EXPOWNER, "spellcasting.affliction") * 3.0f;
			WEAPON_ID = ScriptVarOf(ENT_EXPOWNER, "PLR_ACTIVE_WEAPON");
			DebugPrint("game_tossprojectile " + WEAPON_ID);
			CallExternal(WEAPON_ID, "ext_register_projectile", self);
			ACTIVE_SKILL = ScriptVarOf(WEAPON_ID, "WEAPON_PRIMARY_SKILL");
		}

		IS_ACTIVE = true;
		CallEventDelayed(0.01f, "damage_area");
	}

	// arrow_spawn
	void OnArrowSpawn()
	{
		SetName("Skull Scythe");
		SetDescription("Someone threw this thing with the intention of doing harm");
		SetWeight(0);
		SetValue(1);
		SetGravity(0.0001f);

		SetModel("weapons/projectiles.mdl");
		SetModelBody(0, ARROW_BODY_OFS); // %%

		// setprop ent_me rendermode 5
		// setprop ent_me renderamt 255
		ServerPlaySound(1, 10, "fans/fan1.wav");
	}

	// game_fall
	// override base_arrow.  Just do nothing
	void OnGameFall()
	{
	}

	// game_projectile_hitnpc
	void OnGameProjectileHitnpc(CBaseEntity@ target = null)
	{
	}

	// game_projectile_landed
	void OnGameProjectileLanded()
	{
		OnRemoveMe();
	}

	// damage_area
	void OnDamageArea()
	{
		if (!IS_ACTIVE)
			return;
		CallEventDelayed(0.2f, "damage_area");
		// <target|(src_origin)> <range|aoe|(dest_origin)|direct> <damage> <cth|fall_off> <attacker> <inflciter> <skill|none> <dmg_type> [flag_string]
		DoDamageEx(OriginOf(ENT_ME), SCAN_RANGE, DMG_AMT, 0.75f, ENT_EXPOWNER, WEAPON_ID, ACTIVE_SKILL, "dark");
	}

	// game_projectile_hitwall
	void OnGameProjectileHitwall()
	{
		OnRemoveMe();
	}

	// remove_me
	void OnRemoveMe(string caller = "")
	{
		if (!IsPlayer(ENT_EXPOWNER))
		{
			CallExternal(ENT_EXPOWNER, "ext_sscythe_done"); // tell monster his ball popped
		}
		else
		{
			Vector3 sprPos = OriginOf(ENT_EXPOWNER);
			float ownerYaw = AnglesOf(ENT_EXPOWNER).y;
			sprPos += RelativePosition(Vector3(0, ownerYaw, 0), Vector3(10, 32, 20));

			// same CL effect as Unholy Blade on return
			ClientEvent("new", "all", "items/proj_ub_cl", OriginOf(ENT_ME), sprPos);

			if (caller != "remote") // when called by player
				CallExternal(ScriptVarOf(ENT_EXPOWNER, "PLR_ACTIVE_WEAPON"), "ext_projectile_landed");
		}

		IS_ACTIVE = false;
		ServerPlaySound(1, 0, "fans/fan1.wav");
		DeleteEntity(ENT_ME);
		RemoveScript();
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("weapons/projectiles.mdl");
		Precache("fans/fan1.wav");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "arrow_spawn") { OnArrowSpawn(); return true; }
		if (name == "damage_area") { OnDamageArea(); return true; }
		if (name == "game_fall") { OnGameFall(); return true; }
		if (name == "game_projectile_hitnpc") { OnGameProjectileHitnpc(EntityParam(params, 0)); return true; }
		if (name == "game_projectile_hitwall") { OnGameProjectileHitwall(); return true; }
		if (name == "game_projectile_landed") { OnGameProjectileLanded(); return true; }
		if (name == "game_tossprojectile") { OnGameTossprojectile(); return true; }
		if (name == "remove_me") { OnRemoveMe(Param(params, 0)); return true; }
		return ProjArrowBaseScript::DispatchEvent(name, params);
	}
}
