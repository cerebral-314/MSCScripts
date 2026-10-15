#pragma context server

// Converted from m2_quest/game_master.script by msc_transpiler.

#include "runtime/ScriptEntity.as"

[script "m2_quest/game_master"]
class M2QuestGameMaster : ScriptEntity
{
	// gm_map_m2_quest_setmusic
	// <target>
	void OnGmMapM2QuestSetmusic(string target = "")
	{
		CBaseEntity@ sylphId = FindByName("sylphiel");
		if (Truthy(ScriptVarOf(sylphId, "DID_FIRST_HELP")))
		{
			if (!Truthy(ScriptVarOf(sylphId, "ALL_QUESTS_DONE")))
			{
				// player on quest, play questie music
				CallExternal(target, "ext_play_music_me", "FortFraeyOrch.mp3");
			}
			else
			{
				// quests done, play some ambiance
				CallExternal(target, "ext_play_music_me", "idemarks_tower_elegie-in-bb-minor.mp3");
			}
		}
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "gm_map_m2_quest_setmusic") { OnGmMapM2QuestSetmusic(Param(params, 0)); return true; }
		return false;
	}
}
