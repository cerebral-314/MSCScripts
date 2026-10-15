#pragma context server

// Converted from traps/fire_burst.script by msc_transpiler.
// explodie fire trap, temporary NPC
// takes addparam set_aoe;<radius> (default 256)
// damage scales by % of maxhealth
// dmgmulti can be used to increase damage

#include "runtime/ScriptEntity.as"

[script "traps/fire_burst"]
class FireBurst : ScriptEntity
{
	// Variables (an unset .script variable reads as its own name)
	string PLAYING_DEAD = "PLAYING_DEAD";
	string TRAP_AOE = "TRAP_AOE";

	// explode_dodamage
	string FireBurst_OnExplodeDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		float blastRatio;
		string result = "";
		if (!hit)
			return result;
		float targMaxhp = MaxHealthOf(target);

		string blastDmg = "L_TARG_HP";
		blastRatio = Divide(0.0f, 100.0f);

		result = AppendResult(result, Text(blastRatio));

		float dot = MaxHealthOf(target) * 0.05f;
		ApplyEffect(target, "effects/dot_fire", 5.0f, self, dot);

		OnRepelTarget(EntityId(target), "1000", OriginOf(ENT_ME));
		return result;
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		SetName("Exploding Fire Trap");
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
		CallEventDelayed(0.1f, "do_explode");
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

	// do_explode
	void OnDoExplode(string value = "")
	{
		if (TRAP_AOE == "TRAP_AOE")
			TRAP_AOE = "256";
		Vector3 burstPos = OriginOf(ENT_ME);
		burstPos.z = GroundHeight(burstPos);
		DoDamageEx(burstPos, TRAP_AOE, Eval("game.players.avghp"), 0, ENT_ME, ENT_ME, "none", "fire_effect", "dmgevent:explode");
		ClientEvent("new", "all", "effects/sfx_fire_burst", burstPos, TRAP_AOE, 1, Vector3(255, 64, 0));
		CallEventDelayed(6.0f, "npc_suicide");
	}

	string OnExplodeDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "") { return FireBurst_OnExplodeDodamage(hit, target, start, end, damageType, damageText); } // explode_dodamage

	// repel_target
	// <target> <strength> <from_origin>
	void OnRepelTarget(string target = "", string strength = "", Vector3 fromOrigin = Vector3())
	{
		Vector3 targOrg = OriginOf(target);
		float targAng = AnglesTo(fromOrigin, targOrg);
		int newYaw = int(targAng);
		SetVelocity(target, RelativeVelocity(Vector3(0, newYaw, 0), Vector3(0, Float(strength), 0)));
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
		if (name == "do_explode") { OnDoExplode(Param(params, 0)); return true; }
		if (name == "explode_dodamage") { Return(OnExplodeDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5))); return true; }
		if (name == "game_dynamically_created") { OnGameDynamicallyCreated(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Float(Param(params, 6)), Param(params, 7), Param(params, 8)); return true; }
		if (name == "game_postspawn") { OnGamePostspawn(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "npc_suicide") { OnNpcSuicide(Param(params, 0)); return true; }
		if (name == "repel_target") { OnRepelTarget(Param(params, 0), Param(params, 1), Vec(Param(params, 2))); return true; }
		if (name == "set_aoe") { OnSetAoe(Param(params, 0)); return true; }
		return false;
	}
}
