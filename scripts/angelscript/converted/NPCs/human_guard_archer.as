#pragma context server

// Converted from NPCs/human_guard_archer.script by msc_transpiler.
// Thothie - tired of dealing with the weirdness from these old guard scripts
// making some new guard scripts from scratch - will include/adjust ext scripts as needed

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_monster_new.as"
#include "converted/monsters/base_guard_friendly_new.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class HumanGuardArcher
{
	// Constants
	string SOUND_STRUCK = "body/flesh1.wav";
	string SOUND_WARCRY = "voices/human/male_guard_shout.wav";
	string SOUND_ATTACK = "weapons/bow/bowslow.wav";
	string SOUND_DEATH = "voices/human/male_die.wav";
	int ATTACK_SPEED = 500;
	string ATTACK_DAMAGE = "$rand(8,12)";
	int ATTACK_COF = 0;

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
	void HumanGuardArcher_FirstThink()
	{
		ANIM_IDLE = "idle1";
		ANIM_RUN = "run";
		ANIM_WALK = "walk";
		ANIM_DEATH = "die_fallback";
		ANIM_ATTACK = "shootorcbow";
		MOVE_RANGE = ATTACK_SPEED;
		ATTACK_RANGE = ATTACK_SPEED;
		ATTACK_HITRANGE = ATTACK_SPEED;

		CAN_HUNT = "1";
		CAN_ATTACK = "1";
		HUNT_AGRO = "1";
		CAN_RETALIATE = "1";

		NPC_GIVE_EXP = 0.0f;
	}

	// npc_spawn
	// in helena 	name_unique	Archer
	void HumanGuardArcher_OnNpcSpawn(string npc = "")
	{
		SetName("Human Archer");
		SetHealth(120);
		// ov	359
		SetHearingSensitivity(12);
		SetWidth(32);
		SetHeight(85);
		SetRace("hguard");
		SetRoam(false);
		SetModel("npc/archer.mdl");
		SetDamageTaken("all", 0.9f);
		SetModelBody(2, 2);
		// this fixed shakey idle! :)
		// playanim loop ANIM_IDLE
		// setidleanim	ANIM_IDLE
		// setmovedest ANIM_IDLE
		// setmoveanim	ANIM_IDLE
		// setactionanim	none
		SetStat("parry", 2, 2, 2);
		SetMoveSpeed(0);

		if (ToLowerCase(MapName()) != "foutpost")
			return;
		SetDamageTaken("all", 0.25f);
		SetRace("human");
		NPC_NO_PLAYER_DMG = true; // foutpost guards maybe forced to work amongst AOE player spells
	}

	// shoot_arrow
	// called from anim shootorcbow @ frame 100
	void HumanGuardArcher_OnShootArrow()
	{
		// callevent baseaim_adjust_angles
		PlaySound(0, 10, SOUND_ATTACK);

		// //local FINAL_ATTACK_DAMAGE ATTACK_DAMAGE
		// if ( EXT_DAMAGE_ADJUSTMENT isnot 'EXT_DAMAGE_ADJUSTMENT' ) add FINAL_ATTACK_DAMAGE EXT_DAMAGE_ADJUSTMENT //for future use
		// tossprojectile view ATTACK_SPEED FINAL_ATTACK_DAMAGE ATTACK_COF proj_arrow_npc (0,0,48)
		// works:
		Vector3 targOrg = OriginOf(NPCATK_TARGET);
		if (!IsPlayer(Text(targOrg)))
			targOrg.z += HeightOf(NPCATK_TARGET);
		float targDist = Divide(Distance(targOrg, MyOrigin()), 25.0f);
		SetAngle("add_view.pitch", targDist);
		// <projectile scriptname> <"view"|(src_origin)> <target|(targ_origin)|none> <speed> <damage> <cof> <skill|none> //Converted to use new tossprojectile //greatguys1@FEB2022
		TossProjectile("proj_arrow_npc", RelativePosition(Vector3(0, 0, 3)), "none", ATTACK_SPEED, ATTACK_DAMAGE, ATTACK_COF, "none");
		CallExternal(EntityOf(ENT_LASTPROJECTILE), "ext_lighten", 0.4f);
	}

	// npc_struck
	void HumanGuardArcher_OnNpcStruck(float damage = 0.0f)
	{
		PlaySound(0, 5, SOUND_STRUCK);
	}

	// baseguard_tobattle
	void HumanGuardArcher_OnBaseguardTobattle(CBaseEntity@ enemy = null)
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
		HumanGuardArcher_OnNpcSpawn(npc);
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
		HumanGuardArcher_OnBaseguardTobattle(enemy);
	}

	void OnNpcPreFlee() { BaseGuardFriendlyNew_OnNpcPreFlee(); } // npc_pre_flee
	void OnShootArrow() { HumanGuardArcher_OnShootArrow(); } // shoot_arrow
	void OnNpcStruck(float damage = 0.0f) { HumanGuardArcher_OnNpcStruck(damage); } // npc_struck

	// This file's events and timers by their .script names
	bool HumanGuardArcher_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "baseguard_tobattle") { OnBaseguardTobattle(EntityParam(params, 0)); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "npc_struck") { OnNpcStruck(Float(Param(params, 0))); return true; }
		if (name == "shoot_arrow") { OnShootArrow(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "NPCs/human_guard_archer"]
shared class HumanGuardArcherScript : BaseMonsterNewScript, HumanGuardArcher, BaseGuardFriendlyNew
{
	// Variables every script that includes this file declares
	bool NO_CHAT = false;

	// Variables declared by included files, with the value they start with in this script
	HumanGuardArcherScript()
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
		Precache("npc/archer.mdl");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		HumanGuardArcher_FirstThink();
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
		return HumanGuardArcher_DispatchEvent(name, params)
			|| BaseGuardFriendlyNew_DispatchEvent(name, params)
			|| BaseMonsterNewScript::DispatchEvent(name, params);
	}
}
