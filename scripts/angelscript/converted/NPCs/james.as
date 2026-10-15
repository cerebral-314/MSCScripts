#pragma context server

// Converted from NPCs/james.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_npc.as"
#include "converted/monsters/base_chat.as"

[script "NPCs/james"]
class James : BaseNpcScript, BaseChat
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
	bool BUSY_CHATTING = false;
	string CHAT_STEP1 = "CHAT_STEP1";
	string CHAT_STEP2 = "CHAT_STEP2";
	string CHAT_STEP3 = "CHAT_STEP3";
	string CHAT_STEP4 = "CHAT_STEP4";
	string CHAT_STEP5 = "CHAT_STEP5";
	bool CONGRATS_MSG = false;

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		SetName("Jae'em");
		SetHealth(1);
		SetInvincible(true);
		SetWidth(32);
		SetHeight(72);
		SetRace("beloved");
		SetModel("npc/human1.mdl");
		SetModelBody(0, 2);
		SetModelBody(1, 5);
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
			OnBchatMouthMove();
			SayText("Thank you for driving the orcs away! I hope our people will return soon...");
			CallEventDelayed(2.0f, "fix_anims");
		}

		if (CONGRATS_MSG)
			return;

		if (BUSY_CHATTING)
			return;

		PlayAnim("critical", "fear1");
		CHAT_STEPS = 5;
		CHAT_STEP = 0.0f;
		BUSY_CHATTING = true;
		PlaySound(0, 10, "npc/oldvillager2.wav");
		CHAT_STEP1 = "Please help us! The orcs have taken over our town!";
		CHAT_STEP2 = "Most of the town's people fled but Taol and I got trapped here.";
		CHAT_STEP3 = "I've been hiding in this room and Taol has locked himself in the room below.";
		CHAT_STEP4 = "He won't let anyone in until the orcs are gone.";
		CHAT_STEP5 = "If you slay the orcs, I'll open two of the city gates for you and perhaps we'll get to see Taol again.";

		OnChatLoop();
	}

	// wavend
	// ms_npcsript
	void OnWavend()
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
		PlayAnim("critical", "idle1");
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
		if (name == "fix_anims") { OnFixAnims(); return true; }
		if (name == "game_heardsound") { OnGameHeardsound(Param(params, 0), Vec(Param(params, 1)), Float(Param(params, 2))); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "say_hi") { OnSayHi(PlayerParam(params, 0)); return true; }
		if (name == "wavend") { OnWavend(); return true; }
		return BaseChat_DispatchEvent(name, params)
			|| BaseNpcScript::DispatchEvent(name, params);
	}
}
