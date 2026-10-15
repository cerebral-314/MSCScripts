#pragma context server

// Converted from monsters/khaz_model_test.script by msc_transpiler.

#include "runtime/ScriptEntity.as"

[script "monsters/khaz_model_test"]
class KhazModelTest : ScriptEntity
{
	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		SetModel("monsters/khaz.mdl");
		SetInvincible(true);
		SetRace("beloved");
		SetSolid("none");
		SetBoundingBox(Vector3(0, 0, 0), Vector3(0, 0, 0));
	}

	// ext_anim
	void OnExtAnim(string animName = "")
	{
		PlayAnim("once", animName);
	}

	// npc_suicide
	void OnNpcSuicide(string suicideMode = "")
	{
		DeleteEntity(ENT_ME, "fade");
	}

	// ext_faceme
	void OnExtFaceme(CBaseEntity@ target = null)
	{
		DebugPrint(EntityId(target) + " " + NameOf(target));
		SetMoveDest(@target, 9999);
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/khaz.mdl");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "ext_anim") { OnExtAnim(Param(params, 0)); return true; }
		if (name == "ext_faceme") { OnExtFaceme(EntityParam(params, 0)); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "npc_suicide") { OnNpcSuicide(Param(params, 0)); return true; }
		return false;
	}
}
