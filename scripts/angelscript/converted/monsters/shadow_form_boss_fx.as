#pragma context server

// Converted from monsters/shadow_form_boss_fx.script by msc_transpiler.
// server side beam effect

#include "runtime/ScriptEntity.as"

[script "monsters/shadow_form_boss_fx"]
class ShadowFormBossFx : ScriptEntity
{
	// unnamed block (timer)
	void ShadowFormBossFx_Timer()
	{
		CallEventDelayed(10.0f, "ShadowFormBossFx_Timer");
		PlayAnim("once", "rot");
		Effect("beam", "ents", "lgtning.spr", 30, ENT_ME, 1, ENT_ME, 2, Vector3(200, 0, 200), 100, 200, 10.0f);
		Effect("beam", "ents", "lgtning.spr", 30, ENT_ME, 2, ENT_ME, 3, Vector3(200, 0, 200), 100, 200, 10.0f);
		Effect("beam", "ents", "lgtning.spr", 30, ENT_ME, 3, ENT_ME, 4, Vector3(200, 0, 200), 100, 200, 10.0f);
		Effect("beam", "ents", "lgtning.spr", 30, ENT_ME, 1, ENT_ME, 1, Vector3(200, 0, 200), 100, 200, 10.0f);
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		SetNoPush(true);
		SetInvincible(true);
		SetFly(true);
		SetGravity(0);
		SetModel("monsters/shadowform_beams.mdl");
		SetIdleAnim("rot");
		SetMoveAnim("rot");
		SetSolid("none");
		SetBoundingBox("none");
		PlayAnim("once", "rot");
	}

	// remove_beams
	// {
	// repeatdelay 30.0
	// clientevent new all monsters/shadow_form_boss_fx_cl $get(ent_me,index)
	// }
	// called by boss
	void OnRemoveBeams()
	{
		DeleteEntity(ENT_ME);
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/shadowform_beams.mdl");
		CallEventDelayed(10.0f, "ShadowFormBossFx_Timer");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "remove_beams") { OnRemoveBeams(); return true; }
		if (name == "ShadowFormBossFx_Timer") { ShadowFormBossFx_Timer(); return true; }
		return false;
	}
}
