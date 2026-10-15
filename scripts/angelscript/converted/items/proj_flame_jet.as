#pragma context server

// Converted from items/proj_flame_jet.script by msc_transpiler.
// Jet o flame

#include "runtime/ScriptEntity.as"
#include "converted/items/proj_arrow_base.as"

[script "items/proj_flame_jet"]
class ProjFlameJet : ProjArrowBaseScript
{
	// Constants
	int ARROW_BODY_OFS = 1;
	string PROJ_ANIM_IDLE = "idle_iceball";
	bool ARROW_SOLIDIFY_ON_WALL = false;
	string MODEL_BODY_OFS = "1";
	int PROJ_STICK_DURATION = 0;
	bool PROJ_SOLIDIFY_ON_WALL = false;
	int PROJ_DAMAGE_AOE_RANGE = 0;
	bool PROJ_DAMAGE_AOE_FALLOFF = true;
	int SCAN_RANGE = 64;
	float FREQ_SCAN = 0.5f;

	// Variables (an unset .script variable reads as its own name)
	int GAME_PVP = 0;
	float DMG_AMT = 0.0f;
	string DOT_AMT = "DOT_AMT";
	string USE_SKILL = "USE_SKILL";
	bool IS_ACTIVE = false;
	string MY_CL_IDX = "MY_CL_IDX";
	float NEXT_SCAN = 0.0f;
	string TARGET_LIST = "TARGET_LIST";

	// Variables declared by included files, with the value they start with in this script
	ProjFlameJet()
	{
		MODEL_HANDS = "weapons/projectiles.mdl";
		MODEL_WORLD = "weapons/projectiles.mdl";
		HITWALL_VOL = 2;
		PROJ_MOTIONBLUR = false;
		PROJ_DAMAGE = "0";
		PROJ_DAMAGE_TYPE = "cold";
		PROJ_IGNORENPC = true;
	}

	// game_projectile_hitwall
	void ProjFlameJet_OnGameProjectileHitwall()
	{
		OnRemoveMe();
	}

	// game_tossprojectile
	void OnGameTossprojectile()
	{
		ProjBase_OnGameTossprojectile(); // items/proj_base
		ProjArrowBase_OnGameTossprojectile(); // items/proj_arrow_base

		CallEventDelayed(10.0f, "remove_me"); // max dist

		DMG_AMT = Float(ScriptVarOf(ENT_EXPOWNER, "FLAME_JET_DMG"));
		DOT_AMT = ScriptVarOf(ENT_EXPOWNER, "FLAME_JET_DOT");
		USE_SKILL = ScriptVarOf(ENT_EXPOWNER, "FLAME_JET_SKILL");
		if (!IsPlayer(ENT_EXPOWNER))
			USE_SKILL = "none";

		IS_ACTIVE = true;

		ClientEvent("new", "all", "items/proj_flame_jet_cl", IndexOf(ENT_ME), "xfireball3.spr");
		MY_CL_IDX = LastClientScriptId();

		CallEventDelayed(0.01f, "damage_area");
	}

	// arrow_spawn
	void OnArrowSpawn()
	{
		SetName("Jet of Flame");
		SetDescription("A streaming jet of flames");
		SetWeight(0);
		SetValue(1);
		SetGravity(0.0001f);

		SetModel("weapons/projectiles.mdl");
		SetModelBody(0, 0);
		SetProp(ENT_ME, "rendermode", 5);
		SetProp(ENT_ME, "renaderamt", 0);

		ServerPlaySound(1, 10, "monsters/goblin/sps_fogfire.wav");

		GAME_PVP = (IsPvp() ? 1 : 0);
	}

	// game_fall
	// override base_arrow.  Just do nothing
	void OnGameFall()
	{
	}

	// game_projectile_hitnpc
	void OnGameProjectileHitnpc(CBaseEntity@ target = null)
	{
		if (!IsAlive(target))
			return;
		if (RelationshipOf(target, ENT_EXPOWNER) != "enemy")
			return;
		ApplyEffect(target, "effects/dot_fire", 5.0f, @EntityOf(ENT_EXPOWNER), DOT_AMT);
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
		CallEventDelayed(0.1f, "damage_area");
		// <target|(src_origin)> <range|aoe|(dest_origin)|direct> <damage> <cth|fall_off> <attacker> <inflciter> <skill|none> <dmg_type> [flag_string]
		DebugPrint("damage_area " + Text(DMG_AMT));
		DoDamageEx(OriginOf(ENT_ME), 128, DMG_AMT, 0, ENT_EXPOWNER, ENT_EXPOWNER, USE_SKILL, "fire");
		if (!(GameTime() > NEXT_SCAN))
			return;
		NEXT_SCAN = FREQ_SCAN + FREQ_SCAN;

		// this may need to be an external
		TARGET_LIST = FindInSphere("any", 64);
	}

	// game_projectile_hitwall
	void OnGameProjectileHitwall()
	{
		OnRemoveMe();
	}

	// affect_targets
	void OnAffectTargets()
	{
		string curTarget = GetToken(TARGET_LIST, loopIteration);
		if (RelationshipOf(curTarget, ENT_EXPOWNER) != "enemy")
			return;
		ApplyEffect(curTarget, "effects/dot_fire", 5.0f, @EntityOf(ENT_EXPOWNER), DOT_AMT);
	}

	// remove_me
	void OnRemoveMe(string caller = "")
	{
		if (!IsPlayer(ENT_EXPOWNER)) // tell monster his ball popped
			CallExternal(ENT_EXPOWNER, "ext_spiral_done");
		ClientEvent("update", "all", MY_CL_IDX, "end_fx");
		PlaySound(1, 0, "monsters/goblin/sps_fogfire.wav");
		IS_ACTIVE = false;
		DeleteEntity(ENT_ME);
		RemoveScript();
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("weapons/projectiles.mdl");
		Precache("monsters/goblin/sps_fogfire.wav");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "affect_targets") { OnAffectTargets(); return true; }
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
