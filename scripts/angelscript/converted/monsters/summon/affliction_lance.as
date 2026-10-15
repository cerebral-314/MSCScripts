#pragma context server

// Converted from monsters/summon/affliction_lance.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/summon/base_aoe2.as"

[script "monsters/summon/affliction_lance"]
class AfflictionLance : BaseAoe2Script
{
	// Constants
	bool AOE_AFFECTS_WARY = true;

	// Variables (an unset .script variable reads as its own name)
	string MY_OWNER = "MY_OWNER";
	float CUR_PITCH = 0.0f;
	float DOT_POISON = 0.0f;
	string MY_FX = "MY_FX";
	float MY_END_TIME = 0.0f;

	// Variables declared by included files, with the value they start with in this script
	AfflictionLance()
	{
		AOE_RADIUS = "255";
		AOE_SCAN_FREQ = 1.0f;
		AOE_VADJ = 32;
	}

	// game_spawn
	void AfflictionLance_OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		SetNoPush(true);
		SetWidth(2);
		SetHeight(96);
		SetSolid("none");
		PLAYING_DEAD = "1";
		LegacyCommand("blind", 1);
		SetFly(true);
		SetGravity(0);
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		AfflictionLance_OnGameSpawn(playerRace, playerGender);
		BaseAoe2_OnGameSpawn(playerRace, playerGender); // monsters/summon/base_aoe2
	}

	// game_dynamically_created
	// <owner> <origin> <pitch> <duration>
	void OnGameDynamicallyCreated(string creatorValue1 = "", string creatorValue2 = "", string damage = "", string skill = "", string extraValue5 = "", string extraValue6 = "", float alwaysPush = 0.0f, string duration = "", string extraValue9 = "")
	{
		BaseAoe2_OnGameDynamicallyCreated(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/summon/base_aoe2

		SetModel("weapons/projectiles.mdl");
		SetModelBody(0, 70);

		MY_OWNER = creatorValue1;
		Vector3 spawnOrg = Vec(creatorValue2);
		AOE_DURATION = skill;
		spawnOrg.z += 32.0f;
		SetOrigin(ENT_ME, spawnOrg);
		SetIdleAnim("axis_spin");
		PlayAnim("once", "axis_spin");

		ScriptFlags(MY_OWNER, "add", "pole_a", "Affliction Lance", self, AOE_DURATION);

		CUR_PITCH = Vec(damage).x;
		// subtract CUR_PITCH 360
		SetAngle("face", damage);
		if (CUR_PITCH != -90.0f)
			OnFixPitchLoop();

		AOE_OWNER = creatorValue1;

		DOT_POISON = SkillOf(MY_OWNER, "spellcasting.affliction");

		ServerPlaySound(1, 10, "ambience/steamjet1.wav");

		ClientEvent("new", "all", "monsters/summon/affliction_lance_cl", IndexOf(ENT_ME), 19.0f);
		MY_FX = LastClientScriptId();
		MY_END_TIME = GameTime() + Float(AOE_DURATION);
	}

	// fix_pitch_loop
	void OnFixPitchLoop()
	{
		if (CUR_PITCH > 270.0f)
			CUR_PITCH -= 4.0f;
		if (CUR_PITCH < 270.0f)
			CUR_PITCH += 4.0f;

		if (CUR_PITCH < 290.0f && CUR_PITCH > 250.0f)
			CUR_PITCH = 270.0f;
		float myYaw = AnglesOf(ENT_ME).y;
		float myRoll = AnglesOf(ENT_ME).z;
		SetAngle("face", Vector3(CUR_PITCH, myYaw, myRoll));
		DebugPrint("fix_pitch_loop " + Text(CUR_PITCH));
		if (CUR_PITCH == 270.0f)
			return;
		CallEventDelayed(0.1f, "fix_pitch_loop");
	}

	// aoe_affect_target
	void OnAoeAffectTarget(string target = "")
	{
		ApplyEffect(target, "effects/dot_poison", 5.0f, MY_OWNER, DOT_POISON, "polearms");
	}

	// aoe_end
	void OnAoeEnd()
	{
		if (GameTime() >= MY_END_TIME)
		{
			AOE_ACTIVE = false;
			ServerPlaySound(1, 0, "ambience/steamjet1.wav");
			DeleteEntity(ENT_ME, "fade");
		}
		else
		{
			CallEventDelayed(1.0f, "aoe_end");
		}
	}

	// transfer_location
	// <newLocationVector>
	void OnTransferLocation(Vector3 newLocation = Vector3())
	{
		Vector3 newPos = newLocation;

		MY_END_TIME = GameTime() + Float(AOE_DURATION); // Resets the duration
		ClientEvent("update", "all", MY_FX, "keep_on"); // Resets duration of client effect

		newPos.z += 32.0f;
		SetOrigin(ENT_ME, newPos);

		ScriptFlags(MY_OWNER, "edit", "pole_a", "Affliction Lance", self, AOE_DURATION);
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("weapons/projectiles.mdl");
		Precache("ambience/steamjet1.wav");
		CallEventDelayed(AOE_SCAN_FREQ, "aoe_scan_loop");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "aoe_affect_target") { OnAoeAffectTarget(Param(params, 0)); return true; }
		if (name == "aoe_end") { OnAoeEnd(); return true; }
		if (name == "fix_pitch_loop") { OnFixPitchLoop(); return true; }
		if (name == "game_dynamically_created") { OnGameDynamicallyCreated(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Float(Param(params, 6)), Param(params, 7), Param(params, 8)); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "transfer_location") { OnTransferLocation(Vec(Param(params, 0))); return true; }
		return BaseAoe2Script::DispatchEvent(name, params);
	}
}
