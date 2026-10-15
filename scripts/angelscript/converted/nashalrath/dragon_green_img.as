#pragma context server

// Converted from nashalrath/dragon_green_img.script by msc_transpiler.
// Jaminportlants
// . tele -1278 3221 -347
// . eventall start_battle
// . eventall drop_meteor
// Mind you, this was setup before base_chat_array got the ability to play sounds
// Plus, Jaz's voice plays everywhere on the map, so his sound needs are a bit unique

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_chat_array.as"
#include "converted/monsters/debug.as"

[script "nashalrath/dragon_green_img"]
class DragonGreenImg : BaseChatArrayScript, Debug
{
	// Constants
	string ANIM_IDLE_LOOK = "anim_img_idle2_look";
	string ANIM_TALK = "anim_img_idle2_talk";
	string ANIM_LEAVE = "anim_img_flyout";
	string ANIM_LIFT_LEFT = "anim_img_lift_left";
	string ANIM_LIFT_RIGHT = "anim_img_lift_right";
	string ANIM_BREATH_STORM = "anim_img_breath_storm";
	string ANIM_SUMMON = "anim_img_idle2_look";
	string ANIM_LAUGH = "anim_img_idle2_talk";
	string ANIM_LAUGH_CONVO = "anim_img_idle2_talk";
	string ANIM_CONVO1 = "anim_img_idle2_talk";
	string ANIM_CONVO2 = "anim_img_idle2_look";
	float ATTN_VOICE = 0.01f;
	int PITCH_VOICE = 50;
	Vector3 STORM_CENTER = Vector3();
	int STORM_RAD = 768;
	float FREQ_BREATH = 120.0f;
	float DUR_STORM = 60.0f;
	float FREQ_BOLTS = 0.0f;
	float FREQ_BALLS = 0.0f;
	int DMG_ICE_SHARD = 0;
	int DOT_COLD = 50;
	int DMG_LIGHTNING_STRIKE = 0;
	int DOT_LIGHTNING = 150;
	float DOT_FIRE = 100.0f;
	int DMG_METEOR = 800;
	int NECK_MAX_ANG = 30;
	int NECK_MIN_ANG = -30;
	string SOUND_BREATH_IN = "magic/spookie1.wav";
	string SOUND_BREATH_OUT = "monsters/goblin/sps_fogfire.wav";
	int DG_BASE_RENDERAMT = 100;

	// Variables (an unset .script variable reads as its own name)
	string ANIM_IDLE = "anim_img_idle2";
	string ATK_POINTS = "ATK_POINTS";
	int DEST_NECK_ANG = 0;
	float CURRENT_NECK_ANG = 0.0f;
	string PLAYING_DEAD = "PLAYING_DEAD";
	string PLAYER_LIST = "PLAYER_LIST";
	int DID_INTRO = 0;
	CBaseEntity@ FLICKER_BRUSH_ID = null;
	float GLOAT_COUNT = 0.0f;
	string RACE_VOICE = "RACE_VOICE";
	string RACE_TEXT = "RACE_TEXT";
	string HEAD_TARGET = "HEAD_TARGET";
	bool HEAD_FOLLOW = false;
	bool HEAD_TRACKING = false;
	float NEXT_PULSE = 0.0f;
	float NEXT_BREATH = 0.0f;
	float NEXT_LIFT_CHECK = 0.0f;
	bool BATTLE_ACTIVE = false;
	float BREATH_CYCLE = 0.0f;
	float LIFT_COUNT = 0.0f;
	CBaseEntity@ ASPECT_ID = null;
	float HALF_ASPECT_HEALTH = 0.0f;
	bool DID_MINIONS = false;
	bool BUSY_TALKING = false;
	float NEXT_BALLS = 0.0f;
	float NEXT_BOLTS = 0.0f;
	float NEXT_LIFT = 0.0f;
	string PILLAR_NAME = "PILLAR_NAME";
	CBaseEntity@ PILLAR_CHECK_ID = null;
	bool AM_LIFTING = false;
	bool AM_BREATHING = false;
	string CL_BREATH_IDX = "CL_BREATH_IDX";
	bool STORM_ON = false;
	CBaseEntity@ STORM_BRUSH_ID = null;
	string CL_STORM_IDX = "CL_STORM_IDX";
	bool LIGHTNING_FLICKERING = false;
	float FLICKER_COUNT = 0.0f;
	bool HAZARD_STRUCK = false;
	bool FLICKER_BRUSH_ON = false;
	float FADE_COUNT = 0.0f;
	bool DG_PULSE_LOOP = false;
	float NEXT_WING_BEAT = 0.0f;
	float DG_PULSE_COUNT = 0.0f;
	int DG_PULSE_DIR = 0;

	// Variables declared by included files, with the value they start with in this script
	DragonGreenImg()
	{
		CHAT_MOVE_MOUTH = false;
		CHAT_AUTO_FACE = false;
		CHAT_FACE_ON_USE = false;
		CHAT_MENU_ENABLE = false;
		CHAT_PLAYANIM_STYLE = "once";
	}

	// unnamed block (first think)
	void DragonGreenImg_FirstThink()
	{
		ANIM_IDLE = "anim_img_idle2";

		ATK_POINTS = ""; // Holds a token of points for lightning or ice to damage at.
		DEST_NECK_ANG = 0;
		CURRENT_NECK_ANG = 0.0f;
	}

	// unnamed block (timer)
	// ========================= HEAD TRACKING SYSTEM BEGIN
	void DragonGreenImg_Timer()
	{
		bool exitSub = false;
		CallEventDelayed(1.0f, "DragonGreenImg_Timer");
		if (!HEAD_FOLLOW)
			return;
		if (!IsAlive(HEAD_TARGET))
		{
			SetProp(ENT_ME, "controller0", 0);
			SetProp(ENT_ME, "controller1", 0);
			exitSub = true;
		}
		if (exitSub)
			return;

		if (!IsAlive(HEAD_TARGET))
		{
			DEST_NECK_ANG = 0;
			if (!HEAD_TRACKING)
			{
				HEAD_TRACKING = true;
				OnHeadTrack();
			}
		}

		if (!IsAlive(HEAD_TARGET))
			return;
		Vector3 myOrg = OriginOf(ENT_ME);
		float targRange = RangeTo(HEAD_TARGET);

		if (targRange > 128.0f)
		{
			Vector3 targOrg = OriginOf(HEAD_TARGET);
			float angToTarg = AnglesTo(myOrg, targOrg) * 0.25f;
			angToTarg = -angToTarg;

			DEST_NECK_ANG = int(angToTarg);
		}
		else
		{
			// too close to swing my neck around
			DEST_NECK_ANG = 0;
		}

		if (DEST_NECK_ANG > NECK_MAX_ANG)
			DEST_NECK_ANG = NECK_MAX_ANG;
		if (DEST_NECK_ANG < NECK_MIN_ANG)
			DEST_NECK_ANG = NECK_MIN_ANG;

		if (!HEAD_TRACKING)
		{
			float destAngP = DEST_NECK_ANG;
			float destAngM = DEST_NECK_ANG;
			destAngP += 2.0f;
			destAngM -= 2.0f;

			float close = 0.0f;
			if (CURRENT_NECK_ANG < destAngP)
				close = 1.0f;
			if (CURRENT_NECK_ANG > destAngM)
				close += 1.0f;
			if (close == 2.0f)
			{
				HEAD_TRACKING = false; // close enough, stop tracking
			}
			else
			{
				// dbg close enough
				HEAD_TRACKING = true;
				OnHeadTrack();
			}
		}

		// dbg head_follow neck ANG_TO_TARG head L_HEAD_ADJ
		if (GameTime() > NEXT_PULSE)
		{
			NEXT_PULSE = GameTime() + Random(30, 60);
			OnDoPulse();
		}
	}

	// game_dodamage
	// Called from various storm hazards //PARAM1=hit:0|1 PARAM2=ent_hit PARAM3=(start) PARAM4=(end) PARAM5=DmgType PARAM6=DmgAmt
	string DragonGreenImg_OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";

		if (!HAZARD_STRUCK)
			return result;
		HAZARD_STRUCK = false;

		if (!hit)
			return result;
		if (int(Float(damageText)) == 0)
			return result;
		if (RelationshipOf(ENT_ME, @target) != "enemy") // if the target is an enemy, and was hit
			return result;

		if (BREATH_CYCLE == 1.0f) // meteors
			ApplyEffect(target, "effects/dot_fire", 5.0f, self, DOT_FIRE);
		else if (BREATH_CYCLE == 2.0f) // lightning
			ApplyEffect(target, "effects/dot_lightning", 10.0f, self, DOT_LIGHTNING);
		return result;
	}

	// fake_precache
	void OnFakePrecache()
	{
		// svplaysounds have to be precached in a hacky way
		ServerPlaySound(1, 0, "voices/dragons/Jaminporlants_hide1.wav");
		ServerPlaySound(1, 0, "voices/dragons/Jaminporlants_hide2.wav");
		ServerPlaySound(1, 0, "voices/dragons/Jaminporlants_hide3.wav");
		ServerPlaySound(1, 0, "voices/dragons/Jaminporlants_intro01.wav");
		ServerPlaySound(1, 0, "voices/dragons/Jaminporlants_intro02.wav");
		ServerPlaySound(1, 0, "voices/dragons/Jaminporlants_intro03.wav");
		ServerPlaySound(1, 0, "voices/dragons/Jaminporlants_intro04.wav");
		ServerPlaySound(1, 0, "voices/dragons/Jaminporlants_laugh1.wav");
		ServerPlaySound(1, 0, "voices/dragons/Jaminporlants_laugh2.wav");
		ServerPlaySound(1, 0, "voices/dragons/Jaminporlants_minions01.wav");
		ServerPlaySound(1, 0, "voices/dragons/Jaminporlants_minions02.wav");
		ServerPlaySound(1, 0, "voices/dragons/Jaminporlants_minions03.wav");
		ServerPlaySound(1, 0, "voices/dragons/Jaminporlants_player_human.wav");
		ServerPlaySound(1, 0, "voices/dragons/Jaminporlants_player_multirace.wav");
		ServerPlaySound(1, 0, "voices/dragons/Jaminporlants_players_human.wav");
		ServerPlaySound(1, 0, "voices/dragons/Jaminporlants_win01.wav");
		ServerPlaySound(1, 0, "voices/dragons/Jaminporlants_win02.wav");
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseChatArray_OnGameSpawn(playerRace, playerGender); // monsters/base_chat_array
		SetName("Jaminporlants");
		SetModel("monsters/dragon_green_img.mdl");
		SetUniqueName("gdragon_img");
		SetRace("demon");
		SetHealth(99999);
		SetInvincible(true);
		PLAYING_DEAD = "1";
		SetNoPush(true);
		SetWidth(1);
		SetHeight(1);
		SetFly(true);
		SetGravity(0);
		SetProp(ENT_ME, "movetype", 0);
		SetSayTextRange(2048);
		CallEventDelayed(0.1f, "scan_for_players");

		SetProp(ENT_ME, "rendermode", 5);
		SetProp(ENT_ME, "renderamt", DG_BASE_RENDERAMT);
	}

	// scan_for_players
	void OnScanForPlayers()
	{
		if (DID_INTRO != 0)
			return;
		PLAYER_LIST = "";
		PLAYER_LIST = GetActivePlayers();
		int count = GetTokenCount(PLAYER_LIST);
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnCheckPlayers();
			if (breakLoop)
			{
				breakLoop = false;
				break;
			}
		}
		if (DID_INTRO != 0)
			return;
		CallEventDelayed(1.0f, "scan_for_players");
	}

	// check_players
	void OnCheckPlayers()
	{
		string curTarg = GetToken(PLAYER_LIST, loopIteration);
		if (DID_INTRO != 0)
			return;
		if (!(RangeTo(curTarg) < 768.0f))
			return;
		DID_INTRO = 1;
		CHAT_CURRENT_SPEAKER = curTarg;
		CallEventDelayed(1.0f, "do_intro");
	}

	// do_intro
	void OnDoIntro()
	{
		// check players for racial types here (need to work up a system for this)
		@FLICKER_BRUSH_ID = FindByName("brush_storm_lightning2");

		GLOAT_COUNT = 0.0f;

		if (PlayerCount() > 1)
		{
			RACE_VOICE = "voices/dragons/Jaminporlants_players_human.wav";
			RACE_TEXT = "Children of Torkalath...?";
		}
		else if (PlayerCount() == 1)
		{
			RACE_VOICE = "voices/dragons/Jaminporlants_player_human.wav";
			RACE_TEXT = "A child of Torkalath...?";
		}

		// callexternal players ext_svplaysound_kiss 5 10 RACE_VOICE 0.8 100 //ATTN_VOICE PITCH_VOICE
		CallExternal("players", "ext_svplaysound_kiss", 2, 10, RACE_VOICE, 0.8f, 100); // ATTN_VOICE PITCH_VOICE
		SetIdleAnim(ANIM_CONVO1);
		OnChatNow(RACE_TEXT, "2.6", ANIM_IDLE_LOOK, "do_intro2", "add_to_que");
	}

	// do_intro2
	void OnDoIntro2()
	{
		HEAD_TARGET = CHAT_CURRENT_SPEAKER;
		HEAD_FOLLOW = true;

		// AUG! Wish we'd added a playsound array for base_chat_array, but no time now
		// callexternal players ext_svplaysound_kiss 5 10 "voices/dragons/Jaminporlants_intro01.wav" ATTN_VOICE PITCH_VOICE
		CallExternal("players", "ext_svplaysound_kiss", 2, 10, "voices/dragons/Jaminporlants_intro01.wav", ATTN_VOICE, PITCH_VOICE);
		OnChatNow("Creatures forged by, single, pitiful gods... Dare to seek out me?", "7.9", ANIM_CONVO1, "none", "add_to_que");
		OnChatNow("...a being who was forged at the dawn of time by thousands of gods!?", "6.91", ANIM_CONVO1, "do_intro3", "add_to_que");
	}

	// do_intro3
	void OnDoIntro3()
	{
		// callexternal players ext_svplaysound_kiss 5 10 "voices/dragons/Jaminporlants_intro02.wav" ATTN_VOICE PITCH_VOICE
		CallExternal("players", "ext_svplaysound_kiss", 2, 10, "voices/dragons/Jaminporlants_intro02.wav", ATTN_VOICE, PITCH_VOICE);
		OnChatNow("...but I'm afraid your efforts, are in vain.", "3.86", ANIM_CONVO2, "do_intro4", "add_to_que");
	}

	// do_intro4
	void OnDoIntro4()
	{
		// callexternal players ext_svplaysound_kiss 5 10 voices/dragons/Jaminporlants_intro03.wav ATTN_VOICE PITCH_VOICE
		CallExternal("players", "ext_svplaysound_kiss", 2, 10, "voices/dragons/Jaminporlants_intro03.wav", ATTN_VOICE, PITCH_VOICE);
		OnChatNow("I have long since moved on from this place...", "4.10", ANIM_CONVO1, "none", "add_to_que");
		OnChatNow("...And have merely left this image here to 'entertain' belated guests.", "6.2", ANIM_CONVO1, "do_intro5", "add_to_que");
	}

	// do_intro5
	void OnDoIntro5()
	{
		// callexternal players ext_svplaysound_kiss 5 10 "voices/dragons/Jaminporlants_intro04.wav" ATTN_VOICE PITCH_VOICE
		CallExternal("players", "ext_svplaysound_kiss", 2, 10, "voices/dragons/Jaminporlants_intro04.wav", ATTN_VOICE, PITCH_VOICE);
		OnChatNow("But fear not... It is not all I have left behind... ", "5.23", ANIM_CONVO1, "none", "add_to_que");
		OnChatNow("Behold...", "2.2", "none", "none", "add_to_que");
		CallEventDelayed(4.5f, "do_intro6");
	}

	// do_intro6
	void OnDoIntro6()
	{
		SetIdleAnim(ANIM_IDLE);
		PlayAnim("critical", ANIM_SUMMON);
		CallEventDelayed(1.0f, "start_battle");
		CallEventDelayed(3.0f, "ext_gloat");
	}

	// head_track
	void OnHeadTrack()
	{
		float headAdj;
		if (!HEAD_FOLLOW)
			return;
		if (!HEAD_TRACKING)
			return;
		if (CURRENT_NECK_ANG < DEST_NECK_ANG)
			CURRENT_NECK_ANG += 1.0f;
		if (CURRENT_NECK_ANG > DEST_NECK_ANG)
			CURRENT_NECK_ANG -= 1.0f;

		float destAngP = DEST_NECK_ANG;
		float destAngM = DEST_NECK_ANG;
		destAngP += 2.0f;
		destAngM -= 2.0f;

		float close = 0.0f;
		if (CURRENT_NECK_ANG < destAngP)
			close = 1.0f;
		if (CURRENT_NECK_ANG > destAngM)
			close += 1.0f;
		if (close == 2.0f)
		{
			HEAD_TRACKING = false; // close enough, stop tracking
		}

		// dbg close enough
		// probably need to adjust before this
		SetProp(ENT_ME, "controller0", CURRENT_NECK_ANG);

		if (!HEAD_TRACKING)
			return;

		// dbg head_track CURRENT_NECK_ANG vs DEST_NECK_ANG
		if (!IsAlive(HEAD_TARGET))
		{
			headAdj = 0.0f;
		}
		else
		{
			Vector3 myOrg = OriginOf(ENT_ME);
			float targRange = RangeTo(HEAD_TARGET);

			float rangeRatio = Divide(targRange, 1000.0f);
			headAdj = Ratio(rangeRatio, -10, 18);
		}

		SetProp(ENT_ME, "controller1", headAdj);
		CallEventDelayed(0.01f, "head_track");
	}

	// suspend_head_tracking
	void OnSuspendHeadTracking()
	{
		SetProp(ENT_ME, "controller0", 0);
		SetProp(ENT_ME, "controller1", 0);
		HEAD_TRACKING = false;
		HEAD_FOLLOW = false;
		DEST_NECK_ANG = 0;
		CURRENT_NECK_ANG = 0.0f;
	}

	// resume_head_tracking
	void OnResumeHeadTracking()
	{
		HEAD_FOLLOW = true;
	}

	// start_battle
	// ========================= HEAD TRACKING SYSTEM END
	void OnStartBattle()
	{
		UseTrigger("spawn_dragon");
		NEXT_BREATH = GameTime() + FREQ_BREATH;
		NEXT_LIFT_CHECK = GameTime() + 20.0f;
		BATTLE_ACTIVE = true;
		BREATH_CYCLE = 0.0f; // 1=fire 2=lightning 3=cold
		LIFT_COUNT = 0.0f;
		OnBattleLoop();
	}

	// battle_loop
	// ========================= MAIN THINK CYCLE
	void OnBattleLoop()
	{
		bool exitSub = false;
		if (!BATTLE_ACTIVE)
			return;

		CallEventDelayed(1.0f, "battle_loop");

		if (!IsAlive(ASPECT_ID))
		{
			@ASPECT_ID = FindByName("gdragon_aspect");
			if (IsAlive(ASPECT_ID))
				HALF_ASPECT_HEALTH = MaxHealthOf(ASPECT_ID) * 0.5f;
		}
		else
		{
			HEAD_TARGET = ScriptVarOf(ASPECT_ID, "NPCATK_TARGET");
			if (!IsAlive(HEAD_TARGET))
				HEAD_TARGET = EntityId(ASPECT_ID);
		}

		if (HealthOf(ASPECT_ID) < HALF_ASPECT_HEALTH && !DID_MINIONS)
		{
			DID_MINIONS = true;
			BUSY_TALKING = true; // remember to reset after summoning minions
			OnDoMinions();
		}

		if (STORM_ON)
		{
			if (BREATH_CYCLE == 1.0f && GameTime() > NEXT_BALLS)
			{
				NEXT_BALLS = GameTime() + FREQ_BALLS;

				OnDropMeteor();
				if (RandomInt(1, 2) == 1)
				{
					CallEventDelayed(Random(0.5f, 2), "drop_meteor"); // somtimes two
					if (RandomInt(1, 4) < 4)
					{
						CallEventDelayed(Random(2.1f, 4), "drop_meteor"); // somtimes three
					}
				}
			}

			if (BREATH_CYCLE == 2.0f && GameTime() > NEXT_BOLTS)
			{
				NEXT_BOLTS = GameTime() + FREQ_BOLTS;

				OnDoLightningBolt();
				if (RandomInt(1, 2) == 1)
				{
					CallEventDelayed(Random(0.5f, 2), "do_lightning_bolt"); // somtimes two
				}
			}

			if (BREATH_CYCLE == 3.0f)
			{
				if (GameTime() > NEXT_BALLS) // using meteor ball timer because meh
				{
					NEXT_BALLS = GameTime() + FREQ_BALLS;

					OnDoIceBolt();
					if (RandomInt(1, 2) == 1)
					{
						CallEventDelayed(Random(0.5f, 2), "do_ice_bolt"); // somtimes two
					}
				}
			}
		}

		if (GameTime() > NEXT_BREATH && !AM_BREATHING)
		{
			if (BUSY_TALKING)
			{
				// wait until minion comment is over
				exitSub = true;
				NEXT_BREATH = GameTime() + 20.0f;
			}

			if (AM_LIFTING)
			{
				// wait until life sequence is over
				exitSub = true;
				NEXT_BREATH = GameTime() + 10.0f;
			}
			if (!exitSub)
			{
				OnDoBreath();
				exitSub = true;
			}
		}
		if (exitSub)
			return;

		if (GameTime() > NEXT_LIFT_CHECK && !AM_LIFTING)
		{
			// check pillars every 20 seconds
			NEXT_LIFT_CHECK = GameTime() + 20.0f;

			if (BUSY_TALKING)
			{
				// wait until minion comment is over
				exitSub = true;
				NEXT_LIFT = GameTime() + 20.0f;
			}
			if (!exitSub)
			{
				if (AM_BREATHING)
				{
					// wait until breath sequence is over
					exitSub = true;
					NEXT_LIFT = GameTime() + 20.0f;
				}
				if (!exitSub)
				{
					CBaseEntity@ pillarId = FindByName("lift_pillar_left");
					CallExternal(pillarId, "ext_check_targets");
					if (ScriptVarOf(pillarId, "TARGET_CHECK") != "none")
					{
						OnDoLift("left", pillarId);
						exitSub = true;
					}
					if (!exitSub)
					{
						@pillarId = FindByName("lift_pillar_right");
						CallExternal(pillarId, "ext_check_targets");
						if (ScriptVarOf(pillarId, "TARGET_CHECK") != "none")
						{
							OnDoLift("right", pillarId);
							exitSub = true;
						}
						if (!exitSub) {}
					}
				}
			}
		}
	}

	// ext_breath_now
	// debuggary
	void OnExtBreathNow()
	{
		NEXT_BREATH = 0.0f;
	}

	// ext_lift_now
	// debuggary
	void OnExtLiftNow()
	{
		NEXT_LIFT_CHECK = 0.0f;
	}

	// do_lift
	// ========================= LIFT PILLARS
	// <left/right> <pillar_check_id>
	void OnDoLift(string side = "", CBaseEntity@ pillarCheckId = null)
	{
		// set this again when lift done
		NEXT_LIFT_CHECK = GameTime() + 60.0f;

		PILLAR_NAME = side;
		@PILLAR_CHECK_ID = pillarCheckId;

		string animName = "anim_img_lift_" + PILLAR_NAME;
		PlayAnim("critical", animName);

		OnSuspendHeadTracking();

		DebugPrint("do_lift anim " + animName);

		LIFT_COUNT += 1.0f;
		AM_LIFTING = true;

		if (LIFT_COUNT == 1.0f)
		{
			OnChatNow("Hiding already?", "3.0", "none", "none", "add_to_que");
			// callexternal players ext_svplaysound_kiss 5 10 voices/dragons/Jaminporlants_hide1.wav ATTN_VOICE PITCH_VOICE
			CallExternal("players", "ext_svplaysound_kiss", 2, 10, "voices/dragons/Jaminporlants_hide1.wav", ATTN_VOICE, PITCH_VOICE);
		}
		else if (LIFT_COUNT == 2.0f)
		{
			OnChatNow("What are you doing over there? ...Trying to hide?", "3.0", "none", "none", "add_to_que");
			// callexternal players ext_svplaysound_kiss 5 10 voices/dragons/Jaminporlants_hide2.wav ATTN_VOICE PITCH_VOICE
			CallExternal("players", "ext_svplaysound_kiss", 2, 10, "voices/dragons/Jaminporlants_hide2.wav", ATTN_VOICE, PITCH_VOICE);
		}
		else if (LIFT_COUNT == 3.0f)
		{
			OnChatNow("Hiding again, I see...", "3.0", "none", "none", "add_to_que");
			// callexternal players ext_svplaysound_kiss 5 10 voices/dragons/Jaminporlants_hide3.wav ATTN_VOICE PITCH_VOICE
			CallExternal("players", "ext_svplaysound_kiss", 2, 10, "voices/dragons/Jaminporlants_hide3.wav", ATTN_VOICE, PITCH_VOICE);
			LIFT_COUNT = 0.0f;
		}
	}

	// frame_lift
	void OnFrameLift()
	{
		string triggerName = "door_lift_" + PILLAR_NAME;
		UseTrigger(triggerName);
		CallExternal(PILLAR_CHECK_ID, "ext_do_shake");
	}

	// frame_release
	void OnFrameRelease()
	{
		CallEventDelayed(2.0f, "resume_head_tracking");
		AM_LIFTING = false;
		string triggerName = "door_lift_" + PILLAR_NAME;
		UseTrigger(triggerName);
		CallExternal(PILLAR_CHECK_ID, "ext_do_boom");
		NEXT_LIFT_CHECK = GameTime() + 30.0f;
	}

	// do_breath
	// ========================= BREATH STORM
	void OnDoBreath()
	{
		OnSuspendHeadTracking();
		AM_BREATHING = true;
		BREATH_CYCLE += 1.0f;
		if (BREATH_CYCLE > 3.0f)
			BREATH_CYCLE = 1.0f;
		PlayAnim("critical", ANIM_BREATH_STORM);
	}

	// frame_storm_prep
	void OnFrameStormPrep()
	{
		PlaySound(0, 10, SOUND_BREATH_IN, 0.1f, 80);
	}

	// frame_storm_breath_start
	// Called from anim
	void OnFrameStormBreathStart()
	{
		PlaySound(0, 10, SOUND_BREATH_OUT, 0.1f, 70);
		ClientEvent("new", "all", "nashalrath/dragon_green_img_cl", IndexOf(ENT_ME), BREATH_CYCLE);
		CL_BREATH_IDX = LastClientScriptId();
		CallEventDelayed(2.0f, "setup_storm");
	}

	// frame_storm_breath_stop
	void OnFrameStormBreathStop()
	{
		ClientEvent("update", "all", CL_BREATH_IDX, "ext_breath_stop");
	}

	// frame_storm_breath_done
	void OnFrameStormBreathDone()
	{
		AM_BREATHING = false;
		NEXT_BREATH = GameTime() + FREQ_BREATH;
		OnResumeHeadTracking();
	}

	// setup_storm
	void OnSetupStorm()
	{
		STORM_ON = true;
		if (BREATH_CYCLE == 1.0f)
		{
			UseTrigger("light_storm_fire");
			CallExternal(GetVar("GAME_MASTER"), "gm_set_weather", "fog_dragon_red", 1);
			@STORM_BRUSH_ID = FindByName("brush_storm_fire");
			NEXT_BALLS = GameTime() + FREQ_BALLS;
		}
		if (BREATH_CYCLE == 2.0f)
		{
			// usetrigger light_storm_lightning //this flickers during strikes
			CallExternal(GetVar("GAME_MASTER"), "gm_set_weather", "fog_dragon_black", 1);
			@STORM_BRUSH_ID = FindByName("brush_storm_lightning1");
			NEXT_BOLTS = GameTime() + FREQ_BOLTS;
		}
		if (BREATH_CYCLE == 3.0f)
		{
			UseTrigger("light_storm_cold");
			CallExternal(GetVar("GAME_MASTER"), "gm_set_weather", "fog_dragon_white", 1);
			@STORM_BRUSH_ID = FindByName("brush_storm_cold");

			ClientEvent("new", "all", "nashalrath/dragon_ice_storm_cl", STORM_CENTER);
			CL_STORM_IDX = LastClientScriptId();
		}
		CallExternal(STORM_BRUSH_ID, "storm_fade_in");
		CallEventDelayed(DUR_STORM, "end_storm");
	}

	// end_storm
	// remember to call on aspect death
	void OnEndStorm()
	{
		if (!STORM_ON)
			return;
		STORM_ON = false;
		SetGlobal("G_WEATHER_LOCK", 0);
		SetGlobal("G_CURRENT_WEATHER", "clear");
		CallExternal(GetVar("GAME_MASTER"), "gm_start_weather", "clear");
		CallExternal(STORM_BRUSH_ID, "storm_fade_out");
		if (BREATH_CYCLE == 1.0f)
			UseTrigger("light_storm_fire");
		if (BREATH_CYCLE == 3.0f)
		{
			UseTrigger("light_storm_cold");
			ClientEvent("update", "all", CL_STORM_IDX, "end_fx");
		}
	}

	// do_lightning_bolt
	// { isl_dodamage
	// if PARAM1
	// if $get(ent_me,relationship,PARAM2) equals enemy
	// applyeffect PARAM2 effects/dot_cold 5.0 $get(ent_me,id) DOT_COLD
	// }
	void OnDoLightningBolt()
	{
		if (!LIGHTNING_FLICKERING)
		{
			LIGHTNING_FLICKERING = true;
			FLICKER_COUNT = 0.0f;
			OnLightningFlicker();
			CallEventDelayed(5.0f, "lightning_flicker_end");
		}

		Vector3 pos = STORM_CENTER;
		float rndAng = Random(0, 359.99f);
		float rndDist = Random(0, STORM_RAD);
		pos += RelativePosition(Vector3(0, rndAng, 0), Vector3(0, rndDist, 0));

		string ground = Text(pos);
		ground = Text(WithZ(Vec(ground), GroundHeight(pos)));

		int strikeTime = 0; // Strike time 0 means less fx, and no damage
		if (Vec(ground).z > -3000.0f) // If strike is landing on the island, not below
		{
			strikeTime = 3; // Then turn strike time up
			ATK_POINTS = TokenAdd(ATK_POINTS, ground);
			CallEventDelayed(strikeTime, "lightning_strike");
		}

		ClientEvent("new", "all", "nashalrath/lightning_strike_cl", pos, strikeTime);
	}

	// lightning_strike
	void OnLightningStrike()
	{
		string pos = GetToken(ATK_POINTS, 0);
		ATK_POINTS = TokenRemove(ATK_POINTS, 0);

		HAZARD_STRUCK = true;
		DoDamageEx(pos, 128, DMG_LIGHTNING_STRIKE, 0.1f, ENT_ME, ENT_ME, "none", "lightning_effect");
	}

	// lightning_flicker
	void OnLightningFlicker()
	{
		FLICKER_COUNT += 1.0f;
		if (!(FLICKER_COUNT < 7.0f))
			return;
		DebugPrint("lightning_flicker");
		CallEventDelayed(Random(0.1f, 0.2f), "lightning_flicker");
		if (!FLICKER_BRUSH_ON)
		{
			FLICKER_BRUSH_ON = true;
			UseTrigger("light_storm_lightning");
			CallExternal(FLICKER_BRUSH_ID, "storm_show");
		}
		else
		{
			FLICKER_BRUSH_ON = false;
			UseTrigger("light_storm_lightning");
			CallExternal(FLICKER_BRUSH_ID, "storm_hide");
		}
	}

	// lightning_flicker_end
	void OnLightningFlickerEnd()
	{
		if (FLICKER_BRUSH_ON)
		{
			FLICKER_BRUSH_ON = false;
			UseTrigger("light_storm_lightning");
			CallExternal(FLICKER_BRUSH_ID, "storm_hide");
		}
		LIGHTNING_FLICKERING = false;
	}

	// do_ice_bolt
	// called by main think cycle when fire storm active
	void OnDoIceBolt()
	{
		Vector3 pos = STORM_CENTER;
		float rndAng = Random(0, 359.99f);
		float rndDist = Random(0, STORM_RAD);
		pos += RelativePosition(Vector3(0, rndAng, 0), Vector3(0, rndDist, 0));

		string dest = Text(pos);
		dest = Text(Vec(dest) + Vector3(0.0f, 0.0f, -50.0f));

		// <projectile scriptname> <"view"|(src_origin)> <target|(targ_origin)|none> <speed> <damage> <cof> <skill|none>
		TossProjectile("proj_ice_bolt", pos, dest, 450, DMG_ICE_SHARD, 0, "none");

		CallExternal(EntityOf(ENT_LASTPROJECTILE), "ext_scale", 4);
	}

	// drop_meteor
	// called by main think cycle when fire storm active
	void OnDropMeteor()
	{
		Vector3 pos = STORM_CENTER;
		float rndAng = Random(0, 359.99f);
		float rndDist = Random(0, STORM_RAD);
		pos += RelativePosition(Vector3(0, rndAng, 0), Vector3(0, rndDist, 0));
		Vector3 dest = RelativePosition(pos, Vector3(-10, -10, -100));

		// createnpc monsters/summon/meteor_deployer L_POS $get(ent_me,id) $get(ent_me,id)
		// <projectile scriptname> <"view"|(src_origin)> <target|(targ_origin)|none> <speed> <damage> <cof> <skill|none>
		TossProjectile("proj_staff_fire_bomb", pos, dest, 120, DMG_METEOR, 0, "none");
	}

	// ext_fire_bomb
	void OnExtFireBomb(Vector3 landPosition = Vector3())
	{
		HAZARD_STRUCK = true;
	}

	string OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "") { return DragonGreenImg_OnGameDodamage(hit, target, start, end, damageType, damageText); } // game_dodamage

	// do_minions
	// ========================= SUMMON MINIONS (once)
	void OnDoMinions()
	{
		// callexternal players ext_svplaysound_kiss 5 10 "voices/dragons/Jaminporlants_minions01.wav" ATTN_VOICE PITCH_VOICE
		CallExternal("players", "ext_svplaysound_kiss", 2, 10, "voices/dragons/Jaminporlants_minions01.wav", ATTN_VOICE, PITCH_VOICE);
		OnChatNow("Did you enjoy my minions?", "3.3", ANIM_CONVO1, "do_minions2", "add_to_que");
	}

	// do_minions2
	void OnDoMinions2()
	{
		UseTrigger("spawn_minions");
		CallExternal("players", "ext_play_music_me", "dream_battle.mp3");
		// callexternal players ext_svplaysound_kiss 5 10 "voices/dragons/Jaminporlants_minions02.wav" ATTN_VOICE PITCH_VOICE
		CallExternal("players", "ext_svplaysound_kiss", 2, 10, "voices/dragons/Jaminporlants_minions02.wav", ATTN_VOICE, PITCH_VOICE);
		OnChatNow("Their creation was inspired by Kharaztorant's pitiful attempts at immortality...", "7.5", ANIM_CONVO1, "do_minions3", "add_to_que");
	}

	// do_minions3
	void OnDoMinions3()
	{
		// callexternal players ext_svplaysound_kiss 5 10 "voices/dragons/Jaminporlants_minions03.wav" ATTN_VOICE PITCH_VOICE
		CallExternal("players", "ext_svplaysound_kiss", 2, 10, "voices/dragons/Jaminporlants_minions03.wav", ATTN_VOICE, PITCH_VOICE);
		OnChatNow("But they are well suited for menial tasks...", "4.1", ANIM_CONVO1, "none", "add_to_que");
		OnChatNow("...such as crushing insects!", "3.5", ANIM_CONVO1, "do_minions4", "add_to_que");
	}

	// do_minions4
	void OnDoMinions4()
	{
		BUSY_TALKING = false;
	}

	// ext_gloat
	// ========================= SUMMON MINIONS END
	void OnExtGloat()
	{
		// dbg ext_gloat AM_BREATHING BUSY_TALKING AM_LIFTING
		if (AM_BREATHING)
			return;
		if (BUSY_TALKING)
			return;
		if (AM_LIFTING)
			return;

		GLOAT_COUNT += 1.0f;

		if (GLOAT_COUNT == 1.0f)
		{
			// callexternal players ext_svplaysound_kiss 5 10 "voices/dragons/Jaminporlants_laugh1.wav" ATTN_VOICE PITCH_VOICE
			CallExternal("players", "ext_svplaysound_kiss", 2, 10, "voices/dragons/Jaminporlants_laugh1.wav", ATTN_VOICE, PITCH_VOICE);
		}
		else
		{
			// callexternal players ext_svplaysound_kiss 5 10 "voices/dragons/Jaminporlants_laugh2.wav" ATTN_VOICE PITCH_VOICE
			CallExternal("players", "ext_svplaysound_kiss", 2, 10, "voices/dragons/Jaminporlants_laugh2.wav", ATTN_VOICE, PITCH_VOICE);
			GLOAT_COUNT = 0.0f;
		}
	}

	// ext_image_died
	void OnExtImageDied()
	{
		BATTLE_ACTIVE = false;
		if (STORM_ON)
			OnEndStorm();
		CallEventDelayed(2.0f, "win_sequence1");
	}

	// win_sequence1
	void OnWinSequence1()
	{
		CallExternal("players", "ext_play_music_me", "Nashalrath.mp3");
		// callexternal players ext_svplaysound_kiss 5 10 "voices/dragons/Jaminporlants_win01.wav" ATTN_VOICE PITCH_VOICE
		CallExternal("players", "ext_svplaysound_kiss", 2, 10, "voices/dragons/Jaminporlants_win01.wav", ATTN_VOICE, PITCH_VOICE);
		OnChatNow("Impressive... Most impressive...", "3.81", ANIM_LAUGH, "none", "add_to_que");
		OnChatNow("When you die, for the final time, should you be fortunate enough to see your god Torkalath...", "9.52", ANIM_CONVO1, "none", "add_to_que");
		OnChatNow("Remind him... That I still believe in rewarding strength!", "7.02", ANIM_SUMMON, "win_sequence2", "add_to_que");
	}

	// win_sequence2
	void OnWinSequence2()
	{
		UseTrigger("spawn_dragon_chest");
	}

	// ext_exit_sequence
	// called by treasure chest when opened
	void OnExtExitSequence()
	{
		// callexternal players ext_svplaysound_kiss 5 10 "voices/dragons/Jaminporlants_win02.wav" ATTN_VOICE PITCH_VOICE
		CallExternal("players", "ext_svplaysound_kiss", 2, 10, "voices/dragons/Jaminporlants_win02.wav", ATTN_VOICE, PITCH_VOICE);
		OnChatNow("Should your efforts continue to be so fruitful...", "7.0", ANIM_CONVO1, "none", "add_to_que");
		OnChatNow("We may one day, meet in person!", "2.58", "none", "do_exit", "add_to_que");
	}

	// do_exit
	void OnDoExit()
	{
		PlayAnim("hold", ANIM_LEAVE);
		FADE_COUNT = 255.0f;
		DG_PULSE_LOOP = false;
		OnDragFadeOut();
	}

	// drag_fade_out
	void OnDragFadeOut()
	{
		// play game.time based huge wing beat sound here too
		if (GameTime() > NEXT_WING_BEAT)
		{
			NEXT_WING_BEAT = GameTime() + 0.75f;
			PlaySound(0, 10, "weapons/swinghuge.wav", 0.8f, RandomInt(75, 100));
		}

		FADE_COUNT -= 5.0f;
		if (FADE_COUNT < 0.0f)
		{
			FADE_COUNT = 0.0f;
			DeleteMe();
		}
		SetProp(ENT_ME, "renderamt", FADE_COUNT);
		if (!(FADE_COUNT > 0.0f))
			return;
		CallEventDelayed(0.1f, "drag_fade_out");
	}

	// do_pulse
	void OnDoPulse()
	{
		if (DG_PULSE_LOOP)
			return;
		DG_PULSE_COUNT = DG_BASE_RENDERAMT;
		DG_PULSE_LOOP = true;
		DG_PULSE_DIR = 1;
		OnDoDgpulseLoop();
	}

	// do_dgpulse_loop
	void OnDoDgpulseLoop()
	{
		if (!DG_PULSE_LOOP)
			return;
		CallEventDelayed(0.1f, "do_dgpulse_loop");

		DebugPrint("do_dgpulse_loop " + Text(DG_PULSE_COUNT));
		if (DG_PULSE_DIR == 1)
		{
			if (DG_PULSE_COUNT < 255.0f)
			{
				DG_PULSE_COUNT += 1.0f;
				SetProp(ENT_ME, "renderamt", DG_PULSE_COUNT);
			}
			else
			{
				DG_PULSE_DIR = -1;
			}
		}
		else if (DG_PULSE_COUNT > DG_BASE_RENDERAMT)
		{
			DG_PULSE_COUNT -= 1.0f;
			SetProp(ENT_ME, "renderamt", DG_PULSE_COUNT);
		}
		else
		{
			SetProp(ENT_ME, "renderamt", DG_BASE_RENDERAMT);
			DG_PULSE_LOOP = false;
		}
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files
	void OnDurStorm() {} // DUR_STORM
	void OnLStrikeTime() {} // L_STRIKE_TIME

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("voices/dragons/Jaminporlants_hide1.wav");
		Precache("voices/dragons/Jaminporlants_hide2.wav");
		Precache("voices/dragons/Jaminporlants_hide3.wav");
		Precache("voices/dragons/Jaminporlants_intro01.wav");
		Precache("voices/dragons/Jaminporlants_intro02.wav");
		Precache("voices/dragons/Jaminporlants_intro03.wav");
		Precache("voices/dragons/Jaminporlants_intro04.wav");
		Precache("voices/dragons/Jaminporlants_laugh1.wav");
		Precache("voices/dragons/Jaminporlants_laugh2.wav");
		Precache("voices/dragons/Jaminporlants_minions01.wav");
		Precache("voices/dragons/Jaminporlants_minions02.wav");
		Precache("voices/dragons/Jaminporlants_minions03.wav");
		Precache("voices/dragons/Jaminporlants_player_human.wav");
		Precache("voices/dragons/Jaminporlants_player_multirace.wav");
		Precache("voices/dragons/Jaminporlants_players_human.wav");
		Precache("voices/dragons/Jaminporlants_win01.wav");
		Precache("voices/dragons/Jaminporlants_win02.wav");
		Precache("monsters/dragon_green_img.mdl");
		CallEventDelayed(1.0f, "DragonGreenImg_Timer");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		DragonGreenImg_FirstThink();
		BaseChatArray_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "battle_loop") { OnBattleLoop(); return true; }
		if (name == "check_players") { OnCheckPlayers(); return true; }
		if (name == "do_breath") { OnDoBreath(); return true; }
		if (name == "do_dgpulse_loop") { OnDoDgpulseLoop(); return true; }
		if (name == "do_exit") { OnDoExit(); return true; }
		if (name == "do_ice_bolt") { OnDoIceBolt(); return true; }
		if (name == "do_intro") { OnDoIntro(); return true; }
		if (name == "do_intro2") { OnDoIntro2(); return true; }
		if (name == "do_intro3") { OnDoIntro3(); return true; }
		if (name == "do_intro4") { OnDoIntro4(); return true; }
		if (name == "do_intro5") { OnDoIntro5(); return true; }
		if (name == "do_intro6") { OnDoIntro6(); return true; }
		if (name == "do_lift") { OnDoLift(Param(params, 0), EntityParam(params, 1)); return true; }
		if (name == "do_lightning_bolt") { OnDoLightningBolt(); return true; }
		if (name == "do_minions") { OnDoMinions(); return true; }
		if (name == "do_minions2") { OnDoMinions2(); return true; }
		if (name == "do_minions3") { OnDoMinions3(); return true; }
		if (name == "do_minions4") { OnDoMinions4(); return true; }
		if (name == "do_pulse") { OnDoPulse(); return true; }
		if (name == "drag_fade_out") { OnDragFadeOut(); return true; }
		if (name == "drop_meteor") { OnDropMeteor(); return true; }
		if (name == "end_storm") { OnEndStorm(); return true; }
		if (name == "ext_breath_now") { OnExtBreathNow(); return true; }
		if (name == "ext_exit_sequence") { OnExtExitSequence(); return true; }
		if (name == "ext_fire_bomb") { OnExtFireBomb(Vec(Param(params, 0))); return true; }
		if (name == "ext_gloat") { OnExtGloat(); return true; }
		if (name == "ext_image_died") { OnExtImageDied(); return true; }
		if (name == "ext_lift_now") { OnExtLiftNow(); return true; }
		if (name == "fake_precache") { OnFakePrecache(); return true; }
		if (name == "frame_lift") { OnFrameLift(); return true; }
		if (name == "frame_release") { OnFrameRelease(); return true; }
		if (name == "frame_storm_breath_done") { OnFrameStormBreathDone(); return true; }
		if (name == "frame_storm_breath_start") { OnFrameStormBreathStart(); return true; }
		if (name == "frame_storm_breath_stop") { OnFrameStormBreathStop(); return true; }
		if (name == "frame_storm_prep") { OnFrameStormPrep(); return true; }
		if (name == "game_dodamage") { Return(OnGameDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5))); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "head_track") { OnHeadTrack(); return true; }
		if (name == "lightning_flicker") { OnLightningFlicker(); return true; }
		if (name == "lightning_flicker_end") { OnLightningFlickerEnd(); return true; }
		if (name == "lightning_strike") { OnLightningStrike(); return true; }
		if (name == "resume_head_tracking") { OnResumeHeadTracking(); return true; }
		if (name == "scan_for_players") { OnScanForPlayers(); return true; }
		if (name == "setup_storm") { OnSetupStorm(); return true; }
		if (name == "start_battle") { OnStartBattle(); return true; }
		if (name == "suspend_head_tracking") { OnSuspendHeadTracking(); return true; }
		if (name == "win_sequence1") { OnWinSequence1(); return true; }
		if (name == "win_sequence2") { OnWinSequence2(); return true; }
		if (name == "DragonGreenImg_Timer") { DragonGreenImg_Timer(); return true; }
		return Debug_DispatchEvent(name, params)
			|| BaseChatArrayScript::DispatchEvent(name, params);
	}
}
