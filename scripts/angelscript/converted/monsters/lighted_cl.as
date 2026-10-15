#pragma context server

// Converted from monsters/lighted_cl.script by msc_transpiler.
// Adjustable light for monsters
// Add to monster
// ===light system
// { [server] npc_post_spawn //call at spawn or cycle_up
// clientevent persist all monsters/lighted_cl $get(ent_me,index) LIGHT_COLOR LIGHT_RAD
// setvard MY_LIGHT_SCRIPT game.script.last_sent_id
// }
// { [server] game_death
// clientevent remove all MY_LIGHT_SCRIPT
// }

#include "runtime/ScriptEntity.as"

[script "monsters/lighted_cl"]
class LightedCl : ScriptEntity
{
	// remove_me
	void OnRemoveMe(string caller = "")
	{
		RemoveScript();
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "remove_me") { OnRemoveMe(Param(params, 0)); return true; }
		return false;
	}
}
