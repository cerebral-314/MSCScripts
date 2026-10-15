#pragma context server

// Converted from other/oyster_breakable.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/debug.as"

[script "other/oyster_breakable"]
class OysterBreakable : DebugScript
{
	// Constants
	string VALID_DAMAGE_TYPES = "blunt;fire";
	string OBJECT_NAME = "web";
	string MAP_TRIGGER = "break_web1";
	int DAMAGE_THRESHOLD = 100;
	string SOUND_STRUCK1 = "debris/flesh1.wav";
	string SOUND_STRUCK2 = "debris/flesh2.wav";
	string SOUND_STRUCK3 = "debris/flesh3.wav";
	string SOUND_RESIST1 = "weapons/bullet_hit1.wav";
	string SOUND_RESIST2 = "weapons/bullet_hit2.wav";
	string SOUND_RESIST3 = "weapons/ric1.wav";
	string SOUND_BREAK = "debris/bustflesh1.wav";

	// Variables (an unset .script variable reads as its own name)
	string PLAYING_DEAD = "PLAYING_DEAD";
	bool VALID_DAMAGE = false;
	string INC_DAMAGE_TYPE = "INC_DAMAGE_TYPE";
	float NEXT_IMMUNE_WARN = 0.0f;
	bool AM_BROKE = false;

	// game_damaged
	// PARAM1=attacker PARAM2=dmg PARAM3=dmg_type
	string OysterBreakable_OnGameDamaged(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float accuracyRoll = 0.0f, CBaseEntity@ inflictor = null, string skill = "")
	{
		string result = "";

		if (AM_BROKE)
			return result;
		// check for valid incoming damage types
		VALID_DAMAGE = false;
		INC_DAMAGE_TYPE = damageType;
		int count = GetTokenCount(VALID_DAMAGE_TYPES);
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnCheckType();
		}

		if (!VALID_DAMAGE && GameTime() > NEXT_IMMUNE_WARN)
		{
			NEXT_IMMUNE_WARN = GameTime() + 5.0f; // so we don't spam the player with this report, due to an invalid DOT or what not.
			PlayerMessageDark(attacker, "The " + NameOf(ENT_ME) + " seems resistant to this weapon.");
			PlayRandomSound(0, 10, SOUND_RESIST1, SOUND_RESIST2, SOUND_RESIST3);
		}

		if (VALID_DAMAGE)
		{
			if (damage >= DAMAGE_THRESHOLD)
			{
				PlaySound(0, 10, SOUND_BREAK);
				UseTrigger(MAP_TRIGGER);
				SetInvincible(true);
				AM_BROKE = true;
				CallEventDelayed(0.1f, "remove_me"); // adding a delay here in case damage sent to a soon-to-be null entity causes a problem
			}
			else
			{
				PlayRandomSound(0, 10, SOUND_STRUCK1, SOUND_STRUCK2, SOUND_STRUCK3);
				PlayerMessageDark(attacker, "The " + NameOf(ENT_ME) + " budges, but it seems it must be struck with more force. ( " + int(damage) + " of " + DAMAGE_THRESHOLD + " )");
				// zero out damage and reset health (just in case)
				SetHealth(9999);
			}
		}
		return result;
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		SetHealth(99999);
		SetName(OBJECT_NAME);
		PLAYING_DEAD = "1"; // so mobs don't target it
	}

	string OnGameDamaged(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float accuracyRoll = 0.0f, CBaseEntity@ inflictor = null, string skill = "") { return OysterBreakable_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill); } // game_damaged

	// check_type
	void OnCheckType()
	{
		string curType = GetToken(VALID_DAMAGE_TYPES, loopIteration);
		if (!StartsWith(INC_DAMAGE_TYPE, curType)) // use use startswith because DOT fire becomes fire_effect, etc.
			return;
		VALID_DAMAGE = true;
	}

	// remove_me
	void OnRemoveMe(string caller = "")
	{
		DeleteEntity(ENT_ME);
		RemoveScript();
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "check_type") { OnCheckType(); return true; }
		if (name == "game_damaged") { Return(OnGameDamaged(EntityParam(params, 0), Float(Param(params, 1)), Param(params, 2), Float(Param(params, 3)), EntityParam(params, 4), Param(params, 5))); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "remove_me") { OnRemoveMe(Param(params, 0)); return true; }
		return DebugScript::DispatchEvent(name, params);
	}
}
