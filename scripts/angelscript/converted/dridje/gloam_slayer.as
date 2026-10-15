#pragma context server

// Converted from dridje/gloam_slayer.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_monster_new.as"
#include "converted/monsters/base_chat.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class GloamSlayer
{
	// Constants
	float FREQ_GLOAM = 120.0f;
	string CONV_ANIMS = "converse2;talkleft;talkright;lean;pondering2;pondering3;yes;c1a0_catwalkidle;quicklook";
	string MAGIC_LIST = "fire;ice;lightning;earth;poison;acid;magic;";
	float FREQ_FF_WARN = 10.0f;
	float CHAT_DELAY = 5.5f;
	string REWARD_LIST = "scroll2_lightning_storm;blunt_granitemace;blunt_darkmaul;blunt_gauntlets_serpant;mana_leadfoot;armor_helm_golden;item_charm_w3;";
	string REWARD_NAMES = "a Lightning Storm Scroll;a Granite Mace;a Dark Maul;Serpant Gauntlets;a Potion of Stability;a Golden Helm;a Shadow Wolf Charm;";
	string SOUND_STRUCK = "body/flesh1.wav";
	string SOUND_DEATH = "voices/human/male_die.wav";
	string ATTACK_HITCHANCE = "85%";
	string ATTACK_DAMAGE = "$randf(50,200)";
	bool NO_JOB = true;
	bool NO_RUMOR = true;
	string ANIM_SPELL_SELF = "return_needle";
	string ANIM_SPELL_OTHER = "give_shot";
	float FREQ_ICE_SHIELD = 60.0f;

	// Variables (an unset .script variable reads as its own name)
	string ANIM_IDLE = "idle1";
	string ANIM_RUN = "run";
	string ANIM_WALK = "walk";
	float N_REWARDS_GIVEN = 0.0f;
	int MAX_REWARDS_TOGIVE = 0;
	string ANIM_DEATH = "ANIM_DEATH";
	string ANIM_ATTACK = "ANIM_ATTACK";
	string MOVE_RANGE = "MOVE_RANGE";
	float ATTACK_RANGE = 0.0f;
	float ATTACK_HITRANGE = 0.0f;
	float NPC_GIVE_EXP = 0.0f;
	bool NO_HAIL = false;
	string NO_STUCK_CHECKS = "NO_STUCK_CHECKS";
	float LAST_DAMAGED = 0.0f;
	float NEXT_FF_WARNING = 0.0f;
	CBaseEntity@ CURRENT_SPEAKER = null;
	int DID_INTRO = 0;
	string CONVO_TYPE = "CONVO_TYPE";
	int CHAT_STEPS = 0;
	float CHAT_STEP = 0.0f;
	string CHAT_STEP1 = "CHAT_STEP1";
	string CHAT_STEP2 = "CHAT_STEP2";
	string CHAT_STEP3 = "CHAT_STEP3";
	string CHAT_STEP4 = "CHAT_STEP4";
	bool BUSY_CHATTING = false;
	bool DONE_WARNING = false;
	CBasePlayer@ OFFERING_REWARD = null;
	float N_REWARDS = 0.0f;
	bool MISSION_ACCEPTED = false;
	CBasePlayer@ ESCORT_TARGET = null;
	string QUEST_WINNER = "QUEST_WINNER";
	bool IN_BATTLE = false;
	int SCHAT_STEPS = 0;
	float SCHAT_STEP = 0.0f;
	string SCHAT_STEP1 = "SCHAT_STEP1";
	string SCHAT_STEP2 = "SCHAT_STEP2";
	string SCHAT_STEP3 = "SCHAT_STEP3";
	string CHAT_STEP5 = "CHAT_STEP5";
	string CHAT_STEP6 = "CHAT_STEP6";
	string CHAT_STEP7 = "CHAT_STEP7";
	string CHAT_STEP8 = "CHAT_STEP8";
	bool BATTLE_OVER = false;
	bool BATTLLE_OVER = false;
	bool FORCED_MOVE_DEST = false;
	bool NPC_STUCK_CHECKS = false;
	bool NPC_FORCED_MOVEDEST = false;
	string MENU_TARGET = "MENU_TARGET";

	// unnamed block (first think)
	void GloamSlayer_FirstThink()
	{
		N_REWARDS_GIVEN = 0.0f; // maxes at whatever game.players was at battle_over
		MAX_REWARDS_TOGIVE = 0;

		ANIM_IDLE = "idle1";
		ANIM_RUN = "run";
		ANIM_WALK = "walk";
		ANIM_DEATH = "diebackward";
		ANIM_ATTACK = "swordswing1_l";

		MOVE_RANGE = "32";
		ATTACK_RANGE = 96.0f;
		ATTACK_HITRANGE = 120.0f;

		NPC_GIVE_EXP = 0.0f;
		NO_HAIL = true;
	}

	// game_precache
	void GloamSlayer_OnGamePrecache()
	{
		PrecacheFile("monsters/gloam1");
	}

	// npc_spawn
	void GloamSlayer_OnNpcSpawn(string npc = "")
	{
		SetUniqueName("agrath");
		SetName("Agrath the Gloam Hunter");
		SetInvincible(true); // toggle off when battle begins
		SetRoam(false);
		SetBlood("red");
		NO_STUCK_CHECKS = "1";
		SetRace("human");
		SetWidth(32);
		SetHeight(96);
		SetHealth(1000);
		SetSayTextRange(1024);
		SetHearingSensitivity(8);
		// setmonsterclip 0
		SetModel("npc/royal_guard2.mdl");
		SetIdleAnim("idle1");
		SetMoveAnim("walk");

		CallEventDelayed(1.0f, "set_critical");

		SetAnimMoveSpeed(2);
		SetMoveSpeed(2);

		CallEventDelayed(2.0f, "light_up");

		CatchSpeech("say_hi", "hi", "hail", "j0", "jo", "yo", "waddup", "wassup", "hello", "greet");
		CatchSpeech("say_gloam", "gloam");
		CatchSpeech("say_yes", "yes", "help", "accept");
	}

	// set_critical
	void GloamSlayer_OnSetCritical()
	{
		if (NPC_CRITICAL)
			return;
		OnCriticalNpc();
	}

	// game_damaged
	// PARAM1=attacker PARAM2=dmg PARAM3=dmg_type
	string GloamSlayer_OnGameDamaged(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float accuracyRoll = 0.0f, CBaseEntity@ inflictor = null, string skill = "")
	{
		bool exitSub = false;
		bool isSpell = false;
		string result = "";

		// cant get him to stay invulnerable pre and post battle for some reason
		// not sure if this fixes it, but something did
		if (BATTLE_OVER)
		{
			result = AppendResult(result, "0");
			exitSub = true;
		}

		if (!IN_BATTLE)
		{
			result = AppendResult(result, "0");
			exitSub = true;
		}

		if (exitSub)
			return result;

		PlaySound(0, 5, SOUND_STRUCK);

		if (!IsPlayer(attacker))
			LAST_DAMAGED = GameTime();

		if (!IsPlayer(attacker))
			return result;

		if (!(GameTime() > NEXT_FF_WARNING))
			return result;

		NEXT_FF_WARNING = GameTime() + FREQ_FF_WARN;

		if (Contains(damageType, "effect"))
			isSpell = true;
		if (FindToken(MAGIC_LIST, damageType) > -1)
			isSpell = true;

		if (isSpell)
		{
			if (RangeTo(attacker) > 256.0f)
			{
				SayText("Watch where you cast those things!");
			}
			else
			{
				string namePre = NameOf(attacker) + "!";
				SayText(namePre + " Check your targets!");
			}
		}

		if (!isSpell)
		{
			if (RangeTo(attacker) < 256.0f)
				SayText("Careful where you swing that!");
			else
				SayText(NameOf(attacker) + " , watch your targets!");
		}
		return result;
	}

	// say_hi
	void GloamSlayer_OnSayHi(CBasePlayer@ talkingPlayer = null)
	{
		if (IN_BATTLE)
			return;
		if (BUSY_CHATTING)
			return;

		if (IsPlayer(talkingPlayer))
		{
			@CURRENT_SPEAKER = talkingPlayer;
			OnFaceSpeaker(EntityId(CURRENT_SPEAKER));
		}
		if (IsPlayer(ENT_LASTSPOKE))
		{
			@CURRENT_SPEAKER = EntityOf(ENT_LASTSPOKE);
			OnFaceSpeaker(EntityId(CURRENT_SPEAKER));
		}

		if (!BATTLE_OVER)
		{
			DID_INTRO = 1;
			PlayAnim("critical", "idle4");
			CallEventDelayed(2.0f, "fix_anims");
			CONVO_TYPE = "intro";
			CHAT_STEPS = 4;
			CHAT_STEP = 0.0f;
			CHAT_STEP1 = "Bah! Hail there. I am known as Agrath of the Royal Guard. The King sent me here to clear this isle of gloams that we may begin logging the forest safely.";
			CHAT_STEP2 = "But I never imagined there would be so many such beasts in this jungle, and this sad contigent I brought with me would be mere fodder for them.";
			if (PlayerCount() > 1)
				CHAT_STEP3 = "You lads look a bit more up to a battle, more so than this sad lot anyways.";
			if (PlayerCount() == 1)
				CHAT_STEP3 = "You may yet make better escort than all this sad lot combined.";
			CHAT_STEP4 = "If you will serve as my escort and ferret these beasts out, you will be well rewarded for your efforts.";
			BUSY_CHATTING = true;
			OnChatLoop();
		}

		if (BATTLE_OVER)
		{
			PlayAnim("critical", "yes");
			CallEventDelayed(2.0f, "fix_anims");
			SayText("Thanks again for your assistance.");
		}
	}

	// open_menu
	void GloamSlayer_OnOpenMenu()
	{
		OpenMenu(CURRENT_SPEAKER);
	}

	// chat_loop
	void GloamSlayer_OnChatLoop()
	{
		if (!(CHAT_STEP > 1.0f))
			return;
		CallEventDelayed(1.0f, "convo_anim");

		if (CHAT_STEP == 4.0f && CONVO_TYPE == "intro")
		{
			SetMoveDest(@CURRENT_SPEAKER, 9999);
			// playanim critical converse2
			CallEventDelayed(2.0f, "open_menu");
		}

		if (CHAT_STEP == 8.0f && CONVO_TYPE == "info_talk")
		{
			SetMoveDest(@CURRENT_SPEAKER, 9999);
			// playanim critical converse2
			CONVO_TYPE = "intro";
			CallEventDelayed(2.0f, "open_menu");
		}

		if (CHAT_STEP == 3.0f && CONVO_TYPE == "pep_talk")
			DONE_WARNING = true;
	}

	// game_menu_getoptions
	void GloamSlayer_OnGameMenuGetoptions(CBasePlayer@ player = null)
	{
		MenuItem menuItem;
		int count;

		DebugPrint("game_menu_getoptions");

		if (BUSY_CHATTING)
		{
			menuItem.title = "(Busy Chatting)";
			menuItem.type = "disabled";
			menuItem.callback = "none";
			RegisterMenuItem(menuItem);
		}

		if (IN_BATTLE)
		{
			string hpTitle = "HP (" + int(HealthOf(ENT_ME)) + "/" + int(MaxHealthOf(ENT_ME)) + ")";

			menuItem.title = hpTitle;
			menuItem.type = "disabled";
			menuItem.callback = "none";
			RegisterMenuItem(menuItem);
		}

		if (BUSY_CHATTING)
			return;

		if (CONVO_TYPE != "intro" && !IN_BATTLE && CONVO_TYPE != "give_list")
		{
			menuItem.title = "Hail";
			menuItem.type = "callback";
			menuItem.callback = "say_hi";
			RegisterMenuItem(menuItem);
		}

		if (CONVO_TYPE == "intro")
		{
			menuItem.title = "Yes, I'll help.";
			menuItem.type = "callback";
			menuItem.callback = "dude_said_yes";
			RegisterMenuItem(menuItem);

			menuItem.title = "What are Gloams?";
			menuItem.type = "callback";
			menuItem.callback = "say_gloam";
			RegisterMenuItem(menuItem);

			menuItem.title = "Sorry, busy.";
			menuItem.type = "callback";
			menuItem.callback = "player_deny";
			RegisterMenuItem(menuItem);
		}

		if (BATTLE_OVER && CONVO_TYPE != "give_list" && !Truthy(ScriptVarOf(player, "PLR_GOT_REWARD")))
		{
			menuItem.title = "Collect reward";
			menuItem.type = "callback";
			menuItem.callback = "give_reward";
			RegisterMenuItem(menuItem);
		}

		if (CONVO_TYPE == "give_list" && !Truthy(ScriptVarOf(player, "PLR_GOT_REWARD")))
		{
			@OFFERING_REWARD = player;
			count = GetTokenCount(REWARD_LIST);
			for (int i = 0; i < count; i++)
			{
				loopIteration = i;
				OnAddRewards();
			}
			CONVO_TYPE = "none";
		}
	}

	// add_rewards
	void GloamSlayer_OnAddRewards()
	{
		MenuItem menuItem;

		if (!(RandomInt(1, 100) <= 75))
			return;

		N_REWARDS += 1.0f;
		int curIdx = loopIteration;
		string curReward = GetToken(REWARD_LIST, curIdx);
		string curName = GetToken(REWARD_NAMES, curIdx);

		menuItem.title = curName;
		menuItem.type = "callback";
		menuItem.data = curIdx;
		menuItem.cb_failed = "no_want";
		menuItem.callback = "give_selected_reward";

		DebugPrint("add_rewards reg.mitem.title reg.mitem.callback");

		RegisterMenuItem(menuItem);
	}

	// game_menu_cancel
	void GloamSlayer_OnGameMenuCancel(CBasePlayer@ player = null)
	{
		DebugPrint("game_menu_cancel " + CONVO_TYPE + " " + NameOf(player));
		// dont let them recycle the reward list
		if (OFFERING_REWARD !is player)
			return;
		SayText("I see. A noble warrior for whom the battle is reward enough. Good show.");
		CallExternal(OFFERING_REWARD, "ext_set_reward", 1);
	}

	// give_selected_reward
	void GloamSlayer_OnGiveSelectedReward(CBasePlayer@ player = null, int rewardIndex = 0)
	{
		DebugPrint("give_selected_reward " + NameOf(player) + " " + rewardIndex);
		N_REWARDS_GIVEN += 1.0f;
		Offer(player, GetToken(REWARD_LIST, rewardIndex));
		CallExternal(player, "ext_set_reward", 1);
	}

	// say_yes
	void GloamSlayer_OnSayYes(CBasePlayer@ player = null)
	{
		if (CONVO_TYPE != "intro")
			return;
		OnDudeSaidYes(ToPlayer(EntityOf(ENT_LASTSPOKE)));
	}

	// dude_said_yes
	void GloamSlayer_OnDudeSaidYes(CBasePlayer@ speaker = null)
	{
		// (always true here) if game.serverside

		if (MISSION_ACCEPTED)
			return;
		if (DONE_WARNING)
			return;
		if (!IsAlive(speaker))
			return;
		MISSION_ACCEPTED = true;

		@ESCORT_TARGET = speaker;

		OnCycleUp("manual_override");
		CONVO_TYPE = "none";
		QUEST_WINNER = EntityId(speaker);
		PlayAnim("critical", "yes");
		IN_BATTLE = true;
		NO_STUCK_CHECKS = "1";

		DONE_WARNING = false;
		CONVO_TYPE = "pep_talk";
		SCHAT_STEPS = 3;
		SCHAT_STEP = 0.0f;
		SCHAT_STEP1 = "Alright, the forest beyond that barricade is completely infested with [Gloams]. Nasty work, Gloams are...";
		SCHAT_STEP2 = "If we can slay all the elder, Ether Gloams, the rest shouldnt give us any trouble, and most likely will flee.";
		SCHAT_STEP3 = "Be ready for a good fight. Ill follow you in, but these novices will have to stay behind. No point in leading them to a slaughter.";
		BUSY_CHATTING = true;
		CallEventDelayed(1.0f, "special_chat_loop"); // this insanity fixes the double text mystery

		SetInvincible(false);
		UseTrigger("ether_gloams_go");
		CallEventDelayed(FREQ_ICE_SHIELD, "do_ice_shield");
	}

	// special_chat_loop
	void GloamSlayer_OnSpecialChatLoop()
	{
		bool exitSub = false;

		SCHAT_STEP += 1.0f;
		if (SCHAT_STEP == SCHAT_STEPS)
			BUSY_CHATTING = false;
		if (SCHAT_STEP > SCHAT_STEPS)
		{
			BUSY_CHATTING = false;
			SCHAT_STEP = 0.0f;
			exitSub = true;
		}
		if (exitSub)
			return;
		if (!(SCHAT_STEP <= SCHAT_STEPS))
			return;
		CallEventDelayed(CHAT_DELAY, "special_chat_loop");
		if (SCHAT_STEP == 1.0f)
			SayText(SCHAT_STEP1);
		if (SCHAT_STEP == 2.0f)
			SayText(SCHAT_STEP2);
		if (SCHAT_STEP == 3.0f)
		{
			SayText(SCHAT_STEP3);
			DONE_WARNING = true;
		}
	}

	// player_deny
	void GloamSlayer_OnPlayerDeny()
	{
		CONVO_TYPE = "none";
		PlayAnim("critical", "no");

		CONVO_TYPE = "angry";
		CHAT_STEPS = 2;
		CHAT_STEP = 0.0f;
		CHAT_STEP1 = "Bah, coward! I suppose I could order you in the name of the king...";
		CHAT_STEP2 = "but I'd rather beat these swine into shape than have an escort who'll run at the first sign of danger!";
		BUSY_CHATTING = true;
		OnChatLoop();
	}

	// say_gloam
	void GloamSlayer_OnSayGloam()
	{
		if (!IN_BATTLE)
		{
			CallEventDelayed(2.0f, "fix_anims");
			CONVO_TYPE = "info_talk";
			CHAT_STEPS = 8;
			CHAT_STEP = 0.0f;
			CHAT_STEP1 = "I've seen all sorts of gloams: gloams of stone, of ice, and of fire. Tis why they've sent me, I suppose.";
			CHAT_STEP2 = "These gloams here are the more common, tropical variety. Slimy beasts tend to show up in abandoned wetlands such as this jungle.";
			CHAT_STEP3 = "They move fast, are tough, and in addition to the usual motivation of hunger, are likely also defending their nests.";
			CHAT_STEP4 = "The ether gloams are the elder ones. It seems a good gloam never dies, it just fades away. Sadly, this means the creatures can turn invisible.";
			CHAT_STEP5 = "While they are invisible they are neigh impossible to hit, and if they touches you while in their ethereal state, it'll give you a nasty wallup.";
			CHAT_STEP6 = "The ether gloams are vulnerable to holy weapons due to their unnatural state, so if you have any, have them at the ready...";
			CHAT_STEP7 = "But beware that the same does not apply to the younger ones. For, as the wizards tell me, they are beastly, but still of this world.";
			CHAT_STEP8 = "Beyond that all I can say is keep a sharp eye and a steady hand, and ye may yet survive with all your limbs uneaten.";
			BUSY_CHATTING = true;
			OnChatLoop();
		}
		else
		{
			SayText("Oh NOW you want to hear about the gloams!? A bit busy at the moment! You'll learn anything I could have taught you the hard way soon enough!");
		}
	}

	// gloam_raid_over
	// external via ms_npcscript
	void GloamSlayer_OnGloamRaidOver()
	{
		NO_STUCK_CHECKS = "0";
		MAX_REWARDS_TOGIVE = PlayerCount();
		BATTLE_OVER = true;
		OnNpcatkWalk();
		OnNpcatkClearTargets();
		BATTLLE_OVER = true;
		IN_BATTLE = false;
		FORCED_MOVE_DEST = true;
		SetMoveDest(QUEST_WINNER, 32);
		SetInvincible(true);
		CallEventDelayed(1.0f, "hunt_quest_winner_loop");
	}

	// npcatk_hunt
	void GloamSlayer_OnNpcatkHunt()
	{
		// if IN_BATTLE
		if (!DONE_WARNING)
			return;

		// if ( NPCATK_TARGET isnot unset ) setanim.movespeed 1.0
		if (NPCATK_TARGET != "unset")
			return;
		// setanim.movespeed 2.0
		if (!IsAlive(ESCORT_TARGET))
			return;
		float escortDist = RangeTo(ESCORT_TARGET);
		if (escortDist > 128.0f)
		{
			NPC_STUCK_CHECKS = false;
			OnNpcatkSetmovedest(EntityId(ESCORT_TARGET), "128");
			if (escortDist > 384.0f)
				SetMoveAnim(ANIM_RUN);
			else
				SetMoveAnim(ANIM_WALK);
		}
		else
		{
			NPC_STUCK_CHECKS = false;
			SetMoveDest("none");
			// dbg facing escort angs
			float escortFace = AnglesOf(ESCORT_TARGET).y;
			SetAngle("face", Vector3(0, escortFace, 0));
		}
	}

	// give_reward
	void GloamSlayer_OnGiveReward(CBasePlayer@ player = null)
	{
		bool exitSub = false;
		if (N_REWARDS_GIVEN >= MAX_REWARDS_TOGIVE)
		{
			SayText("Sorry, I've nothing left to offer.");
			exitSub = true;
		}
		if (exitSub)
			return;

		NPC_FORCED_MOVEDEST = true;
		PlayAnim("critical", "yes");
		if (IsAlive(player))
			SetMoveDest(@player, 9999);
		CallEventDelayed(2.0f, "fix_anims");

		if (Truthy(ScriptVarOf(player, "PLR_GOT_REWARD")))
			return;
		SayText("Thank you for your fine aid in battle! Please select a reward, courtesy of the king...");
		CONVO_TYPE = "give_list";
		if (IsAlive(player))
			MENU_TARGET = EntityId(player);
		if (!IsAlive(player))
			MENU_TARGET = QUEST_WINNER;
		CallEventDelayed(0.1f, "send_menu");
	}

	// send_menu
	void GloamSlayer_OnSendMenu()
	{
		OpenMenu(MENU_TARGET);
	}

	// fix_anims
	void GloamSlayer_OnFixAnims()
	{
		// ms_npcscript seems to be fubar'ing my anims, reset after call
		SetMoveAnim("walk");
		SetIdleAnim("idle1");
		PlayAnim("once", "idle1");
	}

	// game_menu_cancel
	void GloamSlayer_OnGameMenuCancel_2(CBasePlayer@ player = null)
	{
		CONVO_TYPE = "none";
	}

	// attack_1
	void GloamSlayer_OnAttack12()
	{
		OnNpcatkDodamage(NPCATK_TARGET, Text(ATTACK_HITRANGE), ATTACK_DAMAGE, ATTACK_HITCHANCE);
	}

	// do_ice_shield
	void GloamSlayer_OnDoIceShield()
	{
		if (!IN_BATTLE)
			return;
		CallEventDelayed(FREQ_ICE_SHIELD, "do_ice_shield");

		if (CanSee("ally"))
		{
			if (IsPlayer(ENT_LASTSEEN))
			{
				bool cantShieldTarget = false;
				if (HasEffect(ENT_LASTSEEN, "iceshield"))
					cantShieldTarget = true;
				if (Truthy(ScriptVarOf(ENT_LASTSEEN, "PLAYING_DEAD")))
					cantShieldTarget = true;

				if (!cantShieldTarget)
				{
					SetMoveDest(ENT_LASTSEEN, 9999);
					PlayAnim("critical", ANIM_SPELL_OTHER);
					ApplyEffect(ENT_LASTSEEN, "effects/iceshield", 45, self, 0.5f);
					PlayerMessageGreen(ENT_LASTSEEN, "Agrath casts Ice Shield upon you.");
				}
				else
				{
					PlayAnim("critical", ANIM_SPELL_SELF);
					ApplyEffect(ENT_ME, "effects/iceshield", 45, self, 0.5f);
				}
			}
		}
		else
		{
			PlayAnim("critical", ANIM_SPELL_SELF);
			ApplyEffect(ENT_ME, "effects/iceshield", 45, self, 0.5f);
		}
		PlaySound(0, 10, "magic/cast.wav");
	}

	// cycle_npc
	void GloamSlayer_OnCycleNpc(string mode = "")
	{
		OnCycleUp("forced");
	}

	// my_target_died
	void GloamSlayer_OnMyTargetDied(string offender = "")
	{
		OnNpcatkWalk();
	}

	// unnamed block (timer)
	// glow
	void GloamSlayer_Timer()
	{
		CallEventDelayed(30.1f, "GloamSlayer_Timer");
		ClientEvent("new", "all", "effects/sfx_follow_glow_cl", IndexOf(ENT_ME), Vector3(255, 255, 255), 96, 30.0f);
	}

	// game_death
	void GloamSlayer_OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		if (!NPC_CRITICAL)
			InfoMessage("all", "CRITICAL NPC DIED", "Agrath the Gloam Hunter has died.");
	}

	// unnamed block (timer)
	void GloamSlayer_Timer2()
	{
		CallEventDelayed(20.0f, "GloamSlayer_Timer2");
		if (!IN_BATTLE)
			return;

		float timeDiff = GameTime() - LAST_DAMAGED;

		if (timeDiff > FREQ_GLOAM)
		{
			// it's been at least a minute since anything struck me, perhaps I am lost or exploited
			// summon a gloam from the trees above
			DebugPrint("******* SPAWNING GLOAM *******");

			Vector3 summonPos = OriginOf(ENT_ME);
			summonPos.z += 256.0f;
			CreateNpc("monsters/gloam1", summonPos);
			LAST_DAMAGED = GameTime();
		}
	}

	// ext_freeze
	// debuggary
	void GloamSlayer_OnExtFreeze()
	{
		SetMoveSpeed(0);
	}

	// npc_suicide
	void GloamSlayer_OnNpcSuicide(string suicideMode = "")
	{
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
		GloamSlayer_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4);
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseNpc_OnGameSpawn(playerRace, playerGender); // monsters/base_npc
		BaseMonsterShared_OnGameSpawn(playerRace, playerGender); // monsters/base_monster_shared
		BaseChat_OnGameSpawn(playerRace, playerGender); // monsters/base_chat
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseNpcAttackNew_OnNpcSpawn(npc); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck
		GloamSlayer_OnNpcSpawn(npc);
	}

	// npcatk_hunt
	void OnNpcatkHunt()
	{
		BaseNpcAttackNew_OnNpcatkHunt(); // monsters/base_npc_attack_new
		BaseAntiStuck_OnNpcatkHunt(); // monsters/base_anti_stuck
		GloamSlayer_OnNpcatkHunt();
	}

	// my_target_died
	void OnMyTargetDied(string offender = "")
	{
		BaseNpcAttackNew_OnMyTargetDied(offender); // monsters/base_npc_attack_new
		GloamSlayer_OnMyTargetDied(offender);
	}

	// game_damaged - Return a damage multiplier to scale the damage
	string OnGameDamaged(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float accuracyRoll = 0.0f, CBaseEntity@ inflictor = null, string skill = "")
	{
		string result = "";
		result = AppendResult(result, BaseAntiStuck_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, BaseMonsterShared_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, BaseMonsterShared_OnGameDamaged_2(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, GloamSlayer_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		return result;
	}

	// game_menu_getoptions
	void OnGameMenuGetoptions(CBasePlayer@ player = null)
	{
		BaseChat_OnGameMenuGetoptions(player); // monsters/base_chat
		GloamSlayer_OnGameMenuGetoptions(player);
	}

	// chat_loop
	void OnChatLoop()
	{
		BaseChat_OnChatLoop(); // monsters/base_chat
		GloamSlayer_OnChatLoop();
	}

	void OnGamePrecache() { GloamSlayer_OnGamePrecache(); } // game_precache
	void OnSetCritical() { GloamSlayer_OnSetCritical(); } // set_critical
	void OnSayHi(CBasePlayer@ talkingPlayer = null) { GloamSlayer_OnSayHi(talkingPlayer); } // say_hi
	void OnOpenMenu() { GloamSlayer_OnOpenMenu(); } // open_menu
	void OnAddRewards() { GloamSlayer_OnAddRewards(); } // add_rewards

	// game_menu_cancel
	void OnGameMenuCancel(CBasePlayer@ player = null)
	{
		GloamSlayer_OnGameMenuCancel(player);
		GloamSlayer_OnGameMenuCancel_2(player);
	}

	void OnGiveSelectedReward(CBasePlayer@ player = null, int rewardIndex = 0) { GloamSlayer_OnGiveSelectedReward(player, rewardIndex); } // give_selected_reward
	void OnSayYes(CBasePlayer@ player = null) { GloamSlayer_OnSayYes(player); } // say_yes
	void OnDudeSaidYes(CBasePlayer@ speaker = null) { GloamSlayer_OnDudeSaidYes(speaker); } // dude_said_yes
	void OnSpecialChatLoop() { GloamSlayer_OnSpecialChatLoop(); } // special_chat_loop
	void OnPlayerDeny() { GloamSlayer_OnPlayerDeny(); } // player_deny
	void OnSayGloam() { GloamSlayer_OnSayGloam(); } // say_gloam
	void OnGloamRaidOver() { GloamSlayer_OnGloamRaidOver(); } // gloam_raid_over
	void OnGiveReward(CBasePlayer@ player = null) { GloamSlayer_OnGiveReward(player); } // give_reward
	void OnSendMenu() { GloamSlayer_OnSendMenu(); } // send_menu
	void OnFixAnims() { GloamSlayer_OnFixAnims(); } // fix_anims
	void OnAttack12() { GloamSlayer_OnAttack12(); } // attack_1
	void OnDoIceShield() { GloamSlayer_OnDoIceShield(); } // do_ice_shield
	void OnCycleNpc(string mode = "") { GloamSlayer_OnCycleNpc(mode); } // cycle_npc
	void OnExtFreeze() { GloamSlayer_OnExtFreeze(); } // ext_freeze
	void OnNpcSuicide(string suicideMode = "") { GloamSlayer_OnNpcSuicide(suicideMode); } // npc_suicide
	void OnChatDelay() {} // CHAT_DELAY
	void OnFreqIceShield() {} // FREQ_ICE_SHIELD

	// This file's events and timers by their .script names
	bool GloamSlayer_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "add_rewards") { OnAddRewards(); return true; }
		if (name == "attack_1") { OnAttack12(); return true; }
		if (name == "chat_loop") { OnChatLoop(); return true; }
		if (name == "cycle_npc") { OnCycleNpc(Param(params, 0)); return true; }
		if (name == "do_ice_shield") { OnDoIceShield(); return true; }
		if (name == "dude_said_yes") { OnDudeSaidYes(PlayerParam(params, 0)); return true; }
		if (name == "ext_freeze") { OnExtFreeze(); return true; }
		if (name == "fix_anims") { OnFixAnims(); return true; }
		if (name == "game_damaged") { Return(OnGameDamaged(EntityParam(params, 0), Float(Param(params, 1)), Param(params, 2), Float(Param(params, 3)), EntityParam(params, 4), Param(params, 5))); return true; }
		if (name == "game_death") { OnGameDeath(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_menu_cancel") { OnGameMenuCancel(PlayerParam(params, 0)); return true; }
		if (name == "game_menu_getoptions") { OnGameMenuGetoptions(PlayerParam(params, 0)); return true; }
		if (name == "game_precache") { OnGamePrecache(); return true; }
		if (name == "give_reward") { OnGiveReward(PlayerParam(params, 0)); return true; }
		if (name == "give_selected_reward") { OnGiveSelectedReward(PlayerParam(params, 0), Int(Param(params, 1))); return true; }
		if (name == "gloam_raid_over") { OnGloamRaidOver(); return true; }
		if (name == "my_target_died") { OnMyTargetDied(Param(params, 0)); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "npc_suicide") { OnNpcSuicide(Param(params, 0)); return true; }
		if (name == "npcatk_hunt") { OnNpcatkHunt(); return true; }
		if (name == "open_menu") { OnOpenMenu(); return true; }
		if (name == "player_deny") { OnPlayerDeny(); return true; }
		if (name == "say_gloam") { OnSayGloam(); return true; }
		if (name == "say_hi") { OnSayHi(PlayerParam(params, 0)); return true; }
		if (name == "say_yes") { OnSayYes(PlayerParam(params, 0)); return true; }
		if (name == "send_menu") { OnSendMenu(); return true; }
		if (name == "set_critical") { OnSetCritical(); return true; }
		if (name == "special_chat_loop") { OnSpecialChatLoop(); return true; }
		if (name == "GloamSlayer_Timer") { GloamSlayer_Timer(); return true; }
		if (name == "GloamSlayer_Timer2") { GloamSlayer_Timer2(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "dridje/gloam_slayer"]
shared class GloamSlayerScript : BaseMonsterNewScript, GloamSlayer, BaseChat
{
	// Variables declared by included files, with the value they start with in this script
	GloamSlayerScript()
	{
		SOUND_DEATH = "voices/human/male_die.wav";
		ANIM_IDLE = "idle1";
		ANIM_RUN = "run";
		ANIM_WALK = "walk";
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files

	// npcatk_suspend_ai
	void OnNpcatkSuspendAi(string seconds = "", string debugTag = "")
	{
		BaseNpcAttackNew_OnNpcatkSuspendAi(seconds, debugTag); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcatkSuspendAi(seconds, debugTag); // monsters/base_monster_shared
	}

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("npc/royal_guard2.mdl");
		CallEventDelayed(30.1f, "GloamSlayer_Timer");
		CallEventDelayed(20.0f, "GloamSlayer_Timer2");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		GloamSlayer_FirstThink();
		BaseNpc_FirstThink();
		MonstersExternals_FirstThink();
		BaseNpcAttackNew_FirstThink();
		BaseMonsterShared_FirstThink();
		BaseChat_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return GloamSlayer_DispatchEvent(name, params)
			|| BaseChat_DispatchEvent(name, params)
			|| BaseMonsterNewScript::DispatchEvent(name, params);
	}
}
