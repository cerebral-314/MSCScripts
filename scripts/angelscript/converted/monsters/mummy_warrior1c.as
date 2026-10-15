#pragma context server

// Converted from monsters/mummy_warrior1c.script by msc_transpiler.
// Projectile tosser

#include "runtime/ScriptEntity.as"
#include "converted/monsters/mummy_base.as"

[script "monsters/mummy_warrior1c"]
class MummyWarrior1c : MummyBaseScript
{
	// Constants
	bool MUMMY_THROWS_PIKE = true;
	float FREQ_MUMMY_PIKE_TOSS = 4.0f;
	int DMG_PIKE = 400;
	int MUMMY_PIKE_SPEED = 800;
	string MUMMY_PROJ_NAME = "proj_mummy_spear";
	bool MUMMY_PIKE_NOGLOW = true;

	// Variables declared by included files, with the value they start with in this script
	MummyWarrior1c()
	{
		ANIM_WALK = "walk";
		ANIM_RUN = "walk2";
		ANIM_IDLE = "idle1";
		ANIM_ATTACK_LONG = "stab";
		ATTACK_TYPE = "long";
		DMG_SLASH = 300.0f;
		ATTACK_HITCHANCE = "90";
		ATTACK_RANGE_LONG = 130;
		ATTACK_HITRANGE_LONG = 150;
		DMG_STEELPIPE = 100;
		DMG_STAB = 300;
	}

	// unnamed block (first think)
	void MummyWarrior1c_FirstThink()
	{
		// base anims
		ANIM_WALK = "walk";
		ANIM_RUN = "walk2";
		ANIM_IDLE = "idle1";
		ANIM_ATTACK = "stab";

		// base stats
		NPC_GIVE_EXP = 2000.0f;
	}

	// mummy_spawn
	void OnMummySpawn()
	{
		SetName("Mummified Legionnaire");
		SetDamageTaken("all", 0.75f);
		SetHealth(4000);

		SetModelBody(0, 0); // 0=Dark_Bandages 1=Tan_Bandages
		SetModelBody(1, 3); // 0=None 1=Priest 2=Royal 3=Warrior 4=High_Peasant
		SetModelBody(2, 6); // 0=None 1=Mace 2=Axe 3=Sword 4=Mace_Bigger 5=Magic_Sword 6=Pike 7=Pike_glowfx
		SetModelBody(3, 0); // 0=None 1=Red_Repulse 4=Weird_Confusion(hi-poly)

		SetMoveSpeed(2);
		BASE_MOVESPEED = 2.0f;
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		MummyWarrior1c_FirstThink();
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
