#pragma context server

// Converted from furion/dragoons/dragoon_elite.script by msc_transpiler.
// *** Random bandit script ***
// Elite Dragoon Variant

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_monster.as"
#include "converted/monsters/base_aim_proj.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class DragoonElite
{
	// Constants
	string MONSTER_MODEL = "fur/npcs/dragoon_elite.mdl";
	string ANIM_HOP = "long_jump";
	float FREQ_BOW = 0.0f;
	float FREQ_DAGGER = 0.0f;
	float FREQ_MA = 0.0f;
	float FREQ_SWORD = 0.0f;
	float FREQ_AXE = 0.0f;
	float FREQ_MACE = 0.0f;
	float FREQ_SPEAR = 0.0f;
	float DMG_DAGGER = 0.0f;
	int DMG_MA = 25;
	float DMG_SWORD = 0.0f;
	float DMG_AXE = 0.0f;
	float DMG_MACE = 0.0f;
	float DMG_SPEAR = 0.0f;
	string SOUND_PAIN = "player/chesthit1.wav";
	string SOUND_PAIN2 = "player/armhit1.wav";
	string SOUND_BOW = "weapons/bow/bow.wav";
	string RETALIATE_CHANGETARGET_CHANCE = "75%";
	int AIM_RATIO = 50;
	string ARROW_DAMAGE = "$rand(50,120)";

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
	string ELEMENT = "ELEMENT";
	int ATTACK_SPEED = 1200;
	int ATTACK_COF = 0;
	string BANDIT_TYPE = "bow";
	string MOVE_RANGE = "MOVE_RANGE";
	float ATTACK_RANGE = 0.0f;
	string ANIM_ATTACK = "ANIM_ATTACK";
	float TOO_CLOSE = 0.0f;
	int DROPS_CONTAINER = 0;
	string NO_STUCK_CHECKS = "NO_STUCK_CHECKS";
	string ATTACK1_DAMAGE = "ATTACK1_DAMAGE";
	string ATTACK_PERCENTAGE = "80%";
	string ORIG_ATTACK = "ORIG_ATTACK";
	string DROP_ITEM1 = "DROP_ITEM1";
	string DROP_ITEM1_CHANCE = "DROP_ITEM1_CHANCE";
	string BASE_FRAMERATE = "1.5";
	float BASE_MOVESPEED = 1.5f;
	float CHANGE_POSITION = 0.0f;
	bool PURE_FLEE = false;
	float AS_ATTACKING = 0.0f;
	bool SPEC_LOOP = false;
	float FREQ_SPEC_ATTACK = 0.0f;
	bool POWER_ATTACK = false;
	string LEAP_TARGET = "LEAP_TARGET";
	int ATK_TYPE = 0;
	bool AM_LEAPING = false;
	bool NPC_FORCED_MOVEDEST = false;
	float OLD_Z = 0.0f;
	bool DO_STUN = false;
	float ADJ_RANGE = 0.0f;
	bool MELEE_ATTACK = false;
	int SPECIAL_EFFECT_CHANCE = 0;
	bool LEAP_UP_DELAY = false;

	// unnamed block (first think)
	void DragoonElite_FirstThink()
	{
		// external media precache
		// stun_burst
		CONTAINER_DROP_CHANCE = "10%";
		CONTAINER_SCRIPT = "chests/quiver_of_frost_arrows";
		ANIM_IDLE = "idle";
		ANIM_RUN = "run";
		ANIM_WALK = "walk2";
		ANIM_DEATH = "die_simple";
		CAN_HUNT = "1";
		HUNT_AGRO = "1";
		CAN_ATTACK = "1";
		CAN_RETALIATE = "1";
		CAN_HEAR = "1";
		NPC_GIVE_EXP = 400.0f;

		OnBowey();
		OnFistey();
		OnDaggerey();
		OnSwordey();
		OnAxey();
		OnMacey();
		OnSpeary();

		OnIcey();
		OnPoisoney();
		OnFirey();
		OnZappy();
	}

	// npc_spawn
	// Spawn properties
	void DragoonElite_OnNpcSpawn(string npc = "")
	{
		if (WEAPON == "WEAPON")
			WEAPON = RandomInt(0, 6);
		if (ELEMENT == "ELEMENT")
			ELEMENT = RandomInt(0, 3);
		SetGold(RandomInt(70, 100));
		// fov			220
		SetWidth(32);
		SetHeight(92);
		SetRace("rogue");
		SetHearingSensitivity(3);
		SetRoam(true);
		SetModel(MONSTER_MODEL);
		SetIdleAnim(ANIM_IDLE);
		SetMoveAnim(ANIM_WALK);
	}

	// bowey
	void DragoonElite_OnBowey()
	{
		if (Float(WEAPON) != 0.0f)
			return;
		SetName("Elite Dragoon Archer");
		SetHealth(800);
		ATTACK_SPEED = 1200;
		MOVE_RANGE = ATTACK_SPEED;
		ATTACK_RANGE = ATTACK_SPEED;
		ATTACK_COF = 0;
		ANIM_ATTACK = "shootbow";
		SetModelBody(1, 5);
		TOO_CLOSE = 0.0f;
		DROPS_CONTAINER = 1;
		NO_STUCK_CHECKS = "1";

		BANDIT_TYPE = "bow";
	}

	// daggerey
	void DragoonElite_OnDaggerey()
	{
		if (Float(WEAPON) != 1.0f)
			return;
		SetName("Elite Dragoon Rogue");
		SetHealth(800);
		MOVE_RANGE = "30";
		ATTACK_RANGE = 90.0f;
		ATTACK1_DAMAGE = Text(DMG_DAGGER);
		ATTACK_PERCENTAGE = "80%";
		ANIM_ATTACK = "swordjab1_R";
		ORIG_ATTACK = ANIM_ATTACK;
		SetModelBody(1, 1);
		DROP_ITEM1 = "smallarms_fangstooth"; // Used by base_monster
		DROP_ITEM1_CHANCE = "5%"; // Used by base_monster

		BANDIT_TYPE = "dagger";
	}

	// fistey
	void DragoonElite_OnFistey()
	{
		if (Float(WEAPON) != 2.0f)
			return;
		SetName("Elite Dragoon Martial Artist");
		SetHealth(1000);

		SetMoveSpeed(1.5f);
		SetAnimMoveSpeed(1.5f);

		BASE_FRAMERATE = "1.5";
		BASE_MOVESPEED = 1.5f;

		MOVE_RANGE = "30";
		ATTACK_RANGE = 80.0f;
		ATTACK1_DAMAGE = DMG_MA;
		ATTACK_PERCENTAGE = "80%";
		ANIM_ATTACK = "aim_punch1";
		ORIG_ATTACK = ANIM_ATTACK;
		SetModelBody(1, 0);

		BANDIT_TYPE = "ma";
	}

	// swordey
	void DragoonElite_OnSwordey()
	{
		if (Float(WEAPON) != 3.0f)
			return;
		SetName("Elite Dragoon Swordsman");
		SetHealth(1000);
		MOVE_RANGE = "60";
		ATTACK_RANGE = 100.0f;
		ATTACK1_DAMAGE = Text(Random(20, 30));
		ATTACK_PERCENTAGE = "85%";
		ANIM_ATTACK = "swordswing2_R";
		ORIG_ATTACK = ANIM_ATTACK;
		SetModelBody(1, 4);

		BANDIT_TYPE = "sword";
	}

	// axey
	void DragoonElite_OnAxey()
	{
		if (Float(WEAPON) != 4.0f)
			return;
		SetName("Elite Dragoon Axeman");
		SetHealth(1500);
		MOVE_RANGE = "80";
		ATTACK_RANGE = 100.0f;
		ATTACK1_DAMAGE = Text(Random(30, 60));
		ATTACK_PERCENTAGE = "85%";
		ANIM_ATTACK = "battleaxe_swing1_R";
		ORIG_ATTACK = ANIM_ATTACK;
		SetModelBody(1, 3);

		BANDIT_TYPE = "axe";
	}

	// macey
	void DragoonElite_OnMacey()
	{
		if (Float(WEAPON) != 5.0f)
			return;
		SetName("Elite Dragoon Berserker");
		SetHealth(1750);
		MOVE_RANGE = "80";
		ATTACK_RANGE = 100.0f;
		ATTACK1_DAMAGE = Text(Random(30, 60));
		ATTACK_PERCENTAGE = "85%";
		ANIM_ATTACK = "battleaxe_swing1_R";
		ORIG_ATTACK = ANIM_ATTACK;
		SetModelBody(1, 2);

		BANDIT_TYPE = "mace";
	}

	// speary
	void DragoonElite_OnSpeary()
	{
		if (Float(WEAPON) != 6.0f)
			return;
		SetName("Elite Dragoon Lancer");
		SetHealth(1200);
		MOVE_RANGE = "120";
		ATTACK_RANGE = 140.0f;
		ATTACK1_DAMAGE = Text(Random(30, 60));
		ATTACK_PERCENTAGE = "85%";
		ANIM_ATTACK = "spearjab";
		ORIG_ATTACK = ANIM_ATTACK;
		SetModelBody(1, 6);

		BANDIT_TYPE = "spear";
	}

	// icey
	void DragoonElite_OnIcey()
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
	void DragoonElite_OnPoisoney()
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
	void DragoonElite_OnFirey()
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
	void DragoonElite_OnZappy()
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

	// check_attack
	void DragoonElite_OnCheckAttack()
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

	// npc_struck
	void DragoonElite_OnNpcStruck(float damage = 0.0f)
	{
		SetVolume(5);
		PlayRandomSound(2, 5, SOUND_PAIN, SOUND_PAIN2, "none", "none");
	}

	// npc_death
	void DragoonElite_OnNpcDeath()
	{
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

	// npc_struck
	void DragoonElite_OnNpcStruck_2(float damage = 0.0f)
	{
		// trained archers move if hit
		if (Float(WEAPON) != 0.0f)
			return;
		if (Text(IsPlayer(ENT_LASTSTRUCK)) != Text(CHANGE_POSITION))
			return;
	}

	// npc_targetsighted
	void DragoonElite_OnNpcTargetsighted(string target = "")
	{
		// archer
		if (Float(WEAPON) == 0.0f && !IS_FLEEING && CanSee(target))
		{
			AS_ATTACKING = GameTime();
			PlayAnim("once", ANIM_ATTACK);
		}
	}

	// cycle_up
	void DragoonElite_OnCycleUp(string reason = "")
	{
		if (SPEC_LOOP)
			return;
		SPEC_LOOP = true;

		if (BANDIT_TYPE == "bow")
			FREQ_SPEC_ATTACK = FREQ_BOW;
		if (BANDIT_TYPE == "dagger")
			FREQ_SPEC_ATTACK = FREQ_DAGGER;
		if (BANDIT_TYPE == "ma")
			FREQ_SPEC_ATTACK = FREQ_MA;
		if (BANDIT_TYPE == "sword")
			FREQ_SPEC_ATTACK = FREQ_SWORD;
		if (BANDIT_TYPE == "axe")
			FREQ_SPEC_ATTACK = FREQ_AXE;
		if (BANDIT_TYPE == "mace")
			FREQ_SPEC_ATTACK = FREQ_MACE;
		if (BANDIT_TYPE == "spear")
			FREQ_SPEC_ATTACK = FREQ_SPEAR;

		// dbg temp Special attack in FREQ_SPEC_ATTACK
		CallEventDelayed(FREQ_SPEC_ATTACK, "special_attack");
	}

	// special_attack
	void DragoonElite_OnSpecialAttack()
	{
		if (BANDIT_TYPE == "bow")
			FREQ_SPEC_ATTACK = FREQ_BOW;
		if (BANDIT_TYPE == "dagger")
			FREQ_SPEC_ATTACK = FREQ_DAGGER;
		if (BANDIT_TYPE == "ma")
			FREQ_SPEC_ATTACK = FREQ_MA;
		if (BANDIT_TYPE == "sword")
			FREQ_SPEC_ATTACK = FREQ_SWORD;
		if (BANDIT_TYPE == "axe")
			FREQ_SPEC_ATTACK = FREQ_AXE;
		if (BANDIT_TYPE == "mace")
			FREQ_SPEC_ATTACK = FREQ_MACE;
		if (BANDIT_TYPE == "spear")
			FREQ_SPEC_ATTACK = FREQ_SPEAR;

		CallEventDelayed(FREQ_SPEC_ATTACK, "special_attack");

		if (I_R_FROZEN)
			return;

		if (!CanSee("enemy"))
			return;

		PlaySound(0, 10, "player/swordready.wav");

		if (BANDIT_TYPE != "dagger")
			Effect("glow", ENT_ME, Vector3(255, 255, 255), 64, 1, 1);

		CallEventDelayed(0.75f, "special_attack2");
	}

	// special_attack2
	void DragoonElite_OnSpecialAttack2()
	{
		// dbg special_attack2 ( BANDIT_TYPE )
		if (BANDIT_TYPE == "bow")
		{
			// toss six arrows ^_^
			if (CanSee("enemy"))
			{
				SetAngle("add_view.pitch", 10);
				PlaySound(0, 10, "player/shout1.wav");
				CallEventDelayed(0.1f, "bow_sound");
				CallEventDelayed(0.2f, "bow_sound");
				CallEventDelayed(0.3f, "bow_sound");
				CallEventDelayed(0.4f, "bow_sound");
				CallEventDelayed(0.5f, "bow_sound");
				CallEventDelayed(0.6f, "bow_sound");
				Vector3 pos = RelativePosition(Vector3(0, 0, 2));
				// <projectile scriptname> <"view"|(src_origin)> <target|(targ_origin)> <speed> <damage> <cof> <skill|none>
				TossProjectile("proj_arrow_npc", pos, "none", ATTACK_SPEED, "FINAL_DAMAGE", 10, "none"); // Converted to use new tossprojectile //greatguys1@FEB2022
				TossProjectile("proj_arrow_npc", pos, "none", ATTACK_SPEED, "FINAL_DAMAGE", 10, "none");
				TossProjectile("proj_arrow_npc", pos, "none", ATTACK_SPEED, "FINAL_DAMAGE", 10, "none");
				TossProjectile("proj_arrow_npc", pos, "none", ATTACK_SPEED, "FINAL_DAMAGE", 10, "none");
				TossProjectile("proj_arrow_npc", pos, "none", ATTACK_SPEED, "FINAL_DAMAGE", 10, "none");
				TossProjectile("proj_arrow_npc", pos, "none", ATTACK_SPEED, "FINAL_DAMAGE", 10, "none");
			}
		}

		if (BANDIT_TYPE == "dagger")
		{
			// turbo attack
			PlaySound(0, 10, "player/shout1.wav");
			OnTurboAttack();
		}

		if (BANDIT_TYPE == "ma")
		{
			POWER_ATTACK = true;
			PlayAnim("break");
		}

		if (BANDIT_TYPE == "sword")
		{
			// next attack will be power attack (freeze effect + dbl dam)
			PlayAnim("break");
			POWER_ATTACK = true;
		}

		if (BANDIT_TYPE == "axe")
		{
			// AOE damage and throw after leap
			if (CanSee("enemy"))
			{
				PlayAnim("break");
				LEAP_TARGET = EntityId(EntityOf(ENT_LASTSEEN));
				POWER_ATTACK = true; // callevent leap_at LEAP_TARGET
				if (RangeTo(LEAP_TARGET) < 200.0f)
				{
					PURE_FLEE = true;
					OnNpcatkFlee(LEAP_TARGET, "300", "2.0");
				}
				CallEventDelayed(0.1f, "leap_scan");
			}
		}

		if (BANDIT_TYPE == "mace")
		{
			// AOE stun + fire
			PlayAnim("break");
			POWER_ATTACK = true;
		}
		if (BANDIT_TYPE == "spear")
		{
			// AOE damage and throw after leap
			if (CanSee("enemy"))
			{
				PlayAnim("break");
				LEAP_TARGET = EntityId(EntityOf(ENT_LASTSEEN));
				POWER_ATTACK = true; // callevent leap_at LEAP_TARGET
				if (RangeTo(LEAP_TARGET) < 200.0f)
				{
					PURE_FLEE = true;
					OnNpcatkFlee(LEAP_TARGET, "300", "2.0");
				}
				CallEventDelayed(0.1f, "leap_scan");
			}
		}
	}

	// turbo_attack
	void DragoonElite_OnTurboAttack()
	{
		PlayAnim("critical", ANIM_ATTACK); // stops from getting stuck

		Effect("glow", ENT_ME, Vector3(255, 255, 255), 64, 10, 10);

		SetMoveSpeed(2);
		SetAnimMoveSpeed(2);
		SetAnimFrameRate(3);

		BASE_FRAMERATE = "3.0";
		BASE_MOVESPEED = 3.0f;

		CallEventDelayed(10.0f, "end_turbo");
	}

	// end_turbo
	void DragoonElite_OnEndTurbo()
	{
		SetMoveSpeed(1);
		SetAnimMoveSpeed(1);
		SetAnimFrameRate(1);

		BASE_FRAMERATE = "1.0";
		BASE_MOVESPEED = 1.0f;
	}

	// npc_selectattack
	void DragoonElite_OnNpcSelectattack()
	{
		if (BANDIT_TYPE == "ma")
		{
			ATK_TYPE = RandomInt(1, 3);
			if (POWER_ATTACK)
				ATK_TYPE = 2;
			if (ATK_TYPE == 1)
				ANIM_ATTACK = "aim_punch1";
			if (ATK_TYPE == 2)
				ANIM_ATTACK = "stance_normal_highkick_r1";
			if (ATK_TYPE == 3)
				ANIM_ATTACK = "stance_normal_lowkick_r1";
		}

		if (POWER_ATTACK)
		{
			if (BANDIT_TYPE == "sword")
			{
				SetMoveAnim("walk_squatwalk1_R");
				ANIM_ATTACK = "swordjab1_R";
			}
			if (BANDIT_TYPE == "axe" && !IS_FLEEING)
			{
				if (!IsAlive(LEAP_TARGET)) // original target no good - switch to current targ
					LEAP_TARGET = HUNT_LASTTARGET;
			}
			if (BANDIT_TYPE == "mace")
			{
				SetMoveAnim("walk_squatwalk1_R");
				ANIM_ATTACK = "battleaxe_swing1_R";
			}
			if (BANDIT_TYPE == "spear" && !IS_FLEEING)
			{
				if (!IsAlive(LEAP_TARGET)) // original target no good - switch to current targ
					LEAP_TARGET = HUNT_LASTTARGET;
			}
		}
	}

	// leap_at
	// <target>
	void DragoonElite_OnLeapAt(string target = "")
	{
		if (AM_LEAPING)
			return;
		AM_LEAPING = true;
		NPC_FORCED_MOVEDEST = true;
		OnNpcatkSuspendAi("1.0");
		POWER_ATTACK = false;
		SetMoveDest(target, MOVE_RANGE);
		CallEventDelayed(0.1f, "leap_at2");
	}

	// leap_at2
	void DragoonElite_OnLeapAt2()
	{
		PlaySound(0, 10, "player/shout1.wav");
		PlayAnim("critical", ANIM_HOP);
		AS_ATTACKING = GameTime();
		CallEventDelayed(0.1f, "bandit_charge");
		CallEventDelayed(1.0f, "reset_leaping");
		OLD_Z = MyOrigin().z;
		DO_STUN = true;
		CallEventDelayed(0.5f, "ground_scan");
	}

	// leap_away
	// <target>
	void DragoonElite_OnLeapAway(string target = "")
	{
		// dbg leap_away PARAM2
		AM_LEAPING = true;
		NPC_FORCED_MOVEDEST = true;
		OnNpcatkSuspendAi("1.0");
		SetMoveDest(target, 800, "flee");
		CallEventDelayed(0.1f, "leap_away2");
	}

	// leap_away2
	void DragoonElite_OnLeapAway2()
	{
		PlaySound(0, 10, "player/shout1.wav");
		PlayAnim("critical", ANIM_HOP);
		AS_ATTACKING = GameTime();
		CallEventDelayed(0.1f, "bandit_hop");
		CallEventDelayed(1.0f, "reset_leaping");
	}

	// bandit_charge
	void DragoonElite_OnBanditCharge()
	{
		AddVelocity(ENT_ME, RelativeVelocity(Vector3(0, 400, 100)));
	}

	// bandit_hop
	void DragoonElite_OnBanditHop()
	{
		int jumpHeight = RandomInt(350, 450);
		AddVelocity(ENT_ME, RelativeVelocity(Vector3(0, 250, jumpHeight)));
	}

	// reset_leaping
	void DragoonElite_OnResetLeaping()
	{
		AM_LEAPING = false;
	}

	// ground_scan
	void DragoonElite_OnGroundScan()
	{
		if (!DO_STUN)
			return;
		CallEventDelayed(0.2f, "ground_scan");

		float myGround = GroundHeight(MyOrigin());
		float myZ = MyOrigin().z;
		float diff = myZ - myGround;
		if (diff < 5.0f)
			DO_STUN = false;

		if (DO_STUN)
			return;
		CreateNpc("monsters/summon/stun_burst", RelativePosition(Vector3(0, 60, 0)), self, 128, 1, 100); // <owner> <range> [toss1|0] [damage]
	}

	// attack
	// called from model
	void DragoonElite_OnAttack()
	{
		float finalDamage = 0.0f;

		AS_ATTACKING = GameTime();

		if (IS_FLEEING)
			return;

		if (Float(WEAPON) == 0.0f)
		{
			SetAngle("add_view.pitch", 5); // fires in such a shallow arc, no need to adj based on distance
			finalDamage = Float(ARROW_DAMAGE);
			OnNpcatkAdjAttack();
			AS_ATTACKING = GameTime();
			// <projectile scriptname> <"view"|(src_origin)> <target|(targ_origin)> <speed> <damage> <cof> <skill|none>
			TossProjectile("proj_arrow_npc", RelativePosition(Vector3(0, 0, 2)), "none", ATTACK_SPEED, finalDamage, ATTACK_COF, "none"); // Converted to use new tossprojectile //greatguys1@FEB2022
			CallExternal(EntityOf(ENT_LASTPROJECTILE), "ext_lighten", 0.4f);
			OnBowSound();
		}

		// hit range adj
		if (Float(WEAPON) != 0.0f)
		{
			ADJ_RANGE = ATTACK_RANGE;
			OnNpcatkRangeAdj();
		}

		if (BANDIT_TYPE == "dagger")
		{
			OnSmallswingSound();
			finalDamage = DMG_DAGGER;
			OnNpcatkAdjAttack();
			DoDamage(HUNT_LASTTARGET, ADJ_RANGE, finalDamage, ATTACK_PERCENTAGE);
			MELEE_ATTACK = true;
		}

		if (BANDIT_TYPE == "ma")
		{
			OnMaSound();
			finalDamage = DMG_MA;
			string hitChance = ATTACK_PERCENTAGE;
			if (POWER_ATTACK)
			{
				finalDamage *= 2.0f;
				hitChance = "100%";
			}
			OnNpcatkAdjAttack();
			DoDamage(HUNT_LASTTARGET, ADJ_RANGE, finalDamage, hitChance);
			MELEE_ATTACK = true;
		}

		if (BANDIT_TYPE == "sword")
		{
			OnBigswingSound();
			finalDamage = DMG_SWORD;
			if (POWER_ATTACK)
				finalDamage *= 2.0f;
			OnNpcatkAdjAttack();
			DoDamage(HUNT_LASTTARGET, ADJ_RANGE, finalDamage, ATTACK_PERCENTAGE);
			MELEE_ATTACK = true;
		}

		if (BANDIT_TYPE == "axe")
		{
			OnBigswingSound();
			finalDamage = DMG_AXE;
			if (POWER_ATTACK)
				finalDamage *= 2.0f;
			OnNpcatkAdjAttack();
			DoDamage(HUNT_LASTTARGET, ADJ_RANGE, finalDamage, ATTACK_PERCENTAGE);
			MELEE_ATTACK = true;
		}

		if (BANDIT_TYPE == "mace")
		{
			OnBigswingSound();
			finalDamage = DMG_MACE;
			if (POWER_ATTACK)
				finalDamage *= 2.0f;
			OnNpcatkAdjAttack();
			if (POWER_ATTACK)
				finalDamage *= 2.0f;
			DoDamage(HUNT_LASTTARGET, ADJ_RANGE, finalDamage, ATTACK_PERCENTAGE);
			MELEE_ATTACK = true;

			// elite bandit uses dark maul
			if (RandomInt(1, 3) == 1)
				ApplyEffect(HUNT_LASTTARGET, "effects/dot_fire", 5, self, RandomInt(10, 20));
		}
		if (BANDIT_TYPE == "spear")
		{
			OnBigswingSound();
			finalDamage = DMG_SPEAR;
			if (POWER_ATTACK)
				finalDamage *= 2.0f;
			OnNpcatkAdjAttack();
			DoDamage(HUNT_LASTTARGET, ADJ_RANGE, finalDamage, ATTACK_PERCENTAGE);
			MELEE_ATTACK = true;
		}
	}

	// reset_power_attack
	void DragoonElite_OnResetPowerAttack()
	{
		POWER_ATTACK = false;
		ANIM_ATTACK = ORIG_ATTACK;
		SetMoveAnim(ANIM_RUN);
	}

	// game_dodamage
	// 1: Attack Hit (1/0)  2: Entity Attack hit  3:  Start Position  4:  End Position
	string DragoonElite_OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";

		if (!MELEE_ATTACK)
			return result;
		MELEE_ATTACK = false;
		// trained archers move if can't hit - thothie
		if (Float(WEAPON) == 0.0f)
		{
			if (!hit)
				CHANGE_POSITION += 1.0f;

			if (hit)
			{
				if ((IsPlayer(target) ? 1 : 0) == 1)
					CHANGE_POSITION = -2.0f;
				if (CHANGE_POSITION < -5.0f)
					CHANGE_POSITION = 0.0f;
			}
		}

		if (BANDIT_TYPE == "ma" && hit && !POWER_ATTACK && ATK_TYPE > 1)
			AddVelocity(target, RelativeVelocity(Vector3(10, 200, 10)));

		if (POWER_ATTACK)
		{
			if (BANDIT_TYPE == "ma")
			{
				PlaySound(0, 10, "player/shout1.wav");
				OnResetPowerAttack();
				if (hit)
				{
					AddVelocity(target, RelativeVelocity(Vector3(0, 200, 200)));
					ApplyEffect(target, "effects/debuff_stun", 10, self);
				}
			}

			if (BANDIT_TYPE == "sword")
			{
				PlaySound(0, 10, "player/shout1.wav");
				OnResetPowerAttack();
				if (hit)
					ApplyEffect(target, "effects/dot_cold_freeze", Random(5, 10), self);
			}

			if (BANDIT_TYPE == "mace")
			{
				PlaySound(0, 10, "player/shout1.wav");
				OnResetPowerAttack();
				CreateNpc("monsters/summon/stun_burst", OriginOf(target), self, 128); // <owner> <range> [toss1|0] [damage]
			}
		}

		if (!hit)
			return result;
		SPECIAL_EFFECT_CHANCE = RandomInt(0, 100);
		if (SPECIAL_EFFECT_CHANCE < 30)
		{
			// Crude chance of effect snippet, If player is resistant to element, it runs this and their resistence checks
			// 30% of doing effect, subject to increase if players escape it too frequently.
			if (BANDIT_TYPE != "bow")
			{
				if (Float(ELEMENT) == 0.0f) // set in spawn
					ApplyEffect(target, "effects/dot_cold", 10.0f, self, RandomInt(1, 5));
				// 10 seconds of the player moving as slow as a snail.
				if (Float(ELEMENT) == 1.0f) // set in spawn
					ApplyEffect(target, "effects/dot_poison", 4.0f, self, RandomInt(25, 40));
				// Short lived but deadly poison
				if (Float(ELEMENT) == 2.0f) // set in spawn
					ApplyEffect(target, "effects/dot_fire", 15.0f, self, RandomInt(5, 15));
				// players on fire are on fire for a quite a while but the fire damage is weak.
				if (Float(ELEMENT) == 3.0f) // set in spawn
					ApplyEffect(target, "effects/dot_lightning", 2.0f, self, RandomInt(1, 100));
			}
		}
		return result;
	}

	// bow_sound
	void DragoonElite_OnBowSound()
	{
		PlaySound(0, 10, SOUND_BOW);
	}

	// bigswing_sound
	void DragoonElite_OnBigswingSound()
	{
		PlaySound(0, 8, "weapons/swingsmall.wav");
	}

	// smallswing_sound
	void DragoonElite_OnSmallswingSound()
	{
		PlaySound(0, 8, "weapons/swingsmall.wav");
	}

	// ma_sound
	void DragoonElite_OnMaSound()
	{
		PlayRandomSound(0, 8, "player/jab1.wav", "player/jab2.wav");
	}

	// attack_jab
	void DragoonElite_OnAttackJab()
	{
		OnAttack();
	}

	// kick_high
	void DragoonElite_OnKickHigh()
	{
		OnAttack();
	}

	// kick_low
	void DragoonElite_OnKickLow()
	{
		OnAttack();
	}

	// game_struck
	void DragoonElite_OnGameStruck(float damage = 0.0f, string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		// martial art bandit leaps away when struck, sometimes
		if (BANDIT_TYPE != "ma")
			return;
		if (I_R_FROZEN)
			return;
		int leapChance = RandomInt(1, 10);
		if (damage > 100.0f)
			leapChance = 1;
		if (damage > 20.0f && leapChance == 1)
			OnLeapAway(EntityId(EntityOf(ENT_LASTSTRUCK)));
	}

	// npc_targetsighted
	void DragoonElite_OnNpcTargetsighted_2(string target = "")
	{
		if (BANDIT_TYPE == "bow")
			return;

		if (LEAP_UP_DELAY)
			return;
		LEAP_UP_DELAY = true;
		CallEventDelayed(2.0f, "reset_leap_up_delay");

		Vector3 targPos = OriginOf(HUNT_LASTTARGET);
		float myZ = MyOrigin().z;
		float targZ = targPos.z;
		float zDiff = targZ;
		myZ += 0.0f;
		zDiff -= myZ;
		if (zDiff < 0.0f)
			zDiff = -zDiff;
		if (zDiff > 96.0f && zDiff < 300.0f)
			OnLeapAt(EntityId(EntityOf(HUNT_LASTTARGET)));
	}

	// reset_leap_up_delay
	void DragoonElite_OnResetLeapUpDelay()
	{
		LEAP_UP_DELAY = false;
	}

	// game_damaged_other
	// P1 = target P2= damage
	string DragoonElite_OnGameDamagedOther(CBaseEntity@ target = null, float damage = 0.0f, string damageType = "", string damageEvent = "")
	{
		string result = "";

		// elite dagger using bone blade
		if (BANDIT_TYPE != "dagger")
			return result;
		float maxCheck = MyHealth() + damage;
		// dbg temp MyHP game.monster.hp vs MAX_CHECK
		if (!(maxCheck < MyMaxHealth()))
			return result;
		GiveHealth(damage);
		Effect("glow", ENT_ME, Vector3(0, 255, 0), 80, 0.5f, 0.5f);
		PlaySound(0, 10, "player/heartbeat_noloop.wav");
		return result;
	}

	// leap_scan
	void DragoonElite_OnLeapScan()
	{
		if (!POWER_ATTACK)
			return;

		CallEventDelayed(0.25f, "leap_scan");

		if (IS_FLEEING)
			return;
		if (IsAlive(LEAP_TARGET))
			OnLeapAt(LEAP_TARGET);

		if (!IsAlive(LEAP_TARGET))
		{
			LEAP_TARGET = NPCATK_TARGET;
			if (NPCATK_TARGET == "unset")
			{
				OnLeapAt(LEAP_TARGET); // just do a leap at 0x0x0 to reset
			}
		}
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)

	// game_damaged_other
	string OnGameDamagedOther(CBaseEntity@ target = null, float damage = 0.0f, string damageType = "", string damageEvent = "")
	{
		string result = "";
		result = AppendResult(result, MonstersExternals_OnGameDamagedOther(target, damage, damageType, damageEvent));
		result = AppendResult(result, BaseAntiStuck_OnGameDamagedOther(target, damage, damageType, damageEvent));
		result = AppendResult(result, BaseMonsterShared_OnGameDamagedOther(target, damage, damageType, damageEvent));
		result = AppendResult(result, DragoonElite_OnGameDamagedOther(target, damage, damageType, damageEvent));
		return result;
	}

	// game_struck
	void OnGameStruck(float damage = 0.0f, string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		BaseNpc_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseNpcAttack_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc_attack
		BaseMonsterShared_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared
		DragoonElite_OnGameStruck(damage, extraValue2, extraValue3, extraValue4);
	}

	// check_attack
	void OnCheckAttack()
	{
		BaseNpcAttack_OnCheckAttack(); // monsters/base_npc_attack
		DragoonElite_OnCheckAttack();
	}

	// cycle_up
	void OnCycleUp(string reason = "")
	{
		BaseNpcAttack_OnCycleUp(reason); // monsters/base_npc_attack
		DragoonElite_OnCycleUp(reason);
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck
		DragoonElite_OnNpcSpawn(npc);
	}

	// npc_selectattack
	void OnNpcSelectattack()
	{
		BaseAntiStuck_OnNpcSelectattack(); // monsters/base_anti_stuck
		BaseMonsterShared_OnNpcSelectattack(); // monsters/base_monster_shared
		DragoonElite_OnNpcSelectattack();
	}

	// game_dodamage
	string OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";
		result = AppendResult(result, BaseAntiStuck_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BaseMonsterShared_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, DragoonElite_OnGameDodamage(hit, target, start, end, damageType, damageText));
		return result;
	}

	// npc_targetsighted
	void OnNpcTargetsighted(string target = "")
	{
		BaseMonsterShared_OnNpcTargetsighted(target); // monsters/base_monster_shared
		DragoonElite_OnNpcTargetsighted(target);
		DragoonElite_OnNpcTargetsighted_2(target);
	}

	void OnBowey() { DragoonElite_OnBowey(); } // bowey
	void OnDaggerey() { DragoonElite_OnDaggerey(); } // daggerey
	void OnFistey() { DragoonElite_OnFistey(); } // fistey
	void OnSwordey() { DragoonElite_OnSwordey(); } // swordey
	void OnAxey() { DragoonElite_OnAxey(); } // axey
	void OnMacey() { DragoonElite_OnMacey(); } // macey
	void OnSpeary() { DragoonElite_OnSpeary(); } // speary
	void OnIcey() { DragoonElite_OnIcey(); } // icey
	void OnPoisoney() { DragoonElite_OnPoisoney(); } // poisoney
	void OnFirey() { DragoonElite_OnFirey(); } // firey
	void OnZappy() { DragoonElite_OnZappy(); } // zappy

	// npc_struck
	void OnNpcStruck(float damage = 0.0f)
	{
		DragoonElite_OnNpcStruck(damage);
		DragoonElite_OnNpcStruck_2(damage);
	}

	void OnNpcDeath() { DragoonElite_OnNpcDeath(); } // npc_death
	void OnSpecialAttack() { DragoonElite_OnSpecialAttack(); } // special_attack
	void OnSpecialAttack2() { DragoonElite_OnSpecialAttack2(); } // special_attack2
	void OnTurboAttack() { DragoonElite_OnTurboAttack(); } // turbo_attack
	void OnEndTurbo() { DragoonElite_OnEndTurbo(); } // end_turbo
	void OnLeapAt(string target = "") { DragoonElite_OnLeapAt(target); } // leap_at
	void OnLeapAt2() { DragoonElite_OnLeapAt2(); } // leap_at2
	void OnLeapAway(string target = "") { DragoonElite_OnLeapAway(target); } // leap_away
	void OnLeapAway2() { DragoonElite_OnLeapAway2(); } // leap_away2
	void OnBanditCharge() { DragoonElite_OnBanditCharge(); } // bandit_charge
	void OnBanditHop() { DragoonElite_OnBanditHop(); } // bandit_hop
	void OnResetLeaping() { DragoonElite_OnResetLeaping(); } // reset_leaping
	void OnGroundScan() { DragoonElite_OnGroundScan(); } // ground_scan
	void OnAttack() { DragoonElite_OnAttack(); } // attack
	void OnResetPowerAttack() { DragoonElite_OnResetPowerAttack(); } // reset_power_attack
	void OnBowSound() { DragoonElite_OnBowSound(); } // bow_sound
	void OnBigswingSound() { DragoonElite_OnBigswingSound(); } // bigswing_sound
	void OnSmallswingSound() { DragoonElite_OnSmallswingSound(); } // smallswing_sound
	void OnMaSound() { DragoonElite_OnMaSound(); } // ma_sound
	void OnAttackJab() { DragoonElite_OnAttackJab(); } // attack_jab
	void OnKickHigh() { DragoonElite_OnKickHigh(); } // kick_high
	void OnKickLow() { DragoonElite_OnKickLow(); } // kick_low
	void OnResetLeapUpDelay() { DragoonElite_OnResetLeapUpDelay(); } // reset_leap_up_delay
	void OnLeapScan() { DragoonElite_OnLeapScan(); } // leap_scan
	void OnFreqSpecAttack() {} // FREQ_SPEC_ATTACK

	// This file's events and timers by their .script names
	bool DragoonElite_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "attack") { OnAttack(); return true; }
		if (name == "attack_jab") { OnAttackJab(); return true; }
		if (name == "axey") { OnAxey(); return true; }
		if (name == "bandit_charge") { OnBanditCharge(); return true; }
		if (name == "bandit_hop") { OnBanditHop(); return true; }
		if (name == "bigswing_sound") { OnBigswingSound(); return true; }
		if (name == "bow_sound") { OnBowSound(); return true; }
		if (name == "bowey") { OnBowey(); return true; }
		if (name == "check_attack") { OnCheckAttack(); return true; }
		if (name == "cycle_up") { OnCycleUp(Param(params, 0)); return true; }
		if (name == "daggerey") { OnDaggerey(); return true; }
		if (name == "end_turbo") { OnEndTurbo(); return true; }
		if (name == "firey") { OnFirey(); return true; }
		if (name == "fistey") { OnFistey(); return true; }
		if (name == "game_damaged_other") { Return(OnGameDamagedOther(EntityParam(params, 0), Float(Param(params, 1)), Param(params, 2), Param(params, 3))); return true; }
		if (name == "game_dodamage") { Return(OnGameDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5))); return true; }
		if (name == "game_struck") { OnGameStruck(Float(Param(params, 0)), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "ground_scan") { OnGroundScan(); return true; }
		if (name == "icey") { OnIcey(); return true; }
		if (name == "kick_high") { OnKickHigh(); return true; }
		if (name == "kick_low") { OnKickLow(); return true; }
		if (name == "leap_at") { OnLeapAt(Param(params, 0)); return true; }
		if (name == "leap_at2") { OnLeapAt2(); return true; }
		if (name == "leap_away") { OnLeapAway(Param(params, 0)); return true; }
		if (name == "leap_away2") { OnLeapAway2(); return true; }
		if (name == "leap_scan") { OnLeapScan(); return true; }
		if (name == "ma_sound") { OnMaSound(); return true; }
		if (name == "macey") { OnMacey(); return true; }
		if (name == "npc_death") { OnNpcDeath(); return true; }
		if (name == "npc_selectattack") { OnNpcSelectattack(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "npc_struck") { OnNpcStruck(Float(Param(params, 0))); return true; }
		if (name == "npc_targetsighted") { OnNpcTargetsighted(Param(params, 0)); return true; }
		if (name == "poisoney") { OnPoisoney(); return true; }
		if (name == "reset_leap_up_delay") { OnResetLeapUpDelay(); return true; }
		if (name == "reset_leaping") { OnResetLeaping(); return true; }
		if (name == "reset_power_attack") { OnResetPowerAttack(); return true; }
		if (name == "smallswing_sound") { OnSmallswingSound(); return true; }
		if (name == "speary") { OnSpeary(); return true; }
		if (name == "special_attack") { OnSpecialAttack(); return true; }
		if (name == "special_attack2") { OnSpecialAttack2(); return true; }
		if (name == "swordey") { OnSwordey(); return true; }
		if (name == "turbo_attack") { OnTurboAttack(); return true; }
		if (name == "zappy") { OnZappy(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "furion/dragoons/dragoon_elite"]
shared class DragoonEliteScript : BaseMonsterScript, DragoonElite, BaseAimProj
{
	// Variables declared by included files, with the value they start with in this script
	DragoonEliteScript()
	{
		ANIM_IDLE = "idle";
		ANIM_RUN = "run";
		ANIM_WALK = "walk2";
		BASE_FRAMERATE = "1.5";
		BASE_MOVESPEED = 1.5f;
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("fur/npcs/dragoon_elite.mdl");
		CallEventDelayed(Float(CYCLE_TIME), "hunting_mode_go");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		DragoonElite_FirstThink();
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
		return DragoonElite_DispatchEvent(name, params)
			|| BaseAimProj_DispatchEvent(name, params)
			|| BaseMonsterScript::DispatchEvent(name, params);
	}
}
