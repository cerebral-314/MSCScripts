#pragma context server

// Converted from items/proj_fire_ball2.script by msc_transpiler.
// Thothie - fireball from Firedart
// fireball projectile

#include "runtime/ScriptEntity.as"
#include "converted/items/proj_arrow_base.as"

[script "items/proj_fire_ball2"]
class ProjFireBall2 : ProjArrowBaseScript
{
	// Constants
	string SOUND_BURN = "items/torch1.wav";
	string SPRITE_FIRE = "3dmflaora.spr";
	string SPRITE_BURN = "fire1_fixed.spr";
	string ITEM_NAME = "firemana";
	string PROJ_DAMAGESTAT = "spellcasting";
	int ARROW_BODY_OFS = 4;
	int PROJ_AOE_RANGE = 250;
	float PROJ_AOE_FALLOFF = 0.0f;
	int PROJ_STICK_DURATION = 0;
	bool PROJ_SOLIDIFY_ON_WALL = false;
	string SOUND_START = "magic/volcano_start.wav";
	string SOUND_LOOP = "magic/volcano_loop.wav";
	string SCRIPT_1 = "items/proj_fire_dart_cl";

	// Variables (an unset .script variable reads as its own name)
	bool SOUND_ON = false;
	string FB_SCRIPT_INDEX = "FB_SCRIPT_INDEX";
	string MY_OWNER = "MY_OWNER";
	string LOCK_BURN_DAMAGE = "LOCK_BURN_DAMAGE";

	// Variables declared by included files, with the value they start with in this script
	ProjFireBall2()
	{
		MODEL_HANDS = "none";
		MODEL_WORLD = "weapons/projectiles.mdl";
		PROJ_DAMAGE_TYPE = "fire";
		PROJ_COLLIDEHITBOX = 64;
	}

	// unnamed block (first think)
	void ProjFireBall2_FirstThink()
	{
		PrecacheFile(SCRIPT_1);
	}

	// game_tossprojectile
	void OnGameTossprojectile()
	{
		ProjBase_OnGameTossprojectile(); // items/proj_base
		ProjArrowBase_OnGameTossprojectile(); // items/proj_arrow_base

		PlaySound(0, 10, SOUND_START);

		SOUND_ON = true;
		CallEventDelayed(1.0f, "loop_sound");

		ClientEvent("new", "all_in_sight", SCRIPT_1, IndexOf(ENT_ME));
		FB_SCRIPT_INDEX = LastClientScriptId();
	}

	// projectile_landed
	void OnProjectileLanded()
	{
		ProjArrowBase_OnProjectileLanded(); // items/proj_arrow_base

		SOUND_ON = false;

		PlaySound(Int(Eval("const.snd.body")), Eval("const.snd.fullvol"), "fire.wav");

		Effect("screenshake", RelativePosition(Vector3(0, 0, 0)), 50, 20, "DURATION", 256);
		Effect("tempent", "trail", "rjet1.spr", RelativePosition(Vector3(0, 0, 0)), RelativePosition(Vector3(0, 0, 10)), 20, 2, 9, 10, 20);
		ClientEvent("remove", "all", FB_SCRIPT_INDEX);
	}

	// arrow_spawn
	void OnArrowSpawn()
	{
		SetName("Meteor");
		SetWeight(500);
		// attempting adding size for larger collision box
		SetValue(5);
		SetGravity(0);

		SetModelBody(0, 0);

		SetHudSprite("hand", "arrows");
		SetHudSprite("trade", ITEM_NAME);
		SetHand("any");
		Effect("glow", ENT_ME, Vector3(255, 75, 0), 128, 5, 5);

		CallEventDelayed(0.1f, "pulsate_loop");
	}

	// pulsate_loop
	void OnPulsateLoop()
	{
		SetProp(ENT_ME, "rendermode", 5);
		int pulseValue = RandomInt(100, 255);
		SetProp(ENT_ME, "renderamt", pulseValue);
		CallEventDelayed(0.1f, "pulsate_loop");
	}

	// loop_sound
	void OnLoopSound()
	{
		if (!SOUND_ON)
			return;
		PlaySound(Int(GetVar("CHAN_BODY")), 7, SOUND_LOOP);
		CallEventDelayed(6.0f, "loop_sound");
	}

	// game_hitnpc
	void OnGameHitnpc()
	{
		float burnDamage = 0.0f;

		MY_OWNER = EntityId(EntityOf(ENT_EXPOWNER));
		if (LOCK_BURN_DAMAGE == "LOCK_BURN_DAMAGE")
			burnDamage = SkillOf(ENT_EXPOWNER, "spellcasting.fire") * 0.4f;
		if (LOCK_BURN_DAMAGE != "LOCK_BURN_DAMAGE")
			burnDamage = Float(LOCK_BURN_DAMAGE);

		// dbg BurnDamage BURN_DAMAGE
		ApplyEffect(ENT_LASTSTRUCKBYME, "effects/dot_fire", 20, MY_OWNER, burnDamage, "spellcasting.fire");
	}

	// lighten
	// param1 = fire dmg
	void OnLighten(string fireDamage = "", string gravity = "")
	{
		LOCK_BURN_DAMAGE = fireDamage;
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("fire1_fixed.spr");
		Precache("rjet1.spr");
		Precache("weapons/projectiles.mdl");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		ProjFireBall2_FirstThink();
		BaseItemExtras_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "arrow_spawn") { OnArrowSpawn(); return true; }
		if (name == "game_hitnpc") { OnGameHitnpc(); return true; }
		if (name == "game_tossprojectile") { OnGameTossprojectile(); return true; }
		if (name == "lighten") { OnLighten(Param(params, 0), Param(params, 1)); return true; }
		if (name == "loop_sound") { OnLoopSound(); return true; }
		if (name == "projectile_landed") { OnProjectileLanded(); return true; }
		if (name == "pulsate_loop") { OnPulsateLoop(); return true; }
		return ProjArrowBaseScript::DispatchEvent(name, params);
	}
}
