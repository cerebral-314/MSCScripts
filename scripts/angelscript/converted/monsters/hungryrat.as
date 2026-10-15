#pragma context server

// Converted from monsters/hungryrat.script by msc_transpiler.
// Rat

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_monster.as"

[script "monsters/hungryrat"]
class Hungryrat : BaseMonsterScript
{
	// Variables (an unset .script variable reads as its own name)
	string ATTACK_DAMAGE = "1.2";
	string ATTACK_HITCHANCE = "30%";
	string SOUND_STRUCK1 = "weapons/cbar_hitbod1.wav";
	string SOUND_STRUCK2 = "weapons/cbar_hitbod2.wav";
	string SOUND_STRUCK3 = "weapons/cbar_hitbod3.wav";
	string SOUND_PAIN = "monsters/rat/squeak1.wav";
	string SOUND_ATTACK1 = "monsters/rat/squeak2.wav";
	string SOUND_ATTACK2 = "monsters/orc/attack2.wav";
	string SOUND_ATTACK3 = "monsters/orc/attack3.wav";
	string SOUND_IDLE1 = "monsters/rat/squeak2.wav";
	int FLEE_HEALTH = 2;
	string FLEE_CHANCE = "10%";
	string ANIM_ATTACK = "ANIM_ATTACK";
	string DROP_ITEM1 = "DROP_ITEM1";

	// Variables declared by included files, with the value they start with in this script
	Hungryrat()
	{
		ANIM_RUN = "run";
		ANIM_WALK = "walk";
		SOUND_DEATH = "monsters/rat/squeak3.wav";
	}

	// unnamed block (first think)
	void Hungryrat_FirstThink()
	{
		ANIM_RUN = "run";
		ANIM_WALK = "walk";
		ANIM_ATTACK = "attack";
		ATTACK_DAMAGE = "1.2";
		ATTACK_RANGE = 68.0f;
		ATTACK_HITCHANCE = "30%";
		SOUND_STRUCK1 = "weapons/cbar_hitbod1.wav";
		SOUND_STRUCK2 = "weapons/cbar_hitbod2.wav";
		SOUND_STRUCK3 = "weapons/cbar_hitbod3.wav";
		SOUND_PAIN = "monsters/rat/squeak1.wav";
		SOUND_ATTACK1 = "monsters/rat/squeak2.wav";
		SOUND_ATTACK2 = "monsters/orc/attack2.wav";
		SOUND_ATTACK3 = "monsters/orc/attack3.wav";
		SOUND_IDLE1 = "monsters/rat/squeak2.wav";
		CAN_FLEE = "1"; // Used by base_npc_attack
		FLEE_HEALTH = 2; // Used by base_npc_attack
		FLEE_CHANCE = "10%"; // Used by base_npc_attack
		DROP_ITEM1 = "skin_ratpelt"; // Used by base_monster
		DROP_ITEM1_CHANCE = "35%"; // Used by base_monster
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck

		SetHealth(20);
		// ov 150
		SetWidth(40);
		SetHeight(64);
		SetName("Hungry looking rat");
		SetRoam(true);
		SetHearingSensitivity(0);
		NPC_GIVE_EXP = 3.0f;
		SetRace("demon"); // ease of placement

		SetModel("monsters/giant_rat.mdl");
		SetModelBody(1, 0);
		SetIdleAnim("idle");
		SetMoveAnim(ANIM_WALK);
	}

	// bite1
	void OnBite1()
	{
		// Deal damage
		PlayRandomSound(2, SOUND_ATTACK1, "none");
		DoDamage(ENT_LASTSEEN, ATTACK_RANGE, ATTACK_DAMAGE, ATTACK_HITCHANCE);
	}

	// npc_struck
	// Hit by someone
	void OnNpcStruck(float damage = 0.0f)
	{
		SetVolume(5);
		PlayRandomSound(2, 5, SOUND_PAIN, SOUND_STRUCK2, SOUND_STRUCK1, SOUND_STRUCK3, SOUND_PAIN);
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/giant_rat.mdl");
		CallEventDelayed(Float(CYCLE_TIME), "hunting_mode_go");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		Hungryrat_FirstThink();
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
		if (name == "bite1") { OnBite1(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "npc_struck") { OnNpcStruck(Float(Param(params, 0))); return true; }
		return BaseMonsterScript::DispatchEvent(name, params);
	}
}
