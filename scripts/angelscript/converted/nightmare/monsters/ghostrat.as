#pragma context server

// Converted from nightmare/monsters/ghostrat.script by msc_transpiler.
// Ghostly Rat
// Rat reskin by Furion001
// V1.0
// 10x original rat script stats
// Dynamic enemy system WIP
// + Added Light script to make rats more visable

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_monster.as"

[script "nightmare/monsters/ghostrat"]
class Ghostrat : BaseMonsterScript
{
	// Constants
	bool NO_EXP_MULTI = true;

	// Variables (an unset .script variable reads as its own name)
	string ATTACK_DAMAGE = "4.0";
	string ATTACK_HITCHANCE = "60%";
	string SOUND_STRUCK1 = "weapons/cbar_hitbod1.wav";
	string SOUND_STRUCK2 = "weapons/cbar_hitbod2.wav";
	string SOUND_STRUCK3 = "weapons/cbar_hitbod3.wav";
	string SOUND_PAIN = "nightmare/monsters/ghostrat/squeak1.wav";
	string SOUND_ATTACK1 = "nightmare/monsters/ghostrat/squeak2.wav";
	string SOUND_ATTACK2 = "monsters/orc/attack2.wav";
	string SOUND_ATTACK3 = "monsters/orc/attack3.wav";
	string SOUND_IDLE1 = "nightmare/monsters/ghostrat/squeak2.wav";
	int FLEE_HEALTH = 2;
	string FLEE_CHANCE = "30%";
	string ANIM_ATTACK = "ANIM_ATTACK";
	string DROP_ITEM1 = "DROP_ITEM1";

	// Variables declared by included files, with the value they start with in this script
	Ghostrat()
	{
		ANIM_RUN = "run";
		ANIM_WALK = "walk";
		ANIM_IDLE = "idle1";
		SOUND_DEATH = "nightmare/monsters/ghostrat/squeak3.wav";
	}

	// unnamed block (first think)
	void Ghostrat_FirstThink()
	{
		HUNT_AGRO = "0";

		ANIM_DEATH = "die";
		ANIM_RUN = "run";
		ANIM_WALK = "walk";
		ANIM_IDLE = "idle1";
		ANIM_ATTACK = "attack";
		ATTACK_DAMAGE = "4.0";
		ATTACK_RANGE = 68.0f;
		ATTACK_HITCHANCE = "60%";
		SOUND_STRUCK1 = "weapons/cbar_hitbod1.wav";
		SOUND_STRUCK2 = "weapons/cbar_hitbod2.wav";
		SOUND_STRUCK3 = "weapons/cbar_hitbod3.wav";
		SOUND_PAIN = "nightmare/monsters/ghostrat/squeak1.wav";
		SOUND_ATTACK1 = "nightmare/monsters/ghostrat/squeak2.wav";
		SOUND_ATTACK2 = "monsters/orc/attack2.wav";
		SOUND_ATTACK3 = "monsters/orc/attack3.wav";
		SOUND_IDLE1 = "nightmare/monsters/ghostrat/squeak2.wav";
		SOUND_DEATH = "nightmare/monsters/ghostrat/squeak3.wav";
		CAN_FLEE = "1"; // Used by base_npc_attack
		FLEE_HEALTH = 2; // Used by base_npc_attack
		FLEE_CHANCE = "30%"; // Used by base_npc_attack
		DROP_ITEM1 = "skin_ratpelt"; // Used by base_monster
		DROP_ITEM1_CHANCE = "0%"; // Used by base_monster
	}

	// unnamed block (timer)
	void Ghostrat_Timer()
	{
		CallEventDelayed(10.1f, "Ghostrat_Timer");
		// renew light 10/secs (light is now self-removing)
		if (!IsAlive(ENT_ME))
			return;
		ClientEvent("new", "all", "effects/sfx_follow_glow_cl", IndexOf(ENT_ME), Vector3(0, 128, 128), 128, 10.0f);
	}

	// unnamed block (timer)
	void Ghostrat_Timer2()
	{
		CallEventDelayed(10.0f, "Ghostrat_Timer2");

		if (IS_HUNTING)
			return;
		if (RandomInt(0, 1) == 0)
			return;

		PlayAnim("once", "idle2");
	}

	// npc_post_spawn
	// Light glow
	void OnNpcPostSpawn()
	{
		MonstersExternals_OnNpcPostSpawn(); // monsters/externals
		MonstersExternals_OnNpcPostSpawn_2(); // monsters/externals
		MonstersExternals_OnNpcPostSpawn_3(); // monsters/externals
		BaseSelfAdjust_OnNpcPostSpawn(); // monsters/base_self_adjust
		BaseNpc_OnNpcPostSpawn(); // monsters/base_npc
		BaseMonsterShared_OnNpcPostSpawn(); // monsters/base_monster_shared
		ClientEvent("new", "all", "effects/sfx_follow_glow_cl", IndexOf(ENT_ME), Vector3(0, 128, 128), 128, 10.0f);
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck

		SetHealth(40);
		// ov 150
		SetWidth(24);
		SetHeight(24);
		SetName("Ghostly Rat");
		SetRoam(true);
		SetHearingSensitivity(0);
		NPC_GIVE_EXP = 30.0f;
		SetRace("undead");

		SetModel("nightmare/monsters/ghost_rat.mdl");
		SetModelBody(1, 0);
		SetIdleAnim("idle");
		SetMoveAnim(ANIM_WALK);
		SetProp(ENT_ME, "rendermode", 5);
		SetProp(ENT_ME, "renderamt", 255);
		SetProp(ENT_ME, "renderfx", 16);
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
		Precache("nightmare/monsters/ghost_rat.mdl");
		CallEventDelayed(10.1f, "Ghostrat_Timer");
		CallEventDelayed(10.0f, "Ghostrat_Timer2");
		CallEventDelayed(Float(CYCLE_TIME), "hunting_mode_go");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		Ghostrat_FirstThink();
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
		if (name == "npc_post_spawn") { OnNpcPostSpawn(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "npc_struck") { OnNpcStruck(Float(Param(params, 0))); return true; }
		if (name == "Ghostrat_Timer") { Ghostrat_Timer(); return true; }
		if (name == "Ghostrat_Timer2") { Ghostrat_Timer2(); return true; }
		return BaseMonsterScript::DispatchEvent(name, params);
	}
}
