#pragma context server

// Converted from monsters/k_childre_black.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/k_childre.as"

[script "monsters/k_childre_black"]
class KChildreBlack : KChildreScript
{
	// Constants
	string NPC_BASE_EXP = "800";

	// Variables declared by included files, with the value they start with in this script
	KChildreBlack()
	{
		PROJECTILE_SCRIPT = "proj_spore";
	}

	// unnamed block (first think)
	void KChildreBlack_FirstThink()
	{
		SPORE_POISON_DMG = "60";
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
		KChildre_OnNpcPostSpawn(); // monsters/k_childre

		// resistances
		SetDamageTaken("all", 0.5f);
		SetDamageTaken("fire", 1);
		SetDamageTaken("cold", 0.5f);
		SetDamageTaken("holy", 1);
		SetDamageTaken("poison", 0);
		SetDamageTaken("lightning", 2);
		SetDamageTaken("stun", 0.5f);
		// post-load stats used by base
		ANIM_FLINCH = "new_flinch";
		CAN_FLINCH = "1";
		FLINCH_HEALTH = 500.0f;
		FLINCH_DELAY = "5.0";
		FLINCH_CHANCE = "50";

		SetMoveAnim(ANIM_WALK);
		SetIdleAnim(ANIM_IDLE);
		SetStat("parry", 100);
	}

	// game_precache
	void OnGamePrecache()
	{
		PrecacheFile("monsters/summon/poison_burst");
	}

	// childre_spawn
	void OnChildreSpawn()
	{
		bool exitSub = false;

		SetName("Black Kharaztorant Childre");
		SetModel("monsters/k_childre_black.mdl");
		SetHealth(3000);
		SetRace("demon");
		SetWidth(32);
		SetHeight(68);
		SetRoam(true);
		SetBoundingBox("npcsize");
		SetHearingSensitivity(4);
		string mapName = ToLowerCase(MapName());
		if (Contains(mapName, "helena"))
		{
			STEP_SIZE_NORM = 18;
			exitSub = true;
		}
		if (Contains(mapName, "demontemple"))
		{
			STEP_SIZE_NORM = 24;
			exitSub = true;
		}
		if (Contains(mapName, "islesofdread"))
		{
			STEP_SIZE_NORM = 24;
			exitSub = true;
		}
		if (exitSub)
			return;
		SetStepSize(STEP_SIZE_NORM);
	}

	// normal_immunes
	void OnNormalImmunes()
	{
		AM_INVISIBLE = false;
		SetDamageTaken("all", 0.5f);
		SetDamageTaken("fire", 1);
		SetDamageTaken("cold", 0.5f);
		SetDamageTaken("holy", 1);
		SetDamageTaken("poison", 0);
		SetDamageTaken("lightning", 2);
	}

	// do_fireball
	void OnDoFireball()
	{
		PlaySound(0, 10, SOUND_FIREBALL);
		FIREBALL_TOSS = true;
		PlayAnim("critical", ANIM_ATTACK);
		// <projectile scriptname> <"view"|(src_origin)> <target|(targ_origin)|none> <speed> <damage> <cof> <skill|none> //Converted to use new tossprojectile //greatguys1@FEB2022
		TossProjectile(PROJECTILE_SCRIPT, RelativePosition(Vector3(0, 48, 62)), NPCATK_TARGET, 400, 200, 0, "none");
		FIREBALL_AMMO -= 1.0f;
		if (FIREBALL_AMMO == 0.0f)
			SetProp(ENT_ME, "skin", 0);
		OnNpcatkResumeAi();
		SetRoam(true);
	}

	// do_fade
	void OnDoFade()
	{
		CreateNpc("monsters/summon/poison_burst", OriginOf(ENT_ME), self, 128, 1, 100, 30);
		OnNpcatkFlee(NPCATK_TARGET, "2048", "3.0");
		FADE_TARGET = NPCATK_TARGET;
		DOING_FADE = true;
		OnNpcatkSuspendAi("2.0");
		SetMoveAnim(ANIM_RUN);
		WAS_STRUCK = false;
		CallEventDelayed(0.1f, "do_fade2");
		CallEventDelayed(1.0f, "resume_attack");
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/k_childre_black.mdl");
		CallEventDelayed(FREQ_RELOAD, "KChildre_Timer");
		CallEventDelayed(FREQ_IDLE, "KChildre_Timer2");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		KChildreBlack_FirstThink();
		KChildre_FirstThink();
		BaseNpc_FirstThink();
		MonstersExternals_FirstThink();
		BaseNpcAttackNew_FirstThink();
		BaseMonsterShared_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "childre_spawn") { OnChildreSpawn(); return true; }
		if (name == "do_fade") { OnDoFade(); return true; }
		if (name == "do_fireball") { OnDoFireball(); return true; }
		if (name == "game_precache") { OnGamePrecache(); return true; }
		if (name == "normal_immunes") { OnNormalImmunes(); return true; }
		if (name == "npc_post_spawn") { OnNpcPostSpawn(); return true; }
		return KChildreScript::DispatchEvent(name, params);
	}
}
