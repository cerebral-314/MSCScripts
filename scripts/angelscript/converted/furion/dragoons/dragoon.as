#pragma context server

// Converted from furion/dragoons/dragoon.script by msc_transpiler.
// Elemental Dragoons or Elemental Bandits By Furion With Quite a bit of help from Thothie
// =Quite based off the normal Bandit script
// Randomize if no settings are set

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_monster.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class Dragoon
{
	// Constants
	string SOUND_PAIN = "player/chesthit1.wav";
	string SOUND_PAIN2 = "player/armhit1.wav";
	string SOUND_BOW = "weapons/bow/bow.wav";
	string RETALIATE_CHANGETARGET_CHANCE = "75%";
	float FIREBALL_FREQ = 5.0f;
	int SPELL_RANGE = 700;
	string ANIM_PREP_SPELL = "prepare_fireball";
	string ANIM_AIM_SPELL = "aim_fireball_R";
	string ANIM_CAST_SPELL = "throw_fireball_R";
	string LIGHTING_SCRIPT = "monsters/summon/summon_lightning_storm";
	string BLIZZARD_SCRIPT = "monsters/summon/summon_blizzard";
	string FIREWALL_SCRIPT = "monsters/summon/keledros_fire_wall";
	string POISONCLOUD_SCRIPT = "monsters/summon/npc_poison_cloud";
	float FREQ_SPELL = 12.0f;
	float SPELL_DURATION = 10.0f;
	int SPELL_DOT = 100;

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
	string ELEMENT = "ELEMENT";
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
	string SPELL_SCRIPT = "SPELL_SCRIPT";
	bool SPELL_FLINGER = false;
	float AS_ATTACKING = 0.0f;
	bool FIREBALL_DELAY = false;
	bool CASTING_SPELL = false;
	float NEXT_SPELL = 0.0f;
	string SPELL_TARGET = "SPELL_TARGET";
	bool BANDIT_FLEE_DELAY = false;
	CBaseEntity@ ALLY_CHECK_ID = null;
	int ICE_SHIELD_CHECK = 0;
	bool IS_BUFFING = false;
	int SPECIAL_EFFECT_CHANCE = 0;

	// unnamed block (first think)
	void Dragoon_FirstThink()
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
		NPC_GIVE_EXP = 150.0f;
		OnBowey();
		OnFistey();
		OnDaggerey();
		OnSwordey();
		OnAxey();
		OnMacey();
		OnMagey();
		OnSpeary();
		OnIcey();
		OnPoisoney();
		OnFirey();
		OnZappy();

		ATTACK_HITRANGE = ATTACK_RANGE * 1.5f;

		NO_STEP_ADJ = true; // seem to be getting stuck on ramps in prelude2
	}

	// npc_spawn
	// Spawn properties
	void Dragoon_OnNpcSpawn(string npc = "")
	{
		BD_COUNT = 0.0f;

		if (ELEMENT == "ELEMENT")
			ELEMENT = RandomInt(0, 3);
		if (WEAPON == "WEAPON")
			WEAPON = RandomInt(0, 7);
		SetGold(RandomInt(50, 75));
		// ov			180
		SetWidth(32);
		SetHeight(92);
		SetRace("rogue");
		SetHearingSensitivity(3);
		SetRoam(true);
		SetModel("fur/npcs/dragoon.mdl");
		SetIdleAnim(ANIM_IDLE);
		SetMoveAnim(ANIM_WALK);
	}

	// bowey
	void Dragoon_OnBowey()
	{
		if (Float(WEAPON) != 0.0f)
			return;
		SetName("Dragoon Archer");
		SetHealth(220);
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
	void Dragoon_OnDaggerey()
	{
		if (Float(WEAPON) != 1.0f)
			return;
		SetName("Dragoon Rogue");
		SetHealth(230);
		MOVE_RANGE = "50";
		ATTACK_RANGE = 90.0f;
		ATTACK1_DAMAGE = Text(Random(8.5f, 10));
		ATTACK_PERCENTAGE = "80%";
		ANIM_ATTACK = "swordjab1_R"; // attack_jab
		SetModelBody(1, 1);
	}

	// fistey
	void Dragoon_OnFistey()
	{
		if (Float(WEAPON) != 2.0f)
			return;
		SetName("Dragoon Brawler");
		SetHealth(280);
		MOVE_RANGE = "50";
		ATTACK_RANGE = 80.0f;
		ATTACK1_DAMAGE = Text(Random(6.5f, 8));
		ATTACK_PERCENTAGE = "80%";
		ANIM_ATTACK = "aim_punch1"; // attack
		SetModelBody(1, 0);
	}

	// swordey
	void Dragoon_OnSwordey()
	{
		if (Float(WEAPON) != 3.0f)
			return;
		SetName("Dragoon Swordsman");
		SetHealth(280);
		MOVE_RANGE = "80";
		ATTACK_RANGE = 120.0f;
		ATTACK1_DAMAGE = Text(Random(8.5f, 10));
		ATTACK_PERCENTAGE = "85%";
		ANIM_ATTACK = "swordswing2_R"; // attack
		SetModelBody(1, 4);
	}

	// axey
	void Dragoon_OnAxey()
	{
		if (Float(WEAPON) != 4.0f)
			return;
		SetName("Dragoon Axeman");
		SetHealth(340);
		MOVE_RANGE = "80";
		ATTACK_RANGE = 120.0f;
		ATTACK1_DAMAGE = Text(Random(9.5f, 11));
		ATTACK_PERCENTAGE = "85%";
		ANIM_ATTACK = "battleaxe_swing1_R"; // attack
		SetModelBody(1, 3);
	}

	// macey
	void Dragoon_OnMacey()
	{
		if (Float(WEAPON) != 5.0f)
			return;
		SetName("Dragoon Berserker");
		SetHealth(330);
		MOVE_RANGE = "80";
		ATTACK_RANGE = 130.0f;
		ATTACK1_DAMAGE = Text(Random(9.5f, 11));
		ATTACK_PERCENTAGE = "85%";
		ANIM_ATTACK = "battleaxe_swing1_R"; // attack
		SetModelBody(1, 2);
	}

	// magey
	void Dragoon_OnMagey()
	{
		if (Float(WEAPON) != 6.0f)
			return;
		SetName("Dragoon Mage");
		SetHealth(210);
		MOVE_RANGE = "300";
		ATTACK_RANGE = 32.0f;
		ATTACK1_DAMAGE = Text(Random(20, 40));
		ATTACK_PERCENTAGE = "85%";
		ANIM_ATTACK = "aim_punch1"; // attack
		CAN_FLINCH = "0";
		SetModelBody(1, 0);
		CallEventDelayed(1.0f, "scan_for_allies");
		CatchSpeech("debug_params", "debug");
		// NPC chooses it's deadly weapon
		if (ELEMENT == "0")
			SPELL_SCRIPT = BLIZZARD_SCRIPT;
		if (ELEMENT == "1")
			SPELL_SCRIPT = POISONCLOUD_SCRIPT;
		if (ELEMENT == "2")
			SPELL_SCRIPT = FIREWALL_SCRIPT;
		if (ELEMENT == "3")
			SPELL_SCRIPT = LIGHTING_SCRIPT;
		SPELL_FLINGER = true;
	}

	// speary
	void Dragoon_OnSpeary()
	{
		if (Float(WEAPON) != 7.0f)
			return;
		SetName("Dragoon Lancer");
		SetHealth(400);
		MOVE_RANGE = "120";
		ATTACK_RANGE = 150.0f;
		ATTACK1_DAMAGE = Text(Random(14, 20));
		ATTACK_PERCENTAGE = "75%";
		ANIM_ATTACK = "spearjab";
		SetModelBody(1, 6);
	}

	// icey
	void Dragoon_OnIcey()
	{
		if (Float(ELEMENT) != 0.0f)
			return;
		SetDamageTaken("slash", 0.8f);
		SetDamageTaken("pierce", 0.8f);
		SetDamageTaken("blunt", 0.8f);
		SetDamageTaken("fire", 1.3f);
		SetDamageTaken("cold", 0.1f);
		SetDamageTaken("poison", 0.8f);
		SetDamageTaken("lightning", 0.8f);
		SetDamageTaken("holy", 0);
		SetModelBody(0, 0);
	}

	// poisoney
	void Dragoon_OnPoisoney()
	{
		if (Float(ELEMENT) != 1.0f)
			return;
		SetDamageTaken("slash", 0.8f);
		SetDamageTaken("pierce", 0.8f);
		SetDamageTaken("blunt", 0.8f);
		SetDamageTaken("fire", 0.8f);
		SetDamageTaken("cold", 0.8f);
		SetDamageTaken("poison", 0.1f);
		SetDamageTaken("lightning", 1.3f);
		SetDamageTaken("holy", 0);
		SetModelBody(0, 1);
	}

	// firey
	void Dragoon_OnFirey()
	{
		if (Float(ELEMENT) != 2.0f)
			return;
		SetDamageTaken("slash", 0.8f);
		SetDamageTaken("pierce", 0.8f);
		SetDamageTaken("blunt", 0.8f);
		SetDamageTaken("fire", 0.1f);
		SetDamageTaken("cold", 1.3f);
		SetDamageTaken("poison", 0.8f);
		SetDamageTaken("lightning", 0.8f);
		SetDamageTaken("holy", 0);
		SetModelBody(0, 2);
	}

	// zappy
	void Dragoon_OnZappy()
	{
		if (Float(ELEMENT) != 3.0f)
			return;
		SetDamageTaken("slash", 0.8f);
		SetDamageTaken("pierce", 0.8f);
		SetDamageTaken("blunt", 0.8f);
		SetDamageTaken("fire", 0.8f);
		SetDamageTaken("cold", 0.8f);
		SetDamageTaken("poison", 1.3f);
		SetDamageTaken("lightning", 0.1f);
		SetDamageTaken("holy", 0);
		SetModelBody(0, 3);
	}

	// debug_params
	void Dragoon_OnDebugParams()
	{
		SetSayTextRange(1024);
		SayText("Mov " + MOVE_RANGE);
	}

	// attack
	void Dragoon_OnAttack()
	{
		if (Float(WEAPON) == 0.0f)
		{
			// setvar AIM_ANGLE game.monster.last_seen.distance	//Aim up a bit
			// divide AIM_ANGLE GEXT_ADJ1
			SetAngle("add_view.pitch", 5); // fires in such a shallow arc, no need to adj based on distance
			AS_ATTACKING = GameTime();
			// <projectile scriptname> <"view"|(src_origin)> <target|(targ_origin)> <speed> <damage> <cof> <skill|none>
			TossProjectile("proj_arrow_npc", RelativePosition(Vector3(0, 0, 2)), "none", ATTACK_SPEED, ATTACK1_DAMAGE, ATTACK_COF, "none"); // Converted to use new tossprojectile //greatguys1@FEB2022
			CallExternal(EntityOf(ENT_LASTPROJECTILE), "ext_lighten", 0.4f); // helps aim - thothie
			PlaySound(2, 10, SOUND_BOW);
		}
		else
		{
			DoDamageEx(NPCATK_TARGET, ATTACK_HITRANGE, ATTACK1_DAMAGE, ATTACK_PERCENTAGE, ENT_ME, ENT_ME, "none", "slash", "dmgevent:attack");
		}
	}

	// attack_jab
	void Dragoon_OnAttackJab()
	{
		OnAttack();
	}

	// npc_struck
	void Dragoon_OnNpcStruck(float damage = 0.0f)
	{
		SetVolume(5);
		PlayRandomSound(2, 5, SOUND_PAIN, SOUND_PAIN2, "none", "none");
	}

	// npc_death
	void Dragoon_OnNpcDeath()
	{
		SetVolume(5);
		PlayRandomSound(2, 5, SOUND_PAIN, SOUND_PAIN2, "none", "none");
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
	void Dragoon_OnNpcTargetsighted(string target = "")
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
				if (SPELL_FLINGER && GameTime() > NEXT_SPELL)
				{
					NEXT_SPELL = GameTime() + FREQ_SPELL; // current game time (server up in seconds [floats to 100ths])
					PlayAnim("critical", ANIM_PREP_SPELL);
					CallEventDelayed(2.0f, "do_spell");
				}
			}
		}
	}

	// reset_fireball_delay
	void Dragoon_OnResetFireballDelay()
	{
		FIREBALL_DELAY = false;
	}

	// spell_attack
	// param1 = targ
	void Dragoon_OnSpellAttack(CBaseEntity@ target = null)
	{
		AS_ATTACKING = GameTime();
		PlaySound(0, 10, "magic/fire_powerup.wav");
		SPELL_TARGET = EntityId(target);
		SetMoveDest(SPELL_TARGET, 9999);
		PlayAnim("once", ANIM_PREP_SPELL);
		CallEventDelayed(0.5f, "spell_attack2");
	}

	// spell_attack2
	void Dragoon_OnSpellAttack2()
	{
		SetMoveDest(SPELL_TARGET, 9999);
		PlayAnim("critical", ANIM_AIM_SPELL);
		CallEventDelayed(0.5f, "spell_attack3");
	}

	// spell_attack3
	void Dragoon_OnSpellAttack3()
	{
		SetMoveDest(SPELL_TARGET, 9999);
		Vector3 targOrg = OriginOf(SPELL_TARGET);
		SetAngle("face_origin", targOrg);
		CallEventDelayed(0.1f, "straighten_out");

		PlaySound(0, 10, "magic/ice_strike.wav");

		PlayAnim("critical", ANIM_CAST_SPELL);
		// <projectile scriptname> <"view"|(src_origin)> <target|(targ_origin)> <speed> <damage> <cof> <skill|none>
		TossProjectile("proj_fire_ball", RelativePosition(Vector3(0, 48, 2)), "FIREBALL_TARGET", 400, ATTACK1_DAMAGE, 5, "none"); // Converted to use new tossprojectile //greatguys1@FEB2022
		CallExternal(EntityOf(ENT_LASTPROJECTILE), "ext_lighten", 0);
		CASTING_SPELL = false;
	}

	// straighten_out
	void Dragoon_OnStraightenOut()
	{
		Vector3 myAng = MyAngles();
		float myYaw = Vec(SPELL_TARGET).y;
		SetAngle("face", Vector3(0, myYaw, 0));
		CallEventDelayed(1.0f, "mage_reposition");
	}

	// mage_reposition
	void Dragoon_OnMageReposition()
	{
		if (RangeTo(HUNT_LASTTARGET) < SPELL_RANGE)
			OnNpcatkFlee(EntityId(EntityOf(HUNT_LASTTARGET)), "700", "1.0");
		if (RangeTo(HUNT_LASTTARGET) >= Float(MOVE_RANGE))
			OnChickenRun(1.0f);
	}

	// game_struck
	void Dragoon_OnGameStruck(float damage = 0.0f, string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		if (Float(WEAPON) == 6.0f && !BANDIT_FLEE_DELAY)
		{
			BANDIT_FLEE_DELAY = true;
			CallEventDelayed(10.0f, "reset_bandit_flee_delay");
			OnNpcatkFlee(EntityId(EntityOf(ENT_LASTSTRUCK)), "2000", "5.0");
		}
	}

	// reset_bandit_flee_delay
	void Dragoon_OnResetBanditFleeDelay()
	{
		BANDIT_FLEE_DELAY = false;
	}

	// npcatk_ally_alert
	// param1 attacker, param2 ally under attack
	void Dragoon_OnNpcatkAllyAlert(string attacker = "", CBaseEntity@ allyToAid = null)
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
	void Dragoon_OnCheckCanShield()
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
	void Dragoon_OnCheckCanShield2()
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
	void Dragoon_OnShieldAlly()
	{
		if (!CanSee(EntityId(ALLY_CHECK_ID)))
			return;

		CallEventDelayed(0.5f, "cast_shield");
	}

	// cast_shield
	void Dragoon_OnCastShield()
	{
		IS_BUFFING = false;
		PlaySound(0, 10, "magic/cast.wav");
		ApplyEffect(ALLY_CHECK_ID, "effects/iceshield", 20, self, 0.5f);
	}

	// scan_for_allies
	void Dragoon_OnScanForAllies()
	{
		CallEventDelayed(0.7f, "scan_for_allies");
		if (!CanSee("ally"))
			return;
		@ALLY_CHECK_ID = EntityOf(ENT_LASTSEEN);
		OnCheckCanShield();
	}

	// unnamed block (timer)
	void Dragoon_Timer()
	{
		CallEventDelayed(2.0f, "Dragoon_Timer");

		// something in this script is causing BD periodically
		// prevention measure/hack
		if (SUSPEND_AI)
			BD_COUNT += 1.0f;
		if (!SUSPEND_AI)
			BD_COUNT = 0.0f;
		if (BD_COUNT > 10.0f)
			OnNpcatkResumeAi();
	}

	// do_spell
	void Dragoon_OnDoSpell()
	{
		if (NPCATK_TARGET == "unset") // in case target dies before spell completed
			return;
		if (!IsAlive(ENT_ME)) // in case I die before spell completed
			return;
		CreateNpc(SPELL_SCRIPT, OriginOf(NPCATK_TARGET), self, AnglesOf(ENT_ME).y, SPELL_DOT, SPELL_DURATION);
	}

	// attack_dodamage
	// PARAM1=hit:0|1 PARAM2=ent_hit PARAM3=(start) PARAM4=(end) DmgType DmgAmt
	void Dragoon_OnAttackDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		if (!hit)
			return;

		SPECIAL_EFFECT_CHANCE = RandomInt(0, 100);
		if (SPECIAL_EFFECT_CHANCE < 30)
		{
			// Crude chance of effect snippet, If player is resistant to element, it runs this and their resistence checks
			// 30% of doing effect, subject to increase if players escape it too frequently.
			if (Float(ELEMENT) == 0.0f) // set in spawn
				ApplyEffect(target, "effects/dot_cold", 10.0f, self, RandomInt(5, 15));
			// ^ Freezes target with WEAPON_DOT/DPS for 10 seconds
			if (Float(ELEMENT) == 1.0f) // set in spawn
				ApplyEffect(target, "effects/dot_poison", 10.0f, self, RandomInt(5, 15));
			// ^ Poisons target with WEAPON_DOT/DPS for 10 seconds
			if (Float(ELEMENT) == 2.0f) // set in spawn
				ApplyEffect(target, "effects/dot_fire", 10.0f, self, RandomInt(5, 15));
			// ^ Burns target with WEAPON_DOT/DPS for 10 seconds
			if (Float(ELEMENT) == 3.0f) // set in spawn
				ApplyEffect(target, "effects/dot_lightning", 10.0f, self, RandomInt(5, 15));
		}
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)

	// game_struck
	void OnGameStruck(float damage = 0.0f, string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		BaseNpc_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseNpcAttack_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc_attack
		BaseMonsterShared_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared
		Dragoon_OnGameStruck(damage, extraValue2, extraValue3, extraValue4);
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck
		Dragoon_OnNpcSpawn(npc);
	}

	// npcatk_ally_alert
	void OnNpcatkAllyAlert(string attacker = "", CBaseEntity@ allyToAid = null)
	{
		BaseMonsterShared_OnNpcatkAllyAlert(attacker, allyToAid); // monsters/base_monster_shared
		Dragoon_OnNpcatkAllyAlert(attacker, allyToAid);
	}

	// npc_targetsighted
	void OnNpcTargetsighted(string target = "")
	{
		BaseMonsterShared_OnNpcTargetsighted(target); // monsters/base_monster_shared
		Dragoon_OnNpcTargetsighted(target);
	}

	void OnBowey() { Dragoon_OnBowey(); } // bowey
	void OnDaggerey() { Dragoon_OnDaggerey(); } // daggerey
	void OnFistey() { Dragoon_OnFistey(); } // fistey
	void OnSwordey() { Dragoon_OnSwordey(); } // swordey
	void OnAxey() { Dragoon_OnAxey(); } // axey
	void OnMacey() { Dragoon_OnMacey(); } // macey
	void OnMagey() { Dragoon_OnMagey(); } // magey
	void OnSpeary() { Dragoon_OnSpeary(); } // speary
	void OnIcey() { Dragoon_OnIcey(); } // icey
	void OnPoisoney() { Dragoon_OnPoisoney(); } // poisoney
	void OnFirey() { Dragoon_OnFirey(); } // firey
	void OnZappy() { Dragoon_OnZappy(); } // zappy
	void OnDebugParams() { Dragoon_OnDebugParams(); } // debug_params
	void OnAttack() { Dragoon_OnAttack(); } // attack
	void OnAttackJab() { Dragoon_OnAttackJab(); } // attack_jab
	void OnNpcStruck(float damage = 0.0f) { Dragoon_OnNpcStruck(damage); } // npc_struck
	void OnNpcDeath() { Dragoon_OnNpcDeath(); } // npc_death
	void OnResetFireballDelay() { Dragoon_OnResetFireballDelay(); } // reset_fireball_delay
	void OnSpellAttack(CBaseEntity@ target = null) { Dragoon_OnSpellAttack(target); } // spell_attack
	void OnSpellAttack2() { Dragoon_OnSpellAttack2(); } // spell_attack2
	void OnSpellAttack3() { Dragoon_OnSpellAttack3(); } // spell_attack3
	void OnStraightenOut() { Dragoon_OnStraightenOut(); } // straighten_out
	void OnMageReposition() { Dragoon_OnMageReposition(); } // mage_reposition
	void OnResetBanditFleeDelay() { Dragoon_OnResetBanditFleeDelay(); } // reset_bandit_flee_delay
	void OnCheckCanShield() { Dragoon_OnCheckCanShield(); } // check_can_shield
	void OnCheckCanShield2() { Dragoon_OnCheckCanShield2(); } // check_can_shield2
	void OnShieldAlly() { Dragoon_OnShieldAlly(); } // shield_ally
	void OnCastShield() { Dragoon_OnCastShield(); } // cast_shield
	void OnScanForAllies() { Dragoon_OnScanForAllies(); } // scan_for_allies
	void OnDoSpell() { Dragoon_OnDoSpell(); } // do_spell
	void OnAttackDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "") { Dragoon_OnAttackDodamage(hit, target, start, end, damageType, damageText); } // attack_dodamage
	void OnFireballFreq() {} // FIREBALL_FREQ

	// This file's events and timers by their .script names
	bool Dragoon_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "attack") { OnAttack(); return true; }
		if (name == "attack_dodamage") { OnAttackDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5)); return true; }
		if (name == "attack_jab") { OnAttackJab(); return true; }
		if (name == "axey") { OnAxey(); return true; }
		if (name == "bowey") { OnBowey(); return true; }
		if (name == "cast_shield") { OnCastShield(); return true; }
		if (name == "check_can_shield") { OnCheckCanShield(); return true; }
		if (name == "check_can_shield2") { OnCheckCanShield2(); return true; }
		if (name == "daggerey") { OnDaggerey(); return true; }
		if (name == "debug_params") { OnDebugParams(); return true; }
		if (name == "do_spell") { OnDoSpell(); return true; }
		if (name == "firey") { OnFirey(); return true; }
		if (name == "fistey") { OnFistey(); return true; }
		if (name == "game_struck") { OnGameStruck(Float(Param(params, 0)), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "icey") { OnIcey(); return true; }
		if (name == "macey") { OnMacey(); return true; }
		if (name == "mage_reposition") { OnMageReposition(); return true; }
		if (name == "magey") { OnMagey(); return true; }
		if (name == "npc_death") { OnNpcDeath(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "npc_struck") { OnNpcStruck(Float(Param(params, 0))); return true; }
		if (name == "npc_targetsighted") { OnNpcTargetsighted(Param(params, 0)); return true; }
		if (name == "npcatk_ally_alert") { OnNpcatkAllyAlert(Param(params, 0), EntityParam(params, 1)); return true; }
		if (name == "poisoney") { OnPoisoney(); return true; }
		if (name == "reset_bandit_flee_delay") { OnResetBanditFleeDelay(); return true; }
		if (name == "reset_fireball_delay") { OnResetFireballDelay(); return true; }
		if (name == "scan_for_allies") { OnScanForAllies(); return true; }
		if (name == "shield_ally") { OnShieldAlly(); return true; }
		if (name == "speary") { OnSpeary(); return true; }
		if (name == "spell_attack") { OnSpellAttack(EntityParam(params, 0)); return true; }
		if (name == "spell_attack2") { OnSpellAttack2(); return true; }
		if (name == "spell_attack3") { OnSpellAttack3(); return true; }
		if (name == "straighten_out") { OnStraightenOut(); return true; }
		if (name == "swordey") { OnSwordey(); return true; }
		if (name == "zappy") { OnZappy(); return true; }
		if (name == "Dragoon_Timer") { Dragoon_Timer(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "furion/dragoons/dragoon"]
shared class DragoonScript : BaseMonsterScript, Dragoon
{
	// Variables declared by included files, with the value they start with in this script
	DragoonScript()
	{
		ANIM_IDLE = "idle";
		ANIM_RUN = "run";
		ANIM_WALK = "walk2";
		NO_STEP_ADJ = true;
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("fur/npcs/dragoon.mdl");
		CallEventDelayed(2.0f, "Dragoon_Timer");
		CallEventDelayed(Float(CYCLE_TIME), "hunting_mode_go");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		Dragoon_FirstThink();
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
		return Dragoon_DispatchEvent(name, params)
			|| BaseMonsterScript::DispatchEvent(name, params);
	}
}
