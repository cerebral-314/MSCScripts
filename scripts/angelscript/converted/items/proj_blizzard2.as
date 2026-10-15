#pragma context server

// Converted from items/proj_blizzard2.script by msc_transpiler.
// Moved from ye old mass proj-spawner

#include "runtime/ScriptEntity.as"
#include "converted/items/proj_arrow_base.as"

[script "items/proj_blizzard2"]
class ProjBlizzard2 : ProjArrowBaseScript
{
	// Constants
	int ARROW_BODY_OFS = 2;
	string MODEL_BODY_OFS = "2";
	string SOUND_BURN = "items/torch1.wav";
	string ITEM_NAME = "watermana";
	string PROJ_DAMAGESTAT = "spellcasting.ice";
	string PROJ_ANIM_IDLE = "idle_iceball";
	int PROJ_AOE_RANGE = 256;
	float PROJ_AOE_FALLOFF = 1.0f;
	int PROJ_STICK_DURATION = 0;

	// Variables declared by included files, with the value they start with in this script
	ProjBlizzard2()
	{
		MODEL_HANDS = "none";
		MODEL_WORLD = "weapons/projectiles.mdl";
		SOUND_HITWALL2 = "weapons/bow/arrowhit1.wav";
		PROJ_DAMAGE_TYPE = "cold";
		PROJ_DAMAGE = "100";
		PROJ_COLLIDEHITBOX = 32;
	}

	// unnamed block (first think)
	void ProjBlizzard2_FirstThink()
	{
		PrecacheFile("monsters/summon/summon_blizzard");
	}

	// projectile_spawn
	void OnProjectileSpawn()
	{
		ProjArrowBase_OnProjectileSpawn(); // items/proj_arrow_base

		SetName("Blizzard Spawner");
		SetWeight(500);
		SetValue(1);
		SetGravity(0.7f);
		SetGroupable(25);

		SetHudSprite("hand", "arrows");
		SetHudSprite("trade", ITEM_NAME);
		SetHand("any");

		SetProp(ENT_ME, "rendermode", 5);
		SetProp(ENT_ME, "renderamt", 255);
	}

	// projectile_landed
	// end game_spawn
	void OnProjectileLanded()
	{
		ProjArrowBase_OnProjectileLanded(); // items/proj_arrow_base

		OnFrostLanded();
	}

	// game_hitnpc
	void OnGameHitnpc()
	{
		// //dbg HitNPC p1 PARAM1 p2 PARAM2 p3 PARAM3 p4 PARAM4 - nadda
		OnFrostHit();
	}

	// frost_hit
	void OnFrostHit()
	{
		// fear my redundant var setting (Lazy cut and paste by Thothie)
		CBaseEntity@ myOwner = EntityOf(ENT_EXPOWNER);
		float effectDmg = SkillOf(myOwner, "spellcasting.ice") * 1.25f;
		int effectMaxduration = 10;
		int effectMinduration = 10;
		float effectDuration = Float(LegacyFunction("get_skill_ratio", "EFFECT_DURATION_STAT", effectMinduration, effectMaxduration));
		ApplyEffect(ENT_LASTSTRUCKBYME, "effects/dot_cold", effectDuration, @myOwner, effectDmg, "spellcasting.ice");
		OnFrostLanded();
	}

	// frost_landed
	void OnFrostLanded()
	{
		float effectDmg = 0.0f;
		string effectDuration = "EFFECT_DURATION";

		CBaseEntity@ myOwner = EntityOf(ENT_EXPOWNER);
		bool ownerIsplayer = IsPlayer(ENT_EXPOWNER);

		Vector3 pos = OriginOf(ENT_ME);
		float temp = GroundHeight(pos);
		float x = pos.x;
		float y = pos.y;
		pos = Vector3(x, y, temp);

		if (ownerIsplayer)
		{
			effectDmg = SkillOf(myOwner, "spellcasting.ice");
			float effectDurationStat = StatOf(myOwner, "concentration.ratio");
			int effectMaxduration = 5;
			int effectMinduration = 15;
			effectDuration = LegacyFunction("get_skill_ratio", effectDurationStat, effectMinduration, effectMaxduration);

			effectDmg = Divide(effectDmg, 2.0f);

			CreateNpc("monsters/summon/summon_blizzard", pos, @myOwner, AnglesOf(ENT_ME).y, effectDmg, effectDuration, "spellcasting.ice");
			CBaseEntity@ lastEnt = EntityOf(ENT_LASTCREATED);
		}

		if (!ownerIsplayer)
		{
			// get damage from monster vars
			effectDmg = Float(ScriptVarOf(myOwner, "BLIZZARD_DMG"));
			effectDuration = ScriptVarOf(myOwner, "BLIZZARD_DUR");
			CreateNpc("monsters/summon/summon_blizzard", pos, @myOwner, AnglesOf(ENT_ME).y, effectDmg, effectDuration, "spellcasting.ice");
		}
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("weapons/projectiles.mdl");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		ProjBlizzard2_FirstThink();
		BaseItemExtras_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "frost_hit") { OnFrostHit(); return true; }
		if (name == "frost_landed") { OnFrostLanded(); return true; }
		if (name == "game_hitnpc") { OnGameHitnpc(); return true; }
		if (name == "projectile_landed") { OnProjectileLanded(); return true; }
		if (name == "projectile_spawn") { OnProjectileSpawn(); return true; }
		return ProjArrowBaseScript::DispatchEvent(name, params);
	}
}
