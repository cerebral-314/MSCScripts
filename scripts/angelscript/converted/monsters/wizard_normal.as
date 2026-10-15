#pragma context server

// Converted from monsters/wizard_normal.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/keledrosruins/keledros.as"

[script "monsters/wizard_normal"]
class WizardNormal : KeledrosruinsKeledrosScript
{
	// Variables declared by included files, with the value they start with in this script
	WizardNormal()
	{
		AM_GENERIC = true;
	}

	// do_ale_intro
	// { game_spawn
	// callevent 0.1 bogus_script_check
	// }
	// { bogus_script_check
	// setvard BOGUS_SCRIPT not
	// }
	// {
	// epeatdelay 1.0
	// dbg bogus_script_check BOGUS_SCRIPT
	// }
	void OnDoAleIntro()
	{
		CallEventDelayed(1.0f, "do_ale_intro1");
	}

	// do_ale_intro1
	void OnDoAleIntro1()
	{
		SetSayTextRange(2048);
		SayText("Whoever you are, turn around and head back. Only death awaits further.");
		CallEventDelayed(4.0f, "do_ale_intro2");
	}

	// do_ale_intro2
	void OnDoAleIntro2()
	{
		SayText("For many cycles I have guarded these canyons and will continue to do so until the great Keledros returns.");
		CallEventDelayed(4.0f, "do_ale_intro3");
	}

	// do_ale_intro3
	void OnDoAleIntro3()
	{
		SayText("Keledros dead, you say!? Ha! Only time will tell if that is true or not.");
		CallEventDelayed(4.0f, "do_ale_intro4");
	}

	// do_ale_intro4
	void OnDoAleIntro4()
	{
		SayText("Enough! Prepare to die at my hands!");
	}

	// npc_death
	void OnNpcDeath()
	{
		if (!AM_SKELE)
			return;
		if (!Contains(ToLowerCase(MapName()), "aleyesu"))
			return;
		SayText("Master... Forgive me...");
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
		if (name == "npc_death") { OnNpcDeath(); return true; }
		return KeledrosruinsKeledrosScript::DispatchEvent(name, params);
	}
}
