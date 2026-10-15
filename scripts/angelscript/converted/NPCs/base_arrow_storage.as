#pragma context server

// Converted from NPCs/base_arrow_storage.script by msc_transpiler.

#include "runtime/ScriptEntity.as"

[script "NPCs/base_arrow_storage"]
class BaseArrowStorage : ScriptEntity
{
	// Constants
	string ARROW_NAMES = "proj_arrow_bluntwooden;proj_arrow_broadhead;proj_arrow_fire;proj_arrow_frost;proj_arrow_gholy;proj_arrow_holy;proj_arrow_jagged;proj_arrow_poison;proj_arrow_silvertipped;proj_arrow_wooden;";
	string BOLT_NAMES = "proj_bolt_fire;proj_bolt_iron;proj_bolt_silver;proj_bolt_steel;proj_bolt_wooden";
	string SAYTEXT_GIVE_TICKET = "There you go. You can redeem that ticket with most any fletcher in the land.";
	string SAYTEXT_REDEEMTICKET = "Okay, here's your ammo.";
	string SAYTEXT_NOT_ENOUGH = "Sorry, you don't have enough of those for me to sell you the ticket.";
	string SAYTEXT_NOTICKET = "Sorry, I did not recieve the ticket.";
	string ANIM_CHAT = "none";
	string ANIM_YES = "none";
	string ANIM_NO = "none";

	// Variables (an unset .script variable reads as its own name)
	CBaseEntity@ CUSTOMER_ID = null;
	float CHECK_LOOP = 0.0f;

	// game_menu_getoptions
	void OnGameMenuGetoptions(CBasePlayer@ player = null)
	{
		@CUSTOMER_ID = player;

		OnCheckForItem("proj_arrow_bluntwooden");
		OnCheckForItem("proj_arrow_broadhead");
		OnCheckForItem("proj_arrow_fire");
		OnCheckForItem("proj_arrow_frost");
		OnCheckForItem("proj_arrow_gholy");
		OnCheckForItem("proj_arrow_holy");
		OnCheckForItem("proj_arrow_jagged");
		OnCheckForItem("proj_arrow_poison");
		OnCheckForItem("proj_arrow_silvertipped");
		OnCheckForItem("proj_arrow_wooden");
		OnCheckForItem("proj_bolt_fire");
		OnCheckForItem("proj_bolt_iron");
		OnCheckForItem("proj_bolt_silver");
		OnCheckForItem("proj_bolt_steel");
		OnCheckForItem("proj_bolt_wooden");

		if (!Truthy(LegacyFunction("item_exists", @player, "\"item_tk_proj\"", "partialname")))
			return;

		CHECK_LOOP = 0.0f;
		int nNames = GetTokenCount(ARROW_NAMES);
		for (int i = 0; i < nNames; i++)
		{
			loopIteration = i;
			OnListTickets(ARROW_NAMES);
		}

		CHECK_LOOP = 0.0f;
		nNames = GetTokenCount(BOLT_NAMES);
		for (int i = 0; i < nNames; i++)
		{
			loopIteration = i;
			OnListTickets(BOLT_NAMES);
		}
	}

	// gticket_proj_bolt_fire
	void OnGticketProjBoltFire()
	{
		OnGiveTicket("proj_bolt_fire");
	}

	// gticket_proj_bolt_iron
	void OnGticketProjBoltIron()
	{
		OnGiveTicket("proj_bolt_iron");
	}

	// gticket_proj_bolt_silver
	void OnGticketProjBoltSilver()
	{
		OnGiveTicket("proj_bolt_silver");
	}

	// gticket_proj_bolt_steel
	void OnGticketProjBoltSteel()
	{
		OnGiveTicket("proj_bolt_steel");
	}

	// gticket_proj_bolt_wooden
	void OnGticketProjBoltWooden()
	{
		OnGiveTicket("proj_bolt_wooden");
	}

	// gticket_proj_arrow_bluntwooden
	void OnGticketProjArrowBluntwooden()
	{
		OnGiveTicket("proj_arrow_bluntwooden");
	}

	// gticket_proj_arrow_broadhead
	void OnGticketProjArrowBroadhead()
	{
		OnGiveTicket("proj_arrow_broadhead");
	}

	// gticket_proj_arrow_fire
	void OnGticketProjArrowFire()
	{
		OnGiveTicket("proj_arrow_fire");
	}

	// gticket_proj_arrow_frost
	void OnGticketProjArrowFrost()
	{
		OnGiveTicket("proj_arrow_frost");
	}

	// gticket_proj_arrow_gholy
	void OnGticketProjArrowGholy()
	{
		OnGiveTicket("proj_arrow_gholy");
	}

	// gticket_proj_arrow_holy
	void OnGticketProjArrowHoly()
	{
		OnGiveTicket("proj_arrow_holy");
	}

	// gticket_proj_arrow_jagged
	void OnGticketProjArrowJagged()
	{
		OnGiveTicket("proj_arrow_jagged");
	}

	// gticket_proj_arrow_poison
	void OnGticketProjArrowPoison()
	{
		OnGiveTicket("proj_arrow_poison");
	}

	// gticket_proj_arrow_silvertipped
	void OnGticketProjArrowSilvertipped()
	{
		OnGiveTicket("proj_arrow_silvertipped");
	}

	// gticket_proj_arrow_wooden
	void OnGticketProjArrowWooden()
	{
		OnGiveTicket("proj_arrow_wooden");
	}

	// give_ticket
	// param1 item_type
	void OnGiveTicket(string boltType = "")
	{
		string ticketName = "item_tk_";

		Offer(CUSTOMER_ID, ticketName);

		PlayAnim("critical", ANIM_YES);
		SayText(SAYTEXT_GIVE_TICKET);
	}

	// list_tickets
	// PARAM1 string to use
	void OnListTickets(string text = "", string filterText = "")
	{
		MenuItem menuItem;

		string searchItem = GetToken(filterText, int(CHECK_LOOP));

		string searchTicket = "item_tk_" + searchItem;
		if (!Truthy(ItemExists(CUSTOMER_ID, searchTicket)))
			return;

		string ticketName = LegacyFunction("item_exists", @CUSTOMER_ID, searchTicket, "name");
		menuItem.title = "Redeem " + ticketName;
		menuItem.type = "callback";
		menuItem.data = searchItem;
		menuItem.callback = "redeem_ticket";
		RegisterMenuItem(menuItem);
	}

	// redeem_ticket
	// PARAM1=customer_id PARAM2=item to return
	void OnRedeemTicket(CBasePlayer@ customerId = null, string returnItem = "")
	{
		// dbg temp RedeemTicket got $get(PARAM1,name) PARAM2 PARAM3 PARAM4

		string ticketName = "item_tk_" + returnItem;

		if (Truthy(ItemExists(customerId, ticketName)))
		{
			PlayAnim("critical", "ANIM_STORE");

			// dbg temp attempting to remove TICKET_NAME in exchange for ITEM_IN
			string methodHack = LegacyFunction("item_exists", @customerId, ticketName, "remove");
			Offer(customerId, "ITEM_IN:150"); // check code, see if you can offer batches of items
			// other issue is can't control bundle based on item type easily
			// maybe get that $contain(<string>,<look_for_string>) if ( $contain(ITEM_IN,"bolt") local BUNDLE 100
			PlayAnim("critical", ANIM_YES);
			SayText(SAYTEXT_REDEEMTICKET);
		}
		else
		{
			SayText(SAYTEXT_NOTICKET);
			PlayAnim("critical", ANIM_NO);
		}
	}

	// not_enough_arrows
	void OnNotEnoughArrows()
	{
		PlayAnim("critical", ANIM_NO);
		SayText(SAYTEXT_NOT_ENOUGH);
	}

	// check_for_item
	// PARAM1=item //PARAM2=fee
	void OnCheckForItem(string item = "")
	{
		MenuItem menuItem;

		string storageFee = "";
		if (!Truthy(ItemExists(item, item)))
			return;

		string callback = "gticket_" + item;
		string itemName = LegacyFunction("item_exists", item, "SEARCH_NAME", "name");
		menuItem.title = "Store: 150 " + itemName + "s (" + storageFee + "gp )";
		menuItem.type = "payment";
		menuItem.data = "gold:" + storageFee + " " + item + ":150";
		menuItem.callback = callback;
		menuItem.cb_failed = "not_enough_arrows";
		RegisterMenuItem(menuItem);
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "check_for_item") { OnCheckForItem(Param(params, 0)); return true; }
		if (name == "game_menu_getoptions") { OnGameMenuGetoptions(PlayerParam(params, 0)); return true; }
		if (name == "give_ticket") { OnGiveTicket(Param(params, 0)); return true; }
		if (name == "gticket_proj_arrow_bluntwooden") { OnGticketProjArrowBluntwooden(); return true; }
		if (name == "gticket_proj_arrow_broadhead") { OnGticketProjArrowBroadhead(); return true; }
		if (name == "gticket_proj_arrow_fire") { OnGticketProjArrowFire(); return true; }
		if (name == "gticket_proj_arrow_frost") { OnGticketProjArrowFrost(); return true; }
		if (name == "gticket_proj_arrow_gholy") { OnGticketProjArrowGholy(); return true; }
		if (name == "gticket_proj_arrow_holy") { OnGticketProjArrowHoly(); return true; }
		if (name == "gticket_proj_arrow_jagged") { OnGticketProjArrowJagged(); return true; }
		if (name == "gticket_proj_arrow_poison") { OnGticketProjArrowPoison(); return true; }
		if (name == "gticket_proj_arrow_silvertipped") { OnGticketProjArrowSilvertipped(); return true; }
		if (name == "gticket_proj_arrow_wooden") { OnGticketProjArrowWooden(); return true; }
		if (name == "gticket_proj_bolt_fire") { OnGticketProjBoltFire(); return true; }
		if (name == "gticket_proj_bolt_iron") { OnGticketProjBoltIron(); return true; }
		if (name == "gticket_proj_bolt_silver") { OnGticketProjBoltSilver(); return true; }
		if (name == "gticket_proj_bolt_steel") { OnGticketProjBoltSteel(); return true; }
		if (name == "gticket_proj_bolt_wooden") { OnGticketProjBoltWooden(); return true; }
		if (name == "list_tickets") { OnListTickets(Param(params, 0), Param(params, 1)); return true; }
		if (name == "not_enough_arrows") { OnNotEnoughArrows(); return true; }
		if (name == "redeem_ticket") { OnRedeemTicket(PlayerParam(params, 0), Param(params, 1)); return true; }
		return false;
	}
}
