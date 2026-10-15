#pragma context server

// Converted from items/proj_server_arrow.script by msc_transpiler.
// Base Arrow
// Req. Variables
// ARROW_BODY_OFS
// ARROW_EXPIRE_DELAY
// ARROW_SOLIDIFY_ON_WALL
// ARROW_BREAK_CHANCE

#include "runtime/ScriptEntity.as"
#include "converted/items/proj_arrow_base.as"
#include "converted/items/proj_base.as"

[script "items/proj_server_arrow"]
class ProjServerArrow : ProjArrowBaseScript
{
	// Constants
	int ARROW_BODY_OFS = 0;
	int ARROW_STICK_DURATION = 10;
	bool ARROW_SOLIDIFY_ON_WALL = false;
	string ARROW_BREAK_CHANCE = "20%";
	string PROJ_DAMAGETYPE = "pierce";

	// Variables declared by included files, with the value they start with in this script
	ProjServerArrow()
	{
		SOUND_HITWALL2 = "weapons/bow/arrowhit1.wav";
		ANIM_DEPLOY = "idle2";
		ANIM_DROPPED = "idle1";
	}

	// game_tossprojectile
	void ProjServerArrow_OnGameTossprojectile()
	{
		LegacyCommand("useable", 0); // Can't be picked up after it's shot/tossed
		if (PROJ_MOTIONBLUR)
			ClientEvent("new", "all_in_sight", "effects/sfx_motionblur", IndexOf(ENT_ME));
		OnGameFall();
	}

	// game_tossprojectile
	void ProjServerArrow_OnGameTossprojectile_2()
	{
		// clientevent new all_in_sight effects/sfx_motionblur $get(ent_me,index)
		OnGameFall();
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseItemExtras_OnGameSpawn(playerRace, playerGender); // items/base_item_extras
		ProjBase_OnGameSpawn(playerRace, playerGender); // items/proj_base

		LegacyCommand("movetype", "projectile"); // Causes the orientation to change based on velocity

		SetWorldModel(MODEL_WORLD);
		OnProjectileSpawn();

		SetLocal("reg.proj.dmg", PROJ_DAMAGE);
		SetLocal("reg.proj.dmgtype", PROJ_DAMAGE_TYPE);
		SetLocal("reg.proj.aoe.range", "PROJ_AOE_RANGE");
		SetLocal("reg.proj.aoe.falloff", "PROJ_AOE_FALLOFF");
		SetLocal("reg.proj.stick.duration", "PROJ_STICK_DURATION");
		SetLocal("reg.proj.collidehitbox", PROJ_COLLIDEHITBOX);

		LegacyCommand("registerprojectile");
	}

	// game_fall
	void OnGameFall()
	{
		BaseItemExtras_OnGameFall(); // items/base_item_extras
		BaseItemExtras_OnGameFall_2(); // items/base_item_extras
		ProjBase_OnGameFall(); // items/proj_base
		ProjArrowBase_OnGameFall(); // items/proj_arrow_base

		SetModelBody(0, ARROW_BODY_OFS);
		PlayAnim(ANIM_DROPPED);
	}

	// game_deploy
	void OnGameDeploy()
	{
		BaseItemExtras_OnGameDeploy(); // items/base_item_extras
		BaseItemExtras_OnGameDeploy_2(); // items/base_item_extras
		BaseItemExtras_OnGameDeploy_3(); // items/base_item_extras
		ProjArrowBase_OnGameDeploy(); // items/proj_arrow_base

		SetModel(MODEL_HANDS);
		PlayAnim(ANIM_DEPLOY);

		float mbTemp = ItemHandIndex() + 1.0f + ARROW_BODY_OFS;
		SetModelBody(0, int(mbTemp));
		OnArrowDeploy();
	}

	// game_tossprojectile
	void OnGameTossprojectile()
	{
		ProjBase_OnGameTossprojectile(); // items/proj_base
		ProjArrowBase_OnGameTossprojectile(); // items/proj_arrow_base
		ProjServerArrow_OnGameTossprojectile();
		ProjServerArrow_OnGameTossprojectile_2();
	}

	// game_projectile_landed
	void OnGameProjectileLanded()
	{
		ProjBase_OnGameProjectileLanded(); // items/proj_base

		LegacyCommand("movetype", "none"); // Back to normal movement
		LegacyCommand("expiretime", 0);
		OnProjectileLanded();
	}

	// game_projectile_hitwall
	void OnGameProjectileHitwall()
	{
		ProjBase_OnGameProjectileHitwall(); // items/proj_base
		ProjArrowBase_OnGameProjectileHitwall(); // items/proj_arrow_base

		PlayRandomSound(4, 5, SOUND_HITWALL1, SOUND_HITWALL2);
	}

	// game_projectile_hitnpc
	void OnGameProjectileHitnpc(CBaseEntity@ target = null)
	{
		ProjBase_OnGameProjectileHitnpc(target); // items/proj_base
		ProjArrowBase_OnGameProjectileHitnpc(target); // items/proj_arrow_base

		if (ARROW_STICK_DURATION > 0)
		{
			LegacyCommand("setfollow", ENT_LASTSTRUCKBYME, "normal"); // align_bottom

			LegacyCommand("expiretime", ARROW_STICK_DURATION);
			CallEventDelayed(ARROW_STICK_DURATION, "arrow_unstick");
		}

		LegacyCommand("expiretime", 0);
	}

	// projectile_spawn
	void OnProjectileSpawn()
	{
		ProjArrowBase_OnProjectileSpawn(); // items/proj_arrow_base

		SetGroupable(25);

		SetWorldModel(MODEL_WORLD);
		SetHudSprite("hand", SPRITE_ARROW_HAND);
		SetHudSprite("trade", SPRITE_ARROW_TRADE);
		SetHand("left");

		OnArrowSpawn();
	}

	// projectile_landed
	void OnProjectileLanded()
	{
		ProjArrowBase_OnProjectileLanded(); // items/proj_arrow_base

		LegacyCommand("expiretime", ARROW_EXPIRE_DELAY); // Let the fired arrows stay around for a bit
	}

	// arrow_spawn
	void OnArrowSpawn()
	{
		SetName("Server Arrow");
		SetDescription("For testing server side projectiles");
		SetWeight(0.1f);
		SetValue(0);
		SetGravity(0.75f);
	}

	// arrow_unstick
	void OnArrowUnstick()
	{
		LegacyCommand("setfollow", "none");
	}

	// arrow_breakchance
	void OnArrowBreakchance()
	{
		if (!(RandomInt(0, 99) < Float(ARROW_BREAK_CHANCE)))
			return;

		OnProjectileBroke();
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files
	void OnArrowStickDuration() {} // ARROW_STICK_DURATION
	void OnProjectileBroke() {} // projectile_broke

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "arrow_breakchance") { OnArrowBreakchance(); return true; }
		if (name == "arrow_spawn") { OnArrowSpawn(); return true; }
		if (name == "arrow_unstick") { OnArrowUnstick(); return true; }
		if (name == "game_deploy") { OnGameDeploy(); return true; }
		if (name == "game_fall") { OnGameFall(); return true; }
		if (name == "game_projectile_hitnpc") { OnGameProjectileHitnpc(EntityParam(params, 0)); return true; }
		if (name == "game_projectile_hitwall") { OnGameProjectileHitwall(); return true; }
		if (name == "game_projectile_landed") { OnGameProjectileLanded(); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "game_tossprojectile") { OnGameTossprojectile(); return true; }
		if (name == "projectile_landed") { OnProjectileLanded(); return true; }
		if (name == "projectile_spawn") { OnProjectileSpawn(); return true; }
		return ProjArrowBaseScript::DispatchEvent(name, params);
	}
}
