#pragma context server

// Converted from effects/iceshield.script by msc_transpiler.
// Ice Shield
// Any npc
// PARAM1 == Duration
// PARAM2 == Damage multiplier

#include "runtime/ScriptEntity.as"
#include "converted/effects/base_effect.as"

[script "effects/iceshield"]
class Iceshield : BaseEffectScript
{
	// Variables (an unset .script variable reads as its own name)
	CBaseEntity@ LAST_SHIELDER = null;
	float DAMAGE_MULTIPLIER = 0.0f;

	// Variables declared by included files, with the value they start with in this script
	Iceshield()
	{
		EFFECT_ID = "iceshield";
		EFFECT_FLAGS = "nostack";
	}

	// game_damaged
	string Iceshield_OnGameDamaged(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float accuracyRoll = 0.0f, CBaseEntity@ inflictor = null, string skill = "")
	{
		string result = "";

		if (!(damage > 0.0f))
			return result;

		Effect("screenfade", ENT_ME, 0.5f, 0, Vector3(0, 0, 192), 40, "fadein");

		PlaySound(0, 3, "player/pl_metal2.wav");

		result = AppendResult(result, Text(DAMAGE_MULTIPLIER));
		return result;
	}

	// game_activate
	// <duration> <who_applied> <damage_multiplier>
	void OnGameActivate(string duration = "", string amount = "", string damage = "", string skill = "", string extraValue5 = "", string falloff = "")
	{
		BaseEffect_OnGameActivate(duration, amount, damage, skill, extraValue5, falloff); // effects/base_effect

		@LAST_SHIELDER = FindEntity(amount);
		DAMAGE_MULTIPLIER = Float(damage); // *damage reduct

		OnShieldMeBaby();

		PlayerMessageGreen(ENT_ME, "You are protected by a shield of ice.");
		PlayerMessageBlue(ENT_ME, "Ice shield " + int(Float(EFFECT_DURATION)) + " seconds remain.");

		if (LAST_SHIELDER !is self)
		{
			PlayerMessageGreen(LAST_SHIELDER, "You shield " + NameOf(ENT_ME) + " for " + EFFECT_DURATION + " seconds."); // Tell shielder that they shielded a player
		}

		OnCheckDoBonus(EFFECT_DURATION);
	}

	// effect_die
	void OnEffectDie()
	{
		BaseEffect_OnEffectDie(); // effects/base_effect

		LegacyCommand("hud.killstatusicon", ENT_ME, "iceshield");
		ServerPlaySound(0, 2, "debris/bustglass2.wav");

		Effect("tempent", "trail", "blueflare1.spr", RelativePosition(Vector3(0, 0, 0)), RelativePosition(Vector3(0, 0, 40)), 10, 2, 5, 10, 20);
		PlayerMessageBlue(self, "Your ice shield has collapsed!");
	}

	// ext_refresh_ice_shield
	// <duration> <shielder> //If a smaller duration is supplied, it will ignore it and refresh the longer duration instead.
	void OnExtRefreshIceShield(string duration = "", CBaseEntity@ shielder = null)
	{
		if (Float(duration) > Float(EFFECT_DURATION))
			EFFECT_DURATION = duration;
		@LAST_SHIELDER = shielder;

		OnEffectGetTimeleft();
		float timeDiff = Float(EFFECT_DURATION) - EFFECT_TIMELEFT; // Get how many seconds were added

		OnEffectSetDuration(EFFECT_DURATION); // Reset expire timer.

		OnShieldMeBaby();

		// Player stuff
		if (LAST_SHIELDER !is self) // If not shielding self
		{
			if (IsPlayer(ENT_ME)) // If I am a player
			{
				PlayerMessageGreen(ENT_ME, NameOf(LAST_SHIELDER) + " has protected you with a shield of ice."); // Tell me that a player so graciously shielded me (and possibly increased my duration)
				PlayerMessageBlue(ENT_ME, "Added " + int(timeDiff) + " seconds to Ice Shield.");
			}

			PlayerMessageGreen(LAST_SHIELDER, "You shield " + NameOf(ENT_ME) + " for " + int(timeDiff) + " more seconds."); // Tell shielder that they shielded a player
		}
		else
		{
			PlayerMessageBlue(ENT_ME, "Added " + int(timeDiff) + " seconds to Ice Shield.");
		}

		OnCheckDoBonus(Text(timeDiff));
	}

	// shield_me_baby
	// Activate fx related to ice shielding
	void OnShieldMeBaby()
	{
		AddStatusIcon(ENT_ME, "hud/status/alpha_iceshield", "iceshield", EFFECT_DURATION);
		Effect("glow", self, Vector3(0, 0, 192), 72, EFFECT_DURATION, EFFECT_DURATION);
		PlaySound(Int(Eval("game.sound.item")), Eval("game.sound.maxvol"), "magic/heal_strike.wav");
	}

	// check_do_bonus
	// <timeAdded>
	void OnCheckDoBonus(string timeAdded = "")
	{
		bool addBonus = false;

		if (LAST_SHIELDER !is self) // If not shielding self
		{
			if (IsPlayer(ENT_ME)) // If I am a player
				addBonus = true;
		}

		if (Truthy(ScriptVarOf(ENT_ME, "NPC_CRITICAL")))
			addBonus = true;

		if (!addBonus)
			return;
		string bonusMsg = "for shielding " + NameOf(ENT_ME);

		float dmgpointAdd = Divide(Float(timeAdded), 412.0f) * 1000.0f; // ( time_diff / 412 seconds ) * 1000
		CallExternal(LAST_SHIELDER, "ext_dmgpoint_bonus", dmgpointAdd, bonusMsg); // Add bonus soda to healer
	}

	string OnGameDamaged(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float accuracyRoll = 0.0f, CBaseEntity@ inflictor = null, string skill = "") { return Iceshield_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill); } // game_damaged

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "check_do_bonus") { OnCheckDoBonus(Param(params, 0)); return true; }
		if (name == "effect_die") { OnEffectDie(); return true; }
		if (name == "ext_refresh_ice_shield") { OnExtRefreshIceShield(Param(params, 0), EntityParam(params, 1)); return true; }
		if (name == "game_activate") { OnGameActivate(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5)); return true; }
		if (name == "game_damaged") { Return(OnGameDamaged(EntityParam(params, 0), Float(Param(params, 1)), Param(params, 2), Float(Param(params, 3)), EntityParam(params, 4), Param(params, 5))); return true; }
		if (name == "shield_me_baby") { OnShieldMeBaby(); return true; }
		return BaseEffectScript::DispatchEvent(name, params);
	}
}
