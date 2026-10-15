#pragma context server

// Converted from monsters/skeleton_ice_enraged.script by msc_transpiler.
// Ice Bone Skeleton (Decayed) by Thothie from mscave/Shaddar

#include "runtime/ScriptEntity.as"
#include "converted/monsters/skeleton_base.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class SkeletonIceEnraged
{
	// Constants
	float FREQ_RETREAT = 20.0f;
	int SKEL_HP = 1000;
	string ATTACK_HITCHANCE = "85%";
	string SMASH_DAMAGE = "SMASH_DAMAGE";
	string SWIPE_DAMAGE = "SWIPE_DAMAGE";
	string ANIM_SWIPE = "attack1";
	string ANIM_SMASH = "attack2";
	string SKEL_RESPAWN_CHANCE = "50%";
	int SKEL_RESPAWN_LIVES = 1;
	string ANIM_BLAST = "rlflinch";
	string SOUND_BOLT = "magic/ice_strike.wav";
	string BOLT_FREQUENCY = "$randf(15,60)";
	float BOLT_DAMAGE = 30.0f;
	string FREEZE_CHANCE = "50%";
	float STUCK_CHECK_FREQUENCY = 2.0f;

	// Variables (an unset .script variable reads as its own name)
	string ANIM_WALK = "run";
	string ANIM_RUN = "run";
	float NPC_GIVE_EXP = 0.0f;
	string ANIM_ATTACK = "ANIM_ATTACK";
	int DROP_GOLD = 0;
	int DROP_GOLD_MIN = 0;
	int DROP_GOLD_MAX = 0;
	float RUN_THRESHOLD = 0.0f;
	float DAMAGE_TRACKER = 0.0f;
	bool SET_GREEK = false;
	bool BOLT_CHECKING = false;
	bool ICE_BLASTING = false;
	float NEXT_RETREAT = 0.0f;

	// unnamed block (first think)
	void SkeletonIceEnraged_FirstThink()
	{
		NPC_GIVE_EXP = 200.0f;

		ANIM_ATTACK = "attack1";

		// always run
		ANIM_WALK = "run";
		ANIM_RUN = "run";

		DROP_GOLD = 1;
		DROP_GOLD_MIN = 20;
		DROP_GOLD_MAX = 45;

		RUN_THRESHOLD = 200.0f; // chucken_run every 200pts damage
	}

	// skeleton_spawn
	void SkeletonIceEnraged_OnSkeletonSpawn()
	{
		SetName("Enraged Ice Bone");
		SetRace("undead");
		SetRoam(true);
		SetDamageTaken("all", 0.7f);
		SetDamageTaken("fire", 1.2f);
		SetDamageTaken("lightning", 0.5f);
		SetDamageTaken("cold", 0);
		// applyeffect ent_me effects/speed -1
		SetAnimMoveSpeed(2);
		SetModel("monsters/skeleton_enraged.mdl");
		SetHearingSensitivity(5);
		SetMoveAnim(ANIM_RUN);
		SetModelBody(0, 5); // 0=standard 1=ash 2=green 3=bloody 4=decayed 5=ice 6=gold 7=stone 8=crystal 9=weirdgel
		SetModelBody(1, 5); // 0=Unarmed 1=darkmace 2=sword 3=hammahs 4=bigsword+shield 5=iceclubs 6=fireclubs 7=highsword 8=wand
		SetStat("concentration", 30);
		SetStat("spellcasting", 30, 30, 30); // not sure if this'll work

		DAMAGE_TRACKER = 0.0f;

		if (ToLowerCase(MapName()) == "thanatos")
			SET_GREEK = true;
		if (SET_GREEK)
			SetModelBody(0, 10);
	}

	// npc_post_spawn
	void SkeletonIceEnraged_OnNpcPostSpawn()
	{
		RUN_THRESHOLD = MaxHealthOf(ENT_ME) * 0.25f;
	}

	// cast_bolts
	void SkeletonIceEnraged_OnCastBolts()
	{
		if (!IsAlive(ENT_ME))
			return;

		// callevent BOLT_FREQUENCY cast_bolts
		BOLT_CHECKING = false;

		if (ICE_BLASTING)
			return;
		if (Truthy(PLAYING_DEAD))
			return;

		// dbg Checking for Boltables
		PlayAnim("critcal", ANIM_BLAST);

		ICE_BLASTING = true;
		DoDamage(Text(RelativePosition(Vector3(0, 0, 0))), 2048, 0, "100%", 0, "reflective");
		ICE_BLASTING = false;
	}

	// game_dodamage
	// 1: Attack Hit (1/0)  2: Entity Attack hit  3:  Start Position  4:  End Position
	string SkeletonIceEnraged_OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";

		if (!ICE_BLASTING && ANIM_ATTACK == ANIM_SMASH && RandomInt(1, 4) == 1)
			ApplyEffect(target, "effects/dot_cold", 5, self, RandomInt(3, 5), "none");

		if (ICE_BLASTING && hit && RelationshipOf(target, ENT_ME) == "enemy")
		{
			// dbg Casting Bolt
			PlaySound(Int(Eval("game.sound.voice")), 10, SOUND_BOLT);

			SetMoveDest(@target, 9999);

			// <projectile scriptname> <"view"|(src_origin)> <target|(targ_origin)|none> <speed> <damage> <cof> <skill|none> //Converted to use new tossprojectile //greatguys1@FEB2022
			TossProjectile("proj_ice_bolt", RelativePosition(Vector3(0, 5, 10)), @target, 500, BOLT_DAMAGE, 1, "none");
		}
		return result;
	}

	// npc_targetsighted
	void SkeletonIceEnraged_OnNpcTargetsighted(string target = "")
	{
		if (BOLT_CHECKING)
			return;
		BOLT_CHECKING = true;

		CallEventDelayed(4.0f, "cast_bolts");
	}

	// attack_1
	// Deal damage
	void SkeletonIceEnraged_OnAttack12()
	{
		OnAttackSnd();
		DoDamage(ENT_LASTSEEN, ATTACK_HITRANGE, SWIPE_DAMAGE, ATTACK_HITCHANCE, "slash");

		if (RandomInt(1, 4) == 1)
			ANIM_ATTACK = ANIM_SMASH;
		CallEventDelayed(2.0f, "reset_atk");
	}

	// reset_atk
	void SkeletonIceEnraged_OnResetAtk()
	{
		ANIM_ATTACK = ANIM_SWIPE; // something happens that causes attack2 to sip the attack_2 frame
	}

	// attack_2
	void SkeletonIceEnraged_OnAttack22()
	{
		OnAttackSnd();
		DoDamage(ENT_LASTSEEN, ATTACK_HITRANGE, SMASH_DAMAGE, ATTACK_HITCHANCE, "blunt");

		ANIM_ATTACK = ANIM_SWIPE;
	}

	// game_struck
	void SkeletonIceEnraged_OnGameStruck(float damage = 0.0f, string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		if (CHICKEN_RUN)
			return;

		DAMAGE_TRACKER += damage;

		if (!(DAMAGE_TRACKER > RUN_THRESHOLD))
			return;

		if (!(GameTime() > NEXT_RETREAT))
			return;
		NEXT_RETREAT = GameTime() + FREQ_RETREAT;

		DAMAGE_TRACKER = 0.0f;

		OnChickenRun(3.0f);
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)

	// npc_post_spawn
	void OnNpcPostSpawn()
	{
		MonstersExternals_OnNpcPostSpawn(); // monsters/externals
		MonstersExternals_OnNpcPostSpawn_2(); // monsters/externals
		MonstersExternals_OnNpcPostSpawn_3(); // monsters/externals
		BaseSelfAdjust_OnNpcPostSpawn(); // monsters/base_self_adjust
		BaseNpc_OnNpcPostSpawn(); // monsters/base_npc
		BaseMonsterShared_OnNpcPostSpawn(); // monsters/base_monster_shared
		SkeletonBase_OnNpcPostSpawn(); // monsters/skeleton_base
		SkeletonIceEnraged_OnNpcPostSpawn();
	}

	// game_struck
	void OnGameStruck(float damage = 0.0f, string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		BaseNpc_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseNpcAttack_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc_attack
		BaseMonsterShared_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared
		SkeletonIceEnraged_OnGameStruck(damage, extraValue2, extraValue3, extraValue4);
	}

	// game_dodamage
	string OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";
		result = AppendResult(result, BaseAntiStuck_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BaseMonsterShared_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, SkeletonIceEnraged_OnGameDodamage(hit, target, start, end, damageType, damageText));
		return result;
	}

	// npc_targetsighted
	void OnNpcTargetsighted(string target = "")
	{
		BaseMonsterShared_OnNpcTargetsighted(target); // monsters/base_monster_shared
		SkeletonIceEnraged_OnNpcTargetsighted(target);
	}

	void OnSkeletonSpawn() { SkeletonIceEnraged_OnSkeletonSpawn(); } // skeleton_spawn
	void OnCastBolts() { SkeletonIceEnraged_OnCastBolts(); } // cast_bolts
	void OnAttack12() { SkeletonIceEnraged_OnAttack12(); } // attack_1
	void OnResetAtk() { SkeletonIceEnraged_OnResetAtk(); } // reset_atk
	void OnAttack22() { SkeletonIceEnraged_OnAttack22(); } // attack_2
	void OnAttackSnd() {} // attack_snd

	// This file's events and timers by their .script names
	bool SkeletonIceEnraged_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "attack_1") { OnAttack12(); return true; }
		if (name == "attack_2") { OnAttack22(); return true; }
		if (name == "cast_bolts") { OnCastBolts(); return true; }
		if (name == "game_dodamage") { Return(OnGameDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5))); return true; }
		if (name == "game_struck") { OnGameStruck(Float(Param(params, 0)), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "npc_post_spawn") { OnNpcPostSpawn(); return true; }
		if (name == "npc_targetsighted") { OnNpcTargetsighted(Param(params, 0)); return true; }
		if (name == "reset_atk") { OnResetAtk(); return true; }
		if (name == "skeleton_spawn") { OnSkeletonSpawn(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "monsters/skeleton_ice_enraged"]
shared class SkeletonIceEnragedScript : SkeletonBaseScript, SkeletonIceEnraged
{
	// Variables declared by included files, with the value they start with in this script
	SkeletonIceEnragedScript()
	{
		SKEL_HP = 1000;
		ATTACK_HITCHANCE = "85%";
		ANIM_WALK = "run";
		ANIM_RUN = "run";
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/skeleton_enraged.mdl");
		Precache("monsters/skeleton.mdl");
		CallEventDelayed(Float(CYCLE_TIME), "hunting_mode_go");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		SkeletonIceEnraged_FirstThink();
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
		return SkeletonIceEnraged_DispatchEvent(name, params)
			|| SkeletonBaseScript::DispatchEvent(name, params);
	}
}
