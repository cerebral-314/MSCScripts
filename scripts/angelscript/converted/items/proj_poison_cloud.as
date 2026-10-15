#pragma context server

// Converted from items/proj_poison_cloud.script by msc_transpiler.
// Poison Cloud Projectile by Thothie (from proj_lightning_storm)

#include "runtime/ScriptEntity.as"

[script "items/proj_poison_cloud"]
class ProjPoisonCloud : ScriptEntity
{
	// Constants
	string SCRIPT_1 = "items/proj_poison_cloud_cl";
	string POISON_SPRITE = "poison_cloud.spr";

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
	string SCRIPT_1_ID = "SCRIPT_1_ID";

	// unnamed block (first think)
	void ProjPoisonCloud_FirstThink()
	{
		// precache all scripts this script may be spawned here!!!
		PrecacheFile("monsters/summon/poison_cloud2");
	}

	// game_spawn
	// This is variable now, so must be called direct (can't use #include)
	// ===================================== Proj_Base Begin
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		MODEL_HANDS = "none";
		MODEL_WORLD = "none";

		// Redo Sounds
		SOUND_HITWALL1 = "ambience/steamburst1.wav";
		SOUND_HITWALL2 = "ambience/steamburst1.wav";
		SOUND_BURN = "ambience/steamburst1.wav";

		ITEM_NAME = "watermana";
		PROJ_DAMAGE_TYPE = "poison";
		PROJ_DAMAGESTAT = "spellcasting.affliction"; // this does not determin xp stat

		PROJ_DAMAGE = "100";
		PROJ_AOE_RANGE = 256;
		PROJ_AOE_FALLOFF = 0.0f;
		PROJ_STICK_DURATION = 0; // Don't stick in enemies
		PROJ_COLLIDEHITBOX = 32;

		// precache MODEL_WORLD
		LegacyCommand("movetype", "projectile"); // Causes the orientation to change based on velocity

		SetWorldModel(MODEL_WORLD);
		OnProjectileSpawn();

		SetLocal("reg.proj.dmg", PROJ_DAMAGE);
		SetLocal("reg.proj.dmgtype", PROJ_DAMAGE_TYPE);
		SetLocal("reg.proj.aoe.range", PROJ_AOE_RANGE);
		SetLocal("reg.proj.aoe.falloff", PROJ_AOE_FALLOFF);
		SetLocal("reg.proj.stick.duration", PROJ_STICK_DURATION);
		SetLocal("reg.proj.collidehitbox", PROJ_COLLIDEHITBOX);

		// precachefile			SCRIPT_1
		LegacyCommand("registerprojectile");
	}

	// game_tossprojectile
	// end game_spawn
	void OnGameTossprojectile()
	{
		// Called here because the origin isn't set in spawn
		ClientEvent("new", "all_in_sight", SCRIPT_1, IndexOf(ENT_ME));

		SCRIPT_1_ID = LastClientScriptId();

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
		SetName("Poison Cloud Spawner");
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
		Effect("tempent", "trail", POISON_SPRITE, RelativePosition(Vector3(0, 0, 0)), RelativePosition(Vector3(0, 0, 10)), 10, 2, 5, 10, 20); // more nifty effects
		ClientEvent("remove", "all", SCRIPT_1_ID);

		CBaseEntity@ myOwner = EntityOf(ENT_EXPOWNER);

		Vector3 pos = OriginOf(ENT_ME);
		float temp = GroundHeight(pos);
		float x = pos.x;
		float y = pos.y;
		pos = Vector3(x, y, temp);

		float effectDmg = SkillOf(myOwner, "spellcasting.affliction") * 0.6f;
		float effectDuration = Divide(StatOf(myOwner, "concentration"), 2.0f) + effectDmg;

		// dbg OutgoingDur EFFECT_DURATION
		CreateNpc("monsters/summon/poison_cloud2", pos, @myOwner, PROJ_AOE_RANGE, effectDmg, effectDuration, "spellcasting.affliction");
		CBaseEntity@ lastEnt = EntityOf(ENT_LASTCREATED);
	}

	// game_hitnpc
	void OnGameHitnpc()
	{
		PlayRandomSound(0, Eval("game.sound.maxvol"), SOUND_HITWALL1, SOUND_HITWALL2);

		if (HasEffect(ENT_LASTSTRUCKBYME, "DOT_poison"))
			return;

		CBaseEntity@ myOwner = EntityOf(ENT_EXPOWNER);
		float effectDurationStat = StatOf(myOwner, "concentration.ratio");
		float effectDmg = SkillOf(myOwner, "spellcasting.affliction");
		int effectMaxduration = 15;
		int effectMinduration = 10;
		float effectDuration = Float(LegacyFunction("get_skill_ratio", effectDurationStat, effectMinduration, effectMaxduration));
		ApplyEffect(ENT_LASTSTRUCKBYME, "effects/dot_poison", effectDuration, @myOwner, effectDmg, "spellcasting.affliction");
	}

	// hitwall
	void OnHitwall()
	{
		PlayRandomSound(Int(Eval("game.sound.weapon")), Eval("game.sound.maxvol"), SOUND_HITWALL1, SOUND_HITWALL2);
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files
	void OnGameFall() {} // game_fall

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("poison_cloud.spr");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		ProjPoisonCloud_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "game_hitnpc") { OnGameHitnpc(); return true; }
		if (name == "game_projectile_landed") { OnGameProjectileLanded(); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "game_tossprojectile") { OnGameTossprojectile(); return true; }
		if (name == "hitwall") { OnHitwall(); return true; }
		if (name == "projectile_landed") { OnProjectileLanded(); return true; }
		if (name == "projectile_spawn") { OnProjectileSpawn(); return true; }
		return false;
	}
}
