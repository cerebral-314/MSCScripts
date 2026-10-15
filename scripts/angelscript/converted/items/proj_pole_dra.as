#pragma context server

// Converted from items/proj_pole_dra.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/items/proj_arrow_base.as"

[script "items/proj_pole_dra"]
class ProjPoleDra : ProjArrowBaseScript
{
	// Constants
	string MODEL_BODY_OFS = "66";
	int ARROW_BODY_OFS = 66;
	int ARROW_STICK_DURATION = 5;
	bool ARROW_SOLIDIFY_ON_WALL = false;
	string ARROW_BREAK_CHANCE = "100%";
	string ITEM_NAME = "watermana";
	string PROJ_DAMAGESTAT = "spellcasting.fire";
	string PROJ_ANIM_IDLE = "idle_icebolt";
	int PROJ_AOE_RANGE = 0;
	float PROJ_AOE_FALLOFF = 0.0f;
	int PROJ_STICK_DURATION = 0;
	bool PROJ_COLLIDE = true;

	// Variables (an unset .script variable reads as its own name)
	float LOT_DOT = 0.0f;
	bool DID_FIREBURST = false;
	string BURN_TARGS = "BURN_TARGS";
	int GAME_PVP = 0;
	float FIRE_DOT = 0.0f;

	// Variables declared by included files, with the value they start with in this script
	ProjPoleDra()
	{
		MODEL_HANDS = "none";
		MODEL_WORLD = "weapons/projectiles.mdl";
		ARROW_EXPIRE_DELAY = 2;
		SOUND_HITWALL1 = "weapons/xbow_hit1.wav";
		SOUND_HITWALL2 = "weapons/xbow_hit1.wav";
		PROJ_DAMAGE_TYPE = "fire";
		PROJ_DAMAGE = "0";
	}

	// game_projectile_hitnpc
	void OnGameProjectileHitnpc(CBaseEntity@ target = null)
	{
		ProjBase_OnGameProjectileHitnpc(target); // items/proj_base
		ProjArrowBase_OnGameProjectileHitnpc(target); // items/proj_arrow_base
		bool exitSub = false;

		if (IsPlayer(target) && !IsPvp())
			exitSub = true;
		if (exitSub)
			return;

		float dmg = 300.0f;
		float ownerSkillRatio = SkillOf(ENT_EXPOWNER, "polearms") * 0.01f;
		dmg *= ownerSkillRatio;

		DoDamageEx(@target, "direct", dmg, "100%", ENT_EXPOWNER, ENT_ME, "polearms", "fire");

		float dot = SkillOf(ENT_EXPOWNER, "spellcasting.fire");
		if (!(dot >= 15.0f))
			return;
		if (dot >= 20.0f)
			OnDoFireBurst(OriginOf(target));
		LOT_DOT *= 0.5f;
		ApplyEffect(target, "effects/dot_fire", 5.0f, @EntityOf(ENT_EXPOWNER), dot, "polearms");
	}

	// arrow_spawn
	void OnArrowSpawn()
	{
		SetName("Dragon Lance");
		SetDescription("Wait! I'm not a dragon!");
		SetWeight(0.1f);
		SetValue(0);
		SetGravity(0.8f);
		SetGroupable(25);
	}

	// hitwall
	void OnHitwall()
	{
		if (SkillOf(ENT_EXPOWNER, "spellcasting.fire") >= 20.0f)
			OnDoFireBurst(OriginOf(ENT_ME));
	}

	// do_fire_burst
	void OnDoFireBurst(Vector3 projectilePosition = Vector3())
	{
		bool exitSub = false;
		if (DID_FIREBURST)
			return;
		DID_FIREBURST = true;
		Vector3 projPos = projectilePosition;
		Vector3 ownerPos = OriginOf(ENT_EXPOWNER);

		DebugPrint("do_fire_burst " + Text(Distance(projPos, ownerPos)));

		if (!(Distance(projPos, ownerPos) > 128.0f))
			return;
		float groundHeight = GroundHeight(projPos);
		float zDiff = projPos.z - groundHeight;
		if (zDiff > 50.0f)
			exitSub = true;
		if (zDiff < -50.0f)
			exitSub = true;
		if (exitSub)
			return;
		projPos.z = groundHeight;
		ClientEvent("new", "all", "effects/sfx_fire_burst", projPos, 128, 1, Vector3(255, 0, 0));
		// local DMG_AOE $get(ent_expowner,skill.spellcasting.fire)
		// xdodamage PROJ_POS 128 DMG_AOE 0 ent_expowner ent_me polearms fire_effect
		projPos.z += 32.0f;
		BURN_TARGS = LegacyFunction("get_tsphere", "any", 128, projPos);
		if (BURN_TARGS == "none")
			return;
		GAME_PVP = (IsPvp() ? 1 : 0);
		FIRE_DOT = SkillOf(ENT_EXPOWNER, "spellcasting.fire") * 0.5f;
		int count = GetTokenCount(BURN_TARGS);
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnFireBurstAffectTargets();
		}
	}

	// fire_burst_affect_targets
	void OnFireBurstAffectTargets()
	{
		bool exitSub = false;

		string curTarg = GetToken(BURN_TARGS, loopIteration);
		if (RelationshipOf(curTarg, ENT_EXPOWNER) != "enemy")
			return;
		if (IsPlayer(curTarg) && GAME_PVP == 0)
			exitSub = true;
		if (exitSub)
			return;

		ApplyEffect(curTarg, "effects/dot_fire", 5.0f, @EntityOf(ENT_EXPOWNER), FIRE_DOT, "polearms");
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
		if (name == "do_fire_burst") { OnDoFireBurst(Vec(Param(params, 0))); return true; }
		if (name == "fire_burst_affect_targets") { OnFireBurstAffectTargets(); return true; }
		if (name == "game_projectile_hitnpc") { OnGameProjectileHitnpc(EntityParam(params, 0)); return true; }
		if (name == "hitwall") { OnHitwall(); return true; }
		return ProjArrowBaseScript::DispatchEvent(name, params);
	}
}
