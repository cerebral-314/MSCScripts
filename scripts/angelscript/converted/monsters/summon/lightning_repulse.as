#pragma context server

// Converted from monsters/summon/lightning_repulse.script by msc_transpiler.

#include "runtime/ScriptEntity.as"

[script "monsters/summon/lightning_repulse"]
class LightningRepulse : ScriptEntity
{
	// Constants
	string SOUND_SHOCK1 = "debris/zap8.wav";
	string SOUND_SHOCK2 = "debris/zap3.wav";
	string SOUND_SHOCK3 = "debris/zap4.wav";

	// Variables (an unset .script variable reads as its own name)
	string MY_OWNER = "MY_OWNER";
	string MY_RANGE = "MY_RANGE";
	string MY_DURATION = "MY_DURATION";
	float MY_BASE_DMG = 0.0f;
	float OWNER_DBLHP = 0.0f;
	string OWNER_ISPLAYER = "OWNER_ISPLAYER";
	int GAME_PVP = 0;
	bool IS_ACTIVE = false;
	string ACTIVE_SKILL = "ACTIVE_SKILL";
	string PLAYING_DEAD = "PLAYING_DEAD";
	bool DID_MESSAGE = false;

	// unnamed block (timer)
	void LightningRepulse_Timer()
	{
		CallEventDelayed(0.1f, "LightningRepulse_Timer");

		if (!IS_ACTIVE)
			return;
		SetOrigin(ENT_ME, OriginOf(MY_OWNER));

		DoDamage(Text(RelativePosition(Vector3(0, 0, 0))), MY_RANGE, 0, "100%", 0, "reflective", "lightning");
	}

	// game_dodamage
	string LightningRepulse_OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		bool exitSub = false;
		string result = "";

		if (!hit)
			return result;
		if (Truthy(OWNER_ISPLAYER) && GAME_PVP == 0 && IsPlayer(target))
			exitSub = true;
		if (exitSub)
			return result;

		if (RelationshipOf(target, MY_OWNER) != "enemy")
			return result;

		Vector3 beamStart = MyOrigin();

		// effect beam point lgtning.spr 30 BEAM_START BEAM_END (255,255,255) 255 10 0.2
		Effect("beam", "end", "lgtning.spr", 30, beamStart, @target, 0, Vector3(200, 255, 50), 200, 30, 0.1f);

		float targHp = MaxHealthOf(target);
		if (targHp > 1500.0f && OWNER_DBLHP < targHp)
		{
			exitSub = true;
			if (Truthy(OWNER_ISPLAYER) && !DID_MESSAGE)
			{
				DID_MESSAGE = true;
				PlayerMessage(MY_OWNER, NameOf(target) + " is too strong to be affected.");
			}
		}
		if (exitSub)
			return result;

		Vector3 targVel = AnglesOf(MY_OWNER);
		SetAngle("face", @target);
		AddVelocity(target, RelativeVelocity(Vector3(0, 500, 10)));
		PlayRandomSound(0, 10, SOUND_SHOCK1, SOUND_SHOCK2, SOUND_SHOCK3);
		if (!(MY_BASE_DMG > 0.0f))
			return result;
		DoDamageEx(@target, "direct", MY_BASE_DMG, "100%", MY_OWNER, MY_OWNER, ACTIVE_SKILL, "lightning");
		return result;
	}

	// game_dynamically_created
	void OnGameDynamicallyCreated(string creatorValue1 = "", string creatorValue2 = "", string damage = "", string skill = "", string extraValue5 = "", string extraValue6 = "", float alwaysPush = 0.0f, string duration = "", string extraValue9 = "")
	{
		MY_OWNER = creatorValue1;
		MY_RANGE = creatorValue2;
		SetRace(RaceOf(MY_OWNER));
		MY_DURATION = damage;
		MY_BASE_DMG = Float(skill);
		OWNER_DBLHP = MaxHealthOf(MY_OWNER) * 2.0f;
		OWNER_ISPLAYER = Text(IsPlayer(MY_OWNER));
		GAME_PVP = (IsPvp() ? 1 : 0);
		IS_ACTIVE = true;
		CallEventOrDelay(MY_DURATION, "end_summon");
		ACTIVE_SKILL = extraValue5;
		if (ACTIVE_SKILL.isEmpty())
			ACTIVE_SKILL = "spellcasting.lightning";
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		SetName("Static Shock");
		SetInvincible(true);
		SetWidth(32);
		SetHeight(32);
		SetSolid("none");
		PLAYING_DEAD = "1";
	}

	string OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "") { return LightningRepulse_OnGameDodamage(hit, target, start, end, damageType, damageText); } // game_dodamage

	// end_summon
	void OnEndSummon()
	{
		IS_ACTIVE = false;
		CallEventDelayed(0.1f, "remove_me");
	}

	// remove_me
	void OnRemoveMe(string caller = "")
	{
		DeleteEntity(ENT_ME);
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files
	void OnMyDuration() {} // MY_DURATION

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		CallEventDelayed(0.1f, "LightningRepulse_Timer");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "end_summon") { OnEndSummon(); return true; }
		if (name == "game_dodamage") { Return(OnGameDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5))); return true; }
		if (name == "game_dynamically_created") { OnGameDynamicallyCreated(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Float(Param(params, 6)), Param(params, 7), Param(params, 8)); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "remove_me") { OnRemoveMe(Param(params, 0)); return true; }
		if (name == "LightningRepulse_Timer") { LightningRepulse_Timer(); return true; }
		return false;
	}
}
