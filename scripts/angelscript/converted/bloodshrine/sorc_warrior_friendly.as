#pragma context server

// Converted from bloodshrine/sorc_warrior_friendly.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/sorc_warrior.as"
#include "converted/bloodshrine/base_sorc_friendly.as"
#include "converted/monsters/base_chat_array.as"

[script "bloodshrine/sorc_warrior_friendly"]
class SorcWarriorFriendly : SorcWarriorScript, BaseSorcFriendly, BaseChatArray
{
	// Variables (an unset .script variable reads as its own name)
	CBaseEntity@ SECOND_ID = null;
	bool CHAT_TEMP_NO_AUTO_FACE = false;
	CBaseEntity@ SHAMAN_ID = null;
	bool DID_WAIT_COMMENT = false;

	// Variables declared by included files, with the value they start with in this script
	SorcWarriorFriendly()
	{
		DOT_THROW_SHOCK = 120.0f;
		DOT_SHOCK = 60.0f;
		CHAT_NO_CLOSE_MOUTH = true;
		CHAT_NEVER_INTERRUPT = true;
		NPC_EXTRA_VALIDATIONS = true;
		NPC_FIGHTS_NPCS = true; // from bloodshrine/base_sorc_friendly
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

	// orc_spawn
	void OnOrcSpawn()
	{
		OrcBaseMelee_OnOrcSpawn(); // monsters/orc_base_melee
		SorcWarrior_OnOrcSpawn(); // monsters/sorc_warrior

		SetName("Brindahr, the Warleader");
		SetUniqueName("fsorc_leader");
		SetModel("monsters/sorc.mdl");
		SetHealth(8000);
		SetDamageTaken("all", 0.5f);
		SetStat("parry", 110);
		SetRace("human");
		SetRoam(false);

		SetWidth(32);
		SetHeight(96);

		SetModelBody(0, 2); // body: 0=bare 1=bloody_shirt 2=gold_armor 3=archer
		SetModelBody(1, 2); // head: 0=hat_horns 1=hat_spiked 2=lizardskin_horned 3=gold_Chieftain 4=lizard_cap
		SetModelBody(2, 7); // weapon: 0=unarmed 1=axe 2=bow 3=steel_bow 4=sword 5=great_axe 6=sword_sheild 8=yellow_axe 9=blooddrinker
	}

	// npc_targetvalidate
	void OnNpcTargetvalidate(CBaseEntity@ target = null)
	{
		BaseMonsterShared_OnNpcTargetvalidate(target); // monsters/base_monster_shared
		if (NPCATK_TARGET == EntityId(SBOSS_ID))
			NPCATK_TARGET = "unset";
	}

	// fsorc_wait
	void OnFsorcWait(Vector3 waitPosition = Vector3())
	{
		BaseSorcFriendly_OnFsorcWait(waitPosition); // bloodshrine/base_sorc_friendly
		if (DID_WAIT_COMMENT)
			return;
		DID_WAIT_COMMENT = true;
		CallEventDelayed(1.0f, "fsorc_wait_comment");
	}

	// fsorc_zombie_alert
	void OnFsorcZombieAlert(CBaseEntity@ zombie = null)
	{
		BaseSorcFriendly_OnFsorcZombieAlert(zombie); // bloodshrine/base_sorc_friendly
		OnNpcatkResumeAi();
		CallEventDelayed(3.0f, "ash_comment");
		SetMoveAnim(ANIM_RUN);
		@ZOMBIE_ID = zombie;
		OnNpcatkSettarget(EntityId(ZOMBIE_ID));
		NPCATK_TARGET = EntityId(ZOMBIE_ID);
		SetMoveDest(@ZOMBIE_ID, 64);
	}

	// ext_do_leader_intro
	void OnExtDoLeaderIntro()
	{
		// <text> [time] [anim|"none"] [event|"none"] ["clear_que"] ["add_to_que"]
		OnChatNow("Wait!", "3.0", "neigh", "bfsorc_follow_close", "add_to_que");
		OnChatNow("I know you... You are of the humans who fought beside Chief Runegahr!", "5.0", "none", "face_second", "add_to_que");
		OnChatNow("Surely they will help us escape this accursed place!", "3.0", "none", "add_to_que");
		OnChatNow("We were exploring, outside these ruins, when a great shadow fell upon us.", "4.0", "add_to_que");
		OnChatNow("When we awoke, we found ourselves imprisoned here...", "4.0", "none", "call_shaman_lines", "add_to_que");
	}

	// face_second
	void OnFaceSecond()
	{
		@SECOND_ID = FindByName("fsorc_second");
		CHAT_TEMP_NO_AUTO_FACE = true;
		SetMoveDest(@SECOND_ID, 9999);
		OnNpcatkSuspendAi();
		CallEventDelayed(0.1f, "shew_second");
		CallEventDelayed(2.0f, "resume_faceing_speaker");
		CallEventDelayed(2.5f, "chat_face_speaker");
		OnBfsorcFollowNormal();
	}

	// resume_faceing_speaker
	void OnResumeFaceingSpeaker()
	{
		CHAT_TEMP_NO_AUTO_FACE = false;
	}

	// shew_second
	void OnShewSecond()
	{
		SetMoveDest(@SECOND_ID, 9999);
		PlayAnim("critical", "swordswing1_L");
	}

	// call_shaman_lines
	void OnCallShamanLines()
	{
		CallEventDelayed(1.0f, "call_shaman_lines2");
	}

	// call_shaman_lines2
	void OnCallShamanLines2()
	{
		@SHAMAN_ID = FindByName("fsorc_shaman");
		SetMoveDest(@SHAMAN_ID, 9999);
		CallEventDelayed(2.5f, "chat_face_speaker");
		CallExternal(SHAMAN_ID, "ext_shaman_lines");
	}

	// ash_comment
	void OnAshComment()
	{
		OnChatNow("To battle! Rend his cursed corpse until it ceases to move!", "3.0", "warcry", "add_to_que");
	}

	// ext_leader_ash
	void OnExtLeaderAsh()
	{
		if (DID_ASHINKAHR)
			return;
		DID_ASHINKAHR = true;
		CallEventDelayed(3.0f, "ext_leader_ash2");
	}

	// ext_leader_ash2
	void OnExtLeaderAsh2()
	{
		OnChatNow("Yes... Lead on, we shall follow.", "3.0", "add_to_que");
		CallEventDelayed(3.0f, "sham_comment");
	}

	// sham_comment
	void OnShamComment()
	{
		CallExternal(SHAMAN_ID, "ext_return_comment");
	}

	// fsorc_wait_comment
	void OnFsorcWaitComment()
	{
		OnChatNow("Very well. We trust in your judgement, elder.", "3.0", "nod_yes");
	}

	// give_reward_options
	void OnGiveRewardOptions(CBaseEntity@ player = null)
	{
		MenuItem menuItem;
		if (GAVE_REWARD)
			return;
		menuItem.title = "Gather Reward";
		menuItem.type = "callback";
		menuItem.callback = "give_reward";
		RegisterMenuItem(menuItem);
	}

	// give_reward
	void OnGiveReward(CBasePlayer@ player = null)
	{
		GAVE_REWARD = true;
		Offer(player, "axes_gthunder11");
		OnChatNow("It's a meager reward, for such a warrior, but I'm sure you'll make good use of it.", "3.0", "nod_yes");
		CallEventDelayed(6.0f, "ready_to_go");
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

	// npcatk_hunt
	void OnNpcatkHunt()
	{
		BaseNpcAttackNew_OnNpcatkHunt(); // monsters/base_npc_attack_new
		BaseAntiStuck_OnNpcatkHunt(); // monsters/base_anti_stuck
		SorcBase_OnNpcatkHunt(); // monsters/sorc_base
		BaseSorcFriendly_OnNpcatkHunt(); // bloodshrine/base_sorc_friendly
	}

	// npcatk_settarget
	void OnNpcatkSettarget(string target = "", string debug = "")
	{
		BaseNpcAttackNew_OnNpcatkSettarget(target, debug); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcatkSettarget(target, debug); // monsters/base_monster_shared
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
		SorcWarrior_FirstThink();
		OrcBaseMelee_FirstThink();
		SorcBase_FirstThink();
		BaseNpc_FirstThink();
		MonstersExternals_FirstThink();
		BaseNpcAttackNew_FirstThink();
		BaseMonsterShared_FirstThink();
		SorcBase_FirstThink2();
		BaseSorcFriendly_FirstThink();
		BaseChatArray_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "ash_comment") { OnAshComment(); return true; }
		if (name == "call_shaman_lines") { OnCallShamanLines(); return true; }
		if (name == "call_shaman_lines2") { OnCallShamanLines2(); return true; }
		if (name == "ext_do_leader_intro") { OnExtDoLeaderIntro(); return true; }
		if (name == "ext_leader_ash") { OnExtLeaderAsh(); return true; }
		if (name == "ext_leader_ash2") { OnExtLeaderAsh2(); return true; }
		if (name == "face_second") { OnFaceSecond(); return true; }
		if (name == "fsorc_wait") { OnFsorcWait(Vec(Param(params, 0))); return true; }
		if (name == "fsorc_wait_comment") { OnFsorcWaitComment(); return true; }
		if (name == "fsorc_zombie_alert") { OnFsorcZombieAlert(EntityParam(params, 0)); return true; }
		if (name == "give_reward") { OnGiveReward(PlayerParam(params, 0)); return true; }
		if (name == "give_reward_options") { OnGiveRewardOptions(EntityParam(params, 0)); return true; }
		if (name == "npc_targetvalidate") { OnNpcTargetvalidate(EntityParam(params, 0)); return true; }
		if (name == "orc_spawn") { OnOrcSpawn(); return true; }
		if (name == "resume_faceing_speaker") { OnResumeFaceingSpeaker(); return true; }
		if (name == "sham_comment") { OnShamComment(); return true; }
		if (name == "shew_second") { OnShewSecond(); return true; }
		return BaseSorcFriendly_DispatchEvent(name, params)
			|| BaseChatArray_DispatchEvent(name, params)
			|| SorcWarriorScript::DispatchEvent(name, params);
	}
}
