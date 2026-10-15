#pragma context server

// Converted from bloodshrine/sorc_warrior2_friendly.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/sorc_warrior.as"
#include "converted/bloodshrine/base_sorc_friendly.as"
#include "converted/monsters/base_chat_array.as"

[script "bloodshrine/sorc_warrior2_friendly"]
class SorcWarrior2Friendly : SorcWarriorScript, BaseSorcFriendly, BaseChatArray
{
	// Variables (an unset .script variable reads as its own name)
	int DID_INTRO = 0;
	CBaseEntity@ LEADER_ID = null;

	// Variables declared by included files, with the value they start with in this script
	SorcWarrior2Friendly()
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

		SetName("Shadahar Lieutenant");
		SetUniqueName("fsorc_second");
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

	// my_target_died
	void OnMyTargetDied(string offender = "")
	{
		OrcBaseMelee_OnMyTargetDied(offender); // monsters/orc_base_melee
		BaseNpcAttackNew_OnMyTargetDied(offender); // monsters/base_npc_attack_new
		if (DID_ASHINKAHR)
			return;
		DID_ASHINKAHR = true;
		OnNpcatkSuspendAi("3.0");
		OnChatNow("That should put him to rest once and for all.", "3.0", "add_to_que");
		CallExternal(LEADER_ID, "ext_leader_ash");
	}

	// npcatk_hunt
	void OnNpcatkHunt()
	{
		BaseNpcAttackNew_OnNpcatkHunt(); // monsters/base_npc_attack_new
		BaseAntiStuck_OnNpcatkHunt(); // monsters/base_anti_stuck
		SorcBase_OnNpcatkHunt(); // monsters/sorc_base
		BaseSorcFriendly_OnNpcatkHunt(); // bloodshrine/base_sorc_friendly
		if (DID_INTRO == 0 && CanSee("player"))
		{
			CHAT_CURRENT_SPEAKER = EntityId(EntityOf(ENT_LASTSEEN));
			if (!IsAlive(ENT_LASTSEEN))
			{
				CHAT_CURRENT_SPEAKER = FindInSphere("player", 512);
				CHAT_CURRENT_SPEAKER = SortEntities(CHAT_CURRENT_SPEAKER, "range");
				CHAT_CURRENT_SPEAKER = GetToken(CHAT_CURRENT_SPEAKER, 0);
			}
			FOLLOW_PLR_ID = CHAT_CURRENT_SPEAKER;
			FOLLOW_PLR_DIST = 200;
			DID_INTRO = 1;
			OnDoIntro();
		}
	}

	// npc_targetvalidate
	void OnNpcTargetvalidate(CBaseEntity@ target = null)
	{
		BaseMonsterShared_OnNpcTargetvalidate(target); // monsters/base_monster_shared
		if (NPCATK_TARGET == EntityId(SBOSS_ID))
			NPCATK_TARGET = "unset";
	}

	// do_intro
	void OnDoIntro()
	{
		OnChatNow("Humans!? Attack!!!", "3.0", ANIM_ATTACK, "add_to_que");
		CallEventDelayed(1.0f, "leader_interrupt");
	}

	// leader_interrupt
	void OnLeaderInterrupt()
	{
		@LEADER_ID = FindByName("fsorc_leader");
		SetMoveDest(@LEADER_ID, 9999);
		CallExternal(LEADER_ID, "ext_do_leader_intro");
	}

	// ext_zombie_react
	void OnExtZombieReact()
	{
		SetName("Vurinahr, the Lieutenant");
		string findZombie = FindInSphere("enemy", 1024);
		@ZOMBIE_ID = FindEntity(GetToken(findZombie, 0));
		OnNpcatkSettarget(EntityId(ZOMBIE_ID));
		NPCATK_TARGET = EntityId(ZOMBIE_ID);
		SetMoveDest(@ZOMBIE_ID, 64);
		CallEventDelayed(1.5f, "alert_others");
		OnBfsorcFollowNormal();
		OnChatNow("Make that three! Ashinkahr has changed!", "3.0", ANIM_ATTACK, "add_to_que");
	}

	// alert_others
	void OnAlertOthers()
	{
		CallExternal("all", "fsorc_zombie_alert", @ZOMBIE_ID);
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
		Offer(player, "axes_thunder11");
		OnChatNow("It's a meager reward, for bravery, but I'm sure you'll find one who make use of it.", "3.0", "nod_yes");
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
		if (name == "alert_others") { OnAlertOthers(); return true; }
		if (name == "do_intro") { OnDoIntro(); return true; }
		if (name == "ext_zombie_react") { OnExtZombieReact(); return true; }
		if (name == "give_reward") { OnGiveReward(PlayerParam(params, 0)); return true; }
		if (name == "give_reward_options") { OnGiveRewardOptions(EntityParam(params, 0)); return true; }
		if (name == "leader_interrupt") { OnLeaderInterrupt(); return true; }
		if (name == "my_target_died") { OnMyTargetDied(Param(params, 0)); return true; }
		if (name == "npc_targetvalidate") { OnNpcTargetvalidate(EntityParam(params, 0)); return true; }
		if (name == "npcatk_hunt") { OnNpcatkHunt(); return true; }
		if (name == "orc_spawn") { OnOrcSpawn(); return true; }
		return BaseSorcFriendly_DispatchEvent(name, params)
			|| BaseChatArray_DispatchEvent(name, params)
			|| SorcWarriorScript::DispatchEvent(name, params);
	}
}
