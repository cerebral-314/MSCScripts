#pragma context server

// Converted from monsters/summon/circle_of_ice_greater.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_npc.as"

[script "monsters/summon/circle_of_ice_greater"]
class CircleOfIceGreater : BaseNpcScript
{
	// Constants
	string SEAL_MODEL = "weapons/magic/seals.mdl";
	string SEAL_OFS = "8";
	string SOUND_MANIFEST = "magic/spawn_loud.wav";
	string SOUND_PULSE = "magic/frost_forward.wav";
	string SOUND_FADE = "magic/frost_reverse.wav";
	float PULSE_PLAYTIME = 1.0f;
	string FX_SPRITE = "firemagic.spr";
	int CIRCLE_RADIUS = 172;
	string APPLY_EFFECT = "effects/dot_cold_freeze";

	// Variables (an unset .script variable reads as its own name)
	string MY_OWNER = "MY_OWNER";
	string MY_DURATION = "MY_DURATION";
	float FREEZE_DURATION = 0.0f;
	string MY_OWNER_RACE = "MY_OWNER_RACE";
	bool CIRCLE_ON = false;
	string THIS_SCRIPT_CLIENT_ID = "THIS_SCRIPT_CLIENT_ID";
	bool CIRCLE_UP = false;
	bool DID_WINDUP = false;

	// game_dodamage
	// 1: Attack Hit (1/0)  2: Entity Attack hit  3:  Start Position  4:  End Position
	string CircleOfIceGreater_OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";

		if (RelationshipOf(target, MY_OWNER) != "enemy")
			return result;
		// //dbg Hit $get(PARAM2,name)
		string dmgSource = MY_OWNER;
		ApplyEffect(ENT_LASTSEEN, APPLY_EFFECT, FREEZE_DURATION, dmgSource);
		return result;
	}

	// game_dynamically_created
	// PARAM1 = owner PARAM2 = CircleDuration PARAM3 = FreezeDuration
	void OnGameDynamicallyCreated(string creatorValue1 = "", string creatorValue2 = "", string damage = "", string skill = "", string extraValue5 = "", string extraValue6 = "", float alwaysPush = 0.0f, string duration = "", string extraValue9 = "")
	{
		BaseSelfAdjust_OnGameDynamicallyCreated(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/base_self_adjust
		BaseSelfAdjust_OnGameDynamicallyCreated_2(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/base_self_adjust

		MY_OWNER = creatorValue1;
		MY_DURATION = creatorValue2;
		FREEZE_DURATION = Float(damage);

		MY_OWNER_RACE = RaceOf(creatorValue1);

		CallEventOrDelay(MY_DURATION, "circle_end");
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		SetName("Greater Circle of Ice");
		SetHealth(1);
		SetFieldOfView(359);
		SetInvincible(true);
		SetRace("beloved");
		SetHeight(2);
		SetWidth(2);
		SetFly(true);
		LegacyCommand("float", 1);
		SetGravity(0);
		SetBlood("none");
		SetModel("none");
		SetSolid("none");

		CIRCLE_ON = true;

		CallEventDelayed(0.1f, "make_seal");

		CallEventDelayed(1.0f, "circle_go");

		CallEventDelayed(0.1f, "circle_hum");
	}

	// make_seal
	void OnMakeSeal()
	{
		Vector3 sealPos = OriginOf(ENT_ME);
		float groundZ = GroundHeight(sealPos);
		float sealZ = sealPos.z;
		float groundDist = groundZ - sealZ;
		// dbg MyBasePos SEAL_POS GroundZ GROUND_Z
		sealPos += RelativePosition(Vector3(0, 0, 0), Vector3(0, 0, groundDist));
		// dbg MyGroundPos SEAL_POS Ground GROUND_DIST
		CreateNpc("monsters/summon/seal_maker", sealPos, SEAL_MODEL, MY_DURATION, SEAL_OFS);
	}

	// circle_hum
	void OnCircleHum()
	{
		// drop_to_floor ent_me
		if (!CIRCLE_UP)
		{
			// clientevent persist all $currentscript effect.duration $get(ent_me,index) PARAM2 GLOW_COLOR
			float clientDuration = Float(MY_DURATION);
			clientDuration -= 0.2f; // effort to prevent client side fx from sticking
			ClientEvent("new", "all_in_sight", "monsters/summon/circle_of_ice_greater", clientDuration, IndexOf(ENT_ME), CIRCLE_RADIUS);
			Vector3 myOrigin = OriginOf(ENT_ME);
			ClientEffect("light", "new", myOrigin, CIRCLE_RADIUS, Vector3(128, 128, 255), MY_DURATION);
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

	// circle_go
	void OnCircleGo()
	{
		if (!CIRCLE_ON)
			return;

		CallEventDelayed(0.25f, "circle_go");

		if (EntityId(EntityOf(ENT_LASTSEEN)) == MY_OWNER)
			Look(1024);

		DoDamage(Text(RelativePosition(Vector3(0, 0, 0))), CIRCLE_RADIUS, 0, "100%", 0, "reflective");

		if (!CanSee("ally"))
			return;
		if (!(RangeTo(ENT_LASTSEEN) <= CIRCLE_RADIUS))
			return;
		if (RelationshipOf(ENT_LASTSEEN, MY_OWNER) != "enemy")
			return;
		// //dbg Saw $get(ent_lastseen,name)
		string dmgSource = MY_OWNER;
		// if ( $get(MY_OWNER,isplayer) == 0 ) local DMG_SOURCE $get(ent_me,id)
		if (HasEffect(ENT_LASTSEEN, "DOT_cold"))
			return;
		ApplyEffect(ENT_LASTSEEN, APPLY_EFFECT, FREEZE_DURATION, dmgSource);
	}

	string OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "") { return CircleOfIceGreater_OnGameDodamage(hit, target, start, end, damageType, damageText); } // game_dodamage

	// circle_end
	void OnCircleEnd()
	{
		ClientEvent("remove", "all", THIS_SCRIPT_CLIENT_ID);
		CIRCLE_ON = false;

		ClientEvent("remove", "all", "monsters/summon/circle_of_ice_greater"); // there can be only one
		PlaySound(0, 10, SOUND_FADE);
		CallEventDelayed(0.5f, "circle_remove");
	}

	// circle_remove
	void OnCircleRemove()
	{
		DeleteEntity(ENT_ME);
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files
	void OnMyDuration() {} // MY_DURATION
	void OnPulsePlaytime() {} // PULSE_PLAYTIME

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "circle_end") { OnCircleEnd(); return true; }
		if (name == "circle_go") { OnCircleGo(); return true; }
		if (name == "circle_hum") { OnCircleHum(); return true; }
		if (name == "circle_remove") { OnCircleRemove(); return true; }
		if (name == "game_dodamage") { Return(OnGameDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5))); return true; }
		if (name == "game_dynamically_created") { OnGameDynamicallyCreated(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Float(Param(params, 6)), Param(params, 7), Param(params, 8)); return true; }
		if (name == "make_seal") { OnMakeSeal(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		return BaseNpcScript::DispatchEvent(name, params);
	}
}
