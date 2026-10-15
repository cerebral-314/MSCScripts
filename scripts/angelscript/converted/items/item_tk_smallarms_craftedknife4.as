#pragma context server

// Converted from items/item_tk_smallarms_craftedknife4.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/items/base_ticket.as"

[script "items/item_tk_smallarms_craftedknife4"]
class ItemTkSmallarmsCraftedknife4 : BaseTicketScript
{
	// ticket_spawn
	void OnTicketSpawn()
	{
		SetName("Ticket for FCK4");
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "ticket_spawn") { OnTicketSpawn(); return true; }
		return BaseTicketScript::DispatchEvent(name, params);
	}
}
