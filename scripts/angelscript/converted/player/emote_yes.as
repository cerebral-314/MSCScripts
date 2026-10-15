#pragma context server

// Converted from player/emote_yes.script by msc_transpiler.
// Nod Yes

#include "runtime/ScriptEntity.as"
#include "converted/effects/base_effect.as"

[script "player/emote_yes"]
class EmoteYes : BaseEffectScript
{
	// Constants
	string TEXT_NOD = "#ACTION_NOD_YES";

	// Variables declared by included files, with the value they start with in this script
	EmoteYes()
	{
		EFFECT_ID = "player_nodyes";
		EFFECT_FLAGS = "player_action";
	}

	// unnamed block (first think)
	void EmoteYes_FirstThink()
	{
		SetVar(Eval("game.effect.displayname"), TEXT_NOD);

		SetVar("local.idling", 0);
	}

	// game_player_activate
	void OnGamePlayerActivate()
	{
		CallExternal(ENT_ME, "emote_stop");
		PlayAnim("once", "nod_yes");
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
		EmoteYes_FirstThink();
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
