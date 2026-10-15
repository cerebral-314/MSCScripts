#pragma context server

// Converted from monsters/ogre_cave.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_monster_new.as"

[script "monsters/ogre_cave"]
class OgreCave : BaseMonsterNewScript
{
	// Constants
	string ANIM_SEARCH = "idle_look";
	string ANIM_SWIPE = "attack1";
	string ANIM_HEADBUTT = "attack2";
	string ANIM_JUMP = "jump";
	string ANIM_LEAP = "jump";
	string ANIM_WARCRY = "warcry";
	string ANIM_BEAM = "beam";
	float ORC_HOP_DELAY = 1.0f;
	int ORC_JUMP_THRESH = 80;
	string SOUND_IDLE1 = "bullchicken/bc_idle1.wav";
	string SOUND_IDLE2 = "bullchicken/bc_idle2.wav";
	string SOUND_IDLE3 = "bullchicken/bc_idle3.wav";
	string SOUND_IDLE4 = "bullchicken/bc_idle4.wav";
	string SOUND_IDLE5 = "bullchicken/bc_idle5.wav";
	string SOUND_HEADBUTT = "bullchicken/bc_spithit1.wav";
	string SOUND_SWIPEHIT1 = "zombie/claw_strike1.wav";
	string SOUND_SWIPEHIT2 = "zombie/claw_strike2.wav";
	string SOUND_SWIPEMISS1 = "zombie/claw_miss1.wav";
	string SOUND_SWIPEMISS2 = "zombie/claw_miss2.wav";
	string SOUND_STRUCK1 = "debris/flesh1.wav";
	string SOUND_STRUCK2 = "debris/flesh2.wav";
	string SOUND_STEP1 = "player/pl_snow1.wav";
	string SOUND_STEP2 = "player/pl_snow2.wav";
	string SOUND_PAIN_WEAK = "bullchicken/bc_pain2.wav";
	string SOUND_PAIN_STRONG = "bullchicken/bc_pain1.wav";
	string SOUND_WARCRY = "bullchicken/bc_attackgrowl3.wav";
	string SOUND_LEAP = "bullchicken/bc_attackgrowl2.wav";
	string SOUND_LEAP_LAND = "weapons/g_bounce2.wav";
	string SOUND_FLINCH = "bullchicken/bc_pain3.wav";
	string SWIPE_DAMAGE = "$rand(50,75)";
	string HEADBUTT_CHANCE = "100%";
	float HEADBUTT_FREQ = 7.0f;
	string HEADBUTT_DAMAGE = "$rand(50,75)";
	string LEAP_DAMAGE = "$rand(10,30)";
	string LEAP_STUNCHANCE = "30%";
	int LEAP_RANGE_TOOFAR = 512;
	int LEAP_RANGE_TOOCLOSE = 128;
	float FREQ_LEAP_AWAY = 0.0f;
	float NEXT_LEAP_AWAY = 1800.0f;
	string ATTACK_HITCHANCE = "95%";

	// Variables (an unset .script variable reads as its own name)
	string ANIM_WALK_DEFAULT = "walk";
	string ANIM_RUN_DEFAULT = "run1";
	string ANIM_FLINCH = "ANIM_FLINCH";
	string ANIM_ATTACK = "ANIM_ATTACK";
	float LEAP_AWAY_INTERVAL = 0.0f;
	int DROP_GOLD_MIN = 0;
	int DROP_GOLD_MAX = 0;
	string FLINCH_CHANCE = "FLINCH_CHANCE";
	float RUN_STEP = 0.0f;
	float WEAK_THRESHOLD = 0.0f;
	float DMG_LEAP_THRESH = 0.0f;
	bool DID_WARCRY = false;
	bool LEAP_ENABLED = false;
	bool HEADBUTT_DELAY = false;
	bool SWIPE_ATTACK = false;
	bool HEADBUTT_ON = false;
	float NEXT_DMG_LEAP_AWAY = 0.0f;
	bool ORC_JUMPING = false;

	// Variables declared by included files, with the value they start with in this script
	OgreCave()
	{
		ANIM_IDLE = "idle1";
		SOUND_DEATH = "bullchicken/bc_die1.wav";
		FLINCH_HEALTH = 1500.0f;
	}

	// unnamed block (first think)
	void OgreCave_FirstThink()
	{
		ANIM_IDLE = "idle1";
		ANIM_WALK_DEFAULT = "walk";
		ANIM_RUN_DEFAULT = "run1";
		ANIM_DEATH = "dieforward";
		ANIM_FLINCH = "bigflinch";

		ANIM_WALK = ANIM_WALK_DEFAULT;
		ANIM_RUN = ANIM_RUN_DEFAULT;
		ANIM_ATTACK = ANIM_SWIPE;
	}

	// unnamed block (first think)
	void OgreCave_FirstThink2()
	{
		if (ToLowerCase(MapName()) == "underpath")
		{
			NPC_GIVE_EXP = 2000.0f; // 300
		}
		else
		{
			NPC_GIVE_EXP = 300.0f;
		}
		LEAP_AWAY_INTERVAL = 500.0f; // leap away every time I loose this many HP (1/4th hp)

		DROP_GOLD = 1;
		DROP_GOLD_MIN = 30;
		DROP_GOLD_MAX = 50;

		CAN_FLINCH = "1";
		FLINCH_CHANCE = "20%";
		FLINCH_DELAY = "10.0";
		FLINCH_HEALTH = 1500.0f;
	}

	// my_target_died
	void OgreCave_OnMyTargetDied(string offender = "")
	{
		if (!CanSee("enemy"))
		{
			PlayAnim("critical", ANIM_WARCRY);
			PlaySound(0, 10, SOUND_WARCRY);
			DID_WARCRY = false;
			if (!LEAP_ENABLED)
				CallEventDelayed(1.0f, "enable_leap");
		}
	}

	// game_dodamage
	// 1: Attack Hit (1/0)  2: Entity Attack hit  3:  Start Position  4:  End Position
	string OgreCave_OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		bool exitSub = false;
		string result = "";

		if (HEADBUTT_ON)
		{
			if (hit)
			{
				PlaySound(0, 10, SOUND_HEADBUTT);
				ApplyEffect(NPCATK_TARGET, "effects/debuff_stun", 5, self);
			}
			if (!hit)
				PlayRandomSound(0, 10, SOUND_SWIPEMISS1, SOUND_SWIPEMISS2);
			ANIM_ATTACK = ANIM_SWIPE;
			exitSub = true;
		}
		HEADBUTT_ON = false;
		if (exitSub)
			return result;

		// assumes swipe
		if (!SWIPE_ATTACK)
			return result;
		SWIPE_ATTACK = false;
		if (hit)
		{
			PlayRandomSound(0, 10, SOUND_SWIPEHIT1, SOUND_SWIPEHIT2);
			AddVelocity(ENT_LASTSTRUCKBYME, RelativeVelocity(Vector3(-100, 130, 120)));
		}
		if (!hit)
			PlayRandomSound(0, 10, SOUND_SWIPEMISS1, SOUND_SWIPEMISS2);
		return result;
	}

	// my_target_died
	void OgreCave_OnMyTargetDied_2(string offender = "")
	{
		if (CanSee("enemy"))
			return;
		// stop jumping (saves CPU when monster idle)
		ORC_JUMPING = false;
	}

	// game_struck
	// PARAM1 = damage
	void OnGameStruck(float damage = 0.0f, string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		BaseNpc_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseNpcAttackNew_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc_attack_new
		BaseMonsterShared_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared

		if (MyHealth() > WEAK_THRESHOLD)
			PlayRandomSound(0, 10, SOUND_STRUCK1, SOUND_STRUCK2, SOUND_PAIN_STRONG);
		if (MyHealth() <= WEAK_THRESHOLD)
			PlayRandomSound(0, 10, SOUND_STRUCK1, SOUND_STRUCK2, SOUND_PAIN_WEAK);

		if (damage > DMG_LEAP_THRESH)
		{
			// dbg leaping away due to damage
			if (GameTime() > NEXT_DMG_LEAP_AWAY)
			{
				NEXT_DMG_LEAP_AWAY = GameTime() + FREQ_LEAP_AWAY;
				OnLeapAway();
			}
		}
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseNpcAttackNew_OnNpcSpawn(npc); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck

		SetName("Cave Ogre");
		SetHealth(1000);
		SetRace("orc");
		SetRoam(true);
		SetModel("monsters/ogre_cave.mdl");
		SetMoveAnim(ANIM_WALK);
		SetHeight(64);
		SetWidth(32);
		SetHearingSensitivity(2);
		SetBlood("green");
		SetIdleAnim(ANIM_IDLE);

		SetDamageTaken("poison", 1.5f);
		SetDamageTaken("acid", 1.5f);

		RUN_STEP = 0.0f;

		CallEventDelayed(1.0f, "idle_sounds");
		CallEventDelayed(2.0f, "final_postspawn");
	}

	// npcatk_hunt
	void OnNpcatkHunt()
	{
		BaseNpcAttackNew_OnNpcatkHunt(); // monsters/base_npc_attack_new
		BaseAntiStuck_OnNpcatkHunt(); // monsters/base_anti_stuck

		// regenerate
		if (MyHealth() < MyMaxHealth())
			GiveHealth(0.1f);

		if (NPCATK_TARGET == "unset")
			return;
		if (!(RangeTo(NPCATK_TARGET) <= LEAP_RANGE_TOOFAR))
			return;
		if (!(RangeTo(NPCATK_TARGET) > LEAP_RANGE_TOOCLOSE))
			return;
		if (!LEAP_ENABLED)
			return;

		LEAP_ENABLED = false;
		CallEventDelayed(5.0f, "enable_leap");
		OnScriptLeap(); // do not confused with model vent leap_attack
	}

	// npcatk_targetvalidate
	void OnNpcatkTargetvalidate(string target = "")
	{
		BaseNpcAttackNew_OnNpcatkTargetvalidate(target); // monsters/base_npc_attack_new

		// if spotted player, start jump checks
		if (ORC_JUMPING)
			return;
		if (!IsPlayer(NPCATK_TARGET))
			return;
		ORC_JUMPING = true;
		CallEventDelayed(1.0f, "orc_jump_check");
	}

	// my_target_died
	void OnMyTargetDied(string offender = "")
	{
		BaseNpcAttackNew_OnMyTargetDied(offender); // monsters/base_npc_attack_new
		OgreCave_OnMyTargetDied(offender);
		OgreCave_OnMyTargetDied_2(offender);
	}

	// game_dodamage
	string OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";
		result = AppendResult(result, BaseNpcAttackNew_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BaseAntiStuck_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BaseMonsterShared_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, OgreCave_OnGameDodamage(hit, target, start, end, damageType, damageText));
		return result;
	}

	// npc_selectattack
	void OnNpcSelectattack()
	{
		BaseAntiStuck_OnNpcSelectattack(); // monsters/base_anti_stuck
		BaseMonsterShared_OnNpcSelectattack(); // monsters/base_monster_shared

		if (HEADBUTT_DELAY)
		{
			ANIM_ATTACK = ANIM_SWIPE;
		}
		else if (RandomInt(1, 100) < Float(HEADBUTT_CHANCE))
		{
			ANIM_ATTACK = ANIM_HEADBUTT;
			HEADBUTT_DELAY = true;
			CallEventDelayed(HEADBUTT_FREQ, "headbutt_reset");
		}
	}

	// final_postspawn
	void OnFinalPostspawn()
	{
		WEAK_THRESHOLD = MaxHealthOf(ENT_ME) * 0.5f;

		DMG_LEAP_THRESH = MaxHealthOf(ENT_ME) * 0.1f;
	}

	// npcatk_validatetarget
	// first spot
	void OnNpcatkValidatetarget(string target = "")
	{
		if (!IsPlayer(target))
			return;
		if (DID_WARCRY)
			return;
		PlayAnim("critical", ANIM_WARCRY);
		PlaySound(0, 10, SOUND_WARCRY);
		DID_WARCRY = true;
	}

	// enable_leap
	void OnEnableLeap()
	{
		LEAP_ENABLED = true;
	}

	// script_leap
	void OnScriptLeap()
	{
		PlayAnim("critical", ANIM_LEAP);
		CallEventDelayed(0.1f, "leap_boost");
	}

	// leap_boost
	void OnLeapBoost()
	{
		if (I_R_FROZEN)
			return;
		AddVelocity(ENT_ME, RelativeVelocity(Vector3(0, 600, 100)));
	}

	// headbutt_reset
	void OnHeadbuttReset()
	{
		HEADBUTT_DELAY = false;
	}

	// attack1
	void OnAttack1()
	{
		SWIPE_ATTACK = true;
		OnNpcatkDodamage(NPCATK_TARGET, Text(ATTACK_HITRANGE), SWIPE_DAMAGE, ATTACK_HITCHANCE);
	}

	// attack2
	// headbut on frame 6 of attack2
	void OnAttack2()
	{
		PlayRandomSound(0, 10, SOUND_SWIPEMISS1, SOUND_SWIPEMISS2);
		OnNpcatkDodamage(NPCATK_TARGET, Text(ATTACK_HITRANGE), HEADBUTT_DAMAGE, ATTACK_HITCHANCE);
		HEADBUTT_ON = true;
	}

	// leap_away
	void OnLeapAway(string target = "")
	{
		PlayAnim("critical", ANIM_LEAP);
		SetMoveDest(NPCATK_TARGET, 99999, "flee");
		CallEventDelayed(0.1f, "leap_boost");
		OnNpcatkSuspendAi("3.0");
	}

	// leap_attack
	// called from ANIM_LEAP at frame 28
	void OnLeapAttack()
	{
		PlaySound(0, 10, SOUND_LEAP);

		if (Truthy(LegacyFunction("cansee", "enemy", 128)))
		{
			OnNpcatkDodamage(EntityId(EntityOf(ENT_LASTSEEN)), Text(ATTACK_HITRANGE), LEAP_DAMAGE, ATTACK_HITCHANCE);
			if (RandomInt(1, 100) < Float(LEAP_STUNCHANCE))
				ApplyEffect(EntityOf(ENT_LASTSEEN), "effects/debuff_stun", 5, self);
		}
	}

	// leap_done
	void OnLeapDone()
	{
		PlaySound(0, 10, SOUND_LEAP_LAND);
		SetMoveAnim(ANIM_RUN);
	}

	// npc_flinch
	void OnNpcFlinch(float damage = 0.0f)
	{
		PlaySound(0, 10, SOUND_FLINCH);
	}

	// idle_sounds
	void OnIdleSounds()
	{
		if (!IsAlive(ENT_ME))
			return;
		CallEventDelayed(Random(3, 10), "idle_sounds");
		if (NPCATK_TARGET != "unset")
			return;
		PlayRandomSound(0, 10, SOUND_IDLE1, SOUND_IDLE2, SOUND_IDLE3, SOUND_IDLE4, SOUND_IDLE5);
	}

	// run_step1
	// called from model during ANIM_RUN
	void OnRunStep1()
	{
		PlaySound(0, 5, SOUND_STEP1);
	}

	// run_step2
	// called from model during ANIM_RUN
	void OnRunStep2()
	{
		PlaySound(0, 5, SOUND_STEP2);
	}

	// orc_jump_check
	void OnOrcJumpCheck()
	{
		if (!ORC_JUMPING)
			return;
		CallEventDelayed(ORC_HOP_DELAY, "orc_jump_check");

		if (IS_FLEEING)
			return;
		if (NPCATK_TARGET == "unset")
			return;
		if (!CanSee(NPCATK_TARGET))
			return;

		// jump at player if he's higher than I am
		Vector3 mePos = MyOrigin();
		float myZ = mePos.z;
		Vector3 targetPos = OriginOf(NPCATK_TARGET);
		float targetZ = targetPos.z;
		float targetZDifference = targetZ - myZ;

		if (targetZDifference > ORC_JUMP_THRESH)
			OnOrcHop();
	}

	// orc_hop
	void OnOrcHop()
	{
		NPC_FORCED_MOVEDEST = true;
		SetMoveDest(NPCATK_TARGET, 1);
		PlayAnim("critical", ANIM_LEAP);
		PlaySound(0, 10, SOUND_LEAP);
		int jumpHeight = RandomInt(550, 650);
		AddVelocity(ENT_ME, RelativeVelocity(Vector3(0, 250, jumpHeight)));
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files
	void OnHeadbuttFreq() {} // HEADBUTT_FREQ
	void OnOrcHopDelay() {} // ORC_HOP_DELAY

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/ogre_cave.mdl");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		OgreCave_FirstThink();
		OgreCave_FirstThink2();
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
		if (name == "attack1") { OnAttack1(); return true; }
		if (name == "attack2") { OnAttack2(); return true; }
		if (name == "enable_leap") { OnEnableLeap(); return true; }
		if (name == "final_postspawn") { OnFinalPostspawn(); return true; }
		if (name == "game_dodamage") { Return(OnGameDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5))); return true; }
		if (name == "game_struck") { OnGameStruck(Float(Param(params, 0)), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "headbutt_reset") { OnHeadbuttReset(); return true; }
		if (name == "idle_sounds") { OnIdleSounds(); return true; }
		if (name == "leap_attack") { OnLeapAttack(); return true; }
		if (name == "leap_away") { OnLeapAway(Param(params, 0)); return true; }
		if (name == "leap_boost") { OnLeapBoost(); return true; }
		if (name == "leap_done") { OnLeapDone(); return true; }
		if (name == "my_target_died") { OnMyTargetDied(Param(params, 0)); return true; }
		if (name == "npc_flinch") { OnNpcFlinch(Float(Param(params, 0))); return true; }
		if (name == "npc_selectattack") { OnNpcSelectattack(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "npcatk_hunt") { OnNpcatkHunt(); return true; }
		if (name == "npcatk_targetvalidate") { OnNpcatkTargetvalidate(Param(params, 0)); return true; }
		if (name == "npcatk_validatetarget") { OnNpcatkValidatetarget(Param(params, 0)); return true; }
		if (name == "orc_hop") { OnOrcHop(); return true; }
		if (name == "orc_jump_check") { OnOrcJumpCheck(); return true; }
		if (name == "run_step1") { OnRunStep1(); return true; }
		if (name == "run_step2") { OnRunStep2(); return true; }
		if (name == "script_leap") { OnScriptLeap(); return true; }
		return BaseMonsterNewScript::DispatchEvent(name, params);
	}
}
