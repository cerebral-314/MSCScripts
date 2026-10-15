#pragma context server

// Converted from items/item_log_magic.script by msc_transpiler.
// Thothie - Playing with fire... wood.

#include "runtime/ScriptEntity.as"
#include "converted/items/base_miscitem.as"

[script "items/item_log_magic"]
class ItemLogMagic : BaseMiscitemScript
{
	// Constants
	string TORCH_LIGHT_SCRIPT = "player/player_conartist";

	// Variables (an unset .script variable reads as its own name)
	string SCRIPT_ID = "SCRIPT_ID";
	bool IN_WORLD = false;
	bool PARTY_STARTED = false;

	// Variables declared by included files, with the value they start with in this script
	ItemLogMagic()
	{
		MODEL_WORLD = "misc/item_log.mdl";
		MODEL_HANDS = "misc/item_log.mdl";
	}

	// game_remove
	void OnGameRemove()
	{
		BaseItemExtras_OnGameRemove(); // items/base_item_extras
		ClientEvent("remove", "all", SCRIPT_ID);
		IN_WORLD = false;
	}

	// game_drop
	void OnGameDrop()
	{
		BaseItemExtras_OnGameDrop(); // items/base_item_extras
		BaseMiscitem_OnGameDrop(); // items/base_miscitem

		// applyeffect ent_me effects/dot_fire 999 $get(ent_owner,id) 0
		ClientEvent("persist", "all", TORCH_LIGHT_SCRIPT, "disco", IndexOf(ENT_ME));
		SCRIPT_ID = LastClientScriptId();
		IN_WORLD = true;
		if (!PARTY_STARTED)
		{
			PARTY_STARTED = true;
			CallEventDelayed(0.2f, "music_loop");
		}
		CallEventDelayed(0.1f, "world_boogie");
	}

	// game_pickup
	void OnGamePickup()
	{
		BaseMiscitem_OnGamePickup(); // items/base_miscitem

		// callexternal effects/dot_fire effect_die
		ClientEvent("remove", "all", SCRIPT_ID);
		IN_WORLD = false;
	}

	// miscitem_spawn
	void OnMiscitemSpawn()
	{
		SetName("Magical Firewood");
		SetDescription("Some strange artifact assembled by a somewhat flamboyant wizard");
		SetWeight(7);
		SetValue(5);
		SetHudSprite("trade", "log");
	}

	// world_boogie
	void OnWorldBoogie()
	{
		CallEventDelayed(0.2f, "world_boogie");
		if (!IN_WORLD)
			return;
		SetProp(ENT_ME, "rendermode", 5);
		SetProp(ENT_ME, "renderamt", RandomInt(80, 255));
	}

	// music_loop
	void OnMusicLoop()
	{
		CallEventDelayed(13.2f, "music_loop");
		if (!IN_WORLD)
			return;
		PlaySound(0, 10, "magic/disco_loop.wav");
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("misc/item_log.mdl");
		CallEventDelayed(0.2f, "world_boogie");
		CallEventDelayed(13.2f, "music_loop");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "game_drop") { OnGameDrop(); return true; }
		if (name == "game_pickup") { OnGamePickup(); return true; }
		if (name == "game_remove") { OnGameRemove(); return true; }
		if (name == "miscitem_spawn") { OnMiscitemSpawn(); return true; }
		if (name == "music_loop") { OnMusicLoop(); return true; }
		if (name == "world_boogie") { OnWorldBoogie(); return true; }
		return BaseMiscitemScript::DispatchEvent(name, params);
	}
}
