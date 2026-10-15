#pragma context server

// Converted from phobia/ralion_ally.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_battle_ally.as"
#include "converted/monsters/bandit_elite_archer.as"
#include "converted/monsters/base_chat_array.as"

[script "phobia/ralion_ally"]
class RalionAlly : BanditEliteArcherScript, BaseBattleAlly, BaseChatArray
{
	// Variables declared by included files, with the value they start with in this script
	RalionAlly()
	{
		MY_SKILL = "archery";
		OVERRIDE_BANDIT_SPAWN = true;
		AI_NO_TARGET_STRING = "\xAFNONE\xAF";
		ANIM_ALLY_JUMP = "long_jump";
		SOUND_ALLY_JUMP = "player/shout1.wav";
		ALLY_JUMP_THRESHOLD = 150;
		NPC_PROX_ACTIVATE = true;
		NPC_PROXACT_RANGE = "512";
		NPC_PROXACT_EVENT = "do_intro";
		NPC_PROXACT_DELAY = "0";
		ANIM_IDLE = "ANIM_IDLE";
		NPC_FIGHTS_NPCS = true; // from monsters/base_battle_ally
		ALLY_MIN_DISTANCE = 42; // from monsters/base_battle_ally
		ALLY_FOLLOW_CLOSE_DIST = 60; // from monsters/base_battle_ally
		ALLY_FOLLOW_NORM_DIST = 128; // from monsters/base_battle_ally
		ALLY_MOVE_AWAY_DIST = 64; // from monsters/base_battle_ally
		ALLY_REGEN_RATIO = 0.1f; // from monsters/base_battle_ally
		ALLY_MAX_JUMP_RANGE = 600; // from monsters/base_battle_ally
		CHAT_CONV_ANIMS = "converse2;converse1;talkleft;talkright;lean;pondering;pondering2;pondering3;"; // from monsters/base_chat_array
		HAS_BASE_CHAT_ARRAY_INCLUDE = true; // from monsters/base_chat_array
		CHAT_USE_BUSY_MESSAGE = true; // from monsters/base_chat_array
		CHAT_USE_CONV_ANIMS = true; // from monsters/base_chat_array
		CHAT_AUTO_FACE = true; // from monsters/base_chat_array
		CHAT_FACE_ON_USE = true; // from monsters/base_chat_array
		CHAT_MENU_ENABLE = true; // from monsters/base_chat_array
		CHAT_PLAYANIM_STYLE = "critical"; // from monsters/base_chat_array
		CHAT_MAX_LINE_LEN = 192; // from monsters/base_chat_array
		CHAT_DELAY = 4.0f; // from monsters/base_chat_array
	}

	// unnamed block (first think)
	void RalionAlly_FirstThink()
	{
		NPC_HBAR_ADJ = Vector3(0, 0, 32);
	}

	// bandit_ally_fire_spawn
	void RalionAlly_OnBanditAllyFireSpawn()
	{
		// slight delay to give chance for players to spot boss (kinda floats in the air)
		CallEventDelayed(5.0f, "bandit_ally_fire_spawn2");
	}

	// bandit_ally_fire_spawn
	void RalionAlly_OnBanditAllyFireSpawn_2()
	{
		OnChatNow("Oh, I was afraid Cethin would show her ugly self after we killed that damned bear of hers...", "3.0", "none", "aim_punch1", "clear_que");
		OnChatNow("You know the plan men, drink up!", "2.0", "none", "none", "clear_que");
		CallEventDelayed(5.0f, "bandit_ally_fire_spawn3");
	}

	// game_precache
	void OnGamePrecache()
	{
		PrecacheFile("monsters/bandit_elite");
	}

	// npcatk_suspend_ai
	void OnNpcatkSuspendAi(string seconds = "", string debugTag = "")
	{
		BaseNpcAttack_OnNpcatkSuspendAi(seconds, debugTag); // monsters/base_npc_attack
		BaseMonsterShared_OnNpcatkSuspendAi(seconds, debugTag); // monsters/base_monster_shared
		DebugPrint("npcatk_suspend_ai " + seconds + " " + debugTag); // AI suspended for no reason, trying to find out where
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck
		BanditElite_OnNpcSpawn(npc); // monsters/bandit_elite

		BANDIT_TYPE = "bow";

		SetName("|Ralion");
		SetUniqueName("bandit_ralion");
		SetMonsterClip(false);
		SetModel("npc/rogue_1337.mdl");
		SetProp(ENT_ME, "scale", 1.5f);
		SetGold(RandomInt(30, 40));
		SetWidth(32);
		SetHeight(92);

		SetRace("human");
		SetDamageTaken("all", 0.6f);
		SetHearingSensitivity(10);
		SetRoam(false);

		SetIdleAnim(ANIM_IDLE);
		SetMoveAnim(ANIM_WALK);

		SetMenuAutoOpen(true);

		CallEventDelayed(0.1f, "custom_bowey");
	}

	// game_menu_getoptions
	void OnGameMenuGetoptions(CBasePlayer@ player = null)
	{
		BaseChatArray_OnGameMenuGetoptions(player); // monsters/base_chat_array
		MenuItem menuItem;

		if (HOSTILE_MODE)
			return;

		if (REWARD_MODE && MADE_DEAL)
		{
			InfoMessage(player, "Training with bandits", "You may only train with one bandit, so choose wisely.");
			menuItem.title = "Bow Training...";
			menuItem.type = "callback";
			menuItem.callback = "say_reward";
			RegisterMenuItem(menuItem);
		}

		if (!MADE_DEAL)
		{
			SetGlobal("G_REWARD_LIST", "");
			menuItem.title = "Deal.";
			menuItem.type = "callback";
			menuItem.callback = "say_deal";
			RegisterMenuItem(menuItem);

			menuItem.title = "No Deal.";
			menuItem.type = "callback";
			menuItem.callback = "say_no_deal";
			RegisterMenuItem(menuItem);
		}

		if (!Truthy(GetVar("G_DEVELOPER_MODE")))
			return;

		if (!ALLY_FOLLOW_ON)
		{
			menuItem.title = "Dev:Follow.";
			menuItem.type = "callback";
			menuItem.callback = "bandit_ally_start_follow";
			RegisterMenuItem(menuItem);
		}
		else
		{
			menuItem.title = "Dev:Stay here.";
			menuItem.type = "callback";
			menuItem.callback = "stop_follow";
			RegisterMenuItem(menuItem);
		}

		menuItem.title = "Dev:Go hostile.";
		menuItem.type = "callback";
		menuItem.callback = "bandit_ally_go_hostile";
		RegisterMenuItem(menuItem);
	}

	// custom_bowey
	void OnCustomBowey()
	{
		// bowey
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

		CallEventDelayed(300.0f, "bandit_remove_delay");
	}

	// bandit_remove_delay
	void OnBanditRemoveDelay()
	{
		if (HOSTILE_MODE)
			return;
		if (MADE_DEAL)
			return;
		CallExternal("all", "bandits_remove");
	}

	// bandits_remove
	void OnBanditsRemove()
	{
		DeleteEntity(ENT_ME, "fade"); // folks left us here, probably hoping to exploit, remove
	}

	// bandit_ally_start_follow
	void OnBanditAllyStartFollow()
	{
		// saytext Following...
		PlayAnim("break");
		ALLY_FOLLOW_ON = true;
	}

	// stop_follow
	void OnStopFollow()
	{
		SayText("Stopping...");
		PlayAnim("break");
		ALLY_FOLLOW_ON = false;
	}

	// bandit_ally_go_hostile
	void OnBanditAllyGoHostile()
	{
		HOSTILE_MODE = true;
		NPC_NO_PLAYER_DMG = false;
		NPC_BATTLE_ALLY = false;
		ALLY_FOLLOW_ON = false;
		SetRace("rogue");
		SetRoam(true);
		if (BANDIT_TYPE != "bow")
			NO_STUCK_CHECKS = "0";
		SetMenuAutoOpen(false);
	}

	// do_intro
	void OnDoIntro()
	{
		SetMoveDest(@NPC_PROXACT_PLAYERID, 96);
		CHAT_CURRENT_SPEAKER = EntityId(NPC_PROXACT_PLAYERID);
		PlaySound(0, 10, "voices\\phobia\\ralion01.wav");
		OnNpcatkResumeAi();
		// callevent chat_now <text> [time] [anim|"none"] [event|"none"] ["clear_que"] ["add_to_que"]
		CHAT_TEMP_NO_AUTO_FACE = true;
		OnChatNow("Woah there! Hold a sec! Truce! Truce!", "2.0", "none", "do_intro2", "add_to_que");
	}

	// do_intro2
	void OnDoIntro2()
	{
		CHAT_TEMP_NO_AUTO_FACE = false;
		OnChatNow("I saw you tear through those orcs, and our would-be rescuers, like so much butter, and have no desire to put your steel to the test further.", "4.0", "look_idle", "play_line2", "add_to_que");
		OnChatNow("Not that it matters. Even without that display, the fort we escaped belongs to Graznux's horde, and the only way out, without going through it, is through this forest.", "6.0", "deep_idle", "play_line3", "add_to_que");
		OnChatNow("But there's angry spirits in this forest, and I'd rather not tangle with such a beasts alone, or with just my two men here.", "5.0", "deep_idle", "play_line4", "add_to_que");
		OnChatNow("I'd offer you gold for your help, but I'm sure you'd just as soon take it off our corpses. So let me offer you something that you can't acquire so easily...", "6.0", "look_idle", "play_line5", "add_to_que");
		OnChatNow("We three know our stuff. We can teach you a few tricks. I know my bows... Betor there knows his hammers. ...And Skelr sleeps with that damned dagger like it was a teddy.", "7.0", "aim_fireball_R", "play_line6", "add_to_que");
		OnChatNow("Help us escape this mess, and we'll teach you what we know... One lesson for each of you. Whaddaya say, deal?", "3.0", "look_idle", "set_deal_idle", "add_to_que");
	}

	// set_deal_idle
	void OnSetDealIdle()
	{
		OpenMenu(NPC_PROXACT_PLAYERID);
		ANIM_IDLE = "aim_fireball_R";
		SetIdleAnim(ANIM_IDLE);
	}

	// play_line2
	void OnPlayLine2()
	{
		PlaySound(0, 10, "voices\\phobia\\ralion02.wav");
	}

	// play_line3
	void OnPlayLine3()
	{
		PlaySound(0, 10, "voices\\phobia\\ralion03.wav");
	}

	// play_line4
	void OnPlayLine4()
	{
		PlaySound(0, 10, "voices\\phobia\\ralion04.wav");
	}

	// play_line5
	void OnPlayLine5()
	{
		PlaySound(0, 10, "voices\\phobia\\ralion05.wav");
	}

	// play_line6
	void OnPlayLine6()
	{
		PlaySound(0, 10, "voices\\phobia\\ralion06.wav");
	}

	// say_deal
	void OnSayDeal()
	{
		OnChatClearQue();
		MADE_DEAL = true;
		SetMenuAutoOpen(false);
		ANIM_IDLE = "deep_idle";
		SetIdleAnim(ANIM_IDLE);
		PlaySound(0, 10, "voices\\phobia\\ralion_deal.wav");
		OnChatNow("Alright, we may make it out of this alive yet. Lead on, we'll follow.", "2.0", "aim_fireball_R", "none", "clear_que");
		// callevent bandit_ally_start_follow
		CallExternal("all", "bandit_ally_start_follow");
	}

	// say_no_deal
	void OnSayNoDeal()
	{
		OnChatClearQue();
		ANIM_IDLE = "deep_idle";
		MADE_DEAL = true;
		SetMenuAutoOpen(false);
		SetIdleAnim(ANIM_IDLE);
		PlaySound(0, 10, "voices\\phobia\\ralion_no_deal.wav");
		OnChatNow("Well, I suppose we can always train you in the more direct way then.", "2.0", "none", "none", "clear_que");
		CallEventDelayed(1.0f, "say_no_deal2");
	}

	// say_no_deal2
	void OnSayNoDeal2()
	{
		// callevent bandit_ally_go_hostile
		CallExternal("all", "bandit_ally_go_hostile");
	}

	// bandit_ally_fire_spawn
	void OnBanditAllyFireSpawn()
	{
		RalionAlly_OnBanditAllyFireSpawn();
		RalionAlly_OnBanditAllyFireSpawn_2();
	}

	// bandit_ally_fire_spawn3
	void OnBanditAllyFireSpawn3()
	{
		CallExternal("all", "bandit_ally_drinkup");
	}

	// bandit_ally_drinkup
	void OnBanditAllyDrinkup()
	{
		PlayAnim("critical", "aim_punch1");

		float myHp = HealthOf(ENT_ME);
		float myMaxhp = MaxHealthOf(ENT_ME);

		if (myHp < myMaxhp)
		{
			float healAmt = myMaxhp;
			string healAmtText;
			healAmt -= myHp;
			healAmtText = Text(healAmt);
			GiveHealth(ENT_ME, healAmtText);
		}

		string outTitle = NameOf(ENT_ME) + " has quaffed a potion of fire resistance.";
		InfoMessage("all", outTitle, "' '");
		SetDamageTaken("fire", 0.25f);
		SetDamageTaken("all", 0.4f);
		PlaySound(0, 10, "items/drink.wav");
		Effect("glow", ENT_ME, Vector3(255, 0, 0), 64, 2, 2);
	}

	// bandit_ally_boss_dead
	void OnBanditAllyBossDead()
	{
		OnNpcatkSuspendAi();
		OnNpcatkSuspendMovement("deep_idle");
		SetMoveDest("none");
		OnCheckQualify();
		ALLY_FOLLOW_ON = false;
		REWARD_MODE = true;
		SetMenuAutoOpen(true);
	}

	// check_qualify
	void OnCheckQualify()
	{
		TC_QUAL_PLAYERS = false;
		TC_QUAL_PLAYERS = Truthy(GetActivePlayers());
		TC_AVG_DMG_PTS = 0.0f;
		int count = GetTokenCount(Text(TC_QUAL_PLAYERS));
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnTcGetAverages();
		}
		TC_AVG_DMG_PTS = Divide(TC_AVG_DMG_PTS, PlayerCount());
		TC_HALF_AVG_DMG_PTS = TC_AVG_DMG_PTS * 0.5f;
	}

	// tc_get_averages
	void OnTcGetAverages()
	{
		string curPlayer = GetToken(Text(TC_QUAL_PLAYERS), loopIteration);
		TC_AVG_DMG_PTS += Float(ScriptVarOf(curPlayer, "PLR_TOTAL_DMG"));
	}

	// say_reward
	void OnSayReward(CBasePlayer@ player = null)
	{
		bool exitSub = false;
		int userPts = Int(ScriptVarOf(player, "PLR_TOTAL_DMG"));
		USER_QUALIFIES = false;
		if (userPts >= TC_HALF_AVG_DMG_PTS)
			USER_QUALIFIES = true;
		if (!USER_QUALIFIES)
		{
			PlayAnim("critical", "look_idle");
			SayText("Judging by your performance out there, or rather the lack there of, I don't think you're ready for what I could teach you.");
		}
		if (!USER_QUALIFIES)
			return;
		float userSteam = Float(SteamIdOf(player));
		userSteam += Float(GetProp(player, "slot"));
		if (Contains(GetVar("G_REWARD_LIST"), Text(userSteam)))
		{
			PlayAnim("critical", "look_idle");
			SayText("Sorry, only one training session per customer. Thanks for helping us out of this mess though.");
			exitSub = true;
		}
		if (exitSub)
			return;

		// local RALION_ID $get_by_name(bandit_ralion)
		// if ( !$get(RALION_ID,isalive) ) saytext Ralion maybe dead, but I'll stick to his deal... I'll show you what I know.
		PlayAnim("critical", "look_idle");
		SayText("Alright, here's a few tricks that'll let you show your enemies what-for.");

		float xpGain = 20000.0f;
		float plrAdj = (PlayerCount() - 1.0f) * 0.25f + 1.0f;
		xpGain *= plrAdj;
		LegacyCommand("giveexp", @player, MY_SKILL, int(xpGain));
		PlayerMessageGreen(player, "* " + int(xpGain) + " XP Awarded ( " + MY_SKILL + " )");
		LegacyCommand("token.add", "G_REWARD_LIST", userSteam);

		string outMsg = "You recieve " + MY_SKILL + " from " + NameOf(ENT_ME);
		InfoMessage(player, "Training Recieved", outMsg);
	}

	// bandit_ally_lights
	void OnBanditAllyLights()
	{
		if (!IsAlive(ENT_ME))
			return;
		CallEventDelayed(10.0f, "bandit_ally_lights");
		ClientEvent("new", "all", "effects/sfx_follow_glow_cl", IndexOf(ENT_ME), Vector3(128, 64, 0), 64, 9.9f);
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files

	// npcatk_hunt
	void OnNpcatkHunt()
	{
		BaseBattleAlly_OnNpcatkHunt(); // monsters/base_battle_ally
		BaseAntiStuck_OnNpcatkHunt(); // monsters/base_anti_stuck
	}

	// game_damaged - Return a damage multiplier to scale the damage
	string OnGameDamaged(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float accuracyRoll = 0.0f, CBaseEntity@ inflictor = null, string skill = "")
	{
		string result = "";
		result = AppendResult(result, BaseBattleAlly_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, BaseAntiStuck_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, BaseMonsterShared_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, BaseMonsterShared_OnGameDamaged_2(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		return result;
	}

	// game_death
	void OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		DqMonsterExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // dq/externals/dq_monster_externals
		MonstersExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/externals
		BaseSelfAdjust_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_self_adjust
		BaseNpc_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseMonsterShared_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared
		BanditElite_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/bandit_elite
		BaseChatArray_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_chat_array
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseNpc_OnGameSpawn(playerRace, playerGender); // monsters/base_npc
		BaseNpcAttack_OnGameSpawn(playerRace, playerGender); // monsters/base_npc_attack
		BaseMonsterShared_OnGameSpawn(playerRace, playerGender); // monsters/base_monster_shared
		BaseChatArray_OnGameSpawn(playerRace, playerGender); // monsters/base_chat_array
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		RalionAlly_FirstThink();
		BaseBattleAlly_FirstThink();
		BanditElite_FirstThink();
		BaseNpcAttack_FirstThink();
		BaseNpc_FirstThink();
		MonstersExternals_FirstThink();
		BaseMonsterShared_FirstThink();
		BaseChatArray_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "bandit_ally_boss_dead") { OnBanditAllyBossDead(); return true; }
		if (name == "bandit_ally_drinkup") { OnBanditAllyDrinkup(); return true; }
		if (name == "bandit_ally_fire_spawn") { OnBanditAllyFireSpawn(); return true; }
		if (name == "bandit_ally_fire_spawn3") { OnBanditAllyFireSpawn3(); return true; }
		if (name == "bandit_ally_go_hostile") { OnBanditAllyGoHostile(); return true; }
		if (name == "bandit_ally_lights") { OnBanditAllyLights(); return true; }
		if (name == "bandit_ally_start_follow") { OnBanditAllyStartFollow(); return true; }
		if (name == "bandit_remove_delay") { OnBanditRemoveDelay(); return true; }
		if (name == "bandits_remove") { OnBanditsRemove(); return true; }
		if (name == "check_qualify") { OnCheckQualify(); return true; }
		if (name == "custom_bowey") { OnCustomBowey(); return true; }
		if (name == "do_intro") { OnDoIntro(); return true; }
		if (name == "do_intro2") { OnDoIntro2(); return true; }
		if (name == "game_menu_getoptions") { OnGameMenuGetoptions(PlayerParam(params, 0)); return true; }
		if (name == "game_precache") { OnGamePrecache(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "npcatk_suspend_ai") { OnNpcatkSuspendAi(Param(params, 0), Param(params, 1)); return true; }
		if (name == "play_line2") { OnPlayLine2(); return true; }
		if (name == "play_line3") { OnPlayLine3(); return true; }
		if (name == "play_line4") { OnPlayLine4(); return true; }
		if (name == "play_line5") { OnPlayLine5(); return true; }
		if (name == "play_line6") { OnPlayLine6(); return true; }
		if (name == "say_deal") { OnSayDeal(); return true; }
		if (name == "say_no_deal") { OnSayNoDeal(); return true; }
		if (name == "say_no_deal2") { OnSayNoDeal2(); return true; }
		if (name == "say_reward") { OnSayReward(PlayerParam(params, 0)); return true; }
		if (name == "set_deal_idle") { OnSetDealIdle(); return true; }
		if (name == "stop_follow") { OnStopFollow(); return true; }
		if (name == "tc_get_averages") { OnTcGetAverages(); return true; }
		return BaseBattleAlly_DispatchEvent(name, params)
			|| BaseChatArray_DispatchEvent(name, params)
			|| BanditEliteArcherScript::DispatchEvent(name, params);
	}
}
