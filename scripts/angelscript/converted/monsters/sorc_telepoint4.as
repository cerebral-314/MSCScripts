#pragma context server

// Converted from monsters/sorc_telepoint4.script by msc_transpiler.

#include "runtime/ScriptEntity.as"

[script "monsters/sorc_telepoint4"]
class SorcTelepoint4 : ScriptEntity
{
	// Variables (an unset .script variable reads as its own name)
	bool IN_USE = false;
	bool IS_TELE = false;

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		SetUniqueName("sorc_telepoint4");
		SetFly(true);
		SetGravity(0);
		SetInvincible(true);
		SetRace("beloved");
		IN_USE = false;
		SetSolid("none");
		IS_TELE = true;
		SetNoPush(true);

		if (ToLowerCase(MapName()) != "shad_palace")
			return;
		CallEventDelayed(2.0f, "special_reg");
	}

	// special_reg
	void OnSpecialReg()
	{
		if (GetVar("G_RUNE_POINTS") == "G_RUNE_POINTS")
			SetGlobal("G_RUNE_POINTS", "");
		LegacyCommand("token.add", "G_RUNE_POINTS", OriginOf(ENT_ME));
		CallEventDelayed(1.0f, "remove_me");
	}

	// remove_me
	void OnRemoveMe(string caller = "")
	{
		DeleteEntity(ENT_ME);
	}

	// tele_used
	void OnTeleUsed()
	{
		IN_USE = true;
		CallEventDelayed(2.0f, "tele_reset");
	}

	// tele_reset
	void OnTeleReset()
	{
		IN_USE = false;
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "remove_me") { OnRemoveMe(Param(params, 0)); return true; }
		if (name == "special_reg") { OnSpecialReg(); return true; }
		if (name == "tele_reset") { OnTeleReset(); return true; }
		if (name == "tele_used") { OnTeleUsed(); return true; }
		return false;
	}
}
