#pragma context server

// Converted from global.script by msc_transpiler.
// This is initialization for the game
// This script is run once on the client,
// and once at the startup of each level on the server

#include "runtime/ScriptEntity.as"
#include "converted/races.as"
#include "converted/titles.as"
#include "converted/effects.as"
#include "converted/global/sv_globals.as"
#include "converted/global/server/treasure.as"

[script "global"]
class Global : RacesScript, Titles, Effects, SvGlobals, GlobalServerTreasure
{
	// Variables declared by included files, with the value they start with in this script
	Global()
	{
		SK_LVL1_MIN = 4; // from titles
		SK_LVL2_MIN = 10; // from titles
	}

	// unnamed block (first think)
	void Global_FirstThink()
	{
		// Game constants
		SetGlobal("G_MAX_SKILL_LEVEL", 45);
		SetGlobal("G_MAX_ITEMS", 100);

		// Audio channels. Sounds played on the same channel override each other
		SetGlobal("CHAN_AUTO", 0);
		SetGlobal("CHAN_WEAPON", 1);
		SetGlobal("CHAN_VOICE", 2);
		SetGlobal("CHAN_ITEM", 3);
		SetGlobal("CHAN_BODY", 4);

		// Game defaults
		// Weapon or spell the player can choose to start with
		SetLocal("reg.newchar.weaponlist", "swords_rsword;bows_treebow;smallarms_rknife;axes_rsmallaxe;blunt_hammer1;magic_hand_lightning_weak;polearms_qs");

		// Extra free items the player is given
		SetLocal("reg.newchar.freeitems", "sheath_belt_holster;sheath_back;sheath_dagger;pack_sack");

		// Starting gold
		SetLocal("reg.newchar.gold", 10);

		// The spawnbox model on the HUD
		SetLocal("reg.hud.spawnbox", "models/hud/spawnbox.mdl");

		// The HUD quickslot sounds
		SetLocal("reg.hud.quickslot.select", "ui/buttonrollover.wav");
		SetLocal("reg.hud.quickslot.confirm", "ui/buttonclick.wav");
		SetLocal("reg.hud.quickslot.assign", "ui/buttonrollover.wav");

		// The character model animations on the Join Screen HUD
		SetLocal("reg.hud.char.active_weapon", "idle");
		SetLocal("reg.hud.char.active_noweap", "attention");
		SetLocal("reg.hud.char.figet", "stretch");
		SetLocal("reg.hud.char.highlight", "jump");
		SetLocal("reg.hud.char.upload", "run");
		SetLocal("reg.hud.char.inactive", "sitdown");

		// The item description text
		SetLocal("reg.hud.desctext.x", 0.012f); // Coords in ratio form (0-1) across screen
		SetLocal("reg.hud.desctext.y", 0.72f);

		LegacyCommand("registerdefaults");
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		Races_FirstThink();
		Titles_FirstThink();
		Effects_FirstThink();
		Global_FirstThink();
		SvGlobals_FirstThink();
		GlobalServerTreasure_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return GlobalServerTreasure_DispatchEvent(name, params)
			|| RacesScript::DispatchEvent(name, params);
	}
}
