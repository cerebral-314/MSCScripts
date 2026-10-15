#pragma context server

// Converted from items/proj_freezing_sphere.script by msc_transpiler.
// Thothie FEB2009_13 - Freezing sphere, now a projectile! :D
// -
// define on user:
// PASS_FREEZE_DMG (can be 0)
// PASS_FREEZE_DUR

#include "runtime/ScriptEntity.as"
#include "converted/items/proj_arrow_base.as"

[script "items/proj_freezing_sphere"]
class ProjFreezingSphere : ProjArrowBaseScript
{
	// Constants
	int ARROW_BODY_OFS = 1;
	string PROJ_ANIM_IDLE = "idle_iceball";
	string SOUND_ZAP1 = "debris/beamstart14.wav";
	string SOUND_ZAP2 = "debris/beamstart14.wav";
	string SOUND_ZAP3 = "debris/zap1.wav";
	string SOUND_LOOP = "ambience/pulsemachine.wav";
	bool ARROW_SOLIDIFY_ON_WALL = false;
	string MODEL_BODY_OFS = "1";
	int PROJ_STICK_DURATION = 0;
	bool PROJ_SOLIDIFY_ON_WALL = false;
	int PROJ_DAMAGE_AOE_RANGE = 0;
	bool PROJ_DAMAGE_AOE_FALLOFF = true;
	int SCAN_RANGE = 96;

	// Variables (an unset .script variable reads as its own name)
	int GAME_PVP = 0;
	string FREEZE_DMG = "FREEZE_DMG";
	string FREEZE_DUR = "FREEZE_DUR";
	bool IS_ACTIVE = false;
	string TARGET_LIST = "TARGET_LIST";

	// Variables declared by included files, with the value they start with in this script
	ProjFreezingSphere()
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
	void ProjFreezingSphere_OnGameProjectileHitwall()
	{
		OnRemoveMe();
	}

	// game_tossprojectile
	void OnGameTossprojectile()
	{
		ProjBase_OnGameTossprojectile(); // items/proj_base
		ProjArrowBase_OnGameTossprojectile(); // items/proj_arrow_base

		CallEventDelayed(10.0f, "remove_me"); // max dist

		FREEZE_DMG = ScriptVarOf(ENT_EXPOWNER, "PASS_FREEZE_DMG");
		FREEZE_DUR = ScriptVarOf(ENT_EXPOWNER, "PASS_FREEZE_DUR");
		ServerPlaySound(2, 10, SOUND_LOOP);
		IS_ACTIVE = true;
		CallEventDelayed(0.01f, "scan_targets");
	}

	// arrow_spawn
	void OnArrowSpawn()
	{
		SetName("Freezing Sphere");
		SetDescription("A large ball of freezing magiks");
		SetWeight(0);
		SetValue(1);
		SetGravity(0.0001f);

		SetModel("weapons/projectiles.mdl");
		SetModelBody(0, 1);

		CallEventDelayed(10.0f, "remove_me");

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
	}

	// game_projectile_landed
	void OnGameProjectileLanded()
	{
		OnRemoveMe();
	}

	// game_projectile_hitwall
	void OnGameProjectileHitwall()
	{
		PlayRandomSound(0, 10, SOUND_ZAP1, SOUND_ZAP2, SOUND_ZAP3);

		OnRemoveMe();
	}

	// scan_targets
	void OnScanTargets()
	{
		if (!IS_ACTIVE)
			return;
		CallEventDelayed(0.2f, "scan_targets");

		TARGET_LIST = FindInSphere("any", SCAN_RANGE);
		if (TARGET_LIST == "none")
			return;
		int nTargets = GetTokenCount(TARGET_LIST);
		if (!(GetTokenCount("MY_ORG") > 0))
			return;
		if (!(nTargets > 0))
			return;
		for (int i = 0; i < nTargets; i++)
		{
			loopIteration = i;
			OnAffectTargets();
		}
	}

	// affect_targets
	void OnAffectTargets()
	{
		string curTarget = GetToken(TARGET_LIST, loopIteration);
		if (RelationshipOf(curTarget, ENT_EXPOWNER) != "enemy")
			return;
		if (Truthy(ScriptVarOf(curTarget, "I_R_FROZEN")))
			return;
		ApplyEffect(curTarget, "effects/dot_cold_freeze", FREEZE_DUR, @EntityOf(ENT_EXPOWNER), FREEZE_DMG);
	}

	// remove_me
	void OnRemoveMe(string caller = "")
	{
		if (!IsPlayer(ENT_EXPOWNER)) // tell monster his ball popped
			CallExternal(ENT_EXPOWNER, "ext_ball_done");
		ServerPlaySound(2, 0, SOUND_LOOP);
		IS_ACTIVE = false;
		DeleteEntity(ENT_ME);
		RemoveScript();
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("weapons/projectiles.mdl");
		Precache("ambience/pulsemachine.wav");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "affect_targets") { OnAffectTargets(); return true; }
		if (name == "arrow_spawn") { OnArrowSpawn(); return true; }
		if (name == "game_fall") { OnGameFall(); return true; }
		if (name == "game_projectile_hitnpc") { OnGameProjectileHitnpc(EntityParam(params, 0)); return true; }
		if (name == "game_projectile_hitwall") { OnGameProjectileHitwall(); return true; }
		if (name == "game_projectile_landed") { OnGameProjectileLanded(); return true; }
		if (name == "game_tossprojectile") { OnGameTossprojectile(); return true; }
		if (name == "remove_me") { OnRemoveMe(Param(params, 0)); return true; }
		if (name == "scan_targets") { OnScanTargets(); return true; }
		return ProjArrowBaseScript::DispatchEvent(name, params);
	}
}
