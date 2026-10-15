#pragma context server

// Converted from monsters/horror_fire.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/horror.as"

[script "monsters/horror_fire"]
class HorrorFire : HorrorScript
{
	// Constants
	string NPC_BASE_EXP = "200";

	// Variables (an unset .script variable reads as its own name)
	float SPORE_CLOUD_AMMO = 0.0f;

	// Variables declared by included files, with the value they start with in this script
	HorrorFire()
	{
		BREATH_SPRITE = "3dmflaora.spr";
	}

	// npc_post_spawn
	void OnNpcPostSpawn()
	{
		MonstersExternals_OnNpcPostSpawn(); // monsters/externals
		MonstersExternals_OnNpcPostSpawn_2(); // monsters/externals
		MonstersExternals_OnNpcPostSpawn_3(); // monsters/externals
		BaseSelfAdjust_OnNpcPostSpawn(); // monsters/base_self_adjust
		BaseNpc_OnNpcPostSpawn(); // monsters/base_npc
		BaseMonsterShared_OnNpcPostSpawn(); // monsters/base_monster_shared
		NO_STUCK_CHECKS = "0";
	}

	// game_dynamically_created
	void OnGameDynamicallyCreated(string creatorValue1 = "", string creatorValue2 = "", string damage = "", string skill = "", string extraValue5 = "", string extraValue6 = "", float alwaysPush = 0.0f, string duration = "", string extraValue9 = "")
	{
		BaseSelfAdjust_OnGameDynamicallyCreated(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/base_self_adjust
		BaseSelfAdjust_OnGameDynamicallyCreated_2(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/base_self_adjust
		BaseAntiStuck_OnGameDynamicallyCreated(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/base_anti_stuck
		BaseAntiStuck_OnGameDynamicallyCreated_2(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/base_anti_stuck
		Horror_OnGameDynamicallyCreated(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/horror
		MY_OWNER = creatorValue1;
		AM_SUMMONED = true;
		SPAWNED_ORG = MyOrigin();
		CallEventDelayed(180.0f, "do_vanish");
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseNpcAttackNew_OnNpcSpawn(npc); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck
		Horror_OnNpcSpawn(npc); // monsters/horror

		SetName("Flaming Horror");
		SetHealth(500);
		SetDamageTaken("all", 1);
		SetDamageTaken("holy", 1);
		SetDamageTaken("fire", 0);

		SetWidth(22);
		SetHeight(22);
		SetBoundingBox("npcsize");
		SetRoam(true);
		SetFly(true);
		I_FLY = true;
		LegacyCommand("float", 0);
		SetRace("demon");
		SetIdleAnim(ANIM_WALK);
		SetMoveAnim(ANIM_WALK);
		SetHearingSensitivity(5);
		SetModel("monsters/edwardgorey.mdl");
		SetModelBody(0, 1);
		NPC_GIVE_EXP = 300.0f;
		CallEventDelayed(1.0f, "idle_sounds");
		FLIGHT_SCANNING = true;

		SPORE_CLOUD_AMMO = 1.0f;
	}

	// npcatk_anti_stuck
	void OnNpcatkAntiStuck()
	{
		BaseAntiStuck_OnNpcatkAntiStuck(); // monsters/base_anti_stuck
		// (never true here, the rest is skipped) if STUCK_CHECK > 10
	}

	// attack1
	// called by model anim: bite1
	void OnAttack1()
	{
		bool exitSub = false;

		if (SPITTING)
		{
			// <projectile scriptname> <"view"|(src_origin)> <target|(targ_origin)|none> <speed> <damage> <cof> <skill|none> //Converted to use new tossprojectile //greatguys1@FEB2022
			TossProjectile("proj_fire_xolt", "view", "none", 500, SPIT_DAMAGE, 0.5f, "none");
			SPITTING = false;
			if (SPIT_AMMO == 0.0f)
				OnFlyMode();
			exitSub = true;
		}
		if (exitSub)
			return;

		DoDamage(ENTITY_ENEMY, ATTACK_HITRANGE, ATTACK_DAMAGE, ATTACK_ACCURACY);
		PlayRandomSound(0, 10, SOUND_ATTACK1, SOUND_ATTACK2, SOUND_ATTACK3);
		if (RandomInt(1, 10) == 1) // developer - set back to 20
			ANIM_ATTACK = ANIM_GORE;
	}

	// do_vanish
	void OnDoVanish()
	{
		CallExternal(MY_OWNER, "horror_died");
		CallEventDelayed(0.1f, "do_vanish2");
	}

	// do_vanish2
	void OnDoVanish2()
	{
		DeleteEntity(ENT_ME, "fade");
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("3dmflaora.spr");
		Precache("monsters/edwardgorey.mdl");
		CallEventDelayed(1.0f, "Horror_Timer");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "attack1") { OnAttack1(); return true; }
		if (name == "do_vanish") { OnDoVanish(); return true; }
		if (name == "do_vanish2") { OnDoVanish2(); return true; }
		if (name == "game_dynamically_created") { OnGameDynamicallyCreated(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Float(Param(params, 6)), Param(params, 7), Param(params, 8)); return true; }
		if (name == "npc_post_spawn") { OnNpcPostSpawn(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "npcatk_anti_stuck") { OnNpcatkAntiStuck(); return true; }
		return HorrorScript::DispatchEvent(name, params);
	}
}
