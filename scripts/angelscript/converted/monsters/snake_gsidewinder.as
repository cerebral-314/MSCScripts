#pragma context server

// Converted from monsters/snake_gsidewinder.script by msc_transpiler.
// Giant Sidewinder by Thothie (from Sidewinder)

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_monster_new.as"

[script "monsters/snake_gsidewinder"]
class SnakeGsidewinder : BaseMonsterNewScript
{
	// Constants
	string ATTACK_HITCHANCE = "80%";
	string ATTACK_DAMAGE = "$randf(10,30)";
	string POISON_DAMAGE = "$randf(4,8)";
	string POISON_DURATION = "$rand(30,45)";
	string SOUND_ALERT = "monsters/gsnake_idle1.wav";
	string SOUND_IDLE = "monsters/gsnake_idle1.wav";
	string SOUND_ATTACK = "bullchicken/bc_bite2.wav";
	string SOUND_POISON = "monsters/snakeman/sm_alert1.wav";
	string SOUND_STRUCK = "debris/flesh3.wav";
	string SOUND_PAIN1 = "agrunt/ag_attack3.wav";
	string SOUND_PAIN2 = "agrunt/ag_idle2.wav";
	string MONSTER_MODEL = "monsters/gsidewinder.mdl";
	string MONSTER_MODELT = "monsters/gsidewinderT.mdl";

	// Variables (an unset .script variable reads as its own name)
	string ANIM_ATTACK = "ANIM_ATTACK";
	bool BITE_SOUND = false;
	bool DID_ALERT = false;
	string NPC_DELAYING_UNSTUCK = "NPC_DELAYING_UNSTUCK";
	float ATTACK_DELAY = 0.0f;

	// Variables declared by included files, with the value they start with in this script
	SnakeGsidewinder()
	{
		ANIM_WALK = "walk";
		ANIM_RUN = "walk";
		ANIM_IDLE = "idle1";
		SOUND_DEATH = "agrunt/ag_die2.wav";
	}

	// unnamed block (first think)
	void SnakeGsidewinder_FirstThink()
	{
		ANIM_WALK = "walk";
		ANIM_RUN = "walk";
		ANIM_DEATH = "diesimple";
		ANIM_IDLE = "idle1";
		ANIM_ATTACK = "attack1";
		ATTACK_RANGE = 100.0f;
		ATTACK_HITRANGE = 180.0f;
		ATTACK_MOVERANGE = 30.0f;
	}

	// game_damaged_other
	// PARAM1=ent hit PARAM2=damage
	string SnakeGsidewinder_OnGameDamagedOther(CBaseEntity@ target = null, float damage = 0.0f, string damageType = "", string damageEvent = "")
	{
		string result = "";

		if (!BITE_SOUND)
			return result;
		BITE_SOUND = false;
		if (RandomInt(1, 2) != 1)
			return result;
		PlaySound(0, 10, SOUND_POISON);
		ApplyEffect(target, "effects/dot_poison", POISON_DURATION, self, POISON_DAMAGE);
		return result;
	}

	// game_damaged_other
	string OnGameDamagedOther(CBaseEntity@ target = null, float damage = 0.0f, string damageType = "", string damageEvent = "")
	{
		string result = "";
		result = AppendResult(result, MonstersExternals_OnGameDamagedOther(target, damage, damageType, damageEvent));
		result = AppendResult(result, BaseAntiStuck_OnGameDamagedOther(target, damage, damageType, damageEvent));
		result = AppendResult(result, BaseMonsterShared_OnGameDamagedOther(target, damage, damageType, damageEvent));
		result = AppendResult(result, SnakeGsidewinder_OnGameDamagedOther(target, damage, damageType, damageEvent));
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

		SetName("Large Rattle Snake");
		SetHealth(400);
		SetWidth(48);
		SetHeight(32);
		SetRoam(false);
		NPC_GIVE_EXP = 100.0f;
		SetRace("demon"); // for easier placement
		SetModel(MONSTER_MODEL);
		SetHearingSensitivity(8);
		CallEventDelayed(0.2f, "post_spawn_props");
		CallEventDelayed(1.0f, "idle_sounds");
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

		SetMoveDest(NPC_SPAWN_LOC);
		OnIdleSounds();
		DID_ALERT = false;
	}

	// idle_sounds
	void OnIdleSounds()
	{
		PlaySound(0, 10, SOUND_IDLE);
		CallEventDelayed(Random(5, 10), "idle_sounds");
	}

	// post_spawn_props
	void OnPostSpawnProps()
	{
		SetDamageTaken("holy", 0); // not actually a demon :)
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
		Precache("monsters/gsidewinder.mdl");
		Precache("monsters/gsidewinderT.mdl");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		SnakeGsidewinder_FirstThink();
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
		if (name == "post_spawn_props") { OnPostSpawnProps(); return true; }
		if (name == "reset_attack_delay") { OnResetAttackDelay(); return true; }
		return BaseMonsterNewScript::DispatchEvent(name, params);
	}
}
