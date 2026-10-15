#pragma context server

// Converted from monsters/bgoblin.script by msc_transpiler.
// Blood goblin fodder by Thothie
// Weakest of the blood goblins
// generic randomized high-end goblin with random weapon
// All the bgoblins and vgoblins use this as their base, hence its complexity
// In addition the hobgoblin_ scripts use this base their base
// The old goblin_ scripts, however, still use their original configurations, and do not share this script

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_monster_new.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class Bgoblin
{
	// Constants
	string FLINCH_CHANCE = "25%";
	string ANIM_SMASH = "battleaxe_swing1_L";
	string ANIM_SWIPE = "swordswing1_L";
	string ANIM_WARCRY = "warcry";
	string ANIM_KICK = "kick";
	string ANIM_BOW = "shootorcbow";
	int DMG_CLUB = 0;
	float DMG_AXE = 0.0f;
	float DMG_SWORD = 0.0f;
	int GOB_TYPE = 0;
	int GOBLIN_JUMPRANGE = 512;
	int DMG_FIREBALL = 50;
	int DMG_FIREBALL_DOT = 10;
	float FREQ_FIREBALL = 0.0f;
	bool GOB_JUMPER = true;
	string ANIM_PARRY = "deflectcounter";
	int CHARGE_SPEED = 600;
	float FREQ_CHARGE = 5.0f;
	bool GOB_CHARGER = true;
	int GOB_CHARGE_MIN_DIST = 96;
	int GOB_CHARGE_MAX_DIST = 256;
	int MIN_FIREBALL_DIST = 96;
	bool NEW_MODEL = true;
	string SOUND_STRUCK1 = "body/flesh1.wav";
	string SOUND_STRUCK2 = "body/flesh2.wav";
	string SOUND_STRUCK3 = "body/flesh3.wav";
	string SOUND_PAIN1 = "monsters/goblin/c_gargoyle_hit1.wav";
	string SOUND_PAIN2 = "monsters/goblin/c_gargoyle_hit2.wav";
	string SOUND_ALERT1 = "monsters/goblin/c_goblin_bat1.wav";
	string SOUND_ALERT2 = "monsters/goblin/c_goblin_bat2.wav";
	string SOUND_IDLE = "monsters/goblin/c_goblin_slct.wav";
	string SOUND_ATTACK1 = "monsters/goblin/c_goblin_atk1.wav";
	string SOUND_ATTACK2 = "monsters/goblin/c_goblin_atk2.wav";
	string SOUND_ATTACK3 = "monsters/goblin/c_goblin_atk3.wav";
	string SOUND_FIREBALL_CAST = "monsters/goblin/c_gargoyle_slct.wav";
	string SOUND_FIREBALL = "magic/fireball_strike.wav";
	string SOUND_JUMP1 = "monsters/goblin/c_goblin_hit1.wav";
	string SOUND_JUMP2 = "monsters/goblin/c_goblin_hit2.wav";
	string SOUND_PARRY1 = "body/armour1.wav";
	string SOUND_PARRY2 = "body/armour2.wav";
	string SOUND_PARRY3 = "body/armour3.wav";
	string SOUND_CHIEF_ALERT = "monsters/goblin/c_goblinchf_bat1.wav";
	string SOUND_SHAM_ALERT = "monsters/goblin/c_goblinwiz_bat1.wav";
	string SOUND_DEATH = "monsters/goblin/c_goblin_dead.wav";

	// Variables (an unset .script variable reads as its own name)
	string ANIM_WALK = "walk";
	string ANIM_IDLE = "idle1";
	string ANIM_RUN = "run";
	float ATTACK_RANGE = 0.0f;
	float ATTACK_HITRANGE = 0.0f;
	float ATTACK_MOVERANGE = 0.0f;
	string MOVE_RANGE = "MOVE_RANGE";
	float NPC_GIVE_EXP = 0.0f;
	int DROP_GOLD = 0;
	float DROP_GOLD_AMT = 0.0f;
	float NPC_ALLY_RESPONSE_RANGE = 0.0f;
	string ANIM_DEATH = "ANIM_DEATH";
	string CAN_FLINCH = "CAN_FLINCH";
	string FLINCH_ANIM = "FLINCH_ANIM";
	float FLINCH_HEALTH = 0.0f;
	bool GOB_TYPE_SET = false;
	string F_GOB_TYPE = "F_GOB_TYPE";
	string ANIM_ATTACK = "ANIM_ATTACK";
	string ATTACK_HITCHANCE = "ATTACK_HITCHANCE";
	bool CAN_STUN = false;
	bool CAN_FIREBALL = false;
	bool TOSS_FIREBALL = false;
	float NEXT_FIREBALL = 0.0f;
	float AS_ATTACKING = 0.0f;
	float NEXT_LEAP = 0.0f;
	string STUN_LIST = "STUN_LIST";
	bool GOB_JUMP_SCANNING = false;
	bool DBL_JUMP = false;

	// unnamed block (first think)
	void Bgoblin_FirstThink()
	{
		// base
		ANIM_WALK = "walk";
		ANIM_IDLE = "idle1";
		ANIM_RUN = "run";
		ATTACK_RANGE = 64.0f;
		ATTACK_HITRANGE = 80.0f;
		ATTACK_MOVERANGE = 48.0f;
		MOVE_RANGE = "48";
		NPC_GIVE_EXP = 200.0f;
		DROP_GOLD = 1;
		DROP_GOLD_AMT = RandomInt(10, 15);
		NPC_ALLY_RESPONSE_RANGE = 4096.0f;
		ANIM_DEATH = "die_fallback";
		CAN_FLINCH = "1";
		FLINCH_ANIM = "flinch";
		FLINCH_HEALTH = 100.0f;
	}

	// npc_spawn
	void Bgoblin_OnNpcSpawn(string npc = "")
	{
		OnGoblinSpawn();
		CallEventDelayed(1.0f, "idle_mode");
		CallEventDelayed(0.01f, "goblin_pre_spawn"); // use to reset setvard props handled by post_spawn
	}

	// goblin_pre_spawn
	// not required in this script, but here to stop console spam
	void Bgoblin_OnGoblinPreSpawn()
	{
		ATTACK_RANGE = 64.0f;
		ATTACK_HITRANGE = 80.0f;
		ATTACK_MOVERANGE = 48.0f;
		MOVE_RANGE = "48";
	}

	// goblin_spawn
	void Bgoblin_OnGoblinSpawn()
	{
		SetName("Blood Goblin");
		if (!NEW_MODEL)
		{
			SetModel("monsters/goblin2.mdl");
			SetWidth(32);
			SetHeight(60);
		}
		else
		{
			SetModel("monsters/goblin_new.mdl");
			SetWidth(24);
			SetHeight(50);
		}

		SetRace("goblin");
		SetBlood("red"); // green for v_goblin
		SetHealth(500);

		SetRoam(true);

		SetHearingSensitivity(2);

		if (!NEW_MODEL)
		{
			SetModelBody(0, 0); // body: 0-Bare 1-Archer 2-Armor 3-Sniper
			SetModelBody(1, 4); // head: 0-Horns 1-Spikes 2-Animal 3-Chief 4-Cowl
			SetModelBody(2, 0); // weapon: 0-Unarmed 1-Axe 2-wbow 3-sbow 4-sword 5-rAxe 6-sword&shield 7-club 8-knife
			SetModelBody(3, 0); // arrow: on/off

			SetProp(ENT_ME, "skin", 2);
		}
		else
		{
			SetModelBody(0, 0); // body: 0-Bare 1-Quiver&Strap
			SetModelBody(1, 0); // head: 0-Bare 1-Horns 2-Animal 3-Chief 4-Rag
			SetModelBody(2, 0); // weapon: 0-Unarmed 1-Axe 2-wbow 3-sbow 4-sword 5-rAxe 6-sword&shield 7-club 8-knife
			SetModelBody(3, 0); // arrow: On/off

			SetProp(ENT_ME, "skin", 1); // 0-norm 1-blood 2-vile
		}

		SetIdleAnim(ANIM_IDLE);
		SetMoveAnim(ANIM_WALK);

		SetDamageTaken("fire", 0.5f); // blood goblins only
		SetDamageTaken("cold", 1.25f);

		if (F_GOB_TYPE != "F_GOB_TYPE")
			return;
		CallEventDelayed(0.01f, "goblin_set_weapon");
	}

	// goblin_set_weapon
	void Bgoblin_OnGoblinSetWeapon(string weaponType = "")
	{
		float myHp = 0.0f;

		if (GOB_TYPE_SET)
			return;
		GOB_TYPE_SET = true;

		if (weaponType.isEmpty())
			F_GOB_TYPE = GOB_TYPE;
		else
			F_GOB_TYPE = weaponType;

		if (Float(F_GOB_TYPE) == 1.0f)
		{
			// clubber
			SetModelBody(0, 0);
			SetModelBody(2, 7);
			ANIM_ATTACK = ANIM_SMASH;
			ATTACK_HITCHANCE = "75%";
			myHp = HealthOf(ENT_ME) * 1.5f;
			SetHealth(myHp);
			CAN_STUN = false; // only guards stun
		}

		if (Float(F_GOB_TYPE) == 2.0f)
		{
			// axe
			SetModelBody(0, 0);
			SetModelBody(2, 1);
			ANIM_ATTACK = ANIM_SMASH;
			ATTACK_HITCHANCE = "80%";
			myHp = HealthOf(ENT_ME) * 1.25f;
			SetHealth(myHp);
			CAN_STUN = false;
		}

		if (Float(F_GOB_TYPE) == 3.0f)
		{
			// sword
			CAN_FIREBALL = true;
			SetModelBody(0, 1);
			SetModelBody(2, 4);
			ANIM_ATTACK = ANIM_SWIPE;
			ATTACK_HITCHANCE = "90%";
			CAN_STUN = false;
		}
	}

	// swing_axe
	// ANIM_SMASH
	void Bgoblin_OnSwingAxe()
	{
		PlayRandomSound(0, 10, SOUND_ATTACK1, SOUND_ATTACK2, SOUND_ATTACK3);
		if (Float(F_GOB_TYPE) == 1.0f)
			DoDamageEx(NPCATK_TARGET, ATTACK_HITRANGE, DMG_CLUB, ATTACK_HITCHANCE, ENT_ME, ENT_ME, "none", "blunt", "dmgevent:swing");
		if (Float(F_GOB_TYPE) == 2.0f)
			DoDamageEx(NPCATK_TARGET, ATTACK_HITRANGE, DMG_AXE, ATTACK_HITCHANCE, ENT_ME, ENT_ME, "slash", "dmgevent:swing");
	}

	// swing_sword
	// ANIM_SWIPE
	void Bgoblin_OnSwingSword()
	{
		if (TOSS_FIREBALL)
			OnTossFireball();
		if (TOSS_FIREBALL)
			return;
		PlayRandomSound(0, 10, SOUND_ATTACK1, SOUND_ATTACK2, SOUND_ATTACK3);
		DoDamageEx(NPCATK_TARGET, ATTACK_HITRANGE, DMG_SWORD, ATTACK_HITCHANCE, ENT_ME, ENT_ME, "slash", "dmgevent:swing");
	}

	// toss_fireball
	void Bgoblin_OnTossFireball()
	{
		TOSS_FIREBALL = false;

		// <projectile scriptname> <"view"|(src_origin)> <target|(targ_origin)|none> <speed> <damage> <cof> <skill|none> //Converted to use new tossprojectile //greatguys1@FEB2022
		TossProjectile("proj_fire_ball", RelativePosition(Vector3(0, 48, 0)), NPCATK_TARGET, 400, DMG_FIREBALL, 0.5f, "none");
		CallExternal(ENT_LASTPROJECTILE, "lighten", DMG_FIREBALL_DOT, 0.01f);
		PlaySound(0, 10, SOUND_FIREBALL);
	}

	// npcatk_hunt
	void Bgoblin_OnNpcatkHunt()
	{
		OnGobHunt();
	}

	// gob_hunt
	void Bgoblin_OnGobHunt()
	{
		if (!IsAlive(NPCATK_TARGET))
			return;
		if (SUSPEND_AI)
			return;
		if (I_R_FROZEN)
			return;

		if (CAN_FIREBALL && !IS_FLEEING && GameTime() > NEXT_FIREBALL)
			OnPrepFireball();

		if (!GOB_CHARGER)
			return;
		if (!(GameTime() > NEXT_LEAP))
			return;

		if (!(RangeTo(NPCATK_TARGET) > GOB_CHARGE_MIN_DIST))
			return;
		if (!(RangeTo(NPCATK_TARGET) < GOB_CHARGE_MAX_DIST))
			return;
		if (I_R_FROZEN)
			return;

		OnLeapForward();
	}

	// prep_fireball
	void Bgoblin_OnPrepFireball()
	{
		if (!(RangeTo(NPCATK_TARGET) > MIN_FIREBALL_DIST))
			return;
		if (!CanSee(NPCATK_TARGET))
			return;
		NEXT_FIREBALL = GameTime() + FREQ_FIREBALL;
		TOSS_FIREBALL = true;
		PlayAnim("critical", ANIM_SWIPE);
		PlaySound(0, 10, SOUND_FIREBALL_CAST);
		AS_ATTACKING = GameTime() + 10.0f;
	}

	// leap_forward
	void Bgoblin_OnLeapForward()
	{
		NEXT_LEAP = GameTime() + FREQ_CHARGE;
		PlayRandomSound(0, 10, SOUND_JUMP1, SOUND_JUMP2);
		PlayAnim("critical", ANIM_SMASH);
		AddVelocity(ENT_ME, RelativeVelocity(Vector3(0, CHARGE_SPEED, 100)));
		CallEventDelayed(0.5f, "leap_stun");
	}

	// leap_stun
	void Bgoblin_OnLeapStun()
	{
		STUN_LIST = LegacyFunction("get_tsphere", "enemy", 64, MyOrigin());
		if (STUN_LIST == "none")
			return;
		int count = GetTokenCount(STUN_LIST);
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnStunTargets();
		}
	}

	// stun_targets
	void Bgoblin_OnStunTargets()
	{
		CBaseEntity@ curTarget = FindEntity(GetToken(STUN_LIST, loopIteration));
		AddVelocity(curTarget, RelativeVelocity(Vector3(0, 200, 120)));
		if (CAN_STUN)
			ApplyEffect(curTarget, "effects/debuff_stun", 3.0f, self);
	}

	// cycle_up
	void Bgoblin_OnCycleUp(string reason = "")
	{
		OnGobCycleUp();
	}

	// gob_cycle_up
	void Bgoblin_OnGobCycleUp()
	{
		// delay first fireball
		NEXT_FIREBALL = GameTime() + Random(10, 30);

		if (GOB_JUMP_SCANNING)
			return;
		GOB_JUMP_SCANNING = true;
		PlayRandomSound(0, 10, SOUND_ALERT1, SOUND_ALERT2);
		OnGobJumpCheck();
	}

	// cycle_down
	void Bgoblin_OnCycleDown()
	{
		GOB_JUMP_SCANNING = false;
		SetMoveAnim(ANIM_WALK);
		CallEventDelayed(1.0f, "idle_mode");
	}

	// gob_jump_check
	void Bgoblin_OnGobJumpCheck()
	{
		if (!GOB_JUMPER)
			return;
		if (!GOB_JUMP_SCANNING)
			return;

		float gobHopDelay = Random(2, 4);

		CallEventDelayed(gobHopDelay, "gob_jump_check");

		if (NPCATK_TARGET == "unset")
			return;
		if (I_R_FROZEN)
			return;
		if (IS_FLEEING)
			return;
		if (SUSPEND_AI)
			return;
		if (!(RangeTo(NPCATK_TARGET) < GOBLIN_JUMPRANGE))
			return;

		// jump at target if he's higher than I am
		Vector3 mePos = MyOrigin();
		float myZ = mePos.z;
		Vector3 targetPos = OriginOf(NPCATK_TARGET);
		float targetZ = targetPos.z;
		float targetZDifference = targetZ - myZ;

		if (targetZDifference > 0.0f)
		{
			if (targetZDifference < 500.0f) // not hoplessly high up
			{
				PlayAnim("critical", ANIM_SMASH);
				CallEventDelayed(0.1f, "gob_hop");
			}
		}
	}

	// gob_hop
	void Bgoblin_OnGobHop()
	{
		PlayRandomSound(0, 10, SOUND_JUMP1, SOUND_JUMP2);
		float jumpHeight = RandomInt(350, 550);
		if (DBL_JUMP)
		{
			jumpHeight *= 2.0f;
			DBL_JUMP = false;
		}
		AddVelocity(ENT_ME, RelativeVelocity(Vector3(0, 250, jumpHeight)));
	}

	// game_death
	void Bgoblin_OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		SetModelBody(2, 0);
	}

	// idle_mode
	void Bgoblin_OnIdleMode()
	{
		if (NPCATK_TARGET != "unset")
			return;
		if (!CanSee("ally"))
			return;
		SetMoveDest(ENT_LASTSEEN, 9999);
		PlayAnim("once", ANIM_WARCRY);
		PlaySound(0, 10, SOUND_IDLE);
		CallEventDelayed(Random(10, 20), "idle_mode");
		CallExternal(ENT_LASTSEEN, "ext_faceme", self);
	}

	// ext_faceme
	void Bgoblin_OnExtFaceme(CBaseEntity@ target = null)
	{
		if (NPCATK_TARGET != "unset")
			return;
		SetMoveDest(@target, 9999);
		CallEventDelayed(0.1f, "reply_anim");
	}

	// reply_anim
	void Bgoblin_OnReplyAnim()
	{
		PlayAnim("once", ANIM_WARCRY);
	}

	// game_struck
	void Bgoblin_OnGameStruck(float damage = 0.0f, string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		PlayRandomSound(0, 5, SOUND_STRUCK1, SOUND_STRUCK2, SOUND_STRUCK3, SOUND_STRUCK1, SOUND_STRUCK2, SOUND_STRUCK3, SOUND_PAIN1, SOUND_PAIN2);
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
		Bgoblin_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4);
	}

	// game_struck
	void OnGameStruck(float damage = 0.0f, string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		BaseNpc_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseNpcAttackNew_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc_attack_new
		BaseMonsterShared_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared
		Bgoblin_OnGameStruck(damage, extraValue2, extraValue3, extraValue4);
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseNpcAttackNew_OnNpcSpawn(npc); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck
		Bgoblin_OnNpcSpawn(npc);
	}

	// npcatk_hunt
	void OnNpcatkHunt()
	{
		BaseNpcAttackNew_OnNpcatkHunt(); // monsters/base_npc_attack_new
		BaseAntiStuck_OnNpcatkHunt(); // monsters/base_anti_stuck
		Bgoblin_OnNpcatkHunt();
	}

	// cycle_up
	void OnCycleUp(string reason = "")
	{
		BaseNpcAttackNew_OnCycleUp(reason); // monsters/base_npc_attack_new
		Bgoblin_OnCycleUp(reason);
	}

	// cycle_down
	void OnCycleDown()
	{
		BaseNpcAttackNew_OnCycleDown(); // monsters/base_npc_attack_new
		BaseMonsterShared_OnCycleDown(); // monsters/base_monster_shared
		BaseMonsterShared_OnCycleDown_2(); // monsters/base_monster_shared
		Bgoblin_OnCycleDown();
	}

	void OnGoblinPreSpawn() { Bgoblin_OnGoblinPreSpawn(); } // goblin_pre_spawn
	void OnGoblinSpawn() { Bgoblin_OnGoblinSpawn(); } // goblin_spawn
	void OnGoblinSetWeapon(string weaponType = "") { Bgoblin_OnGoblinSetWeapon(weaponType); } // goblin_set_weapon
	void OnSwingAxe() { Bgoblin_OnSwingAxe(); } // swing_axe
	void OnSwingSword() { Bgoblin_OnSwingSword(); } // swing_sword
	void OnTossFireball() { Bgoblin_OnTossFireball(); } // toss_fireball
	void OnGobHunt() { Bgoblin_OnGobHunt(); } // gob_hunt
	void OnPrepFireball() { Bgoblin_OnPrepFireball(); } // prep_fireball
	void OnLeapForward() { Bgoblin_OnLeapForward(); } // leap_forward
	void OnLeapStun() { Bgoblin_OnLeapStun(); } // leap_stun
	void OnStunTargets() { Bgoblin_OnStunTargets(); } // stun_targets
	void OnGobCycleUp() { Bgoblin_OnGobCycleUp(); } // gob_cycle_up
	void OnGobJumpCheck() { Bgoblin_OnGobJumpCheck(); } // gob_jump_check
	void OnGobHop() { Bgoblin_OnGobHop(); } // gob_hop
	void OnIdleMode() { Bgoblin_OnIdleMode(); } // idle_mode
	void OnExtFaceme(CBaseEntity@ target = null) { Bgoblin_OnExtFaceme(target); } // ext_faceme
	void OnReplyAnim() { Bgoblin_OnReplyAnim(); } // reply_anim
	void OnGobHopDelay() {} // GOB_HOP_DELAY

	// This file's events and timers by their .script names
	bool Bgoblin_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "cycle_down") { OnCycleDown(); return true; }
		if (name == "cycle_up") { OnCycleUp(Param(params, 0)); return true; }
		if (name == "ext_faceme") { OnExtFaceme(EntityParam(params, 0)); return true; }
		if (name == "game_death") { OnGameDeath(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_struck") { OnGameStruck(Float(Param(params, 0)), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "gob_cycle_up") { OnGobCycleUp(); return true; }
		if (name == "gob_hop") { OnGobHop(); return true; }
		if (name == "gob_hunt") { OnGobHunt(); return true; }
		if (name == "gob_jump_check") { OnGobJumpCheck(); return true; }
		if (name == "goblin_pre_spawn") { OnGoblinPreSpawn(); return true; }
		if (name == "goblin_set_weapon") { OnGoblinSetWeapon(Param(params, 0)); return true; }
		if (name == "goblin_spawn") { OnGoblinSpawn(); return true; }
		if (name == "idle_mode") { OnIdleMode(); return true; }
		if (name == "leap_forward") { OnLeapForward(); return true; }
		if (name == "leap_stun") { OnLeapStun(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "npcatk_hunt") { OnNpcatkHunt(); return true; }
		if (name == "prep_fireball") { OnPrepFireball(); return true; }
		if (name == "reply_anim") { OnReplyAnim(); return true; }
		if (name == "stun_targets") { OnStunTargets(); return true; }
		if (name == "swing_axe") { OnSwingAxe(); return true; }
		if (name == "swing_sword") { OnSwingSword(); return true; }
		if (name == "toss_fireball") { OnTossFireball(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "monsters/bgoblin"]
shared class BgoblinScript : BaseMonsterNewScript, Bgoblin
{
	// Variables every script that includes this file declares
	string NPC_BASE_EXP = "NPC_BASE_EXP";

	// Variables declared by included files, with the value they start with in this script
	BgoblinScript()
	{
		ANIM_WALK = "walk";
		ANIM_IDLE = "idle1";
		ANIM_RUN = "run";
		SOUND_DEATH = "monsters/goblin/c_goblin_dead.wav";
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/goblin2.mdl");
		Precache("monsters/goblin_new.mdl");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		Bgoblin_FirstThink();
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
		return Bgoblin_DispatchEvent(name, params)
			|| BaseMonsterNewScript::DispatchEvent(name, params);
	}
}
