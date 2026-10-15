#pragma context server

// Converted from items/magic_hand_lightning_chain_cl.script by msc_transpiler.
// "true" chain lightning fx

#include "runtime/ScriptEntity.as"

[script "items/magic_hand_lightning_chain_cl"]
class MagicHandLightningChainCl : ScriptEntity
{
	// Variables (an unset .script variable reads as its own name)
	string CASTER_INDEX = "CASTER_INDEX";
	string IDX_LIST = "IDX_LIST";

	// client_activate
	void OnClientActivate(string owner = "", string hand = "", string fxColor = "", string lifetime = "", string sprite = "", string flag = "", string specialFlags = "", string glowRadius = "")
	{
		CASTER_INDEX = owner; // store index of caster for later use
	}

	// draw_beams
	// <target_idx_list>
	void OnDrawBeams(string targetIdxList = "")
	{
		bool useViewmodel = false;
		string clHand1;
		string clHand2;

		IDX_LIST = targetIdxList;

		// store first target and origin
		string firstTarget = GetToken(IDX_LIST, 0);
		Vector3 firstTargetOrg = Vec(LegacyFunction("getcl", firstTarget, "origin"));
		firstTargetOrg.z += 32.0f; // origin will be at feat on monsters, so add 32 (will wind up targeting heads of players)

		if (Eval("game.localplayer.index") == CASTER_INDEX && !Truthy(Eval("game.localplayer.thirdperson")))
			useViewmodel = true;

		if (useViewmodel)
		{
			// I'm currently running on the caster, and he's in first person mode
			// so first two beams start from left and right hands of viewmodel
			clHand1 = LegacyFunction("getcl", Eval("game.localplayer.viewmodel.active.id"), "bonepos", 16);
			clHand2 = LegacyFunction("getcl", Eval("game.localplayer.viewmodel.active.id"), "bonepos", 35);
		}
		else
		{
			// this is drawing on another client, or the caster is not in first person mode
			// thus beams start from player model hands instead of viewmodel
			clHand1 = LegacyFunction("getcl", CASTER_INDEX, "bonepos", 21);
			clHand2 = LegacyFunction("getcl", CASTER_INDEX, "bonepos", 38);
		}

		ClientEffect("beam_points", clHand1, firstTargetOrg, "lgtning.spr", 0.5f, 5.0f, 0.5f, 255, 50, 30, Vector3(60, 60, 255));
		ClientEffect("beam_points", clHand2, firstTargetOrg, "lgtning.spr", 0.5f, 5.0f, 0.5f, 255, 50, 30, Vector3(60, 60, 255));

		// from here draw rest of beams
		int count = GetTokenCount(IDX_LIST);
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnDrawBeamsLoop();
		}
	}

	// draw_beams_loop
	void OnDrawBeamsLoop()
	{
		int nextIdx = 0;

		int curLoop = loopIteration;
		float nextLoop = curLoop + 1.0f;

		if (!(nextLoop < GetTokenCount(IDX_LIST)))
			return;

		string curIdx = GetToken(IDX_LIST, curLoop);
		Vector3 curIdxOrg = Vec(LegacyFunction("getcl", curIdx, "origin"));
		curIdxOrg.z += 32.0f;

		string nextIdxText = GetToken(IDX_LIST, nextIdx);
		Vector3 nextIdxOrg = Vec(LegacyFunction("getcl", nextIdxText, "origin"));
		nextIdxOrg.z += 32.0f;

		ClientEffect("beam_points", curIdxOrg, nextIdxOrg, "lgtning.spr", 0.5f, 5.0f, 0.5f, 255, 50, 30, Vector3(60, 60, 255));
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "client_activate") { OnClientActivate(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Param(params, 6), Param(params, 7)); return true; }
		if (name == "draw_beams") { OnDrawBeams(Param(params, 0)); return true; }
		if (name == "draw_beams_loop") { OnDrawBeamsLoop(); return true; }
		return false;
	}
}
