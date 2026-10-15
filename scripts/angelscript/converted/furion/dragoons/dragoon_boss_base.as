#pragma context server

// Converted from furion/dragoons/dragoon_boss_base.script by msc_transpiler.
// SCRIPT Edited by Furion
// 1 = Dragoon lord - Same actions as Firedagger bandit leader

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_monster_new.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class DragoonBossBase
{
	// Constants
	float NPC_BOSS_REGEN_RATE = 0.1f;
	float NPC_BOSS_RESTORATION = 0.25f;
	string ANIM_DRINK = "swordready1_R";
	string ANIM_AXE_FAST = "battleaxe_swing1_R";
	string ANIM_AXE_SLOW = "battleaxe_swing1_L";
	string ANIM_SWORD_FAST = "longsword_swipe_R";
	string ANIM_SWORD_SLOW = "longsword_swipe_L";
	string ANIM_BOW = "shootbow";
	string ANIM_SWING_SLOW = "swordswing1_R";
	string ANIM_SWING_FAST = "swordswing2_R";
	string ANIM_JAB = "swordjab1_R";
	string ANIM_KICK_HIGH = "stance_normal_highkick_r1";
	string ANIM_KICK_LOW = "stance_normal_lowkick_r1";
	string ANIM_PARRY = "longsword_parry";
	string ANIM_SPELL = "prepare_fireball";
	string ANIM_CAST = "throw_fireball_R";
	string ANIM_MOVE_SLOW = "run_squatwalk1_R";
	string ANIM_HOP = "jump";
	string ANIM_LEAP = "long_jump";
	string SOUND_PARRY = "weapons/parry.wav";
	string SOUND_POWERUP = "voices/big_swordready.wav";
	string SOUND_LEAP = "voices/big_shout1.wav";
	string SOUND_SATTACK = "voices/big_shout1.wav";
	string SOUND_TAUNT1 = "voices/big_yeah1.wav";
	string SOUND_TAUNT2 = "voices/big_taunt1.wav";
	string SOUND_SWING_FAST = "weapons/cbar_miss1.wav";
	string SOUND_SWING_SLOW1 = "zombie/claw_miss1.wav";
	string SOUND_SWING_SLOW2 = "zombie/claw_miss2.wav";
	string SOUND_DEATH = "voices/big_death.wav";
	string SOUND_BOW_STRETCH = "weapons/bow/stretch.wav";
	string SOUND_BOW_SHOOT = "weapons/bow/crossbow.wav";
	string SOUND_PAIN = "voices/big_chesthit1.wav";
	string SOUND_PAIN2 = "voices/big_armhit1.wav";
	float FREQ_HEALTH = 50.0f;
	float FREQ_PULL = 10.0f;
	float FREQ_KICK = 0.0f;
	float FREQ_SPECIAL = 0.0f;
	int FREQ_INVIS = 0;
	float FREQ_FLANK = 5.0f;
	float FREQ_AVOID = 10.0f;
	float FLINCH_DAMAGE_THRESHOLD = 75.0f;
	string ATTACK_HITCHANCE = "85%";
	string DMG_KICK = "DMG_KICK";
	float DMG_DAGGER = 0.0f;
	int ELEMENT_LIMIT = 5;
	int ELEMENT_DMG_THRESH = 30;
	int ARROW_SPEED = 1200;
	int AS_ATK_VALUE = 10;
	string BEAM_SPRITE = "lgtning.spr";
	string MONSTER_MODEL = "fur/npcs/dragoonlord.mdl";

	// Variables (an unset .script variable reads as its own name)
	string ANIM_WALK_NORM = "walk2";
	string ANIM_RUN_NORM = "run";
	string ANIM_WALK = "walk2";
	string ANIM_RUN = "run";
	bool NPC_IS_BOSS = false;
	string ANIM_FLINCH = "ANIM_FLINCH";
	string ANIM_DEATH = "ANIM_DEATH";
	string CAN_FLINCH = "CAN_FLINCH";
	string FLINCH_CHANCE = "FLINCH_CHANCE";
	string FLINCH_ANIM = "FLINCH_ANIM";
	float ATTACK_RANGE = 0.0f;
	float ATTACK_HITRANGE = 0.0f;
	float ATTACK_MOVERANGE = 0.0f;
	string MOVE_RANGE = "MOVE_RANGE";
	float HEALTH_AMMO = 0.0f;
	float RESIST_AMMO = 0.0f;
	int SPECIAL_AMMO = 0;
	float FIRE_STRUCK = 0.0f;
	float COLD_STRUCK = 0.0f;
	float POISON_STRUCK = 0.0f;
	float LIGHTNING_STRUCK = 0.0f;
	float FAST_SWINGS = 0.0f;
	float NEXT_ATTACK = 0.0f;
	float BD_COUNT = 0.0f;
	float NOVA_PICK_ATK = 0.0f;
	string ANIM_ATTACK = "ANIM_ATTACK";
	float ORIG_MOVE_RANGE = 0.0f;
	float HALF_HEALTH = 0.0f;
	float FIRST_SPEC_POT_HEALTH = 0.0f;
	float QUARTER_HEALTH = 0.0f;
	string ORIG_ATTACK = "ORIG_ATTACK";
	int ORIG_WEAPON = 0;
	float FREQ_ATTACK = 0.0f;
	float ORIG_FREQ_ATTACK = 0.0f;
	bool SWEEP_KICK_DELAY = false;
	float AS_ATTACKING = 0.0f;
	bool HEALTH_POT_DELAY = false;
	bool DID_FIRST_POT = false;
	bool DID_SECOND_POT = false;
	CBaseEntity@ PULL_TARGET = null;
	bool PULL_DELAY = false;
	bool IN_RESIST = false;
	bool AVOID_DELAY = false;
	bool DRINKING_POT = false;
	string DRINK_TYPE = "DRINK_TYPE";
	bool USED_FIRE_POT = false;
	bool USED_COLD_POT = false;
	bool USED_POISON_POT = false;
	bool USED_LIGHTNING_POT = false;
	string SPEC_TYPE = "SPEC_TYPE";
	bool GLOW_ON = false;
	Vector3 GLOW_LOOP_COLOR = Vector3();
	bool DEMON_NOHP_LOSS = false;
	bool FLINCHED_RECENTLY = false;
	bool DEMON_BLOOD = false;
	string BASE_FRAMERATE = "3.0";
	float BASE_MOVESPEED = 3.0f;
	bool DOING_PULL = false;
	bool KICK_ATTACK = false;
	bool FREEZE_ATTACK = false;
	bool STUN_ATTACK = false;
	bool NORM_ATTACK = false;
	bool CYCLES_ON = false;
	bool DOING_NOVA = false;
	string NOVA_ATTACK = "NOVA_ATTACK";
	float SCATTER_COUNT = 0.0f;
	bool BB_IN_ATTACK = false;
	bool FLANK_DELAY = false;
	float BALL_SIZE = 0.0f;
	float BALL_SPEED = 0.0f;
	float BALL_DMG = 0.0f;
	bool SCATTER_SHOT = false;
	string LEAP_TARGET = "LEAP_TARGET";
	bool AM_LEAPING = false;
	bool NPC_FORCED_MOVEDEST = false;
	bool POWER_ATTACK = false;
	bool LEGAL_ACT = false;
	int ATTACK_ANIMINDEX = 0;
	bool NPC_NO_MOVE = false;

	// unnamed block (first think)
	void DragoonBossBase_FirstThink()
	{
		if (ToLowerCase(MapName()) == "dragooncaves")
			NPC_IS_BOSS = true;
		ANIM_FLINCH = ANIM_PARRY;

		// move anims
		ANIM_WALK_NORM = "walk2";
		ANIM_RUN_NORM = "run";
		ANIM_WALK = "walk2";
		ANIM_RUN = "run"; // bad thing here, can't setvar run for some reason
		ANIM_DEATH = "die_backwards1";

		// combat
		CAN_FLINCH = "1";
		FLINCH_CHANCE = "50";
		FLINCH_ANIM = "longsword_parry";

		ATTACK_RANGE = 100.0f; // swing if this close
		ATTACK_HITRANGE = 180.0f; // hits if this close
		ATTACK_MOVERANGE = 90.0f; // moves this close
		MOVE_RANGE = "90"; // debugary - shouldnt have to do this, maybe something up in base_npc_attack_new
	}

	// game_precache
	void DragoonBossBase_OnGamePrecache()
	{
		PrecacheFile("monsters/summon/stun_burst");
		PrecacheFile("monsters/summon/flame_burst");
		PrecacheFile("monsters/summon/flame_burst");
	}

	// npc_spawn
	void DragoonBossBase_OnNpcSpawn(string npc = "")
	{
		SetInvincible(true); // stay invincible until attribs defined, so you don't die in a volcano that happens to be laying around when you spawn

		SetModel(MONSTER_MODEL);
		SetWidth(40);
		SetHeight(120);
		SetRace("rogue");
		SetDamageTaken("all", 0.5f);
		SetDamageTaken("stun", 0.5f);
		SetSayTextRange(2048);
		SetRoam(true);

		SetHealth(9999); // this resets to stop insant death

		SetHearingSensitivity(8);

		HEALTH_AMMO = 2.0f;
		RESIST_AMMO = 3.0f;
		SPECIAL_AMMO = 2;
		FIRE_STRUCK = 0.0f;
		COLD_STRUCK = 0.0f;
		POISON_STRUCK = 0.0f;
		LIGHTNING_STRUCK = 0.0f;
		FAST_SWINGS = 0.0f;
		NEXT_ATTACK = 0.0f;
		BD_COUNT = 0.0f;
		NOVA_PICK_ATK = 0.0f;

		ANIM_RUN = "run";
		ANIM_WALK = "walk2";

		// setmodelbody 1 0 //unarmed
		// setmodelbody 1 1 //fire lance
		// setmodelbody 1 7 //potion - red
		// setmodelbody 1 8 //potion - green
		CallEventDelayed(0.1f, "setup_boss");
	}

	// setup_boss
	void DragoonBossBase_OnSetupBoss()
	{
		SetName("Demetricus the Dragoon Leader");
		SetHealth(3400);
		SetModelBody(1, 1);
		ANIM_ATTACK = ANIM_JAB;
		SetSkillLevel(1000);

		SetMoveAnim(ANIM_WALK);

		SetInvincible(false);
	}

	// npc_post_spawn
	void DragoonBossBase_OnNpcPostSpawn()
	{
		ORIG_MOVE_RANGE = ATTACK_MOVERANGE;

		HALF_HEALTH = Divide(MyMaxHealth(), 2.0f);

		FIRST_SPEC_POT_HEALTH = MyMaxHealth() * 0.75f;

		QUARTER_HEALTH = MyMaxHealth() * 0.25f;

		ORIG_ATTACK = ANIM_ATTACK;
		ORIG_WEAPON = 1;

		FREQ_ATTACK = 0.25f;
		ORIG_FREQ_ATTACK = FREQ_ATTACK;
	}

	// game_damaged
	// PARAM1=attacker PARAM2=Damage PARAM3=DamageType
	string DragoonBossBase_OnGameDamaged(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float accuracyRoll = 0.0f, CBaseEntity@ inflictor = null, string skill = "")
	{
		int pullChance = 0;
		string result = "";

		// dbg temp health game.monster.hp PARAM2 PARAM3
		if (!Truthy(Eval("game.monster.isalive"))) // no drinking potions post-mortem!
			return result;

		if (damage > 30.0f)
		{
			// sweep kick all if surrounded (repulse)
			LegacyCommand("getents", "player", 128);
		}

		// drink health pot when low on health
		if (HEALTH_AMMO > 0.0f && !DRINKING_POT && MyHealth() < HALF_HEALTH && !HEALTH_POT_DELAY)
		{
			HEALTH_POT_DELAY = true;
			CallEventDelayed(FREQ_HEALTH, "reset_health_pot_delay");
			OnDrinkPot("health");
		}

		// monster drinks special potions at 75% health (effect ends at 50%) and 25% health (lasts until death)
		if (!DID_FIRST_POT && !DRINKING_POT && MyHealth() < FIRST_SPEC_POT_HEALTH)
		{
			DID_FIRST_POT = true;
			OnDrinkSpecial();
			CallEventDelayed(90.0f, "end_special_effect");
		}

		if (!DID_SECOND_POT && !DRINKING_POT && MyHealth() < QUARTER_HEALTH)
		{
			DID_SECOND_POT = true;
			OnDrinkSpecial();
		}

		if (RangeTo(attacker) > ATTACK_HITRANGE)
		{
			// (always true here) if !AM_INVISIBLE
			if (!DRINKING_POT)
			{
				@PULL_TARGET = attacker; // used by pull attack / freeze, etc
				if (damage > 20.0f)
					pullChance = RandomInt(1, 10);
				if (damage > 60.0f)
					pullChance = RandomInt(1, 2);
				if (!PULL_DELAY)
				{
					PULL_DELAY = true;
					CallEventDelayed(FREQ_PULL, "reset_pull_delay");
					OnTractorBeam();
				}
			}
		}

		if (RESIST_AMMO > 0.0f)
		{
			// if struck by elemental attack repeatedly, use resistance potion
			if (damage > ELEMENT_DMG_THRESH && !DRINKING_POT && !IN_RESIST)
			{
				// dbg temp struck_by_type PARAM3 ( FIRE_STRUCK COLD_STRUCK LIGHTNING_STRUCK POISON_STRUCK )
				if (damageType == "fire")
					FIRE_STRUCK += 1.0f;
				if (damageType == "cold")
					COLD_STRUCK += 1.0f;
				if (damageType == "lightning")
					LIGHTNING_STRUCK += 1.0f;
				if (damageType == "poison")
					POISON_STRUCK += 1.0f;

				if (FIRE_STRUCK >= ELEMENT_LIMIT && !USED_FIRE_POT)
					OnDrinkPot("fire");

				if (COLD_STRUCK >= ELEMENT_LIMIT && !USED_COLD_POT)
					OnDrinkPot("cold");

				if (LIGHTNING_STRUCK >= ELEMENT_LIMIT && !USED_LIGHTNING_POT)
					OnDrinkPot("lightning");

				if (POISON_STRUCK >= ELEMENT_LIMIT && !USED_POISON_POT)
					OnDrinkPot("poison");
			}
		}
		return result;
	}

	// normal_immune
	void DragoonBossBase_OnNormalImmune()
	{
		IN_RESIST = false;
	}

	// reset_avoid_delay
	void DragoonBossBase_OnResetAvoidDelay()
	{
		AVOID_DELAY = false;
	}

	// reset_sweep_kick_delay
	void DragoonBossBase_OnResetSweepKickDelay()
	{
		SWEEP_KICK_DELAY = false;
	}

	// reset_health_pot_delay
	void DragoonBossBase_OnResetHealthPotDelay()
	{
		HEALTH_POT_DELAY = false;
	}

	// reset_pull_delay
	void DragoonBossBase_OnResetPullDelay()
	{
		PULL_DELAY = false;
	}

	// drink_special
	void DragoonBossBase_OnDrinkSpecial()
	{
		int rndPot = RandomInt(1, 3);
		if (rndPot == 1)
			OnDrinkPot("demon");
		if (rndPot == 2)
			OnDrinkPot("protection");
		if (rndPot == 3)
			OnDrinkPot("speed");
	}

	// drink_pot
	void DragoonBossBase_OnDrinkPot(string drinkType = "")
	{
		if (!Truthy(Eval("game.monster.isalive")))
			return;

		if (DRINKING_POT) // don't try to change pots
			return;
		DRINKING_POT = true;

		if (drinkType != "health") // green pot
			SetModelBody(1, 3);
		if (drinkType == "health") // red pot
			SetModelBody(1, 2);
		OnNpcatkSuspendAi("2.0");
		PlayAnim("break");
		AS_ATTACKING = GameTime();
		PlayAnim("critical", ANIM_DRINK);
		DRINK_TYPE = drinkType;
	}

	// drink_done
	void DragoonBossBase_OnDrinkDone()
	{
		Vector3 glowColor = Vec("GLOW_COLOR");
		string outMsg = "OUT_MSG";

		OnNpcatkResumeAi();

		DRINKING_POT = false;

		PlaySound(0, 10, "items/drink.wav");

		if (DRINK_TYPE == "fire")
		{
			USED_FIRE_POT = true;
			RESIST_AMMO -= 1.0f;
			glowColor = Vector3(255, 0, 0);
			SetDamageTaken("fire", 0.5f);
			CallEventDelayed(120.0f, "normal_immune");
			IN_RESIST = true;
			outMsg = Eval("game.monster.name") + " has drank a potion and is now resistant to fire!";
			InfoMessage("all", "POTION OF RESISTANCE TO FIRE", outMsg);
		}

		if (DRINK_TYPE == "cold")
		{
			USED_COLD_POT = true;
			RESIST_AMMO -= 1.0f;
			glowColor = Vector3(128, 128, 255);
			SetDamageTaken("cold", 0.5f);
			CallEventDelayed(120.0f, "normal_immune");
			IN_RESIST = true;
			outMsg = Eval("game.monster.name") + " has drank a potion and is now resistant to cold!";
			InfoMessage("all", "POTION OF RESISTANCE TO COLD", outMsg);
		}

		if (DRINK_TYPE == "poison")
		{
			USED_POISON_POT = true;
			RESIST_AMMO -= 1.0f;
			glowColor = Vector3(0, 255, 0);
			SetDamageTaken("poison", 0.5f);
			CallEventDelayed(120.0f, "normal_immune");
			IN_RESIST = true;
			outMsg = Eval("game.monster.name") + " has drank a potion and is now resistant to poison!";
			InfoMessage("all", "POTION OF RESISTANCE TO POISON", outMsg);
		}

		if (DRINK_TYPE == "lightning")
		{
			USED_LIGHTNING_POT = true;
			RESIST_AMMO -= 1.0f;
			glowColor = Vector3(255, 255, 0);
			SetDamageTaken("lightning", 0.5f);
			CallEventDelayed(120.0f, "normal_immune");
			IN_RESIST = true;
			outMsg = Eval("game.monster.name.full") + " has drank a potion and is now resistant to lightning!";
			InfoMessage("all", "POTION OF RESISTANCE TO LIGHTNING", outMsg);
		}

		if (DRINK_TYPE == "health")
		{
			HEALTH_AMMO -= 1.0f;
			glowColor = Vector3(0, 255, 0);
			float hpGive = MyMaxHealth() - MyHealth();
			GiveHealth(hpGive);
			outMsg = Eval("game.monster.name.full") + " has used a potion of health!";
			InfoMessage("all", "POTION OF HEALTH", outMsg);
		}

		if (DRINK_TYPE == "protection")
		{
			SPEC_TYPE = "protection";
			glowColor = Vector3(255, 255, 255);
			GLOW_ON = true;
			GLOW_LOOP_COLOR = Vector3(255, 255, 255);
			CallEventDelayed(5.0f, "glow_loop");
			SetDamageTaken("all", 0.25f);
			CallEventDelayed(60.0f, "end_special_effect");
			outMsg = Eval("game.monster.name.full") + " has used a potion of protection!";
			InfoMessage("all", "POTION OF PROTECTION", outMsg);
		}

		if (DRINK_TYPE == "demon")
		{
			SPEC_TYPE = "demon";
			glowColor = Vector3(255, 0, 0);
			DEMON_NOHP_LOSS = true;
			CallEventDelayed(5.0f, "demon_blood");
			CallEventDelayed(90.0f, "end_special_effect");

			outMsg = Eval("game.monster.name.full") + " has used a vial of demon blood!";
			InfoMessage("all", "POTION OF DEMON BLOOD", outMsg);
		}

		if (DRINK_TYPE == "speed")
		{
			SPEC_TYPE = "speed";
			glowColor = Vector3(255, 0, 255);
			CallEventDelayed(5.0f, "turbo_on");
			CallEventDelayed(90.0f, "end_special_effect");
			FREQ_ATTACK = Divide(FREQ_ATTACK, 2.0f);
			outMsg = Eval("game.monster.name.full") + " has used a potion of speed!";
			InfoMessage("all", "POTION OF SPEED", outMsg);
		}

		Effect("glow", ENT_ME, glowColor, 128, 5, 5);

		DRINK_TYPE = "unset";

		SetModelBody(1, ORIG_WEAPON);
	}

	// npc_flinch
	void DragoonBossBase_OnNpcFlinch(float damage = 0.0f)
	{
		OnNpcatkResumeAi();
		if (DRINK_TYPE == "health")
			CreateItem("health_spotion", RelativePosition(Vector3(0, 0, 0)));
	}

	// npcatk_resume_ai
	void DragoonBossBase_OnNpcatkResumeAi(string target = "")
	{
		SetModelBody(1, ORIG_WEAPON);
		DRINKING_POT = false;
	}

	// npcatk_checkflinch
	// PARAM1 = incoming damage amt
	void DragoonBossBase_OnNpcatkCheckflinch(string incomingDamage = "")
	{
		// this monster can flinch while AI suspended
		if (Truthy(CAN_FLINCH) && !FLINCHED_RECENTLY && MyHealth() < HALF_HEALTH && Float(incomingDamage) > FLINCH_DAMAGE_THRESHOLD)
		{
			if (RandomInt(1, 100) <= Float(FLINCH_CHANCE))
			{
				OnNpcFlinch(); // external - can be used to select flinch anim
				PlayAnim("break");
				AS_ATTACKING = GameTime();
				PlayAnim("critical", FLINCH_ANIM);
			}
			FLINCHED_RECENTLY = true;
			CallEventOrDelay(FLINCH_DELAY, "npcatk_reset_flinch");
		}
	}

	// game_parry
	void DragoonBossBase_OnGameParry(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float parryRoll = 0.0f, float accuracyRoll = 0.0f, float parryValue = 0.0f)
	{
		AS_ATTACKING = GameTime();
		PlayAnim("critical", ANIM_PARRY);
		PlaySound(0, 10, SOUND_PARRY);
	}

	// end_special_effect
	void DragoonBossBase_OnEndSpecialEffect()
	{
		string outMsg = "OUT_MSG";
		// end demon/speed/protection pot here
		if (SPEC_TYPE == "demon")
		{
			DEMON_BLOOD = false;
			outMsg = Eval("game.monster.name.full") + "'s demon blood potion has run out.";
			InfoMessage("all", "EFFECT ENDED", outMsg);
		}

		if (SPEC_TYPE == "protection")
		{
			SetDamageTaken("all", 0.5f);
			GLOW_ON = false;
			outMsg = Eval("game.monster.name.full") + "'s protection potion has run out.";
			InfoMessage("all", "EFFECTED ENDED", outMsg);
		}

		if (SPEC_TYPE == "speed")
		{
			FREQ_ATTACK = ORIG_FREQ_ATTACK;
			OnTurboOff();
			outMsg = Eval("game.monster.name.full") + "'s speed potion has run out.";
			InfoMessage("all", "EFFECTED ENDED", outMsg);
		}
	}

	// turbo_on
	void DragoonBossBase_OnTurboOn()
	{
		if (!GLOW_ON)
		{
			GLOW_ON = true;
			GLOW_LOOP_COLOR = Vector3(255, 255, 0);
			OnGlowLoop();
		}
		SPEC_TYPE = "speed";

		SetMoveSpeed(2);
		SetAnimMoveSpeed(2);
		SetAnimFrameRate(3);

		BASE_FRAMERATE = "3.0";
		BASE_MOVESPEED = 3.0f;

		CallEventDelayed(0.1f, "stuck_fix");
	}

	// stuck_fix
	void DragoonBossBase_OnStuckFix()
	{
		PlayAnim("critical", ANIM_ATTACK);
	}

	// do_turbo
	void DragoonBossBase_OnDoTurbo()
	{
		OnTurboOn();
		CallEventDelayed(10.0f, "turbo_off");
	}

	// turbo_off
	void DragoonBossBase_OnTurboOff()
	{
		SetMoveSpeed(1);
		SetAnimMoveSpeed(1);
		SetAnimFrameRate(1);

		BASE_FRAMERATE = "1.0";
		BASE_MOVESPEED = 1.0f;
	}

	// tractor_beam
	void DragoonBossBase_OnTractorBeam()
	{
		DOING_PULL = true;
		if (!(RangeTo(PULL_TARGET) < 4000.0f))
			return;
		OnNpcatkSuspendAi();
		SetMoveDest(@PULL_TARGET, 9999);
		AS_ATTACKING = GameTime();
		PlayAnim("critical", ANIM_JAB);
		Vector3 beamStart = RelativePosition(Vector3(0, 0, 60));
		Vector3 beamEnd = OriginOf(PULL_TARGET);
		// <spritename> <width> <target> <attachment index> <(r,g,b)> <brightness> <noise> <duration>
		// effect beam point BEAM_SPRITE 30 BEAM_START BEAM_END (255,255,0) 200 30 1.5
		Effect("beam", "end", BEAM_SPRITE, 30, beamStart, @PULL_TARGET, 0, Vector3(255, 255, 0), 200, 30, 1.5f);
		CallEventDelayed(1.0f, "tractor_beam2");
	}

	// tractor_beam2
	void DragoonBossBase_OnTractorBeam2()
	{
		SayText("Don't think you can escape me!");
		SetAngle("face", @PULL_TARGET);
		// see if setangle works on player via external
		AddVelocity(PULL_TARGET, RelativeVelocity(Vector3(10, -3000, 10)));
		CallEventDelayed(0.25f, "npcatk_resume_ai");
		CallEventDelayed(0.5f, "tractor_beam3");
	}

	// tractor_beam3
	void DragoonBossBase_OnTractorBeam3()
	{
		SetAngle("face", @PULL_TARGET);
		// straighten out
		float myYaw = MyAngles().y;
		SetAngle("face", Vector3(0, myYaw, 0));

		OnNpcatkSettarget(EntityId(PULL_TARGET));
	}

	// kick_low
	void DragoonBossBase_OnKickLow()
	{
		// repulse sweep kick
		KICK_ATTACK = true;
		CreateNpc("monsters/summon/stun_burst", RelativePosition(Vector3(0, 0, 0)), self, 256, 1, 100); // <owner> <range> [toss1|0] [damage]
		OnNpcatkDodamage(NPCATK_TARGET, Text(ATTACK_RANGE), DMG_KICK, "100%", "blunt");
		CAN_FLINCH = "1";
		ANIM_ATTACK = ORIG_ATTACK;
	}

	// kick_high
	void DragoonBossBase_OnKickHigh()
	{
		KICK_ATTACK = true;
		OnNpcatkDodamage(NPCATK_TARGET, Text(ATTACK_HITRANGE), DMG_KICK, "100%", "blunt");
		ANIM_ATTACK = ORIG_ATTACK;
	}

	// game_dodamage
	// 1:AttackHit(1/0)  2:EntityHit  3:StartOrigin  4:EndOrigin
	string DragoonBossBase_OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";

		if (hit && RangeTo(target) < ATTACK_HITRANGE)
		{
			if (KICK_ATTACK)
			{
				ApplyEffect(target, "effects/debuff_stun", 10, self);
				ANIM_ATTACK = ORIG_ATTACK;
			}
			if (FREEZE_ATTACK)
			{
				int freezeChance = RandomInt(1, 4);
				if (freezeChance < 4)
				{
					PlaySound(0, 10, "playsound", 0, 10, "debris/beamstart14.wav");
					ApplyEffect(target, "effects/dot_cold_freeze", 10, @EntityOf(ENT_OWNER), 30);
				}
				if (freezeChance == 4)
					PlaySound(0, 10, "debris/zap1.wav");
				ANIM_ATTACK = ORIG_ATTACK;
			}
			if (STUN_ATTACK)
				ApplyEffect(target, "effects/debuff_stun", 10, self);

			if (!KICK_ATTACK)
				ApplyEffect(target, "effects/dot_fire", 5, self, "DMG_BURN_DAGGER");
		}

		// reset atk types
		KICK_ATTACK = false;
		FREEZE_ATTACK = false;
		STUN_ATTACK = false;
		NORM_ATTACK = false;
		return result;
	}

	// cycle_up
	void DragoonBossBase_OnCycleUp(string reason = "")
	{
		if (CYCLES_ON)
			return;
		CYCLES_ON = true;

		CallEventDelayed(FREQ_KICK, "do_kick");

		CallEventDelayed(FREQ_SPECIAL, "do_special");
		OnFreqTurbo();
		CallEventDelayed(FREQ_INVIS, "do_invis");
	}

	// do_special
	void DragoonBossBase_OnDoSpecial()
	{
		float freqSpecial = FREQ_SPECIAL;

		OnCheckLegalAct();
		if (!LEGAL_ACT)
			freqSpecial = 5.0f;

		bool canSeeNme = CanSee("enemy");
		if (!canSeeNme)
			freqSpecial = 5.0f;

		CallEventDelayed(freqSpecial, "do_special");

		if (!canSeeNme)
			return;
		if (!LEGAL_ACT)
			return;

		// flame burst
		PlaySound(0, 10, SOUND_POWERUP);
		Effect("glow", ENT_ME, Vector3(255, 0, 0), 128, 3, 3);
		AS_ATTACKING = 20.0f;
		PlayAnim("critical", ANIM_SPELL);
	}

	// reset_doing_nova
	void DragoonBossBase_OnResetDoingNova()
	{
		DOING_NOVA = false;
	}

	// do_fire_wall
	void DragoonBossBase_OnDoFireWall()
	{
		// dbg firewall delayed go
		PlayAnim("critical", ANIM_SPELL);
		Effect("glow", ENT_ME, Vector3(255, 255, 128), 128, 3, 3);
	}

	// do_fireball
	// do_special
	void DragoonBossBase_OnDoFireball()
	{
		AS_ATTACKING = GameTime();
		PlayAnim("critical", ANIM_JAB);
	}

	// do_sphere
	// do_special
	void DragoonBossBase_OnDoSphere()
	{
		AS_ATTACKING = GameTime();
		PlayAnim("critical", ANIM_JAB);
		PlaySound(0, 10, SOUND_SATTACK);
		CreateNpc("monsters/summon/ice_blast", RelativePosition(Vector3(0, 64, 32)), self, 20.0f, RelativePosition(Vector3(0, 2000, 0)));
	}

	// go_blizz
	// do_special
	void DragoonBossBase_OnGoBlizz()
	{
		PlaySound(0, 10, SOUND_SATTACK);
		AS_ATTACKING = GameTime();
		PlayAnim("critical", ANIM_JAB);
		Effect("glow", ENT_ME, Vector3(128, 128, 255), 128, 3, 3);
		Vector3 blizzPos = OriginOf("BLIZZ_TARGET");
		CreateNpc("monsters/summon/summon_blizzard", blizzPos, self, AnglesOf(ENT_ME), "DMG_BLIZZ", 20.0f);
		OnNpcatkResumeAi();
	}

	// do_kick
	void DragoonBossBase_OnDoKick()
	{
		CallEventDelayed(FREQ_KICK, "do_kick");

		OnCheckLegalAct();
		if (!LEGAL_ACT)
			return;

		int kickType = RandomInt(1, 3);
		if (kickType <= 2)
			NEXT_ATTACK = Float(ANIM_KICK_HIGH);
		if (kickType == 3)
			NEXT_ATTACK = Float(ANIM_KICK_LOW);
	}

	// do_volcano
	void DragoonBossBase_OnDoVolcano()
	{
		string freqVolcano = "FREQ_VOLCANO";

		OnCheckLegalAct();

		if (DOING_NOVA)
			freqVolcano = "5.0";
		if (!LEGAL_ACT)
			freqVolcano = "5.0";

		// dbg checking vocano ( innova DOING_NOVA legal LEGAL_ACT )
		CallEventOrDelay(freqVolcano, "do_volcano");

		if (!LEGAL_ACT)
			return;
		if (DOING_NOVA)
			return;

		NOVA_ATTACK = "volcano";
		AS_ATTACKING = 20.0f;
		PlayAnim("critical", ANIM_SPELL);
	}

	// do_scatter_shot
	void DragoonBossBase_OnDoScatterShot()
	{
		string arrowType = "ARROW_TYPE";
		SCATTER_COUNT += 1.0f;
		if (SCATTER_COUNT < 10.0f)
			CallEventDelayed(0.1f, "do_scatter_shot");
		PlaySound(0, 10, SOUND_BOW_SHOOT);
		int rndArrow = RandomInt(1, 3);
		string finDmgText = "DMG_ARROW";
		float finDmg = 0.0f;
		if (rndArrow == 1)
			arrowType = "proj_arrow_frost";
		if (rndArrow == 2)
			arrowType = "proj_arrow_gpoison";
		if (rndArrow == 3)
		{
			arrowType = "proj_arrow_jagged";
			finDmg *= 4.0f;
			finDmgText = Text(finDmg);
		}
		// <projectile scriptname> <"view"|(src_origin)> <target|(targ_origin)> <speed> <damage> <cof> <skill|none>
		TossProjectile(arrowType, RelativePosition(Vector3(0, 32, 32)), "none", ARROW_SPEED, finDmgText, 10, "none"); // Converted to use new tossprojectile //greatguys1@FEB2022
		CallExternal(ENT_LASTPROJECTILE, "ext_lighten", 0.1f);
	}

	// axe_fast
	// ================================ ATTACK ANIMS - BEGIN
	void DragoonBossBase_OnAxeFast()
	{
		BB_IN_ATTACK = false;

		if (Text(NEXT_ATTACK) != "unset")
		{
			ANIM_ATTACK = Text(NEXT_ATTACK);
			NEXT_ATTACK = 0.0f;
		}

		OnNpcatkDodamage(NPCATK_TARGET, Text(ATTACK_HITRANGE), "DMG_AXE_FAST", ATTACK_HITCHANCE, "slash");
		NORM_ATTACK = true;
	}

	// axe_slow
	// used by mace, and periodically by axe
	void DragoonBossBase_OnAxeSlow()
	{
		BB_IN_ATTACK = false;

		if (Text(NEXT_ATTACK) != "unset")
		{
			ANIM_ATTACK = Text(NEXT_ATTACK);
			NEXT_ATTACK = 0.0f;
		}

		NORM_ATTACK = true;
		OnNpcatkDodamage(NPCATK_TARGET, Text(ATTACK_HITRANGE), "DMG_AXE_SLOW", ATTACK_HITCHANCE, "blunt");
	}

	// sword_fast
	void DragoonBossBase_OnSwordFast()
	{
		BB_IN_ATTACK = false;

		if (Text(NEXT_ATTACK) != "unset")
		{
			ANIM_ATTACK = Text(NEXT_ATTACK);
			NEXT_ATTACK = 0.0f;
		}

		NORM_ATTACK = true;
		OnNpcatkDodamage(NPCATK_TARGET, Text(ATTACK_HITRANGE), "DMG_SWORD_FAST", ATTACK_HITCHANCE, "slash");
	}

	// sword_slow
	// used by sword and periodically by mace
	void DragoonBossBase_OnSwordSlow()
	{
		BB_IN_ATTACK = false;

		if (Text(NEXT_ATTACK) != "unset")
		{
			ANIM_ATTACK = Text(NEXT_ATTACK);
			NEXT_ATTACK = 0.0f;
		}

		NORM_ATTACK = true;
		OnNpcatkDodamage(NPCATK_TARGET, Text(ATTACK_HITRANGE), "DMG_SWORD_SLOW", ATTACK_HITCHANCE, "slash");
	}

	// swing_slow
	void DragoonBossBase_OnSwingSlow()
	{
		BB_IN_ATTACK = false;

		if (Text(NEXT_ATTACK) != "unset")
		{
			ANIM_ATTACK = Text(NEXT_ATTACK);
			NEXT_ATTACK = 0.0f;
		}

		NORM_ATTACK = true;
		OnNpcatkDodamage(NPCATK_TARGET, Text(ATTACK_HITRANGE), "DMG_SWING_SLOW", ATTACK_HITCHANCE, "slash");
	}

	// swing_fast
	void DragoonBossBase_OnSwingFast()
	{
		BB_IN_ATTACK = false;

		if (Text(NEXT_ATTACK) != "unset")
		{
			ANIM_ATTACK = Text(NEXT_ATTACK);
			NEXT_ATTACK = 0.0f;
		}
		NORM_ATTACK = true;
		OnNpcatkDodamage(NPCATK_TARGET, Text(ATTACK_HITRANGE), "DMG_SWING_FAST", ATTACK_HITCHANCE, "slash");
	}

	// attack_jab
	void DragoonBossBase_OnAttackJab()
	{
		bool exitSub = false;
		BB_IN_ATTACK = false;

		if (Text(NEXT_ATTACK) != "unset")
		{
			ANIM_ATTACK = Text(NEXT_ATTACK);
			NEXT_ATTACK = 0.0f;
		}

		if (DOING_PULL)
		{
			DOING_PULL = false;
			exitSub = true;
		}
		if (exitSub)
			return;

		OnNpcatkDodamage(NPCATK_TARGET, Text(ATTACK_HITRANGE), Text(DMG_DAGGER), ATTACK_HITCHANCE, "slash");

		// dagger bandit re-flanks periodically
		if (RandomInt(1, 20) == 1 && !FLANK_DELAY)
		{
			FLANK_DELAY = true;
			CallEventDelayed(FREQ_FLANK, "flank_delay_reset");
			OnNpcatkFlank(NPCATK_TARGET);
		}
	}

	// prep_done
	void DragoonBossBase_OnPrepDone()
	{
		BB_IN_ATTACK = false;

		PlaySound(0, 10, SOUND_SATTACK);
		CreateNpc("monsters/summon/flame_burst", RelativePosition(Vector3(0, 0, 0)), self, "DMG_FLAME_BURST", 1);
	}

	// bow_shoot
	void DragoonBossBase_OnBowShoot()
	{
		BB_IN_ATTACK = false;

		if (Text(NEXT_ATTACK) != "unset")
		{
			ANIM_ATTACK = Text(NEXT_ATTACK);
			NEXT_ATTACK = 0.0f;
		}

		PlaySound(0, 10, SOUND_BOW_SHOOT);

		if (!SCATTER_SHOT)
		{
			// fires magic darts of various size, larger do more damage, but are slower
			BALL_SIZE = Random(1, 9);
			BALL_SPEED = 1000.0f;
			float ballSadj = 90.0f * BALL_SIZE;
			BALL_SPEED -= ballSadj;
			BALL_DMG = BALL_SIZE * 30.0f;

			// local BALL_TARG $get(NPCATK_TARGET,origin)
			// //dbg temp magic_dart size BALL_SIZE spd BALL_SPEED dmg BALL_DMG
			// createnpc monsters/summon/magic_dart $relpos(0,BALL_OFS,92) $get(ent_me,id) BALL_TARG BALL_SIZE BALL_SPEED BALL_DMG
			Vector3 ofsAdj = RelativePosition(Vector3(0, 28, 36));
			if (RangeTo(NPCATK_TARGET) < 100.0f)
				ofsAdj = RelativePosition(Vector3(0, 28, -12));
			// <projectile scriptname> <"view"|(src_origin)> <target|(targ_origin)> <speed> <damage> <cof> <skill|none>
			TossProjectile("proj_mana", ofsAdj, "none", BALL_SPEED, BALL_DMG, 1, "none"); // Converted to use new tossprojectile
		}

		if (SCATTER_SHOT)
		{
			PlaySound(0, 10, SOUND_SATTACK);
			SCATTER_SHOT = false;
			SCATTER_COUNT = 0.0f;
			OnDoScatterShot();
		}
	}

	// bow_stretch
	void DragoonBossBase_OnBowStretch()
	{
		BB_IN_ATTACK = false;
		PlaySound(0, 10, SOUND_BOW_STRETCH);
	}

	// sound_fast
	void DragoonBossBase_OnSoundFast()
	{
		if (Text(NEXT_ATTACK) == "unset")
			PlaySound(0, 10, SOUND_SWING_FAST);
		if (Text(NEXT_ATTACK) != "unset" && Text(NEXT_ATTACK) != ANIM_KICK_HIGH && Text(NEXT_ATTACK) != ANIM_KICK_LOW)
			PlaySound(0, 10, SOUND_POWERUP);
	}

	// sound_slow
	void DragoonBossBase_OnSoundSlow()
	{
		if (Text(NEXT_ATTACK) == "unset")
			PlayRandomSound(0, 8, SOUND_SWING_SLOW1, SOUND_SWING_SLOW2);
		if (Text(NEXT_ATTACK) != "unset" && Text(NEXT_ATTACK) != ANIM_KICK_HIGH && Text(NEXT_ATTACK) != ANIM_KICK_LOW)
		{
			Effect("glow", ENT_ME, Vector3(255, 255, 255), 128, 2, 2);
			PlaySound(0, 10, SOUND_POWERUP);
		}
	}

	// leap_scan
	// ================================ ATTACK ANIMS - END
	// =================================== LEAP/CHARGE SEQUENCE - BEGIN
	void DragoonBossBase_OnLeapScan()
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

	// leap_at
	// <target>
	void DragoonBossBase_OnLeapAt(string target = "")
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
	void DragoonBossBase_OnLeapAt2()
	{
		PlaySound(0, 10, SOUND_LEAP);
		AS_ATTACKING = GameTime();
		PlayAnim("critical", ANIM_LEAP);
		CallEventDelayed(0.1f, "bandit_charge");
		CallEventDelayed(1.0f, "reset_leaping");
		CallEventDelayed(0.9f, "bullrush_stun");
	}

	// bandit_charge
	void DragoonBossBase_OnBanditCharge()
	{
		AddVelocity(ENT_ME, RelativeVelocity(Vector3(0, 400, 100)));
	}

	// reset_leaping
	void DragoonBossBase_OnResetLeaping()
	{
		AM_LEAPING = false;
	}

	// bullrush_stun
	void DragoonBossBase_OnBullrushStun()
	{
		CreateNpc("monsters/summon/stun_burst", RelativePosition(Vector3(0, 60, 0)), self, 256, 1, 150); // <owner> <range> [toss1|0] [damage]
	}

	// leap_away
	// <target>
	void DragoonBossBase_OnLeapAway(string target = "")
	{
		// dbg leap_away PARAM2
		AM_LEAPING = true;
		NPC_FORCED_MOVEDEST = true;
		OnNpcatkSuspendAi("1.0");
		SetMoveDest(target, 800, "flee");
		CallEventDelayed(0.1f, "leap_away2");
	}

	// leap_away2
	void DragoonBossBase_OnLeapAway2()
	{
		PlaySound(0, 10, SOUND_LEAP);
		AS_ATTACKING = GameTime();
		PlayAnim("critical", ANIM_HOP);
		CallEventDelayed(0.1f, "bandit_hop");
		CallEventDelayed(1.0f, "reset_leaping");
	}

	// bandit_hop
	void DragoonBossBase_OnBanditHop()
	{
		int jumpHeight = RandomInt(350, 450);
		AddVelocity(ENT_ME, RelativeVelocity(Vector3(0, 250, jumpHeight)));
	}

	// flank_delay_reset
	// =================================== LEAP/CHARGE SEQUENCE - END
	void DragoonBossBase_OnFlankDelayReset()
	{
		FLANK_DELAY = false;
	}

	// my_target_died
	void DragoonBossBase_OnMyTargetDied(string offender = "")
	{
		// dbg temp MY TARGET DIED
		CallEventDelayed(0.1f, "taunt_sound");
		AS_ATTACKING = GameTime();
		if (DRINKING_POT)
			return;
		if (Truthy(ScriptVarOf(offender, "I_R_PET")))
			return;
		PlayAnim("critical", "aim_punch1");
	}

	// taunt_sound
	void DragoonBossBase_OnTauntSound()
	{
		PlayRandomSound(0, 10, SOUND_TAUNT1, SOUND_TAUNT2);
	}

	// glow_loop
	void DragoonBossBase_OnGlowLoop()
	{
		if (!GLOW_ON)
			return;
		CallEventDelayed(5.1f, "glow_loop");
		Effect(ENT_ME, "glow", GLOW_LOOP_COLOR, 128, 5, 0);
	}

	// game_struck
	void DragoonBossBase_OnGameStruck(float damage = 0.0f, string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		PlayRandomSound(0, 8, SOUND_PAIN, SOUND_PAIN2, "none", "none");
	}

	// check_legal_act
	void DragoonBossBase_OnCheckLegalAct()
	{
		LEGAL_ACT = true;

		if (I_R_FROZEN)
			LEGAL_ACT = false;
		if (ANIM_ATTACK == ANIM_KICK_HIGH)
			LEGAL_ACT = false;
		if (ANIM_ATTACK == ANIM_KICK_LOW)
			LEGAL_ACT = false;
		if (IS_FLEEING)
			LEGAL_ACT = false;
		if (SUSPEND_AI)
			LEGAL_ACT = false;
		if (DRINKING_POT)
			LEGAL_ACT = false;
	}

	// unnamed block (timer)
	void DragoonBossBase_Timer()
	{
		CallEventDelayed(2.0f, "DragoonBossBase_Timer");

		// something in this script is causing BD periodically
		// prevention measure/hack
		if (SUSPEND_AI)
			BD_COUNT += 1.0f;
		if (!SUSPEND_AI)
			BD_COUNT = 0.0f;
		if (BD_COUNT > 20.0f)
			OnNpcatkResumeAi();
	}

	// npcatk_attack
	// JUN2007b
	// slow swinging banidts have an odd bug where if you 'dance' in front of them they
	// keep starting their attack animation over and over again (and thus, never swing)
	// this is an effort to fix that
	// ( [override] npcatk_attack callevent npcatk_attack_hack - if you need atack hack, see below )
	void DragoonBossBase_OnNpcatkAttack()
	{
		if (NPC_NO_ATTACK)
			return;
		OnNpcSelectattack(); // give chance for mon to chose an anim (external) (old naming convention for compatiblity)
		PlayAnim("once", ANIM_ATTACK);
		ATTACK_ANIMINDEX = AnimIndexOf(ENT_ME);
		// dbg temp npcatk_attack attackanimindex ATTACK_INDEX
		ATTACK_MOVERANGE = 9999.0f;
		NPC_NO_MOVE = true;
	}

	// npcatk_hunt
	void DragoonBossBase_OnNpcatkHunt()
	{
		if (ATTACK_ANIMINDEX == AnimIndexOf(ENT_ME))
		{
			NPC_NO_MOVE = true;
			NPC_FORCED_MOVEDEST = true;
			SetMoveDest(NPCATK_TARGET, 9999);
			AS_ATTACKING = 5.0f;
		}

		if (ATTACK_ANIMINDEX == AnimIndexOf(ENT_ME))
			return;
		ATTACK_MOVERANGE = ORIG_MOVE_RANGE;
		NPC_NO_MOVE = false;
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)
	void OnGamePrecache() { DragoonBossBase_OnGamePrecache(); } // game_precache

	// normal_immune
	void OnNormalImmune()
	{
		MonstersExternals_OnNormalImmune(); // monsters/externals
		DragoonBossBase_OnNormalImmune();
	}

	// npc_post_spawn
	void OnNpcPostSpawn()
	{
		MonstersExternals_OnNpcPostSpawn(); // monsters/externals
		MonstersExternals_OnNpcPostSpawn_2(); // monsters/externals
		MonstersExternals_OnNpcPostSpawn_3(); // monsters/externals
		BaseSelfAdjust_OnNpcPostSpawn(); // monsters/base_self_adjust
		BaseNpc_OnNpcPostSpawn(); // monsters/base_npc
		BaseMonsterShared_OnNpcPostSpawn(); // monsters/base_monster_shared
		DragoonBossBase_OnNpcPostSpawn();
	}

	// game_struck
	void OnGameStruck(float damage = 0.0f, string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		BaseNpc_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseNpcAttackNew_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc_attack_new
		BaseMonsterShared_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared
		DragoonBossBase_OnGameStruck(damage, extraValue2, extraValue3, extraValue4);
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseNpcAttackNew_OnNpcSpawn(npc); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck
		DragoonBossBase_OnNpcSpawn(npc);
	}

	// npcatk_hunt
	void OnNpcatkHunt()
	{
		BaseNpcAttackNew_OnNpcatkHunt(); // monsters/base_npc_attack_new
		BaseAntiStuck_OnNpcatkHunt(); // monsters/base_anti_stuck
		DragoonBossBase_OnNpcatkHunt();
	}

	// my_target_died
	void OnMyTargetDied(string offender = "")
	{
		BaseNpcAttackNew_OnMyTargetDied(offender); // monsters/base_npc_attack_new
		DragoonBossBase_OnMyTargetDied(offender);
	}

	// npcatk_resume_ai
	void OnNpcatkResumeAi(string target = "")
	{
		BaseNpcAttackNew_OnNpcatkResumeAi(target); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcatkResumeAi(target); // monsters/base_monster_shared
		BaseMonsterShared_OnNpcatkResumeAi_2(target); // monsters/base_monster_shared
		DragoonBossBase_OnNpcatkResumeAi(target);
	}

	// game_dodamage
	string OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";
		result = AppendResult(result, BaseNpcAttackNew_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BaseAntiStuck_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BaseMonsterShared_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, DragoonBossBase_OnGameDodamage(hit, target, start, end, damageType, damageText));
		return result;
	}

	// cycle_up
	void OnCycleUp(string reason = "")
	{
		BaseNpcAttackNew_OnCycleUp(reason); // monsters/base_npc_attack_new
		DragoonBossBase_OnCycleUp(reason);
	}

	// game_damaged - Return a damage multiplier to scale the damage
	string OnGameDamaged(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float accuracyRoll = 0.0f, CBaseEntity@ inflictor = null, string skill = "")
	{
		string result = "";
		result = AppendResult(result, BaseAntiStuck_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, BaseMonsterShared_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, BaseMonsterShared_OnGameDamaged_2(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, DragoonBossBase_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		return result;
	}

	// game_parry
	void OnGameParry(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float parryRoll = 0.0f, float accuracyRoll = 0.0f, float parryValue = 0.0f)
	{
		BaseMonsterShared_OnGameParry(attacker, damage, damageType, parryRoll, accuracyRoll, parryValue); // monsters/base_monster_shared
		DragoonBossBase_OnGameParry(attacker, damage, damageType, parryRoll, accuracyRoll, parryValue);
	}

	void OnSetupBoss() { DragoonBossBase_OnSetupBoss(); } // setup_boss
	void OnResetAvoidDelay() { DragoonBossBase_OnResetAvoidDelay(); } // reset_avoid_delay
	void OnResetSweepKickDelay() { DragoonBossBase_OnResetSweepKickDelay(); } // reset_sweep_kick_delay
	void OnResetHealthPotDelay() { DragoonBossBase_OnResetHealthPotDelay(); } // reset_health_pot_delay
	void OnResetPullDelay() { DragoonBossBase_OnResetPullDelay(); } // reset_pull_delay
	void OnDrinkSpecial() { DragoonBossBase_OnDrinkSpecial(); } // drink_special
	void OnDrinkPot(string drinkType = "") { DragoonBossBase_OnDrinkPot(drinkType); } // drink_pot
	void OnDrinkDone() { DragoonBossBase_OnDrinkDone(); } // drink_done
	void OnNpcFlinch(float damage = 0.0f) { DragoonBossBase_OnNpcFlinch(damage); } // npc_flinch
	void OnNpcatkCheckflinch(string incomingDamage = "") { DragoonBossBase_OnNpcatkCheckflinch(incomingDamage); } // npcatk_checkflinch
	void OnEndSpecialEffect() { DragoonBossBase_OnEndSpecialEffect(); } // end_special_effect
	void OnTurboOn() { DragoonBossBase_OnTurboOn(); } // turbo_on
	void OnStuckFix() { DragoonBossBase_OnStuckFix(); } // stuck_fix
	void OnDoTurbo() { DragoonBossBase_OnDoTurbo(); } // do_turbo
	void OnTurboOff() { DragoonBossBase_OnTurboOff(); } // turbo_off
	void OnTractorBeam() { DragoonBossBase_OnTractorBeam(); } // tractor_beam
	void OnTractorBeam2() { DragoonBossBase_OnTractorBeam2(); } // tractor_beam2
	void OnTractorBeam3() { DragoonBossBase_OnTractorBeam3(); } // tractor_beam3
	void OnKickLow() { DragoonBossBase_OnKickLow(); } // kick_low
	void OnKickHigh() { DragoonBossBase_OnKickHigh(); } // kick_high
	void OnDoSpecial() { DragoonBossBase_OnDoSpecial(); } // do_special
	void OnResetDoingNova() { DragoonBossBase_OnResetDoingNova(); } // reset_doing_nova
	void OnDoFireWall() { DragoonBossBase_OnDoFireWall(); } // do_fire_wall
	void OnDoFireball() { DragoonBossBase_OnDoFireball(); } // do_fireball
	void OnDoSphere() { DragoonBossBase_OnDoSphere(); } // do_sphere
	void OnGoBlizz() { DragoonBossBase_OnGoBlizz(); } // go_blizz
	void OnDoKick() { DragoonBossBase_OnDoKick(); } // do_kick
	void OnDoVolcano() { DragoonBossBase_OnDoVolcano(); } // do_volcano
	void OnDoScatterShot() { DragoonBossBase_OnDoScatterShot(); } // do_scatter_shot
	void OnAxeFast() { DragoonBossBase_OnAxeFast(); } // axe_fast
	void OnAxeSlow() { DragoonBossBase_OnAxeSlow(); } // axe_slow
	void OnSwordFast() { DragoonBossBase_OnSwordFast(); } // sword_fast
	void OnSwordSlow() { DragoonBossBase_OnSwordSlow(); } // sword_slow
	void OnSwingSlow() { DragoonBossBase_OnSwingSlow(); } // swing_slow
	void OnSwingFast() { DragoonBossBase_OnSwingFast(); } // swing_fast
	void OnAttackJab() { DragoonBossBase_OnAttackJab(); } // attack_jab
	void OnPrepDone() { DragoonBossBase_OnPrepDone(); } // prep_done
	void OnBowShoot() { DragoonBossBase_OnBowShoot(); } // bow_shoot
	void OnBowStretch() { DragoonBossBase_OnBowStretch(); } // bow_stretch
	void OnSoundFast() { DragoonBossBase_OnSoundFast(); } // sound_fast
	void OnSoundSlow() { DragoonBossBase_OnSoundSlow(); } // sound_slow
	void OnLeapScan() { DragoonBossBase_OnLeapScan(); } // leap_scan
	void OnLeapAt(string target = "") { DragoonBossBase_OnLeapAt(target); } // leap_at
	void OnLeapAt2() { DragoonBossBase_OnLeapAt2(); } // leap_at2
	void OnBanditCharge() { DragoonBossBase_OnBanditCharge(); } // bandit_charge
	void OnResetLeaping() { DragoonBossBase_OnResetLeaping(); } // reset_leaping
	void OnBullrushStun() { DragoonBossBase_OnBullrushStun(); } // bullrush_stun
	void OnLeapAway(string target = "") { DragoonBossBase_OnLeapAway(target); } // leap_away
	void OnLeapAway2() { DragoonBossBase_OnLeapAway2(); } // leap_away2
	void OnBanditHop() { DragoonBossBase_OnBanditHop(); } // bandit_hop
	void OnFlankDelayReset() { DragoonBossBase_OnFlankDelayReset(); } // flank_delay_reset
	void OnTauntSound() { DragoonBossBase_OnTauntSound(); } // taunt_sound
	void OnGlowLoop() { DragoonBossBase_OnGlowLoop(); } // glow_loop
	void OnCheckLegalAct() { DragoonBossBase_OnCheckLegalAct(); } // check_legal_act
	void OnNpcatkAttack() { DragoonBossBase_OnNpcatkAttack(); } // npcatk_attack
	void OnFreqFlank() {} // FREQ_FLANK
	void OnFreqHealth() {} // FREQ_HEALTH
	void OnFreqInvis() {} // FREQ_INVIS
	void OnFreqKick() {} // FREQ_KICK
	void OnFreqPull() {} // FREQ_PULL
	void OnFreqSpecial() {} // FREQ_SPECIAL
	void OnFreqTurbo() {} // FREQ_TURBO
	void OnLFreqSpecial() {} // L_FREQ_SPECIAL
	void OnLFreqVolcano() {} // L_FREQ_VOLCANO

	// This file's events and timers by their .script names
	bool DragoonBossBase_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "attack_jab") { OnAttackJab(); return true; }
		if (name == "axe_fast") { OnAxeFast(); return true; }
		if (name == "axe_slow") { OnAxeSlow(); return true; }
		if (name == "bandit_charge") { OnBanditCharge(); return true; }
		if (name == "bandit_hop") { OnBanditHop(); return true; }
		if (name == "bow_shoot") { OnBowShoot(); return true; }
		if (name == "bow_stretch") { OnBowStretch(); return true; }
		if (name == "bullrush_stun") { OnBullrushStun(); return true; }
		if (name == "check_legal_act") { OnCheckLegalAct(); return true; }
		if (name == "cycle_up") { OnCycleUp(Param(params, 0)); return true; }
		if (name == "do_fire_wall") { OnDoFireWall(); return true; }
		if (name == "do_fireball") { OnDoFireball(); return true; }
		if (name == "do_kick") { OnDoKick(); return true; }
		if (name == "do_scatter_shot") { OnDoScatterShot(); return true; }
		if (name == "do_special") { OnDoSpecial(); return true; }
		if (name == "do_sphere") { OnDoSphere(); return true; }
		if (name == "do_turbo") { OnDoTurbo(); return true; }
		if (name == "do_volcano") { OnDoVolcano(); return true; }
		if (name == "drink_done") { OnDrinkDone(); return true; }
		if (name == "drink_pot") { OnDrinkPot(Param(params, 0)); return true; }
		if (name == "drink_special") { OnDrinkSpecial(); return true; }
		if (name == "end_special_effect") { OnEndSpecialEffect(); return true; }
		if (name == "flank_delay_reset") { OnFlankDelayReset(); return true; }
		if (name == "game_damaged") { Return(OnGameDamaged(EntityParam(params, 0), Float(Param(params, 1)), Param(params, 2), Float(Param(params, 3)), EntityParam(params, 4), Param(params, 5))); return true; }
		if (name == "game_dodamage") { Return(OnGameDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5))); return true; }
		if (name == "game_parry") { OnGameParry(EntityParam(params, 0), Float(Param(params, 1)), Param(params, 2), Float(Param(params, 3)), Float(Param(params, 4)), Float(Param(params, 5))); return true; }
		if (name == "game_precache") { OnGamePrecache(); return true; }
		if (name == "game_struck") { OnGameStruck(Float(Param(params, 0)), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "glow_loop") { OnGlowLoop(); return true; }
		if (name == "go_blizz") { OnGoBlizz(); return true; }
		if (name == "kick_high") { OnKickHigh(); return true; }
		if (name == "kick_low") { OnKickLow(); return true; }
		if (name == "leap_at") { OnLeapAt(Param(params, 0)); return true; }
		if (name == "leap_at2") { OnLeapAt2(); return true; }
		if (name == "leap_away") { OnLeapAway(Param(params, 0)); return true; }
		if (name == "leap_away2") { OnLeapAway2(); return true; }
		if (name == "leap_scan") { OnLeapScan(); return true; }
		if (name == "my_target_died") { OnMyTargetDied(Param(params, 0)); return true; }
		if (name == "normal_immune") { OnNormalImmune(); return true; }
		if (name == "npc_flinch") { OnNpcFlinch(Float(Param(params, 0))); return true; }
		if (name == "npc_post_spawn") { OnNpcPostSpawn(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "npcatk_attack") { OnNpcatkAttack(); return true; }
		if (name == "npcatk_checkflinch") { OnNpcatkCheckflinch(Param(params, 0)); return true; }
		if (name == "npcatk_hunt") { OnNpcatkHunt(); return true; }
		if (name == "npcatk_resume_ai") { OnNpcatkResumeAi(Param(params, 0)); return true; }
		if (name == "prep_done") { OnPrepDone(); return true; }
		if (name == "reset_avoid_delay") { OnResetAvoidDelay(); return true; }
		if (name == "reset_doing_nova") { OnResetDoingNova(); return true; }
		if (name == "reset_health_pot_delay") { OnResetHealthPotDelay(); return true; }
		if (name == "reset_leaping") { OnResetLeaping(); return true; }
		if (name == "reset_pull_delay") { OnResetPullDelay(); return true; }
		if (name == "reset_sweep_kick_delay") { OnResetSweepKickDelay(); return true; }
		if (name == "setup_boss") { OnSetupBoss(); return true; }
		if (name == "sound_fast") { OnSoundFast(); return true; }
		if (name == "sound_slow") { OnSoundSlow(); return true; }
		if (name == "stuck_fix") { OnStuckFix(); return true; }
		if (name == "swing_fast") { OnSwingFast(); return true; }
		if (name == "swing_slow") { OnSwingSlow(); return true; }
		if (name == "sword_fast") { OnSwordFast(); return true; }
		if (name == "sword_slow") { OnSwordSlow(); return true; }
		if (name == "taunt_sound") { OnTauntSound(); return true; }
		if (name == "tractor_beam") { OnTractorBeam(); return true; }
		if (name == "tractor_beam2") { OnTractorBeam2(); return true; }
		if (name == "tractor_beam3") { OnTractorBeam3(); return true; }
		if (name == "turbo_off") { OnTurboOff(); return true; }
		if (name == "turbo_on") { OnTurboOn(); return true; }
		if (name == "DragoonBossBase_Timer") { DragoonBossBase_Timer(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "furion/dragoons/dragoon_boss_base"]
shared class DragoonBossBaseScript : BaseMonsterNewScript, DragoonBossBase
{
	// Variables declared by included files, with the value they start with in this script
	DragoonBossBaseScript()
	{
		NPC_BOSS_RESTORATION = 0.25f;
		ANIM_WALK = "walk2";
		ANIM_RUN = "run";
		SOUND_DEATH = "voices/big_death.wav";
		FLINCH_DAMAGE_THRESHOLD = 75.0f;
		BASE_FRAMERATE = "3.0";
		BASE_MOVESPEED = 3.0f;
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("fur/npcs/dragoonlord.mdl");
		Precache("nhth1.spr");
		Precache("monsters/bat.mdl");
		CallEventDelayed(2.0f, "DragoonBossBase_Timer");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		DragoonBossBase_FirstThink();
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
		return DragoonBossBase_DispatchEvent(name, params)
			|| BaseMonsterNewScript::DispatchEvent(name, params);
	}
}
