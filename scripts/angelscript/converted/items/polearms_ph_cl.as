#pragma context server

// Converted from items/polearms_ph_cl.script by msc_transpiler.

#include "runtime/ScriptEntity.as"

[script "items/polearms_ph_cl"]
class PolearmsPhCl : ScriptEntity
{
	// Variables (an unset .script variable reads as its own name)
	string FX_OWNER = "FX_OWNER";
	string FX_VIEW_IDX = "FX_VIEW_IDX";
	string FORK_SPRITE_ORG = "FORK_SPRITE_ORG";
	bool FX_ACTIVE = false;

	// client_activate
	void OnClientActivate(string owner = "", string hand = "", string fxColor = "", string lifetime = "", string sprite = "", string flag = "", string specialFlags = "", string glowRadius = "")
	{
		FX_OWNER = owner;
		DebugPrint("*** polearms_ph " + FX_OWNER + " vs " + Eval("game.localplayer.index"));

		if (!Truthy(Eval("game.localplayer.thirdperson")) && Eval("game.localplayer.index") == FX_OWNER)
		{
			FX_VIEW_IDX = Eval("game.localplayer.viewmodel.active.id");
			FORK_SPRITE_ORG = LegacyFunction("getcl", FX_VIEW_IDX, "attachment0");
			ClientEffect("tempent", "sprite", "3dmflaora.spr", FORK_SPRITE_ORG, "setup_fork_sprite", "update_fork_sprite");
		}
		FX_ACTIVE = true;
		CallEventDelayed(2.0f, "end_fx");
	}

	// end_fx
	void OnEndFx(string reason = "")
	{
		FX_ACTIVE = false;
		CallEventDelayed(1.0f, "remove_fx");
	}

	// remove_fx
	void OnRemoveFx()
	{
		RemoveScript();
	}

	// do_lightning
	// <end_origin> external
	void OnDoLightning(string endOrigin = "")
	{
		string beamStart;

		if (Eval("game.localplayer.index") == FX_OWNER)
		{
			if (!Truthy(Eval("game.localplayer.thirdperson")))
				beamStart = LegacyFunction("getcl", Eval("game.localplayer.viewmodel.active.id"), "attachment0");
			else
				beamStart = LegacyFunction("getcl", FX_OWNER, "bonepos", 38);
		}
		else
		{
			beamStart = LegacyFunction("getcl", FX_OWNER, "bonepos", 38);
		}

		// local BEAM_END $getcl(TARG_IDX,origin)
		// if ( !$getcl(TARG_IDX,isplayer) ) vectoradd BEAM_END z 32
		ClientEffect("beam_points", beamStart, endOrigin, "lgtning.spr", 0.5f, 15.0f, 0.5f, 255, 50, 30, Vector3(255, 255, 0));
	}

	// update_fork_sprite
	void OnUpdateForkSprite()
	{
		if (!FX_ACTIVE)
			return;
		if (!Truthy(Eval("game.localplayer.thirdperson")))
			ClientEffect("tempent", "set_current_prop", "origin", LegacyFunction("getcl", Eval("game.localplayer.viewmodel.active.id"), "attachment0"));
	}

	// setup_fork_sprite
	void OnSetupForkSprite()
	{
		ClientEffect("tempent", "set_current_prop", "death_delay", 2.0f);
		ClientEffect("tempent", "set_current_prop", "renderamt", 255);
		ClientEffect("tempent", "set_current_prop", "rendermode", "add");
		ClientEffect("tempent", "set_current_prop", "rendercolor", Vector3(254, 254, 1));
		ClientEffect("tempent", "set_current_prop", "scale", 0.5f);
		ClientEffect("tempent", "set_current_prop", "gravity", 0);
		ClientEffect("tempent", "set_current_prop", "collide", "none");
		ClientEffect("tempent", "set_current_prop", "framerate", 30);
		ClientEffect("tempent", "set_current_prop", "frames", 1);
		ClientEffect("tempent", "set_current_prop", "update", 1);
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "client_activate") { OnClientActivate(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Param(params, 6), Param(params, 7)); return true; }
		if (name == "do_lightning") { OnDoLightning(Param(params, 0)); return true; }
		if (name == "end_fx") { OnEndFx(Param(params, 0)); return true; }
		if (name == "remove_fx") { OnRemoveFx(); return true; }
		if (name == "setup_fork_sprite") { OnSetupForkSprite(); return true; }
		if (name == "update_fork_sprite") { OnUpdateForkSprite(); return true; }
		return false;
	}
}
