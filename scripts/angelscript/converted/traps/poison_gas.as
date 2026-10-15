#pragma context server

// Converted from traps/poison_gas.script by msc_transpiler.
// poison gas trap DOT
// takes addparam set_aoe;<radius> (default 256)
// damage scales by % of maxhealth
// dmgmulti can be used to increase damage

#include "runtime/ScriptEntity.as"

[script "traps/poison_gas"]
class PoisonGas : ScriptEntity
{
	// Variables (an unset .script variable reads as its own name)
	string PLAYING_DEAD = "PLAYING_DEAD";
	string TRAP_AOE = "TRAP_AOE";
	Vector3 DOT_ORG = Vector3();
	bool IS_ACTIVE = false;

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		SetName("Poison Gas Trap");
		SetModel("null.mdl");
		SetHealth(1);
		SetWidth(1);
		SetHeight(1);
		SetInvincible(true);
		SetGravity(0);
		SetFly(true);
		SetBlood("none");
		SetRace("hated");
		PLAYING_DEAD = "1";
		SetNoPush(true);
		CallEventDelayed(0.1f, "start_dot");
	}

	// game_postspawn
	void OnGamePostspawn(string title = "", string damageMultiplier = "", string healthMultiplier = "", string params = "")
	{
		if (StartsWith(params, "set_"))
			OnSetAoe(GetToken(params, 1));

		if (!(Float(damageMultiplier) > 1.0f))
			return;
		SetDamageMultiplier(Float(damageMultiplier));
	}

	// start_dot
	void OnStartDot()
	{
		if (TRAP_AOE == "TRAP_AOE")
			TRAP_AOE = "256";
		DOT_ORG = OriginOf(ENT_ME);
		DOT_ORG.z = GroundHeight(DOT_ORG);
		ClientEvent("new", "all", "effects/sfx_poison_cloud", DOT_ORG, TRAP_AOE, 20.0f);
		IS_ACTIVE = true;
		OnDotLoop();
		CallEventDelayed(20.0f, "dot_end");
	}

	// dot_loop
	void OnDotLoop()
	{
		if (!IS_ACTIVE)
			return;
		CallEventDelayed(1.0f, "dot_loop");
		DoDamageEx(DOT_ORG, TRAP_AOE, 0, 0, ENT_ME, ENT_ME, "none", "target", "dmgevent:dot");
	}

	// dot_dodamage
	void OnDotDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		if (!hit)
			return;
		float dot = MaxHealthOf(target) * 0.1f;
		ApplyEffect(target, "effects/dot_poison", 10.0f, self, dot);
	}

	// dot_end
	void OnDotEnd()
	{
		IS_ACTIVE = false;
		CallEventDelayed(11.0f, "npc_suicide");
	}

	// npc_suicide
	void OnNpcSuicide(string suicideMode = "")
	{
		SetOrigin(ENT_ME, Vector3(20000, 10000, 30000));
		SetInvincible(false);
		DoDamage(ENT_ME, "direct", 99999, 100, GetVar("GAME_MASTER"), "target");
	}

	// game_dynamically_created
	// <aoe>
	void OnGameDynamicallyCreated(string creatorValue1 = "", string creatorValue2 = "", string damage = "", string skill = "", string extraValue5 = "", string extraValue6 = "", float alwaysPush = 0.0f, string duration = "", string extraValue9 = "")
	{
		TRAP_AOE = creatorValue1;
	}

	// set_aoe
	void OnSetAoe(string aoeRadius = "")
	{
		TRAP_AOE = aoeRadius;
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("null.mdl");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "dot_dodamage") { OnDotDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5)); return true; }
		if (name == "dot_end") { OnDotEnd(); return true; }
		if (name == "dot_loop") { OnDotLoop(); return true; }
		if (name == "game_dynamically_created") { OnGameDynamicallyCreated(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Float(Param(params, 6)), Param(params, 7), Param(params, 8)); return true; }
		if (name == "game_postspawn") { OnGamePostspawn(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "npc_suicide") { OnNpcSuicide(Param(params, 0)); return true; }
		if (name == "set_aoe") { OnSetAoe(Param(params, 0)); return true; }
		if (name == "start_dot") { OnStartDot(); return true; }
		return false;
	}
}
