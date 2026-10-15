#pragma context server

// Converted from items/proj_mana2.script by msc_transpiler.
// Magic bolt that varies with size by the energy put into it

#include "runtime/ScriptEntity.as"

[script "items/proj_mana2"]
class ProjMana2 : ScriptEntity
{
	// Constants
	string SOUND_SHOOT = "ambience/alienflyby1.wav";
	string SOUND_ZAP = "debris/zap1.wav";
	string CLFX_ARROW_SCRIPT = "items/proj_mana2_cl";

	// Variables (an unset .script variable reads as its own name)
	string FX_OWNER = "FX_OWNER";
	string FX_VEL = "FX_VEL";
	float FX_SIZE = 0.0f;
	string FX_DAMAGE = "FX_DAMAGE";
	string FX_SKILL = "FX_SKILL";
	float SCAN_SIZE = 0.0f;
	Vector3 PREV_SCAN = Vector3();
	bool CLFX_ARROW_INIT = false;
	bool CLFX_ARROW_IN_FLIGHT = false;
	string CLFX_ARROW_IDX = "CLFX_ARROW_IDX";

	// func_get_scan_size
	string ProjMana2_OnFuncGetScanSize()
	{
		string result = "";

		float scanSize = Clamp(24.0f * FX_SIZE, 55.0f, 140.0f);
		result = "";
		result = AppendResult(result, Text(scanSize));
		return result;
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		SetName("Manabolt");
		SetDescription("Manabolt");
		SetWeight(0);
		SetGravity(0);

		SetModel("none");

		CallEventDelayed(10.0f, "remove_projectile");
	}

	// game_dynamically_created
	// <owner> <vec> <ballSize> <damage> <skill to level>
	void OnGameDynamicallyCreated(string creatorValue1 = "", string creatorValue2 = "", string damage = "", string skill = "", string extraValue5 = "", string extraValue6 = "", float alwaysPush = 0.0f, string duration = "", string extraValue9 = "")
	{
		FX_OWNER = creatorValue1;
		FX_VEL = creatorValue2; // Kept to check to see if it changes
		FX_SIZE = Float(damage);
		FX_DAMAGE = skill;
		FX_SKILL = extraValue5;

		SCAN_SIZE = Float(OnFuncGetScanSize());

		SetVelocity(ENT_ME, Vec(FX_VEL));
		LegacyCommand("svsound.play3d", SOUND_SHOOT, 2.5f, OriginOf(ENT_ME), 0, 4);

		PREV_SCAN = OriginOf(ENT_ME);
		CallEventDelayed(0.3f, "scan_cycle");

		OnCreateClfx();

		SetProp(ENT_ME, "movetype", 11);
		SetProp(ENT_ME, "friction", 10000);
		SetProp(ENT_ME, "solid", 0);
	}

	// create_clfx
	void OnCreateClfx()
	{
		// these have to be assembled and sent, as there's no actual model for client to grab info from
		if (!CLFX_ARROW_INIT)
		{
			CLFX_ARROW_INIT = true;
			CLFX_ARROW_IN_FLIGHT = true;

			ClientEvent("new", "all", CLFX_ARROW_SCRIPT, OriginOf(ENT_ME), AnglesOf(ENT_ME), VelocityOf(ENT_ME), FX_SIZE); // origin angle velocity ballSize
			CLFX_ARROW_IDX = LastClientScriptId();
		}
	}

	// scan_cycle
	void OnScanCycle()
	{
		Vector3 vel = VelocityOf(ENT_ME);
		// infomsg all FX_VEL $get(ent_me,velocity)
		if (FX_VEL == Text(vel)) // The projectile has moved
		{
			// <target|(src_origin)> <range|aoe|(dest_origin)|direct> <damage> <cth|fall_off> <attacker> <inflciter> <skill|none> <dmg_type> [flag_string]
			DoDamageEx(OriginOf(ENT_ME), SCAN_SIZE, FX_DAMAGE, 0, FX_OWNER, ENT_ME, FX_SKILL, "magic", "dmgevent:*ball");
			CallEventDelayed(0.3f, "scan_cycle");
		}
		else
		{
			OnRemoveProjectile();
		}
	}

	// ball_dodamage
	// PARAM1=hit:0|1 PARAM2=ent_hit PARAM3=(start) PARAM4=(end) PARAM5=DmgType PARAM6=DmgAmt
	void OnBallDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		if (!hit)
			return;
		if (!(Float(damageText) > 0.0f))
			return;

		FX_SIZE -= 1.0f;
		if (FX_SIZE > 0.0f)
		{
			SCAN_SIZE = Float(OnFuncGetScanSize());

			ClientEvent("update", "all", CLFX_ARROW_IDX, "reduce_size"); // huevito
		}
		else
		{
			OnRemoveProjectile();
		}
	}

	// remove_projectile
	void OnRemoveProjectile(string fxIndex = "")
	{
		LegacyCommand("svsound.play3d", SOUND_ZAP, 4, OriginOf(ENT_ME), 0, 4);
		ClientEvent("update", "all", CLFX_ARROW_IDX, "end_fx");
		DeleteMe();
	}

	// fake_precache
	void OnFakePrecache()
	{
		ServerPlaySound(4, 0, SOUND_ZAP);
	}

	string OnFuncGetScanSize() { return ProjMana2_OnFuncGetScanSize(); } // func_get_scan_size

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("ambience/alienflyby1.wav");
		Precache("debris/zap1.wav");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "ball_dodamage") { OnBallDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5)); return true; }
		if (name == "create_clfx") { OnCreateClfx(); return true; }
		if (name == "fake_precache") { OnFakePrecache(); return true; }
		if (name == "func_get_scan_size") { Return(OnFuncGetScanSize()); return true; }
		if (name == "game_dynamically_created") { OnGameDynamicallyCreated(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Float(Param(params, 6)), Param(params, 7), Param(params, 8)); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "remove_projectile") { OnRemoveProjectile(Param(params, 0)); return true; }
		if (name == "scan_cycle") { OnScanCycle(); return true; }
		return false;
	}
}
