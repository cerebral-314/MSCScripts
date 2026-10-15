#pragma context server

// Converted from traps/ice_wall.script by msc_transpiler.
// Ice Wall Trap by Thothie (from Summon_Ice_wall)

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_npc.as"
#include "converted/monsters/base_npc_attack.as"

[script "traps/ice_wall"]
class TrapsIceWall : BaseNpcAttackScript
{
	// Variables (an unset .script variable reads as its own name)
	float rotate = 0.0f;
	int r1 = 0;
	float r2 = 0.0f;
	int f1 = 0;
	int f2 = 0;

	// unnamed block (first think)
	void TrapsIceWall_FirstThink()
	{
		ANIM_DEATH = "";
		CAN_ATTACK = "0";
		CAN_HUNT = "0";
	}

	// game_dynamically_created
	void OnGameDynamicallyCreated(string creatorValue1 = "", string creatorValue2 = "", string damage = "", string skill = "", string extraValue5 = "", string extraValue6 = "", float alwaysPush = 0.0f, string duration = "", string extraValue9 = "")
	{
		BaseSelfAdjust_OnGameDynamicallyCreated(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/base_self_adjust
		BaseSelfAdjust_OnGameDynamicallyCreated_2(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/base_self_adjust

		creatorValue1 = Text(Float(creatorValue1) + 90.0f);
		SetAngle("face.y", creatorValue1);
		if (!creatorValue2.isEmpty())
			return;
		rotate = AnglesOf(ENT_ME).y + 90.0f;
		r1 = RandomInt(50, 70);
		r2 = RandomInt(50, 70) * -1.0f;
		f1 = RandomInt(-5, 5);
		f2 = RandomInt(-5, 5);
		CreateNpc("traps/ice_wall", RelativePosition(Vector3(f1, r1, 0)), rotate, 1);
		CreateNpc("traps/ice_wall", RelativePosition(Vector3(f2, r2, 0)), rotate, 1);
		CreateNpc("traps/ice_wall", RelativePosition(Vector3(f1, f1, 0)), rotate, 1);
		CreateNpc("traps/ice_wall", RelativePosition(Vector3(r2, r2, 0)), rotate, 1);
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		SetHealth(30);
		// ov 360
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

		CallEventDelayed(0.0f, "icewall_up"); // Plays the up animation
	}

	// icewall_up
	void OnIcewallUp()
	{
		PlayAnim("hold", "up");
	}

	// npc_death
	void OnNpcDeath()
	{
		Effect("tempent", "trail", "blueflare1.spr", RelativePosition(Vector3(0, 0, 0)), RelativePosition(Vector3(0, 0, 32)), 2, 0.1f, 3, 30, 0);
		Effect("tempent", "trail", "blueflare1.spr", RelativePosition(Vector3(0, 0, 32)), RelativePosition(Vector3(0, 0, 64)), 2, 0.1f, 3, 30, 0);
		Effect("tempent", "trail", "blueflare1.spr", RelativePosition(Vector3(0, 0, 64)), RelativePosition(Vector3(0, 0, 96)), 5, 0.1f, 3, 30, 0);
		DeleteMe();
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("misc/icewall.mdl");
		CallEventDelayed(Float(CYCLE_TIME), "hunting_mode_go");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		TrapsIceWall_FirstThink();
		BaseNpc_FirstThink();
		MonstersExternals_FirstThink();
		BaseNpcAttack_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "game_dynamically_created") { OnGameDynamicallyCreated(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Float(Param(params, 6)), Param(params, 7), Param(params, 8)); return true; }
		if (name == "icewall_up") { OnIcewallUp(); return true; }
		if (name == "npc_death") { OnNpcDeath(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		return BaseNpcAttackScript::DispatchEvent(name, params);
	}
}
