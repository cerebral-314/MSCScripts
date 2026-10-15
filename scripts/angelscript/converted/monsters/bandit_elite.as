#pragma context server

// Converted from monsters/bandit_elite.script by msc_transpiler.
// This is an older script and may have some bad conventions as a result
// *** Random bandit script ***

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_monster.as"
#include "converted/monsters/base_aim_proj.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class BanditElite
{
	// Constants
	string MONSTER_MODEL = "npc/rogue_1337.mdl";
	string ANIM_HOP = "long_jump";
	float FREQ_BOW = 0.0f;
	float FREQ_DAGGER = 0.0f;
	float FREQ_MA = 0.0f;
	float FREQ_SWORD = 0.0f;
	float FREQ_AXE = 0.0f;
	float FREQ_MACE = 0.0f;
	float DMG_DAGGER = 0.0f;
	int DMG_MA = 25;
	float DMG_SWORD = 0.0f;
	float DMG_AXE = 0.0f;
	float DMG_MACE = 0.0f;
	string SOUND_PAIN = "player/chesthit1.wav";
	string SOUND_PAIN2 = "player/armhit1.wav";
	string SOUND_DEATH = "player/leghit1.wav";
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
	bool LEAP_UP_DELAY = false;

	// unnamed block (first think)
	void BanditElite_FirstThink()
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
		NPC_GIVE_EXP = 300.0f;

		if (Truthy(GetVar("OVERRIDE_BANDIT_SPAWN")))
			return;
		OnBowey();
		OnFistey();
		OnDaggerey();
		OnSwordey();
		OnAxey();
		OnMacey();
	}

	// npc_spawn
	// Spawn properties
	void BanditElite_OnNpcSpawn(string npc = "")
	{
		if (Truthy(GetVar("OVERRIDE_BANDIT_SPAWN")))
			return;

		if (WEAPON == "WEAPON")
			WEAPON = RandomInt(0, 5);
		SetGold(RandomInt(30, 40));
		// fov			220
		SetWidth(32);
		SetHeight(92);
		SetRace("rogue");
		SetDamageTaken("all", 0.6f);
		SetHearingSensitivity(3);
		SetRoam(true);
		SetModel(MONSTER_MODEL);
		SetIdleAnim(ANIM_IDLE);
		SetMoveAnim(ANIM_WALK);
	}

	// bowey
	void BanditElite_OnBowey()
	{
		if (Float(WEAPON) != 0.0f)
			return;
		SetName("Elite Bandit Archer");
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
	void BanditElite_OnDaggerey()
	{
		if (Float(WEAPON) != 1.0f)
			return;
		SetName("Elite Bandit Rogue");
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
	void BanditElite_OnFistey()
	{
		if (Float(WEAPON) != 2.0f)
			return;
		SetName("Elite Bandit Martial Artist");
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
	void BanditElite_OnSwordey()
	{
		if (Float(WEAPON) != 3.0f)
			return;
		SetName("Elite Bandit Swordsman");
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
	void BanditElite_OnAxey()
	{
		if (Float(WEAPON) != 4.0f)
			return;
		SetName("Elite Bandit Axeman");
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
	void BanditElite_OnMacey()
	{
		if (Float(WEAPON) != 5.0f)
			return;
		SetName("Elite Bandit Berserker");
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

	// check_attack
	void BanditElite_OnCheckAttack()
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
	void BanditElite_OnGameStruck(float damage = 0.0f, string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		PlayRandomSound(2, 5, SOUND_PAIN, SOUND_PAIN2, "none", "none");
	}

	// game_death
	void BanditElite_OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
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

	// game_struck
	void BanditElite_OnGameStruck_2(float damage = 0.0f, string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		// trained archers move if hit
		if (Float(WEAPON) != 0.0f)
			return;
		if (Text(IsPlayer(ENT_LASTSTRUCK)) != Text(CHANGE_POSITION))
			return;
	}

	// npc_targetsighted
	void BanditElite_OnNpcTargetsighted(string target = "")
	{
		// archer
		if (Float(WEAPON) == 0.0f && !IS_FLEEING && CanSee(target))
		{
			AS_ATTACKING = GameTime();
			PlayAnim("once", ANIM_ATTACK);
		}
	}

	// cycle_up
	void BanditElite_OnCycleUp(string reason = "")
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

		// dbg temp Special attack in FREQ_SPEC_ATTACK
		CallEventDelayed(FREQ_SPEC_ATTACK, "special_attack");
	}

	// special_attack
	void BanditElite_OnSpecialAttack()
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

		CallEventDelayed(FREQ_SPEC_ATTACK, "special_attack");

		if (I_R_FROZEN)
			CallEventDelayed(10.0f, "freeze_solid_end");

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
	void BanditElite_OnSpecialAttack2()
	{
		// dbg special_attack2 ( BANDIT_TYPE )
		if (BANDIT_TYPE == "bow")
		{
			// toss four arrows ^_^
			if (CanSee("enemy"))
			{
				SetAngle("add_view.pitch", 10);
				PlaySound(0, 10, "player/shout1.wav");
				CallEventDelayed(0.1f, "bow_sound");
				CallEventDelayed(0.2f, "bow_sound");
				CallEventDelayed(0.3f, "bow_sound");
				CallEventDelayed(0.4f, "bow_sound");

				Vector3 pos = RelativePosition(Vector3(0, 0, 2));
				// <projectile scriptname> <"view"|(src_origin)> <target|(targ_origin)|none> <speed> <damage> <cof> <skill|none> //Converted to use new tossprojectile //greatguys1@FEB2022
				TossProjectile("proj_arrow_gpoison", pos, "none", ATTACK_SPEED, "FINAL_DAMAGE", 10, "none");
				TossProjectile("proj_arrow_gpoison", pos, "none", ATTACK_SPEED, "FINAL_DAMAGE", 10, "none");
				TossProjectile("proj_arrow_gpoison", pos, "none", ATTACK_SPEED, "FINAL_DAMAGE", 10, "none");
				TossProjectile("proj_arrow_gpoison", pos, "none", ATTACK_SPEED, "FINAL_DAMAGE", 10, "none");
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
	}

	// turbo_attack
	void BanditElite_OnTurboAttack()
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
	void BanditElite_OnEndTurbo()
	{
		SetMoveSpeed(1);
		SetAnimMoveSpeed(1);
		SetAnimFrameRate(1);

		BASE_FRAMERATE = "1.0";
		BASE_MOVESPEED = 1.0f;
	}

	// npc_selectattack
	void BanditElite_OnNpcSelectattack()
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
		}
	}

	// leap_at
	// <target>
	void BanditElite_OnLeapAt(string target = "")
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
	void BanditElite_OnLeapAt2()
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
	void BanditElite_OnLeapAway(string target = "")
	{
		// dbg leap_away PARAM2
		AM_LEAPING = true;
		NPC_FORCED_MOVEDEST = true;
		OnNpcatkSuspendAi("1.0");
		SetMoveDest(target, 800, "flee");
		CallEventDelayed(0.1f, "leap_away2");
	}

	// leap_away2
	void BanditElite_OnLeapAway2()
	{
		PlaySound(0, 10, "player/shout1.wav");
		PlayAnim("critical", ANIM_HOP);
		AS_ATTACKING = GameTime();
		CallEventDelayed(0.1f, "bandit_hop");
		CallEventDelayed(1.0f, "reset_leaping");
	}

	// bandit_charge
	void BanditElite_OnBanditCharge()
	{
		AddVelocity(ENT_ME, RelativeVelocity(Vector3(0, 400, 100)));
	}

	// bandit_hop
	void BanditElite_OnBanditHop()
	{
		int jumpHeight = RandomInt(350, 450);
		AddVelocity(ENT_ME, RelativeVelocity(Vector3(0, 250, jumpHeight)));
	}

	// reset_leaping
	void BanditElite_OnResetLeaping()
	{
		AM_LEAPING = false;
	}

	// ground_scan
	void BanditElite_OnGroundScan()
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
	void BanditElite_OnAttack()
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

			// <projectile scriptname> <"view"|(src_origin)> <target|(targ_origin)|none> <speed> <damage> <cof> <skill|none> //Converted to use new tossprojectile //greatguys1@FEB2022
			TossProjectile("proj_arrow_frost", RelativePosition(Vector3(0, 0, 2)), "none", ATTACK_SPEED, finalDamage, ATTACK_COF, "none");
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
		}

		if (BANDIT_TYPE == "sword")
		{
			OnBigswingSound();
			finalDamage = DMG_SWORD;
			if (POWER_ATTACK)
				finalDamage *= 2.0f;
			OnNpcatkAdjAttack();
			DoDamage(HUNT_LASTTARGET, ADJ_RANGE, finalDamage, ATTACK_PERCENTAGE);
		}

		if (BANDIT_TYPE == "axe")
		{
			OnBigswingSound();
			finalDamage = DMG_AXE;
			if (POWER_ATTACK)
				finalDamage *= 2.0f;
			OnNpcatkAdjAttack();
			DoDamage(HUNT_LASTTARGET, ADJ_RANGE, finalDamage, ATTACK_PERCENTAGE);
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

			// elite bandit uses dark maul
			if (RandomInt(1, 3) == 1)
				ApplyEffect(HUNT_LASTTARGET, "effects/dot_fire", 5, self, RandomInt(10, 20));
		}
	}

	// reset_power_attack
	void BanditElite_OnResetPowerAttack()
	{
		POWER_ATTACK = false;
		ANIM_ATTACK = ORIG_ATTACK;
		SetMoveAnim(ANIM_RUN);
	}

	// game_dodamage
	// 1: Attack Hit (1/0)  2: Entity Attack hit  3:  Start Position  4:  End Position
	string BanditElite_OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";

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
		return result;
	}

	// bow_sound
	void BanditElite_OnBowSound()
	{
		PlaySound(0, 10, SOUND_BOW);
	}

	// bigswing_sound
	void BanditElite_OnBigswingSound()
	{
		PlaySound(0, 8, "weapons/swingsmall.wav");
	}

	// smallswing_sound
	void BanditElite_OnSmallswingSound()
	{
		PlaySound(0, 8, "weapons/swingsmall.wav");
	}

	// ma_sound
	void BanditElite_OnMaSound()
	{
		PlayRandomSound(0, 8, "player/jab1.wav", "player/jab2.wav");
	}

	// attack_jab
	void BanditElite_OnAttackJab()
	{
		OnAttack();
	}

	// kick_high
	void BanditElite_OnKickHigh()
	{
		OnAttack();
	}

	// kick_low
	void BanditElite_OnKickLow()
	{
		OnAttack();
	}

	// game_struck
	void BanditElite_OnGameStruck_3(float damage = 0.0f, string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
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
	void BanditElite_OnNpcTargetsighted_2(string target = "")
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
	void BanditElite_OnResetLeapUpDelay()
	{
		LEAP_UP_DELAY = false;
	}

	// game_damaged_other
	// P1 = target P2= damage
	string BanditElite_OnGameDamagedOther(CBaseEntity@ target = null, float damage = 0.0f, string damageType = "", string damageEvent = "")
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
	void BanditElite_OnLeapScan()
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

	// game_death
	void OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		DqMonsterExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // dq/externals/dq_monster_externals
		MonstersExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/externals
		BaseSelfAdjust_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_self_adjust
		BaseNpc_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseMonsterShared_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared
		BanditElite_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4);
	}

	// game_damaged_other
	string OnGameDamagedOther(CBaseEntity@ target = null, float damage = 0.0f, string damageType = "", string damageEvent = "")
	{
		string result = "";
		result = AppendResult(result, MonstersExternals_OnGameDamagedOther(target, damage, damageType, damageEvent));
		result = AppendResult(result, BaseAntiStuck_OnGameDamagedOther(target, damage, damageType, damageEvent));
		result = AppendResult(result, BaseMonsterShared_OnGameDamagedOther(target, damage, damageType, damageEvent));
		result = AppendResult(result, BanditElite_OnGameDamagedOther(target, damage, damageType, damageEvent));
		return result;
	}

	// game_struck
	void OnGameStruck(float damage = 0.0f, string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		BaseNpc_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseNpcAttack_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc_attack
		BaseMonsterShared_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared
		BanditElite_OnGameStruck(damage, extraValue2, extraValue3, extraValue4);
		BanditElite_OnGameStruck_2(damage, extraValue2, extraValue3, extraValue4);
		BanditElite_OnGameStruck_3(damage, extraValue2, extraValue3, extraValue4);
	}

	// check_attack
	void OnCheckAttack()
	{
		BaseNpcAttack_OnCheckAttack(); // monsters/base_npc_attack
		BanditElite_OnCheckAttack();
	}

	// cycle_up
	void OnCycleUp(string reason = "")
	{
		BaseNpcAttack_OnCycleUp(reason); // monsters/base_npc_attack
		BanditElite_OnCycleUp(reason);
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck
		BanditElite_OnNpcSpawn(npc);
	}

	// npc_selectattack
	void OnNpcSelectattack()
	{
		BaseAntiStuck_OnNpcSelectattack(); // monsters/base_anti_stuck
		BaseMonsterShared_OnNpcSelectattack(); // monsters/base_monster_shared
		BanditElite_OnNpcSelectattack();
	}

	// game_dodamage
	string OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";
		result = AppendResult(result, BaseAntiStuck_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BaseMonsterShared_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BanditElite_OnGameDodamage(hit, target, start, end, damageType, damageText));
		return result;
	}

	// npc_targetsighted
	void OnNpcTargetsighted(string target = "")
	{
		BaseMonsterShared_OnNpcTargetsighted(target); // monsters/base_monster_shared
		BanditElite_OnNpcTargetsighted(target);
		BanditElite_OnNpcTargetsighted_2(target);
	}

	void OnBowey() { BanditElite_OnBowey(); } // bowey
	void OnDaggerey() { BanditElite_OnDaggerey(); } // daggerey
	void OnFistey() { BanditElite_OnFistey(); } // fistey
	void OnSwordey() { BanditElite_OnSwordey(); } // swordey
	void OnAxey() { BanditElite_OnAxey(); } // axey
	void OnMacey() { BanditElite_OnMacey(); } // macey
	void OnSpecialAttack() { BanditElite_OnSpecialAttack(); } // special_attack
	void OnSpecialAttack2() { BanditElite_OnSpecialAttack2(); } // special_attack2
	void OnTurboAttack() { BanditElite_OnTurboAttack(); } // turbo_attack
	void OnEndTurbo() { BanditElite_OnEndTurbo(); } // end_turbo
	void OnLeapAt(string target = "") { BanditElite_OnLeapAt(target); } // leap_at
	void OnLeapAt2() { BanditElite_OnLeapAt2(); } // leap_at2
	void OnLeapAway(string target = "") { BanditElite_OnLeapAway(target); } // leap_away
	void OnLeapAway2() { BanditElite_OnLeapAway2(); } // leap_away2
	void OnBanditCharge() { BanditElite_OnBanditCharge(); } // bandit_charge
	void OnBanditHop() { BanditElite_OnBanditHop(); } // bandit_hop
	void OnResetLeaping() { BanditElite_OnResetLeaping(); } // reset_leaping
	void OnGroundScan() { BanditElite_OnGroundScan(); } // ground_scan
	void OnAttack() { BanditElite_OnAttack(); } // attack
	void OnResetPowerAttack() { BanditElite_OnResetPowerAttack(); } // reset_power_attack
	void OnBowSound() { BanditElite_OnBowSound(); } // bow_sound
	void OnBigswingSound() { BanditElite_OnBigswingSound(); } // bigswing_sound
	void OnSmallswingSound() { BanditElite_OnSmallswingSound(); } // smallswing_sound
	void OnMaSound() { BanditElite_OnMaSound(); } // ma_sound
	void OnAttackJab() { BanditElite_OnAttackJab(); } // attack_jab
	void OnKickHigh() { BanditElite_OnKickHigh(); } // kick_high
	void OnKickLow() { BanditElite_OnKickLow(); } // kick_low
	void OnResetLeapUpDelay() { BanditElite_OnResetLeapUpDelay(); } // reset_leap_up_delay
	void OnLeapScan() { BanditElite_OnLeapScan(); } // leap_scan
	void OnFreqSpecAttack() {} // FREQ_SPEC_ATTACK

	// This file's events and timers by their .script names
	bool BanditElite_DispatchEvent(const string &in name, const array<string> &in params)
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
		if (name == "fistey") { OnFistey(); return true; }
		if (name == "game_damaged_other") { Return(OnGameDamagedOther(EntityParam(params, 0), Float(Param(params, 1)), Param(params, 2), Param(params, 3))); return true; }
		if (name == "game_death") { OnGameDeath(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_dodamage") { Return(OnGameDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5))); return true; }
		if (name == "game_struck") { OnGameStruck(Float(Param(params, 0)), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "ground_scan") { OnGroundScan(); return true; }
		if (name == "kick_high") { OnKickHigh(); return true; }
		if (name == "kick_low") { OnKickLow(); return true; }
		if (name == "leap_at") { OnLeapAt(Param(params, 0)); return true; }
		if (name == "leap_at2") { OnLeapAt2(); return true; }
		if (name == "leap_away") { OnLeapAway(Param(params, 0)); return true; }
		if (name == "leap_away2") { OnLeapAway2(); return true; }
		if (name == "leap_scan") { OnLeapScan(); return true; }
		if (name == "ma_sound") { OnMaSound(); return true; }
		if (name == "macey") { OnMacey(); return true; }
		if (name == "npc_selectattack") { OnNpcSelectattack(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "npc_targetsighted") { OnNpcTargetsighted(Param(params, 0)); return true; }
		if (name == "reset_leap_up_delay") { OnResetLeapUpDelay(); return true; }
		if (name == "reset_leaping") { OnResetLeaping(); return true; }
		if (name == "reset_power_attack") { OnResetPowerAttack(); return true; }
		if (name == "smallswing_sound") { OnSmallswingSound(); return true; }
		if (name == "special_attack") { OnSpecialAttack(); return true; }
		if (name == "special_attack2") { OnSpecialAttack2(); return true; }
		if (name == "swordey") { OnSwordey(); return true; }
		if (name == "turbo_attack") { OnTurboAttack(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "monsters/bandit_elite"]
shared class BanditEliteScript : BaseMonsterScript, BanditElite, BaseAimProj
{
	// Variables declared by included files, with the value they start with in this script
	BanditEliteScript()
	{
		SOUND_DEATH = "player/leghit1.wav";
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
		Precache("npc/rogue_1337.mdl");
		CallEventDelayed(Float(CYCLE_TIME), "hunting_mode_go");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		BanditElite_FirstThink();
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
		return BanditElite_DispatchEvent(name, params)
			|| BaseAimProj_DispatchEvent(name, params)
			|| BaseMonsterScript::DispatchEvent(name, params);
	}
}
