#pragma context server

// Converted from monsters/dragon_guard.script by msc_transpiler.
// Jaminporlants Dragon Guards
// (also with skins for Kharaztorant - maybe for Rhudeanlorat later)
// - large magic weapon array
// - various potion options
// - various breath weapon options
// - armored option
// - options adjust base XP
// - good jumper
// - kick attack*
// Options:
// dg_potd - Demon Blood Pot (+750 Base XP)
// dg_potp - Protection Pot (+200 Base XP)
// dg_potf - Fire Aura Pot (+100 Base XP)
// dg_pots - Speed Pot (+500 Base XP)
// dg_bfir - Fire Breath Prefix:"Infernal" (+100 Base XP) +50% fire, -75% cold
// dg_bice - Ice Breath Prefix:"Freezing" (+200 Base XP) +50 cold, -75% fire
// dg_bpoi - Poison Breath Prefix:"Noxious" (+100 Base XP) +50% acid/poison, -75% lighting
// dg_bacd - Acid Bolt Breath Prefix:"Caustic" (+100 Base XP) +50% acid, -50% lighting
// dg_blgt - Lighting Bolt Breath "Thunderguard" (+100 Base XP) +50% lightning, -75% acid, -50% poison
// dg_wice - Greater Ice Blade "Iceblade" (+200 Base XP)
// dg_wbow - Cross Bow "Bowman" (-250 Base XP)
// dg_wpol - Lance "Pikeman" (+150 Base XP)
// dg_wham - Big ol Hammer "Mauler" (+400 Base XP)
// dg_wcre - Envenomed Crescent Blades "Ravager" (+200 Base XP)
// dg_wdbl - Vampyric Katanas "Bladesman" (+250 Base XP)
// dg_wfrb - Red Rune Blade + Shield  "Flameblade"  (+150 Base XP), +50% fire
// dg_wgrb - Green Rune Blade + Shield "Plaguebringer" (+200 Base XP), +50% poison
// dg_armr - Armored (+350 Base XP) (50% damage reduct + 50% stun resist)
// dg_narm - Never armored (norm 20% chance)
// dg_npot - Never has a potion (healing or otherwise - norm 50% for heal + 20% for special)
// dg_nbrt - No breath attack (norm 25% chance)
// +25% elemental resisitance
// Elemental Adjustments capped at: (Immune)/-300%
// green:  +25% acid/poison, -25% lightning
// red: +100% fire, -50% cold
// black: +25% all elements, +75% stun, -200% Holy

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_monster_new.as"
#include "converted/monsters/base_jumper.as"

[script "monsters/dragon_guard"]
class DragonGuard : BaseMonsterNewScript, BaseJumper
{
	// Constants
	string ANIM_CAUTIOUS_APPROACH = "cwalkf";
	string ANIM_CAUTIOUS_RETREAT = "cwalkb";
	string ANIM_KICK = "kick";
	string ANIM_SHOCK = "spasm";
	string ANIM_THROW = "throwr";
	string ANIM_DRINK = "drink";
	string ANIM_WALK_HEARDSOUND = "cwalkf";
	string ANIM_WALK_WOUNDED = "walkinj";
	string ANIM_NPC_JUMP = "kick";
	string ANIM_BREATH_LOOP = "breath_loop";
	string SOUND_XBOW_STRETCH = "weapons/bow/stretch.wav";
	string SOUND_XBOW_SHOOT = "weapons/bow/crossbow.wav";
	string SOUND_BOLT_HIT = "weapons/bow/bolthit1.wav";
	int RANGE_MELEE_STANDARD = 64;
	int MOVERANGE_MELEE_STANDARD = 32;
	int HITRANGE_MELEE_STANDARD = 96;
	int HITRANGE_POLE_SHORT = 75;
	float FREQ_SHIELD_BASH = 0.0f;
	float HEAL_DELAY = 15.0f;
	int DMG_STUN_BURST = 300;
	string DMG_KICK = "100";
	int DG_FAURA_DOT = 100;
	int DG_FAURA_AOE = 64;
	float DG_FAURA_CL_RATE = 15.0f;
	int DMG_XBOW = 100;
	string SOUND_HEARD_ALERT1 = "monsters/dg/c_lizardm_bat1.wav";
	string SOUND_HEARD_ALERT2 = "monsters/dg/c_lizardm_bat2.wav";
	string SOUND_PAIN1 = "monsters/dg/c_lizardm_hit1.wav";
	string SOUND_PAIN2 = "monsters/dg/c_lizardm_hit2.wav";
	string SOUND_NPC_JUMP = "monsters/dg/c_lizardm_atk1.wav";
	string SOUND_DEATH1 = "monsters/dg/c_lizardm_dead.wav";
	string SOUND_DEATH2 = "monsters/dg/vs_nlizardm_bye.wav";
	string SOUND_INVESTIGATE = "monsters/dg/c_lizardmw_bat1.wav";
	string SOUND_ATTACK1 = "monsters/dg/c_lizardm_atk1.wav";
	string SOUND_ATTACK2 = "monsters/dg/c_lizardm_atk2.wav";
	string SOUND_ATTACK3 = "monsters/dg/c_lizardm_atk3.wav";
	string SOUNDA_HEARD_ALERT1 = "monsters/dg/c_lizardmc_bat1.wav";
	string SOUNDA_HEARD_ALERT2 = "monsters/dg/c_lizardmw_bat2.wav";
	string SOUNDA_PAIN1 = "monsters/dg/vs_nlizardm_hit1.wav";
	string SOUNDA_PAIN2 = "monsters/dg/vs_nlizardm_hit2.wav";
	string SOUNDA_PAIN3 = "monsters/dg/vs_nlizardm_hit3.wav";
	string SOUNDA_NPC_JUMP = "monsters/dg/vs_nlizardm_atk1.wav";
	string SOUNDA_DEATH1 = "monsters/dg/vs_nlizardm_dead.wav";
	string SOUNDA_DEATH2 = "monsters/dg/vs_nlizardm_bye.wav";
	string SOUNDA_INVESTIGATE = "monsters/dg/vs_nlizardm_bat2.wav";
	string SOUNDA_ATTACK1 = "monsters/dg/vs_nlizardm_atk1.wav";
	string SOUNDA_ATTACK2 = "monsters/dg/vs_nlizardm_atk2.wav";
	string SOUNDA_ATTACK3 = "monsters/dg/vs_nlizardm_atk3.wav";
	string SOUNDA_HEAL = "monsters/dg/vs_nlizardm_heal.wav";
	string SOUND_BREATH_LOOP = "monsters/goblin/sps_fogfire.wav";
	string SOUND_BREATH_ACID_READY = "bullchicken/bc_attack1.wav";
	string SOUND_BREATH_ACID_BOLT = "bullchicken/bc_attack2.wav";
	string SOUND_BREATH_LIGHTNING_READY = "debris/beamstart1.wav";
	string SOUND_BREATH_LIGHTNING = "debris/zap1.wav";
	string SOUND_MELEE1 = "zombie/claw_miss1.wav";
	string SOUND_MELEE2 = "zombie/claw_miss2.wav";
	string SOUND_MELEE_LARGE = "weapons/swinghuge.wav";
	string SOUND_STRUCK1 = "weapons/cbar_hitbod1.wav";
	string SOUND_STRUCK2 = "weapons/cbar_hitbod2.wav";
	string SOUND_STRUCK3 = "weapons/cbar_hitbod3.wav";
	string SOUND_STRUCK_ARMOR1 = "weapons/axemetal1.wav";
	string SOUND_STRUCK_ARMOR2 = "weapons/axemetal2.wav";

	// Variables (an unset .script variable reads as its own name)
	float TAKEDMG_ADJ_ACID = 0.0f;
	float TAKEDMG_ADJ_COLD = 0.0f;
	float TAKEDMG_ADJ_FIRE = 0.0f;
	float TAKEDMG_ADJ_POISON = 0.0f;
	float TAKEDMG_ADJ_LIGHTNING = 0.0f;
	bool IS_GREEN = false;
	float FREQ_KICK = 0.0f;
	int DMG_CRESCENT = 0;
	int XBOW_ACCURACY = 0;
	bool NPC_JUMPER = false;
	string PLR_POT_ALERT_LIST = "PLR_POT_ALERT_LIST";
	string ANIM_ATTACK = "ANIM_ATTACK";
	int POT_HEAL = 0;
	bool POT_SPECIAL = false;
	bool SELECTED_RND_POT = false;
	bool SELECTED_RND_ARMOR = false;
	bool SELECTED_RND_WEP = false;
	float QUARTER_HP = 0.0f;
	float HALF_HP = 0.0f;
	float ATTACK_RANGE_DEFAULT = 0.0f;
	string ANIM_ATTACK_DEFAULT = "ANIM_ATTACK_DEFAULT";
	string DEFAULT_TAKDMG_ACID = "DEFAULT_TAKDMG_ACID";
	string DEFAULT_TAKDMG_COLD = "DEFAULT_TAKDMG_COLD";
	string DEFAULT_TAKDMG_FIRE = "DEFAULT_TAKDMG_FIRE";
	string DEFAULT_TAKDMG_POISON = "DEFAULT_TAKDMG_POISON";
	string DEFAULT_TAKDMG_LIGHTNING = "DEFAULT_TAKDMG_LIGHTNING";
	bool NO_ARMOR = false;
	bool IS_ARMORED = false;
	bool SKIN_SET = false;
	bool IS_RED = false;
	bool IS_BLACK = false;
	string WEAPON_TYPE = "WEAPON_TYPE";
	int ATTACK_REACH_RANGE = 0;
	string ANIM_IDLE_COMBAT = "ANIM_IDLE_COMBAT";
	string ANIM_IDLE_DEEP = "ANIM_IDLE_DEEP";
	string ANIM_ATTACK1 = "ANIM_ATTACK1";
	string ANIM_ATTACK2 = "ANIM_ATTACK2";
	string ANIM_ATTACK_REACH = "ANIM_ATTACK_REACH";
	float FREQ_REACH_ATTACK = 0.0f;
	bool CAUTIOUS_APPROACH = false;
	int DMG_MELEE = 0;
	string DMG_MELEE_TYPE = "DMG_MELEE_TYPE";
	bool HAS_DOT = false;
	int MELEE_DOT_DUR = 0;
	int MELEE_DOT = 0;
	string MELEE_DOT_EFFECT = "MELEE_DOT_EFFECT";
	bool NO_REACH_ATTACK = false;
	bool NPC_NO_VADJ = false;
	bool NEVER_JUMPS = false;
	bool EXTEND_KICK_RANGE = false;
	bool RETREATS_WHEN_NEAR = false;
	int RETREATS_NEAR_RANGE = 0;
	string RETREATS_NEAR_TYPE = "RETREATS_NEAR_TYPE";
	bool CAN_STUN = false;
	bool STUN_BURST = false;
	string STUN_CHANCE = "STUN_CHANCE";
	bool CAN_THROW = false;
	string PROJECTILE_THROW = "PROJECTILE_THROW";
	bool MELEE_VAMPIRE = false;
	bool HAS_SHIELD = false;
	string NAME_PREF = "NAME_PREF";
	bool BREATH_ATTACK = false;
	string BREATH_TYPE = "BREATH_TYPE";
	int BREATH_DOT = 0;
	string ANIM_BREATH = "ANIM_BREATH";
	int BREATH_MIN_RANGE = 0;
	int BREATH_PUSH_VEL = 0;
	int BREATH_RANGE = 0;
	float FREQ_BREATH = 0.0f;
	bool BREATH_QUICK = false;
	bool NO_BREATH = false;
	bool NO_POTION = false;
	string POT_TYPE = "POT_TYPE";
	bool DID_INIT = false;
	float NEXT_ALERT_SOUND = 0.0f;
	float NEXT_KICK = 0.0f;
	float NEXT_BREATH = 0.0f;
	float DG_SUSPEND = 0.0f;
	bool DO_HEAL = false;
	bool ATTEMPTED_HEAL = false;
	float NEXT_BREATH_REMOVE = 0.0f;
	string BREATH_ON = "BREATH_ON";
	float NEXT_BACK_OFF = 0.0f;
	float NEXT_REACH_ATTACK = 0.0f;
	float NEXT_CRE_THROW = 0.0f;
	float NEXT_SHIELD_BASH = 0.0f;
	float MISS_COUNT = 0.0f;
	float NEXT_HEAL = 0.0f;
	bool HEAL_READY = false;
	float NEXT_CALM = 0.0f;
	bool AM_WOUNDED = false;
	bool MELEE_ATTACK = false;
	Vector3 BURST_START = Vector3();
	string BURST_TARGS = "BURST_TARGS";
	float FREEZE_COUNT = 0.0f;
	CBaseEntity@ OLD_ATTACK_TARGET = null;
	string POT_OUT_MSG = "POT_OUT_MSG";
	bool DEMON_NOHP_LOSS = false;
	bool DG_FAURA = false;
	string DG_FAURA_CLIDX = "DG_FAURA_CLIDX";
	float DG_FAURA_NEXT_CL = 0.0f;
	string DG_FAURA_SCAN = "DG_FAURA_SCAN";
	string NPC_ALT_SOUND_DEATH = "NPC_ALT_SOUND_DEATH";
	string BREATH_CL_IDX = "BREATH_CL_IDX";
	string BREATH_TARGS = "BREATH_TARGS";
	bool EXPLOSIVE_BOLT = false;
	float NEXT_SPLODIE_BOLT = 0.0f;
	Vector3 ELF_AIM_ANGLES = Vector3();
	bool ELF_XBOW_SHOT = false;
	string ELF_BOLT_LAND = "ELF_BOLT_LAND";
	float NEXT_GLOAT = 0.0f;

	// Variables declared by included files, with the value they start with in this script
	DragonGuard()
	{
		ANIM_WALK = "walk";
		ANIM_IDLE = "deep_idle";
	}

	// unnamed block (first think)
	void DragonGuard_FirstThink()
	{
		ANIM_DEATH = "death_long";

		ANIM_WALK = "walk";
		ANIM_IDLE = "deep_idle"; // maybe changed by weapon array
		ANIM_RUN = "run";
	}

	// unnamed block (first think)
	void DragonGuard_FirstThink2()
	{
		// const NPC_HOLD_ADDPARAMS 1
		TAKEDMG_ADJ_ACID = 0.0f;
		TAKEDMG_ADJ_COLD = 0.0f;
		TAKEDMG_ADJ_FIRE = 0.0f;
		TAKEDMG_ADJ_POISON = 0.0f;
		TAKEDMG_ADJ_LIGHTNING = 0.0f;

		SetGlobal("DEV_STRING", "Flags: ");

		IS_GREEN = true; // default to green

		NPC_GIVE_EXP = 1500.0f; // adjusts based on selected options

		FREQ_KICK = Random(20, 30); // varies by weapon
		DMG_CRESCENT = 60; // used by proj_crescent
		XBOW_ACCURACY = 75;

		NPC_JUMPER = true;
	}

	// game_damaged
	string DragonGuard_OnGameDamaged(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float accuracyRoll = 0.0f, CBaseEntity@ inflictor = null, string skill = "")
	{
		string result = "";
		// limp when 25% hp or less
		float myHp = HealthOf(ENT_ME);
		if (!IS_ARMORED)
		{
			if (myHp > HALF_HP)
				PlayRandomSound(0, 10, SOUND_STRUCK1, SOUND_STRUCK2, SOUND_STRUCK3);
			else
				PlayRandomSound(0, 10, SOUND_STRUCK1, SOUND_STRUCK2, SOUND_STRUCK3, SOUND_PAIN1, SOUND_PAIN2);
		}
		else if (myHp > HALF_HP)
			PlayRandomSound(0, 10, SOUND_STRUCK1, SOUND_STRUCK2, SOUND_STRUCK3, SOUND_STRUCK_ARMOR1, SOUND_STRUCK_ARMOR2);
		else
			PlayRandomSound(0, 10, SOUND_STRUCK1, SOUND_STRUCK2, SOUND_STRUCK3, SOUND_STRUCK_ARMOR1, SOUND_STRUCK_ARMOR2, SOUNDA_PAIN1, SOUNDA_PAIN2, SOUNDA_PAIN3);

		if (POT_HEAL != 0 && myHp < HALF_HP)
		{
			NEXT_HEAL = 0.0f;
			NEXT_HEAL += HEAL_DELAY;
			HEAL_READY = true;
			POT_HEAL = 0;
		}

		NEXT_CALM = GameTime() + 20.0f;
		if (myHp > QUARTER_HP)
		{
			AM_WOUNDED = false;
			if (!NEVER_JUMPS)
				NPC_JUMPER = true;
			ANIM_RUN = "run";
			SetMoveAnim(ANIM_RUN);
		}
		else
		{
			AM_WOUNDED = true;
			NPC_JUMPER = false;
			ANIM_RUN = "walkinj";
			LegacyCommand("setmoveanim", ANIM_RUN, "walkinj");
		}
		return result;
	}

	// game_dodamage
	// ================================== end anim events
	string DragonGuard_OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";
		if (MELEE_ATTACK)
		{
			if (MELEE_VAMPIRE)
			{
				float giveHp = MaxHealthOf(ENT_ME);
				if (HealthOf(ENT_ME) < giveHp)
				{
					giveHp *= 0.01f;
					GiveHealth(ENT_ME, giveHp);
				}
			}

			if (Float(WEAPON_TYPE) == 1.0f)
			{
				if (target is OLD_ATTACK_TARGET)
				{
					if (!Truthy(ScriptVarOf(target, "I_R_FROZEN")))
						FREEZE_COUNT += 1.0f;
					else
						FREEZE_COUNT = 0.0f;
					if (FREEZE_COUNT >= 4.0f && hit)
					{
						FREEZE_COUNT = 0.0f;
						ApplyEffect(target, "effects/dot_cold_freeze", MELEE_DOT_DUR, self, 0);
					}
				}
				else
				{
					@OLD_ATTACK_TARGET = target;
					FREEZE_COUNT = 0.0f;
				}
			}

			if (hit && HAS_DOT)
				ApplyEffect(target, MELEE_DOT_EFFECT, MELEE_DOT_DUR, self, MELEE_DOT);
		}
		MELEE_ATTACK = false;
		return result;
	}

	// game_precache
	void OnGamePrecache()
	{
		PrecacheFile("monsters/dragon_guard_breath_cl");
		PrecacheFile("monsters/elf_xbow_cl");
	}

	// game_death
	// ================================== Death Events / Cleanup
	void OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		DqMonsterExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // dq/externals/dq_monster_externals
		MonstersExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/externals
		BaseSelfAdjust_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_self_adjust
		BaseNpc_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseMonsterShared_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared
		if (IS_ARMORED)
		{
			if (RandomInt(1, 2) == 1)
				NPC_ALT_SOUND_DEATH = SOUNDA_DEATH1;
			else
				NPC_ALT_SOUND_DEATH = SOUNDA_DEATH2;
		}
		else if (RandomInt(1, 2) == 1)
			NPC_ALT_SOUND_DEATH = SOUND_DEATH1;
		else
			NPC_ALT_SOUND_DEATH = SOUND_DEATH2;

		if (DG_FAURA)
			ClientEvent("update", "all", DG_FAURA_CLIDX, "remove_fx");
		if (Truthy(BREATH_ON))
			ClientEvent("update", "all", BREATH_CL_IDX, "end_fx");
		SetModelBody(1, 0); // hide weapon
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
		EXT_DEMON_BLOOD_RATIO = 3.0f; // nerfage
		ANIM_IDLE = ANIM_IDLE_DEEP;
		SetMoveAnim(ANIM_WALK);
		SetIdleAnim(ANIM_IDLE);

		MOVE_RANGE = Text(ATTACK_RANGE); // someday I'll figure why we need this
		ANIM_ATTACK = ANIM_ATTACK1;
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseNpcAttackNew_OnNpcSpawn(npc); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck
		SetName("Dragon Guard");
		SetModel("monsters/dragon_guard.mdl");
		SetWidth(32);
		SetHeight(90);
		SetRace("demon");
		SetMoveAnim(ANIM_WALK);
		SetIdleAnim(ANIM_IDLE);
		SetHealth(4000);
		SetHearingSensitivity(6);
		SetRoam(true);

		SetDamageTaken("stun", 0.75f);

		PLR_POT_ALERT_LIST = "";

		CallEventDelayed(0.2f, "pick_specials");
		CallEventDelayed(2.0f, "dragon_guard_finalize");
	}

	// npcatk_hunt
	void OnNpcatkHunt()
	{
		BaseNpcAttackNew_OnNpcatkHunt(); // monsters/base_npc_attack_new
		BaseAntiStuck_OnNpcatkHunt(); // monsters/base_anti_stuck
		BaseJumper_OnNpcatkHunt(); // monsters/base_jumper
		bool exitSub = false;
		int kickRange = 0;

		// some day I'll stop writing my scripts so sloppy as to cause their AI's to stick suspended
		if (SUSPEND_AI)
		{
			float lastAiSuspendPlus10 = NPC_LAST_SUSPEND_AI + 10.0f;
			if (GameTime() > lastAiSuspendPlus10)
			{
				// AI suspended more than 10 seconds, force resume
				DebugPrint("AI SUSPENDED TOO LONG");
				OnNpcatkResumeAi();
				DG_SUSPEND = 0.0f;
			}
		}

		if (SUSPEND_AI)
			return;

		if (ATTACK_HITRANGE < ATTACK_RANGE)
		{
			// some odd combos can cause range to excede hitrange, which causes problems
			ATTACK_HITRANGE = ATTACK_RANGE * 1.25f;
		}

		float gameTime = GameTime();

		if (NPCATK_TARGET == "unset")
			return;

		if (HEAL_READY && !ATTEMPTED_HEAL && gameTime > NEXT_HEAL)
		{
			SetModelBody(1, 10);
			DO_HEAL = true;
			ATTEMPTED_HEAL = true;
			OnNpcatkSuspendAi("2.0");
			PlayAnim("critical", ANIM_DRINK);
			if (IS_ARMORED)
				PlaySound(0, 10, SOUNDA_HEAL);
			CallEventDelayed(5.0f, "reset_weapon_submodel"); // in case stuck for some reason
		}
		if (SUSPEND_AI) // suspend rest of think if healing
			return;

		float targRange = RangeTo(NPCATK_TARGET);

		if (BREATH_ATTACK && gameTime > NEXT_BREATH && targRange < BREATH_RANGE && targRange > BREATH_MIN_RANGE && CanSee(NPCATK_TARGET))
		{
			NEXT_BREATH = GameTime() + FREQ_BREATH;
			PlayAnim("critical", ANIM_BREATH);
			DG_SUSPEND = gameTime;
			if (BREATH_QUICK)
				DG_SUSPEND += 1.0f;
			else
				DG_SUSPEND += 2.5f;
		}
		if (!(gameTime > DG_SUSPEND)) // suspend the internal AI for a bit, to give breath a chance to go
			return;

		if (CAUTIOUS_APPROACH)
		{
			if (targRange < 256.0f)
			{
				if (HealthOf(ENT_ME) > QUARTER_HP && gameTime > NEXT_CALM)
				{
					ANIM_RUN = ANIM_CAUTIOUS_APPROACH;
					SetMoveAnim(ANIM_RUN);
				}
			}
			else if (HealthOf(ENT_ME) > QUARTER_HP)
			{
				ANIM_RUN = "run";
				SetMoveAnim(ANIM_RUN);
			}
		}
		else if (HealthOf(ENT_ME) > QUARTER_HP)
			SetMoveAnim(ANIM_RUN);

		// in case this pulls the same strangeness the gpolar breath attack did
		if (Truthy(BREATH_ON) && gameTime > NEXT_BREATH_REMOVE)
		{
			NEXT_BREATH_REMOVE = 0.0f;
			NEXT_BREATH_REMOVE += 1.0f;
			BREATH_ON = "0";
			ClientEvent("update", "all", BREATH_CL_IDX, "end_fx");
			exitSub = true;
		}
		if (exitSub)
			return;

		if (RETREATS_WHEN_NEAR && targRange < RETREATS_NEAR_RANGE && gameTime > NEXT_BACK_OFF)
		{
			if (RETREATS_NEAR_TYPE == "walk")
			{
				// glave bastards back off periodically, if opponent too near
				PlayAnim("critical", ANIM_CAUTIOUS_RETREAT);
				NEXT_BACK_OFF = gameTime + 10.0f;
			}

			if (RETREATS_NEAR_TYPE == "flee")
			{
				// xbow bastards rtf away when opponent too near
				// reset run attribs, in case cautious approach tripped above
				if (HealthOf(ENT_ME) > QUARTER_HP)
				{
					ANIM_RUN = "run";
					SetMoveAnim(ANIM_RUN);
				}
				else
				{
					ANIM_RUN = "walkinj";
					LegacyCommand("setmoveanim", ANIM_RUN, "walkinj");
				}
				OnNpcatkFlee(NPCATK_TARGET, "512", "2.0");
				NEXT_BACK_OFF = gameTime + 20.0f;
			}
		}

		if (!NO_REACH_ATTACK && Float(WEAPON_TYPE) != 3.0f && targRange < ATTACK_REACH_RANGE && gameTime > NEXT_REACH_ATTACK)
		{
			NEXT_REACH_ATTACK = gameTime + FREQ_REACH_ATTACK;
			// playanim once ANIM_ATTACK_REACH
			ATTACK_RANGE = ATTACK_REACH_RANGE;
			ANIM_ATTACK = ANIM_ATTACK_REACH;
		}

		// setvard AS_ATTACKING GAME_TIME
		// add AS_ATTACKING 5.0
		if (Float(WEAPON_TYPE) == 3.0f)
		{
			// polearm adjust attack on range
			if (targRange < 70.0f)
			{
				int rndAtk = RandomInt(1, 2);
				if (rndAtk == 1)
					ANIM_ATTACK = "plparryl";
				if (rndAtk == 2)
					ANIM_ATTACK = "pole_close";
			}
			else
			{
				ANIM_ATTACK = "pole_reach";
			}
		}

		if (Float(WEAPON_TYPE) == 5.0f && gameTime > NEXT_CRE_THROW && CanSee(NPCATK_TARGET))
		{
			NEXT_CRE_THROW = GameTime() + 3.0f;
			PlayAnim("critical", ANIM_THROW);
		}

		if (HAS_SHIELD && targRange < 48.0f && gameTime > NEXT_SHIELD_BASH)
		{
			NEXT_SHIELD_BASH = gameTime + FREQ_SHIELD_BASH;
			PlayAnim("critical", "shieldl");
		}

		if (gameTime > NEXT_KICK)
		{
			if (!AM_WOUNDED)
			{
				kickRange = MOVERANGE_MELEE_STANDARD;
				if (EXTEND_KICK_RANGE)
					kickRange = RANGE_MELEE_STANDARD;
				if (RangeTo(NPCATK_TARGET) < kickRange)
				{
					ANIM_ATTACK = ANIM_KICK;
					NEXT_KICK = GameTime() + FREQ_KICK + 2.0f; // compensate for melee time, cuz we moved this here
					exitSub = true;
				}
			}
		}
		else
		{
			kickRange = MOVERANGE_MELEE_STANDARD;
			if (EXTEND_KICK_RANGE)
				kickRange = RANGE_MELEE_STANDARD;
			if (RangeTo(NPCATK_TARGET) > kickRange && ANIM_ATTACK == ANIM_KICK)
				ANIM_ATTACK = ANIM_ATTACK1;
		}
		if (exitSub)
			return;

		// xbow re-orient
		if (MISS_COUNT > 3.0f)
		{
			MISS_COUNT = 0.0f;
			OnChickenRun(2.0f);
		}
	}

	// game_heardsound
	void OnGameHeardsound(string soundType = "", Vector3 origin = Vector3(), float dangerRadius = 0.0f)
	{
		BaseNpcAttackNew_OnGameHeardsound(soundType, origin, dangerRadius); // monsters/base_npc_attack_new
		BaseMonsterShared_OnGameHeardsound(soundType, origin, dangerRadius); // monsters/base_monster_shared
		// cautiously move towards suspicious unseen sounds
		if (NPCATK_TARGET != "unset")
			return;
		CBaseEntity@ heardId = EntityOf(ENT_LASTHEARD);
		if (RelationshipOf(heardId, ENT_ME) != "enemy")
			return;
		if (HealthOf(ENT_ME) > QUARTER_HP)
		{
			ANIM_WALK = ANIM_WALK_HEARDSOUND;
			SetMoveAnim(ANIM_WALK);
		}
		if (!(GameTime() > NEXT_ALERT_SOUND))
			return;
		NEXT_ALERT_SOUND = GameTime() + 30.0f;
		if (IS_ARMORED)
			PlaySound(0, 10, SOUNDA_INVESTIGATE);
		else
			PlaySound(0, 10, SOUND_INVESTIGATE);
	}

	// my_target_died
	void OnMyTargetDied(string offender = "")
	{
		BaseNpcAttackNew_OnMyTargetDied(offender); // monsters/base_npc_attack_new
		if (!IS_ARMORED)
			return;
		if (!(GameTime() > NEXT_GLOAT))
			return;
		NEXT_GLOAT = GameTime() + 20.0f;
		PlaySound(0, 10, "monsters/dg/vs_nlizardm_haha.wav");
	}

	// game_dodamage
	string OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";
		result = AppendResult(result, BaseNpcAttackNew_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BaseAntiStuck_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BaseMonsterShared_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, DragonGuard_OnGameDodamage(hit, target, start, end, damageType, damageText));
		return result;
	}

	// cycle_up
	void OnCycleUp(string reason = "")
	{
		BaseNpcAttackNew_OnCycleUp(reason); // monsters/base_npc_attack_new
		ANIM_IDLE = ANIM_IDLE_COMBAT;
		SetIdleAnim(ANIM_IDLE);
	}

	// cycle_down
	void OnCycleDown()
	{
		BaseNpcAttackNew_OnCycleDown(); // monsters/base_npc_attack_new
		BaseMonsterShared_OnCycleDown(); // monsters/base_monster_shared
		BaseMonsterShared_OnCycleDown_2(); // monsters/base_monster_shared
		ANIM_IDLE = ANIM_IDLE_DEEP;
		SetIdleAnim(ANIM_IDLE);
		if (!(HealthOf(ENT_ME) > QUARTER_HP))
			return;
		ANIM_WALK = "walk";
		SetMoveAnim(ANIM_WALK);
	}

	// game_damaged - Return a damage multiplier to scale the damage
	string OnGameDamaged(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float accuracyRoll = 0.0f, CBaseEntity@ inflictor = null, string skill = "")
	{
		string result = "";
		result = AppendResult(result, BaseAntiStuck_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, BaseMonsterShared_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, BaseMonsterShared_OnGameDamaged_2(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, DragonGuard_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		return result;
	}

	// npc_targetsighted
	// ================================== end addparams
	// ================================== MAIN HUNT CYCLE
	void OnNpcTargetsighted(string target = "")
	{
		BaseMonsterShared_OnNpcTargetsighted(target); // monsters/base_monster_shared
		if (DID_INIT)
			return;
		DID_INIT = true;

		float gameTime = GameTime();

		NEXT_ALERT_SOUND = gameTime + 10.0f;

		NEXT_KICK = gameTime + FREQ_KICK;

		NEXT_BREATH = gameTime + FREQ_BREATH;

		if (IS_ARMORED)
		{
			if (RandomInt(1, 3) == 1)
				PlayRandomSound(0, 10, SOUNDA_HEARD_ALERT1, SOUNDA_HEARD_ALERT2);
		}
		else if (RandomInt(1, 5) == 1)
			PlayRandomSound(0, 10, SOUND_HEARD_ALERT1, SOUND_HEARD_ALERT2);

		if (ToLowerCase(MapName()) == "nashalrath")
		{
			// if ( game.time < 20 )
			// {
			CBaseEntity@ mahDaddy = FindByName("gdragon_img");
			if (!IsAlive(mahDaddy)) // dont fuck with daddy's musak
				CallExternal(NPCATK_TARGET, "ext_play_music", "DemonicFlesh2.mp3");
		}

		// }
		// else
		// {
		// callexternal NPCATK_TARGET ext_play_music NPCATK_TARGET 7.5 DemonicFlesh2.mp3
		// }
		if (!POT_SPECIAL)
			return;
		OnNpcatkSuspendAi("2.0");
		PlayAnim("critical", ANIM_DRINK);
	}

	// pick_specials
	void OnPickSpecials()
	{
		int rndPot = 0;

		if (!NO_POTION)
		{
			POT_HEAL = RandomInt(0, 1);
			if (POT_HEAL != 0)
			{
				if (Truthy(GetVar("G_DEVELOPER_MODE")))
					LegacyCommand("stradd", "DEV_STRING", "Pot_Healing ");
				NPC_GIVE_EXP += 200.0f;
			}
			if (RandomInt(1, 5) == 1)
				POT_SPECIAL = true;
			if (POT_SPECIAL)
			{
				rndPot = RandomInt(1, 4);
				if (rndPot == 1)
					OnDgPotd();
				if (rndPot == 2)
					OnDgPotp();
				if (rndPot == 3)
					OnDgPotf();
				if (rndPot == 4)
					OnDgPots();
				SELECTED_RND_POT = true;
			}
		}

		if (!NO_BREATH && !BREATH_ATTACK && RandomInt(1, 4) == 1)
		{
			int rndBreath = RandomInt(1, 5);
			if (rndBreath == 1)
				OnDgBfir();
			if (rndBreath == 2)
				OnDgBice();
			if (rndBreath == 3)
				OnDgBpoi();
			if (rndBreath == 4)
				OnDgBacd();
			if (rndBreath == 5)
				OnDgBlgt();
		}

		if (!IS_ARMORED && !NO_ARMOR && RandomInt(1, 5) == 1)
		{
			OnDgArmr();
			SELECTED_RND_ARMOR = true;
		}

		if (!Truthy(WEAPON_TYPE))
		{
			int rndWep = RandomInt(1, 8);

			SELECTED_RND_WEP = true;

			if (ToLowerCase(MapName()) == "nashalrath")
			{
				// don't randomly pick whammers on Nashalrath (sub with crescent)
				if (rndWep == 4)
					rndWep = 5;
			}

			if (rndWep == 6)
			{
				// don't randomly selecte armor+speedpot+vampblades (sub with crescent)
				float strikeCount = 1.0f;
				if (SELECTED_RND_ARMOR && IS_ARMORED)
					strikeCount += 1.0f;

				if (SELECTED_RND_POT && rndPot == 4)
					strikeCount += 1.0f;

				if (strikeCount == 3.0f)
					rndWep = 5;
			}

			if (rndWep == 1)
				OnDgWice();
			if (rndWep == 2)
				OnDgWbow();
			if (rndWep == 3)
				OnDgWpol();
			if (rndWep == 4)
				OnDgWham();
			if (rndWep == 5)
				OnDgWcre();
			if (rndWep == 6)
				OnDgWdbl();
			if (rndWep == 7)
				OnDgWfrb();
			if (rndWep == 8)
				OnDgWgrb();
		}
	}

	// dragon_guard_finalize
	void OnDragonGuardFinalize()
	{
		if (!NPC_CUSTOM_NAME)
		{
			if (NAME_PREF != "NAME_PREF")
			{
				string newName = NAME_PREF + " " + NEW_NAME;
				NEW_NAME = newName;
			}

			if (Contains("aeiou", Left(NEW_NAME, 0)))
				SetNamePrefix("an");

			if (BREATH_TYPE == "lightning")
			{
				int start = NEW_NAME.findFirst("Guard");
				string left = Left(NEW_NAME, start) + "Thunderguard";
				float len = int(NEW_NAME.length()) - start - 5.0f;
				string right = Right(NEW_NAME, int(len));
				NEW_NAME = left + right;
			}

			SetName(NEW_NAME);
		}

		ANIM_IDLE = ANIM_IDLE_DEEP;
		SetMoveAnim(ANIM_WALK);
		SetIdleAnim(ANIM_IDLE);
		PlayAnim("once", ANIM_IDLE);

		QUARTER_HP = MaxHealthOf(ENT_ME) * 0.25f; // walk injured threshold

		HALF_HP = MaxHealthOf(ENT_ME) * 0.5f; // threshold for healing potion (20 secs later, will drink)

		if (HAS_SHIELD)
			SetStat("parry", 150);

		ATTACK_RANGE_DEFAULT = ATTACK_RANGE;
		ANIM_ATTACK_DEFAULT = ANIM_ATTACK;
		if (!CAUTIOUS_APPROACH)
			ANIM_RUN = "run";

		// takedmg adjust (starts 25% resist to most everything)
		float fTakedmgAdjAcid = 0.75f;
		float fTakedmgAdjCold = 0.75f;
		float fTakedmgAdjFire = 0.75f;
		float fTakedmgAdjPoison = 0.75f;
		float fTakedmgAdjLightning = 0.75f;

		if (IS_GREEN)
		{
			fTakedmgAdjAcid += -0.25f;
			fTakedmgAdjPoison += -0.25f;
			fTakedmgAdjLightning += 0.25f;
		}

		if (IS_RED)
		{
			fTakedmgAdjFire += -1.0f;
			fTakedmgAdjCold += 0.5f;
		}

		if (IS_BLACK)
		{
			fTakedmgAdjAcid += -0.5f;
			fTakedmgAdjFire += -0.5f;
			fTakedmgAdjCold += -0.5f;
			fTakedmgAdjPoison += -0.5f;
			fTakedmgAdjLightning += -0.5f;
			SetDamageTaken("holy", 2);
			SetDamageTaken("stun", 0.25f);
		}

		if (IS_ARMORED)
		{
			float adj = DamageTakenOf(ENT_ME, "stun") - 0.25f;
			SetDamageTaken("stun", adj);
		}

		DEFAULT_TAKDMG_ACID = Text(fTakedmgAdjAcid);
		DEFAULT_TAKDMG_COLD = Text(fTakedmgAdjCold);
		DEFAULT_TAKDMG_FIRE = Text(fTakedmgAdjFire);
		DEFAULT_TAKDMG_POISON = Text(fTakedmgAdjPoison);
		DEFAULT_TAKDMG_LIGHTNING = Text(fTakedmgAdjLightning);

		fTakedmgAdjAcid += TAKEDMG_ADJ_ACID;
		fTakedmgAdjCold += TAKEDMG_ADJ_COLD;
		fTakedmgAdjFire += TAKEDMG_ADJ_FIRE;
		fTakedmgAdjPoison += TAKEDMG_ADJ_POISON;
		fTakedmgAdjLightning += TAKEDMG_ADJ_LIGHTNING;

		if (fTakedmgAdjAcid < 0.0f)
			fTakedmgAdjAcid = 0.0f;
		if (fTakedmgAdjCold < 0.0f)
			fTakedmgAdjCold = 0.0f;
		if (fTakedmgAdjFire < 0.0f)
			fTakedmgAdjFire = 0.0f;
		if (fTakedmgAdjPoison < 0.0f)
			fTakedmgAdjPoison = 0.0f;
		if (fTakedmgAdjLightning < 0.0f)
			fTakedmgAdjLightning = 0.0f;

		if (fTakedmgAdjAcid > 3.0f)
			fTakedmgAdjAcid = 3.0f;
		if (fTakedmgAdjCold > 3.0f)
			fTakedmgAdjCold = 3.0f;
		if (fTakedmgAdjFire > 3.0f)
			fTakedmgAdjFire = 3.0f;
		if (fTakedmgAdjPoison > 3.0f)
			fTakedmgAdjPoison = 3.0f;
		if (fTakedmgAdjLightning > 3.0f)
			fTakedmgAdjLightning = 3.0f;

		SetDamageTaken("acid", fTakedmgAdjAcid);
		SetDamageTaken("cold", fTakedmgAdjCold);
		SetDamageTaken("fire", fTakedmgAdjFire);
		SetDamageTaken("poison", fTakedmgAdjPoison);
		SetDamageTaken("lightning", fTakedmgAdjLightning);

		if (Truthy(GetVar("G_DEVELOPER_MODE")))
		{
			SetSayTextRange(1024);
			OnDevText();
		}
	}

	// dev_text
	void OnDevText()
	{
		SayText(GetVar("DEV_STRING"));
		SayText("Takedmg: acd: " + Text(DamageTakenOf(ENT_ME, "acid")) + " cld: " + Text(DamageTakenOf(ENT_ME, "cold")) + " fir: " + Text(DamageTakenOf(ENT_ME, "fire")) + " poi: " + Text(DamageTakenOf(ENT_ME, "poison")) + " lgt: " + Text(DamageTakenOf(ENT_ME, "lightning")) + " stun: IMMUNE_STUN");
		SayText("hp: " + Text(MaxHealthOf(ENT_ME)) + " exp: " + Text(NPC_GIVE_EXP));
		DebugPrint(GetVar("DEV_STRING"));
		DebugPrint("Takedmg: acd: " + Text(DamageTakenOf(ENT_ME, "acid")) + " cld: " + Text(DamageTakenOf(ENT_ME, "cold")) + " fir: " + Text(DamageTakenOf(ENT_ME, "fire")) + " poi: " + Text(DamageTakenOf(ENT_ME, "poison")) + " lgt: " + Text(DamageTakenOf(ENT_ME, "lightning")) + " stun: IMMUNE_STUN");
		DebugPrint("hp: " + Text(MaxHealthOf(ENT_ME)) + " exp: " + Text(NPC_GIVE_EXP));
	}

	// dg_narm
	// { game_dynamically_created //<type_string>
	// dbg game_dynamically_created PARAM1
	// if G_DEVELOPER_MODE
	// setvard NPC_DO_EVENTS PARAM1
	// if ( PARAM1 startswith PARAM ) local EXIT_SUB 1
	// if !EXIT_SUB
	// calleventloop $get_token_amt(NPC_DO_EVENTS) npcatk_do_events
	// }
	// ================================== ADD PARAMS (can also be set through createdyn params)
	void OnDgNarm()
	{
		NO_ARMOR = true;
	}

	// dg_armr
	void OnDgArmr()
	{
		IS_ARMORED = true;
		SetModelBody(0, 1);
		SetDamageTaken("all", 0.5f);
		NPC_GIVE_EXP += 350.0f;
	}

	// dg_red
	void OnDgRed()
	{
		if (SKIN_SET)
			InfoMessage("all", "MAPPER ERROR", "Two skins set on Dragon Guard");
		if (SKIN_SET)
			return;
		SKIN_SET = true;
		IS_RED = true;
		IS_GREEN = false;
		IS_BLACK = false;
		SetProp(ENT_ME, "skin", 1);
		NPC_GIVE_EXP += 50.0f;
	}

	// dg_black
	void OnDgBlack()
	{
		if (SKIN_SET)
			InfoMessage("all", "MAPPER ERROR", "Two skins set on Dragon Guard");
		if (SKIN_SET)
			return;
		SKIN_SET = true;
		IS_BLACK = true;
		IS_GREEN = false;
		IS_RED = false;
		SetProp(ENT_ME, "skin", 2); // pending
		NPC_GIVE_EXP += 1000.0f;
	}

	// dg_wice
	void OnDgWice()
	{
		// gice blade
		// if ( WEAPON_TYPE > 0 ) infomsg all "MAP ERROR" "Dragon guard assigned more than one weapon type."
		if (Truthy(WEAPON_TYPE))
			return;
		WEAPON_TYPE = "1"; // 0-unarmed 1-iceblade 2-hxbow 3-glaive 4-hammer 5-crescents 6-swords
		SetModelBody(1, Int(WEAPON_TYPE));
		NPC_GIVE_EXP += 200.0f;

		ATTACK_REACH_RANGE = 128;
		ATTACK_RANGE = RANGE_MELEE_STANDARD;
		ATTACK_HITRANGE = HITRANGE_MELEE_STANDARD;
		ATTACK_MOVERANGE = MOVERANGE_MELEE_STANDARD;

		ANIM_IDLE_COMBAT = "combat_idle";
		ANIM_IDLE_DEEP = "deep_idle";
		ANIM_ATTACK1 = "1h_slash1"; // frame_melee_strike
		ANIM_ATTACK2 = "1h_slash2"; // frame_melee_strike
		ANIM_ATTACK_REACH = "1h_reach"; // frame_reach_strike
		NPC_JUMPER = true;

		FREQ_REACH_ATTACK = 15.0f;

		CAUTIOUS_APPROACH = false;
		DMG_MELEE = 200;
		DMG_MELEE_TYPE = "slash";
		HAS_DOT = true;
		MELEE_DOT_DUR = 5;
		MELEE_DOT = 50;
		MELEE_DOT_EFFECT = "effects/dot_cold";

		// WEAPON_TYPE 1 has a freeze_solid attack on every 5th hit
		NEW_NAME = "Dragon Guard Iceblade";
	}

	// dg_wbow
	void OnDgWbow()
	{
		// xbow
		// if ( WEAPON_TYPE > 0 ) infomsg all "MAP ERROR" "Dragon guard assigned more than one weapon type."
		if (Truthy(WEAPON_TYPE))
			return;
		WEAPON_TYPE = "2"; // 0-unarmed 1-iceblade 2-hxbow 3-glaive 4-hammer 5-crescents 6-swords
		SetModelBody(1, Int(WEAPON_TYPE));
		NPC_GIVE_EXP -= 200.0f;

		ATTACK_RANGE = 1024.0f;
		ATTACK_MOVERANGE = 384.0f;
		ATTACK_HITRANGE = 1024.0f;
		NO_REACH_ATTACK = true;

		NPC_NO_VADJ = true;

		ANIM_IDLE_COMBAT = "xbowrdy";
		ANIM_IDLE_DEEP = "deep_idle";
		ANIM_ATTACK1 = "xbowshot"; // frame_xbow
		ANIM_ATTACK2 = "xbowshot"; // frame_xbow
		NPC_JUMPER = false;
		NEVER_JUMPS = true;

		FREQ_KICK = 8.0f;
		EXTEND_KICK_RANGE = true;

		RETREATS_WHEN_NEAR = true;
		RETREATS_NEAR_RANGE = 72;
		RETREATS_NEAR_TYPE = "flee";
		ATTACK_REACH_RANGE = 128;
		CAUTIOUS_APPROACH = false;
		NPC_RANGED = "1";
		DMG_MELEE = 200;
		DMG_MELEE_TYPE = "pierce";
		HAS_DOT = true;
		MELEE_DOT_DUR = 5;
		MELEE_DOT = 50;
		MELEE_DOT_EFFECT = "effects/dot_poison";

		NEW_NAME = "Dragon Guard Bowman";
	}

	// dg_wpol
	void OnDgWpol()
	{
		// glaive
		// if ( WEAPON_TYPE > 0 ) infomsg all "MAP ERROR" "Dragon guard assigned more than one weapon type."
		if (Truthy(WEAPON_TYPE))
			return;
		WEAPON_TYPE = "3"; // 0-unarmed 1-iceblade 2-hxbow 3-glaive 4-hammer 5-crescents 6-swords
		SetModelBody(1, Int(WEAPON_TYPE));
		NPC_GIVE_EXP += 150.0f;

		ATTACK_REACH_RANGE = 196;
		ATTACK_RANGE = 128.0f;
		ATTACK_HITRANGE = 190.0f;
		ATTACK_MOVERANGE = 96.0f;
		NPC_JUMPER = true;

		NPC_MUST_SEE_TARGET = "0";

		ANIM_IDLE_COMBAT = "pole_idle2";
		ANIM_IDLE_DEEP = "pole_idle1";
		ANIM_ATTACK1 = "pole_close"; // frame_pole_close - push back
		ANIM_ATTACK2 = "plparryl"; // frame_pole_close - push back
		ANIM_ATTACK_REACH = "pole_reach"; // frame_pole_strike (some push back, but less)

		FREQ_REACH_ATTACK = 1.0f;

		FREQ_KICK = 8.0f;

		RETREATS_WHEN_NEAR = true;
		RETREATS_NEAR_RANGE = 96;
		RETREATS_NEAR_TYPE = "walk";

		CAUTIOUS_APPROACH = true;
		DMG_MELEE = 600; // falls off when closer
		DMG_MELEE_TYPE = "pierce";
		HAS_DOT = false;

		NEW_NAME = "Dragon Guard Pikeman";
	}

	// dg_wham
	void OnDgWham()
	{
		// hammer
		// if ( WEAPON_TYPE > 0 ) infomsg all "MAP ERROR" "Dragon guard assigned more than one weapon type."
		if (Truthy(WEAPON_TYPE))
			return;
		WEAPON_TYPE = "4"; // 0-unarmed 1-iceblade 2-hxbow 3-glaive 4-hammer 5-crescents 6-swords
		SetModelBody(1, Int(WEAPON_TYPE));
		NPC_GIVE_EXP += 400.0f;

		ATTACK_REACH_RANGE = 196;
		ATTACK_RANGE = 64.0f;
		ATTACK_HITRANGE = 110.0f;
		ATTACK_MOVERANGE = 48.0f;
		NPC_JUMPER = true;

		FREQ_KICK = 9999.0f; // never kicks (weapon too unweildy)

		ANIM_IDLE_COMBAT = "2w_idle";
		ANIM_IDLE_DEEP = "combat_idle";
		ANIM_ATTACK1 = "2hclosel";
		ANIM_ATTACK2 = "2hcloseh";
		ANIM_ATTACK_REACH = "hammer_reach"; // frame_hammer_slam
		FREQ_REACH_ATTACK = 15.0f;

		CAUTIOUS_APPROACH = false;
		DMG_MELEE = 400;
		DMG_MELEE_TYPE = "blunt";
		HAS_DOT = false;
		CAN_STUN = true;
		STUN_BURST = true;
		STUN_CHANCE = "25%";

		NEW_NAME = "Dragon Guard Mauler";
	}

	// dg_wcre
	void OnDgWcre()
	{
		// crescent blades
		// if ( WEAPON_TYPE > 0 ) infomsg all "MAP ERROR" "Dragon guard assigned more than one weapon type."
		if (Truthy(WEAPON_TYPE))
			return;
		WEAPON_TYPE = "5"; // 0-unarmed 1-iceblade 2-hxbow 3-glaive 4-hammer 5-crescents 6-swords
		SetModelBody(1, Int(WEAPON_TYPE));
		NPC_GIVE_EXP += 200.0f;

		ATTACK_REACH_RANGE = 128;
		ATTACK_RANGE = 52.0f;
		ATTACK_HITRANGE = 70.0f;
		ATTACK_MOVERANGE = MOVERANGE_MELEE_STANDARD;
		NPC_JUMPER = true;

		FREQ_KICK = Random(10, 15);

		ANIM_IDLE_COMBAT = "2w_readyvs";
		ANIM_IDLE_DEEP = "2w_idle";
		ANIM_ATTACK1 = "2wslashl";
		ANIM_ATTACK2 = "2wcloseh";
		ANIM_ATTACK_REACH = "2wreach";
		FREQ_REACH_ATTACK = 10.0f;

		CAUTIOUS_APPROACH = true;
		DMG_MELEE = 100;
		DMG_MELEE_TYPE = "slash";
		HAS_DOT = true;
		MELEE_DOT = 50;
		MELEE_DOT_DUR = 5;
		MELEE_DOT_EFFECT = "effects/dot_poison";

		CAN_THROW = true;
		PROJECTILE_THROW = "proj_crescent";

		NEW_NAME = "Dragon Guard Ravager";
	}

	// dg_wdbl
	void OnDgWdbl()
	{
		// katanas
		// if ( WEAPON_TYPE > 0 ) infomsg all "MAP ERROR" "Dragon guard assigned more than one weapon type."
		if (Truthy(WEAPON_TYPE))
			return;
		WEAPON_TYPE = "6"; // 0-unarmed 1-iceblade 2-hxbow 3-glaive 4-hammer 5-crescents 6-swords
		SetModelBody(1, Int(WEAPON_TYPE));
		NPC_GIVE_EXP += 250.0f;

		ATTACK_REACH_RANGE = 128;
		ATTACK_RANGE = RANGE_MELEE_STANDARD;
		ATTACK_HITRANGE = HITRANGE_MELEE_STANDARD;
		ATTACK_MOVERANGE = MOVERANGE_MELEE_STANDARD;
		NPC_JUMPER = true;

		ANIM_IDLE_COMBAT = "2w_readyvs";
		ANIM_IDLE_DEEP = "deep_idle";
		ANIM_ATTACK1 = "2wslashl";
		ANIM_ATTACK2 = "2wcloseh";
		ANIM_ATTACK_REACH = "2wreach";
		FREQ_REACH_ATTACK = 10.0f;

		CAUTIOUS_APPROACH = true;
		DMG_MELEE = 150;
		DMG_MELEE_TYPE = "dark";
		HAS_DOT = false;
		MELEE_VAMPIRE = true;

		NEW_NAME = "Dragon Guard Bladesman";
	}

	// dg_wfrb
	void OnDgWfrb()
	{
		// red rune blade
		// if ( WEAPON_TYPE > 0 ) infomsg all "MAP ERROR" "Dragon guard assigned more than one weapon type."
		if (Truthy(WEAPON_TYPE))
			return;
		WEAPON_TYPE = "7"; // 0-unarmed 1-iceblade 2-hxbow 3-glaive 4-hammer 5-crescents 6-swords 7-fire_runeblade+shield 8-green_runeblade+shield
		SetModelBody(1, Int(WEAPON_TYPE));
		NPC_GIVE_EXP += 150.0f;

		TAKEDMG_ADJ_FIRE += -0.5f;

		ATTACK_REACH_RANGE = 128;
		ATTACK_RANGE = RANGE_MELEE_STANDARD;
		ATTACK_HITRANGE = HITRANGE_MELEE_STANDARD;
		ATTACK_MOVERANGE = MOVERANGE_MELEE_STANDARD;
		NPC_JUMPER = true;
		FREQ_KICK = 9999.0f; // never kicks (favors sheild bash)

		ANIM_IDLE_COMBAT = "2w_idle";
		ANIM_IDLE_DEEP = "deep_idle";
		ANIM_ATTACK1 = "1h_slash1";
		ANIM_ATTACK2 = "1h_slash2";
		ANIM_ATTACK_REACH = "1h_reach";
		FREQ_REACH_ATTACK = 10.0f;

		CAUTIOUS_APPROACH = true;
		HAS_SHIELD = true;
		DMG_MELEE = 200;
		DMG_MELEE_TYPE = "slash";
		HAS_DOT = true;
		MELEE_DOT = 150;
		MELEE_DOT_DUR = 5;
		MELEE_DOT_EFFECT = "effects/dot_fire";

		NEW_NAME = "Dragon Guard Flameblade";
	}

	// dg_wgrb
	void OnDgWgrb()
	{
		// green rune blade
		// if ( WEAPON_TYPE > 0 ) infomsg all "MAP ERROR" "Dragon guard assigned more than one weapon type."
		if (Truthy(WEAPON_TYPE))
			return;
		WEAPON_TYPE = "8"; // 0-unarmed 1-iceblade 2-hxbow 3-glaive 4-hammer 5-crescents 6-swords 7-fire_runeblade+shield 8-green_runeblade+shield
		SetModelBody(1, Int(WEAPON_TYPE));
		NPC_GIVE_EXP += 200.0f;

		TAKEDMG_ADJ_POISON += -0.5f;

		ATTACK_REACH_RANGE = 128;
		ATTACK_RANGE = RANGE_MELEE_STANDARD;
		ATTACK_HITRANGE = HITRANGE_MELEE_STANDARD;
		ATTACK_MOVERANGE = MOVERANGE_MELEE_STANDARD;
		NPC_JUMPER = true;
		FREQ_KICK = 9999.0f; // never kicks (favors sheild bash)

		ANIM_IDLE_COMBAT = "2w_idle";
		ANIM_IDLE_DEEP = "deep_idle";
		ANIM_ATTACK1 = "1h_slash1";
		ANIM_ATTACK2 = "1h_slash2";
		ANIM_ATTACK_REACH = "1h_reach";
		FREQ_REACH_ATTACK = 10.0f;

		CAUTIOUS_APPROACH = true;
		HAS_SHIELD = true;
		HAS_DOT = true;
		DMG_MELEE = 150;
		DMG_MELEE_TYPE = "slash";
		MELEE_DOT = 50;
		MELEE_DOT_DUR = 10;
		MELEE_DOT_EFFECT = "effects/dot_poison";

		NEW_NAME = "Dragon Guard Plaguebringer";
	}

	// dg_bfir
	void OnDgBfir()
	{
		if (Truthy(GetVar("G_DEVELOPER_MODE")))
			LegacyCommand("stradd", "DEV_STRING", "Breath_Fire ");

		NAME_PREF = "Infernal";

		BREATH_ATTACK = true;
		BREATH_TYPE = "fire";
		NPC_GIVE_EXP += 100.0f;
		BREATH_DOT = 200;
		ANIM_BREATH = "breath_start"; // frame_breath_start
		BREATH_MIN_RANGE = 0;
		BREATH_PUSH_VEL = 200;

		TAKEDMG_ADJ_FIRE += -0.5f;
		TAKEDMG_ADJ_COLD += 0.75f;

		BREATH_RANGE = 256;
		FREQ_BREATH = 20.0f;
	}

	// dg_bice
	void OnDgBice()
	{
		if (IS_RED)
			return;
		if (Truthy(GetVar("G_DEVELOPER_MODE")))
			LegacyCommand("stradd", "DEV_STRING", "Breath_Cold ");
		NAME_PREF = "Freezing";
		DebugPrint("dg_bice");
		BREATH_ATTACK = true;
		BREATH_TYPE = "cold";
		NPC_GIVE_EXP += 200.0f;
		TAKEDMG_ADJ_FIRE += 0.75f;
		TAKEDMG_ADJ_COLD += -0.5f;

		BREATH_DOT = 50;
		BREATH_MIN_RANGE = 0;
		BREATH_PUSH_VEL = 0;
		ANIM_BREATH = "breath_start"; // frame_breath_start

		FREQ_BREATH = 20.0f;
		BREATH_RANGE = 256;
	}

	// dg_bpoi
	void OnDgBpoi()
	{
		if (Truthy(GetVar("G_DEVELOPER_MODE")))
			LegacyCommand("stradd", "DEV_STRING", "Breath_Poison ");
		NAME_PREF = "Noxious";
		BREATH_ATTACK = true;
		BREATH_TYPE = "poison";
		NPC_GIVE_EXP += 100.0f;

		TAKEDMG_ADJ_POISON += -0.5f;
		TAKEDMG_ADJ_ACID += -0.5f;
		TAKEDMG_ADJ_LIGHTNING += 0.75f;

		BREATH_DOT = 50;
		ANIM_BREATH = "breath_start"; // frame_breath_start
		BREATH_MIN_RANGE = 0;
		BREATH_PUSH_VEL = 200;
		FREQ_BREATH = 20.0f;
		BREATH_RANGE = 256;
	}

	// dg_bacd
	void OnDgBacd()
	{
		if (Truthy(GetVar("G_DEVELOPER_MODE")))
			LegacyCommand("stradd", "DEV_STRING", "Breath_Acid ");
		NAME_PREF = "Caustic";
		BREATH_ATTACK = true;
		BREATH_TYPE = "acid";
		NPC_GIVE_EXP += 100.0f;

		TAKEDMG_ADJ_ACID += -0.5f;
		TAKEDMG_ADJ_LIGHTNING += 0.5f;

		ANIM_BREATH = "breath_quick"; // frame_breath_quick
		BREATH_QUICK = true;

		FREQ_BREATH = 6.0f;
		BREATH_RANGE = 1024;
		BREATH_MIN_RANGE = 150;
	}

	// dg_blgt
	void OnDgBlgt()
	{
		if (Truthy(GetVar("G_DEVELOPER_MODE")))
			LegacyCommand("stradd", "DEV_STRING", "Breath_lightning ");
		// setvard NAME_PREF Thundering
		BREATH_ATTACK = true;
		BREATH_TYPE = "lightning";
		NPC_GIVE_EXP += 100.0f;

		TAKEDMG_ADJ_ACID += 0.75f;
		TAKEDMG_ADJ_POISON += 0.5f;
		TAKEDMG_ADJ_LIGHTNING += -0.5f;

		ANIM_BREATH = "breath_quick"; // frame_breath_quick
		BREATH_QUICK = true;
		FREQ_BREATH = 6.0f;
		BREATH_RANGE = 1024;
		BREATH_MIN_RANGE = 0;
	}

	// dg_nbrt
	void OnDgNbrt()
	{
		NO_BREATH = true;
	}

	// dg_npot
	void OnDgNpot()
	{
		NO_POTION = true;
	}

	// dg_potd
	void OnDgPotd()
	{
		if (Truthy(GetVar("G_DEVELOPER_MODE")))
			LegacyCommand("stradd", "DEV_STRING", "Pot_Demonblood ");
		NO_POTION = true;
		POT_SPECIAL = true;
		POT_TYPE = "demon";
		NPC_GIVE_EXP += 750.0f;
	}

	// dg_potp
	void OnDgPotp()
	{
		if (Truthy(GetVar("G_DEVELOPER_MODE")))
			LegacyCommand("stradd", "DEV_STRING", "Pot_Protection");
		NO_POTION = true;
		POT_SPECIAL = true;
		POT_TYPE = "protection";
		NPC_GIVE_EXP += 200.0f;
	}

	// dg_potf
	void OnDgPotf()
	{
		if (Truthy(GetVar("G_DEVELOPER_MODE")))
			LegacyCommand("stradd", "DEV_STRING", "Pot_Faura ");
		NO_POTION = true;
		POT_SPECIAL = true;
		POT_TYPE = "faura";
		NPC_GIVE_EXP += 100.0f;
	}

	// dg_pots
	void OnDgPots()
	{
		if (Truthy(GetVar("G_DEVELOPER_MODE")))
			LegacyCommand("stradd", "DEV_STRING", "Pot_Speed ");
		NO_POTION = true;
		POT_SPECIAL = true;
		POT_TYPE = "speed";
		NPC_GIVE_EXP += 500.0f;
	}

	// frame_kick_strike
	void OnFrameKickStrike()
	{
		if (IS_ARMORED)
			PlaySound(2, 10, SOUNDA_NPC_JUMP);
		else
			PlaySound(2, 10, SOUND_NPC_JUMP);
		PlayRandomSound(0, 10, SOUND_MELEE1, SOUND_MELEE2);
		DoDamageEx(NPCATK_TARGET, HITRANGE_MELEE_STANDARD, DMG_KICK, "90%", ENT_ME, ENT_ME, "none", "blunt", "dmgevent:kick");
		ANIM_ATTACK = ANIM_ATTACK1;
	}

	// kick_dodamage
	void OnKickDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		if (!hit)
			return;
		AddVelocity(target, RelativeVelocity(Vector3(0, 300, 110)));
		ApplyEffect(target, "effects/debuff_stun", 5.0f, self);
	}

	// frame_melee_strike
	// ================================== ANIM EVENTS
	void OnFrameMeleeStrike()
	{
		PlayRandomSound(0, 10, SOUND_MELEE1, SOUND_MELEE2);
		if (IS_ARMORED)
		{
			if (RandomInt(1, 5) == 1)
				PlayRandomSound(2, 10, SOUNDA_ATTACK1, SOUNDA_ATTACK2, SOUNDA_ATTACK3);
		}
		else if (RandomInt(1, 5) == 1)
			PlayRandomSound(2, 10, SOUND_ATTACK1, SOUND_ATTACK2, SOUND_ATTACK3);
		MELEE_ATTACK = true;
		DoDamage(NPCATK_TARGET, ATTACK_HITRANGE, DMG_MELEE, "90%", DMG_MELEE_TYPE);
	}

	// frame_reach_strike
	void OnFrameReachStrike()
	{
		if (IS_ARMORED)
		{
			if (RandomInt(1, 3) == 1)
				PlayRandomSound(2, 10, SOUNDA_ATTACK1, SOUNDA_ATTACK2, SOUNDA_ATTACK3);
		}
		else if (RandomInt(1, 3) == 1)
			PlayRandomSound(2, 10, SOUND_ATTACK1, SOUND_ATTACK2, SOUND_ATTACK3);
		PlayRandomSound(0, 10, SOUND_MELEE1, SOUND_MELEE2);
		MELEE_ATTACK = true;
		float hitRange = ATTACK_HITRANGE * 1.5f;
		DoDamage(NPCATK_TARGET, hitRange, DMG_MELEE, "90%", DMG_MELEE_TYPE);
		ANIM_ATTACK = ANIM_ATTACK_DEFAULT;
		ATTACK_RANGE = ATTACK_RANGE_DEFAULT;
	}

	// frame_hammer_slam
	void OnFrameHammerSlam()
	{
		if (IS_ARMORED)
			PlayRandomSound(2, 10, SOUNDA_ATTACK1, SOUNDA_ATTACK2, SOUNDA_ATTACK3);
		else
			PlayRandomSound(2, 10, SOUND_ATTACK1, SOUND_ATTACK2, SOUND_ATTACK3);
		ANIM_ATTACK = ANIM_ATTACK_DEFAULT;
		ATTACK_RANGE = ATTACK_RANGE_DEFAULT;
		PlaySound(0, 10, SOUND_MELEE_LARGE);
		BURST_START = RelativePosition(Vector3(0, 150, 0));
		ClientEvent("new", "all", "effects/sfx_stun_burst", BURST_START, 256, 0);
		BURST_START.z += 32.0f;
		BURST_TARGS = LegacyFunction("get_tsphere", "enemy", 256, BURST_START);
		if (BURST_TARGS == "none")
			return;
		int count = GetTokenCount(BURST_TARGS);
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnStunBurstAffectTargets();
		}
	}

	// stun_burst_affect_targets
	void OnStunBurstAffectTargets()
	{
		string curTarg = GetToken(BURST_TARGS, loopIteration);
		if (!IsOnGround(curTarg))
			return;
		ApplyEffect(curTarg, "effects/debuff_stun", 5.0f, self);
		Vector3 targOrg = OriginOf(curTarg);
		Vector3 myOrg = BURST_START;
		float newYaw = AnglesTo(myOrg, targOrg);
		DoDamageEx(curTarg, "direct", DMG_STUN_BURST, "100%", ENT_ME, ENT_ME, "none", "blunt");
		AddVelocity(curTarg, RelativeVelocity(Vector3(0, newYaw, 0), Vector3(0, 1000, 200)));
	}

	// frame_pole_close
	void OnFramePoleClose()
	{
		PlayRandomSound(0, 10, SOUND_MELEE1, SOUND_MELEE2);
		AddVelocity(NPCATK_TARGET, RelativeVelocity(Vector3(0, 300, 110)));
		int dmgMelee = 100;
		DoDamage(NPCATK_TARGET, HITRANGE_POLE_SHORT, dmgMelee, "90%", DMG_MELEE_TYPE);
	}

	// frame_pole_strike
	void OnFramePoleStrike()
	{
		if (IS_ARMORED)
		{
			if (RandomInt(1, 3) == 1)
				PlayRandomSound(2, 10, SOUNDA_ATTACK1, SOUNDA_ATTACK2, SOUNDA_ATTACK3);
		}
		else if (RandomInt(1, 3) == 1)
			PlayRandomSound(2, 10, SOUND_ATTACK1, SOUND_ATTACK2, SOUND_ATTACK3);
		PlayRandomSound(0, 10, SOUND_MELEE1, SOUND_MELEE2);

		if (!IsAlive(NPCATK_TARGET)) // in case dies/disconnects before strike, and we dun wanna divide by zero
			return;
		float rangeRatio = Divide(RangeTo(NPCATK_TARGET), ATTACK_RANGE);
		float halfMax = DMG_MELEE * 0.5f;
		float dmgMelee = Ratio(rangeRatio, halfMax, DMG_MELEE);
		if (Truthy(NPC_MUST_SEE_TARGET))
			DoDamage(NPCATK_TARGET, ATTACK_HITRANGE, dmgMelee, "90%", DMG_MELEE_TYPE);
		else if (RangeTo(NPCATK_TARGET) < ATTACK_HITRANGE)
			DoDamage(NPCATK_TARGET, "direct", dmgMelee, "90%", ENT_ME, DMG_MELEE_TYPE);
	}

	// frame_shield_bash
	void OnFrameShieldBash()
	{
		if (!(RangeTo(NPCATK_TARGET) < 64.0f))
			return;
		float dmgMelee = DMG_MELEE * 0.25f;
		DoDamageEx(NPCATK_TARGET, ATTACK_HITRANGE, dmgMelee, "90%", ENT_ME, ENT_ME, "none", "blunt", "dmgevent:shieldbash");
	}

	// shieldbash_dodamage
	void OnShieldbashDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		if (!hit)
			return;
		AddVelocity(NPCATK_TARGET, RelativeVelocity(Vector3(0, 200, 110)));
		ApplyEffect(NPCATK_TARGET, "effects/debuff_stun", 5.0f, self);
		PlaySound(0, 10, "body/armour1.wav");
	}

	// frame_drink_done
	void OnFrameDrinkDone()
	{
		bool fumblePotion = false;
		int count;
		// fumble potion if flinched in last three seconds
		float lastFlinchP3 = 0.0f;
		lastFlinchP3 += 3.0f;
		if (GameTime() < lastFlinchP3)
			fumblePotion = false;

		// healing potion
		if (DO_HEAL)
		{
			DO_HEAL = false;
			HEAL_READY = false;
			if (!fumblePotion)
			{
				Effect("glow", ENT_ME, Vector3(0, 255, 255), 64, 1.0f, 1.0f);
				PlaySound(0, 10, "magic/cast.wav");
				float hpToGive = MaxHealthOf(ENT_ME) - HealthOf(ENT_ME);
				GiveHealth(ENT_ME, hpToGive);

				POT_OUT_MSG = "Quaffs a potion of healing.";
				PLR_POT_ALERT_LIST = GetActivePlayers();
				if (PLR_POT_ALERT_LIST != "none")
				{
					count = GetTokenCount(PLR_POT_ALERT_LIST);
					for (int i = 0; i < count; i++)
					{
						loopIteration = i;
						OnPotMessage();
					}
				}
			}
		}

		if (POT_SPECIAL)
		{
			POT_SPECIAL = false;
			if (!fumblePotion)
			{
				if (POT_TYPE == "demon")
				{
					POT_OUT_MSG = "Quaffs a potion of demon blood.";
					DEMON_NOHP_LOSS = true;
					OnDemonBlood();
				}
				if (POT_TYPE == "protection")
				{
					POT_OUT_MSG = "Quaffs a potion of greater protection.";
					ApplyEffect(ENT_ME, "effects/protection", 9999, 0.5f);
				}
				if (POT_TYPE == "faura")
				{
					POT_OUT_MSG = "Quaffs a potion of flame aura.";
					float curColdDmg = DamageTakenOf(ENT_ME, "cold") * 0.5f;
					SetDamageTaken("cold", curColdDmg);
					OnExtFireAuraActivate();
				}
				if (POT_TYPE == "speed")
				{
					POT_OUT_MSG = "Quaffs a potion of speed.";
					ClientEvent("persist", "all", "effects/sfx_motionblur_perm", IndexOf(ENT_ME), 0);
					OnSpeedX25();
				}

				PLR_POT_ALERT_LIST = GetActivePlayers();
				if (PLR_POT_ALERT_LIST != "none")
				{
					count = GetTokenCount(PLR_POT_ALERT_LIST);
					for (int i = 0; i < count; i++)
					{
						loopIteration = i;
						OnPotMessage();
					}
				}
			}
		}

		if (SUSPEND_AI)
			OnNpcatkResumeAi();

		SetModelBody(1, Int(WEAPON_TYPE));
	}

	// reset_weapon_submodel
	void OnResetWeaponSubmodel()
	{
		SetModelBody(1, Int(WEAPON_TYPE));
	}

	// pot_message
	void OnPotMessage()
	{
		CBasePlayer@ curPlayer = FindPlayer(GetToken(PLR_POT_ALERT_LIST, loopIteration));
		if (!(RangeTo(curPlayer) < 1024.0f))
			return;
		InfoMessage(curPlayer, NameOf(ENT_ME), POT_OUT_MSG);
	}

	// ext_fire_aura_activate
	// ================================== Fire Aura, from player/externals
	// (dot and size are fixed)
	void OnExtFireAuraActivate(string dot = "", int size = 0)
	{
		if (DG_FAURA)
			return;
		DG_FAURA = true;

		ClientEvent("new", "all", "items/armor_faura_cl", IndexOf(ENT_ME), DG_FAURA_AOE, DG_FAURA_CL_RATE, 1);
		DG_FAURA_CLIDX = LastClientScriptId();
		DG_FAURA_NEXT_CL = GameTime() + DG_FAURA_CL_RATE;
		OnFireAuraLoop();
	}

	// fire_aura_loop
	void OnFireAuraLoop()
	{
		if (!DG_FAURA)
			return;
		if (!IsAlive(ENT_ME))
			return;
		CallEventDelayed(1.0f, "fire_aura_loop");

		float gameTime = GameTime();

		if (gameTime > DG_FAURA_NEXT_CL)
		{
			ClientEvent("new", "all", "items/armor_faura_cl", IndexOf(ENT_ME), DG_FAURA_AOE, DG_FAURA_CL_RATE, 1);
			DG_FAURA_CLIDX = LastClientScriptId();
			DG_FAURA_NEXT_CL = gameTime + DG_FAURA_CL_RATE;
		}

		float scanAoe = DG_FAURA_AOE * 1.5f;
		DG_FAURA_SCAN = FindInSphere("enemy", scanAoe); // scan extra distance to make up for monster width
		// dbg fire_aura_loop DG_FAURA_SCAN
		if (DG_FAURA_SCAN == "none")
			return;
		// dbg fire_aura_loop $get_token_amt(DG_FAURA_SCAN) DG_FAURA_SCAN
		int count = GetTokenCount(DG_FAURA_SCAN);
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnFireAuraBurn();
		}
	}

	// fire_aura_burn
	void OnFireAuraBurn()
	{
		CBaseEntity@ curTarg = FindEntity(GetToken(DG_FAURA_SCAN, loopIteration));

		ApplyEffect(curTarg, "effects/dot_fire", 5.0f, self, DG_FAURA_DOT);
	}

	// frame_breath_start
	// ================================== Breath Attacks
	void OnFrameBreathStart()
	{
		// fire, cold, and poison cones
		if (Truthy(BREATH_ON))
			return;
		SetRoam(false);
		OnNpcatkSuspendAi("5.0");
		OnNpcatkSuspendMovement(ANIM_BREATH_LOOP, "5.0");
		ClientEvent("new", "all", "monsters/dragon_guard_breath_cl", IndexOf(ENT_ME), BREATH_TYPE);
		BREATH_CL_IDX = LastClientScriptId();
		BREATH_ON = "1";
		OnBreathLoop();
		ServerPlaySound(1, 10, SOUND_BREATH_LOOP);
		CallEventDelayed(5.0f, "breath_attack_end");

		// redundant
		NEXT_BREATH = GameTime() + FREQ_BREATH;
	}

	// breath_loop
	void OnBreathLoop()
	{
		if (!Truthy(BREATH_ON))
			return;
		CallEventDelayed(0.5f, "breath_loop");
		float breathRange = BREATH_RANGE * 2.0f;
		BREATH_TARGS = FindInSphere("enemy", breathRange);
		if (BREATH_TARGS == "none")
			return;
		int count = GetTokenCount(BREATH_TARGS);
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnBreathAffectTargets();
		}
	}

	// breath_affect_targets
	void OnBreathAffectTargets()
	{
		CBaseEntity@ curTarg = FindEntity(GetToken(BREATH_TARGS, loopIteration));
		Vector3 targOrg = OriginOf(curTarg);
		if (!WithinCone2D(targOrg, MyOrigin(), MyAngles(), 10))
			return;
		Vector3 traceStart = OriginOf(ENT_ME) + RelativePosition(Vector3(0, 24, 80));
		string traceEnd = Text(targOrg);
		string traceLine = LegacyFunction("get_traceline", traceStart, traceEnd, "worldonly");
		if (traceLine == traceEnd)
			return;
		if (BREATH_TYPE == "cold")
			ApplyEffect(curTarg, "effects/dot_cold_freeze", 6.0f, self, BREATH_DOT);
		if (BREATH_TYPE == "fire")
			ApplyEffect(curTarg, "effects/dot_fire", 5.0f, self, BREATH_DOT);
		if (BREATH_TYPE == "poison")
			ApplyEffect(curTarg, "effects/dot_poison_blind", 5.0f, self, BREATH_DOT);
		AddVelocity(curTarg, RelativeVelocity(Vector3(0, BREATH_PUSH_VEL, 0)));
	}

	// breath_attack_end
	void OnBreathAttackEnd()
	{
		OnNpcatkResumeAi();
		OnNpcatkResumeMovement();
		PlayAnim("break");
		SetRoam(true);
		BREATH_ON = "0";
		ServerPlaySound(1, 0, SOUND_BREATH_LOOP);
		// redundant
		NEXT_BREATH = GameTime() + FREQ_BREATH;
	}

	// frame_breath_quick
	void OnFrameBreathQuick()
	{
		if (BREATH_TYPE == "acid")
		{
			PlaySound(0, 10, SOUND_BREATH_ACID_BOLT);
			TossProjectile("proj_acid_bolt", RelativePosition(Vector3(0, 24, 35)), NPCATK_TARGET, 300, 800, 0.1f, "none"); // <view|(origin)|id> <speed> <dmg> <cof> <projectile scriptname> [start offset]
		}

		if (BREATH_TYPE == "lightning")
		{
			PlaySound(0, 10, SOUND_BREATH_LIGHTNING);
			Vector3 beamStart = AttachmentPositionOf(ENT_ME, 0);
			Vector3 beamEnd = OriginOf(NPCATK_TARGET);
			Vector3 beamAngs = Angles3DTo(beamStart, beamEnd);
			beamAngs.x = -beamAngs.x;
			beamEnd += RelativePosition(beamAngs, Vector3(0, 1024, 0));
			Effect("beam", "end", "lgtning.spr", 60, beamEnd, ENT_ME, 1, Vector3(255, 255, 0), 200, 20, 1.0f);
			DoDamageEx(beamStart, beamEnd, 500, "100%", ENT_ME, ENT_ME, "none", "lightning", "dmgevent:zapbreath");
		}
		NEXT_BREATH = GameTime() + FREQ_BREATH;
	}

	// zapbreath_dodamage
	void OnZapbreathDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		if (!hit)
			return;
		if (RelationshipOf(target, ENT_ME) != "enemy")
			return;
		ApplyEffect(target, "effects/dot_lightning", 5.0f, self, 200);
	}

	// frame_throw
	void OnFrameThrow()
	{
		// <projectile scriptname> <"view"|(src_origin)> <target|(targ_origin)|none> <speed> <damage> <cof> <skill|none> //Converted to use new tossprojectile //greatguys1@FEB2022
		if (Float(WEAPON_TYPE) == 5.0f)
			TossProjectile("proj_crescent", RelativePosition(Vector3(-20, 0, 3)), NPCATK_TARGET, 200, 0, 0, "none");
	}

	// frame_xbow
	// borrwing from torkie elves here (somewhat modified)
	void OnFrameXbow()
	{
		if (GameTime() > NEXT_SPLODIE_BOLT)
		{
			EXPLOSIVE_BOLT = true;
			NEXT_SPLODIE_BOLT = GameTime() + 3.0f;
		}
		else
		{
			EXPLOSIVE_BOLT = false;
		}

		PlaySound(1, 10, SOUND_XBOW_SHOOT);

		Vector3 startLine = BonePositionOf(ENT_ME, 25);
		Vector3 targOrg = OriginOf(NPCATK_TARGET);

		if (EXPLOSIVE_BOLT)
			targOrg.z = GroundHeight(targOrg);

		if (RandomInt(1, 100) > XBOW_ACCURACY)
		{
			DebugPrint("elf_shoot_xbow miss"); // miss slightly
			float rndX = Random(-64, 64);
			float rndY = Random(-64, 64);
			targOrg.x += rndX;
			targOrg.y += rndY;
			targOrg.z = GroundHeight(targOrg);
		}

		ELF_AIM_ANGLES = Angles3DTo(startLine, targOrg);
		DebugPrint("before " + Text(ELF_AIM_ANGLES));
		ELF_AIM_ANGLES.x = -ELF_AIM_ANGLES.x;
		DebugPrint("after " + Text(ELF_AIM_ANGLES));
		string endLine = Text(startLine);
		endLine = Text(Vec(endLine) + RelativePosition(ELF_AIM_ANGLES, Vector3(0, 2048, 0)));
		ELF_XBOW_SHOT = true;
		endLine = LegacyFunction("get_traceline", startLine, endLine, "worldonly");
		ELF_BOLT_LAND = endLine;

		// if ( G_DEVELOPER_MODE ) effect beam point lgtning.spr 30 START_LINE END_LINE (255,0,0) 255 0 1.0
		MISS_COUNT += 1.0f;
		DoDamageEx(startLine, endLine, DMG_XBOW, "100%", ENT_ME, ENT_ME, "none", "pierce", "dmgevent:xbow");
		ClientEvent("new", "all", "monsters/elf_xbow_cl", startLine, ELF_BOLT_LAND, AnglesOf(ENT_ME), EXPLOSIVE_BOLT);
		if (!EXPLOSIVE_BOLT)
			return;
		CallEventDelayed(0.1f, "bolt_explode");
	}

	// bolt_explode
	void OnBoltExplode()
	{
		DoDamageEx(ELF_BOLT_LAND, 128, DMG_XBOW, 0.2f, ENT_ME, ENT_ME, "none", "fire_effect", "dmgevent:exbow");
	}

	// xbow_dodamage
	void OnXbowDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		if (!hit)
			return;
		MISS_COUNT = 0.0f;
	}

	// exbow_dodamage
	void OnExbowDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		if (!hit)
			return;
		MISS_COUNT = 0.0f;
		Vector3 targOrg = OriginOf(target);
		float targAng = AnglesTo(Vec(ELF_BOLT_LAND), targOrg);
		float targDist = Divide(Distance(targOrg, Vec(ELF_BOLT_LAND)), 128.0f);
		float pushStr = Float(LegacyFunction("get_skill_ratio", targDist, 600, 100));
		DebugPrint("game_dodamage str " + Text(pushStr) + " ratio " + Text(targDist));
		SetVelocity(target, RelativeVelocity(Vector3(0, targAng, 0), Vector3(10, pushStr, 120)));
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files

	// npcatk_suspend_ai
	void OnNpcatkSuspendAi(string seconds = "", string debugTag = "")
	{
		BaseNpcAttackNew_OnNpcatkSuspendAi(seconds, debugTag); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcatkSuspendAi(seconds, debugTag); // monsters/base_monster_shared
	}

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("rain_mist.spr");
		Precache("explode1.spr");
		Precache("poison_cloud.spr");
		Precache("monsters/dragon_guard.mdl");
		Precache("monsters/goblin/sps_fogfire.wav");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		DragonGuard_FirstThink();
		DragonGuard_FirstThink2();
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
		if (name == "bolt_explode") { OnBoltExplode(); return true; }
		if (name == "breath_affect_targets") { OnBreathAffectTargets(); return true; }
		if (name == "breath_attack_end") { OnBreathAttackEnd(); return true; }
		if (name == "breath_loop") { OnBreathLoop(); return true; }
		if (name == "cycle_down") { OnCycleDown(); return true; }
		if (name == "cycle_up") { OnCycleUp(Param(params, 0)); return true; }
		if (name == "dev_text") { OnDevText(); return true; }
		if (name == "dg_armr") { OnDgArmr(); return true; }
		if (name == "dg_bacd") { OnDgBacd(); return true; }
		if (name == "dg_bfir") { OnDgBfir(); return true; }
		if (name == "dg_bice") { OnDgBice(); return true; }
		if (name == "dg_black") { OnDgBlack(); return true; }
		if (name == "dg_blgt") { OnDgBlgt(); return true; }
		if (name == "dg_bpoi") { OnDgBpoi(); return true; }
		if (name == "dg_narm") { OnDgNarm(); return true; }
		if (name == "dg_nbrt") { OnDgNbrt(); return true; }
		if (name == "dg_npot") { OnDgNpot(); return true; }
		if (name == "dg_potd") { OnDgPotd(); return true; }
		if (name == "dg_potf") { OnDgPotf(); return true; }
		if (name == "dg_potp") { OnDgPotp(); return true; }
		if (name == "dg_pots") { OnDgPots(); return true; }
		if (name == "dg_red") { OnDgRed(); return true; }
		if (name == "dg_wbow") { OnDgWbow(); return true; }
		if (name == "dg_wcre") { OnDgWcre(); return true; }
		if (name == "dg_wdbl") { OnDgWdbl(); return true; }
		if (name == "dg_wfrb") { OnDgWfrb(); return true; }
		if (name == "dg_wgrb") { OnDgWgrb(); return true; }
		if (name == "dg_wham") { OnDgWham(); return true; }
		if (name == "dg_wice") { OnDgWice(); return true; }
		if (name == "dg_wpol") { OnDgWpol(); return true; }
		if (name == "dragon_guard_finalize") { OnDragonGuardFinalize(); return true; }
		if (name == "exbow_dodamage") { OnExbowDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5)); return true; }
		if (name == "ext_fire_aura_activate") { OnExtFireAuraActivate(Param(params, 0), Int(Param(params, 1))); return true; }
		if (name == "fire_aura_burn") { OnFireAuraBurn(); return true; }
		if (name == "fire_aura_loop") { OnFireAuraLoop(); return true; }
		if (name == "frame_breath_quick") { OnFrameBreathQuick(); return true; }
		if (name == "frame_breath_start") { OnFrameBreathStart(); return true; }
		if (name == "frame_drink_done") { OnFrameDrinkDone(); return true; }
		if (name == "frame_hammer_slam") { OnFrameHammerSlam(); return true; }
		if (name == "frame_kick_strike") { OnFrameKickStrike(); return true; }
		if (name == "frame_melee_strike") { OnFrameMeleeStrike(); return true; }
		if (name == "frame_pole_close") { OnFramePoleClose(); return true; }
		if (name == "frame_pole_strike") { OnFramePoleStrike(); return true; }
		if (name == "frame_reach_strike") { OnFrameReachStrike(); return true; }
		if (name == "frame_shield_bash") { OnFrameShieldBash(); return true; }
		if (name == "frame_throw") { OnFrameThrow(); return true; }
		if (name == "frame_xbow") { OnFrameXbow(); return true; }
		if (name == "game_damaged") { Return(OnGameDamaged(EntityParam(params, 0), Float(Param(params, 1)), Param(params, 2), Float(Param(params, 3)), EntityParam(params, 4), Param(params, 5))); return true; }
		if (name == "game_death") { OnGameDeath(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_dodamage") { Return(OnGameDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5))); return true; }
		if (name == "game_heardsound") { OnGameHeardsound(Param(params, 0), Vec(Param(params, 1)), Float(Param(params, 2))); return true; }
		if (name == "game_precache") { OnGamePrecache(); return true; }
		if (name == "kick_dodamage") { OnKickDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5)); return true; }
		if (name == "my_target_died") { OnMyTargetDied(Param(params, 0)); return true; }
		if (name == "npc_post_spawn") { OnNpcPostSpawn(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "npc_targetsighted") { OnNpcTargetsighted(Param(params, 0)); return true; }
		if (name == "npcatk_hunt") { OnNpcatkHunt(); return true; }
		if (name == "pick_specials") { OnPickSpecials(); return true; }
		if (name == "pot_message") { OnPotMessage(); return true; }
		if (name == "reset_weapon_submodel") { OnResetWeaponSubmodel(); return true; }
		if (name == "shieldbash_dodamage") { OnShieldbashDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5)); return true; }
		if (name == "stun_burst_affect_targets") { OnStunBurstAffectTargets(); return true; }
		if (name == "xbow_dodamage") { OnXbowDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5)); return true; }
		if (name == "zapbreath_dodamage") { OnZapbreathDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5)); return true; }
		return BaseJumper_DispatchEvent(name, params)
			|| BaseMonsterNewScript::DispatchEvent(name, params);
	}
}
