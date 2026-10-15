#pragma context server

// Converted from monsters/bgoblin_chief.script by msc_transpiler.
// Da Chief
// Only extra ability is fire breath, so needs a heavy escort

#include "runtime/ScriptEntity.as"
#include "converted/monsters/bgoblin.as"

[script "monsters/bgoblin_chief"]
class BgoblinChief : BgoblinScript
{
	// Constants
	string SOUND_BREATH = "monsters/goblin/sps_fogfire.wav";
	int STEP_SIZE_NORM = 36;
	float DOT_FIRE = 75.0f;
	int DMG_CHARGE = 50;
	float FREQ_BREATH = 0.0f;
	string FIRE_BREATH_SCRIPT = "monsters/bgoblin_chief_cl";
	string SOUND_REPEL = "ambience/alien_humongo.wav";

	// Variables (an unset .script variable reads as its own name)
	bool AXE_SWING = false;
	bool STARTED_CYCLES = false;
	float BREATH_ANG = 0.0f;
	float BREATH_COUNT = 0.0f;
	bool FIRE_BREATH_ON = false;
	string CL_IDX = "CL_IDX";
	float NEXT_SCAN = 0.0f;
	string CLOUD_TARGS = "CLOUD_TARGS";
	string STUN_BURST_POS = "STUN_BURST_POS";
	int STUN_BURST_RAD = 0;
	bool STUN_BURST_REPEL = false;
	string STUN_BURST_DMG = "STUN_BURST_DMG";

	// Variables declared by included files, with the value they start with in this script
	BgoblinChief()
	{
		NPC_BASE_EXP = "3000";
		SOUND_ATTACK1 = "monsters/goblin/c_gargoyle_atk1.wav";
		SOUND_ATTACK2 = "monsters/goblin/c_gargoyle_atk2.wav";
		SOUND_ATTACK3 = "monsters/goblin/c_gargoyle_atk3.wav";
		CAN_STUN = true;
	}

	// unnamed block (first think)
	void BgoblinChief_FirstThink()
	{
		DROP_GOLD = 0;

		ANIM_ATTACK = "battleaxe_swing1_L";

		ATTACK_HITCHANCE = "90%";
	}

	// game_dodamage
	// PARAM1=hit:0|1 PARAM2=ent_hit PARAM3=(start) PARAM4=(end)
	string BgoblinChief_OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";

		// fire axe effect
		if (hit && AXE_SWING)
		{
			ApplyEffect(target, "effects/dot_fire", 10.0f, self, DOT_FIRE);
			AXE_SWING = false;
		}
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
		Bgoblin_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/bgoblin

		CallExternal(GetVar("GAME_MASTER"), "bgoblin_chief_died", OriginOf(ENT_ME));
		if (FIRE_BREATH_ON)
			ClientEvent("update", "all", CL_IDX, "end_fx");
	}

	// game_struck
	void OnGameStruck(float damage = 0.0f, string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		BaseNpc_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseNpcAttackNew_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc_attack_new
		BaseMonsterShared_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared
		Bgoblin_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/bgoblin
		if (FIRE_BREATH_ON && RangeTo(ENT_LASTSTRUCK) < 128.0f)
		{
			Vector3 targetOrg = OriginOf(ENT_LASTSTRUCK);
			float targAng = AnglesTo(MyOrigin(), targetOrg);
			SetVelocity(ENT_LASTSTRUCK, RelativeVelocity(Vector3(0, targAng, 0), Vector3(10, 1000, 0)));
			PlaySound(0, 10, SOUND_REPEL);
			Effect("glow", ENT_ME, Vector3(255, 0, 0), 60, 2.0f, 2.0f);
		}
	}

	// my_target_died
	void OnMyTargetDied(string offender = "")
	{
		BaseNpcAttackNew_OnMyTargetDied(offender); // monsters/base_npc_attack_new
		CallEventDelayed(1.0f, "npcatk_go_home");
	}

	// game_dodamage
	string OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";
		result = AppendResult(result, BaseNpcAttackNew_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BaseAntiStuck_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BaseMonsterShared_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BgoblinChief_OnGameDodamage(hit, target, start, end, damageType, damageText));
		return result;
	}

	// cycle_up
	void OnCycleUp(string reason = "")
	{
		BaseNpcAttackNew_OnCycleUp(reason); // monsters/base_npc_attack_new
		Bgoblin_OnCycleUp(reason); // monsters/bgoblin
		if (STARTED_CYCLES)
			return;
		STARTED_CYCLES = true;
		OnClEffectLoop();
		CallEventDelayed(FREQ_BREATH, "do_fire_breath");
	}

	// goblin_pre_spawn
	void OnGoblinPreSpawn()
	{
		Bgoblin_OnGoblinPreSpawn(); // monsters/bgoblin
		ATTACK_RANGE = 96.0f;
		ATTACK_HITRANGE = 128.0f;
		ATTACK_MOVERANGE = 48.0f; // a bit huggie :)
		MOVE_RANGE = "48";
	}

	// stun_targets
	void OnStunTargets()
	{
		Bgoblin_OnStunTargets(); // monsters/bgoblin
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

	// game_precache
	void OnGamePrecache()
	{
		PrecacheFile(FIRE_BREATH_SCRIPT);
	}

	// goblin_spawn
	void OnGoblinSpawn()
	{
		SetName("Blood Goblin Chieftain");
		SetRace("goblin");
		SetBlood("red"); // green for v_goblin
		SetHealth(5000);
		SetRoam(true);

		SetAnimFrameRate(1.5f);

		SetHearingSensitivity(4);

		if (!NEW_MODEL)
		{
			SetModel("monsters/goblin2_boss.mdl");
			SetWidth(32);
			SetHeight(72);

			SetModelBody(0, 2); // body: 0-Bare 1-Archer 2-Armor 3-Sniper
			SetModelBody(1, 3); // head: 0-Horns 1-Spikes 2-Animal 3-Chief 4-Cowl
			SetModelBody(2, 2); // weapon: 0-Unarmed 1-SkullClub 2-DragonAxe 3-Knife 4-Bow 5-Raxe 6-SW&SH
			SetModelBody(3, 0); // arrow: on/off

			SetProp(ENT_ME, "skin", 2);
		}
		else
		{
			SetModel("monsters/goblin_new_boss.mdl");
			SetWidth(32);
			SetHeight(72);

			SetModelBody(0, 0); // body: 0-Bare 1-Quiver&Strap
			SetModelBody(1, 3); // head: 0-Bare 1-Horns 2-Animal 3-Chief 4-Rag
			SetModelBody(2, 2); // weapon: 0-Unarmed 1-SkullClub 2-DragonAxe 3-Knife 4-Bow 5-Raxe 6-SW&SH
			SetModelBody(3, 0); // arrow: On/off

			SetProp(ENT_ME, "skin", 1); // 0-norm 1-blood 2-vile
		}

		SetIdleAnim(ANIM_IDLE);
		SetMoveAnim(ANIM_WALK);

		SetDamageTaken("all", 0.5f);
		SetDamageTaken("fire", 0);
		SetDamageTaken("cold", 1.25f);
	}

	// swing_axe
	// ANIM_SMASH
	void OnSwingAxe()
	{
		AXE_SWING = true;
		PlayRandomSound(0, 10, SOUND_ATTACK1, SOUND_ATTACK2, SOUND_ATTACK3);
		DoDamage(NPCATK_TARGET, ATTACK_HITRANGE, DMG_AXE, ATTACK_HITCHANCE, "slash");
	}

	// do_fire_breath
	void OnDoFireBreath()
	{
		CallEventDelayed(FREQ_BREATH, "do_fire_breath");
		if (NPCATK_TARGET == "unset")
			return;

		OnNpcatkSuspendAi();
		BREATH_ANG = AnglesOf(ENT_ME).y - 30.0f;
		if (BREATH_ANG < 0.0f)
			BREATH_ANG += 359.0f;
		BREATH_COUNT = 0.0f;
		SetMoveAnim(ANIM_WARCRY);
		SetIdleAnim(ANIM_WARCRY);
		PlayAnim("critical", ANIM_WARCRY);
		CallEventDelayed(0.01f, "fire_breath_loop");
		FIRE_BREATH_ON = true;
		ServerPlaySound(1, 10, SOUND_BREATH);

		ClientEvent("new", "all", "monsters/bgoblin_chief_cl", IndexOf(ENT_ME));
		CL_IDX = LastClientScriptId();
	}

	// fire_breath_loop
	void OnFireBreathLoop()
	{
		int count;

		BREATH_COUNT += 1.0f;
		if (BREATH_COUNT == 60.0f)
			OnEndFireBreath();

		if (!(BREATH_COUNT < 60.0f))
			return;
		CallEventDelayed(0.05f, "fire_breath_loop");

		BREATH_ANG += 1.0f;
		if (BREATH_ANG > 359.0f)
			BREATH_ANG -= 359.0f;

		Vector3 facePos = MyOrigin() + RelativePosition(Vector3(0, BREATH_ANG, 0), Vector3(0, 500, 0));
		SetMoveDest(facePos, 9999);

		Vector3 cloudStart = BonePositionOf(ENT_ME, 20); // see if you can move this client side with $getcl(SKEL_IDX,bonepos,BONE_IDX)
		cloudStart += RelativePosition(Vector3(0, Float(Eval("game.monster.angles.yaw")), 0), Vector3(0, 16, 0));

		// clientevent update all CL_IDX make_cloud CLOUD_START $get(ent_me,angles.yaw)
		if (CLOUD_TARGS != "none")
		{
			count = GetTokenCount(CLOUD_TARGS);
			for (int i = 0; i < count; i++)
			{
				loopIteration = i;
				OnBurnTargets();
			}
		}

		if (!(GameTime() > NEXT_SCAN))
			return;
		NEXT_SCAN = GameTime() + 0.5f;
		Vector3 scanPoint = RelativePosition(Vector3(0, 128, 0));
		CLOUD_TARGS = LegacyFunction("get_tbox", "enemy", 128, scanPoint);
		PlayAnim("once", ANIM_WARCRY);
	}

	// burn_targets
	void OnBurnTargets()
	{
		string curTarget = GetToken(CLOUD_TARGS, loopIteration);
		if (!IsAlive(curTarget))
			return;
		Vector3 targOrg = OriginOf(curTarget);
		if (!WithinCone2D(targOrg, MyOrigin(), MyAngles(), 30))
			return;
		if (!(RangeTo(curTarget) < 256.0f))
			return;
		ApplyEffect(curTarget, "effects/dot_fire", 10.0f, self, DOT_FIRE);
		AddVelocity(curTarget, RelativeVelocity(Vector3(0, 300, 120)));
	}

	// end_fire_breath
	void OnEndFireBreath()
	{
		ClientEvent("update", "all", CL_IDX, "end_fx");

		OnNpcatkResumeAi();
		SetIdleAnim(ANIM_IDLE);
		SetMoveAnim(ANIM_RUN);
		ServerPlaySound(1, 0, SOUND_BREATH);
		FIRE_BREATH_ON = false;
	}

	// leap_stun
	void OnLeapStun()
	{
		// createnpc monsters/summon/stun_burst $relpos(0,64,0) $get(ent_me,id) 64 0 DMG_CHARGE
		// optimization: doing stun burst local to save an NPC creation
		Vector3 burstPos = RelativePosition(Vector3(0, 64, 0));
		OnStunburstGo(Text(burstPos), 64, 0, Text(DMG_CHARGE));
	}

	// gob_jump_check
	// less likey to jump, but jumps higher, if needed to reach target
	void OnGobJumpCheck()
	{
		float zDiff;

		if (!GOB_JUMPER)
			return;
		if (!GOB_JUMP_SCANNING)
			return;

		float gobHopDelay = Random(2, 4);

		CallEventDelayed(gobHopDelay, "gob_jump_check");

		if (NPCATK_TARGET == "unset")
			return;
		if (IS_FLEEING)
			return;
		if (SUSPEND_AI)
			return;
		if (!(RangeTo(NPCATK_TARGET) < GOBLIN_JUMPRANGE))
			return;

		// jump at target if he's higher than I am
		float meZ = Float(Eval("game.monster.origin.z"));
		float targZ = OriginOf(NPCATK_TARGET).z;
		if (IsPlayer(NPCATK_TARGET)) // player center compensation
			targZ -= 38.0f;

		if (meZ > targZ)
		{
			zDiff = meZ;
			meZ -= targZ;
		}
		else
		{
			zDiff = targZ - meZ;
		}

		if (zDiff > ATTACK_RANGE)
		{
			PlayAnim("critical", ANIM_SMASH);
			CallEventDelayed(0.1f, "do_jump"); // bludgeon style
		}
	}

	// do_jump
	void OnDoJump()
	{
		SetStepSize(1000);
		AddVelocity(ENT_ME, RelativeVelocity(Vector3(0, -200, 800)));
		CallEventDelayed(0.5f, "push_forward");
		CallEventDelayed(1.0f, "jump_done");
	}

	// push_forward
	void OnPushForward()
	{
		AddVelocity(ENT_ME, RelativeVelocity(Vector3(0, 400, 100)));
	}

	// jump_done
	void OnJumpDone(string npc = "")
	{
		SetStepSize(STEP_SIZE_NORM);
		SetMoveAnim(ANIM_RUN);
	}

	// stunburst_go
	// localized stun burst to save NPC (since he already has his own client effects)
	// <pos> <radius> <repel:0|1> <dmg>
	void OnStunburstGo(string pos = "", int radius = 0, int repel = 0, string dmg = "")
	{
		STUN_BURST_POS = pos;
		STUN_BURST_RAD = radius;
		STUN_BURST_REPEL = repel != 0;
		STUN_BURST_DMG = dmg;
		DebugPrint("stunburst_go pos: " + STUN_BURST_POS + " rad: " + STUN_BURST_RAD + " repel: " + Text(STUN_BURST_REPEL) + " dmg: " + STUN_BURST_DMG);

		ClientEvent("new", "all", "effects/sfx_stun_burst", STUN_BURST_POS, STUN_BURST_RAD, 0);
		PlaySound(0, 10, "magic/boom.wav");
		CallEventDelayed(0.25f, "stun_targets");
	}

	// stunburst_affect_targets
	void OnStunburstAffectTargets()
	{
		CBaseEntity@ checkEnt = FindEntity(GetToken(STUN_LIST, loopIteration));

		if (!IsOnGround(checkEnt))
			return;

		ApplyEffect(checkEnt, "effects/debuff_stun", 5.0f, self);

		if (Float(STUN_BURST_DMG) > 0.0f)
			DoDamage(checkEnt, "direct", STUN_BURST_DMG, "100%", ENT_ME, "magic");

		if (!STUN_BURST_REPEL)
			return;
		Vector3 targetOrg = OriginOf(checkEnt);
		float targAng = AnglesTo(Vec(STUN_BURST_POS), targetOrg);
		int newYaw = int(targAng);
		SetVelocity(checkEnt, RelativeVelocity(Vector3(0, newYaw, 0), Vector3(0, 1000, 0)));
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files
	void OnFreqBreath() {} // FREQ_BREATH
	void OnClEffectLoop() {} // cl_effect_loop

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/goblin2_boss.mdl");
		Precache("monsters/goblin_new_boss.mdl");
		Precache("monsters/goblin/sps_fogfire.wav");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		BgoblinChief_FirstThink();
		Bgoblin_FirstThink();
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
		if (name == "burn_targets") { OnBurnTargets(); return true; }
		if (name == "cycle_up") { OnCycleUp(Param(params, 0)); return true; }
		if (name == "do_fire_breath") { OnDoFireBreath(); return true; }
		if (name == "do_jump") { OnDoJump(); return true; }
		if (name == "end_fire_breath") { OnEndFireBreath(); return true; }
		if (name == "fire_breath_loop") { OnFireBreathLoop(); return true; }
		if (name == "game_death") { OnGameDeath(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_dodamage") { Return(OnGameDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5))); return true; }
		if (name == "game_precache") { OnGamePrecache(); return true; }
		if (name == "game_struck") { OnGameStruck(Float(Param(params, 0)), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "gob_jump_check") { OnGobJumpCheck(); return true; }
		if (name == "goblin_pre_spawn") { OnGoblinPreSpawn(); return true; }
		if (name == "goblin_spawn") { OnGoblinSpawn(); return true; }
		if (name == "jump_done") { OnJumpDone(Param(params, 0)); return true; }
		if (name == "leap_stun") { OnLeapStun(); return true; }
		if (name == "my_target_died") { OnMyTargetDied(Param(params, 0)); return true; }
		if (name == "push_forward") { OnPushForward(); return true; }
		if (name == "stun_targets") { OnStunTargets(); return true; }
		if (name == "stunburst_affect_targets") { OnStunburstAffectTargets(); return true; }
		if (name == "stunburst_go") { OnStunburstGo(Param(params, 0), Int(Param(params, 1)), Int(Param(params, 2)), Param(params, 3)); return true; }
		if (name == "swing_axe") { OnSwingAxe(); return true; }
		return BgoblinScript::DispatchEvent(name, params);
	}
}
