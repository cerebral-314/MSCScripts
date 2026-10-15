#pragma context server

// Converted from monsters/summon/tnt_bomb.script by msc_transpiler.

#include "runtime/ScriptEntity.as"

[script "monsters/summon/tnt_bomb"]
class TntBomb : ScriptEntity
{
	// Constants
	string SPRITE_EXPLODE = "bigsmoke.spr";
	string SOUND_EXPLODE = "weapons/explode3.wav";
	string SOUND_FUSE_LOOP = "monsters/dwarf_bomber/fuse_loop.wav";

	// Variables (an unset .script variable reads as its own name)
	string MY_OWNER = "MY_OWNER";
	string START_VEL = "START_VEL";
	bool IS_ACTIVE = false;
	float BOMB_DURATION = 0.0f;
	string CL_INDEX = "CL_INDEX";
	string PLAYING_DEAD = "PLAYING_DEAD";
	float OLD_SPEED = 0.0f;
	float N_DMG_TIMES = 0.0f;
	float GROUND_PULSE = 0.0f;
	CBaseEntity@ TOUCH_TARG = null;
	float NEXT_DMG = 0.0f;

	// game_touch
	string TntBomb_OnGameTouch(CBaseEntity@ other = null, string hpRange = "", string effectDamage = "")
	{
		string result = "";
		// dbg game_touch $get(PARAM1,id) $get(ent_me,speed)
		if (!IS_ACTIVE)
			return result;
		@TOUCH_TARG = other;
		CallEventDelayed(0.01f, "damage_touched");
		return result;
	}

	// game_damaged_other
	string TntBomb_OnGameDamagedOther(CBaseEntity@ target = null, float damage = 0.0f, string damageType = "", string damageEvent = "")
	{
		bool reduce = false;
		string result = "";
		if (EntityId(target) == MY_OWNER)
			reduce = true;
		if (RelationshipOf(MY_OWNER, @target) == "ally")
			reduce = true;
		if (!reduce && RelationshipOf(MY_OWNER, @target) == "enemy")
			CallExternal(MY_OWNER, "ext_hittarget", @target);
		if (!reduce)
			return result;
		result = AppendResult(result, "0.1");
		return result;
	}

	// game_dynamically_created
	// <owner> <vel>
	void OnGameDynamicallyCreated(string creatorValue1 = "", string creatorValue2 = "", string damage = "", string skill = "", string extraValue5 = "", string extraValue6 = "", float alwaysPush = 0.0f, string duration = "", string extraValue9 = "")
	{
		MY_OWNER = creatorValue1;
		START_VEL = creatorValue2;
		// setvard DMG_MULTI PARAM3 //grab dmg_multi and base dmg from summoner
		SetCallback("touch", "enable");
		IS_ACTIVE = true;
		CallEventDelayed(0.01f, "boost_and_scan");
		BOMB_DURATION = Random(5, 10);
		Effect("beam", "follow", "lgtning.spr", ENT_ME, 1, 1, BOMB_DURATION, 200, Vector3(255, 0, 0));
		// client effects go here
		CallEventDelayed(0.01f, "setup_fx");
		CallEventDelayed(BOMB_DURATION, "go_splodie");
	}

	// setup_fx
	void OnSetupFx()
	{
		ClientEvent("new", "all", "monsters/summon/tnt_bomb_cl", IndexOf(ENT_ME), BOMB_DURATION);
		DebugPrint("setup_fx");
		CL_INDEX = LastClientScriptId();
		SetProp(ENT_ME, "avelocity", RelativeVelocity(Vector3(0, 60, 0)));
		ServerPlaySound(1, 5, SOUND_FUSE_LOOP);
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		SetName("explosives");
		SetModel("monsters/dwarf_bomber_tnt.mdl");
		SetWidth(8);
		SetHeight(8);
		SetGravity(2);
		SetIdleAnim("tnt_idle");
		SetProp(ENT_ME, "movetype", Eval("const.movetype.bounce"));
		SetProp(ENT_ME, "friction", 0.2f);
		SetInvincible(true);
		SetRace("hated");
		PLAYING_DEAD = "1";
		SetMonsterClip(false);
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

	string OnGameTouch(CBaseEntity@ other = null, string hpRange = "", string effectDamage = "") { return TntBomb_OnGameTouch(other, hpRange, effectDamage); } // game_touch

	// damage_touched
	void OnDamageTouched(string target = "")
	{
		if (!(GameTime() > NEXT_DMG))
			return;
		NEXT_DMG = GameTime() + 0.25f;
		if (RelationshipOf(MY_OWNER, target) == "enemy") {}
		CallEventDelayed(0.1f, "go_splodie");
	}

	// go_splodie
	void OnGoSplodie()
	{
		if (Float(CL_INDEX) > 0.0f)
			ClientEvent("update", "all", CL_INDEX, "end_fx");
		ServerPlaySound(1, 0, SOUND_FUSE_LOOP);

		Effect("tempent", "spray", SPRITE_EXPLODE, MyOrigin(), 0, 1, 0, 0);
		SetModel("none");
		float dmgAmt = Float(ScriptVarOf(MY_OWNER, "DMG_BOMB"));
		if (DamageMultiplierOf(MY_OWNER) > 0.0f)
			dmgAmt *= DamageMultiplierOf(MY_OWNER);
		DoDamageEx(OriginOf(ENT_ME), 128, dmgAmt, 0, ENT_ME, ENT_ME, "none", "fire_effect", "dmgevent:push_loop");
		// attachsprite SPRITE_EXPLODE trans 20 1.0
		PlaySound(0, 10, SOUND_EXPLODE);
		// drop splodie sprite here
		IS_ACTIVE = false;
		CallEventDelayed(0.1f, "remove_me");
	}

	string OnGameDamagedOther(CBaseEntity@ target = null, float damage = 0.0f, string damageType = "", string damageEvent = "") { return TntBomb_OnGameDamagedOther(target, damage, damageType, damageEvent); } // game_damaged_other

	// push_loop_dodamage
	void OnPushLoopDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		// dbg push_loop $get(CUR_TARGET,name) of PUSH_LIST
		Vector3 targetOrg = OriginOf(target);
		float targAng = AnglesTo(MyOrigin(), targetOrg);
		SetVelocity(target, RelativeVelocity(Vector3(0, targAng, 0), Vector3(10, 1000, 110))); // a little to the left too, in case he's stuck up against a wall
		if (EntityId(target) == MY_OWNER)
			CallExternal(MY_OWNER, "friendly_fire");
	}

	// remove_me
	void OnRemoveMe(string caller = "")
	{
		DeleteEntity(ENT_ME);
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files
	void OnBombDuration() {} // BOMB_DURATION

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/dwarf_bomber/fuse_loop.wav");
		Precache("monsters/dwarf_bomber_tnt.mdl");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "boost_and_scan") { OnBoostAndScan(); return true; }
		if (name == "damage_touched") { OnDamageTouched(Param(params, 0)); return true; }
		if (name == "game_damaged_other") { Return(OnGameDamagedOther(EntityParam(params, 0), Float(Param(params, 1)), Param(params, 2), Param(params, 3))); return true; }
		if (name == "game_dynamically_created") { OnGameDynamicallyCreated(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Float(Param(params, 6)), Param(params, 7), Param(params, 8)); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "game_touch") { Return(OnGameTouch(EntityParam(params, 0), Param(params, 1), Param(params, 2))); return true; }
		if (name == "go_splodie") { OnGoSplodie(); return true; }
		if (name == "monitor_speed") { OnMonitorSpeed(); return true; }
		if (name == "push_loop_dodamage") { OnPushLoopDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5)); return true; }
		if (name == "remove_me") { OnRemoveMe(Param(params, 0)); return true; }
		if (name == "setup_fx") { OnSetupFx(); return true; }
		return false;
	}
}
