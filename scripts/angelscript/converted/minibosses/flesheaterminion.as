#pragma context server

// Converted from minibosses/flesheaterminion.script by msc_transpiler.
// This is an older script and may have some bad conventions as a result.
// Thothie - for MS 1.35 compatitbility - and because mini-bosses are kewl! ;)
// Notable Differences from Calrian <damage <hp <gold sounds poison
// Flesheater Minion

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_monster.as"

[script "minibosses/flesheaterminion"]
class Flesheaterminion : BaseMonsterScript
{
	// Constants
	string ATTACK_DAMAGE = "10";
	string ATTACK_HITCHANCE = "85%";
	string SOUND_STRUCK1 = "controller/con_pain3.wav";
	string SOUND_STRUCK2 = "controller/con_pain3.wav";
	string SOUND_STRUCK3 = "none";
	string SOUND_PAIN = "zombie/zo_pain2.wav";
	string SOUND_ATTACK1 = "controller/con_attack1.wav";
	string SOUND_ATTACK2 = "controller/con_attack2.wav";
	string SOUND_IDLE1 = "controller/con_attack3.wav";

	// Variables (an unset .script variable reads as its own name)
	string ANIM_ATTACK = "ANIM_ATTACK";
	string MY_ENEMY = "MY_ENEMY";
	int DROP_GOLD_MIN = 0;
	int DROP_GOLD_MAX = 0;
	bool I_AM_TURNABLE = false;
	bool SET_GREEK = false;

	// Variables declared by included files, with the value they start with in this script
	Flesheaterminion()
	{
		ANIM_RUN = "run";
		ANIM_WALK = "walk";
		ANIM_IDLE = "idle1";
		SOUND_DEATH = "controller/con_die2.wav";
	}

	// unnamed block (first think)
	void Flesheaterminion_FirstThink()
	{
		ANIM_RUN = "run";
		ANIM_WALK = "walk";
		ANIM_IDLE = "idle1";
		CAN_HUNT = "1";
		HUNT_AGRO = "1";
		CAN_ATTACK = "1";
		ANIM_ATTACK = "attack3";
		ATTACK_RANGE = 100.0f;
		ATTACK_HITRANGE = 200.0f;
		MOVE_RANGE = "90";
		MY_ENEMY = "enemy"; // base_npc_attack - Premptive attack
		RETALIATE_CHANCE = "75%"; // base_npc_attack - Automatically switch targets to the last damaging player
		CAN_FLEE = "0"; // base_npc_attack - Whether I run away at low health
		DROP_GOLD = 1;
		DROP_GOLD_MIN = 15;
		DROP_GOLD_MAX = 240;
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck

		I_AM_TURNABLE = false;

		SetHealth(400);
		// ov 359
		SetWidth(32);
		SetHeight(80);
		SetName("A minion of Flesheater");
		SetRoam(true);
		SetHearingSensitivity(8);
		NPC_GIVE_EXP = 80.0f;
		SetRace("undead");
		SetModel("monsters/skeleton_enraged.mdl");
		SetModelBody(0, 2); // 0=standard 1=ash 2=green 3=bloody 4=decayed 5=ice 6=gold 7=stone 8=crystal 9=weirdgel
		SetModelBody(1, 7); // 0=Unarmed 1=darkmace 2=sword 3=hammahs 4=bigsword+shield 5=iceclubs 6=fireclubs 7=highsword 8=wand
		SetDamageTaken("all", 0.65f);
		SetDamageTaken("holy", 3);
		SetDamageTaken("poison", 0);
		SetIdleAnim("idle1");
		SetMoveAnim(ANIM_WALK);

		if (ToLowerCase(MapName()) == "thanatos")
			SET_GREEK = true;
		if (SET_GREEK)
			SetModelBody(0, 10);

		CallEventDelayed(2.0f, "game_wander");
	}

	// attack_3
	void OnAttack3()
	{
		DoDamage(ENT_LASTSEEN, ATTACK_HITRANGE, ATTACK_DAMAGE, ATTACK_HITCHANCE);
		ApplyEffect(ENT_LASTSTRUCKBYME, "effects/dot_poison", 5, ENT_ME, RandomInt(8, 12));

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
		SetVolume(5);
		PlayRandomSound(2, 5, SOUND_PAIN, SOUND_PAIN, SOUND_STRUCK1, SOUND_STRUCK2, SOUND_STRUCK3);
	}

	// npc_death
	void OnNpcDeath()
	{
		ANIM_DEATH = "dieheadshot";
		if (RandomInt(0, 1) == 0)
			SayText("My master shall have your flesh!");
	}

	// go_greek
	void OnGoGreek()
	{
		SetModelBody(0, 10);
		SET_GREEK = true;
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/skeleton_enraged.mdl");
		CallEventDelayed(Float(CYCLE_TIME), "hunting_mode_go");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		Flesheaterminion_FirstThink();
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
		if (name == "attack_3") { OnAttack3(); return true; }
		if (name == "go_greek") { OnGoGreek(); return true; }
		if (name == "npc_death") { OnNpcDeath(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "npc_struck") { OnNpcStruck(Float(Param(params, 0))); return true; }
		return BaseMonsterScript::DispatchEvent(name, params);
	}
}
