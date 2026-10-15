#pragma context server

// Converted from items/proj_icelance.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/items/proj_arrow_base.as"

[script "items/proj_icelance"]
class ProjIcelance : ProjArrowBaseScript
{
	// Constants
	string MODEL_BODY_OFS = "38";
	int ARROW_BODY_OFS = 38;
	string SOUND_BURN = "magic/ice_powerup.wav";
	bool ARROW_SOLIDIFY_ON_WALL = true;
	string ARROW_BREAK_CHANCE = "100%";
	string ITEM_NAME = "watermana";
	string PROJ_DAMAGESTAT = "spellcasting.ice";
	string PROJ_ANIM_IDLE = "idle_icelance";
	float PROJ_AOE_FALLOFF = 0.0f;
	int PROJ_STICK_DURATION = 0;

	// Variables (an unset .script variable reads as its own name)
	string DOT_STAT = "DOT_STAT";
	string EFFECT_DURATION = "EFFECT_DURATION";

	// Variables declared by included files, with the value they start with in this script
	ProjIcelance()
	{
		MODEL_HANDS = "none";
		MODEL_WORLD = "weapons/projectiles.mdl";
		SOUND_HITWALL1 = "weapons/axemetal1.wav";
		SOUND_HITWALL2 = "weapons/axemetal1.wav";
		PROJ_DAMAGE_TYPE = "cold";
		PROJ_MOTIONBLUR = false;
		PROJ_DAMAGE = "800";
	}

	// game_dodamage
	// 1: Attack Hit (1/0)  2: Entity Attack hit  3:  Start Position  4:  End Position
	string ProjIcelance_OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		bool exitSub = false;
		string result = "";

		if (!hit)
			return result;

		CBaseEntity@ myOwner = EntityOf(ENT_EXPOWNER);
		bool ownerIsplayer = IsPlayer(ENT_EXPOWNER);
		CBaseEntity@ enemyHit = target;

		if (!IsAlive(enemyHit))
			return result;

		if ((ownerIsplayer ? 1 : 0) == 1 && (IsPvp() ? 1 : 0) < 1 && IsPlayer(enemyHit))
			exitSub = true;
		if (exitSub)
			return result;

		if (RelationshipOf(myOwner, @enemyHit) != "enemy")
			return result;

		EFFECT_DURATION = Text(SkillOf(myOwner, "spellcasting.ice"));
		EFFECT_DURATION = Text(Float(EFFECT_DURATION) * 0.5f);
		if (Float(EFFECT_DURATION) < 3.0f)
			EFFECT_DURATION = "3";
		if (!ownerIsplayer)
			EFFECT_DURATION = "5";

		if (DamageTakenOf(enemyHit, "cold") == 0.0f)
			return result;

		int rndEffect = RandomInt(1, 3);
		int frostDmg = RandomInt(1, Int(EFFECT_DURATION));
		if (!ownerIsplayer)
			frostDmg = Int(ScriptVarOf(ENT_EXPOWNER, "ICELANCE_DOT"));
		ApplyEffect(enemyHit, "effects/dot_cold", EFFECT_DURATION, @myOwner, frostDmg, DOT_STAT);

		if (rndEffect != 1)
			return result;

		ApplyEffect(enemyHit, "effects/debuff_freeze", Random(5, 7), @myOwner, 0);

		if (IsPlayer(enemyHit)) // cant get I_R_FROZEN from players...
			return result;
		if (Truthy(ScriptVarOf(enemyHit, "I_R_FROZEN")))
			OwnerMessage("Your enemy has been encased in ice!");
		return result;
	}

	// game_tossprojectile
	void OnGameTossprojectile()
	{
		ProjBase_OnGameTossprojectile(); // items/proj_base
		ProjArrowBase_OnGameTossprojectile(); // items/proj_arrow_base
		SetGravity(0);
	}

	// arrow_spawn
	void OnArrowSpawn()
	{
		SetName("Ice Lance");
		SetDescription("A sharp bolt of ice");
		SetGravity(0);
		DOT_STAT = "spellcasting.ice";
		SetProp(ENT_ME, "rendermode", 5);
		SetProp(ENT_ME, "renderamt", 255);
	}

	// ext_dot_stat
	// <stat> - hoarfrost shard sets this so its lance dot trains swordsmanship
	void OnExtDotStat(string stat = "")
	{
		DOT_STAT = stat;
	}

	string OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "") { return ProjIcelance_OnGameDodamage(hit, target, start, end, damageType, damageText); } // game_dodamage

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
		if (name == "ext_dot_stat") { OnExtDotStat(Param(params, 0)); return true; }
		if (name == "game_dodamage") { Return(OnGameDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5))); return true; }
		if (name == "game_tossprojectile") { OnGameTossprojectile(); return true; }
		return ProjArrowBaseScript::DispatchEvent(name, params);
	}
}
