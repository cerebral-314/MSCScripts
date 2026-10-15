#pragma context server

// Converted from roghan/test_boss.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_monster_new.as"

[script "roghan/test_boss"]
class TestBoss : BaseMonsterNewScript
{
	// Constants
	string ANIM_SWING = "swordswing1_L";
	string ANIM_SMASH = "battleaxe_swing1_L";
	int DMG_SWING = 0;
	string DMG_SMASH = "DMG_SMASH";
	string ATTACK_HITCHANCE = "80";
	string SOUND_ATTACK1 = "voices/orc/attack.wav";
	string SOUND_ATTACK2 = "voices/orc/attack2.wav";
	string SOUND_ATTACK3 = "voices/orc/attack3.wav";
	string SOUND_STRUCK1 = "body/armour1.wav";
	string SOUND_STRUCK2 = "body/armour2.wav";
	string SOUND_STRUCK3 = "body/armour3.wav";
	string SOUND_PAIN = "monsters/orc/pain.wav";
	string MONSTER_MODEL = "monsters/Orc.mdl";

	// Variables (an unset .script variable reads as its own name)
	string ANIM_ATTACK = "ANIM_ATTACK";
	int MAX_SPIRITS = 0;
	float SUM_SPIRITS = 0.0f;
	float PHASE_NUM = 0.0f;
	int SPIRIT_SIDE = 0;
	float BOB_UP = 0.0f;

	// Variables declared by included files, with the value they start with in this script
	TestBoss()
	{
		ANIM_RUN = "run";
		ANIM_WALK = "walk";
		ANIM_IDLE = "idle1";
		SOUND_DEATH = "voices/orc/die.wav";
	}

	// unnamed block (first think)
	void TestBoss_FirstThink()
	{
		ANIM_ATTACK = "attack1";

		ANIM_RUN = "run"; // walk anim
		ANIM_WALK = "walk"; // run anim
		ANIM_IDLE = "idle1"; // idle anim

		MOVE_RANGE = "64";
		ATTACK_RANGE = 80.0f;
		ATTACK_HITRANGE = 120.0f;
	}

	// game_damaged
	// PARAM1=attacker PARAM2=dmg PARAM3=dmg_type   //not used yet but left for later
	string TestBoss_OnGameDamaged(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float accuracyRoll = 0.0f, CBaseEntity@ inflictor = null, string skill = "")
	{
		string result = "";

		PlayRandomSound(0, 8, SOUND_PAIN, "SOUND_PAIN2", "none", "none");
		return result;
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseNpcAttackNew_OnNpcSpawn(npc); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck

		SetName("Elemental Master");

		SetRace("evil");

		SetHealth(1000);

		SetModel(MONSTER_MODEL);
		SetWidth(32);
		SetHeight(72);

		SetSayTextRange(10000);

		SetMoveAnim(ANIM_RUN);
		SetIdleAnim(ANIM_IDLE);

		SetDamageTaken("all", 0.7f);
		SetDamageTaken("fire", 1.25f);
		SetDamageTaken("cold", 0.25f);

		SetInvincible(true);

		MAX_SPIRITS = 6; // Nax number of spirits to spawn
		SUM_SPIRITS = 0.0f; // How many spirits have been summoned so far
		PHASE_NUM = 1.0f; // What phase it is
		SPIRIT_SIDE = 1; // Which side to spawn the next spirit on
		BOB_UP = 0.0f; // Will help keep boss from slowly falling

		CreateNpc("roghan/test_npc", RelativePosition(Vector3(45, -1000, 0)));

		SetAngle("face", ENT_LASTCREATED);
		OnNpcatkSuspendAi();
	}

	// game_damaged - Return a damage multiplier to scale the damage
	string OnGameDamaged(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float accuracyRoll = 0.0f, CBaseEntity@ inflictor = null, string skill = "")
	{
		string result = "";
		result = AppendResult(result, BaseAntiStuck_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, BaseMonsterShared_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, BaseMonsterShared_OnGameDamaged_2(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, TestBoss_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		return result;
	}

	// swing_sword
	// not used but left in for later
	void OnSwingSword()
	{
		OnNpcatkDodamage(NPCATK_TARGET, Text(ATTACK_HITRANGE), "DMG_SWIPE", ATTACK_HITCHANCE, "slash");
	}

	// swing_axe
	// not used but left in for later
	void OnSwingAxe()
	{
		OnNpcatkDodamage(NPCATK_TARGET, Text(ATTACK_HITRANGE), DMG_SMASH, ATTACK_HITCHANCE, "slash");
	}

	// begin_float
	void OnBeginFloat()
	{
		OnNpcatkSuspendAi();
		PlayAnim("break");
		OnNpcatkClearTargets();
		SetGravity(0);
		CreateNpc("roghan/crystal", RelativePosition(Vector3(0, -150, 0)));
		AddVelocity(ENT_ME, RelativeVelocity(Vector3(0, 0, 100)));
		CallEventDelayed(2.0f, "bob_float");
		CallEventDelayed(1.0f, "phase_choose");
	}

	// bob_float
	void OnBobFloat()
	{
		if (BOB_UP == 0.0f)
		{
			SetVelocity(ENT_ME, Vector3(0, 0, 5));
			BOB_UP += 1.0f;
		}
		else
		{
			SetVelocity(ENT_ME, Vector3(0, 0, -2.5f));
			BOB_UP = 0.0f;
		}
		if (PHASE_NUM == 1.0f)
		{
			CallEventDelayed(3.0f, "bob_float");
		}
		else
		{
			SetGravity(1); // Once phase 1 is over drop the boss to the ground
		}
	}

	// phase_choose
	void OnPhaseChoose()
	{
		if (PHASE_NUM == 1.0f)
		{
			SayText("Fools! Now feel the power of my Ice Spirits!");
			OnSpiritSummon();
			OnIcePulse();
		}
	}

	// spirit_summon
	void OnSpiritSummon()
	{
		if (SUM_SPIRITS < MAX_SPIRITS)
		{
			if (SPIRIT_SIDE == 1)
			{
				CreateNpc("roghan/slow_walk", RelativePosition(Vector3(150, 0, 0)));
				SPIRIT_SIDE = 0;
				SUM_SPIRITS += 1.0f;
				CallEventDelayed(5.0f, "spirit_summon");
			}
			else
			{
				CreateNpc("roghan/slow_walk", RelativePosition(Vector3(-150, 0, 0)));
				SPIRIT_SIDE = 1;
				SUM_SPIRITS += 1.0f;
				CallEventDelayed(5.0f, "spirit_summon");
			}
		}
		else
		{
			PHASE_NUM += 1.0f; // Phase 1 will eventually end when all spirits are dead, as of now Phase 1 ends as soon as they stop spawning
		}
	}

	// ice_pulse
	void OnIcePulse()
	{
		Vector3 myPos = OriginOf(ENT_ME);
		if (PHASE_NUM == 1.0f) {}
		DoDamageEx(myPos, 100000, 0.5f, 0, ENT_ME, ENT_ME, "none", "cold_effect"); // This is the ice pulse. When done it will do double damage after each pulse, can't do now cause it would kill
		CallEventDelayed(3.0f, "ice_pulse"); // Only pulse while in phase 1
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/Orc.mdl");
		Precache("nimble/crystal.mdl");
		Precache("npc/balancepriest1.mdl");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		TestBoss_FirstThink();
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
		if (name == "begin_float") { OnBeginFloat(); return true; }
		if (name == "bob_float") { OnBobFloat(); return true; }
		if (name == "game_damaged") { Return(OnGameDamaged(EntityParam(params, 0), Float(Param(params, 1)), Param(params, 2), Float(Param(params, 3)), EntityParam(params, 4), Param(params, 5))); return true; }
		if (name == "ice_pulse") { OnIcePulse(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "phase_choose") { OnPhaseChoose(); return true; }
		if (name == "spirit_summon") { OnSpiritSummon(); return true; }
		if (name == "swing_axe") { OnSwingAxe(); return true; }
		if (name == "swing_sword") { OnSwingSword(); return true; }
		return BaseMonsterNewScript::DispatchEvent(name, params);
	}
}
