#pragma context server

// Converted from races.script by msc_transpiler.
// Thothie - adding a vermin race, so bats, rats, etc, don't have to be undead
// - primary reason is I want some vs. undead weapons and some weapons/spells/effects that do not function on undead
// - also adding two utilitarian races: hated and beloved and hguard (human guard, since human's can't attack players)
// - added utility race evil, and race Demon for upcoming scripts

#include "runtime/ScriptEntity.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class Races
{

	// unnamed block (first think)
	void Races_FirstThink()
	{
		// Set up race relationships for the game
		// New races can be added here
		// this race can't attack players
		SetLocal("reg.race.name", "human");
		SetLocal("reg.race.enemies", "all;hated");
		SetLocal("reg.race.allies", "human;beloved");
		SetLocal("reg.race.wary", "none");
		RegisterRace();

		SetLocal("reg.race.name", "hguard");
		SetLocal("reg.race.enemies", "orc;goblin;undead;rogue;hated;evil;demon;torkie");
		SetLocal("reg.race.allies", "hguard;beloved");
		SetLocal("reg.race.wary", "human");
		RegisterRace();

		SetLocal("reg.race.name", "wildanimal");
		SetLocal("reg.race.enemies", "orc;spider;hated;evil;human");
		SetLocal("reg.race.allies", "wildanimal;vermin;beloved");
		SetLocal("reg.race.wary", "none");
		RegisterRace();

		SetLocal("reg.race.name", "undead");
		SetLocal("reg.race.enemies", "human;orc;goblin;good;hated;rogue;hguard");
		SetLocal("reg.race.allies", "undead;spider;vermin;beloved;demon;evil");
		SetLocal("reg.race.wary", "none");
		RegisterRace();

		SetLocal("reg.race.name", "vermin");
		SetLocal("reg.race.enemies", "orc;goblin;hated");
		SetLocal("reg.race.allies", "vermin;undead;spider;wildanimal;beloved;evil");
		SetLocal("reg.race.wary", "human");
		RegisterRace();

		SetLocal("reg.race.name", "spider");
		SetLocal("reg.race.enemies", "all;hated");
		SetLocal("reg.race.allies", "undead;spider;beloved;evil;demon");
		SetLocal("reg.race.wary", "none");
		RegisterRace();

		SetLocal("reg.race.name", "orc");
		SetLocal("reg.race.enemies", "all;hated");
		SetLocal("reg.race.allies", "goblin;orc;beloved;demon;evil");
		SetLocal("reg.race.wary", "none");
		RegisterRace();

		// same as orc - redundant faction - dun do again
		SetLocal("reg.race.name", "goblin");
		SetLocal("reg.race.enemies", "all;hated");
		SetLocal("reg.race.allies", "goblin;orc;beloved;demon;evil");
		SetLocal("reg.race.wary", "none");
		RegisterRace();

		SetLocal("reg.race.name", "rogue");
		SetLocal("reg.race.enemies", "all;hated");
		SetLocal("reg.race.allies", "rogue;beloved");
		SetLocal("reg.race.wary", "none");
		RegisterRace();

		SetLocal("reg.race.name", "giant");
		SetLocal("reg.race.enemies", "all;hated");
		SetLocal("reg.race.allies", "giant;beloved");
		SetLocal("reg.race.wary", "none");
		RegisterRace();

		SetLocal("reg.race.name", "demon");
		SetLocal("reg.race.enemies", "all;hated");
		SetLocal("reg.race.allies", "undead;demon;goblin;orc;evil;vermin;spider;beloved");
		SetLocal("reg.race.wary", "none");
		RegisterRace();

		SetLocal("reg.race.name", "torkie");
		SetLocal("reg.race.enemies", "all;hated");
		SetLocal("reg.race.allies", "torkie;necro;wildanimal;vermin;demon;evil;beloved");
		SetLocal("reg.race.wary", "none");
		RegisterRace();

		// torkaloth necros
		SetLocal("reg.race.name", "necro");
		SetLocal("reg.race.enemies", "all;hated");
		SetLocal("reg.race.allies", "necro;undead;torkie;wildanimal;vermin;demon;evil;beloved");
		SetLocal("reg.race.wary", "none");
		RegisterRace();

		SetLocal("reg.race.name", "ant_red");
		SetLocal("reg.race.enemies", "all;hated;ant_black");
		SetLocal("reg.race.allies", "ant_red;demon;evil;beloved");
		SetLocal("reg.race.wary", "none");
		RegisterRace();

		SetLocal("reg.race.name", "ant_black");
		SetLocal("reg.race.enemies", "all;hated;ant_red");
		SetLocal("reg.race.allies", "ant_black;demon;evil;beloved");
		SetLocal("reg.race.wary", "none");
		RegisterRace();

		// utility race - hostile to player, allies with other hostiles
		SetLocal("reg.race.name", "evil");
		SetLocal("reg.race.enemies", "all;hated");
		SetLocal("reg.race.allies", "evil;demon;goblin;orc;beloved");
		SetLocal("reg.race.wary", "none");
		RegisterRace();

		// utility race - non-hostile to player, allies with other non-hostiles
		SetLocal("reg.race.name", "good");
		SetLocal("reg.race.enemies", "hated;evil;demon;orc;goblin;undead");
		SetLocal("reg.race.allies", "beloved;human;good;hguard");
		SetLocal("reg.race.wary", "none");
		RegisterRace();

		// utility race - misc objects
		SetLocal("reg.race.name", "nothing");
		SetLocal("reg.race.enemies", "none;hated");
		SetLocal("reg.race.allies", "none;beloved");
		SetLocal("reg.race.wary", "none");
		RegisterRace();

		// utility race - point of attack
		SetLocal("reg.race.name", "hated");
		SetLocal("reg.race.enemies", "all;hated");
		SetLocal("reg.race.allies", "none");
		SetLocal("reg.race.wary", "none");
		RegisterRace();

		// utility race - ignored and undamagable
		SetLocal("reg.race.name", "beloved");
		SetLocal("reg.race.enemies", "none");
		SetLocal("reg.race.allies", "all;beloved");
		SetLocal("reg.race.wary", "none");
		RegisterRace();

		// neutral race
		SetLocal("reg.race.name", "neutral");
		SetLocal("reg.race.enemies", "none");
		SetLocal("reg.race.allies", "none");
		SetLocal("reg.race.wary", "none");
		RegisterRace();

		// utility race - hostile to all but this group
		SetLocal("reg.race.name", "hostile1");
		SetLocal("reg.race.enemies", "all;hated");
		SetLocal("reg.race.allies", "hostile1;beloved;evil");
		SetLocal("reg.race.wary", "none");
		RegisterRace();

		// utility race - hostile to all but this group
		SetLocal("reg.race.name", "hostile2");
		SetLocal("reg.race.enemies", "all;hated");
		SetLocal("reg.race.allies", "hostile2;beloved;evil");
		SetLocal("reg.race.wary", "none");
		RegisterRace();

		// utility race - hostile to all but this group
		SetLocal("reg.race.name", "hostile3");
		SetLocal("reg.race.enemies", "all;hated");
		SetLocal("reg.race.allies", "hostile3;beloved;evil");
		SetLocal("reg.race.wary", "none");
		RegisterRace();

		// utility race - hostile to all but this group
		SetLocal("reg.race.name", "hostile4");
		SetLocal("reg.race.enemies", "all;hated");
		SetLocal("reg.race.allies", "hostile4;beloved;evil");
		SetLocal("reg.race.wary", "none");
		RegisterRace();

		// utility race - hostile to all but this group
		SetLocal("reg.race.name", "hostile5");
		SetLocal("reg.race.enemies", "all;hated");
		SetLocal("reg.race.allies", "hostile5;beloved;evil");
		SetLocal("reg.race.wary", "none");
		RegisterRace();
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "races"]
shared class RacesScript : ScriptEntity, Races
{
	// Variables every script that includes this file declares
	string CUR_ITEM = "CUR_ITEM";
	string LOAD_ITEMS = "LOAD_ITEMS";
	int SK_LVL1_MIN = 0;
	int SK_LVL2_MIN = 0;
	int TITLE_MINSKILL = 0;

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		Races_FirstThink();
	}
}
