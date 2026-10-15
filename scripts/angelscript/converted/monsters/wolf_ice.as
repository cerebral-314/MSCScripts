#pragma context server

// Converted from monsters/wolf_ice.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/wolf_base.as"

[script "monsters/wolf_ice"]
class WolfIce : WolfBaseScript
{
	// Constants
	string NPC_PET_SCRIPT = "monsters/companion/pet_wolf_ice";
	bool CUSTOM_WOLF = true;
	bool AM_ALPHA = false;
	float DOT_BURN = 70.0f;
	float FREQ_COMBAT_HOWL = 0.0f;
	string CHANCE_BURN = "30%";
	string SOUND_BURN = "magic/frost_reverse.wav";

	// Variables (an unset .script variable reads as its own name)
	string NPC_PET_TYPE = "NPC_PET_TYPE";
	bool DOING_HOWL = false;
	bool CYCLES_STARTED = false;

	// unnamed block (first think)
	void WolfIce_FirstThink()
	{
		NPC_PET_TYPE = "wolf_ice"; // tells charm that this can be tamed

		if (Contains(ToLowerCase(MapName()), "lodagond"))
		{
			NPC_GIVE_EXP = 800.0f; // lodagond mons have insane xp
		}
		else
		{
			NPC_GIVE_EXP = 400.0f;
		}
	}

	// game_dodamage
	string WolfIce_OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";

		if (!DOING_HOWL)
			return result;
		if (RelationshipOf(target, ENT_ME) != "enemy")
			return result;
		PlayerMessage(target, "You hear a chilling howl!");
		ApplyEffect(target, "effects/dot_cold_freeze", 5, ENT_ME, 1);
		DOING_HOWL = false;
		return result;
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseNpcAttackNew_OnNpcSpawn(npc); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck
		WolfBase_OnNpcSpawn(npc); // monsters/wolf_base

		SetName("Winter Wolf");
		SetRace("demon");
		SetModel(MONSTER_MODEL);
		SetWidth(36);
		SetHeight(48);
		SetRoam(true);
		SetHealth(2000);
		SetDamageTaken("all", 0.5f); // ice shield
		SetDamageTaken("fire", 1.25f);
		SetDamageTaken("cold", 0);
		SetModelBody(0, 2);
		SetHearingSensitivity(8);

		NEXT_HOWL = 0.0f;
	}

	// game_dodamage
	string OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";
		result = AppendResult(result, BaseNpcAttackNew_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BaseAntiStuck_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BaseMonsterShared_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, WolfBase_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, WolfIce_OnGameDodamage(hit, target, start, end, damageType, damageText));
		return result;
	}

	// cycle_up
	void OnCycleUp(string reason = "")
	{
		BaseNpcAttackNew_OnCycleUp(reason); // monsters/base_npc_attack_new
		WolfBase_OnCycleUp(reason); // monsters/wolf_base

		if (CYCLES_STARTED)
			return;
		CYCLES_STARTED = true;
		CallEventDelayed(FREQ_COMBAT_HOWL, "do_combat_howl");
	}

	// do_combat_howl
	void OnDoCombatHowl()
	{
		// stunning howl
		if (I_R_FROZEN)
			return;
		DOING_HOWL = true;
		PlayAnim("critical", ANIM_HOWL);
		PlayRandomSound(0, 10, SOUND_HOWL1, SOUND_HOWL2);
		DoDamage(Text(OriginOf(ENT_ME)), 200, 0, "100%", 0.0f, "normal", "target");
		CallEventDelayed(0.1f, "end_combat_howl");
	}

	// end_combat_howl
	void OnEndCombatHowl()
	{
		DOING_HOWL = false;
		CallEventDelayed(FREQ_COMBAT_HOWL, "do_combat_howl");
	}

	// wolfatk_dodamage
	void OnWolfatkDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		if (hit && RandomInt(1, 100) < Float(CHANCE_BURN) && RelationshipOf(target, ENT_ME) == "enemy")
		{
			ApplyEffect(target, "effects/dot_cold", 10, self, DOT_BURN);
			PlaySound(0, 10, SOUND_BURN);
			Effect("glow", ENT_ME, Vector3(0, 75, 255), 128, 1, 1);
		}
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files
	void OnFreqCombatHowl() {} // FREQ_COMBAT_HOWL

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		WolfIce_FirstThink();
		WolfBase_FirstThink();
		BaseNpc_FirstThink();
		MonstersExternals_FirstThink();
		BaseNpcAttackNew_FirstThink();
		BaseMonsterShared_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "cycle_up") { OnCycleUp(Param(params, 0)); return true; }
		if (name == "do_combat_howl") { OnDoCombatHowl(); return true; }
		if (name == "end_combat_howl") { OnEndCombatHowl(); return true; }
		if (name == "game_dodamage") { Return(OnGameDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5))); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "wolfatk_dodamage") { OnWolfatkDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5)); return true; }
		return WolfBaseScript::DispatchEvent(name, params);
	}
}
