#pragma context server

// Converted from effects/sfx_jump_beams.script by msc_transpiler.
// Must be created via createnpc.
// PARAM1 = <targetId|origin>
// Anything that uses "!startswith '('" means its checking if it is an entity
// Swirly beam effect that jumps to a target at first, then beams to enemies, or randomly around
// hover on target ~2 sec before jumping to next
// Has server-side and client-side counterparts in one script.
// Server tracks enemy targeting & jumping, client side handles fx.
// Removed "cleffect ce" usage //greatguys1@JAN2022

#include "runtime/ScriptEntity.as"

[script "effects/sfx_jump_beams"]
class SfxJumpBeams : ScriptEntity
{
	// Constants
	int MAX_JUMPS = 6;

	// Variables (an unset .script variable reads as its own name)
	float CUR_JUMPS = 0.0f;
	Vector3 FX_TARGET = Vector3();
	string FX_OWNER = "FX_OWNER";
	string FX_SCRIPT_ID = "FX_SCRIPT_ID";

	// unnamed block (first think)
	void SfxJumpBeams_FirstThink()
	{
		CUR_JUMPS = 0.0f;
	}

	// func_is_ent
	// <param> //Returns 1 if the given param is an entity
	string SfxJumpBeams_OnFuncIsEnt(string value = "")
	{
		string result = "";

		bool return_ = false;
		if (!StartsWith(value, "("))
			return_ = true;

		result = "";
		result = AppendResult(result, Text(return_));
		return result;
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		SetName("Swirly Lightning Effect :)");

		SetModel("null.mdl");
		SetRace("beloved");
		SetInvincible(true);
		SetHeight(0);
		SetWidth(0);
		SetSolid("none");

		CallEventDelayed(120.0f, "end_me_please");
	}

	// game_dynamically_created
	// <targetId|origin> <owner>
	void OnGameDynamicallyCreated(string creatorValue1 = "", string creatorValue2 = "", string damage = "", string skill = "", string extraValue5 = "", string extraValue6 = "", float alwaysPush = 0.0f, string duration = "", string extraValue9 = "")
	{
		FX_TARGET = Vec(creatorValue1);
		FX_OWNER = creatorValue2;

		ClientEvent("new", "all", ScriptNameOf(ENT_ME), OriginOf(FX_OWNER));
		FX_SCRIPT_ID = LastClientScriptId();

		CallEventDelayed(0.1f, "jump_beam");
	}

	// jump_beam
	void OnJumpBeam()
	{
		// scan area for new beam target
		// make sure doesn't match index of reported target (if isent)
		// if cant find new ent, trace line to random location and send result, otherwise send new model index
		if (CUR_JUMPS != 0.0f) // Never scan on the first jump
		{
			if (!StartsWith(Text(FX_TARGET), "("))
				OnScanTarget(OriginOf(Text(FX_TARGET)));
			else
				OnScanTarget(FX_TARGET);
		}

		if (!StartsWith(Text(FX_TARGET), "("))
		{
			OnBeamDamage();
			ClientEvent("update", "all", FX_SCRIPT_ID, "beam_jump", IndexOf(Text(FX_TARGET)));
		}
		else
		{
			ClientEvent("update", "all", FX_SCRIPT_ID, "beam_jump", FX_TARGET);
		}

		CUR_JUMPS += 1.0f;
		if (CUR_JUMPS >= MAX_JUMPS)
			CallEventDelayed(2.0f, "end_me_please");
		else
			CallEventDelayed(2.0f, "jump_beam");
	}

	// scan_target
	// Scans and stores target
	void OnScanTarget(Vector3 origin = Vector3())
	{
		Vector3 scanOrg = origin;
		scanOrg.z = GroundHeight(scanOrg);
		scanOrg += Vec(Text(32));

		CallExternal(FX_OWNER, "ext_sphere_token", "enemy", 270, scanOrg); // Player scans for enemies
		string beamTargs = ScriptVarOf(FX_OWNER, "PLR_SCAN_TOKEN");

		bool doRandomJump = false;

		if (beamTargs != "none")
		{
			beamTargs = LegacyFunction("sort_entlist", beamTargs, "range", scanOrg);
			string curTarg = GetToken(beamTargs, 0);
			int nTargs = GetTokenCount(beamTargs);

			if (nTargs > 1)
				curTarg = GetToken(beamTargs, 1);
			if (curTarg == Text(FX_TARGET)) // target is last target struck, didn't find new one, jump random loc instead
				doRandomJump = true;
			FX_TARGET = Vec(curTarg);
		}
		else
		{
			doRandomJump = true; // no new targets, jump to random loc
		}

		if (doRandomJump)
		{
			if (!StartsWith(Text(FX_TARGET), "("))
				FX_TARGET = OriginOf(Text(FX_TARGET));

			Vector3 oldTarg = FX_TARGET;

			FX_TARGET += RelativePosition(Vector3(0, Random(0, 359), 0), Vector3(0, 270, 32));
			FX_TARGET = Vec(LegacyFunction("get_traceline", oldTarg, FX_TARGET, "worldonly"));
		}
	}

	// beam_damage
	// Damage and burn stored id
	void OnBeamDamage()
	{
		float dmg = SkillOf(FX_OWNER, "spellcasting.lightning");
		float dmgDirect = dmg * 3.0f;
		string dmgDirectText = Text(dmgDirect);
		DoDamageEx(FX_TARGET, "direct", dmgDirectText, "100%", FX_OWNER, FX_OWNER, "spellcasting.lightning", "lightning_effect");
		float dot = dmg * 0.5f;
		string dotText = Text(dot);
		ApplyEffect(Text(FX_TARGET), "effects/dot_lightning", 5.0f, FX_OWNER, dotText);
	}

	// end_me_please
	void OnEndMePlease()
	{
		ClientEvent("update", "all", FX_SCRIPT_ID, "end_fx");
		DeleteMe();
	}

	string OnFuncIsEnt(string value = "") { return SfxJumpBeams_OnFuncIsEnt(value); } // func_is_ent

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		SfxJumpBeams_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "beam_damage") { OnBeamDamage(); return true; }
		if (name == "end_me_please") { OnEndMePlease(); return true; }
		if (name == "func_is_ent") { Return(OnFuncIsEnt(Param(params, 0))); return true; }
		if (name == "game_dynamically_created") { OnGameDynamicallyCreated(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Float(Param(params, 6)), Param(params, 7), Param(params, 8)); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "jump_beam") { OnJumpBeam(); return true; }
		if (name == "scan_target") { OnScanTarget(Vec(Param(params, 0))); return true; }
		return false;
	}
}
