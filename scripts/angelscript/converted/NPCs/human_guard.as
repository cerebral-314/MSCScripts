#pragma context server

// Converted from NPCs/human_guard.script by msc_transpiler.
// Thothie - tired of dealing with the weirdness from these old guard scripts
// making some new guard scripts from scratch - will include/adjust ext scripts as needed

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_monster_new.as"
#include "converted/monsters/base_guard_friendly_new.as"
#include "converted/monsters/base_xmass.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class HumanGuard
{
	// Constants
	string SOUND_STRUCK = "body/flesh1.wav";
	string SOUND_WARCRY = "voices/human/male_guard_shout2.wav";
	string SOUND_DEATH = "voices/human/male_die.wav";
	string SOUND_ATTACK = "weapons/cbar_miss1.wav";
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

	// unnamed block (first think)
	void HumanGuard_FirstThink()
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
	void HumanGuard_OnNpcSpawn(string npc = "")
	{
		SetName("Guard");
		SetHealth(170);
		// ov	359
		SetHearingSensitivity(12);
		SetWidth(32);
		SetHeight(85);
		SetRace("hguard");
		SetRoam(false);
		SetBlood("red");
		SetModel("npc/guard1.mdl");
		SetDamageTaken("all", 0.9f);
		SetStat("parry", 10);

		CatchSpeech("say_xmass", "christmas", "xmas", "holidays", "hogswatch", "x-mas");
		// (always true here) if game.serverside

		if (ToLowerCase(MapName()) != "foutpost")
			return;
		SetRace("human");
		NPC_NO_PLAYER_DMG = true; // foutpost guards maybe forced to work amongst AOE player spells
	}

	// attack_1
	void HumanGuard_OnAttack12()
	{
		// Deal damage
		PlaySound(0, 8, SOUND_ATTACK);
		OnNpcatkDodamage(NPCATK_TARGET, Text(ATTACK_HITRANGE), ATTACK_DAMAGE, ATTACK_HITCHANCE);
	}

	// npc_struck
	void HumanGuard_OnNpcStruck(float damage = 0.0f)
	{
		PlaySound(0, 3, SOUND_STRUCK);
	}

	// baseguard_tobattle
	// called from base_guard_friendly
	void HumanGuard_OnBaseguardTobattle(CBaseEntity@ enemy = null)
	{
		PlaySound(0, 10, SOUND_WARCRY);
	}

	// game_dodamage
	string HumanGuard_OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";

		if (!hit)
			return result;
		PlaySound(0, 10, SOUND_STRUCK);
		return result;
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseNpc_OnGameSpawn(playerRace, playerGender); // monsters/base_npc
		BaseMonsterShared_OnGameSpawn(playerRace, playerGender); // monsters/base_monster_shared
		BaseXmass_OnGameSpawn(playerRace, playerGender); // monsters/base_xmass
	}

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
		HumanGuard_OnNpcSpawn(npc);
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

	// game_dodamage
	string OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";
		result = AppendResult(result, BaseNpcAttackNew_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BaseAntiStuck_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BaseMonsterShared_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, HumanGuard_OnGameDodamage(hit, target, start, end, damageType, damageText));
		return result;
	}

	// baseguard_tobattle
	void OnBaseguardTobattle(CBaseEntity@ enemy = null)
	{
		BaseGuardFriendlyNew_OnBaseguardTobattle(enemy); // monsters/base_guard_friendly_new
		HumanGuard_OnBaseguardTobattle(enemy);
	}

	void OnNpcPreFlee() { BaseGuardFriendlyNew_OnNpcPreFlee(); } // npc_pre_flee
	void OnAttack12() { HumanGuard_OnAttack12(); } // attack_1
	void OnNpcStruck(float damage = 0.0f) { HumanGuard_OnNpcStruck(damage); } // npc_struck

	// This file's events and timers by their .script names
	bool HumanGuard_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "attack_1") { OnAttack12(); return true; }
		if (name == "baseguard_tobattle") { OnBaseguardTobattle(EntityParam(params, 0)); return true; }
		if (name == "game_dodamage") { Return(OnGameDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5))); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "npc_struck") { OnNpcStruck(Float(Param(params, 0))); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "NPCs/human_guard"]
shared class HumanGuardScript : BaseMonsterNewScript, HumanGuard, BaseGuardFriendlyNew, BaseXmass
{
	// Variables declared by included files, with the value they start with in this script
	HumanGuardScript()
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
		HumanGuard_FirstThink();
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
		return HumanGuard_DispatchEvent(name, params)
			|| BaseGuardFriendlyNew_DispatchEvent(name, params)
			|| BaseXmass_DispatchEvent(name, params)
			|| BaseMonsterNewScript::DispatchEvent(name, params);
	}
}
