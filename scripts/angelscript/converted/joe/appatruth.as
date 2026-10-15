#pragma context server

// Converted from joe/appatruth.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_npc.as"
#include "converted/monsters/base_chat_array.as"

[script "joe/appatruth"]
class Appatruth : BaseNpcScript, BaseChatArray
{
	// Constants
	bool CHAT_NEVER_INTERRUPT = true;

	// Variables (an unset .script variable reads as its own name)
	string TORCH_TRIGGER = "TORCH_TRIGGER";

	// game_postspawn
	// PARAM1 = (name|default), PARAM2 = DmgMulti, PARAM3 = HPMulti, PARAM4 = pass_params
	void OnGamePostspawn(string title = "", string damageMultiplier = "", string healthMultiplier = "", string params = "")
	{
		BaseSelfAdjust_OnGamePostspawn(title, damageMultiplier, healthMultiplier, params); // monsters/base_self_adjust
		BaseNpc_OnGamePostspawn(title, damageMultiplier, healthMultiplier, params); // monsters/base_npc
		TORCH_TRIGGER = params;
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		SetName("Apparition of Atruth");
		SetModel("npc/dwarf_lantern.mdl");
		SetHealth(9001);
		SetRace("beloved");
		PLAYING_DEAD = "1";
		SetInvincible(true);
		SetNoPush(true);
		SetRoam(false);

		SetProp(ENT_ME, "rendermode", 5);
		SetProp(ENT_ME, "renderamt", 100);
		SetProp(ENT_ME, "renderfx", 16);

		SetIdleAnim("idle");

		SetWidth(32);
		SetHeight(54);

		SetModelBody(0, 2);
		SetSayTextRange(2048);

		SetBlood("none");

		SetSolid("none");

		UseTrigger("candle");
		CallEventDelayed(2.0f, "intro");
	}

	// intro
	// Not really much of an intro.
	void OnIntro()
	{
		OnChatFaceSpeaker();
		OnChatAddText("intro_chat", "Aye! Could ya be helpin' out a poor old ghost of a once good dwarf?", "3.5", "nod", "speak_help");
		OnChatAddText("intro_chat", "My fellows and I were working these here mines, but something... Unholy... Happened to them.", "6.0");
		OnChatAddText("intro_chat", "If ya could put their souls to rest, I would be forever grateful, as then I could be movin' on me self.", "7.0");
		OnChatAddText("intro_chat", "There's also some explosives in the caves we were hoping to use to connect the other mines.", "6.5", "nod", "access");
		OnChatAddText("intro_chat", "They be dwarven explosives, so they'll still be good, despite the time and the damp.", "6.0");
		OnChatAddText("intro_chat", "So take these torches, and keep your eye out for a fuse. They'll be useful for that as well as fer seein'.", "6.0");

		OnChatStartSequence("intro_chat", "add_to_que");
	}

	// speak_help
	void OnSpeakHelp()
	{
		PlaySound(0, 10, "voices/dwarf/vs_nx0drogm_heal.wav");
	}

	// access
	void OnAccess()
	{
		UseTrigger(TORCH_TRIGGER);
		UseTrigger("wave1");

		OnChatAddText("end_chat", "I think I'll be fading away fer a bit. After all, I can't really be helpin' ye like this, now can I?", "6.5", "none", "remove_me");
		OnChatStartSequence("end_chat", "add_to_que");
	}

	// remove_me
	void OnRemoveMe(string caller = "")
	{
		UseTrigger("candle");
		DeleteEntity(ENT_ME, "fade");
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
		BaseChatArray_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_chat_array
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseNpc_OnGameSpawn(playerRace, playerGender); // monsters/base_npc
		BaseChatArray_OnGameSpawn(playerRace, playerGender); // monsters/base_chat_array
	}

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("npc/dwarf_lantern.mdl");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		BaseNpc_FirstThink();
		MonstersExternals_FirstThink();
		BaseChatArray_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "access") { OnAccess(); return true; }
		if (name == "game_postspawn") { OnGamePostspawn(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "intro") { OnIntro(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "remove_me") { OnRemoveMe(Param(params, 0)); return true; }
		if (name == "speak_help") { OnSpeakHelp(); return true; }
		return BaseChatArray_DispatchEvent(name, params)
			|| BaseNpcScript::DispatchEvent(name, params);
	}
}
