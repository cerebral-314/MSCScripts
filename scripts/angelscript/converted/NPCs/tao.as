#pragma context server

// Converted from NPCs/tao.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_npc.as"
#include "converted/monsters/base_chat.as"

[script "NPCs/tao"]
class Tao : BaseNpcScript, BaseChat
{
	// Constants
	bool NO_JOB = true;
	bool NO_RUMOR = true;
	float CHAT_DELAY = 3.0f;

	// Variables (an unset .script variable reads as its own name)
	int SAID_HI = 0;
	bool DID_CONGRATS = false;
	int CHAT_STEPS = 0;
	float CHAT_STEP = 0.0f;
	string CHAT_STEP1 = "CHAT_STEP1";
	string CHAT_STEP2 = "CHAT_STEP2";
	bool BUSY_CHATTING = false;
	string CHAT_STEP3 = "CHAT_STEP3";
	string CHAT_STEP4 = "CHAT_STEP4";
	string CHAT_STEP5 = "CHAT_STEP5";
	string CHAT_STEP6 = "CHAT_STEP6";
	string CHAT_STEP7 = "CHAT_STEP7";
	bool CONGRATS_MSG = false;

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		SetName("Tao'l");
		SetHealth(1);
		SetInvincible(true);
		SetWidth(32);
		SetHeight(72);
		SetRace("beloved");
		SetModel("npc/human1.mdl");
		SetModelBody(0, 1);
		SetModelBody(1, 0);
		SetRoam(false);
		SetMoveAnim("idle1");
		SetHearingSensitivity(10);
		SetSayTextRange(1024);

		CatchSpeech("say_hi", "hi", "hail", "yo", "waddup", "greetings", "hello", "j0");
	}

	// game_heardsound
	void OnGameHeardsound(string soundType = "", Vector3 origin = Vector3(), float dangerRadius = 0.0f)
	{
		CBaseEntity@ lastHeard = EntityOf(ENT_LASTHEARD);

		if (!IsPlayer(lastHeard))
			return;

		if (!CanSee(EntityId(lastHeard)))
			return;

		if (!(RangeTo(lastHeard) < 200.0f))
			return;
		if (CONGRATS_MSG)
		{
			OnFaceSpeaker(EntityId(lastHeard));
			if (!DID_CONGRATS)
				OnSayHi();
		}
		if (SAID_HI != 0)
			return;
		OnFaceSpeaker(EntityId(lastHeard));
		OnSayHi();
	}

	// say_hi
	void OnSayHi(CBasePlayer@ talkingPlayer = null)
	{
		if (IsPlayer(talkingPlayer))
			OnFaceSpeaker(EntityId(talkingPlayer));
		if (IsPlayer(ENT_LASTSPOKE))
			OnFaceSpeaker(EntityId(EntityOf(ENT_LASTSPOKE)));

		SAID_HI = 1;

		if (CONGRATS_MSG)
		{
			DID_CONGRATS = true;
			PlayAnim("critical", "eye_wipe");
			CHAT_STEPS = 2;
			CHAT_STEP = 0.0f;
			CHAT_STEP1 = "Thank you for bringing us the key.";
			CHAT_STEP2 = "If you find something of interest in the cellar, feel free to have that too!";
			OnChatLoop();
			CallEventDelayed(2.0f, "fix_anims");
		}

		if (CONGRATS_MSG)
			return;

		if (BUSY_CHATTING)
			return;
		if (IsPlayer(talkingPlayer))
			OnFaceSpeaker(EntityId(talkingPlayer));
		if (IsPlayer(ENT_LASTSPOKE))
			OnFaceSpeaker(EntityId(EntityOf(ENT_LASTSPOKE)));

		PlayAnim("critical", "converse1");
		CHAT_STEPS = 7;
		CHAT_STEP = 0.0f;
		BUSY_CHATTING = true;
		CHAT_STEP1 = "Thank you so much for killing the orcs!";
		CHAT_STEP2 = "Take anything you want from my chest as a reward.";
		CHAT_STEP3 = "If you want to continue your journey, you can travel to the forest behind the rocks but be careful...";
		CHAT_STEP4 = "...there might be more orcs near the town and in the forest too!";
		CHAT_STEP5 = "Oh, also, the town cellar door is locked and we don't have the key.";
		CHAT_STEP6 = "I think it was left in the shed near the field when the orcs attacked...";
		CHAT_STEP7 = "Please, see if you can find it for us.";
		OnChatLoop();
		CallEventDelayed(2.0f, "fix_anims");
	}

	// dungeon
	// ms_npcsript
	void OnDungeon()
	{
		CONGRATS_MSG = true;
		string nearbyPlayer = FindOneInSphere("player", 512);
		if (nearbyPlayer != "0")
		{
			OnFaceSpeaker(nearbyPlayer);
			OnSayHi();
		}
	}

	// fix_anims
	void OnFixAnims()
	{
		// ms_npcscript seems to be fubar'ing my anims, reset after call
		SetMoveAnim("idle1");
		SetIdleAnim("idle1");
		PlayAnim("once", "idle1");
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseNpc_OnGameSpawn(playerRace, playerGender); // monsters/base_npc
		BaseChat_OnGameSpawn(playerRace, playerGender); // monsters/base_chat
	}

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("npc/human1.mdl");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		BaseNpc_FirstThink();
		MonstersExternals_FirstThink();
		BaseChat_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "dungeon") { OnDungeon(); return true; }
		if (name == "fix_anims") { OnFixAnims(); return true; }
		if (name == "game_heardsound") { OnGameHeardsound(Param(params, 0), Vec(Param(params, 1)), Float(Param(params, 2))); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "say_hi") { OnSayHi(PlayerParam(params, 0)); return true; }
		return BaseChat_DispatchEvent(name, params)
			|| BaseNpcScript::DispatchEvent(name, params);
	}
}
