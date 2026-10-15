#pragma context server

// Converted from sorc_villa/sfx_blacksmith.script by msc_transpiler.

#include "runtime/ScriptEntity.as"

[script "sorc_villa/sfx_blacksmith"]
class SfxBlacksmith : ScriptEntity
{
	// Constants
	string SOUND_ANVIL = "amb/fx_anvil.wav";

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		SetUniqueName("sfx_blacksmith");

		SetModel("weapons/p_weapons2.mdl");
		SetIdleAnim("dagger_floor_idle");
		SetModelBody(0, 79);

		SetInvincible(true);
		SetNoPush(true);

		SetAngle("face", Vector3(0, 90, 0));
	}

	// do_spark
	void OnDoSpark()
	{
		Vector3 sparkLoc = OriginOf(ENT_ME);
		PlaySound(0, 5, SOUND_ANVIL);
		// sound.play3d SOUND_BURST 10 FX_CENTER
		ClientEvent("update", "all", Eval("const.localplayer.scriptID"), "fx_spark", sparkLoc);
	}

	// do_forge_fx
	// <fx_tokens> [weapon_script_name]
	void OnDoForgeFx(string fxTokens = "", string weaponScriptName = "")
	{
		Vector3 fxLoc = OriginOf(ENT_ME);

		CallEventDelayed(6.0f, "do_forge_fx_end");

		// meh, this bit don't work, cuz offsets are different, I guess
		// just vanishing the axe instead (lazy)
		SetProp(ENT_ME, "rendermode", 5);
		SetProp(ENT_ME, "renderamt", 255);

		if (weaponScriptName == "swords_ub")
		{
			// setvard SMITH_MODEL weapons/p_weapons3.mdl
			// setvard SMITH_MODEL_ANIM_IDX 1
			// setvard SMITH_MODEL_BODY_IDX 65
			SetModel("weapons/p_weapons3.mdl");
			SetIdleAnim("standard_floor_idle");
			SetModelBody(0, 65);
		}

		if (weaponScriptName == "swords_sf")
		{
			SetModel("weapons/p_weapons3.mdl");
			SetIdleAnim("standard_floor_idle");
			SetModelBody(0, 86);
		}

		if (weaponScriptName == "axes_df")
		{
			SetModel("weapons/p_weapons3.mdl");
			SetIdleAnim("standard_floor_idle");
			SetModelBody(0, 79);
		}

		if (weaponScriptName == "blunt_db")
		{
			SetModel("weapons/p_weapons3.mdl");
			SetIdleAnim("standard_floor_idle");
			SetModelBody(0, 73);
		}

		if (weaponScriptName == "axes_ss")
		{
			SetModel("weapons/p_weapons3.mdl");
			SetIdleAnim("standard_floor_idle");
			SetModelBody(0, 76);
		}

		if (weaponScriptName == "smallarms_vt")
		{
			SetModel("weapons/p_weapons3.mdl");
			SetIdleAnim("standard_floor_idle");
			SetModelBody(0, 68);
		}

		if (weaponScriptName == "blunt_gauntlets_ic")
		{
			SetModel("weapons/p_weapons3.mdl");
			SetIdleAnim("standard_floor_idle");
			SetModelBody(0, 70);
		}

		ClientEvent("update", "all", Eval("const.localplayer.scriptID"), "fx_smith_effect", fxTokens, "skull.spr", "ice_icon.spr");
	}

	// do_forge_fx_end
	void OnDoForgeFxEnd()
	{
		ClientEvent("update", "all", Eval("const.localplayer.scriptID"), "fx_smith_effect", "none");
		SetModel("weapons/p_weapons2.mdl");
		SetIdleAnim("dagger_floor_idle");
		SetModelBody(0, 79);
		SetAngle("face", Vector3(0, 90, 0));
		SetProp(ENT_ME, "rendermode", 0);
		SetProp(ENT_ME, "renderamt", 255);
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("weapons/p_weapons2.mdl");
		Precache("skull.spr");
		Precache("ice_icon.spr");
		Precache("weapons/p_weapons3.mdl");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "do_forge_fx") { OnDoForgeFx(Param(params, 0), Param(params, 1)); return true; }
		if (name == "do_forge_fx_end") { OnDoForgeFxEnd(); return true; }
		if (name == "do_spark") { OnDoSpark(); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		return false;
	}
}
