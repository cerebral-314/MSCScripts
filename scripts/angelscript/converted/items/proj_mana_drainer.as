#pragma context server

// Converted from items/proj_mana_drainer.script by msc_transpiler.
// Attempt to see if I can create an scriptable movable object with no AI
// Figure less resource than a full monster, and less trouble than a client side monster
// no good - projectiles are immune to add/setvelocity

#include "runtime/ScriptEntity.as"

[script "items/proj_mana_drainer"]
class ProjManaDrainer : ScriptEntity
{
	// Constants
	int MP_DRAIN_RATE = 1;
	string CL_SCRIPT = "items/proj_mana_drainer_cl";
	string HOVER_SOUND = "ambience/labdrone2.wav";
	string SOUND_POP = "turret/tu_die2.wav";

	// Variables (an unset .script variable reads as its own name)
	string F_MP_DRAIN_RATE = "F_MP_DRAIN_RATE";
	string MP_DRAIN_OVERRIDE = "MP_DRAIN_OVERRIDE";

	// unnamed block (timer)
	void ProjManaDrainer_Timer()
	{
		CallEventDelayed(1.0f, "ProjManaDrainer_Timer");
		DebugPrint("pulse");
		AddVelocity(ENT_ME, RelativeVelocity(Vector3(0, Random(0, 359), 0), Vector3(0, 500, 0)));
		string scanTarget = LegacyFunction("get_insphere", "player", 64, MyOrigin());
		if (!IsAlive(scanTarget))
			return;
		DebugPrint("drain target " + NameOf(scanTarget) + " " + F_MP_DRAIN_RATE);
		// givemp SCAN_TARGET F_MP_DRAIN_RATE
		PlayerMessageRed(scanTarget, "A corpse light is draining your mana!");
		if (ManaOf(scanTarget) <= 0.0f)
		{
			CallExternal(ENT_EXPOWNER, "drainer_kill", scanTarget);
			CallEventDelayed(0.1f, "end_life");
		}
	}

	// unnamed block (timer)
	void ProjManaDrainer_Timer2()
	{
		CallEventDelayed(30.0f, "ProjManaDrainer_Timer2");
		ServerPlaySound(1, 5, HOVER_SOUND);
	}

	// game_precache
	void OnGamePrecache()
	{
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		SetName("Mana Drainer");

		SetModel("weapons/projectiles.mdl");
		SetModelBody(0, 13); // needs new model
		PlayAnim("spin_horizontal_slow");

		LegacyCommand("movetype", "normal"); // projectile
		SetBoundingBox("none");
		SetSolid("none");

		SetGravity(0);

		SetLocal("reg.proj.dmg", 0);
		SetLocal("reg.proj.dmgtype", "none");
		SetLocal("reg.proj.aoe.range", 0);
		SetLocal("reg.proj.aoe.falloff", 0);
		SetLocal("reg.proj.stick.duration", 0);
		SetLocal("reg.proj.collidehitbox", 0);
		SetLocal("reg.proj.ignorenpc", 1);
		SetLocal("reg.proj.ignoreworld", 1); // this will have to be implemented

		LegacyCommand("registerprojectile");

		CallEventDelayed(60.0f, "end_life");
	}

	// game_tossprojectile
	void OnGameTossprojectile()
	{
		F_MP_DRAIN_RATE = MP_DRAIN_RATE;
		MP_DRAIN_OVERRIDE = ScriptVarOf(ENT_EXPOWNER, "DRAINER_POWER");
		if (MP_DRAIN_OVERRIDE != "DRAINER_POWER")
			F_MP_DRAIN_RATE = MP_DRAIN_OVERRIDE;
		ServerPlaySound(1, 5, HOVER_SOUND);
	}

	// end_life
	void OnEndLife()
	{
		CallExternal(ENT_EXPOWNER, "drainer_died");
		ServerPlaySound(1, 0, HOVER_SOUND);
		PlaySound(0, 10, SOUND_POP);
		// splode fx
		// clientevent new all CL_SCRIPT $get(ent_me,origin)
		CallEventDelayed(0.1f, "remove_me");
	}

	// remove_me
	void OnRemoveMe(string caller = "")
	{
		DeleteEntity(ENT_ME);
		RemoveScript();
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("weapons/projectiles.mdl");
		Precache("ambience/labdrone2.wav");
		CallEventDelayed(1.0f, "ProjManaDrainer_Timer");
		CallEventDelayed(30.0f, "ProjManaDrainer_Timer2");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "end_life") { OnEndLife(); return true; }
		if (name == "game_precache") { OnGamePrecache(); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "game_tossprojectile") { OnGameTossprojectile(); return true; }
		if (name == "remove_me") { OnRemoveMe(Param(params, 0)); return true; }
		if (name == "ProjManaDrainer_Timer") { ProjManaDrainer_Timer(); return true; }
		if (name == "ProjManaDrainer_Timer2") { ProjManaDrainer_Timer2(); return true; }
		return false;
	}
}
