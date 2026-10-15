#pragma context server

// Converted from items/proj_k_knife.script by msc_transpiler.
// Kharaztorant knife, (from catapult, don't ask), by Thothie
// - This knife's damage type and appearance is determined by its owner

#include "runtime/ScriptEntity.as"
#include "converted/items/proj_arrow_base.as"

[script "items/proj_k_knife"]
class ProjKKnife : ProjArrowBaseScript
{
	// Constants
	string PROJ_ANIM_IDLE = "idle_standard";
	int PROJ_STICK_DURATION = 2;
	bool ARROW_SOLIDIFY_ON_WALL = true;
	string ARROW_BREAK_CHANCE = "100%";

	// Variables (an unset .script variable reads as its own name)
	int ARROW_BODY_OFS = 26;
	string MODEL_BODY_OFS = "26";
	string MY_OWNER = "MY_OWNER";
	CBaseEntity@ MY_WEAPON = null;
	string OWNER_TYPE = "OWNER_TYPE";
	string OWNER_ISPLAYER = "OWNER_ISPLAYER";
	string SPAWN_ITEM = "SPAWN_ITEM";
	string EFFECT_SCRIPT = "EFFECT_SCRIPT";
	string EFFECT_DUR = "EFFECT_DUR";
	float EFFECT_DMG = 0.0f;

	// Variables declared by included files, with the value they start with in this script
	ProjKKnife()
	{
		MODEL_WORLD = "weapons/projectiles.mdl";
		ARROW_EXPIRE_DELAY = 1;
		SOUND_HITWALL1 = "weapons/dagger/daggermetal1.wav";
		SOUND_HITWALL2 = "weapons/dagger/daggermetal2.wav";
	}

	// unnamed block (first think)
	void ProjKKnife_FirstThink()
	{
		ARROW_BODY_OFS = 26;
		MODEL_BODY_OFS = "26";
	}

	// game_dodamage
	string ProjKKnife_OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		bool exitSub = false;
		string result = "";

		if (!hit)
			return result;

		if (Truthy(OWNER_ISPLAYER))
			CallExternal(MY_OWNER, "knife_return");

		if (OWNER_TYPE == "ninja")
			return result;
		if (RelationshipOf(target, MY_OWNER) != "enemy")
			return result;

		if (Truthy(OWNER_ISPLAYER) && IsPlayer(target))
		{
			bool pvpSet = IsPvp();
			if ((pvpSet ? 1 : 0) == 0)
				exitSub = true;
		}
		if (exitSub)
			return result;

		if (EFFECT_SCRIPT == "EFFECT_SCRIPT")
			return result;
		ApplyEffect(target, EFFECT_SCRIPT, EFFECT_DUR, MY_OWNER, EFFECT_DMG, "smallarms");
		return result;
	}

	// game_tossprojectile
	void OnGameTossprojectile()
	{
		ProjBase_OnGameTossprojectile(); // items/proj_base
		ProjArrowBase_OnGameTossprojectile(); // items/proj_arrow_base
		SetGravity(0);
		MY_OWNER = EntityId(EntityOf(ENT_EXPOWNER));
		@MY_WEAPON = ActiveItemOf(MY_OWNER);
		OWNER_TYPE = ScriptVarOf(MY_OWNER, "ALCO_TYPE");
		OWNER_ISPLAYER = Text(IsPlayer(MY_OWNER));

		if (Truthy(OWNER_ISPLAYER))
			SPAWN_ITEM = ScriptVarOf(MY_OWNER, "ALCO_SPAWN_ITEM");

		if (OWNER_TYPE == "ninja")
			ARROW_BODY_OFS = 26;
		if (OWNER_TYPE == "fire")
		{
			ARROW_BODY_OFS = 27;
			EFFECT_SCRIPT = "effects/dot_fire";
			EFFECT_DUR = "5.0";
			EFFECT_DMG = 30.0f;
		}
		if (OWNER_TYPE == "poison")
		{
			ARROW_BODY_OFS = 28;
			EFFECT_SCRIPT = "effects/dot_poison";
			EFFECT_DUR = "15.0";
			EFFECT_DMG = 8.0f;
		}
		if (OWNER_TYPE == "cold")
		{
			ARROW_BODY_OFS = 29;
			EFFECT_SCRIPT = "effects/dot_cold";
			EFFECT_DUR = "5.0";
			EFFECT_DMG = 10.0f;
		}

		SetModelBody(0, ARROW_BODY_OFS);
	}

	// arrow_spawn
	void OnArrowSpawn()
	{
		SetName("Kharaztorant Knife");
		SetDescription("An evil magical knife");
		SetWeight(0.1f);
		SetValue(0);
		SetGravity(0);
		SetGroupable(25);
	}

	string OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "") { return ProjKKnife_OnGameDodamage(hit, target, start, end, damageType, damageText); } // game_dodamage

	// hitwall
	void OnHitwall()
	{
		if (Truthy(OWNER_ISPLAYER))
			CallExternal(MY_WEAPON, "knife_return");
		LegacyCommand("solidifyprojectile");
		DeleteEntity(ENT_ME, "fade");
	}

	// game_hitnpc
	void OnGameHitnpc()
	{
		if (Truthy(OWNER_ISPLAYER))
			CallExternal(MY_WEAPON, "knife_return");
		DeleteEntity(ENT_ME, "fade");
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("weapons/projectiles.mdl");
		Precache("weapons/bows/arrows.mdl");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		ProjKKnife_FirstThink();
		BaseItemExtras_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "arrow_spawn") { OnArrowSpawn(); return true; }
		if (name == "game_dodamage") { Return(OnGameDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5))); return true; }
		if (name == "game_hitnpc") { OnGameHitnpc(); return true; }
		if (name == "game_tossprojectile") { OnGameTossprojectile(); return true; }
		if (name == "hitwall") { OnHitwall(); return true; }
		return ProjArrowBaseScript::DispatchEvent(name, params);
	}
}
