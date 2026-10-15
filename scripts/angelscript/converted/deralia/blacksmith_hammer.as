#pragma context server

// Converted from deralia/blacksmith_hammer.script by msc_transpiler.
// Blacksmith

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_npc.as"

[script "deralia/blacksmith_hammer"]
class BlacksmithHammer : BaseNpcScript
{
	// Constants
	bool NO_CHAT = true;

	// Variables (an unset .script variable reads as its own name)
	float COUNT = 0.0f;
	float REST = 10.0f;
	float DELAY = 1.05f;

	// unnamed block (first think)
	void BlacksmithHammer_FirstThink()
	{
		COUNT = 0.0f;
		REST = 10.0f;
		DELAY = 1.05f;
	}

	// unnamed block (timer)
	void BlacksmithHammer_Timer()
	{
		CallEventDelayed(DELAY, "BlacksmithHammer_Timer");

		if (COUNT < 8.0f)
		{
			// playanim critical smith_hammer_time
			COUNT += 1.0f;
		}

		if (COUNT == 8.0f && REST > 0.0f)
		{
			if (DELAY == 8.36f)
			{
				PlayAnim("critical", "smith_hammer_look");
				COUNT = 0.0f;
				DELAY = 1.05f;
				REST -= 1.0f;
			}
			else
			{
				DELAY = 8.36f;
			}
		}

		if (REST == 0.0f)
		{
			if (DELAY == 10.86f)
			{
				PlayAnim("critical", "smith_hammer_idle");
				REST = 10.0f;
				COUNT = 0.0f;
				DELAY = 1.05f;
			}
			else
			{
				DELAY = 10.86f;
			}
		}
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		SetHealth(1);
		SetName("A blacksmith");
		SetWidth(1);
		SetHeight(72);
		SetRoam(false);
		SetModel("npc/blacksmith.mdl");
		SetModelBody(0, 1);
		SetModelBody(1, 2);
		SetIdleAnim("smith_hammer_time");
		SetInvincible(true);
		SetAngle("face", Vector3(0, -90, 0));
	}

	// hammer_sound
	void OnHammerSound()
	{
		PlaySound(0, 10, "amb/fx_anvil.wav");
		Effect("tempent", "trail", "3dmflaora.spr", RelativePosition(Vector3(-11, 15, -10)), RelativePosition(Vector3(-11, 15, 25)), 5, 0.5f, 1, 10, 10);
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("3dmflaora.spr");
		Precache("npc/blacksmith.mdl");
		CallEventDelayed(DELAY, "BlacksmithHammer_Timer");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		BlacksmithHammer_FirstThink();
		BaseNpc_FirstThink();
		MonstersExternals_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "hammer_sound") { OnHammerSound(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "BlacksmithHammer_Timer") { BlacksmithHammer_Timer(); return true; }
		return BaseNpcScript::DispatchEvent(name, params);
	}
}
