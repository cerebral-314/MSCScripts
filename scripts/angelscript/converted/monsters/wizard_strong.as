#pragma context server

// Converted from monsters/wizard_strong.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/bloodrose/venevus.as"

[script "monsters/wizard_strong"]
class WizardStrong : VenevusScript
{
	// Variables declared by included files, with the value they start with in this script
	WizardStrong()
	{
		AM_GENERIC = true;
	}

	// game_precache
	void OnGamePrecache()
	{
		PrecacheFile("aleyesu/death_image");
	}

	// game_death
	void OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		DqMonsterExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // dq/externals/dq_monster_externals
		MonstersExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/externals
		BaseSelfAdjust_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_self_adjust
		BaseNpc_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		Venevus_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // bloodrose/venevus
		if (!Contains(ToLowerCase(MapName()), "aleyesu"))
			return;
		CreateNpc("aleyesu/death_image", RelativePosition(Vector3(0, 0, 0)), NPC_SPAWN_LOC);
		SetProp(ENT_ME, "rendermode", 5);
		SetProp(ENT_ME, "renderamt", 0);
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		Venevus_OnNpcSpawn(npc); // bloodrose/venevus

		SetHealth(12000);

		SetDamageTaken("slash", 1);
		SetDamageTaken("pierce", 1);
		SetDamageTaken("blunt", 1);
		SetDamageTaken("lightning", 0.25f);
		SetDamageTaken("cold", 0.25f);
	}

	// do_ale_intro
	void OnDoAleIntro()
	{
		CallEventDelayed(1.0f, "do_ale_intro1");
	}

	// do_ale_intro1
	void OnDoAleIntro1()
	{
		SetSayTextRange(2048);
		SayText("I don't believe it! I mean of course I believe it, I did just travel forward through time.");
		CallEventDelayed(4.0f, "do_ale_intro2");
	}

	// do_ale_intro2
	void OnDoAleIntro2()
	{
		SayText("Who are you?! What are you doing in my chamber?!");
		CallEventDelayed(4.0f, "do_ale_intro3");
	}

	// do_ale_intro3
	void OnDoAleIntro3()
	{
		SayText("Don't tell me you touched that dial!?");
		CallEventDelayed(4.0f, "do_ale_intro4");
	}

	// do_ale_intro4
	void OnDoAleIntro4()
	{
		SayText("Oh never mind... I'll just kill you all!");
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "do_ale_intro") { OnDoAleIntro(); return true; }
		if (name == "do_ale_intro1") { OnDoAleIntro1(); return true; }
		if (name == "do_ale_intro2") { OnDoAleIntro2(); return true; }
		if (name == "do_ale_intro3") { OnDoAleIntro3(); return true; }
		if (name == "do_ale_intro4") { OnDoAleIntro4(); return true; }
		if (name == "game_death") { OnGameDeath(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_precache") { OnGamePrecache(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		return VenevusScript::DispatchEvent(name, params);
	}
}
