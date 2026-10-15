#pragma context server

// Converted from items/proj_mana_boss.script by msc_transpiler.
// Manabolt for npc bosses, off items/proj_mana2 - Dravus
// Tighter scan than the player version so fast bolts don't slip/blink between checks,
// and the radius isn't capped to the player value

#include "runtime/ScriptEntity.as"

[script "items/proj_mana_boss"]
class ProjManaBoss : ScriptEntity
{
	// Constants
	string SOUND_SHOOT = "ambience/alienflyby1.wav";
	string SOUND_ZAP = "debris/zap1.wav";
	string CLFX_ARROW_SCRIPT = "items/proj_mana2_cl";
	float SCAN_RATE = 0.1f;
	float RETICK_DELAY = 0.55f;
	int SCAN_PER_SIZE = 10;
	int SCAN_MIN = 55;
	int SCAN_MAX = 140;
	int MIN_TRAVEL = 16;
	int BLOCK_LIMIT = 3;
	bool FOLLOW_FLOOR = true;
	int FLOOR_OFS = 24;
	bool SINK_RATE = false;

	// Variables (an unset .script variable reads as its own name)
	string FX_OWNER = "FX_OWNER";
	string FX_VEL = "FX_VEL";
	float FX_SIZE = 0.0f;
	string FX_DAMAGE = "FX_DAMAGE";
	string FX_SKILL = "FX_SKILL";
	string FX_MODE = "FX_MODE";
	float SCAN_SIZE = 0.0f;
	string DAMAGE_LIST = "DAMAGE_LIST";
	float BLOCK_COUNT = 0.0f;
	float NEXT_RETICK = 0.0f;
	float FX_SIZE_START = 0.0f;
	string FX_DAMAGE_START = "FX_DAMAGE_START";
	Vector3 PREV_SCAN = Vector3();
	bool CLFX_ARROW_INIT = false;
	bool CLFX_ARROW_IN_FLIGHT = false;
	string CLFX_ARROW_IDX = "CLFX_ARROW_IDX";
	string SCAN_TARGS = "SCAN_TARGS";

	// func_get_scan_size
	string ProjManaBoss_OnFuncGetScanSize()
	{
		string result = "";

		float scanSize = Clamp(SCAN_PER_SIZE * FX_SIZE, SCAN_MIN, SCAN_MAX);
		result = "";
		result = AppendResult(result, Text(scanSize));
		return result;
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		SetName("Manabolt");
		SetDescription("Manabolt");
		SetWeight(0);
		SetGravity(0);

		SetModel("none");

		CallEventDelayed(10.0f, "remove_projectile");
	}

	// game_dynamically_created
	// <owner> <vec> <ballSize> <damage> <skill to level> [mode]
	void OnGameDynamicallyCreated(string creatorValue1 = "", string creatorValue2 = "", string damage = "", string skill = "", string extraValue5 = "", string extraValue6 = "", float alwaysPush = 0.0f, string duration = "", string extraValue9 = "")
	{
		FX_OWNER = creatorValue1;
		FX_VEL = creatorValue2;
		FX_SIZE = Float(damage);
		FX_DAMAGE = skill;
		FX_SKILL = extraValue5;

		FX_MODE = extraValue6;
		if (FX_MODE.isEmpty())
			FX_MODE = "shrink";

		SCAN_SIZE = Float(OnFuncGetScanSize());

		SetVelocity(ENT_ME, Vec(FX_VEL));
		LegacyCommand("svsound.play3d", SOUND_SHOOT, 2.5f, OriginOf(ENT_ME), 0, 4);

		DAMAGE_LIST = "";
		BLOCK_COUNT = 0.0f;
		NEXT_RETICK = 0.0f;

		FX_SIZE_START = FX_SIZE;
		FX_DAMAGE_START = FX_DAMAGE;

		PREV_SCAN = OriginOf(ENT_ME);
		CallEventDelayed(SCAN_RATE, "scan_cycle");

		OnCreateClfx();

		SetProp(ENT_ME, "movetype", 11);
		SetProp(ENT_ME, "friction", 10000);
		SetProp(ENT_ME, "solid", 0);
	}

	// create_clfx
	void OnCreateClfx()
	{
		if (!CLFX_ARROW_INIT)
		{
			CLFX_ARROW_INIT = true;
			CLFX_ARROW_IN_FLIGHT = true;

			ClientEvent("new", "all", CLFX_ARROW_SCRIPT, OriginOf(ENT_ME), AnglesOf(ENT_ME), VelocityOf(ENT_ME), FX_SIZE);
			CLFX_ARROW_IDX = LastClientScriptId();
		}
	}

	// scan_cycle
	void OnScanCycle()
	{
		bool exitSub = false;
		int count;

		Vector3 org = OriginOf(ENT_ME);

		if (FOLLOW_FLOOR)
		{
			float ground = GroundHeight(org);
			float ridez = ground;
			string ridezText;
			ridez += FLOOR_OFS;
			ridezText = Text(ridez);
			float myz = org.z;

			if (myz < ridez)
			{
				org.z = ridez;
				SetOrigin(ENT_ME, org);
			}
			if (myz > ridez)
			{
				float drop = myz;
				string dropText;
				drop -= (SINK_RATE ? 1.0f : 0.0f);
				if (drop < ridez)
					drop = ridez;
				org.z = drop;
				SetOrigin(ENT_ME, org);
			}
		}

		string flat = Text(org);
		flat = Text(WithZ(Vec(flat), PREV_SCAN.z));
		string trace = LegacyFunction("get_traceline", PREV_SCAN, flat, "worldonly");
		if (trace != flat)
		{
			BLOCK_COUNT += 1.0f;
			if (BLOCK_COUNT >= BLOCK_LIMIT)
			{
				OnRemoveProjectile();
				exitSub = true;
			}
		}
		else
		{
			BLOCK_COUNT = 0.0f;
		}
		if (exitSub)
			return;

		if (Distance(org, PREV_SCAN) > MIN_TRAVEL)
		{
			PREV_SCAN = org;

			if (GameTime() > NEXT_RETICK)
			{
				DAMAGE_LIST = "";
				NEXT_RETICK = GameTime() + RETICK_DELAY;
			}

			SCAN_TARGS = LegacyFunction("get_tsphere", "any", SCAN_SIZE, OriginOf(ENT_ME));
			if (SCAN_TARGS != "none")
			{
				count = GetTokenCount(SCAN_TARGS);
				for (int i = 0; i < count; i++)
				{
					loopIteration = i;
					OnDamageTargets();
				}
			}

			CallEventDelayed(SCAN_RATE, "scan_cycle");
		}
		else
		{
			OnRemoveProjectile();
		}
	}

	// damage_targets
	void OnDamageTargets()
	{
		bool exitSub = false;

		CBaseEntity@ curTarg = FindEntity(GetToken(SCAN_TARGS, loopIteration));

		if (Contains(DAMAGE_LIST, EntityId(curTarg)))
			exitSub = true;
		if (exitSub)
			return;
		if (RelationshipOf(curTarg, FX_OWNER) != "enemy")
			return;

		DoDamageEx(OriginOf(ENT_ME), OriginOf(curTarg), FX_DAMAGE, "100%", FX_OWNER, ENT_ME, FX_SKILL, "magic");

		DAMAGE_LIST = TokenAdd(DAMAGE_LIST, EntityId(curTarg));

		if (FX_MODE != "persist")
			OnShrinkBall();
	}

	// shrink_ball
	void OnShrinkBall()
	{
		FX_SIZE -= 1.0f;
		if (FX_SIZE > 0.0f)
		{
			SCAN_SIZE = Float(OnFuncGetScanSize());

			float dmg = Float(FX_DAMAGE_START);
			dmg *= FX_SIZE;
			dmg = Divide(dmg, FX_SIZE_START);
			FX_DAMAGE = Text(dmg);

			ClientEvent("update", "all", CLFX_ARROW_IDX, "reduce_size");
		}
		else
		{
			OnRemoveProjectile();
		}
	}

	// remove_projectile
	void OnRemoveProjectile(string fxIndex = "")
	{
		LegacyCommand("svsound.play3d", SOUND_ZAP, 4, OriginOf(ENT_ME), 0, 4);
		ClientEvent("update", "all", CLFX_ARROW_IDX, "end_fx");
		DeleteMe();
	}

	// fake_precache
	void OnFakePrecache()
	{
		ServerPlaySound(4, 0, SOUND_ZAP);
	}

	string OnFuncGetScanSize() { return ProjManaBoss_OnFuncGetScanSize(); } // func_get_scan_size

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files
	void OnScanRate() {} // SCAN_RATE

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("ambience/alienflyby1.wav");
		Precache("debris/zap1.wav");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "create_clfx") { OnCreateClfx(); return true; }
		if (name == "damage_targets") { OnDamageTargets(); return true; }
		if (name == "fake_precache") { OnFakePrecache(); return true; }
		if (name == "func_get_scan_size") { Return(OnFuncGetScanSize()); return true; }
		if (name == "game_dynamically_created") { OnGameDynamicallyCreated(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Float(Param(params, 6)), Param(params, 7), Param(params, 8)); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "remove_projectile") { OnRemoveProjectile(Param(params, 0)); return true; }
		if (name == "scan_cycle") { OnScanCycle(); return true; }
		if (name == "shrink_ball") { OnShrinkBall(); return true; }
		return false;
	}
}
