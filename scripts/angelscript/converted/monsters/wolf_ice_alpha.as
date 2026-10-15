#pragma context server

// Converted from monsters/wolf_ice_alpha.script by msc_transpiler.
// larger ice wolf with uber blizzard and charge/knockback attack

#include "runtime/ScriptEntity.as"
#include "converted/monsters/wolf_base.as"

[script "monsters/wolf_ice_alpha"]
class WolfIceAlpha : WolfBaseScript
{
	// Constants
	bool CUSTOM_WOLF = true;
	bool AM_ALPHA = true;
	float DOT_BURN = 70.0f;
	float FREQ_COMBAT_HOWL = 30.0f;
	string CHANCE_BURN = "30%";
	string SOUND_BURN = "magic/frost_reverse.wav";
	float FREQ_LEAP = 15.0f;
	float DMG_STORM = 20.0f;
	float STORM_DUR = 20.0f;
	int STORM_RAD = 800;

	// Variables (an unset .script variable reads as its own name)
	bool DOING_HOWL = false;
	bool CYCLES_STARTED = false;
	bool LEAP_DELAY = false;
	bool DID_BOOST = false;
	bool CHARGE_ATTACK = false;

	// Variables declared by included files, with the value they start with in this script
	WolfIceAlpha()
	{
		NPC_BOSS_REGEN_RATE = 0.05f;
		NPC_BOSS_RESTORATION = 0.25f;
		CHANCE_CLAW = 5;
		MONSTER_MODEL = "monsters/wolf_huge.mdl";
	}

	// unnamed block (first think)
	void WolfIceAlpha_FirstThink()
	{
		if (StartsWith(ToLowerCase(MapName()), "lodagond"))
		{
			NPC_IS_BOSS = true;
			NPC_GIVE_EXP = 8000.0f;
		}
		else
		{
			NPC_GIVE_EXP = 2000.0f;
		}

		ATTACK_RANGE = 92.0f;
		ATTACK_HITRANGE = 128.0f;
		ATTACK_MOVERANGE = 72.0f;
	}

	// game_dodamage
	string WolfIceAlpha_OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";

		if (hit && !DOING_HOWL && !CHARGE_ATTACK && RandomInt(1, 100) < Float(CHANCE_BURN) && RelationshipOf(target, ENT_ME) == "enemy")
		{
			ApplyEffect(target, "effects/dot_cold", 10, self, DOT_BURN);
			PlaySound(0, 10, SOUND_BURN);
			Effect("glow", ENT_ME, Vector3(0, 75, 255), 128, 1, 1);
		}

		if (!DOING_HOWL)
			return result;
		if (RelationshipOf(target, ENT_ME) != "enemy")
			return result;
		ApplyEffect(target, "effects/dot_cold_freeze", 5, 1, 1);
		DOING_HOWL = false;
		return result;
	}

	// game_precache
	void OnGamePrecache()
	{
		PrecacheFile("monsters/summon/uber_blizzard");
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseNpcAttackNew_OnNpcSpawn(npc); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck
		WolfBase_OnNpcSpawn(npc); // monsters/wolf_base

		SetName("Winter Alpha Wolf");
		if (Contains(ToLowerCase(MapName()), "aleyesu"))
			SetRace("demon");
		else
			SetRace("rogue");
		SetModel(MONSTER_MODEL);
		SetWidth(48);
		SetHeight(72);
		SetRoam(true);
		SetHealth(9000);
		SetDamageTaken("fire", 1.25f);
		SetDamageTaken("cold", 0);
		SetModelBody(0, 1);
		SetHearingSensitivity(8);

		NEXT_HOWL = 0.0f;
		SetGlobal("G_ALPHA", self); // lesser wolves consider me alpha
	}

	// npcatk_attack
	void OnNpcatkAttack()
	{
		BaseNpcAttackNew_OnNpcatkAttack(); // monsters/base_npc_attack_new

		if (ANIM_ATTACK == "attack2" && !DID_BOOST)
		{
			DID_BOOST = true;
			AddVelocity(ENT_ME, RelativeVelocity(Vector3(0, 400, 50)));
			CHARGE_ATTACK = true;
			CallEventDelayed(1.0f, "reset_charge_attack");
			OnChargeLoop();
		}

		if (ANIM_ATTACK != "attack2")
			DID_BOOST = false;
	}

	// game_dodamage
	string OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";
		result = AppendResult(result, BaseNpcAttackNew_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BaseAntiStuck_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BaseMonsterShared_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, WolfBase_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, WolfIceAlpha_OnGameDodamage(hit, target, start, end, damageType, damageText));
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
		// ice blast howl
		if (CYCLED_UP)
		{
			DOING_HOWL = true;
			PlayAnim("critical", ANIM_HOWL);
			PlayRandomSound(0, 10, SOUND_HOWL1, SOUND_HOWL2);
			OnIceStorm();
			DoDamage(Text(RelativePosition(Vector3(0, 0, 0))), 512, 0, "100%", 0.0f, "reflective", "target");
			ApplyEffect(ENT_ME, "effects/iceshield", 20, self, 0.4f); // <who_applied> <FINAL_DURATION> <ICESHIELD_FORMULA>
		}
		CallEventDelayed(0.1f, "end_combat_howl");
	}

	// end_combat_howl
	void OnEndCombatHowl()
	{
		PlaySound(0, 10, "magic/cast.wav"); // ice shield init sound
		DOING_HOWL = false;
		CallEventDelayed(FREQ_COMBAT_HOWL, "do_combat_howl");
	}

	// bite1
	void OnBite1()
	{
		ATTACK_TYPE = "bite";
		OnNpcatkDodamage(NPCATK_TARGET, Text(ATTACK_HITRANGE), Text(DMG_BITE), ATTACK_HITCHANCE, "slash");
		OnAtkSound();
		if (!(RandomInt(1, 100) < CHANCE_CLAW))
			return;
		if (LEAP_DELAY)
			return;
		LEAP_DELAY = true;
		CallEventDelayed(FREQ_LEAP, "reset_leap_delay");
		ANIM_ATTACK = ANIM_CLAW;
	}

	// reset_leap_delay
	void OnResetLeapDelay()
	{
		LEAP_DELAY = false;
	}

	// reset_charge_attack
	void OnResetChargeAttack()
	{
		CHARGE_ATTACK = false;
	}

	// charge_loop
	void OnChargeLoop()
	{
		if (!CHARGE_ATTACK)
			return;
		CallEventDelayed(0.1f, "charge_loop");

		// dodamage $relpos(0,32,0) 96 20 100% 0.0 reflective target
		DoDamageEx(RelativePosition(Vector3(0, 32, 0)), 96, 20, "100%", ENT_ME, ENT_ME, "none", "target", "dmgevent:push");
	}

	// push_dodamage
	void OnPushDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		if (RelationshipOf(target, ENT_ME) != "enemy")
			return;
		AddVelocity(target, RelativeVelocity(Vector3(0, 1000, 0)));
	}

	// ice_storm
	void OnIceStorm()
	{
		// dbg ice storm
		Vector3 blizLoc = RelativePosition(Vector3(0, 0, 0));
		CBaseEntity@ summonPoint1 = FindByName("summon_point1");
		if (Exists(summonPoint1))
			blizLoc = OriginOf(summonPoint1);

		CreateNpc("monsters/summon/uber_blizzard", blizLoc, self, DMG_STORM, STORM_DUR, STORM_RAD, "30%");

		SetVar("PLAYER_LIST", GetActivePlayers());

		int count = GetTokenCount("PLAYER_LIST");
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnFadeBlue();
		}
	}

	// fade_blue
	void OnFadeBlue()
	{
		string checkEnt = GetToken("PLAYER_LIST", loopIteration);

		if (!(RangeTo(checkEnt) < STORM_RAD))
			return;

		Effect("screenfade", checkEnt, 5, 0, Vector3(0, 0, 192), 128, "fadein");
	}

	// npcatk_set_skill
	void OnNpcatkSetSkill()
	{
		string mapName = ToLowerCase(MapName());

		if (NPC_IS_BOSS)
			NPC_GIVE_EXP = 4000.0f;
		if (!NPC_IS_BOSS)
			NPC_GIVE_EXP = 1000.0f;

		if (Contains(mapName, "lodagond"))
			NPC_GIVE_EXP *= 1.75f;
		if (Contains(mapName, "old_helena"))
			NPC_GIVE_EXP *= 0.5f;
		if (NPC_GIVE_EXP != 0.0f)
			SetSkillLevel(NPC_GIVE_EXP);
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files
	void OnFreqCombatHowl() {} // FREQ_COMBAT_HOWL
	void OnFreqLeap() {} // FREQ_LEAP

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/normal_wolf.mdl");
		Precache("monsters/wolf_huge.mdl");
		CallEventDelayed(FREQ_IDLE, "WolfBase_Timer");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		WolfIceAlpha_FirstThink();
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
		if (name == "bite1") { OnBite1(); return true; }
		if (name == "charge_loop") { OnChargeLoop(); return true; }
		if (name == "cycle_up") { OnCycleUp(Param(params, 0)); return true; }
		if (name == "do_combat_howl") { OnDoCombatHowl(); return true; }
		if (name == "end_combat_howl") { OnEndCombatHowl(); return true; }
		if (name == "fade_blue") { OnFadeBlue(); return true; }
		if (name == "game_dodamage") { Return(OnGameDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5))); return true; }
		if (name == "game_precache") { OnGamePrecache(); return true; }
		if (name == "ice_storm") { OnIceStorm(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "npcatk_attack") { OnNpcatkAttack(); return true; }
		if (name == "npcatk_set_skill") { OnNpcatkSetSkill(); return true; }
		if (name == "push_dodamage") { OnPushDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5)); return true; }
		if (name == "reset_charge_attack") { OnResetChargeAttack(); return true; }
		if (name == "reset_leap_delay") { OnResetLeapDelay(); return true; }
		return WolfBaseScript::DispatchEvent(name, params);
	}
}
