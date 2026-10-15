#pragma context server

// Converted from monsters/summon/stun_burst.script by msc_transpiler.
// Stun burst, from Flame Burst

#include "runtime/ScriptEntity.as"

[script "monsters/summon/stun_burst"]
class StunBurst : ScriptEntity
{
	// Variables (an unset .script variable reads as its own name)
	string MY_OWNER = "MY_OWNER";
	string OWNER_ISPLAYER = "OWNER_ISPLAYER";
	int SCAN_RANGE = 0;
	float MY_BASE_DAMAGE = 0.0f;
	string SKILL_TYPE = "SKILL_TYPE";
	string THROW_TARGETS = "THROW_TARGETS";
	string BURST_SCRIPT_IDX = "BURST_SCRIPT_IDX";
	string TARG_LIST = "TARG_LIST";

	// game_dynamically_created
	// PARAM1 Owner, PARAM2 ScanRange, PARAM3 = throw if set 1, PARAM4 damage if set > 0, PARAM5 = passskill
	void OnGameDynamicallyCreated(string creatorValue1 = "", string creatorValue2 = "", string damage = "", string skill = "", string extraValue5 = "", string extraValue6 = "", float alwaysPush = 0.0f, string duration = "", string extraValue9 = "")
	{
		LegacyCommand("storeentity", ENT_EXPOWNER, creatorValue1);

		MY_OWNER = creatorValue1;
		OWNER_ISPLAYER = Text(IsPlayer(creatorValue1));
		SCAN_RANGE = Int(creatorValue2);
		MY_BASE_DAMAGE = 0.0f;
		SKILL_TYPE = "none";
		if (!extraValue5.isEmpty())
			SKILL_TYPE = extraValue5;
		SetRace(RaceOf(MY_OWNER));

		if (SCAN_RANGE == 0)
			SCAN_RANGE = 96;

		// make sure starts on ground
		Vector3 traceOrg = MyOrigin();
		string traceEnd = Text(traceOrg);
		traceEnd = Text(Vec(traceEnd) + RelativePosition(Vector3(0, 0, 0), Vector3(0, 0, -1000)));
		string traceLine = LegacyFunction("get_traceline", traceOrg, traceEnd, "worldonly");

		if (!damage.isEmpty())
			THROW_TARGETS = damage;
		if (!skill.isEmpty())
			MY_BASE_DAMAGE = Float(skill);

		// //dbg temp got Rng SCAN_RANGE Throw THROW_TARGETS Dmg MY_BASE_DAMAGE
		SetOrigin(ENT_ME, Vec(traceLine));

		SetAngle("face", AnglesOf(MY_OWNER));

		ClientEvent("new", "all_in_sight", "monsters/summon/stun_burst_cl", traceLine, SCAN_RANGE);
		BURST_SCRIPT_IDX = LastClientScriptId();

		CallEventDelayed(0.25f, "big_boom");

		CallEventDelayed(3.0f, "effect_die");
	}

	// effect_die
	void OnEffectDie()
	{
		ClientEvent("remove", "all", BURST_SCRIPT_IDX);
		DeleteEntity(ENT_ME);
	}

	// big_boom
	void OnBigBoom()
	{
		PlaySound(0, 10, "magic/boom.wav");

		TARG_LIST = LegacyFunction("get_tsphere", "enemy", SCAN_RANGE, MyOrigin());
		if (TARG_LIST == "none")
			return;
		int count = GetTokenCount(TARG_LIST);
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnAffectTargets();
		}
	}

	// affect_targets
	void OnAffectTargets()
	{
		bool exitSub = false;

		string checkEnt = GetToken(TARG_LIST, loopIteration);

		if (!IsOnGround(checkEnt))
			return;

		if (Truthy(OWNER_ISPLAYER) && (IsPvp() ? 1 : 0) == 0 && IsPlayer(checkEnt))
			exitSub = true;
		// dbg aborted, players do not stun players in non-pvp ( game.pvp )
		if (exitSub)
			return;

		ApplyEffect(checkEnt, "effects/debuff_stun", 5.0f, self);

		if (MY_BASE_DAMAGE > 0.0f)
			DoDamageEx(checkEnt, "direct", MY_BASE_DAMAGE, 0, MY_OWNER, MY_OWNER, SKILL_TYPE, "magic");

		if (!Truthy(THROW_TARGETS))
			return;
		Vector3 targetOrg = OriginOf(checkEnt);
		float targAng = AnglesTo(MyOrigin(), targetOrg);
		int newYaw = int(targAng);
		SetVelocity(checkEnt, RelativeVelocity(Vector3(0, newYaw, 0), Vector3(0, 1000, 0)));
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "affect_targets") { OnAffectTargets(); return true; }
		if (name == "big_boom") { OnBigBoom(); return true; }
		if (name == "effect_die") { OnEffectDie(); return true; }
		if (name == "game_dynamically_created") { OnGameDynamicallyCreated(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Float(Param(params, 6)), Param(params, 7), Param(params, 8)); return true; }
		return false;
	}
}
