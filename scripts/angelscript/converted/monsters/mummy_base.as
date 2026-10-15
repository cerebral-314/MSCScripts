#pragma context server

// Converted from monsters/mummy_base.script by msc_transpiler.
// Top script must set initial attack animations and ranges, as they vary by type
// - make turnable
// - poison breath
// - lightning
// - undead summon

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_monster_new.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class MummyBase
{
	// Constants
	string ANIM_BREATH_START = "walkB";
	string ANIM_BREATH_WALK = "walkB1";
	string ANIM_EAT = "eat";
	string ANIM_SQUAT = "trauma";
	string ANIM_EAT_TO_STAND = "Egetup";
	string ANIM_SQUAT_TO_STAND = "Tgetup";
	string ANIM_BREATH_PREP = "walkB";
	string ANIM_BREATH = "walkB1";
	string ANIM_ATTACK_SHORT = "steelpipe";
	string ANIM_ATTACK_LONG = "longslash";
	string ANIM_HEAL = "stab";
	string ANIM_FLINCH1 = "flinch";
	string ANIM_FLINCH2 = "flinch1";
	string ANIM_DEATH1 = "dieforward";
	string ANIM_DEATH2 = "diebackward";
	string ANIM_PRE_REBIRTH1 = "seizure";
	string ANIM_REBIRTH1 = "getupforw";
	string ANIM_DEATH_IDLE1 = "dieforward_idle";
	string ANIM_PRE_REBIRTH2 = "seizure1";
	string ANIM_REBIRTH2 = "getupback";
	string ANIM_DEATH_IDLE2 = "diebackward_idle";
	string ANIM_UNARMED1 = "slash";
	string ANIM_UNARMED2 = "slash1";
	string ANIM_UNARMED3 = "stab1";
	string ANIM_BITE = "bite";
	string ANIM_STEELPIPE = "steelpipe";
	string ANIM_PIKE_HOLD = "pike_hold";
	string ANIM_SUMMON = "pike_hold";
	string FLINCH_CHANCE = "20%";
	string MUMMY_MELEE_DMG_TYPE = "slash";
	bool MUMMY_MUNCHES = false;
	float FREQ_MUMMY_BITE = 10.0f;
	int ATTACK_RANGE_SHORT = 64;
	int ATTACK_HITRANGE_SHORT = 96;
	int ATTACK_RANGE_LONG = 140;
	int ATTACK_HITRANGE_LONG = 175;
	int ATTACK_RANGE_BITE = 52;
	int ATTACK_HITRANGE_BITE = 53;
	string ATTACK_HITCHANCE = "80";
	string ATTACK_TYPE = "short";
	int MUMMY_STARTING_LIVES = 1;
	int AURA_TYPE = 0;
	int AURA_RANGE = 100;
	float DMG_SLASH = 200.0f;
	int DMG_LONGSLASH = 400;
	int DMG_STAB = 400;
	int DMG_STEELPIPE = 200;
	float DMG_BITE = 1000.0f;
	bool MUMMY_IS_CLERIC = false;
	bool MUMMY_BREATH_ATTACK = false;
	string MUMMY_BREATH_ATTACK_TYPE = "bile";
	int MUMMY_BREATH_DOT = 50;
	float MUMMY_BREATH_DOT_DURATION = 10.0f;
	int MUMMY_BREATH_ATTACK_RANGE = 300;
	int MUMMY_BREATH_ATTACK_OFS = 150;
	int MUMMY_BREATH_CONE = 30;
	float FREQ_MUMMY_BREATH_ATTACK = 35.0f;
	float MUMMY_BREATH_DURATION = 4.0f;
	string MUMMY_BREATH_ATTACK_CLSCRIPT = "monsters/mummy_bile_attack_cl";
	bool MUMMY_BEAM_ATTACK = false;
	float FREQ_MUMMY_BEAM_ATTACK = 0.0f;
	float DMG_PUSH_BEAM = 50.0f;
	float MUMMY_BEAM_DUR = 5.0f;
	string SOUND_LOOP_AURA1 = "magic/chant_loop.wav";
	string SOUND_LOOP_AURA2 = "magic/haunted_loop.wav";
	string SOUND_STRUCK1 = "weapons/cbar_hitbod1.wav";
	string SOUND_STRUCK2 = "weapons/cbar_hitbod2.wav";
	string SOUND_STRUCK3 = "weapons/cbar_hitbod3.wav";
	string SOUND_ATTACK1 = "zombie/claw_miss1.wav";
	string SOUND_ATTACK2 = "zombie/claw_miss2.wav";
	string SOUND_DEATH = "agrunt/ag_die3.wav";
	string SOUND_BREATH_PREP = "monsters/mummy/c_mummycom_bat2.wav";
	string SOUND_MUMMY_BREATH = "monsters/mummy/c_mummycom_bat1.wav";
	string SOUND_BREATH_LOOP = "magic/bolt_loop.wav";
	string SOUND_BREATH_END = "magic/bolt_end.wav";
	string SOUND_HEALED = "magic/heal_strike.wav";
	string SOUND_HEAL_OTHER = "magic/cast.wav";
	string SOUND_BITE_START = "monsters/mummy/c_mummycom_bat2.wav";
	string SOUND_BITE_HIT = "bullchicken/bc_bite3.wav";
	string SOUND_PIKE_TOSS = "zombie/claw_miss2.wav";
	string SOUND_SUMMON = "magic/spawn_loud.wav";
	string SOUND_BEAM_START = "magic/bolt_end.wav";
	string SOUND_BEAM_LOOP = "magic/bolt_loop.wav";

	// Variables (an unset .script variable reads as its own name)
	string ANIM_DEATH = "ANIM_DEATH";
	float FLINCH_HEALTH_RATIO = 0.0f;
	string MUMMY_CLERIC_RANGE = "MUMMY_CLERIC_RANGE";
	string MUMMY_MELEE_DMG_TYPE_FINAL = "MUMMY_MELEE_DMG_TYPE_FINAL";
	float MUMMY_DMG_SLASH = 0.0f;
	int MUMMY_DMG_LONGSLASH = 0;
	int MUMMY_DMG_STAB = 0;
	int MUMMY_DMG_STEELPIPE = 0;
	string MUMMY_NAME = "MUMMY_NAME";
	float MUMMY_LIVES = 0.0f;
	string NPC_PROXACT_RANGE = "NPC_PROXACT_RANGE";
	string MUMMY_DEFAULT_ANIM_RUN = "MUMMY_DEFAULT_ANIM_RUN";
	string MUMMY_DEFAULT_ANIM_WALK = "MUMMY_DEFAULT_ANIM_WALK";
	string MUMMY_DEFAULT_ANIM_IDLE = "MUMMY_DEFAULT_ANIM_IDLE";
	float FLINCH_HEALTH = 0.0f;
	float ATTACK_RANGE = 0.0f;
	float ATTACK_HITRANGE = 0.0f;
	float ATTACK_MOVERANGE = 0.0f;
	bool MUMMY_START_SQUAT = false;
	bool MUMMY_START_EAT = false;
	bool MUMMY_CYCLES_STARTED = false;
	float MUMMY_CUR_CYCLE_ATTACK = 0.0f;
	bool MUMMY_BACKHAND = false;
	bool MUMMY_HEAL_FLAG = false;
	bool MUMMY_PUSH_ATTACK = false;
	bool MUMMY_TOSSING_PIKE = false;
	bool MUMMY_STUN_ATTACK = false;
	float MUMMY_NEXT_BITE = 0.0f;
	string ANIM_ATTACK = "ANIM_ATTACK";
	string REPULSE_TARGETS = "REPULSE_TARGETS";
	string MUMMY_ICE_TARGETS = "MUMMY_ICE_TARGETS";
	bool NPC_PROXACT_TRIPPED = false;
	bool NPC_PROXACT_IFSEEN = false;
	bool NPC_PROX_ACTIVATE = false;
	string NPC_PROXACT_EVENT = "NPC_PROXACT_EVENT";
	bool NPC_PROXACT_FOV = false;
	int NPC_PROXACT_CONE = 0;
	string MUMMY_RESUME_MODE = "MUMMY_RESUME_MODE";
	float AS_ATTACKING = 0.0f;
	string PLAYING_DEAD = "PLAYING_DEAD";
	string ANIM_DEATH_IDLE = "ANIM_DEATH_IDLE";
	bool NPC_NO_ATTACK = false;
	string NO_STUCK_CHECKS = "NO_STUCK_CHECKS";
	string CAN_HEAR = "CAN_HEAR";
	string ANIM_RUN = "ANIM_RUN";
	string ANIM_WALK = "ANIM_WALK";
	string ANIM_IDLE = "ANIM_IDLE";
	string MUMMY_REBIRTH_SCAN = "MUMMY_REBIRTH_SCAN";
	bool MUMMY_CANT_GET_UP = false;
	bool MUMMY_REALLY_CANT_GET_UP = false;
	float NPC_GIVE_EXP = 0.0f;
	string NPC_PREV_TARGET = "NPC_PREV_TARGET";
	bool MUMMY_HIT_BY_HOLY = false;
	string MUMMY_HEAL_LIST = "MUMMY_HEAL_LIST";
	float MUMMY_NO_HEALS = 0.0f;
	string MUMMY_HEAL_TARGET = "MUMMY_HEAL_TARGET";
	bool NPC_FORCED_MOVEDEST = false;
	string FLINCH_ANIM = "FLINCH_ANIM";
	float MUMMY_NEXT_PIKE_TOSS = 0.0f;
	float MUMMY_NEXT_SUMMON = 0.0f;
	float MUMMY_NSUMMONS = 0.0f;
	bool MUMMY_BEAMING = false;
	string MUMMY_BEAM_TARGET = "MUMMY_BEAM_TARGET";
	string MUMMY_BEAM_ID = "MUMMY_BEAM_ID";
	float MUMMY_BEAM_ABORT_TIME = 0.0f;
	bool MUMMY_BREATHING = false;
	string MUMMY_BREATH_TARGET = "MUMMY_BREATH_TARGET";
	string MUMMY_BREATH_TARGETS = "MUMMY_BREATH_TARGETS";

	// unnamed block (first think)
	void MummyBase_FirstThink()
	{
		// base anims
		ANIM_DEATH = "dieforward";
	}

	// unnamed block (first think)
	void MummyBase_FirstThink2()
	{
		// custom stats
		FLINCH_HEALTH_RATIO = 0.25f; // ratio of health mummy must be down to before it's possible to make them flinch
		MUMMY_CLERIC_RANGE = "1024";
	}

	// npc_spawn
	// ==================================================================== Setup Spawn and Init
	void MummyBase_OnNpcSpawn(string npc = "")
	{
		SetModel("monsters/mummy.mdl");
		SetWidth(28);
		SetHeight(72);
		SetBlood("none");
		SetRace("undead");

		// These are here so they can be overriden by mummies that use random weapon types (warriors)
		MUMMY_MELEE_DMG_TYPE_FINAL = MUMMY_MELEE_DMG_TYPE;
		MUMMY_DMG_SLASH = DMG_SLASH;
		MUMMY_DMG_LONGSLASH = DMG_LONGSLASH;
		MUMMY_DMG_STAB = DMG_STAB;
		MUMMY_DMG_STEELPIPE = DMG_STEELPIPE;

		OnMummyImmunes();
		OnMummySpawn();

		MUMMY_NAME = FullNameOf(ENT_ME); // for resetting after playing dead
		MUMMY_LIVES = MUMMY_STARTING_LIVES;

		if (MUMMY_START_EAT)
			OnMummyForceEatMode("init");

		if (MUMMY_START_SQUAT)
			OnMummyForceSquatMode("init");

		if (AURA_TYPE == 1)
		{
			SetModelBody(3, 1);
			OnMummyAuraSound1();
			OnMummyRepulseAura();
			NPC_PROXACT_RANGE = "384";
		}

		if (AURA_TYPE == 2)
		{
			SetModelBody(3, 4);
			OnMummyAuraSound1();
			OnMummyIceAura();
			NPC_PROXACT_RANGE = "384";
		}

		if (AURA_TYPE == 3)
		{
			SetModelBody(3, 4);
			OnMummyAuraSound2();
			OnMummyNecroAura();
			NPC_PROXACT_RANGE = "384";
		}

		if (!NPC_PROX_ACTIVATE)
		{
			SetIdleAnim(ANIM_IDLE);
			SetMoveAnim(ANIM_WALK);
			SetHearingSensitivity(6);
			SetRoam(true);
		}

		if (MUMMY_IS_CLERIC)
			CallEventDelayed(1.0f, "mummy_cleric_cycle");

		if (Truthy(GetVar("MUMMY_THROWS_PIKE")))
			CallEventDelayed(1.0f, "mummy_pike_check");

		if (Truthy(GetVar("MUMMY_IS_NECRO")))
			CallEventDelayed(1.0f, "mummy_necro_summon");

		MUMMY_DEFAULT_ANIM_RUN = ANIM_RUN; // breathing switches runanim
		MUMMY_DEFAULT_ANIM_WALK = ANIM_WALK; // death switches walk anim
		MUMMY_DEFAULT_ANIM_IDLE = ANIM_IDLE; // death switches idle anim

		// set amount of health before it's possible to make the mummy flinch
		FLINCH_HEALTH = HealthOf(ENT_ME) * FLINCH_HEALTH_RATIO;

		if (ATTACK_TYPE == "unarmed")
		{
			ATTACK_RANGE = 80.0f;
			ATTACK_HITRANGE = 128.0f;
			ATTACK_MOVERANGE = 48.0f;
		}

		if (ATTACK_TYPE == "melee")
		{
			ATTACK_RANGE = 80.0f;
			ATTACK_HITRANGE = 128.0f;
			ATTACK_MOVERANGE = 48.0f;
		}

		if (ATTACK_TYPE == "long")
		{
			ATTACK_RANGE = ATTACK_RANGE_LONG;
			ATTACK_HITRANGE = ATTACK_HITRANGE_LONG;
		}
	}

	// game_dynamically_created
	void MummyBase_OnGameDynamicallyCreated(string creatorValue1 = "", string creatorValue2 = "", string damage = "", string skill = "", string extraValue5 = "", string extraValue6 = "", float alwaysPush = 0.0f, string duration = "", string extraValue9 = "")
	{
		// dev things, not setup for summon
		// mental note in case I forget again: game_dynamically_created comes AFTER game_spawn
		DebugPrint("game_dynamically_created " + creatorValue1 + " " + creatorValue2);

		if (creatorValue1 == "squat")
		{
			MUMMY_START_SQUAT = true;
			OnMummyForceSquatMode("init");
		}
		if (creatorValue1 == "eat")
		{
			MUMMY_START_EAT = true;
			OnMummyForceEatMode("init");
		}
	}

	// mummy_immunes
	void MummyBase_OnMummyImmunes()
	{
		SetDamageTaken("holy", 1.25f);
		SetDamageTaken("fire", 1.25f);
		SetDamageTaken("cold", 0.5f);
		SetDamageTaken("lightning", 0.5f);
		SetDamageTaken("poison", 0);

		SetDamageTaken("blunt", 1);
		SetDamageTaken("slash", 1.1f);
		SetDamageTaken("pierce", 0.5f);
	}

	// cycle_up
	void MummyBase_OnCycleUp(string reason = "")
	{
		if (MUMMY_CYCLES_STARTED)
			return;
		MUMMY_CYCLES_STARTED = true;
		if (MUMMY_BREATH_ATTACK && !Truthy(GetVar("MUMMY_DOUBLE_CYCLE")))
			CallEventDelayed(FREQ_MUMMY_BREATH_ATTACK, "mummy_breath_attack");
		if (MUMMY_BEAM_ATTACK && !Truthy(GetVar("MUMMY_DOUBLE_CYCLE")))
			CallEventDelayed(FREQ_MUMMY_BEAM_ATTACK, "mummy_beam_attack");
		if (Truthy(GetVar("MUMMY_DOUBLE_CYCLE")))
		{
			MUMMY_CUR_CYCLE_ATTACK = 0.0f;
			CallEventDelayed(1.0f, "mummy_double_cycle_event");
		}
	}

	// frame_slash
	// =========================================================================== Attack Damage
	// short unarmed overhead attack
	void MummyBase_OnFrameSlash()
	{
		PlaySound(0, 10, SOUND_ATTACK1);
		DebugPrint("frame_slash " + Text(MUMMY_DMG_SLASH));
		DoDamage(NPCATK_TARGET, ATTACK_HITRANGE_SHORT, MUMMY_DMG_SLASH, ATTACK_HITCHANCE, "slash");
	}

	// frame_slash1
	// short unarmed backhand attack
	void MummyBase_OnFrameSlash1()
	{
		PlaySound(0, 10, SOUND_ATTACK1);
		DebugPrint("frame_slash " + Text(MUMMY_DMG_SLASH));
		MUMMY_BACKHAND = true; // pushes away a bit
		DoDamage(NPCATK_TARGET, ATTACK_HITRANGE_SHORT, MUMMY_DMG_SLASH, ATTACK_HITCHANCE, "slash");
	}

	// frame_stab1
	// short unarmed double swipe
	void MummyBase_OnFrameStab1()
	{
		PlaySound(0, 10, SOUND_ATTACK1);
		DebugPrint("frame_slash " + Text(MUMMY_DMG_SLASH));
		DoDamage(NPCATK_TARGET, ATTACK_HITRANGE_SHORT, MUMMY_DMG_SLASH, ATTACK_HITCHANCE, "slash");
	}

	// frame_longslash
	// long unarmed "Dalsim" attack
	void MummyBase_OnFrameLongslash()
	{
		PlaySound(0, 10, SOUND_ATTACK2);
		DoDamage(NPCATK_TARGET, ATTACK_HITRANGE_LONG, MUMMY_DMG_LONGSLASH, ATTACK_HITCHANCE, "slash");
	}

	// frame_stab
	// pike attack
	void MummyBase_OnFrameStab()
	{
		bool exitSub = false;
		if (MUMMY_HEAL_FLAG)
		{
			// we're using this anim for other things, so abort the damage in certain circumstances, such as when used as heal spell
			MUMMY_HEAL_FLAG = false;
			exitSub = true;
		}
		if (exitSub)
			return;

		PlaySound(0, 10, SOUND_ATTACK2);
		DoDamage(NPCATK_TARGET, ATTACK_HITRANGE_LONG, MUMMY_DMG_STAB, ATTACK_HITCHANCE, "pierce");
	}

	// frame_steelpipe
	// short melee attack and toss pike anim
	void MummyBase_OnFrameSteelpipe()
	{
		DebugPrint("frame_steelpipe " + Text(MUMMY_TOSSING_PIKE));

		if (Truthy(GetVar("MUMMY_THROWS_PIKE")))
		{
			MUMMY_PUSH_ATTACK = true; // pike barers try to knock away nearby opponents
		}

		if (MUMMY_TOSSING_PIKE)
		{
			SetModelBody(2, 0); // hide pike
			MUMMY_PUSH_ATTACK = false;

			// <projectile scriptname> <"view"|(src_origin)> <target|(targ_origin)|none> <speed> <damage> <cof> <skill|none> //Converted to use new tossprojectile //greatguys1@FEB2022
			TossProjectile(GetVar("MUMMY_PROJ_NAME"), RelativePosition(Vector3(10, 64, 12)), NPCATK_TARGET, GetVar("MUMMY_PIKE_SPEED"), GetVar("DMG_PIKE"), 0, "none");
			PlaySound(0, 10, SOUND_PIKE_TOSS);
			MUMMY_TOSSING_PIKE = false;
		}
		else
		{
			PlaySound(0, 10, SOUND_ATTACK2);
			DoDamageEx(NPCATK_TARGET, ATTACK_HITRANGE_SHORT, MUMMY_DMG_STEELPIPE, ATTACK_HITCHANCE, ENT_ME, ENT_ME, "none", MUMMY_MELEE_DMG_TYPE_FINAL, "dmgevent:steelpipe");

			if (Float(GetVar("MUMMY_STUN_CHANCE")) > 0.0f)
				MUMMY_STUN_ATTACK = true;
		}
	}

	// frame_bite_start
	void MummyBase_OnFrameBiteStart()
	{
		PlaySound(0, 10, SOUND_BITE_START);
	}

	// frame_bite_dmg
	void MummyBase_OnFrameBiteDmg()
	{
		PlaySound(0, 10, SOUND_BITE_HIT);
		DoDamage(NPCATK_TARGET, ATTACK_HITRANGE_BITE, DMG_BITE, "100%", "magic");

		MUMMY_NEXT_BITE = GameTime() + FREQ_MUMMY_BITE;
	}

	// game_dodamage
	// PARAM1=hit:0|1 PARAM2=ent_hit PARAM3=(start) PARAM4=(end)
	string MummyBase_OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		float rndLf = 0.0f;
		string result = "";
		if (MUMMY_STUN_ATTACK)
		{
			MUMMY_STUN_ATTACK = false;
			if (hit && RandomInt(1, 100) < Float(GetVar("MUMMY_STUN_CHANCE")))
				ApplyEffect(target, "effects/debuff_stun", 7.0f, self);
		}

		if (MUMMY_BACKHAND)
		{
			MUMMY_BACKHAND = false;
			rndLf = Random(-50, 50);
			AddVelocity(target, RelativeVelocity(Vector3(rndLf, 300, 110)));
		}

		if (MUMMY_PUSH_ATTACK)
		{
			MUMMY_PUSH_ATTACK = false;
			if (hit)
			{
				rndLf = Random(-50, 50);
				AddVelocity(target, RelativeVelocity(Vector3(rndLf, 600, 110)));
			}
		}
		return result;
	}

	// npc_selectattack
	// =============================================================  Attack Animation Selection
	void MummyBase_OnNpcSelectattack()
	{
		if (ATTACK_TYPE != "unarmed")
			return;

		int rndAttack = RandomInt(1, 3);
		if (rndAttack == 1)
			ANIM_ATTACK = ANIM_UNARMED1;
		if (rndAttack == 2)
			ANIM_ATTACK = ANIM_UNARMED2;
		if (rndAttack == 3)
			ANIM_ATTACK = ANIM_UNARMED3;

		if (!MUMMY_MUNCHES)
			return;
		if (!(GameTime() > MUMMY_NEXT_BITE))
			return;
		if (!(RangeTo(NPCATK_TARGET) < ATTACK_RANGE_BITE))
			return;
		ANIM_ATTACK = ANIM_BITE;
	}

	// npcatk_hunt
	// has to be done in hunt instead of npc_selectattack, as changes range
	void MummyBase_OnNpcatkHunt()
	{
		if (ATTACK_TYPE == "long")
		{
			if (RangeTo(NPCATK_TARGET) <= ATTACK_RANGE_SHORT)
			{
				ANIM_ATTACK = ANIM_ATTACK_SHORT;
				ATTACK_RANGE = ATTACK_RANGE_SHORT;
				ATTACK_HITRANGE = ATTACK_HITRANGE_SHORT;
				if (MUMMY_MUNCHES && GameTime() > MUMMY_NEXT_BITE && RangeTo(NPCATK_TARGET) < ATTACK_RANGE_BITE)
				{
					ANIM_ATTACK = ANIM_BITE;
					ATTACK_RANGE = ATTACK_RANGE_BITE;
					ATTACK_HITRANGE = ATTACK_HITRANGE_BITE;
				}
			}
			else
			{
				ANIM_ATTACK = ANIM_ATTACK_LONG;
				ATTACK_RANGE = ATTACK_RANGE_LONG;
				ATTACK_HITRANGE = ATTACK_HITRANGE_LONG;
			}
		}

		if (AURA_TYPE == 2)
		{
			// ice mummies approach targets in their field to munch
			if (Truthy(ScriptVarOf(NPCATK_TARGET, "I_R_FROZEN")))
			{
				if (RangeTo(NPCATK_TARGET) <= AURA_RANGE)
				{
					ATTACK_MOVERANGE = 32.0f;
					ANIM_ATTACK = ANIM_BITE;
					ATTACK_RANGE = ATTACK_RANGE_BITE;
					ATTACK_HITRANGE = ATTACK_HITRANGE_BITE;
				}
				else
				{
					ATTACK_MOVERANGE = 128.0f;
					ANIM_ATTACK = ANIM_ATTACK_LONG;
					ATTACK_RANGE = ATTACK_RANGE_LONG;
					ATTACK_HITRANGE = ATTACK_HITRANGE_LONG;
				}
			}
		}
	}

	// mummy_repulse_aura
	// ===========================================================================  Repulse Aura
	void MummyBase_OnMummyRepulseAura()
	{
		if (!IsAlive(ENT_ME))
			return;
		CallEventDelayed(0.5f, "mummy_repulse_aura");

		REPULSE_TARGETS = FindInSphere("enemy", AURA_RANGE);

		DebugPrint("mummy_repulse_aura " + REPULSE_TARGETS);
		if (REPULSE_TARGETS == "none")
			return;
		int count = GetTokenCount(REPULSE_TARGETS);
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnMummyRepulseTargets();
		}
	}

	// mummy_repulse_targets
	void MummyBase_OnMummyRepulseTargets()
	{
		CBaseEntity@ curTarg = FindEntity(GetToken(REPULSE_TARGETS, loopIteration));
		Vector3 targOrg = OriginOf(curTarg);
		float targAng = AnglesTo(MyOrigin(), targOrg);
		SetVelocity(curTarg, RelativeVelocity(Vector3(0, targAng, 0), Vector3(10, 1000, 0)));
	}

	// mummy_aura_sound1
	void MummyBase_OnMummyAuraSound1()
	{
		if (!IsAlive(ENT_ME))
			return;
		ServerPlaySound(2, 0, SOUND_LOOP_AURA1);
		ServerPlaySound(2, 5, SOUND_LOOP_AURA1);
		CallEventDelayed(30.0f, "mummy_aura_sound1");
	}

	// mummy_aura_sound2
	void MummyBase_OnMummyAuraSound2()
	{
		if (!IsAlive(ENT_ME))
			return;
		ServerPlaySound(2, 0, SOUND_LOOP_AURA2);
		ServerPlaySound(2, 5, SOUND_LOOP_AURA2);
		CallEventDelayed(30.0f, "mummy_aura_sound2");
	}

	// mummy_ice_aura
	// ================================================================================ Ice Aura
	void MummyBase_OnMummyIceAura()
	{
		if (!IsAlive(ENT_ME))
			return;
		CallEventDelayed(1.0f, "mummy_ice_aura");

		MUMMY_ICE_TARGETS = FindInSphere("enemy", AURA_RANGE);
		if (MUMMY_ICE_TARGETS == "none")
			return;
		int count = GetTokenCount(MUMMY_ICE_TARGETS);
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnMummyIceTargets();
		}
	}

	// mummy_ice_targets
	void MummyBase_OnMummyIceTargets()
	{
		CBaseEntity@ curTarg = FindEntity(GetToken(MUMMY_ICE_TARGETS, loopIteration));
		ApplyEffect(curTarg, "effects/dot_cold_freeze", 5.0f, self, GetVar("AURA_DOT"));
	}

	// mummy_necro_aura
	// ============================================================================== Necro Aura
	void MummyBase_OnMummyNecroAura()
	{
		if (!IsAlive(ENT_ME))
			return;
		CallEventDelayed(0.5f, "mummy_necro_aura");

		DoDamage(Text(RelativePosition(Vector3(0, 0, 0))), AURA_RANGE, GetVar("DMG_AURA"), "100%", 0, "reflective", "dark");
	}

	// spawn_squatting
	// ========================================================================  Prox Activation
	// inteded as additional parameter - used to start mummy sitting
	void MummyBase_OnSpawnSquatting()
	{
		MUMMY_START_SQUAT = true;
		OnMummyForceSquatMode("init");
	}

	// spawn_eating
	// inteded as additional paramater - used to start mummy eating
	void MummyBase_OnSpawnEating()
	{
		MUMMY_START_EAT = true;
		OnMummyForceEatMode("init");
	}

	// mummy_getup_now
	void MummyBase_OnMummyGetupNow()
	{
		NPC_PROXACT_TRIPPED = true;
		if (MUMMY_START_SQUAT)
			OnMummySquatToStand();
		if (MUMMY_START_EAT)
			OnMummyEatToStand();
	}

	// mummy_force_eat_mode
	// can also be used to force mummy to resume eating after kill
	void MummyBase_OnMummyForceEatMode(string mode = "")
	{
		SetHearingSensitivity(0);
		SetRoam(false);
		NPC_PROXACT_TRIPPED = false;
		NPC_PROXACT_IFSEEN = false;
		NPC_PROX_ACTIVATE = true;
		NPC_PROXACT_RANGE = "64";
		NPC_PROXACT_EVENT = "mummy_eat_to_stand";
		NPC_PROXACT_FOV = true;
		NPC_PROXACT_CONE = 90;
		SetIdleAnim(ANIM_EAT);
		SetMoveAnim(ANIM_EAT);
		PlayAnim("critical", ANIM_EAT);
		OnNpcatkSuspendAi();
		if (mode != "init")
			OnNpcatkProxactScan();
		MUMMY_RESUME_MODE = "eat";
	}

	// mummy_force_squat_mode
	// can also be used to force mummy to resume squatting after kill
	void MummyBase_OnMummyForceSquatMode(string mode = "")
	{
		SetHearingSensitivity(0);
		SetRoam(false);
		NPC_PROXACT_TRIPPED = false;
		NPC_PROXACT_IFSEEN = false;
		NPC_PROX_ACTIVATE = true;
		NPC_PROXACT_RANGE = "96";
		NPC_PROXACT_EVENT = "mummy_squat_to_stand";
		NPC_PROXACT_FOV = true;
		NPC_PROXACT_CONE = 90;
		SetIdleAnim(ANIM_SQUAT);
		SetMoveAnim(ANIM_SQUAT);
		PlayAnim("critical", ANIM_SQUAT);
		OnNpcatkSuspendAi();
		if (mode != "init")
			OnNpcatkProxactScan();
		MUMMY_RESUME_MODE = "squat";
	}

	// mummy_eat_to_stand
	void MummyBase_OnMummyEatToStand()
	{
		// setvard NPC_PROXACT_TRIPPED 1 //still seem to have one bug left with proxact - this var isn't getting set, yet it shouldn't be able to reach here if it hasn't been
		SetHearingSensitivity(6);
		SetIdleAnim(ANIM_IDLE);
		SetMoveAnim(ANIM_WALK);
		CallEventDelayed(1.0f, "npcatk_resume_ai");
		SetRoam(true);
		AS_ATTACKING = GameTime();
		PlayAnim("critical", ANIM_EAT_TO_STAND);

		if (!IsAlive(NPC_PROXACT_PLAYERID))
			return;
		CallEventDelayed(1.1f, "mummy_target_disturber");
	}

	// mummy_squat_to_stand
	void MummyBase_OnMummySquatToStand()
	{
		// setvard NPC_PROXACT_TRIPPED 1 //still seem to have one bug left with proxact - this var isn't getting set, yet it shouldn't be able to reach here if it hasn't been
		SetHearingSensitivity(6);
		SetIdleAnim(ANIM_IDLE);
		SetMoveAnim(ANIM_WALK);
		CallEventDelayed(1.0f, "npcatk_resume_ai");
		SetRoam(true);
		AS_ATTACKING = GameTime();
		PlayAnim("critical", ANIM_SQUAT_TO_STAND);

		if (!IsAlive(NPC_PROXACT_PLAYERID))
			return;
		CallEventDelayed(1.1f, "mummy_target_disturber");
	}

	// mummy_target_disturber
	void MummyBase_OnMummyTargetDisturber()
	{
		// setvard NPC_PROXACT_TRIPPED 1 //still seem to have one bug left with proxact - this var isn't getting set, yet it shouldn't be able to reach here if it hasn't been
		if (!IsAlive(NPC_PROXACT_PLAYERID))
			return;
		SetIdleAnim(ANIM_IDLE);
		SetMoveAnim(ANIM_RUN);
		OnNpcatkSettarget(EntityId(NPC_PROXACT_PLAYERID));
	}

	// my_target_died
	void MummyBase_OnMyTargetDied(string offender = "")
	{
		CallEventDelayed(1.0f, "mummy_return_to_proxscan");
	}

	// mummy_return_to_proxscan
	void MummyBase_OnMummyReturnToProxscan()
	{
		if (FindInSphere("enemy", 256) != "none")
			return;
		if (CanSee("enemy"))
			return;

		if (MUMMY_RESUME_MODE == "squat")
			OnMummyForceSquatMode();
		if (MUMMY_RESUME_MODE == "eat")
			OnMummyForceEatMode();
	}

	// game_death
	// ========================================================================= Death & Rebirth
	void MummyBase_OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		// turn off any auras
		OnMummyAurasOff();
		if (MUMMY_BREATH_ATTACK_TYPE == "lightning")
			ServerPlaySound(2, 0, SOUND_BREATH_LOOP);
		if (MUMMY_BREATH_ATTACK_TYPE == "ice")
			ServerPlaySound(3, 0, SOUND_BREATH_LOOP);

		int rndDeath = RandomInt(1, 2);
		if (rndDeath == 1)
			ANIM_DEATH = ANIM_DEATH1;
		if (rndDeath == 2)
			ANIM_DEATH = ANIM_DEATH1;
	}

	// npc_death
	void MummyBase_OnNpcDeath()
	{
		if (MUMMY_HIT_BY_HOLY)
			return;
		if (!(MUMMY_LIVES > 1.0f))
			return;
		MUMMY_LIVES -= 1.0f;
		PLAYING_DEAD = "1";
		if (ANIM_DEATH == ANIM_DEATH1)
			ANIM_DEATH_IDLE = ANIM_DEATH_IDLE1;
		if (ANIM_DEATH == ANIM_DEATH2)
			ANIM_DEATH_IDLE = ANIM_DEATH_IDLE2;
		OnNpcatkSuspendAi();
		NPC_NO_ATTACK = true;
		NO_STUCK_CHECKS = "1";
		CAN_HEAR = "0";
		SetSolid("none");
		SetBoundingBox(Vector3(0, 0, 0), Vector3(0, 0, 0));
		SetInvincible(true);
		SetMoveDest("none");
		ANIM_RUN = ANIM_DEATH_IDLE;
		ANIM_WALK = ANIM_DEATH_IDLE;
		ANIM_IDLE = ANIM_DEATH_IDLE;
		SetIdleAnim(ANIM_DEATH_IDLE);
		SetMoveAnim(ANIM_DEATH_IDLE);
		SetAlive(true);
		SetRoam(false);
		CallEventDelayed(RandomInt(5, 15), "mummy_rebirth_check");
	}

	// mummy_rebirth_check
	void MummyBase_OnMummyRebirthCheck()
	{
		int count;
		OnNpcatkSuspendAi(); // make sure AI stays off
		NPC_NO_ATTACK = true;
		MUMMY_REBIRTH_SCAN = FindInSphere("any", 96);
		if (ANIM_DEATH == ANIM_DEATH1)
			PlayAnim("critical", ANIM_PRE_REBIRTH1);
		if (ANIM_DEATH == ANIM_DEATH2)
			PlayAnim("critical", ANIM_PRE_REBIRTH2);

		if (MUMMY_REBIRTH_SCAN != "none")
		{
			MUMMY_CANT_GET_UP = true;
			MUMMY_REALLY_CANT_GET_UP = false;
			count = GetTokenCount(MUMMY_REBIRTH_SCAN);
			for (int i = 0; i < count; i++)
			{
				loopIteration = i;
				OnMummyRebirthScanLoop();
			}
			if (MUMMY_REALLY_CANT_GET_UP)
				MUMMY_CANT_GET_UP = true;
		}

		if (MUMMY_REBIRTH_SCAN == "none")
			MUMMY_CANT_GET_UP = false;

		if (MUMMY_CANT_GET_UP)
			CallEventDelayed(1.0f, "mummy_rebirth_check");
		else
			OnMummyRebirth();
	}

	// mummy_rebirth_scan_loop
	void MummyBase_OnMummyRebirthScanLoop()
	{
		CBaseEntity@ curTarg = FindEntity(GetToken(MUMMY_REBIRTH_SCAN, loopIteration));
		if (Contains(ItemNameOf(curTarg), "mummy"))
		{
			// this maybe a mummy trying to get up too
			if (Truthy(ScriptVarOf(curTarg, "PLAYING_DEAD")))
			{
				// it is, get up, but hold all other dead zombies down a bit
				if (GameTime() > Float(GetVar("G_MUMMY_NEXT_REBIRTH")))
				{
					SetGlobal("G_MUMMY_NEXT_REBIRTH", GameTime());
					LegacyCommand("add", "G_MUMMY_NEXT_REBIRTH", 5.0f);
					MUMMY_CANT_GET_UP = false;
					DebugPrint("can get up " + Text(GameTime()) + " vs. " + GetVar("G_MUMMY_NEXT_REBIRTH"));
				}
			}
			else
			{
				MUMMY_CANT_GET_UP = true;
				MUMMY_REALLY_CANT_GET_UP = true;
			}
		}
		else
		{
			MUMMY_CANT_GET_UP = true;
			MUMMY_REALLY_CANT_GET_UP = true; // this is in case I see a player earlier in the scan, but a dead friend later, and think I can get up
		}
	}

	// mummy_rebirth
	void MummyBase_OnMummyRebirth()
	{
		SetSolid("box");
		SetBoundingBox("npcsize");
		SetRace("undead");
		SetHealth(MaxHealthOf(ENT_ME));
		NPC_GIVE_EXP = Divide(NPC_GIVE_EXP, 2.0f);
		SetSkillLevel(NPC_GIVE_EXP);
		PLAYING_DEAD = "0";
		CallEventDelayed(1.0f, "mummy_rebirth2");
	}

	// mummy_rebirth2
	void MummyBase_OnMummyRebirth2()
	{
		SetInvincible(false);
		ANIM_RUN = MUMMY_DEFAULT_ANIM_RUN;
		ANIM_WALK = MUMMY_DEFAULT_ANIM_WALK;
		ANIM_IDLE = MUMMY_DEFAULT_ANIM_IDLE;
		NO_STUCK_CHECKS = "0";
		CAN_HEAR = "1";
		SetMoveAnim(ANIM_WALK);
		SetIdleAnim(ANIM_IDLE);
		if (ANIM_DEATH == ANIM_DEATH1)
			PlayAnim("critical", ANIM_REBIRTH1);
		if (ANIM_DEATH == ANIM_DEATH2)
			PlayAnim("critical", ANIM_REBIRTH2);
		NPC_PREV_TARGET = "unset"; // so we re-apply musak
		CallEventDelayed(1.0f, "npcatk_resume_ai");
		NPC_NO_ATTACK = false;
		CallEventDelayed(1.1f, "mummy_rebirth3");
	}

	// mummy_rebirth3
	void MummyBase_OnMummyRebirth3()
	{
		SetRoam(true);
	}

	// game_damaged
	string MummyBase_OnGameDamaged(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float accuracyRoll = 0.0f, CBaseEntity@ inflictor = null, string skill = "")
	{
		string result = "";
		// mummies struck by holy will not rise again
		if (damageType != "holy")
			return result;
		MUMMY_HIT_BY_HOLY = true;
		MUMMY_LIVES = 1.0f;
		return result;
	}

	// mummy_auras_off
	void MummyBase_OnMummyAurasOff()
	{
		SetModelBody(3, 0);
		if (AURA_TYPE == 1)
			ServerPlaySound(2, 0, SOUND_LOOP_AURA1);
		if (AURA_TYPE == 2)
			ServerPlaySound(2, 0, SOUND_LOOP_AURA2);
	}

	// set_no_fake_death
	// additional parameter
	void MummyBase_OnSetNoFakeDeath()
	{
		MUMMY_LIVES = 1.0f;
	}

	// mummy_cleric_cycle
	// ============================================================================ Cleric Cycle
	void MummyBase_OnMummyClericCycle()
	{
		if (!IsAlive(ENT_ME))
			return;

		CallEventDelayed(3.0f, "mummy_cleric_cycle");

		if (MUMMY_NO_HEALS > GameTime())
		{
			// I've not found anyone to heal for at least 10 seconds
			// Start moving closer to players, as it maybe there are no other mummies left
			ATTACK_MOVERANGE = 48.0f;
		}

		MUMMY_HEAL_LIST = FindInSphere("ally", Float(MUMMY_CLERIC_RANGE));

		if (MUMMY_HEAL_LIST == "none")
			MUMMY_NO_HEALS = GameTime() + 10.0f;

		if (MUMMY_HEAL_LIST == "none")
			return;
		ATTACK_MOVERANGE = 1024.0f; // dont approach targets - let the guys I heal take the front line

		MUMMY_HEAL_LIST = TokenShuffle(MUMMY_HEAL_LIST); // heal randomly
		MUMMY_HEAL_TARGET = "none";
		OnMummyFindHealTarget();

		if (MUMMY_HEAL_TARGET == "none")
			return;

		CallExternal(MUMMY_HEAL_TARGET, "mummy_healed");

		PlaySound(0, 10, SOUND_HEAL_OTHER);
		Effect("glow", ENT_ME, Vector3(0, 255, 0), 64, 1, 1);

		OnNpcatkSuspendAi("1.0");
		NPC_FORCED_MOVEDEST = true;
		SetMoveDest(MUMMY_HEAL_TARGET, 9999);
		CallEventDelayed(0.1f, "mummy_cleric_heal_anim");
	}

	// mummy_cleric_heal_anim
	void MummyBase_OnMummyClericHealAnim()
	{
		AS_ATTACKING = GameTime();
		PlayAnim("critical", ANIM_HEAL);
		MUMMY_HEAL_FLAG = true; // abort damage on this attack anim
	}

	// mummy_find_heal_target
	void MummyBase_OnMummyFindHealTarget()
	{
		CBaseEntity@ curTarg = FindEntity(GetToken(MUMMY_HEAL_LIST, loopIteration));
		if (!IsAlive(curTarg))
			return;
		if (!(HealthOf(curTarg) < MaxHealthOf(curTarg)))
			return;
		if (!Contains(ItemNameOf(curTarg), "mummy")) // heal mummies only, not pets
			return;
		MUMMY_HEAL_TARGET = EntityId(curTarg);
	}

	// mummy_healed
	void MummyBase_OnMummyHealed()
	{
		Effect("glow", ENT_ME, Vector3(0, 255, 0), 256, 1, 1);
		PlaySound(0, 10, SOUND_HEALED);
		SetHealth(MyMaxHealth());
	}

	// game_struck
	void MummyBase_OnGameStruck(float damage = 0.0f, string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		if (MUMMY_BEAMING)
		{
			// if I'm beaming, redirect beam to new attacker, if I can see him
			OnMummyBeamNewTarget(EntityId(EntityOf(ENT_LASTSTRUCK)));
		}

		if (!MUMMY_IS_CLERIC)
			return;
		// (never true here, the rest is skipped) if ATTACK_MOVE_RANGE == 1024
	}

	// ext_setbody
	// =============================================================================== Debuggary
	// debuggary
	void MummyBase_OnExtSetbody(int bodyGroup = 0, int submodel = 0)
	{
		SetModelBody(bodyGroup, submodel);
	}

	// npc_flinch
	// ================================================================================== Flinch
	void MummyBase_OnNpcFlinch(float damage = 0.0f)
	{
		int rndFlinch = RandomInt(1, 2);
		if (rndFlinch == 1)
			FLINCH_ANIM = ANIM_FLINCH1;
		if (rndFlinch == 1)
			FLINCH_ANIM = ANIM_FLINCH2;
	}

	// mummy_pike_check
	// =============================================================================== Pike Toss
	void MummyBase_OnMummyPikeCheck()
	{
		CallEventDelayed(1.0f, "mummy_pike_check");
		if (!CanSee(NPCATK_TARGET))
			return;
		if (!(RangeTo(NPCATK_TARGET) > ATTACK_RANGE_LONG))
			return;
		if (!(GameTime() > MUMMY_NEXT_PIKE_TOSS))
			return;
		MUMMY_NEXT_PIKE_TOSS = GameTime();
		MUMMY_NEXT_PIKE_TOSS += Float(GetVar("FREQ_MUMMY_PIKE_TOSS"));
		MUMMY_TOSSING_PIKE = true;
		if (!Truthy(GetVar("MUMMY_PIKE_NOGLOW"))) // make pike glow
			SetModelBody(2, 7);
		OnNpcatkSuspendAi();
		SetMoveDest(NPCATK_TARGET, 9999);
		ANIM_RUN = ANIM_PIKE_HOLD;
		ANIM_IDLE = ANIM_PIKE_HOLD;
		SetMoveAnim(ANIM_PIKE_HOLD);
		SetIdleAnim(ANIM_PIKE_HOLD);
		NPC_FORCED_MOVEDEST = true;
		SetRoam(false);
		AS_ATTACKING = GameTime() + 2.0f;
		PlayAnim("critical", ANIM_STEELPIPE);
		CallEventDelayed(1.5f, "mummy_pike_reload");
	}

	// mummy_pike_reload
	void MummyBase_OnMummyPikeReload()
	{
		SetModelBody(2, 7);
		SetRoam(true);
		OnNpcatkResumeAi();
		ANIM_RUN = MUMMY_DEFAULT_ANIM_RUN;
		ANIM_IDLE = MUMMY_DEFAULT_ANIM_IDLE;
		SetMoveAnim(ANIM_RUN);
		SetIdleAnim(ANIM_IDLE);
		MUMMY_TOSSING_PIKE = false;
		CallEventDelayed(0.5f, "mummy_pike_reload2");
	}

	// mummy_pike_reload2
	void MummyBase_OnMummyPikeReload2()
	{
		SetModelBody(2, 6); // stop pike glowing
	}

	// ext_projectile_hit
	// called from items/proj_mummy_pike
	void MummyBase_OnExtProjectileHit()
	{
		MUMMY_NEXT_PIKE_TOSS += 10.0f; // delay so we don't repeatedly freeze the same poor bastard
	}

	// mummy_necro_summon
	// =========================================================================== Summon Wraith
	void MummyBase_OnMummyNecroSummon()
	{
		if (!IsAlive(ENT_ME))
			return;
		CallEventDelayed(1.0f, "mummy_necro_summon");
		if (NPCATK_TARGET == "unset")
			return;
		int maxSummons = 2;
		if (maxSummons < PlayerCount())
			maxSummons = PlayerCount();
		if (!(MUMMY_NSUMMONS < maxSummons))
			return;
		if (!(GameTime() > MUMMY_NEXT_SUMMON))
			return;
		MUMMY_NEXT_SUMMON = GameTime();
		MUMMY_NEXT_SUMMON += Float(GetVar("FREQ_MUMMY_SUMMON"));
		OnNpcatkSuspendAi();
		ANIM_RUN = ANIM_SUMMON;
		ANIM_IDLE = ANIM_SUMMON;
		SetRoam(false);
		SetMoveAnim(ANIM_SUMMON);
		SetIdleAnim(ANIM_SUMMON);
		CallEventDelayed(1.0f, "mummy_necro_summon2");
	}

	// mummy_necro_summon2
	void MummyBase_OnMummyNecroSummon2()
	{
		Effect("glow", ENT_ME, Vector3(255, 255, 255), 128, 1, 1);
		PlaySound(0, 10, SOUND_SUMMON);
		MUMMY_NSUMMONS += 1.0f;
		Vector3 summonPoint = RelativePosition(Vector3(0, 64, 0));
		CreateNpc(GetVar("MUMMY_SUMMON_SCRIPT"), summonPoint, self, NPCATK_TARGET, summonPoint);
		CallEventDelayed(2.0f, "mummy_necro_summon3");
	}

	// mummy_necro_summon3
	void MummyBase_OnMummyNecroSummon3()
	{
		OnNpcatkResumeAi();
		ANIM_RUN = MUMMY_DEFAULT_ANIM_RUN;
		ANIM_IDLE = MUMMY_DEFAULT_ANIM_IDLE;
		SetMoveAnim(ANIM_RUN);
		SetIdleAnim(ANIM_IDLE);
		SetRoam(true);
	}

	// ext_wraith_died
	// called by wraith
	void MummyBase_OnExtWraithDied()
	{
		MUMMY_NSUMMONS -= 1.0f;
		// dont constantly refresh summons
		MUMMY_NEXT_SUMMON = GameTime();
		MUMMY_NEXT_SUMMON += Float(GetVar("FREQ_MUMMY_SUMMON"));
	}

	// mummy_beam_attack
	// ============================================================================= Beam Attack
	void MummyBase_OnMummyBeamAttack()
	{
		// lightning beam plows enemies into walls
		if (!IsAlive(ENT_ME))
			return;
		if (!Truthy(GetVar("MUMMY_DOUBLE_CYCLE")))
			CallEventDelayed(FREQ_MUMMY_BEAM_ATTACK, "mummy_beam_attack");

		if (Truthy(PLAYING_DEAD))
			return;
		if (MUMMY_BREATHING)
			return;
		if (MUMMY_BEAMING)
			return;
		// if !SUSPEND_AI
		if (!IsAlive(NPCATK_TARGET))
			return;

		if (!CanSee(NPCATK_TARGET))
			return;

		MUMMY_BEAMING = true;

		MUMMY_BEAM_TARGET = NPCATK_TARGET;

		OnNpcatkSuspendAi();
		ANIM_RUN = ANIM_PIKE_HOLD;
		ANIM_IDLE = ANIM_PIKE_HOLD;
		SetRoam(false);
		SetMoveAnim(ANIM_PIKE_HOLD);
		SetIdleAnim(ANIM_PIKE_HOLD);

		Effect("beam", "ents", "lgtning.spr", 200, ENT_ME, 2, MUMMY_BEAM_TARGET, 0, Vector3(255, 255, 0), 255, 20, MUMMY_BEAM_DUR);
		MUMMY_BEAM_ID = ENT_LASTCREATED;

		PlaySound(0, 10, SOUND_BEAM_START);
		ServerPlaySound(2, 10, SOUND_BEAM_LOOP);

		ClientEvent("new", "all", "effects/sfx_attach_sprite", "0;1.0;255;add;(255,255,0);30;1", IndexOf(ENT_ME), 1, MUMMY_BEAM_DUR, "3dmflaora.spr"); // should be attach #1 - but isn't working

		// weird shit going on here where beam get stuck occasionally
		MUMMY_BEAM_ABORT_TIME = GameTime() + MUMMY_BEAM_DUR + 1.0f;

		OnMummyBeamAttackLoop();
		CallEventDelayed(MUMMY_BEAM_DUR, "mummy_beam_attack_end");
	}

	// mummy_beam_attack_end
	void MummyBase_OnMummyBeamAttackEnd()
	{
		Effect("beam", "update", MUMMY_BEAM_ID, "remove", 0.1f);
		ServerPlaySound(2, 0, SOUND_BEAM_LOOP);
		MUMMY_BEAMING = false;
		OnNpcatkResumeAi();
		ANIM_RUN = MUMMY_DEFAULT_ANIM_RUN;
		ANIM_IDLE = MUMMY_DEFAULT_ANIM_IDLE;
		SetMoveAnim(ANIM_RUN);
		SetIdleAnim(ANIM_IDLE);
		SetRoam(true);
	}

	// mummy_beam_new_target
	void MummyBase_OnMummyBeamNewTarget(string target = "")
	{
		if (!Exists(target))
			return;
		if (!IsAlive(target))
			return;

		Vector3 myStaffOrg = AttachmentPositionOf(ENT_ME, 1);
		Vector3 attackerOrg = OriginOf(target);
		string traceLine = LegacyFunction("get_traceline", myStaffOrg, attackerOrg, "worldonly");

		if (traceLine != Text(attackerOrg))
			return;

		MUMMY_BEAM_TARGET = target;
		Effect("beam", "update", MUMMY_BEAM_ID, "end_target", MUMMY_BEAM_TARGET, 0);
	}

	// mummy_beam_attack_loop
	void MummyBase_OnMummyBeamAttackLoop()
	{
		// weird shit going on here where beam get stuck occasionally
		if (GameTime() > MUMMY_BEAM_ABORT_TIME)
			OnMummyBeamAttackEnd();

		if (!MUMMY_BEAMING)
			return;
		CallEventDelayed(0.1f, "mummy_beam_attack_loop");

		if (!IsAlive(MUMMY_BEAM_TARGET))
		{
			// dbg error_check 1
			Effect("beam", "update", MUMMY_BEAM_ID, "brightness", 0);
			string newTarget = TokenShuffle(FindInSphere("enemy", 1024));
			OnMummyBeamNewTarget(newTarget);
		}
		else
		{
			// dbg error_check 2
			SetMoveDest(MUMMY_BEAM_TARGET, 9999);

			Vector3 beamStart = AttachmentPositionOf(ENT_ME, 1);
			Vector3 beamEnd = OriginOf(MUMMY_BEAM_TARGET);

			string beamTrace = LegacyFunction("get_traceline", beamStart, beamEnd, "worldonly");

			if (beamTrace != Text(beamEnd))
			{
				Effect("beam", "update", MUMMY_BEAM_ID, "brightness", 0);
			}
			else
			{
				Effect("beam", "update", MUMMY_BEAM_ID, "brightness", 255);
				Vector3 velSet = RelativePosition(Vector3(0, Float(Eval("game.monster.angles.yaw")), 0), Vector3(-500, 1000, 30));
				SetVelocity(MUMMY_BEAM_TARGET, velSet);
				DoDamage(MUMMY_BEAM_TARGET, "direct", DMG_PUSH_BEAM, "100%", ENT_ME, "lightning_effect");
			}
		}
	}

	// mummy_breath_attack
	// =========================================================================== Breath Attack
	void MummyBase_OnMummyBreathAttack()
	{
		bool doBreathAttack = false;

		if (IsAlive(ENT_ME) && !Truthy(PLAYING_DEAD) && !MUMMY_BREATHING && !MUMMY_BEAMING)
		{
			// if !SUSPEND_AI
			if (IsAlive(NPCATK_TARGET) && Truthy(LegacyFunction("cansee", NPCATK_TARGET, 512)))
				doBreathAttack = true;
		}

		if (doBreathAttack)
		{
			if (!Truthy(GetVar("MUMMY_DOUBLE_CYCLE")))
				CallEventDelayed(FREQ_MUMMY_BREATH_ATTACK, "mummy_breath_attack");
		}
		else if (!Truthy(GetVar("MUMMY_DOUBLE_CYCLE")))
			CallEventDelayed(2.0f, "mummy_breath_attack");
		if (!doBreathAttack)
			return;

		MUMMY_BREATHING = true;
		MUMMY_DEFAULT_ANIM_RUN = ANIM_RUN;
		ANIM_RUN = ANIM_BREATH_WALK;
		SetMoveAnim(ANIM_RUN);
		SetIdleAnim(ANIM_BREATH_WALK);
		AS_ATTACKING = GameTime() + 5.0f;
		PlayAnim("critical", ANIM_BREATH_PREP);
		PlaySound(0, 10, SOUND_BREATH_PREP);
		CallEventDelayed(1.5f, "mummy_breath_start");
		CallEventDelayed(MUMMY_BREATH_DURATION, "mummy_breath_stop");
		MUMMY_BREATH_TARGET = NPCATK_TARGET;
		OnNpcatkSuspendAi();
		NPC_FORCED_MOVEDEST = true;
		SetMoveDest(NPCATK_TARGET, ATTACK_MOVERANGE);
	}

	// mummy_breath_start
	void MummyBase_OnMummyBreathStart()
	{
		if (MUMMY_BREATH_ATTACK_TYPE == "lightning")
			ServerPlaySound(2, 10, SOUND_BREATH_LOOP);
		if (MUMMY_BREATH_ATTACK_TYPE == "ice")
			ServerPlaySound(3, 10, SOUND_BREATH_LOOP);
		PlaySound(0, 10, SOUND_MUMMY_BREATH);
		ClientEvent("new", "all", MUMMY_BREATH_ATTACK_CLSCRIPT, IndexOf(ENT_ME), MUMMY_BREATH_DURATION);
		OnMummyBreathLoop();
	}

	// mummy_breath_loop
	void MummyBase_OnMummyBreathLoop()
	{
		if (!MUMMY_BREATHING)
			return;
		CallEventDelayed(0.5f, "mummy_breath_loop");
		NPC_FORCED_MOVEDEST = true;
		SetMoveDest(NPCATK_TARGET, ATTACK_MOVERANGE);

		Vector3 breathCenter = OriginOf(ENT_ME);
		breathCenter += RelativePosition(Vector3(0, Float(Eval("game.monster.angles.yaw")), 0), Vector3(0, MUMMY_BREATH_ATTACK_OFS, 0));
		MUMMY_BREATH_TARGETS = LegacyFunction("get_tsphere", "enemy", MUMMY_BREATH_ATTACK_RANGE, breathCenter);
		if (MUMMY_BREATH_TARGETS == "none")
			return;
		int count = GetTokenCount(MUMMY_BREATH_TARGETS);
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnMummyBreathAffectTargets();
		}
	}

	// mummy_breath_stop
	void MummyBase_OnMummyBreathStop()
	{
		OnNpcatkResumeAi();
		MUMMY_BREATHING = false;
		ANIM_RUN = MUMMY_DEFAULT_ANIM_RUN;
		SetMoveAnim(ANIM_RUN);
		SetIdleAnim(ANIM_IDLE);
		PlayAnim("critical", ANIM_BREATH_WALK);
		if (MUMMY_BREATH_ATTACK_TYPE == "lightning")
			CallEventDelayed(1.0f, "mummy_breath_stop_sound");
		if (MUMMY_BREATH_ATTACK_TYPE == "ice")
			ServerPlaySound(3, 0, SOUND_BREATH_LOOP);
	}

	// mummy_breath_stop_sound
	void MummyBase_OnMummyBreathStopSound()
	{
		PlaySound(0, 10, SOUND_BREATH_END);
		ServerPlaySound(2, 0, SOUND_BREATH_LOOP);
	}

	// mummy_breath_affect_targets
	void MummyBase_OnMummyBreathAffectTargets()
	{
		CBaseEntity@ curTarg = FindEntity(GetToken(MUMMY_BREATH_TARGETS, loopIteration));
		if (!(RangeTo(curTarg) < MUMMY_BREATH_ATTACK_RANGE))
			return;
		Vector3 targOrg = OriginOf(curTarg);
		if (!WithinCone2D(targOrg, MyOrigin(), MyAngles(), MUMMY_BREATH_CONE))
			return;

		Vector3 myMouthOrg = AttachmentPositionOf(ENT_ME, 0);
		string traceLine = LegacyFunction("get_traceline", myMouthOrg, targOrg, "worldonly");

		if (traceLine != Text(targOrg))
			return;

		if (MUMMY_BREATH_ATTACK_TYPE == "bile")
			ApplyEffect(curTarg, "effects/dot_poison_blind", MUMMY_BREATH_DOT_DURATION, self, MUMMY_BREATH_DOT);
		if (MUMMY_BREATH_ATTACK_TYPE == "lightning")
		{
			DoDamage(curTarg, "direct", MUMMY_BREATH_DOT, "100%", ENT_ME, "lightning");
			ApplyEffect(curTarg, "effects/dot_lightning", MUMMY_BREATH_DOT_DURATION, self, MUMMY_BREATH_DOT);
			float zapTargResist = DamageTakenOf(curTarg, "lightning");
			float zapRoll = Random(0, 2);
			if (zapRoll < zapTargResist)
			{
				targOrg = OriginOf(curTarg);
				float targAng = AnglesTo(MyOrigin(), targOrg);
				SetVelocity(curTarg, RelativeVelocity(Vector3(0, targAng, 0), Vector3(10, 1000, 10)));
			}
		}
		if (MUMMY_BREATH_ATTACK_TYPE == "ice")
			ApplyEffect(curTarg, "effects/dot_cold", MUMMY_BREATH_DOT_DURATION, self, MUMMY_BREATH_DOT);
	}

	// mummy_double_cycle_event
	// ========================================================= Alternating Beam/Breath Attacks
	void MummyBase_OnMummyDoubleCycleEvent()
	{
		// alternate between beam and breath weapons
		if (!IsAlive(ENT_ME))
			return;
		CallEventOrDelay(GetVar("MUMMY_FREQ_DOUBLE_CYCLE"), "mummy_double_cycle_event");
		if (Truthy(PLAYING_DEAD))
			return;
		if (MUMMY_BREATHING)
			return;
		if (MUMMY_BEAMING)
			return;
		// if !SUSPEND_AI
		if (!IsAlive(NPCATK_TARGET))
			return;

		MUMMY_CUR_CYCLE_ATTACK += 1.0f;
		if (MUMMY_CUR_CYCLE_ATTACK == 1.0f)
			OnMummyBeamAttack();
		if (MUMMY_CUR_CYCLE_ATTACK == 2.0f)
		{
			OnMummyBreathAttack();
			MUMMY_CUR_CYCLE_ATTACK = 0.0f;
		}
	}

	// set_cleric_range
	// ========================================================= Additional Paramater
	// let mapper set max heal range
	void MummyBase_OnSetClericRange(string value = "", string healRange = "")
	{
		MUMMY_CLERIC_RANGE = healRange;
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)

	// game_death
	void OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		DqMonsterExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // dq/externals/dq_monster_externals
		MonstersExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/externals
		BaseSelfAdjust_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_self_adjust
		BaseNpc_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseMonsterShared_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared
		MummyBase_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4);
	}

	// game_dynamically_created
	void OnGameDynamicallyCreated(string creatorValue1 = "", string creatorValue2 = "", string damage = "", string skill = "", string extraValue5 = "", string extraValue6 = "", float alwaysPush = 0.0f, string duration = "", string extraValue9 = "")
	{
		BaseSelfAdjust_OnGameDynamicallyCreated(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/base_self_adjust
		BaseSelfAdjust_OnGameDynamicallyCreated_2(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/base_self_adjust
		BaseAntiStuck_OnGameDynamicallyCreated(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/base_anti_stuck
		BaseAntiStuck_OnGameDynamicallyCreated_2(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/base_anti_stuck
		MummyBase_OnGameDynamicallyCreated(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9);
	}

	// game_struck
	void OnGameStruck(float damage = 0.0f, string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		BaseNpc_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseNpcAttackNew_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc_attack_new
		BaseMonsterShared_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared
		MummyBase_OnGameStruck(damage, extraValue2, extraValue3, extraValue4);
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseNpcAttackNew_OnNpcSpawn(npc); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck
		MummyBase_OnNpcSpawn(npc);
	}

	// npcatk_hunt
	void OnNpcatkHunt()
	{
		BaseNpcAttackNew_OnNpcatkHunt(); // monsters/base_npc_attack_new
		BaseAntiStuck_OnNpcatkHunt(); // monsters/base_anti_stuck
		MummyBase_OnNpcatkHunt();
	}

	// my_target_died
	void OnMyTargetDied(string offender = "")
	{
		BaseNpcAttackNew_OnMyTargetDied(offender); // monsters/base_npc_attack_new
		MummyBase_OnMyTargetDied(offender);
	}

	// game_dodamage
	string OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";
		result = AppendResult(result, BaseNpcAttackNew_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BaseAntiStuck_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BaseMonsterShared_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, MummyBase_OnGameDodamage(hit, target, start, end, damageType, damageText));
		return result;
	}

	// cycle_up
	void OnCycleUp(string reason = "")
	{
		BaseNpcAttackNew_OnCycleUp(reason); // monsters/base_npc_attack_new
		MummyBase_OnCycleUp(reason);
	}

	// npc_selectattack
	void OnNpcSelectattack()
	{
		BaseAntiStuck_OnNpcSelectattack(); // monsters/base_anti_stuck
		BaseMonsterShared_OnNpcSelectattack(); // monsters/base_monster_shared
		MummyBase_OnNpcSelectattack();
	}

	// game_damaged - Return a damage multiplier to scale the damage
	string OnGameDamaged(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float accuracyRoll = 0.0f, CBaseEntity@ inflictor = null, string skill = "")
	{
		string result = "";
		result = AppendResult(result, BaseAntiStuck_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, BaseMonsterShared_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, BaseMonsterShared_OnGameDamaged_2(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, MummyBase_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		return result;
	}

	void OnMummyImmunes() { MummyBase_OnMummyImmunes(); } // mummy_immunes
	void OnFrameSlash() { MummyBase_OnFrameSlash(); } // frame_slash
	void OnFrameSlash1() { MummyBase_OnFrameSlash1(); } // frame_slash1
	void OnFrameStab1() { MummyBase_OnFrameStab1(); } // frame_stab1
	void OnFrameLongslash() { MummyBase_OnFrameLongslash(); } // frame_longslash
	void OnFrameStab() { MummyBase_OnFrameStab(); } // frame_stab
	void OnFrameSteelpipe() { MummyBase_OnFrameSteelpipe(); } // frame_steelpipe
	void OnFrameBiteStart() { MummyBase_OnFrameBiteStart(); } // frame_bite_start
	void OnFrameBiteDmg() { MummyBase_OnFrameBiteDmg(); } // frame_bite_dmg
	void OnMummyRepulseAura() { MummyBase_OnMummyRepulseAura(); } // mummy_repulse_aura
	void OnMummyRepulseTargets() { MummyBase_OnMummyRepulseTargets(); } // mummy_repulse_targets
	void OnMummyAuraSound1() { MummyBase_OnMummyAuraSound1(); } // mummy_aura_sound1
	void OnMummyAuraSound2() { MummyBase_OnMummyAuraSound2(); } // mummy_aura_sound2
	void OnMummyIceAura() { MummyBase_OnMummyIceAura(); } // mummy_ice_aura
	void OnMummyIceTargets() { MummyBase_OnMummyIceTargets(); } // mummy_ice_targets
	void OnMummyNecroAura() { MummyBase_OnMummyNecroAura(); } // mummy_necro_aura
	void OnSpawnSquatting() { MummyBase_OnSpawnSquatting(); } // spawn_squatting
	void OnSpawnEating() { MummyBase_OnSpawnEating(); } // spawn_eating
	void OnMummyGetupNow() { MummyBase_OnMummyGetupNow(); } // mummy_getup_now
	void OnMummyForceEatMode(string mode = "") { MummyBase_OnMummyForceEatMode(mode); } // mummy_force_eat_mode
	void OnMummyForceSquatMode(string mode = "") { MummyBase_OnMummyForceSquatMode(mode); } // mummy_force_squat_mode
	void OnMummyEatToStand() { MummyBase_OnMummyEatToStand(); } // mummy_eat_to_stand
	void OnMummySquatToStand() { MummyBase_OnMummySquatToStand(); } // mummy_squat_to_stand
	void OnMummyTargetDisturber() { MummyBase_OnMummyTargetDisturber(); } // mummy_target_disturber
	void OnMummyReturnToProxscan() { MummyBase_OnMummyReturnToProxscan(); } // mummy_return_to_proxscan
	void OnNpcDeath() { MummyBase_OnNpcDeath(); } // npc_death
	void OnMummyRebirthCheck() { MummyBase_OnMummyRebirthCheck(); } // mummy_rebirth_check
	void OnMummyRebirthScanLoop() { MummyBase_OnMummyRebirthScanLoop(); } // mummy_rebirth_scan_loop
	void OnMummyRebirth() { MummyBase_OnMummyRebirth(); } // mummy_rebirth
	void OnMummyRebirth2() { MummyBase_OnMummyRebirth2(); } // mummy_rebirth2
	void OnMummyRebirth3() { MummyBase_OnMummyRebirth3(); } // mummy_rebirth3
	void OnMummyAurasOff() { MummyBase_OnMummyAurasOff(); } // mummy_auras_off
	void OnSetNoFakeDeath() { MummyBase_OnSetNoFakeDeath(); } // set_no_fake_death
	void OnMummyClericCycle() { MummyBase_OnMummyClericCycle(); } // mummy_cleric_cycle
	void OnMummyClericHealAnim() { MummyBase_OnMummyClericHealAnim(); } // mummy_cleric_heal_anim
	void OnMummyFindHealTarget() { MummyBase_OnMummyFindHealTarget(); } // mummy_find_heal_target
	void OnMummyHealed() { MummyBase_OnMummyHealed(); } // mummy_healed
	void OnExtSetbody(int bodyGroup = 0, int submodel = 0) { MummyBase_OnExtSetbody(bodyGroup, submodel); } // ext_setbody
	void OnNpcFlinch(float damage = 0.0f) { MummyBase_OnNpcFlinch(damage); } // npc_flinch
	void OnMummyPikeCheck() { MummyBase_OnMummyPikeCheck(); } // mummy_pike_check
	void OnMummyPikeReload() { MummyBase_OnMummyPikeReload(); } // mummy_pike_reload
	void OnMummyPikeReload2() { MummyBase_OnMummyPikeReload2(); } // mummy_pike_reload2
	void OnExtProjectileHit() { MummyBase_OnExtProjectileHit(); } // ext_projectile_hit
	void OnMummyNecroSummon() { MummyBase_OnMummyNecroSummon(); } // mummy_necro_summon
	void OnMummyNecroSummon2() { MummyBase_OnMummyNecroSummon2(); } // mummy_necro_summon2
	void OnMummyNecroSummon3() { MummyBase_OnMummyNecroSummon3(); } // mummy_necro_summon3
	void OnExtWraithDied() { MummyBase_OnExtWraithDied(); } // ext_wraith_died
	void OnMummyBeamAttack() { MummyBase_OnMummyBeamAttack(); } // mummy_beam_attack
	void OnMummyBeamAttackEnd() { MummyBase_OnMummyBeamAttackEnd(); } // mummy_beam_attack_end
	void OnMummyBeamNewTarget(string target = "") { MummyBase_OnMummyBeamNewTarget(target); } // mummy_beam_new_target
	void OnMummyBeamAttackLoop() { MummyBase_OnMummyBeamAttackLoop(); } // mummy_beam_attack_loop
	void OnMummyBreathAttack() { MummyBase_OnMummyBreathAttack(); } // mummy_breath_attack
	void OnMummyBreathStart() { MummyBase_OnMummyBreathStart(); } // mummy_breath_start
	void OnMummyBreathLoop() { MummyBase_OnMummyBreathLoop(); } // mummy_breath_loop
	void OnMummyBreathStop() { MummyBase_OnMummyBreathStop(); } // mummy_breath_stop
	void OnMummyBreathStopSound() { MummyBase_OnMummyBreathStopSound(); } // mummy_breath_stop_sound
	void OnMummyBreathAffectTargets() { MummyBase_OnMummyBreathAffectTargets(); } // mummy_breath_affect_targets
	void OnMummyDoubleCycleEvent() { MummyBase_OnMummyDoubleCycleEvent(); } // mummy_double_cycle_event
	void OnSetClericRange(string value = "", string healRange = "") { MummyBase_OnSetClericRange(value, healRange); } // set_cleric_range
	void OnFreqMummyBeamAttack() {} // FREQ_MUMMY_BEAM_ATTACK
	void OnFreqMummyBreathAttack() {} // FREQ_MUMMY_BREATH_ATTACK
	void OnMummyBeamDur() {} // MUMMY_BEAM_DUR
	void OnMummyBreathDuration() {} // MUMMY_BREATH_DURATION
	void OnMummyFreqDoubleCycle() {} // MUMMY_FREQ_DOUBLE_CYCLE
	void OnMummySpawn() {} // mummy_spawn

	// This file's events and timers by their .script names
	bool MummyBase_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "cycle_up") { OnCycleUp(Param(params, 0)); return true; }
		if (name == "ext_projectile_hit") { OnExtProjectileHit(); return true; }
		if (name == "ext_setbody") { OnExtSetbody(Int(Param(params, 0)), Int(Param(params, 1))); return true; }
		if (name == "ext_wraith_died") { OnExtWraithDied(); return true; }
		if (name == "frame_bite_dmg") { OnFrameBiteDmg(); return true; }
		if (name == "frame_bite_start") { OnFrameBiteStart(); return true; }
		if (name == "frame_longslash") { OnFrameLongslash(); return true; }
		if (name == "frame_slash") { OnFrameSlash(); return true; }
		if (name == "frame_slash1") { OnFrameSlash1(); return true; }
		if (name == "frame_stab") { OnFrameStab(); return true; }
		if (name == "frame_stab1") { OnFrameStab1(); return true; }
		if (name == "frame_steelpipe") { OnFrameSteelpipe(); return true; }
		if (name == "game_damaged") { Return(OnGameDamaged(EntityParam(params, 0), Float(Param(params, 1)), Param(params, 2), Float(Param(params, 3)), EntityParam(params, 4), Param(params, 5))); return true; }
		if (name == "game_death") { OnGameDeath(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_dodamage") { Return(OnGameDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5))); return true; }
		if (name == "game_dynamically_created") { OnGameDynamicallyCreated(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Float(Param(params, 6)), Param(params, 7), Param(params, 8)); return true; }
		if (name == "game_struck") { OnGameStruck(Float(Param(params, 0)), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "mummy_aura_sound1") { OnMummyAuraSound1(); return true; }
		if (name == "mummy_aura_sound2") { OnMummyAuraSound2(); return true; }
		if (name == "mummy_auras_off") { OnMummyAurasOff(); return true; }
		if (name == "mummy_beam_attack") { OnMummyBeamAttack(); return true; }
		if (name == "mummy_beam_attack_end") { OnMummyBeamAttackEnd(); return true; }
		if (name == "mummy_beam_attack_loop") { OnMummyBeamAttackLoop(); return true; }
		if (name == "mummy_beam_new_target") { OnMummyBeamNewTarget(Param(params, 0)); return true; }
		if (name == "mummy_breath_affect_targets") { OnMummyBreathAffectTargets(); return true; }
		if (name == "mummy_breath_attack") { OnMummyBreathAttack(); return true; }
		if (name == "mummy_breath_loop") { OnMummyBreathLoop(); return true; }
		if (name == "mummy_breath_start") { OnMummyBreathStart(); return true; }
		if (name == "mummy_breath_stop") { OnMummyBreathStop(); return true; }
		if (name == "mummy_breath_stop_sound") { OnMummyBreathStopSound(); return true; }
		if (name == "mummy_cleric_cycle") { OnMummyClericCycle(); return true; }
		if (name == "mummy_cleric_heal_anim") { OnMummyClericHealAnim(); return true; }
		if (name == "mummy_double_cycle_event") { OnMummyDoubleCycleEvent(); return true; }
		if (name == "mummy_eat_to_stand") { OnMummyEatToStand(); return true; }
		if (name == "mummy_find_heal_target") { OnMummyFindHealTarget(); return true; }
		if (name == "mummy_force_eat_mode") { OnMummyForceEatMode(Param(params, 0)); return true; }
		if (name == "mummy_force_squat_mode") { OnMummyForceSquatMode(Param(params, 0)); return true; }
		if (name == "mummy_getup_now") { OnMummyGetupNow(); return true; }
		if (name == "mummy_healed") { OnMummyHealed(); return true; }
		if (name == "mummy_ice_aura") { OnMummyIceAura(); return true; }
		if (name == "mummy_ice_targets") { OnMummyIceTargets(); return true; }
		if (name == "mummy_immunes") { OnMummyImmunes(); return true; }
		if (name == "mummy_necro_aura") { OnMummyNecroAura(); return true; }
		if (name == "mummy_necro_summon") { OnMummyNecroSummon(); return true; }
		if (name == "mummy_necro_summon2") { OnMummyNecroSummon2(); return true; }
		if (name == "mummy_necro_summon3") { OnMummyNecroSummon3(); return true; }
		if (name == "mummy_pike_check") { OnMummyPikeCheck(); return true; }
		if (name == "mummy_pike_reload") { OnMummyPikeReload(); return true; }
		if (name == "mummy_pike_reload2") { OnMummyPikeReload2(); return true; }
		if (name == "mummy_rebirth") { OnMummyRebirth(); return true; }
		if (name == "mummy_rebirth2") { OnMummyRebirth2(); return true; }
		if (name == "mummy_rebirth3") { OnMummyRebirth3(); return true; }
		if (name == "mummy_rebirth_check") { OnMummyRebirthCheck(); return true; }
		if (name == "mummy_rebirth_scan_loop") { OnMummyRebirthScanLoop(); return true; }
		if (name == "mummy_repulse_aura") { OnMummyRepulseAura(); return true; }
		if (name == "mummy_repulse_targets") { OnMummyRepulseTargets(); return true; }
		if (name == "mummy_return_to_proxscan") { OnMummyReturnToProxscan(); return true; }
		if (name == "mummy_squat_to_stand") { OnMummySquatToStand(); return true; }
		if (name == "mummy_target_disturber") { OnMummyTargetDisturber(); return true; }
		if (name == "my_target_died") { OnMyTargetDied(Param(params, 0)); return true; }
		if (name == "npc_death") { OnNpcDeath(); return true; }
		if (name == "npc_flinch") { OnNpcFlinch(Float(Param(params, 0))); return true; }
		if (name == "npc_selectattack") { OnNpcSelectattack(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "npcatk_hunt") { OnNpcatkHunt(); return true; }
		if (name == "set_cleric_range") { OnSetClericRange(Param(params, 0), Param(params, 1)); return true; }
		if (name == "set_no_fake_death") { OnSetNoFakeDeath(); return true; }
		if (name == "spawn_eating") { OnSpawnEating(); return true; }
		if (name == "spawn_squatting") { OnSpawnSquatting(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "monsters/mummy_base"]
shared class MummyBaseScript : BaseMonsterNewScript, MummyBase
{
	// Variables declared by included files, with the value they start with in this script
	MummyBaseScript()
	{
		SOUND_DEATH = "agrunt/ag_die3.wav";
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/mummy.mdl");
		Precache("magic/chant_loop.wav");
		Precache("magic/haunted_loop.wav");
		Precache("magic/bolt_loop.wav");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		MummyBase_FirstThink();
		MummyBase_FirstThink2();
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
		return MummyBase_DispatchEvent(name, params)
			|| BaseMonsterNewScript::DispatchEvent(name, params);
	}
}
