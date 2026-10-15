#pragma context server

// Converted from monsters/base_flyer_agro.script by msc_transpiler.
// Aggressive fly AI
// - As used by Horror, bats, etc. - good for swimmers too
// - They have it integrated via copy & paste - figure overdue time to make a base
// - use in place of base_flyer

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_flyer.as"

[script "monsters/base_flyer_agro"]
class BaseFlyerAgro : BaseFlyerScript
{
	// Constants
	int BF_CRUISE_SPEED = 200;
	int BF_BOOST_SPEED = 500;
	int BF_FLIGHT_STUCK_LIMIT = 4;

	// Variables (an unset .script variable reads as its own name)
	float FLIGHT_STUCK = 0.0f;
	float LAST_PROG = 0.0f;
	Vector3 LAST_POS = Vector3();

	// bf_agrofly_loop
	void OnBfAgroflyLoop()
	{
		CallEventDelayed(0.5f, "bf_agrofly_loop");
		// (never true here, the rest is skipped) if IS_HUNTING
	}

	// chicken_run
	void OnChickenRun(float duration = 0.0f)
	{
		CallEventDelayed(0.1f, "bf_agrofly_boost");
	}

	// bf_agrofly_boost
	void OnBfAgroflyBoost()
	{
		SetVelocity(ENT_ME, RelativeVelocity(Vector3(0, BF_BOOST_SPEED, 0)));
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files
	void OnNpcatkFaceattacker(string target = "") {} // npcatk_faceattacker

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "bf_agrofly_boost") { OnBfAgroflyBoost(); return true; }
		if (name == "bf_agrofly_loop") { OnBfAgroflyLoop(); return true; }
		if (name == "chicken_run") { OnChickenRun(Float(Param(params, 0))); return true; }
		return BaseFlyerScript::DispatchEvent(name, params);
	}
}
