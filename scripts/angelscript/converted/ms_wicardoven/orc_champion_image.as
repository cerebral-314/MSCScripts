#pragma context server

// Converted from ms_wicardoven/orc_champion_image.script by msc_transpiler.

#include "runtime/ScriptEntity.as"

[script "ms_wicardoven/orc_champion_image"]
class OrcChampionImage : ScriptEntity
{
	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		SetName("Orc Lieutenant Veral");
		SetRace("orc");
		SetInvincible(true);

		SetUniqueName("orc_b");

		SetModel("monsters/orc.mdl");
		SetSolid("none");

		SetSayTextRange(2048);

		SetModelBody(0, 0); // Body
		SetModelBody(1, 2); // Head
		SetModelBody(2, 1); // Weapon
	}

	// say_minions
	void OnSayMinions()
	{
		PlayAnim("critical", "shielddeflect1");
		SayText("...And we couldn't control your minions! They kept attacking us!");
		PlaySound(0, 10, "voices/ms_wicardoven/orcb_2fmaldora.wav");
	}

	// die
	void OnDie()
	{
		SetIdleAnim("die_fallback");
		SetMoveAnim("die_fallback");
		PlaySound(0, 10, "voices/orc/die.wav");
		PlayAnim("hold", "die_fallback");
		Effect("glow", ENT_ME, Vector3(255, 255, 255), 200, 3, 3);
		CallEventDelayed(2.0f, "remove_me");
	}

	// remove_me
	void OnRemoveMe(string caller = "")
	{
		DeleteEntity(ENT_ME, "fade");
	}

	// face_me
	void OnFaceMe(CBaseEntity@ target = null)
	{
		SetAngle("face_origin", OriginOf(target));
		CallEventDelayed(0.1f, "straighten_up");
	}

	// straighten_up
	void OnStraightenUp()
	{
		SetAngle("face", Vector3(0, MyAngles().y, 0));
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/orc.mdl");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "die") { OnDie(); return true; }
		if (name == "face_me") { OnFaceMe(EntityParam(params, 0)); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "remove_me") { OnRemoveMe(Param(params, 0)); return true; }
		if (name == "say_minions") { OnSayMinions(); return true; }
		if (name == "straighten_up") { OnStraightenUp(); return true; }
		return false;
	}
}
