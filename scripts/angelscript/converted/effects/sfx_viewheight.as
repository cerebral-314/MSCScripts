#pragma context server

// Converted from effects/sfx_viewheight.script by msc_transpiler.

#include "runtime/ScriptEntity.as"

[script "effects/sfx_viewheight"]
class EffectsSfxViewheight : ScriptEntity
{
	// Variables (an unset .script variable reads as its own name)
	int FX_SPEED = 0;
	string FX_DEST_V = "FX_DEST_V";
	bool FX_DRIFTING = false;
	float FX_CUR_V = 0.0f;

	// client_activate
	// <v_ofs|remove> [drift]
	void OnClientActivate(string owner = "", string hand = "", string fxColor = "", string lifetime = "", string sprite = "", string flag = "", string specialFlags = "", string glowRadius = "")
	{
		DebugPrint("*** sfx_viewheight client_activate " + owner + " " + hand + " " + fxColor);

		if (owner != "remove")
		{
			FX_SPEED = Int(hand);
			if (FX_SPEED != 0)
			{
				FX_DEST_V = owner;
				FX_DRIFTING = true;
				OnDriftToNewView();
			}
			else
			{
				string param1 = owner;
				OnSetView(Float(param1));
				FX_CUR_V = Float(owner);
			}
		}
		else
		{
			RemoveScript();
		}
	}

	// set_view
	void OnSetView(float viewOffsetZ = 0.0f)
	{
		SetVar(Eval("game.cleffect.view_ofs.z"), viewOffsetZ);
	}

	// update_view
	// <dest_v> <speed>
	void OnUpdateView(float destV = 0.0f, int speed = 0, string value = "")
	{
		DebugPrint("*** effects/sfx_viewheight update_view " + Text(destV) + " " + speed + " " + value);
		FX_SPEED = speed;
		if (FX_SPEED != 0)
		{
			FX_DEST_V = Text(destV);
			if (!FX_DRIFTING)
			{
				FX_DRIFTING = true;
				OnDriftToNewView();
			}
		}
		else
		{
			FX_CUR_V = destV;
			OnSetView(FX_CUR_V);
		}
	}

	// drift_to_new_view
	void OnDriftToNewView()
	{
		if (!FX_DRIFTING)
			return;

		FX_CUR_V += FX_SPEED;

		if (FX_SPEED < 0)
		{
			if (FX_CUR_V < Float(FX_DEST_V))
			{
				OnSetView(FX_CUR_V);
				FX_DRIFTING = false;
			}
		}
		else if (FX_CUR_V > Float(FX_DEST_V))
		{
			OnSetView(FX_CUR_V);
			FX_DRIFTING = false;
		}

		OnSetView(FX_CUR_V);

		if (!FX_DRIFTING)
			return;
		CallEventDelayed(0.01f, "drift_to_new_view");
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "client_activate") { OnClientActivate(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Param(params, 6), Param(params, 7)); return true; }
		if (name == "drift_to_new_view") { OnDriftToNewView(); return true; }
		if (name == "set_view") { OnSetView(Float(Param(params, 0))); return true; }
		if (name == "update_view") { OnUpdateView(Float(Param(params, 0)), Int(Param(params, 1)), Param(params, 2)); return true; }
		return false;
	}
}
