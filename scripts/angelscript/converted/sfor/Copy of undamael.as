#pragma context server

// Converted from sfor/Copy of undamael.script by msc_transpiler.
// Thothie - for MS 1.35 compatibility
// - This undmael does not attack or play greeting sounds.
// - Has been used in past maps to spawn Undamael, make him say something threatening, then Vanish

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_monster.as"

[script "sfor/Copy of undamael"]
class CopyOfUndamael : BaseMonsterScript
{
	// Variables (an unset .script variable reads as its own name)
	bool SEE_ENEMY = false;
	bool IGNORE_ENEMY = true;

	// Variables declared by included files, with the value they start with in this script
	CopyOfUndamael()
	{
		ANIM_IDLE = "idle1";
	}

	// unnamed block (first think)
	void CopyOfUndamael_FirstThink()
	{
		ANIM_IDLE = "idle1";
		MOVE_RANGE = "0";
		SEE_ENEMY = false;
		IGNORE_ENEMY = true;
		CAN_FLINCH = "0";
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck

		SetName("|Lord Undamael");
		SetInvincible(true);
		SetHealth(2900);
		SetGold(RandomInt(100, 400));
		SetFieldOfView(359);
		SetWidth(50);
		SetHeight(128);
		SetRace("undead");
		SetRoam(false);
		SetHearingSensitivity(0);
		SetSkillLevel(400);
		SetModel("monsters/skeleton_hood.mdl");
		SetModelBody(0, 0);
		SetIdleAnim(ANIM_IDLE);
	}

	// fade_away
	// called by ms_npcscript
	void OnFadeAway()
	{
		DeleteEntity(ENT_ME, "fade");
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("lgtning.spr");
		Precache("monsters/skeleton_hood.mdl");
		CallEventDelayed(Float(CYCLE_TIME), "hunting_mode_go");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		CopyOfUndamael_FirstThink();
		BaseNpcAttack_FirstThink();
		BaseNpc_FirstThink();
		MonstersExternals_FirstThink();
		BaseMonsterShared_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "fade_away") { OnFadeAway(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		return BaseMonsterScript::DispatchEvent(name, params);
	}
}
