#pragma context server

// Converted from NPCs/base_fletcher.script by msc_transpiler.
// This was an attempt to allow fletchers to organize arrows
// It won't work, apparently the payment system thinks each tile = 1 item

#include "runtime/ScriptEntity.as"

[script "NPCs/base_fletcher"]
class BaseFletcher : ScriptEntity
{
	// Constants
	string ARROW_STACK_TYPES = "proj_arrow_bluntwooden;proj_arrow_broadhead;proj_arrow_fire;proj_arrow_frost;proj_arrow_gholy;proj_arrow_gpoison;proj_arrow_holy;proj_arrow_jagged;proj_arrow_poison;proj_arrow_silvertipped;proj_arrow_wooden;";
	string BOLT_STACK_TYPES = "proj_bolt_fire;proj_bolt_iron;proj_bolt_silver;proj_bolt_steel;proj_bolt_wooden;";
	string SAYTEXT_NOT_ENOUGH = "You do not have enough of that type of projectile.";
	string SAYTEXT_BUNDLE_DONE = "There you go, all bundled up.";
	string SAYTEXT_BUNDLE = "I can tie your arrows and bolts into neat bundles for quicker access, if you have enough to make such bundles. No charge for this.";
	string ANIM_DONE = "pull_needle";
	string ANIM_NO = "no";
	string ANIM_CONVO = "converse1";

	// Variables (an unset .script variable reads as its own name)
	CBaseEntity@ CUSTOMER_ID = null;
	float LOOP_COUNT = 0.0f;
	bool BUNDLE_MENU = false;
	bool VENDOR_MENU_OFF = false;
	int BUNDLE_AMT = 0;
	string BUNDLE_TYPE = "BUNDLE_TYPE";
	bool ARROW_MENU = false;
	bool BOLT_MENU = false;
	string GIVE_ITEM = "GIVE_ITEM";

	// game_menu_getoptions
	void OnGameMenuGetoptions(CBasePlayer@ player = null)
	{
		int count;
		MenuItem menuItem;

		@CUSTOMER_ID = player;

		if (!BUNDLE_MENU)
		{
			LOOP_COUNT = 0.0f;
			count = GetTokenCount(ARROW_STACK_TYPES);
			for (int i = 0; i < count; i++)
			{
				loopIteration = i;
				OnCheckArrows();
			}
			LOOP_COUNT = 0.0f;
			count = GetTokenCount(ARROW_STACK_TYPES);
			for (int i = 0; i < count; i++)
			{
				loopIteration = i;
				OnCheckBolts();
			}

			// dbg temp BOLT_MENU ARROW_MENU $item_exists(CUSTOMER_ID,proj_arrow_jagged) $item_exists(CUSTOMER_ID,proj_arrow_,partialname)
			if (ARROW_MENU)
			{
				menuItem.title = "Bundle Arrows (120)";
				menuItem.type = "callback";
				menuItem.data = "120";
				menuItem.callback = "bundle_arrows_menu";
				RegisterMenuItem(menuItem);

				menuItem.title = "Bundle Arrows (240)";
				menuItem.type = "callback";
				menuItem.data = "120";
				menuItem.callback = "bundle_arrows_menu";
				RegisterMenuItem(menuItem);
			}

			if (BOLT_MENU)
			{
				menuItem.title = "Bundle Bolts (200)";
				menuItem.type = "callback";
				menuItem.data = "200";
				menuItem.callback = "bundle_bolts_menu";
				RegisterMenuItem(menuItem);

				menuItem.title = "Bundle Bolts (400)";
				menuItem.type = "callback";
				menuItem.data = "400";
				menuItem.callback = "bundle_bolts_menu";
				RegisterMenuItem(menuItem);
			}
		}

		if (!BUNDLE_MENU)
			return;

		if (BUNDLE_TYPE == "arrows")
		{
			LOOP_COUNT = 0.0f;
			count = GetTokenCount(ARROW_STACK_TYPES);
			for (int i = 0; i < count; i++)
			{
				loopIteration = i;
				OnAddArrowOptions();
			}
		}

		if (BUNDLE_TYPE == "bolts")
		{
			LOOP_COUNT = 0.0f;
			count = GetTokenCount(BOLT_STACK_TYPES);
			for (int i = 0; i < count; i++)
			{
				loopIteration = i;
				OnAddBoltOptions();
			}
		}
	}

	// bundle_arrows_menu
	void OnBundleArrowsMenu(CBasePlayer@ value = null, int bundleAmount = 0)
	{
		BUNDLE_MENU = true;
		VENDOR_MENU_OFF = true;
		BUNDLE_AMT = bundleAmount;
		BUNDLE_TYPE = "arrows";
		OpenMenu(CUSTOMER_ID);

		PlayAnim("critical", ANIM_CONVO);
		SayText(SAYTEXT_BUNDLE);
	}

	// bundle_bolts_menu
	void OnBundleBoltsMenu(CBasePlayer@ value = null, int bundleAmount = 0)
	{
		BUNDLE_MENU = true;
		VENDOR_MENU_OFF = true;
		BUNDLE_AMT = bundleAmount;
		BUNDLE_TYPE = "bolts";
		OpenMenu(CUSTOMER_ID);

		PlayAnim("critical", ANIM_CONVO);
		SayText(SAYTEXT_BUNDLE);
	}

	// add_arrow_options
	void OnAddArrowOptions()
	{
		MenuItem menuItem;
		string curItem = GetToken(ARROW_STACK_TYPES, loopIteration);

		string stackString = curItem + ":" + BUNDLE_AMT;

		string callbackString = "give_bundle_" + curItem;

		string titleString = "bundle " + LegacyFunction("item_exists", @CUSTOMER_ID, curItem, "name") + "s";

		DebugPrint("adding_menu item " + curItem + " title " + titleString + " data " + stackString + " callback " + callbackString);

		if (!Truthy(ItemExists(CUSTOMER_ID, curItem)))
			return;
		menuItem.title = titleString;
		menuItem.type = "payment";
		menuItem.data = stackString;
		menuItem.callback = callbackString;
		menuItem.cb_failed = "not_enough_arrows";
		RegisterMenuItem(menuItem);
	}

	// add_bolt_options
	void OnAddBoltOptions()
	{
		MenuItem menuItem;
		DebugPrint("iteration " + loopIteration);
		string curItem = GetToken(BOLT_STACK_TYPES, int(LOOP_COUNT));
		LOOP_COUNT += 1.0f;

		string stackString = curItem + ":" + BUNDLE_AMT;

		string callbackString = "give_bundle_" + curItem;

		if (!Truthy(ItemExists(CUSTOMER_ID, curItem)))
			return;
		string itemName = LegacyFunction("item_exists", @CUSTOMER_ID, curItem, "name");
		menuItem.title = "Bundle " + itemName + "s";
		menuItem.type = "payment";
		menuItem.data = stackString;
		menuItem.callback = callbackString;
		menuItem.cb_failed = "not_enough_arrows";
		RegisterMenuItem(menuItem);
	}

	// check_arrows
	void OnCheckArrows()
	{
		string curItem = GetToken(ARROW_STACK_TYPES, int(LOOP_COUNT));
		LOOP_COUNT += 1.0f;
		string itemName = LegacyFunction("item_exists", @CUSTOMER_ID, curItem, "name");
		ARROW_MENU = true;
	}

	// check_bolts
	void OnCheckBolts()
	{
		string curItem = GetToken(ARROW_STACK_TYPES, int(LOOP_COUNT));
		LOOP_COUNT += 1.0f;
		string itemName = LegacyFunction("item_exists", @CUSTOMER_ID, curItem, "name");
		BOLT_MENU = true;
	}

	// not_enough_arrows
	void OnNotEnoughArrows()
	{
		PlayAnim("critical", ANIM_NO);
		SayText(SAYTEXT_NOT_ENOUGH);
		BUNDLE_MENU = false;
		VENDOR_MENU_OFF = false;
	}

	// give_bundle_proj_arrow_bluntwooden
	void OnGiveBundleProjArrowBluntwooden()
	{
		GIVE_ITEM = "proj_arrow_bluntwooden";
		OnReturnBundle();
	}

	// give_bundle_proj_arrow_broadhead
	void OnGiveBundleProjArrowBroadhead()
	{
		GIVE_ITEM = "proj_arrow_broadhead";
		OnReturnBundle();
	}

	// give_bundle_proj_arrow_fire
	void OnGiveBundleProjArrowFire()
	{
		GIVE_ITEM = "proj_arrow_fire";
		OnReturnBundle();
	}

	// give_bundle_proj_arrow_frost
	void OnGiveBundleProjArrowFrost()
	{
		GIVE_ITEM = "proj_arrow_frost";
		OnReturnBundle();
	}

	// give_bundle_proj_arrow_gholy
	void OnGiveBundleProjArrowGholy()
	{
		GIVE_ITEM = "proj_arrow_gholy";
		OnReturnBundle();
	}

	// give_bundle_proj_arrow_gpoison
	void OnGiveBundleProjArrowGpoison()
	{
		GIVE_ITEM = "proj_arrow_gpoison";
		OnReturnBundle();
	}

	// give_bundle_proj_arrow_holy
	void OnGiveBundleProjArrowHoly()
	{
		GIVE_ITEM = "proj_arrow_holy";
		OnReturnBundle();
	}

	// give_bundle_proj_arrow_jagged
	void OnGiveBundleProjArrowJagged()
	{
		GIVE_ITEM = "proj_arrow_jagged";
		OnReturnBundle();
	}

	// give_bundle_proj_arrow_poison
	void OnGiveBundleProjArrowPoison()
	{
		GIVE_ITEM = "proj_arrow_poison";
		OnReturnBundle();
	}

	// give_bundle_proj_arrow_silvertipped
	void OnGiveBundleProjArrowSilvertipped()
	{
		GIVE_ITEM = "proj_arrow_silvertipped";
		OnReturnBundle();
	}

	// give_bundle_proj_arrow_wooden
	void OnGiveBundleProjArrowWooden()
	{
		GIVE_ITEM = "proj_arrow_wooden";
		OnReturnBundle();
	}

	// give_bundle_proj_bolt_fire
	void OnGiveBundleProjBoltFire()
	{
		GIVE_ITEM = "proj_bolt_fire";
		OnReturnBundle();
	}

	// give_bundle_proj_bolt_iron
	void OnGiveBundleProjBoltIron()
	{
		GIVE_ITEM = "proj_bolt_iron";
		OnReturnBundle();
	}

	// give_bundle_proj_bolt_silver
	void OnGiveBundleProjBoltSilver()
	{
		GIVE_ITEM = "proj_bolt_silver";
		OnReturnBundle();
	}

	// give_bundle_proj_bolt_steel
	void OnGiveBundleProjBoltSteel()
	{
		GIVE_ITEM = "proj_bolt_steel";
		OnReturnBundle();
	}

	// give_bundle_proj_bolt_wooden
	void OnGiveBundleProjBoltWooden()
	{
		GIVE_ITEM = "proj_bolt_wooden";
		OnReturnBundle();
	}

	// return_bundle
	void OnReturnBundle()
	{
		DebugPrint("return_bundle");

		string bundleString = GIVE_ITEM + ":" + BUNDLE_AMT;
		Offer(CUSTOMER_ID, bundleString);
		PlayAnim("critical", ANIM_DONE);
		SayText(SAYTEXT_BUNDLE_DONE);
		BUNDLE_MENU = false;
		VENDOR_MENU_OFF = false;
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "add_arrow_options") { OnAddArrowOptions(); return true; }
		if (name == "add_bolt_options") { OnAddBoltOptions(); return true; }
		if (name == "bundle_arrows_menu") { OnBundleArrowsMenu(PlayerParam(params, 0), Int(Param(params, 1))); return true; }
		if (name == "bundle_bolts_menu") { OnBundleBoltsMenu(PlayerParam(params, 0), Int(Param(params, 1))); return true; }
		if (name == "check_arrows") { OnCheckArrows(); return true; }
		if (name == "check_bolts") { OnCheckBolts(); return true; }
		if (name == "game_menu_getoptions") { OnGameMenuGetoptions(PlayerParam(params, 0)); return true; }
		if (name == "give_bundle_proj_arrow_bluntwooden") { OnGiveBundleProjArrowBluntwooden(); return true; }
		if (name == "give_bundle_proj_arrow_broadhead") { OnGiveBundleProjArrowBroadhead(); return true; }
		if (name == "give_bundle_proj_arrow_fire") { OnGiveBundleProjArrowFire(); return true; }
		if (name == "give_bundle_proj_arrow_frost") { OnGiveBundleProjArrowFrost(); return true; }
		if (name == "give_bundle_proj_arrow_gholy") { OnGiveBundleProjArrowGholy(); return true; }
		if (name == "give_bundle_proj_arrow_gpoison") { OnGiveBundleProjArrowGpoison(); return true; }
		if (name == "give_bundle_proj_arrow_holy") { OnGiveBundleProjArrowHoly(); return true; }
		if (name == "give_bundle_proj_arrow_jagged") { OnGiveBundleProjArrowJagged(); return true; }
		if (name == "give_bundle_proj_arrow_poison") { OnGiveBundleProjArrowPoison(); return true; }
		if (name == "give_bundle_proj_arrow_silvertipped") { OnGiveBundleProjArrowSilvertipped(); return true; }
		if (name == "give_bundle_proj_arrow_wooden") { OnGiveBundleProjArrowWooden(); return true; }
		if (name == "give_bundle_proj_bolt_fire") { OnGiveBundleProjBoltFire(); return true; }
		if (name == "give_bundle_proj_bolt_iron") { OnGiveBundleProjBoltIron(); return true; }
		if (name == "give_bundle_proj_bolt_silver") { OnGiveBundleProjBoltSilver(); return true; }
		if (name == "give_bundle_proj_bolt_steel") { OnGiveBundleProjBoltSteel(); return true; }
		if (name == "give_bundle_proj_bolt_wooden") { OnGiveBundleProjBoltWooden(); return true; }
		if (name == "not_enough_arrows") { OnNotEnoughArrows(); return true; }
		if (name == "return_bundle") { OnReturnBundle(); return true; }
		return false;
	}
}
