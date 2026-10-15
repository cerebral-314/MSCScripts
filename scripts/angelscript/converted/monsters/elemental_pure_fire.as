#pragma context server

// Converted from monsters/elemental_pure_fire.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_monster_new.as"
#include "converted/monsters/base_propelled.as"
#include "converted/monsters/base_struck.as"
#include "converted/monsters/base_flyer_grav.as"

[script "monsters/elemental_pure_fire"]
class ElementalPureFire : BaseMonsterNewScript, BasePropelled, BaseStruck, BaseFlyerGrav
{
	// Constants
	string ANIM_PROJECTILE = "fireball";
	int MOVESPEED_SLOW = 100;
	int MOVESPEED_FAST = 200;
	int DMG_STRIKE = 0;
	int DOT_STRIKE = 0;
	string ACCURACY_STRIKE = "80%";
	int DMG_AMB_BURN = 0;
	int DMG_FIRE_BALL = 100;
	int DMG_FIRE_BOLT = 20;
	string SOUND_FIRECHARGE = "magic/fireball_powerup.wav";
	string SOUND_FIRESHOOT = "magic/fireball_strike.wav";
	string SOUND_FIRESHOOT2 = "weapons/rocketfire1.wav";
	string SOUND_IDLE1 = "agrunt/ag_alert1.wav";
	string SOUND_IDLE2 = "agrunt/ag_die1.wav";
	string SOUND_IDLE3 = "agrunt/ag_idle1.wav";
	string SOUND_SWIPE = "weapons/debris1.wav";
	string SOUND_SWIPEHIT = "ambience/steamburst1.wav";
	string SOUND_PAIN1 = "debris/bustflesh2.wav";
	string SOUND_PAIN2 = "agrunt/ag_pain1.wav";
	string SOUND_PAIN3 = "agrunt/ag_pain4.wav";
	string SOUND_GLOAT = "x/x_laugh1.wav";
	int NPC_PITCH_PAIN = 1;
	string SOUND_STRUCK1 = "bullchicken/bc_acid1.wav";
	string SOUND_STRUCK2 = "bullchicken/bc_acid1.wav";
	string SOUND_STRUCK3 = "ambience/flameburst1.wav";
	bool NPC_USE_FLINCH = true;
	float NPC_FLINCH_HEALTH_RATIO = 0.5f;
	float FREQ_CL_REFRESH = 5.0f;
	Vector3 ELM_COLOR = Vector3();
	string ELM_TYPE = "fire";
	string MELEE_RANGE = "96";
	string CL_FX_SCRIPT = "monsters/elemental_pure_cl";
	int ELEMENTAL_EXP = 500;
	float DMG_BASE = 100.0f;
	string DOT1_SCRIPT = "effects/dot_fire";
	string DOT1_ID = "DOT_fire";
	float DOT1_DURATION = 5.0f;
	float DOT1_DMG = 0.0f;
	string DOT2_SCRIPT = "effects/dot_fire";
	string DOT2_ID = "DOT_fire";
	float DOT2_DURATION = 5.0f;
	float DOT2_DMG = 0.0f;
	string PROJECTILE1_SCRIPT = "proj_fire_ball";
	string PROJECTILE2_SCRIPT = "proj_fire_xolt";
	float DMG_PROJ = 0.0f;

	// Variables (an unset .script variable reads as its own name)
	bool AS_SUMMON_TELE_CHECK = true;
	bool IS_UNHOLY = true;
	bool EFFECT_NO_GLOW_SHELLS = false;
	string ANIM_ATTACK = "ANIM_ATTACK";
	string ANIM_FLINCH = "ANIM_FLINCH";
	float NPC_HACKED_MOVE_SPEED = 0.0f;
	float FREQ_SPECIAL = 0.0f;
	float DOT_STACK = 0.0f;
	bool PROJ_GUIDED = false;
	bool PROJ_NO_SPRITES = false;
	bool GAME_NO_CORPSE = false;
	int ELEMENT_SEAL_IDX = 0;
	float NEXT_SEAL = 0.0f;
	int DID_INTRO = 0;
	float NEXT_LOOP_SOUND = 0.0f;
	float ARCH_COUNT_GUIDED = 0.0f;
	string CL_IDX = "CL_IDX";
	float NEXT_CL_REFRESH = 0.0f;
	Vector3 SEAL_POS = Vector3();

	// Variables declared by included files, with the value they start with in this script
	ElementalPureFire()
	{
		ANIM_IDLE = "idle1";
		ANIM_WALK = "idle1";
		ANIM_RUN = "idle1";
		IS_BLOODLESS = true;
		SOUND_DEATH = "garg/gar_die1.wav";
	}

	// unnamed block (first think)
	// cheap sprite based monster based on fire elemental
	// immune to physical damage
	// other flavors pending
	void ElementalPureFire_FirstThink()
	{
		AS_SUMMON_TELE_CHECK = true;

		EFFECT_NO_GLOW_SHELLS = true;

		// base anims
		ANIM_IDLE = "idle1";
		ANIM_WALK = "idle1";
		ANIM_RUN = "idle1";
		ANIM_ATTACK = "attack1";
		ANIM_FLINCH = "flinch";
		ANIM_DEATH = "die1";
		ANIM_ATTACK = "attack1";

		// base stats
		IS_UNHOLY = true;
		IS_BLOODLESS = true;
		IMMUNE_VAMPIRE = true;
		ATTACK_RANGE = 1024.0f;
		ATTACK_HITRANGE = 1024.0f;
		MOVE_RANGE = "512";
		NPC_HACKED_MOVE_SPEED = 100.0f;
		FREQ_SPECIAL = 5.0f;
		ANIM_FLINCH = "flinch";
		NPC_GIVE_EXP = ELEMENTAL_EXP;

		DOT_STACK = 0.0f; // at 4 stacks, applies DOT2

		PROJ_GUIDED = true;
		PROJ_NO_SPRITES = true;

		GAME_NO_CORPSE = true;
	}

	// game_damaged
	// PARAM1=attacker PARAM2=dmg PARAM3=dmg_type PARAM4=accuracy_roll PARAM5=skill PARAM6=Inflicter
	string ElementalPureFire_OnGameDamaged(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float accuracyRoll = 0.0f, CBaseEntity@ inflictor = null, string skill = "")
	{
		bool noDmg = false;
		string result = "";
		if (Contains(damageType, "slash"))
			noDmg = true;
		if (Contains(damageType, "blunt"))
			noDmg = true;
		if (Contains(damageType, "pierce"))
			noDmg = true;
		if (Contains(damageType, "generic"))
			noDmg = true;

		if (!noDmg)
			return result;
		if (IsPlayer(attacker))
			PlayerMessageDark(attacker, NameOf(ENT_ME) + " is immune to physical attacks!");
		return result;
	}

	// bs_global_command
	// player I was attacking died
	void OnBsGlobalCommand(CBasePlayer@ deadPlayer = null, string command = "", string reason = "")
	{
		MonstersExternals_OnBsGlobalCommand(deadPlayer, command, reason); // monsters/externals
		DebugPrint("bs_global_command " + NameOf(deadPlayer) + " " + command + " " + reason);
		if (EntityId(deadPlayer) != NPCATK_TARGET)
			return;
		if (reason != "death")
			return;
		PlaySound(0, 10, SOUND_GLOAT);
		PlayAnim("critical", "yes");
		DID_INTRO = 0;
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseNpc_OnGameSpawn(playerRace, playerGender); // monsters/base_npc
		BaseMonsterShared_OnGameSpawn(playerRace, playerGender); // monsters/base_monster_shared
		BaseStruck_OnGameSpawn(playerRace, playerGender); // monsters/base_struck
		BaseFlyerGrav_OnGameSpawn(playerRace, playerGender); // monsters/base_flyer_grav
		OnPElementalSpawn();
	}

	// npcatk_hunt
	void OnNpcatkHunt()
	{
		BaseNpcAttackNew_OnNpcatkHunt(); // monsters/base_npc_attack_new
		BaseAntiStuck_OnNpcatkHunt(); // monsters/base_anti_stuck
		BaseStruck_OnNpcatkHunt(); // monsters/base_struck
		BaseFlyerGrav_OnNpcatkHunt(); // monsters/base_flyer_grav
		float gameTime = GameTime();

		if (IsAlive(ENT_ME))
		{
			SetProp(ENT_ME, "rendermode", 5);
			SetProp(ENT_ME, "renderamt", 1);
		}

		if (gameTime > NEXT_CL_REFRESH)
			OnClRefresh();

		if (gameTime > NEXT_LOOP_SOUND)
		{
			NEXT_LOOP_SOUND = gameTime + 6.0f;
			ServerPlaySound(2, 0, "ambience/alien_powernode.wav");
			ServerPlaySound(2, 10, "ambience/alien_powernode.wav");
		}

		if (NPCATK_TARGET == "unset")
			return;
		if (!NPC_CANSEE_TARGET)
			return;
		if (I_R_FROZEN)
			return;

		if (gameTime > NEXT_SEAL && DID_INTRO != 0)
		{
			NEXT_SEAL = gameTime + Random(20, 30);
			OnDoSeal();
		}

		if (RangeTo(NPCATK_TARGET) < Float(MELEE_RANGE))
		{
			ANIM_ATTACK = "attack1"; // attack1_strike
		}
		else
		{
			ANIM_ATTACK = "fireball"; // throw_fireball
		}

		// I have a habit of sticking people in place by sitting on their heads
		// see if this helps
		if (!(RangeTo(NPCATK_TARGET) < 24.0f))
			return;
		AddVelocity(ENT_ME, RelativeVelocity(Vector3(0, -110, 110)));
	}

	// game_damaged - Return a damage multiplier to scale the damage
	string OnGameDamaged(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float accuracyRoll = 0.0f, CBaseEntity@ inflictor = null, string skill = "")
	{
		string result = "";
		result = AppendResult(result, BaseAntiStuck_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, BaseMonsterShared_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, BaseMonsterShared_OnGameDamaged_2(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, BaseStruck_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, ElementalPureFire_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		return result;
	}

	// npc_targetsighted
	void OnNpcTargetsighted(string target = "")
	{
		BaseMonsterShared_OnNpcTargetsighted(target); // monsters/base_monster_shared
		BaseFlyerGrav_OnNpcTargetsighted(target); // monsters/base_flyer_grav
		if (DID_INTRO == 0)
		{
			NEXT_SEAL = 0.0f;
			NEXT_SEAL += Random(20, 30);
			DID_INTRO = 1;
			OnClRefresh();
		}
	}

	// p_elemental_spawn
	void OnPElementalSpawn()
	{
		SetName("Pyron Archon");
		SetHealth(2500);
		SetWidth(48);
		SetHeight(80);
		SetRace("demon");
		SetDamageTaken("holy", 2);
		SetDamageTaken("cold", 1.5f);
		SetDamageTaken("fire", 0);
		SetDamageTaken("poison", 0);

		SetRoam(true);
		SetIdleAnim(ANIM_IDLE);
		SetMoveAnim(ANIM_WALK);
		SetHearingSensitivity(5);
		SetModel("monsters/elementals_greater.mdl");
		SetProp(ENT_ME, "rendermode", 5);
		SetProp(ENT_ME, "renderamt", 1);
		SetModelBody(0, 0);
		NPC_GIVE_EXP = 500.0f;
		SetBlood("none");

		if (ELM_TYPE == "fire")
			ELEMENT_SEAL_IDX = 32;
		else if (ELM_TYPE == "cold")
			ELEMENT_SEAL_IDX = 33;
		else if (ELM_TYPE == "lightning")
			ELEMENT_SEAL_IDX = 34;

		OnClRefresh();
	}

	// throw_fireball
	// ================================================ Frame Events
	void OnThrowFireball()
	{
		ARCH_COUNT_GUIDED += 1.0f;
		if (ARCH_COUNT_GUIDED > 4.0f)
		{
			PlaySound(0, 10, SOUND_FIRESHOOT2);
			ARCH_COUNT_GUIDED = 0.0f;
			TossProjectile("view", 300, DMG_PROJ, 30, PROJECTILE2_SCRIPT, Vector3(0, 0, 64));
			CallExternal(ENT_LASTPROJECTILE, "ext_render", 5, 255);
		}
		else
		{
			// borrowed from elemental_fire1
			PlaySound(0, 10, SOUND_FIRESHOOT);

			float aimAngle = DistanceTo(NPCATK_TARGET);
			DebugPrint("throw_fireball " + Text(aimAngle));
			aimAngle = Divide(aimAngle, 50.0f);
			SetAngle("add_view.x", aimAngle);

			TossProjectile("view", 500, DMG_PROJ, 2, PROJECTILE1_SCRIPT, Vector3(0, 48, 48));
			CallExternal(ENT_LASTPROJECTILE, "lighten", DOT1_DMG);
			CallExternal(ENT_LASTPROJECTILE, "ext_render", 5, 255);
		}
	}

	// attack1_strike
	void OnAttack1Strike()
	{
		DoDamageEx(NPCATK_TARGET, 128, "DMG_SWIPE", 90, ENT_ME, ENT_ME, "none", "fire_effect", "dmgevent:fist");
	}

	// fist_dodamage
	// ================================================ Damage Events
	void OnFistDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		if (!hit)
			return;
		if (RelationshipOf(target, ENT_ME) != "enemy")
			return;

		AddVelocity(target, RelativeVelocity(Vector3(0, 400, 110)));
		if (DOT_STACK >= 4.0f)
		{
			DOT_STACK = 0.0f;
			OnApplyDot2(target);
		}
		else
		{
			OnApplyDot1(target);
		}
	}

	// apply_dot1
	// <target>
	void OnApplyDot1(CBaseEntity@ target = null)
	{
		if (HasEffect(target, DOT1_ID))
			DOT_STACK += 1.0f;
		else
			ApplyEffect(target, DOT1_SCRIPT, DOT1_DURATION, self, DOT1_DMG);
	}

	// apply_dot2
	// <target>
	void OnApplyDot2(CBaseEntity@ target = null)
	{
		if (HasEffect(target, DOT2_ID))
			return;
		ApplyEffect(target, DOT2_SCRIPT, DOT2_DURATION, self, DOT2_DMG);
	}

	// cl_refresh
	// ================================================ Other / Unsorted
	void OnClRefresh()
	{
		if (CL_IDX == "CL_IDX")
		{
			ClientEvent("new", "all", CL_FX_SCRIPT, IndexOf(ENT_ME), ELM_COLOR, ELM_TYPE, FREQ_CL_REFRESH);
			CL_IDX = LastClientScriptId();
		}
		else
		{
			ClientEvent("update", "all", CL_IDX, "end_fx");
			ClientEvent("new", "all", CL_FX_SCRIPT, IndexOf(ENT_ME), ELM_COLOR, ELM_TYPE, FREQ_CL_REFRESH);
			CL_IDX = LastClientScriptId();
		}

		NEXT_CL_REFRESH = GameTime() + FREQ_CL_REFRESH;
	}

	// game_predeath
	void OnGamePredeath()
	{
		ClientEvent("update", "all", CL_IDX, "owner_death");
		SetProp(ENT_ME, "rendermode", 5);
		SetProp(ENT_ME, "renderamt", 0);
		SetModel("null.mdl");
		ServerPlaySound(2, 0, "ambience/alien_powernode.wav");
	}

	// do_seal
	void OnDoSeal()
	{
		OnNpcatkSuspendAi();
		OnNpcatkSuspendMovement("charging");
		PlaySound(0, 10, "weapons/egon_windup2.wav");
		NPC_NO_ATTACK = true;
		OnClRefresh();
		SEAL_POS = OriginOf(NPCATK_TARGET);
		SEAL_POS.z = GroundHeight(SEAL_POS);
		ClientEvent("new", "all", "effects/sfx_seal_warning", SEAL_POS, ELM_TYPE, 128, ELEMENT_SEAL_IDX, 2.0f);
		CallEventDelayed(2.0f, "do_seal2");
	}

	// do_seal2
	void OnDoSeal2()
	{
		ClientEvent("new", "all", "effects/sfx_seal_instant", SEAL_POS, ELM_TYPE, 128, ELEMENT_SEAL_IDX);
		string dmgType = ELM_TYPE + "_effect";
		DoDamageEx(LegacyFunction("math", "vectoradd", SEAL_POS, "z", 32), 128, DMG_BASE, 0.0f, ENT_ME, ENT_ME, "none", dmgType, "dmgevent:seal");

		OnNpcatkResumeAi();
		OnNpcatkResumeMovement();
		NPC_NO_ATTACK = false;
	}

	// seal_dodamage
	void OnSealDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		if (!hit)
			return;
		if (RelationshipOf(target, ENT_ME) != "enemy")
			return;
		OnApplyDot2(target);
		if (Truthy(LegacyFunction("inset_string", ELM_TYPE, "fire", "lightning")))
		{
			Vector3 targOrg = OriginOf(target);
			Vector3 myOrg = SEAL_POS;
			float repelYaw = AnglesTo(myOrg, targOrg);
			AddVelocity(target, RelativeVelocity(Vector3(0, repelYaw, 0), Vector3(0, 600, 600)));
		}
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files

	// game_death
	void OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		DqMonsterExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // dq/externals/dq_monster_externals
		MonstersExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/externals
		BaseSelfAdjust_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_self_adjust
		BaseNpc_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseMonsterShared_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared
		BaseFlyerGrav_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_flyer_grav
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
		BasePropelled_OnNpcPostSpawn(); // monsters/base_propelled
	}

	// npcatk_suspend_ai
	void OnNpcatkSuspendAi(string seconds = "", string debugTag = "")
	{
		BaseNpcAttackNew_OnNpcatkSuspendAi(seconds, debugTag); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcatkSuspendAi(seconds, debugTag); // monsters/base_monster_shared
	}

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/elementals_greater.mdl");
		Precache("ambience/alien_powernode.wav");
		Precache("null.mdl");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		ElementalPureFire_FirstThink();
		BaseNpc_FirstThink();
		MonstersExternals_FirstThink();
		BaseNpcAttackNew_FirstThink();
		BaseMonsterShared_FirstThink();
		BaseStruck_FirstThink();
		BaseFlyerGrav_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "apply_dot1") { OnApplyDot1(EntityParam(params, 0)); return true; }
		if (name == "apply_dot2") { OnApplyDot2(EntityParam(params, 0)); return true; }
		if (name == "attack1_strike") { OnAttack1Strike(); return true; }
		if (name == "bs_global_command") { OnBsGlobalCommand(PlayerParam(params, 0), Param(params, 1), Param(params, 2)); return true; }
		if (name == "cl_refresh") { OnClRefresh(); return true; }
		if (name == "do_seal") { OnDoSeal(); return true; }
		if (name == "do_seal2") { OnDoSeal2(); return true; }
		if (name == "fist_dodamage") { OnFistDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5)); return true; }
		if (name == "game_damaged") { Return(OnGameDamaged(EntityParam(params, 0), Float(Param(params, 1)), Param(params, 2), Float(Param(params, 3)), EntityParam(params, 4), Param(params, 5))); return true; }
		if (name == "game_predeath") { OnGamePredeath(); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "npc_targetsighted") { OnNpcTargetsighted(Param(params, 0)); return true; }
		if (name == "npcatk_hunt") { OnNpcatkHunt(); return true; }
		if (name == "p_elemental_spawn") { OnPElementalSpawn(); return true; }
		if (name == "seal_dodamage") { OnSealDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5)); return true; }
		if (name == "throw_fireball") { OnThrowFireball(); return true; }
		return BasePropelled_DispatchEvent(name, params)
			|| BaseStruck_DispatchEvent(name, params)
			|| BaseFlyerGrav_DispatchEvent(name, params)
			|| BaseMonsterNewScript::DispatchEvent(name, params);
	}
}
