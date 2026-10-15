#pragma context server

// Converted from monsters/sorc_juggernaut.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/orc_base_melee.as"
#include "converted/monsters/sorc_base.as"

[script "monsters/sorc_juggernaut"]
class SorcJuggernaut : SorcBaseScript, OrcBaseMelee
{
	// Constants
	string DMG_KICK = "DMG_KICK";
	string ATTACK_ACCURACY = "70%";
	float DMG_SWORD = 0.0f;
	float FREQ_LUNGE = 10.0f;
	int LUNGE_RANGE = 256;
	string SOUND_WALK1 = "monsters/troll/step1.wav";
	string SOUND_WALK2 = "monsters/troll/step2.wav";
	string SOUND_UPSWING = "monsters/orc/attack1.wav";
	string SOUND_SWINGHIT = "monsters/orc/pain.wav";
	string SOUND_SWINGMISS = "debris/bustmetal2.wav";

	// Variables (an unset .script variable reads as its own name)
	string ANIM_ATTACK1 = "ANIM_ATTACK1";
	string ANIM_ATTACK2 = "ANIM_ATTACK2";
	bool LUNGE_DELAY = false;
	string MY_SCRIPT_IDX = "MY_SCRIPT_IDX";
	string LEAP_TARGET = "LEAP_TARGET";
	bool DID_LEAPSTUN = false;
	bool LEAPING = false;
	float LEAP_END = 0.0f;
	float LAST_SWORD_HIT = 0.0f;

	// Variables declared by included files, with the value they start with in this script
	SorcJuggernaut()
	{
		AS_MAX_ATTACK_TIME = 10.0f;
		SORC_LRESIST = 0.6f;
		SORC_PRESIST = 1.2f;
	}

	// unnamed block (first think)
	void SorcJuggernaut_FirstThink()
	{
		DROP_GOLD = 1; // Gold Drops
		DROP_GOLD_AMT = RandomInt(150, 220);
		NPC_GIVE_EXP = 1750.0f;

		ANIM_ATTACK1 = "battleaxe_swing1_L"; // Attack animation 1
		ANIM_ATTACK2 = "swordswing1_L"; // Attack animation 2
		FLINCH_CHANCE = "25%";

		ANIM_ATTACK = ANIM_ATTACK1;
	}

	// swing_axe
	void SorcJuggernaut_OnSwingAxe()
	{
		OnBaseorcYell();

		OnNpcatkDodamage(ENT_LASTSEEN, Text(ATTACK_HITRANGE), Text(DMG_SWORD), ATTACK_ACCURACY, "slash");
		AddVelocity(ENT_LASTSEEN, RelativeVelocity(Vector3(-120, 120, 150)));

		if (RandomInt(1, 10) != 1)
			return;
		ANIM_ATTACK = "kick";
	}

	// swing_axe
	void SorcJuggernaut_OnSwingAxe_2()
	{
		PlaySound(2, 10, SOUND_SWINGMISS);
	}

	// orc_spawn
	void OnOrcSpawn()
	{
		OrcBaseMelee_OnOrcSpawn(); // monsters/orc_base_melee

		SetName("Shadahar Juggernaut");
		SetModel("monsters/sorc_huge.mdl");
		SetHealth(5000);
		SetDamageTaken("all", 0.5f);
		SetStat("parry", 110);

		SetWidth(48);
		SetHeight(128);

		SetModelBody(0, 0); // body: 0=bare 1=bloody_shirt 2=gold_armor 3=archer
		SetModelBody(1, 0); // head: 0=hat_horns 1=hat_spiked 2=lizardskin_horned 3=gold_Chieftain 4=lizard_cap
		SetModelBody(2, 5); // weapon: 0=unarmed 1=axe 2=bow 3=steel_bow 4=sword 5=great_axe 6=sword_sheild 8=yellow_axe 9=blooddrinker
	}

	// npc_post_spawn
	void OnNpcPostSpawn()
	{
		MonstersExternals_OnNpcPostSpawn(); // monsters/externals
		MonstersExternals_OnNpcPostSpawn_2(); // monsters/externals
		MonstersExternals_OnNpcPostSpawn_3(); // monsters/externals
		BaseSelfAdjust_OnNpcPostSpawn(); // monsters/base_self_adjust
		BaseNpc_OnNpcPostSpawn(); // monsters/base_npc
		BaseMonsterShared_OnNpcPostSpawn(); // monsters/base_monster_shared
		SorcBase_OnNpcPostSpawn(); // monsters/sorc_base
		SorcBase_OnNpcPostSpawn_2(); // monsters/sorc_base
		ATTACK_MOVERANGE = 96.0f;
		ATTACK_RANGE = 128.0f;
		ATTACK_HITRANGE = 200.0f;
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
		SorcJuggernaut_OnSwingAxe();
		SorcJuggernaut_OnSwingAxe_2();
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
		ClientEvent("new", "all", "effects/sfx_motionblur_perm", IndexOf(ENT_ME), 0);
		MY_SCRIPT_IDX = LastClientScriptId();
		NPC_FORCED_MOVEDEST = true;
		OnNpcatkSuspendAi("1.0");
		LEAP_TARGET = target;
		SetMoveDest(target, MOVE_RANGE);
		CallEventDelayed(0.1f, "leap_at2");
		DID_LEAPSTUN = false;
		LEAPING = true;
		LEAP_END = GameTime() + 1.0f;
		OnLeapScan();
		CallEventDelayed(1.0f, "leap_end");
	}

	// leap_end
	void OnLeapEnd()
	{
		ClientEvent("remove", "all", MY_SCRIPT_IDX);
	}

	// leap_scan
	void OnLeapScan()
	{
		if (!(GameTime() < LEAP_END))
			return;
		CallEventDelayed(0.1f, "leap_scan");
		DebugPrint("temp leap_scan " + NameOf(LEAP_TARGET) + " " + Text(RangeTo(LEAP_TARGET)));
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

	// run_step1
	void OnRunStep1()
	{
		PlaySound(2, 8, SOUND_WALK2);
		Effect("screenshake", RelativePosition(Vector3(0, 0, 0)), 128, 10, 1, 256);
	}

	// run_step2
	void OnRunStep2()
	{
		PlaySound(2, 8, SOUND_WALK1);
		Effect("screenshake", RelativePosition(Vector3(0, 0, 0)), 128, 10, 1, 256);
	}

	// swing_start
	void OnSwingStart()
	{
		PlaySound(1, 10, SOUND_UPSWING);
	}

	// kick_land
	void OnKickLand()
	{
		// dbg kick_land PARAM1
		if (RangeTo(NPCATK_TARGET) < ATTACK_RANGE)
			LAST_SWORD_HIT = GameTime();
		OnNpcatkDodamage(NPCATK_TARGET, Text(ATTACK_HITRANGE), DMG_KICK, ATTACK_ACCURACY, "blunt");
		ANIM_ATTACK = "battleaxe_swing1_L";
		if (!(RangeTo(NPCATK_TARGET) < ATTACK_HITRANGE))
			return;
		ApplyEffect(NPCATK_TARGET, "effects/debuff_stun", Random(5, 10), self);
		AddVelocity(NPCATK_TARGET, RelativeVelocity(Vector3(-100, 200, 150)));
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
		Precache("monsters/sorc_huge.mdl");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		SorcJuggernaut_FirstThink();
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
		if (name == "kick_land") { OnKickLand(); return true; }
		if (name == "leap_at") { OnLeapAt(Param(params, 0)); return true; }
		if (name == "leap_at2") { OnLeapAt2(); return true; }
		if (name == "leap_boost") { OnLeapBoost(); return true; }
		if (name == "leap_end") { OnLeapEnd(); return true; }
		if (name == "leap_scan") { OnLeapScan(); return true; }
		if (name == "npc_post_spawn") { OnNpcPostSpawn(); return true; }
		if (name == "npc_targetsighted") { OnNpcTargetsighted(Param(params, 0)); return true; }
		if (name == "orc_spawn") { OnOrcSpawn(); return true; }
		if (name == "reset_lunge_delay") { OnResetLungeDelay(); return true; }
		if (name == "run_step1") { OnRunStep1(); return true; }
		if (name == "run_step2") { OnRunStep2(); return true; }
		if (name == "swing_axe") { OnSwingAxe(); return true; }
		if (name == "swing_start") { OnSwingStart(); return true; }
		return OrcBaseMelee_DispatchEvent(name, params)
			|| SorcBaseScript::DispatchEvent(name, params);
	}
}
