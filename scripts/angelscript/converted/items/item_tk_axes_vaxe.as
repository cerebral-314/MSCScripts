#pragma context server

// Converted from items/item_tk_axes_vaxe.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/items/base_ticket.as"

[script "items/item_tk_axes_vaxe"]
class ItemTkAxesVaxe : BaseTicketScript
{
	// ticket_spawn
	void OnTicketSpawn()
	{
		SetName("Ticket for Blood Axe");
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
