#pragma context server

// Converted from old_helena/erkold.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_chat.as"
#include "converted/monsters/base_npc.as"
#include "converted/old_helena/base_old_helena_npc.as"

[script "old_helena/erkold"]
class OldHelenaErkold : BaseNpcScript, BaseChat, BaseOldHelenaNpc
{
	// Constants
	bool NO_HAIL = true;
	bool NO_RUMOR = true;
	bool NO_JOB = true;

	// Variables (an unset .script variable reads as its own name)
	bool HELENA_SAVED = false;
	bool GAVE_REWARD = false;

	// game_menu_getoptions
	void OnGameMenuGetoptions(CBasePlayer@ player = null)
	{
		BaseChat_OnGameMenuGetoptions(player); // monsters/base_chat
		MenuItem menuItem;

		if (!HELENA_SAVED)
			return;
		if (GAVE_REWARD)
			return;

		menuItem.title = "Hail";
		menuItem.type = "callback";
		menuItem.callback = "give_reward";
		RegisterMenuItem(menuItem);
	}

	// old_helena_warboss_died
	// Add winning items
	void OnOldHelenaWarbossDied()
	{
		BaseOldHelenaNpc_OnOldHelenaWarbossDied(); // old_helena/base_old_helena_npc
		SetMenuAutoOpen(true);
		HELENA_SAVED = true;
	}

	// spawn
	void OnSpawn()
	{
		SetHealth(1000);
		SetGold(0);
		SetName("Erkold");
		// ov		128
		SetWidth(32);
		SetHeight(72);
		SetRace("human");
		SetRoam(false); // Don't go roaming around
		SetModel("npc/human1.mdl");
		SetModelBody(1, 2);

		SetBlood("red");
	}

	// give_reward
	void OnGiveReward(CBasePlayer@ player = null)
	{
		if (GAVE_REWARD)
		{
			PlayAnim("critical", "lean");
			OnBchatMouthMove();
			SayText("I wish I had more to give, but most of my belongings went up with the flames.");
		}

		if (GAVE_REWARD)
			return;
		GAVE_REWARD = true;
		OnBchatMouthMove();
		SayText("Thank the gods you saved us! Here! Take this as a reward!");
		Offer(player, GetRandomToken("scroll2_healing_circle_920;scroll_healing_circle"));
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseChat_OnGameSpawn(playerRace, playerGender); // monsters/base_chat
		BaseNpc_OnGameSpawn(playerRace, playerGender); // monsters/base_npc
		BaseOldHelenaNpc_OnGameSpawn(playerRace, playerGender); // old_helena/base_old_helena_npc
	}

	// game_death
	void OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		DqMonsterExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // dq/externals/dq_monster_externals
		MonstersExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/externals
		BaseSelfAdjust_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_self_adjust
		BaseNpc_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseOldHelenaNpc_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // old_helena/base_old_helena_npc
	}

	// game_struck
	void OnGameStruck(float damage = 0.0f, string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		BaseNpc_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseOldHelenaNpc_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // old_helena/base_old_helena_npc
	}

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("npc/human1.mdl");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		BaseChat_FirstThink();
		BaseNpc_FirstThink();
		MonstersExternals_FirstThink();
		BaseOldHelenaNpc_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "game_menu_getoptions") { OnGameMenuGetoptions(PlayerParam(params, 0)); return true; }
		if (name == "give_reward") { OnGiveReward(PlayerParam(params, 0)); return true; }
		if (name == "old_helena_warboss_died") { OnOldHelenaWarbossDied(); return true; }
		if (name == "spawn") { OnSpawn(); return true; }
		return BaseChat_DispatchEvent(name, params)
			|| BaseOldHelenaNpc_DispatchEvent(name, params)
			|| BaseNpcScript::DispatchEvent(name, params);
	}
}
