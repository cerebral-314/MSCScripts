#pragma context server

// Converted from deralia/guard_gate.script by msc_transpiler.
// Since this does practically the same thing as deralia/guard, I just made it as an include.

#include "runtime/ScriptEntity.as"
#include "converted/deralia/guard.as"

[script "deralia/guard_gate"]
class GuardGate : DeraliaGuardScript
{
	// unnamed block (timer)
	// Greet player and other NPCs
	void GuardGate_Timer()
	{
		string speak = "L_SPEAK";
		CallEventDelayed(30.0f, "GuardGate_Timer");

		if (!IS_HUNTING && Truthy(LegacyFunction("cansee", "ally", 80)))
		{
			CBaseEntity@ ent = EntityOf(ENT_LASTSEEN);
			string easterEgg = "Tamed Boar"; // Found out that guards attempt to greet the friendly boars. It was entertaining enough for me to want to make an easter egg.

			if (NameOf(ent) == easterEgg && !IsPlayer(ent))
			{
				int rand = RandomInt(0, 3);

				if (rand == 0)
					speak = "G'day, sir";
				else if (rand == 1)
					speak = "*Squeal?*";
				else if (rand == 2)
					speak = "henlo";
				else if (rand == 3)
					speak = "*cough cough*";

				CallExternal(ent, "ext_speak", speak);
			}

			OnNpcatkSetmovedest(EntityId(ent), "128");

			PlaySound(0, 5, "npc/hello1.wav");
			Say("[.83]", "[.33]", "[.91]", "[.91]", "[.38]", "[.36]");
		}
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("npc/guard1.mdl");
		CallEventDelayed(30.0f, "GuardGate_Timer");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "GuardGate_Timer") { GuardGate_Timer(); return true; }
		return DeraliaGuardScript::DispatchEvent(name, params);
	}
}
