#pragma context server

// Converted from monsters/skeleton_ice.script by msc_transpiler.
// Ice Bone Skeleton (Decayed) by Thothie from mscave/Shaddar

#include "runtime/ScriptEntity.as"
#include "converted/monsters/skeleton_base.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class SkeletonIce
{
	// Constants
	int SKEL_HP = 700;
	string ATTACK_HITCHANCE = "85%";
	string SKEL_RESPAWN_CHANCE = "50%";
	int SKEL_RESPAWN_LIVES = 1;
	string ANIM_BLAST = "castspell";
	string SOUND_BOLT = "magic/ice_strike.wav";
	string BOLT_FREQUENCY = "3.0";
	float BOLT_DAMAGE = 60.0f;

	// Variables (an unset .script variable reads as its own name)
	float ATTACK_DAMAGE_LOW = 0.0f;
	float ATTACK_DAMAGE_HIGH = 0.0f;
	float NPC_GIVE_EXP = 0.0f;
	int DROP_GOLD = 0;
	int DROP_GOLD_MIN = 0;
	int DROP_GOLD_MAX = 0;
	string MOVE_RANGE = "MOVE_RANGE";
	bool SET_GREEK = false;
	bool BOLT_CHECKING = false;
	string NO_STUCK_CHECKS = "NO_STUCK_CHECKS";
	bool BOLTS_ON = false;
	float NEXT_BOLT = 0.0f;

	// unnamed block (first think)
	void SkeletonIce_FirstThink()
	{
		ATTACK_DAMAGE_LOW = 10.5f;
		ATTACK_DAMAGE_HIGH = 15.5f;
		NPC_GIVE_EXP = 120.0f;

		DROP_GOLD = 1;
		DROP_GOLD_MIN = 20;
		DROP_GOLD_MAX = 35;

		MOVE_RANGE = "300";
	}

	// skeleton_spawn
	void SkeletonIce_OnSkeletonSpawn()
	{
		SetName("Decayed Ice Bone");
		SetRace("undead");
		SetRoam(true);
		SetDamageTaken("all", 0.7f);
		SetDamageTaken("fire", 1.2f);
		SetDamageTaken("lightning", 0.5f);
		SetDamageTaken("cold", 0);
		SetModel("monsters/skeleton_boss1.mdl");
		SetModelBody(0, 5); // 0=standard 1=ash 2=green 3=bloody 4=decayed 5=ice 6=gold 7=stone 8=crystal 9=weirdgel
		SetModelBody(1, 8); // 0=Unarmed 1=darkmace 2=sword 3=hammahs 4=bigsword+shield 5=iceclubs 6=fireclubs 7=highsword 8=wand 9=wand(active)
		SetHearingSensitivity(5);

		if (ToLowerCase(MapName()) == "thanatos")
			SET_GREEK = true;
		if (SET_GREEK)
			SetModelBody(0, 10);

		SetMoveAnim(ANIM_WALK);
		SetIdleAnim(ANIM_IDLE);

		BOLT_CHECKING = false;

		SetStat("concentration", 30);
		SetStat("spellcasting", 30, 30, 30); // not sure if this'll work
	}

	// cast_bolts
	void SkeletonIce_OnCastBolts()
	{
		if (!IsAlive(ENT_ME))
			return;

		if (!BOLT_CHECKING)
			return;

		CallEventOrDelay(BOLT_FREQUENCY, "cast_bolts");

		bool seeNme = CanSee("enemy");

		if (!seeNme)
			NO_STUCK_CHECKS = "0";

		if (!seeNme)
			return;

		if (!(RangeTo(ENT_LASTSEEN) > ATTACK_RANGE))
			return;

		NO_STUCK_CHECKS = "1";

		PlaySound(0, 10, "magic/frost_reverse.wav");

		Effect("glow", ENT_ME, Vector3(128, 128, 255), 32, 2, 2);

		SetModelBody(1, 9);

		PlayAnim("once", "castspell");

		BOLTS_ON = true;

		CallEventDelayed(1.0f, "bolts_off");
	}

	// bolts_off
	void SkeletonIce_OnBoltsOff()
	{
		BOLTS_ON = false;

		SetModelBody(1, 8);
	}

	// extra_bolts
	void SkeletonIce_OnExtraBolts()
	{
		// playsound 0 10 SOUND_BOLT
		Vector3 boltDest = OriginOf(ENT_ME);
		float boltYaw = AnglesOf(ENT_ME).y;
		boltDest += RelativePosition(Vector3(0, boltYaw, 0), Vector3(0, 100, 40));
		// local BOLT_START game.monster.origin
		// vectoradd BOLT_START $relpos($vec(0,BOLT_DIR,0),$vec(0,30,40))
		// <projectile scriptname> <"view"|(src_origin)> <target|(targ_origin)|none> <speed> <damage> <cof> <skill|none> //Converted to use new tossprojectile //greatguys1@FEB2022
		TossProjectile("proj_ice_bolt", AttachmentPositionOf(ENT_ME, 0), boltDest, 500, BOLT_DAMAGE, 20, "none");
	}

	// npc_targetsighted
	void SkeletonIce_OnNpcTargetsighted(string target = "")
	{
		if (!BOLTS_ON)
			return;
		if (!(GameTime() > NEXT_BOLT))
			return;
		NEXT_BOLT = GameTime() + 0.2f;
		Vector3 boltDest = OriginOf(NPCATK_TARGET);
		// local BOLT_START game.monster.origin
		// vectoradd BOLT_START $relpos($vec(0,BOLT_DIR,0),$vec(0,30,40))
		TossProjectile("proj_ice_bolt", AttachmentPositionOf(ENT_ME, 0), boltDest, 500, BOLT_DAMAGE, 10, "none");
	}

	// cycle_up
	// { game_dodamage //1: Attack Hit (1/0)  2: Entity Attack hit  3:  Start Position  4:  End Position
	// if ICE_BLASTING
	// if PARAM1
	// if PARAM2 isnot LAST_DAMAGED
	// if $get(PARAM2,relationship,ent_me) equals enemy
	// add BOLTED 1
	// //dbg Casting Bolt
	// playsound 0 10 SOUND_BOLT
	// //setmovedest PARAM2 9999
	// setvard LAST_DAMAGED PARAM2
	// tossprojectile PARAM2 500 BOLT_DAMAGE 1 proj_ice_bolt (0,20,50)
	// }
	void SkeletonIce_OnCycleUp(string reason = "")
	{
		if (BOLT_CHECKING)
			return;
		BOLT_CHECKING = true;

		OnCastBolts();
	}

	// cycle_down
	void SkeletonIce_OnCycleDown()
	{
	}

	// game_death
	void SkeletonIce_OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		SetModelBody(1, 8);
	}

	// go_greek
	void SkeletonIce_OnGoGreek()
	{
		SetModelBody(0, 10);
		SET_GREEK = true;
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)

	// game_death
	void OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		DqMonsterExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // dq/externals/dq_monster_externals
		MonstersExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/externals
		BaseSelfAdjust_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_self_adjust
		BaseNpc_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseMonsterShared_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared
		SkeletonIce_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4);
	}

	// cycle_up
	void OnCycleUp(string reason = "")
	{
		BaseNpcAttack_OnCycleUp(reason); // monsters/base_npc_attack
		SkeletonIce_OnCycleUp(reason);
	}

	// cycle_down
	void OnCycleDown()
	{
		BaseNpcAttack_OnCycleDown(); // monsters/base_npc_attack
		BaseMonsterShared_OnCycleDown(); // monsters/base_monster_shared
		BaseMonsterShared_OnCycleDown_2(); // monsters/base_monster_shared
		SkeletonIce_OnCycleDown();
	}

	// npc_targetsighted
	void OnNpcTargetsighted(string target = "")
	{
		BaseMonsterShared_OnNpcTargetsighted(target); // monsters/base_monster_shared
		SkeletonIce_OnNpcTargetsighted(target);
	}

	// go_greek
	void OnGoGreek()
	{
		SkeletonBase_OnGoGreek(); // monsters/skeleton_base
		SkeletonIce_OnGoGreek();
	}

	void OnSkeletonSpawn() { SkeletonIce_OnSkeletonSpawn(); } // skeleton_spawn
	void OnCastBolts() { SkeletonIce_OnCastBolts(); } // cast_bolts
	void OnBoltsOff() { SkeletonIce_OnBoltsOff(); } // bolts_off
	void OnExtraBolts() { SkeletonIce_OnExtraBolts(); } // extra_bolts
	void OnBoltFrequency() {} // BOLT_FREQUENCY

	// This file's events and timers by their .script names
	bool SkeletonIce_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "bolts_off") { OnBoltsOff(); return true; }
		if (name == "cast_bolts") { OnCastBolts(); return true; }
		if (name == "cycle_down") { OnCycleDown(); return true; }
		if (name == "cycle_up") { OnCycleUp(Param(params, 0)); return true; }
		if (name == "extra_bolts") { OnExtraBolts(); return true; }
		if (name == "game_death") { OnGameDeath(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "go_greek") { OnGoGreek(); return true; }
		if (name == "npc_targetsighted") { OnNpcTargetsighted(Param(params, 0)); return true; }
		if (name == "skeleton_spawn") { OnSkeletonSpawn(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "monsters/skeleton_ice"]
shared class SkeletonIceScript : SkeletonBaseScript, SkeletonIce
{
	// Variables declared by included files, with the value they start with in this script
	SkeletonIceScript()
	{
		SKEL_HP = 700;
		ATTACK_HITCHANCE = "85%";
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/skeleton_boss1.mdl");
		Precache("monsters/skeleton.mdl");
		CallEventDelayed(Float(CYCLE_TIME), "hunting_mode_go");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		SkeletonIce_FirstThink();
		SkeletonBase_FirstThink();
		SkeletonBase_FirstThink2();
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
		return SkeletonIce_DispatchEvent(name, params)
			|| SkeletonBaseScript::DispatchEvent(name, params);
	}
}
