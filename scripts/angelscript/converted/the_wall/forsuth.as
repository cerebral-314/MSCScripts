#pragma context server

// Converted from the_wall/forsuth.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_monster_new.as"
#include "converted/monsters/base_chat.as"
#include "converted/monsters/base_battle_ally.as"
#include "converted/NPCs/dwarf_lantern_base.as"

[script "the_wall/forsuth"]
class TheWallForsuth : BaseMonsterNewScript, BaseChat, BaseBattleAlly, DwarfLanternBase
{
	// Constants
	float STAIR_TOP_Z = -1519.97f;
	bool NPC_BATTLE_ALLY = true;
	bool NO_RUMOR = true;
	bool NO_HAIL = true;
	bool NO_JOB = true;
	int DMG_SWING = 200;
	string ATTACK_HITCHANCE = "90";
	string SOUND_STRUCK1 = "weapons/cbar_hitbod1.wav";
	string SOUND_STRUCK2 = "weapons/cbar_hitbod2.wav";
	string SOUND_STRUCK3 = "weapons/cbar_hitbod3.wav";
	string SOUND_SWING = "weapons/swingsmall.wav";
	string SOUND_BATTLE_CRY1 = "none";
	string SOUND_BATTLE_CRY2 = "none";
	string SOUND_BATTLE_CRY3 = "none";
	string SOUND_BATTLE_CRY4 = "none";
	string SOUND_BATTLE_CRY5 = "none";
	string SOUND_VICTORY1 = "none";
	string SOUND_VICTORY2 = "none";
	string SOUND_PAIN1 = "none";
	string SOUND_PAIN2 = "none";
	string SOUND_PAIN3 = "none";
	string SOUND_COME_HERE = "none";
	string SOUND_HEALER1 = "none";
	string SOUND_HEALER2 = "none";
	string SOUND_HI = "none";
	string SOUND_HI_ALT = "none";
	string SOUND_BYE = "none";
	string SOUND_YES = "none";
	string SOUND_NO = "none";
	string SOUND_LAUGH = "none";
	string SOUND_ATTACK1 = "none";
	string SOUND_ATTACK2 = "none";
	string SOUND_ATTACK3 = "none";
	float FREQ_ALERT = 120.0f;
	float FREQ_VICTORY = 120.0f;
	float FREQ_HEALER = 30.0f;
	float FREQ_CRITICAL = 60.0f;
	int MY_HP = 5000;
	float HALF_HP = 2500.0f;
	float CHAT_DELAY = 4.0f;
	string SOUND_ALLY_JUMP = "none";

	// Variables (an unset .script variable reads as its own name)
	string ANIM_ATTACK = "ANIM_ATTACK";
	string REWARD_LIST = "REWARD_LIST";
	int FOLLOW_RANGE_MIN = 0;
	int FOLLOW_RANGE_MAX = 0;
	string GAVE_POT_LIST = "GAVE_POT_LIST";
	float NEXT_VICTORY = 0.0f;
	bool FORSUTH_CRITICAL = false;
	float NEXT_HEALER = 0.0f;
	bool DID_FF_WARN = false;
	float NEXT_REGEN = 0.0f;
	float NEXT_CRITICAL = 0.0f;
	float CYCLCE_TIME = 0.0f;
	string PLAYER_FOLLOW = "PLAYER_FOLLOW";
	string ALLY_FOLLOW_PLR_ID = "ALLY_FOLLOW_PLR_ID";
	CBaseEntity@ PLAYER_CHAT = null;
	int DID_INTRO = 0;
	bool TELEPORT_CHEAT = false;
	bool ALLY_FOLLOW_ON = false;
	string CHAT_STEP1 = "CHAT_STEP1";
	string CHAT_SOUND1 = "CHAT_SOUND1";
	string CHAT_DELAY_STEP1 = "CHAT_DELAY_STEP1";
	string CHAT_STEP2 = "CHAT_STEP2";
	string CHAT_SOUND2 = "CHAT_SOUND2";
	string CHAT_DELAY_STEP2 = "CHAT_DELAY_STEP2";
	string CHAT_STEP3 = "CHAT_STEP3";
	string CHAT_SOUND3 = "CHAT_SOUND3";
	string CHAT_DELAY_STEP3 = "CHAT_DELAY_STEP3";
	int CHAT_STEPS = 0;
	string CHAT_EVENT_STEP2 = "CHAT_EVENT_STEP2";
	string MAX_CHAT_TIME = "MAX_CHAT_TIME";
	bool GAVE_FIRST_POT = false;
	bool PLAT_SUSPEND_MODE = false;
	bool GAVE_REWARD = false;
	string ANIM_STEP1 = "ANIM_STEP1";
	string CHAT_STEP4 = "CHAT_STEP4";
	string CHAT_SOUND4 = "CHAT_SOUND4";
	string CHAT_DELAY_STEP4 = "CHAT_DELAY_STEP4";
	string CHAT_STEP5 = "CHAT_STEP5";
	string CHAT_SOUND5 = "CHAT_SOUND5";
	string CHAT_DELAY_STEP5 = "CHAT_DELAY_STEP5";
	string CHAT_STEP6 = "CHAT_STEP6";
	string CHAT_SOUND6 = "CHAT_SOUND6";
	string CHAT_DELAY_STEP6 = "CHAT_DELAY_STEP6";
	string CHAT_STEP7 = "CHAT_STEP7";
	string CHAT_SOUND7 = "CHAT_SOUND7";
	string CHAT_DELAY_STEP7 = "CHAT_DELAY_STEP7";
	string CHAT_STEP8 = "CHAT_STEP8";
	string CHAT_DELAY_STEP8 = "CHAT_DELAY_STEP8";
	string CHAT_STEP9 = "CHAT_STEP9";
	string CHAT_SOUND9 = "CHAT_SOUND9";
	string CHAT_DELAY_STEP9 = "CHAT_DELAY_STEP9";
	string ANIM_STEP9 = "ANIM_STEP9";
	float NEXT_ALERT = 0.0f;
	bool DID_MOUNTAIN_COMMENT = false;
	float ALLY_NEXT_FAS_CHECK = 0.0f;
	bool DID_UNDEAD_COMMENT = false;
	bool DID_STAIRS_COMMENT = false;
	CBaseEntity@ PLAT_ENT = null;
	float PLAT_OFS = 0.0f;
	bool REACHED_TOP = false;
	bool DID_END_EVENT = false;
	string QUEST_WINNER = "QUEST_WINNER";
	bool FACE_PLAYERS = false;
	float CHAT_OVERRIDE_TIME = 0.0f;
	bool BUSY_CHATTING = false;
	float CHAT_STEP = 0.0f;
	Vector3 COMPANION_LR = Vector3();
	float NEXT_TELEPORT = 0.0f;
	bool DID_WRAITH_COMMENT = false;

	// Variables declared by included files, with the value they start with in this script
	TheWallForsuth()
	{
		ANIM_IDLE = "idle";
		ANIM_RUN = "run";
		ANIM_WALK = "walk";
		NPC_FIGHTS_NPCS = true; // from monsters/base_battle_ally
	}

	// unnamed block (first think)
	void TheWallForsuth_FirstThink()
	{
		ANIM_IDLE = "idle";
		ANIM_DEATH = "death";
		ANIM_ATTACK = "attack";

		ANIM_RUN = "run";
		ANIM_WALK = "walk";
	}

	// unnamed block (first think)
	void TheWallForsuth_FirstThink2()
	{
		// base monster
		ATTACK_RANGE = 50.0f;
		ATTACK_MOVERANGE = 32.0f;
		ATTACK_HITRANGE = 100.0f;
		NPC_GIVE_EXP = 0.0f;
		NPC_NO_PLAYER_DMG = true;
		REWARD_LIST = "bows_telf1;bows_telf2;bows_telf3;bows_telf4;axes_b;smallarms_rd;blunt_gauntlets_bear;polearms_h";

		FOLLOW_RANGE_MIN = 64;
		FOLLOW_RANGE_MAX = 256;
	}

	// game_damaged
	// PARAM1=attacker PARAM2=dmg PARAM3=dmg_type
	string TheWallForsuth_OnGameDamaged(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float accuracyRoll = 0.0f, CBaseEntity@ inflictor = null, string skill = "")
	{
		bool requestedHealer = false;
		string result = "";

		if (!DID_WRAITH_COMMENT && Contains(NameOf(attacker), "Wrait"))
			OnDoWraithComment();

		if (HealthOf(ENT_ME) < HALF_HP && !IsPlayer(attacker) && GameTime() > NEXT_HEALER)
		{
			NEXT_HEALER = GameTime() + FREQ_HEALER;
			requestedHealer = true;
			PlayRandomSound(0, 10, SOUND_HEALER1, SOUND_HEALER2);
		}

		if (IsPlayer(attacker))
		{
			if (!DID_FF_WARN)
			{
				DID_FF_WARN = true;
				// playsound 0 10 SOUND_LAUGH
				SayText("Woah there! Friendly dwarf comin' through!");
				PlaySound(0, 10, "voices/the_wall/forsuth/woah_there_friendly.wav");
			}
		}
		else
		{
			float maxHp = MaxHealthOf(ENT_ME);
			int rndPain = RandomInt(1, int(maxHp));
			if (rndPain > maxHp)
			{
				if (!requestedHealer)
					PlayRandomSound(0, 10, SOUND_PAIN1, SOUND_PAIN2, SOUND_PAIN3);
			}
			else if (!requestedHealer)
			{
				if (RandomInt(1, 5) != 1)
					PlayRandomSound(0, 10, SOUND_STRUCK1, SOUND_STRUCK2, SOUND_STRUCK3, SOUND_STRUCK1, SOUND_STRUCK2, SOUND_STRUCK3);
				else
					PlayRandomSound(0, 10, SOUND_PAIN1, SOUND_PAIN2, SOUND_PAIN3);
			}

			NEXT_REGEN = GameTime() + 10.0f;

			if (FORSUTH_CRITICAL && GameTime() > NEXT_CRITICAL)
			{
				NEXT_CRITICAL = GameTime() + FREQ_CRITICAL;
				InfoMessage("all", "CRITICAL NPC UNDER ATTACK", "Forsuth the Frosty is under attack!");
			}
		}
		return result;
	}

	// unnamed block (timer)
	void TheWallForsuth_Timer()
	{
		CallEventDelayed(Random(15, 60), "TheWallForsuth_Timer");

		if (!GAVE_FIRST_POT)
			return;

		if (CanSee("ally"))
		{
			bool cantShieldTarget = false;
			if (HasEffect(ENT_LASTSEEN, "iceshield"))
				cantShieldTarget = true;
			if (Truthy(ScriptVarOf(ENT_LASTSEEN, "PLAYING_DEAD")))
				cantShieldTarget = true;

			if (!cantShieldTarget)
			{
				SetMoveDest(ENT_LASTSEEN, 9999);
				PlayAnim("critical", "nod");
				ApplyEffect(ENT_LASTSEEN, "effects/iceshield", 360, self, 0.5f); // <who_applied> <FINAL_DURATION> <ICESHIELD_FORMULA>
				PlayerMessageGreen(ENT_LASTSEEN, "Forsuth casts Ice Shield upon you.");
			}
			else
			{
				PlayAnim("critical", "nod");
				ApplyEffect(ENT_ME, "effects/iceshield", 360, self, 0.5f); // <who_applied> <FINAL_DURATION> <ICESHIELD_FORMULA>
			}
		}
		else
		{
			PlayAnim("critical", "nod");
			ApplyEffect(ENT_ME, "effects/iceshield", 360, self, 0.5f); // <who_applied> <FINAL_DURATION> <ICESHIELD_FORMULA>
		}
		PlaySound(0, 10, "magic/cast.wav");
	}

	// unnamed block (timer)
	void TheWallForsuth_Timer2()
	{
		CallEventDelayed(10.0f, "TheWallForsuth_Timer2");
		if (!BUSY_CHATTING)
			return;
		if (!(GameTime() > CHAT_OVERRIDE_TIME))
			return;
		BUSY_CHATTING = false;
		CHAT_STEP = 0.0f;
		CHAT_STEPS = 0;
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
		SetStepSize(32);
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseNpcAttackNew_OnNpcSpawn(npc); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck

		SetName("Forsuth the Frosty");
		SetUniqueName("forsuth_frost");
		SetModel("dwarf/male1.mdl");
		SetHealth(MY_HP);
		SetDamageTaken("all", 0.5f);
		SetDamageTaken("cold", 0);
		SetWidth(32);
		SetHeight(72);
		SetHearingSensitivity(8);
		SetRace("human");
		SetRoam(false);
		SetSayTextRange(2048);
		SetNoPush(true); // no one tosses a dwarf!

		SetMoveSpeed(3);
		SetAnimMoveSpeed(3);
		BASE_MOVESPEED = 4.0f;

		SetIdleAnim(ANIM_IDLE);
		SetMoveAnim(ANIM_WALK);

		CatchSpeech("say_seekers", "seekers", "elves", "felewyn", "elf");
		CatchSpeech("say_stairs", "card", "hate", "zoe", "bill");

		SetModelBody(0, 0); // 0-Elder 1-Youngin 2-Zombie
		SetModelBody(1, 2); // 0-Unarmed 1-smallaxe 2-battleaxe 3-bastardsword
		SetModelBody(2, 1); // 0-none 1-lantern_left 2-lantern_right
		OnSetLantern();

		GAVE_POT_LIST = "";
		CallEventDelayed(90.0f, "set_critical"); // since he opens in battle, we don't want the critical alert to come as a surprise, save it for later

		NEXT_VICTORY = GameTime() + FREQ_VICTORY;
	}

	// npcatk_hunt
	void OnNpcatkHunt()
	{
		BaseNpcAttackNew_OnNpcatkHunt(); // monsters/base_npc_attack_new
		BaseAntiStuck_OnNpcatkHunt(); // monsters/base_anti_stuck
		BaseBattleAlly_OnNpcatkHunt(); // monsters/base_battle_ally
		DwarfLanternBase_OnNpcatkHunt(); // NPCs/dwarf_lantern_base
		CYCLCE_TIME = 0.1f;

		if (!IsAlive(PLAYER_FOLLOW) && IsAlive(ALLY_FOLLOW_PLR_ID))
			PLAYER_FOLLOW = ALLY_FOLLOW_PLR_ID;

		if (!IsAlive(ALLY_FOLLOW_PLR_ID) && IsAlive(PLAYER_FOLLOW))
			ALLY_FOLLOW_PLR_ID = PLAYER_FOLLOW;

		if (TELEPORT_CHEAT)
		{
			float myZ = OriginOf(ENT_ME).z;
			if (myZ < STAIR_TOP_Z && GameTime() > NEXT_TELEPORT && !BUSY_CHATTING)
			{
				// if !SUSPEND_AI
				if (DID_INTRO != 0 && !DID_END_EVENT && NPCATK_TARGET == "unset" && IsAlive(PLAYER_FOLLOW))
				{
					Vector3 plrOrg = OriginOf(PLAYER_FOLLOW);
					Vector3 myOrg = OriginOf(ENT_ME);
					if (Distance(myOrg, plrOrg) > 300.0f)
						OnBasecompanionCatchup();
				}
			}
		}

		if (DID_INTRO == 0 && NPCATK_TARGET == "unset")
		{
			string nearPlayer = FindInSphere("player", 256);
			SetRoam(false);
			NO_STUCK_CHECKS = "1";
			if (nearPlayer != "none")
			{
				nearPlayer = SortEntities(nearPlayer, "range");
				@PLAYER_CHAT = FindEntity(GetToken(nearPlayer, 0));
				SetMoveDest(@PLAYER_CHAT, 64);
				DID_INTRO = 1;
				TELEPORT_CHEAT = true;
				OnDoIntro();
				ALLY_FOLLOW_ON = true;
			}
		}

		if (SUSPEND_AI)
			return;
	}

	// npcatk_settarget
	void OnNpcatkSettarget(string target = "", string debug = "")
	{
		BaseNpcAttackNew_OnNpcatkSettarget(target, debug); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcatkSettarget(target, debug); // monsters/base_monster_shared
		if (!Contains(NameOf(NPCATK_TARGET), "Wraith"))
			return;
		if (!DID_WRAITH_COMMENT)
			OnDoWraithComment();
	}

	// npcatk_clear_targets
	void OnNpcatkClearTargets(string reason = "")
	{
		BaseNpcAttackNew_OnNpcatkClearTargets(reason); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcatkClearTargets(reason); // monsters/base_monster_shared
		BaseMonsterShared_OnNpcatkClearTargets_2(reason); // monsters/base_monster_shared
		if (!(GameTime() > NEXT_VICTORY))
			return;
		NEXT_VICTORY = GameTime() + FREQ_VICTORY;
		PlayRandomSound(0, 10, SOUND_VICTORY1, SOUND_VICTORY2);
	}

	// game_damaged - Return a damage multiplier to scale the damage
	string OnGameDamaged(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float accuracyRoll = 0.0f, CBaseEntity@ inflictor = null, string skill = "")
	{
		string result = "";
		result = AppendResult(result, BaseAntiStuck_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, BaseMonsterShared_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, BaseMonsterShared_OnGameDamaged_2(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, BaseBattleAlly_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, TheWallForsuth_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		return result;
	}

	// npc_targetsighted
	void OnNpcTargetsighted(string target = "")
	{
		BaseMonsterShared_OnNpcTargetsighted(target); // monsters/base_monster_shared
		if (!(GameTime() > NEXT_ALERT))
			return;
		NEXT_ALERT = GameTime() + FREQ_ALERT;
		PlayRandomSound(0, 10, SOUND_BATTLE_CRY1, SOUND_BATTLE_CRY2, SOUND_BATTLE_CRY3, SOUND_BATTLE_CRY4, SOUND_BATTLE_CRY5);
	}

	// game_menu_getoptions
	void OnGameMenuGetoptions(CBasePlayer@ player = null)
	{
		BaseChat_OnGameMenuGetoptions(player); // monsters/base_chat
		MenuItem menuItem;
		bool exitSub = false;

		if (PLAT_SUSPEND_MODE)
		{
			OnNpcatkResumeAi();
			OnNpcatkResumeMovement();
			SayText("Oh, sorry. Dozed off for a sec there.");
			PLAT_SUSPEND_MODE = false;
		}

		if (NPCATK_TARGET != "unset")
		{
			menuItem.title = "(In combat...)";
			menuItem.type = "disabled";
			RegisterMenuItem(menuItem);
			exitSub = true;
		}
		if (exitSub)
			return;

		if (BUSY_CHATTING)
		{
			menuItem.title = "(Talking...)";
			menuItem.type = "disabled";
			RegisterMenuItem(menuItem);
			exitSub = true;
		}
		if (exitSub)
			return;

		PlaySound(0, 10, SOUND_YES);

		PLAYER_FOLLOW = EntityId(player);

		SetMoveDest(@player, 9999);

		menuItem.title = "Hail";
		menuItem.type = "callback";
		menuItem.callback = "say_hi";
		RegisterMenuItem(menuItem);

		menuItem.title = "Ask for Ale";
		menuItem.type = "callback";
		menuItem.callback = "say_ale";
		RegisterMenuItem(menuItem);

		menuItem.title = "About Seekers";
		menuItem.type = "callback";
		menuItem.callback = "say_seekers";
		RegisterMenuItem(menuItem);

		if (EntityId(player) == QUEST_WINNER && !GAVE_REWARD)
		{
			string saytextStr = "Thar ye be, " + NameOf(QUEST_WINNER);
			OnBchatMouthMove();
			CallEventDelayed(3.0f, "bchat_close_mouth");
			SayText(saytextStr);

			PlaySound(0, 10, "voices/the_wall/forsuth/there_ye_be_i_have.wav");

			menuItem.title = "Get Reward";
			menuItem.type = "callback";
			menuItem.callback = "give_reward";
			RegisterMenuItem(menuItem);
		}
	}

	// chat_loop
	// Something odd is happening with forsuth getting stuck in chat mode
	// this is part of hacky workaround
	void OnChatLoop()
	{
		BaseChat_OnChatLoop(); // monsters/base_chat
		CHAT_OVERRIDE_TIME = GameTime() + Float(MAX_CHAT_TIME);
	}

	// set_critical
	void OnSetCritical()
	{
		FORSUTH_CRITICAL = true;
	}

	// do_intro
	void OnDoIntro()
	{
		if (BUSY_CHATTING)
			CallEventDelayed(1.0f, "do_intro");
		if (BUSY_CHATTING)
			return;
		// playsound 0 10 SOUND_HI
		CHAT_STEP1 = "Hail thar! I heard you were spotted goin into The Wall, so I took the shortcut from my house and wandered on down here.";
		CHAT_SOUND1 = "voices/the_wall/forsuth/hail_there_i_heard_you.wav";
		CHAT_DELAY_STEP1 = "5.9";
		CHAT_STEP2 = "Wanted to make sure ya'll were alright. Dangerous in here, but I guess you already figured that out, from the look of ye.";
		CHAT_SOUND2 = "voices/the_wall/forsuth/wanted_to_make_sure.wav";
		CHAT_DELAY_STEP2 = "6.5";
		CHAT_STEP3 = "Take this, it'll keep ya warm. Though, judging by the frost on yer armor, I think it might have done ya more good earlier.";
		CHAT_SOUND3 = "voices/the_wall/forsuth/take_this_itll_keep_you.wav";
		CHAT_DELAY_STEP3 = "5.8";

		CHAT_STEPS = 3;
		CHAT_EVENT_STEP2 = "give_pot";

		float totalChatTime = (CHAT_STEPS + 1.0f) * CHAT_DELAY;
		MAX_CHAT_TIME = Text(totalChatTime);
		OnChatLoop();
	}

	// give_pot
	void OnGivePot()
	{
		GAVE_FIRST_POT = true;
		Offer(PLAYER_CHAT, "drink_forsuth");
		GAVE_POT_LIST += EntityId(PLAYER_CHAT);
		CallEventOrDelay(CHAT_DELAY_STEP3, "do_intro2");
	}

	// do_intro2
	void OnDoIntro2()
	{
		SayText("Now, let's be gettin' out of here before anything too troublesome comes our way.");
		PlaySound(0, 10, "voices/the_wall/forsuth/now_lets_be_getting.wav");
		PlayAnim("critical", "nod");
		SetRoam(false);
		PLAYER_FOLLOW = EntityId(PLAYER_CHAT);
	}

	// give_reward
	void OnGiveReward(CBasePlayer@ player = null)
	{
		GAVE_REWARD = true;
		float nRewardsM1 = GetTokenCount(REWARD_LIST) - 1.0f;
		int rewardIdx = RandomInt(0, int(nRewardsM1));
		string rewardItem = GetToken(REWARD_LIST, rewardIdx);
		Offer(player, rewardItem);
		if (rewardItem != "smallarms_rd")
		{
			SayText("Thar ya go! Somethin' for a fine warrior. Use it wisely.");
			PlaySound(0, 10, "voices/the_wall/forsuth/there_you_go_something.wav");
		}
		else
		{
			CHAT_STEP1 = "This here may not look like much, but I've a feeling it be special.";
			CHAT_SOUND1 = "voices/the_wall/forsuth/now_this_here_might.wav";
			CHAT_DELAY_STEP1 = "4.5";
			CHAT_STEP2 = "You'll be needin a more experienced smith than I to figure it out though.";
			CHAT_SOUND2 = "voices/the_wall/forsuth/youll_be_needing.wav";
			CHAT_DELAY_STEP2 = "4.2";
			CHAT_STEPS = 2;
			float totalChatTime = (CHAT_STEPS + 1.0f) * CHAT_DELAY;
			MAX_CHAT_TIME = Text(totalChatTime);
			OnChatLoop();
		}
		OnBchatMouthMove();
		CallEventDelayed(3.0f, "bchat_close_mouth");
	}

	// say_hi
	void OnSayHi(CBasePlayer@ talkingPlayer = null)
	{
		if (BUSY_CHATTING)
			return;
		PlaySound(0, 10, SOUND_HI_ALT);
		CHAT_STEP1 = "Ya remember me, surely! Good ol' Forsuth the frosty, who lives up on the Frozen Summit!";
		ANIM_STEP1 = "nod";
		CHAT_SOUND1 = "voices/the_wall/forsuth/you_remember_me_surely.wav";
		CHAT_DELAY_STEP1 = "4.7";
		CHAT_STEP2 = "Word got to me that you got hired by some [Seekers] at the entrance to The Wall.";
		CHAT_SOUND2 = "voices/the_wall/forsuth/word_got_to_me_that.wav";
		CHAT_DELAY_STEP2 = "4.3";
		CHAT_STEP3 = "Got me worried. So I came runnin just as fast as my stubby dwarf legs would carry me.";
		CHAT_SOUND3 = "voices/the_wall/forsuth/got_me_worried_so.wav";
		CHAT_DELAY_STEP3 = "5.1";
		CHAT_STEP4 = "Not that it looks as though you really need the help, mind ye.";
		CHAT_SOUND4 = "voices/the_wall/forsuth/not_as_if_you_need_the.wav";
		CHAT_DELAY_STEP4 = "3.3";
		CHAT_STEP5 = "But it never hurts to have an extra pair of hands on your side. Especially if those hands can wield some dwarven steel!";
		CHAT_SOUND5 = "voices/the_wall/forsuth/but_it_never_hurts_to.wav";
		CHAT_DELAY_STEP5 = "6.2";

		CHAT_STEPS = 5;

		float totalChatTime = (CHAT_STEPS + 1.0f) * CHAT_DELAY;
		MAX_CHAT_TIME = Text(totalChatTime);
		OnChatLoop();
	}

	// say_ale
	void OnSayAle(CBasePlayer@ player = null)
	{
		if (Contains(GAVE_POT_LIST, EntityId(player)))
		{
			// playsound 0 10 SOUND_NO
			if (PlayerCount() > 1)
			{
				SayText("Sorry, I only brought enough for one for each of ye.");
				PlaySound(0, 10, "voices/the_wall/forsuth/sorry_only_brought.wav");
			}
			else
			{
				SayText("I brought more, actually, but me throte got parched along the way here and...");
				PlaySound(0, 10, "voices/the_wall/forsuth/i_brought_more_but_my.wav");
			}
		}
		else
		{
			// playsound 0 10 SOUND_YES
			Offer(player, "drink_forsuth");
			GAVE_POT_LIST = TokenAdd(GAVE_POT_LIST, EntityId(player));
			SayText("Thar ya go, that'll keep you warm through narely anything.");
			PlaySound(0, 10, "voices/the_wall/forsuth/there_ya_go_thatll_keep.wav");
			PlayAnim("critical", "nod");
		}
	}

	// say_seekers
	void OnSaySeekers()
	{
		if (BUSY_CHATTING)
			return;
		CHAT_STEP1 = "Those elves who hired you outside. Seekers they are. Bad news they can be.";
		CHAT_SOUND1 = "voices/the_wall/forsuth/those_elves_that_hired.wav";
		CHAT_DELAY_STEP1 = "4.5";
		CHAT_STEP2 = "They ain't evil, per-say, but they are rather... Methodical.";
		CHAT_SOUND2 = "voices/the_wall/forsuth/they_aint_evil_per_se.wav";
		CHAT_DELAY_STEP2 = "4.2";
		CHAT_STEP3 = "They believe in executing the letter of the law, but compassion and mercy ne'er enter into it.";
		CHAT_SOUND3 = "voices/the_wall/forsuth/they_believe_in_executing.wav";
		CHAT_DELAY_STEP3 = "6.0";
		CHAT_STEP4 = "Sometimes that makes them lose sight of the bigger picture, if you get my meaning.";
		CHAT_SOUND4 = "voices/the_wall/forsuth/sometimes_that_makes.wav";
		CHAT_DELAY_STEP4 = "4.5";
		CHAT_STEP5 = "Although I'm a dwarf, born of Urdual, and sworn to Him, first are foremost, I understand Torkalath.";
		CHAT_SOUND5 = "voices/the_wall/forsuth/although_im_a_dwarf.wav";
		CHAT_DELAY_STEP5 = "6.8";
		CHAT_STEP6 = "He values freedom, strength, and independence... And I've always been a bit too independent meself.";
		CHAT_SOUND6 = "voices/the_wall/forsuth/he_values_freedom.wav";
		CHAT_DELAY_STEP6 = "5.9";
		CHAT_STEP7 = "So, I kinda feel sorry for these 'Rammata' those zealots hunt so fanatically. Not that this lot wasn't mad...";
		CHAT_SOUND7 = "voices/the_wall/forsuth/so_i_kind_of_feel_sorry.wav";
		CHAT_DELAY_STEP7 = "7.2";
		CHAT_STEP8 = "But if the Seekers showed some tolerance, they likely would not have become so.";
		// MISSING FILE: setvard CHAT_SOUND8 voices/the_wall/forsuth/
		CHAT_DELAY_STEP8 = "5.0";
		CHAT_STEP9 = "Anyways, I don't want to go near those Seekers, for fear they might catch onto me disposition, if ya catch me drift.";
		CHAT_SOUND9 = "voices/the_wall/forsuth/anyway_i_dont_want_to.wav";
		CHAT_DELAY_STEP9 = "5.9";
		CHAT_DELAY_STEP9 = "";
		ANIM_STEP9 = "nod";
		CHAT_STEPS = 9;

		float totalChatTime = (CHAT_STEPS + 1.0f) * CHAT_DELAY;
		MAX_CHAT_TIME = Text(totalChatTime);
		OnChatLoop();
	}

	// attack_1
	// combat
	// called by modelanim attack @frame 6
	void OnAttack12()
	{
		PlaySound(0, 10, SOUND_SWING);
		DoDamage(NPCATK_TARGET, ATTACK_HITRANGE, DMG_SWING, ATTACK_HITCHANCE, "slash");

		if (RandomInt(1, 5) != 1)
			return;
		ANIM_ATTACK = "attack2";
	}

	// attack_2
	void OnAttack22()
	{
		PlayRandomSound(0, 10, SOUND_ATTACK1, SOUND_ATTACK2, SOUND_ATTACK3);
		float dmg = DMG_SWING * 2.0f;
		DoDamage(NPCATK_TARGET, ATTACK_HITRANGE, dmg, ATTACK_HITCHANCE, "slash");
		ANIM_ATTACK = "attack";
		ApplyEffect(NPCATK_TARGET, "effects/debuff_stun", 10.0f, self);
	}

	// ext_forsuth_mountain
	// =================== MAP TRIGGERED EVENTS
	void OnExtForsuthMountain()
	{
		if (DID_MOUNTAIN_COMMENT)
			return;
		DID_MOUNTAIN_COMMENT = true;
		CallEventDelayed(5.0f, "ext_forsuth_mountain2");
		Vector3 faceTo = OriginOf(ENT_ME) + RelativePosition(Vector3(0, 90, 0), Vector3(0, 1000, 0));
		SetMoveDest(faceTo, 9999);
		OnNpcatkSuspendAi("8.0");
		OnNpcatkSuspendMovement(ANIM_IDLE);
		CHAT_STEP1 = "Them be the mountains surrounding The Bleak. Pretty they are... though deadly";
		ANIM_STEP1 = "nod";
		CHAT_SOUND1 = "voices/the_wall/forsuth/them_be_the_mountains.wav";
		CHAT_DELAY_STEP1 = "4.2";
		// setvard CHAT_STEP2 "Deadly, but pretty."
		CHAT_STEPS = 1;

		AS_ATTACKING = GameTime() + 15.0f;
		ALLY_NEXT_FAS_CHECK = GameTime() + 15.0f;

		float totalChatTime = (CHAT_STEPS + 1.0f) * CHAT_DELAY;
		MAX_CHAT_TIME = Text(totalChatTime);
		OnChatLoop();
	}

	// ext_forsuth_mountain2
	void OnExtForsuthMountain2()
	{
		OnNpcatkResumeMovement();
		SayText("Oh well, enough gawkin' - let's be movin'.");
		PlaySound(0, 10, "voices/the_wall/forsuth/enough_gawking.wav");
	}

	// ext_forsuth_morc
	void OnExtForsuthMorc()
	{
		// no repeat flag here, as this is a trigger_once
		CHAT_STEP1 = "Stupid bleedin Marogar orcs come down here, lookin' for lost elven treasure.";
		CHAT_SOUND1 = "voices/the_wall/forsuth/stupid_bleedin_marogar.wav";
		CHAT_DELAY_STEP1 = "4.9";
		CHAT_STEP2 = "Half of them wind up like that poor bloke there - rotting zombies.";
		CHAT_SOUND2 = "voices/the_wall/forsuth/half_of_them_end_up_like.wav";
		CHAT_DELAY_STEP2 = "3.8";
		CHAT_STEPS = 2;

		float totalChatTime = (CHAT_STEPS + 1.0f) * CHAT_DELAY;
		MAX_CHAT_TIME = Text(totalChatTime);
		OnChatLoop();
	}

	// ext_forsuth_undead
	void OnExtForsuthUndead()
	{
		if (DID_UNDEAD_COMMENT)
			return;
		DID_UNDEAD_COMMENT = true;
		CHAT_STEP1 = "Well, will ye be lookin' at that! Orcs and undead, livin' together in harmony!";
		CHAT_SOUND1 = "voices/the_wall/forsuth/orcs_and_undead.wav";
		CHAT_DELAY_STEP1 = "4.8";
		CHAT_STEP2 = "Well... Together, anyways...";
		CHAT_SOUND2 = "voices/the_wall/forsuth/well_together_anyways.wav";
		CHAT_DELAY_STEP2 = "2.4";
		CHAT_STEPS = 2;

		float totalChatTime = (CHAT_STEPS + 1.0f) * CHAT_DELAY;
		MAX_CHAT_TIME = Text(totalChatTime);
		OnChatLoop();
	}

	// ext_forsuth_stairs
	void OnExtForsuthStairs()
	{
		if (DID_STAIRS_COMMENT)
			return;
		DID_STAIRS_COMMENT = true;
		CHAT_STEP1 = "By Urdual's Beard! My poor stubby dwarven legs!";
		CHAT_SOUND1 = "voices/the_wall/forsuth/by_urduals_beard.wav";
		CHAT_DELAY_STEP1 = "5.1";
		CHAT_STEP2 = "Ya'd think... The elves... Such skinny legged folk they be...";
		CHAT_SOUND2 = "voices/the_wall/forsuth/youd_think.wav";
		CHAT_DELAY_STEP2 = "6.2";
		CHAT_STEP3 = "Would be less prone to building endless flights of stairs!";
		CHAT_SOUND3 = "voices/the_wall/forsuth/less_prone_to_building.wav";
		CHAT_DELAY_STEP3 = "6.1";
		CHAT_STEPS = 3;

		float totalChatTime = (CHAT_STEPS + 1.0f) * CHAT_DELAY;
		MAX_CHAT_TIME = Text(totalChatTime);
		OnChatLoop();
	}

	// say_stairs
	void OnSayStairs()
	{
		// left4dead easter egg
		if (!DID_STAIRS_COMMENT)
			return;
		SayText("We got enough zombies to deal with without draggin' Bill and Francis into this!");
		PlaySound(0, 10, "voices/the_wall/forsuth/enough_zombies_to.wav");
		PlayAnim("critical", "nod");
	}

	// ext_forsuth_paint
	void OnExtForsuthPaint()
	{
		// no repeat flag here, as this is a trigger_once
		CallEventDelayed(3.0f, "ext_forsuth_paint2");
		Vector3 faceTo = OriginOf(ENT_ME) + RelativePosition(Vector3(0, 270, 0), Vector3(0, 1000, 0));
		SetMoveDest(faceTo, 128);
		OnNpcatkSuspendAi("3.0");
		OnNpcatkSuspendMovement(ANIM_IDLE);

		AS_ATTACKING = GameTime() + 5.0f;
		ALLY_NEXT_FAS_CHECK = GameTime() + 5.0f;

		SayText("Now who'd go ruinin' a perflectly good paintin' of Felewyn like that?");
		PlaySound(0, 10, "voices/the_wall/forsuth/now_whod_go_ruining.wav");
		PlayAnim("critical", "nod");
	}

	// ext_forsuth_paint2
	void OnExtForsuthPaint2()
	{
		OnNpcatkResumeMovement();
	}

	// ext_forsuth_plat
	void OnExtForsuthPlat()
	{
		CallEventDelayed(40.0f, "forsuth_plat_abort");
		@PLAT_ENT = FindByName("plat_exit");
		PLAT_OFS = 0.0f;
		if (PLAT_ENT !is null)
			PLAT_OFS = OriginOf(ENT_ME).z - OriginOf(PLAT_ENT).z;
		CallEventDelayed(0.1f, "forsuth_plat_loop");
		OnForsuthPlatChatter();

		Vector3 faceTo = OriginOf(ENT_ME) + RelativePosition(Vector3(0, 270, 0), Vector3(0, 1000, 0));
		SetMoveDest(faceTo, 128);
		OnNpcatkSuspendAi();
		OnNpcatkSuspendMovement(ANIM_IDLE);
	}

	// forsuth_plat_loop
	void OnForsuthPlatLoop()
	{
		bool exitSub = false;
		if (REACHED_TOP)
			return;
		CallEventDelayed(0.1f, "forsuth_plat_loop");
		Vector3 adjOrg = OriginOf(ENT_ME);

		if (PLAT_ENT !is null)
		{
			float platZ = OriginOf(PLAT_ENT).z + PLAT_OFS;
			adjOrg.z = platZ;
			SetOrigin(ENT_ME, adjOrg);
			exitSub = true;
		}
		if (exitSub)
			return;

		adjOrg.z += 10.0f;
		SetOrigin(ENT_ME, adjOrg);
	}

	// forsuth_plat_chatter
	void OnForsuthPlatChatter()
	{
		// case we just crossed the orc trigger
		if (BUSY_CHATTING)
			CallEventDelayed(1.0f, "forsuth_plat_chatter");
		if (BUSY_CHATTING)
			return;
		CHAT_STEP1 = "Alright, here's the pullyworks...";
		CHAT_SOUND1 = "voices/the_wall/forsuth/alright_heres_the_pulleyworks.wav";
		CHAT_DELAY_STEP1 = "2.2";
		CHAT_STEP2 = "Turn that wheel there, and it'll take us up the mountain to the surface.";
		CHAT_SOUND2 = "voices/the_wall/forsuth/turn_that_wheel_there.wav";
		CHAT_DELAY_STEP2 = "3.5";
		CHAT_STEPS = 2;

		float totalChatTime = (CHAT_STEPS + 1.0f) * CHAT_DELAY;
		MAX_CHAT_TIME = Text(totalChatTime);
		OnChatLoop();
	}

	// reached_top
	void OnReachedTop()
	{
		REACHED_TOP = true;
	}

	// forsuth_plat_abort
	void OnForsuthPlatAbort()
	{
		if (REACHED_TOP)
			return;
		// not hit the top for some reason, teleport
		string teleportDest = EntityId(FindByName("forsuth_teleport"));
		teleportDest = Text(OriginOf(teleportDest));
		SetOrigin(ENT_ME, Vec(teleportDest));
		SayText("Don't ask me how I did that.");

		PlaySound(0, 10, "voices/the_wall/forsuth/dont_ask_me_how.wav");

		REACHED_TOP = true;
		PLAT_SUSPEND_MODE = true;

		CallEventDelayed(20.0f, "ext_forsuth_bye"); // just in case the exit event fails
	}

	// ext_forsuth_reached_top
	void OnExtForsuthReachedTop()
	{
		CallEventDelayed(1.5f, "reached_top");
		SayText("Top floor: seekers, undead elves, and lovely mountain vistas.");
		PlaySound(0, 10, "voices/the_wall/forsuth/top_floor_seekers.wav");
		OnNpcatkResumeAi();
		OnNpcatkResumeMovement();
	}

	// ext_forsuth_bye
	void OnExtForsuthBye()
	{
		ALLY_FOLLOW_ON = false;
		TELEPORT_CHEAT = false;
		if (DID_END_EVENT)
			return;
		DID_END_EVENT = true;
		UseTrigger("spawn_forsuth_extras");
		CallExternal("players", "ext_clear_valid_gauntlets");
		OnNpcatkSuspendAi();
		OnNpcatkSuspendMovement(ANIM_IDLE);
		// playsound 0 10 SOUND_BYE
		CHAT_STEP1 = "Alright, this is as far as I go.";
		CHAT_SOUND1 = "voices/the_wall/forsuth/alright_this_is_as_far_as_i_go.wav";
		CHAT_DELAY_STEP1 = "2.5";
		CHAT_STEP2 = "I don't blame you for working for the [Seekers]. They pay well...";
		CHAT_SOUND2 = "voices/the_wall/forsuth/i_dont_blame_you_for.wav";
		CHAT_DELAY_STEP2 = "3.8";
		CHAT_STEP3 = "...but I don't want to be goin' anywhere near 'em, meself.";
		CHAT_SOUND3 = "voices/the_wall/forsuth/but_i_dont_want_to_go.wav";
		CHAT_DELAY_STEP3 = "2.7";
		CallExternal(GetVar("GAME_MASTER"), "gm_top_players_reset", PlayerCount());
		QUEST_WINNER = ScriptVarOf(GetVar("GAME_MASTER"), "THE_CHOSEN_ONE");
		CHAT_STEP4 = "Send " + NameOf(QUEST_WINNER);
		if (GenderOf(QUEST_WINNER) == "male")
		{
			CHAT_STEP4 += " over yonder. He's done more than his share, and I've a reward for him.";
			CHAT_SOUND4 = "voices/the_wall/forsuth/reward_reminder_male.wav";
			CHAT_DELAY_STEP4 = "4.5";
		}
		else
		{
			CHAT_STEP4 += " over yonder. The lass has done more than her share, and I've a reward for her.";
			CHAT_SOUND4 = "voices/the_wall/forsuth/reward_reminder_female.wav";
			CHAT_DELAY_STEP4 = "5.1";
		}
		CHAT_STEPS = 4;

		FACE_PLAYERS = true;

		float totalChatTime = (CHAT_STEPS + 1.0f) * CHAT_DELAY;
		MAX_CHAT_TIME = Text(totalChatTime);
		OnChatLoop();
		SetSolid("none");
	}

	// ext_forsuth_follow_close
	void OnExtForsuthFollowClose()
	{
		DebugPrint("ext_forsuth_follow_close");
		if (TELEPORT_CHEAT)
			return;
		TELEPORT_CHEAT = true;
		OnTeleportCheatLoop();
		NO_STUCK_CHECKS = "1";
		FOLLOW_RANGE_MIN = 48;
		FOLLOW_RANGE_MAX = 64;
	}

	// ext_forsuth_follow_norm
	void OnExtForsuthFollowNorm()
	{
		TELEPORT_CHEAT = false;
		NO_STUCK_CHECKS = "0";
		FOLLOW_RANGE_MIN = 64;
		FOLLOW_RANGE_MAX = 256;
	}

	// ext_unsolid
	// debugarry
	void OnExtUnsolid(float time = 0.0f)
	{
		SetSolid("none");
	}

	// basecompanion_catchup
	void OnBasecompanionCatchup(int emergency = 0)
	{
		Vector3 pos = OriginOf(PLAYER_FOLLOW);

		// alternate tele positions
		// add COMPANION_LR 10
		// if ( COMPANION_LR > 359 ) subtract COMPANION_LR 359
		// default to behind player if not teleported recently
		COMPANION_LR = ViewAnglesOf(PLAYER_FOLLOW);

		float ang = COMPANION_LR.y;
		pos += RelativePosition(Vector3(0, ang, 0), Vector3(0, -48, 0));

		// vectorset L_POS z $get_ground_height(L_POS)
		// dbg basecompanion_catchup $get(PLAYER_FOLLOW,name)
		// dbg game.ret.npcmove.success game.ret.npcmove.dist game.ret.npcmove.hitstep
		// setsolid PLAYER_FOLLOW slidebox
		Vector3 oldPos = OriginOf(ENT_ME);
		SetOrigin(ENT_ME, pos);
		pos += RelativePosition(Vector3(0, 90, 0), Vector3(0, 16, 0));
		// setsolid PLAYER_FOLLOW none
		SetLocal("reg.npcmove.endpos", pos);
		SetLocal("reg.npcmove.testonly", 1);
		LegacyCommand("npcmove", ENT_ME, PLAYER_FOLLOW);
		NEXT_TELEPORT = GameTime() + 3.0f;
		if (!(Float(Eval("game.ret.npcmove.dist")) <= 0.0f))
			return;
		SetOrigin(ENT_ME, oldPos);
		NEXT_TELEPORT = 0.0f;
	}

	// do_wraith_comment
	void OnDoWraithComment()
	{
		DID_WRAITH_COMMENT = true;
		SayText("Blast! Wraiths! You'll need a holy weapon to even hit 'em!");
		PlaySound(0, 10, "voices/the_wall/forsuth/blast_wraiths.wav");
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files

	// game_death
	void OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		DqMonsterExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // dq/externals/dq_monster_externals
		MonstersExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/externals
		BaseSelfAdjust_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_self_adjust
		BaseNpc_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseMonsterShared_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared
		DwarfLanternBase_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // NPCs/dwarf_lantern_base
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseNpc_OnGameSpawn(playerRace, playerGender); // monsters/base_npc
		BaseMonsterShared_OnGameSpawn(playerRace, playerGender); // monsters/base_monster_shared
		BaseChat_OnGameSpawn(playerRace, playerGender); // monsters/base_chat
	}

	// npcatk_suspend_ai
	void OnNpcatkSuspendAi(string seconds = "", string debugTag = "")
	{
		BaseNpcAttackNew_OnNpcatkSuspendAi(seconds, debugTag); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcatkSuspendAi(seconds, debugTag); // monsters/base_monster_shared
	}

	void OnChatDelayStep3() {} // CHAT_DELAY_STEP3
	void OnTeleportCheatLoop() {} // teleport_cheat_loop

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("3dmflagry.spr");
		Precache("dwarf/male1.mdl");
		CallEventDelayed(Float(Eval("$randf(15.0,60.0)")), "TheWallForsuth_Timer");
		CallEventDelayed(10.0f, "TheWallForsuth_Timer2");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		TheWallForsuth_FirstThink();
		TheWallForsuth_FirstThink2();
		BaseNpc_FirstThink();
		MonstersExternals_FirstThink();
		BaseNpcAttackNew_FirstThink();
		BaseMonsterShared_FirstThink();
		BaseChat_FirstThink();
		BaseBattleAlly_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "attack_1") { OnAttack12(); return true; }
		if (name == "attack_2") { OnAttack22(); return true; }
		if (name == "basecompanion_catchup") { OnBasecompanionCatchup(Int(Param(params, 0))); return true; }
		if (name == "chat_loop") { OnChatLoop(); return true; }
		if (name == "do_intro") { OnDoIntro(); return true; }
		if (name == "do_intro2") { OnDoIntro2(); return true; }
		if (name == "do_wraith_comment") { OnDoWraithComment(); return true; }
		if (name == "ext_forsuth_bye") { OnExtForsuthBye(); return true; }
		if (name == "ext_forsuth_follow_close") { OnExtForsuthFollowClose(); return true; }
		if (name == "ext_forsuth_follow_norm") { OnExtForsuthFollowNorm(); return true; }
		if (name == "ext_forsuth_morc") { OnExtForsuthMorc(); return true; }
		if (name == "ext_forsuth_mountain") { OnExtForsuthMountain(); return true; }
		if (name == "ext_forsuth_mountain2") { OnExtForsuthMountain2(); return true; }
		if (name == "ext_forsuth_paint") { OnExtForsuthPaint(); return true; }
		if (name == "ext_forsuth_paint2") { OnExtForsuthPaint2(); return true; }
		if (name == "ext_forsuth_plat") { OnExtForsuthPlat(); return true; }
		if (name == "ext_forsuth_reached_top") { OnExtForsuthReachedTop(); return true; }
		if (name == "ext_forsuth_stairs") { OnExtForsuthStairs(); return true; }
		if (name == "ext_forsuth_undead") { OnExtForsuthUndead(); return true; }
		if (name == "ext_unsolid") { OnExtUnsolid(Float(Param(params, 0))); return true; }
		if (name == "forsuth_plat_abort") { OnForsuthPlatAbort(); return true; }
		if (name == "forsuth_plat_chatter") { OnForsuthPlatChatter(); return true; }
		if (name == "forsuth_plat_loop") { OnForsuthPlatLoop(); return true; }
		if (name == "game_damaged") { Return(OnGameDamaged(EntityParam(params, 0), Float(Param(params, 1)), Param(params, 2), Float(Param(params, 3)), EntityParam(params, 4), Param(params, 5))); return true; }
		if (name == "game_menu_getoptions") { OnGameMenuGetoptions(PlayerParam(params, 0)); return true; }
		if (name == "give_pot") { OnGivePot(); return true; }
		if (name == "give_reward") { OnGiveReward(PlayerParam(params, 0)); return true; }
		if (name == "npc_post_spawn") { OnNpcPostSpawn(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "npc_targetsighted") { OnNpcTargetsighted(Param(params, 0)); return true; }
		if (name == "npcatk_clear_targets") { OnNpcatkClearTargets(Param(params, 0)); return true; }
		if (name == "npcatk_hunt") { OnNpcatkHunt(); return true; }
		if (name == "npcatk_settarget") { OnNpcatkSettarget(Param(params, 0), Param(params, 1)); return true; }
		if (name == "reached_top") { OnReachedTop(); return true; }
		if (name == "say_ale") { OnSayAle(PlayerParam(params, 0)); return true; }
		if (name == "say_hi") { OnSayHi(PlayerParam(params, 0)); return true; }
		if (name == "say_seekers") { OnSaySeekers(); return true; }
		if (name == "say_stairs") { OnSayStairs(); return true; }
		if (name == "set_critical") { OnSetCritical(); return true; }
		if (name == "TheWallForsuth_Timer") { TheWallForsuth_Timer(); return true; }
		if (name == "TheWallForsuth_Timer2") { TheWallForsuth_Timer2(); return true; }
		return BaseChat_DispatchEvent(name, params)
			|| BaseBattleAlly_DispatchEvent(name, params)
			|| DwarfLanternBase_DispatchEvent(name, params)
			|| BaseMonsterNewScript::DispatchEvent(name, params);
	}
}
