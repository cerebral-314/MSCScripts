#pragma context server

// Converted from monsters/mummy_cleric.script by msc_transpiler.
// This mummy heals other mummies

#include "runtime/ScriptEntity.as"
#include "converted/monsters/mummy_base.as"

[script "monsters/mummy_cleric"]
class MummyCleric : MummyBaseScript
{
	// Variables (an unset .script variable reads as its own name)
	string MUMMY_STUN_CHANCE = "MUMMY_STUN_CHANCE";

	// Variables declared by included files, with the value they start with in this script
	MummyCleric()
	{
		ANIM_WALK = "walk";
		ANIM_RUN = "walk2";
		ANIM_IDLE = "idle1";
		ATTACK_TYPE = "melee";
		DMG_STEELPIPE = 400;
		MUMMY_IS_CLERIC = true;
		MUMMY_MELEE_DMG_TYPE = "blunt";
	}

	// unnamed block (first think)
	void MummyCleric_FirstThink()
	{
		// base anims
		ANIM_WALK = "walk";
		ANIM_RUN = "walk2";
		ANIM_IDLE = "idle1";

		// base stats
		NPC_GIVE_EXP = 1000.0f;
		ATTACK_RANGE = 80.0f; // slightly longer attack range in case someone tries to sploit him while he's healing
		ATTACK_HITRANGE = 96.0f;
		ATTACK_MOVERANGE = 48.0f;
		ANIM_ATTACK = "steelpipe";
		FLINCH_DAMAGE_THRESHOLD = 50.0f; // flinches easy
		FLINCH_HEALTH_RATIO = 0.75f; // " "
		MUMMY_STUN_CHANCE = "20%";
	}

	// mummy_spawn
	void OnMummySpawn()
	{
		SetName("Mummy High Priest");
		SetHealth(5000);

		SetModelBody(0, 1); // 0=Dark_Bandages 1=Tan_Bandages
		SetModelBody(1, 4); // 0=None 1=Priest 2=Royal 3=Warrior 4=High_Peasant
		SetModelBody(2, 4); // 0=None 1=Mace 2=Axe 3=Sword 4=Mace_Bigger 5=Magic_Sword 6=Pike 7=Pike_glowfx
		SetModelBody(3, 0); // 0=None 1=Red_Repulse 2=Weird_Confusion(hi-poly)
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		MummyCleric_FirstThink();
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
