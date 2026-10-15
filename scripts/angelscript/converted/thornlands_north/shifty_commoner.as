#pragma context server

// Converted from thornlands_north/shifty_commoner.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/deralia/commoner.as"

[script "thornlands_north/shifty_commoner"]
class ShiftyCommoner : CommonerScript
{
	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseNpc_OnGameSpawn(playerRace, playerGender); // monsters/base_npc
		BaseXmass_OnGameSpawn(playerRace, playerGender); // monsters/base_xmass

		CallEventDelayed(2.0f, "start_shifty");
		SetSayTextRange(900);
	}

	// start_shifty
	void OnStartShifty()
	{
		SetRoam(false);

		if (int(CHATTER) == 0)
		{
			SayText("Hey, you look like an adventurer. Come here.");
			PlaySound(0, 10, "voices/thornlands_north/shifty1.wav");
			CallEventDelayed(4.5f, "start_shifty");
		}
		else if (CHATTER == 1.0f)
		{
			SayText("I left some... valuable... items in a secret cave near those bears.");
			PlaySound(0, 10, "voices/thornlands_north/shifty2.wav");
			CallEventDelayed(5.7f, "start_shifty");
		}
		else if (CHATTER == 2.0f)
		{
			SayText("You NEED to help me get them back. You will be... well rewarded.");
			PlaySound(0, 10, "voices/thornlands_north/shifty3.wav");
			CallEventDelayed(8.0f, "start_shifty");
		}
		else if (CHATTER == 3.0f)
			UseTrigger("WallBlock11");

		CHATTER += 1.0f;
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "start_shifty") { OnStartShifty(); return true; }
		return CommonerScript::DispatchEvent(name, params);
	}
}
