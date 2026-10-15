#pragma context server

// Converted from dridje/gloam_sitter.script by msc_transpiler.

#include "runtime/ScriptEntity.as"

[script "dridje/gloam_sitter"]
class GloamSitter : ScriptEntity
{
	// Variables (an unset .script variable reads as its own name)
	CBaseEntity@ SLAYER_ID = null;
	string ENEMY_ID = "ENEMY_ID";

	// unnamed block (timer)
	void GloamSitter_Timer()
	{
		CallEventDelayed(Random(10, 60), "GloamSitter_Timer");
		PlayAnim("once", "cowering_in_corner");
	}

	// game_damaged
	string GloamSitter_OnGameDamaged(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float accuracyRoll = 0.0f, CBaseEntity@ inflictor = null, string skill = "")
	{
		string result = "";

		if (!IsPlayer(attacker))
			return result;
		result = AppendResult(result, "0");
		return result;
	}

	// unnamed block (timer)
	void GloamSitter_Timer2()
	{
		CallEventDelayed(2.0f, "GloamSitter_Timer2");
		if (!IsAlive(ENT_ME))
			return;

		ENEMY_ID = FindOneInSphere("256", 0);
		if (!IsAlive(ENEMY_ID))
			return;

		int rndAnim = RandomInt(1, 2);
		if (rndAnim == 1)
			PlayAnim("once", "sstruggleidle");
		if (rndAnim == 2)
			PlayAnim("once", "sstruggle");

		string nmeTarget = ScriptVarOf(ENEMY_ID, "NPCATK_TARGET");
		if (NameOf(nmeTarget) == "'Frightened")
			return;
		CallExternal(ENEMY_ID, "npcatk_settarget", self);
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		SetHealth(1);
		SetName("Frightened Mercenary");
		SetWidth(32);
		SetHeight(64);
		SetRoam(false);
		SetRace("human");
		SetBlood("red");
		SetModel("npc/guard1.mdl");
		SetModelBody(1, 0);
		SetIdleAnim("sitidle");
		SetMoveAnim("sitidle");
		PlayAnim("once", "sitidle");
		LegacyCommand("blind", 1); // saves da CPU

		SetNoPush(true);

		SetMenuAutoOpen(true);

		CallEventDelayed(10.0f, "get_slayer_id");
	}

	// get_slayer_id
	void OnGetSlayerId()
	{
		@SLAYER_ID = FindByName("agrath");
	}

	// say_hi
	void OnSayHi(CBasePlayer@ talkingPlayer = null)
	{
		PlayAnim("once", "cowering_in_corner");
		SayText("Have you seen those things!? I'm not going in there again!");
	}

	// game_menu_getoptions
	void OnGameMenuGetoptions(CBasePlayer@ player = null)
	{
		MenuItem menuItem;
		if (!IsAlive(ENT_ME))
			return;

		menuItem.title = "Hail.";
		menuItem.type = "callback";
		menuItem.callback = "say_hi";
		RegisterMenuItem(menuItem);
	}

	string OnGameDamaged(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float accuracyRoll = 0.0f, CBaseEntity@ inflictor = null, string skill = "") { return GloamSitter_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill); } // game_damaged

	// game_death
	void OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		PlayAnim("hold", "diebackward");
		PlayRandomSound(0, 10, "voices/kcult_die1.wav", "voices/human/male_die.wav");
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("npc/guard1.mdl");
		CallEventDelayed(Float(Eval("$randf(10,60)")), "GloamSitter_Timer");
		CallEventDelayed(2.0f, "GloamSitter_Timer2");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "game_damaged") { Return(OnGameDamaged(EntityParam(params, 0), Float(Param(params, 1)), Param(params, 2), Float(Param(params, 3)), EntityParam(params, 4), Param(params, 5))); return true; }
		if (name == "game_death") { OnGameDeath(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_menu_getoptions") { OnGameMenuGetoptions(PlayerParam(params, 0)); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "get_slayer_id") { OnGetSlayerId(); return true; }
		if (name == "say_hi") { OnSayHi(PlayerParam(params, 0)); return true; }
		if (name == "GloamSitter_Timer") { GloamSitter_Timer(); return true; }
		if (name == "GloamSitter_Timer2") { GloamSitter_Timer2(); return true; }
		return false;
	}
}
