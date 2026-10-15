#pragma context server

// Converted from monsters/summon/summon_ice_wall.script by msc_transpiler.
// Ice Wall

#include "runtime/ScriptEntity.as"

[script "monsters/summon/summon_ice_wall"]
class SummonIceWall : ScriptEntity
{
	// Constants
	string CANT_TURN = "1";

	// Variables (an unset .script variable reads as its own name)
	string ANIM_DEATH = "ANIM_DEATH";
	string CAN_ATTACK = "CAN_ATTACK";
	string CAN_HUNT = "CAN_HUNT";
	float rotate = 0.0f;
	int r1 = 0;
	float r2 = 0.0f;
	int f1 = 0;
	int f2 = 0;
	bool SCANNING = false;

	// unnamed block (first think)
	void SummonIceWall_FirstThink()
	{
		ANIM_DEATH = "";
		CAN_ATTACK = "0";
		CAN_HUNT = "0";

		SetCallback("touch", "enable");
	}

	// unnamed block (timer)
	void SummonIceWall_Timer()
	{
		CallEventDelayed(0.5f, "SummonIceWall_Timer");
		if (!SCANNING)
			return;
		LegacyCommand("emitsound", ENT_ME, RelativePosition(Vector3(0, 0, 0)), 10, 0.25f, "combat");
		string playerAbout = FindOneInSphere("any", 200);
		CallExternal(playerAbout, "npcatk_settarget", self);
		if (Float(ScriptVarOf(playerAbout, "STUCK_COUNT")) > 2.0f)
			OnIceDeath();
		if (!IsPlayer(playerAbout))
			return;
		if (!(RangeTo(playerAbout) < 75.0f))
			return;
		OnIceDeath();
	}

	// game_touch
	string SummonIceWall_OnGameTouch(CBaseEntity@ other = null, string hpRange = "", string effectDamage = "")
	{
		string result = "";
		DebugPrint("game_touch " + NameOf(other));
		if (!IsPlayer(other))
			return result;
		OnIceDeath();
		return result;
	}

	// game_spawn
	// #include monsters/base_npc
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		SetHealth(15);
		SetWidth(64);
		SetHeight(64);
		SetName("Ice Wall");
		SetRoam(false);
		SetDamageTaken("fire", 10);
		SetSkillLevel(0);
		SetHearingSensitivity(0);
		SetModel("misc/icewall.mdl");
		SetBlood("none");
		SetRace("hated");

		LegacyCommand("setturnrate", 0.01f);

		CallEventDelayed(0.0f, "icewall_up"); // Plays the up animation
		CallEventDelayed(30.0f, "ice_death"); // Die in 30 seconds
	}

	// game_dynamically_created
	// #include monsters/base_npc_attack
	void OnGameDynamicallyCreated(string creatorValue1 = "", string creatorValue2 = "", string damage = "", string skill = "", string extraValue5 = "", string extraValue6 = "", float alwaysPush = 0.0f, string duration = "", string extraValue9 = "")
	{
		creatorValue1 = Text(Float(creatorValue1) + 90.0f);
		SetAngle("face.y", creatorValue1);
		if (Float(damage) > 1.0f)
		{
			float finalHp = Float(damage);
			finalHp *= 2.0f;
			SetHealth(finalHp);
		}
		if (!SCANNING)
			SCANNING = true;
		if (creatorValue2 != "firstcast")
			return;

		rotate = AnglesOf(ENT_ME).y + 90.0f;
		r1 = RandomInt(50, 70);
		r2 = RandomInt(50, 70) * -1.0f;
		f1 = RandomInt(-5, 5);
		f2 = RandomInt(-5, 5);

		CreateNpc("monsters/summon/summon_ice_wall", RelativePosition(Vector3(f1, r1, 0)), rotate, 1);
		CreateNpc("monsters/summon/summon_ice_wall", RelativePosition(Vector3(f2, r2, 0)), rotate, 1);
	}

	// icewall_up
	void OnIcewallUp()
	{
		PlayAnim("hold", "up");
	}

	// game_death
	void OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		OnIceDeath();
	}

	// ice_death
	void OnIceDeath()
	{
		// originally waterball1.spr - merged with blueflare1.spr for item limit
		SetCallback("touch", "disable");
		Effect("tempent", "trail", "blueflare1.spr", RelativePosition(Vector3(0, 0, 0)), RelativePosition(Vector3(0, 0, 32)), 2, 0.1f, 3, 30, 0);
		Effect("tempent", "trail", "blueflare1.spr", RelativePosition(Vector3(0, 0, 32)), RelativePosition(Vector3(0, 0, 64)), 2, 0.1f, 3, 30, 0);
		Effect("tempent", "trail", "blueflare1.spr", RelativePosition(Vector3(0, 0, 64)), RelativePosition(Vector3(0, 0, 96)), 5, 0.1f, 3, 30, 0);
		DeleteMe();
	}

	string OnGameTouch(CBaseEntity@ other = null, string hpRange = "", string effectDamage = "") { return SummonIceWall_OnGameTouch(other, hpRange, effectDamage); } // game_touch

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("blueflare1.spr");
		Precache("misc/icewall.mdl");
		CallEventDelayed(0.5f, "SummonIceWall_Timer");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		SummonIceWall_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "game_death") { OnGameDeath(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_dynamically_created") { OnGameDynamicallyCreated(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Float(Param(params, 6)), Param(params, 7), Param(params, 8)); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "game_touch") { Return(OnGameTouch(EntityParam(params, 0), Param(params, 1), Param(params, 2))); return true; }
		if (name == "ice_death") { OnIceDeath(); return true; }
		if (name == "icewall_up") { OnIcewallUp(); return true; }
		if (name == "SummonIceWall_Timer") { SummonIceWall_Timer(); return true; }
		return false;
	}
}
