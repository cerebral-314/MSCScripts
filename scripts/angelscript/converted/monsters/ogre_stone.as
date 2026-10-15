#pragma context server

// Converted from monsters/ogre_stone.script by msc_transpiler.
// Swamp ogre by thothie from scratch
// - bugs
// - keeps running on spot
// - doesnt stop jumping after first jump

#include "runtime/ScriptEntity.as"
#include "converted/monsters/swamp_ogre.as"

[script "monsters/ogre_stone"]
class OgreStone : SwampOgreScript
{
	// Constants
	string NPC_BASE_EXP = "700";

	// Variables declared by included files, with the value they start with in this script
	OgreStone()
	{
		SOUND_STRUCK1 = "weapons/axemetal1.wav";
		SOUND_STRUCK2 = "weapons/axemetal2.wav";
		SOUND_PAIN_WEAK = "debris/concrete1.wav";
		SOUND_PAIN_STRONG = "debris/concrete1.wav";
		SWIPE_DAMAGE = "$rand(75,125)";
		HEADBUTT_DAMAGE = "$rand(50,100)";
		LEAP_DAMAGE = "$rand(10,60)";
		NEXT_LEAP_AWAY = 1800.0f;
		FLINCH_HEALTH = 1500.0f;
	}

	// unnamed block (first think)
	void OgreStone_FirstThink()
	{
		NPC_GIVE_EXP = 2000.0f;
		if (ToLowerCase(MapName()) == "phlames")
			NPC_GIVE_EXP = 3000.0f;
		ANIM_IDLE = "idle1";
		ANIM_WALK_DEFAULT = "walk";
		ANIM_RUN_DEFAULT = "run1";
		ANIM_DEATH = "dieforward";
		ANIM_FLINCH = "bigflinch";

		ANIM_WALK = ANIM_WALK_DEFAULT;
		ANIM_RUN = ANIM_RUN_DEFAULT;
		ANIM_ATTACK = ANIM_SWIPE;

		DROP_GOLD = 1;
		DROP_GOLD_MIN = 100;
		DROP_GOLD_MAX = 250;

		CAN_FLINCH = "1";
		FLINCH_CHANCE = "20%";
		FLINCH_DELAY = "10.0";
		FLINCH_HEALTH = 1500.0f;
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

		SetDamageTaken("holy", 2);
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseNpcAttackNew_OnNpcSpawn(npc); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck
		SwampOgre_OnNpcSpawn(npc); // monsters/swamp_ogre

		SetName("Stone Ogre");
		SetHealth(4000);
		SetRoam(true);
		SetRace("demon");
		SetModel(MONSTER_MODEL);
		SetMoveAnim(ANIM_WALK);
		SetHeight(64);
		SetWidth(32);
		SetHearingSensitivity(8);
		SetIdleAnim(ANIM_IDLE);

		SetProp(ENT_ME, "skin", 2);

		SetDamageTaken("all", 0.5f);
		SetDamageTaken("poison", 0);

		RUN_STEP = 0.0f;

		CallEventDelayed(1.0f, "idle_sounds");
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		OgreStone_FirstThink();
		SwampOgre_FirstThink();
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
		if (name == "npc_post_spawn") { OnNpcPostSpawn(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		return SwampOgreScript::DispatchEvent(name, params);
	}
}
