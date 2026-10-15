#pragma context server

// Converted from ara/charon.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_chat.as"

[script "ara/charon"]
class Charon : BaseChatScript
{
	// Constants
	bool NO_RUMOR = true;
	bool NO_JOB = true;

	// Variables (an unset .script variable reads as its own name)
	string SOUND_IDLE1 = "voices/human/male_idle4.wav";
	string SOUND_IDLE2 = "voices/human/male_idle5.wav";
	string SOUND_IDLE3 = "voices/human/male_idle6.wav";
	float ORC_TIME = 0.0f;

	// game_menu_getoptions
	void OnGameMenuGetoptions(CBasePlayer@ player = null)
	{
		BaseChat_OnGameMenuGetoptions(player); // monsters/base_chat
		MenuItem menuItem;

		menuItem.title = "Sail Back to Deralia";
		menuItem.type = "callback";
		menuItem.callback = "vote_deralia";
		RegisterMenuItem(menuItem);
	}

	// spawn
	void OnSpawn()
	{
		SetHealth(1);
		SetName("Captain Charon");
		// fov		180
		SetWidth(32);
		SetHeight(72);
		SetRace("beloved");
		SetRoam(false);
		SetModel("npc/human1.mdl");
		SetInvincible(true);
		SetModelBody(0, 1);
		SetModelBody(1, 2);

		SOUND_IDLE1 = "voices/human/male_idle4.wav";
		SOUND_IDLE2 = "voices/human/male_idle5.wav";
		SOUND_IDLE3 = "voices/human/male_idle6.wav";

		CatchSpeech("say_hi", "hi", "hello", "hail", "greet", "'ello", "j0");
		CatchSpeech("say_orc", "orc");
		CallEventDelayed(0.1f, "post_spawn");
	}

	// post_spawn
	void OnPostSpawn()
	{
		ORC_TIME = GameTime() + 120.0f;
	}

	// say_hi
	void OnSayHi(CBasePlayer@ talkingPlayer = null)
	{
		if (GameTime() < ORC_TIME)
		{
			PlayAnim("critical", "pondering");
			SayText("Oh, I don't like this. It's far too quiet... No one in sight. Something is up, something BAD.");
		}

		if (GameTime() >= ORC_TIME)
		{
			PlayAnim("once", "checktie");
			if (IsAlive(talkingPlayer))
				OnFaceSpeaker(EntityId(talkingPlayer));
			if (IsAlive(ENT_LASTSPOKE))
				OnFaceSpeaker(EntityId(EntityOf(ENT_LASTSPOKE)));
			SayText("Orcs!? Blast! Get in there and see if you can save any potential customers!");
			SayText("I'll stay here and guard the ship.");
		}
	}

	// say_orc
	void OnSayOrc()
	{
		PlayAnim("critical", "pondering2");
		if (IsAlive(ENT_LASTHEARD))
			OnFaceSpeaker(EntityId(EntityOf(ENT_LASTSPOKE)));
		SayText("Awfully brazen these days. Orcs in Helena is one thing... Orcs in Ara is unheard of!");
	}

	// vote_deralia
	void OnVoteDeralia(CBasePlayer@ player = null)
	{
		SayText("I suppose this town is a bust - sorry for wasting your time.");
		UseTrigger("touch_trans_deralia");
		PlayerMessageGreen(player, "Starting AMX vote for Deralia...");
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("npc/human1.mdl");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "game_menu_getoptions") { OnGameMenuGetoptions(PlayerParam(params, 0)); return true; }
		if (name == "post_spawn") { OnPostSpawn(); return true; }
		if (name == "say_hi") { OnSayHi(PlayerParam(params, 0)); return true; }
		if (name == "say_orc") { OnSayOrc(); return true; }
		if (name == "spawn") { OnSpawn(); return true; }
		if (name == "vote_deralia") { OnVoteDeralia(PlayerParam(params, 0)); return true; }
		return BaseChatScript::DispatchEvent(name, params);
	}
}
