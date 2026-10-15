#pragma context server

// Converted from monsters/mummy_necro.script by msc_transpiler.
// This mummy summons wraiths

#include "runtime/ScriptEntity.as"
#include "converted/monsters/mummy_base.as"

[script "monsters/mummy_necro"]
class MummyNecro : MummyBaseScript
{
	// Constants
	bool MUMMY_IS_NECRO = true;
	int DMG_AURA = 100;
	float FREQ_MUMMY_SUMMON = 15.0f;
	string MUMMY_SUMMON_SCRIPT = "monsters/wraith_summoned";

	// Variables (an unset .script variable reads as its own name)
	string MUMMY_STUN_CHANCE = "MUMMY_STUN_CHANCE";

	// Variables declared by included files, with the value they start with in this script
	MummyNecro()
	{
		ANIM_WALK = "walk";
		ANIM_RUN = "walk2";
		ANIM_IDLE = "idle1";
		AURA_TYPE = 3;
		ATTACK_TYPE = "melee";
		DMG_STEELPIPE = 400;
		MUMMY_MELEE_DMG_TYPE = "blunt";
	}

	// unnamed block (first think)
	void MummyNecro_FirstThink()
	{
		// base anims
		ANIM_WALK = "walk";
		ANIM_RUN = "walk2";
		ANIM_IDLE = "idle1";

		// base stats
		NPC_GIVE_EXP = 1000.0f;
		ATTACK_RANGE = 80.0f; // slightly longer attack range in case someone tries to sploit him while he's healing
		ATTACK_HITRANGE = 96.0f;
		ATTACK_MOVERANGE = 80.0f; // will depend on aura, if he can
		ANIM_ATTACK = "steelpipe";
		FLINCH_DAMAGE_THRESHOLD = 50.0f; // flinches easy
		FLINCH_HEALTH_RATIO = 0.75f; // " "
		MUMMY_STUN_CHANCE = "20%";
	}

	// game_death
	void OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		DqMonsterExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // dq/externals/dq_monster_externals
		MonstersExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/externals
		BaseSelfAdjust_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_self_adjust
		BaseNpc_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseMonsterShared_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared
		MummyBase_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/mummy_base
		CallExternal("all", "ext_master_died", self);
	}

	// game_precache
	void OnGamePrecache()
	{
		PrecacheFile("monsters/wraith_summoned");
	}

	// mummy_spawn
	void OnMummySpawn()
	{
		SetName("Mummified Necromonger");
		SetHealth(7000);
		SetDamageTaken("holy", 1.5f);

		SetModelBody(0, 0); // 0=Dark_Bandages 1=Tan_Bandages
		SetModelBody(1, 1); // 0=None 1=Priest 2=Royal 3=Warrior 4=High_Peasant
		SetModelBody(2, 4); // 0=None 1=Mace 2=Axe 3=Sword 4=Mace_Bigger 5=Magic_Sword 6=Pike 7=Pike_glowfx
		SetModelBody(3, 2); // 0=None 1=Red_Repulse 2=Weird_Confusion(hi-poly)
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		MummyNecro_FirstThink();
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
		if (name == "game_death") { OnGameDeath(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_precache") { OnGamePrecache(); return true; }
		if (name == "mummy_spawn") { OnMummySpawn(); return true; }
		return MummyBaseScript::DispatchEvent(name, params);
	}
}
