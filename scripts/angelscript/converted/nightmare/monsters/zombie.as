#pragma context server

// Converted from nightmare/monsters/zombie.script by msc_transpiler.
// Furion001 Zombie
// Zombies move very slow and have a low hit rate, but have a lot of health and hit hard. (When they do.)

#include "runtime/ScriptEntity.as"
#include "converted/monsters/zombie.as"

[script "nightmare/monsters/zombie"]
class NightmareMonstersZombie : MonstersZombieScript
{
	// Constants
	string MODEL = "nightmare/monsters/fzombie.mdl";

	// Variables (an unset .script variable reads as its own name)
	float FLINCH_HEALTH_RATIO = 0.0f;

	// Variables declared by included files, with the value they start with in this script
	NightmareMonstersZombie()
	{
		ANIM_WALK = "walkb1";
		ANIM_RUN = "walkb1";
		ANIM_SWIPE = "stab1";
		ANIM_DISEASE = "slash";
		AS_STUCK_FREQ = 0.6f;
		ATTACK_HITCHANCE = "25";
	}

	// unnamed block (first think)
	void NightmareMonstersZombie_FirstThink()
	{
		// base anims
		ANIM_WALK = "walkb1";
		ANIM_RUN = "walkb1";
		ANIM_IDLE = "idle1";
		ANIM_ATTACK = ANIM_SWIPE;

		// base stats
		NPC_GIVE_EXP = 75.0f;

		ANIM_WALK = "walkb1";
		ANIM_RUN = "walkb1";
		ANIM_IDLE = "idle1";
		ANIM_SWIPE = "stab1";
		ANIM_DISEASE = "slash";
		FLINCH_HEALTH_RATIO = 0.3f;
		ATTACK_RANGE = 100.0f;
		ATTACK_HITRANGE = 130.0f;
		ATTACK_MOVERANGE = 50.0f;
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseNpcAttackNew_OnNpcSpawn(npc); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck
		MonstersZombie_OnNpcSpawn(npc); // monsters/zombie

		SetName("Zombified Commoner");
		SetHealth(200);
		SetModel(MODEL);
		int randEyes = RandomInt(0, 3);
		SetModelBody(0, randEyes); // 0=No Eyes 1=Left eye 2=Right eye 3=Both eyes
		SetModelBody(1, 0); // 0=Placeholder for gear
		SetModelBody(2, 0); // 0=Placeholder for weapons
		SetModelBody(3, 0); // 0=None 1=Red_Repulse 4=Weird_Confusion(hi-poly)

		SetRace("undead");
		SetWidth(25);
		SetHeight(80);
		SetIdleAnim(ANIM_IDLE);
		SetMoveAnim(ANIM_WALK);
		SetHearingSensitivity(7);

		SetRoam(true);

		SetGold(RandomInt(50, 100));

		SetDamageTaken("holy", 2);
		SetDamageTaken("poison", 0.01f);
		SetDamageTaken("fire", 1.5f);
		SetDamageTaken("cold", 0.25f);
		SetDamageTaken("pierce", 0.5f);
		SetDamageTaken("blunt", 1);
		SetDamageTaken("slash", 1.25f);

		CallEventDelayed(1.0f, "idle_sounds");

		// intesting: npc_death doesn't get called when struck by divniation, so set death here
		int pickDeath = RandomInt(1, 5);
		if (pickDeath == 1)
			ANIM_DEATH = ANIM_DEATH1;
		if (pickDeath == 2)
			ANIM_DEATH = ANIM_DEATH2;
		if (pickDeath == 3)
			ANIM_DEATH = ANIM_DEATH3;
		if (pickDeath == 4)
			ANIM_DEATH = ANIM_DEATH4;
		if (pickDeath == 5)
			ANIM_DEATH = ANIM_DEATH5;

		CatchSpeech("debug_props", "debug");
	}

	// npc_selectattack
	void OnNpcSelectattack()
	{
		BaseAntiStuck_OnNpcSelectattack(); // monsters/base_anti_stuck
		BaseMonsterShared_OnNpcSelectattack(); // monsters/base_monster_shared
		MonstersZombie_OnNpcSelectattack(); // monsters/zombie

		// //dbg temp selecting attack ( del DISEASE_DELAY vs DISEASE_FREQ )
		if (DISEASE_DELAY)
			return;
		DISEASE_DELAY = true;
		CallEventDelayed(DISEASE_FREQ, "reset_disease_delay");
		ANIM_ATTACK = ANIM_DISEASE;
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("nightmare/monsters/fzombie.mdl");
		Precache("monsters/zombie_medium.mdl");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		NightmareMonstersZombie_FirstThink();
		MonstersZombie_FirstThink();
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
		if (name == "npc_selectattack") { OnNpcSelectattack(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		return MonstersZombieScript::DispatchEvent(name, params);
	}
}
