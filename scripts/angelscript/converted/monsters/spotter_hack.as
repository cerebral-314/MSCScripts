#pragma context server

// Converted from monsters/spotter_hack.script by msc_transpiler.
// Spot enemy hack by Thothie
// - For non-agro monsters that have issues spotting enemies, such as guards
// - use callevent 1.0 see_enemy in spawn to start checks
// - bade obsolete by new AI 7/Sep/2006 18:55

#include "runtime/ScriptEntity.as"

[script "monsters/spotter_hack"]
class SpotterHack : ScriptEntity
{
	// Variables (an unset .script variable reads as its own name)
	string CAN_ATTACK = "CAN_ATTACK";
	string CAN_HUNT = "CAN_HUNT";
	string NPC_MOVE_TARGET = "NPC_MOVE_TARGET";
	string NPC_ATTACK_TARGET = "NPC_ATTACK_TARGET";
	string HUNT_LASTTARGET = "HUNT_LASTTARGET";
	string CYCLE_TIME = "CYCLE_TIME";

	// see_enemy
	void OnSeeEnemy()
	{
		bool exitSub = false;

		CallEventDelayed(1.0f, "see_enemy");

		// //dbg HUNT_LASTTARGET
		if (HUNT_LASTTARGET != "HUNT_LASTTARGET" && HUNT_LASTTARGET != "\xAFNONE\xAF")
			exitSub = true;
		if (exitSub)
			return;

		if (CanSee("enemy"))
		{
			if (!Truthy(GetVar("NO_ADVANCED_SEARCHES")))
				SetFieldOfView(359);
			CAN_ATTACK = "1";
			CAN_HUNT = "1";
			NPC_MOVE_TARGET = EntityId(EntityOf(ENT_LASTSEEN));
			NPC_ATTACK_TARGET = NPC_MOVE_TARGET;
			HUNT_LASTTARGET = ENT_LASTSEEN;
			CYCLE_TIME = "CYCLE_TIME_ACTIVE";
			OnCycleUp();
			SetMoveDest(ENT_LASTSEEN, "MOVE_RANGE");
			if (Float(GetProp("range", "ent_lastseen")) < 0.0f)
				OnNpcatkAttackenemy();
		}
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files
	void OnCycleUp(string reason = "") {} // cycle_up
	void OnNpcatkAttackenemy() {} // npcatk_attackenemy

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		CallEventDelayed(1.0f, "see_enemy");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "see_enemy") { OnSeeEnemy(); return true; }
		return false;
	}
}
