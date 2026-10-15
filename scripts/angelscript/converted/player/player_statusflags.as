#pragma context server

// Converted from player/player_statusflags.script by msc_transpiler.
// This failed, and is no longer in use

#include "runtime/ScriptEntity.as"

[script "player/player_statusflags"]
class PlayerStatusflags : ScriptEntity
{
	// unnamed block (first think)
	void PlayerStatusflags_FirstThink()
	{
		SetVar(Eval("game.effect.canmove"), 1);
		SetVar(Eval("game.effect.canrun"), 1);
		SetVar(Eval("game.effect.canjump"), 1);
		SetVar(Eval("game.effect.canduck"), 1);
		SetVar(Eval("game.effect.canattack"), 1);
	}

	// set_status_flags
	// <canmove:0|1> <canrun:0:1> <canjump:0|1> >canduck:0|1> <canattack:0|1>
	void OnSetStatusFlags(string canMove = "", string canRun = "", string canJump = "", string canDuck = "", string canAttack = "")
	{
		SetVar(Eval("game.effect.canmove"), canMove);
		SetVar(Eval("game.effect.canrun"), canRun);
		SetVar(Eval("game.effect.canjump"), canJump);
		SetVar(Eval("game.effect.canduck"), canDuck);
		SetVar(Eval("game.effect.canattack"), canAttack);
	}

	// set_status_canmove
	// <0|1>
	void OnSetStatusCanmove(string enabled = "")
	{
		SetVar(Eval("game.effect.canmove"), enabled);
	}

	// set_status_canrun
	// <0|1>
	void OnSetStatusCanrun(string enabled = "")
	{
		SetVar(Eval("game.effect.canrun"), enabled);
	}

	// set_status_canjump
	// <0|1>
	void OnSetStatusCanjump(string enabled = "")
	{
		SetVar(Eval("game.effect.canjump"), enabled);
	}

	// set_status_canduck
	// <0|1>
	void OnSetStatusCanduck(string enabled = "")
	{
		SetVar(Eval("game.effect.canduck"), enabled);
	}

	// set_status_canattack
	// <0|1>
	void OnSetStatusCanattack(string enabled = "")
	{
		SetVar(Eval("game.effect.canattack"), enabled);
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		PlayerStatusflags_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "set_status_canattack") { OnSetStatusCanattack(Param(params, 0)); return true; }
		if (name == "set_status_canduck") { OnSetStatusCanduck(Param(params, 0)); return true; }
		if (name == "set_status_canjump") { OnSetStatusCanjump(Param(params, 0)); return true; }
		if (name == "set_status_canmove") { OnSetStatusCanmove(Param(params, 0)); return true; }
		if (name == "set_status_canrun") { OnSetStatusCanrun(Param(params, 0)); return true; }
		if (name == "set_status_flags") { OnSetStatusFlags(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4)); return true; }
		return false;
	}
}
