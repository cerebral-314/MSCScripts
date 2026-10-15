#pragma context server

// Converted from monsters/summon/ibarrier.script by msc_transpiler.
// Simplified version of monsters/summon/barrier, positionable
// PARAM1 - Owner
// PARAM2 - Radius
// PARAM3 - Duration
// PARAM4 - 1 for No sprites
// PARAM5 - 1 for Sounds
// PARAM6 - Damage when repelled (optional)
// PARAM7 - 1 for Push allies too (ie. everyone but master)

#include "runtime/ScriptEntity.as"

[script "monsters/summon/ibarrier"]
class Ibarrier : ScriptEntity
{
	// Constants
	string SOUND_PUSH = "doors/aliendoor3.wav";

	// Variables (an unset .script variable reads as its own name)
	string MY_OWNER = "MY_OWNER";
	float MY_RADIUS = 0.0f;
	string MY_DURATION = "MY_DURATION";
	float MY_BASE_DAMAGE = 0.0f;
	bool AM_INVISIBLE = false;
	bool NO_SOUND = false;
	bool ALWAYS_PUSH = false;
	Vector3 SPRITE_COLOR = Vector3();
	string BARRIER_SCRIPT_IDX = "BARRIER_SCRIPT_IDX";
	bool AM_BLOCKING = false;
	string PLAYING_DEAD = "PLAYING_DEAD";

	// game_dodamage
	// 1:AttackHit(1/0)  2:EntityHit  3:StartOrigin  4:EndOrigin
	string Ibarrier_OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";

		bool doPush = false;
		if (RelationshipOf(target, MY_OWNER) == "enemy")
			doPush = true;
		if (ALWAYS_PUSH)
			doPush = true;
		if (EntityId(target) == MY_OWNER)
			return result;
		// iBarrier overrides IMMUNE_PUSH due to the fact it is often used to prevent stuckage
		OnPushOut(target);
		return result;
	}

	// game_dynamically_created
	// <owner> <rad> <duration> [invisible:0|1] [silent:0|1] [dmg] [push_allys:0|1]
	void OnGameDynamicallyCreated(string creatorValue1 = "", string creatorValue2 = "", string damage = "", string skill = "", string extraValue5 = "", string extraValue6 = "", float alwaysPush = 0.0f, string duration = "", string extraValue9 = "")
	{
		MY_OWNER = creatorValue1;
		MY_RADIUS = Float(creatorValue2);
		MY_DURATION = damage;

		MY_BASE_DAMAGE = 0.0f;

		if (Float(skill) == 1.0f)
			AM_INVISIBLE = true;
		if (Float(extraValue5) == 1.0f)
			NO_SOUND = true;
		if (!extraValue6.isEmpty())
			MY_BASE_DAMAGE = Float(extraValue6);
		if (alwaysPush == 1.0f)
			ALWAYS_PUSH = true;

		MY_BASE_DAMAGE = 0.0f;

		SetRace("hated");

		if (MY_BASE_DAMAGE == 0.0f)
			SPRITE_COLOR = Vector3(0, 0, 255);
		if (MY_BASE_DAMAGE > 0.0f)
			SPRITE_COLOR = Vector3(255, 0, 0);

		if (!AM_INVISIBLE)
			ClientEvent("new", "all", "monsters/summon/ibarrier", IndexOf(ENT_ME), MY_RADIUS, SPRITE_COLOR);
		BARRIER_SCRIPT_IDX = LastClientScriptId();

		CallEventOrDelay(MY_DURATION, "remove_barrier");

		AM_BLOCKING = true;
		CallEventDelayed(0.1f, "scan_loop");
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		SetName("Magical Barrier");
		SetModel("none"); // prevents gib error
		SetHealth(9000); // high HP in effort to prevent push
		SetInvincible(true);
		SetWidth(8);
		SetHeight(8);
		SetSolid("none");
		SetHearingSensitivity(11);
		SetDamageTaken("stun", 0);

		PLAYING_DEAD = "1"; // not valid target
	}

	// game_heardsound
	void OnGameHeardsound(string soundType = "", Vector3 origin = Vector3(), float dangerRadius = 0.0f)
	{
		if (!AM_BLOCKING)
			return;
		CBaseEntity@ lastheardId = EntityOf(ENT_LASTHEARD);
		if (!(RangeTo(lastheardId) < MY_RADIUS))
			return;
		bool doHpush = false;
		if (RelationshipOf(lastheardId, MY_OWNER) == "enemy")
			doHpush = true;
		if (ALWAYS_PUSH)
			doHpush = true;
		if (EntityId(lastheardId) == MY_OWNER)
			doHpush = false;
		if (!doHpush)
			return;
		OnPushOut(lastheardId);
	}

	// scan_loop
	void OnScanLoop()
	{
		if (!AM_BLOCKING)
			return;
		CallEventDelayed(0.25f, "scan_loop");
		DoDamage(Text(RelativePosition(Vector3(0, 0, 0))), MY_RADIUS, 0.0f, "100%", 0, "reflective", "target");
	}

	string OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "") { return Ibarrier_OnGameDodamage(hit, target, start, end, damageType, damageText); } // game_dodamage

	// push_out
	// PARAM1 - guy to repulse
	void OnPushOut(CBaseEntity@ target = null)
	{
		if (MY_BASE_DAMAGE > 0.0f)
			DoDamage(target, "direct", MY_BASE_DAMAGE, "100%", "MY_MASTER", "magic");
		Effect("glow", @target, Vector3(255, 255, 255), 60, 1.0f, 1.0f);

		// setangle face PARAM1
		// addvelocity $get(PARAM1,id) $relvel(0,1000,0)
		Vector3 targetOrg = OriginOf(target);
		float targAng = AnglesTo(MyOrigin(), targetOrg);
		int newYaw = int(targAng);
		// add NEW_YAW 180
		// if ( NEW_YAW > 359 ) subtract NEW_YAW 359
		PlaySound(0, 10, SOUND_PUSH);
		SetVelocity(target, RelativeVelocity(Vector3(0, newYaw, 0), Vector3(0, 1000, 0)));
	}

	// remove_barrier
	void OnRemoveBarrier()
	{
		AM_BLOCKING = false;
		ClientEvent("update", "all", BARRIER_SCRIPT_IDX, "clear_sprites");
		// if ( !SILENT_EXIT ) playsound 0 10 magic/spawn.wav
		CallEventDelayed(2.0f, "remove_me");
	}

	// remove_me
	void OnRemoveMe(string caller = "")
	{
		if (AM_INVISIBLE)
			ClientEvent("remove", "all", BARRIER_SCRIPT_IDX);
		CallEventDelayed(0.1f, "remove_me2");
	}

	// remove_me2
	void OnRemoveMe2()
	{
		DeleteEntity(ENT_ME);
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files
	void OnMyDuration() {} // MY_DURATION

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "game_dodamage") { Return(OnGameDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5))); return true; }
		if (name == "game_dynamically_created") { OnGameDynamicallyCreated(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Float(Param(params, 6)), Param(params, 7), Param(params, 8)); return true; }
		if (name == "game_heardsound") { OnGameHeardsound(Param(params, 0), Vec(Param(params, 1)), Float(Param(params, 2))); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "push_out") { OnPushOut(EntityParam(params, 0)); return true; }
		if (name == "remove_barrier") { OnRemoveBarrier(); return true; }
		if (name == "remove_me") { OnRemoveMe(Param(params, 0)); return true; }
		if (name == "remove_me2") { OnRemoveMe2(); return true; }
		if (name == "scan_loop") { OnScanLoop(); return true; }
		return false;
	}
}
