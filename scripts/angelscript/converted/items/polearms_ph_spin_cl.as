#pragma context server

// Converted from items/polearms_ph_spin_cl.script by msc_transpiler.

#include "runtime/ScriptEntity.as"

[script "items/polearms_ph_spin_cl"]
class PolearmsPhSpinCl : ScriptEntity
{
	// Variables (an unset .script variable reads as its own name)
	string FX_OWNER = "FX_OWNER";
	bool FX_ACTIVE = false;
	string FX_VIEW_IDX = "FX_VIEW_IDX";
	string FORK_SPRITE_ORG = "FORK_SPRITE_ORG";

	// unnamed block (timer)
	void PolearmsPhSpinCl_Timer()
	{
		CallEventDelayed(Random(0.25f, 0.5f), "PolearmsPhSpinCl_Timer");

		if (!FX_ACTIVE)
			return;

		// if ( game.localplayer.index equals FX_OWNER )
		// {
		// if ( !game.localplayer.thirdperson )
		// {
		// local BEAM_START $getcl(game.localplayer.viewmodel.active.id,bonepos,48)
		// }
		// else
		// {
		// local BEAM_START $getcl(FX_OWNER,bonepos,38)
		// }
		// }
		// else
		// {
		// local BEAM_START $getcl(FX_OWNER,bonepos,38)
		// }
		Vector3 beamStart = Vec(LegacyFunction("getcl", FX_OWNER, "origin"));
		string ownerVang = LegacyFunction("getcl", FX_OWNER, "viewangles");
		beamStart += RelativePosition(Vec(ownerVang), Vector3(0, 32, 0));

		string beamEnd = Text(beamStart);
		float rndAng = Random(0, 359.99f);
		beamEnd = Text(Vec(beamEnd) + RelativePosition(Vector3(rndAng, 0, 0), Vector3(0, 64, 0)));
		ClientEffect("beam_points", beamStart, beamEnd, "lgtning.spr", Random(0.25f, 0.5f), 2.0f, 3.0f, 255, 50, 30, Vector3(255, 255, 0));
		beamEnd = Text(beamStart);
		rndAng = Random(0, 359.99f);
		beamEnd = Text(Vec(beamEnd) + RelativePosition(Vector3(rndAng, 0, 0), Vector3(0, 64, 0)));
		ClientEffect("beam_points", beamStart, beamEnd, "lgtning.spr", Random(0.25f, 0.5f), 2.0f, 3.0f, 255, 50, 30, Vector3(255, 255, 0));
	}

	// client_activate
	void OnClientActivate(string owner = "", string hand = "", string fxColor = "", string lifetime = "", string sprite = "", string flag = "", string specialFlags = "", string glowRadius = "")
	{
		FX_OWNER = owner;
		FX_ACTIVE = true;

		if (!Truthy(Eval("game.localplayer.thirdperson")) && Eval("game.localplayer.index") == FX_OWNER)
		{
			FX_VIEW_IDX = Eval("game.localplayer.viewmodel.active.id");
			FORK_SPRITE_ORG = LegacyFunction("getcl", FX_VIEW_IDX, "bonepos", 48);
			ClientEffect("tempent", "sprite", "3dmflaora.spr", FORK_SPRITE_ORG, "setup_fork_sprite", "update_fork_sprite");
		}
	}

	// end_fx
	void OnEndFx(string reason = "")
	{
		FX_ACTIVE = false;
		CallEventDelayed(2.0f, "remove_fx");
	}

	// remove_fx
	void OnRemoveFx()
	{
		RemoveScript();
	}

	// update_fork_sprite
	void OnUpdateForkSprite()
	{
		if (!FX_ACTIVE)
			ClientEffect("tempent", "set_current_prop", "origin", Vector3(20000, 20000, 20000));
		if (!FX_ACTIVE)
			return;
		if (!Truthy(Eval("game.localplayer.thirdperson")))
			ClientEffect("tempent", "set_current_prop", "origin", LegacyFunction("getcl", Eval("game.localplayer.viewmodel.active.id"), "bonepos", 48));
	}

	// setup_fork_sprite
	void OnSetupForkSprite()
	{
		ClientEffect("tempent", "set_current_prop", "death_delay", 30.0f);
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

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		CallEventDelayed(Float(Eval("$randf(0.25,0.5)")), "PolearmsPhSpinCl_Timer");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "client_activate") { OnClientActivate(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Param(params, 6), Param(params, 7)); return true; }
		if (name == "end_fx") { OnEndFx(Param(params, 0)); return true; }
		if (name == "remove_fx") { OnRemoveFx(); return true; }
		if (name == "setup_fork_sprite") { OnSetupForkSprite(); return true; }
		if (name == "update_fork_sprite") { OnUpdateForkSprite(); return true; }
		if (name == "PolearmsPhSpinCl_Timer") { PolearmsPhSpinCl_Timer(); return true; }
		return false;
	}
}
