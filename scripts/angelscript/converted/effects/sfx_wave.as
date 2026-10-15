#pragma context server

// Converted from effects/sfx_wave.script by msc_transpiler.
// wave that moves forward and deals bursts of holy damage and healing.

#include "runtime/ScriptEntity.as"

[script "effects/sfx_wave"]
class SfxWave : ScriptEntity
{
	// Constants
	float FX_DURATION = 20.0f;

	// Variables (an unset .script variable reads as its own name)
	float CUR_JUMPS = 0.0f;
	float TIMES_HEALED = 0.0f;
	string FX_OWNER = "FX_OWNER";
	string FX_YAW = "FX_YAW";
	string FX_LEVEL = "FX_LEVEL";
	string FX_SKILL = "FX_SKILL";
	Vector3 FX_ORIGIN = Vector3();
	int FX_SPEED = 0;
	string FX_SCRIPT_ID = "FX_SCRIPT_ID";

	// unnamed block (first think)
	void SfxWave_FirstThink()
	{
		CUR_JUMPS = 0.0f;

		// setvar FX_SCRIPT_ID none
		TIMES_HEALED = 1.0f;
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		SetName("Holy Wave");

		SetModel("null.mdl");
		SetInvincible(true);
		SetHeight(0);
		SetWidth(0);
		SetSolid("none");

		CallEventDelayed(FX_DURATION, "end_me_please");
		PlaySound(2, 10, "magic/hburst_sco_lgrinholy01.wav");
	}

	// game_dynamically_created
	// <owner> <yaw> <level-casted-as> <skill-to-level>
	void OnGameDynamicallyCreated(string creatorValue1 = "", string creatorValue2 = "", string damage = "", string skill = "", string extraValue5 = "", string extraValue6 = "", float alwaysPush = 0.0f, string duration = "", string extraValue9 = "")
	{
		FX_OWNER = creatorValue1;
		FX_YAW = creatorValue2;
		FX_LEVEL = damage;
		FX_SKILL = skill;

		FX_ORIGIN = OriginOf(ENT_ME);
		FX_SPEED = 260;

		ClientEvent("new", "all", ScriptNameOf(ENT_ME), FX_ORIGIN, FX_YAW, FX_SPEED);
		FX_SCRIPT_ID = LastClientScriptId();

		CallEventDelayed(0.5f, "burst_fx");
	}

	// burst_fx
	void OnBurstFx()
	{
		Vector3 pos = FX_ORIGIN;
		pos += RelativePosition(Vector3(0, Float(FX_YAW), 0), Vector3(0, Divide(FX_SPEED, 2.0f), 0));

		string trace = LegacyFunction("get_traceline", FX_ORIGIN, pos, "worldonly");
		if (trace == Text(pos))
		{
			FX_ORIGIN = pos;

			// Deal damage
			pos.z += 32.0f;
			float dmg = Float(FX_LEVEL);
			dmg *= 2.0f;
			DoDamageEx(pos, 128, dmg, 0, FX_OWNER, ENT_ME, FX_SKILL, "holy_effect", "dmgevent:*holywave");

			// <target|(src_origin)> <range|aoe|(dest_origin)|direct> <damage> <cth|fall_off> <attacker> <inflciter> <skill|none> <dmg_type> [flag_string]
			ClientEvent("update", "all", FX_SCRIPT_ID, "sfx_wave_explody");
			CallEventDelayed(0.5f, "burst_fx");
		}
		else
		{
			OnEndMePlease();
		}
	}

	// holywave_dodamage
	// PARAM1=hit:0|1 PARAM2=ent_hit PARAM3=(start) PARAM4=(end) PARAM5=DmgType PARAM6=DmgAmt
	void OnHolywaveDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		bool enemy = false;

		string relationship = RelationshipOf(target, FX_OWNER);

		if (relationship == "enemy")
			enemy = true;
		if (relationship == "wary")
			enemy = true;
		if (IsPlayer(target) && !IsPvp())
			enemy = false;

		if (enemy)
		{
			if (hit)
			{
				float dot = Float(FX_LEVEL);
				dot *= 0.5f;
				ApplyEffect(target, "effects/dot_holy", 5.0f, FX_OWNER, dot, FX_SKILL);
			}
		}
		else
		{
			OnCeWaveDoHeal(target);
		}
	}

	// ce_wave_do_heal
	// <target> //Called when holy wave wants to heal a target
	void OnCeWaveDoHeal(CBaseEntity@ target = null)
	{
		if (HealthOf(target) == MaxHealthOf(target)) // Dont heal if they're already full hp
			return;

		bool isMe = false;
		bool addDmgPoints = false;

		float dot = Float(FX_LEVEL);
		dot *= 4.0f;
		dot = Divide(dot, TIMES_HEALED); // Diminishing healing
		TIMES_HEALED *= 2.0f; // Track times healed

		Effect("glow", @target, Vector3(0, 255, 0), 256, 0.5f, 0.5f);

		if (EntityOf(FX_OWNER) is target)
			isMe = true;

		if (HealthOf(target) < MaxHealthOf(target))
		{
			GiveHealth(@target, dot);

			if (isMe)
			{
				PlayerMessageGreen(FX_OWNER, "Your holy wave heals you for " + int(dot) + " hp");
			}
			else
			{
				PlayerMessageGreen(FX_OWNER, "You heal " + NameOf(target) + " for " + int(dot) + " hp");

				if (IsPlayer(target))
				{
					addDmgPoints = true;

					PlayerMessageGreen(target, NameOf(FX_OWNER) + " heals you for " + int(dot) + " hp");
				}
				else if (Truthy(ScriptVarOf(target, "NPC_CRITICAL")))
					addDmgPoints = true;
			}

			if (addDmgPoints)
				CallExternal(FX_OWNER, "add_dmg_points", dot);
		}
	}

	// end_me_please
	void OnEndMePlease()
	{
		ClientEvent("update", "all", FX_SCRIPT_ID, "end_fx");
		DeleteMe();
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files
	void OnFxDuration() {} // FX_DURATION

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		SfxWave_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "burst_fx") { OnBurstFx(); return true; }
		if (name == "ce_wave_do_heal") { OnCeWaveDoHeal(EntityParam(params, 0)); return true; }
		if (name == "end_me_please") { OnEndMePlease(); return true; }
		if (name == "game_dynamically_created") { OnGameDynamicallyCreated(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Float(Param(params, 6)), Param(params, 7), Param(params, 8)); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "holywave_dodamage") { OnHolywaveDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5)); return true; }
		return false;
	}
}
