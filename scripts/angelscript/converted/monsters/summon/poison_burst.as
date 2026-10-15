#pragma context server

// Converted from monsters/summon/poison_burst.script by msc_transpiler.
// Poison burst, from Stun Burst (Thothie JAN2009)

#include "runtime/ScriptEntity.as"

[script "monsters/summon/poison_burst"]
class PoisonBurst : ScriptEntity
{
	// Variables (an unset .script variable reads as its own name)
	string MY_OWNER = "MY_OWNER";
	string OWNER_ISPLAYER = "OWNER_ISPLAYER";
	int SCAN_RANGE = 0;
	string THROW_TARGETS = "THROW_TARGETS";
	float MY_BASE_DAMAGE = 0.0f;
	float MY_DOT = 0.0f;
	string BURST_SCRIPT_IDX = "BURST_SCRIPT_IDX";
	string PLAYING_DEAD = "PLAYING_DEAD";
	string TARG_LIST = "TARG_LIST";

	// game_dynamically_created
	// PARAM1 Owner, PARAM2 ScanRange, PARAM3 = throw if set 1, PARAM4 blast damage, PARAM5 = DOT
	void OnGameDynamicallyCreated(string creatorValue1 = "", string creatorValue2 = "", string damage = "", string skill = "", string extraValue5 = "", string extraValue6 = "", float alwaysPush = 0.0f, string duration = "", string extraValue9 = "")
	{
		MY_OWNER = creatorValue1;
		OWNER_ISPLAYER = Text(IsPlayer(creatorValue1));
		SCAN_RANGE = Int(creatorValue2);
		if (!damage.isEmpty())
			THROW_TARGETS = damage;
		MY_BASE_DAMAGE = Float(skill);
		MY_DOT = Float(extraValue5);

		SetAngle("face", Vector3(0, 90, 0)); // $get(MY_OWNER,angles)

		SetRace(RaceOf(MY_OWNER));

		ClientEvent("new", "all_in_sight", "monsters/summon/poison_burst_cl", OriginOf(ENT_ME), SCAN_RANGE);
		BURST_SCRIPT_IDX = LastClientScriptId();

		CallEventDelayed(0.1f, "do_aoe");

		CallEventDelayed(0.25f, "set_targets");

		CallEventDelayed(3.0f, "effect_die");
	}

	// do_aoe
	void OnDoAoe()
	{
		DoDamageEx(RelativePosition(Vector3(0, 0, 0)), SCAN_RANGE, MY_BASE_DAMAGE, 0, MY_OWNER, MY_OWNER, "spellcasting.affliction", "poison");
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		SetFly(true);
		SetGravity(0);
		SetNoPush(true);
		SetInvincible(true);
		PLAYING_DEAD = "1";
	}

	// effect_die
	void OnEffectDie()
	{
		ClientEvent("remove", "all", BURST_SCRIPT_IDX);
		DeleteEntity(ENT_ME);
	}

	// set_targets
	void OnSetTargets()
	{
		PlaySound(0, 10, "ambience/steamburst1.wav");

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

		if (Truthy(OWNER_ISPLAYER) && (IsPvp() ? 1 : 0) == 0 && IsPlayer(checkEnt))
			exitSub = true;
		// dbg aborted, players do not stun players in non-pvp ( game.pvp )
		if (exitSub)
			return;

		if (!HasEffect(checkEnt, "DOT_poison"))
			ApplyEffect(checkEnt, "effects/dot_poison", 5.0f, MY_OWNER, MY_DOT);

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
		if (name == "do_aoe") { OnDoAoe(); return true; }
		if (name == "effect_die") { OnEffectDie(); return true; }
		if (name == "game_dynamically_created") { OnGameDynamicallyCreated(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Float(Param(params, 6)), Param(params, 7), Param(params, 8)); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "set_targets") { OnSetTargets(); return true; }
		return false;
	}
}
