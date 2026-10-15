#pragma context server

// Converted from items/proj_lightning_storm.script by msc_transpiler.

#include "runtime/ScriptEntity.as"

[script "items/proj_lightning_storm"]
class ProjLightningStorm : ScriptEntity
{
	// Variables (an unset .script variable reads as its own name)
	string MODEL_HANDS = "MODEL_HANDS";
	string MODEL_WORLD = "MODEL_WORLD";
	string SOUND_HITWALL1 = "SOUND_HITWALL1";
	string SOUND_HITWALL2 = "SOUND_HITWALL2";
	string SOUND_BURN = "SOUND_BURN";
	string ITEM_NAME = "ITEM_NAME";
	string PROJ_DAMAGE_TYPE = "PROJ_DAMAGE_TYPE";
	string PROJ_DAMAGESTAT = "PROJ_DAMAGESTAT";
	string PROJ_DAMAGE = "PROJ_DAMAGE";
	int PROJ_AOE_RANGE = 0;
	float PROJ_AOE_FALLOFF = 0.0f;
	int PROJ_STICK_DURATION = 0;
	int PROJ_COLLIDEHITBOX = 0;

	// game_spawn
	// This is variable now, so must be called direct (can't use #include)
	// ===================================== Proj_Base Begin
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		MODEL_HANDS = "none";
		MODEL_WORLD = "none";
		SOUND_HITWALL1 = "weapons/electro4.wav";
		SOUND_HITWALL2 = "weapons/electro4.wav";
		SOUND_BURN = "debris/beamstart15.wav";
		ITEM_NAME = "watermana";
		PROJ_DAMAGE_TYPE = "lightning";
		PROJ_DAMAGESTAT = "spellcasting.lightning"; // this does not determin xp stat

		PROJ_DAMAGE = "100";
		PROJ_AOE_RANGE = 256;
		PROJ_AOE_FALLOFF = 0.0f;
		PROJ_STICK_DURATION = 0; // Don't stick in enemies
		PROJ_COLLIDEHITBOX = 32;

		LegacyCommand("movetype", "projectile"); // Causes the orientation to change based on velocity

		SetWorldModel(MODEL_WORLD);
		OnProjectileSpawn();

		SetLocal("reg.proj.dmg", PROJ_DAMAGE);
		SetLocal("reg.proj.dmgtype", PROJ_DAMAGE_TYPE);
		SetLocal("reg.proj.aoe.range", PROJ_AOE_RANGE);
		SetLocal("reg.proj.aoe.falloff", PROJ_AOE_FALLOFF);
		SetLocal("reg.proj.stick.duration", PROJ_STICK_DURATION);
		SetLocal("reg.proj.collidehitbox", PROJ_COLLIDEHITBOX);

		LegacyCommand("registerprojectile");
	}

	// game_tossprojectile
	// end game_spawn
	void OnGameTossprojectile()
	{
		LegacyCommand("useable", 0); // Can't be picked up after it's shot/tossed
		OnGameFall();
	}

	// game_projectile_landed
	void OnGameProjectileLanded()
	{
		LegacyCommand("movetype", "none"); // Back to normal movement
		LegacyCommand("expiretime", 0);
		OnProjectileLanded();
	}

	// projectile_spawn
	// ===================================== Proj_Base End
	void OnProjectileSpawn()
	{
		SetName("Lightning Storm Spawner");
		SetWeight(500);
		SetValue(5);
		SetGravity(0.7f);
		SetGroupable(25);

		SetHudSprite("hand", "arrows");
		SetHudSprite("trade", ITEM_NAME);
		SetHand("any");
	}

	// projectile_landed
	void OnProjectileLanded()
	{
		CBaseEntity@ myOwner = EntityOf(ENT_EXPOWNER);

		Vector3 pos = OriginOf(ENT_ME);
		float temp = GroundHeight(pos);
		float x = pos.x;
		float y = pos.y;
		pos = Vector3(x, y, temp);

		float effectDmg = SkillOf(myOwner, "spellcasting.lightning");
		float effectDurationStat = StatOf(myOwner, "concentration.ratio");
		int effectMaxduration = 15; // this MUST be 15 due to silly const method used in script
		int effectMinduration = 15;
		float effectDuration = Float(LegacyFunction("get_skill_ratio", effectDurationStat, effectMinduration, effectMaxduration));
		string effectScript = "monsters/summon/summon_lightning_storm";

		CreateNpc(effectScript, pos, @myOwner, AnglesOf(ENT_ME).y, effectDmg, effectDuration, "spellcasting.lightning");
		CBaseEntity@ lastEnt = EntityOf(ENT_LASTCREATED);
	}

	// game_hitnpc
	void OnGameHitnpc()
	{
		CBaseEntity@ myOwner = EntityOf(ENT_EXPOWNER);
		float effectDmg = Divide(SkillOf(myOwner, "spellcasting.lightning"), 2.0f);
		int effectMaxduration = 15;
		int effectMinduration = 10;
		float effectDuration = Float(LegacyFunction("get_skill_ratio", "EFFECT_DURATION_STAT", effectMinduration, effectMaxduration));
		ApplyEffect(ENT_LASTSTRUCKBYME, "effects/dot_lightning", effectDuration, @myOwner, effectDmg, "spellcasting.lightning");
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files
	void OnGameFall() {} // game_fall

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "game_hitnpc") { OnGameHitnpc(); return true; }
		if (name == "game_projectile_landed") { OnGameProjectileLanded(); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "game_tossprojectile") { OnGameTossprojectile(); return true; }
		if (name == "projectile_landed") { OnProjectileLanded(); return true; }
		if (name == "projectile_spawn") { OnProjectileSpawn(); return true; }
		return false;
	}
}
