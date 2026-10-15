#pragma context server

// Converted from monsters/skeleton_ice_warrior.script by msc_transpiler.
// Ice Bone Skeleton (Decayed) by Thothie from mscave/Shaddar

#include "runtime/ScriptEntity.as"
#include "converted/monsters/skeleton_base.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class SkeletonIceWarrior
{
	// Constants
	int SKEL_HP = 1000;
	string ATTACK_HITCHANCE = "85%";
	string SMASH_DAMAGE = "$rand(50,100)";
	string ANIM_SWIPE = "attack1";
	string ANIM_SMASH = "attack2";
	string SKEL_RESPAWN_CHANCE = "50%";
	int SKEL_RESPAWN_LIVES = 1;
	string ANIM_BLAST = "rlflinch";
	string SOUND_BOLT = "magic/ice_strike.wav";
	string BOLT_FREQUENCY = "10.0";
	float BOLT_DAMAGE = 30.0f;
	string FREEZE_CHANCE = "50%";

	// Variables (an unset .script variable reads as its own name)
	float ATTACK_DAMAGE_LOW = 0.0f;
	float ATTACK_DAMAGE_HIGH = 0.0f;
	float NPC_GIVE_EXP = 0.0f;
	string ANIM_ATTACK = "ANIM_ATTACK";
	int DROP_GOLD = 0;
	int DROP_GOLD_MIN = 0;
	int DROP_GOLD_MAX = 0;
	string DROP_ITEM1 = "DROP_ITEM1";
	string DROP_ITEM1_CHANCE = "DROP_ITEM1_CHANCE";
	bool ICE_BLASTING = false;
	bool FREEZE_ATTACK = false;
	bool BOLT_CHECKING = false;

	// unnamed block (first think)
	void SkeletonIceWarrior_FirstThink()
	{
		ATTACK_DAMAGE_LOW = 20.5f;
		ATTACK_DAMAGE_HIGH = 30.5f;
		NPC_GIVE_EXP = 120.0f;

		ANIM_ATTACK = "attack1";

		DROP_GOLD = 1;
		DROP_GOLD_MIN = 20;
		DROP_GOLD_MAX = 35;

		DROP_ITEM1 = "swords_liceblade";
		DROP_ITEM1_CHANCE = "10%";
	}

	// skeleton_spawn
	void SkeletonIceWarrior_OnSkeletonSpawn()
	{
		SetName("Ice Bone Warrior");
		SetRace("undead");
		SetRoam(true);
		SetDamageTaken("all", 0.7f);
		SetDamageTaken("fire", 1.2f);
		SetDamageTaken("lightning", 0.5f);
		SetDamageTaken("cold", 0);
		SetModel("monsters/skeleton.mdl");
		SetHearingSensitivity(5);
		SetModelBody(0, 7);
		SetModelBody(1, 4); // 0=Unarmed 1=BoneBlade 2=DblAxe 3=DblShield 4=sword
		SetStat("concentration", 30);
		SetStat("spellcasting", 30, 30, 30); // not sure if this'll work
	}

	// cast_bolts
	void SkeletonIceWarrior_OnCastBolts()
	{
		if (!IsAlive(ENT_ME))
			return;

		CallEventOrDelay(BOLT_FREQUENCY, "cast_bolts");

		if (!CanSee("player"))
			return;

		if (ICE_BLASTING)
			return;
		if (Truthy(PLAYING_DEAD))
			return;

		// dbg Checking for Boltables
		ICE_BLASTING = true;

		CallEventDelayed(0.1f, "end_blast");

		PlayAnim("critcal", ANIM_BLAST);

		DoDamage(Text(RelativePosition(Vector3(0, 0, 0))), 2048, 0, "100%", 0, "reflective");
	}

	// end_blast
	void SkeletonIceWarrior_OnEndBlast()
	{
		ICE_BLASTING = false;
	}

	// skele_swing_dodamage
	// 1: Attack Hit (1/0)  2: Entity Attack hit  3:  Start Position  4:  End Position
	void SkeletonIceWarrior_OnSkeleSwingDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		if (!ICE_BLASTING && !FREEZE_ATTACK && RandomInt(1, 4) == 1)
			ApplyEffect(EntityOf(ENT_LASTSTRUCKBYME), "effects/dot_cold", 5, ENT_ME, RandomInt(3, 5), "none");

		if (FREEZE_ATTACK)
		{
			int freezeRoll = RandomInt(1, 100);
			if (freezeRoll <= Float(FREEZE_CHANCE))
				ApplyEffect(EntityOf(ENT_LASTSTRUCKBYME), "effects/dot_cold_freeze", 10, self);
			if (freezeRoll > Float(FREEZE_CHANCE) && hit)
				PlayerMessage(target, "Ice Bone Warrior attempts to freeze you!");
			FREEZE_ATTACK = false;
		}

		if (!ICE_BLASTING)
			return;

		if (!hit)
			return;

		if (RelationshipOf(target, ENT_ME) != "enemy")
			return;

		// dbg Casting Bolt
		PlaySound(Int(Eval("game.sound.voice")), 10, SOUND_BOLT);

		SetMoveDest(@target, 9999);

		// <projectile scriptname> <"view"|(src_origin)> <target|(targ_origin)|none> <speed> <damage> <cof> <skill|none> //Converted to use new tossprojectile //greatguys1@FEB2022
		TossProjectile("proj_ice_bolt", RelativePosition(Vector3(0, 5, 10)), @target, 500, BOLT_DAMAGE, 1, "none");
	}

	// npcatk_targetvalidate
	void SkeletonIceWarrior_OnNpcatkTargetvalidate(string target = "")
	{
		if (BOLT_CHECKING)
			return;
		BOLT_CHECKING = true;

		CallEventDelayed(4.0f, "cast_bolts");
	}

	// attack_1
	// Deal damage
	void SkeletonIceWarrior_OnAttack12()
	{
		OnAttackSnd();
		DoDamage(ENT_LASTSEEN, ATTACK_RANGE, Random(ATTACK_DAMAGE_LOW, ATTACK_DAMAGE_HIGH), ATTACK_HITCHANCE);

		if (RandomInt(1, 20) == 1)
			ANIM_ATTACK = "attack2";
	}

	// attack_2
	void SkeletonIceWarrior_OnAttack22()
	{
		Effect("glow", ENT_ME, Vector3(128, 128, 255), 80, 2, 2);
		PlaySound(0, 10, "magic/spawn.wav");

		DoDamage(ENT_LASTSEEN, ATTACK_RANGE, SMASH_DAMAGE, ATTACK_HITCHANCE);

		FREEZE_ATTACK = true;

		ANIM_ATTACK = "attack1";
		OnAttackSnd();
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)

	// npcatk_targetvalidate
	void OnNpcatkTargetvalidate(string target = "")
	{
		BaseNpcAttack_OnNpcatkTargetvalidate(target); // monsters/base_npc_attack
		SkeletonIceWarrior_OnNpcatkTargetvalidate(target);
	}

	void OnSkeletonSpawn() { SkeletonIceWarrior_OnSkeletonSpawn(); } // skeleton_spawn
	void OnCastBolts() { SkeletonIceWarrior_OnCastBolts(); } // cast_bolts
	void OnEndBlast() { SkeletonIceWarrior_OnEndBlast(); } // end_blast
	void OnSkeleSwingDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "") { SkeletonIceWarrior_OnSkeleSwingDodamage(hit, target, start, end, damageType, damageText); } // skele_swing_dodamage
	void OnAttack12() { SkeletonIceWarrior_OnAttack12(); } // attack_1
	void OnAttack22() { SkeletonIceWarrior_OnAttack22(); } // attack_2
	void OnBoltFrequency() {} // BOLT_FREQUENCY
	void OnAttackSnd() {} // attack_snd

	// This file's events and timers by their .script names
	bool SkeletonIceWarrior_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "attack_1") { OnAttack12(); return true; }
		if (name == "attack_2") { OnAttack22(); return true; }
		if (name == "cast_bolts") { OnCastBolts(); return true; }
		if (name == "end_blast") { OnEndBlast(); return true; }
		if (name == "npcatk_targetvalidate") { OnNpcatkTargetvalidate(Param(params, 0)); return true; }
		if (name == "skele_swing_dodamage") { OnSkeleSwingDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5)); return true; }
		if (name == "skeleton_spawn") { OnSkeletonSpawn(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "monsters/skeleton_ice_warrior"]
shared class SkeletonIceWarriorScript : SkeletonBaseScript, SkeletonIceWarrior
{
	// Variables declared by included files, with the value they start with in this script
	SkeletonIceWarriorScript()
	{
		SKEL_HP = 1000;
		ATTACK_HITCHANCE = "85%";
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		SkeletonIceWarrior_FirstThink();
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
		return SkeletonIceWarrior_DispatchEvent(name, params)
			|| SkeletonBaseScript::DispatchEvent(name, params);
	}
}
