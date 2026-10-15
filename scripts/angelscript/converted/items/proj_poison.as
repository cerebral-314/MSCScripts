#pragma context server

// Converted from items/proj_poison.script by msc_transpiler.
// Poison spit
// 12:25 AM 2/8/2005

#include "runtime/ScriptEntity.as"
#include "converted/items/proj_arrow_base.as"

[script "items/proj_poison"]
class ProjPoison : ProjArrowBaseScript
{
	// Constants
	int ARROW_BODY_OFS = 6;
	string PROJ_ANIM_IDLE = "idle_icebolt";
	string MODEL_BODY_OFS = "6";
	string SPRITE = "poison.spr";
	int PROJ_STICK_DURATION = 0;
	bool PROJ_SOLIDIFY_ON_WALL = false;
	string ARROW_BREAK_CHANCE = "20%";
	int PROJ_DAMAGE_AOE_RANGE = 32;
	bool PROJ_DAMAGE_AOE_FALLOFF = true;

	// Variables declared by included files, with the value they start with in this script
	ProjPoison()
	{
		MODEL_HANDS = "weapons/projectiles.mdl";
		MODEL_WORLD = "weapons/projectiles.mdl";
		SOUND_HITWALL2 = "weapons/bow/arrowhit1.wav";
		PROJ_DAMAGE_TYPE = "poison";
	}

	// game_dodamage
	string ProjPoison_OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";

		if (!hit)
			return result;

		int random = RandomInt(0, 1);
		CBaseEntity@ myOwner = EntityOf(ENT_EXPOWNER);

		if (random == 1)
			ApplyEffect(target, "effects/dot_poison", RandomInt(3, 5), @myOwner, Random(1.5f, 2), "spellcasting.affliction");
		return result;
	}

	// game_projectile_landed
	void OnGameProjectileLanded()
	{
		ProjBase_OnGameProjectileLanded(); // items/proj_base

		Effect("tempent", "trail", SPRITE, RelativePosition(Vector3(0, 0, 0)), RelativePosition(Vector3(0, 0, 0)), 3, 1, 1, 15, 0);
		LegacyCommand("expiretime", 0);
	}

	// arrow_spawn
	void OnArrowSpawn()
	{
		SetName("Glob of Spit");
		SetDescription("A glob of spit");
		SetWeight(0);
		SetValue(1);
		SetGravity(0.0001f);
	}

	// game_fall
	// override base_arrow.  Just do nothing
	void OnGameFall()
	{
	}

	// game_hitwall
	void OnGameHitwall()
	{
		PlayRandomSound(Int(Eval("game.sound.weapon")), Eval("game.sound.maxvol"), SOUND_HITWALL1, SOUND_HITWALL2);
	}

	string OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "") { return ProjPoison_OnGameDodamage(hit, target, start, end, damageType, damageText); } // game_dodamage

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("poison.spr");
		Precache("weapons/projectiles.mdl");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "arrow_spawn") { OnArrowSpawn(); return true; }
		if (name == "game_dodamage") { Return(OnGameDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5))); return true; }
		if (name == "game_fall") { OnGameFall(); return true; }
		if (name == "game_hitwall") { OnGameHitwall(); return true; }
		if (name == "game_projectile_landed") { OnGameProjectileLanded(); return true; }
		return ProjArrowBaseScript::DispatchEvent(name, params);
	}
}
