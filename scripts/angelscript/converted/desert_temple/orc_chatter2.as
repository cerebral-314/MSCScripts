#pragma context server

// Converted from desert_temple/orc_chatter2.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/helena/orcwarrior_hard.as"
#include "converted/monsters/base_chat_array.as"

[script "desert_temple/orc_chatter2"]
class OrcChatter2 : OrcwarriorHardScript, BaseChatArray
{
	// Constants
	bool CHAT_USE_CONV_ANIMS = false;
	bool CHAT_NO_CLOSE_MOUTH = true;
	bool CHAT_AUTO_FACE = false;

	// Variables (an unset .script variable reads as its own name)
	float RESPONSE_INDEX = 0.0f;
	string ORC_BUDDY_ID = "ORC_BUDDY_ID";
	bool IN_COMBAT = false;

	// start_combat
	void OrcChatter2_OnStartCombat(string attacker = "")
	{
	}

	// game_damaged
	string OrcChatter2_OnGameDamaged(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float accuracyRoll = 0.0f, CBaseEntity@ inflictor = null, string skill = "")
	{
		string result = "";
		if (IN_COMBAT)
			return result;
		OnStartCombat();
		return result;
	}

	// npcatk_hunt
	void OrcChatter2_OnNpcatkHunt()
	{
		if (IN_COMBAT)
			return;
		if (!CanSee("enemy"))
			return;
		OnStartCombat();
	}

	// start_combat
	void OrcChatter2_OnStartCombat_2(string attacker = "")
	{
		if (IN_COMBAT)
			return;
		IN_COMBAT = true;
		OnChatClearQue();
		CallEventDelayed(3.0f, "start_combat2");
		OnNpcatkResumeAi();
		SetHearingSensitivity(4);
		if (attacker == "game_damaged")
			OnNpcatkSettarget(EntityId(EntityOf(ENT_LASTSTRUCK)));
		else if (IsAlive(attacker))
			OnNpcatkSettarget(EntityId(EntityOf(attacker)));
		else
			OnNpcatkSettarget(EntityId(EntityOf(ENT_LASTSEEN)));

		if (!Truthy(ScriptVarOf(ORC_BUDDY_ID, "IN_COMBAT")))
			CallExternal(ORC_BUDDY_ID, "start_combat", NPCATK_TARGET);
	}

	// npcatk_hunt
	void OrcChatter2_OnNpcatkHunt_2()
	{
		if (ORC_BUDDY_ID == "ORC_BUDDY_ID")
			ORC_BUDDY_ID = EntityId(FindByName("orc_chatter1"));
	}

	// orc_spawn
	void OnOrcSpawn()
	{
		OrcBaseMelee_OnOrcSpawn(); // monsters/orc_base_melee
		OrcwarriorHard_OnOrcSpawn(); // helena/orcwarrior_hard
		SetName("Blackhand Warrior");
		SetSayTextRange(1024);
		SetUniqueName("orc_chatter2");
		SetRoam(false);
		SetHearingSensitivity(0);
		OnNpcatkSuspendAi();
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
		BaseChatArray_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_chat_array
		// one last time, just in case
		CallExternal(ORC_BUDDY_ID, "turn_mclip_on");
	}

	// npcatk_hunt
	void OnNpcatkHunt()
	{
		BaseNpcAttackNew_OnNpcatkHunt(); // monsters/base_npc_attack_new
		BaseAntiStuck_OnNpcatkHunt(); // monsters/base_anti_stuck
		OrcChatter2_OnNpcatkHunt();
		OrcChatter2_OnNpcatkHunt_2();
	}

	// game_damaged - Return a damage multiplier to scale the damage
	string OnGameDamaged(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float accuracyRoll = 0.0f, CBaseEntity@ inflictor = null, string skill = "")
	{
		string result = "";
		result = AppendResult(result, BaseAntiStuck_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, BaseMonsterShared_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, BaseMonsterShared_OnGameDamaged_2(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, OrcChatter2_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		return result;
	}

	// start_combat
	void OnStartCombat(string attacker = "")
	{
		OrcChatter2_OnStartCombat(attacker);
		OrcChatter2_OnStartCombat_2(attacker);
	}

	// ext_do_chat_step
	void OnExtDoChatStep()
	{
		if (IN_COMBAT)
			return;
		RESPONSE_INDEX += 1.0f;
		if (RESPONSE_INDEX == 1.0f)
		{
			OnChatNow("Relax! We don't have to fight them - we just have to warn the others and get out through the tunnels.", "5.5", "neigh", "none", "add_to_que", "clear_que");
			OnChatNow("It's a maze down there, they'll never catch us!", "2.5", "neigh", "request_response", "add_to_que");
		}
		if (RESPONSE_INDEX == 2.0f)
			OnChatNow("You mean those big guys with the red scales and fire in their eyes?", "4.5", "nod_yes", "request_response", "add_to_que");
		if (RESPONSE_INDEX == 3.0f)
			OnChatNow("I don't know... I think I'd look good in red!", "4.0", "nod_yes", "request_response", "add_to_que");
		if (RESPONSE_INDEX == 4.0f)
		{
			OnChatNow("You worry too much my friend!", "2.5", "neigh", "none", "add_to_que");
			OnChatNow("But we should go check on the other side - there's way too many ways into this place.", "4.5", "none", "request_response", "add_to_que");
		}
	}

	// request_response
	void OnRequestResponse()
	{
		if (IN_COMBAT)
			return;
		if (ORC_BUDDY_ID == "ORC_BUDDY_ID")
			ORC_BUDDY_ID = EntityId(FindByName("orc_chatter1"));
		CallExternal(ORC_BUDDY_ID, "ext_do_chat_step");
		if (RESPONSE_INDEX == 4.0f)
			OnStartWander();
	}

	// start_wander
	void OnStartWander()
	{
		if (IN_COMBAT)
			return;
		CallExternal(ORC_BUDDY_ID, "turn_mclip_on");
		SetRoam(true);
		PlayAnim("break");
		OnNpcatkResumeAi();
		SetHearingSensitivity(2);
		OnNpcatkSetmovedest(Text(Vector3(2320, -688, -528)), "32");
	}

	// start_combat2
	void OnStartCombat2()
	{
		CallExternal(ORC_BUDDY_ID, "turn_mclip_on"); // case he didn't do this, or died

		if (PlayerCount() > 1)
			SayText("I don't know, but we better make short work of them and warn the others!");
		else
			SayText("I don't know, but we better make short work of him and warn the others!");
		PlaySound(0, 10, "voices/orc/help.wav");
	}

	// ext_gender_gag1
	void OnExtGenderGag1()
	{
		SayText("How can you tell!?");
	}

	// ext_gender_gag2
	void OnExtGenderGag2()
	{
		SayText("That's... Nice... But maybe we ask her for a date AFTER we kill her!");
	}

	// ext_gender_gag3
	void OnExtGenderGag3()
	{
		SayText("Just shut up and fight!");
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseNpc_OnGameSpawn(playerRace, playerGender); // monsters/base_npc
		BaseMonsterShared_OnGameSpawn(playerRace, playerGender); // monsters/base_monster_shared
		BaseChatArray_OnGameSpawn(playerRace, playerGender); // monsters/base_chat_array
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		OrcwarriorHard_FirstThink();
		OrcBaseMelee_FirstThink();
		OrcBase_FirstThink();
		BaseNpc_FirstThink();
		MonstersExternals_FirstThink();
		BaseNpcAttackNew_FirstThink();
		BaseMonsterShared_FirstThink();
		BaseChatArray_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "ext_do_chat_step") { OnExtDoChatStep(); return true; }
		if (name == "ext_gender_gag1") { OnExtGenderGag1(); return true; }
		if (name == "ext_gender_gag2") { OnExtGenderGag2(); return true; }
		if (name == "ext_gender_gag3") { OnExtGenderGag3(); return true; }
		if (name == "game_damaged") { Return(OnGameDamaged(EntityParam(params, 0), Float(Param(params, 1)), Param(params, 2), Float(Param(params, 3)), EntityParam(params, 4), Param(params, 5))); return true; }
		if (name == "game_death") { OnGameDeath(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "npcatk_hunt") { OnNpcatkHunt(); return true; }
		if (name == "orc_spawn") { OnOrcSpawn(); return true; }
		if (name == "request_response") { OnRequestResponse(); return true; }
		if (name == "start_combat") { OnStartCombat(Param(params, 0)); return true; }
		if (name == "start_combat2") { OnStartCombat2(); return true; }
		if (name == "start_wander") { OnStartWander(); return true; }
		return BaseChatArray_DispatchEvent(name, params)
			|| OrcwarriorHardScript::DispatchEvent(name, params);
	}
}
