#pragma context server

// Converted from monsters/summon/flame_burst.script by msc_transpiler.
// flame burst

#include "runtime/ScriptEntity.as"

[script "monsters/summon/flame_burst"]
class FlameBurst : ScriptEntity
{
	// Constants
	int SCAN_RANGE = 256;

	// Variables (an unset .script variable reads as its own name)
	string MY_OWNER = "MY_OWNER";
	string OWNER_ISPLAYER = "OWNER_ISPLAYER";
	float MY_BASE_DAMAGE = 0.0f;
	string ONE_SHOT = "ONE_SHOT";
	string ACTIVE_SKILL = "ACTIVE_SKILL";
	string BURST_SCRIPT_IDX = "BURST_SCRIPT_IDX";

	// game_dodamage
	// 1:AttackHit(1/0)  2:EntityHit  3:StartOrigin  4:EndOrigin
	string FlameBurst_OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		bool exitSub = false;
		string result = "";

		if (!hit)
			return result;
		if (RelationshipOf(target, MY_OWNER) != "enemy")
			return result;

		// players don't burn each other
		if (Truthy(OWNER_ISPLAYER) && !IsPvp() && IsPlayer(target))
			exitSub = true;
		if (exitSub)
			return result;

		if (!Truthy(ONE_SHOT) && !HasEffect(target, "DOT_fire"))
			ApplyEffect(target, "effects/dot_fire", 5, MY_OWNER, MY_BASE_DAMAGE, ACTIVE_SKILL);
		if (Truthy(ONE_SHOT))
			DoDamageEx(@target, "direct", MY_BASE_DAMAGE, "100%", MY_OWNER, MY_OWNER, ACTIVE_SKILL, "fire");
		return result;
	}

	// game_dynamically_created
	// PARAM1 Owner, PARAM2 Damage
	void OnGameDynamicallyCreated(string creatorValue1 = "", string creatorValue2 = "", string damage = "", string skill = "", string extraValue5 = "", string extraValue6 = "", float alwaysPush = 0.0f, string duration = "", string extraValue9 = "")
	{
		// //dbg temp got PARAM1 PARAM2
		MY_OWNER = creatorValue1;
		OWNER_ISPLAYER = Text(IsPlayer(creatorValue1));
		MY_BASE_DAMAGE = Float(creatorValue2);
		if (!damage.isEmpty())
			ONE_SHOT = damage;
		ACTIVE_SKILL = skill;
		if (ACTIVE_SKILL.isEmpty())
			ACTIVE_SKILL = "spellcasting.fire";

		ClientEvent("new", "all_in_sight", "monsters/summon/flame_burst_cl", IndexOf(MY_OWNER));
		BURST_SCRIPT_IDX = LastClientScriptId();

		CallEventDelayed(0.25f, "big_boom");

		CallEventDelayed(3.0f, "effect_die");
	}

	// effect_die
	void OnEffectDie()
	{
		DeleteEntity(ENT_ME);
	}

	// big_boom
	void OnBigBoom()
	{
		PlaySound(0, 10, "ambience/steamburst1.wav");
		DoDamage(Text(RelativePosition(Vector3(0, 0, -32))), SCAN_RANGE, 0.0f, "100%", 0, "reflective");
	}

	string OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "") { return FlameBurst_OnGameDodamage(hit, target, start, end, damageType, damageText); } // game_dodamage

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "big_boom") { OnBigBoom(); return true; }
		if (name == "effect_die") { OnEffectDie(); return true; }
		if (name == "game_dodamage") { Return(OnGameDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5))); return true; }
		if (name == "game_dynamically_created") { OnGameDynamicallyCreated(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Float(Param(params, 6)), Param(params, 7), Param(params, 8)); return true; }
		return false;
	}
}
