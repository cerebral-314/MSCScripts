#pragma context server

// Converted from monsters/companion/pet_rat.script by msc_transpiler.
// Pet Rat

#include "runtime/ScriptEntity.as"
#include "converted/monsters/summon/base_summon.as"
#include "converted/monsters/companion/base_companion.as"

[script "monsters/companion/pet_rat"]
class PetRat : BaseSummonScript, BaseCompanion
{
	// Constants
	string ATK_MIN = "2";
	int ATK_MAX = 4;
	string ATTACK_HITCHANCE = "90%";
	string SOUND_STRUCK3 = "weapons/cbar_hitbod3.wav";
	string SOUND_PAIN = "monsters/rat/squeak1.wav";
	string SOUND_ATTACK1 = "monsters/rat/squeak2.wav";
	string SOUND_IDLE1 = "monsters/rat/squeak2.wav";

	// Variables (an unset .script variable reads as its own name)
	string CAN_HUNT = "CAN_HUNT";

	// Variables declared by included files, with the value they start with in this script
	PetRat()
	{
		ANIM_IDLE = "idle";
		ANIM_WALK = "walk";
		ANIM_RUN = "run";
		SOUND_STRUCK1 = "weapons/cbar_hitbod1.wav";
		SOUND_STRUCK2 = "weapons/cbar_hitbod2.wav";
		SOUND_DEATH = "monsters/rat/squeak3.wav";
	}

	// unnamed block (first think)
	void PetRat_FirstThink()
	{
		ANIM_IDLE = "idle";
		ANIM_WALK = "walk";
		ANIM_RUN = "run";
		ANIM_ATTACK = "attack";
		MOVE_RANGE = "48";
		ATTACK_RANGE = 64.0f;
		ATTACK_HITRANGE = 100.0f;

		RETALIATE_CHANCE = "75%"; // base_npc_attack - Automatically switch targets to the last damaging player
		CAN_FLEE = "0"; // base_npc_attack - Whether I run away at low health
		CAN_HUNT = "1";
		CAN_HEAR = "0";
		CAN_FLINCH = "0";
	}

	// summon_spawn
	void OnSummonSpawn()
	{
		SetName("Pet Rat");
		SetHealth(10);
		// ov 360
		SetWidth(32);
		SetHeight(20);
		SetRoam(true);
		SetHearingSensitivity(3);
		SetSkillLevel(5);
		SetRace("human");
		SetModel("monsters/rat.mdl");
		SetModelBody(1, 0);
		SetIdleAnim(ANIM_IDLE);
		SetMoveAnim(ANIM_WALK);

		OnBasesummonAttackall(); // Premptive attack

		CatchSpeech("rat_standup", "stand", "shake");
		CatchSpeech("regme", "reg");
		CatchSpeech("unregme", "unreg");
	}

	// regme
	void OnRegme()
	{
		LegacyCommand("companion", "add", ENT_ME, ENT_LASTSPOKE);
		SUMMON_MASTER = EntityId(EntityOf(ENT_LASTSPOKE));
		OnBasesummonFollowMaster();
	}

	// unregme
	void OnUnregme()
	{
		if (EntityId(EntityOf(ENT_LASTSPOKE)) == SUMMON_MASTER)
		{
			LegacyCommand("companion", "remove", ENT_ME, ENT_LASTSPOKE);
			SUMMON_MASTER = "-!-";
			OnBasesummonSayAttackall();
		}
	}

	// bite1
	// Deal damage
	void OnBite1()
	{
		SetVolume(5);
		PlayRandomSound(2, 5, SOUND_ATTACK1, "none");

		DoDamage(ENT_LASTSEEN, ATTACK_HITRANGE, Random(Float(ATK_MIN), ATK_MAX), ATTACK_HITCHANCE);
	}

	// npc_struck
	// Hit by someone
	void OnNpcStruck(float damage = 0.0f)
	{
		SetVolume(5);
		PlayRandomSound(2, 5, SOUND_PAIN, SOUND_PAIN, SOUND_STRUCK1, SOUND_STRUCK2, SOUND_STRUCK3);
	}

	// rat_standup
	// Do a trick
	void OnRatStandup()
	{
		if (!(RandomInt(1, 10) > 2))
			return;

		SetAngle("face", ENT_LASTSPOKE);
		PlayAnim("once", "idle2");
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files

	// game_damaged_other
	string OnGameDamagedOther(CBaseEntity@ target = null, float damage = 0.0f, string damageType = "", string damageEvent = "")
	{
		string result = "";
		result = AppendResult(result, MonstersExternals_OnGameDamagedOther(target, damage, damageType, damageEvent));
		result = AppendResult(result, BaseAntiStuck_OnGameDamagedOther(target, damage, damageType, damageEvent));
		result = AppendResult(result, BaseMonsterShared_OnGameDamagedOther(target, damage, damageType, damageEvent));
		result = AppendResult(result, BaseCompanion_OnGameDamagedOther(target, damage, damageType, damageEvent));
		return result;
	}

	// game_dynamically_created
	void OnGameDynamicallyCreated(string creatorValue1 = "", string creatorValue2 = "", string damage = "", string skill = "", string extraValue5 = "", string extraValue6 = "", float alwaysPush = 0.0f, string duration = "", string extraValue9 = "")
	{
		BaseSelfAdjust_OnGameDynamicallyCreated(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/base_self_adjust
		BaseSelfAdjust_OnGameDynamicallyCreated_2(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/base_self_adjust
		BaseAntiStuck_OnGameDynamicallyCreated(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/base_anti_stuck
		BaseAntiStuck_OnGameDynamicallyCreated_2(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/base_anti_stuck
		BaseSummon_OnGameDynamicallyCreated(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/summon/base_summon
		BaseCompanion_OnGameDynamicallyCreated(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/companion/base_companion
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseNpc_OnGameSpawn(playerRace, playerGender); // monsters/base_npc
		BaseMonsterShared_OnGameSpawn(playerRace, playerGender); // monsters/base_monster_shared
		BaseCompanion_OnGameSpawn(playerRace, playerGender); // monsters/companion/base_companion
	}

	// npcatk_hunt
	void OnNpcatkHunt()
	{
		BaseNpcAttackNew_OnNpcatkHunt(); // monsters/base_npc_attack_new
		BaseAntiStuck_OnNpcatkHunt(); // monsters/base_anti_stuck
		BaseSummon_OnNpcatkHunt(); // monsters/summon/base_summon
		BaseCompanion_OnNpcatkHunt(); // monsters/companion/base_companion
	}

	// my_target_died
	void OnMyTargetDied(string offender = "")
	{
		BaseNpcAttackNew_OnMyTargetDied(offender); // monsters/base_npc_attack_new
		BaseSummon_OnMyTargetDied(offender); // monsters/summon/base_summon
		BaseCompanion_OnMyTargetDied(offender); // monsters/companion/base_companion
	}

	// game_dodamage
	string OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";
		result = AppendResult(result, BaseNpcAttackNew_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BaseAntiStuck_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BaseMonsterShared_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BaseCompanion_OnGameDodamage(hit, target, start, end, damageType, damageText));
		return result;
	}

	// game_damaged - Return a damage multiplier to scale the damage
	string OnGameDamaged(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float accuracyRoll = 0.0f, CBaseEntity@ inflictor = null, string skill = "")
	{
		string result = "";
		result = AppendResult(result, BaseAntiStuck_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, BaseMonsterShared_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, BaseMonsterShared_OnGameDamaged_2(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, BaseCompanion_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		return result;
	}

	// npc_death
	void OnNpcDeath()
	{
		BaseSummon_OnNpcDeath(); // monsters/summon/base_summon
		BaseCompanion_OnNpcDeath(); // monsters/companion/base_companion
	}

	// bs_set_follow_mode
	void OnBsSetFollowMode()
	{
		BaseSummon_OnBsSetFollowMode(); // monsters/summon/base_summon
		BaseCompanion_OnBsSetFollowMode(); // monsters/companion/base_companion
	}

	void OnBsSetDefendMode() { BaseSummon_OnBsSetDefendMode(); } // bs_set_defend_mode
	void OnBasesummonAttackall() {} // basesummon_attackall
	void OnBasesummonFollowMaster() {} // basesummon_follow_master

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("xflare1.spr");
		Precache("monsters/rat.mdl");
		CallEventDelayed(5.0f, "BaseCompanion_Timer");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		PetRat_FirstThink();
		BaseSummon_FirstThink();
		BaseNpc_FirstThink();
		MonstersExternals_FirstThink();
		BaseNpcAttackNew_FirstThink();
		BaseMonsterShared_FirstThink();
		BaseCompanion_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "bite1") { OnBite1(); return true; }
		if (name == "npc_struck") { OnNpcStruck(Float(Param(params, 0))); return true; }
		if (name == "rat_standup") { OnRatStandup(); return true; }
		if (name == "regme") { OnRegme(); return true; }
		if (name == "summon_spawn") { OnSummonSpawn(); return true; }
		if (name == "unregme") { OnUnregme(); return true; }
		return BaseCompanion_DispatchEvent(name, params)
			|| BaseSummonScript::DispatchEvent(name, params);
	}
}
