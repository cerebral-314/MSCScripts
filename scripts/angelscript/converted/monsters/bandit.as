#pragma context server

// Converted from monsters/bandit.script by msc_transpiler.
// This is an older script and may have some bad conventions as a result
// *** Random bandit script ***

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_monster.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class Bandit
{
	// Constants
	string SOUND_PAIN = "player/chesthit1.wav";
	string SOUND_PAIN2 = "player/armhit1.wav";
	string SOUND_DEATH = "player/leghit1.wav";
	string SOUND_BOW = "weapons/bow/bow.wav";
	string RETALIATE_CHANGETARGET_CHANCE = "75%";
	float FIREBALL_FREQ = 5.0f;
	int SPELL_RANGE = 700;
	string ANIM_PREP_SPELL = "prepare_fireball";
	string ANIM_AIM_SPELL = "aim_fireball_R";
	string ANIM_CAST_SPELL = "throw_fireball_R";

	// Variables (an unset .script variable reads as its own name)
	string ANIM_IDLE = "idle";
	string ANIM_RUN = "run";
	string ANIM_WALK = "walk2";
	bool NO_STEP_ADJ = true;
	string CONTAINER_DROP_CHANCE = "CONTAINER_DROP_CHANCE";
	string CONTAINER_SCRIPT = "CONTAINER_SCRIPT";
	string ANIM_DEATH = "ANIM_DEATH";
	string CAN_HUNT = "CAN_HUNT";
	string HUNT_AGRO = "HUNT_AGRO";
	string CAN_ATTACK = "CAN_ATTACK";
	string CAN_RETALIATE = "CAN_RETALIATE";
	string CAN_HEAR = "CAN_HEAR";
	float NPC_GIVE_EXP = 0.0f;
	float ATTACK_HITRANGE = 0.0f;
	float BD_COUNT = 0.0f;
	string WEAPON = "WEAPON";
	int ATTACK_SPEED = 1200;
	string ATTACK1_DAMAGE = "ATTACK1_DAMAGE";
	int ATTACK_COF = 0;
	string MOVE_RANGE = "MOVE_RANGE";
	float ATTACK_RANGE = 0.0f;
	string ANIM_ATTACK = "ANIM_ATTACK";
	int DROPS_CONTAINER = 0;
	string NO_STUCK_CHECKS = "NO_STUCK_CHECKS";
	string ATTACK_PERCENTAGE = "80%";
	string CAN_FLINCH = "CAN_FLINCH";
	float AS_ATTACKING = 0.0f;
	bool FIREBALL_DELAY = false;
	bool CASTING_SPELL = false;
	string SPELL_TARGET = "SPELL_TARGET";
	bool BANDIT_FLEE_DELAY = false;
	CBaseEntity@ ALLY_CHECK_ID = null;
	int ICE_SHIELD_CHECK = 0;
	bool IS_BUFFING = false;

	// unnamed block (first think)
	void Bandit_FirstThink()
	{
		CONTAINER_DROP_CHANCE = "10%";
		CONTAINER_SCRIPT = "chests/quiver_of_random_lesser";
		ANIM_IDLE = "idle";
		ANIM_RUN = "run";
		ANIM_WALK = "walk2";
		ANIM_DEATH = "die_simple";
		CAN_HUNT = "1";
		HUNT_AGRO = "1";
		CAN_ATTACK = "1";
		CAN_RETALIATE = "1";
		CAN_HEAR = "1";
		NPC_GIVE_EXP = 60.0f;
		OnBowey();
		OnFistey();
		OnDaggerey();
		OnSwordey();
		OnAxey();
		OnMacey();
		OnMagey();

		ATTACK_HITRANGE = ATTACK_RANGE * 1.5f;

		NO_STEP_ADJ = true; // seem to be getting stuck on ramps in prelude2
	}

	// npc_spawn
	// Spawn properties
	void Bandit_OnNpcSpawn(string npc = "")
	{
		BD_COUNT = 0.0f;

		if (WEAPON == "WEAPON")
			WEAPON = RandomInt(0, 6);
		SetGold(RandomInt(13, 27));
		// ov			180
		SetWidth(32);
		SetHeight(92);
		SetRace("rogue");
		SetDamageTaken("all", 0.7f);
		SetHearingSensitivity(3);
		SetRoam(true);
		SetModel("npc/rogue.mdl");
		SetIdleAnim(ANIM_IDLE);
		SetMoveAnim(ANIM_WALK);
	}

	// bowey
	void Bandit_OnBowey()
	{
		if (Float(WEAPON) != 0.0f)
			return;
		SetName("Bandit Archer");
		SetHealth(130);
		MOVE_RANGE = "300";
		ATTACK_RANGE = 800.0f;
		ATTACK_SPEED = 1200;
		ATTACK1_DAMAGE = Text(Random(8.5f, 12));
		ATTACK_COF = 0;
		ANIM_ATTACK = "shootbow";
		SetModelBody(1, 5);
		DROPS_CONTAINER = 1;
		NO_STUCK_CHECKS = "1";
	}

	// daggerey
	void Bandit_OnDaggerey()
	{
		if (Float(WEAPON) != 1.0f)
			return;
		SetName("Bandit Rogue");
		SetHealth(130);
		MOVE_RANGE = "50";
		ATTACK_RANGE = 90.0f;
		ATTACK1_DAMAGE = Text(Random(8.5f, 10));
		ATTACK_PERCENTAGE = "80%";
		ANIM_ATTACK = "swordjab1_R";
		SetModelBody(1, 1);
	}

	// fistey
	void Bandit_OnFistey()
	{
		if (Float(WEAPON) != 2.0f)
			return;
		SetName("Bandit Martial Artist");
		SetHealth(160);
		MOVE_RANGE = "50";
		ATTACK_RANGE = 80.0f;
		ATTACK1_DAMAGE = Text(Random(6.5f, 8));
		ATTACK_PERCENTAGE = "80%";
		ANIM_ATTACK = "aim_punch1";
		SetModelBody(1, 0);
	}

	// swordey
	void Bandit_OnSwordey()
	{
		if (Float(WEAPON) != 3.0f)
			return;
		SetName("Bandit Swordsman");
		SetHealth(160);
		MOVE_RANGE = "80";
		ATTACK_RANGE = 120.0f;
		ATTACK1_DAMAGE = Text(Random(8.5f, 10));
		ATTACK_PERCENTAGE = "85%";
		ANIM_ATTACK = "swordswing2_R";
		SetModelBody(1, 4);
	}

	// axey
	void Bandit_OnAxey()
	{
		if (Float(WEAPON) != 4.0f)
			return;
		SetName("Bandit Axeman");
		SetHealth(200);
		MOVE_RANGE = "80";
		ATTACK_RANGE = 120.0f;
		ATTACK1_DAMAGE = Text(Random(9.5f, 11));
		ATTACK_PERCENTAGE = "85%";
		ANIM_ATTACK = "battleaxe_swing1_R";
		SetModelBody(1, 3);
	}

	// macey
	void Bandit_OnMacey()
	{
		if (Float(WEAPON) != 5.0f)
			return;
		SetName("Bandit Berserker");
		SetHealth(200);
		MOVE_RANGE = "80";
		ATTACK_RANGE = 130.0f;
		ATTACK1_DAMAGE = Text(Random(9.5f, 11));
		ATTACK_PERCENTAGE = "85%";
		ANIM_ATTACK = "battleaxe_swing1_R";
		SetModelBody(1, 2);
	}

	// magey
	void Bandit_OnMagey()
	{
		if (Float(WEAPON) != 6.0f)
			return;
		SetName("Bandit Mage");
		SetHealth(100);
		MOVE_RANGE = "300";
		ATTACK_RANGE = 32.0f;
		ATTACK1_DAMAGE = Text(Random(20, 40));
		ATTACK_PERCENTAGE = "85%";
		ANIM_ATTACK = "aim_punch1";
		CAN_FLINCH = "0";
		SetModelBody(1, 0);
		CallEventDelayed(1.0f, "scan_for_allies");
		CatchSpeech("debug_params", "debug");
	}

	// debug_params
	void Bandit_OnDebugParams()
	{
		SetSayTextRange(1024);
		SayText("Mov " + MOVE_RANGE);
	}

	// attack
	void Bandit_OnAttack()
	{
		if (Float(WEAPON) == 0.0f)
		{
			// setvar AIM_ANGLE game.monster.last_seen.distance	//Aim up a bit
			// divide AIM_ANGLE GEXT_ADJ1
			SetAngle("add_view.pitch", 5); // fires in such a shallow arc, no need to adj based on distance
			AS_ATTACKING = GameTime();

			// <projectile scriptname> <"view"|(src_origin)> <target|(targ_origin)|none> <speed> <damage> <cof> <skill|none> //Converted to use new tossprojectile //greatguys1@FEB2022
			TossProjectile("proj_arrow_npc", RelativePosition(Vector3(0, 0, 2)), "none", ATTACK_SPEED, ATTACK1_DAMAGE, ATTACK_COF, "none");
			CallExternal(EntityOf(ENT_LASTPROJECTILE), "ext_lighten", 0.4f); // helps aim - thothie
			PlaySound(2, 10, SOUND_BOW);
		}
		else
		{
			DoDamage(NPCATK_TARGET, ATTACK_HITRANGE, ATTACK1_DAMAGE, ATTACK_PERCENTAGE);
		}
	}

	// attack_jab
	void Bandit_OnAttackJab()
	{
		OnAttack();
	}

	// game_struck
	void Bandit_OnGameStruck(float damage = 0.0f, string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		PlayRandomSound(2, 5, SOUND_PAIN, SOUND_PAIN2, "none", "none");
	}

	// game_death
	void Bandit_OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
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

	// npc_targetsighted
	void Bandit_OnNpcTargetsighted(string target = "")
	{
		// archer
		if (Float(WEAPON) == 0.0f && !IS_FLEEING && CanSee(target))
			PlayAnim("once", ANIM_ATTACK);

		if (Float(WEAPON) == 6.0f && !IS_FLEEING && !FIREBALL_DELAY && !CASTING_SPELL && !IS_BUFFING)
		{
			FIREBALL_DELAY = true;
			CallEventDelayed(FIREBALL_FREQ, "reset_fireball_delay");
			if (Truthy(LegacyFunction("cansee", "enemy", SPELL_RANGE)))
			{
				CBaseEntity@ spellTarget = EntityOf(ENT_LASTSEEN);
				OnSpellAttack(spellTarget);
				CASTING_SPELL = true;
			}
		}
	}

	// reset_fireball_delay
	void Bandit_OnResetFireballDelay()
	{
		FIREBALL_DELAY = false;
	}

	// spell_attack
	// param1 = targ
	void Bandit_OnSpellAttack(CBaseEntity@ target = null)
	{
		AS_ATTACKING = GameTime();
		PlaySound(0, 10, "magic/fireball_powerup.wav");
		SPELL_TARGET = EntityId(target);
		SetMoveDest(SPELL_TARGET, 9999);
		PlayAnim("once", ANIM_PREP_SPELL);
		CallEventDelayed(0.5f, "spell_attack2");
	}

	// spell_attack2
	void Bandit_OnSpellAttack2()
	{
		SetMoveDest(SPELL_TARGET, 9999);
		PlayAnim("critical", ANIM_AIM_SPELL);
		CallEventDelayed(0.5f, "spell_attack3");
	}

	// spell_attack3
	void Bandit_OnSpellAttack3()
	{
		SetMoveDest(SPELL_TARGET, 9999);
		Vector3 targOrg = OriginOf(SPELL_TARGET);
		SetAngle("face_origin", targOrg);
		CallEventDelayed(0.1f, "straighten_out");

		PlaySound(0, 10, "magic/fireball_strike.wav");

		PlayAnim("critical", ANIM_CAST_SPELL);

		// <projectile scriptname> <"view"|(src_origin)> <target|(targ_origin)|none> <speed> <damage> <cof> <skill|none> //Converted to use new tossprojectile //greatguys1@FEB2022
		TossProjectile("proj_fire_dart", RelativePosition(Vector3(0, 48, 2)), SPELL_TARGET, 400, ATTACK1_DAMAGE, 5, "none");
		CallExternal(EntityOf(ENT_LASTPROJECTILE), "ext_lighten", 0);
		CASTING_SPELL = false;
	}

	// straighten_out
	void Bandit_OnStraightenOut()
	{
		Vector3 myAng = MyAngles();
		float myYaw = Vec(SPELL_TARGET).y;
		SetAngle("face", Vector3(0, myYaw, 0));
		CallEventDelayed(1.0f, "mage_reposition");
	}

	// mage_reposition
	void Bandit_OnMageReposition()
	{
		if (RangeTo(HUNT_LASTTARGET) < SPELL_RANGE)
			OnNpcatkFlee(EntityId(EntityOf(HUNT_LASTTARGET)), "700", "1.0");
		if (RangeTo(HUNT_LASTTARGET) >= Float(MOVE_RANGE))
			OnChickenRun(1.0f);
	}

	// game_struck
	void Bandit_OnGameStruck_2(float damage = 0.0f, string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		if (Float(WEAPON) == 6.0f && !BANDIT_FLEE_DELAY)
		{
			BANDIT_FLEE_DELAY = true;
			CallEventDelayed(10.0f, "reset_bandit_flee_delay");
			OnNpcatkFlee(EntityId(EntityOf(ENT_LASTSTRUCK)), "2000", "5.0");
		}
	}

	// reset_bandit_flee_delay
	void Bandit_OnResetBanditFleeDelay()
	{
		BANDIT_FLEE_DELAY = false;
	}

	// npcatk_ally_alert
	// param1 attacker, param2 ally under attack
	void Bandit_OnNpcatkAllyAlert(string attacker = "", CBaseEntity@ allyToAid = null)
	{
		if (SUSPEND_AI)
			return;

		if (IsPlayer(attacker))
			OnCycleUp("ally_hit_by_player");

		if (allyToAid is self)
			return;

		if (Float(WEAPON) != 6.0f)
			return;
		if (IS_BUFFING)
			return;
		if (!(RangeTo(allyToAid) < SPELL_RANGE))
			return;
		// if $get(PARAM2,scriptvar,ICE_SHIELDED) != 1 //this wont work because both monsters have ICE_SHIELDED in their vars (externals)
		@ALLY_CHECK_ID = allyToAid;
		OnCheckCanShield();
	}

	// check_can_shield
	void Bandit_OnCheckCanShield()
	{
		if (IS_BUFFING)
			return;
		if (!CYCLED_UP)
			return;
		if (RaceOf(ALLY_CHECK_ID) != RaceOf(ENT_ME)) // switched from ally, as he'd shield beloveds and such
			return;
		ICE_SHIELD_CHECK = (HasEffect(ALLY_CHECK_ID, "iceshield") ? 1 : 0);
		CallEventDelayed(0.1f, "check_can_shield2");
	}

	// check_can_shield2
	void Bandit_OnCheckCanShield2()
	{
		AS_ATTACKING = GameTime();

		if (ICE_SHIELD_CHECK == 1)
			return;
		// yes, I can shield this guy
		IS_BUFFING = true;
		PlayAnim("critical", ANIM_PREP_SPELL);
		SetMoveDest(@ALLY_CHECK_ID, 64);
		OnNpcatkSuspendAi("1.0");
		CallEventDelayed(0.1f, "shield_ally");
	}

	// shield_ally
	void Bandit_OnShieldAlly()
	{
		if (!CanSee(EntityId(ALLY_CHECK_ID)))
			IS_BUFFING = false;
		if (!CanSee(EntityId(ALLY_CHECK_ID)))
			return;

		CallEventDelayed(0.5f, "cast_shield");
	}

	// cast_shield
	void Bandit_OnCastShield()
	{
		IS_BUFFING = false;
		PlaySound(0, 10, "magic/cast.wav");
		ApplyEffect(ALLY_CHECK_ID, "effects/iceshield", 20, self, 0.5f);
	}

	// scan_for_allies
	void Bandit_OnScanForAllies()
	{
		CallEventDelayed(0.7f, "scan_for_allies");
		if (!CanSee("ally"))
			return;
		@ALLY_CHECK_ID = EntityOf(ENT_LASTSEEN);
		OnCheckCanShield();
	}

	// unnamed block (timer)
	void Bandit_Timer()
	{
		CallEventDelayed(2.0f, "Bandit_Timer");

		// something in this script is causing BD periodically
		// prevention measure/hack
		if (SUSPEND_AI)
			BD_COUNT += 1.0f;
		if (!SUSPEND_AI)
			BD_COUNT = 0.0f;
		if (BD_COUNT > 10.0f)
			OnNpcatkResumeAi();
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
		Bandit_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4);
	}

	// game_struck
	void OnGameStruck(float damage = 0.0f, string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		BaseNpc_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseNpcAttack_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc_attack
		BaseMonsterShared_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared
		Bandit_OnGameStruck(damage, extraValue2, extraValue3, extraValue4);
		Bandit_OnGameStruck_2(damage, extraValue2, extraValue3, extraValue4);
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck
		Bandit_OnNpcSpawn(npc);
	}

	// npcatk_ally_alert
	void OnNpcatkAllyAlert(string attacker = "", CBaseEntity@ allyToAid = null)
	{
		BaseMonsterShared_OnNpcatkAllyAlert(attacker, allyToAid); // monsters/base_monster_shared
		Bandit_OnNpcatkAllyAlert(attacker, allyToAid);
	}

	// npc_targetsighted
	void OnNpcTargetsighted(string target = "")
	{
		BaseMonsterShared_OnNpcTargetsighted(target); // monsters/base_monster_shared
		Bandit_OnNpcTargetsighted(target);
	}

	void OnBowey() { Bandit_OnBowey(); } // bowey
	void OnDaggerey() { Bandit_OnDaggerey(); } // daggerey
	void OnFistey() { Bandit_OnFistey(); } // fistey
	void OnSwordey() { Bandit_OnSwordey(); } // swordey
	void OnAxey() { Bandit_OnAxey(); } // axey
	void OnMacey() { Bandit_OnMacey(); } // macey
	void OnMagey() { Bandit_OnMagey(); } // magey
	void OnDebugParams() { Bandit_OnDebugParams(); } // debug_params
	void OnAttack() { Bandit_OnAttack(); } // attack
	void OnAttackJab() { Bandit_OnAttackJab(); } // attack_jab
	void OnResetFireballDelay() { Bandit_OnResetFireballDelay(); } // reset_fireball_delay
	void OnSpellAttack(CBaseEntity@ target = null) { Bandit_OnSpellAttack(target); } // spell_attack
	void OnSpellAttack2() { Bandit_OnSpellAttack2(); } // spell_attack2
	void OnSpellAttack3() { Bandit_OnSpellAttack3(); } // spell_attack3
	void OnStraightenOut() { Bandit_OnStraightenOut(); } // straighten_out
	void OnMageReposition() { Bandit_OnMageReposition(); } // mage_reposition
	void OnResetBanditFleeDelay() { Bandit_OnResetBanditFleeDelay(); } // reset_bandit_flee_delay
	void OnCheckCanShield() { Bandit_OnCheckCanShield(); } // check_can_shield
	void OnCheckCanShield2() { Bandit_OnCheckCanShield2(); } // check_can_shield2
	void OnShieldAlly() { Bandit_OnShieldAlly(); } // shield_ally
	void OnCastShield() { Bandit_OnCastShield(); } // cast_shield
	void OnScanForAllies() { Bandit_OnScanForAllies(); } // scan_for_allies
	void OnFireballFreq() {} // FIREBALL_FREQ

	// This file's events and timers by their .script names
	bool Bandit_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "attack") { OnAttack(); return true; }
		if (name == "attack_jab") { OnAttackJab(); return true; }
		if (name == "axey") { OnAxey(); return true; }
		if (name == "bowey") { OnBowey(); return true; }
		if (name == "cast_shield") { OnCastShield(); return true; }
		if (name == "check_can_shield") { OnCheckCanShield(); return true; }
		if (name == "check_can_shield2") { OnCheckCanShield2(); return true; }
		if (name == "daggerey") { OnDaggerey(); return true; }
		if (name == "debug_params") { OnDebugParams(); return true; }
		if (name == "fistey") { OnFistey(); return true; }
		if (name == "game_death") { OnGameDeath(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_struck") { OnGameStruck(Float(Param(params, 0)), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "macey") { OnMacey(); return true; }
		if (name == "mage_reposition") { OnMageReposition(); return true; }
		if (name == "magey") { OnMagey(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "npc_targetsighted") { OnNpcTargetsighted(Param(params, 0)); return true; }
		if (name == "npcatk_ally_alert") { OnNpcatkAllyAlert(Param(params, 0), EntityParam(params, 1)); return true; }
		if (name == "reset_bandit_flee_delay") { OnResetBanditFleeDelay(); return true; }
		if (name == "reset_fireball_delay") { OnResetFireballDelay(); return true; }
		if (name == "scan_for_allies") { OnScanForAllies(); return true; }
		if (name == "shield_ally") { OnShieldAlly(); return true; }
		if (name == "spell_attack") { OnSpellAttack(EntityParam(params, 0)); return true; }
		if (name == "spell_attack2") { OnSpellAttack2(); return true; }
		if (name == "spell_attack3") { OnSpellAttack3(); return true; }
		if (name == "straighten_out") { OnStraightenOut(); return true; }
		if (name == "swordey") { OnSwordey(); return true; }
		if (name == "Bandit_Timer") { Bandit_Timer(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "monsters/bandit"]
shared class BanditScript : BaseMonsterScript, Bandit
{
	// Variables declared by included files, with the value they start with in this script
	BanditScript()
	{
		SOUND_DEATH = "player/leghit1.wav";
		ANIM_IDLE = "idle";
		ANIM_RUN = "run";
		ANIM_WALK = "walk2";
		NO_STEP_ADJ = true;
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("npc/rogue.mdl");
		CallEventDelayed(2.0f, "Bandit_Timer");
		CallEventDelayed(Float(CYCLE_TIME), "hunting_mode_go");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		Bandit_FirstThink();
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
		return Bandit_DispatchEvent(name, params)
			|| BaseMonsterScript::DispatchEvent(name, params);
	}
}
