#pragma context server

// Converted from joe/ignite.script by msc_transpiler.
// Ignite script for use with torches - JUN2011, Joe
// Triggers 'ignite' and 'wave1' when fed a torch.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_npc.as"

[script "joe/ignite"]
class Ignite : BaseNpcScript
{
	// game_damaged
	string Ignite_OnGameDamaged(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float accuracyRoll = 0.0f, CBaseEntity@ inflictor = null, string skill = "")
	{
		string result = "";
		SetHealth(99999);

		if (!Contains(damageType, "fire"))
			return result;
		OnItemtaken();
		return result;
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		SetName("Fuse");
		SetModel("misc/item_log.mdl");
		SetInvincible(false);
		SetNoPush(true);
		SetHealth(99999);
		SetDamageTaken("all", 0.01f);
		SetDamageTaken("fire", 1);
		SetDamageTaken("cold", 0);
		SetDamageTaken("blunt", 0);
		SetDamageTaken("pierce", 0);
		SetDamageTaken("slash", 0);
		SetDamageTaken("dark", 0);
		SetDamageTaken("generic", 0);

		SetRace("beloved");
		PLAYING_DEAD = "1";

		SetProp(ENT_ME, "rendermode", 5);
		SetProp(ENT_ME, "renderamt", 0);

		SetWidth(24);
		SetHeight(12);

		SetAlive(true);

		SetMenuAutoOpen(true);
	}

	// itemtaken
	void OnItemtaken()
	{
		UseTrigger("ignite");
		DeleteEntity(ENT_ME);
	}

	// game_menu_getoptions
	void OnGameMenuGetoptions(CBasePlayer@ player = null)
	{
		MenuItem menuItem;

		if (Truthy(ItemExists(player, "item_torch")))
		{
			menuItem.id = "takeitem";
			menuItem.title = "Lite with torch";
			menuItem.type = "payment";
			menuItem.data = "item_torch";
			menuItem.callback = "itemtaken";

			RegisterMenuItem(menuItem);
		}
		else
		{
			PlayerMessageDark(ENT_LASTUSED, "Nothing to lite fuse with.");
		}
	}

	string OnGameDamaged(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float accuracyRoll = 0.0f, CBaseEntity@ inflictor = null, string skill = "") { return Ignite_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill); } // game_damaged

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("misc/item_log.mdl");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "game_damaged") { Return(OnGameDamaged(EntityParam(params, 0), Float(Param(params, 1)), Param(params, 2), Float(Param(params, 3)), EntityParam(params, 4), Param(params, 5))); return true; }
		if (name == "game_menu_getoptions") { OnGameMenuGetoptions(PlayerParam(params, 0)); return true; }
		if (name == "itemtaken") { OnItemtaken(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		return BaseNpcScript::DispatchEvent(name, params);
	}
}
