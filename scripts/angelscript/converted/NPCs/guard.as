#pragma context server

// Converted from NPCs/guard.script by msc_transpiler.
// Guard

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_npc_attack.as"

[script "NPCs/guard"]
class NPCsGuard : BaseNpcAttackScript
{
	// Variables (an unset .script variable reads as its own name)
	string ATTACK_PERCENTAGE = "95%";
	string ANIM_ATTACK = "attack";
	string RETALIATE_CHANGETARGET_CHANCE = "75%";
	bool CAN_STTACK = false;

	// Variables declared by included files, with the value they start with in this script
	NPCsGuard()
	{
		ATTACK_RANGE = 150.0f;
		MOVE_RANGE = "90";
		CAN_ATTACK = "0";
		ANIM_WALK = "walk";
		ANIM_RUN = "run";
		CAN_HUNT = "0";
		CAN_FLEE = "0";
		CAN_RETALIATE = "1";
	}

	// unnamed block (first think)
	void NPCsGuard_FirstThink()
	{
		ATTACK_RANGE = 150.0f;
		MOVE_RANGE = "90";
		CAN_ATTACK = "0";
		ATTACK_PERCENTAGE = "95%";
		ANIM_WALK = "walk";
		ANIM_RUN = "run";
		ANIM_ATTACK = "attack";
		CAN_HUNT = "0";
		CAN_FLEE = "0";
		CAN_RETALIATE = "1";
		RETALIATE_CHANGETARGET_CHANCE = "75%";
	}

	// unnamed block (timer)
	// Greet player and other NPCs
	void NPCsGuard_Timer()
	{
		CallEventDelayed(30.0f, "NPCsGuard_Timer");

		SetMoveDest(ENT_LASTSEEN, 128);

		SetVolume(2);
		Say("hello1[50]", "*[20]", "*[55]", "*[55]", "*[23]", "*[22]");
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		SetHealth(100);
		SetGold(10);
		// ov		180
		SetWidth(32);
		SetHeight(72);
		SetRace("neutral");
		SetName("Guard");
		SetRoam(true);
		SetModel("npc/guard1.mdl");
		SetMoveAnim("walk");
		SetInvincible(false);
	}

	// attack_1
	void OnAttack12()
	{
		// Deal damage
		DoDamage(ENT_LASTSEEN, ATTACK_RANGE, Random(5, 8), ATTACK_PERCENTAGE);
	}

	// npc_struck
	void OnNpcStruck(float damage = 0.0f)
	{
		CAN_STTACK = true;
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("npc/guard1.mdl");
		Precache("npc/hello1.wav");
		CallEventDelayed(30.0f, "NPCsGuard_Timer");
		CallEventDelayed(Float(CYCLE_TIME), "hunting_mode_go");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		NPCsGuard_FirstThink();
		BaseNpcAttack_FirstThink();
		BaseNpc_FirstThink();
		MonstersExternals_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "attack_1") { OnAttack12(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "npc_struck") { OnNpcStruck(Float(Param(params, 0))); return true; }
		if (name == "NPCsGuard_Timer") { NPCsGuard_Timer(); return true; }
		return BaseNpcAttackScript::DispatchEvent(name, params);
	}
}
