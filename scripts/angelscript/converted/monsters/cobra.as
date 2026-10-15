#pragma context server

// Converted from monsters/cobra.script by msc_transpiler.
// Cobra
// Thothie - increased ATTACK_RANGE to match ATTACK_HITRANGE
// - increased size to 64x64
// - Added poison effect of Fangtooth (95%) - 5-10 damage
// - Also added a few more HP
// - Figure doesnt attack unless attacked first, so midas well be a bit meaner

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_monster.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class Cobra
{
	// Constants
	string SOUND_ALERT = "monsters/gsnake_idle1.wav";
	string SOUND_IDLE = "monsters/gsnake_idle1.wav";
	string SOUND_ATTACK = "bullchicken/bc_bite2.wav";
	string SOUND_STRUCK = "debris/flesh3.wav";
	string SOUND_PAIN1 = "agrunt/ag_attack3.wav";
	string SOUND_PAIN2 = "agrunt/ag_idle2.wav";
	string SOUND_DEATH = "agrunt/ag_die2.wav";
	float DMG_POISON = 0.0f;

	// Variables (an unset .script variable reads as its own name)
	string ATTACK_HITCHANCE = "95%";
	string ANIM_RUN = "walk";
	string ANIM_IDLE = "idle1";
	string ANIM_WALK = "walk";
	string ATTACK1_DAMAGE = "45";
	string ANIM_DEATH = "ANIM_DEATH";
	string ANIM_ATTACK = "ANIM_ATTACK";
	float ATTACK_RANGE = 0.0f;
	float ATTACK_HITRANGE = 0.0f;
	string MOVE_RANGE = "MOVE_RANGE";
	float NPC_GIVE_EXP = 0.0f;
	bool DID_ALERT = false;

	// unnamed block (first think)
	void Cobra_FirstThink()
	{
		ATTACK_HITCHANCE = "95%";
		ANIM_RUN = "walk";
		ANIM_IDLE = "idle1";
		ANIM_WALK = "walk";
		ANIM_DEATH = "diesimple";
		ANIM_ATTACK = "attack1";
		ATTACK1_DAMAGE = "45";
		ATTACK_RANGE = 230.0f;
		ATTACK_HITRANGE = 230.0f;
		MOVE_RANGE = "64";
	}

	// npc_spawn
	void Cobra_OnNpcSpawn(string npc = "")
	{
		SetHealth(200);
		// ov 359
		SetWidth(64);
		SetHeight(64);
		SetRace("demon"); // for ease of placement
		SetName("Cobra");
		SetRoam(false);
		NPC_GIVE_EXP = 100.0f;
		SetModel("monsters/kcobra.mdl");
		SetIdleAnim("idle1");
		SetMoveAnim("idle1");
		PlayAnim("once", "idle1");
		SetHearingSensitivity(5);
	}

	// attack1
	void Cobra_OnAttack1()
	{
		DoDamage(ENTITY_ENEMY, ATTACK_RANGE, ATTACK1_DAMAGE, "75%");

		if (RandomInt(1, 3) == 1)
			ApplyEffect(ENT_LASTSEEN, "effects/dot_poison", 15, self, DMG_POISON);

		PlaySound(0, 10, SOUND_ATTACK);
	}

	// game_struck
	void Cobra_OnGameStruck(float damage = 0.0f, string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		PlayRandomSound(0, 10, SOUND_PAIN1, SOUND_PAIN2, SOUND_STRUCK, SOUND_STRUCK, SOUND_ATTACK);
	}

	// npcatk_targetvalidate
	void Cobra_OnNpcatkTargetvalidate(string target = "")
	{
		if (!IsAlive(target))
			return;
		if (RelationshipOf(target, ENT_ME) != "enemy")
			return;

		if (DID_ALERT)
			return;
		PlaySound(0, 10, SOUND_ALERT);
		DID_ALERT = true;
	}

	// idle_sounds
	void Cobra_OnIdleSounds()
	{
		PlaySound(0, 10, SOUND_IDLE);
		CallEventDelayed(Random(5, 10), "idle_sounds");
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)

	// game_struck
	void OnGameStruck(float damage = 0.0f, string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		BaseNpc_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseNpcAttack_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc_attack
		BaseMonsterShared_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared
		Cobra_OnGameStruck(damage, extraValue2, extraValue3, extraValue4);
	}

	// npcatk_targetvalidate
	void OnNpcatkTargetvalidate(string target = "")
	{
		BaseNpcAttack_OnNpcatkTargetvalidate(target); // monsters/base_npc_attack
		Cobra_OnNpcatkTargetvalidate(target);
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck
		Cobra_OnNpcSpawn(npc);
	}

	void OnAttack1() { Cobra_OnAttack1(); } // attack1
	void OnIdleSounds() { Cobra_OnIdleSounds(); } // idle_sounds

	// This file's events and timers by their .script names
	bool Cobra_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "attack1") { OnAttack1(); return true; }
		if (name == "game_struck") { OnGameStruck(Float(Param(params, 0)), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "idle_sounds") { OnIdleSounds(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "npcatk_targetvalidate") { OnNpcatkTargetvalidate(Param(params, 0)); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "monsters/cobra"]
shared class CobraScript : BaseMonsterScript, Cobra
{
	// Variables declared by included files, with the value they start with in this script
	CobraScript()
	{
		SOUND_DEATH = "agrunt/ag_die2.wav";
		ANIM_RUN = "walk";
		ANIM_IDLE = "idle1";
		ANIM_WALK = "walk";
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/kcobra.mdl");
		CallEventDelayed(Float(CYCLE_TIME), "hunting_mode_go");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		Cobra_FirstThink();
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
		return Cobra_DispatchEvent(name, params)
			|| BaseMonsterScript::DispatchEvent(name, params);
	}
}
