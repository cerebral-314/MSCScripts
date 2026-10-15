#pragma context server

// Converted from player/emote_no.script by msc_transpiler.
// Nod No

#include "runtime/ScriptEntity.as"
#include "converted/effects/base_effect.as"

[script "player/emote_no"]
class EmoteNo : BaseEffectScript
{
	// Constants
	string TEXT_NOD = "#ACTION_NOD_NO";

	// Variables declared by included files, with the value they start with in this script
	EmoteNo()
	{
		EFFECT_ID = "player_nodno";
		EFFECT_FLAGS = "player_action";
	}

	// unnamed block (first think)
	void EmoteNo_FirstThink()
	{
		SetVar(Eval("game.effect.displayname"), TEXT_NOD);

		SetVar("local.idling", 0);
	}

	// game_player_activate
	void OnGamePlayerActivate()
	{
		CallExternal(ENT_ME, "emote_stop");
		PlayAnim("once", "nod_no");
		SetVar("local.noding", 1);
	}

	// idle_stop
	void OnIdleStop()
	{
		PlayAnim("break");
		SetVar("local.noding", 0);
	}

	// game_animate
	// Called every frame.  Cancel when the player moves
	void OnGameAnimate()
	{
		// (never true here, the rest is skipped) if local.noding
	}

	// emote_stop
	// Cancel if any other emote is used
	void OnEmoteStop()
	{
		OnIdleStop();
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		EmoteNo_FirstThink();
		BaseEffect_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "emote_stop") { OnEmoteStop(); return true; }
		if (name == "game_animate") { OnGameAnimate(); return true; }
		if (name == "game_player_activate") { OnGamePlayerActivate(); return true; }
		if (name == "idle_stop") { OnIdleStop(); return true; }
		return BaseEffectScript::DispatchEvent(name, params);
	}
}
