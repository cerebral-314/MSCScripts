#pragma context server

// Converted from items/proj_ice_bolt2.script by msc_transpiler.
// Greater Ice Bolt by Thothie from Ice Bolt
// - Some variance for the npc ice mages

#include "runtime/ScriptEntity.as"
#include "converted/items/proj_arrow_base.as"

[script "items/proj_ice_bolt2"]
class ProjIceBolt2 : ProjArrowBaseScript
{
	// Constants
	string MODEL_BODY_OFS = "2";
	int ARROW_BODY_OFS = 2;
	string SOUND_BURN = "magic/ice_powerup.wav";
	bool ARROW_SOLIDIFY_ON_WALL = false;
	string ARROW_BREAK_CHANCE = "100%";
	string ITEM_NAME = "watermana";
	string PROJ_DAMAGESTAT = "spellcasting.ice";
	string PROJ_ANIM_IDLE = "idle_iceball";
	int PROJ_AOE_RANGE = 64;
	float PROJ_AOE_FALLOFF = 0.0f;
	int PROJ_STICK_DURATION = 0;

	// Variables (an unset .script variable reads as its own name)
	string MY_OWNER = "MY_OWNER";
	string OWNER_ISPLAYER = "OWNER_ISPLAYER";
	string EFFECT_DURATION = "EFFECT_DURATION";
	float DOT_FREEZE = 0.0f;

	// Variables declared by included files, with the value they start with in this script
	ProjIceBolt2()
	{
		MODEL_HANDS = "none";
		MODEL_WORLD = "weapons/projectiles.mdl";
		SOUND_HITWALL1 = "magic/frost_pulse.wav";
		SOUND_HITWALL2 = "magic/frost_pulse.wav";
		PROJ_DAMAGE_TYPE = "cold";
		PROJ_MOTIONBLUR = false;
		PROJ_DAMAGE = "96";
		PROJ_COLLIDEHITBOX = 32;
	}

	// game_dodamage
	// 1: Attack Hit (1/0)  2: Entity Attack hit  3:  Start Position  4:  End Position
	string ProjIceBolt2_OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		bool exitSub = false;
		string result = "";

		if (!hit)
			return result;

		MY_OWNER = EntityId(EntityOf(ENT_EXPOWNER));
		OWNER_ISPLAYER = Text(IsPlayer(MY_OWNER));
		CBaseEntity@ entHit = target;

		if (Float(OWNER_ISPLAYER) == 1.0f)
		{
			EFFECT_DURATION = Text(SkillOf(MY_OWNER, "spellcasting.ice"));
			EFFECT_DURATION = Text(Float(EFFECT_DURATION) * 0.5f);
			DOT_FREEZE = SkillOf(MY_OWNER, "spellcasting.ice") * 0.5f;
			if (Float(EFFECT_DURATION) < 3.0f)
				EFFECT_DURATION = "3";
			if (!IsPvp() && IsPlayer(entHit))
				exitSub = true;
		}
		if (exitSub)
			return result;

		if (RelationshipOf(MY_OWNER, @entHit) != "enemy")
			return result;

		if (!Truthy(OWNER_ISPLAYER))
		{
			// set these vars on monster
			EFFECT_DURATION = ScriptVarOf(MY_OWNER, "PROJSET_DURATION");
			DOT_FREEZE = Float(ScriptVarOf(MY_OWNER, "PROJSET_DAMAGE"));
		}

		ApplyEffect(entHit, "effects/dot_cold", EFFECT_DURATION, MY_OWNER, DOT_FREEZE, "spellcasting.ice");
		return result;
	}

	// arrow_spawn
	void OnArrowSpawn()
	{
		SetName("Greater Ice Bolt");
		SetDescription("A jagged ball of ice");
		SetWeight(0.1f);
		SetValue(0);
		SetGravity(0);
		SetGroupable(25);
	}

	string OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "") { return ProjIceBolt2_OnGameDodamage(hit, target, start, end, damageType, damageText); } // game_dodamage

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
		if (name == "game_dodamage") { Return(OnGameDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5))); return true; }
		return ProjArrowBaseScript::DispatchEvent(name, params);
	}
}
