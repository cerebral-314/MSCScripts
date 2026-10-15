#pragma context server

// Converted from NPCs/human_guard_sword.script by msc_transpiler.
// Thothie - tired of dealing with the weirdness from these old guard scripts
// making some new guard scripts from scratch - will include/adjust ext scripts as needed

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_monster_new.as"
#include "converted/monsters/base_guard_friendly_new.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class HumanGuardSword
{
	// Constants
	string SOUND_STRUCK = "body/flesh1.wav";
	string SOUND_WARCRY = "voices/human/male_guard_shout2.wav";
	string SOUND_ATTACK = "weapons/bow/bowslow.wav";
	string SOUND_DEATH = "voices/human/male_die.wav";
	string ATTACK_HITCHANCE = "85%";
	string ATTACK_DAMAGE = "$randf(5.0,8.0)";

	// Variables (an unset .script variable reads as its own name)
	string ANIM_IDLE = "idle1";
	string ANIM_RUN = "run";
	string ANIM_WALK = "walk";
	string ANIM_DEATH = "ANIM_DEATH";
	string ANIM_ATTACK = "ANIM_ATTACK";
	string MOVE_RANGE = "MOVE_RANGE";
	float ATTACK_RANGE = 0.0f;
	float ATTACK_HITRANGE = 0.0f;
	string CAN_HUNT = "CAN_HUNT";
	string CAN_ATTACK = "CAN_ATTACK";
	string HUNT_AGRO = "HUNT_AGRO";
	string CAN_RETALIATE = "CAN_RETALIATE";
	float NPC_GIVE_EXP = 0.0f;
	bool NPC_NO_PLAYER_DMG = false;
	float FINAL_HITCHANCE = 0.0f;
	string FINAL_DAMAGE = "FINAL_DAMAGE";

	// unnamed block (first think)
	void HumanGuardSword_FirstThink()
	{
		ANIM_IDLE = "idle1";
		ANIM_RUN = "run";
		ANIM_WALK = "walk";
		ANIM_DEATH = "diebackward";
		ANIM_ATTACK = "swordswing1_l";

		MOVE_RANGE = "65";
		ATTACK_RANGE = 85.0f;
		ATTACK_HITRANGE = 130.0f;

		// setvard CAN_FLINCH 1
		// setvard FLINCH_DELAY 4
		// const FLEE_HEALTH 10
		// const FLEE_CHANCE 15%
		CAN_HUNT = "1";
		CAN_ATTACK = "1";
		HUNT_AGRO = "1";
		CAN_RETALIATE = "1";

		NPC_GIVE_EXP = 0.0f;
	}

	// npc_spawn
	// in helena 	name_unique	Archer
	void HumanGuardSword_OnNpcSpawn(string npc = "")
	{
		if (CUSTOM_GUARD)
			return;

		SetName("Guard");
		SetHealth(170);
		// ov	359
		SetHearingSensitivity(12);
		SetWidth(32);
		SetHeight(85);
		SetRace("hguard");
		SetRoam(false);
		SetModel("npc/guard1.mdl");
		SetDamageTaken("all", 0.9f);
		SetModelBody(2, 2);
		SetStat("parry", 10);
		SetMoveSpeed(0);
		// (always true here) if game.serverside

		if (ToLowerCase(MapName()) != "foutpost")
			return;
		SetRace("human");
		NPC_NO_PLAYER_DMG = true; // foutpost guards maybe forced to work amongst AOE player spells
	}

	// attack_1
	void HumanGuardSword_OnAttack12()
	{
		// Deal damage
		FINAL_HITCHANCE = ATTACK_HITRANGE;
		FINAL_DAMAGE = ATTACK_DAMAGE;
		OnBasenpcAdjAttack();
		DoDamage(ENT_LASTSEEN, ATTACK_HITRANGE, FINAL_DAMAGE, FINAL_HITCHANCE);
	}

	// npc_struck
	void HumanGuardSword_OnNpcStruck(float damage = 0.0f)
	{
		PlaySound(0, 5, SOUND_STRUCK);
	}

	// baseguard_tobattle
	// called from base_guard_friendly
	void HumanGuardSword_OnBaseguardTobattle(CBaseEntity@ enemy = null)
	{
		PlaySound(0, 10, SOUND_WARCRY);
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
		BaseGuardFriendlyNew_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_guard_friendly_new
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseNpcAttackNew_OnNpcSpawn(npc); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck
		BaseGuardFriendlyNew_OnNpcSpawn(npc); // monsters/base_guard_friendly_new
		HumanGuardSword_OnNpcSpawn(npc);
	}

	// npcatk_targetvalidate
	void OnNpcatkTargetvalidate(string target = "")
	{
		BaseNpcAttackNew_OnNpcatkTargetvalidate(target); // monsters/base_npc_attack_new
		BaseGuardFriendlyNew_OnNpcatkTargetvalidate(target); // monsters/base_guard_friendly_new
	}

	// npcatk_clear_targets
	void OnNpcatkClearTargets(string reason = "")
	{
		BaseNpcAttackNew_OnNpcatkClearTargets(reason); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcatkClearTargets(reason); // monsters/base_monster_shared
		BaseMonsterShared_OnNpcatkClearTargets_2(reason); // monsters/base_monster_shared
		BaseGuardFriendlyNew_OnNpcatkClearTargets(reason); // monsters/base_guard_friendly_new
	}

	// baseguard_tobattle
	void OnBaseguardTobattle(CBaseEntity@ enemy = null)
	{
		BaseGuardFriendlyNew_OnBaseguardTobattle(enemy); // monsters/base_guard_friendly_new
		HumanGuardSword_OnBaseguardTobattle(enemy);
	}

	void OnNpcPreFlee() { BaseGuardFriendlyNew_OnNpcPreFlee(); } // npc_pre_flee
	void OnAttack12() { HumanGuardSword_OnAttack12(); } // attack_1
	void OnNpcStruck(float damage = 0.0f) { HumanGuardSword_OnNpcStruck(damage); } // npc_struck
	void OnBasenpcAdjAttack() {} // basenpc_adj_attack

	// This file's events and timers by their .script names
	bool HumanGuardSword_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "attack_1") { OnAttack12(); return true; }
		if (name == "baseguard_tobattle") { OnBaseguardTobattle(EntityParam(params, 0)); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "npc_struck") { OnNpcStruck(Float(Param(params, 0))); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "NPCs/human_guard_sword"]
shared class HumanGuardSwordScript : BaseMonsterNewScript, HumanGuardSword, BaseGuardFriendlyNew
{
	// Variables every script that includes this file declares
	string ANIM_STEP1 = "ANIM_STEP1";
	string ANIM_STEP10 = "ANIM_STEP10";
	string ANIM_STEP2 = "ANIM_STEP2";
	string ANIM_STEP3 = "ANIM_STEP3";
	string ANIM_STEP4 = "ANIM_STEP4";
	string ANIM_STEP5 = "ANIM_STEP5";
	string ANIM_STEP6 = "ANIM_STEP6";
	string ANIM_STEP7 = "ANIM_STEP7";
	string ANIM_STEP8 = "ANIM_STEP8";
	string ANIM_STEP9 = "ANIM_STEP9";
	float BC_END_AUTO_MOUTH_MOVE = 0.0f;
	float BC_TOTAL_MOUTH_TIME = 0.0f;
	bool BUSY_CHATTING = false;
	string BUSY_COMMENT = "BUSY_COMMENT";
	int CANCHAT = 0;
	float CHAT_DELAY = 0.0f;
	string CHAT_DELAY_STEP1 = "CHAT_DELAY_STEP1";
	string CHAT_DELAY_STEP10 = "CHAT_DELAY_STEP10";
	string CHAT_DELAY_STEP2 = "CHAT_DELAY_STEP2";
	string CHAT_DELAY_STEP3 = "CHAT_DELAY_STEP3";
	string CHAT_DELAY_STEP4 = "CHAT_DELAY_STEP4";
	string CHAT_DELAY_STEP5 = "CHAT_DELAY_STEP5";
	string CHAT_DELAY_STEP6 = "CHAT_DELAY_STEP6";
	string CHAT_DELAY_STEP7 = "CHAT_DELAY_STEP7";
	string CHAT_DELAY_STEP8 = "CHAT_DELAY_STEP8";
	string CHAT_DELAY_STEP9 = "CHAT_DELAY_STEP9";
	string CHAT_EVENT_STEP1 = "CHAT_EVENT_STEP1";
	string CHAT_EVENT_STEP10 = "CHAT_EVENT_STEP10";
	string CHAT_EVENT_STEP2 = "CHAT_EVENT_STEP2";
	string CHAT_EVENT_STEP3 = "CHAT_EVENT_STEP3";
	string CHAT_EVENT_STEP4 = "CHAT_EVENT_STEP4";
	string CHAT_EVENT_STEP5 = "CHAT_EVENT_STEP5";
	string CHAT_EVENT_STEP6 = "CHAT_EVENT_STEP6";
	string CHAT_EVENT_STEP7 = "CHAT_EVENT_STEP7";
	string CHAT_EVENT_STEP8 = "CHAT_EVENT_STEP8";
	string CHAT_EVENT_STEP9 = "CHAT_EVENT_STEP9";
	string CHAT_SOUND1 = "CHAT_SOUND1";
	string CHAT_SOUND10 = "CHAT_SOUND10";
	string CHAT_SOUND2 = "CHAT_SOUND2";
	string CHAT_SOUND3 = "CHAT_SOUND3";
	string CHAT_SOUND4 = "CHAT_SOUND4";
	string CHAT_SOUND5 = "CHAT_SOUND5";
	string CHAT_SOUND6 = "CHAT_SOUND6";
	string CHAT_SOUND7 = "CHAT_SOUND7";
	string CHAT_SOUND8 = "CHAT_SOUND8";
	string CHAT_SOUND9 = "CHAT_SOUND9";
	float CHAT_STEP = 0.0f;
	string CHAT_STEP1 = "CHAT_STEP1";
	string CHAT_STEP10 = "CHAT_STEP10";
	string CHAT_STEP2 = "CHAT_STEP2";
	string CHAT_STEP3 = "CHAT_STEP3";
	string CHAT_STEP4 = "CHAT_STEP4";
	string CHAT_STEP5 = "CHAT_STEP5";
	string CHAT_STEP6 = "CHAT_STEP6";
	string CHAT_STEP7 = "CHAT_STEP7";
	string CHAT_STEP8 = "CHAT_STEP8";
	string CHAT_STEP9 = "CHAT_STEP9";
	int CHAT_STEPS = 0;
	string CONV_ANIMS = "CONV_ANIMS";
	float COUNT = 0.0f;
	bool CUSTOM_GUARD = false;
	float DELAY = 0.0f;
	float FREQ_HINT_TEXT = 0.0f;
	bool HAS_BASE_CHAT_INCLUDE = false;
	bool HAS_INCLUDE_VENDOR = false;
	bool HAS_INCLUDE_VENDOR_CONFIRM = false;
	bool HELENA_RETURNED_HOME = false;
	bool HELENA_SAVED = false;
	float HELENA_TELE_HOME_TIME = 0.0f;
	float NEXT_DAGGER_CHAT = 0.0f;
	float NEXT_HINT_TEXT = 0.0f;
	bool NO_CHAT = false;
	bool NPC_CHECK_LEVEL = false;
	string OVERCHARGE = "OVERCHARGE";
	bool RAID_ON = false;
	float REST = 0.0f;
	string RQUEST_NAMES = "RQUEST_NAMES";
	CBaseEntity@ SCAREY_GUY = null;
	float SELL_RATIO = 0.0f;
	string SELL_WEAPON_LEVEL = "SELL_WEAPON_LEVEL";
	string STORE_BUYMENU = "STORE_BUYMENU";
	int STORE_CLOSED = 0;
	string STORE_NAME = "STORE_NAME";
	bool STORE_RESTOCK = false;
	int STORE_RESTOCK_TIME_HI = 0;
	int STORE_RESTOCK_TIME_LO = 0;
	bool STORE_SELLMENU = false;
	string STORE_TRADEEXT = "STORE_TRADEEXT";
	string STORE_TRIGGERTEXT = "STORE_TRIGGERTEXT";
	bool TRADE_RING = false;
	bool VENDOR_STORE_ACTIVE = false;
	string VENDOR_TARGET = "VENDOR_TARGET";
	bool VEND_ARMORER = false;
	string VEND_CHAT_MODE = "VEND_CHAT_MODE";
	string VEND_NEWBIE = "VEND_NEWBIE";
	bool VEND_NO_GOODBYE = false;
	string VEND_PREFIX = "VEND_PREFIX";
	CBaseEntity@ VEND_USER = null;

	// Variables declared by included files, with the value they start with in this script
	HumanGuardSwordScript()
	{
		SOUND_DEATH = "voices/human/male_die.wav";
		ANIM_IDLE = "idle1";
		ANIM_RUN = "run";
		ANIM_WALK = "walk";
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files

	// npcatk_setmovedest
	void OnNpcatkSetmovedest(string destination = "", string range = "")
	{
		BaseNpcAttackNew_OnNpcatkSetmovedest(destination, range); // monsters/base_npc_attack_new
		BaseAntiStuck_OnNpcatkSetmovedest(destination, range); // monsters/base_anti_stuck
	}

	// npcatk_settarget
	void OnNpcatkSettarget(string target = "", string debug = "")
	{
		BaseNpcAttackNew_OnNpcatkSettarget(target, debug); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcatkSettarget(target, debug); // monsters/base_monster_shared
	}

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("npc/guard1.mdl");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		HumanGuardSword_FirstThink();
		BaseNpc_FirstThink();
		MonstersExternals_FirstThink();
		BaseNpcAttackNew_FirstThink();
		BaseMonsterShared_FirstThink();
		BaseGuardFriendlyNew_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return HumanGuardSword_DispatchEvent(name, params)
			|| BaseGuardFriendlyNew_DispatchEvent(name, params)
			|| BaseMonsterNewScript::DispatchEvent(name, params);
	}
}
