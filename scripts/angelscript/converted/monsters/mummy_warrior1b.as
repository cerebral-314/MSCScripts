#pragma context server

// Converted from monsters/mummy_warrior1b.script by msc_transpiler.
// Mid range end mummified warriors, this one's faster with a magic sword

#include "runtime/ScriptEntity.as"
#include "converted/monsters/mummy_base.as"

[script "monsters/mummy_warrior1b"]
class MummyWarrior1b : MummyBaseScript
{
	// Constants
	int DMG_FIRE_DOT = 150;

	// Variables declared by included files, with the value they start with in this script
	MummyWarrior1b()
	{
		ANIM_WALK = "walk";
		ANIM_RUN = "walk2";
		ANIM_IDLE = "idle1";
		ATTACK_TYPE = "melee";
		DMG_STEELPIPE = 300;
		ATTACK_HITCHANCE = "90";
	}

	// unnamed block (first think)
	void MummyWarrior1b_FirstThink()
	{
		// base anims
		ANIM_WALK = "walk";
		ANIM_RUN = "walk2";
		ANIM_IDLE = "idle1";

		// base stats
		ANIM_ATTACK = "steelpipe";

		NPC_GIVE_EXP = 3000.0f;
	}

	// mummy_spawn
	void OnMummySpawn()
	{
		SetName("Mummified Swordsman");
		SetHealth(4000);
		SetDamageTaken("all", 0.75f);

		SetModelBody(0, 0); // 0=Dark_Bandages 1=Tan_Bandages
		SetModelBody(1, 3); // 0=None 1=Priest 2=Royal 3=Warrior 4=High_Peasant
		SetModelBody(2, 5); // 0=None 1=Mace 2=Axe 3=Sword 4=Mace_Bigger 5=Magic_Sword 6=Pike 7=Pike_glowfx
		SetModelBody(3, 0); // 0=None 1=Red_Repulse 4=Weird_Confusion(hi-poly)

		SetMoveSpeed(2);
		BASE_MOVESPEED = 2.0f;
		SetAnimFrameRate(1.5f);
		BASE_FRAMERATE = "1.5";
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		MummyWarrior1b_FirstThink();
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
