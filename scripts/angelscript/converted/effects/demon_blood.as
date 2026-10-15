#pragma context server

// Converted from effects/demon_blood.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/effects/base_effect.as"

[script "effects/demon_blood"]
class DemonBlood : BaseEffectScript
{
	// Variables (an unset .script variable reads as its own name)
	float FX_DURATION = 0.0f;
	string FX_INTENSITY = "FX_INTENSITY";
	float MAKE_NOISE = 0.0f;
	bool DEMON_BLOOD = false;

	// Variables declared by included files, with the value they start with in this script
	DemonBlood()
	{
		EFFECT_ID = "demon_blood";
		EFFECT_FLAGS = "nostack";
	}

	// game_damaged_other
	string DemonBlood_OnGameDamagedOther(CBaseEntity@ target = null, float damage = 0.0f, string damageType = "", string damageEvent = "")
	{
		string result = "";

		if (DEMON_BLOOD && IsAlive(target) && RelationshipOf(target, ENT_ME) == "enemy")
		{
			float demonBloodDamage = SkillOf(ENT_ME, "spellcasting") * (2.0f * -Float(FX_INTENSITY));

			if (RandomInt(1, 3) == 1)
			{
				DoDamageEx(@target, "direct", demonBloodDamage, 100, ENT_ME, ENT_ME, "none", "magic_effect");
				PlaySound(0, 10, "weather/Storm_exclamation.wav");
				PlayRandomSound(0, 10, "monsters/troll/trollpain.wav", "monsters/troll/trollattack.wav");
			}
		}
		return result;
	}

	// game_activate
	// <duration> <intensity>
	void OnGameActivate(string duration = "", string amount = "", string damage = "", string skill = "", string extraValue5 = "", string falloff = "")
	{
		BaseEffect_OnGameActivate(duration, amount, damage, skill, extraValue5, falloff); // effects/base_effect

		FX_DURATION = Float(duration);
		FX_INTENSITY = amount; // takes a negative number, is the amt of hp removed per tick

		CallEventDelayed(FX_DURATION, "end_demon_blood");

		Effect("screenfade", ENT_ME, 0.5f, 3, Vector3(255, 0, 0), 255, "fadeout");
		PlayerMessageGreen(ENT_ME, "The demonic soul fills your heart with rage!");
		PlaySound(0, 10, "monsters/troll/trollidle2.wav");

		MAKE_NOISE = 2.0f;
		DEMON_BLOOD = true;

		CallEventDelayed(1.0f, "demon_blood_loop");
	}

	// demon_blood_loop
	void OnDemonBloodLoop()
	{
		if (!DEMON_BLOOD)
			return;

		Effect("glow", ENT_ME, Vector3(255, 0, 0), 256, 1.9f, 1.9f);

		CallEventDelayed(2.0f, "demon_blood_loop");

		MAKE_NOISE += 1.0f;
		if (MAKE_NOISE > 5.0f)
		{
			PlayRandomSound(0, 10, "monsters/troll/trollidle2.wav", "monsters/troll/trollidle.wav");
			MAKE_NOISE = 0.0f;
		}

		GiveHealth(FX_INTENSITY);
		Effect("screenfade", ENT_ME, 0.5f, 1, Vector3(255, 0, 0), 150, "fadeout");
		Effect("screenshake", RelativePosition(Vector3(0, 0, 0)), 32, 10, 1, 32);
		if (MAKE_NOISE > 0.0f)
			PlaySound(0, 10, "player/heartbeat_noloop.wav");

		if (HealthOf(ENT_ME) <= 0.0f)
			LegacyCommand("kill", ENT_ME);
	}

	string OnGameDamagedOther(CBaseEntity@ target = null, float damage = 0.0f, string damageType = "", string damageEvent = "") { return DemonBlood_OnGameDamagedOther(target, damage, damageType, damageEvent); } // game_damaged_other

	// end_demon_blood
	void OnEndDemonBlood()
	{
		DEMON_BLOOD = false;
		PlayerMessageGreen(ENT_ME, "The demon blood fades.");

		RemoveScript();
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files
	void OnFxDuration() {} // FX_DURATION

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "demon_blood_loop") { OnDemonBloodLoop(); return true; }
		if (name == "end_demon_blood") { OnEndDemonBlood(); return true; }
		if (name == "game_activate") { OnGameActivate(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5)); return true; }
		if (name == "game_damaged_other") { Return(OnGameDamagedOther(EntityParam(params, 0), Float(Param(params, 1)), Param(params, 2), Param(params, 3))); return true; }
		return BaseEffectScript::DispatchEvent(name, params);
	}
}
