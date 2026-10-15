#pragma context server

// Converted from bloodshrine/sorc_shaman_friendly.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/sorc_shaman_elder.as"
#include "converted/monsters/sorc_base.as"
#include "converted/bloodshrine/base_sorc_friendly.as"
#include "converted/monsters/base_chat_array.as"

[script "bloodshrine/sorc_shaman_friendly"]
class SorcShamanFriendly : SorcShamanElderScript, SorcBase, BaseSorcFriendly, BaseChatArray
{
	// Variables declared by included files, with the value they start with in this script
	SorcShamanFriendly()
	{
		CHAT_NO_CLOSE_MOUTH = true;
		CHAT_NEVER_INTERRUPT = true;
		NO_SUMMON = true;
		SWIPE_DAMAGE = "$rand(50,120)";
		FROST_BOLT_DAMAGE = "$rand(80,175)";
		FROST_STRIKE_DAMAGE = "$rand(60,120)";
		NPC_FIGHTS_NPCS = true; // from bloodshrine/base_sorc_friendly
		ANIM_SORCJUMP = "battleaxe_swing1_L"; // from monsters/sorc_base
		FREQ_SORCJUMP = 5.0f; // from monsters/sorc_base
		SORC_MAX_JUMP_RANGE = 600; // from monsters/sorc_base
		ORC_JUMP_RANGE = 512; // from monsters/sorc_base
		ORC_JUMP_CUTOFF = 400; // from monsters/sorc_base
		SORC_TELEPORTS = true; // from monsters/sorc_base
		SORC_LRESIST = 0.75f; // from monsters/sorc_base
		SORC_PRESIST = 1.10f; // from monsters/sorc_base
		NPC_BATTLE_ALLY = true; // from bloodshrine/base_sorc_friendly
		CHAT_CONV_ANIMS = "converse2;converse1;talkleft;talkright;lean;pondering;pondering2;pondering3;"; // from monsters/base_chat_array
		HAS_BASE_CHAT_ARRAY_INCLUDE = true; // from monsters/base_chat_array
		CHAT_USE_BUSY_MESSAGE = true; // from monsters/base_chat_array
		CHAT_MOVE_MOUTH = true; // from monsters/base_chat_array
		CHAT_AUTO_FACE = true; // from monsters/base_chat_array
		CHAT_FACE_ON_USE = true; // from monsters/base_chat_array
		CHAT_MENU_ENABLE = true; // from monsters/base_chat_array
		CHAT_PLAYANIM_STYLE = "critical"; // from monsters/base_chat_array
		CHAT_MAX_LINE_LEN = 192; // from monsters/base_chat_array
		CHAT_DELAY = 4.0f; // from monsters/base_chat_array
	}

	// unnamed block (first think)
	void SorcShamanFriendly_FirstThink()
	{
		FOLLOW_PLR_DIST = 256;

		SKILL_PAGE = 1;
	}

	// orc_spawn
	void OnOrcSpawn()
	{
		OrcBaseRanged_OnOrcSpawn(); // monsters/orc_base_ranged
		SorcShamanElder_OnOrcSpawn(); // monsters/sorc_shaman_elder

		SetName("Meshkhar, the Elder");
		SetUniqueName("fsorc_shaman");
		SetHealth(8000);
		SetHearingSensitivity(8);
		SetDamageTaken("lightning", 0);
		SetDamageTaken("poison", 2);
		SetRace("human");
		SetRoam(false);
		SetWidth(32);
		SetHeight(96);

		SetModel("monsters/sorc.mdl");

		SetModelBody(1, 0); // body: 0=bare 1=bloody_shirt 2=gold_armor 3=archer
		SetModelBody(1, 4); // head: 0=hat_horns 1=hat_spiked 2=lizardskin_horned 3=gold_Chieftain 4=lizard_cap
		SetModelBody(2, 0); // weapon: 0=unarmed 1=axe 2=bow 3=steel_bow 4=sword 5=great_axe 6=sword_sheild 8=yellow_axe 9=blooddrinker
	}

	// npcatk_hunt
	void OnNpcatkHunt()
	{
		BaseNpcAttackNew_OnNpcatkHunt(); // monsters/base_npc_attack_new
		BaseAntiStuck_OnNpcatkHunt(); // monsters/base_anti_stuck
		BaseLightningShield_OnNpcatkHunt(); // monsters/base_lightning_shield
		SorcShamanElder_OnNpcatkHunt(); // monsters/sorc_shaman_elder
		SorcBase_OnNpcatkHunt(); // monsters/sorc_base
		BaseSorcFriendly_OnNpcatkHunt(); // bloodshrine/base_sorc_friendly
		if (NPCATK_TARGET == "unset")
			return;

		BALL_TYPE = "lightning";
		if (DamageTakenOf(NPCATK_TARGET, "lightning") == 0.0f)
			BALL_TYPE = "holy";
	}

	// ext_shadowform_boss
	void OnExtShadowformBoss()
	{
		BaseSorcFriendly_OnExtShadowformBoss(); // bloodshrine/base_sorc_friendly
		BALL_DMG = Divide(BALL_DMG, 3.0f);
		CallEventDelayed(10.0f, "ext_shadowform_boss2");
	}

	// ext_boss_dead
	void OnExtBossDead()
	{
		BaseSorcFriendly_OnExtBossDead(); // bloodshrine/base_sorc_friendly
		REWARDS_LEFT = 0.0f;
		PLAYERS_TO_REWARD = "";
		SetVar("REWARD_PLAYER_LIST", GetActivePlayers());
		if (!SETUP_QUALIFICATIONS)
		{
			SETUP_QUALIFICATIONS = true;
			OnCheckQualify();
		}
		int count = GetTokenCount("REWARD_PLAYER_LIST");
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnGatherRewardPlayers();
		}
	}

	// ext_shaman_lines
	void OnExtShamanLines()
	{
		@LEADER_ID = FindByName("fsorc_leader");
		FOLLOW_PLR_ID = ScriptVarOf(LEADER_ID, "FOLLOW_PLR_ID");
		OnBfsorcFollowClose();
		OnChatNow("Yes... And then some of us, began to change, and were taken away.", "5.0", "nod_yes", "release_zorc", "add_to_que");
		OnChatNow("We were once a force of nine, but now, we are but four...", "5.0", "neigh", "add_to_que");
	}

	// release_zorc
	void OnReleaseZorc()
	{
		OnBfsorcFollowNormal();
		UseTrigger("sorc_door2");
		CallEventDelayed(5.0f, "release_zorc2");
	}

	// release_zorc2
	void OnReleaseZorc2()
	{
		@SECOND_ID = FindByName("fsorc_second");
		CallExternal(SECOND_ID, "ext_zombie_react");
	}

	// alert_shadowforms
	void OnAlertShadowforms()
	{
		bool leaderAlive = false;
		bool secondAlive = false;
		bool doReadyComment = false;
		if (DID_SHADOWFORM)
			return;
		@T_LEADER_ID = FindByName("fsorc_leader");
		@T_SECOND_ID = FindByName("fsorc_second");
		DID_SHADOWFORM = true;
		OnChatNow("Wait... This scent...", "5.0", "add_to_que");
		OnChatNow("One of the old dark ones lairs here...", "4.0", "warcry", "add_to_que");
		if (IsAlive(T_LEADER_ID))
			leaderAlive = true;
		if (IsAlive(T_SECOND_ID))
			secondAlive = true;
		if (leaderAlive)
		{
			if (!secondAlive)
				OnChatNow("Brindahr, wait here. Your weapon will be useless against it.", "4.0", "add_to_que");
			if (secondAlive)
				OnChatNow("You two wait here. Your weapons will be useless against it.", "4.0", "add_to_que");
		}
		if (!leaderAlive && secondAlive)
			OnChatNow("Vurinahr, wait here. Your weapon will be useless against it.", "4.0", "add_to_que");

		if (leaderAlive)
			doReadyComment = true;
		if (secondAlive)
			doReadyComment = true;
		if (doReadyComment)
			OnChatNow("I, on the other hand, have a trick or two for just such creatures.", "4.0", "none", "set_warrior_wait", "add_to_que");
		else
			OnChatNow("I have a trick or two for just such creatures...", "4.0", "none", "set_warrior_wait", "add_to_que");
	}

	// set_warrior_wait
	void OnSetWarriorWait()
	{
		@LEADER_ID = FindByName("fsorc_leader");
		@SECOND_ID = FindByName("fsorc_second");
		CallExternal(LEADER_ID, "fsorc_wait", Vector3(1616, -1348, -128));
		CallExternal(SECOND_ID, "fsorc_wait", Vector3(1616, -1428, -128));
	}

	// ext_shadowform_boss2
	void OnExtShadowformBoss2()
	{
		bool leaderAlive = false;
		bool secondAlive = false;
		@T_LEADER_ID = FindByName("fsorc_leader");
		@T_SECOND_ID = FindByName("fsorc_second");
		OnChatNow("This creature is immune to our weaponry - you must use holy weapons and banishing magics!", "5.0", "add_to_que");
		OnChatNow("It's only vulnerable when the eye looks upon us! BEWARE THE EYE!", "5.0", "add_to_que");
		if (IsAlive(T_LEADER_ID))
			leaderAlive = true;
		if (IsAlive(T_SECOND_ID))
			secondAlive = true;
		if (leaderAlive)
		{
			if (!secondAlive)
				OnChatNow("Brindahr - concentrate on the undead! The humans and I will strike at the eye of the beast!", "5.0", "add_to_que");
			if (secondAlive)
				OnChatNow("Shadahar warriors - concentrate on the undead! The humans and I will strike at the eye of the beast!", "5.0", "add_to_que");
		}
		if (!leaderAlive && secondAlive)
			OnChatNow("Vurinahr - concentrate on the undead! The humans and I will strike at the eye of the beast!", "5.0", "add_to_que");
	}

	// ext_return_comment
	void OnExtReturnComment()
	{
		OnChatNow("If we can find the source of evil in this place, and destroy it, we should be able to return home through the ways.", "5.0", "nod_yes", "add_to_que");
	}

	// ext_wait_sfs_loop
	void OnExtWaitSfsLoop()
	{
		if (DID_SHADOWFORM)
			return;
		Vector3 myOrg = OriginOf(ENT_ME);
		if (Distance(SFS_ENTRANCE_POINT, myOrg) < 256.0f)
			OnAlertShadowforms();
		if (DID_SHADOWFORM)
			return;
		CallEventDelayed(0.1f, "ext_wait_sfs_loop");
	}

	// give_reward_options
	void OnGiveRewardOptions(CBaseEntity@ player = null)
	{
		MenuItem menuItem;

		DebugPrint("give_reward_options " + Text(REWARDS_LEFT) + " vs REWARDS_TOTAL list " + PLAYERS_TO_REWARD + " vs " + EntityId(player));
		if (!(REWARDS_LEFT > 0.0f))
			return;

		if (!Contains(PLAYERS_TO_REWARD, EntityId(player)))
			return;

		if (!DOING_SWITCH_PAGE)
			OnChatNow("I can use my magics to enhance one of your skills, please select which one.", "3.0", "neigh", "add_to_que");
		DOING_SWITCH_PAGE = false;

		if (SKILL_PAGE == 1)
		{
			menuItem.title = "Archery";
			menuItem.type = "callback";
			menuItem.data = "archery";
			menuItem.callback = "enhance_skill";
			RegisterMenuItem(menuItem);

			menuItem.title = "Axe Handling";
			menuItem.type = "callback";
			menuItem.data = "axehandling";
			menuItem.callback = "enhance_skill";
			RegisterMenuItem(menuItem);

			menuItem.title = "Bluntarms";
			menuItem.type = "callback";
			menuItem.data = "bluntarms";
			menuItem.callback = "enhance_skill";
			RegisterMenuItem(menuItem);

			menuItem.title = "Martial Arts";
			menuItem.type = "callback";
			menuItem.data = "martialarts";
			menuItem.callback = "enhance_skill";
			RegisterMenuItem(menuItem);

			menuItem.title = "Polearms";
			menuItem.type = "callback";
			menuItem.data = "polearms";
			menuItem.callback = "enhance_skill";

			menuItem.title = "Smallarms";
			menuItem.type = "callback";
			menuItem.data = "smallarms";
			menuItem.callback = "enhance_skill";
			RegisterMenuItem(menuItem);

			menuItem.title = "Swordsmanship";
			menuItem.type = "callback";
			menuItem.data = "swordsmanship";
			menuItem.callback = "enhance_skill";
			RegisterMenuItem(menuItem);

			menuItem.title = "Spellcasting...";
			menuItem.type = "callback";
			menuItem.callback = "switch_page2";
			RegisterMenuItem(menuItem);
		}

		if (SKILL_PAGE == 2)
		{
			menuItem.title = "Fire";
			menuItem.type = "callback";
			menuItem.data = "spellcasting.fire";
			menuItem.callback = "enhance_skill";
			RegisterMenuItem(menuItem);

			menuItem.title = "Ice";
			menuItem.type = "callback";
			menuItem.data = "spellcasting.ice";
			menuItem.callback = "enhance_skill";
			RegisterMenuItem(menuItem);

			menuItem.title = "Lightning";
			menuItem.type = "callback";
			menuItem.data = "spellcasting.lightning";
			menuItem.callback = "enhance_skill";
			RegisterMenuItem(menuItem);

			menuItem.title = "Affliction";
			menuItem.type = "callback";
			menuItem.data = "spellcasting.affliction";
			menuItem.callback = "enhance_skill";
			RegisterMenuItem(menuItem);

			menuItem.title = "Divination";
			menuItem.type = "callback";
			menuItem.data = "spellcasting.divination";
			menuItem.callback = "enhance_skill";
			RegisterMenuItem(menuItem);

			menuItem.title = "(previous)";
			menuItem.type = "callback";
			menuItem.callback = "switch_page1";
			RegisterMenuItem(menuItem);
		}
	}

	// switch_page2
	void OnSwitchPage2(CBasePlayer@ target = null)
	{
		DOING_SWITCH_PAGE = true;
		SKILL_PAGE = 2;
		@SFORC_MENU_TARGET = target;
		CallEventDelayed(0.5f, "sforc_offer_menu");
	}

	// switch_page1
	void OnSwitchPage1(CBasePlayer@ target = null)
	{
		DOING_SWITCH_PAGE = true;
		SKILL_PAGE = 1;
		@SFORC_MENU_TARGET = target;
		CallEventDelayed(0.5f, "sforc_offer_menu");
	}

	// enhance_skill
	void OnEnhanceSkill(CBasePlayer@ playerId = null, string skill = "")
	{
		float xpGain;
		float plrAdj;
		OnChatNow("So be it. It is done.", "3.0", "warcry", "add_to_que");
		int findIndx = FindToken(PLAYERS_TO_REWARD, EntityId(playerId));
		PLAYERS_TO_REWARD = TokenRemove(PLAYERS_TO_REWARD, findIndx);
		REWARDS_LEFT -= 1.0f;
		Effect("glow", ENT_ME, "glow", Vector3(255, 255, 0), 64, 1, 1);
		if (skill != "spellcasting.lightning")
		{
			xpGain = 5000.0f;
			plrAdj = (ActivePlayerCount() - 1.0f) * 0.25f + 1.0f;
			xpGain *= plrAdj;
			LegacyCommand("giveexp", @playerId, skill, int(xpGain));
			PlayerMessageGreen(playerId, "* " + int(xpGain) + " XP Awarded ( " + skill + " )");
		}
		else
		{
			xpGain = 10000.0f;
			plrAdj = (ActivePlayerCount() - 1.0f) * 0.25f + 1.0f;
			xpGain *= plrAdj;
			LegacyCommand("giveexp", @playerId, skill, int(xpGain));
			PlayerMessageGreen(playerId, "* " + int(xpGain) + " XP Awarded ( " + skill + " )");
		}
		if (REWARDS_LEFT != 0.0f)
			return;
		CallEventDelayed(6.0f, "ready_to_go");
	}

	// sforc_offer_menu
	void OnSforcOfferMenu()
	{
		OpenMenu(SFORC_MENU_TARGET);
	}

	// gather_reward_players
	void OnGatherRewardPlayers()
	{
		bool plrQualified = false;
		CBasePlayer@ curPlayer = FindPlayer(GetToken("REWARD_PLAYER_LIST", loopIteration));
		int dmgPts = Int(ScriptVarOf(curPlayer, "PLR_TOTAL_DMG"));
		if (dmgPts >= TC_HALF_AVG_DMG_PTS)
			plrQualified = true;
		if (!plrQualified)
			return;
		PLAYERS_TO_REWARD = TokenAdd(PLAYERS_TO_REWARD, EntityId(curPlayer));
		REWARDS_LEFT += 1.0f;
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files
	void OnOrcDeath() { OrcBaseRanged_OnOrcDeath(); } // orc_death

	// npc_targetsighted
	void OnNpcTargetsighted(string target = "")
	{
		OrcBaseRanged_OnNpcTargetsighted(target); // monsters/orc_base_ranged
		BaseMonsterShared_OnNpcTargetsighted(target); // monsters/base_monster_shared
		SorcBase_OnNpcTargetsighted(target); // monsters/sorc_base
	}

	// game_death
	void OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		DqMonsterExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // dq/externals/dq_monster_externals
		MonstersExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/externals
		BaseSelfAdjust_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_self_adjust
		BaseNpc_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseMonsterShared_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared
		OrcBase_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/orc_base
		BaseLightningShield_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_lightning_shield
		SorcBase_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/sorc_base
		BaseChatArray_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_chat_array
	}

	// game_damaged_other
	string OnGameDamagedOther(CBaseEntity@ target = null, float damage = 0.0f, string damageType = "", string damageEvent = "")
	{
		string result = "";
		result = AppendResult(result, MonstersExternals_OnGameDamagedOther(target, damage, damageType, damageEvent));
		result = AppendResult(result, BaseAntiStuck_OnGameDamagedOther(target, damage, damageType, damageEvent));
		result = AppendResult(result, BaseMonsterShared_OnGameDamagedOther(target, damage, damageType, damageEvent));
		result = AppendResult(result, OrcBase_OnGameDamagedOther(target, damage, damageType, damageEvent));
		result = AppendResult(result, SorcBase_OnGameDamagedOther(target, damage, damageType, damageEvent));
		result = AppendResult(result, BaseSorcFriendly_OnGameDamagedOther(target, damage, damageType, damageEvent));
		return result;
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
		OrcBase_OnNpcPostSpawn(); // monsters/orc_base
		SorcShamanElder_OnNpcPostSpawn(); // monsters/sorc_shaman_elder
		SorcBase_OnNpcPostSpawn(); // monsters/sorc_base
		SorcBase_OnNpcPostSpawn_2(); // monsters/sorc_base
		BaseSorcFriendly_OnNpcPostSpawn(); // bloodshrine/base_sorc_friendly
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseNpc_OnGameSpawn(playerRace, playerGender); // monsters/base_npc
		BaseMonsterShared_OnGameSpawn(playerRace, playerGender); // monsters/base_monster_shared
		SorcBase_OnGameSpawn(playerRace, playerGender); // monsters/sorc_base
		BaseChatArray_OnGameSpawn(playerRace, playerGender); // monsters/base_chat_array
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseNpcAttackNew_OnNpcSpawn(npc); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck
		OrcBase_OnNpcSpawn(npc); // monsters/orc_base
		SorcBase_OnNpcSpawn(npc); // monsters/sorc_base
	}

	// npcatk_settarget
	void OnNpcatkSettarget(string target = "", string debug = "")
	{
		BaseNpcAttackNew_OnNpcatkSettarget(target, debug); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcatkSettarget(target, debug); // monsters/base_monster_shared
	}

	// npcatk_targetvalidate
	void OnNpcatkTargetvalidate(string target = "")
	{
		BaseNpcAttackNew_OnNpcatkTargetvalidate(target); // monsters/base_npc_attack_new
		OrcBase_OnNpcatkTargetvalidate(target); // monsters/orc_base
		SorcBase_OnNpcatkTargetvalidate(target); // monsters/sorc_base
	}

	// npcatk_suspend_ai
	void OnNpcatkSuspendAi(string seconds = "", string debugTag = "")
	{
		BaseNpcAttackNew_OnNpcatkSuspendAi(seconds, debugTag); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcatkSuspendAi(seconds, debugTag); // monsters/base_monster_shared
	}

	// game_damaged - Return a damage multiplier to scale the damage
	string OnGameDamaged(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float accuracyRoll = 0.0f, CBaseEntity@ inflictor = null, string skill = "")
	{
		string result = "";
		result = AppendResult(result, BaseAntiStuck_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, BaseMonsterShared_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, BaseMonsterShared_OnGameDamaged_2(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, BaseSorcFriendly_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, BaseSorcFriendly_OnGameDamaged_2(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		return result;
	}

	// game_parry
	void OnGameParry(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float parryRoll = 0.0f, float accuracyRoll = 0.0f, float parryValue = 0.0f)
	{
		BaseMonsterShared_OnGameParry(attacker, damage, damageType, parryRoll, accuracyRoll, parryValue); // monsters/base_monster_shared
		OrcBase_OnGameParry(attacker, damage, damageType, parryRoll, accuracyRoll, parryValue); // monsters/orc_base
		SorcBase_OnGameParry(attacker, damage, damageType, parryRoll, accuracyRoll, parryValue); // monsters/sorc_base
	}

	// npc_death
	void OnNpcDeath()
	{
		OrcBase_OnNpcDeath(); // monsters/orc_base
		SorcShamanElder_OnNpcDeath(); // monsters/sorc_shaman_elder
		SorcBase_OnNpcDeath(); // monsters/sorc_base
	}

	// npc_struck
	void OnNpcStruck(float damage = 0.0f)
	{
		OrcBase_OnNpcStruck(damage); // monsters/orc_base
		SorcShamanElder_OnNpcStruck(damage); // monsters/sorc_shaman_elder
		SorcBase_OnNpcStruck(damage); // monsters/sorc_base
	}

	// sound_struck
	void OnSoundStruck()
	{
		OrcBase_OnSoundStruck(); // monsters/orc_base
		SorcBase_OnSoundStruck(); // monsters/sorc_base
	}

	// baseorc_yell
	void OnBaseorcYell()
	{
		OrcBase_OnBaseorcYell(); // monsters/orc_base
		SorcBase_OnBaseorcYell(); // monsters/sorc_base
	}

	// npc_aiding_ally
	void OnNpcAidingAlly(CBaseEntity@ allyToAid = null, string caller = "")
	{
		OrcBase_OnNpcAidingAlly(allyToAid, caller); // monsters/orc_base
		SorcBase_OnNpcAidingAlly(allyToAid, caller); // monsters/sorc_base
	}

	// game_menu_getoptions
	void OnGameMenuGetoptions(CBasePlayer@ player = null)
	{
		BaseSorcFriendly_OnGameMenuGetoptions(player); // bloodshrine/base_sorc_friendly
		BaseChatArray_OnGameMenuGetoptions(player); // monsters/base_chat_array
	}

	void OnChatNow(string text = "", string displayTime = "", string animation = "", string eventName = "", string sound = "", string sound2 = "", string sound3 = "", string sound4 = "") { BaseChatArray_OnChatNow(text, displayTime, animation, eventName, sound, sound2, sound3, sound4); } // chat_now

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		SorcShamanFriendly_FirstThink();
		SorcShamanElder_FirstThink();
		OrcBaseRanged_FirstThink();
		OrcBase_FirstThink();
		BaseNpc_FirstThink();
		MonstersExternals_FirstThink();
		BaseNpcAttackNew_FirstThink();
		BaseMonsterShared_FirstThink();
		BaseLightningShield_FirstThink();
		SorcBase_FirstThink();
		SorcBase_FirstThink2();
		BaseSorcFriendly_FirstThink();
		BaseChatArray_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "alert_shadowforms") { OnAlertShadowforms(); return true; }
		if (name == "enhance_skill") { OnEnhanceSkill(PlayerParam(params, 0), Param(params, 1)); return true; }
		if (name == "ext_boss_dead") { OnExtBossDead(); return true; }
		if (name == "ext_return_comment") { OnExtReturnComment(); return true; }
		if (name == "ext_shadowform_boss") { OnExtShadowformBoss(); return true; }
		if (name == "ext_shadowform_boss2") { OnExtShadowformBoss2(); return true; }
		if (name == "ext_shaman_lines") { OnExtShamanLines(); return true; }
		if (name == "ext_wait_sfs_loop") { OnExtWaitSfsLoop(); return true; }
		if (name == "gather_reward_players") { OnGatherRewardPlayers(); return true; }
		if (name == "give_reward_options") { OnGiveRewardOptions(EntityParam(params, 0)); return true; }
		if (name == "npcatk_hunt") { OnNpcatkHunt(); return true; }
		if (name == "orc_spawn") { OnOrcSpawn(); return true; }
		if (name == "release_zorc") { OnReleaseZorc(); return true; }
		if (name == "release_zorc2") { OnReleaseZorc2(); return true; }
		if (name == "set_warrior_wait") { OnSetWarriorWait(); return true; }
		if (name == "sforc_offer_menu") { OnSforcOfferMenu(); return true; }
		if (name == "switch_page1") { OnSwitchPage1(PlayerParam(params, 0)); return true; }
		if (name == "switch_page2") { OnSwitchPage2(PlayerParam(params, 0)); return true; }
		return SorcBase_DispatchEvent(name, params)
			|| BaseSorcFriendly_DispatchEvent(name, params)
			|| BaseChatArray_DispatchEvent(name, params)
			|| SorcShamanElderScript::DispatchEvent(name, params);
	}
}
