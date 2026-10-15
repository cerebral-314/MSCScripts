#pragma context server

// Converted from monsters/zombie_zygol.script by msc_transpiler.
// This is an older script and may have some bad conventions as a result.
// Zombie boss with a twist
// . tele -3000 2300 -256

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_monster_new.as"

[script "monsters/zombie_zygol"]
class ZombieZygol : BaseMonsterNewScript
{
	// Constants
	float FREQ_TBEAM = 30.0f;
	float BEAM_DUR = 15.0f;
	int EYE_HP = 1000;
	int EYE_POWER = 50;
	string ANIM_SWIPE = "attack1";
	string ANIM_DISEASE = "attack2";
	string SOUND_IDLE1 = "garg/gar_breathe1.wav";
	string SOUND_IDLE2 = "garg/gar_breathe2.wav";
	string SOUND_IDLE3 = "garg/gar_breathe3.wav";
	string SOUND_IDLE4 = "garg/gar_idle4.wav";
	string SOUND_PAIN1 = "garg/gar_idle1.wav";
	string SOUND_PAIN2 = "garg/gar_idle2.wav";
	string SOUND_PAIN3 = "garg/gar_idle3.wav";
	string SOUND_STRUCK1 = "weapons/cbar_hitbod1.wav";
	string SOUND_STRUCK2 = "weapons/cbar_hitbod2.wav";
	string SOUND_STRUCK3 = "weapons/cbar_hitbod3.wav";
	string SOUND_WARCRY1 = "garg/gar_alert1.wav";
	string SOUND_WARCRY2 = "garg/gar_alert2.wav";
	string SOUND_WARCRY3 = "garg/gar_alert3.wav";
	string SOUND_RAGE1 = "garg/gar_attack1.wav";
	string SOUND_RAGE2 = "garg/gar_attack2.wav";
	string SOUND_MISS1 = "zombie/claw_miss1.wav";
	string SOUND_MISS2 = "zombie/claw_miss2.wav";
	string SOUND_HIT1 = "zombie/claw_strike1.wav";
	string SOUND_HIT2 = "zombie/claw_strike2.wav";
	string ATTACK_DAMAGE = "ATTACK_DAMAGE";
	string ATTACK_HITCHANCE = "80";
	float DISEASE_FREQ = 5.0f;
	float DISEASE_DMG = 0.0f;
	int DISEASE_DUR = 0;
	string MONSTER_MODEL = "monsters/zombie_huge.mdl";
	bool ME_NO_WANDER = true;

	// Variables (an unset .script variable reads as its own name)
	string ANIM_ATTACK = "ANIM_ATTACK";
	string ANIM_DEATH1 = "ANIM_DEATH1";
	string ANIM_DEATH2 = "ANIM_DEATH2";
	string ANIM_DEATH3 = "ANIM_DEATH3";
	string ANIM_DEATH4 = "ANIM_DEATH4";
	string ANIM_DEATH5 = "ANIM_DEATH5";
	string FLINCH_CHANCE = "FLINCH_CHANCE";
	float BASE_MOVERATE = 0.0f;
	float N_EYES = 0.0f;
	bool PAIN_DELAY = false;
	bool I_ATTACKING = false;
	bool I_DISEASE = false;
	bool DID_WARCRY = false;
	bool DISEASE_DELAY = false;
	bool TBEAM_DELAY = false;
	CBaseEntity@ TBEAM_TARG = null;
	bool TBEAM_ON = false;
	bool TBEAM_VIS = false;
	float TBEAM_LASTFX = 0.0f;
	string TBEAM_IDX = "TBEAM_IDX";

	// Variables declared by included files, with the value they start with in this script
	ZombieZygol()
	{
		ANIM_WALK = "walk";
		ANIM_RUN = "walk";
		ANIM_IDLE = "idle1";
		SOUND_DEATH = "garg/gar_die1.wav";
	}

	// unnamed block (first think)
	void ZombieZygol_FirstThink()
	{
		if (ToLowerCase(MapName()) == "lostcaverns")
			NPC_IS_BOSS = true;

		ANIM_WALK = "walk";
		ANIM_RUN = "walk";
		ANIM_ATTACK = ANIM_SWIPE;
		ANIM_DEATH = "diesimple";
		ANIM_IDLE = "idle1";
		ANIM_DEATH1 = "diesimple";
		ANIM_DEATH2 = "diebackward";
		ANIM_DEATH3 = "dieheadshot";
		ANIM_DEATH4 = "dieheadshot2";
		ANIM_DEATH5 = "dieforward";
		ANIM_DEATH = ANIM_DEATH1;

		CAN_FLINCH = "1";
		FLINCH_CHANCE = "30";
		ATTACK_RANGE = 120.0f;
		ATTACK_HITRANGE = 150.0f;
		ATTACK_MOVERANGE = 80.0f;

		NPC_GIVE_EXP = 1000.0f;

		HEAR_RANGE_MAX = "200";
		HEAR_RANGE_PLAYER = "200";
	}

	// game_dodamage
	// 1:AttackHit(1/0)  2:EntityHit  3:StartOrigin  4:EndOrigin
	string ZombieZygol_OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";

		if (!I_ATTACKING)
			return result;
		I_ATTACKING = false;
		if (hit)
			PlayRandomSound(0, 10, SOUND_HIT1, SOUND_HIT2);
		if (!hit)
			PlayRandomSound(0, 10, SOUND_MISS1, SOUND_MISS2);

		if (!I_DISEASE)
			return result;
		I_DISEASE = false;
		if (!hit)
			return result;
		ApplyEffect(target, "effects/dot_poison", DISEASE_DUR, self, DISEASE_DMG, "none");
		return result;
	}

	// game_death
	void OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		DqMonsterExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // dq/externals/dq_monster_externals
		MonstersExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/externals
		BaseSelfAdjust_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_self_adjust
		BaseNpc_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseMonsterShared_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared
		ClientEvent("update", "all", TBEAM_IDX, "effect_die");
		CallExternal("all", "zygoli_died");
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
		ClientEvent("new", "all", "effects/dynamic_beam_cl", IndexOf(ENT_ME), Vector3(255, 0, 0), 100);
		TBEAM_IDX = LastClientScriptId();
	}

	// game_struck
	void OnGameStruck(float damage = 0.0f, string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		BaseNpc_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseNpcAttackNew_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc_attack_new
		BaseMonsterShared_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared
		PlayRandomSound(0, 10, SOUND_STRUCK1, SOUND_STRUCK2, SOUND_STRUCK3);
		if (!PAIN_DELAY)
			CallEventDelayed(0.1f, "pain_sound");
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseNpcAttackNew_OnNpcSpawn(npc); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck

		SetName("Zygoli, The All Seeing");

		SetModel(MONSTER_MODEL);
		SetHealth(6000);
		SetWidth(50);
		SetHeight(110);
		SetIdleAnim(ANIM_IDLE);
		SetMoveAnim(ANIM_WALK);
		PlayAnim("once", ANIM_IDLE); // stop the shakes
		SetRace("undead");
		SetHearingSensitivity(3);

		SetRoam(true);

		SetDamageTaken("holy", 1);
		SetDamageTaken("poison", 0);
		SetDamageTaken("fire", 2);
		SetDamageTaken("cold", 0.25f);
		SetDamageTaken("pierce", 0.5f);
		SetDamageTaken("blunt", 1);
		SetDamageTaken("slash", 1);

		BASE_MOVERATE = 1.5f;
		BASE_FRAMERATE = "1.5";
		SetMoveSpeed(1.5f);
		SetAnimMoveSpeed(1.5f);
		SetAnimFrameRate(1.5f);

		CallEventDelayed(1.0f, "idle_sounds");
		CallEventDelayed(0.1f, "setup_eyes");
	}

	// npcatk_targetvalidate
	void OnNpcatkTargetvalidate(string target = "")
	{
		BaseNpcAttackNew_OnNpcatkTargetvalidate(target); // monsters/base_npc_attack_new

		if (DID_WARCRY)
			return;
		DID_WARCRY = true;
		DISEASE_DELAY = true;
		CallEventDelayed(DISEASE_FREQ, "reset_disease_delay");
		PlayRandomSound(0, 10, SOUND_WARCRY1, SOUND_WARCRY2, SOUND_WARCRY3);
		CallEventDelayed(FREQ_TBEAM, "do_tbeam");
	}

	// game_dodamage
	string OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";
		result = AppendResult(result, BaseNpcAttackNew_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BaseAntiStuck_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BaseMonsterShared_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, ZombieZygol_OnGameDodamage(hit, target, start, end, damageType, damageText));
		return result;
	}

	// npc_selectattack
	void OnNpcSelectattack()
	{
		BaseAntiStuck_OnNpcSelectattack(); // monsters/base_anti_stuck
		BaseMonsterShared_OnNpcSelectattack(); // monsters/base_monster_shared

		// //dbg temp selecting attack ( del DISEASE_DELAY vs DISEASE_FREQ )
		if (DISEASE_DELAY)
			return;
		DISEASE_DELAY = true;
		CallEventDelayed(DISEASE_FREQ, "reset_disease_delay");
		ANIM_ATTACK = ANIM_DISEASE;
	}

	// setup_eyes
	void OnSetupEyes()
	{
		N_EYES = 4.0f;
		OnUpdateEyes();

		Vector3 eyePos = OriginOf(ENT_ME) + RelativePosition(Vector3(0, 0, 0), Vector3(0, 64, 100));
		CreateNpc("monsters/summon/zy_eye", eyePos, self, EYE_HP, EYE_POWER);
		CallEventDelayed(0.1f, "setup_eye2");
	}

	// setup_eye2
	void OnSetupEye2()
	{
		Vector3 eyePos = OriginOf(ENT_ME) + RelativePosition(Vector3(0, 90, 0), Vector3(0, 64, 100));
		CreateNpc("monsters/summon/zy_eye", eyePos, self, EYE_HP, EYE_POWER);
		CallEventDelayed(0.1f, "setup_eye3");
	}

	// setup_eye3
	void OnSetupEye3()
	{
		Vector3 eyePos = OriginOf(ENT_ME) + RelativePosition(Vector3(0, 180, 0), Vector3(0, 64, 100));
		CreateNpc("monsters/summon/zy_eye", eyePos, self, EYE_HP, EYE_POWER);
		CallEventDelayed(0.1f, "setup_eye4");
	}

	// setup_eye4
	void OnSetupEye4()
	{
		Vector3 eyePos = OriginOf(ENT_ME) + RelativePosition(Vector3(0, 270, 0), Vector3(0, 64, 100));
		CreateNpc("monsters/summon/zy_eye", eyePos, self, EYE_HP, EYE_POWER);
	}

	// respawn_eye
	void OnRespawnEye()
	{
		InfoMessage("all", "ZYGOLI THE ALL SEEING", "Has summoned a new eye.");
		N_EYES += 1.0f;
		CreateNpc("monsters/summon/zy_eye", RelativePosition(Vector3(0, 0, 150)), self, EYE_HP, EYE_POWER);
		CallEventDelayed(0.1f, "update_eyes");
	}

	// ext_eye_died
	void OnExtEyeDied()
	{
		N_EYES -= 1.0f;
		OnNpcFlinch();
		Effect("glow", ENT_ME, Vector3(255, 255, 255), 200, 1.0f, 1.0f);
		CallEventDelayed(0.1f, "update_eyes");
		CallEventDelayed(120.0f, "respawn_eye");
	}

	// update_eyes
	void OnUpdateEyes()
	{
		if (N_EYES == 0.0f)
			SetDamageTaken("all", 1);
		if (N_EYES == 1.0f)
			SetDamageTaken("all", 0.5f);
		if (N_EYES == 2.0f)
			SetDamageTaken("all", 0.3f);
		if (N_EYES == 3.0f)
			SetDamageTaken("all", 0.1f);
		if (N_EYES < 4.0f)
			SetInvincible(false);
		if (N_EYES == 4.0f)
		{
			SetDamageTaken("all", 0);
			SetInvincible(true);
		}
	}

	// idle_sounds
	void OnIdleSounds()
	{
		if (NPCATK_TARGET == "unset")
			PlayRandomSound(0, 10, SOUND_IDLE1, SOUND_IDLE2, SOUND_IDLE3, SOUND_IDLE4);

		if (NPCATK_TARGET != "unset")
			PlayRandomSound(0, 5, SOUND_RAGE1, SOUND_RAGE2);

		float nextSound = Random(4, 15);

		CallEventDelayed(nextSound, "idle_sounds");
	}

	// walk_step1
	void OnWalkStep1()
	{
		PlaySound(0, 10, "garg/gar_step1.wav");
	}

	// walk_step2
	void OnWalkStep2()
	{
		PlaySound(0, 10, "garg/gar_step2.wav");
	}

	// walk_step3
	void OnWalkStep3()
	{
		PlaySound(0, 10, "garg/gar_step1.wav");
	}

	// walk_step4
	void OnWalkStep4()
	{
		PlaySound(0, 10, "garg/gar_step2.wav");
	}

	// walk_step5
	void OnWalkStep5()
	{
		PlaySound(0, 10, "garg/gar_step1.wav");
	}

	// walk_step6
	void OnWalkStep6()
	{
		PlaySound(0, 10, "garg/gar_step2.wav");
	}

	// npc_death
	void OnNpcDeath()
	{
		int pickDeath = RandomInt(1, 5);

		if (pickDeath == 1)
			ANIM_DEATH = ANIM_DEATH1;
		if (pickDeath == 2)
			ANIM_DEATH = ANIM_DEATH2;
		if (pickDeath == 3)
			ANIM_DEATH = ANIM_DEATH3;
		if (pickDeath == 4)
			ANIM_DEATH = ANIM_DEATH4;
		if (pickDeath == 5)
			ANIM_DEATH = ANIM_DEATH5;
	}

	// pain_sound
	void OnPainSound()
	{
		string randf510;

		PAIN_DELAY = true;
		randf510 = "NEXT_PAIN";
		PlayRandomSound(0, 10, SOUND_PAIN1, SOUND_PAIN2, SOUND_PAIN3);
		OnNextPain();
	}

	// pain_delay_reset
	void OnPainDelayReset()
	{
		PAIN_DELAY = false;
	}

	// npc_flinch
	void OnNpcFlinch(float damage = 0.0f)
	{
		int rFlinch = RandomInt(1, 4);
		if (rFlinch == 1)
			FLINCH_ANIM = "flinchsmall";
		if (rFlinch == 2)
			FLINCH_ANIM = "flinch";
		if (rFlinch == 3)
			FLINCH_ANIM = "bigflinch";
		if (rFlinch == 4)
			FLINCH_ANIM = "llflinch";
		PlayRandomSound(0, 10, SOUND_PAIN1, SOUND_PAIN2, SOUND_PAIN3);
	}

	// attack_1
	void OnAttack12()
	{
		// //dbg temp using swipe ANIM_ATTACK
		I_ATTACKING = true;
		float fAttackDamage = Float(ATTACK_DAMAGE);
		fAttackDamage *= N_EYES;
		OnNpcatkDodamage(NPCATK_TARGET, Text(ATTACK_HITRANGE), Text(fAttackDamage), ATTACK_HITCHANCE, "blunt");
	}

	// attack_2
	void OnAttack22()
	{
		// //dbg temp using disease ANIM_ATTACK
		I_ATTACKING = true;
		float fAttackDamage = Float(ATTACK_DAMAGE);
		fAttackDamage *= N_EYES;
		OnNpcatkDodamage(NPCATK_TARGET, Text(ATTACK_HITRANGE), Text(fAttackDamage), ATTACK_HITCHANCE, "blunt");
		I_DISEASE = true;
		ANIM_ATTACK = ANIM_SWIPE;
	}

	// reset_tbeam_delay
	void OnResetTbeamDelay()
	{
		TBEAM_DELAY = false;
	}

	// do_tbeam
	void OnDoTbeam()
	{
		CallEventDelayed(FREQ_TBEAM, "do_tbeam");

		if (!CanSee("enemy"))
			return;
		@TBEAM_TARG = EntityOf(ENT_LASTSEEN);
		TBEAM_ON = true;
		TBEAM_VIS = false;
		OnTbeamLoop();
		CallEventDelayed(BEAM_DUR, "end_tbeam");
	}

	// end_tbeam
	void OnEndTbeam()
	{
		ClientEvent("update", "all", TBEAM_IDX, "dbeam_off");
		TBEAM_ON = false;
		TBEAM_VIS = false;
	}

	// tbeam_loop
	void OnTbeamLoop()
	{
		if (!TBEAM_ON)
			return;
		CallEventDelayed(0.2f, "tbeam_loop");

		bool canSeeBtarg = CanSee(EntityId(TBEAM_TARG));

		if (canSeeBtarg)
		{
			AddVelocity(TBEAM_TARG, RelativeVelocity(Vector3(10, -300, 10)));

			if (RangeTo(TBEAM_TARG) > ATTACK_RANGE)
			{
				NPC_FORCED_MOVEDEST = true;
				SetMoveDest(@TBEAM_TARG, 100);
			}

			if (!TBEAM_VIS)
			{
				TBEAM_VIS = true;
				ClientEvent("update", "all", TBEAM_IDX, "dbeam_target", IndexOf(TBEAM_TARG));
			}

			// fx re-establish every 5 secs
			float diffTime = GameTime() - TBEAM_LASTFX;

			if (diffTime > 5.0f)
			{
				TBEAM_LASTFX = GameTime();
				DoDamage(TBEAM_TARG, "direct", 10.0f, "100%", ENT_ME, "magic");

				PlaySound(0, 5, "magic/pulsemachine_noloop.wav");
			}
		}

		// effect beam ents lgtning.spr 90 TBEAM_TARG 0 (255,0,0) 200 0 5
		// local BEAM_START game.monster.origin
		// vectoradd BEAM_START z 100
		// effect beam end lgtning.spr 120 BEAM_START TBEAM_TARG 0 (255,0,0) 200 5 5
		// effect screenfade TBEAM_TARG 4 1 (255,0,0) 128
		if (!canSeeBtarg)
		{
			TBEAM_VIS = false;
			ClientEvent("update", "all", TBEAM_IDX, "dbeam_off");
		}
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files
	void OnBeamDur() {} // BEAM_DUR
	void OnDiseaseFreq() {} // DISEASE_FREQ
	void OnFreqTbeam() {} // FREQ_TBEAM
	void OnNextPain() {} // NEXT_PAIN
	void OnNextSound() {} // NEXT_SOUND

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/zombie_huge.mdl");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		ZombieZygol_FirstThink();
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
		if (name == "attack_1") { OnAttack12(); return true; }
		if (name == "attack_2") { OnAttack22(); return true; }
		if (name == "do_tbeam") { OnDoTbeam(); return true; }
		if (name == "end_tbeam") { OnEndTbeam(); return true; }
		if (name == "ext_eye_died") { OnExtEyeDied(); return true; }
		if (name == "game_death") { OnGameDeath(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_dodamage") { Return(OnGameDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5))); return true; }
		if (name == "game_struck") { OnGameStruck(Float(Param(params, 0)), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "idle_sounds") { OnIdleSounds(); return true; }
		if (name == "npc_death") { OnNpcDeath(); return true; }
		if (name == "npc_flinch") { OnNpcFlinch(Float(Param(params, 0))); return true; }
		if (name == "npc_post_spawn") { OnNpcPostSpawn(); return true; }
		if (name == "npc_selectattack") { OnNpcSelectattack(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "npcatk_targetvalidate") { OnNpcatkTargetvalidate(Param(params, 0)); return true; }
		if (name == "pain_delay_reset") { OnPainDelayReset(); return true; }
		if (name == "pain_sound") { OnPainSound(); return true; }
		if (name == "reset_tbeam_delay") { OnResetTbeamDelay(); return true; }
		if (name == "respawn_eye") { OnRespawnEye(); return true; }
		if (name == "setup_eye2") { OnSetupEye2(); return true; }
		if (name == "setup_eye3") { OnSetupEye3(); return true; }
		if (name == "setup_eye4") { OnSetupEye4(); return true; }
		if (name == "setup_eyes") { OnSetupEyes(); return true; }
		if (name == "tbeam_loop") { OnTbeamLoop(); return true; }
		if (name == "update_eyes") { OnUpdateEyes(); return true; }
		if (name == "walk_step1") { OnWalkStep1(); return true; }
		if (name == "walk_step2") { OnWalkStep2(); return true; }
		if (name == "walk_step3") { OnWalkStep3(); return true; }
		if (name == "walk_step4") { OnWalkStep4(); return true; }
		if (name == "walk_step5") { OnWalkStep5(); return true; }
		if (name == "walk_step6") { OnWalkStep6(); return true; }
		return BaseMonsterNewScript::DispatchEvent(name, params);
	}
}
