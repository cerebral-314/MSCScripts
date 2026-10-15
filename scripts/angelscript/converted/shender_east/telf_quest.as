#pragma context server

// Converted from shender_east/telf_quest.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_chat_array.as"
#include "converted/monsters/base_npc.as"

[script "shender_east/telf_quest"]
class TelfQuest : BaseNpcScript, BaseChatArray
{
	// Constants
	bool CHAT_USE_CONV_ANIMS = false;
	string SOUND_PAIN1 = "scientist/getoutalive.wav";
	string SOUND_PAIN2 = "scientist/iwoundedbad.wav";

	// Variables (an unset .script variable reads as its own name)
	Vector3 HBAR_ADJ_POS = Vector3();
	bool NPC_BATTLE_ALLY = false;
	float HALF_HP = 0.0f;
	string PLAYER_LIST = "PLAYER_LIST";
	int DID_INTRO = 0;
	string CHAT_CURRENT_SPEAKER = "CHAT_CURRENT_SPEAKER";
	float NEXT_WARN = 0.0f;
	bool MISSION_COMPLETE = false;

	// unnamed block (first think)
	void TelfQuest_FirstThink()
	{
		HBAR_ADJ_POS = Vector3(0, 0, -32);

		NPC_NO_PLAYER_DMG = true; // skimping on AI to save resources, but kept this for externals
		NPC_BATTLE_ALLY = true; // ditto
	}

	// game_damaged
	string TelfQuest_OnGameDamaged(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float accuracyRoll = 0.0f, CBaseEntity@ inflictor = null, string skill = "")
	{
		string result = "";

		if (IsPlayer(attacker))
		{
			result = AppendResult(result, "0");
		}
		else if (GameTime() > NEXT_WARN)
		{
			NEXT_WARN = GameTime() + 30.0f;
			InfoMessage("all", "CRITICAL NPC UNDER ATTACK", "Fedrosh is under attack!");
			if (HealthOf(ENT_ME) < HALF_HP)
				PlayRandomSound(0, 10, SOUND_PAIN1, SOUND_PAIN2);
		}
		return result;
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseChatArray_OnGameSpawn(playerRace, playerGender); // monsters/base_chat_array
		BaseNpc_OnGameSpawn(playerRace, playerGender); // monsters/base_npc
		SetName("Fedrosh the Rammata");
		SetModel("npc/elf_m_wizard.mdl");
		SetWidth(32);
		SetHeight(96);
		SetIdleAnim("deep_idle");
		SetMoveAnim("deep_idle");
		SetRace("human");
		SetHealth(5000);
		SetDamageTaken("all", 0.5f);
		SetNoPush(true);

		SetUniqueName("telf_quest");
		CallEventDelayed(0.1f, "scan_for_players");
		CallEventDelayed(2.0f, "finalize_npc");
	}

	// game_death
	void OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		BaseChatArray_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_chat_array
		DqMonsterExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // dq/externals/dq_monster_externals
		MonstersExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/externals
		BaseSelfAdjust_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_self_adjust
		BaseNpc_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		if (MISSION_COMPLETE)
			return;
		// local ELF_ID $get_by_name(sleep_elf)
		// callexternal ELF_ID quest_fail
		CallExternal("all", "ext_shender_fail");
		UseTrigger("sound_nightmare_fail");
		PLAYER_LIST = "";
		PLAYER_LIST = GetActivePlayers();
		int count = GetTokenCount(PLAYER_LIST);
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnRespawnPlayers();
		}
		InfoMessage("all", "A CRITIAL NPC HAS DIED!", "Fedrosh the Rammata is dead.");
		ClientCommand("all", "cd fadeout");
	}

	// finalize_npc
	void OnFinalizeNpc()
	{
		HALF_HP = MaxHealthOf(ENT_ME) * 0.5f;
	}

	// respawn_players
	void OnRespawnPlayers()
	{
		string curTarg = GetToken(PLAYER_LIST, loopIteration);
		string spawnName = GetQuestData(curTarg, "d");
		LegacyCommand("tospawn", curTarg, spawnName);
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
		if (!(RangeTo(curTarg) < 256.0f))
			return;
		DID_INTRO = 1;
		CHAT_CURRENT_SPEAKER = curTarg;
		CallEventDelayed(2.0f, "do_intro");
	}

	// do_intro
	void OnDoIntro()
	{
		if (RaceOf(CHAT_CURRENT_SPEAKER) == "human")
		{
			if (PlayerCount() > 1)
				OnChatNow("Children of Torkalath!?", "1.0", "convo_unarmed_norm", "none", "add_to_que");
			else
				OnChatNow("A child of Torkalath!?", "1.0", "convo_unarmed_norm", "none", "add_to_que");
		}
		OnChatNow("Surely the Lord of Might has sent you to save me!", "2.0", "none", "none", "add_to_que");
		OnChatNow("I am Fedrosh, a Ramatta refugee. I was attacked by Seekers after the location of our stronghold.", "5.0", "none", "none", "add_to_que");
		OnChatNow("I drove them off, but not before one muttered a curse against me.", "4.0", "none", "none", "add_to_que");
		OnChatNow("Nothing happened, so I thought it was a bluff. But when I slept that eve, I awoke here.", "5.0", "none", "none", "add_to_que");
		OnChatNow("Now, each day, nightmarish servants of Felewyn appear and tear me apart!", "5.0", "convo_unarmed_norm", "none", "add_to_que");
		// callevent chat_now "It's happened so many times that I've lost track. I know not how long I've been here!" 5.0 none none add_to_que
		OnChatNow("My magic does not work here, so I cannot defend myself... But maybe yours will!", "5.0", "none", "nightmare_start", "add_to_que");
		OnChatNow("By Torkalath! They are coming! Prepare yourselves!", "3.0", "convo_unarmed_panic", "none", "add_to_que");
	}

	// nightmare_start
	void OnNightmareStart()
	{
		CallEventDelayed(1.0f, "nightmare_start2");
	}

	// nightmare_start2
	void OnNightmareStart2()
	{
		SetIdleAnim("cower_idle");
		SetMoveAnim("cower_idle");
		UseTrigger("mm_nightmare_begin");
	}

	// game_targeted_by_player
	void OnGameTargetedByPlayer(CBasePlayer@ player = null)
	{
		CallExternal(player, "ext_show_hbar_monster", self, 1);
	}

	string OnGameDamaged(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float accuracyRoll = 0.0f, CBaseEntity@ inflictor = null, string skill = "") { return TelfQuest_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill); } // game_damaged

	// ext_quest_win
	void OnExtQuestWin()
	{
		MISSION_COMPLETE = true;
		SetInvincible(true);
		DeleteEntity(ENT_ME);
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("npc/elf_m_wizard.mdl");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		TelfQuest_FirstThink();
		BaseChatArray_FirstThink();
		BaseNpc_FirstThink();
		MonstersExternals_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "check_players") { OnCheckPlayers(); return true; }
		if (name == "do_intro") { OnDoIntro(); return true; }
		if (name == "ext_quest_win") { OnExtQuestWin(); return true; }
		if (name == "finalize_npc") { OnFinalizeNpc(); return true; }
		if (name == "game_damaged") { Return(OnGameDamaged(EntityParam(params, 0), Float(Param(params, 1)), Param(params, 2), Float(Param(params, 3)), EntityParam(params, 4), Param(params, 5))); return true; }
		if (name == "game_death") { OnGameDeath(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "game_targeted_by_player") { OnGameTargetedByPlayer(PlayerParam(params, 0)); return true; }
		if (name == "nightmare_start") { OnNightmareStart(); return true; }
		if (name == "nightmare_start2") { OnNightmareStart2(); return true; }
		if (name == "respawn_players") { OnRespawnPlayers(); return true; }
		if (name == "scan_for_players") { OnScanForPlayers(); return true; }
		return BaseChatArray_DispatchEvent(name, params)
			|| BaseNpcScript::DispatchEvent(name, params);
	}
}
