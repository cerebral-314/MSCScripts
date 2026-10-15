#pragma context server

// Converted from keledrosruins/spawner4.script by msc_transpiler.
// Thothie - I percieve anything else in the Keledros script that would cause brain death
// - It seems very likely that the createNPC meathod does not clean out memory the same way a standard msmonster_spawn does
// - As such, I'm removing 3 spawners, and replacing with "greater animated warriors" and seeing if it helps various issues
// - Also adding new scrolls to Keledros when I get them (and him) working right
// - This spawn is no longer called by Keledros, but he does call an map event called spawn_archers

#include "runtime/ScriptEntity.as"
#include "converted/keledrosruins/spawner_base.as"

[script "keledrosruins/spawner4"]
class Spawner4 : SpawnerBaseScript
{
	// unnamed block (first think)
	void Spawner4_FirstThink()
	{
		SetUniqueName("spawner4");
	}

	// spawn_undead
	void OnSpawnUndead()
	{
		// //dbg Archer Disabled
		if (Float(GetVar("FOUR_IS_DEAD")) == 1.0f)
			CreateNpc("monsters/anim_archer", OriginOf(ENT_ME), self);
		CallExternal(ENT_LASTCREATED, "four_was_summoned");
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		Spawner4_FirstThink();
		SpawnerBase_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "spawn_undead") { OnSpawnUndead(); return true; }
		return SpawnerBaseScript::DispatchEvent(name, params);
	}
}
