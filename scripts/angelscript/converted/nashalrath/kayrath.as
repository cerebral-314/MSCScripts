#pragma context server

// Converted from nashalrath/kayrath.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_monster_new.as"

[script "nashalrath/kayrath"]
class Kayrath : BaseMonsterNewScript
{
	// Constants
	string ANIM_SWING = "attack";
	string ANIM_SMASH = "smash";
	string ANIM_STOMP = "stomp";
	string ANIM_KICK = "kickcar";
	string ANIM_PIERCE = "bitehead";
	string ANIM_FIRE_PREP = "shootflames1";
	string ANIM_FIRE_HOLD = "shootflames2";
	string ANIM_RAWR = "idle2";
	string ANIM_SEARCH = "idle4";
	int MOVERANGE_NORMAL = 100;
	int SMASH_RANGE = 150;
	int SWING_RANGE = 200;
	int KICK_RANGE = 150;
	bool ATTACH_HORN = false;
	bool ATTACH_RIGHT = true;
	int ATTACH_LEFT = 2;
	int DMG_SWING = 200;
	string DMG_SMASH = "400";
	int DMG_STOMP = 400;
	float DOT_FIRE = 150.0f;
	float DOT_POISON = 75.0f;
	float FIRE_DURATION = 6.0f;
	string CUSTOM_FLINCH_CHANCE = "25%";
	float FREQ_STOMP = 0.0f;
	float FREQ_KICK = 0.0f;
	float FREQ_SMASH = 0.0f;
	float FREQ_FIRE = 0.0f;
	float FREQ_SEARCH = 20.0f;
	float FREQ_RANDRAWR = 0.0f;
	int BONEIDX_STOMPFOOT = 6;
	string SOUND_YAWN1 = "garg/gar_breathe1.wav";
	string SOUND_YAWN2 = "garg/gar_breathe2.wav";
	string SOUND_YAWN3 = "garg/gar_breathe3.wav";
	string SOUND_RAWR = "garg/gar_alert2.wav";
	string SOUND_RUNSTEP1 = "garg/gar_step1.wav";
	string SOUND_RUNSTEP2 = "garg/gar_step2.wav";
	string SOUND_WALKSTEP1 = "player/pl_grate1.wav";
	string SOUND_WALKSTEP2 = "player/pl_grate2.wav";
	string SOUND_SWING = "weapons/swinghuge.wav";
	string SOUND_KICK = "weapons/swinghuge.wav";
	string SOUND_STOMP = "magic/boom.wav";
	string SOUND_FIRE_PREP = "garg/gar_flameon1.wav";
	string SOUND_FIRE_LOOP = "garg/gar_flamerun1.wav";
	string SOUND_FIRE_END = "garg/gar_flameoff1.wav";
	string SOUND_RANDRAWR1 = "garg/gar_attack1.wav";
	string SOUND_RANDRAWR2 = "garg/gar_attack2.wav";
	string SOUND_RANDRAWR3 = "garg/gar_attack3.wav";
	string SOUND_STRUCK1 = "weapons/cbar_hitbod1.wav";
	string SOUND_STRUCK2 = "weapons/cbar_hitbod2.wav";
	string SOUND_STRUCK3 = "debris/bustflesh2.wav";
	string SOUND_PAIN1 = "garg/gar_pain1.wav";
	string SOUND_PAIN2 = "garg/gar_pain2.wav";
	string SOUND_PAIN3 = "garg/gar_pain3.wav";
	string SOUND_SEARCH = "garg/gar_alert1.wav";
	string FIRE_CLSCRIPT = "nashalrath/kayrath_cl";

	// Variables (an unset .script variable reads as its own name)
	string ANIM_ATTACK = "ANIM_ATTACK";
	string ANIM_FLINCH = "ANIM_FLINCH";
	bool IS_UNHOLY = true;
	float HALF_HEALTH = 0.0f;
	bool CYCLES_ON = false;
	float NEXT_KICK = 0.0f;
	float NEXT_SMASH = 0.0f;
	float NEXT_STOMP = 0.0f;
	string STUN_BURST_POS = "STUN_BURST_POS";
	int STUN_BURST_RAD = 0;
	bool STUN_BURST_REPEL = false;
	string STUN_BURST_DMG = "STUN_BURST_DMG";
	string STUN_LIST = "STUN_LIST";
	bool FIRE_PREPPING = false;
	bool FIRE_ON = false;
	int FIRE_TYPE = 0;
	int FIRE_ROTATE = 0;
	float FIRE_ROT = 0.0f;
	float NEXT_SCAN = 0.0f;
	string FIRE_TARGS = "FIRE_TARGS";
	float NEXT_SEARCH = 0.0f;

	// Variables declared by included files, with the value they start with in this script
	Kayrath()
	{
		ANIM_WALK = "walk";
		ANIM_IDLE = "idle3";
		SOUND_DEATH = "garg/gar_die1.wav";
	}

	// unnamed block (first think)
	void Kayrath_FirstThink()
	{
		ANIM_WALK = "walk"; // frame_walkstep1 frame_walkstep2
		ANIM_IDLE = "idle3";
		ANIM_RUN = "run"; // frame_runstep1 frame_runstep2
		ANIM_ATTACK = "attack"; // frame_swing
		ANIM_DEATH = "die";
		ANIM_FLINCH = "Flinchheavy";
	}

	// unnamed block (first think)
	void Kayrath_FirstThink2()
	{
		ATTACK_RANGE = 200.0f;
		ATTACK_MOVERANGE = 100.0f;
		ATTACK_HITRANGE = 250.0f;
		IS_UNHOLY = true;
		NPC_MUST_SEE_TARGET = "0";

		if (Contains(ToLowerCase(MapName()), "nashalrath"))
		{
			NPC_IS_BOSS = true;
			NPC_GIVE_EXP = 8000.0f;
		}
		else
		{
			NPC_GIVE_EXP = 1000.0f;
		}
	}

	// unnamed block (timer)
	void Kayrath_Timer()
	{
		CallEventDelayed(FREQ_RANDRAWR, "Kayrath_Timer");
		if (NPCATK_TARGET == "unset")
			return;
		if (FIRE_PREPPING)
			return;
		if (FIRE_ON)
			return;
		PlayRandomSound(0, 10, SOUND_RANDRAWR1, SOUND_RANDRAWR2, SOUND_RANDRAWR3);
	}

	// game_precache
	void OnGamePrecache()
	{
		PrecacheFile(FIRE_CLSCRIPT);
	}

	// game_struck
	// ================================== Struck
	void OnGameStruck(float damage = 0.0f, string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		BaseNpc_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseNpcAttackNew_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc_attack_new
		BaseMonsterShared_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared
		bool exitSub = false;

		if (damage > 250.0f)
		{
			PlayRandomSound(0, 10, SOUND_PAIN1, SOUND_PAIN2, SOUND_PAIN3);
			exitSub = true;
			if (!FIRE_PREPPING && !FIRE_ON && RandomInt(1, 100) <= Float(CUSTOM_FLINCH_CHANCE))
				PlayAnim("critical", ANIM_FLINCH);
		}
		if (exitSub)
			return;

		if (HealthOf(ENT_ME) > HALF_HEALTH)
			PlayRandomSound(0, 10, SOUND_STRUCK1, SOUND_STRUCK2, SOUND_STRUCK3, SOUND_STRUCK1, SOUND_STRUCK2, SOUND_STRUCK3);
		else
			PlayRandomSound(0, 10, SOUND_STRUCK1, SOUND_STRUCK2, SOUND_STRUCK3, SOUND_STRUCK1, SOUND_STRUCK2, SOUND_STRUCK3, SOUND_PAIN1, SOUND_PAIN2, SOUND_PAIN3);
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseNpcAttackNew_OnNpcSpawn(npc); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck
		SetName("Kay'rath");
		SetModel("monsters/kayrath.mdl");
		SetWidth(75);
		SetHeight(200);
		SetHealth(15000);
		SetDamageTaken("all", 0.5f);
		SetDamageTaken("cold", 0.5f);
		SetDamageTaken("holy", 1.25f);
		SetDamageTaken("stun", 0);
		SetRace("demon");
		SetRoam(false);
		SetHearingSensitivity(4);

		HALF_HEALTH = MaxHealthOf(ENT_ME) * 0.5f;

		OnNpcatkSuspendAi();
		AS_ATTACKING = GameTime() + 15.0f;

		CallEventDelayed(FREQ_FIRE, "do_fire");

		CallExternal(GetVar("GAME_MASTER"), "gm_fade_in", self, 5);
	}

	// npcatk_lost_sight
	void OnNpcatkLostSight()
	{
		BaseNpcAttackNew_OnNpcatkLostSight(); // monsters/base_npc_attack_new
		if (!(GameTime() > NEXT_SEARCH))
			return;
		PlaySound(0, 10, SOUND_SEARCH);
		PlayAnim("critical", ANIM_SEARCH);
		NEXT_SEARCH = GameTime() + FREQ_SEARCH;
	}

	// cycle_up
	void OnCycleUp(string reason = "")
	{
		BaseNpcAttackNew_OnCycleUp(reason); // monsters/base_npc_attack_new
		if (CYCLES_ON)
			return;
		CYCLES_ON = true;
		PlayAnim("critical", ANIM_RAWR);
		AS_ATTACKING = GameTime() + 15.0f;
		PlaySound(0, 10, SOUND_RAWR);

		float gameTime = GameTime();

		NEXT_KICK = gameTime + FREQ_KICK;

		NEXT_SMASH = gameTime + FREQ_SMASH;

		NEXT_STOMP = gameTime + FREQ_STOMP;
	}

	// fade_in_done
	// via game master
	void OnFadeInDone()
	{
		OnNpcatkResumeAi();
		SetRoam(true);
		SetProp(ENT_ME, "rendermode", 0);
		SetProp(ENT_ME, "renderamt", 255);
	}

	// frame_swing
	// ================================== Anim Events
	void OnFrameSwing()
	{
		bool exitSub = false;
		float newMoveRange = 0.0f;
		PlaySound(0, 10, SOUND_SWING);
		Vector3 locDmg = AttachmentPositionOf(ENT_ME, ATTACH_RIGHT);
		locDmg += RelativePosition(Vector3(0, Float(Eval("game.monster.angles.yaw")), 0), Vector3(0, 100, -32));
		DoDamageEx(locDmg, 200, DMG_SWING, 0, ENT_ME, ENT_ME, "none", "blunt");

		float gameTime = GameTime();

		if (gameTime > NEXT_STOMP)
		{
			ANIM_ATTACK = ANIM_STOMP;
			exitSub = true;
		}
		if (exitSub)
			return;

		if (gameTime > NEXT_SMASH)
		{
			ANIM_ATTACK = ANIM_SMASH;
			ATTACK_RANGE = SMASH_RANGE;
			newMoveRange = Divide(SMASH_RANGE, 2.0f);
			ATTACK_MOVERANGE = newMoveRange;
			exitSub = true;
		}
		if (exitSub)
			return;

		if (gameTime > NEXT_KICK)
		{
			ANIM_ATTACK = ANIM_KICK;
			ATTACK_RANGE = KICK_RANGE;
			newMoveRange = Divide(KICK_RANGE, 2.0f);
			ATTACK_MOVERANGE = newMoveRange;
		}
	}

	// frame_stomp
	void OnFrameStomp()
	{
		ANIM_ATTACK = ANIM_SWING;
		Vector3 burstPos = BonePositionOf(ENT_ME, BONEIDX_STOMPFOOT);
		float grndBurst = GroundHeight(burstPos);
		burstPos.z = grndBurst;
		OnStunburstGo(Text(burstPos), 256, 1, Text(DMG_STOMP));
		NEXT_STOMP = GameTime() + FREQ_STOMP;
	}

	// frame_smash
	void OnFrameSmash()
	{
		ANIM_ATTACK = ANIM_SWING;
		ATTACK_RANGE = SWING_RANGE;
		ATTACK_MOVERANGE = MOVERANGE_NORMAL;
		Vector3 burstPos = AttachmentPositionOf(ENT_ME, ATTACH_LEFT);
		float grndBurst = GroundHeight(burstPos);
		burstPos.z = grndBurst;
		OnStunburstGo(Text(burstPos), 128, 0, DMG_SMASH);
		NEXT_SMASH = GameTime() + FREQ_SMASH;
	}

	// frame_kick
	void OnFrameKick()
	{
		PlaySound(0, 10, SOUND_SWING);
		ANIM_ATTACK = ANIM_SWING;
		ATTACK_RANGE = SWING_RANGE;
		ATTACK_MOVERANGE = MOVERANGE_NORMAL;
		DoDamage(NPCATK_TARGET, KICK_RANGE, "DMG_KICK", "100%", "blunt");

		NEXT_KICK = GameTime() + FREQ_KICK;

		if (!(RangeTo(NPCATK_TARGET) < KICK_RANGE))
			return;
		ApplyEffect(NPCATK_TARGET, "effects/debuff_stun", 5.0f, self);
		AddVelocity(NPCATK_TARGET, RelativeVelocity(Vector3(0, 1000, 110)));
	}

	// frame_fire_prep_done
	void OnFrameFirePrepDone()
	{
		if (FIRE_ON)
			return;
		OnFireStart();
	}

	// frame_walkstep1
	void OnFrameWalkstep1()
	{
		PlaySound(0, 10, SOUND_WALKSTEP1);
	}

	// frame_walkstep2
	void OnFrameWalkstep2()
	{
		PlaySound(0, 10, SOUND_WALKSTEP2);
	}

	// frame_runstep1
	void OnFrameRunstep1()
	{
		PlaySound(0, 10, SOUND_RUNSTEP1);
	}

	// frame_runstep2
	void OnFrameRunstep2()
	{
		PlaySound(0, 10, SOUND_RUNSTEP2);
	}

	// stunburst_go
	// ================================== Stun Burst Handling
	// <pos> <radius> <repel:0|1> <dmg>
	void OnStunburstGo(string pos = "", int radius = 0, int repel = 0, string dmg = "")
	{
		STUN_BURST_POS = pos;
		STUN_BURST_RAD = radius;
		STUN_BURST_REPEL = repel != 0;
		STUN_BURST_DMG = dmg;
		DebugPrint("stunburst_go pos: " + STUN_BURST_POS + " rad: " + STUN_BURST_RAD + " repel: " + Text(STUN_BURST_REPEL) + " dmg: " + STUN_BURST_DMG);
		DoDamage(STUN_BURST_POS, STUN_BURST_RAD, STUN_BURST_DMG, "100%", 0, "reflective", "blunt");

		ClientEvent("new", "all", "effects/sfx_stun_burst", STUN_BURST_POS, STUN_BURST_RAD, 0, Vector3(0, 0, 0));
		CallEventDelayed(0.25f, "stun_targets");
	}

	// stun_targets
	void OnStunTargets()
	{
		STUN_LIST = LegacyFunction("get_tsphere", "enemy", STUN_BURST_RAD, STUN_BURST_POS);
		DebugPrint("stun_targets " + STUN_LIST);
		if (STUN_LIST == "none")
			return;
		if (!(GetTokenCount(STUN_LIST) > 0))
			return;
		int count = GetTokenCount(STUN_LIST);
		int outerIteration = loopIteration;
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnStunburstAffectTargets();
		}
		loopIteration = outerIteration;
	}

	// stunburst_affect_targets
	void OnStunburstAffectTargets()
	{
		CBaseEntity@ checkEnt = FindEntity(GetToken(STUN_LIST, loopIteration));
		if (!IsOnGround(checkEnt))
			return;
		ApplyEffect(checkEnt, "effects/debuff_stun", 5.0f, self);

		// if ( STUN_BURST_DMG > 0 ) dodamage CHECK_ENT direct STUN_BURST_DMG 100% ent_me magic
		if (!STUN_BURST_REPEL)
			return;
		Vector3 targetOrg = OriginOf(checkEnt);
		float targAng = AnglesTo(Vec(STUN_BURST_POS), targetOrg);
		int newYaw = int(targAng);
		SetVelocity(checkEnt, RelativeVelocity(Vector3(0, newYaw, 0), Vector3(0, 1000, 0)));
	}

	// do_fire
	// ================================== Fire/Poison Spray
	void OnDoFire()
	{
		CallEventDelayed(FREQ_FIRE, "do_fire");

		// somethign funktastic going on here preventing this from repeating
		// setvard NEXT_FIRE game.time
		// add NEXT_FIRE FREQ_FIRE
		// dbg ^^^ do_fire NPCATK_TARGET FREQ_FIRE ( game.time vs. NEXT_FIRE )
		// callevent NEXT_FIRE do_fire
		if (SUSPEND_AI)
			return;
		if (NPCATK_TARGET == "unset")
			return;

		FIRE_PREPPING = true;
		PlayAnim("critical", ANIM_FIRE_PREP);
		PlaySound(0, 10, SOUND_FIRE_PREP);
		OnNpcatkSuspendAi(Text(FIRE_DURATION));
		AS_ATTACKING = GameTime() + 10.0f;
		SetMoveAnim(ANIM_FIRE_HOLD);
		SetIdleAnim(ANIM_FIRE_HOLD);
		SetRoam(false);

		CallEventDelayed(1.0f, "fire_start"); // in case anim event fails for some reason
	}

	// fire_start
	void OnFireStart()
	{
		if (FIRE_ON)
			return;

		ServerPlaySound(1, 10, SOUND_FIRE_LOOP);
		FIRE_ON = true;
		FIRE_PREPPING = false;
		CallEventDelayed(FIRE_DURATION, "fire_end");
		FIRE_TYPE = RandomInt(1, 2); // fire/poison
		FIRE_ROTATE = RandomInt(0, 1); // stay straight/strafe
		if (FIRE_ROTATE != 0)
		{
			float startYaw = AnglesOf(ENT_ME).y - 45.0f;
			if (startYaw < 0.0f)
				startYaw += 359.0f;
			SetAngle("face", Vector3(0, startYaw, 0));
			FIRE_ROT = startYaw;
		}

		ClientEvent("new", "all", FIRE_CLSCRIPT, IndexOf(ENT_ME), FIRE_TYPE, FIRE_DURATION);

		OnFireLoop();
	}

	// fire_loop
	void OnFireLoop()
	{
		if (!FIRE_ON)
			return;
		CallEventDelayed(0.1f, "fire_loop");

		if (FIRE_ROTATE != 0)
		{
			Vector3 facePos = OriginOf(ENT_ME) + RelativePosition(Vector3(0, FIRE_ROT, 0), Vector3(0, 500, 0));
			SetMoveDest(facePos, 9999);
			FIRE_ROT += 1.0f;
			if (FIRE_ROT > 359.0f)
				FIRE_ROT -= 359.0f;
		}

		if (!(GameTime() > NEXT_SCAN))
			return;
		NEXT_SCAN = GameTime() + 0.5f;
		FIRE_TARGS = FindInBox("enemy", 512);
		if (FIRE_TARGS == "none")
			return;
		CallEventDelayed(GetTokenCount(FIRE_TARGS), "fire_affect_targets");
	}

	// fire_affect_targets
	void OnFireAffectTargets()
	{
		CBaseEntity@ curTarg = FindEntity(GetToken(FIRE_TARGS, loopIteration));
		if (!IsAlive(curTarg))
			return;
		Vector3 targOrg = OriginOf(curTarg);

		bool inCone = WithinCone2D(targOrg, MyOrigin(), MyAngles(), 10);
		DebugPrint("fire_affect_targets " + NameOf(curTarg) + " incone " + Text(inCone) + " rng " + Text(RangeTo(curTarg)));

		if (!inCone)
			return;
		if (!(RangeTo(curTarg) < 512.0f))
			return;
		if (FIRE_TYPE == 1)
			ApplyEffect(curTarg, "effects/dot_fire", 10.0f, self, DOT_FIRE);
		if (FIRE_TYPE == 2)
			ApplyEffect(curTarg, "effects/dot_poison", 10.0f, self, DOT_POISON);
	}

	// fire_end
	void OnFireEnd()
	{
		ServerPlaySound(1, 0, SOUND_FIRE_LOOP);
		PlaySound(2, 10, SOUND_FIRE_END);
		FIRE_ON = false;
		SetIdleAnim(ANIM_IDLE);
		SetMoveAnim(ANIM_RUN);
		SetRoam(true);
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files
	void OnFireDuration() {} // FIRE_DURATION
	void OnFreqFire() {} // FREQ_FIRE

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("poison_cloud.spr");
		Precache("explode1.spr");
		Precache("3dmflaora.spr");
		Precache("monsters/kayrath.mdl");
		Precache("garg/gar_flamerun1.wav");
		CallEventDelayed(FREQ_RANDRAWR, "Kayrath_Timer");
		CallEventDelayed(FREQ_FIRE, "do_fire");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		Kayrath_FirstThink();
		Kayrath_FirstThink2();
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
		if (name == "cycle_up") { OnCycleUp(Param(params, 0)); return true; }
		if (name == "do_fire") { OnDoFire(); return true; }
		if (name == "fade_in_done") { OnFadeInDone(); return true; }
		if (name == "fire_affect_targets") { OnFireAffectTargets(); return true; }
		if (name == "fire_end") { OnFireEnd(); return true; }
		if (name == "fire_loop") { OnFireLoop(); return true; }
		if (name == "fire_start") { OnFireStart(); return true; }
		if (name == "frame_fire_prep_done") { OnFrameFirePrepDone(); return true; }
		if (name == "frame_kick") { OnFrameKick(); return true; }
		if (name == "frame_runstep1") { OnFrameRunstep1(); return true; }
		if (name == "frame_runstep2") { OnFrameRunstep2(); return true; }
		if (name == "frame_smash") { OnFrameSmash(); return true; }
		if (name == "frame_stomp") { OnFrameStomp(); return true; }
		if (name == "frame_swing") { OnFrameSwing(); return true; }
		if (name == "frame_walkstep1") { OnFrameWalkstep1(); return true; }
		if (name == "frame_walkstep2") { OnFrameWalkstep2(); return true; }
		if (name == "game_precache") { OnGamePrecache(); return true; }
		if (name == "game_struck") { OnGameStruck(Float(Param(params, 0)), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "npcatk_lost_sight") { OnNpcatkLostSight(); return true; }
		if (name == "stun_targets") { OnStunTargets(); return true; }
		if (name == "stunburst_affect_targets") { OnStunburstAffectTargets(); return true; }
		if (name == "stunburst_go") { OnStunburstGo(Param(params, 0), Int(Param(params, 1)), Int(Param(params, 2)), Param(params, 3)); return true; }
		if (name == "Kayrath_Timer") { Kayrath_Timer(); return true; }
		return BaseMonsterNewScript::DispatchEvent(name, params);
	}
}
