#pragma context server

// Converted from titles.script by msc_transpiler.

#include "runtime/ScriptEntity.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class Titles
{
	// Variables (an unset .script variable reads as its own name)
	int SK_LVL1_MIN = 4;
	int SK_LVL2_MIN = 10;
	int TITLE_MINSKILL = 0;

	// unnamed block (first think)
	void Titles_FirstThink()
	{
		SK_LVL1_MIN = 4; // First title set starts at this level
		SK_LVL2_MIN = 10; // Second title set starts at this level

		// Default title - no skills required
		// --------------------------------------------------------
		RegisterTitle("Adventurer");

		// --------------------------------------------------------
		// //Single high skills
		// //--------------------------------------------------------
		// //At level 4+
		TITLE_MINSKILL = SK_LVL1_MIN;
		RegisterTitle("Swordsman", "swordsmanship");
		RegisterTitle("Martial Artist", "martialarts");
		RegisterTitle("Rogue", "smallarms");
		RegisterTitle("Barbarian", "axehandling");
		RegisterTitle("Basher", "bluntarms");
		RegisterTitle("Marksman", "archery");
		RegisterTitle("Caster", "spellcasting");
		RegisterTitle("Lineman", "polearms");

		// registertitle		Blocker			parry
		// At level 10+
		TITLE_MINSKILL = SK_LVL2_MIN;
		RegisterTitle("Sword Master", "swordsmanship");
		RegisterTitle("Kickboxer", "martialarts");
		RegisterTitle("Thief", "smallarms");
		RegisterTitle("Titan", "axehandling");
		RegisterTitle("Basher", "bluntarms");
		RegisterTitle("Marksman", "archery");
		RegisterTitle("Mage", "spellcasting");
		RegisterTitle("Pikeman", "polearms");

		// registertitle		Defender		parry
		// --------------------------------------------------------
		// Swordsmanship + other
		TITLE_MINSKILL = SK_LVL1_MIN;
		RegisterTitle("Assassin", "swordsmanship;martialarts");
		RegisterTitle("Blademaster", "swordsmanship;smallarms");
		RegisterTitle("Knight", "swordsmanship;axehandling");
		RegisterTitle("Cavalier", "swordsmanship;bluntarms");
		RegisterTitle("Ranger", "swordsmanship;archery");
		RegisterTitle("Blade Caster", "swordsmanship;spellcasting");
		RegisterTitle("Line Defender", "swordsmanship;polearms");

		// registertitle		Fencer		swordsmanship;parry
		// Martial arts + other
		RegisterTitle("Mercenary", "martialarts;smallarms");
		RegisterTitle("Punisher", "martialarts;axehandling");
		RegisterTitle("Mercenary", "martialarts;bluntarms");
		RegisterTitle("Archer", "martialarts;archery");
		RegisterTitle("Aikido Master", "martialarts;spellcasting");
		RegisterTitle("Monk", "martialarts;polearms");

		// registertitle		"Bare Handed Shield"	martialarts;parry
		// Smallarms + other
		RegisterTitle("Thrasher", "smallarms;axehandling");
		RegisterTitle("Thug", "smallarms;bluntarms");
		RegisterTitle("Shadow Archer", "smallarms;archery");
		RegisterTitle("Shadow Weaver", "smallarms;spellcasting");
		RegisterTitle("Shadow Hand", "smallarms;polearms");

		// registertitle		Thug			smallarms;parry
		// Axehandling + other
		RegisterTitle("Berserker", "axehandling;bluntarms");
		RegisterTitle("Hatcheteer", "axehandling;archery");
		RegisterTitle("Battlemage", "axehandling;spellcasting");
		RegisterTitle("Reaper", "axehandling;polearms");

		// registertitle		Titan	 		axehandling;parry
		// Bluntarms + other
		RegisterTitle("Hardy Archer", "bluntarms;archery");
		RegisterTitle("Zauberei Basher", "bluntarms;spellcasting");
		RegisterTitle("Titan", "bluntarms;polearms");

		// registertitle		"Shield Warrior"		bluntarms;parry
		// Archery + other
		RegisterTitle("Archer Arcana", "archery;spellcasting");
		RegisterTitle("Line Archer", "archery;polearms");

		// registertitle		"Shield Archer"		archery;parry
		// Spell Casting + other
		RegisterTitle("Magic Staff", "spellcasting;polearms");
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "titles"]
shared class TitlesScript : ScriptEntity, Titles
{
	// Variables every script that includes this file declares
	string CUR_ITEM = "CUR_ITEM";
	string LOAD_ITEMS = "LOAD_ITEMS";

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		Titles_FirstThink();
	}
}
