#pragma context server

// Converted from traps/fire_wall2.script by msc_transpiler.
// Thothie - re-write of firewall for optimization

#include "runtime/ScriptEntity.as"

[script "traps/fire_wall2"]
class FireWall2 : ScriptEntity
{
	// Constants
	string MY_DURATION = "15.0";

	// Variables (an unset .script variable reads as its own name)
	bool AM_SUMMONED = false;
	string MY_OWNER = "MY_OWNER";
	string MY_ANGLES = "MY_ANGLES";
	float MY_BASE_DMG = 0.0f;
	string PLAYING_DEAD = "PLAYING_DEAD";
	string MY_CL_IDX = "MY_CL_IDX";
	bool IS_ACTIVE = false;
	float DMG_STEP = 0.0f;
	string SCAN_TARGETS = "SCAN_TARGETS";

	// game_dynamically_created
	void OnGameDynamicallyCreated(string creatorValue1 = "", string creatorValue2 = "", string damage = "", string skill = "", string extraValue5 = "", string extraValue6 = "", float alwaysPush = 0.0f, string duration = "", string extraValue9 = "")
	{
		AM_SUMMONED = true;
		MY_OWNER = creatorValue1;
		MY_ANGLES = creatorValue2;
		SetAngle("face.y", AnglesOf(MY_ANGLES).y);
		MY_BASE_DMG = Float(damage);
		if (damage.isEmpty())
			MY_BASE_DMG = 300.0f;
		LegacyCommand("storeentity", ENT_EXPOWNER, MY_OWNER);
		SetRace(RaceOf(MY_OWNER));
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		SetName("Fire Wall Trap");
		SetHealth(1);
		SetInvincible(true);
		PLAYING_DEAD = "1";
		SetNoPush(true);
		SetModel("null.mdl");

		CallEventDelayed(0.1f, "define_vars");

		CallEventOrDelay(MY_DURATION, "end_effect"); // Die after a delay
	}

	// define_vars
	void OnDefineVars()
	{
		if (!AM_SUMMONED)
		{
			SetRace("hated");
			MY_OWNER = EntityId(self);
			MY_BASE_DMG = 300.0f;
			MY_ANGLES = Text(AnglesOf(ENT_ME).y);
		}

		CallEventDelayed(0.1f, "activate_effect");
	}

	// activate_effect
	void OnActivateEffect()
	{
		ClientEvent("new", "all", "traps/fire_wall2", OriginOf(ENT_ME), MY_ANGLES);
		MY_CL_IDX = LastClientScriptId();
		IS_ACTIVE = true;
		DMG_STEP = 0.0f;
		CallEventDelayed(2.0f, "damage_cycle");
	}

	// damage_cycle
	void OnDamageCycle()
	{
		Vector3 scanPos = Vec("SCAN_POS");

		if (!IS_ACTIVE)
			return;
		CallEventDelayed(0.2f, "damage_cycle");
		if (DMG_STEP == 3.0f)
			DMG_STEP = 0.0f;
		DMG_STEP += 1.0f;

		if (DMG_STEP == 1.0f)
			scanPos = RelativePosition(Vector3(0, 0, 0));
		if (DMG_STEP == 2.0f)
			scanPos = RelativePosition(Vector3(0, 96, 0));
		if (DMG_STEP == 3.0f)
			scanPos = RelativePosition(Vector3(0, -96, 0));

		// if ( G_DEVELOPER_MODE ) gplayermessage G_DEV_PLAYER SCAN_POS $get(SCAN_POS,range) $get(ent_me,race)
		SCAN_TARGETS = LegacyFunction("get_tsphere", "enemy", 96, scanPos);
		if (SCAN_TARGETS == "none")
			return;
		CallEventDelayed(GetTokenCount(SCAN_TARGETS), "apply_aoe_effect");
	}

	// apply_aoe_effect
	void OnApplyAoeEffect(CBaseEntity@ target = null)
	{
		CBaseEntity@ curTarget = FindEntity(GetToken(SCAN_TARGETS, loopIteration));
		ApplyEffect(curTarget, "effects/dot_fire", 2, MY_OWNER, MY_BASE_DMG);
	}

	// end_effect
	void OnEndEffect()
	{
		IS_ACTIVE = false;
		ClientEvent("remove", "all", MY_CL_IDX);
		CallEventDelayed(0.1f, "final_remove");
	}

	// final_remove
	void OnFinalRemove()
	{
		RemoveScript();
		DeleteEntity(ENT_ME);
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files
	void OnMyDuration() {} // MY_DURATION

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("null.mdl");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "activate_effect") { OnActivateEffect(); return true; }
		if (name == "apply_aoe_effect") { OnApplyAoeEffect(EntityParam(params, 0)); return true; }
		if (name == "damage_cycle") { OnDamageCycle(); return true; }
		if (name == "define_vars") { OnDefineVars(); return true; }
		if (name == "end_effect") { OnEndEffect(); return true; }
		if (name == "final_remove") { OnFinalRemove(); return true; }
		if (name == "game_dynamically_created") { OnGameDynamicallyCreated(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Float(Param(params, 6)), Param(params, 7), Param(params, 8)); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		return false;
	}
}
