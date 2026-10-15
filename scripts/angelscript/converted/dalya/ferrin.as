#pragma context server

// Converted from dalya/ferrin.script by msc_transpiler.
// Spawn properties

#include "runtime/ScriptEntity.as"

[script "dalya/ferrin"]
class Ferrin : ScriptEntity
{
	// Variables (an unset .script variable reads as its own name)
	bool RETRIEVE = false;

	// spawn
	void OnSpawn()
	{
		SetHealth(30);
		SetGold(50);
		SetName("Ferrin");
		SetWidth(32);
		SetHeight(72);
		SetRace("human");
		SetRoam(false);
		SetModel("npc/human1.mdl");
		SetInvincible(true);
		SetModelBody(0, 2);
		RETRIEVE = false;

		CatchSpeech("say_hi", "hi", "hello", "hail", "greet");

		CatchSpeech("say_dangerous", "dangerous");
		CatchSpeech("say_orcs", "orcs");
		CatchSpeech("say_blackhand", "blackhand");
		CatchSpeech("say_keep", "keep");
		CatchSpeech("say_homage", "homage", "caretaker");
		CatchSpeech("say_picture", "picture");
		CatchSpeech("say_retrieve", "retrieve");
	}

	// say_hi
	// Ramble, bamble...
	void OnSayHi(CBasePlayer@ talkingPlayer = null)
	{
		SayText("Ahh, another traveller? Please feel free to rest, if you like. It's [dangerous] outside these days.");
	}

	// say_dangerous
	void OnSayDangerous()
	{
		SayText("Well, it's getting so that I can't even go into the [keep] to pay my respects! That, and [orcs] are ravaging the land.");
	}

	// say_orcs
	void OnSayOrcs()
	{
		SayText("These terrible [Blackhand] Orcs have been tearing through the countryside lately. They leave me alone because they're afraid of the keep.");
	}

	// say_blackhand
	void OnSayBlackhand()
	{
		SayText("It's a new tribe of Orcs that call themselves the Blackhand. They obey some Orcish Shaman named 'The Blackhand' and wage war upon humans.");
	}

	// say_keep
	void OnSayKeep()
	{
		SayText("The Keledros Keep, of course. I'm the last in a long line of [caretakers] for this bellhouse. We used to serve the Captain Marshall of Keledros.");
	}

	// say_homage
	void OnSayHomage()
	{
		SayText("I used to go into the keep every seventh day of the week...to pay my respects.");
		CallEventDelayed(0.0f, "4");
	}

	// say_homage2
	void OnSayHomage2()
	{
		SayText("There is a picture of my Great Grandfather Luc where I would place flowers...");
		CallEventDelayed(0.0f, "say_homage3");
	}

	// say_homage3
	void OnSayHomage3()
	{
		SayText("Now the place is so infested with evil I can't even get the [picture] out");
	}

	// say_picture
	void OnSayPicture()
	{
		SayText("Will you go into the keep and retrive my picture for me? I would be extremely grateful to you! Please say you will go [retrieve] it?");
	}

	// say_retrieve
	void OnSayRetrieve()
	{
		if ((RETRIEVE ? 1 : 0) != 0)
			return;
		RETRIEVE = true;

		SayText("Thank you so much! Here, you'll need this key to get into the room where it's stored!");
		Offer(ENT_LASTSPOKE, "item_wpkey");
	}

	// give_picture
	// When you've finally retrieved the picture.
	void OnGivePicture(CBasePlayer@ player = null)
	{
		ReceiveOffer("accept");
		SayText("A picture of my Great Grandfather Luc! Thank you so much adventurer! I regret I have little to offer, but take this!");
		Offer(player, "item_storageroomkey");
	}

	// game_menu_getoptions
	void OnGameMenuGetoptions(CBasePlayer@ player = null)
	{
		MenuItem menuItem;
		menuItem.title = "Say Hello";
		menuItem.type = "say";

		int say = RandomInt(2, 4);
		if (say == 1)
			menuItem.data = "Hello";
		else if (say == 2)
			menuItem.data = "Hi";
		else if (say == 3)
			menuItem.data = "Hail";
		else if (say == 4)
			menuItem.data = "Greetings!";
		RegisterMenuItem(menuItem);

		if (Truthy(ItemExists(player, "item_picashlborn")))
		{
			menuItem.title = "Return picture";
			menuItem.type = "payment";
			menuItem.data = "item_picashlborn";
			menuItem.callback = "give_picture";
			RegisterMenuItem(menuItem);
		}
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("npc/human1.mdl");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "game_menu_getoptions") { OnGameMenuGetoptions(PlayerParam(params, 0)); return true; }
		if (name == "give_picture") { OnGivePicture(PlayerParam(params, 0)); return true; }
		if (name == "say_blackhand") { OnSayBlackhand(); return true; }
		if (name == "say_dangerous") { OnSayDangerous(); return true; }
		if (name == "say_hi") { OnSayHi(PlayerParam(params, 0)); return true; }
		if (name == "say_homage") { OnSayHomage(); return true; }
		if (name == "say_homage2") { OnSayHomage2(); return true; }
		if (name == "say_homage3") { OnSayHomage3(); return true; }
		if (name == "say_keep") { OnSayKeep(); return true; }
		if (name == "say_orcs") { OnSayOrcs(); return true; }
		if (name == "say_picture") { OnSayPicture(); return true; }
		if (name == "say_retrieve") { OnSayRetrieve(); return true; }
		if (name == "spawn") { OnSpawn(); return true; }
		return false;
	}
}
