#pragma context server

// Converted from orc_for/test.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/debug.as"

[script "orc_for/test"]
class Test : DebugScript
{
	// Variables (an unset .script variable reads as its own name)
	string PUSH_TARG = "PUSH_TARG";
	float NEXT_PUSH = 0.0f;

	// unnamed block (first think)
	void Test_FirstThink()
	{
		SetCallback("touch", "enable");
	}

	// game_touch
	string Test_OnGameTouch(CBaseEntity@ other = null, string hpRange = "", string effectDamage = "")
	{
		string result = "";
		// dbg game_touch $get(PARAM1,name)
		PUSH_TARG = EntityId(other);
		CallEventDelayed(0.1f, "do_repel");
		return result;
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		SetModel("misc/treasure.mdl");
		SetWidth(32);
		SetHeight(32);
		SetHealth(1000);
		SetRace("hated");
		// setidleanim idle
		// setmoveanim idle
		SetProp(ENT_ME, "movetype", 7);
		SetProp(ENT_ME, "solid", 2);
		// setbbox $vec(-16,-16,0) $vec(16,16,72)
		SetGravity(0);
		CallEventDelayed(0.25f, "snap_to_ground");
	}

	// snap_to_ground
	void OnSnapToGround()
	{
		Vector3 myPos = OriginOf(ENT_ME);
		myPos.z = GroundHeight(myPos);
		SetOrigin(ENT_ME, myPos);
	}

	// ext_forward
	void OnExtForward()
	{
		SetProp(ENT_ME, "movetype", 7);
		SetProp(ENT_ME, "velocity", RelativeVelocity(Vector3(0, 0, 0), Vector3(0, 1000, 0)));
	}

	// ext_backwards
	void OnExtBackwards()
	{
		SetProp(ENT_ME, "velocity", RelativeVelocity(Vector3(0, 0, 0), Vector3(0, -1000, 0)));
		SetProp(ENT_ME, "movetype", 7);
	}

	// ext_reset
	void OnExtReset()
	{
		SetProp(ENT_ME, "velocity", RelativeVelocity(Vector3(0, 0, 0), Vector3(0, 0, 0)));
		SetOrigin(ENT_ME, Vector3(0, 0, 0));
		SetProp(ENT_ME, "solid", 2);
		SetProp(ENT_ME, "movetype", 7);
	}

	// ext_down
	void OnExtDown()
	{
		SetProp(ENT_ME, "solid", 2);
		SetProp(ENT_ME, "movetype", 7);
		SetProp(ENT_ME, "velocity", RelativeVelocity(Vector3(0, 0, 0), Vector3(0, 0, -100)));
		SetProp(ENT_ME, "solid", 2);
		SetProp(ENT_ME, "movetype", 7);
	}

	// ext_up
	void OnExtUp()
	{
		SetProp(ENT_ME, "solid", 2);
		SetProp(ENT_ME, "movetype", 7);
		SetProp(ENT_ME, "velocity", RelativeVelocity(Vector3(0, 0, 0), Vector3(0, 0, 100)));
		SetProp(ENT_ME, "solid", 2);
		SetProp(ENT_ME, "movetype", 7);
	}

	string OnGameTouch(CBaseEntity@ other = null, string hpRange = "", string effectDamage = "") { return Test_OnGameTouch(other, hpRange, effectDamage); } // game_touch

	// do_repel
	void OnDoRepel(CBaseEntity@ target = null)
	{
		if (!(GameTime() > NEXT_PUSH))
			return;
		NEXT_PUSH = GameTime() + 0.25f;
		DebugPrint("do_repel " + NameOf(target) + " " + Text(OriginOf(ENT_ME)));
		string curTarg = PUSH_TARG;
		DoDamage(curTarg, "direct", 0.1f, "100%", ENT_ME, "lightning_effect");
		Vector3 targetOrg = OriginOf(curTarg);
		float targAng = AnglesTo(MyOrigin(), targetOrg);
		int newYaw = int(targAng);
		AddVelocity(curTarg, RelativeVelocity(Vector3(0, newYaw, 0), Vector3(0, 800, 110)));
	}

	// game_blocked
	void OnGameBlocked(CBaseEntity@ other = null)
	{
		DebugPrint("game_blocked " + NameOf(other));
		OnDoRepel(other);
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("misc/treasure.mdl");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		Test_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "do_repel") { OnDoRepel(EntityParam(params, 0)); return true; }
		if (name == "ext_backwards") { OnExtBackwards(); return true; }
		if (name == "ext_down") { OnExtDown(); return true; }
		if (name == "ext_forward") { OnExtForward(); return true; }
		if (name == "ext_reset") { OnExtReset(); return true; }
		if (name == "ext_up") { OnExtUp(); return true; }
		if (name == "game_blocked") { OnGameBlocked(EntityParam(params, 0)); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "game_touch") { Return(OnGameTouch(EntityParam(params, 0), Param(params, 1), Param(params, 2))); return true; }
		if (name == "snap_to_ground") { OnSnapToGround(); return true; }
		return DebugScript::DispatchEvent(name, params);
	}
}
