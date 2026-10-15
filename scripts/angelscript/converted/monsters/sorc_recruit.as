#pragma context server

// Converted from monsters/sorc_recruit.script by msc_transpiler.
// weakest of the Shadahar Orc series

#include "runtime/ScriptEntity.as"
#include "converted/monsters/orc_base_melee.as"
#include "converted/monsters/sorc_base.as"

[script "monsters/sorc_recruit"]
class SorcRecruit : SorcBaseScript, OrcBaseMelee
{
	// Constants
	string ATTACK_ACCURACY = "70%";
	float DMG_SWORD = 0.0f;
	float FREQ_LUNGE = 10.0f;
	int LUNGE_RANGE = 256;

	// Variables (an unset .script variable reads as its own name)
	string ANIM_ATTACK1 = "ANIM_ATTACK1";
	string ANIM_ATTACK2 = "ANIM_ATTACK2";
	bool LUNGE_DELAY = false;
	string LEAP_TARGET = "LEAP_TARGET";
	bool DID_LEAPSTUN = false;
	bool LEAPING = false;
	float LEAP_END = 0.0f;

	// unnamed block (first think)
	void SorcRecruit_FirstThink()
	{
		DROP_GOLD = 1; // Gold Drops
		DROP_GOLD_AMT = RandomInt(15, 30);
		NPC_GIVE_EXP = 100.0f;

		ANIM_ATTACK1 = "swordswing1_L"; // Attack animation 1
		ANIM_ATTACK2 = "battleaxe_swing1_L"; // Attack animation 2
		FLINCH_CHANCE = "25%";

		ANIM_ATTACK = ANIM_ATTACK1;

		ORC_JUMPER = true;
	}

	// orc_spawn
	void OnOrcSpawn()
	{
		OrcBaseMelee_OnOrcSpawn(); // monsters/orc_base_melee

		SetName("Shadahar Novice");
		SetModel("monsters/sorc.mdl");
		SetHealth(500);
		SetDamageTaken("all", 0.7f);
		SetStat("parry", 110);

		SetWidth(32);
		SetHeight(96);

		SetModelBody(0, 0); // body: 0=bare 1=bloody_shirt 2=gold_armor 3=archer
		SetModelBody(1, 1); // head: 0=hat_horns 1=hat_spiked 2=lizardskin_horned 3=gold_Chieftain 4=lizard_cap
		SetModelBody(2, 6); // weapon: 0=unarmed 1=axe 2=bow 3=steel_bow 4=sword 5=great_axe 6=sword_sheild 8=yellow_axe 9=blooddrinker
	}

	// npc_targetsighted
	void OnNpcTargetsighted(string target = "")
	{
		BaseMonsterShared_OnNpcTargetsighted(target); // monsters/base_monster_shared
		SorcBase_OnNpcTargetsighted(target); // monsters/sorc_base

		if (I_R_FROZEN)
			return;
		if (LUNGE_DELAY)
			return;
		if (!(RangeTo(NPCATK_TARGET) < LUNGE_RANGE))
			return;

		LUNGE_DELAY = true;
		CallEventDelayed(FREQ_LUNGE, "reset_lunge_delay");
		OnLeapAt(NPCATK_TARGET);
	}

	// swing_axe
	void OnSwingAxe()
	{
		OnBaseorcYell();

		OnNpcatkDodamage(ENT_LASTSEEN, Text(ATTACK_HITRANGE), Text(DMG_SWORD), ATTACK_ACCURACY);
	}

	// reset_lunge_delay
	void OnResetLungeDelay()
	{
		LUNGE_DELAY = false;
	}

	// leap_at
	// <target>
	void OnLeapAt(string target = "")
	{
		AS_ATTACKING = GameTime() + 3.0f;
		NPC_FORCED_MOVEDEST = true;
		LEAP_TARGET = target;
		OnNpcatkSuspendAi("1.0");
		SetMoveDest(LEAP_TARGET, MOVE_RANGE);
		CallEventDelayed(0.1f, "leap_at2");
		DID_LEAPSTUN = false;
		LEAPING = true;
		LEAP_END = GameTime() + 1.0f;
		OnLeapScan();
	}

	// leap_scan
	void OnLeapScan()
	{
		if (!(GameTime() < LEAP_END))
			return;
		CallEventDelayed(0.1f, "leap_scan");
		// dbg temp leap_scan $get(LEAP_TARGET,name) $get(LEAP_TARGET,range)
		if (!(RangeTo(LEAP_TARGET) < ATTACK_RANGE))
			return;

		AddVelocity(LEAP_TARGET, RelativeVelocity(Vector3(0, 120, 105)));
		if (DID_LEAPSTUN)
			return;
		DID_LEAPSTUN = true;
		ApplyEffect(LEAP_TARGET, "effects/debuff_stun", 2, self);
	}

	// leap_at2
	void OnLeapAt2()
	{
		PlayRandomSound(0, 10, "voices/orc/hit.wav", "voices/orc/hit2.wav", "voices/orc/hit3.wav");
		PlayAnim("critical", ANIM_ATTACK2);
		CallEventDelayed(0.1f, "leap_boost");
	}

	// leap_boost
	void OnLeapBoost()
	{
		AddVelocity(ENT_ME, RelativeVelocity(Vector3(0, 350, 120)));
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files

	// npcatk_targetvalidate
	void OnNpcatkTargetvalidate(string target = "")
	{
		OrcBaseMelee_OnNpcatkTargetvalidate(target); // monsters/orc_base_melee
		BaseNpcAttackNew_OnNpcatkTargetvalidate(target); // monsters/base_npc_attack_new
		SorcBase_OnNpcatkTargetvalidate(target); // monsters/sorc_base
	}

	// my_target_died
	void OnMyTargetDied(string offender = "")
	{
		OrcBaseMelee_OnMyTargetDied(offender); // monsters/orc_base_melee
		BaseNpcAttackNew_OnMyTargetDied(offender); // monsters/base_npc_attack_new
	}

	void OnBaseorcYell() { SorcBase_OnBaseorcYell(); } // baseorc_yell
	void OnFreqLunge() {} // FREQ_LUNGE

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/sorc.mdl");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		SorcRecruit_FirstThink();
		OrcBaseMelee_FirstThink();
		SorcBase_FirstThink();
		BaseNpc_FirstThink();
		MonstersExternals_FirstThink();
		BaseNpcAttackNew_FirstThink();
		BaseMonsterShared_FirstThink();
		SorcBase_FirstThink2();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "leap_at") { OnLeapAt(Param(params, 0)); return true; }
		if (name == "leap_at2") { OnLeapAt2(); return true; }
		if (name == "leap_boost") { OnLeapBoost(); return true; }
		if (name == "leap_scan") { OnLeapScan(); return true; }
		if (name == "npc_targetsighted") { OnNpcTargetsighted(Param(params, 0)); return true; }
		if (name == "orc_spawn") { OnOrcSpawn(); return true; }
		if (name == "reset_lunge_delay") { OnResetLungeDelay(); return true; }
		if (name == "swing_axe") { OnSwingAxe(); return true; }
		return OrcBaseMelee_DispatchEvent(name, params)
			|| SorcBaseScript::DispatchEvent(name, params);
	}
}
