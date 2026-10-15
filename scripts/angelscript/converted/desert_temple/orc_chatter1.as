#pragma context server

// Converted from desert_temple/orc_chatter1.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/orc_flayer.as"
#include "converted/monsters/base_chat_array.as"

[script "desert_temple/orc_chatter1"]
class OrcChatter1 : MonstersOrcFlayerScript, BaseChatArray
{
	// Constants
	bool CHAT_USE_CONV_ANIMS = false;
	bool CHAT_NO_CLOSE_MOUTH = true;
	bool CHAT_AUTO_FACE = false;

	// Variables (an unset .script variable reads as its own name)
	bool NEXT_RESPONSE_INDEX = false;
	string ORC_BUDDY_ID = "ORC_BUDDY_ID";
	float RESPONSE_INDEX = 0.0f;
	bool IN_COMBAT = false;
	bool TURNED_MCLIP_ON = false;

	// game_damaged
	string OrcChatter1_OnGameDamaged(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float accuracyRoll = 0.0f, CBaseEntity@ inflictor = null, string skill = "")
	{
		string result = "";
		if (IN_COMBAT)
			return result;
		OnStartCombat("game_damaged");
		return result;
	}

	// npcatk_hunt
	void OrcChatter1_OnNpcatkHunt()
	{
		if (IN_COMBAT)
			return;
		if (!CanSee("enemy"))
			return;
		OnStartCombat();
	}

	// npcatk_hunt
	void OrcChatter1_OnNpcatkHunt_2()
	{
		if (ORC_BUDDY_ID == "ORC_BUDDY_ID")
			ORC_BUDDY_ID = EntityId(FindByName("orc_chatter2"));
	}

	// orc_spawn
	void OnOrcSpawn()
	{
		OrcBaseMelee_OnOrcSpawn(); // monsters/orc_base_melee
		MonstersOrcFlayer_OnOrcSpawn(); // monsters/orc_flayer
		SetName("Blackhand Flayer");
		SetSayTextRange(1024);
		SetUniqueName("orc_chatter1");
		SetRoam(false);
		OnNpcatkSuspendAi();
		CallEventDelayed(1.0f, "start_chat");
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
		OnTurnMclipOn();
	}

	// npcatk_hunt
	void OnNpcatkHunt()
	{
		BaseNpcAttackNew_OnNpcatkHunt(); // monsters/base_npc_attack_new
		BaseAntiStuck_OnNpcatkHunt(); // monsters/base_anti_stuck
		OrcChatter1_OnNpcatkHunt();
		OrcChatter1_OnNpcatkHunt_2();
	}

	// game_damaged - Return a damage multiplier to scale the damage
	string OnGameDamaged(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float accuracyRoll = 0.0f, CBaseEntity@ inflictor = null, string skill = "")
	{
		string result = "";
		result = AppendResult(result, BaseAntiStuck_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, BaseMonsterShared_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, BaseMonsterShared_OnGameDamaged_2(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, OrcChatter1_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		return result;
	}

	// start_chat
	void OnStartChat()
	{
		if (IN_COMBAT)
			return;
		NEXT_RESPONSE_INDEX = true;
		OnChatNow("This is insane... Rummaging through ruins so far inside Shadahar territory... What is Furux thinking!?", "5.0", "neigh", "request_response", "clear_que", "add_to_que");
	}

	// request_response
	void OnRequestResponse()
	{
		if (IN_COMBAT)
			return;
		if (ORC_BUDDY_ID == "ORC_BUDDY_ID")
			ORC_BUDDY_ID = EntityId(FindByName("orc_chatter2"));
		CallExternal(ORC_BUDDY_ID, "ext_do_chat_step");
	}

	// ext_do_chat_step
	void OnExtDoChatStep()
	{
		if (IN_COMBAT)
			return;
		RESPONSE_INDEX += 1.0f;
		if (RESPONSE_INDEX == 1.0f)
			OnChatNow("I still don't like it... Have you seen those guys he brought with him?", "4.5", "nod_yes", "request_response", "add_to_que");
		if (RESPONSE_INDEX == 2.0f)
		{
			OnChatNow("Yeah... I'm sure this all has something to do with them.", "4.5", "nod_yes", "none", "add_to_que");
			OnChatNow("All this damn magic stuff creeps me out...", "3.0", "neigh", "request_response", "add_to_que");
		}
		if (RESPONSE_INDEX == 3.0f)
			OnChatNow("By Torkalath, you are an idiot!", "3.0", "flinch", "request_response", "add_to_que");
		if (RESPONSE_INDEX == 4.0f)
			OnChatNow("*sigh* Alright... My back's getting sore just standing here like this anyways.", "3.0", "nod_yes", "start_wander", "add_to_que");
	}

	// start_wander
	void OnStartWander()
	{
		if (IN_COMBAT)
			return;
		PlayAnim("break");
		SetRoam(true);
		OnNpcatkResumeAi();
		SetHearingSensitivity(2);
		OnNpcatkSetmovedest(Text(Vector3(2320, -688, -528)), "32");
		OnTurnMclipOn();
	}

	// do_chat3
	void OnDoChat3()
	{
		CallExternal(ORC_BUDDY_ID, "ext_start_chat");
	}

	// start_combat
	void OnStartCombat(string attacker = "")
	{
		if (IN_COMBAT)
			return;
		IN_COMBAT = true;
		OnChatClearQue();
		string saytextStr = "";
		CallEventDelayed(6.0f, "start_combat2");
		CallEventDelayed(2.0f, "turn_mclip_on"); // you have about two seconds to boot them off the cliff should you enter combat
		OnNpcatkResumeAi();
		SetHearingSensitivity(4);
		if (attacker == "game_damaged")
		{
			OnNpcatkSettarget(EntityId(EntityOf(ENT_LASTSTRUCK)));
			saytextStr = "Ow...! ";
		}
		else if (IsAlive(attacker))
			OnNpcatkSettarget(EntityId(EntityOf(attacker)));
		else
			OnNpcatkSettarget(EntityId(EntityOf(ENT_LASTSEEN)));
		if (PlayerCount() > 1)
			saytextStr += "What the... Where'd these guys come from!?";
		else
			saytextStr += "What the... Where'd this guy come from!?";
		SayText(saytextStr);

		if (!Truthy(ScriptVarOf(ORC_BUDDY_ID, "IN_COMBAT")))
			CallExternal(ORC_BUDDY_ID, "start_combat", NPCATK_TARGET);
	}

	// start_combat2
	void OnStartCombat2()
	{
		if (PlayerCount() != 1)
			return;
		if (GenderOf(NPCATK_TARGET) != "female")
			return;
		SayText("I think *he* might be a *she*...");
		CallEventDelayed(2.0f, "gender_gag");
		CallEventDelayed(4.0f, "gender_gag2");
		CallEventDelayed(6.0f, "gender_gag3");
		CallEventDelayed(8.0f, "gender_gag4");
		CallEventDelayed(10.0f, "gender_gag5");
	}

	// gender_gag
	void OnGenderGag()
	{
		if (!IsAlive(ENT_ME))
			return;
		CallExternal(ORC_BUDDY_ID, "ext_gender_gag1");
	}

	// gender_gag2
	void OnGenderGag2()
	{
		if (!IsAlive(ENT_ME))
			return;
		SayText("The human women have bumps on their chests...");
	}

	// gender_gag3
	void OnGenderGag3()
	{
		if (!IsAlive(ENT_ME))
			return;
		CallExternal(ORC_BUDDY_ID, "ext_gender_gag2");
	}

	// gender_gag4
	void OnGenderGag4()
	{
		if (!IsAlive(ENT_ME))
			return;
		SayText("I'm just saying...");
	}

	// gender_gag5
	void OnGenderGag5()
	{
		if (!IsAlive(ENT_ME))
			return;
		CallExternal(ORC_BUDDY_ID, "ext_gender_gag3");
	}

	// turn_mclip_on
	void OnTurnMclipOn()
	{
		if (TURNED_MCLIP_ON)
			return;
		TURNED_MCLIP_ON = true;
		UseTrigger("mclip_toggle");
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
		MonstersOrcFlayer_FirstThink();
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
		if (name == "do_chat3") { OnDoChat3(); return true; }
		if (name == "ext_do_chat_step") { OnExtDoChatStep(); return true; }
		if (name == "game_damaged") { Return(OnGameDamaged(EntityParam(params, 0), Float(Param(params, 1)), Param(params, 2), Float(Param(params, 3)), EntityParam(params, 4), Param(params, 5))); return true; }
		if (name == "game_death") { OnGameDeath(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "gender_gag") { OnGenderGag(); return true; }
		if (name == "gender_gag2") { OnGenderGag2(); return true; }
		if (name == "gender_gag3") { OnGenderGag3(); return true; }
		if (name == "gender_gag4") { OnGenderGag4(); return true; }
		if (name == "gender_gag5") { OnGenderGag5(); return true; }
		if (name == "npcatk_hunt") { OnNpcatkHunt(); return true; }
		if (name == "orc_spawn") { OnOrcSpawn(); return true; }
		if (name == "request_response") { OnRequestResponse(); return true; }
		if (name == "start_chat") { OnStartChat(); return true; }
		if (name == "start_combat") { OnStartCombat(Param(params, 0)); return true; }
		if (name == "start_combat2") { OnStartCombat2(); return true; }
		if (name == "start_wander") { OnStartWander(); return true; }
		if (name == "turn_mclip_on") { OnTurnMclipOn(); return true; }
		return BaseChatArray_DispatchEvent(name, params)
			|| MonstersOrcFlayerScript::DispatchEvent(name, params);
	}
}
