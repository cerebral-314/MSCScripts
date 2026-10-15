#pragma context server

// Converted from monsters/mummy_warrior2.script by msc_transpiler.
// Mid range mummified warriors

#include "runtime/ScriptEntity.as"
#include "converted/monsters/mummy_base.as"

[script "monsters/mummy_warrior2"]
class MummyWarrior2 : MummyBaseScript
{
	// Variables (an unset .script variable reads as its own name)
	string MUMMY_STUN_CHANCE = "MUMMY_STUN_CHANCE";

	// Variables declared by included files, with the value they start with in this script
	MummyWarrior2()
	{
		ANIM_WALK = "walk";
		ANIM_RUN = "walk2";
		ANIM_IDLE = "idle1";
		ATTACK_TYPE = "melee";
		DMG_SLASH = 400.0f;
		ATTACK_HITCHANCE = "90";
	}

	// unnamed block (first think)
	void MummyWarrior2_FirstThink()
	{
		// base anims
		ANIM_WALK = "walk";
		ANIM_RUN = "walk2";
		ANIM_IDLE = "idle1";

		// base stats
		ANIM_ATTACK = "steelpipe";
	}

	// game_dynamically_created
	// for debuggary, not setup for summon
	void OnGameDynamicallyCreated(string creatorValue1 = "", string creatorValue2 = "", string damage = "", string skill = "", string extraValue5 = "", string extraValue6 = "", float alwaysPush = 0.0f, string duration = "", string extraValue9 = "")
	{
		BaseSelfAdjust_OnGameDynamicallyCreated(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/base_self_adjust
		BaseSelfAdjust_OnGameDynamicallyCreated_2(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/base_self_adjust
		BaseAntiStuck_OnGameDynamicallyCreated(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/base_anti_stuck
		BaseAntiStuck_OnGameDynamicallyCreated_2(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/base_anti_stuck
		MummyBase_OnGameDynamicallyCreated(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/mummy_base
		if (Float(creatorValue1) == 1.0f)
			OnSetupMummyMace();
		if (Float(creatorValue1) == 2.0f)
			OnSetupMummyAxe();
		if (Float(creatorValue1) == 3.0f)
			OnSetupMummySword();
	}

	// mummy_spawn
	void OnMummySpawn()
	{
		int rndWeapon;

		SetName("Mummified Warrior");
		SetDamageTaken("all", 0.5f);
		SetDamageTaken("holy", 1);

		rndWeapon = RandomInt(1, 3);

		SetModelBody(0, 1); // 0=Dark_Bandages 1=Tan_Bandages
		SetModelBody(1, 3); // 0=None 1=Priest 2=Royal 3=Warrior 4=High_Peasant
		SetModelBody(2, rndWeapon); // 0=None 1=Mace 2=Axe 3=Sword 4=Mace_Bigger 5=Magic_Sword 6=Pike 7=Pike_glowfx 7=Pike_glowfx
		SetModelBody(3, 0); // 0=None 1=Red_Repulse 4=Weird_Confusion(hi-poly)

		if (rndWeapon == 1)
			OnSetupMummyMace();
		if (rndWeapon == 2)
			OnSetupMummyAxe();
		if (rndWeapon == 3)
			OnSetupMummySword();

		SetMoveSpeed(2);
		BASE_MOVESPEED = 2.0f;
	}

	// setup_mummy_mace
	void OnSetupMummyMace()
	{
		ANIM_ATTACK = "steelpipe";
		MUMMY_MELEE_DMG_TYPE_FINAL = "blunt";
		MUMMY_DMG_STEELPIPE = 400;
		MUMMY_STUN_CHANCE = "30%";
		SetHealth(5000);
		NPC_GIVE_EXP = 2000.0f;
		SetModelBody(2, 1);
	}

	// setup_mummy_axe
	void OnSetupMummyAxe()
	{
		ANIM_ATTACK = "steelpipe";
		MUMMY_MELEE_DMG_TYPE_FINAL = "slash";
		MUMMY_DMG_STEELPIPE = 600;
		SetHealth(7000);
		NPC_GIVE_EXP = 2000.0f;
		SetModelBody(2, 2);
	}

	// setup_mummy_sword
	void OnSetupMummySword()
	{
		ANIM_ATTACK = "steelpipe";
		MUMMY_MELEE_DMG_TYPE_FINAL = "slash";
		MUMMY_DMG_STEELPIPE = 800;
		SetHealth(4000);
		NPC_GIVE_EXP = 2000.0f;
		SetModelBody(2, 3);
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		MummyWarrior2_FirstThink();
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
		if (name == "game_dynamically_created") { OnGameDynamicallyCreated(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Float(Param(params, 6)), Param(params, 7), Param(params, 8)); return true; }
		if (name == "mummy_spawn") { OnMummySpawn(); return true; }
		if (name == "setup_mummy_axe") { OnSetupMummyAxe(); return true; }
		if (name == "setup_mummy_mace") { OnSetupMummyMace(); return true; }
		if (name == "setup_mummy_sword") { OnSetupMummySword(); return true; }
		return MummyBaseScript::DispatchEvent(name, params);
	}
}
