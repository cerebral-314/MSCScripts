#pragma context server

// Converted from monsters/bandit_boss.script by msc_transpiler.
// This is an older script and may have some bad conventions as a result
// Bandit Boss for The_Keep by Thothie from scratch
// BOSS_TYPES
// 1 = Fire Dagger - Flame burst, turbo move, leap, invisiblity / teleport
// 2 = Dark Maul - slow, heavy damage, lots of HP, pull move, large AOE stun
// 3 = Rune Axe - Fast swing, large AOE stun charge, pull move
// 4 = Greater ice Blade - Slow swing, heavy damage, Freeze solid, blizzard (aim at distant), freezing sphere
// 5 = Orion Bow - fires magic arrows of various size, scatter arrows of various types, invisiblity / teleport
// 6 = Nova Blade - Flame Burst, Flaming Skull, Volcano, Huge fireball, Firewall, parry
// All types have 50% armor, stunning kicks
// All types can pull potions randomly (limit: 8 - 3 health, 3 resistance, 2 enhance [demon,speed,protect] )
// Drinks resistance potion if struck 5 times by element for more than 50 damage
// bug: Plevmus - getting stuck in flame burst loop
// =bug: Plevmus - flanking sucks
// =bug: Plevmus - flame burst doing 180 damage from ambient burn?
// bug: axer spins in place just prior to charge atk
// bug: axer charge attack timing is way off
// bug: axer never switches to fast swing?
// =bug: pull beam not drawing (also needs sound)
// bug: (model) sweep kick a bit off ground
// =bug: (6) - nova blade spells not appearing?
// =bug: archers arrows not moving

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_monster_new.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class BanditBoss
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
	string ANIM_HOP = "long_jump";
	string ANIM_LEAP = "long_jump";
	string SOUND_PARRY = "weapons/parry.wav";
	string SOUND_POWERUP = "voices/big_swordready.wav";
	string SOUND_LEAP = "voices/big_shout1.wav";
	string SOUND_SATTACK = "voices/big_shout1.wav";
	string SOUND_TAUNT1 = "voices/big_yeah1.wav";
	string SOUND_TAUNT2 = "voices/big_taunt1.wav";
	string SOUND_PULL = "voices/big_pull.wav";
	string SOUND_SWING_FAST = "weapons/cbar_miss1.wav";
	string SOUND_SWING_SLOW1 = "zombie/claw_miss1.wav";
	string SOUND_SWING_SLOW2 = "zombie/claw_miss2.wav";
	string SOUND_DEATH = "voices/big_death.wav";
	string SOUND_BOW_STRETCH = "weapons/bow/stretch.wav";
	string SOUND_BOW_SHOOT = "weapons/bow/crossbow.wav";
	string SOUND_PAIN = "voices/big_chesthit1.wav";
	string SOUND_PAIN2 = "voices/big_armhit1.wav";
	float FREQ_HEALTH = 20.0f;
	float FREQ_PULL = 10.0f;
	float FREQ_KICK = 0.0f;
	float FREQ_VOLCANO = 45.0f;
	float FREQ_TURBO = 0.0f;
	float FREQ_SPECIAL = 0.0f;
	int FREQ_INVIS = 0;
	float FREQ_FLANK = 5.0f;
	float FREQ_AVOID = 0.0f;
	float FREQ_SPACING = 1.5f;
	int SPACING_RANGE = 110;
	float KICK_HOLD = 3.0f;
	int HOP_DIST = 330;
	float LEAP_SUSPEND = 1.8f;
	float LEAP_CLEAR_DELAY = 1.5f;
	float FLINCH_DAMAGE_THRESHOLD = 75.0f;
	string ATTACK_HITCHANCE = "85%";
	string DMG_KICK = "DMG_KICK";
	float DMG_MACE = 0.0f;
	int DMG_SWORD_FAST = 0;
	int DMG_SWORD_SLOW = 0;
	int DMG_SWORD_JAB = 0;
	int DMG_SWING_FAST = 0;
	int DMG_SWING_SLOW = 0;
	int DMG_AXE_FAST = 0;
	int DMG_AXE_SLOW = 0;
	float DMG_DAGGER = 0.0f;
	int DMG_NOVA_SLOW = 0;
	int DMG_NOVA_FAST = 0;
	int DMG_SWORD_STAB = 0;
	int DMG_BURN_DAGGER = 0;
	int DMG_BURN_MACE = 0;
	int DMG_FLAME_BURST = 400;
	int DMG_FIRE_BALL = 200;
	int DMG_ARROW = 0;
	int DMG_BLIZ = 50;
	int DMG_SKULL = 60;
	int ELEMENT_LIMIT = 5;
	int ELEMENT_DMG_THRESH = 30;
	int ARROW_SPEED = 1200;
	float CHARGE_TIME = 1.3f;
	float CHARGE_FIRE_DELAY = 0.4f;
	float CHARGE_EXPIRE = 4.0f;
	int CHARGE_TICK_MAX = 10;
	float CHARGE_TICK_RATE = 0.08f;
	string SOUND_CHARGE = "ambience/alien_humongo.wav";
	int CHARGE_GAP_MIN = 8;
	int CHARGE_GAP_MAX = 14;
	int VOLLEY_GAP_MIN = 20;
	int VOLLEY_GAP_MAX = 34;
	int CHARGED_BALL_SIZE = 10;
	int CHARGED_BALL_SPEED = 200;
	int DMG_BALL_MULTI = 30;
	int BOLT_OFS_Z = 28;
	int BOLT_AIM_Z = 16;
	bool CHARGED_FLAT = false;
	bool FILLER_BALL_MIN = true;
	bool FILLER_BALL_MAX = true;
	int FILLER_BALL_SPEED = 450;
	int FILLER_DMG_MULTI = 45;
	float FILLER_HOLD = 1.2f;
	int ARROW_COF = 2;
	int SCATTER_COF = 5;
	float ARROW_GRAVITY = 0.1f;
	int AS_ATK_VALUE = 10;
	string BEAM_SPRITE = "lgtning.spr";
	string MONSTER_MODEL = "npc/bandit_boss.mdl";

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
	bool CHARGING_SHOT = false;
	bool CHARGED_SHOT = false;
	string BOW_CL_IDX = "BOW_CL_IDX";
	float POT_COUNT = 0.0f;
	float NO_FILLER_UNTIL = 0.0f;
	float NO_CHARGE_UNTIL = 0.0f;
	float FLEE_COUNT = 0.0f;
	int BOSS_TYPE = 0;
	string ANIM_ATTACK = "ANIM_ATTACK";
	float NPC_GIVE_EXP = 0.0f;
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
	bool AVOID_DELAY = false;
	bool HEALTH_POT_DELAY = false;
	bool DID_FIRST_POT = false;
	bool DID_SECOND_POT = false;
	CBaseEntity@ PULL_TARGET = null;
	bool PULL_DELAY = false;
	bool DRINKING_POT = false;
	string DRINK_TYPE = "DRINK_TYPE";
	bool USED_FIRE_POT = false;
	bool IN_RESIST = false;
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
	bool MELEE_HIT = false;
	bool FREEZE_ATTACK = false;
	bool STUN_ATTACK = false;
	bool NORM_ATTACK = false;
	bool CYCLES_ON = false;
	string LEAP_TARGET = "LEAP_TARGET";
	bool POWER_ATTACK = false;
	bool PURE_FLEE = false;
	string BLIZZ_TARGET = "BLIZZ_TARGET";
	bool SCATTER_SHOT = false;
	bool DOING_NOVA = false;
	string NOvA_TARGET = "NOvA_TARGET";
	string NOVA_ATTACK = "NOVA_ATTACK";
	bool NPC_NO_ATTACK = false;
	float CHARGE_TICKS = 0.0f;
	float BALL_SIZE = 0.0f;
	float BALL_DMG = 0.0f;
	float SCATTER_COUNT = 0.0f;
	bool BB_IN_ATTACK = false;
	bool FLANK_DELAY = false;
	int DMG_VOLCANO = 0;
	bool AM_LEAPING = false;
	bool NPC_FORCED_MOVEDEST = false;
	bool IS_FLEEING = false;
	bool LEGAL_ACT = false;
	int ATTACK_ANIMINDEX = 0;
	bool NPC_NO_MOVE = false;

	// unnamed block (first think)
	void BanditBoss_FirstThink()
	{
		if (ToLowerCase(MapName()) == "the_keep")
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
	void BanditBoss_OnGamePrecache()
	{
		PrecacheFile("monsters/summon/ice_blast");
		PrecacheFile("monsters/summon/summon_blizzard");
		PrecacheFile("monsters/summon/stun_burst");
		PrecacheFile("monsters/summon/flame_burst");
		PrecacheFile("monsters/summon/bandit_boss_fire_wall");
		PrecacheFile("monsters/summon/flame_burst");
		PrecacheFile("monsters/summon/npc_volcano");
		PrecacheFile("monsters/summon/flame_skull");
		PrecacheFile("helena/bandit_boss_chest");
		PrecacheFile("items/proj_mana_boss");
		PrecacheFile("items/proj_arrow_npc");
	}

	// npc_spawn
	void BanditBoss_OnNpcSpawn(string npc = "")
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

		HEALTH_AMMO = 1.0f;
		RESIST_AMMO = 2.0f;
		SPECIAL_AMMO = 2;
		FIRE_STRUCK = 0.0f;
		COLD_STRUCK = 0.0f;
		POISON_STRUCK = 0.0f;
		LIGHTNING_STRUCK = 0.0f;
		FAST_SWINGS = 0.0f;
		NEXT_ATTACK = 0.0f;
		BD_COUNT = 0.0f;
		NOVA_PICK_ATK = 0.0f;
		CHARGING_SHOT = false;
		CHARGED_SHOT = false;
		BOW_CL_IDX = "unset";
		POT_COUNT = 0.0f;
		NO_FILLER_UNTIL = 0.0f;
		NO_CHARGE_UNTIL = 0.0f;
		FLEE_COUNT = 0.0f;

		ANIM_RUN = "run";
		ANIM_WALK = "walk2";

		// setmodelbody 1 0 //unarmed
		// setmodelbody 1 1 //fire dagger
		// setmodelbody 1 2 //dark maul
		// setmodelbody 1 3 //Rune Axe
		// setmodelbody 1 4 //greater ice blade
		// setmodelbody 1 5 //orion bow
		// setmodelbody 1 6 //Nova Blade
		// setmodelbody 1 7 //potion - red
		// setmodelbody 1 8 //potion - green
		CallEventDelayed(0.1f, "setup_boss");
	}

	// setup_boss
	void BanditBoss_OnSetupBoss()
	{
		if (!Truthy(GetVar("BOSS_TYPE_OVERRIDE")))
			BOSS_TYPE = RandomInt(1, 6);

		if (BOSS_TYPE == 1)
		{
			SetName("Plevmus of the Hidden Knife");
			SetHealth(2500);
			SetModelBody(1, 1);
			ANIM_ATTACK = ANIM_JAB;
			SetSkillLevel(1000);
		}

		if (BOSS_TYPE == 2)
		{
			SetName("Golgar the Hammer");
			SetHealth(6000);
			SetModelBody(1, 2);
			ANIM_ATTACK = ANIM_AXE_SLOW;
			NPC_GIVE_EXP = 1000.0f;
		}

		if (BOSS_TYPE == 3)
		{
			SetName("Vultekh of the Runes");
			SetHealth(4000);
			SetModelBody(1, 3);
			ANIM_ATTACK = ANIM_AXE_FAST;
			NPC_GIVE_EXP = 1000.0f;
		}

		if (BOSS_TYPE == 4)
		{
			SetName("Kryoh of the Frozen Blade");
			SetHealth(3000);
			SetModelBody(1, 4);
			ATTACK_MOVERANGE = 256.0f;
			ANIM_ATTACK = ANIM_SWING_FAST;
			NPC_GIVE_EXP = 1500.0f;
		}

		if (BOSS_TYPE == 5)
		{
			SetName("Xaron of the Orion Bow");
			SetHealth(3000);
			SetModelBody(1, 5);
			ANIM_ATTACK = ANIM_BOW;
			NPC_GIVE_EXP = 2000.0f;
		}

		if (BOSS_TYPE == 6)
		{
			SetName("Demonicus of the Burning Blade");
			SetHealth(6000);
			SetModelBody(1, 6);
			SetStat("parry", 100);
			ANIM_ATTACK = ANIM_SWORD_FAST;
			NPC_GIVE_EXP = 500.0f; // reduced due to parry skill artificially raising it
		}

		if (ToLowerCase(MapName()) == "helena") // since you don't get much treasure
			NPC_GIVE_EXP *= 4.0f;

		SetMoveAnim(ANIM_WALK);

		string mapName = ToLowerCase(MapName());
		bool genericName = true;
		if (mapName == "keep_test")
			genericName = false;
		if (mapName == "the_keep")
			genericName = false;
		if (genericName)
			SetName("Bandit Leader");

		SetInvincible(false);
	}

	// npc_post_spawn
	void BanditBoss_OnNpcPostSpawn()
	{
		ORIG_MOVE_RANGE = ATTACK_MOVERANGE;

		HALF_HEALTH = Divide(MyMaxHealth(), 2.0f);

		FIRST_SPEC_POT_HEALTH = MyMaxHealth() * 0.75f;

		QUARTER_HEALTH = MyMaxHealth() * 0.25f;

		ORIG_ATTACK = ANIM_ATTACK;
		ORIG_WEAPON = BOSS_TYPE;

		if (BOSS_TYPE == 1)
			FREQ_ATTACK = 0.25f;
		if (BOSS_TYPE == 2)
			FREQ_ATTACK = 2.0f;
		if (BOSS_TYPE == 3)
			FREQ_ATTACK = 1.75f;
		if (BOSS_TYPE == 4)
			FREQ_ATTACK = 0.25f;
		if (BOSS_TYPE == 5)
			FREQ_ATTACK = 0.1f;
		if (BOSS_TYPE == 6)
			FREQ_ATTACK = 1.5f;
		ORIG_FREQ_ATTACK = FREQ_ATTACK;
	}

	// game_damaged
	// PARAM1=attacker PARAM2=Damage PARAM3=DamageType
	string BanditBoss_OnGameDamaged(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float accuracyRoll = 0.0f, CBaseEntity@ inflictor = null, string skill = "")
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

		if (BOSS_TYPE == 5)
		{
			// archer will sometimes leap away when attacked by melee (or kick attacker away)
			if (RangeTo(attacker) < 120.0f && !AVOID_DELAY && !DRINKING_POT && !CHARGING_SHOT)
			{
				AVOID_DELAY = true;
				CallEventDelayed(FREQ_AVOID, "reset_avoid_delay");
				int avoidType = RandomInt(1, 3);
				AS_ATTACKING = GameTime();
				if (avoidType == 1)
					OnLeapAway(EntityId(attacker));
				if (avoidType == 2)
					PlayAnim("critical", ANIM_KICK_HIGH);
				if (avoidType == 3)
					PlayAnim("critical", ANIM_KICK_LOW);
				if (avoidType > 1)
					CallEventDelayed(1.0f, "reset_attack_anim");
			}
		}

		// drink health pot when low on health
		if (HEALTH_AMMO > 0.0f && !DRINKING_POT && MyHealth() < HALF_HEALTH && !HEALTH_POT_DELAY)
		{
			HEALTH_POT_DELAY = true;
			CallEventDelayed(FREQ_HEALTH, "reset_health_pot_delay");
			OnDrinkPot("health");
		}

		// monster drinks special potions at 75% health and 25% health (lasts for 60s each)
		if (!DID_FIRST_POT && !DRINKING_POT && !Truthy(SPEC_TYPE) && MyHealth() < FIRST_SPEC_POT_HEALTH)
		{
			DID_FIRST_POT = true;
			OnDrinkSpecial();
		}

		if (!DID_SECOND_POT && !DRINKING_POT && !Truthy(SPEC_TYPE) && MyHealth() < QUARTER_HEALTH)
		{
			DID_SECOND_POT = true;
			OnDrinkSpecial();
		}

		if (RangeTo(attacker) > ATTACK_HITRANGE)
		{
			// if struck from afar, pull player to you
			if (BOSS_TYPE != 5)
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

	// reset_avoid_delay
	void BanditBoss_OnResetAvoidDelay()
	{
		AVOID_DELAY = false;
	}

	// reset_sweep_kick_delay
	void BanditBoss_OnResetSweepKickDelay()
	{
		SWEEP_KICK_DELAY = false;
	}

	// reset_health_pot_delay
	void BanditBoss_OnResetHealthPotDelay()
	{
		HEALTH_POT_DELAY = false;
	}

	// reset_pull_delay
	void BanditBoss_OnResetPullDelay()
	{
		PULL_DELAY = false;
	}

	// drink_special
	void BanditBoss_OnDrinkSpecial()
	{
		int rndPot = RandomInt(1, 3);
		if (BOSS_TYPE == 1) // dagger bandit does not use speed potion, as he has it naturally
			rndPot = RandomInt(1, 2);
		if (rndPot == 1)
			OnDrinkPot("demon");
		if (rndPot == 2)
			OnDrinkPot("protection");
		if (rndPot == 3)
			OnDrinkPot("speed");
	}

	// drink_pot
	void BanditBoss_OnDrinkPot(string drinkType = "")
	{
		if (!Truthy(Eval("game.monster.isalive")))
			return;

		if (DRINKING_POT) // don't try to change pots
			return;
		if (CHARGING_SHOT)
			return;
		if (CHARGED_SHOT)
			return;
		DRINKING_POT = true;

		if (drinkType != "health") // green pot
			SetModelBody(1, 8);
		if (drinkType == "health") // red pot
			SetModelBody(1, 7);
		OnNpcatkSuspendAi("2.0");
		PlayAnim("break");
		AS_ATTACKING = GameTime();
		PlayAnim("critical", ANIM_DRINK);
		DRINK_TYPE = drinkType;
	}

	// drink_done
	void BanditBoss_OnDrinkDone()
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
			IN_RESIST = true;
			glowColor = Vector3(255, 0, 0);
			SetDamageTaken("fire", 0.5f);
			CallEventDelayed(60.0f, "normal_immune");
			outMsg = Eval("game.monster.name") + " has drank a potion and is now resistant to fire!";
			InfoMessage("all", "POTION OF RESISTANCE TO FIRE", outMsg);
		}

		if (DRINK_TYPE == "cold")
		{
			USED_COLD_POT = true;
			RESIST_AMMO -= 1.0f;
			IN_RESIST = true;
			glowColor = Vector3(128, 128, 255);
			SetDamageTaken("cold", 0.5f);
			CallEventDelayed(60.0f, "normal_immune");
			outMsg = Eval("game.monster.name") + " has drank a potion and is now resistant to cold!";
			InfoMessage("all", "POTION OF RESISTANCE TO COLD", outMsg);
		}

		if (DRINK_TYPE == "poison")
		{
			USED_POISON_POT = true;
			RESIST_AMMO -= 1.0f;
			IN_RESIST = true;
			glowColor = Vector3(0, 255, 0);
			SetDamageTaken("poison", 0.5f);
			CallEventDelayed(60.0f, "normal_immune");
			outMsg = Eval("game.monster.name") + " has drank a potion and is now resistant to poison!";
			InfoMessage("all", "POTION OF RESISTANCE TO POISON", outMsg);
		}

		if (DRINK_TYPE == "lightning")
		{
			USED_LIGHTNING_POT = true;
			RESIST_AMMO -= 1.0f;
			IN_RESIST = true;
			glowColor = Vector3(255, 255, 0);
			SetDamageTaken("lightning", 0.5f);
			CallEventDelayed(60.0f, "normal_immune");
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
			CallEventDelayed(60.0f, "end_special_effect");
			outMsg = Eval("game.monster.name.full") + " has used a vial of demon blood!";
			InfoMessage("all", "POTION OF DEMON BLOOD", outMsg);
		}

		if (DRINK_TYPE == "speed")
		{
			if (BOSS_TYPE != 1) // dagger type's speed does not end at 50% health
			{
				SPEC_TYPE = "speed";
				glowColor = Vector3(255, 0, 255);
				CallEventDelayed(5.0f, "turbo_on");
				CallEventDelayed(60.0f, "end_special_effect");
				FREQ_ATTACK = Divide(FREQ_ATTACK, 2.0f);
				outMsg = Eval("game.monster.name.full") + " has used a potion of speed!";
				InfoMessage("all", "POTION OF SPEED", outMsg);
			}
		}

		Effect("glow", ENT_ME, glowColor, 128, 5, 5);

		DRINK_TYPE = "unset";

		SetModelBody(1, ORIG_WEAPON);
	}

	// normal_immune
	void BanditBoss_OnNormalImmune()
	{
		IN_RESIST = false;
	}

	// npc_flinch
	void BanditBoss_OnNpcFlinch(float damage = 0.0f)
	{
		OnNpcatkResumeAi();
		if (DRINK_TYPE == "health") // This doesn't work
			CreateItem("health_spotion", RelativePosition(Vector3(0, 0, 0)));
	}

	// npcatk_resume_ai
	void BanditBoss_OnNpcatkResumeAi(string target = "")
	{
		SetModelBody(1, ORIG_WEAPON);
		DRINKING_POT = false;
	}

	// npcatk_checkflinch
	// PARAM1 = incoming damage amt
	void BanditBoss_OnNpcatkCheckflinch(string incomingDamage = "")
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
	void BanditBoss_OnGameParry(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float parryRoll = 0.0f, float accuracyRoll = 0.0f, float parryValue = 0.0f)
	{
		if (CHARGING_SHOT)
			return;
		if (CHARGED_SHOT)
			return;
		AS_ATTACKING = GameTime();
		PlayAnim("critical", ANIM_PARRY);
		PlaySound(0, 10, SOUND_PARRY);
	}

	// end_special_effect
	void BanditBoss_OnEndSpecialEffect()
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

		SPEC_TYPE = "0";
	}

	// turbo_on
	void BanditBoss_OnTurboOn()
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
	void BanditBoss_OnStuckFix()
	{
		PlayAnim("critical", ANIM_ATTACK);
	}

	// do_turbo
	void BanditBoss_OnDoTurbo()
	{
		OnTurboOn();
		CallEventDelayed(10.0f, "turbo_off");
	}

	// turbo_off
	void BanditBoss_OnTurboOff()
	{
		SetMoveSpeed(1);
		SetAnimMoveSpeed(1);
		SetAnimFrameRate(1);

		BASE_FRAMERATE = "1.0";
		BASE_MOVESPEED = 1.0f;

		if (BOSS_TYPE == 1)
			CallEventDelayed(FREQ_TURBO, "do_turbo");
	}

	// tractor_beam
	void BanditBoss_OnTractorBeam()
	{
		DOING_PULL = true;
		if (!(RangeTo(PULL_TARGET) < 4000.0f))
			return;
		OnNpcatkSuspendAi();
		SetMoveDest(@PULL_TARGET, 9999);
		PlaySound(0, 10, SOUND_PULL);
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
	void BanditBoss_OnTractorBeam2()
	{
		SayText("Get over here!");
		SetAngle("face", @PULL_TARGET);
		// see if setangle works on player via external
		AddVelocity(PULL_TARGET, RelativeVelocity(Vector3(10, -3000, 10)));
		CallEventDelayed(0.25f, "npcatk_resume_ai");
		CallEventDelayed(0.5f, "tractor_beam3");
	}

	// tractor_beam3
	void BanditBoss_OnTractorBeam3()
	{
		SetAngle("face", @PULL_TARGET);
		// straighten out
		float myYaw = MyAngles().y;
		SetAngle("face", Vector3(0, myYaw, 0));

		OnNpcatkSettarget(EntityId(PULL_TARGET));
	}

	// kick_low
	void BanditBoss_OnKickLow()
	{
		// repulse sweep kick
		KICK_ATTACK = true;
		CreateNpc("monsters/summon/stun_burst", RelativePosition(Vector3(0, 0, 0)), self, 256, 1, 100); // <owner> <range> [toss1|0] [damage]
		OnNpcatkDodamage(NPCATK_TARGET, Text(ATTACK_RANGE), DMG_KICK, "100%", "blunt");
		CAN_FLINCH = "1";
		ANIM_ATTACK = ORIG_ATTACK;
	}

	// kick_high
	void BanditBoss_OnKickHigh()
	{
		KICK_ATTACK = true;
		OnNpcatkDodamage(NPCATK_TARGET, Text(ATTACK_HITRANGE), DMG_KICK, "100%", "blunt");
		ANIM_ATTACK = ORIG_ATTACK;
	}

	// game_dodamage
	// 1:AttackHit(1/0)  2:EntityHit  3:StartOrigin  4:EndOrigin
	string BanditBoss_OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";

		if (hit && RangeTo(target) < ATTACK_HITRANGE)
		{
			if (KICK_ATTACK)
			{
				ApplyEffect(target, "effects/debuff_stun", 10, self);
				if (BOSS_TYPE == 5) // archer always has kick back
					AddVelocity(target, RelativeVelocity(Vector3(10, 800, 10)));
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

			if (MELEE_HIT)
			{
				MELEE_HIT = false;
				if (BOSS_TYPE == 1 && !KICK_ATTACK)
					ApplyEffect(target, "effects/dot_fire", 5, self, DMG_BURN_DAGGER);
				if (BOSS_TYPE == 2 && !KICK_ATTACK)
					ApplyEffect(target, "effects/dot_fire", 5, self, DMG_BURN_MACE);
				if (BOSS_TYPE == 6 && NORM_ATTACK)
					ApplyEffect(target, "effects/dot_fire", 5, self, DMG_BURN_MACE);
			}
		}

		// reset atk types
		KICK_ATTACK = false;
		FREEZE_ATTACK = false;
		STUN_ATTACK = false;
		NORM_ATTACK = false;
		return result;
	}

	// cycle_up
	void BanditBoss_OnCycleUp(string reason = "")
	{
		if (CYCLES_ON)
			return;
		CYCLES_ON = true;

		CallEventDelayed(FREQ_KICK, "do_kick");

		if (BOSS_TYPE == 1)
		{
			CallEventDelayed(FREQ_SPECIAL, "do_special");
			CallEventDelayed(FREQ_TURBO, "do_turbo");
			CallEventDelayed(FREQ_INVIS, "do_invis");
		}

		if (BOSS_TYPE == 2)
			CallEventDelayed(FREQ_SPECIAL, "do_special");

		if (BOSS_TYPE == 3)
			CallEventDelayed(FREQ_SPECIAL, "do_special");

		if (BOSS_TYPE == 4)
			CallEventDelayed(FREQ_SPECIAL, "do_special");

		if (BOSS_TYPE == 5)
		{
			CallEventDelayed(FREQ_SPECIAL, "do_special");
			CallEventDelayed(FREQ_INVIS, "do_invis");
			CallEventDelayed(Random(CHARGE_GAP_MIN, CHARGE_GAP_MAX), "do_charge_shot");
			CallEventDelayed(FREQ_SPACING, "do_keep_spacing");
		}

		if (BOSS_TYPE == 6)
		{
			CallEventDelayed(FREQ_VOLCANO, "do_volcano");
			CallEventDelayed(FREQ_SPECIAL, "do_special");
		}
	}

	// do_special
	void BanditBoss_OnDoSpecial()
	{
		bool leapExitSub = false;

		float freqSpecial = FREQ_SPECIAL;
		if (BOSS_TYPE == 5)
			freqSpecial = Random(VOLLEY_GAP_MIN, VOLLEY_GAP_MAX);

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

		if (BOSS_TYPE == 1)
		{
			// flame burst
			PlaySound(0, 10, SOUND_POWERUP);
			Effect("glow", ENT_ME, Vector3(255, 0, 0), 128, 3, 3);
			AS_ATTACKING = 20.0f;
			PlayAnim("critical", ANIM_SPELL);
		}

		if (BOSS_TYPE == 2)
		{
			// stun attack
			// playsound 0 10 SOUND_POWERUP
			NEXT_ATTACK = Float(ANIM_SWORD_SLOW);
		}

		if (BOSS_TYPE == 3)
		{
			// charge attack
			PlaySound(0, 10, SOUND_POWERUP);
			PlayAnim("break");
			LEAP_TARGET = EntityId(EntityOf(ENT_LASTSEEN));
			POWER_ATTACK = true;
			if (RangeTo(LEAP_TARGET) < 200.0f)
			{
				PURE_FLEE = true;
				OnNpcatkFlee(LEAP_TARGET, "300", "2.0");
				CallEventDelayed(2.1f, "leap_scan");
				leapExitSub = true;
			}
			if (!leapExitSub)
				CallEventDelayed(0.1f, "leap_scan");
		}

		if (BOSS_TYPE == 4)
		{
			int pickAtk = RandomInt(1, 2); // we'll add a third attack if we get ice_spikes working
			if (pickAtk == 1)
			{
				// blizzard at most distant target
				OnNpcatkFindDistant("2048");
				OnNpcatkSuspendAi();
				// dbg temp most distant returned $get(NPC_MOST_DISTANT,name)
				SetMoveDest(NPC_MOST_DISTANT, 9999);
				BLIZZ_TARGET = NPC_MOST_DISTANT;
				CallEventDelayed(0.1f, "go_blizz");
			}

			if (pickAtk == 2)
			{
				// freezing sphere
				Effect("glow", ENT_ME, Vector3(128, 128, 255), 128, 3, 3);
				PlaySound(Int(SOUND_POWERUP));
				CallEventDelayed(2.0f, "do_sphere");
			}
		}

		if (BOSS_TYPE == 5)
		{
			PlaySound(0, 10, SOUND_POWERUP);
			Effect("glow", ENT_ME, Vector3(0, 255, 255), 128, 3, 3);
			SCATTER_SHOT = true;
		}

		if (BOSS_TYPE == 6)
		{
			NOVA_PICK_ATK += 1.0f;

			DOING_NOVA = true;
			CallEventDelayed(10.0f, "reset_doing_nova");

			if (NOVA_PICK_ATK > 4.0f)
				NOVA_PICK_ATK = 1.0f;

			if (NOVA_PICK_ATK == 1.0f)
			{
				// firewall
				OnNpcatkFindDistant("2048");
				// dbg temp most distant returned $get(NPC_MOST_DISTANT,name)
				SetMoveDest(NPC_MOST_DISTANT, 9999);
				NOvA_TARGET = NPC_MOST_DISTANT;
				PlaySound(0, 10, SOUND_POWERUP);
				AS_ATTACKING = 20.0f;
				NOVA_ATTACK = "fire_wall";
				CallEventDelayed(0.1f, "do_fire_wall");
			}

			if (NOVA_PICK_ATK == 2.0f)
			{
				// flame burst
				NOVA_ATTACK = "flame_burst";
				PlaySound(0, 10, SOUND_POWERUP);
				Effect("glow", ENT_ME, Vector3(255, 0, 0), 128, 3, 3);
				AS_ATTACKING = 20.0f;
				PlayAnim("critical", ANIM_SPELL);
			}

			if (NOVA_PICK_ATK == 3.0f)
			{
				// uber fireball
				PlaySound(0, 10, SOUND_POWERUP);
				Effect("glow", ENT_ME, Vector3(255, 72, 0), 128, 3, 3);
				CallEventDelayed(2.0f, "do_fireball");
			}

			if (NOVA_PICK_ATK == 4.0f)
			{
				// flaming skull
				NOVA_ATTACK = "flame_skull";
				PlaySound(0, 10, SOUND_POWERUP);
				Effect("glow", ENT_ME, Vector3(255, 255, 0), 128, 3, 3);
				AS_ATTACKING = 20.0f;
				PlayAnim("critical", ANIM_SPELL);
			}
		}
	}

	// reset_doing_nova
	void BanditBoss_OnResetDoingNova()
	{
		DOING_NOVA = false;
	}

	// do_fire_wall
	void BanditBoss_OnDoFireWall()
	{
		// dbg firewall delayed go
		PlayAnim("critical", ANIM_SPELL);
		Effect("glow", ENT_ME, Vector3(255, 255, 128), 128, 3, 3);
	}

	// do_fireball
	// do_special
	void BanditBoss_OnDoFireball()
	{
		AS_ATTACKING = GameTime();
		PlayAnim("critical", ANIM_JAB);
	}

	// do_sphere
	// do_special
	void BanditBoss_OnDoSphere()
	{
		AS_ATTACKING = GameTime();
		PlayAnim("critical", ANIM_JAB);
		PlaySound(0, 10, SOUND_SATTACK);
		CreateNpc("monsters/summon/ice_blast", RelativePosition(Vector3(0, 64, 32)), self, 20.0f, RelativePosition(Vector3(0, 2000, 0)));
	}

	// go_blizz
	// do_special
	void BanditBoss_OnGoBlizz()
	{
		PlaySound(0, 10, SOUND_SATTACK);
		AS_ATTACKING = GameTime();
		PlayAnim("critical", ANIM_JAB);
		Effect("glow", ENT_ME, Vector3(128, 128, 255), 128, 3, 3);
		Vector3 blizzPos = OriginOf(BLIZZ_TARGET);
		CreateNpc("monsters/summon/summon_blizzard", blizzPos, self, AnglesOf(ENT_ME), DMG_BLIZ, 20.0f);
		OnNpcatkResumeAi();
	}

	// do_kick
	void BanditBoss_OnDoKick()
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
	void BanditBoss_OnDoVolcano()
	{
		float freqVolcano = FREQ_VOLCANO;

		OnCheckLegalAct();

		if (DOING_NOVA)
			freqVolcano = 5.0f;
		if (!LEGAL_ACT)
			freqVolcano = 5.0f;

		// dbg checking vocano ( innova DOING_NOVA legal LEGAL_ACT )
		CallEventDelayed(freqVolcano, "do_volcano");

		if (!LEGAL_ACT)
			return;
		if (DOING_NOVA)
			return;

		NOVA_ATTACK = "volcano";
		AS_ATTACKING = 20.0f;
		PlayAnim("critical", ANIM_SPELL);
	}

	// reset_attack_anim
	void BanditBoss_OnResetAttackAnim()
	{
		// ANIM_ATTACK sticks, and check_legal_act calls a kick value illegal, so
		// leaving it set kills every timed ability for the rest of the fight
		ANIM_ATTACK = ORIG_ATTACK;
	}

	// do_keep_spacing
	void BanditBoss_OnDoKeepSpacing()
	{
		// type 5 wants range - react to anyone crowding him, not just to being hit
		CallEventDelayed(FREQ_SPACING, "do_keep_spacing");

		if (BOSS_TYPE != 5)
			return;
		if (AVOID_DELAY)
			return;
		if (DRINKING_POT)
			return;
		if (CHARGING_SHOT)
			return;
		if (CHARGED_SHOT)
			return;
		if (AM_LEAPING)
			return;

		OnCheckLegalAct();
		if (!LEGAL_ACT)
			return;

		LegacyCommand("getents", "player", SPACING_RANGE);
	}

	// do_charge_shot
	void BanditBoss_OnDoChargeShot()
	{
		float freqCharge = Random(CHARGE_GAP_MIN, CHARGE_GAP_MAX);

		OnCheckLegalAct();
		if (!LEGAL_ACT)
			freqCharge = 3.0f;

		bool canSeeNme = CanSee("enemy");
		if (!canSeeNme)
			freqCharge = 3.0f;
		if (SCATTER_SHOT)
			freqCharge = 3.0f;

		CallEventDelayed(freqCharge, "do_charge_shot");

		if (!canSeeNme)
			return;
		if (!LEGAL_ACT)
			return;
		if (SCATTER_SHOT)
			return;
		if (!(GameTime() > NO_CHARGE_UNTIL)) // don't chain a charge straight off a kick
			return;
		if (CHARGING_SHOT)
			return;
		if (CHARGED_SHOT) // one at a time or the orbs orphan
			return;

		CHARGING_SHOT = true;
		NPC_NO_ATTACK = true; // no swinging mid-charge
		CAN_FLINCH = "0";
		CHARGE_TICKS = 0.0f;
		PlaySound(0, 10, SOUND_POWERUP);
		ServerPlaySound(2, 5, SOUND_CHARGE);
		Effect("glow", ENT_ME, Vector3(0, 128, 255), 160, CHARGE_TIME, CHARGE_TIME);

		ClientEvent("new", "all", "monsters/bandit_boss", IndexOf(ENT_ME));
		BOW_CL_IDX = LastClientScriptId();

		OnChargeTick();
		CallEventDelayed(CHARGE_TIME, "finish_charge_shot");
	}

	// charge_tick
	void BanditBoss_OnChargeTick()
	{
		if (!CHARGING_SHOT)
			return;

		CHARGE_TICKS += 1.0f;
		ClientEvent("update", "all", BOW_CL_IDX, "add_charge");

		if (CHARGE_TICKS < CHARGE_TICK_MAX)
			CallEventDelayed(CHARGE_TICK_RATE, "charge_tick");
	}

	// expire_charged_shot
	void BanditBoss_OnExpireChargedShot()
	{
		// never fired - died, stunned, potioned, whatever
		if (!CHARGED_SHOT)
			return;
		CHARGED_SHOT = false;
		CAN_FLINCH = "1";
		NPC_NO_ATTACK = false;
		OnReleaseChargeFx();
	}

	// abort_charge
	void BanditBoss_OnAbortCharge()
	{
		// death only, nothing else breaks the charge
		CHARGING_SHOT = false;
		CHARGED_SHOT = false;
		NPC_NO_ATTACK = false;
		CAN_FLINCH = "1";
		OnReleaseChargeFx();
	}

	// release_charge_fx
	void BanditBoss_OnReleaseChargeFx()
	{
		if (BOW_CL_IDX != "unset")
		{
			ClientEvent("update", "all", BOW_CL_IDX, "charge_release");
			BOW_CL_IDX = "unset";
		}
	}

	// finish_charge_shot
	void BanditBoss_OnFinishChargeShot()
	{
		CHARGING_SHOT = false;
		CHARGED_SHOT = true;
		ClientEvent("update", "all", BOW_CL_IDX, "hold_orb");
		CallEventDelayed(CHARGE_EXPIRE, "expire_charged_shot");

		// flash at full charge
		Effect("glow", ENT_ME, Vector3(0, 255, 255), 220, 1, 1);
		PlaySound(0, 10, SOUND_BOW_STRETCH);

		// fire here, not on the next attack cycle - a flinch or parry eats the bow
		// anim and the shot never happens
		NPC_NO_ATTACK = false;
		if (DRINKING_POT) // stomping the drink anim means drink_done never fires
			return;
		ANIM_ATTACK = ANIM_BOW;
		AS_ATTACKING = GameTime();
		PlayAnim("critical", ANIM_BOW);
		CallEventDelayed(CHARGE_FIRE_DELAY, "fire_charged_bolt");
	}

	// fire_charged_bolt
	void BanditBoss_OnFireChargedBolt()
	{
		if (!CHARGED_SHOT)
			return;
		CHARGED_SHOT = false;
		CAN_FLINCH = "1";
		// forced anim reaches bow_shoot, so can the attack cycle. Timer, not a flag.
		NO_FILLER_UNTIL = GameTime() + FILLER_HOLD;
		OnReleaseChargeFx();
		PlaySound(0, 10, SOUND_SATTACK);

		BALL_SIZE = CHARGED_BALL_SIZE;
		BALL_DMG = BALL_SIZE * DMG_BALL_MULTI;

		Vector3 ofsAdj = RelativePosition(Vector3(0, 28, BOLT_OFS_Z));
		if (RangeTo(NPCATK_TARGET) < 100.0f)
			ofsAdj = RelativePosition(Vector3(0, 28, -28));

		// target x/y, muzzle height. $relvel inherits his pitch and fires at the sky
		// when he's on a ledge.
		Vector3 targ = OriginOf(NPCATK_TARGET);
		if (CHARGED_FLAT)
			targ.z = ofsAdj.z;
		if (!CHARGED_FLAT)
			targ.z += BOLT_AIM_Z;

		Vector3 vel = DirectionTo(ofsAdj, targ) * CHARGED_BALL_SPEED;

		// no 'persist' - keeps ticking anyone riding it, losing size and dmg per hit
		// <owner> <vec> <ballSize> <damage> <skill to level> [mode]
		CreateNpc("items/proj_mana_boss", ofsAdj, self, vel, BALL_SIZE, BALL_DMG, "none");
	}

	// do_scatter_shot
	void BanditBoss_OnDoScatterShot()
	{
		string arrowType = "ARROW_TYPE";
		SCATTER_COUNT += 1.0f;
		if (SCATTER_COUNT < 10.0f)
			CallEventDelayed(0.1f, "do_scatter_shot");
		PlaySound(0, 10, SOUND_BOW_SHOOT);
		int rndArrow = RandomInt(1, 3);
		float finDmg = DMG_ARROW;
		if (rndArrow == 1)
			arrowType = "proj_arrow_frost";
		if (rndArrow == 2)
			arrowType = "proj_arrow_gpoison";
		if (rndArrow == 3)
		{
			arrowType = "proj_arrow_jagged";
			finDmg *= 4.0f;
		}

		// <projectile scriptname> <"view"|(src_origin)> <target|(targ_origin)|none> <speed> <damage> <cof> <skill|none> //Converted to use new tossprojectile //greatguys1@FEB2022
		TossProjectile(arrowType, RelativePosition(Vector3(0, 32, 32)), NPCATK_TARGET, ARROW_SPEED, finDmg, SCATTER_COF, "none");
		CallExternal(ENT_LASTPROJECTILE, "ext_lighten", 0.1f);
	}

	// axe_fast
	// ================================ ATTACK ANIMS - BEGIN
	void BanditBoss_OnAxeFast()
	{
		BB_IN_ATTACK = false;

		if (Text(NEXT_ATTACK) != "unset")
		{
			ANIM_ATTACK = Text(NEXT_ATTACK);
			NEXT_ATTACK = 0.0f;
		}

		if (BOSS_TYPE == 2)
		{
			OnNpcatkDodamage(NPCATK_TARGET, Text(ATTACK_HITRANGE), Text(DMG_AXE_FAST), ATTACK_HITCHANCE, "dark");
			MELEE_HIT = true;
		}
		else
		{
			NORM_ATTACK = true;
			OnNpcatkDodamage(NPCATK_TARGET, Text(ATTACK_HITRANGE), Text(DMG_AXE_FAST), ATTACK_HITCHANCE, "slash");
			MELEE_HIT = true;
		}

		if (BOSS_TYPE == 3 && RandomInt(1, 10) == 1)
		{
			// playsound 0 10 SOUND_POWERUP
			Effect("glow", ENT_ME, Vector3(255, 255, 255), 128, 1, 1);
			NEXT_ATTACK = Float(ANIM_AXE_SLOW);
		}
	}

	// axe_slow
	// used by mace, and periodically by axe
	void BanditBoss_OnAxeSlow()
	{
		BB_IN_ATTACK = false;

		if (Text(NEXT_ATTACK) != "unset")
		{
			ANIM_ATTACK = Text(NEXT_ATTACK);
			NEXT_ATTACK = 0.0f;
		}

		if (BOSS_TYPE == 3)
		{
			NEXT_ATTACK = Float(ANIM_SWING_FAST);
			PlaySound(0, 10, SOUND_SATTACK);
		}
		if (BOSS_TYPE != 3)
			NORM_ATTACK = true;

		if (BOSS_TYPE == 2)
		{
			OnNpcatkDodamage(NPCATK_TARGET, Text(ATTACK_HITRANGE), Text(DMG_AXE_FAST), ATTACK_HITCHANCE, "dark");
			MELEE_HIT = true;
		}
		else
		{
			OnNpcatkDodamage(NPCATK_TARGET, Text(ATTACK_HITRANGE), Text(DMG_AXE_SLOW), ATTACK_HITCHANCE, "blunt");
			MELEE_HIT = true;
		}
	}

	// sword_fast
	void BanditBoss_OnSwordFast()
	{
		BB_IN_ATTACK = false;

		if (Text(NEXT_ATTACK) != "unset")
		{
			ANIM_ATTACK = Text(NEXT_ATTACK);
			NEXT_ATTACK = 0.0f;
		}

		NORM_ATTACK = true;
		if (BOSS_TYPE == 6 && RandomInt(1, 10) == 1)
			NEXT_ATTACK = Float(ANIM_SWORD_SLOW);

		if (BOSS_TYPE == 2)
		{
			OnNpcatkDodamage(NPCATK_TARGET, Text(ATTACK_HITRANGE), Text(DMG_AXE_FAST), ATTACK_HITCHANCE, "dark");
			MELEE_HIT = true;
		}
		else
		{
			OnNpcatkDodamage(NPCATK_TARGET, Text(ATTACK_HITRANGE), Text(DMG_SWORD_FAST), ATTACK_HITCHANCE, "slash");
			MELEE_HIT = true;
		}
	}

	// sword_slow
	// used by sword and periodically by mace
	void BanditBoss_OnSwordSlow()
	{
		BB_IN_ATTACK = false;

		if (Text(NEXT_ATTACK) != "unset")
		{
			ANIM_ATTACK = Text(NEXT_ATTACK);
			NEXT_ATTACK = 0.0f;
		}

		if (BOSS_TYPE == 2)
		{
			STUN_ATTACK = true;
			ANIM_ATTACK = ORIG_ATTACK;
			CreateNpc("monsters/summon/stun_burst", RelativePosition(Vector3(0, 0, 0)), self, 256, 0, 200); // <owner> <range> [toss1|0] [damage]
			OnNpcatkDodamage(NPCATK_TARGET, Text(ATTACK_HITRANGE), Text(DMG_AXE_FAST), ATTACK_HITCHANCE, "dark");
			MELEE_HIT = true;
		}
		else
		{
			OnNpcatkDodamage(NPCATK_TARGET, Text(ATTACK_HITRANGE), Text(DMG_SWORD_SLOW), ATTACK_HITCHANCE, "slash");
			MELEE_HIT = true;
		}
		if (BOSS_TYPE != 2)
			NORM_ATTACK = true;
	}

	// swing_slow
	void BanditBoss_OnSwingSlow()
	{
		BB_IN_ATTACK = false;

		if (Text(NEXT_ATTACK) != "unset")
		{
			ANIM_ATTACK = Text(NEXT_ATTACK);
			NEXT_ATTACK = 0.0f;
		}

		NORM_ATTACK = true;
		if (BOSS_TYPE == 2)
		{
			OnNpcatkDodamage(NPCATK_TARGET, Text(ATTACK_HITRANGE), Text(DMG_AXE_FAST), ATTACK_HITCHANCE, "dark");
			MELEE_HIT = true;
		}
		else
		{
			OnNpcatkDodamage(NPCATK_TARGET, Text(ATTACK_HITRANGE), Text(DMG_SWING_SLOW), ATTACK_HITCHANCE, "slash");
			MELEE_HIT = true;
		}
	}

	// swing_fast
	void BanditBoss_OnSwingFast()
	{
		BB_IN_ATTACK = false;

		if (Text(NEXT_ATTACK) != "unset")
		{
			ANIM_ATTACK = Text(NEXT_ATTACK);
			NEXT_ATTACK = 0.0f;
		}

		if (BOSS_TYPE == 3)
		{
			FAST_SWINGS += 1.0f;
			if (FAST_SWINGS >= 20.0f)
			{
				NEXT_ATTACK = Float(ANIM_AXE_FAST);
				FAST_SWINGS = 0.0f;
			}
		}
		NORM_ATTACK = true;

		if (BOSS_TYPE == 2)
		{
			OnNpcatkDodamage(NPCATK_TARGET, Text(ATTACK_HITRANGE), Text(DMG_AXE_FAST), ATTACK_HITCHANCE, "dark");
			MELEE_HIT = true;
		}
		else
		{
			OnNpcatkDodamage(NPCATK_TARGET, Text(ATTACK_HITRANGE), Text(DMG_SWING_FAST), ATTACK_HITCHANCE, "slash");
			MELEE_HIT = true;
		}
	}

	// attack_jab
	void BanditBoss_OnAttackJab()
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

		if (BOSS_TYPE == 1)
		{
			OnNpcatkDodamage(NPCATK_TARGET, Text(ATTACK_HITRANGE), Text(DMG_DAGGER), ATTACK_HITCHANCE, "slash");
			MELEE_HIT = true;
			// dagger bandit re-flanks periodically
			if (RandomInt(1, 20) == 1 && !FLANK_DELAY)
			{
				FLANK_DELAY = true;
				CallEventDelayed(FREQ_FLANK, "flank_delay_reset");
				OnNpcatkFlank(NPCATK_TARGET);
			}
		}
		if (BOSS_TYPE == 2)
		{
			OnNpcatkDodamage(NPCATK_TARGET, Text(ATTACK_HITRANGE), Text(DMG_AXE_FAST), ATTACK_HITCHANCE, "dark");
			MELEE_HIT = true;
		}
		if (BOSS_TYPE == 4)
		{
			PlaySound(0, 10, SOUND_SATTACK);
			FREEZE_ATTACK = true;
			ANIM_ATTACK = ORIG_ATTACK;

			OnNpcatkDodamage(NPCATK_TARGET, Text(ATTACK_HITRANGE), Text(DMG_SWORD_STAB), ATTACK_HITCHANCE, "pierce");
			MELEE_HIT = true;
		}
		if (BOSS_TYPE == 6)
		{
			PlaySound(0, 10, SOUND_SATTACK);
			ANIM_ATTACK = ORIG_ATTACK;

			// <projectile scriptname> <"view"|(src_origin)> <target|(targ_origin)|none> <speed> <damage> <cof> <skill|none> //Converted to use new tossprojectile //greatguys1@FEB2022
			TossProjectile("proj_fire_ball2", RelativePosition(Vector3(0, 48, 36)), "none", 200, DMG_FIRE_BALL, 0, "none");
			CallExternal(EntityOf(ENT_LASTPROJECTILE), "lighten", 20);
		}
	}

	// prep_done
	void BanditBoss_OnPrepDone()
	{
		Vector3 pos = Vec("pos");
		BB_IN_ATTACK = false;

		if (BOSS_TYPE == 1)
		{
			PlaySound(0, 10, SOUND_SATTACK);
			CreateNpc("monsters/summon/flame_burst", RelativePosition(Vector3(0, 0, 0)), self, DMG_FLAME_BURST, 1);
		}

		if (BOSS_TYPE == 6)
		{
			// dbg nova_type NOVA_ATTACK
			if (NOVA_ATTACK == "fire_wall")
			{
				PlaySound(0, 10, SOUND_SATTACK);
				CreateNpc("monsters/summon/bandit_boss_fire_wall", OriginOf(NOvA_TARGET), self, AnglesOf(ENT_ME), 75, 20);
			}

			if (NOVA_ATTACK == "flame_burst")
			{
				PlaySound(0, 10, SOUND_SATTACK);
				float burstDam = DMG_FLAME_BURST * 2.0f;
				CreateNpc("monsters/summon/flame_burst", RelativePosition(Vector3(0, 0, 0)), self, burstDam, 1);
			}

			if (NOVA_ATTACK == "volcano")
			{
				if (CanSee("enemy"))
					pos = OriginOf(ENT_LASTSEEN);
				if (RelationshipOf(ENT_LASTSEEN, ENT_ME) == "enemy")
					pos = OriginOf(ENT_LASTSEEN);
				if (!CanSee("enemy") && Distance(MyOrigin(), pos) > 2000.0f)
				{
					pos = Vec(LegacyFunction("vec", MyOrigin()));
					pos += RelativePosition(Vector3(0, 0, 0), Vector3(0, 500, 0));
					pos = Vec(LegacyFunction("get_traceline", MyOrigin(), pos, "worldonly"));
				}
				float temp = GroundHeight(pos);
				float x = pos.x;
				float y = pos.y;
				pos = Vector3(x, y, temp);
				SetGlobal("VOLCANO_DMG", 2);
				DMG_VOLCANO = 40;
				CreateNpc("monsters/summon/npc_volcano", pos, self, 100, 40.0f);
			}

			if (NOVA_ATTACK == "flame_skull")
				CreateNpc("monsters/summon/flame_skull", RelativePosition(Vector3(0, 0, 64)), self, DMG_SKULL, 256);

			NOVA_ATTACK = "none";
		}
	}

	// bow_shoot
	void BanditBoss_OnBowShoot()
	{
		bool exitSub = false;
		BB_IN_ATTACK = false;

		if (CHARGING_SHOT) // nothing leaves the bow while the orb is building
			return;

		if (Text(NEXT_ATTACK) != "unset")
		{
			ANIM_ATTACK = Text(NEXT_ATTACK);
			NEXT_ATTACK = 0.0f;
		}

		if (SCATTER_SHOT)
		{
			PlaySound(0, 10, SOUND_BOW_SHOOT);
			PlaySound(0, 10, SOUND_SATTACK);
			SCATTER_SHOT = false;
			SCATTER_COUNT = 0.0f;
			OnDoScatterShot();
			exitSub = true;
		}
		if (exitSub)
			return;

		if (GameTime() < NO_FILLER_UNTIL)
			exitSub = true;
		if (exitSub)
			return;

		// filler - plain orion bolt, small and fast
		PlaySound(0, 10, SOUND_BOW_SHOOT);

		BALL_SIZE = RandomInt((FILLER_BALL_MIN ? 1 : 0), (FILLER_BALL_MAX ? 1 : 0));
		BALL_DMG = BALL_SIZE * FILLER_DMG_MULTI;

		Vector3 ofsAdj = RelativePosition(Vector3(0, 28, BOLT_OFS_Z));
		if (RangeTo(NPCATK_TARGET) < 100.0f)
			ofsAdj = RelativePosition(Vector3(0, 28, -28));

		Vector3 targ = OriginOf(NPCATK_TARGET);
		targ.z += BOLT_AIM_Z;
		Vector3 vel = DirectionTo(ofsAdj, targ) * FILLER_BALL_SPEED;

		// <owner> <vec> <ballSize> <damage> <skill to level>
		CreateNpc("items/proj_mana_boss", ofsAdj, self, vel, BALL_SIZE, BALL_DMG, "none");
	}

	// bow_stretch
	void BanditBoss_OnBowStretch()
	{
		BB_IN_ATTACK = false;
		PlaySound(0, 10, SOUND_BOW_STRETCH);
	}

	// sound_fast
	void BanditBoss_OnSoundFast()
	{
		if (Text(NEXT_ATTACK) == "unset")
			PlaySound(0, 10, SOUND_SWING_FAST);
		if (Text(NEXT_ATTACK) != "unset" && Text(NEXT_ATTACK) != ANIM_KICK_HIGH && Text(NEXT_ATTACK) != ANIM_KICK_LOW)
			PlaySound(0, 10, SOUND_POWERUP);
	}

	// sound_slow
	void BanditBoss_OnSoundSlow()
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
	void BanditBoss_OnLeapScan()
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
	void BanditBoss_OnLeapAt(string target = "")
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
	void BanditBoss_OnLeapAt2()
	{
		PlaySound(0, 10, SOUND_LEAP);
		AS_ATTACKING = GameTime();
		PlayAnim("critical", ANIM_LEAP);
		CallEventDelayed(0.1f, "bandit_charge");
		CallEventDelayed(1.0f, "reset_leaping");
		CallEventDelayed(0.9f, "bullrush_stun");
	}

	// bandit_charge
	void BanditBoss_OnBanditCharge()
	{
		AddVelocity(ENT_ME, RelativeVelocity(Vector3(0, 400, 100)));
	}

	// reset_leaping
	void BanditBoss_OnResetLeaping()
	{
		AM_LEAPING = false;

		// leap_away sets the flee flags and nothing clears them, which locks up
		// check_legal_act for good. Delayed, clearing them here cuts the hop short.
		CallEventDelayed(LEAP_CLEAR_DELAY, "clear_leap_flee");
	}

	// clear_leap_flee
	void BanditBoss_OnClearLeapFlee()
	{
		IS_FLEEING = false;
		NPC_FORCED_MOVEDEST = false;
		PURE_FLEE = false;
	}

	// bullrush_stun
	void BanditBoss_OnBullrushStun()
	{
		CreateNpc("monsters/summon/stun_burst", RelativePosition(Vector3(0, 60, 0)), self, 256, 1, 150); // <owner> <range> [toss1|0] [damage]
	}

	// leap_away
	// <target>
	void BanditBoss_OnLeapAway(string target = "")
	{
		// dbg leap_away PARAM2
		AM_LEAPING = true;
		NPC_FORCED_MOVEDEST = true;
		OnNpcatkSuspendAi(Text(LEAP_SUSPEND));
		SetMoveDest(target, 800, "flee");
		CallEventDelayed(0.1f, "leap_away2");
	}

	// leap_away2
	void BanditBoss_OnLeapAway2()
	{
		PlaySound(0, 10, SOUND_LEAP);
		AS_ATTACKING = GameTime();
		PlayAnim("critical", ANIM_HOP);
		CallEventDelayed(0.1f, "bandit_hop");
		CallEventDelayed(LEAP_SUSPEND, "reset_leaping");
	}

	// bandit_hop
	void BanditBoss_OnBanditHop()
	{
		int jumpHeight = RandomInt(350, 450);
		AddVelocity(ENT_ME, RelativeVelocity(Vector3(0, HOP_DIST, jumpHeight)));
	}

	// flank_delay_reset
	// =================================== LEAP/CHARGE SEQUENCE - END
	void BanditBoss_OnFlankDelayReset()
	{
		FLANK_DELAY = false;
	}

	// my_target_died
	void BanditBoss_OnMyTargetDied(string offender = "")
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
	void BanditBoss_OnTauntSound()
	{
		PlayRandomSound(0, 10, SOUND_TAUNT1, SOUND_TAUNT2);
	}

	// game_death
	void BanditBoss_OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		bool exitSub = false;
		bool treasureMap = false;

		OnAbortCharge();
		OnReleaseChargeFx();

		string mapName = ToLowerCase(MapName());
		if (mapName == "helena")
		{
			// call something to the game master here
			CallExternal(GetVar("GAME_MASTER"), "helena_bandit_chest", RelativePosition(Vector3(0, 0, 0)));
			exitSub = true;
		}
		if (exitSub)
			return;
		if (mapName == "keep_test")
			treasureMap = true;
		if (mapName == "the_keep")
			treasureMap = true;

		// if ( TREASURE_MAP ) callevent bm_gold_spew 50 2 100 4 30 - skipping gold spew to cut down on crash
		SetGlobal("G_BANDIT_BOSS_TYPE", BOSS_TYPE);
	}

	// glow_loop
	void BanditBoss_OnGlowLoop()
	{
		if (!GLOW_ON)
			return;
		CallEventDelayed(5.1f, "glow_loop");
		Effect(ENT_ME, "glow", GLOW_LOOP_COLOR, 128, 5, 0);
	}

	// npc_targetsighted
	void BanditBoss_OnNpcTargetsighted(string target = "")
	{
		if (BOSS_TYPE == 5 && !IS_FLEEING)
		{
			if (!CHARGING_SHOT && CanSee(target)) // this skips npcatk_attack, so check here too
			{
				AS_ATTACKING = GameTime();
				PlayAnim("once", ANIM_BOW);
			}
		}
	}

	// game_struck
	void BanditBoss_OnGameStruck(float damage = 0.0f, string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		PlayRandomSound(0, 8, SOUND_PAIN, SOUND_PAIN2, "none", "none");
	}

	// do_invis
	void BanditBoss_OnDoInvis()
	{
	}

	// check_legal_act
	void BanditBoss_OnCheckLegalAct()
	{
		LEGAL_ACT = true;

		if (I_R_FROZEN)
			LEGAL_ACT = false;
		if (CHARGING_SHOT) // charge can't be broken off
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
	void BanditBoss_Timer()
	{
		CallEventDelayed(2.0f, "BanditBoss_Timer");

		// something in this script is causing BD periodically
		// prevention measure/hack
		if (SUSPEND_AI)
			BD_COUNT += 1.0f;
		if (!SUSPEND_AI)
			BD_COUNT = 0.0f;
		if (BD_COUNT > 20.0f)
			OnNpcatkResumeAi();

		// ANIM_ATTACK sticking on a kick makes check_legal_act refuse everything
		if (ANIM_ATTACK == ANIM_KICK_HIGH)
			OnResetAttackAnim();
		if (ANIM_ATTACK == ANIM_KICK_LOW)
			OnResetAttackAnim();

		if (IS_FLEEING)
			FLEE_COUNT += 1.0f;
		if (!IS_FLEEING)
			FLEE_COUNT = 0.0f;
		if (FLEE_COUNT > 4.0f)
		{
			IS_FLEEING = false;
			NPC_FORCED_MOVEDEST = false;
			FLEE_COUNT = 0.0f;
		}

		// drink_done is an anim event - clobber the drink anim and this stays set,
		// then check_legal_act blocks everything
		if (DRINKING_POT)
			POT_COUNT += 1.0f;
		if (!DRINKING_POT)
			POT_COUNT = 0.0f;
		if (POT_COUNT > 3.0f)
		{
			DRINKING_POT = false;
			POT_COUNT = 0.0f;
			SetModelBody(1, ORIG_WEAPON);
		}
	}

	// npcatk_attack
	// JUN2007b
	// slow swinging banidts have an odd bug where if you 'dance' in front of them they
	// keep starting their attack animation over and over again (and thus, never swing)
	// this is an effort to fix that
	// ( [override] npcatk_attack callevent npcatk_attack_hack - if you need atack hack, see below )
	void BanditBoss_OnNpcatkAttack()
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
	void BanditBoss_OnNpcatkHunt()
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
	void OnGamePrecache() { BanditBoss_OnGamePrecache(); } // game_precache

	// game_death
	void OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		DqMonsterExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // dq/externals/dq_monster_externals
		MonstersExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/externals
		BaseSelfAdjust_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_self_adjust
		BaseNpc_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseMonsterShared_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared
		BanditBoss_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4);
	}

	// normal_immune
	void OnNormalImmune()
	{
		MonstersExternals_OnNormalImmune(); // monsters/externals
		BanditBoss_OnNormalImmune();
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
		BanditBoss_OnNpcPostSpawn();
	}

	// game_struck
	void OnGameStruck(float damage = 0.0f, string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		BaseNpc_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseNpcAttackNew_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc_attack_new
		BaseMonsterShared_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared
		BanditBoss_OnGameStruck(damage, extraValue2, extraValue3, extraValue4);
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseNpcAttackNew_OnNpcSpawn(npc); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck
		BanditBoss_OnNpcSpawn(npc);
	}

	// npcatk_hunt
	void OnNpcatkHunt()
	{
		BaseNpcAttackNew_OnNpcatkHunt(); // monsters/base_npc_attack_new
		BaseAntiStuck_OnNpcatkHunt(); // monsters/base_anti_stuck
		BanditBoss_OnNpcatkHunt();
	}

	// my_target_died
	void OnMyTargetDied(string offender = "")
	{
		BaseNpcAttackNew_OnMyTargetDied(offender); // monsters/base_npc_attack_new
		BanditBoss_OnMyTargetDied(offender);
	}

	// npcatk_resume_ai
	void OnNpcatkResumeAi(string target = "")
	{
		BaseNpcAttackNew_OnNpcatkResumeAi(target); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcatkResumeAi(target); // monsters/base_monster_shared
		BaseMonsterShared_OnNpcatkResumeAi_2(target); // monsters/base_monster_shared
		BanditBoss_OnNpcatkResumeAi(target);
	}

	// game_dodamage
	string OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";
		result = AppendResult(result, BaseNpcAttackNew_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BaseAntiStuck_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BaseMonsterShared_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BanditBoss_OnGameDodamage(hit, target, start, end, damageType, damageText));
		return result;
	}

	// cycle_up
	void OnCycleUp(string reason = "")
	{
		BaseNpcAttackNew_OnCycleUp(reason); // monsters/base_npc_attack_new
		BanditBoss_OnCycleUp(reason);
	}

	// game_damaged - Return a damage multiplier to scale the damage
	string OnGameDamaged(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float accuracyRoll = 0.0f, CBaseEntity@ inflictor = null, string skill = "")
	{
		string result = "";
		result = AppendResult(result, BaseAntiStuck_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, BaseMonsterShared_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, BaseMonsterShared_OnGameDamaged_2(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, BanditBoss_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		return result;
	}

	// game_parry
	void OnGameParry(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float parryRoll = 0.0f, float accuracyRoll = 0.0f, float parryValue = 0.0f)
	{
		BaseMonsterShared_OnGameParry(attacker, damage, damageType, parryRoll, accuracyRoll, parryValue); // monsters/base_monster_shared
		BanditBoss_OnGameParry(attacker, damage, damageType, parryRoll, accuracyRoll, parryValue);
	}

	// npc_targetsighted
	void OnNpcTargetsighted(string target = "")
	{
		BaseMonsterShared_OnNpcTargetsighted(target); // monsters/base_monster_shared
		BanditBoss_OnNpcTargetsighted(target);
	}

	void OnSetupBoss() { BanditBoss_OnSetupBoss(); } // setup_boss
	void OnResetAvoidDelay() { BanditBoss_OnResetAvoidDelay(); } // reset_avoid_delay
	void OnResetSweepKickDelay() { BanditBoss_OnResetSweepKickDelay(); } // reset_sweep_kick_delay
	void OnResetHealthPotDelay() { BanditBoss_OnResetHealthPotDelay(); } // reset_health_pot_delay
	void OnResetPullDelay() { BanditBoss_OnResetPullDelay(); } // reset_pull_delay
	void OnDrinkSpecial() { BanditBoss_OnDrinkSpecial(); } // drink_special
	void OnDrinkPot(string drinkType = "") { BanditBoss_OnDrinkPot(drinkType); } // drink_pot
	void OnDrinkDone() { BanditBoss_OnDrinkDone(); } // drink_done
	void OnNpcFlinch(float damage = 0.0f) { BanditBoss_OnNpcFlinch(damage); } // npc_flinch
	void OnNpcatkCheckflinch(string incomingDamage = "") { BanditBoss_OnNpcatkCheckflinch(incomingDamage); } // npcatk_checkflinch
	void OnEndSpecialEffect() { BanditBoss_OnEndSpecialEffect(); } // end_special_effect
	void OnTurboOn() { BanditBoss_OnTurboOn(); } // turbo_on
	void OnStuckFix() { BanditBoss_OnStuckFix(); } // stuck_fix
	void OnDoTurbo() { BanditBoss_OnDoTurbo(); } // do_turbo
	void OnTurboOff() { BanditBoss_OnTurboOff(); } // turbo_off
	void OnTractorBeam() { BanditBoss_OnTractorBeam(); } // tractor_beam
	void OnTractorBeam2() { BanditBoss_OnTractorBeam2(); } // tractor_beam2
	void OnTractorBeam3() { BanditBoss_OnTractorBeam3(); } // tractor_beam3
	void OnKickLow() { BanditBoss_OnKickLow(); } // kick_low
	void OnKickHigh() { BanditBoss_OnKickHigh(); } // kick_high
	void OnDoSpecial() { BanditBoss_OnDoSpecial(); } // do_special
	void OnResetDoingNova() { BanditBoss_OnResetDoingNova(); } // reset_doing_nova
	void OnDoFireWall() { BanditBoss_OnDoFireWall(); } // do_fire_wall
	void OnDoFireball() { BanditBoss_OnDoFireball(); } // do_fireball
	void OnDoSphere() { BanditBoss_OnDoSphere(); } // do_sphere
	void OnGoBlizz() { BanditBoss_OnGoBlizz(); } // go_blizz
	void OnDoKick() { BanditBoss_OnDoKick(); } // do_kick
	void OnDoVolcano() { BanditBoss_OnDoVolcano(); } // do_volcano
	void OnResetAttackAnim() { BanditBoss_OnResetAttackAnim(); } // reset_attack_anim
	void OnDoKeepSpacing() { BanditBoss_OnDoKeepSpacing(); } // do_keep_spacing
	void OnDoChargeShot() { BanditBoss_OnDoChargeShot(); } // do_charge_shot
	void OnChargeTick() { BanditBoss_OnChargeTick(); } // charge_tick
	void OnExpireChargedShot() { BanditBoss_OnExpireChargedShot(); } // expire_charged_shot
	void OnAbortCharge() { BanditBoss_OnAbortCharge(); } // abort_charge
	void OnReleaseChargeFx() { BanditBoss_OnReleaseChargeFx(); } // release_charge_fx
	void OnFinishChargeShot() { BanditBoss_OnFinishChargeShot(); } // finish_charge_shot
	void OnFireChargedBolt() { BanditBoss_OnFireChargedBolt(); } // fire_charged_bolt
	void OnDoScatterShot() { BanditBoss_OnDoScatterShot(); } // do_scatter_shot
	void OnAxeFast() { BanditBoss_OnAxeFast(); } // axe_fast
	void OnAxeSlow() { BanditBoss_OnAxeSlow(); } // axe_slow
	void OnSwordFast() { BanditBoss_OnSwordFast(); } // sword_fast
	void OnSwordSlow() { BanditBoss_OnSwordSlow(); } // sword_slow
	void OnSwingSlow() { BanditBoss_OnSwingSlow(); } // swing_slow
	void OnSwingFast() { BanditBoss_OnSwingFast(); } // swing_fast
	void OnAttackJab() { BanditBoss_OnAttackJab(); } // attack_jab
	void OnPrepDone() { BanditBoss_OnPrepDone(); } // prep_done
	void OnBowShoot() { BanditBoss_OnBowShoot(); } // bow_shoot
	void OnBowStretch() { BanditBoss_OnBowStretch(); } // bow_stretch
	void OnSoundFast() { BanditBoss_OnSoundFast(); } // sound_fast
	void OnSoundSlow() { BanditBoss_OnSoundSlow(); } // sound_slow
	void OnLeapScan() { BanditBoss_OnLeapScan(); } // leap_scan
	void OnLeapAt(string target = "") { BanditBoss_OnLeapAt(target); } // leap_at
	void OnLeapAt2() { BanditBoss_OnLeapAt2(); } // leap_at2
	void OnBanditCharge() { BanditBoss_OnBanditCharge(); } // bandit_charge
	void OnResetLeaping() { BanditBoss_OnResetLeaping(); } // reset_leaping
	void OnClearLeapFlee() { BanditBoss_OnClearLeapFlee(); } // clear_leap_flee
	void OnBullrushStun() { BanditBoss_OnBullrushStun(); } // bullrush_stun
	void OnLeapAway(string target = "") { BanditBoss_OnLeapAway(target); } // leap_away
	void OnLeapAway2() { BanditBoss_OnLeapAway2(); } // leap_away2
	void OnBanditHop() { BanditBoss_OnBanditHop(); } // bandit_hop
	void OnFlankDelayReset() { BanditBoss_OnFlankDelayReset(); } // flank_delay_reset
	void OnTauntSound() { BanditBoss_OnTauntSound(); } // taunt_sound
	void OnGlowLoop() { BanditBoss_OnGlowLoop(); } // glow_loop
	void OnDoInvis() { BanditBoss_OnDoInvis(); } // do_invis
	void OnCheckLegalAct() { BanditBoss_OnCheckLegalAct(); } // check_legal_act
	void OnNpcatkAttack() { BanditBoss_OnNpcatkAttack(); } // npcatk_attack
	void OnChargeExpire() {} // CHARGE_EXPIRE
	void OnChargeFireDelay() {} // CHARGE_FIRE_DELAY
	void OnChargeTickRate() {} // CHARGE_TICK_RATE
	void OnChargeTime() {} // CHARGE_TIME
	void OnFreqAvoid() {} // FREQ_AVOID
	void OnFreqFlank() {} // FREQ_FLANK
	void OnFreqHealth() {} // FREQ_HEALTH
	void OnFreqInvis() {} // FREQ_INVIS
	void OnFreqKick() {} // FREQ_KICK
	void OnFreqPull() {} // FREQ_PULL
	void OnFreqSpacing() {} // FREQ_SPACING
	void OnFreqSpecial() {} // FREQ_SPECIAL
	void OnFreqTurbo() {} // FREQ_TURBO
	void OnFreqVolcano() {} // FREQ_VOLCANO
	void OnLeapClearDelay() {} // LEAP_CLEAR_DELAY
	void OnLeapSuspend() {} // LEAP_SUSPEND
	void OnLFreqCharge() {} // L_FREQ_CHARGE
	void OnLFreqSpecial() {} // L_FREQ_SPECIAL
	void OnLFreqVolcano() {} // L_FREQ_VOLCANO

	// This file's events and timers by their .script names
	bool BanditBoss_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "abort_charge") { OnAbortCharge(); return true; }
		if (name == "attack_jab") { OnAttackJab(); return true; }
		if (name == "axe_fast") { OnAxeFast(); return true; }
		if (name == "axe_slow") { OnAxeSlow(); return true; }
		if (name == "bandit_charge") { OnBanditCharge(); return true; }
		if (name == "bandit_hop") { OnBanditHop(); return true; }
		if (name == "bow_shoot") { OnBowShoot(); return true; }
		if (name == "bow_stretch") { OnBowStretch(); return true; }
		if (name == "bullrush_stun") { OnBullrushStun(); return true; }
		if (name == "charge_tick") { OnChargeTick(); return true; }
		if (name == "check_legal_act") { OnCheckLegalAct(); return true; }
		if (name == "clear_leap_flee") { OnClearLeapFlee(); return true; }
		if (name == "cycle_up") { OnCycleUp(Param(params, 0)); return true; }
		if (name == "do_charge_shot") { OnDoChargeShot(); return true; }
		if (name == "do_fire_wall") { OnDoFireWall(); return true; }
		if (name == "do_fireball") { OnDoFireball(); return true; }
		if (name == "do_invis") { OnDoInvis(); return true; }
		if (name == "do_keep_spacing") { OnDoKeepSpacing(); return true; }
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
		if (name == "expire_charged_shot") { OnExpireChargedShot(); return true; }
		if (name == "finish_charge_shot") { OnFinishChargeShot(); return true; }
		if (name == "fire_charged_bolt") { OnFireChargedBolt(); return true; }
		if (name == "flank_delay_reset") { OnFlankDelayReset(); return true; }
		if (name == "game_damaged") { Return(OnGameDamaged(EntityParam(params, 0), Float(Param(params, 1)), Param(params, 2), Float(Param(params, 3)), EntityParam(params, 4), Param(params, 5))); return true; }
		if (name == "game_death") { OnGameDeath(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
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
		if (name == "npc_targetsighted") { OnNpcTargetsighted(Param(params, 0)); return true; }
		if (name == "npcatk_attack") { OnNpcatkAttack(); return true; }
		if (name == "npcatk_checkflinch") { OnNpcatkCheckflinch(Param(params, 0)); return true; }
		if (name == "npcatk_hunt") { OnNpcatkHunt(); return true; }
		if (name == "npcatk_resume_ai") { OnNpcatkResumeAi(Param(params, 0)); return true; }
		if (name == "prep_done") { OnPrepDone(); return true; }
		if (name == "release_charge_fx") { OnReleaseChargeFx(); return true; }
		if (name == "reset_attack_anim") { OnResetAttackAnim(); return true; }
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
		if (name == "BanditBoss_Timer") { BanditBoss_Timer(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "monsters/bandit_boss"]
shared class BanditBossScript : BaseMonsterNewScript, BanditBoss
{
	// Variables declared by included files, with the value they start with in this script
	BanditBossScript()
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
		Precache("npc/bandit_boss.mdl");
		Precache("nhth1.spr");
		Precache("monsters/bat.mdl");
		Precache("ambience/alien_humongo.wav");
		CallEventDelayed(2.0f, "BanditBoss_Timer");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		BanditBoss_FirstThink();
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
		return BanditBoss_DispatchEvent(name, params)
			|| BaseMonsterNewScript::DispatchEvent(name, params);
	}
}
