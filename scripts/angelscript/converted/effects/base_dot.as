#pragma context server

// Converted from effects/base_dot.script by msc_transpiler.
// Base dot by greatguys1
// Includes functions to help the top script deal damage over time.
// Supports stacking DoTs.
// DoTs of the same element from the same attacker do not stack.
// PARAM1 = duration. 0, or less than 0 will stay until death.

#include "runtime/ScriptEntity.as"
#include "converted/effects/base_effect.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class BaseDot
{
	// Constants
	string EFFECT_ID = "base_dot";
	string EFFECT_SCRIPT = "EFFECT_SCRIPT";
	string DOT_TYPE = "fire_effect";
	string DOT_IM_AFFECTED = "You are on base_dot!";
	string DOT_IM_RESIST = "The base_dot leaves you unharmed.";
	string DOT_HE_IMMUNE = "is not harmed by the base_dot.";

	// Variables (an unset .script variable reads as its own name)
	bool DOT_RESISTED = false;
	string DOT_ATTACKER = "DOT_ATTACKER";
	float DOT_DMG = 0.0f;
	string DOT_SKILL = "DOT_SKILL";
	string DOT_FLAG_NAME = "DOT_FLAG_NAME";
	string BE_RESIST_STRING = "BE_RESIST_STRING";

	// unnamed block (first think)
	void BaseDot_FirstThink()
	{
		DOT_RESISTED = false; // Checks will set this to 1 if the target should not get the dot affects
	}

	// game_activate
	void BaseDot_OnGameActivate(string duration = "", string amount = "", string damage = "", string skill = "", string extraValue5 = "", string falloff = "")
	{
		DOT_ATTACKER = amount;
		DOT_DMG = Float(damage);
		DOT_SKILL = skill;

		DOT_FLAG_NAME = DOT_TYPE + ";" + IndexOf(DOT_ATTACKER); // example: fire_effect;1

		// $funcs will call the event on every applied dot. A callevent with a var that gets set should suffice.
		OnDotCheckCanapply();
		if (!DOT_RESISTED)
		{
			PlayerMessage(ENT_ME, DOT_IM_AFFECTED);
			ScriptFlags(ENT_ME, "add", DOT_FLAG_NAME, EFFECT_ID, DOT_DMG, EFFECT_DURATION);

			OnDotStart(); // For higher script use
			CallEventDelayed(0.5f, "dot_effect");
		}
		else
		{
			RemoveScript();
		}
	}

	// game_death
	// Gets called when npc dies
	void BaseDot_OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		if (DOT_RESISTED)
			return;
		ScriptFlags(ENT_ME, "remove", DOT_FLAG_NAME);
	}

	// dot_start
	// Begin any fx or additional commands on the DoT
	void BaseDot_OnDotStart()
	{
	}

	// dot_effect
	// requires DOT_TYPE DOT_DMG DOT_ATTACKER DOT_SKILL
	void BaseDot_OnDotEffect()
	{
		// <target> <direct> <damage> <chance to hit> <attacker> <inflciter> <skill|none> <dmg_type> [flag_string]
		DoDamageEx(self, "direct", DOT_DMG, 100, DOT_ATTACKER, DOT_ATTACKER, DOT_SKILL, DOT_TYPE);
		CallEventDelayed(1.0f, "dot_effect");
	}

	// dot_check_canapply
	// Runs all the functions needed to see if this effect can be applied
	void BaseDot_OnDotCheckCanapply()
	{
		OnDotFiendlyCheck();

		if (DOT_RESISTED) // checks can send players info, dont run additional checks if theyre not necessary
			return;
		OnDotResistCheck();

		if (DOT_RESISTED)
			return;
		OnDotScriptflagCheck();
	}

	// dot_fiendly_check
	// Returns 1 if I am friendly
	void BaseDot_OnDotFiendlyCheck()
	{
		// $can_damage doesnt seem to be working correctly. Just check if they're immune until fix.
		// if ( !$get(ent_me,invincible) ) //cannot be damaged by attacker
		// {
		// //infomsg all "Can damage: " $can_damage(DOT_ATTACKER)
		// return 1
		// exitevent
		// }
		// Okay. Invincible checks dont work either. Nix this check all together until fix.
		if (EntityOf(DOT_ATTACKER) is self) // cannot afflict myself
		{
			DOT_RESISTED = true;
			return;
		}

		if (IsPlayer(ENT_ME) && IsPlayer(DOT_ATTACKER) && !IsPvp()) // cannot affect players if pvp is off
		{
			DOT_RESISTED = true;
			return;
		}

		if (RelationshipOf(ENT_ME, DOT_ATTACKER) == "ally") // cannot be affected by allies
		{
			DOT_RESISTED = true;
			return;
		}
	}

	// dot_resist_check
	void BaseDot_OnDotResistCheck()
	{
		if (Truthy(ScriptVarOf(ENT_ME, "PLAYING_DEAD")))
		{
			DOT_RESISTED = true;
			return;
		}

		string dotType = DOT_TYPE;
		if (Contains(dotType, "_effect"))
		{
			dotType = LegacyFunction("string_upto", dotType, "_"); // Removes "_effect" from the damage type for the $get_takedmg test.
		}

		float immuneRatio = DamageTakenOf(ENT_ME, dotType); // Test damage resistance

		if (immuneRatio == 0.0f)
		{
			PlayerMessageGreen(ENT_ME, DOT_IM_RESIST);
			PlayerMessageDark(DOT_ATTACKER, NameOf(ENT_ME) + " " + DOT_HE_IMMUNE);

			DOT_RESISTED = true;
			return;
		}

		int roll = RandomInt(1, 100);
		float resistance = Clamp(int(immuneRatio * 100.0f), 0.0f, 100.0f);

		BE_RESIST_STRING = " ( " + roll + " / " + Text(resistance) + " )";

		if (roll > resistance) // Resisted
		{
			PlayerMessageGreen(ENT_ME, DOT_IM_RESIST + " " + BE_RESIST_STRING);
			PlayerMessageDark(DOT_ATTACKER, NameOf(ENT_ME) + " resists the " + dotType + " magic. " + BE_RESIST_STRING);

			DOT_RESISTED = true;
			return;
		}
	}

	// dot_scriptflag_check
	void BaseDot_OnDotScriptflagCheck()
	{
		ScriptFlags(ENT_ME, "remove_expired"); // Remove potentially expired dots b4 checking

		string valueText = ScriptFlag(ENT_ME, DOT_FLAG_NAME, "name_value");
		float value = Float(valueText);

		if (valueText != "none")
		{
			DOT_RESISTED = true; // Flag that it's already on

			if (value < DOT_DMG)
			{
				value = DOT_DMG;
				valueText = Text(value);
			}

			ScriptFlags(ENT_ME, "edit", DOT_FLAG_NAME, EFFECT_ID, valueText, EFFECT_DURATION); // increase damage / duration
		}
		else if (IsPlayer(ENT_ME) && Truthy(ScriptFlag(ENT_ME, EFFECT_ID, "type_exists")))
		{
			DOT_RESISTED = true; // players dont get stacked dots from monsters.
		}
	}

	// game_scriptflag_update
	// <action> <name> <type> <value> <base_expire_time>
	void BaseDot_OnGameScriptflagUpdate(string action = "", string flagName = "", string flagType = "", float value = 0.0f, float baseExpireTime = 0.0f)
	{
		if (DOT_RESISTED)
			return;
		if (action != "edit")
			return;
		if (flagName != DOT_FLAG_NAME)
			return;

		OnDotScriptflagUpdate(Float(Text(value)), Float(Text(baseExpireTime)));
	}

	// dot_scriptflag_update
	// scriptflag was updated, helps update any other relavant fx on higher scripts
	void BaseDot_OnDotScriptflagUpdate(float damage = 0.0f, float duration = 0.0f)
	{
		DOT_DMG = damage;
		OnEffectSetDuration(Text(duration));

		OnDotStart(); // "start" the dot over again.
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)

	// game_activate
	void OnGameActivate(string duration = "", string amount = "", string damage = "", string skill = "", string extraValue5 = "", string falloff = "")
	{
		BaseEffect_OnGameActivate(duration, amount, damage, skill, extraValue5, falloff); // effects/base_effect
		BaseDot_OnGameActivate(duration, amount, damage, skill, extraValue5, falloff);
	}

	void OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "") { BaseDot_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); } // game_death
	void OnDotStart() { BaseDot_OnDotStart(); } // dot_start
	void OnDotEffect() { BaseDot_OnDotEffect(); } // dot_effect
	void OnDotCheckCanapply() { BaseDot_OnDotCheckCanapply(); } // dot_check_canapply
	void OnDotFiendlyCheck() { BaseDot_OnDotFiendlyCheck(); } // dot_fiendly_check
	void OnDotResistCheck() { BaseDot_OnDotResistCheck(); } // dot_resist_check
	void OnDotScriptflagCheck() { BaseDot_OnDotScriptflagCheck(); } // dot_scriptflag_check
	void OnGameScriptflagUpdate(string action = "", string flagName = "", string flagType = "", float value = 0.0f, float baseExpireTime = 0.0f) { BaseDot_OnGameScriptflagUpdate(action, flagName, flagType, value, baseExpireTime); } // game_scriptflag_update
	void OnDotScriptflagUpdate(float damage = 0.0f, float duration = 0.0f) { BaseDot_OnDotScriptflagUpdate(damage, duration); } // dot_scriptflag_update

	// This file's events and timers by their .script names
	bool BaseDot_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "dot_check_canapply") { OnDotCheckCanapply(); return true; }
		if (name == "dot_effect") { OnDotEffect(); return true; }
		if (name == "dot_fiendly_check") { OnDotFiendlyCheck(); return true; }
		if (name == "dot_resist_check") { OnDotResistCheck(); return true; }
		if (name == "dot_scriptflag_check") { OnDotScriptflagCheck(); return true; }
		if (name == "dot_scriptflag_update") { OnDotScriptflagUpdate(Float(Param(params, 0)), Float(Param(params, 1))); return true; }
		if (name == "dot_start") { OnDotStart(); return true; }
		if (name == "game_activate") { OnGameActivate(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5)); return true; }
		if (name == "game_death") { OnGameDeath(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_scriptflag_update") { OnGameScriptflagUpdate(Param(params, 0), Param(params, 1), Param(params, 2), Float(Param(params, 3)), Float(Param(params, 4))); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "effects/base_dot"]
shared class BaseDotScript : BaseEffectScript, BaseDot
{
	// Variables declared by included files, with the value they start with in this script
	BaseDotScript()
	{
		EFFECT_ID = "base_dot";
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		BaseDot_FirstThink();
		BaseEffect_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return BaseDot_DispatchEvent(name, params)
			|| BaseEffectScript::DispatchEvent(name, params);
	}
}
