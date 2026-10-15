#pragma context server

// Converted from minibosses/bloodreaver.script by msc_transpiler.
// This is an older script and may have some bad conventions as a result.
// Thothie - for MS 1.35 compatitbility - and because mini-bosses are kewl! ;)
// Notable Differences from Calrian <hp <gold sounds model size trigger text
// Bloodreaver (from Calrian)

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_monster_new.as"

[script "minibosses/bloodreaver"]
class Bloodreaver : BaseMonsterNewScript
{
	// Constants
	string ATTACK_DAMAGE = "30";
	string ATTACK_HITCHANCE = "85%";
	string SOUND_STRUCK1 = "garg/gar_pain1.wav";
	string SOUND_STRUCK2 = "garg/gar_pain2.wav";
	string SOUND_STRUCK3 = "garg/gar_pain3.wav";
	string SOUND_PAIN = "garg/gar_pain3.wav";
	string SOUND_ATTACK1 = "controller/con_attack1.wav";
	string SOUND_ATTACK2 = "controller/con_attack2.wav";
	string SOUND_IDLE1 = "controller/con_attack3.wav";
	string SOUND_SPAWN = "monsters/skeleton/calrian2.wav";

	// Variables (an unset .script variable reads as its own name)
	string CAN_HUNT = "CAN_HUNT";
	string HUNT_AGRO = "HUNT_AGRO";
	string ANIM_ATTACK = "ANIM_ATTACK";
	string MY_ENEMY = "MY_ENEMY";
	int DROP_GOLD_MIN = 0;
	int DROP_GOLD_MAX = 0;
	bool I_AM_TURNABLE = false;

	// Variables declared by included files, with the value they start with in this script
	Bloodreaver()
	{
		ANIM_RUN = "walk";
		ANIM_WALK = "walk";
		ANIM_IDLE = "idle1";
		SOUND_DEATH = "garg/gar_die1.wav";
	}

	// unnamed block (first think)
	void Bloodreaver_FirstThink()
	{
		ANIM_RUN = "walk";
		ANIM_WALK = "walk";
		ANIM_IDLE = "idle1";
		CAN_HUNT = "1";
		HUNT_AGRO = "0";
		ANIM_ATTACK = "attack1";
		MOVE_RANGE = "40";
		ATTACK_RANGE = 100.0f;
		ATTACK_HITRANGE = 200.0f;
		MY_ENEMY = "enemy"; // base_npc_attack - Premptive attack
		RETALIATE_CHANCE = "75%"; // base_npc_attack - Automatically switch targets to the last damaging player
		CAN_FLEE = "0"; // base_npc_attack - Whether I run away at low health
		DROP_GOLD = 1;
		DROP_GOLD_MIN = 100;
		DROP_GOLD_MAX = 240;
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseNpcAttackNew_OnNpcSpawn(npc); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck

		I_AM_TURNABLE = false;

		SetName("Blood Reaver");
		SetRoam(false);
		SetHearingSensitivity(8);
		NPC_GIVE_EXP = 200.0f;
		SetRace("undead");
		SetModel("monsters/skeleton3.mdl");
		SetModelBody(1, 0);
		SetHealth(2000);
		SetWidth(64);
		SetHeight(128);
		SetDamageTaken("all", 0.65f);
		SetDamageTaken("holy", 2);
		SetDamageTaken("fire", 0);
		SetDamageTaken("blunt", 0.5f);
		SetIdleAnim("idle1");
		SetMoveAnim(ANIM_WALK);
		PlayAnim(ANIM_IDLE);
		SetIdleAnim(ANIM_IDLE);
		SetRoam(false);

		PlaySound(2, 10, SOUND_SPAWN);
		GiveItem("scroll2_summon_undead");
	}

	// npcatk_targetvalidate
	void OnNpcatkTargetvalidate(string target = "")
	{
		BaseNpcAttackNew_OnNpcatkTargetvalidate(target); // monsters/base_npc_attack_new

		if (RelationshipOf(ENT_ME, target) != "enemy")
			return;
		SetRoam(true);
	}

	// attack_1
	void OnAttack12()
	{
		DoDamage(ENT_LASTSEEN, ATTACK_HITRANGE, ATTACK_DAMAGE, ATTACK_HITCHANCE);

		if (RandomInt(0, 1) == 0)
		{
			SetVolume(5);
			PlayRandomSound(2, 5, SOUND_ATTACK1, SOUND_ATTACK2);
		}
	}

	// npc_struck
	// Hit by someone
	void OnNpcStruck(float damage = 0.0f)
	{
		SetRoam(true);
		SetVolume(5);
		PlayRandomSound(2, 5, SOUND_PAIN, SOUND_PAIN, SOUND_STRUCK1, SOUND_STRUCK2, SOUND_STRUCK3);
	}

	// npc_death
	void OnNpcDeath()
	{
		PlaySound(2, 10, SOUND_DEATH);
		PlaySound(2, 10, "SND_DEATH2");
		UseTrigger("bloodreaver_die");
		SetSayTextRange(1024);
		SayText("After all this time, alas... I can rest.");
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/skeleton3.mdl");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		Bloodreaver_FirstThink();
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
		if (name == "attack_1") { OnAttack12(); return true; }
		if (name == "npc_death") { OnNpcDeath(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "npc_struck") { OnNpcStruck(Float(Param(params, 0))); return true; }
		if (name == "npcatk_targetvalidate") { OnNpcatkTargetvalidate(Param(params, 0)); return true; }
		return BaseMonsterNewScript::DispatchEvent(name, params);
	}
}
