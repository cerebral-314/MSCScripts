#pragma context server

// Converted from monsters/swamp_reaver.script by msc_transpiler.
// vitriolic
// The new base for the firereaver.mdl based reavers

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_monster_new.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class SwampReaver
{
	// Constants
	string REAVER_NAME = "Vitriolic Reaver";
	int REAVER_MAXHP = 4000;
	int REAVER_XP = 2750;
	int REAVER_SKIN = 1;
	string REAVER_MODEL = "monsters/firereaver.mdl";
	int REAVER_WIDTH = 72;
	int REAVER_HEIGHT = 64;
	string ANIM_SEARCH = "idle2";
	string ANIM_SMASH = "mattack3";
	string ANIM_SLASH = "mattack2";
	string ANIM_PROJECTILE = "distanceattack";
	string ANIM_BOMB = "bomb_attack";
	string ANIM_ALERT = "distanceattack";
	string ANIM_BREATH = "breath";
	string ANIM_VICTORY1 = "victoryeat";
	string ANIM_VICTORY2 = "victorysniff";
	float FREQ_FIRE_BALL = 10.0f;
	int DMG_FIRE_BALL = 100;
	string SOUND_WALK1 = "common/npc_step1.wav";
	string SOUND_WALK2 = "common/npc_step2.wav";
	string SOUND_WALK3 = "common/npc_step3.wav";
	string SOUND_WALK4 = "common/npc_step4.wav";
	string SOUND_RUN1 = "gonarch/gon_step1.wav";
	string SOUND_RUN2 = "gonarch/gon_step2.wav";
	string SOUND_RUN3 = "gonarch/gon_step3.wav";
	string SOUND_DEATH = "gonarch/gon_die1.wav";
	string SOUND_WARCRY = "gonarch/gon_alert1.wav";
	string SOUND_STRUCK1 = "gonarch/gon_sack1.wav";
	string SOUND_STRUCK2 = "gonarch/gon_sack2.wav";
	string SOUND_PAIN_STRONG = "gonarch/gon_pain2.wav";
	string SOUND_PAIN_WEAK = "gonarch/gon_pain4.wav";
	string SOUND_PAIN_NEAR_DEATH = "gonarch/gon_pain5.wav";
	string SOUND_SLASHHIT = "zombie/claw_strike1.wav";
	string SOUND_SMASHHIT = "zombie/claw_strike2.wav";
	string SOUND_SLASHMISS = "zombie/claw_miss1.wav";
	string SOUND_SMASHMISS = "zombie/claw_miss2.wav";
	string SOUND_SEARCH1 = "gonarch/gon_childdie3.wav";
	string SOUND_SEARCH2 = "gonarch/gon_childdie2.wav";
	string SOUND_SEARCH3 = "gonarch/gon_childdie1.wav";
	string SLASH_DAMAGE = "$rand(100,200)";
	string SMASH_DAMAGE = "500";
	string SLASH_HITCHANCE = "90%";
	float FREQ_ERRUPT = 30.0f;
	float FREQ_BREATH = 0.0f;
	float FREQ_ACID_BOMB = 0.0f;
	bool DOES_ACID_BOMB = true;
	string FIREBALL1_SCRIPT = "monsters/summon/acid_ball_guided";
	string FIREBALL2_SCRIPT = "monsters/summon/acid_ball_guided";
	float FIREBALL1_DURATION = 5.0f;
	float FIREBALL2_DURATION = 5.0f;
	int DMG_ACID_BOMB = 400;
	string SOUND_ACID_BOMB_PREP = "gonarch/gon_birth3.wav";
	string SOUND_ACID_BOMB_FIRE = "gonarch/gon_birth1.wav";
	string SOUND_POISON_ERRUPT_START = "monsters/mummy/c_mummycom_bat1.wav";
	string SOUND_POISON_ERRUPT_LOOP = "amb/amb_spa2.wav";
	string SOUND_POISON_BREATH_START = "monsters/mummy/c_mummycom_bat2.wav";
	string SOUND_POISON_BREATH_LOOP = "magic/volcano_loop.wav";
	string SOUND_FIRE_ERRUPT_START = "magic/volcano_start.wav";
	string SOUND_FIRE_ERRUPT_LOOP = "magic/volcano_loop.wav";
	string SOUND_FIRE_BREATH_START = "ambience/steamburst1.wav";
	string SOUND_FIRE_BREATH_LOOP = "monsters/goblin/sps_fogfire.wav";
	string BOMB_DMG_TYPE = "acid";

	// Variables (an unset .script variable reads as its own name)
	string ANIM_WALK = "walk";
	string ANIM_RUN = "run";
	string ANIM_IDLE = "idle1";
	string ANIM_FLINCH = "ANIM_FLINCH";
	string ANIM_DEATH1 = "ANIM_DEATH1";
	string ANIM_DEATH2 = "ANIM_DEATH2";
	string ANIM_DEATH3 = "ANIM_DEATH3";
	string ANIM_VICTORY = "ANIM_VICTORY";
	string ANIM_DEATH = "ANIM_DEATH";
	string ANIM_ATTACK = "ANIM_ATTACK";
	string SOUND_ATTACKHIT = "SOUND_ATTACKHIT";
	string SOUND_ATTACKMISS = "SOUND_ATTACKMISS";
	float ATTACK_RANGE = 0.0f;
	float ATTACK_HITRANGE = 0.0f;
	float ATTACK_MOVERANGE = 0.0f;
	string MOVE_RANGE = "MOVE_RANGE";
	string DOT_EFFECT = "DOT_EFFECT";
	float DOT_DURATION = 0.0f;
	float DOT_DMG = 0.0f;
	string ERRUPT_TYPE = "ERRUPT_TYPE";
	string BREATH_TYPE = "BREATH_TYPE";
	string PROJECTILE_SCRIPT = "PROJECTILE_SCRIPT";
	int DOT_ACID_BOMB = 0;
	string EFFECT_ACID_BOMB = "EFFECT_ACID_BOMB";
	float NPC_GIVE_EXP = 0.0f;
	float SLASH_COUNT = 0.0f;
	float MIX_COUNT = 0.0f;
	bool DID_WARCRY = false;
	bool FIRST_ATTACK = false;
	bool CYCLES_ON = false;
	float NEXT_ERRUPT = 0.0f;
	float NEXT_BREATH = 0.0f;
	float NEXT_ACID_BOMB = 0.0f;
	bool SLASH_ATTACK = false;
	string PUSH_VEL = "PUSH_VEL";
	bool PUSH_ATTACK = false;
	bool SMASH_ATTACK = false;
	bool STUN_BURST = false;
	Vector3 STUN_POS = Vector3();
	float NEXT_SEARCH = 0.0f;
	float AS_ATTACKING = 0.0f;
	float HP_STORAGE = 0.0f;
	bool VOLCANO_ON = false;
	bool DOING_FIREBALL = false;
	float REAVER_LAST_FIRE_BALL = 0.0f;
	float NEXT_FX_REFRESH = 0.0f;
	string CL_EFFECT_ID = "CL_EFFECT_ID";
	string DOING_ERRUPT = "DOING_ERRUPT";
	string ERRUPT_TARGS = "ERRUPT_TARGS";
	float BREATH_ANG = 0.0f;
	string DOING_BREATH = "DOING_BREATH";
	float BREATH_COUNT = 0.0f;
	float NEXT_SCAN = 0.0f;
	string CLOUD_TARGS = "CLOUD_TARGS";
	bool DOING_ACID_BOMB = false;
	bool ACID_BOMB_ATTACK = false;
	bool IS_FIRE_BOMB = false;
	Vector3 ACID_BOMB_POS = Vector3();

	// unnamed block (first think)
	void SwampReaver_FirstThink()
	{
		ANIM_WALK = "walk";
		ANIM_RUN = "run";
		ANIM_IDLE = "idle1";
		ANIM_FLINCH = "turnl";
		ANIM_DEATH1 = "dieforward";
		ANIM_DEATH2 = "diesimple";
		ANIM_DEATH3 = "diesideways";
		ANIM_VICTORY = "victoryeat";
		ANIM_DEATH = "dieforward";
		ANIM_ATTACK = "mattack3";
	}

	// unnamed block (first think)
	void SwampReaver_FirstThink2()
	{
		SOUND_ATTACKHIT = "unset";
		SOUND_ATTACKMISS = "unset";

		// called indirectly, so need precache
		// defaults are a little too far, prob cuz of large model
		ATTACK_RANGE = 140.0f;
		ATTACK_HITRANGE = 200.0f;
		ATTACK_MOVERANGE = 100.0f;
		MOVE_RANGE = "100";

		// new
		// - a lot of these are setvards as hoping to use this as #include for the mixed version
		DOT_EFFECT = "effects/dot_poison"; // mix reaver varies
		DOT_DURATION = 10.0f; // mix reaver varies
		DOT_DMG = 30.0f; // mix reaver varies
		ERRUPT_TYPE = "poison";
		BREATH_TYPE = "poison";

		PROJECTILE_SCRIPT = "proj_acid_bomb";
		DOT_ACID_BOMB = 150;
		EFFECT_ACID_BOMB = "effects/dot_acid";
	}

	// game_precache
	void SwampReaver_OnGamePrecache()
	{
		// remember to precache both at the top script on the mix reaver
		// precachefile monsters/summon/fire_ball_guided
		PrecacheFile("monsters/summon/acid_ball_guided");
		PrecacheFile("effects/sfx_acid_splash");
	}

	// npc_spawn
	void SwampReaver_OnNpcSpawn(string npc = "")
	{
		SetName(REAVER_NAME);
		SetHealth(REAVER_MAXHP);
		SetRoam(true);
		OnReaverImmunes();
		SetWidth(72);
		SetHeight(64);
		NPC_GIVE_EXP = REAVER_XP;
		SetRace("demon");
		SetHearingSensitivity(3);
		SetModel(REAVER_MODEL);
		SetMoveAnim(ANIM_WALK);
		SetProp(ENT_ME, "skin", REAVER_SKIN);
		SetBlood("green");

		SLASH_COUNT = 0.0f;
		MIX_COUNT = 0.0f;
	}

	// reaver_immunes
	void SwampReaver_OnReaverImmunes()
	{
		SetDamageTaken("lightning", 2);
		SetDamageTaken("acid", 0);
		SetDamageTaken("poison", 0);
		SetDamageTaken("holy", 0.5f); // some magic involved in creation
	}

	// npc_targetsighted
	// first spot
	void SwampReaver_OnNpcTargetsighted(string target = "")
	{
		if (DID_WARCRY)
			return;

		// //dbg temp Spotted Target $get(NPCATK_TARGET,name)
		PlaySound(0, 10, SOUND_WARCRY);
		DID_WARCRY = true;
		FIRST_ATTACK = true;
		PlayAnim("once", ANIM_ALERT);

		if (CYCLES_ON)
			return;

		CYCLES_ON = true;

		float gameTime = GameTime();

		NEXT_ERRUPT = gameTime + FREQ_ERRUPT;

		NEXT_BREATH = gameTime + FREQ_BREATH;

		NEXT_ACID_BOMB = gameTime + FREQ_ACID_BOMB;

		if (CL_EFFECT_ID == "CL_EFFECT_ID")
			OnRefreshClientFx();
	}

	// my_target_died
	void SwampReaver_OnMyTargetDied(string offender = "")
	{
		if (CanSee("enemy"))
			return;

		int randVict = RandomInt(1, 2);
		if (randVict == 1)
			ANIM_VICTORY = ANIM_VICTORY1;
		if (randVict == 2)
			ANIM_VICTORY = ANIM_VICTORY2;
		PlayAnim("critical", ANIM_VICTORY);
		PlayRandomSound(0, 10, SOUND_SEARCH1, SOUND_SEARCH2, SOUND_SEARCH3);
	}

	// npc_targetsighted
	void SwampReaver_OnNpcTargetsighted_2(string target = "")
	{
		if (RangeTo(NPCATK_TARGET) > ATTACK_RANGE)
		{
			float lastFire = REAVER_LAST_FIRE_BALL + FREQ_FIRE_BALL;
			if (!Truthy(DOING_BREATH) && !DOING_ACID_BOMB && GameTime() > lastFire)
				OnDoFireballs();
		}
	}

	// attack_mele1
	// slash (right hook)
	// called from model ANIM_SLASH (mattack2) @ frame 30
	void SwampReaver_OnAttackMele1()
	{
		SLASH_ATTACK = true;
		int randomPush = RandomInt(100, 175);
		PUSH_VEL = Text(RelativeVelocity(Vector3(-200, randomPush, 120)));
		SOUND_ATTACKHIT = SOUND_SLASHHIT;
		SOUND_ATTACKMISS = SOUND_SLASHMISS;
		OnNpcatkDodamage(NPCATK_TARGET, Text(ATTACK_HITRANGE), SLASH_DAMAGE, SLASH_HITCHANCE);
		PUSH_ATTACK = true;

		SLASH_COUNT += 1.0f;
		if (SLASH_COUNT > RandomInt(9, 15))
			ANIM_ATTACK = ANIM_SMASH;
	}

	// attack_mele2
	// smash (overhead strike)
	// called from model ANIM_SMASH (mattack3) @ frame 30
	void SwampReaver_OnAttackMele2()
	{
		SMASH_ATTACK = true;
		SOUND_ATTACKHIT = SOUND_SMASHHIT;
		SOUND_ATTACKMISS = SOUND_SMASHMISS;
		ANIM_ATTACK = ANIM_SLASH;

		// createnpc monsters/summon/stun_burst $relpos(0,0,0) $get(ent_me,id) 256 1 SMASH_DAMAGE
		ClientEvent("new", "all", "effects/sfx_stun_burst", OriginOf(ENT_ME), 256, 0);
		STUN_BURST = true;
		STUN_POS = OriginOf(ENT_ME);
		DoDamage(Text(RelativePosition(Vector3(0, 0, 0))), 256, SMASH_DAMAGE, "100%", 0, "reflective", "blunt");
		CallEventDelayed(0.1f, "reset_stun_burst");

		SLASH_COUNT = 0.0f;
		ANIM_ATTACK = ANIM_SLASH;
	}

	// reset_stun_burst
	void SwampReaver_OnResetStunBurst()
	{
		STUN_BURST = false;
	}

	// npcatk_lost_sight
	void SwampReaver_OnNpcatkLostSight()
	{
		if (!(GameTime() > NEXT_SEARCH))
			return;
		NEXT_SEARCH = GameTime() + 20.0f;
		AS_ATTACKING = GameTime() + 10.0f;
		PlayAnim("critical", ANIM_SEARCH);
		PlayRandomSound(0, 10, SOUND_SEARCH1, SOUND_SEARCH2, SOUND_SEARCH3);
	}

	// game_dodamage
	// 1: Attack Hit (1/0)  2: Entity Attack hit  3:  Start Position  4:  End Position
	string SwampReaver_OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		Vector3 targOrg = Vec("TARG_ORG");
		Vector3 myOrg = Vec("MY_ORG");
		float newYaw = 0.0f;
		bool exitSub = false;
		string result = "";

		if (STUN_BURST && hit)
		{
			targOrg = OriginOf(target);
			myOrg = STUN_POS;
			newYaw = AnglesTo(myOrg, targOrg);
			AddVelocity(target, RelativeVelocity(Vector3(0, newYaw, 0), Vector3(0, 1000, 200)));
			ApplyEffect(target, "effects/debuff_stun", 5.0f, self);
		}
		if (exitSub)
			return result;

		if (ACID_BOMB_ATTACK)
		{
			exitSub = true;
			if (hit && RelationshipOf(target, ENT_ME) == "enemy")
			{
				ApplyEffect(target, EFFECT_ACID_BOMB, 5, self, DOT_ACID_BOMB, "none");

				if (IS_FIRE_BOMB)
				{
					targOrg = OriginOf(target);
					myOrg = ACID_BOMB_POS;
					newYaw = AnglesTo(myOrg, targOrg);
					AddVelocity(target, RelativeVelocity(Vector3(0, newYaw, 0), Vector3(0, 1000, 200)));
				}
			}
		}
		if (exitSub)
			return result;

		if (!hit && SOUND_ATTACKMISS != "unset")
			PlaySound(0, 10, SOUND_ATTACKMISS);

		if (hit && SOUND_ATTACKHIT != "unset")
		{
			PlaySound(0, 10, SOUND_ATTACKHIT);
			if (PUSH_ATTACK)
			{
				AddVelocity(ENT_LASTSTRUCKBYME, Vec(PUSH_VEL));
				ApplyEffect(DOT_EFFECT, Text(DOT_DURATION), self, DOT_DMG);
			}
		}
		PUSH_ATTACK = false;
		return result;
	}

	// game_struck
	void SwampReaver_OnGameStruck(float damage = 0.0f, string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		string painSound = "PAIN_SOUND";

		HP_STORAGE = MyHealth(); // anti-heal

		if (MyHealth() >= 1500.0f)
			painSound = SOUND_PAIN_STRONG;
		if (MyHealth() < 1500.0f)
			painSound = SOUND_PAIN_WEAK;
		if (MyHealth() < 500.0f)
			painSound = SOUND_PAIN_NEAR_DEATH;
		PlayRandomSound(0, 10, SOUND_STRUCK1, SOUND_STRUCK2, SOUND_STRUCK1, SOUND_STRUCK2, painSound);
	}

	// monster_walk_step
	// called from model anim walk at various frames
	void SwampReaver_OnMonsterWalkStep()
	{
		PlayRandomSound(0, 5, SOUND_WALK1, SOUND_WALK2, SOUND_WALK3, SOUND_WALK4);
	}

	// monster_run_step
	// called from model anim run at various frames
	void SwampReaver_OnMonsterRunStep()
	{
		Effect("screenshake", RelativePosition(Vector3(0, 0, 0)), 64, 10, 0.5f, 128);
		PlayRandomSound(0, 8, SOUND_RUN1, SOUND_RUN2, SOUND_RUN3);
	}

	// npc_death
	// called from base_npc
	void SwampReaver_OnNpcDeath()
	{
		// death anims
		int randDeath = RandomInt(2, 3);
		// if ( RAND_DEATH == 1 ) setvard ANIM_DEATH ANIM_DEATH1 //use for volcano anim instead
		if (randDeath == 2)
			ANIM_DEATH = ANIM_DEATH2;
		if (randDeath == 3)
			ANIM_DEATH = ANIM_DEATH3;

		SetMoveDest("none");
		SetMoveAnim(ANIM_DEATH);
	}

	// npcatk_clear_targets
	void SwampReaver_OnNpcatkClearTargets(string reason = "")
	{
		VOLCANO_ON = false;
		ServerPlaySound(2, 0, "magic/volcano_loop.wav");
	}

	// do_fireballs
	void SwampReaver_OnDoFireballs()
	{
		if (I_R_FROZEN)
			return;
		DOING_FIREBALL = true;
		CallEventDelayed(2.0f, "fireball_release");
		AS_ATTACKING = GameTime() + 10.0f;
		REAVER_LAST_FIRE_BALL = GameTime();
		PlayAnim("critical", ANIM_PROJECTILE);
		CreateNpc(FIREBALL1_SCRIPT, RelativePosition(Vector3(-64, 96, 64)), self, DMG_FIRE_BALL, FIREBALL1_DURATION, 200);
		CallEventDelayed(0.2f, "do_fireballs2");
	}

	// do_fireballs2
	void SwampReaver_OnDoFireballs2()
	{
		CreateNpc(FIREBALL2_SCRIPT, RelativePosition(Vector3(64, 96, 64)), self, DMG_FIRE_BALL, FIREBALL2_DURATION, 200);
	}

	// fireball_release
	void SwampReaver_OnFireballRelease()
	{
		DOING_FIREBALL = false;
	}

	// npcatk_hunt
	// { do_fireballs3
	// createnpc monsters/summon/fire_ball_guided $relpos(0,96,64) $get(ent_me,id) DMG_FIRE_BALL 20.0 200
	// }
	void SwampReaver_OnNpcatkHunt()
	{
		float gameTime = GameTime();

		if (CYCLES_ON && gameTime > NEXT_FX_REFRESH)
			OnRefreshClientFx();

		if (NPCATK_TARGET == "unset")
			return;

		if (gameTime > NEXT_ERRUPT)
		{
			NEXT_ERRUPT = gameTime + FREQ_ERRUPT;
			if (Truthy(GetVar("MIXED_REAVER")))
				OnMixedReaverSwitch();
			OnDoErrupt();
		}

		if (!CanSee(NPCATK_TARGET))
			return;
		if (DOING_FIREBALL)
			return;

		if (gameTime > NEXT_BREATH && !DOING_ACID_BOMB && RangeTo(NPCATK_TARGET) < 300.0f)
		{
			NEXT_BREATH = gameTime + FREQ_BREATH;
			if (Truthy(GetVar("MIXED_REAVER")))
				OnMixedReaverSwitch();
			if (!I_R_FROZEN)
				OnDoBreath();
		}

		if (gameTime > NEXT_ACID_BOMB && !Truthy(DOING_ERRUPT) && !Truthy(DOING_BREATH) && RangeTo(NPCATK_TARGET) > 275.0f)
		{
			NEXT_ACID_BOMB = gameTime + FREQ_ACID_BOMB;
			if (Truthy(GetVar("MIXED_REAVER")))
				OnMixedReaverSwitch();
			if (!I_R_FROZEN)
				OnDoAcidBomb();
		}
	}

	// refresh_client_fx
	void SwampReaver_OnRefreshClientFx()
	{
		NEXT_FX_REFRESH = GameTime() + 30.0f;
		ClientEvent("new", "all", "monsters/reavers_cl", IndexOf(ENT_ME), BREATH_TYPE, ERRUPT_TYPE, DOING_ERRUPT, DOING_BREATH);
		CL_EFFECT_ID = LastClientScriptId();
	}

	// game_death
	void SwampReaver_OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		if (CL_EFFECT_ID == "CL_EFFECT_ID")
			return;
		if (Truthy(DOING_BREATH))
			OnFrameBreathEnd();

		if (Truthy(DOING_ERRUPT))
			OnEndErrupt();

		ClientEvent("update", "all", CL_EFFECT_ID, "end_fx");

		if (ToLowerCase(MapName()) == "mscave")
		{
			// spawn some treasurez
			CBaseEntity@ chestId = FindByName("fire_cave_chest2");
			if (Exists(chestId))
				CreateNpc("mscave/firecave2", RelativePosition(Vector3(0, 0, 0)), "fire_reaver");
		}
	}

	// do_errupt
	void SwampReaver_OnDoErrupt()
	{
		DOING_ERRUPT = "1";
		ClientEvent("update", "all", CL_EFFECT_ID, "errupt_on", ERRUPT_TYPE);
		OnErruptLoop();
		CallEventDelayed(10.0f, "end_errupt");
		if (ERRUPT_TYPE == "poison")
		{
			ServerPlaySound(1, 10, SOUND_POISON_ERRUPT_LOOP);
			PlaySound(2, 10, SOUND_POISON_ERRUPT_START);
		}
		else
		{
			ServerPlaySound(1, 10, SOUND_FIRE_ERRUPT_LOOP);
			PlaySound(2, 10, SOUND_FIRE_ERRUPT_START);
		}
	}

	// errupt_loop
	void SwampReaver_OnErruptLoop()
	{
		int count;
		if (!Truthy(DOING_ERRUPT))
			return;
		CallEventDelayed(0.75f, "errupt_loop");
		if (ERRUPT_TYPE == "poison")
		{
			ERRUPT_TARGS = FindInSphere("enemy", 160);
			if (ERRUPT_TARGS != "none")
			{
				count = GetTokenCount(ERRUPT_TARGS);
				for (int i = 0; i < count; i++)
				{
					loopIteration = i;
					OnErruptAffectTargetsPoison();
				}
			}
		}
		else
		{
			ERRUPT_TARGS = FindInSphere("enemy", 225);
			if (ERRUPT_TARGS != "none")
			{
				count = GetTokenCount(ERRUPT_TARGS);
				for (int i = 0; i < count; i++)
				{
					loopIteration = i;
					OnErruptAffectTargetsFire();
				}
			}
		}
	}

	// errupt_affect_targets_poison
	void SwampReaver_OnErruptAffectTargetsPoison()
	{
		CBaseEntity@ curTarg = FindEntity(GetToken(ERRUPT_TARGS, loopIteration));
		ApplyEffect(curTarg, "effects/dot_poison_blind", 5.0f, self, DOT_DMG);
	}

	// errupt_affect_targets_fire
	void SwampReaver_OnErruptAffectTargetsFire()
	{
		CBaseEntity@ curTarg = FindEntity(GetToken(ERRUPT_TARGS, loopIteration));
		ApplyEffect(curTarg, "effects/dot_fire", 5.0f, self, DOT_DMG);
	}

	// end_errupt
	void SwampReaver_OnEndErrupt()
	{
		DOING_ERRUPT = "0";
		ClientEvent("update", "all", CL_EFFECT_ID, "errupt_off");
		if (ERRUPT_TYPE == "poison")
			ServerPlaySound(1, 0, SOUND_POISON_ERRUPT_LOOP);
		else
			ServerPlaySound(1, 0, SOUND_FIRE_ERRUPT_LOOP);
	}

	// do_breath
	void SwampReaver_OnDoBreath()
	{
		SetRoam(false);
		PlayAnim("break");
		PlayAnim("critical", ANIM_BREATH);
		OnNpcatkSuspendMovement(ANIM_BREATH);

		if (BREATH_TYPE == "poison")
			PlaySound(1, 10, SOUND_POISON_BREATH_START);
		else
			PlaySound(1, 10, SOUND_FIRE_BREATH_START);

		SetMoveDest(NPCATK_TARGET, 9999);
		OnNpcatkSuspendAi();

		BREATH_ANG = AnglesOf(ENT_ME).y;
		CallEventDelayed(1.5f, "frame_breath_start"); // in case he fails to play anim
		CallEventDelayed(15.0f, "frame_breath_end"); // in case he gets stuck
	}

	// frame_breath_start
	void SwampReaver_OnFrameBreathStart()
	{
		DebugPrint("frame_breath_start");
		if (Truthy(DOING_BREATH))
			return;
		DOING_BREATH = "1";
		if (BREATH_TYPE == "poison")
			PlaySound(2, 10, SOUND_POISON_BREATH_LOOP);
		else
			PlaySound(2, 10, SOUND_FIRE_BREATH_LOOP);
		BREATH_COUNT = 0.0f;
		BREATH_ANG = AnglesOf(ENT_ME).y;
		CallEventDelayed(0.1f, "breath_loop");
		ClientEvent("update", "all", CL_EFFECT_ID, "breath_on", BREATH_TYPE);
	}

	// breath_loop
	void SwampReaver_OnBreathLoop()
	{
		int count;
		if (!Truthy(DOING_BREATH))
			return;
		CallEventDelayed(0.05f, "breath_loop");

		BREATH_ANG += 10.0f;
		if (BREATH_ANG > 359.99f)
			BREATH_ANG -= 359.99f;

		Vector3 facePos = OriginOf(ENT_ME);
		facePos += RelativePosition(Vector3(0, BREATH_ANG, 0), Vector3(0, 1000, 0));
		SetMoveDest(facePos, 9999);
		DebugPrint("breath_loop " + Text(BREATH_ANG));

		// setangle face $vec(0,BREATH_ANG,0)
		if (!(GameTime() > NEXT_SCAN))
			return;
		NEXT_SCAN = GameTime() + 0.25f;
		Vector3 scanPoint = RelativePosition(Vector3(0, 128, 0));
		CLOUD_TARGS = LegacyFunction("get_tsphere", "enemy", 256, scanPoint);
		if (CLOUD_TARGS != "none")
		{
			count = GetTokenCount(CLOUD_TARGS);
			for (int i = 0; i < count; i++)
			{
				loopIteration = i;
				OnBreathAffectTargets();
			}
		}
	}

	// breath_affect_targets
	void SwampReaver_OnBreathAffectTargets()
	{
		CBaseEntity@ curTarg = FindEntity(GetToken(CLOUD_TARGS, loopIteration));
		Vector3 targOrg = OriginOf(curTarg);
		if (!WithinCone2D(targOrg, MyOrigin(), MyAngles(), 30))
			return;
		float targRange = RangeTo(curTarg);
		if (!(targRange < 450.0f))
			return;
		if (BREATH_TYPE == "poison")
			ApplyEffect(curTarg, "effects/dot_poison_blind", 5.0f, self, DOT_DMG, 0, 0, "none");
		else
			ApplyEffect(curTarg, "effects/dot_fire", 5.0f, self, DOT_DMG);

		float pushStr = 1000.0f;
		if (targRange > 200.0f)
			pushStr -= targRange;
		AddVelocity(curTarg, RelativeVelocity(Vector3(0, pushStr, 120)));
	}

	// frame_breath_end
	void SwampReaver_OnFrameBreathEnd()
	{
		DebugPrint("frame_breath_end");
		if (!Truthy(DOING_BREATH))
			return;
		DOING_BREATH = "0";
		OnNpcatkResumeAi();
		OnNpcatkResumeMovement();
		ClientEvent("update", "all", CL_EFFECT_ID, "breath_off");
		SetRoam(true);
		NEXT_ACID_BOMB += 5.0f;
	}

	// do_acid_bomb
	void SwampReaver_OnDoAcidBomb()
	{
		DebugPrint("do_acid_bomb");
		SetRoam(false);

		// setmovedest NPCATK_TARGET 9999
		// callevent npcatk_suspend_ai 0.5
		DOING_ACID_BOMB = true;
		AS_ATTACKING = GameTime() + 10.0f;
		PlaySound(0, 10, SOUND_ACID_BOMB_PREP);

		CallEventDelayed(3.0f, "doing_acid_bomb_reset"); // in case interrupted
		PlayAnim("critical", ANIM_BOMB);
	}

	// doing_acid_bomb_reset
	void SwampReaver_OnDoingAcidBombReset()
	{
		DOING_ACID_BOMB = false;
	}

	// attack_ranged
	void SwampReaver_OnAttackRanged()
	{
		DebugPrint("attack_ranged");

		PlaySound(0, 10, SOUND_ACID_BOMB_FIRE);

		NEXT_BREATH += 5.0f;
	}

	// attack_bomb
	void SwampReaver_OnAttackBomb()
	{
		PlaySound(0, 10, SOUND_ACID_BOMB_FIRE);
		Vector3 targOrg = OriginOf(NPCATK_TARGET);
		if (!IsPlayer(Text(targOrg)))
			targOrg.z += HeightOf(NPCATK_TARGET);
		float targDist = Divide(Distance(targOrg, MyOrigin()), 35.0f);
		SetAngle("add_view.pitch", targDist);

		DebugPrint("attack_bomb " + Text(RangeTo(NPCATK_TARGET)));

		// not exactly dynamic, but works
		int bombSpeed = 500;
		if (RangeTo(NPCATK_TARGET) > 800.0f)
			bombSpeed = 600;

		// <projectile scriptname> <"view"|(src_origin)> <target|(targ_origin)|none> <speed> <damage> <cof> <skill|none> //Converted to use new tossprojectile //greatguys1@FEB2022
		TossProjectile(PROJECTILE_SCRIPT, RelativePosition(Vector3(0, 20, 28)), "none", bombSpeed, "DMG_BOMB", 0, "none");
		SetRoam(true);
		// callevent npcatk_resume_ai
		DOING_ACID_BOMB = false;
	}

	// ext_acid_bomb
	// <land point> - called by proj_acid_bomb
	void SwampReaver_OnExtAcidBomb(Vector3 landPosition = Vector3())
	{
		ACID_BOMB_ATTACK = true;
		DoDamageEx(landPosition, 200, DMG_ACID_BOMB, "100%", ENT_ME, ENT_ME, "none", "acid");
		IS_FIRE_BOMB = true;
		CallEventDelayed(0.1f, "acid_bomb_reset");
	}

	// acid_bomb_reset
	void SwampReaver_OnAcidBombReset()
	{
		ACID_BOMB_ATTACK = false;
	}

	// ext_fire_bomb
	// <land point> - called by proj_fire_bomb
	void SwampReaver_OnExtFireBomb(Vector3 landPosition = Vector3())
	{
		ACID_BOMB_ATTACK = true;
		ACID_BOMB_POS = landPosition;
		IS_FIRE_BOMB = true;
		DoDamageEx(ACID_BOMB_POS, 200, DMG_ACID_BOMB, 0.01f, ENT_ME, ENT_ME, "none", BOMB_DMG_TYPE);
		CallEventDelayed(0.1f, "acid_bomb_reset");
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
		SwampReaver_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4);
	}

	// game_struck
	void OnGameStruck(float damage = 0.0f, string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		BaseNpc_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseNpcAttackNew_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc_attack_new
		BaseMonsterShared_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared
		SwampReaver_OnGameStruck(damage, extraValue2, extraValue3, extraValue4);
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseNpcAttackNew_OnNpcSpawn(npc); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck
		SwampReaver_OnNpcSpawn(npc);
	}

	// npcatk_hunt
	void OnNpcatkHunt()
	{
		BaseNpcAttackNew_OnNpcatkHunt(); // monsters/base_npc_attack_new
		BaseAntiStuck_OnNpcatkHunt(); // monsters/base_anti_stuck
		SwampReaver_OnNpcatkHunt();
	}

	// npcatk_lost_sight
	void OnNpcatkLostSight()
	{
		BaseNpcAttackNew_OnNpcatkLostSight(); // monsters/base_npc_attack_new
		SwampReaver_OnNpcatkLostSight();
	}

	// npcatk_clear_targets
	void OnNpcatkClearTargets(string reason = "")
	{
		BaseNpcAttackNew_OnNpcatkClearTargets(reason); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcatkClearTargets(reason); // monsters/base_monster_shared
		BaseMonsterShared_OnNpcatkClearTargets_2(reason); // monsters/base_monster_shared
		SwampReaver_OnNpcatkClearTargets(reason);
	}

	// my_target_died
	void OnMyTargetDied(string offender = "")
	{
		BaseNpcAttackNew_OnMyTargetDied(offender); // monsters/base_npc_attack_new
		SwampReaver_OnMyTargetDied(offender);
	}

	// game_dodamage
	string OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";
		result = AppendResult(result, BaseNpcAttackNew_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BaseAntiStuck_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BaseMonsterShared_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, SwampReaver_OnGameDodamage(hit, target, start, end, damageType, damageText));
		return result;
	}

	// npc_targetsighted
	void OnNpcTargetsighted(string target = "")
	{
		BaseMonsterShared_OnNpcTargetsighted(target); // monsters/base_monster_shared
		SwampReaver_OnNpcTargetsighted(target);
		SwampReaver_OnNpcTargetsighted_2(target);
	}

	void OnGamePrecache() { SwampReaver_OnGamePrecache(); } // game_precache
	void OnReaverImmunes() { SwampReaver_OnReaverImmunes(); } // reaver_immunes
	void OnAttackMele1() { SwampReaver_OnAttackMele1(); } // attack_mele1
	void OnAttackMele2() { SwampReaver_OnAttackMele2(); } // attack_mele2
	void OnResetStunBurst() { SwampReaver_OnResetStunBurst(); } // reset_stun_burst
	void OnMonsterWalkStep() { SwampReaver_OnMonsterWalkStep(); } // monster_walk_step
	void OnMonsterRunStep() { SwampReaver_OnMonsterRunStep(); } // monster_run_step
	void OnNpcDeath() { SwampReaver_OnNpcDeath(); } // npc_death
	void OnDoFireballs() { SwampReaver_OnDoFireballs(); } // do_fireballs
	void OnDoFireballs2() { SwampReaver_OnDoFireballs2(); } // do_fireballs2
	void OnFireballRelease() { SwampReaver_OnFireballRelease(); } // fireball_release
	void OnRefreshClientFx() { SwampReaver_OnRefreshClientFx(); } // refresh_client_fx
	void OnDoErrupt() { SwampReaver_OnDoErrupt(); } // do_errupt
	void OnErruptLoop() { SwampReaver_OnErruptLoop(); } // errupt_loop
	void OnErruptAffectTargetsPoison() { SwampReaver_OnErruptAffectTargetsPoison(); } // errupt_affect_targets_poison
	void OnErruptAffectTargetsFire() { SwampReaver_OnErruptAffectTargetsFire(); } // errupt_affect_targets_fire
	void OnEndErrupt() { SwampReaver_OnEndErrupt(); } // end_errupt
	void OnDoBreath() { SwampReaver_OnDoBreath(); } // do_breath
	void OnFrameBreathStart() { SwampReaver_OnFrameBreathStart(); } // frame_breath_start
	void OnBreathLoop() { SwampReaver_OnBreathLoop(); } // breath_loop
	void OnBreathAffectTargets() { SwampReaver_OnBreathAffectTargets(); } // breath_affect_targets
	void OnFrameBreathEnd() { SwampReaver_OnFrameBreathEnd(); } // frame_breath_end
	void OnDoAcidBomb() { SwampReaver_OnDoAcidBomb(); } // do_acid_bomb
	void OnDoingAcidBombReset() { SwampReaver_OnDoingAcidBombReset(); } // doing_acid_bomb_reset
	void OnAttackRanged() { SwampReaver_OnAttackRanged(); } // attack_ranged
	void OnAttackBomb() { SwampReaver_OnAttackBomb(); } // attack_bomb
	void OnExtAcidBomb(Vector3 landPosition = Vector3()) { SwampReaver_OnExtAcidBomb(landPosition); } // ext_acid_bomb
	void OnAcidBombReset() { SwampReaver_OnAcidBombReset(); } // acid_bomb_reset
	void OnExtFireBomb(Vector3 landPosition = Vector3()) { SwampReaver_OnExtFireBomb(landPosition); } // ext_fire_bomb
	void OnMixedReaverSwitch() {} // mixed_reaver_switch

	// This file's events and timers by their .script names
	bool SwampReaver_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "acid_bomb_reset") { OnAcidBombReset(); return true; }
		if (name == "attack_bomb") { OnAttackBomb(); return true; }
		if (name == "attack_mele1") { OnAttackMele1(); return true; }
		if (name == "attack_mele2") { OnAttackMele2(); return true; }
		if (name == "attack_ranged") { OnAttackRanged(); return true; }
		if (name == "breath_affect_targets") { OnBreathAffectTargets(); return true; }
		if (name == "breath_loop") { OnBreathLoop(); return true; }
		if (name == "do_acid_bomb") { OnDoAcidBomb(); return true; }
		if (name == "do_breath") { OnDoBreath(); return true; }
		if (name == "do_errupt") { OnDoErrupt(); return true; }
		if (name == "do_fireballs") { OnDoFireballs(); return true; }
		if (name == "do_fireballs2") { OnDoFireballs2(); return true; }
		if (name == "doing_acid_bomb_reset") { OnDoingAcidBombReset(); return true; }
		if (name == "end_errupt") { OnEndErrupt(); return true; }
		if (name == "errupt_affect_targets_fire") { OnErruptAffectTargetsFire(); return true; }
		if (name == "errupt_affect_targets_poison") { OnErruptAffectTargetsPoison(); return true; }
		if (name == "errupt_loop") { OnErruptLoop(); return true; }
		if (name == "ext_acid_bomb") { OnExtAcidBomb(Vec(Param(params, 0))); return true; }
		if (name == "ext_fire_bomb") { OnExtFireBomb(Vec(Param(params, 0))); return true; }
		if (name == "fireball_release") { OnFireballRelease(); return true; }
		if (name == "frame_breath_end") { OnFrameBreathEnd(); return true; }
		if (name == "frame_breath_start") { OnFrameBreathStart(); return true; }
		if (name == "game_death") { OnGameDeath(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_dodamage") { Return(OnGameDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5))); return true; }
		if (name == "game_precache") { OnGamePrecache(); return true; }
		if (name == "game_struck") { OnGameStruck(Float(Param(params, 0)), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "monster_run_step") { OnMonsterRunStep(); return true; }
		if (name == "monster_walk_step") { OnMonsterWalkStep(); return true; }
		if (name == "my_target_died") { OnMyTargetDied(Param(params, 0)); return true; }
		if (name == "npc_death") { OnNpcDeath(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "npc_targetsighted") { OnNpcTargetsighted(Param(params, 0)); return true; }
		if (name == "npcatk_clear_targets") { OnNpcatkClearTargets(Param(params, 0)); return true; }
		if (name == "npcatk_hunt") { OnNpcatkHunt(); return true; }
		if (name == "npcatk_lost_sight") { OnNpcatkLostSight(); return true; }
		if (name == "reaver_immunes") { OnReaverImmunes(); return true; }
		if (name == "refresh_client_fx") { OnRefreshClientFx(); return true; }
		if (name == "reset_stun_burst") { OnResetStunBurst(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "monsters/swamp_reaver"]
shared class SwampReaverScript : BaseMonsterNewScript, SwampReaver
{
	// Variables declared by included files, with the value they start with in this script
	SwampReaverScript()
	{
		ANIM_WALK = "walk";
		ANIM_RUN = "run";
		ANIM_IDLE = "idle1";
		SOUND_DEATH = "gonarch/gon_die1.wav";
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/firereaver.mdl");
		Precache("magic/volcano_loop.wav");
		Precache("amb/amb_spa2.wav");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		SwampReaver_FirstThink();
		SwampReaver_FirstThink2();
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
		return SwampReaver_DispatchEvent(name, params)
			|| BaseMonsterNewScript::DispatchEvent(name, params);
	}
}
