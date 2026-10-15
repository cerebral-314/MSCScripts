#pragma context server

// Converted from nashalrath/game_master.script by msc_transpiler.

#include "runtime/ScriptEntity.as"

[script "nashalrath/game_master"]
class NashalrathGameMaster : ScriptEntity
{
	// Variables (an unset .script variable reads as its own name)
	string GM_TEAR_TRACKER = "GM_TEAR_TRACKER";
	float GM_NASH_KEYS = 0.0f;
	float GM_NEXT_NASH_MSG = 0.0f;
	string GM_LAST_PLAYER = "GM_LAST_PLAYER";
	float GM_NASH_KEYS_USED = 0.0f;
	bool GM_NASH_KEY1_USED = false;
	bool GM_NASH_KEY2_USED = false;
	bool GM_NASH_KEYS_DONE = false;

	// gm_nash_tear
	void OnGmNashTear(string player = "")
	{
		bool exitSub = false;
		CallExternal(FindByName("metal_cave"), "ext_refresh_cl_fx");

		if (GM_TEAR_TRACKER == "GM_TEAR_TRACKER")
			GM_TEAR_TRACKER = "";

		if (Contains(GM_TEAR_TRACKER, player))
		{
			PlayerMessageGreen(player, "Exiting reality tear...");
			int tokenIdx = FindToken(GM_TEAR_TRACKER, player);
			GM_TEAR_TRACKER = TokenRemove(GM_TEAR_TRACKER, tokenIdx);
			exitSub = true;
		}
		else
		{
			PlayerMessageGreen(player, "Entering reality tear...");
		}
		if (exitSub)
			return;

		GM_TEAR_TRACKER = TokenAdd(GM_TEAR_TRACKER, player);

		InfoMessage(player, "TEAR IN REALITY", "A tear in reality from the Wars of Fate. Apparently, the Lost Loreldians here never mended this one.");
	}

	// gm_nash_cryskey_found
	void OnGmNashCryskeyFound(string player = "")
	{
		if (Text(GM_NASH_KEYS) == "GM_NASH_KEYS")
			GM_NASH_KEYS = 0.0f;
		GM_NASH_KEYS += 1.0f;
		InfoMessage(player, "ARTIFACT FOUND", "You've found an ancient Loreldian crystal key.");
	}

	// gm_crys_key_activate
	// <user> <key_index:1|2>
	void OnGmCrysKeyActivate(string player = "", string keyNumber = "")
	{
		bool exitSub = false;
		DebugPrint("gm_crys_key_activate " + keyNumber);

		if (GM_NASH_KEYS_DONE)
			return;

		if (Float(keyNumber) == 1.0f && GM_NASH_KEY1_USED)
			exitSub = true;

		if (Float(keyNumber) == 2.0f && GM_NASH_KEY2_USED)
			exitSub = true;
		if (exitSub)
			return;

		if (GM_NASH_KEYS == 0.0f)
		{
			if (player == GM_LAST_PLAYER)
			{
				// dont spam the same guy
				if (GameTime() < GM_NEXT_NASH_MSG)
					exitSub = true;
			}
			if (!exitSub)
			{
				GM_NEXT_NASH_MSG = GameTime() + 10.0f;
				GM_LAST_PLAYER = player;

				InfoMessage(player, "CRYSTAL SOCKET KEYHOLE", "This appears to be a crystal shaped socket.");
			}
		}
		else
		{
			if (Text(GM_NASH_KEYS_USED) == "GM_NASH_KEYS_USED")
				GM_NASH_KEYS_USED = 0.0f;
			GM_NASH_KEYS_USED += 1.0f;
			GM_NASH_KEYS -= 1.0f;
			if (Float(keyNumber) == 1.0f)
			{
				UseTrigger("rend_key1_on");
				GM_NASH_KEY1_USED = true;
			}
			if (Float(keyNumber) == 2.0f)
			{
				UseTrigger("rend_key2_on");
				GM_NASH_KEY2_USED = true;
			}

			PlayerMessageGreen(player, "You insert the Loreldian crystal into the socket.");

			if (GM_NASH_KEYS_USED == 2.0f)
			{
				UseTrigger("brk_lordoor");
				GM_NASH_KEYS_DONE = true;

				CallExternal(FindByName("metal_cave"), "ext_clearout");
			}
		}
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "gm_crys_key_activate") { OnGmCrysKeyActivate(Param(params, 0), Param(params, 1)); return true; }
		if (name == "gm_nash_cryskey_found") { OnGmNashCryskeyFound(Param(params, 0)); return true; }
		if (name == "gm_nash_tear") { OnGmNashTear(Param(params, 0)); return true; }
		return false;
	}
}
