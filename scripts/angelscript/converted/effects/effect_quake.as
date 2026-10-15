#pragma context server

// Converted from effects/effect_quake.script by msc_transpiler.
// . effectme effects/effect_quake 10 GAME_MASTER 512 20 GAME_MASTER 0

#include "runtime/ScriptEntity.as"
#include "converted/effects/base_effect.as"

[script "effects/effect_quake"]
class EffectQuake : BaseEffectScript
{
	// Variables (an unset .script variable reads as its own name)
	string QUAKE_DMGSRC = "QUAKE_DMGSRC";
	string QUAKE_AOE = "QUAKE_AOE";
	string QUAKE_DMG = "QUAKE_DMG";
	string QUAKE_ORIGIN = "QUAKE_ORIGIN";
	string QUAKE_FALLOFF = "QUAKE_FALLOFF";
	bool QUAKE_MOBILE = false;
	string QUAKE_SKILL = "QUAKE_SKILL";
	bool QUAKE_ACTIVE = false;

	// Variables declared by included files, with the value they start with in this script
	EffectQuake()
	{
		EFFECT_ID = "DOT_quake";
		EFFECT_FLAGS = "nostack";
	}

	// game_activate
	// <duration> <afflicter> <aoe> <dmg> <origin|src> <falloff:0|1>
	void OnGameActivate(string duration = "", string amount = "", string damage = "", string skill = "", string extraValue5 = "", string falloff = "")
	{
		BaseEffect_OnGameActivate(duration, amount, damage, skill, extraValue5, falloff); // effects/base_effect

		QUAKE_DMGSRC = amount;
		QUAKE_AOE = damage;
		QUAKE_DMG = skill;
		QUAKE_ORIGIN = extraValue5;
		QUAKE_FALLOFF = falloff;

		if (IsAlive(QUAKE_ORIGIN))
			QUAKE_MOBILE = true;
		QUAKE_SKILL = "none";
		if (IsPlayer(QUAKE_ORIGIN))
			QUAKE_SKILL = "spellcasting.earth";

		SetVar(Eval("game.effect.canjump"), 0);
		// setting now, in case we can't adjust dynamically based on distance from source
		SetVar(Eval("game.effect.movespeed"), 0.1f);
		SetVar(Eval("game.effect.anim.framerate"), 0.1f);

		// be nice to rig up a function to screenshake individual players based on distance from src, or do it client side
		float shakeAoe = Float(QUAKE_AOE);
		shakeAoe *= 1.5f;

		if (IsPlayer(ENT_ME))
			PlayerMessage("You", "are caught in a quake!");

		QUAKE_ACTIVE = true;
		OnQuakeLoop();
	}

	// quake_loop
	void OnQuakeLoop()
	{
		string qpos;
		float distRatio = 0.0f;
		if (!QUAKE_ACTIVE)
			return;
		CallEventDelayed(0.5f, "quake_loop");

		if (QUAKE_MOBILE)
			qpos = Text(OriginOf(QUAKE_ORIGIN));
		else
			qpos = QUAKE_ORIGIN;

		Vector3 myPos = OriginOf(ENT_ME);
		float quakeDist = Distance(Vec(qpos), myPos);
		if (Truthy(QUAKE_FALLOFF))
			distRatio = 1.0f - Divide(quakeDist, Float(QUAKE_AOE));

		// dbg quake distratio L_DIST_RATIO
		if (quakeDist <= Float(QUAKE_AOE))
		{
			if (Float(QUAKE_DMG) > 0.0f)
			{
				float dmg = Float(QUAKE_DMG);
				if (Truthy(QUAKE_FALLOFF))
				{
					dmg = Ratio(distRatio, 1, Float(QUAKE_DMG)) * 2.0f;

					if (IsPlayer(ENT_ME) && IsNoPush(ENT_ME))
						dmg *= 5.0f;
				}

				DoDamageEx(ENT_ME, "direct", dmg, "100%", QUAKE_DMGSRC, QUAKE_DMGSRC, QUAKE_SKILL, "blunt_effect");
			}

			float slow = 0.3f;
			if (Truthy(QUAKE_FALLOFF))
				slow = Ratio(distRatio, 0.9f, 0.1f);

			// dbg quake_loop rat L_DIST_RATIO slw L_SLOW dmg L_DMG
			SetVar(Eval("game.effect.movespeed"), 100.0f * slow);
			SetVar(Eval("game.effect.anim.framerate"), slow);
		}
		else
		{
			SetVar(Eval("game.effect.movespeed"), 100);
			SetVar(Eval("game.effect.anim.framerate"), 1.0f);
		}
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "game_activate") { OnGameActivate(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5)); return true; }
		if (name == "quake_loop") { OnQuakeLoop(); return true; }
		return BaseEffectScript::DispatchEvent(name, params);
	}
}
