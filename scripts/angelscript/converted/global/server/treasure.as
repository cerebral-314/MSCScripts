#pragma context server

// Converted from global/server/treasure.script by msc_transpiler.

#include "runtime/ScriptEntity.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class GlobalServerTreasure
{
	// Variables (an unset .script variable reads as its own name)
	string LOAD_ITEMS = "LOAD_ITEMS";
	string CUR_ITEM = "CUR_ITEM";

	// unnamed block (first think)
	void GlobalServerTreasure_FirstThink()
	{
		int count;

		// ======== Treasure Arrays [begin]
		// NEWB
		SetGlobal("G_NOOB_ITEMS1", "smallarms_royaldagger;smallarms_stiletto;blunt_maul;blunt_mace;blunt_hammer1;blunt_hammer2;bows_treebow;bows_orcbow;smallarms_rknife;smallarms_knife;smallarms_dagger;bows_shortbow;shields_buckler;health_apple;");
		SetGlobal("G_NOOB_ITEMS2", "skin_boar;skin_boar_heavy;skin_ratpelt;skin_bear;drink_ale;drink_mead;swords_katana;drink_wine;blunt_warhammer;swords_rsword;swords_shortsword;smallarms_dirk;swords_longsword;swords_scimitar;");
		SetGlobal("G_NOOB_ITEMS3", "swords_bastardsword;item_galat_note_10;axes_rsmallaxe;axes_smallaxe;axes_axe;axes_battleaxe;axes_greataxe;axes_scythe;axes_2haxe;gold_pouch_5;gold_pouch_10;gold_pouch_25;sheath_holster_snakeskin;");
		SetGlobal("G_NOOB_ITEMS4", "sheath_belt_holster_snakeskin;blunt_gauntlets_leather;sheath_dagger_snakeskin;sheath_belt_snakeskin;sheath_belt_holster_snakeskin;sheath_axe_snakeskin;sheath_blunt_snakeskin;sheath_dagger;sheath_back;sheath_belt;");
		SetGlobal("G_NOOB_ITEMS5", "sheath_belt_holster;sheath_back_holster;sheath_belt_snakeskin;pack_bigsack;pack_xbowquiver;pack_quiver;armor_leather;armor_leather_torn;scroll_glow;swords_skullblade2;smallarms_craftedknife2;");
		SetGlobal("G_NOOB_ITEMS6", "polearms_qs;polearms_sp;");
		SetGlobal("G_NOOB_SETS", 6); // you can add up to G_NOOB_ITEMS9 without changing any scripts, but change this number accordingly

		// GOOD
		SetGlobal("G_GOOD_ITEMS1", "smallarms_huggerdagger2;smallarms_craftedknife;swords_katana2;swords_skullblade;swords_skullblade3;scroll_fire_dart;scroll_lightning_weak;armor_leather_studded;shields_ironshield;pack_archersquiver;");
		SetGlobal("G_GOOD_ITEMS2", "item_crystal_return;swords_nkatana;armor_helm_bronze;gold_pouch_50;gold_pouch_100;item_light_crystal;scroll2_lightning_weak;bows_longbow;scroll2_glow;scroll_poison;sheath_spellbook;");
		SetGlobal("G_GOOD_ITEMS3", "sheath_back_snakeskin;blunt_greatmaul;pack_heavybackpack;armor_helm_plate;armor_helm_mongol;armor_plate;armor_mongol;polearms_ba;mana_lleadfoot;");
		SetGlobal("G_GOOD_SETS", 3);

		// GREAT
		SetGlobal("G_GREAT_ITEMS1", "smallarms_huggerdagger;swords_katana3;bows_swiftbow;smallarms_craftedknife3;swords_skullblade4;scroll_summon_undead;armor_knight;armor_helm_knight;shields_lironshield;blunt_gauntlets;scroll2_rejuvenate;blunt_hammer3;");
		SetGlobal("G_GREAT_ITEMS2", "item_crystal_reloc;scroll2_fire_dart;scroll2_frost_xolt;scroll2_poison;armor_fireliz;armor_salamander;gold_pouch_200;scroll2_summon_rat;mana_leadfoot;mana_prot_spiders;swords_liceblade;swords_poison1;scroll_summon_rat;");
		SetGlobal("G_GREAT_ITEMS3", "armor_leather_gaz1;scroll2_summon_undead;axes_poison1;scroll_fire_ball;polearms_hal;mana_lleadfoot;");
		SetGlobal("G_GREAT_SETS", 3);

		// Arrows
		// there's some overlap in this list, but there really aren't four teirs of arrows.
		SetGlobal("G_NOOB_ARROWS", "proj_arrow_blunt;proj_arrow_bluntwooden;proj_arrow_wooden;proj_arrow_broadhead;proj_arrow_silvertipped;proj_bolt_wooden;proj_bolt_wooden");
		SetGlobal("G_GOOD_ARROWS", "proj_arrow_blunt;proj_arrow_broadhead;proj_arrow_silvertipped;proj_arrow_jagged;proj_arrow_fire;proj_bolt_iron");
		SetGlobal("G_GREAT_ARROWS", "proj_arrow_blunt;proj_arrow_jagged;proj_arrow_poison;proj_arrow_frost;proj_arrow_holy;proj_bolt_steel");
		SetGlobal("G_EPIC_ARROWS", "proj_arrow_blunt;proj_arrow_poison;proj_arrow_frost;proj_arrow_holy;proj_arrow_gholy;proj_arrow_gpoison;proj_arrow_lightning;proj_bolt_fire;proj_bolt_fire;proj_bolt_steel;proj_bolt_steel;proj_bolt_silver");

		// GLOBAL EPIC TREASURE ARRAY
		// token array format: <item>;<frequency>
		if (GetGlobalArrayCount("G_ARRAY_EPIC") == -1)
		{
			GlobalArrayCreate("G_ARRAY_EPIC");
			LOAD_ITEMS = "smallarms_huggerdagger3;6;scroll_fire_wall;5;smallarms_huggerdagger4;10;scroll_rejuvenate;10;smallarms_craftedknife4;10;mana_demon_blood;1";
			count = GetTokenCount(LOAD_ITEMS);
			for (int i = 0; i < count; i++)
			{
				loopIteration = i;
				OnAddEpicArray();
			}
			LOAD_ITEMS = "scroll2_lightning_chain;1;scroll_lightning_chain;1;item_galat_note_100;10;mana_regen;1;mana_vampire;1;swords_spiderblade;5;blunt_granitemace;5;swords_iceblade;2;gold_pouch_500;10";
			count = GetTokenCount(LOAD_ITEMS);
			for (int i = 0; i < count; i++)
			{
				loopIteration = i;
				OnAddEpicArray();
			}
			LOAD_ITEMS = "scroll_volcano;1;scroll_ice_wall;1;smallarms_bone_blade;1;mana_forget;10;mana_speed;1;mana_gprotection;1;mana_protection;2;blunt_granitemaul;5;mana_resist_cold;10;scroll2_fire_ball;3";
			count = GetTokenCount(LOAD_ITEMS);
			for (int i = 0; i < count; i++)
			{
				loopIteration = i;
				OnAddEpicArray();
			}
			LOAD_ITEMS = "mana_immune_fire;1;mana_immune_poison;1;scroll2_ice_wall;1;axes_thunder11;3;scroll2_turn_undead;5;scroll2_fire_wall;1";
			count = GetTokenCount(LOAD_ITEMS);
			for (int i = 0; i < count; i++)
			{
				loopIteration = i;
				OnAddEpicArray();
			}
			LOAD_ITEMS = "blunt_gauntlets_serpant;1;armor_helm_gaz1;1;smallarms_flamelick;2;armor_helm_golden;3;mana_resist_fire;5;mana_immune_cold;1";
			count = GetTokenCount(LOAD_ITEMS);
			for (int i = 0; i < count; i++)
			{
				loopIteration = i;
				OnAddEpicArray();
			}
			LOAD_ITEMS = "polearms_tri;5;polearms_nag;1;mana_lsb;1;mana_bravery;1;item_crystal_reloc;3;mana_lleadfoot;5;mana_st;5;armor_helm_alvo1;1";
			count = GetTokenCount(LOAD_ITEMS);
			for (int i = 0; i < count; i++)
			{
				loopIteration = i;
				OnAddEpicArray();
			}
		}

		// pots
		SetGlobal("G_NOOB_POTS", "health_apple;health_mpotion;health_lpotion;mana_mpotion;mana_resist_fire;mana_prot_spiders;mana_bravery;mana_fbrand;mana_faura;mana_paura;mana_st");
		SetGlobal("G_GOOD_POTS", "health_spotion;mana_forget;mana_resist_cold;mana_vampire;mana_prot_spiders;mana_bravery;mana_fbrand;mana_faura;mana_paura;mana_lsb;mana_lleadfoot;mana_st");
		SetGlobal("G_GREAT_POTS", "mana_forget;mana_protection;mana_resist_cold;mana_demon_blood;mana_regen;mana_immune_lightning;mana_bravery;mana_fbrand;mana_faura;mana_paura;mana_lsb;mana_lleadfoot");
		SetGlobal("G_EPIC_POTS", "mana_gprotection;mana_protection;mana_immune_cold;mana_immune_fire;mana_immune_poison;mana_demon_blood;mana_regen;mana_vampire;mana_leadfoot;mana_immune_lightning;mana_faura;mana_lsb;mana_sb;");
	}

	// add_epic_array
	void GlobalServerTreasure_OnAddEpicArray()
	{
		bool exitSub = false;
		float curIdx = loopIteration;
		CUR_ITEM = GetToken(LOAD_ITEMS, int(curIdx));
		if (int(CUR_ITEM.length()) <= 3) // this is a number iterator, skip to next
			exitSub = true;
		if (exitSub)
			return;
		curIdx += 1.0f;
		int curFreq = Int(GetToken(LOAD_ITEMS, int(curIdx)));
		int outerIteration = loopIteration;
		for (int i = 0; i < curFreq; i++)
		{
			loopIteration = i;
			OnAddEpicItem();
		}
		loopIteration = outerIteration;
	}

	// add_epic_item
	void GlobalServerTreasure_OnAddEpicItem()
	{
		// dbg add_epic_item CUR_ITEM
		GlobalArrayAdd("G_ARRAY_EPIC", CUR_ITEM);
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)
	void OnAddEpicArray() { GlobalServerTreasure_OnAddEpicArray(); } // add_epic_array
	void OnAddEpicItem() { GlobalServerTreasure_OnAddEpicItem(); } // add_epic_item

	// This file's events and timers by their .script names
	bool GlobalServerTreasure_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "add_epic_array") { OnAddEpicArray(); return true; }
		if (name == "add_epic_item") { OnAddEpicItem(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "global/server/treasure"]
shared class GlobalServerTreasureScript : ScriptEntity, GlobalServerTreasure
{
	// Variables every script that includes this file declares
	int SK_LVL1_MIN = 0;
	int SK_LVL2_MIN = 0;
	int TITLE_MINSKILL = 0;

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		GlobalServerTreasure_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return GlobalServerTreasure_DispatchEvent(name, params);
	}
}
