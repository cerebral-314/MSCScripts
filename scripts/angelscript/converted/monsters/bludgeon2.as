#pragma context server

// Converted from monsters/bludgeon2.script by msc_transpiler.
// Meaner nastier bludgeon by Frodo/Little-G request

#include "runtime/ScriptEntity.as"
#include "converted/monsters/bludgeon.as"

[script "monsters/bludgeon2"]
class Bludgeon2 : BludgeonScript
{
	// Variables declared by included files, with the value they start with in this script
	Bludgeon2()
	{
		SOUND_STRUCK1 = "monsters/bludgeon/bludgeonattack2.wav";
		SOUND_STRUCK2 = "monsters/bludgeon/bludgeonattack2.wav";
		SOUND_STRUCK3 = "monsters/bludgeon/bludgeonattack2.wav";
		SOUND_PAIN = "monsters/bludgeon/bludgeonpain2.wav";
		SOUND_IDLE1 = "monsters/bludgeon/bludgeonidle2.wav";
		SOUND_IDLE2 = "monsters/bludgeon/bludgeonidle2.wav";
		SOUND_DEATH = "monsters/bludgeon/bludgeonpain2.wav";
		ATTACK_DAMAGE = "$rand(40,80)";
		CHARGE_DAMAGE = "$rand(80,160)";
	}

	// unnamed block (first think)
	void Bludgeon2_FirstThink()
	{
		IS_UNHOLY = true;

		// setvard CAN_FLEE		1
		// const FLEE_HEALTH		100
		// const FLEE_CHANCE		50%
		NPC_GIVE_EXP = 250.0f;
		DROP_GOLD = 1;
		DROP_GOLD_MIN = 15;
		DROP_GOLD_MAX = 50;

		MOVE_RANGE = "32";
		ATTACK_RANGE = 96.0f;
		ATTACK_HITRANGE = 120.0f;
		PrecacheFile(CL_SCRIPT);
	}

	// my_target_died
	void OnMyTargetDied(string offender = "")
	{
		BaseNpcAttack_OnMyTargetDied(offender); // monsters/base_npc_attack
		Bludgeon_OnMyTargetDied(offender); // monsters/bludgeon
		IS_JUMPING = false;
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck
		Bludgeon_OnNpcSpawn(npc); // monsters/bludgeon

		SetName("Bludgeon Demon Warrior");
		SetModel("monsters/bludgeon.mdl");
		SetHealth(800);
		SetWidth(32);
		SetHeight(72);
		SetRace("demon");
		SetRoam(true);
		SetHearingSensitivity(8);
		SetDamageTaken("all", 0.5f); // dark armor.. damn my tabs don't match source :)
		SetDamageTaken("fire", 0); // immune to fire
		SetDamageTaken("cold", 2); // very vulnerable to cold
		SetDamageTaken("lightning", 2); // vulnerable to lightning
		SetDamageTaken("holy", 1);

		SetMoveSpeed(BASE_MOVESPEED); // anim LX fux0red

		CallEventDelayed(5.0f, "idle_loop");

		SetIdleAnim(ANIM_IDLE);
		SetMoveAnim(ANIM_WALK);
		PlayAnim("once", ANIM_IDLE);
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		Bludgeon2_FirstThink();
		Bludgeon_FirstThink();
		BaseNpcAttack_FirstThink();
		BaseNpc_FirstThink();
		MonstersExternals_FirstThink();
		BaseMonsterShared_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "my_target_died") { OnMyTargetDied(Param(params, 0)); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		return BludgeonScript::DispatchEvent(name, params);
	}
}
