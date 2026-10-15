#pragma context server

// Converted from effects/lightning_disc.script by msc_transpiler.

#include "runtime/ScriptEntity.as"

[script "effects/lightning_disc"]
class LightningDisc : ScriptEntity
{
	// Variables (an unset .script variable reads as its own name)
	string MY_LIGHT_SCRIPT = "MY_LIGHT_SCRIPT";
	string FX_OWNER = "FX_OWNER";
	string FX_VELOCITY = "FX_VELOCITY";
	string FX_DMG = "FX_DMG";
	string FX_SKILL = "FX_SKILL";
	string FX_WOBBLE_SEQ = "FX_WOBBLE_SEQ";
	float SEQ_IDX = 0.0f;
	float FX_WOBBLE_MULT = 0.0f;

	// unnamed block (timer)
	// scan damage
	void LightningDisc_Timer()
	{
		CallEventDelayed(0.2f, "LightningDisc_Timer");

		DoDamageEx(OriginOf(ENT_ME), 120, FX_DMG, 0, FX_OWNER, ENT_ME, FX_SKILL, "lightning_effect", "dmgevent:*disc");
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		SetName("laserdisc");
		SetModel("weapons/magic/seals.mdl");
		SetModelBody(0, 31);

		SetProp(ENT_ME, "movetype", 11);
		SetProp(ENT_ME, "friction", 0.1f);
		SetProp(ENT_ME, "scale", 10);
		SetProp(ENT_ME, "solid", 0);
		SetProp(ENT_ME, "rendermode", 5);
		SetProp(ENT_ME, "renderamt", 255);

		SetWidth(5);
		SetHeight(1);

		// setbbox none
		SetInvincible(true);
		SetRace("beloved");

		CallEventDelayed(10.0f, "fx_die");

		ClientEvent("persist", "all", "monsters/lighted_cl", IndexOf(ENT_ME), Vector3(255, 255, 40), 96);
		MY_LIGHT_SCRIPT = LastClientScriptId();

		SetMonsterClip(false);
	}

	// game_dynamically_created
	// <owner> <vec> <damage> <skill to level>
	void OnGameDynamicallyCreated(string creatorValue1 = "", string creatorValue2 = "", string damage = "", string skill = "", string extraValue5 = "", string extraValue6 = "", float alwaysPush = 0.0f, string duration = "", string extraValue9 = "")
	{
		FX_OWNER = creatorValue1;
		FX_VELOCITY = creatorValue2;
		FX_DMG = damage;
		FX_SKILL = skill;

		FX_WOBBLE_SEQ = "0;1;2;3;2;1;0;-1;-2;-3;-2;-1";
		SEQ_IDX = 0.0f;

		FX_WOBBLE_MULT = 0.07f;
		CallEventDelayed(0.05f, "wobble");

		SetVelocity(ENT_ME, Vec(FX_VELOCITY));
		ServerPlaySound(3, 4, "ambient/alien_frantic.wav");
	}

	// disc_dodamage
	// PARAM1=hit:0|1 PARAM2=ent_hit PARAM3=(start) PARAM4=(end) PARAM5=DmgType PARAM6=DmgAmt
	void OnDiscDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		if (!hit)
			return;
		ApplyEffect(target, "effects/dot_lightning", 5, FX_OWNER, SkillOf(FX_OWNER, "spellcasting.lightning"), "spellcasting.lightning");
	}

	// wobble
	// Should wobble faster the longer the duration
	void OnWobble()
	{
		string idx = GetToken(FX_WOBBLE_SEQ, int(SEQ_IDX));
		SEQ_IDX += 1.0f;
		if (SEQ_IDX >= GetTokenCount(FX_WOBBLE_SEQ))
			SEQ_IDX = 0.0f;

		Vector3 ang = AnglesOf(ENT_ME) + Vector3(Float(idx) * FX_WOBBLE_MULT, 7, 0);
		SetAngle("face", ang);

		FX_WOBBLE_MULT += 0.03f;

		CallEventDelayed(0.05f, "wobble");
	}

	// fx_die
	// explode fx when die
	void OnFxDie()
	{
		ClientEvent("new", "all", "effects/sfx_prism_blast", OriginOf(ENT_ME), 100, "lightning");
		ServerPlaySound(3, 10, "magic/bolt_end.wav");
		SetModel("none");
		DeleteMe();

		ClientEvent("remove", "all", MY_LIGHT_SCRIPT);
		ClientEvent("update", "all", MY_LIGHT_SCRIPT, "remove_me");
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("weapons/magic/seals.mdl");
		Precache("ambient/alien_frantic.wav");
		Precache("magic/bolt_end.wav");
		CallEventDelayed(0.2f, "LightningDisc_Timer");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "disc_dodamage") { OnDiscDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5)); return true; }
		if (name == "fx_die") { OnFxDie(); return true; }
		if (name == "game_dynamically_created") { OnGameDynamicallyCreated(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Float(Param(params, 6)), Param(params, 7), Param(params, 8)); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "wobble") { OnWobble(); return true; }
		if (name == "LightningDisc_Timer") { LightningDisc_Timer(); return true; }
		return false;
	}
}
