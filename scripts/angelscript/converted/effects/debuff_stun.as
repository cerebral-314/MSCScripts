#pragma context server

// Converted from effects/debuff_stun.script by msc_transpiler.
// Stun - Slows afflicted npcs and stops players from attacking
// Any npc
// Param1 - Duration
// Param2 - attacker
// . effectme effects/debuff_stun 10 GAME_MASTER

#include "runtime/ScriptEntity.as"
#include "converted/effects/base_debuff_diminishing.as"

[script "effects/debuff_stun"]
class DebuffStun : BaseDebuffDiminishingScript
{
	// Constants
	string SOUND_RESIST = "body/armour3.wav";

	// Variables (an unset .script variable reads as its own name)
	string DOT_ATTACKER = "DOT_ATTACKER";
	float STUN_RESISTANCE = 0.0f;
	string CL_FX = "CL_FX";
	string BE_RESIST_STRING = "BE_RESIST_STRING";

	// Variables declared by included files, with the value they start with in this script
	DebuffStun()
	{
		EFFECT_ID = "debuff_stun";
		EFFECT_FLAGS = "nostack";
	}

	// game_precache
	void DebuffStun_OnGamePrecache()
	{
		PrecacheFile("effects/sfx_stunring");
	}

	// game_activate
	// <duration> <attacker> //This is above the include on purpose
	void DebuffStun_OnGameActivate(string duration = "", string amount = "", string damage = "", string skill = "", string extraValue5 = "", string falloff = "")
	{
		DOT_ATTACKER = amount;

		STUN_RESISTANCE = DamageTakenOf(ENT_ME, "stun");

		OnCheckImmuneStun();
		if (DEBUFF_SCRIPTFLAG)
			return;
		OnCheckBlockStun();
		if (DEBUFF_SCRIPTFLAG)
			return;
		OnCheckResistStun();
	}

	// game_precache
	void OnGamePrecache()
	{
		DebuffStun_OnGamePrecache();
		BaseEffect_OnGamePrecache(); // effects/base_effect
	}

	// game_activate
	void OnGameActivate(string duration = "", string amount = "", string damage = "", string skill = "", string extraValue5 = "", string falloff = "")
	{
		DebuffStun_OnGameActivate(duration, amount, damage, skill, extraValue5, falloff);
		BaseEffect_OnGameActivate(duration, amount, damage, skill, extraValue5, falloff); // effects/base_effect
		BaseDebuff_OnGameActivate(duration, amount, damage, skill, extraValue5, falloff); // effects/base_debuff
	}

	// effect_die
	void OnEffectDie()
	{
		BaseEffect_OnEffectDie(); // effects/base_effect

		if (Truthy(CL_FX))
			ClientEvent("update", "all", CL_FX, "end_fx");
	}

	// debuff_start
	void OnDebuffStart()
	{
		BaseDebuff_OnDebuffStart(); // effects/base_debuff

		SetVar(Eval("game.effect.movespeed"), 45);
		SetVar(Eval("game.effect.anim.framerate"), 0.4f);
		SetVar(Eval("game.effect.canjump"), 0);
		SetVar(Eval("game.effect.canattack"), 0);

		if (IsPlayer(ENT_ME))
		{
			// effect screenshake_one ent_me 16 20 EFFECT_DURATION //It appears that this doesn't work, and effect_push only does screen shake anyways. -greatguys1 SEP2021
			AddStatusIcon(ENT_ME, "hud/status/alpha_stun", "stun", EFFECT_DURATION);
		}

		ClientEvent("new", "all", "effects/sfx_stunring", IndexOf(ENT_ME), EFFECT_DURATION, HeightOf(ENT_ME));
		CL_FX = LastClientScriptId();
	}

	// check_immune_stun
	void OnCheckImmuneStun()
	{
		if (STUN_RESISTANCE <= 0.0f) // Immunity
		{
			PlayerMessageGreen(ENT_ME, "You are immune to stun effects."); // those immune to push are immune to stun
			PlayerMessageDark(DOT_ATTACKER, NameOf(ENT_ME) + " is immune to stun effects.");

			DEBUFF_SCRIPTFLAG = true;
			return;
		}

		if (IsNoPush(ENT_ME)) // Immunity
		{
			PlayerMessageGreen(ENT_ME, "You are immune to stun effects."); // those immune to push are immune to stun
			PlayerMessageDark(DOT_ATTACKER, NameOf(ENT_ME) + " is immune to stun effects.");

			DEBUFF_SCRIPTFLAG = true;
			return;
		}
	}

	// check_block_stun
	void OnCheckBlockStun()
	{
		bool blockedAttack = false;

		if (IsPlayer(ENT_ME)) // Blocked with item
		{
			string curWeapon = ScriptVarOf(ENT_ME, "PLR_LEFT_HAND"); // Gets item id in hand
			if (Float(ScriptVarOf(curWeapon, "POLE_IN_BLOCK")) == 1.0f)
				blockedAttack = true;
			if (Float(ScriptVarOf(curWeapon, "PARRY_ON")) == 1.0f)
				blockedAttack = true;

			if (blockedAttack)
			{
				PlayerMessage(ENT_ME, NameOf(curWeapon) + " blocked stun impact.");

				DEBUFF_SCRIPTFLAG = true;
				return;
			}

			curWeapon = ScriptVarOf(ENT_ME, "PLR_RIGHT_HAND");
			if (Float(ScriptVarOf(curWeapon, "POLE_IN_BLOCK")) == 1.0f)
				blockedAttack = true;
			if (Float(ScriptVarOf(curWeapon, "PARRY_ON")) == 1.0f)
				blockedAttack = true;

			if (blockedAttack)
			{
				PlayerMessage(ENT_ME, NameOf(curWeapon) + " blocked the stun impact.");

				DEBUFF_SCRIPTFLAG = true;
				return;
			}
		}
	}

	// check_resist_stun
	void OnCheckResistStun()
	{
		int stunRoll = RandomInt(1, 100);
		float stunResistPercent = STUN_RESISTANCE * 100.0f;
		stunResistPercent = int(100.0f - stunResistPercent);

		if (stunRoll <= stunResistPercent) // Resisted
		{
			PlaySound(0, 10, SOUND_RESIST);

			BE_RESIST_STRING = "( " + stunRoll + " / " + Text(stunResistPercent) + " )";

			PlayerMessageGreen(ENT_ME, "You resist being stunned! " + BE_RESIST_STRING);
			PlayerMessageDark(DOT_ATTACKER, NameOf(ENT_ME) + " resists the stun effect. " + BE_RESIST_STRING);

			DEBUFF_SCRIPTFLAG = true;
			return;
		}
		else
		{
			PlayerMessage(ENT_ME, "You have been stunned! ( " + stunRoll + " / " + Text(stunResistPercent) + " )");
		}
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "check_block_stun") { OnCheckBlockStun(); return true; }
		if (name == "check_immune_stun") { OnCheckImmuneStun(); return true; }
		if (name == "check_resist_stun") { OnCheckResistStun(); return true; }
		if (name == "debuff_start") { OnDebuffStart(); return true; }
		if (name == "effect_die") { OnEffectDie(); return true; }
		if (name == "game_activate") { OnGameActivate(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5)); return true; }
		if (name == "game_precache") { OnGamePrecache(); return true; }
		return BaseDebuffDiminishingScript::DispatchEvent(name, params);
	}
}
