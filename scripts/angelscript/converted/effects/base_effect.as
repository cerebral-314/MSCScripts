#pragma context server

// Converted from effects/base_effect.script by msc_transpiler.
// Base effect
// Handles effects applied to players or monsters
// Removes itself when target dies or when time is up
// PARAM1 = duration. 0 will stay until death, or manual removal.

#include "runtime/ScriptEntity.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class BaseEffect
{
	// Constants
	string EFFECT_ID = "base_effect";
	string EFFECT_FLAGS = "EFFECT_FLAGS";
	string EFFECT_SCRIPT = "EFFECT_SCRIPT";

	// Variables (an unset .script variable reads as its own name)
	float EFFECT_STARTED = 0.0f;
	string EFFECT_DURATION = "EFFECT_DURATION";
	float EFFECT_TIMELEFT = 0.0f;

	// unnamed block (first think)
	void BaseEffect_FirstThink()
	{
		// "clearfx" will check this to see if it is 1 before removing the script, and will not if it is set to 0.
		// If "player_action" is used in the flags, ensure that this is set to 0.
		// If this is set to 1, but you want "clearfx" to ignore the effect, EFFECT_IGNORE_CLEARFX can be set to 1 also.
		// The following can be turned on or off at will to influence the target:
		// setvard game.effect.canmove
		// setvard game.effect.canrun //Doesn't work :(
		// setvard game.effect.canduck
		// setvard game.effect.canattack
		// setvard game.effect.movespeed
		// setvard game.effect.anim.framerate
		// They do not need to be set back to the original value at effect death
		SetVar(Eval("game.effect.id"), EFFECT_ID); // Used to tell if this script is an effect. Clients tell the server this id when a player action is used, and will call "game_player_activate" on the effect.
	}

	// game_precache
	// Effects are, unusually, registered in game_precache.
	void BaseEffect_OnGamePrecache()
	{
		SetLocal("reg.effect.script", EFFECT_SCRIPT); // Not clear what it does, but is required, and must be correct.
		SetLocal("reg.effect.name", EFFECT_ID);
		SetLocal("reg.effect.flags", EFFECT_FLAGS);

		LegacyCommand("registereffect");
	}

	// game_activate
	// PARAM1 = duration
	void BaseEffect_OnGameActivate(string duration = "", string amount = "", string damage = "", string skill = "", string extraValue5 = "", string falloff = "")
	{
		EFFECT_STARTED = GameTime();
		EFFECT_DURATION = duration;

		if (!Truthy(EFFECT_DURATION)) // If there is a duration on this effect
			return;
		if (EFFECT_DURATION.isEmpty())
			return;
		CallEventOrDelay(EFFECT_DURATION, "effect_duration_ended");
	}

	// effect_duration_ended
	void BaseEffect_OnEffectDurationEnded()
	{
		float endTime = EFFECT_STARTED + Float(EFFECT_DURATION);

		if (GameTime() >= endTime) // Check if duration was increased
		{
			RemoveScript(); // will automatically call effect_die.
		}
		else
		{
			// Reset end timer if duration was increased
			float timeRemaining = endTime - GameTime();
			CallEventDelayed(timeRemaining, "effect_duration_ended");
		}
	}

	// effect_increase_duration
	// Increases duration by a number of seconds. Cannot lower duration. Must be called by the effect script.
	void BaseEffect_OnEffectIncreaseDuration(float seconds = 0.0f)
	{
		EFFECT_DURATION = Text(Float(EFFECT_DURATION) + seconds);
	}

	// effect_set_duration
	// Sets duration by a number of seconds. Cannot lower duration. Must be called by the effect script.
	void BaseEffect_OnEffectSetDuration(string duration = "")
	{
		EFFECT_STARTED = GameTime();
		OnEffectGetTimeleft();
		if (Float(duration) < EFFECT_TIMELEFT)
			CallEventOrDelay(duration, "effect_duration_ended");
		EFFECT_DURATION = duration;
	}

	// effect_get_timeleft
	// Sets a variable with the remaining duration.
	void BaseEffect_OnEffectGetTimeleft()
	{
		EFFECT_TIMELEFT = GameTime() - EFFECT_STARTED; // gets number of seconds elapsed
		EFFECT_TIMELEFT = Float(EFFECT_DURATION) - EFFECT_TIMELEFT; // gets time left
	}

	// effect_die
	// Gets called when effect dies or is removed.
	void BaseEffect_OnEffectDie()
	{
	}

	// game_duplicated
	// Gets called by c++ code whenever the effect successfully stacks
	void BaseEffect_OnGameDuplicated()
	{
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)
	void OnGamePrecache() { BaseEffect_OnGamePrecache(); } // game_precache
	void OnGameActivate(string duration = "", string amount = "", string damage = "", string skill = "", string extraValue5 = "", string falloff = "") { BaseEffect_OnGameActivate(duration, amount, damage, skill, extraValue5, falloff); } // game_activate
	void OnEffectDurationEnded() { BaseEffect_OnEffectDurationEnded(); } // effect_duration_ended
	void OnEffectIncreaseDuration(float seconds = 0.0f) { BaseEffect_OnEffectIncreaseDuration(seconds); } // effect_increase_duration
	void OnEffectSetDuration(string duration = "") { BaseEffect_OnEffectSetDuration(duration); } // effect_set_duration
	void OnEffectGetTimeleft() { BaseEffect_OnEffectGetTimeleft(); } // effect_get_timeleft
	void OnEffectDie() { BaseEffect_OnEffectDie(); } // effect_die
	void OnGameDuplicated() { BaseEffect_OnGameDuplicated(); } // game_duplicated
	void OnEffectDuration() {} // EFFECT_DURATION
	void OnLTimeRemaining() {} // L_TIME_REMAINING

	// This file's events and timers by their .script names
	bool BaseEffect_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "effect_die") { OnEffectDie(); return true; }
		if (name == "effect_duration_ended") { OnEffectDurationEnded(); return true; }
		if (name == "effect_get_timeleft") { OnEffectGetTimeleft(); return true; }
		if (name == "effect_increase_duration") { OnEffectIncreaseDuration(Float(Param(params, 0))); return true; }
		if (name == "effect_set_duration") { OnEffectSetDuration(Param(params, 0)); return true; }
		if (name == "game_activate") { OnGameActivate(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5)); return true; }
		if (name == "game_duplicated") { OnGameDuplicated(); return true; }
		if (name == "game_precache") { OnGamePrecache(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "effects/base_effect"]
shared class BaseEffectScript : ScriptEntity, BaseEffect
{
	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		BaseEffect_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return BaseEffect_DispatchEvent(name, params);
	}
}
