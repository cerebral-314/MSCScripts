#pragma context server

// Converted from tutorial/chest.script by msc_transpiler.
// Tutorial chest by CrazyMonkeyDude Oct 2009
// Checks what item player recieves from chest and gives a brief description about it
// Opens door when all items are removed

#include "runtime/ScriptEntity.as"
#include "converted/chests/base_treasurechest.as"

[script "tutorial/chest"]
class TutorialChest : BaseTreasurechestScript
{
	// Constants
	bool NO_ORE = true;

	// Variables (an unset .script variable reads as its own name)
	float WEPS_ATTAINED = 0.0f;
	bool NPC_ECHO_ITEMS = false;
	bool DOOR_OPENED = false;

	// unnamed block (first think)
	void TutorialChest_FirstThink()
	{
		WEPS_ATTAINED = 0.0f;

		NPC_ECHO_ITEMS = true;
	}

	// chest_additems
	void OnChestAdditems()
	{
		BaseTreasurechest_OnChestAdditems(); // chests/base_treasurechest
		AddStoreItem(STORENAME, "axes_rsmallaxe", 1, 0);
		AddStoreItem(STORENAME, "swords_rsword", 1, 0);
		AddStoreItem(STORENAME, "smallarms_rknife", 1, 0);
		AddStoreItem(STORENAME, "blunt_hammer1", 1, 0);
		AddStoreItem(STORENAME, "bows_treebow", 1, 0);
		AddStoreItem(STORENAME, "blunt_gauntlets_leather", 1, 0);
	}

	// ext_player_got_item
	// PARAM1: Item | PARAM2: Player
	void OnExtPlayerGotItem(CBaseEntity@ itemEntity = null, CBaseEntity@ owner = null)
	{
		DebugPrint("ext_player_got_item " + EntityId(itemEntity) + " [ " + ItemNameOf(itemEntity) + " ] " + NameOf(owner));

		if (Contains(ItemNameOf(itemEntity), "axes_rsmallaxe"))
		{
			HelpTip(owner, "generic", "Axe Handling", "Axes are slow, but powerful. They also have|a higher chance to miss than most weapons.|At higher levels, and with two-handed axes, you can|perform a leap attack, hitting all enemies|in an area in front of you for lower damage.");
			WEPS_ATTAINED += 1.0f;
			CallEventDelayed(0.1f, "axes_msg");
		}
		if (Contains(ItemNameOf(itemEntity), "swords_rsword"))
		{
			HelpTip(owner, "generic", "Swordsmanship", "Swords are the most balanced of melee weapons,|providing average speed, damage, and hit chance.|Swordsmanship increases Strength, Fitness, and,|to a lower degree, agility and awareness.");
			WEPS_ATTAINED += 1.0f;
		}
		if (Contains(ItemNameOf(itemEntity), "smallarms_rknife"))
		{
			HelpTip(owner, "generic", "Small Arms", "Daggers are fast and accurate, at the cost of damage.|Higher levels allow for a speed burst, enhancing|attack and run speed for a time. Small Arms|increases Strength, Agility, Fitness, and Awareness.");
			WEPS_ATTAINED += 1.0f;
		}
		if (Contains(ItemNameOf(itemEntity), "blunt_hammer1"))
		{
			HelpTip(owner, "generic", "Blunt Arms", "Blunt arms, like this hammer, are slow, but powerful.|Higher levels allow for a stun attack.|Blunt Arms increases Strength heavily, Fitness moderately|and Agility and Awareness minimally.");
			WEPS_ATTAINED += 1.0f;
		}
		if (Contains(ItemNameOf(itemEntity), "bows_treebow"))
		{
			HelpTip(owner, "generic", "Archery", "Bows and crossbows allow you to attack your enemy|at range. Better bows allow for more accuracy, range,|and slightly more damage.");
			CallEventDelayed(0.1f, "bows_msg");
			WEPS_ATTAINED += 1.0f;
		}
		if (Contains(ItemNameOf(itemEntity), "blunt_gauntlets_leather"))
		{
			HelpTip(owner, "generic", "Martial Arts", "Martial Arts uses your fists and feet to deal damage to foes.|Kicking is gained at higher levels, and as you level your martial|arts stat, you will be able to kick enemies away from you and even stun.");
			WEPS_ATTAINED += 1.0f;
			CallEventDelayed(0.1f, "marts_msg");
		}

		CallEventDelayed(7.0f, "trigger_door");
	}

	// trigger_door
	void OnTriggerDoor()
	{
		if (DOOR_OPENED)
			return;
		DOOR_OPENED = true;
		UseTrigger("chest_door");
	}

	// axes_msg
	void OnAxesMsg()
	{
		HelpTip(CHEST_USER, "generic", " ", "Axe Handling increases Strength heavily, Fitness|moderately, and Agility and Awareness minimally.");
	}

	// bows_msg
	void OnBowsMsg()
	{
		HelpTip(CHEST_USER, "generic", " ", "You have an unlimited supply of basic arrows and bolts,|though better ammunition can be bought from vendors,dropped|from monsters, or found in chests around the world of Daragoth.|Crossbows shoots with much higher accuracy, but take longer|to reload. Archery increases Concentration heavily, Strength,|Agility, and Awareness moderately, and Fitness minimally.");
	}

	// marts_msg
	void OnMartsMsg()
	{
		HelpTip(CHEST_USER, "generic", " ", "Martial Arts increases Strength, Agility, Awareness and Fitness.");
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		TutorialChest_FirstThink();
		BaseTreasurechest_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "axes_msg") { OnAxesMsg(); return true; }
		if (name == "bows_msg") { OnBowsMsg(); return true; }
		if (name == "chest_additems") { OnChestAdditems(); return true; }
		if (name == "ext_player_got_item") { OnExtPlayerGotItem(EntityParam(params, 0), EntityParam(params, 1)); return true; }
		if (name == "marts_msg") { OnMartsMsg(); return true; }
		if (name == "trigger_door") { OnTriggerDoor(); return true; }
		return BaseTreasurechestScript::DispatchEvent(name, params);
	}
}
