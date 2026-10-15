#pragma context server

// Converted from monsters/bandit_hard.script by msc_transpiler.
// This is an older script and may have some bad conventions as a result
// *** Random bandit script ***

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_monster.as"
#include "converted/monsters/base_aim_proj.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class BanditHard
{
	// Constants
	string SOUND_PAIN = "player/chesthit1.wav";
	string SOUND_PAIN2 = "player/armhit1.wav";
	string SOUND_DEATH = "player/leghit1.wav";
	string SOUND_BOW = "weapons/bow/bow.wav";
	string RETALIATE_CHANGETARGET_CHANCE = "75%";
	int AIM_RATIO = 50;
	string ARROW_DAMAGE = "$rand(15,40)";

	// Variables (an unset .script variable reads as its own name)
	string ANIM_IDLE = "idle";
	string ANIM_RUN = "run";
	string ANIM_WALK = "walk2";
	string CONTAINER_DROP_CHANCE = "CONTAINER_DROP_CHANCE";
	string CONTAINER_SCRIPT = "CONTAINER_SCRIPT";
	string ANIM_DEATH = "ANIM_DEATH";
	string CAN_HUNT = "CAN_HUNT";
	string HUNT_AGRO = "HUNT_AGRO";
	string CAN_ATTACK = "CAN_ATTACK";
	string CAN_RETALIATE = "CAN_RETALIATE";
	string CAN_HEAR = "CAN_HEAR";
	float NPC_GIVE_EXP = 0.0f;
	string WEAPON = "WEAPON";
	int ATTACK_SPEED = 1200;
	int ATTACK_COF = 0;
	string MOVE_RANGE = "MOVE_RANGE";
	float ATTACK_RANGE = 0.0f;
	string ANIM_ATTACK = "ANIM_ATTACK";
	float TOO_CLOSE = 0.0f;
	int DROPS_CONTAINER = 0;
	string NO_STUCK_CHECKS = "NO_STUCK_CHECKS";
	string ATTACK1_DAMAGE = "ATTACK1_DAMAGE";
	string ATTACK_PERCENTAGE = "80%";
	string DROP_ITEM1 = "DROP_ITEM1";
	string DROP_ITEM1_CHANCE = "DROP_ITEM1_CHANCE";
	string FINAL_DAMAGE = "FINAL_DAMAGE";
	float AS_ATTACKING = 0.0f;
	float CHANGE_POSITION = 0.0f;
	bool PURE_FLEE = false;

	// unnamed block (first think)
	void BanditHard_FirstThink()
	{
		CONTAINER_DROP_CHANCE = "10%";
		CONTAINER_SCRIPT = "chests/quiver_of_poison";
		ANIM_IDLE = "idle";
		ANIM_RUN = "run";
		ANIM_WALK = "walk2";
		ANIM_DEATH = "die_simple";
		CAN_HUNT = "1";
		HUNT_AGRO = "1";
		CAN_ATTACK = "1";
		CAN_RETALIATE = "1";
		CAN_HEAR = "1";
		NPC_GIVE_EXP = 120.0f;

		OnBowey();
		OnFistey();
		OnDaggerey();
		OnSwordey();
		OnAxey();
		OnMacey();
	}

	// npc_spawn
	// Spawn properties
	void BanditHard_OnNpcSpawn(string npc = "")
	{
		if (WEAPON == "WEAPON")
			WEAPON = RandomInt(0, 5);
		SetGold(RandomInt(23, 37));
		// fov			220
		SetWidth(32);
		SetHeight(92);
		SetRace("rogue");
		SetDamageTaken("all", 0.6f);
		SetHearingSensitivity(3);
		SetRoam(true);
		SetModel("npc/rogue.mdl");
		SetIdleAnim(ANIM_IDLE);
		SetMoveAnim(ANIM_WALK);
	}

	// bowey
	void BanditHard_OnBowey()
	{
		if (Float(WEAPON) != 0.0f)
			return;
		SetName("Trained Bandit Archer");
		SetHealth(190);
		ATTACK_SPEED = 1200;
		MOVE_RANGE = ATTACK_SPEED;
		ATTACK_RANGE = ATTACK_SPEED;
		ATTACK_COF = 0;
		ANIM_ATTACK = "shootbow";
		SetModelBody(1, 5);
		TOO_CLOSE = 0.0f;
		DROPS_CONTAINER = 1;
		NO_STUCK_CHECKS = "1";
	}

	// daggerey
	void BanditHard_OnDaggerey()
	{
		if (Float(WEAPON) != 1.0f)
			return;
		SetName("Trained Bandit Rogue");
		SetHealth(190);
		MOVE_RANGE = "50";
		ATTACK_RANGE = 90.0f;
		ATTACK1_DAMAGE = Text(Random(10.5f, 12));
		ATTACK_PERCENTAGE = "80%";
		ANIM_ATTACK = "swordjab1_R";
		SetModelBody(1, 1);
		DROP_ITEM1 = "smallarms_fangstooth"; // Used by base_monster
		DROP_ITEM1_CHANCE = "5%"; // Used by base_monster
	}

	// fistey
	void BanditHard_OnFistey()
	{
		if (Float(WEAPON) != 2.0f)
			return;
		SetName("Trained Bandit Martial Artist");
		SetHealth(220);
		MOVE_RANGE = "50";
		ATTACK_RANGE = 80.0f;
		ATTACK1_DAMAGE = Text(Random(8.5f, 10));
		ATTACK_PERCENTAGE = "80%";
		ANIM_ATTACK = "aim_punch1";
		SetModelBody(1, 0);
	}

	// swordey
	void BanditHard_OnSwordey()
	{
		if (Float(WEAPON) != 3.0f)
			return;
		SetName("Trained Bandit Swordsman");
		SetHealth(220);
		MOVE_RANGE = "80";
		ATTACK_RANGE = 120.0f;
		ATTACK1_DAMAGE = Text(Random(10.5f, 12));
		ATTACK_PERCENTAGE = "85%";
		ANIM_ATTACK = "swordswing2_R";
		SetModelBody(1, 4);
	}

	// axey
	void BanditHard_OnAxey()
	{
		if (Float(WEAPON) != 4.0f)
			return;
		SetName("Trained Bandit Axeman");
		SetHealth(260);
		MOVE_RANGE = "80";
		ATTACK_RANGE = 120.0f;
		ATTACK1_DAMAGE = Text(Random(11.5f, 13));
		ATTACK_PERCENTAGE = "85%";
		ANIM_ATTACK = "battleaxe_swing1_R";
		SetModelBody(1, 3);
	}

	// macey
	void BanditHard_OnMacey()
	{
		if (Float(WEAPON) != 5.0f)
			return;
		SetName("Trained Bandit Berserker");
		SetHealth(260);
		MOVE_RANGE = "80";
		ATTACK_RANGE = 130.0f;
		ATTACK1_DAMAGE = Text(Random(11.5f, 13));
		ATTACK_PERCENTAGE = "85%";
		ANIM_ATTACK = "battleaxe_swing1_R";
		SetModelBody(1, 2);
	}

	// attack
	void BanditHard_OnAttack()
	{
		// Deal damage
		if (IS_FLEEING)
			return;

		if (Float(WEAPON) == 0.0f)
		{
			// local AIM_ANGLE $get(ent_lastseen,dist)		//Aim up a bit
			// divide AIM_ANGLE AIM_RATIO				//
			// setangle add_view.x AIM_ANGLE			//
			// local TARGET_POS $get(ent_lastseen,origin) //combine with final
			// local TARGET_DIST $get(ent_lastseen,range)
			// local TARGET_Z $vec.z(TARGET_POS) //not used
			// local FINAL_TARGET TARGET_POS
			// vectoradd FINAL_TARGET $relpos($vec(0,0,0),$vec(0,0,TARGET_DIST))
			// divide TARGET_DIST 100
			// setangle add_view.pitch TARGET_DIST
			// callevent baseaim_adjust_angles
			SetAngle("add_view.pitch", 5); // fires in such a shallow arc, no need to adj based on distance
			FINAL_DAMAGE = ARROW_DAMAGE;
			OnNpcatkAdjAttack();
			AS_ATTACKING = GameTime();

			// <projectile scriptname> <"view"|(src_origin)> <target|(targ_origin)|none> <speed> <damage> <cof> <skill|none> //Converted to use new tossprojectile //greatguys1@FEB2022
			TossProjectile("proj_arrow_poison", RelativePosition(Vector3(0, 0, 2)), "none", ATTACK_SPEED, FINAL_DAMAGE, ATTACK_COF, "none");
			CallExternal(EntityOf(ENT_LASTPROJECTILE), "ext_lighten", 0.4f);
			PlaySound(2, 10, SOUND_BOW);
		}
		else
		{
			DoDamage(ENT_LASTSEEN, ATTACK_RANGE, ATTACK1_DAMAGE, ATTACK_PERCENTAGE);

			// bandit dagger now using fangtooth
			if (Float(WEAPON) == 1.0f && RandomInt(1, 3) == 1)
				ApplyEffect(ENT_LASTSTRUCKBYME, "effects/dot_poison", 5, ENT_ME, RandomInt(3, 5));
		}
	}

	// check_attack
	void BanditHard_OnCheckAttack()
	{
		// trained archers move away from melee - thothie
		if (Float(WEAPON) != 0.0f)
			return;

		if (IS_FLEEING)
			return;

		// //dbg ChangPos CHANGE_POSITION
		if (CHANGE_POSITION > 3.0f)
		{
			CHANGE_POSITION = 0.0f;
			PlayAnim("break");
			PlayAnim("critical", ANIM_RUN);
			// setvard PURE_FLEE 1
			// callevent npcatk_flee ent_lastseen 1000 5
			OnChickenRun(3.0f);
		}

		if (!CanSee("enemy"))
			return;

		if (RangeTo(ENT_LASTSEEN) < 100.0f)
			TOO_CLOSE += 0.1f;

		if (TOO_CLOSE > 5.0f)
		{
			// dbg Too close for too long, backing off
			TOO_CLOSE = 0.0f;
			PURE_FLEE = true;
			OnNpcatkFlee(ENT_LASTSEEN, "600", "5");
		}
	}

	// game_struck
	void BanditHard_OnGameStruck(float damage = 0.0f, string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		PlayRandomSound(2, 5, SOUND_PAIN, SOUND_PAIN2, "none", "none");
	}

	// game_death
	void BanditHard_OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		PlayRandomSound(2, 5, SOUND_DEATH, "none", "none", "none");
		int deathanim = RandomInt(0, 6);
		if (deathanim == 0)
			ANIM_DEATH = "die_simple";
		if (deathanim == 1)
			ANIM_DEATH = "die_backwards1";
		if (deathanim == 2)
			ANIM_DEATH = "die_backwards";
		if (deathanim == 3)
			ANIM_DEATH = "die_forwards";
		if (deathanim == 4)
			ANIM_DEATH = "headshot";
		if (deathanim == 5)
			ANIM_DEATH = "die_spin";
		if (deathanim == 6)
			ANIM_DEATH = "gutshot";
	}

	// game_dodamage
	// 1: Attack Hit (1/0)  2: Entity Attack hit  3:  Start Position  4:  End Position
	string BanditHard_OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";

		// trained archers move if can't hit - thothie
		if (Float(WEAPON) != 0.0f)
			return result;
		if (!hit)
			CHANGE_POSITION += 1.0f;
		// if ( $get(PARAM2,isplayer) == 0 ) add CHANGE_POSITION 1
		if (hit)
		{
			if ((IsPlayer(target) ? 1 : 0) == 1)
				CHANGE_POSITION = -2.0f;
			if (CHANGE_POSITION < -5.0f)
				CHANGE_POSITION = 0.0f;
		}
		return result;
	}

	// game_struck
	void BanditHard_OnGameStruck_2(float damage = 0.0f, string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		// trained archers move if hit
		if (Float(WEAPON) != 0.0f)
			return;
		if (Text(IsPlayer(ENT_LASTSTRUCK)) != Text(CHANGE_POSITION))
			return;
	}

	// npc_targetsighted
	void BanditHard_OnNpcTargetsighted(string target = "")
	{
		// archer
		if (Float(WEAPON) != 0.0f)
			return;
		if (IS_FLEEING)
			return;
		if (!CanSee(target))
			return;
		PlayAnim("once", ANIM_ATTACK);
	}

	// game_death
	void BanditHard_OnGameDeath_2(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		SetSolid("none");
		SetBoundingBox("none");
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
		BanditHard_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4);
		BanditHard_OnGameDeath_2(attacker, extraValue2, extraValue3, extraValue4);
	}

	// game_struck
	void OnGameStruck(float damage = 0.0f, string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		BaseNpc_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseNpcAttack_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc_attack
		BaseMonsterShared_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared
		BanditHard_OnGameStruck(damage, extraValue2, extraValue3, extraValue4);
		BanditHard_OnGameStruck_2(damage, extraValue2, extraValue3, extraValue4);
	}

	// check_attack
	void OnCheckAttack()
	{
		BaseNpcAttack_OnCheckAttack(); // monsters/base_npc_attack
		BanditHard_OnCheckAttack();
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck
		BanditHard_OnNpcSpawn(npc);
	}

	// game_dodamage
	string OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";
		result = AppendResult(result, BaseAntiStuck_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BaseMonsterShared_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BanditHard_OnGameDodamage(hit, target, start, end, damageType, damageText));
		return result;
	}

	// npc_targetsighted
	void OnNpcTargetsighted(string target = "")
	{
		BaseMonsterShared_OnNpcTargetsighted(target); // monsters/base_monster_shared
		BanditHard_OnNpcTargetsighted(target);
	}

	void OnBowey() { BanditHard_OnBowey(); } // bowey
	void OnDaggerey() { BanditHard_OnDaggerey(); } // daggerey
	void OnFistey() { BanditHard_OnFistey(); } // fistey
	void OnSwordey() { BanditHard_OnSwordey(); } // swordey
	void OnAxey() { BanditHard_OnAxey(); } // axey
	void OnMacey() { BanditHard_OnMacey(); } // macey
	void OnAttack() { BanditHard_OnAttack(); } // attack

	// This file's events and timers by their .script names
	bool BanditHard_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "attack") { OnAttack(); return true; }
		if (name == "axey") { OnAxey(); return true; }
		if (name == "bowey") { OnBowey(); return true; }
		if (name == "check_attack") { OnCheckAttack(); return true; }
		if (name == "daggerey") { OnDaggerey(); return true; }
		if (name == "fistey") { OnFistey(); return true; }
		if (name == "game_death") { OnGameDeath(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_dodamage") { Return(OnGameDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5))); return true; }
		if (name == "game_struck") { OnGameStruck(Float(Param(params, 0)), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "macey") { OnMacey(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "npc_targetsighted") { OnNpcTargetsighted(Param(params, 0)); return true; }
		if (name == "swordey") { OnSwordey(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "monsters/bandit_hard"]
shared class BanditHardScript : BaseMonsterScript, BanditHard, BaseAimProj
{
	// Variables declared by included files, with the value they start with in this script
	BanditHardScript()
	{
		SOUND_DEATH = "player/leghit1.wav";
		ANIM_IDLE = "idle";
		ANIM_RUN = "run";
		ANIM_WALK = "walk2";
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("npc/rogue.mdl");
		CallEventDelayed(Float(CYCLE_TIME), "hunting_mode_go");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		BanditHard_FirstThink();
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
		return BanditHard_DispatchEvent(name, params)
			|| BaseAimProj_DispatchEvent(name, params)
			|| BaseMonsterScript::DispatchEvent(name, params);
	}
}
