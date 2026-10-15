#pragma context server

// Converted from monsters/zombie_huge.script by msc_transpiler.
// This is an older script and may have some bad conventions as a result.
// Zombie Boss from Decayed Zombie

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_monster_new.as"

[script "monsters/zombie_huge"]
class ZombieHuge : BaseMonsterNewScript
{
	// Constants
	string ANIM_SWIPE = "attack1";
	string ANIM_DISEASE = "attack2";
	string SOUND_IDLE1 = "garg/gar_breathe1.wav";
	string SOUND_IDLE2 = "garg/gar_breathe2.wav";
	string SOUND_IDLE3 = "garg/gar_breathe3.wav";
	string SOUND_IDLE4 = "garg/gar_idle4.wav";
	string SOUND_PAIN1 = "garg/gar_idle1.wav";
	string SOUND_PAIN2 = "garg/gar_idle2.wav";
	string SOUND_PAIN3 = "garg/gar_idle3.wav";
	string SOUND_STRUCK1 = "weapons/cbar_hitbod1.wav";
	string SOUND_STRUCK2 = "weapons/cbar_hitbod2.wav";
	string SOUND_STRUCK3 = "weapons/cbar_hitbod3.wav";
	string SOUND_WARCRY1 = "garg/gar_alert1.wav";
	string SOUND_WARCRY2 = "garg/gar_alert2.wav";
	string SOUND_WARCRY3 = "garg/gar_alert3.wav";
	string SOUND_RAGE1 = "garg/gar_attack1.wav";
	string SOUND_RAGE2 = "garg/gar_attack2.wav";
	string SOUND_MISS1 = "zombie/claw_miss1.wav";
	string SOUND_MISS2 = "zombie/claw_miss2.wav";
	string SOUND_HIT1 = "zombie/claw_strike1.wav";
	string SOUND_HIT2 = "zombie/claw_strike2.wav";
	string ATTACK_DAMAGE = "ATTACK_DAMAGE";
	string ATTACK_HITCHANCE = "80";
	float DISEASE_FREQ = 5.0f;
	float DISEASE_DMG = 0.0f;
	int DISEASE_DUR = 0;
	string MONSTER_MODEL = "monsters/zombie_huge.mdl";
	bool ME_NO_WANDER = true;

	// Variables (an unset .script variable reads as its own name)
	string ANIM_ATTACK = "ANIM_ATTACK";
	string ANIM_DEATH1 = "ANIM_DEATH1";
	string ANIM_DEATH2 = "ANIM_DEATH2";
	string ANIM_DEATH3 = "ANIM_DEATH3";
	string ANIM_DEATH4 = "ANIM_DEATH4";
	string ANIM_DEATH5 = "ANIM_DEATH5";
	string FLINCH_CHANCE = "FLINCH_CHANCE";
	bool DISEASE_DELAY = false;
	bool DID_WARCRY = false;
	bool I_ATTACKING = false;
	bool I_DISEASE = false;
	bool PAIN_DELAY = false;

	// Variables declared by included files, with the value they start with in this script
	ZombieHuge()
	{
		ANIM_WALK = "walk";
		ANIM_RUN = "walk";
		ANIM_IDLE = "idle1";
		SOUND_DEATH = "garg/gar_die1.wav";
	}

	// unnamed block (first think)
	void ZombieHuge_FirstThink()
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
		ANIM_DEATH = ANIM_DEATH1;

		CAN_FLINCH = "1";
		FLINCH_CHANCE = "10";
		ATTACK_RANGE = 120.0f;
		ATTACK_HITRANGE = 150.0f;
		ATTACK_MOVERANGE = 80.0f;

		NPC_GIVE_EXP = 150.0f;

		HEAR_RANGE_MAX = "200";
		HEAR_RANGE_PLAYER = "200";
	}

	// game_dodamage
	// 1:AttackHit(1/0)  2:EntityHit  3:StartOrigin  4:EndOrigin
	string ZombieHuge_OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
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

	// game_precache
	void OnGamePrecache()
	{
		PrecacheFile("chests/islesofdread1");
	}

	// game_struck
	void OnGameStruck(float damage = 0.0f, string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		BaseNpc_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseNpcAttackNew_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc_attack_new
		BaseMonsterShared_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared
		PlayRandomSound(0, 10, SOUND_STRUCK1, SOUND_STRUCK2, SOUND_STRUCK3);
		if (!PAIN_DELAY)
			CallEventDelayed(0.1f, "pain_sound");
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseNpcAttackNew_OnNpcSpawn(npc); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck

		SetName("Giant Zombie");
		SetModel(MONSTER_MODEL);
		int maxHp = RandomInt(2000, 4000); // random hp
		SetHealth(maxHp);
		SetWidth(50);
		if (ToLowerCase(MapName()) != "challs")
			SetHeight(110);
		else
			SetHeight(72);
		SetIdleAnim(ANIM_IDLE);
		SetMoveAnim(ANIM_WALK);
		PlayAnim("once", ANIM_IDLE); // stop the shakes
		SetRace("undead");
		SetHearingSensitivity(3);

		if (!ME_NO_WANDER)
			SetRoam(true);
		if (ME_NO_WANDER)
			SetRoam(false);

		SetGold(RandomInt(40, 100));

		if (MapName() == "challs")
		{
			SetName("Iuluz the Giant");
			if (RandomInt(1, 5) == 1)
				GiveItem("mana_vampire");
		}

		SetDamageTaken("holy", 1);
		SetDamageTaken("poison", 0);
		SetDamageTaken("fire", 2);
		SetDamageTaken("cold", 0.25f);
		SetDamageTaken("pierce", 0.5f);
		SetDamageTaken("blunt", 1);
		SetDamageTaken("slash", 1.25f);

		CallEventDelayed(1.0f, "idle_sounds");

		CatchSpeech("debug_props", "debug");
	}

	// npcatk_targetvalidate
	void OnNpcatkTargetvalidate(string target = "")
	{
		BaseNpcAttackNew_OnNpcatkTargetvalidate(target); // monsters/base_npc_attack_new

		if (DID_WARCRY)
			return;
		DID_WARCRY = true;
		DISEASE_DELAY = true;
		CallEventDelayed(DISEASE_FREQ, "reset_disease_delay");
		PlayRandomSound(0, 10, SOUND_WARCRY1, SOUND_WARCRY2, SOUND_WARCRY3);
	}

	// game_dodamage
	string OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";
		result = AppendResult(result, BaseNpcAttackNew_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BaseAntiStuck_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BaseMonsterShared_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, ZombieHuge_OnGameDodamage(hit, target, start, end, damageType, damageText));
		return result;
	}

	// cycle_up
	void OnCycleUp(string reason = "")
	{
		BaseNpcAttackNew_OnCycleUp(reason); // monsters/base_npc_attack_new
		if (ME_NO_WANDER)
			SetRoam(true);
	}

	// cycle_down
	void OnCycleDown()
	{
		BaseNpcAttackNew_OnCycleDown(); // monsters/base_npc_attack_new
		BaseMonsterShared_OnCycleDown(); // monsters/base_monster_shared
		BaseMonsterShared_OnCycleDown_2(); // monsters/base_monster_shared
		DID_WARCRY = false;
	}

	// npc_selectattack
	void OnNpcSelectattack()
	{
		BaseAntiStuck_OnNpcSelectattack(); // monsters/base_anti_stuck
		BaseMonsterShared_OnNpcSelectattack(); // monsters/base_monster_shared

		// //dbg temp selecting attack ( del DISEASE_DELAY vs DISEASE_FREQ )
		if (DISEASE_DELAY)
			return;
		DISEASE_DELAY = true;
		CallEventDelayed(DISEASE_FREQ, "reset_disease_delay");
		ANIM_ATTACK = ANIM_DISEASE;
	}

	// debug_props
	void OnDebugProps()
	{
		SayText("My Atkrange " + Text(ATTACK_RANGE) + " vs. " + Text(MIN_ATTACK_RANGE) + " against " + Eval("game.monster.height"));
	}

	// reset_disease_delay
	void OnResetDiseaseDelay()
	{
		DISEASE_DELAY = false;
	}

	// attack_1
	void OnAttack12()
	{
		// //dbg temp using swipe ANIM_ATTACK
		I_ATTACKING = true;
		OnNpcatkDodamage(NPCATK_TARGET, Text(ATTACK_HITRANGE), ATTACK_DAMAGE, ATTACK_HITCHANCE, "blunt");
	}

	// attack_2
	void OnAttack22()
	{
		// //dbg temp using disease ANIM_ATTACK
		I_ATTACKING = true;
		OnNpcatkDodamage(NPCATK_TARGET, Text(ATTACK_HITRANGE), ATTACK_DAMAGE, ATTACK_HITCHANCE, "blunt");
		I_DISEASE = true;
		ANIM_ATTACK = ANIM_SWIPE;
	}

	// idle_sounds
	void OnIdleSounds()
	{
		if (NPCATK_TARGET == "unset")
			PlayRandomSound(0, 10, SOUND_IDLE1, SOUND_IDLE2, SOUND_IDLE3, SOUND_IDLE4);

		if (NPCATK_TARGET != "unset")
			PlayRandomSound(0, 5, SOUND_RAGE1, SOUND_RAGE2);

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
	void OnWalkStep1()
	{
		PlaySound(0, 10, "garg/gar_step1.wav");
	}

	// walk_step2
	void OnWalkStep2()
	{
		PlaySound(0, 10, "garg/gar_step2.wav");
	}

	// walk_step3
	void OnWalkStep3()
	{
		PlaySound(0, 10, "garg/gar_step1.wav");
	}

	// walk_step4
	void OnWalkStep4()
	{
		PlaySound(0, 10, "garg/gar_step2.wav");
	}

	// walk_step5
	void OnWalkStep5()
	{
		PlaySound(0, 10, "garg/gar_step1.wav");
	}

	// walk_step6
	void OnWalkStep6()
	{
		PlaySound(0, 10, "garg/gar_step2.wav");
	}

	// npc_death
	void OnNpcDeath()
	{
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

		if (Contains(ToLowerCase(MapName()), "islesofdread1"))
			CreateNpc("chests/islesofdread1", RelativePosition(Vector3(0, 0, 0)));
	}

	// pain_sound
	void OnPainSound()
	{
		string randf510;

		PAIN_DELAY = true;
		randf510 = "NEXT_PAIN";
		PlayRandomSound(0, 10, SOUND_PAIN1, SOUND_PAIN2, SOUND_PAIN3);
		OnNextPain();
	}

	// pain_delay_reset
	void OnPainDelayReset()
	{
		PAIN_DELAY = false;
	}

	// npc_flinch
	void OnNpcFlinch(float damage = 0.0f)
	{
		int rFlinch = RandomInt(1, 4);
		if (rFlinch == 1)
			FLINCH_ANIM = "flinchsmall";
		if (rFlinch == 2)
			FLINCH_ANIM = "flinch";
		if (rFlinch == 3)
			FLINCH_ANIM = "bigflinch";
		if (rFlinch == 4)
			FLINCH_ANIM = "llflinch";
		PlayRandomSound(0, 10, SOUND_PAIN1, SOUND_PAIN2, SOUND_PAIN3);
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files
	void OnDiseaseFreq() {} // DISEASE_FREQ
	void OnNextPain() {} // NEXT_PAIN
	void OnNextSound() {} // NEXT_SOUND

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/zombie_huge.mdl");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		ZombieHuge_FirstThink();
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
		if (name == "attack_2") { OnAttack22(); return true; }
		if (name == "cycle_down") { OnCycleDown(); return true; }
		if (name == "cycle_up") { OnCycleUp(Param(params, 0)); return true; }
		if (name == "debug_props") { OnDebugProps(); return true; }
		if (name == "game_dodamage") { Return(OnGameDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5))); return true; }
		if (name == "game_precache") { OnGamePrecache(); return true; }
		if (name == "game_struck") { OnGameStruck(Float(Param(params, 0)), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "idle_sounds") { OnIdleSounds(); return true; }
		if (name == "npc_death") { OnNpcDeath(); return true; }
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
		return BaseMonsterNewScript::DispatchEvent(name, params);
	}
}
