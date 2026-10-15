#pragma context server

// Converted from monsters/fire_reaver_cl.script by msc_transpiler.
// Fire Reaver client side volcano effect

#include "runtime/ScriptEntity.as"

[script "monsters/fire_reaver_cl"]
class FireReaverCl : ScriptEntity
{
	// Variables (an unset .script variable reads as its own name)
	bool VOLC_SOUND_DELAY = false;
	bool FX_ACTIVE = false;

	// reset_volc_sound_delay
	void OnResetVolcSoundDelay()
	{
		VOLC_SOUND_DELAY = false;
	}

	// game_prerender
	void OnGamePrerender()
	{
		if (Truthy(LegacyFunction("getcl", "MY_OWNER", "exists")))
			return;
		OnVolcanoDie();
	}

	// end_fx
	void OnEndFx(string reason = "")
	{
		FX_ACTIVE = false;
		CallEventDelayed(2.0f, "volcano_die");
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files
	void OnVolcanoDie() {} // volcano_die

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "end_fx") { OnEndFx(Param(params, 0)); return true; }
		if (name == "game_prerender") { OnGamePrerender(); return true; }
		if (name == "reset_volc_sound_delay") { OnResetVolcSoundDelay(); return true; }
		return false;
	}
}
