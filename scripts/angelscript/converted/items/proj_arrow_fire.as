#pragma context server

// Converted from items/proj_arrow_fire.script by msc_transpiler.
// Thothie - Seems to me its light effect should apply even if it doesnt hit a creature, not sure how to make it do this
// Fire Arrow

#include "runtime/ScriptEntity.as"
#include "converted/items/proj_arrow_base.as"
#include "converted/items/base_loopsnd.as"

[script "items/proj_arrow_fire"]
class ProjArrowFire : ProjArrowBaseScript, BaseLoopsnd
{
	// Constants
	int ARROW_BODY_OFS = 0;
	string PROJ_DAMAGETYPE = "fire";
	int ARROW_STICK_DURATION = 25;
	int PROJ_STICK_DURATION = 25;
	bool ARROW_SOLIDIFY_ON_WALL = false;
	string ARROW_BREAK_CHANCE = "0%";
	string SFX_SCRIPT = "items/proj_arrow_fire_cl";
	string LOOPSND_NAME = "items/torch1.wav";
	int LOOPSND_LENGTH = 6;
	float LOOPSND_VOLUME = 5.0f;

	// Variables (an unset .script variable reads as its own name)
	string SCRIPT_1_ID = "SCRIPT_1_ID";

	// Variables declared by included files, with the value they start with in this script
	ProjArrowFire()
	{
		SPRITE_ARROW_TRADE = "firearrow";
		ARROW_EXPIRE_DELAY = 100;
	}

	// unnamed block (first think)
	void ProjArrowFire_FirstThink()
	{
		PrecacheFile(SFX_SCRIPT);
	}

	// game_dodamage
	string ProjArrowFire_OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";

		if (!hit)
			return result;

		CBaseEntity@ myOwner = EntityOf(ENT_EXPOWNER);
		ApplyEffect(target, "effects/dot_fire", 5, @myOwner, 1, "archery");
		return result;
	}

	// game_fall
	void OnGameFall()
	{
		BaseItemExtras_OnGameFall(); // items/base_item_extras
		BaseItemExtras_OnGameFall_2(); // items/base_item_extras
		ProjBase_OnGameFall(); // items/proj_base
		ProjArrowBase_OnGameFall(); // items/proj_arrow_base

		OnLoopsndStart(); // base_loopsnd
	}

	// game_putinpack
	void OnGamePutinpack()
	{
		BaseItemExtras_OnGamePutinpack(); // items/base_item_extras
		BaseLoopsnd_OnGamePutinpack(); // items/base_loopsnd

		OnLoopsndEnd(); // base_loopsnd
	}

	// game_tossprojectile
	void OnGameTossprojectile()
	{
		ProjBase_OnGameTossprojectile(); // items/proj_base
		ProjArrowBase_OnGameTossprojectile(); // items/proj_arrow_base

		// Called here because the origin isn't set in spawn
		ClientEvent("new", "all", SFX_SCRIPT, IndexOf(ENT_ME));
		SCRIPT_1_ID = LastClientScriptId();
	}

	// game_projectile_hitnpc
	void OnGameProjectileHitnpc(CBaseEntity@ target = null)
	{
		ProjBase_OnGameProjectileHitnpc(target); // items/proj_base
		ProjArrowBase_OnGameProjectileHitnpc(target); // items/proj_arrow_base
		if (!IsAlive(target))
			return;
		ClientEvent("update", "all", SCRIPT_1_ID, "transfer_owner", IndexOf(target));
	}

	// projectile_landed
	void OnProjectileLanded()
	{
		ProjArrowBase_OnProjectileLanded(); // items/proj_arrow_base

		// clientevent new all effects/make_light $get(ent_me,origin) 256 (255,255,128) 60
		// clientevent remove all SCRIPT_1_ID
		// clientevent update all SCRIPT_1_ID make_light $get(ent_me,index)
		SetSolid("none");
		OnLoopsndEnd();
		ClientEvent("update", "all", SCRIPT_1_ID, "loop_sound");
		CallEventDelayed(10.0f, "projectile_expire");
	}

	// arrow_spawn
	void OnArrowSpawn()
	{
		SetName("Fire Arrow");
		SetDescription("This kind of arrow is merely used for lighting up dark areas");
		SetWeight(0.125f);
		SetValue(10);
		SetGravity(0.8f);
		SetGroupable(25);
	}

	// arrow_hitwall
	void OnArrowHitwall()
	{
		OnLoopsndStart(); // base_loopsnd
	}

	// hitwall
	void OnHitwall()
	{
		Vector3 traceStart = OriginOf(ENT_ME);
		string traceEnd = Text(traceStart);
		traceEnd = Text(Vec(traceEnd) + RelativePosition(Vector3(0, 100, 0)));
		Effect("decal", traceEnd, 46);
	}

	string OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "") { return ProjArrowFire_OnGameDodamage(hit, target, start, end, damageType, damageText); } // game_dodamage

	// projectile_broke
	void OnProjectileBroke()
	{
		OnLoopsndEnd(); // base_loopsnd
	}

	// projectile_expire
	void OnProjectileExpire()
	{
		DeleteEntity(ENT_ME);
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseItemExtras_OnGameSpawn(playerRace, playerGender); // items/base_item_extras
		ProjBase_OnGameSpawn(playerRace, playerGender); // items/proj_base
		BaseLoopsnd_OnGameSpawn(playerRace, playerGender); // items/base_loopsnd
	}

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("weapons/bows/arrows.mdl");
		Precache("items/torch1.wav");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		ProjArrowFire_FirstThink();
		BaseItemExtras_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "arrow_hitwall") { OnArrowHitwall(); return true; }
		if (name == "arrow_spawn") { OnArrowSpawn(); return true; }
		if (name == "game_dodamage") { Return(OnGameDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5))); return true; }
		if (name == "game_fall") { OnGameFall(); return true; }
		if (name == "game_projectile_hitnpc") { OnGameProjectileHitnpc(EntityParam(params, 0)); return true; }
		if (name == "game_putinpack") { OnGamePutinpack(); return true; }
		if (name == "game_tossprojectile") { OnGameTossprojectile(); return true; }
		if (name == "hitwall") { OnHitwall(); return true; }
		if (name == "projectile_broke") { OnProjectileBroke(); return true; }
		if (name == "projectile_expire") { OnProjectileExpire(); return true; }
		if (name == "projectile_landed") { OnProjectileLanded(); return true; }
		return BaseLoopsnd_DispatchEvent(name, params)
			|| ProjArrowBaseScript::DispatchEvent(name, params);
	}
}
