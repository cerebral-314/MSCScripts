#pragma context server

// Converted from NPCs/tutorial_npc_req_item.script by msc_transpiler.
// These lines are executed before spawn
// Since they appear before the #include, constants defined here override those in the included scripts

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_npc.as"

[script "NPCs/tutorial_npc_req_item"]
class TutorialNpcReqItem : BaseNpcScript
{
	// Constants
	string ANIM_OPEN_DOOR = "gluonshow";

	// Variables (an unset .script variable reads as its own name)
	string ANIM_IDLE = "idle1";
	bool GOT_RAT_SKULL = false;

	// unnamed block (first think)
	void TutorialNpcReqItem_FirstThink()
	{
		ANIM_IDLE = "idle1";
	}

	// npc_spawn
	// called from base_npc at game_spawn - all scripts fire game_spawn just before the NPC is put in the world
	void OnNpcSpawn(string npc = "")
	{
		SetName("Old Hag");
		SetModel("npc/human2.mdl"); // female human model
		SetHealth(1); // she's going to be unkillable, but give her 1hp for internal handeling

		// standard human dimensions
		SetWidth(32);
		SetHeight(96);

		SetInvincible(true); // can't be killed

		SetNoPush(true); // can't be pushed

		SetRace("beloved"); // won't be attacked by other NPC's (see /races.script)

		SetModelBody(0, 0); // standard clothes
		SetModelBody(1, 1); // sets the older face

		// View the model in Jed's HLMV - note that Jed's numbers submodels from 1, while the scripts number from 0
		SetIdleAnim(ANIM_IDLE);
		SetMoveAnim(ANIM_IDLE); // since she doesn't move, we're going to set the move anim to idle as well

		SetSayTextRange(1024); // how distant her saytext commands will be "heard"

		SetMenuAutoOpen(true); // makes it so she'll give her menu to any player that clicks "+use" on her

		CatchSpeech("say_hail", "hail", "hello", "y0", "j0", "wassup", "greet", "gweets"); // will fire the event "say_hail" if any of these text strings appear in player's local chat
		CatchSpeech("say_pretty", "pretty", "skull", "rat"); // will fire the event "say_pretty" if any player uses the word "pretty", "skull", or "rat", in local chat
	}

	// game_menu_getoptions
	// PARAM1 = player recieving the menu
	void OnGameMenuGetoptions(CBasePlayer@ player = null)
	{
		MenuItem menuItem;

		if (GOT_RAT_SKULL)
			return;

		if (Truthy(ItemExists(player, "item_ratskull")))
		{
			SayText("My my, what a pretty skull you've found there...");
			OnMoveMouth();
			menuItem.title = "Offer Golden Rat Skull"; // menu option to add
			menuItem.type = "payment"; // requires an item to activate
			menuItem.data = "item_ratskull"; // item required
			menuItem.callback = "got_rat_skull"; // event to call upon recieving item
			RegisterMenuItem(menuItem); // registers the menu option based on the above vars
		}
		else
		{
			SayText("No one gets by this door until I get my [pretty]!");
			OnMoveMouth();
			menuItem.title = "Your pretty?";
			menuItem.type = "callback";
			menuItem.callback = "say_pretty"; // event to call when menu option is selected
			RegisterMenuItem(menuItem);
		}
	}

	// say_hail
	void OnSayHail()
	{
		if (!GOT_RAT_SKULL)
		{
			SayText("No one gets by this door until I get my [pretty]!");
			OnMoveMouth();
		}
		else
		{
			SayText("Thank you for returning my pretty... I'll be sure to keep it safe, this time.");
		}
	}

	// say_pretty
	void OnSayPretty()
	{
		if (!GOT_RAT_SKULL)
		{
			SayText("Yes! My golden rat skull. Bloody thing grew legs and wandered off... Again!");
			SayText("Find it for me, and I'll open this door - but not before!");
			OnMoveMouth();
		}
		else
		{
			SayText("Thank you. I've got my good eye on it now... It'll not wander off again.");
		}
	}

	// move_mouth
	void OnMoveMouth()
	{
		// this makes her mouth move a bit when she talks
		Say("[0.2]", "[0.2]", "[0.3]", "[0.1]", "[0.1]", "[0.2]", "[0.1]", "[0.1]");
	}

	// got_rat_skull
	void OnGotRatSkull()
	{
		GOT_RAT_SKULL = true;
		SayText("Finally! My pretty rat skull is returned to me! Alright... Here we go...");
		OnMoveMouth();
		PlayAnim("critical", ANIM_OPEN_DOOR);
		CallEventDelayed(0.25f, "open_door"); // delays the event 0.25 seconds to sync with the animation
		SetMenuAutoOpen(false); // she no longer needs the menu, so disable it
	}

	// open_door
	void OnOpenDoor()
	{
		// this fires a map event, presuming there is a func_door with the targetname "hag_door", it will open
		UseTrigger("hag_door");
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("npc/human2.mdl");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		TutorialNpcReqItem_FirstThink();
		BaseNpc_FirstThink();
		MonstersExternals_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "game_menu_getoptions") { OnGameMenuGetoptions(PlayerParam(params, 0)); return true; }
		if (name == "got_rat_skull") { OnGotRatSkull(); return true; }
		if (name == "move_mouth") { OnMoveMouth(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "open_door") { OnOpenDoor(); return true; }
		if (name == "say_hail") { OnSayHail(); return true; }
		if (name == "say_pretty") { OnSayPretty(); return true; }
		return BaseNpcScript::DispatchEvent(name, params);
	}
}
