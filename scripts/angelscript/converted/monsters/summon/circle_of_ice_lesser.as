#pragma context server

// Converted from monsters/summon/circle_of_ice_lesser.script by msc_transpiler.
// Circle of Ice, Lesser - by Thothie
// - same as circle of ice but smaller radius, less sprites, and frost_dmg instead of freeze_solid

#include "runtime/ScriptEntity.as"
#include "converted/monsters/summon/base_aoe.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class CircleOfIceLesser
{
	// Constants
	string SEAL_MODEL = "weapons/magic/seals.mdl";
	string SEAL_OFS = "7";
	string SOUND_MANIFEST = "magic/spawn.wav";
	string SOUND_PULSE = "magic/frost_forward.wav";
	string SOUND_FADE = "magic/frost_reverse.wav";
	float PULSE_PLAYTIME = 1.0f;
	string FX_SPRITE = "teleporter_blue_sprites.mdl";
	int CIRCLE_RADIUS = 110;
	string APPLY_EFFECT = "effects/dot_cold";
	float AOE_FREQ = 1.0f;
	string AOE_RADIUS = "110";

	// Variables (an unset .script variable reads as its own name)
	string MY_OWNER = "MY_OWNER";
	string MY_DURATION = "MY_DURATION";
	string FROST_DURATION = "FROST_DURATION";
	float MY_BASE_DAMAGE = 0.0f;
	string ACTIVE_SKILL = "ACTIVE_SKILL";
	string MY_OWNER_RACE = "MY_OWNER_RACE";
	string OWNER_ISPLAYER = "OWNER_ISPLAYER";
	bool CIRCLE_ON = false;
	string THIS_SCRIPT_CLIENT_ID = "THIS_SCRIPT_CLIENT_ID";
	bool CIRCLE_UP = false;
	bool DID_WINDUP = false;

	// game_dynamically_created
	// PARAM1 = owner PARAM2 = CircleDuration PARAM3 = Frost Duration PARAM4 = Damage
	void CircleOfIceLesser_OnGameDynamicallyCreated(string creatorValue1 = "", string creatorValue2 = "", string damage = "", string skill = "", string extraValue5 = "", string extraValue6 = "", float alwaysPush = 0.0f, string duration = "", string extraValue9 = "")
	{
		MY_OWNER = creatorValue1;
		MY_DURATION = creatorValue2;
		FROST_DURATION = damage;
		MY_BASE_DAMAGE = Float(skill);
		ACTIVE_SKILL = extraValue5;
		if (ACTIVE_SKILL.isEmpty())
			ACTIVE_SKILL = "spellcasting.ice";

		MY_OWNER_RACE = RaceOf(creatorValue1);
		OWNER_ISPLAYER = Text(IsPlayer(creatorValue1));

		CallEventOrDelay(MY_DURATION, "circle_end");
	}

	// game_spawn
	void CircleOfIceLesser_OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		SetName("Lesser Circle of Ice");
		SetHealth(10000);
		SetFieldOfView(359);
		SetInvincible(true);
		SetRace("beloved");
		SetHeight(2);
		SetWidth(2);
		SetFly(true);
		LegacyCommand("float", 1);
		SetDamageTaken("all", 0);
		SetGravity(0);
		SetBlood("none");
		SetModel("none");
		SetSolid("none");
		SetBoundingBox("none");

		CIRCLE_ON = true;

		CallEventDelayed(0.1f, "make_seal");

		// callevent 1.0 circle_go
		CallEventDelayed(0.2f, "circle_hum");
	}

	// make_seal
	void CircleOfIceLesser_OnMakeSeal()
	{
		Vector3 sealPos = OriginOf(ENT_ME);
		float groundZ = GroundHeight(sealPos);
		// subtract GROUND_Z 8
		sealPos.z = groundZ;
		DebugPrint("make_seal " + Text(sealPos));
		CreateNpc("monsters/summon/seal_maker", sealPos, SEAL_MODEL, MY_DURATION, SEAL_OFS);
	}

	// circle_hum
	void CircleOfIceLesser_OnCircleHum()
	{
		// drop_to_floor ent_me
		if (!CIRCLE_UP)
		{
			// clientevent persist all $currentscript effect.duration $get(ent_me,index) PARAM2 GLOW_COLOR
			float clientDuration = Float(MY_DURATION);
			clientDuration -= 0.2f; // effort to prevent client side fx from sticking
			if (!NO_RAIN_FX)
				ClientEvent("new", "all_in_sight", "monsters/summon/circle_of_ice_lesser", clientDuration, IndexOf(ENT_ME), CIRCLE_RADIUS);
			Vector3 myOrigin = OriginOf(ENT_ME);
			ClientEffect("light", "new", myOrigin, CIRCLE_RADIUS, Vector3(128, 128, 255), MY_DURATION); // dun think this does anything from here
			THIS_SCRIPT_CLIENT_ID = LastClientScriptId();
			CIRCLE_UP = true;
		}

		if (DID_WINDUP)
			PlaySound(0, 10, SOUND_PULSE);
		if (!DID_WINDUP)
		{
			PlaySound(0, 10, SOUND_MANIFEST);
			DID_WINDUP = true;
		}

		if (!CIRCLE_ON)
			return;
		CallEventDelayed(PULSE_PLAYTIME, "circle_hum");
	}

	// circle_end
	void CircleOfIceLesser_OnCircleEnd()
	{
		ClientEvent("remove", "all", THIS_SCRIPT_CLIENT_ID);
		CIRCLE_ON = false;

		ClientEvent("remove", "all", "monsters/summon/circle_of_ice_lesser"); // there can be only one
		PlaySound(0, 10, SOUND_FADE);
		CallEventDelayed(0.5f, "circle_remove");
	}

	// circle_remove
	void CircleOfIceLesser_OnCircleRemove()
	{
		DeleteEntity(ENT_ME);
	}

	// apply_aoe_effect
	// from base_aoe
	void CircleOfIceLesser_OnApplyAoeEffect(CBaseEntity@ target = null)
	{
		if (HasEffect(target, "DOT_cold"))
			return;
		ApplyEffect(target, "effects/dot_cold", FROST_DURATION, MY_OWNER, MY_BASE_DAMAGE, ACTIVE_SKILL);
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseAoe_OnGameSpawn(playerRace, playerGender); // monsters/summon/base_aoe
		CircleOfIceLesser_OnGameSpawn(playerRace, playerGender);
	}

	void OnGameDynamicallyCreated(string creatorValue1 = "", string creatorValue2 = "", string damage = "", string skill = "", string extraValue5 = "", string extraValue6 = "", float alwaysPush = 0.0f, string duration = "", string extraValue9 = "") { CircleOfIceLesser_OnGameDynamicallyCreated(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); } // game_dynamically_created
	void OnMakeSeal() { CircleOfIceLesser_OnMakeSeal(); } // make_seal
	void OnCircleHum() { CircleOfIceLesser_OnCircleHum(); } // circle_hum
	void OnCircleEnd() { CircleOfIceLesser_OnCircleEnd(); } // circle_end
	void OnCircleRemove() { CircleOfIceLesser_OnCircleRemove(); } // circle_remove
	void OnApplyAoeEffect(CBaseEntity@ target = null) { CircleOfIceLesser_OnApplyAoeEffect(target); } // apply_aoe_effect
	void OnMyDuration() {} // MY_DURATION
	void OnPulsePlaytime() {} // PULSE_PLAYTIME

	// This file's events and timers by their .script names
	bool CircleOfIceLesser_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "apply_aoe_effect") { OnApplyAoeEffect(EntityParam(params, 0)); return true; }
		if (name == "circle_end") { OnCircleEnd(); return true; }
		if (name == "circle_hum") { OnCircleHum(); return true; }
		if (name == "circle_remove") { OnCircleRemove(); return true; }
		if (name == "game_dynamically_created") { OnGameDynamicallyCreated(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Float(Param(params, 6)), Param(params, 7), Param(params, 8)); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "make_seal") { OnMakeSeal(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "monsters/summon/circle_of_ice_lesser"]
shared class CircleOfIceLesserScript : BaseAoeScript, CircleOfIceLesser
{
	// Variables every script that includes this file declares
	bool NO_RAIN_FX = false;

	// Variables declared by included files, with the value they start with in this script
	CircleOfIceLesserScript()
	{
		AOE_FREQ = 1.0f;
		AOE_RADIUS = "110";
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("teleporter_blue_sprites.mdl");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return CircleOfIceLesser_DispatchEvent(name, params)
			|| BaseAoeScript::DispatchEvent(name, params);
	}
}
