#pragma context server

// Converted from monsters/summon/npc_poison_cloud2_cl.script by msc_transpiler.

#include "runtime/ScriptEntity.as"

[script "monsters/summon/npc_poison_cloud2_cl"]
class NpcPoisonCloud2Cl : ScriptEntity
{
	// Variables (an unset .script variable reads as its own name)
	Vector3 FX_ORIGIN = Vector3();
	string FX_COLOR = "FX_COLOR";
	bool IS_ACTIVE = false;

	// client_activate
	// <origin> <duration> <variant>
	void OnClientActivate(string owner = "", string hand = "", string fxColor = "", string lifetime = "", string sprite = "", string flag = "", string specialFlags = "", string glowRadius = "")
	{
		FX_ORIGIN = Vec(owner);
		FX_ORIGIN.z += 32.0f;

		if (Float(fxColor) == 1.0f)
			FX_COLOR = Text(Vector3(0, 0, 0));
		if (Float(fxColor) == 2.0f)
			FX_COLOR = Text(Vector3(128, 255, 0));
		if (Float(fxColor) == 3.0f)
			FX_COLOR = Text(Vector3(255, 0, 0));

		DebugPrint("*** client_activate org " + Text(FX_ORIGIN) + " dur " + hand + " type " + fxColor);

		IS_ACTIVE = true;
		OnDoSmokes();
		CallEventOrDelay(hand, "end_fx");
	}

	// do_smokes
	void OnDoSmokes()
	{
		if (!IS_ACTIVE)
			return;
		CallEventDelayed(0.5f, "do_smokes");
		for (int i = 0; i < 3; i++)
		{
			loopIteration = i;
			OnDoSmokesLoop();
		}
	}

	// do_smokes_loop
	void OnDoSmokesLoop()
	{
		Vector3 pos = FX_ORIGIN;
		pos.x += Random(-128, 128);
		pos.y += Random(-128, 128);
		ClientEffect("tempent", "sprite", "poison_cloud.spr", pos, "setup_smokes");
	}

	// end_fx
	void OnEndFx(string reason = "")
	{
		IS_ACTIVE = false;
		CallEventDelayed(3.0f, "remove_fx");
	}

	// remove_fx
	void OnRemoveFx()
	{
		RemoveScript();
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files
	void OnFxDuration() {} // FX_DURATION

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "client_activate") { OnClientActivate(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Param(params, 6), Param(params, 7)); return true; }
		if (name == "do_smokes") { OnDoSmokes(); return true; }
		if (name == "do_smokes_loop") { OnDoSmokesLoop(); return true; }
		if (name == "end_fx") { OnEndFx(Param(params, 0)); return true; }
		if (name == "remove_fx") { OnRemoveFx(); return true; }
		return false;
	}
}
