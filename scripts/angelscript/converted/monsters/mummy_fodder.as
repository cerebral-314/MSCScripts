#pragma context server

// Converted from monsters/mummy_fodder.script by msc_transpiler.
// Slower fodder mummy

#include "runtime/ScriptEntity.as"
#include "converted/monsters/mummy_base.as"

[script "monsters/mummy_fodder"]
class MummyFodder : MummyBaseScript
{
	// Variables declared by included files, with the value they start with in this script
	MummyFodder()
	{
		ANIM_WALK = "walk";
		ANIM_RUN = "walk1";
		ANIM_IDLE = "idle1";
		AS_STUCK_FREQ = 0.5f;
		ATTACK_TYPE = "unarmed";
		DMG_SLASH = 100.0f;
		MUMMY_STARTING_LIVES = 0;
	}

	// unnamed block (first think)
	void MummyFodder_FirstThink()
	{
		// base anims
		ANIM_WALK = "walk";
		ANIM_RUN = "walk1";
		ANIM_IDLE = "idle1";
		ANIM_DEATH = "dieforward";

		// base stats
		NPC_GIVE_EXP = 200.0f;
		ANIM_ATTACK = "stab1";
		FLINCH_HEALTH_RATIO = 0.5f; // Flinches a bit sooner than his stronger brethern
	}

	// mummy_spawn
	void OnMummySpawn()
	{
		SetName("Crypt Fiend");
		SetHealth(1000);

		SetModelBody(0, 0); // 0=Dark_Bandages 1=Tan_Bandages
		SetModelBody(1, 0); // 0=None 1=Priest 2=Royal 3=Warrior 4=High_Peasant
		SetModelBody(2, 0); // 0=None 1=Mace 2=Axe 3=Sword 4=Mace_Bigger 5=Magic_Sword 6=Pike 7=Pike_glowfx
		SetModelBody(3, 0); // 0=None 1=Red_Repulse 4=Weird_Confusion(hi-poly)

		SetDamageTaken("holy", 1.5f);
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		MummyFodder_FirstThink();
		MummyBase_FirstThink();
		MummyBase_FirstThink2();
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
		if (name == "mummy_spawn") { OnMummySpawn(); return true; }
		return MummyBaseScript::DispatchEvent(name, params);
	}
}
