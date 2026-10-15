#pragma context server

// Converted from monsters/zombie.script by msc_transpiler.
// This is an older script and may have some bad conventions as a result.
// Zombie from Decayed Zombie

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_monster_new.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class MonstersZombie
{
	// Constants
	string ZOMBIE_NAME = "Zombie";
	string ANIM_SWIPE = "attack1";
	string ANIM_DISEASE = "attack2";
	string SOUND_IDLE1 = "monsters/zombie1/zo_idle1.wav";
	string SOUND_IDLE2 = "monsters/zombie1/zo_idle2.wav";
	string SOUND_IDLE3 = "monsters/zombie1/zo_idle3.wav";
	string SOUND_IDLE4 = "monsters/zombie1/zo_idle4.wav";
	string SOUND_PAIN1 = "monsters/zombie1/zo_pain1.wav";
	string SOUND_PAIN2 = "monsters/zombie1/zo_pain2.wav";
	string SOUND_PAIN3 = "monsters/zombie1/zo_pain3.wav";
	string SOUND_STRUCK1 = "weapons/cbar_hitbod1.wav";
	string SOUND_STRUCK2 = "weapons/cbar_hitbod2.wav";
	string SOUND_STRUCK3 = "weapons/cbar_hitbod3.wav";
	string SOUND_WARCRY1 = "monsters/zombie1/zo_alert10.wav";
	string SOUND_WARCRY2 = "monsters/zombie1/zo_alert20.wav";
	string SOUND_WARCRY3 = "monsters/zombie1/zo_alert30.wav";
	string SOUND_RAGE1 = "monsters/zombie1/zo_attack1.wav";
	string SOUND_RAGE2 = "monsters/zombie1/zo_attack2.wav";
	string SOUND_DEATH = "monsters/zombie1/hitground.wav";
	string SOUND_MISS1 = "zombie/claw_miss1.wav";
	string SOUND_MISS2 = "zombie/claw_miss2.wav";
	string SOUND_HIT1 = "zombie/claw_strike1.wav";
	string SOUND_HIT2 = "zombie/claw_strike2.wav";
	string ATTACK_DAMAGE = "ATTACK_DAMAGE";
	string ATTACK_HITCHANCE = "70";
	float DISEASE_FREQ = 10.0f;
	float DISEASE_DMG = 0.0f;
	int DISEASE_DUR = 0;
	string MONSTER_MODEL = "monsters/zombie_medium.mdl";

	// Variables (an unset .script variable reads as its own name)
	string ANIM_WALK = "walk";
	string ANIM_RUN = "walk";
	string ANIM_IDLE = "idle1";
	string ANIM_ATTACK = "ANIM_ATTACK";
	string ANIM_DEATH = "ANIM_DEATH";
	string ANIM_DEATH1 = "ANIM_DEATH1";
	string ANIM_DEATH2 = "ANIM_DEATH2";
	string ANIM_DEATH3 = "ANIM_DEATH3";
	string ANIM_DEATH4 = "ANIM_DEATH4";
	string ANIM_DEATH5 = "ANIM_DEATH5";
	string ANIM_FLINCH = "ANIM_FLINCH";
	string CAN_FLINCH = "CAN_FLINCH";
	string FLINCH_CHANCE = "FLINCH_CHANCE";
	float ATTACK_RANGE = 0.0f;
	float ATTACK_HITRANGE = 0.0f;
	float ATTACK_MOVERANGE = 0.0f;
	float NPC_GIVE_EXP = 0.0f;
	bool DISEASE_DELAY = false;
	bool DID_WARCRY = false;
	bool I_ATTACKING = false;
	bool I_DISEASE = false;
	bool PAIN_DELAY = false;

	// unnamed block (first think)
	void MonstersZombie_FirstThink()
	{
		ANIM_WALK = "walk";
		ANIM_RUN = "walk";
		ANIM_ATTACK = ANIM_SWIPE;
		ANIM_DEATH = "diesimple";
		ANIM_IDLE = "idle1";
		ANIM_DEATH1 = "diesimple";
		ANIM_DEATH2 = "diebackward";
		ANIM_DEATH3 = "dieheadshot";
		ANIM_DEATH4 = "dieheadshot2";
		ANIM_DEATH5 = "dieforward";
		ANIM_DEATH = "diesimple";

		ANIM_FLINCH = "llflinch";
		CAN_FLINCH = "1";
		FLINCH_CHANCE = "30";
		ATTACK_RANGE = 100.0f;
		ATTACK_HITRANGE = 130.0f;
		ATTACK_MOVERANGE = 50.0f;

		NPC_GIVE_EXP = 60.0f;
	}

	// npc_spawn
	void MonstersZombie_OnNpcSpawn(string npc = "")
	{
		SetName(ZOMBIE_NAME);
		SetModel(MONSTER_MODEL);
		int maxHp = RandomInt(100, 400); // random hp
		SetHealth(maxHp);
		SetWidth(25);
		SetHeight(80);
		SetIdleAnim(ANIM_IDLE);
		SetMoveAnim(ANIM_WALK);
		SetRace("undead");
		SetHearingSensitivity(7);

		SetRoam(true);

		SetGold(RandomInt(5, 15));

		SetDamageTaken("holy", 2);
		SetDamageTaken("poison", 0);
		SetDamageTaken("fire", 2);
		SetDamageTaken("cold", 0.25f);
		SetDamageTaken("pierce", 0.5f);
		SetDamageTaken("blunt", 1);
		SetDamageTaken("slash", 1.25f);

		CallEventDelayed(1.0f, "idle_sounds");

		// intesting: npc_death doesn't get called when struck by divniation, so set death here
		int pickDeath = RandomInt(1, 5);
		if (pickDeath == 1)
			ANIM_DEATH = ANIM_DEATH1;
		if (pickDeath == 2)
			ANIM_DEATH = ANIM_DEATH2;
		if (pickDeath == 3)
			ANIM_DEATH = ANIM_DEATH3;
		if (pickDeath == 4)
			ANIM_DEATH = ANIM_DEATH4;
		if (pickDeath == 5)
			ANIM_DEATH = ANIM_DEATH5;

		CatchSpeech("debug_props", "debug");
	}

	// debug_props
	void MonstersZombie_OnDebugProps()
	{
		SayText("My Atkrange " + Text(ATTACK_RANGE) + " vs. " + Text(MIN_ATTACK_RANGE) + " against " + Eval("game.monster.height"));
	}

	// npc_selectattack
	void MonstersZombie_OnNpcSelectattack()
	{
		// //dbg temp selecting attack ( del DISEASE_DELAY vs DISEASE_FREQ )
		if (DISEASE_DELAY)
			return;
		DISEASE_DELAY = true;
		CallEventDelayed(DISEASE_FREQ, "reset_disease_delay");
		ANIM_ATTACK = ANIM_DISEASE;
	}

	// reset_disease_delay
	void MonstersZombie_OnResetDiseaseDelay()
	{
		DISEASE_DELAY = false;
	}

	// npcatk_targetvalidate
	void MonstersZombie_OnNpcatkTargetvalidate(string target = "")
	{
		if (DID_WARCRY)
			return;
		DID_WARCRY = true;
		DISEASE_DELAY = true;
		CallEventDelayed(DISEASE_FREQ, "reset_disease_delay");
		PlayRandomSound(2, 10, SOUND_WARCRY1, SOUND_WARCRY2, SOUND_WARCRY3);
	}

	// attack_1
	void MonstersZombie_OnAttack12()
	{
		// //dbg temp using swipe ANIM_ATTACK
		I_ATTACKING = true;
		OnNpcatkDodamage(NPCATK_TARGET, Text(ATTACK_HITRANGE), ATTACK_DAMAGE, ATTACK_HITCHANCE, "blunt");
	}

	// attack_2
	void MonstersZombie_OnAttack22()
	{
		// //dbg temp using disease ANIM_ATTACK
		I_ATTACKING = true;
		OnNpcatkDodamage(NPCATK_TARGET, Text(ATTACK_HITRANGE), ATTACK_DAMAGE, ATTACK_HITCHANCE, "blunt");
		I_DISEASE = true;
		ANIM_ATTACK = ANIM_SWIPE;
	}

	// game_dodamage
	// 1:AttackHit(1/0)  2:EntityHit  3:StartOrigin  4:EndOrigin
	string MonstersZombie_OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";

		if (!I_ATTACKING)
			return result;
		I_ATTACKING = false;
		if (hit)
			PlayRandomSound(0, 10, SOUND_HIT1, SOUND_HIT2);
		if (!hit)
			PlayRandomSound(0, 10, SOUND_MISS1, SOUND_MISS2);

		if (!I_DISEASE)
			return result;
		I_DISEASE = false;
		if (!hit)
			return result;
		ApplyEffect(target, "effects/dot_poison", DISEASE_DUR, self, DISEASE_DMG, "none");
		return result;
	}

	// idle_sounds
	void MonstersZombie_OnIdleSounds()
	{
		if (NPCATK_TARGET == "unset")
			PlayRandomSound(2, 10, SOUND_IDLE1, SOUND_IDLE2, SOUND_IDLE3, SOUND_IDLE4);

		if (NPCATK_TARGET != "unset")
			PlayRandomSound(2, 5, SOUND_RAGE1, SOUND_RAGE2);

		float nextSound = Random(4, 15);

		CallEventDelayed(nextSound, "idle_sounds");
	}

	// walk_step1
	// Zombie walkstep pattern
	// { event 600 2 "common/npc_step1.wav" }
	// { event 600 12 "common/npc_step3.wav" }
	// { event 600 22 "common/npc_step2.wav" }
	// { event 600 31 "common/npc_step4.wav" }
	// { event 600 41 "common/npc_step1.wav" }
	// { event 600 51 "common/npc_step3.wav" }
	void MonstersZombie_OnWalkStep1()
	{
		PlaySound(0, 10, "common/npc_step1.wav");
	}

	// walk_step2
	void MonstersZombie_OnWalkStep2()
	{
		PlaySound(0, 10, "common/npc_step3.wav");
	}

	// walk_step3
	void MonstersZombie_OnWalkStep3()
	{
		PlaySound(0, 10, "common/npc_step2.wav");
	}

	// walk_step4
	void MonstersZombie_OnWalkStep4()
	{
		PlaySound(0, 10, "common/npc_step4.wav");
	}

	// walk_step5
	void MonstersZombie_OnWalkStep5()
	{
		PlaySound(0, 10, "common/npc_step1.wav");
	}

	// walk_step6
	void MonstersZombie_OnWalkStep6()
	{
		PlaySound(0, 10, "common/npc_step3.wav");
	}

	// cycle_up
	void MonstersZombie_OnCycleUp(string reason = "")
	{
	}

	// cycle_down
	void MonstersZombie_OnCycleDown()
	{
		DID_WARCRY = false;
	}

	// game_struck
	void MonstersZombie_OnGameStruck(float damage = 0.0f, string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		PlayRandomSound(2, 10, SOUND_STRUCK1, SOUND_STRUCK2, SOUND_STRUCK3);
		if (!PAIN_DELAY)
			CallEventDelayed(0.1f, "pain_sound");
	}

	// pain_sound
	void MonstersZombie_OnPainSound()
	{
		string randf510;

		PAIN_DELAY = true;
		randf510 = "NEXT_PAIN";
		PlayRandomSound(2, 10, SOUND_PAIN1, SOUND_PAIN2, SOUND_PAIN3);
		OnNextPain();
	}

	// pain_delay_reset
	void MonstersZombie_OnPainDelayReset()
	{
		PAIN_DELAY = false;
	}

	// npc_flinch
	void MonstersZombie_OnNpcFlinch(float damage = 0.0f)
	{
		PlayRandomSound(2, 10, SOUND_PAIN1, SOUND_PAIN2, SOUND_PAIN3);
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)

	// game_struck
	void OnGameStruck(float damage = 0.0f, string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		BaseNpc_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseNpcAttackNew_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc_attack_new
		BaseMonsterShared_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared
		MonstersZombie_OnGameStruck(damage, extraValue2, extraValue3, extraValue4);
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseNpcAttackNew_OnNpcSpawn(npc); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck
		MonstersZombie_OnNpcSpawn(npc);
	}

	// npcatk_targetvalidate
	void OnNpcatkTargetvalidate(string target = "")
	{
		BaseNpcAttackNew_OnNpcatkTargetvalidate(target); // monsters/base_npc_attack_new
		MonstersZombie_OnNpcatkTargetvalidate(target);
	}

	// game_dodamage
	string OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";
		result = AppendResult(result, BaseNpcAttackNew_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BaseAntiStuck_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BaseMonsterShared_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, MonstersZombie_OnGameDodamage(hit, target, start, end, damageType, damageText));
		return result;
	}

	// cycle_up
	void OnCycleUp(string reason = "")
	{
		BaseNpcAttackNew_OnCycleUp(reason); // monsters/base_npc_attack_new
		MonstersZombie_OnCycleUp(reason);
	}

	// cycle_down
	void OnCycleDown()
	{
		BaseNpcAttackNew_OnCycleDown(); // monsters/base_npc_attack_new
		BaseMonsterShared_OnCycleDown(); // monsters/base_monster_shared
		BaseMonsterShared_OnCycleDown_2(); // monsters/base_monster_shared
		MonstersZombie_OnCycleDown();
	}

	// npc_selectattack
	void OnNpcSelectattack()
	{
		BaseAntiStuck_OnNpcSelectattack(); // monsters/base_anti_stuck
		BaseMonsterShared_OnNpcSelectattack(); // monsters/base_monster_shared
		MonstersZombie_OnNpcSelectattack();
	}

	void OnDebugProps() { MonstersZombie_OnDebugProps(); } // debug_props
	void OnResetDiseaseDelay() { MonstersZombie_OnResetDiseaseDelay(); } // reset_disease_delay
	void OnAttack12() { MonstersZombie_OnAttack12(); } // attack_1
	void OnAttack22() { MonstersZombie_OnAttack22(); } // attack_2
	void OnIdleSounds() { MonstersZombie_OnIdleSounds(); } // idle_sounds
	void OnWalkStep1() { MonstersZombie_OnWalkStep1(); } // walk_step1
	void OnWalkStep2() { MonstersZombie_OnWalkStep2(); } // walk_step2
	void OnWalkStep3() { MonstersZombie_OnWalkStep3(); } // walk_step3
	void OnWalkStep4() { MonstersZombie_OnWalkStep4(); } // walk_step4
	void OnWalkStep5() { MonstersZombie_OnWalkStep5(); } // walk_step5
	void OnWalkStep6() { MonstersZombie_OnWalkStep6(); } // walk_step6
	void OnPainSound() { MonstersZombie_OnPainSound(); } // pain_sound
	void OnPainDelayReset() { MonstersZombie_OnPainDelayReset(); } // pain_delay_reset
	void OnNpcFlinch(float damage = 0.0f) { MonstersZombie_OnNpcFlinch(damage); } // npc_flinch
	void OnDiseaseFreq() {} // DISEASE_FREQ
	void OnNextPain() {} // NEXT_PAIN
	void OnNextSound() {} // NEXT_SOUND

	// This file's events and timers by their .script names
	bool MonstersZombie_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "attack_1") { OnAttack12(); return true; }
		if (name == "attack_2") { OnAttack22(); return true; }
		if (name == "cycle_down") { OnCycleDown(); return true; }
		if (name == "cycle_up") { OnCycleUp(Param(params, 0)); return true; }
		if (name == "debug_props") { OnDebugProps(); return true; }
		if (name == "game_dodamage") { Return(OnGameDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5))); return true; }
		if (name == "game_struck") { OnGameStruck(Float(Param(params, 0)), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "idle_sounds") { OnIdleSounds(); return true; }
		if (name == "npc_flinch") { OnNpcFlinch(Float(Param(params, 0))); return true; }
		if (name == "npc_selectattack") { OnNpcSelectattack(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "npcatk_targetvalidate") { OnNpcatkTargetvalidate(Param(params, 0)); return true; }
		if (name == "pain_delay_reset") { OnPainDelayReset(); return true; }
		if (name == "pain_sound") { OnPainSound(); return true; }
		if (name == "reset_disease_delay") { OnResetDiseaseDelay(); return true; }
		if (name == "walk_step1") { OnWalkStep1(); return true; }
		if (name == "walk_step2") { OnWalkStep2(); return true; }
		if (name == "walk_step3") { OnWalkStep3(); return true; }
		if (name == "walk_step4") { OnWalkStep4(); return true; }
		if (name == "walk_step5") { OnWalkStep5(); return true; }
		if (name == "walk_step6") { OnWalkStep6(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "monsters/zombie"]
shared class MonstersZombieScript : BaseMonsterNewScript, MonstersZombie
{
	// Variables declared by included files, with the value they start with in this script
	MonstersZombieScript()
	{
		ANIM_WALK = "walk";
		ANIM_RUN = "walk";
		ANIM_IDLE = "idle1";
		SOUND_DEATH = "monsters/zombie1/hitground.wav";
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/zombie_medium.mdl");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		MonstersZombie_FirstThink();
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
		return MonstersZombie_DispatchEvent(name, params)
			|| BaseMonsterNewScript::DispatchEvent(name, params);
	}
}
