#pragma context server

// Converted from minibosses/titan.script by msc_transpiler.
// Titan (for J's Olympus)
// Placement Requirements:
// - There can be only one (effects through central system)
// - Summons appear above creature's spawn point, so players should be sealed in that area
// Spells:
// -Guided Lightning Balls (1 per player)
// -Summon birds
// -Summon Scorpions (2 huge or 1 giant)
// -smash attack if player in proper position
// -kick atk
// -grab & throw atk
// -stomp attack (stun burst)
// -meteror storm (drops boulders from sky in radius - use tossprojectile)
// -v.big, v.slow

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_monster_new.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class Titan
{
	// Constants
	bool CANT_FLEE = true;
	float FLINCH_DAMAGE_THRESHOLD = 50.0f;
	string FLINCH_DELAY = "20.0";
	string ANIM_SWIPE = "swipe2";
	string ANIM_METEOR = "roar2";
	string ANIM_STOMP = "stomp";
	string ANIM_SNAP = "bitehead";
	string ANIM_GRAB = "throw1";
	string ANIM_SQUEEZE = "throw2";
	string ANIM_THROW = "throw3";
	string ANIM_SMASH = "punch";
	string ANIM_KICK = "kick";
	string ANIM_CAST = "summon";
	string MONSTER_MODEL = "monsters/titan.mdl";
	int SCORP_SPAWN_VADJ = 650;
	int SCORP_RAD = 300;
	string SCORP_SCRIPT1 = "monsters/scorpion5_stone";
	string SCORP_SCRIPT2 = "monsters/scorpion6_stone";
	string CHANCE_KICK = "25";
	float FREQ_GRAB = 60.0f;
	int DMG_THROW = 800;
	int SUM_RAD = 300;
	int SUM_VADJ = 650;
	string DMG_SWIPE = "150";
	int DMG_METEOR = 300;
	string DMG_KICK = "250";
	int DMG_STOMP = 100;
	int DMG_BALL = 200;
	int DMG_SQUEEZE = 30;
	string BIRD_SCRIPT = "monsters/eagle_stone";
	int BIRD_COOLDOWN = 55;
	Vector3 SMASH_OFS = Vector3();
	int SMASH_RANGE = 128;
	Vector3 SWIPE_OFS = Vector3();
	int SWIPE_RAD = 200;
	int R_ARM_ATT_IDX = 2;
	int L_ARM_ATT_IDX = 3;
	float FREQ_KICK = 10.0f;
	float FREQ_STOMP = 10.0f;
	float FREQ_SMASH = 5.0f;
	string SOUND_SUMMON = "debris/beamstart1.wav";
	string SOUND_YAWN1 = "garg/gar_breathe1.wav";
	string SOUND_YAWN2 = "garg/gar_breathe2.wav";
	string SOUND_YAWN3 = "garg/gar_breathe3.wav";
	string SOUND_RAWR = "garg/gar_alert2.wav";
	string SOUND_STEP1 = "garg/gar_step1.wav";
	string SOUND_STEP2 = "garg/gar_step2.wav";
	string SOUND_SWIPE = "weapons/swinghuge.wav";
	string SOUND_KICK = "weapons/swinghuge.wav";
	string SOUND_THROW = "weapons/swinghuge.wav";
	string SOUND_DEATH = "garg/gar_die1.wav";
	string SOUND_GRAB = "garg/gar_attack2.wav";
	string SOUND_SQUEEZE = "garg/gar_alert1.wav";
	string CL_GLOW_SPR = "3dmflaora.spr";
	string CL_TELE_SPR = "c-tele1.spr";

	// Variables (an unset .script variable reads as its own name)
	string ANIM_WALK = "walk";
	string ANIM_IDLE = "idle";
	bool IS_UNHOLY = true;
	bool NO_STEP_ADJ = true;
	string ANIM_RUN = "ANIM_RUN";
	string ANIM_ATTACK = "ANIM_ATTACK";
	string ANIM_DEATH = "ANIM_DEATH";
	string FLINCH_ANIM = "FLINCH_ANIM";
	float FLINCH_HEALTH = 0.0f;
	string NPC_MUST_SEE_TARGET = "NPC_MUST_SEE_TARGET";
	float ATTACK_RANGE = 0.0f;
	float ATTACK_HITRANGE = 0.0f;
	float ATTACK_MOVERANGE = 0.0f;
	string MOVE_RANGE = "MOVE_RANGE";
	string CAN_RETALIATE = "CAN_RETALIATE";
	bool IMMUNE_VAMPIRE = false;
	bool LAST_BIRD = false;
	bool NPC_IS_BOSS = false;
	float NPC_GIVE_EXP = 0.0f;
	float TITAN_RNDAMT = 0.0f;
	float N_SCORPS = 0.0f;
	float T_SUM_ANG = 0.0f;
	bool WALK_COUNT = false;
	bool DO_GRAB = false;
	string CL_IDX = "CL_IDX";
	string M_SUMMON_POINT1 = "M_SUMMON_POINT1";
	string M_SUMMON_POINT2 = "M_SUMMON_POINT2";
	string M_SUMMON_POINT3 = "M_SUMMON_POINT3";
	string M_SUMMON_POINT4 = "M_SUMMON_POINT4";
	float M_BIRD_ROT = 0.0f;
	float M_SUMMON_COUNT = 0.0f;
	bool M_SUMMON_POINTS = false;
	float N_BALLS = 0.0f;
	string SCORP_SCRIPT = "SCORP_SCRIPT";
	bool M_SUMMON_BIRDS = false;
	float ROT_ANG = 0.0f;
	float METEOR_COUNT = 0.0f;
	float NEXT_KICK = 0.0f;
	float NEXT_STOMP = 0.0f;
	float CHANCE_STOMP = 0.0f;
	string BALL_TARGETS = "BALL_TARGETS";
	float N_BIRDS = 0.0f;
	Vector3 SMASH_SCAN_POINT = Vector3();
	string SMASH_TARGET = "SMASH_TARGET";
	float NEXT_SMASH = 0.0f;
	float SUM_ANG = 0.0f;
	int ALTERNATE_SUM_POINT = 0;
	Vector3 SUM_POINT = Vector3();
	string GRAB_TARG = "GRAB_TARG";
	bool GRAB_MODE = false;
	float NEXT_GRAB = 0.0f;
	float END_SQEEEZE_DMG_LOOP = 0.0f;
	string STUN_BURST_POS = "STUN_BURST_POS";
	int STUN_BURST_RAD = 0;
	bool STUN_BURST_REPEL = false;
	string STUN_BURST_DMG = "STUN_BURST_DMG";
	string STUN_LIST = "STUN_LIST";

	// unnamed block (first think)
	void Titan_FirstThink()
	{
		// base anims
		ANIM_WALK = "walk";
		ANIM_IDLE = "idle";
		ANIM_RUN = "walk"; // doesn't run
		ANIM_ATTACK = "swipe2";
		ANIM_DEATH = "death";
		FLINCH_ANIM = "flinchheavy";
		FLINCH_HEALTH = 2000.0f;
		NPC_MUST_SEE_TARGET = "0"; // cuz very big

		// base stats
		IS_UNHOLY = true;
		NO_STEP_ADJ = true; // monster is so tall, he might climb up just about anything
		ATTACK_RANGE = 300.0f;
		ATTACK_HITRANGE = 350.0f;
		ATTACK_MOVERANGE = 250.0f;
		MOVE_RANGE = "250";
		CAN_RETALIATE = "0"; // kinda single minded
		IMMUNE_VAMPIRE = true;
		LAST_BIRD = false;

		if (Contains(ToLowerCase(MapName()), "thanatos"))
		{
			NPC_IS_BOSS = true;
			NPC_GIVE_EXP = 16000.0f; // raised another 1000xp for fire resist MAY2010_24
		}
		else
		{
			NPC_GIVE_EXP = 1000.0f;
		}
	}

	// game_precache
	void Titan_OnGamePrecache()
	{
		PrecacheFile(SCORP_SCRIPT1);
		PrecacheFile(SCORP_SCRIPT2);
		PrecacheFile("monsters/summon/lightning_ball_guided");
		PrecacheFile(BIRD_SCRIPT);
		PrecacheFile("chests/olympus");
	}

	// npc_spawn
	void Titan_OnNpcSpawn(string npc = "")
	{
		if (ToLowerCase(MapName()) == "thanatos")
			SetName("Titan");
		else
			SetName("Elder Earth Elemental");

		SetModel(MONSTER_MODEL);
		SetHealth(18000);
		SetWidth(200);
		SetHeight(600);
		SetRace("demon");
		SetRoam(false);
		SetHearingSensitivity(11);
		SetDamageTaken("all", 0.5f);
		SetDamageTaken("holy", 0.5f);
		SetDamageTaken("fire", 0.5f); // compensate for not being fraid nothin
		SetDamageTaken("poison", 0); // if we go with stone titan
		SetDamageTaken("stun", 0);

		SetBlood("none");

		SetStepSize(32);

		SetIdleAnim("bust");
		SetMoveAnim("bust");
		PlayAnim("critical", "bust");

		TITAN_RNDAMT = 0.0f;
		SetProp(ENT_ME, "rendermode", 2);
		SetProp(ENT_ME, "renderamt", 0);
		OnTitanFadeIn();

		OnNpcatkSuspendAi();

		CallEventDelayed(5.0f, "do_special");
		CallEventDelayed(0.1f, "smash_scanner");
		N_SCORPS = 0.0f;
		T_SUM_ANG = 0.0f;
		WALK_COUNT = false;
		DO_GRAB = false;

		CL_IDX = Eval("const.localplayer.scriptID");
		ClientEvent("update", "all", CL_IDX, "titan_setup", IndexOf(ENT_ME), CL_TELE_SPR, CL_GLOW_SPR);

		CallEventDelayed(0.5f, "get_map_summon_points");
	}

	// get_map_summon_points
	void Titan_OnGetMapSummonPoints()
	{
		M_SUMMON_POINT1 = EntityId(FindByName("titan_summon_point1"));
		M_SUMMON_POINT2 = EntityId(FindByName("titan_summon_point2"));
		M_SUMMON_POINT3 = EntityId(FindByName("titan_summon_point3"));
		M_SUMMON_POINT4 = EntityId(FindByName("titan_summon_point4"));
		M_SUMMON_POINT1 = Text(OriginOf(M_SUMMON_POINT1));
		M_SUMMON_POINT2 = Text(OriginOf(M_SUMMON_POINT2));
		M_SUMMON_POINT3 = Text(OriginOf(M_SUMMON_POINT3));
		M_SUMMON_POINT4 = Text(OriginOf(M_SUMMON_POINT4));

		M_BIRD_ROT = 0.0f;
		M_SUMMON_COUNT = 0.0f;
		M_SUMMON_POINTS = true;
		if (Vec(M_SUMMON_POINT1).x != 0.0f)
			return;
		if (Vec(M_SUMMON_POINT2).y != 0.0f)
			return;
		if (Vec(M_SUMMON_POINT3).z != 0.0f)
			return;
		M_SUMMON_POINTS = false;
	}

	// frame_spawn_done
	void Titan_OnFrameSpawnDone()
	{
		OnNpcatkResumeAi();
		SetIdleAnim(ANIM_IDLE);
		SetMoveAnim(ANIM_WALK);
	}

	// do_special
	void Titan_OnDoSpecial()
	{
		float nextSpecial = 0.0f;
		bool exitSub = false;

		if (!IsAlive(ENT_ME))
			return;

		if (SUSPEND_AI)
		{
			// busy with somethin else, come back soon
			nextSpecial = 1.0f;
			CallEventDelayed(nextSpecial, "do_special");
			exitSub = true;
		}
		if (exitSub)
			return;

		nextSpecial = 20.0f; // default freq, some specials take longer than others

		if (IsAlive(NPCATK_TARGET))
		{
			int nSpecials = 4; // constant this when finished

			int rndSpecial = RandomInt(1, nSpecials);

			if (rndSpecial == 1)
			{
				if (N_SCORPS < 2.0f)
				{
					OnDoScorps(); // (these need to spawn in a radius from his spawn pos to prevent stuckage)
					nextSpecial = 20.0f;
				}
				else
				{
					rndSpecial = RandomInt(2, nSpecials);
				}
			}
			if (rndSpecial == 2)
				OnDoBirds();
			if (rndSpecial == 3) {}
			// local NEXT_SPECIAL 20.0
			// callevent do_meteors
			if (rndSpecial == 4)
			{
				N_BALLS = 0.0f;
				OnDoLballs();
			}
		}

		CallEventDelayed(nextSpecial, "do_special");
	}

	// do_scorps
	void Titan_OnDoScorps()
	{
		PlayAnim("critical", ANIM_CAST);
		CallEventDelayed(1.0f, "do_scorps2");
	}

	// do_scorps2
	void Titan_OnDoScorps2()
	{
		SCORP_SCRIPT = SCORP_SCRIPT1;
		if (Float(Eval("game.players.totalhp")) > 4000.0f)
			SCORP_SCRIPT = SCORP_SCRIPT2;

		N_SCORPS += 1.0f;
		M_SUMMON_BIRDS = false;
		OnGetSummonPoint();
		CreateNpc(SCORP_SCRIPT, SUM_POINT, self);
		CallExternal(ENT_LASTCREATED, "ext_delay_target", 3.0f, "enemy");
		if (!(N_SCORPS < 2.0f))
			return;
		if (Float(Eval("game.players.totalhp")) <= 4000.0f)
		{
			CallEventDelayed(0.1f, "do_scorps3"); // delay for t3h l4g
		}
	}

	// do_scorps3
	void Titan_OnDoScorps3()
	{
		N_SCORPS += 1.0f;
		M_SUMMON_BIRDS = false;
		OnGetSummonPoint();
		CreateNpc(SCORP_SCRIPT, SUM_POINT, self);
		CallExternal(ENT_LASTCREATED, "ext_delay_target", 3.0f, "enemy");
	}

	// scorpion_died
	void Titan_OnScorpionDied()
	{
		N_SCORPS -= 1.0f;
	}

	// do_meteors
	void Titan_OnDoMeteors()
	{
		OnNpcatkSuspendAi();
		SetMoveAnim(ANIM_METEOR);
		SetIdleAnim(ANIM_METEOR);
		PlayAnim("once", ANIM_METEOR);
		ROT_ANG = Float(Eval("game.monster.angles.yaw"));
		METEOR_COUNT = 0.0f;
		PlaySound(0, 10, SOUND_RAWR);
		OnDoMeteorsLoop();
	}

	// do_meteors_loop
	void Titan_OnDoMeteorsLoop()
	{
		if (METEOR_COUNT < 18.0f)
		{
			ROT_ANG += 20.0f;
			if (ROT_ANG > 359.0f)
				ROT_ANG -= 359.0f;
			Vector3 moveDest = MyOrigin() + RelativePosition(Vector3(0, ROT_ANG, 0), Vector3(0, 1000, 0));
			SetMoveDest(moveDest, 9999);

			// <projectile scriptname> <"view"|(src_origin)> <target|(targ_origin)|none> <speed> <damage> <cof> <skill|none> //Converted to use new tossprojectile //greatguys1@FEB2022
			// tossprojectile "proj_catapaultball" view MOVE_DEST none 200 DMG_METEOR 0 none //i broke it :(
			METEOR_COUNT += 1.0f;
			CallEventDelayed(0.1f, "do_meteors_loop");
		}
		else
		{
			OnNpcatkResumeAi();
			SetMoveAnim(ANIM_WALK);
			SetIdleAnim(ANIM_IDLE);
			PlayAnim("break");
		}
	}

	// frame_kick
	void Titan_OnFrameKick()
	{
		ANIM_ATTACK = ANIM_SWIPE;
		NEXT_KICK = GameTime() + FREQ_KICK;
		PlaySound(0, 10, SOUND_KICK);
		if (!(RangeTo(NPCATK_TARGET) < ATTACK_HITRANGE))
			return;
		// applyeffect NPCATK_TARGET effects/effect_knockback 5.0 $get(ent_me,id) $relvel(0,-500,20)
		AddVelocity(NPCATK_TARGET, RelativeVelocity(Vector3(0, 1000, 200)));
		ApplyEffect(NPCATK_TARGET, "effects/debuff_stun", 2.0f, self);
		DoDamage(NPCATK_TARGET, "direct", DMG_KICK, "100%", ENT_ME, "blunt");
	}

	// frame_stomp
	void Titan_OnFrameStomp()
	{
		ANIM_ATTACK = ANIM_SWIPE;
		// //createnpc monsters/summon/stun_burst $relpos(50,50,0) $get(ent_me,id) 512 1 DMG_STOMP
		Vector3 burstPos = RelativePosition(Vector3(50, 50, 0));
		float grndBurst = GroundHeight(burstPos);
		burstPos.z = grndBurst;
		OnStunburstGo(Text(burstPos), 512, 1, Text(DMG_STOMP));

		NEXT_STOMP = GameTime() + FREQ_STOMP;
	}

	// frame_swipe
	void Titan_OnFrameSwipe()
	{
		PlaySound(0, 10, SOUND_SWIPE);
		Vector3 swipePoint = SWIPE_OFS;

		// dodamage SWIPE_POINT 256 DMG_SWIPE 100% 0.0 normal blunt
		// using xdodamage instead of dodamage, as dodamage AOE requires monster can "see" initial dmg point - and his model is too large for him to see through
		DoDamageEx(swipePoint, SWIPE_RAD, DMG_SWIPE, 0.0f, ENT_ME, ENT_ME, "none", "blunt");

		// debugarry
		// if ( G_DEVELOPER_MODE )
		// {
		// local BEAM_END SWIPE_POINT
		// vectoradd BEAM_END z 64
		// effect beam point lgtning.spr 30 SWIPE_POINT BEAM_END (255,255,0) 200 0 0.4
		// }
		if (RandomInt(1, 100) < Float(CHANCE_KICK) && GameTime() > NEXT_KICK)
			ANIM_ATTACK = ANIM_KICK;

		// check players nearby
		// if several nearby, next attack more likely to be stomp
		CHANCE_STOMP = 10.0f;
		SetVar("PLAYER_LIST", GetActivePlayers());
		int count = GetTokenCount("PLAYER_LIST");
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnStompCheck();
		}
		if (CHANCE_STOMP > 50.0f) // cap at 50
			CHANCE_STOMP = 50.0f;
		if (!(RandomInt(1, 100) < CHANCE_STOMP))
			return;
		if (!(GameTime() > NEXT_STOMP))
			return;
		ANIM_ATTACK = ANIM_STOMP;
	}

	// stomp_check
	void Titan_OnStompCheck()
	{
		string curPlayer = GetToken("PLAYER_LIST", loopIteration);
		if (!(RangeTo(curPlayer) < ATTACK_HITRANGE))
			return;
		CHANCE_STOMP += 10.0f;
	}

	// do_lballs
	void Titan_OnDoLballs()
	{
		if (N_BALLS == 0.0f)
			PlayAnim("critical", ANIM_CAST);

		BALL_TARGETS = TokenShuffle(LegacyFunction("get_tsphere", "enemy", 2048, MyOrigin()));
		OnGetSummonPoint();

		CreateNpc("monsters/summon/lightning_ball_guided", SUM_POINT, self, DMG_BALL, 30.0f, 192, GetToken(BALL_TARGETS, 0));
		N_BALLS += 1.0f;

		int nBallTargs = GetTokenCount(BALL_TARGETS);

		if (!(N_BALLS < 2.0f))
			return;
		CallEventDelayed(0.1f, "do_lballs"); // at least 2

		if (!(nBallTargs > 1)) // +1 per player, max 8 (stagger creation to prevent lag)
			return;

		float nBallsSans2 = N_BALLS - 2.0f;
		if (nBallsSans2 < nBallTargs)
		{
			float nBallsF10 = N_BALLS * 0.1f;
			CallEventDelayed(nBallsF10, "do_lballs");
		}
	}

	// do_birds
	void Titan_OnDoBirds()
	{
		float diff = (LAST_BIRD ? 1.0f : 0.0f) - GameTime();
		if (!(diff > BIRD_COOLDOWN))
			return;
		PlayAnim("critical", ANIM_CAST);
		CallExternal("all", "summon_eagle_vanish");
		N_BIRDS = 0.0f;
		OnDoBirdsLoop();
	}

	// do_birds_loop
	// 2 per player, max 12
	void Titan_OnDoBirdsLoop()
	{
		M_SUMMON_BIRDS = true;
		OnGetSummonPoint();
		CreateNpc(BIRD_SCRIPT, SUM_POINT);
		CallExternal(ENT_LASTCREATED, "ext_delay_target", 3.0f, "enemy");
		N_BIRDS += 1.0f;

		if (!(N_BIRDS < 12.0f))
			return;
		float dblNplayers = PlayerCount() * 2.0f;
		if (!(N_BIRDS < dblNplayers))
			return;
		CallEventDelayed(0.1f, "do_birds_loop");
	}

	// game_death
	void Titan_OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		CBaseEntity@ titanId = self;
		Vector3 titanDeathPos = OriginOf(ENT_ME);
		Vector3 titanStunPos = RelativePosition(Vector3(0, 400, 0));

		CreateNpc("chests/olympus", Vec(NPC_HOME_LOC));

		// go out with bang
		CallExternal(GetVar("GAME_MASTER"), "gm_createnpc", 4.0f, "monsters/summon/stun_burst", titanStunPos, @titanId, 512, 1, 100);
		CallExternal(GetVar("GAME_MASTER"), "gold_spew", 500, 2, 256, 4, 16, titanDeathPos);
	}

	// smash_scanner
	void Titan_OnSmashScanner()
	{
		if (!IsAlive(ENT_ME))
			return;
		CallEventDelayed(0.5f, "smash_scanner");

		if (!(GameTime() > NEXT_SMASH))
			return;

		SMASH_SCAN_POINT = SMASH_OFS;

		// debugarry
		// if ( G_DEVELOPER_MODE )
		// {
		// local BEAM_END SMASH_SCAN_POINT
		// vectoradd BEAM_END z 256
		// effect beam point lgtning.spr 30 SMASH_SCAN_POINT BEAM_END (255,0,255) 200 0 0.4
		// }
		// I *think* this is faster than doing an AOE scan
		SMASH_TARGET = "unset";
		SetVar("SMASH_PLAYER_LIST", GetActivePlayers());
		int count = GetTokenCount("SMASH_PLAYER_LIST");
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnCheckForSmash();
		}

		if (SMASH_TARGET == "unset")
			return;
		ANIM_ATTACK = ANIM_SMASH;
		DO_GRAB = false;
		if (!(GameTime() > NEXT_GRAB))
			return;
		if (RandomInt(1, 2) != 1)
			return;
		DO_GRAB = true; // do grab instead
		ANIM_ATTACK = ANIM_GRAB;
	}

	// check_for_smash
	void Titan_OnCheckForSmash()
	{
		CBasePlayer@ curPlayer = FindPlayer(GetToken("SMASH_PLAYER_LIST", loopIteration));
		Vector3 curPlayerOrg = OriginOf(curPlayer);
		if (Distance(curPlayerOrg, SMASH_SCAN_POINT) < SMASH_RANGE)
			SMASH_TARGET = EntityId(curPlayer);
	}

	// frame_smash
	void Titan_OnFrameSmash()
	{
		NEXT_SMASH = GameTime() + FREQ_SMASH;
		ANIM_ATTACK = ANIM_SWIPE;
		Vector3 smashPoint = SMASH_OFS;
		smashPoint.z += 64.0f; // little above in case player is on a lip
		// //createnpc monsters/summon/stun_burst SMASH_POINT $get(ent_me,id) 128 0 DMG_STOMP
		string burstPos = Text(smashPoint);
		OnStunburstGo(burstPos, 128, 0, Text(DMG_STOMP));
	}

	// get_summon_point
	void Titan_OnGetSummonPoint()
	{
		int armIdx = 0;

		// alternate summon points to opposite ends of arena from one another for maximum coverage
		if (!M_SUMMON_POINTS)
		{
			if (ALTERNATE_SUM_POINT == 0)
			{
				T_SUM_ANG += 20.0f;
				if (T_SUM_ANG > 359.0f)
					T_SUM_ANG -= 359.0f;
				SUM_ANG = T_SUM_ANG;
				ALTERNATE_SUM_POINT = 1;
			}
			else
			{
				SUM_ANG = T_SUM_ANG + 180.0f;
				if (SUM_ANG > 359.0f)
					SUM_ANG -= 359.0f;
				ALTERNATE_SUM_POINT = 0;
			}

			SUM_POINT = Vec(NPC_HOME_LOC);
			SUM_POINT += RelativePosition(Vector3(0, SUM_ANG, 0), Vector3(0, SUM_RAD, SUM_VADJ));

			if (ALTERNATE_SUM_POINT != 0)
			{
				Effect("beam", "end", "lgtning.spr", 120, SUM_POINT, ENT_ME, R_ARM_ATT_IDX, Vector3(64, 64, 255), 200, 30, 1.0f);
				ClientEvent("update", "all", CL_IDX, "titan_summon_sprite", SUM_POINT);
			}
			else
			{
				Effect("beam", "end", "lgtning.spr", 120, SUM_POINT, ENT_ME, L_ARM_ATT_IDX, Vector3(64, 64, 255), 200, 30, 1.0f);
				ClientEvent("update", "all", CL_IDX, "titan_summon_sprite", SUM_POINT);
			}
		}
		else
		{
			M_SUMMON_COUNT += 1.0f;
			if (M_SUMMON_COUNT == 1.0f)
			{
				SUM_POINT = Vec(M_SUMMON_POINT1);
				armIdx = R_ARM_ATT_IDX;
			}
			else if (M_SUMMON_COUNT == 2.0f)
			{
				SUM_POINT = Vec(M_SUMMON_POINT2);
				armIdx = L_ARM_ATT_IDX;
			}
			else if (M_SUMMON_COUNT == 3.0f)
			{
				SUM_POINT = Vec(M_SUMMON_POINT3);
				armIdx = R_ARM_ATT_IDX;
			}
			else if (M_SUMMON_COUNT == 4.0f)
			{
				SUM_POINT = Vec(M_SUMMON_POINT4);
				armIdx = L_ARM_ATT_IDX;
				M_SUMMON_COUNT = 0.0f;
			}

			if (M_SUMMON_BIRDS)
			{
				// since there's only 4 summon points, and we can spawn up to 12 birds
				M_BIRD_ROT += 90.0f;
				if (M_BIRD_ROT > 359.99f)
					M_BIRD_ROT = 0.0f;
				SUM_POINT += RelativePosition(Vector3(0, M_BIRD_ROT, 0), Vector3(0, 96, 0));
			}

			DebugPrint("get_summon_point - using map points " + Text(SUM_POINT));

			Effect("beam", "end", "lgtning.spr", 120, SUM_POINT, ENT_ME, L_ARM_ATT_IDX, Vector3(64, 64, 255), 200, 30, 1.0f);
			ClientEvent("update", "all", CL_IDX, "titan_summon_sprite", SUM_POINT);
		}

		PlaySound(2, 10, SOUND_SUMMON);
	}

	// frame_walk_step1
	void Titan_OnFrameWalkStep1()
	{
		PlaySound(0, 5, SOUND_STEP1);
	}

	// frame_walk_step2
	void Titan_OnFrameWalkStep2()
	{
		PlaySound(0, 5, SOUND_STEP2);
	}

	// frame_idle_breath
	void Titan_OnFrameIdleBreath()
	{
		PlayRandomSound(2, 10, SOUND_YAWN1, SOUND_YAWN2, SOUND_YAWN3);
	}

	// frame_idle_yawn
	void Titan_OnFrameIdleYawn()
	{
		PlayRandomSound(2, 10, SOUND_YAWN1, SOUND_YAWN2, SOUND_YAWN3);
	}

	// frame_grab_player
	// animation: throw1
	void Titan_OnFrameGrabPlayer()
	{
		GRAB_TARG = "0";
		if (IsAlive(SMASH_TARGET))
		{
			PlaySound(0, 10, SOUND_GRAB);
			Vector3 grabTargOrg = OriginOf(SMASH_TARGET);
			Vector3 fistOrg = AttachmentPositionOf(ENT_ME, R_ARM_ATT_IDX);
			DebugPrint("frame_grab_body " + Text(fistOrg) + " vs " + Text(grabTargOrg));
			if (Distance(fistOrg, grabTargOrg) < 128.0f)
			{
				GRAB_TARG = SMASH_TARGET;
				GRAB_MODE = true;
				CallEventDelayed(0.01f, "lock_player_to_hand");
				// callexternal ext_setfollow $get(ent_me,id) none
				OnNpcatkSuspendAi();
				CallEventDelayed(0.5f, "face_home");
			}
			else
			{
				NEXT_GRAB = GameTime() + FREQ_GRAB;
				ANIM_ATTACK = ANIM_SWIPE;
			}
		}
		else
		{
			NEXT_GRAB = GameTime() + 10.0f;
			ANIM_ATTACK = ANIM_SWIPE;
		}
	}

	// frame_start_squeeze
	void Titan_OnFrameStartSqueeze()
	{
		if (!IsAlive(GRAB_TARG))
			return;
		PlayAnim("critical", ANIM_SQUEEZE);
	}

	// frame_squeeze_player
	void Titan_OnFrameSqueezePlayer()
	{
		PlaySound(0, 10, SOUND_SQUEEZE);
		END_SQEEEZE_DMG_LOOP = GameTime() + 2.0f;
		OnSqueezeDmgLoop();
		Effect("screenshake", GetProp(GRAB_TARG, "org"), 190, 20, 3, 32);
	}

	// squeeze_dmg_loop
	void Titan_OnSqueezeDmgLoop()
	{
		if (!(GameTime() < END_SQEEEZE_DMG_LOOP))
			return;
		if (!IsAlive(GRAB_TARG))
			GRAB_MODE = false;
		if (!IsAlive(GRAB_TARG))
			return;
		if (!(RangeTo(GRAB_TARG) < 1024.0f)) // case dies and respawns
			return;

		CallEventDelayed(0.1f, "squeeze_dmg_loop");

		DoDamage(GRAB_TARG, "direct", DMG_SQUEEZE, "100%", ENT_ME, "blunt");
	}

	// frame_squeeze_done
	void Titan_OnFrameSqueezeDone()
	{
		if (!IsAlive(GRAB_TARG))
		{
			OnNpcatkResumeAi();
			GRAB_MODE = false;
		}
		else
		{
			PlayAnim("critical", ANIM_THROW);
		}
	}

	// face_home
	void Titan_OnFaceHome()
	{
		SetMoveDest(NPC_HOME_LOC, 9999);
	}

	// lock_player_to_hand
	void Titan_OnLockPlayerToHand()
	{
		if (!GRAB_MODE)
			return;
		CallEventDelayed(0.01f, "lock_player_to_hand");
		SetOrigin(GRAB_TARG, AttachmentPositionOf(ENT_ME, R_ARM_ATT_IDX));
		SetVelocity(GRAB_TARG, Vector3(0, 0, 0));
	}

	// frame_toss_player
	// anim: throw3
	void Titan_OnFrameTossPlayer()
	{
		OnNpcatkResumeAi();
		GRAB_MODE = false;
		NEXT_GRAB = GameTime() + FREQ_GRAB;
		Vector3 shiftOrg = AttachmentPositionOf(ENT_ME, L_ARM_ATT_IDX);
		shiftOrg.z += 580.0f;
		SetOrigin(GRAB_TARG, shiftOrg);
		SetProp(GRAB_TARG, "movetype", Eval("const.movetype.bouncemissle"));
		AddVelocity(GRAB_TARG, RelativeVelocity(Vector3(0, 2000, 200)));
		DoDamage(GRAB_TARG, "direct", DMG_THROW, "100%", "blunt");
		ApplyEffect(GRAB_TARG, "effects/debuff_stun", 10.0f, self);
		PlaySound(0, 10, SOUND_THROW);
	}

	// ext_popup
	// debuggary
	void Titan_OnExtPopup()
	{
		Vector3 myZ = MyOrigin();
		myZ.z += 96.0f;
		SetOrigin(ENT_ME, myZ);
	}

	// titan_fade_in
	void Titan_OnTitanFadeIn()
	{
		if (TITAN_RNDAMT == 255.0f)
		{
			SetProp(ENT_ME, "rendermode", 0);
			SetRoam(true);
		}
		if (!(TITAN_RNDAMT < 255.0f))
			return;
		TITAN_RNDAMT += 5.0f;
		SetProp(ENT_ME, "renderamt", TITAN_RNDAMT);
		CallEventDelayed(0.1f, "titan_fade_in");
	}

	// stunburst_go
	// <pos> <radius> <repel:0|1> <dmg>
	void Titan_OnStunburstGo(string pos = "", int radius = 0, int repel = 0, string dmg = "")
	{
		STUN_BURST_POS = pos;
		STUN_BURST_RAD = radius;
		STUN_BURST_REPEL = repel != 0;
		STUN_BURST_DMG = dmg;
		DebugPrint("stunburst_go pos: " + STUN_BURST_POS + " rad: " + STUN_BURST_RAD + " repel: " + Text(STUN_BURST_REPEL) + " dmg: " + STUN_BURST_DMG);

		ClientEvent("update", "all", CL_IDX, "fx_stunburst_go_cl", STUN_BURST_POS, STUN_BURST_RAD);
		CallEventDelayed(0.25f, "stun_targets");
	}

	// stun_targets
	void Titan_OnStunTargets()
	{
		STUN_LIST = LegacyFunction("get_tsphere", "enemy", STUN_BURST_RAD, STUN_BURST_POS);
		DebugPrint("stun_targets " + STUN_LIST);
		if (STUN_LIST == "none")
			return;
		if (!(GetTokenCount(STUN_LIST) > 0))
			return;
		int count = GetTokenCount(STUN_LIST);
		int outerIteration = loopIteration;
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnStunburstAffectTargets();
		}
		loopIteration = outerIteration;
	}

	// stunburst_affect_targets
	void Titan_OnStunburstAffectTargets()
	{
		CBaseEntity@ checkEnt = FindEntity(GetToken(STUN_LIST, loopIteration));

		if (!IsOnGround(checkEnt))
			return;

		ApplyEffect(checkEnt, "effects/debuff_stun", 5.0f, self);

		if (Float(STUN_BURST_DMG) > 0.0f)
			DoDamage(checkEnt, "direct", STUN_BURST_DMG, "100%", ENT_ME, "magic");

		if (!STUN_BURST_REPEL)
			return;
		Vector3 targetOrg = OriginOf(checkEnt);
		float targAng = AnglesTo(Vec(STUN_BURST_POS), targetOrg);
		int newYaw = int(targAng);
		SetVelocity(checkEnt, RelativeVelocity(Vector3(0, newYaw, 0), Vector3(0, 1000, 0)));
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)
	void OnGamePrecache() { Titan_OnGamePrecache(); } // game_precache

	// game_death
	void OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		DqMonsterExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // dq/externals/dq_monster_externals
		MonstersExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/externals
		BaseSelfAdjust_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_self_adjust
		BaseNpc_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseMonsterShared_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared
		Titan_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4);
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseNpcAttackNew_OnNpcSpawn(npc); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck
		Titan_OnNpcSpawn(npc);
	}

	void OnGetMapSummonPoints() { Titan_OnGetMapSummonPoints(); } // get_map_summon_points
	void OnFrameSpawnDone() { Titan_OnFrameSpawnDone(); } // frame_spawn_done
	void OnDoSpecial() { Titan_OnDoSpecial(); } // do_special
	void OnDoScorps() { Titan_OnDoScorps(); } // do_scorps
	void OnDoScorps2() { Titan_OnDoScorps2(); } // do_scorps2
	void OnDoScorps3() { Titan_OnDoScorps3(); } // do_scorps3
	void OnScorpionDied() { Titan_OnScorpionDied(); } // scorpion_died
	void OnDoMeteors() { Titan_OnDoMeteors(); } // do_meteors
	void OnDoMeteorsLoop() { Titan_OnDoMeteorsLoop(); } // do_meteors_loop
	void OnFrameKick() { Titan_OnFrameKick(); } // frame_kick
	void OnFrameStomp() { Titan_OnFrameStomp(); } // frame_stomp
	void OnFrameSwipe() { Titan_OnFrameSwipe(); } // frame_swipe
	void OnStompCheck() { Titan_OnStompCheck(); } // stomp_check
	void OnDoLballs() { Titan_OnDoLballs(); } // do_lballs
	void OnDoBirds() { Titan_OnDoBirds(); } // do_birds
	void OnDoBirdsLoop() { Titan_OnDoBirdsLoop(); } // do_birds_loop
	void OnSmashScanner() { Titan_OnSmashScanner(); } // smash_scanner
	void OnCheckForSmash() { Titan_OnCheckForSmash(); } // check_for_smash
	void OnFrameSmash() { Titan_OnFrameSmash(); } // frame_smash
	void OnGetSummonPoint() { Titan_OnGetSummonPoint(); } // get_summon_point
	void OnFrameWalkStep1() { Titan_OnFrameWalkStep1(); } // frame_walk_step1
	void OnFrameWalkStep2() { Titan_OnFrameWalkStep2(); } // frame_walk_step2
	void OnFrameIdleBreath() { Titan_OnFrameIdleBreath(); } // frame_idle_breath
	void OnFrameIdleYawn() { Titan_OnFrameIdleYawn(); } // frame_idle_yawn
	void OnFrameGrabPlayer() { Titan_OnFrameGrabPlayer(); } // frame_grab_player
	void OnFrameStartSqueeze() { Titan_OnFrameStartSqueeze(); } // frame_start_squeeze
	void OnFrameSqueezePlayer() { Titan_OnFrameSqueezePlayer(); } // frame_squeeze_player
	void OnSqueezeDmgLoop() { Titan_OnSqueezeDmgLoop(); } // squeeze_dmg_loop
	void OnFrameSqueezeDone() { Titan_OnFrameSqueezeDone(); } // frame_squeeze_done
	void OnFaceHome() { Titan_OnFaceHome(); } // face_home
	void OnLockPlayerToHand() { Titan_OnLockPlayerToHand(); } // lock_player_to_hand
	void OnFrameTossPlayer() { Titan_OnFrameTossPlayer(); } // frame_toss_player
	void OnExtPopup() { Titan_OnExtPopup(); } // ext_popup
	void OnTitanFadeIn() { Titan_OnTitanFadeIn(); } // titan_fade_in
	void OnStunburstGo(string pos = "", int radius = 0, int repel = 0, string dmg = "") { Titan_OnStunburstGo(pos, radius, repel, dmg); } // stunburst_go
	void OnStunTargets() { Titan_OnStunTargets(); } // stun_targets
	void OnStunburstAffectTargets() { Titan_OnStunburstAffectTargets(); } // stunburst_affect_targets
	void OnNextSpecial() {} // NEXT_SPECIAL
	void OnNBallsF10() {} // N_BALLS_F10

	// This file's events and timers by their .script names
	bool Titan_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "check_for_smash") { OnCheckForSmash(); return true; }
		if (name == "do_birds") { OnDoBirds(); return true; }
		if (name == "do_birds_loop") { OnDoBirdsLoop(); return true; }
		if (name == "do_lballs") { OnDoLballs(); return true; }
		if (name == "do_meteors") { OnDoMeteors(); return true; }
		if (name == "do_meteors_loop") { OnDoMeteorsLoop(); return true; }
		if (name == "do_scorps") { OnDoScorps(); return true; }
		if (name == "do_scorps2") { OnDoScorps2(); return true; }
		if (name == "do_scorps3") { OnDoScorps3(); return true; }
		if (name == "do_special") { OnDoSpecial(); return true; }
		if (name == "ext_popup") { OnExtPopup(); return true; }
		if (name == "face_home") { OnFaceHome(); return true; }
		if (name == "frame_grab_player") { OnFrameGrabPlayer(); return true; }
		if (name == "frame_idle_breath") { OnFrameIdleBreath(); return true; }
		if (name == "frame_idle_yawn") { OnFrameIdleYawn(); return true; }
		if (name == "frame_kick") { OnFrameKick(); return true; }
		if (name == "frame_smash") { OnFrameSmash(); return true; }
		if (name == "frame_spawn_done") { OnFrameSpawnDone(); return true; }
		if (name == "frame_squeeze_done") { OnFrameSqueezeDone(); return true; }
		if (name == "frame_squeeze_player") { OnFrameSqueezePlayer(); return true; }
		if (name == "frame_start_squeeze") { OnFrameStartSqueeze(); return true; }
		if (name == "frame_stomp") { OnFrameStomp(); return true; }
		if (name == "frame_swipe") { OnFrameSwipe(); return true; }
		if (name == "frame_toss_player") { OnFrameTossPlayer(); return true; }
		if (name == "frame_walk_step1") { OnFrameWalkStep1(); return true; }
		if (name == "frame_walk_step2") { OnFrameWalkStep2(); return true; }
		if (name == "game_death") { OnGameDeath(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_precache") { OnGamePrecache(); return true; }
		if (name == "get_map_summon_points") { OnGetMapSummonPoints(); return true; }
		if (name == "get_summon_point") { OnGetSummonPoint(); return true; }
		if (name == "lock_player_to_hand") { OnLockPlayerToHand(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "scorpion_died") { OnScorpionDied(); return true; }
		if (name == "smash_scanner") { OnSmashScanner(); return true; }
		if (name == "squeeze_dmg_loop") { OnSqueezeDmgLoop(); return true; }
		if (name == "stomp_check") { OnStompCheck(); return true; }
		if (name == "stun_targets") { OnStunTargets(); return true; }
		if (name == "stunburst_affect_targets") { OnStunburstAffectTargets(); return true; }
		if (name == "stunburst_go") { OnStunburstGo(Param(params, 0), Int(Param(params, 1)), Int(Param(params, 2)), Param(params, 3)); return true; }
		if (name == "titan_fade_in") { OnTitanFadeIn(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "minibosses/titan"]
shared class TitanScript : BaseMonsterNewScript, Titan
{
	// Variables declared by included files, with the value they start with in this script
	TitanScript()
	{
		ANIM_WALK = "walk";
		ANIM_IDLE = "idle";
		FLINCH_DAMAGE_THRESHOLD = 50.0f;
		FLINCH_DELAY = "20.0";
		NO_STEP_ADJ = true;
		SOUND_DEATH = "garg/gar_die1.wav";
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("3dmflaora.spr");
		Precache("c-tele1.spr");
		Precache("monsters/titan.mdl");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		Titan_FirstThink();
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
		return Titan_DispatchEvent(name, params)
			|| BaseMonsterNewScript::DispatchEvent(name, params);
	}
}
