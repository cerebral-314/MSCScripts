#pragma context server

// Converted from monsters/snake_cursed.script by msc_transpiler.
// Cursed snake by Thothie (From Sidewinder)
// - Bites until it manages to poison something, then vanishes.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_monster_new.as"

[script "monsters/snake_cursed"]
class MonstersSnakeCursed : BaseMonsterNewScript
{
	// Constants
	string ATTACK_HITCHANCE = "80%";
	string ATTACK_DAMAGE = "$randf(5,20)";
	string POISON_DAMAGE = "$randf(10,50)";
	string POISON_DURATION = "$rand(10,20)";
	string SOUND_ALERT = "monsters/snake_idle1.wav";
	string SOUND_IDLE = "monsters/snake_idle2.wav";
	string SOUND_ATTACK = "bullchicken/bc_bite2.wav";
	string SOUND_PAIN1 = "monsters/snake_pain1.wav";
	string SOUND_PAIN2 = "monsters/snake_pain2.wav";
	string SOUND_POISON = "monsters/snakeman/sm_alert1.wav";
	string SOUND_STRUCK = "debris/flesh2.wav";
	string MONSTER_MODEL = "monsters/csnake.mdl";

	// Variables (an unset .script variable reads as its own name)
	bool IS_UNHOLY = true;
	string ANIM_ATTACK = "ANIM_ATTACK";
	bool BITE_SOUND = false;
	bool DID_ALERT = false;
	string NPC_DELAYING_UNSTUCK = "NPC_DELAYING_UNSTUCK";
	float ATTACK_DELAY = 0.0f;

	// Variables declared by included files, with the value they start with in this script
	MonstersSnakeCursed()
	{
		ANIM_WALK = "walk";
		ANIM_RUN = "walk";
		ANIM_IDLE = "idle1";
	}

	// unnamed block (first think)
	void MonstersSnakeCursed_FirstThink()
	{
		IS_UNHOLY = true;

		ANIM_WALK = "walk";
		ANIM_RUN = "walk";
		ANIM_DEATH = "diesimple";
		ANIM_IDLE = "idle1";
		ANIM_ATTACK = "attack1";
		ATTACK_RANGE = 80.0f;
		ATTACK_HITRANGE = 120.0f;
		ATTACK_MOVERANGE = 35.0f;

		NPC_GIVE_EXP = 5.0f;

		NO_SPAWN_STUCK_CHECK = true;
	}

	// game_damaged_other
	// PARAM1=ent hit PARAM2=damage
	string MonstersSnakeCursed_OnGameDamagedOther(CBaseEntity@ target = null, float damage = 0.0f, string damageType = "", string damageEvent = "")
	{
		string result = "";

		if (!BITE_SOUND)
			return result;
		BITE_SOUND = false;
		if (RandomInt(1, 5) != 1)
			return result;
		PlaySound(0, 10, SOUND_POISON);
		ApplyEffect(target, "effects/dot_poison", POISON_DURATION, self, POISON_DAMAGE);
		OnNpcFadeAway();
		return result;
	}

	// game_damaged_other
	string OnGameDamagedOther(CBaseEntity@ target = null, float damage = 0.0f, string damageType = "", string damageEvent = "")
	{
		string result = "";
		result = AppendResult(result, MonstersExternals_OnGameDamagedOther(target, damage, damageType, damageEvent));
		result = AppendResult(result, BaseAntiStuck_OnGameDamagedOther(target, damage, damageType, damageEvent));
		result = AppendResult(result, BaseMonsterShared_OnGameDamagedOther(target, damage, damageType, damageEvent));
		result = AppendResult(result, MonstersSnakeCursed_OnGameDamagedOther(target, damage, damageType, damageEvent));
		return result;
	}

	// game_struck
	void OnGameStruck(float damage = 0.0f, string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		BaseNpc_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseNpcAttackNew_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc_attack_new
		BaseMonsterShared_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared

		PlayRandomSound(0, 10, SOUND_PAIN1, SOUND_PAIN2, SOUND_STRUCK, SOUND_STRUCK);
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseNpcAttackNew_OnNpcSpawn(npc); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck

		SetName("Cursed Snake");
		SetHealth(30);
		SetWidth(48);
		SetHeight(32);
		SetRoam(false);
		SetRace("demon"); // for easier placement
		SetModel(MONSTER_MODEL);
		SetHearingSensitivity(4);
		CallEventDelayed(1.0f, "idle_sounds");
		SetDamageTaken("poison", 0);
		SetDamageTaken("holy", 2);
		SetSolid("none");
	}

	// npcatk_targetvalidate
	void OnNpcatkTargetvalidate(string target = "")
	{
		BaseNpcAttackNew_OnNpcatkTargetvalidate(target); // monsters/base_npc_attack_new

		if (DID_ALERT)
			return;
		PlaySound(0, 10, SOUND_ALERT);
		SetRoam(true);
		DID_ALERT = true;
	}

	// my_target_died
	void OnMyTargetDied(string offender = "")
	{
		BaseNpcAttackNew_OnMyTargetDied(offender); // monsters/base_npc_attack_new

		// vanishes on kill
		OnNpcFadeAway();
	}

	// idle_sounds
	void OnIdleSounds()
	{
		PlaySound(0, 10, SOUND_IDLE);
		CallEventDelayed(Random(5, 10), "idle_sounds");
	}

	// bite1
	void OnBite1()
	{
		BITE_SOUND = true;
		OnNpcatkDodamage(NPCATK_TARGET, Text(ATTACK_HITRANGE), ATTACK_DAMAGE, ATTACK_HITCHANCE, ENT_ME);
	}

	// npcatk_attack
	void OnNpcatkAttack()
	{
		NPC_DELAYING_UNSTUCK = "NPC_UNSTUCK_DELAY"; // I've stopped moving to attack, I'm not stuck

		if (int(ATTACK_DELAY) != 0)
			return;
		PlayAnim("critical", ANIM_ATTACK);
		PlaySound(0, 10, SOUND_ATTACK);
		ATTACK_DELAY = 1.0f;
		CallEventDelayed(1.0f, "reset_attack_delay");
	}

	// reset_attack_delay
	void OnResetAttackDelay()
	{
		ATTACK_DELAY = 0.0f;
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/csnake.mdl");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		MonstersSnakeCursed_FirstThink();
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
		if (name == "bite1") { OnBite1(); return true; }
		if (name == "game_damaged_other") { Return(OnGameDamagedOther(EntityParam(params, 0), Float(Param(params, 1)), Param(params, 2), Param(params, 3))); return true; }
		if (name == "game_struck") { OnGameStruck(Float(Param(params, 0)), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "idle_sounds") { OnIdleSounds(); return true; }
		if (name == "my_target_died") { OnMyTargetDied(Param(params, 0)); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "npcatk_attack") { OnNpcatkAttack(); return true; }
		if (name == "npcatk_targetvalidate") { OnNpcatkTargetvalidate(Param(params, 0)); return true; }
		if (name == "reset_attack_delay") { OnResetAttackDelay(); return true; }
		return BaseMonsterNewScript::DispatchEvent(name, params);
	}
}
