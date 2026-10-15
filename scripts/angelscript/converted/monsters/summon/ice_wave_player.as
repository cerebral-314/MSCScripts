#pragma context server

// Converted from monsters/summon/ice_wave_player.script by msc_transpiler.
// Ice Wave for North Maul by Thothie
// - Probably use this for stun wave later

#include "runtime/ScriptEntity.as"
#include "converted/monsters/summon/base_aoe.as"
#include "converted/monsters/base_noclip.as"

[script "monsters/summon/ice_wave_player"]
class IceWavePlayer : BaseAoeScript, BaseNoclip, BasePropelled
{
	// Constants
	float FWD_SPEED = 20.0f;

	// Variables (an unset .script variable reads as its own name)
	string PLAYING_DEAD = "PLAYING_DEAD";
	float FREEZE_DURATION = 0.0f;
	string MY_DURATION = "MY_DURATION";
	Vector3 NPC_NOCLIP_DEST = Vector3();
	bool IS_FADING = false;
	float FADE_AMT = 0.0f;

	// Variables declared by included files, with the value they start with in this script
	IceWavePlayer()
	{
		AOE_FREQ = 0.1f;
		AOE_RADIUS = "128";
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseAoe_OnGameSpawn(playerRace, playerGender); // monsters/summon/base_aoe
		BaseNoclip_OnGameSpawn(playerRace, playerGender); // monsters/base_noclip

		SetName("Ice Wave");
		SetHealth(1);
		SetInvincible(true);
		SetSolid("none");
		PLAYING_DEAD = "1";
		SetNoPush(true);
		SetModel("weapons/projectiles.mdl");
		SetModelBody(0, 52);
		LegacyCommand("drop_to_floor", ENT_ME);
		SetProp(ENT_ME, "rendermode", 5);
		SetProp(ENT_ME, "renderamt", 0);
		SetIdleAnim("idle_standard"); // anims need to be set
		SetMoveAnim("idle_standard"); // anims need to be set
	}

	// aoe_scan_loop
	void OnAoeScanLoop()
	{
		BaseAoe_OnAoeScanLoop(); // monsters/summon/base_aoe

		if (!IS_FADING)
			return;
		FADE_AMT -= 10.0f;
		if (!(FADE_AMT >= 0.0f))
			return;
		SetProp(ENT_ME, "rendermode", 5);
		SetProp(ENT_ME, "renderamt", FADE_AMT);
	}

	// game_dynamically_created
	// <owner> <freeze_duration> <max_live_time>
	void OnGameDynamicallyCreated(string creatorValue1 = "", string creatorValue2 = "", string damage = "", string skill = "", string extraValue5 = "", string extraValue6 = "", float alwaysPush = 0.0f, string duration = "", string extraValue9 = "")
	{
		MY_OWNER = creatorValue1;
		FREEZE_DURATION = Float(creatorValue2);
		MY_DURATION = damage;

		CallEventOrDelay(MY_DURATION, "aoe_end");
		float fadeStart = Float(MY_DURATION);
		fadeStart -= 2.0f;
		CallEventDelayed(fadeStart, "begin_fade");

		CallEventDelayed(0.1f, "set_angles_and_dest");
	}

	// apply_aoe_effect
	void OnApplyAoeEffect(CBaseEntity@ target = null)
	{
		DebugPrint("freezing " + NameOf(target));
		ApplyEffect(target, "effects/dot_cold_freeze", FREEZE_DURATION, MY_OWNER);
	}

	// set_angles_and_dest
	void OnSetAnglesAndDest()
	{
		Vector3 ownerAng = AnglesOf(MY_OWNER);
		NPC_NOCLIP_DEST = RelativePosition(Vector3(0, ownerAng.y, 0), Vector3(0, 10000, 0));
		SetAngle("face", Vector3(0, ownerAng.y, 0));
		SetProp(ENT_ME, "rendermode", 5);
		SetProp(ENT_ME, "renderamt", 255);
	}

	// begin_fade
	void OnBeginFade()
	{
		IS_FADING = true;
		FADE_AMT = 255.0f;
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files
	void OnFadeStart() {} // FADE_START
	void OnMyDuration() {} // MY_DURATION

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("weapons/projectiles.mdl");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		BaseNoclip_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "aoe_scan_loop") { OnAoeScanLoop(); return true; }
		if (name == "apply_aoe_effect") { OnApplyAoeEffect(EntityParam(params, 0)); return true; }
		if (name == "begin_fade") { OnBeginFade(); return true; }
		if (name == "game_dynamically_created") { OnGameDynamicallyCreated(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Float(Param(params, 6)), Param(params, 7), Param(params, 8)); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "set_angles_and_dest") { OnSetAnglesAndDest(); return true; }
		return BaseNoclip_DispatchEvent(name, params)
			|| BasePropelled_DispatchEvent(name, params)
			|| BaseAoeScript::DispatchEvent(name, params);
	}
}
