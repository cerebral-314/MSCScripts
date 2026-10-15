#pragma context server

// Converted from monsters/abomination_bone.script by msc_transpiler.
// lightning field (self-expiring client effect)
// acid breath
// charge attack (would, but needs anim, plus always tricky)
// jump/stun

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_monster_new.as"
#include "converted/monsters/base_lightning_shield.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class AbominationBone
{
	// Constants
	string ANIM_ATTACK_SHORT = "attack1";
	string ANIM_ATTACK_LONG = "attack2";
	string ANIM_CRAWL = "crawl";
	string ANIM_WALK_ACTIVE = "walk";
	string ANIM_LIGHTNING = "breath_fast";
	string ANIM_FLING = "grab_fling";
	string ANIM_JUMP = "jump";
	string ANIM_BREATH_ATTACK = "breath";
	string ANIM_RAWR = "rawr";
	float MONSTER_HP = 20000.0f;
	int ATTACK_RANGE_SHORT = 100;
	int ATTACK_RANGE_LONG = 150;
	int ATTACK_HITRANGE_SHORT = 150;
	int ATTACK_HITRANGE_LONG = 200;
	string ATTACK_HITCHANCE = "80%";
	int DOT_BREATH = 200;
	int DMG_BITE_SHORT = 300;
	int DMG_BITE_LONG = 600;
	float FREQ_SPECIAL = 0.0f;
	float FREQ_IDLE = 0.0f;
	string SOUND_RAWR = "monsters/abombination/rawr.wav";
	string SOUND_ATTACK1 = "monsters/abombination/attack1.wav";
	string SOUND_ATTACK2 = "monsters/abombination/attack2.wav";
	string SOUND_IDLE1 = "monsters/abombination/growl1.wav";
	string SOUND_IDLE2 = "monsters/abombination/growl2.wav";
	string SOUND_PAIN1 = "monsters/abombination/pain1.wav";
	string SOUND_PAIN2 = "monsters/abombination/pain2.wav";
	string SOUND_DEATH = "monsters/abombination/die.wav";
	string SOUND_STEP1 = "monsters/abombination/step1.wav";
	string SOUND_STEP2 = "monsters/abombination/step2.wav";
	string SOUND_STRUCK1 = "weapons/bullet_hit1.wav";
	string SOUND_STRUCK2 = "weapons/bullet_hit2.wav";
	string SOUND_ATTACK_LONG = "zombie/claw_miss1.wav";
	string SOUND_ATTACK_SHORT = "zombie/claw_miss2.wav";
	string SOUND_BREATH_START = "ambience/steamburst1.wav";
	string SOUND_BREATH_LOOP = "ambience/steamjet1.wav";
	bool LSHIELD_PASSIVE = false;
	int LSHIELD_REPELL_STRENGTH = 300;
	float LSHIELD_FREQ_UPDATE = 0.25f;
	int DMG_LSHIELD = 300;
	int LSHIELD_RADIUS = 128;
	string SOUND_ZAP_LOOP = "magic/bolt_loop.wav";
	string SOUND_ZAP_START = "magic/bolt_end.wav";

	// Variables (an unset .script variable reads as its own name)
	string ANIM_WALK = "crawl";
	string ANIM_RUN = "run";
	string ANIM_IDLE = "idle1";
	string ANIM_ATTACK = "ANIM_ATTACK";
	string ANIM_DEATH = "ANIM_DEATH";
	bool IS_UNHOLY = true;
	bool IMMUNE_VAMPIRE = true;
	string NPC_BASE_EXP = "NPC_BASE_EXP";
	float ATTACK_RANGE = 0.0f;
	float ATTACK_HITRANGE = 0.0f;
	float CUR_SPECIAL = 0.0f;
	float NEXT_IDLE = 0.0f;
	float NPC_HALF_HEALTH = 0.0f;
	float NEXT_SPECIAL = 0.0f;
	float ATTACK_COUNTER = 0.0f;
	bool DID_WARCRY = false;
	float AS_ATTACKING = 0.0f;
	float BREATH_IDX = 0.0f;
	float BREATH_ANG = 0.0f;
	float BREATH_COUNT = 0.0f;
	bool BREATH_ATTACK_ON = false;
	float NEXT_SCAN = 0.0f;
	string CLOUD_TARGS = "CLOUD_TARGS";
	bool MELEE_ATTACK_SHORT = false;
	bool MELEE_ATTACK_LONG = false;
	string STUN_TARGS = "STUN_TARGS";
	bool DROP_HUNDERSWAMP_CHEST = false;

	// unnamed block (first think)
	void AbominationBone_FirstThink()
	{
		// base anims
		ANIM_WALK = "crawl";
		ANIM_RUN = "run";
		ANIM_IDLE = "idle1";
		ANIM_ATTACK = "attack1";
		ANIM_DEATH = "death1_die";
	}

	// unnamed block (first think)
	void AbominationBone_FirstThink2()
	{
		NPC_BASE_EXP = "10000";

		if (ToLowerCase(MapName()) == "deraliasewers")
			NPC_BASE_EXP = "5000";

		// base stats
		ATTACK_RANGE = 150.0f;
		ATTACK_HITRANGE = 200.0f;
		IS_UNHOLY = true;
		IMMUNE_VAMPIRE = true;
	}

	// npc_spawn
	void AbominationBone_OnNpcSpawn(string npc = "")
	{
		if (ToLowerCase(MapName()) == "shad_palace")
			SetName("Bone Guardian");
		else
			SetName("Bone Abomination");

		SetModel("monsters/abomination.mdl");

		SetHeight(72);
		SetWidth(96);

		SetRace("demon");

		SetBlood("none");

		if (!START_SUSPEND)
			SetRoam(true);
		SetHearingSensitivity(4);

		SetMoveAnim(ANIM_WALK);
		SetIdleAnim(ANIM_IDLE);

		SetHealth(MONSTER_HP);

		SetDamageTaken("all", 0.5f);
		SetDamageTaken("holy", 1.5f);
		SetDamageTaken("fire", 1.25f);
		SetDamageTaken("cold", 0.5f);
		SetDamageTaken("poison", 0);

		SetDamageTaken("slash", 1);
		SetDamageTaken("blunt", 1.25f);
		SetDamageTaken("pierce", 0.75f);
		SetDamageTaken("stun", 0.5f);

		CUR_SPECIAL = 0.0f;
		NEXT_IDLE = GameTime() + FREQ_IDLE;

		CallEventDelayed(2.0f, "final_adj");

		if (!START_SUSPEND)
			return;
		SetInvincible(true);
		OnNpcatkSuspendAi();
	}

	// final_adj
	void AbominationBone_OnFinalAdj()
	{
		NPC_HALF_HEALTH = MaxHealthOf(ENT_ME) * 0.5f;

		if (!START_SUSPEND)
			return;
		OnNpcatkSuspendAi();
	}

	// cycle_up
	void AbominationBone_OnCycleUp(string reason = "")
	{
		NEXT_SPECIAL = GameTime() + FREQ_SPECIAL;
		ATTACK_COUNTER = 0.0f;
		if (DID_WARCRY)
			return;
		PlayAnim("critical", ANIM_RAWR);
		PlaySound(0, 10, SOUND_RAWR);
		DID_WARCRY = true;
	}

	// cycle_down
	void AbominationBone_OnCycleDown()
	{
		DID_WARCRY = false;
	}

	// my_target_died
	void AbominationBone_OnMyTargetDied(string offender = "")
	{
		PlayRandomSound(0, 10, SOUND_IDLE1, SOUND_IDLE2);
	}

	// npcatk_hunt
	void AbominationBone_OnNpcatkHunt()
	{
		if (NPCATK_TARGET == "unset" && GameTime() > NEXT_IDLE)
		{
			NEXT_IDLE = GameTime() + FREQ_IDLE;
			PlayRandomSound(0, 10, SOUND_IDLE1, SOUND_IDLE2);
			PlayAnim("once", "breath_slow");
		}

		if (NPCATK_TARGET == "unset")
			return;

		if (RangeTo(NPCATK_TARGET) < ATTACK_RANGE_LONG)
		{
			ANIM_ATTACK = ANIM_ATTACK_LONG;
			ATTACK_RANGE = ATTACK_RANGE_LONG;
			ATTACK_HITRANGE = ATTACK_HITRANGE_LONG;
		}
		if (RangeTo(NPCATK_TARGET) < ATTACK_RANGE_SHORT)
		{
			ANIM_ATTACK = ANIM_ATTACK_SHORT;
			ATTACK_RANGE = ATTACK_RANGE_SHORT;
			ATTACK_HITRANGE = ATTACK_HITRANGE_SHORT;
		}

		if (!(GameTime() > NEXT_SPECIAL))
			return;
		NEXT_SPECIAL = GameTime() + FREQ_SPECIAL;
		CUR_SPECIAL += 1.0f;
		if (CUR_SPECIAL == 1.0f)
			OnDoLfield();
		if (CUR_SPECIAL == 2.0f)
		{
			AS_ATTACKING = GameTime() + 3.0f;
			PlayAnim("critical", ANIM_JUMP);
			CallEventDelayed(0.01f, "jump_boost");
		}
		if (CUR_SPECIAL == 3.0f)
		{
			OnDoBreathAttack();
			CUR_SPECIAL = 0.0f;
		}
	}

	// jump_boost
	void AbominationBone_OnJumpBoost()
	{
		AddVelocity(ENT_ME, RelativeVelocity(Vector3(0, 250, 200)));
	}

	// do_lfield
	void AbominationBone_OnDoLfield()
	{
		OnNpcatkSuspendAi();
		PlayAnim("break");
		OnNpcatkSuspendMovement(ANIM_LIGHTNING);
		PlayAnim("critical", ANIM_LIGHTNING);
		OnLshieldActivate(10.0f);
		CallEventDelayed(10.0f, "end_lfield");
	}

	// end_lfield
	void AbominationBone_OnEndLfield()
	{
		OnNpcatkResumeAi();
		OnNpcatkResumeMovement();
		OnLshieldToggleOff();
		NEXT_SPECIAL = GameTime() + FREQ_SPECIAL;
	}

	// do_breath_attack
	void AbominationBone_OnDoBreathAttack()
	{
		ClientEvent("new", "all", "monsters/abomination_cl", IndexOf(ENT_ME));
		BREATH_IDX = Float(LastClientScriptId());
		OnNpcatkSuspendAi();
		OnNpcatkSuspendMovement(ANIM_BREATH_ATTACK);
		PlaySound(1, 10, SOUND_BREATH_START);
		ServerPlaySound(2, 10, SOUND_BREATH_LOOP);
		PlayAnim("break");
		PlayAnim("hold", ANIM_BREATH_ATTACK);
		SetMoveDest(NPCATK_TARGET, 9999);
		BREATH_ANG = AnglesOf(ENT_ME).y - 45.0f;
		if (BREATH_ANG < 0.0f)
			BREATH_ANG += 359.0f;
		BREATH_COUNT = 0.0f;
		BREATH_ATTACK_ON = true;
		CallEventDelayed(0.01f, "breath_attack_loop");
	}

	// breath_attack_loop
	void AbominationBone_OnBreathAttackLoop()
	{
		int count;
		if (!BREATH_ATTACK_ON)
			return;

		BREATH_COUNT += 1.0f;
		if (BREATH_COUNT == 45.0f)
			OnEndBreathAttack();

		if (!(BREATH_COUNT < 45.0f))
			return;
		CallEventDelayed(0.05f, "breath_attack_loop");

		BREATH_ANG += 1.0f;
		if (BREATH_ANG > 359.0f)
			BREATH_ANG -= 359.0f;

		Vector3 facePos = OriginOf(ENT_ME) + RelativePosition(Vector3(0, BREATH_ANG, 0), Vector3(0, 500, 0));
		SetMoveDest(facePos, 9999);

		if (!(GameTime() > NEXT_SCAN))
			return;
		NEXT_SCAN = GameTime() + 0.25f;
		Vector3 scanPoint = RelativePosition(Vector3(0, 128, 0));
		CLOUD_TARGS = LegacyFunction("get_tsphere", "enemy", 256, scanPoint);
		if (CLOUD_TARGS != "none")
		{
			count = GetTokenCount(CLOUD_TARGS);
			for (int i = 0; i < count; i++)
			{
				loopIteration = i;
				OnBreathAffectTargets();
			}
		}
	}

	// breath_affect_targets
	void AbominationBone_OnBreathAffectTargets()
	{
		CBaseEntity@ curTarget = FindEntity(GetToken(CLOUD_TARGS, loopIteration));
		Vector3 targOrg = OriginOf(curTarget);
		if (!WithinCone2D(targOrg, MyOrigin(), MyAngles(), 30))
			return;
		if (!(RangeTo(curTarget) < 384.0f))
			return;
		ApplyEffect(curTarget, "effects/dot_poison_blind", 5.0f, self, DOT_BREATH, 0, 0, "none");
		AddVelocity(curTarget, RelativeVelocity(Vector3(0, 800, 120)));
	}

	// end_breath_attack
	void AbominationBone_OnEndBreathAttack()
	{
		NEXT_SPECIAL = GameTime() + FREQ_SPECIAL;

		ClientEvent("update", "all", BREATH_IDX, "end_fx");
		OnNpcatkResumeAi();
		OnNpcatkResumeMovement();
		PlayAnim("critical", ANIM_ATTACK);
		ServerPlaySound(2, 0, SOUND_BREATH_LOOP);
		BREATH_ATTACK_ON = false;
	}

	// frame_attack_short
	void AbominationBone_OnFrameAttackShort()
	{
		PlaySound(1, 10, SOUND_ATTACK_SHORT);
		ATTACK_COUNTER += 1.0f;
		if (ATTACK_COUNTER > 4.0f)
		{
			PlayRandomSound(2, 10, SOUND_ATTACK1, SOUND_ATTACK2);
			ATTACK_COUNTER = Random(-2, 1);
		}
		MELEE_ATTACK_SHORT = true;
		DoDamage(NPCATK_TARGET, ATTACK_HITRANGE, DMG_BITE_SHORT, ATTACK_HITCHANCE, "slash");
	}

	// frame_attack_long
	void AbominationBone_OnFrameAttackLong()
	{
		PlaySound(1, 10, SOUND_ATTACK_LONG);
		ATTACK_COUNTER += 1.0f;
		if (ATTACK_COUNTER > 3.0f)
		{
			PlayRandomSound(2, 10, SOUND_ATTACK1, SOUND_ATTACK2);
			ATTACK_COUNTER = Random(-2, 1);
		}
		MELEE_ATTACK_LONG = true;
		DoDamage(NPCATK_TARGET, ATTACK_HITRANGE, DMG_BITE_LONG, ATTACK_HITCHANCE, "slash");
	}

	// frame_run
	void AbominationBone_OnFrameRun()
	{
		PlayRandomSound(0, 10, SOUND_STEP1, SOUND_STEP2);
	}

	// frame_jump_land
	void AbominationBone_OnFrameJumpLand()
	{
		NEXT_SPECIAL = GameTime() + FREQ_SPECIAL;
		Vector3 myGround = OriginOf(ENT_ME);
		myGround.z = GroundHeight(myGround);
		ClientEvent("new", "all", "effects/sfx_stun_burst", myGround, 256, 1, Vector3(64, 64, 255));
		STUN_TARGS = FindInSphere("enemy", 256);
		if (STUN_TARGS == "none")
			return;
		int count = GetTokenCount(STUN_TARGS);
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnStunTargets();
		}
	}

	// stun_targets
	void AbominationBone_OnStunTargets()
	{
		bool exitSub = false;
		CBaseEntity@ curTarg = FindEntity(GetToken(STUN_TARGS, loopIteration));
		if (IsPlayer(curTarg) && !IsOnGround(curTarg))
			exitSub = true;
		if (exitSub)
			return;
		ApplyEffect(curTarg, "effects/debuff_stun", 5.0f, self);
		Vector3 targOrg = OriginOf(curTarg);
		float targAng = AnglesTo(MyOrigin(), targOrg);
		int newYaw = int(targAng);
		AddVelocity(curTarg, RelativeVelocity(Vector3(0, newYaw, 0), Vector3(0, 800, 110)));
	}

	// game_dodamage
	string AbominationBone_OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";

		if (hit)
		{
			if (MELEE_ATTACK_LONG)
				AddVelocity(target, RelativeVelocity(Vector3(0, 400, 110)));
			if (MELEE_ATTACK_SHORT)
				AddVelocity(target, RelativeVelocity(Vector3(-150, 200, 110)));
		}
		MELEE_ATTACK_LONG = false;
		MELEE_ATTACK_SHORT = false;
		return result;
	}

	// game_struck
	void AbominationBone_OnGameStruck(float damage = 0.0f, string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		if (MaxHealthOf(ENT_ME) > NPC_HALF_HEALTH)
			PlayRandomSound(0, 5, SOUND_STRUCK1, SOUND_STRUCK2);
		else
			PlayRandomSound(0, 5, SOUND_STRUCK1, SOUND_STRUCK2, SOUND_STRUCK1, SOUND_STRUCK2, SOUND_STRUCK1, SOUND_STRUCK2, SOUND_PAIN1, SOUND_PAIN2);
	}

	// game_death
	void AbominationBone_OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		if (DROP_HUNDERSWAMP_CHEST)
		{
			UseTrigger("mm_abom_seal");
			UseTrigger("brk_weed");
			CreateNpc("chests/hunderswamp1_extra", RelativePosition(Vector3(0, 0, 0)));
		}

		if (!BREATH_ATTACK_ON)
			return;
		ClientEvent("update", "all", BREATH_IDX, "end_fx");
	}

	// set_hunderswamp_north_spec
	void AbominationBone_OnSetHunderswampNorthSpec()
	{
		DebugPrint("set_hunderswamp_north_spec");
		SetRace("wildanimal");
		DROP_HUNDERSWAMP_CHEST = true;
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
		BaseLightningShield_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_lightning_shield
		AbominationBone_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4);
	}

	// game_struck
	void OnGameStruck(float damage = 0.0f, string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		BaseNpc_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseNpcAttackNew_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc_attack_new
		BaseMonsterShared_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared
		AbominationBone_OnGameStruck(damage, extraValue2, extraValue3, extraValue4);
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseNpcAttackNew_OnNpcSpawn(npc); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck
		AbominationBone_OnNpcSpawn(npc);
	}

	// npcatk_hunt
	void OnNpcatkHunt()
	{
		BaseNpcAttackNew_OnNpcatkHunt(); // monsters/base_npc_attack_new
		BaseAntiStuck_OnNpcatkHunt(); // monsters/base_anti_stuck
		BaseLightningShield_OnNpcatkHunt(); // monsters/base_lightning_shield
		AbominationBone_OnNpcatkHunt();
	}

	// my_target_died
	void OnMyTargetDied(string offender = "")
	{
		BaseNpcAttackNew_OnMyTargetDied(offender); // monsters/base_npc_attack_new
		AbominationBone_OnMyTargetDied(offender);
	}

	// game_dodamage
	string OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";
		result = AppendResult(result, BaseNpcAttackNew_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BaseAntiStuck_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BaseMonsterShared_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, AbominationBone_OnGameDodamage(hit, target, start, end, damageType, damageText));
		return result;
	}

	// cycle_up
	void OnCycleUp(string reason = "")
	{
		BaseNpcAttackNew_OnCycleUp(reason); // monsters/base_npc_attack_new
		AbominationBone_OnCycleUp(reason);
	}

	// cycle_down
	void OnCycleDown()
	{
		BaseNpcAttackNew_OnCycleDown(); // monsters/base_npc_attack_new
		BaseMonsterShared_OnCycleDown(); // monsters/base_monster_shared
		BaseMonsterShared_OnCycleDown_2(); // monsters/base_monster_shared
		AbominationBone_OnCycleDown();
	}

	void OnFinalAdj() { AbominationBone_OnFinalAdj(); } // final_adj
	void OnJumpBoost() { AbominationBone_OnJumpBoost(); } // jump_boost
	void OnDoLfield() { AbominationBone_OnDoLfield(); } // do_lfield
	void OnEndLfield() { AbominationBone_OnEndLfield(); } // end_lfield
	void OnDoBreathAttack() { AbominationBone_OnDoBreathAttack(); } // do_breath_attack
	void OnBreathAttackLoop() { AbominationBone_OnBreathAttackLoop(); } // breath_attack_loop
	void OnBreathAffectTargets() { AbominationBone_OnBreathAffectTargets(); } // breath_affect_targets
	void OnEndBreathAttack() { AbominationBone_OnEndBreathAttack(); } // end_breath_attack
	void OnFrameAttackShort() { AbominationBone_OnFrameAttackShort(); } // frame_attack_short
	void OnFrameAttackLong() { AbominationBone_OnFrameAttackLong(); } // frame_attack_long
	void OnFrameRun() { AbominationBone_OnFrameRun(); } // frame_run
	void OnFrameJumpLand() { AbominationBone_OnFrameJumpLand(); } // frame_jump_land
	void OnStunTargets() { AbominationBone_OnStunTargets(); } // stun_targets
	void OnSetHunderswampNorthSpec() { AbominationBone_OnSetHunderswampNorthSpec(); } // set_hunderswamp_north_spec

	// This file's events and timers by their .script names
	bool AbominationBone_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "breath_affect_targets") { OnBreathAffectTargets(); return true; }
		if (name == "breath_attack_loop") { OnBreathAttackLoop(); return true; }
		if (name == "cycle_down") { OnCycleDown(); return true; }
		if (name == "cycle_up") { OnCycleUp(Param(params, 0)); return true; }
		if (name == "do_breath_attack") { OnDoBreathAttack(); return true; }
		if (name == "do_lfield") { OnDoLfield(); return true; }
		if (name == "end_breath_attack") { OnEndBreathAttack(); return true; }
		if (name == "end_lfield") { OnEndLfield(); return true; }
		if (name == "final_adj") { OnFinalAdj(); return true; }
		if (name == "frame_attack_long") { OnFrameAttackLong(); return true; }
		if (name == "frame_attack_short") { OnFrameAttackShort(); return true; }
		if (name == "frame_jump_land") { OnFrameJumpLand(); return true; }
		if (name == "frame_run") { OnFrameRun(); return true; }
		if (name == "game_death") { OnGameDeath(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_dodamage") { Return(OnGameDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5))); return true; }
		if (name == "game_struck") { OnGameStruck(Float(Param(params, 0)), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "jump_boost") { OnJumpBoost(); return true; }
		if (name == "my_target_died") { OnMyTargetDied(Param(params, 0)); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "npcatk_hunt") { OnNpcatkHunt(); return true; }
		if (name == "set_hunderswamp_north_spec") { OnSetHunderswampNorthSpec(); return true; }
		if (name == "stun_targets") { OnStunTargets(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "monsters/abomination_bone"]
shared class AbominationBoneScript : BaseMonsterNewScript, AbominationBone, BaseLightningShield
{
	// Variables every script that includes this file declares
	string FLING_IDX = "FLING_IDX";
	bool INTRO_DONE = false;
	bool START_SUSPEND = false;

	// Variables declared by included files, with the value they start with in this script
	AbominationBoneScript()
	{
		ANIM_WALK = "crawl";
		ANIM_RUN = "run";
		ANIM_IDLE = "idle1";
		IMMUNE_VAMPIRE = true;
		SOUND_DEATH = "monsters/abombination/die.wav";
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/abomination.mdl");
		Precache("ambience/steamjet1.wav");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		AbominationBone_FirstThink();
		AbominationBone_FirstThink2();
		BaseNpc_FirstThink();
		MonstersExternals_FirstThink();
		BaseNpcAttackNew_FirstThink();
		BaseMonsterShared_FirstThink();
		BaseLightningShield_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return AbominationBone_DispatchEvent(name, params)
			|| BaseLightningShield_DispatchEvent(name, params)
			|| BaseMonsterNewScript::DispatchEvent(name, params);
	}
}
