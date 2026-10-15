#pragma context server

// Converted from orc_for/orc_summoner.script by msc_transpiler.

#include "runtime/ScriptEntity.as"

[script "orc_for/orc_summoner"]
class OrcSummoner : ScriptEntity
{
	// Variables (an unset .script variable reads as its own name)
	bool NO_SPAWN_STUCK_CHECK = true;

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		SetUniqueName("orc_summoner");

		SetName("Blackhand Summoner");
		SetInvincible(true);
		SetRace("orc");
		SetModel("monsters/Orc.mdl");
		SetProp(ENT_ME, "skin", 2);
		SetWidth(5);
		SetHeight(5);
		SetHealth(9999);
		SetBlood("red");

		SetIdleAnim("kneel");
		SetMoveAnim("kneel");

		PlayAnim("once", "kneel");

		NO_SPAWN_STUCK_CHECK = true;

		SetModelBody(0, 0); // Body 0=naked 1=leather 2=plate 3=green-hide
		SetModelBody(1, 4); // Head 0=cap_shorthorn 1=cap_nohorn 2=buffo_skin 3=cheif_ramhorns 4=green_hood
		SetModelBody(2, 0); // Weapon 0=fist 1=axe 2=bow_weak 3=bow_strng 4=sword 5=bloodyaxe 6=sword&sheild

		SetSayTextRange(4096);
	}

	// ext_players_r_here
	void OnExtPlayersRHere()
	{
		SayText("No! The binding is not yet complete!");
		CallEventDelayed(2.0f, "summon_fail");
	}

	// summon_fail
	void OnSummonFail()
	{
		PlayMusic("all", "combat", "media/Suspense07.mp3");

		CBaseEntity@ boneAbom = FindByName("bone_abomination");
		CBaseEntity@ fireDjinn = FindByName("fire_djinn");
		if (IsAlive(fireDjinn))
			CallExternal(fireDjinn, "kill_zugdah");
		if (IsAlive(boneAbom))
		{
			PlaySound(0, 10, "voices/orc/die.wav");
			CallExternal(boneAbom, "eat_me");
		}
		UseTrigger("mm_circle_fade");
	}

	// ext_me_die
	void OnExtMeDie()
	{
		SetInvincible(false);
		DoDamage(ENT_ME, "direct", 2000, 100, GetVar("GAME_MASTER"), "target");
		PlaySound(0, 10, "voices/orc/die.wav");
		PlayAnim("break");
		PlayAnim("hold", "die_fallback");
		SetSolid("none");
		SetBoundingBox("none");
		CallEventDelayed(5.0f, "fade_out");
	}

	// fade_out
	void OnFadeOut()
	{
		DeleteEntity(ENT_ME, "fade");
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/Orc.mdl");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "ext_me_die") { OnExtMeDie(); return true; }
		if (name == "ext_players_r_here") { OnExtPlayersRHere(); return true; }
		if (name == "fade_out") { OnFadeOut(); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "summon_fail") { OnSummonFail(); return true; }
		return false;
	}
}
