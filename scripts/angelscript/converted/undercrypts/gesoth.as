#pragma context server

// Converted from undercrypts/gesoth.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_chat_array.as"

[script "undercrypts/gesoth"]
class Gesoth : BaseChatArrayScript
{
	// Constants
	bool QUEST_REWARD_ALL = true;

	// Variables (an unset .script variable reads as its own name)
	string PLAYING_DEAD = "PLAYING_DEAD";
	float CONVO_IDX = 0.0f;
	float NEXT_NAY = 0.0f;

	// Variables declared by included files, with the value they start with in this script
	Gesoth()
	{
		CHAT_AUTO_FACE = false;
		CHAT_FACE_ON_USE = false;
		CHAT_NEVER_INTERRUPT = true;
		CHAT_CONV_ANIMS = "anim_sit_convo;anim_sit_idle_lantern";
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseChatArray_OnGameSpawn(playerRace, playerGender); // monsters/base_chat_array
		SetName("Gesoth");
		SetUniqueName("gesoth");
		SetModel("dwarf/male1.mdl");
		SetWidth(32);
		SetHeight(48);
		SetRoam(false);
		SetHealth(1000);
		SetHearingSensitivity(0);
		SetRace("beloved");
		SetSayTextRange(1024);

		SetNoPush(true);
		SetInvincible(true);

		PLAYING_DEAD = "1";

		SetIdleAnim("anim_sit_idle_nolantern");
		SetProp(ENT_ME, "skin", 1);
		SetMenuAutoOpen(true);

		SetMonsterClip(false);
	}

	// game_menu_getoptions
	void OnGameMenuGetoptions(CBasePlayer@ player = null)
	{
		BaseChatArray_OnGameMenuGetoptions(player); // monsters/base_chat_array

		PlayAnim("critical", "anim_sit_idle_nolantern");

		if (CONVO_IDX == 0.0f)
			OnChatNow("Uggh... Talk to Halsof, he's the brains of this doomed outfit.");
		if (CONVO_IDX == 1.0f)
		{
			CONVO_IDX = 0.0f;
			OnChatNow("Leave me alone... Talk to Halsof.");
		}
		CONVO_IDX += 1.0f;

		if (!(GameTime() > NEXT_NAY))
			return;
		NEXT_NAY = GameTime() + 3.0f;
		PlaySound(2, 10, "voices/dwarf/vs_ndwarfm1_no.wav");
	}

	// ext_remove
	void OnExtRemove()
	{
		DeleteEntity(ENT_ME, "fade");
	}

	// ext_found_tnt
	void OnExtFoundTnt()
	{
		OnChatNow("Eh, it may have been me who left that there.");
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("dwarf/male1.mdl");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "ext_found_tnt") { OnExtFoundTnt(); return true; }
		if (name == "ext_remove") { OnExtRemove(); return true; }
		if (name == "game_menu_getoptions") { OnGameMenuGetoptions(PlayerParam(params, 0)); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		return BaseChatArrayScript::DispatchEvent(name, params);
	}
}
