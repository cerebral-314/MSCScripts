#pragma context server

// Converted from monsters/summon/spiked_ball.script by msc_transpiler.

#include "runtime/ScriptEntity.as"

[script "monsters/summon/spiked_ball"]
class SpikedBall : ScriptEntity
{
	// Constants
	string SPRITE_EXPLODE = "bigsmoke.spr";
	string SOUND_EXPLODE = "weapons/explode3.wav";

	// Variables (an unset .script variable reads as its own name)
	string MY_OWNER = "MY_OWNER";
	string START_VEL = "START_VEL";
	string DMG_MULTI = "DMG_MULTI";
	bool IS_ACTIVE = false;
	string PLAYING_DEAD = "PLAYING_DEAD";
	float OLD_SPEED = 0.0f;
	float N_DMG_TIMES = 0.0f;
	float GROUND_PULSE = 0.0f;
	CBaseEntity@ TOUCH_TARG = null;
	float NEXT_DMG = 0.0f;
	float DMG_SMT = 0.0f;
	string PUSH_LIST = "PUSH_LIST";

	// game_touch
	string SpikedBall_OnGameTouch(CBaseEntity@ other = null, string hpRange = "", string effectDamage = "")
	{
		string result = "";
		// dbg game_touch $get(PARAM1,id) $get(ent_me,speed)
		if (!IS_ACTIVE)
			return result;
		@TOUCH_TARG = other;
		CallEventDelayed(0.01f, "damage_touched");
		return result;
	}

	// game_dynamically_created
	// <owner> <vel> <dmg_multi>
	void OnGameDynamicallyCreated(string creatorValue1 = "", string creatorValue2 = "", string damage = "", string skill = "", string extraValue5 = "", string extraValue6 = "", float alwaysPush = 0.0f, string duration = "", string extraValue9 = "")
	{
		MY_OWNER = creatorValue1;
		START_VEL = creatorValue2;
		DMG_MULTI = damage;
		SetCallback("touch", "enable");
		IS_ACTIVE = true;
		CallEventDelayed(0.01f, "boost_and_scan");
		CallEventDelayed(10.0f, "go_splodie");
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		SetName("Spiked Ball");
		SetModel("weapons/projectiles.mdl");
		SetModelBody(0, 64);
		SetWidth(48);
		SetHeight(48);
		SetGravity(2);
		SetIdleAnim("spin_vertical_norm");
		SetProp(ENT_ME, "movetype", Eval("const.movetype.bounce"));
		SetProp(ENT_ME, "friction", 0.2f);
		SetInvincible(true);
		SetRace("beloved");
		PLAYING_DEAD = "1";
	}

	// boost_and_scan
	void OnBoostAndScan()
	{
		AddVelocity(ENT_ME, Vec(START_VEL));
		OLD_SPEED = SpeedOf(ENT_ME);
		N_DMG_TIMES = 0.0f;
		GROUND_PULSE = 0.0f;
		OnMonitorSpeed();
	}

	// monitor_speed
	void OnMonitorSpeed()
	{
		bool exitSub = false;
		if (!IS_ACTIVE)
			return;
		CallEventDelayed(0.1f, "monitor_speed");

		float curSpeed = SpeedOf(ENT_ME);
		if (curSpeed < 200.0f && OLD_SPEED < 200.0f)
		{
			OnGoSplodie();
			exitSub = true;
		}
		if (exitSub)
			return;

		float myZ = OriginOf(ENT_ME).z;
		float myGroundZ = GroundHeight(MyOrigin());

		myZ -= myGroundZ;

		if (myZ < 10.0f)
		{
			GROUND_PULSE += 1.0f;
			PlaySound(0, 10, "debris/bustmetal2.wav");
			if (GROUND_PULSE > 2.0f)
				OnGoSplodie();
		}

		OLD_SPEED = curSpeed;
	}

	string OnGameTouch(CBaseEntity@ other = null, string hpRange = "", string effectDamage = "") { return SpikedBall_OnGameTouch(other, hpRange, effectDamage); } // game_touch

	// damage_touched
	void OnDamageTouched(string target = "")
	{
		if (!(GameTime() > NEXT_DMG))
			return;
		NEXT_DMG = GameTime() + 0.25f;
		N_DMG_TIMES += 1.0f;
		if (RelationshipOf(MY_OWNER, @TOUCH_TARG) != "enemy")
			return;
		float dmgAmt = SpeedOf(ENT_ME) * Float(DMG_MULTI);
		if (DamageMultiplierOf(MY_OWNER) > 0.0f)
			DMG_SMT *= DamageMultiplierOf(MY_OWNER);
		PlaySound(0, 10, "debris/bustmetal2.wav");
		DoDamageEx(@TOUCH_TARG, "direct", dmgAmt, "100%", MY_OWNER, MY_OWNER, "none", "blunt_effect");

		if (N_DMG_TIMES > 10.0f)
			CallEventDelayed(0.1f, "go_splodie");
	}

	// go_splodie
	void OnGoSplodie()
	{
		int count;
		Effect("tempent", "spray", SPRITE_EXPLODE, MyOrigin(), 0, 1, 0, 0);
		SetModel("none");
		float dmgAmt = Float(DMG_MULTI);
		dmgAmt *= 300.0f;
		DoDamageEx(OriginOf(ENT_ME), 128, dmgAmt, 0, MY_OWNER, MY_OWNER, "none", "fire_effect");
		PUSH_LIST = LegacyFunction("get_tsphere", "enemy", 128, MyOrigin());
		if (PUSH_LIST != "none")
		{
			count = GetTokenCount(PUSH_LIST);
			for (int i = 0; i < count; i++)
			{
				loopIteration = i;
				OnPushLoop();
			}
		}
		// attachsprite SPRITE_EXPLODE trans 20 1.0
		PlaySound(0, 10, SOUND_EXPLODE);
		// drop splodie sprite here
		IS_ACTIVE = false;
		CallEventDelayed(0.1f, "remove_me");
	}

	// push_loop
	void OnPushLoop()
	{
		CBaseEntity@ curTarget = FindEntity(GetToken(PUSH_LIST, loopIteration));
		// dbg push_loop $get(CUR_TARGET,name) of PUSH_LIST
		Vector3 targetOrg = OriginOf(curTarget);
		float targAng = AnglesTo(MyOrigin(), targetOrg);
		SetVelocity(curTarget, RelativeVelocity(Vector3(0, targAng, 0), Vector3(10, 1000, 110))); // a little to the left too, in case he's stuck up against a wall
	}

	// remove_me
	void OnRemoveMe(string caller = "")
	{
		DeleteEntity(ENT_ME);
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("weapons/projectiles.mdl");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "boost_and_scan") { OnBoostAndScan(); return true; }
		if (name == "damage_touched") { OnDamageTouched(Param(params, 0)); return true; }
		if (name == "game_dynamically_created") { OnGameDynamicallyCreated(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Float(Param(params, 6)), Param(params, 7), Param(params, 8)); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "game_touch") { Return(OnGameTouch(EntityParam(params, 0), Param(params, 1), Param(params, 2))); return true; }
		if (name == "go_splodie") { OnGoSplodie(); return true; }
		if (name == "monitor_speed") { OnMonitorSpeed(); return true; }
		if (name == "push_loop") { OnPushLoop(); return true; }
		if (name == "remove_me") { OnRemoveMe(Param(params, 0)); return true; }
		return false;
	}
}
