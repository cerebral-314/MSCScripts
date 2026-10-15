#pragma context server

// Converted from items/proj_snow_ball.script by msc_transpiler.
// Thothie - Blizzard from Fireball
// - To prevent blizzard storm from crashing the server when it strikes func_breakables
// - Generic_AOE's freeze effect doesnt seem to be working constantly, hence we have this.
// - This projectile does no damage in itself
// - Designate dam via tossprojectile
// - example: tossprojectile view 1000 MY_BASE_DMG 30 proj_generic_aoe $vec(z,x,y)

#include "runtime/ScriptEntity.as"
#include "converted/items/proj_base.as"

[script "items/proj_snow_ball"]
class ProjSnowBall : ProjBaseScript
{
	// Constants
	string MODEL_BODY_OFS = "2";
	string PROJ_ANIM_IDLE = "idle_iceball";
	string ITEM_NAME = "firemana";
	int PROJ_AOE_RANGE = 256;
	float PROJ_AOE_FALLOFF = 0.0f;
	int PROJ_STICK_DURATION = 0;
	bool PROJ_SOLIDIFY_ON_WALL = false;
	string SOUND_WOOSH = "doors/aliendoor3.wav";
	string SOUND_SMOOSH = "debris/beamstart14.wav";

	// Variables declared by included files, with the value they start with in this script
	ProjSnowBall()
	{
		MODEL_HANDS = "none";
		MODEL_WORLD = "weapons/projectiles.mdl";
		PROJ_DAMAGE_TYPE = "cold";
		PROJ_DAMAGE = "100";
		PROJ_COLLIDEHITBOX = 16;
	}

	// game_dodamage
	// 1: Attack Hit (1/0)  2: Entity Attack hit  3:  Start Position  4:  End Position
	string ProjSnowBall_OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		float outDamage = 0.0f;
		string result = "";

		if (!hit)
			return result;

		CBaseEntity@ myOwner = EntityOf(ENT_EXPOWNER);
		bool myOwnerPlayer = IsPlayer(ENT_EXPOWNER);
		CBaseEntity@ entHit = target;

		float effectDuration = SkillOf(myOwner, "spellcasting.ice") * 0.5f;

		if (!myOwnerPlayer)
			effectDuration = Float(ScriptVarOf(myOwner, "SNOWBALL_DURATION"));

		if (effectDuration < 3.0f)
			effectDuration = 3.0f;

		if (myOwnerPlayer)
			outDamage = SkillOf(ENT_OWNER, "spellcasting.ice");
		if (!myOwnerPlayer)
			outDamage = 20.0f;
		ApplyEffect(entHit, "effects/dot_cold", effectDuration, @EntityOf(ENT_OWNER), outDamage, "spellcasting.ice");
		return result;
	}

	// game_tossprojectile
	void OnGameTossprojectile()
	{
		ProjBase_OnGameTossprojectile(); // items/proj_base

		ServerPlaySound(0, 10, SOUND_WOOSH);
	}

	// projectile_spawn
	void OnProjectileSpawn()
	{
		SetName("Snow Ball of Dewm");
		SetWeight(500);
		SetValue(5);
		SetGravity(0.05f);
		SetGroupable(25);

		SetHudSprite("hand", "arrows");
		SetHudSprite("trade", ITEM_NAME);
		SetHand("any");

		SetProp(ENT_ME, "rendermode", 5);
		SetProp(ENT_ME, "renderamt", 255);
	}

	// projectile_landed
	void OnProjectileLanded()
	{
		// splodie
		// tempent trail <modelname/spritename> <start> <dest> <count> <life> <scale> <speed> <randomness>
		PlaySound(0, 10, SOUND_SMOOSH);
		Effect("tempent", "trail", "xflare1.spr", RelativePosition(Vector3(0, 0, 0)), RelativePosition(Vector3(0, 1, 1)), 1, 1.0f, 15.0f, 1.0f, 0);
	}

	string OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "") { return ProjSnowBall_OnGameDodamage(hit, target, start, end, damageType, damageText); } // game_dodamage

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("xflare1.spr");
		Precache("weapons/projectiles.mdl");
		Precache("doors/aliendoor3.wav");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "game_dodamage") { Return(OnGameDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5))); return true; }
		if (name == "game_tossprojectile") { OnGameTossprojectile(); return true; }
		if (name == "projectile_landed") { OnProjectileLanded(); return true; }
		if (name == "projectile_spawn") { OnProjectileSpawn(); return true; }
		return ProjBaseScript::DispatchEvent(name, params);
	}
}
