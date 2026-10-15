#pragma context server

// Converted from items/proj_bolt_poison.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/items/proj_arrow_base.as"

[script "items/proj_bolt_poison"]
class ProjBoltPoison : ProjArrowBaseScript
{
	// Constants
	bool HITSCAN_BOLT = true;
	string MODEL_BODY_OFS = "0";
	int PROJ_STICK_DURATION = 25;
	bool ARROW_SOLIDIFY_ON_WALL = false;
	string ARROW_BREAK_CHANCE = "1%";

	// Variables declared by included files, with the value they start with in this script
	ProjBoltPoison()
	{
		PROJ_DAMAGE = "150";
		PROJ_DAMAGE_TYPE = "poison";
	}

	// strike_target
	void OnStrikeTarget(string target = "")
	{
		ProjBase_OnStrikeTarget(target); // items/proj_base
		Vector3 pass = OriginOf(target);
		// also poison the mob here
		OnDoExplode(Text(pass));
	}

	// arrow_spawn
	void OnArrowSpawn()
	{
		SetName("Poison Gas Bolt");
		SetDescription("This crossbow bolt explodes into a cloud of poisonous gas.");
		SetWeight(0.15f);
		SetValue(0);
		SetGravity(0);
		SetGroupable(25);
	}

	// bolt_dodamage
	// PARAM1=hit:0|1 PARAM2=ent_hit PARAM3=(start) PARAM4=(end) DmgType DmgAmt
	void OnBoltDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		DebugPrint("bolt_dodamage " + Text(hit) + " " + EntityId(target) + " " + Text(start) + " " + Text(end));
		// local L_PASS PARAM4 //this seems to be returning attack destination rather than attack end :\
		string pass = BOLT_TRACE_END;
		OnDoExplode(pass);
	}

	// do_explode
	void OnDoExplode(string value = "")
	{
		// spawn da cloud
		CallExternal(ENT_EXPOWNER, "ext_poison_bolt", value);
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "arrow_spawn") { OnArrowSpawn(); return true; }
		if (name == "bolt_dodamage") { OnBoltDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5)); return true; }
		if (name == "do_explode") { OnDoExplode(Param(params, 0)); return true; }
		if (name == "strike_target") { OnStrikeTarget(Param(params, 0)); return true; }
		return ProjArrowBaseScript::DispatchEvent(name, params);
	}
}
