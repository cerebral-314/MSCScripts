#pragma context server

// Converted from items/proj_spore.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/items/proj_arrow_base.as"

[script "items/proj_spore"]
class ProjSpore : ProjArrowBaseScript
{
	// Constants
	string PROJ_ANIM_IDLE = "idle_standard";
	string MODEL_BODY_OFS = "23";
	int ARROW_BODY_OFS = 23;
	string PROJ_DAMAGETYPE = "poison";
	int ARROW_STICK_DURATION = 10;
	bool ARROW_SOLIDIFY_ON_WALL = false;
	string ARROW_BREAK_CHANCE = "1%";

	// Variables (an unset .script variable reads as its own name)
	string SOUND_BURN = "SOUND_BURN";
	string MY_OWNER = "MY_OWNER";
	string SPORE_STR = "SPORE_STR";
	bool SPAWNED_CLOUD = false;

	// Variables declared by included files, with the value they start with in this script
	ProjSpore()
	{
		SOUND_HITWALL1 = "ambience/steamburst1.wav";
		SOUND_HITWALL2 = "ambience/steamburst1.wav";
		ARROW_EXPIRE_DELAY = 5;
		MODEL_WORLD = "weapons/projectiles.mdl";
	}

	// unnamed block (first think)
	void ProjSpore_FirstThink()
	{
		SOUND_BURN = "ambience/steamburst1.wav";
	}

	// game_tossprojectile
	void OnGameTossprojectile()
	{
		ProjBase_OnGameTossprojectile(); // items/proj_base
		ProjArrowBase_OnGameTossprojectile(); // items/proj_arrow_base
		PlayAnim("spore_spinning");
		MY_OWNER = EntityId(EntityOf(ENT_EXPOWNER));
		bool ownerIsplayer = IsPlayer(MY_OWNER);

		if (ownerIsplayer)
			SPORE_STR = Text(SkillOf(MY_OWNER, "spellcasting.affliction"));
		if (!ownerIsplayer)
			SPORE_STR = ScriptVarOf(MY_OWNER, "SPORE_POISON_DMG");
	}

	// game_projectile_landed
	void OnGameProjectileLanded()
	{
		ProjBase_OnGameProjectileLanded(); // items/proj_base
		DebugPrint("game_projectile_landed " + Text(OriginOf(ENT_ME)));
		MY_OWNER = EntityId(EntityOf(ENT_EXPOWNER));
		DoDamageEx(OriginOf(ENT_ME), 256, "SPORE_POISON_DMG", 0, MY_OWNER, MY_OWNER, "spellcasting.affliction", "poison");
	}

	// game_projectile_hitwall
	void OnGameProjectileHitwall()
	{
		ProjBase_OnGameProjectileHitwall(); // items/proj_base
		ProjArrowBase_OnGameProjectileHitwall(); // items/proj_arrow_base

		DebugPrint("game_projectile_hitwall " + Text(OriginOf(ENT_ME)));

		if (SPAWNED_CLOUD)
			return;
		SPAWNED_CLOUD = true;
		MY_OWNER = EntityId(EntityOf(ENT_EXPOWNER));
		CreateNpc("monsters/summon/npc_poison_cloud2", OriginOf(ENT_ME), MY_OWNER, SPORE_STR, 10.0f, 2);
	}

	// game_projectile_hitnpc
	void OnGameProjectileHitnpc(CBaseEntity@ target = null)
	{
		ProjBase_OnGameProjectileHitnpc(target); // items/proj_base
		ProjArrowBase_OnGameProjectileHitnpc(target); // items/proj_arrow_base

		DebugPrint("game_projectile_hitnpc " + NameOf(target));

		// if $get(PARAM1,relationship,ent_owner) equals enemy
		if (SPAWNED_CLOUD)
			return;
		SPAWNED_CLOUD = true;
		CreateNpc("monsters/summon/npc_poison_cloud2", OriginOf(target), MY_OWNER, SPORE_STR, 10.0f, 2);
	}

	// arrow_spawn
	void OnArrowSpawn()
	{
		SetName("spore sack");
		SetDescription("a spore sack");
		SetWeight(0.1f);
		SetValue(0);
		SetGravity(0.001f);
		LegacyCommand("useable", 0);
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
		ProjSpore_FirstThink();
		BaseItemExtras_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "arrow_spawn") { OnArrowSpawn(); return true; }
		if (name == "game_projectile_hitnpc") { OnGameProjectileHitnpc(EntityParam(params, 0)); return true; }
		if (name == "game_projectile_hitwall") { OnGameProjectileHitwall(); return true; }
		if (name == "game_projectile_landed") { OnGameProjectileLanded(); return true; }
		if (name == "game_tossprojectile") { OnGameTossprojectile(); return true; }
		return ProjArrowBaseScript::DispatchEvent(name, params);
	}
}
