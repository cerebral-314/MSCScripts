#pragma context server

// Converted from monsters/vgoblin_chief.script by msc_transpiler.
// Da Chief
// Launches laughing skulls from his axe that chew on players and 'splode into clouds
// alternate skull bounces around and explodes
// large AOE stun
// dewm tree
// constant cloud of poison
// also todo:
// stone cobra (g. cobra w/breath atk)
// axes_dragon  ("the dragon's breath" - axe with w/breath atk)
// chests for chapel
// chests for isle

#include "runtime/ScriptEntity.as"
#include "converted/monsters/bgoblin.as"

[script "monsters/vgoblin_chief"]
class VgoblinChief : BgoblinScript
{
	// Constants
	int STEP_SIZE_NORM = 36;
	float FREQ_CLOUD = 1.5f;
	int DMG_CLOUD = 20;
	string CL_SCRIPT = "monsters/vgoblin_chief_cl";
	float FREQ_SPECIAL = 0.0f;
	float DOT_POISON = 50.0f;
	int DMG_CHARGE = 50;
	string PLANT_SCRIPT = "monsters/summon/doom_plant";
	string CHEW_SKULL_SCRIPT = "monsters/lost_soul";
	string SPLODIE_SKULL_SCRIPT = "traps/splodie_skull";
	float SPLODIE_SKULL_STR = 1.0f;
	float CHEW_SKULL_STR = 1.0f;
	int PLANT_STR = 30;
	float SKULL_DURATION = 0.0f;

	// Variables (an unset .script variable reads as its own name)
	string MY_CL_SCRIPT_IDX = "MY_CL_SCRIPT_IDX";
	bool AXE_SWING = false;
	bool STARTED_CYCLES = false;
	int RND_SPECIAL = 0;
	Vector3 SUM_POS = Vector3();
	string POISON_LIST = "POISON_LIST";
	string STUN_BURST_POS = "STUN_BURST_POS";
	int STUN_BURST_RAD = 0;
	bool STUN_BURST_REPEL = false;
	string STUN_BURST_DMG = "STUN_BURST_DMG";

	// Variables declared by included files, with the value they start with in this script
	VgoblinChief()
	{
		NPC_BASE_EXP = "3000";
		SOUND_ATTACK1 = "monsters/goblin/c_gargoyle_atk1.wav";
		SOUND_ATTACK2 = "monsters/goblin/c_gargoyle_atk2.wav";
		SOUND_ATTACK3 = "monsters/goblin/c_gargoyle_atk3.wav";
	}

	// unnamed block (first think)
	void VgoblinChief_FirstThink()
	{
		CAN_STUN = true;

		DROP_GOLD = 0;

		ANIM_ATTACK = "battleaxe_swing1_L";

		ATTACK_HITCHANCE = "90%";
	}

	// swing_axe
	// ANIM_SMASH
	void VgoblinChief_OnSwingAxe()
	{
		AXE_SWING = true;
		PlayRandomSound(0, 10, SOUND_ATTACK1, SOUND_ATTACK2, SOUND_ATTACK3);
		DoDamage(NPCATK_TARGET, ATTACK_HITRANGE, DMG_AXE, ATTACK_HITCHANCE, "blunt");
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
		ClientEvent("remove", "all", MY_CL_SCRIPT_IDX);
		CallExternal(GetVar("GAME_MASTER"), "vgoblin_chief_died", OriginOf(ENT_ME));
	}

	// my_target_died
	void OnMyTargetDied(string offender = "")
	{
		BaseNpcAttackNew_OnMyTargetDied(offender); // monsters/base_npc_attack_new
		CallEventDelayed(1.0f, "npcatk_go_home");
	}

	// cycle_up
	void OnCycleUp(string reason = "")
	{
		BaseNpcAttackNew_OnCycleUp(reason); // monsters/base_npc_attack_new
		Bgoblin_OnCycleUp(reason); // monsters/bgoblin
		if (STARTED_CYCLES)
			return;
		STARTED_CYCLES = true;
		CallEventDelayed(FREQ_SPECIAL, "set_special");
		CallEventDelayed(FREQ_CLOUD, "update_cloud");
	}

	// goblin_pre_spawn
	void OnGoblinPreSpawn()
	{
		Bgoblin_OnGoblinPreSpawn(); // monsters/bgoblin
		ATTACK_RANGE = 96.0f;
		ATTACK_HITRANGE = 128.0f;
		ATTACK_MOVERANGE = 58.0f;
		MOVE_RANGE = "58";
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
		PrecacheFile(PLANT_SCRIPT);
		PrecacheFile(CHEW_SKULL_SCRIPT);
		PrecacheFile(SPLODIE_SKULL_SCRIPT);
		PrecacheFile(CL_SCRIPT);
	}

	// goblin_spawn
	void OnGoblinSpawn()
	{
		SetName("Vile Goblin Chieftain");
		SetRace("goblin");
		SetBlood("green");
		SetHealth(5000);

		if (!NEW_MODEL)
		{
			SetModel("monsters/goblin2_boss.mdl");
			SetWidth(32);
			SetHeight(72);

			SetModelBody(0, 0); // body: 0-Runed 1-Archer 2-Leathers 3-Sniper
			SetModelBody(1, 3); // head: 0-Horns 1-Spikes 2-Animal 3-Chief 4-Cowl
			SetModelBody(2, 1); // weapon: 0-Unarmed 1-SkullClub 2-DragonAxe 3-Knife 4-Bow 5-Raxe 6-SW&SH
			SetModelBody(3, 0); // arrow: on/off

			SetProp(ENT_ME, "skin", 3);
		}
		else
		{
			SetModel("monsters/goblin_new_boss.mdl");
			SetWidth(32);
			SetHeight(72);

			SetModelBody(0, 0); // body: 0-Bare 1-Quiver&Strap
			SetModelBody(1, 3); // head: 0-Bare 1-Horns 2-Animal 3-Chief 4-Rag
			SetModelBody(2, 1); // weapon: 0-Unarmed 1-SkullClub 2-DragonAxe 3-Knife 4-Bow 5-Raxe 6-SW&SH
			SetModelBody(3, 0); // arrow: On/off

			SetProp(ENT_ME, "skin", 2); // 0-norm 1-blood 2-vile
		}

		SetRoam(true);

		SetAnimFrameRate(1.5f);

		SetHearingSensitivity(4);

		SetIdleAnim(ANIM_IDLE);
		SetMoveAnim(ANIM_WALK);

		SetDamageTaken("all", 0.5f);
		SetDamageTaken("poison", 0);
		SetDamageTaken("lightning", 1.25f);

		ClientEvent("persist", "all", CL_SCRIPT, IndexOf(ENT_ME));
		MY_CL_SCRIPT_IDX = LastClientScriptId();
	}

	// swing_dodamage
	// PARAM1=hit:0|1 PARAM2=ent_hit PARAM3=(start) PARAM4=(end)
	void OnSwingDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		// poison mace effect
		if (hit && AXE_SWING)
			ApplyEffect(target, "effects/dot_poison", 10.0f, self, DOT_POISON);
		AXE_SWING = false;
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

	// set_special
	void OnSetSpecial()
	{
		CallEventDelayed(FREQ_SPECIAL, "set_special");
		RND_SPECIAL = RandomInt(1, 3);
	}

	// swing_axe
	// ANIM_SMASH
	void OnSwingAxe()
	{
		AXE_SWING = true;
		PlayRandomSound(0, 10, SOUND_ATTACK1, SOUND_ATTACK2, SOUND_ATTACK3);
		DoDamage(NPCATK_TARGET, ATTACK_HITRANGE, DMG_AXE, ATTACK_HITCHANCE, "slash");

		if (!(RND_SPECIAL > 0))
			return;
		Vector3 burstPos = RelativePosition(Vector3(0, 64, -16));
		OnStunburstGo(Text(burstPos), 256, 1, Text(DMG_CHARGE));
		if (RND_SPECIAL == 1)
			CallEventDelayed(0.2f, "summon_chew_skulls");
		if (RND_SPECIAL == 2)
			CallEventDelayed(0.2f, "summon_splodie_skulls");
		if (RND_SPECIAL == 3)
			CallEventDelayed(0.2f, "summon_dewm");
		RND_SPECIAL = 0;
	}

	// summon_chew_skulls
	// x2
	void OnSummonChewSkulls()
	{
		SUM_POS = RelativePosition(Vector3(-64, 64, -16));
		OnSummonEffect();
		CreateNpc(CHEW_SKULL_SCRIPT, SUM_POS, self, CHEW_SKULL_STR, SKULL_DURATION);
		CallEventDelayed(0.01f, "summon_chew_skulls2");
	}

	// summon_chew_skulls2
	void OnSummonChewSkulls2()
	{
		SUM_POS = RelativePosition(Vector3(64, 64, -16));
		OnSummonEffect();
		CreateNpc(CHEW_SKULL_SCRIPT, SUM_POS, self, CHEW_SKULL_STR, SKULL_DURATION);
	}

	// summon_splodie_skulls
	// x4
	void OnSummonSplodieSkulls()
	{
		SUM_POS = RelativePosition(Vector3(-64, 64, 32));
		OnSummonEffect();
		CreateNpc(SPLODIE_SKULL_SCRIPT, SUM_POS, self, SPLODIE_SKULL_STR, SKULL_DURATION);
		CallEventDelayed(0.01f, "summon_splodie_skulls2");
	}

	// summon_splodie_skulls2
	void OnSummonSplodieSkulls2()
	{
		SUM_POS = RelativePosition(Vector3(64, 64, 32));
		OnSummonEffect();
		CreateNpc(SPLODIE_SKULL_SCRIPT, RelativePosition(Vector3(64, 64, 32)), self, SPLODIE_SKULL_STR, SKULL_DURATION);
		CallEventDelayed(0.01f, "summon_splodie_skulls3");
	}

	// summon_splodie_skulls3
	void OnSummonSplodieSkulls3()
	{
		SUM_POS = RelativePosition(Vector3(64, 64, -16));
		OnSummonEffect();
		CreateNpc(SPLODIE_SKULL_SCRIPT, RelativePosition(Vector3(64, 64, -16)), self, SPLODIE_SKULL_STR, SKULL_DURATION);
		CallEventDelayed(0.01f, "summon_splodie_skulls4");
	}

	// summon_splodie_skulls4
	void OnSummonSplodieSkulls4()
	{
		SUM_POS = RelativePosition(Vector3(-64, 64, -16));
		OnSummonEffect();
		CreateNpc(SPLODIE_SKULL_SCRIPT, RelativePosition(Vector3(-64, 64, -16)), self, SPLODIE_SKULL_STR, SKULL_DURATION);
	}

	// summon_dewm
	// x1
	void OnSummonDewm()
	{
		OnSummonPlantEffect();
		Vector3 plantPos = RelativePosition(Vector3(0, 64, -32));
		ClientEvent("update", "all", MY_CL_SCRIPT_IDX, "dewm_plant_fx", plantPos);
		CreateNpc(PLANT_SCRIPT, plantPos, PLANT_STR);
	}

	// summon_effect
	// draw a beam from mace to summon point
	void OnSummonEffect()
	{
		Vector3 startPos = BonePositionOf(ENT_ME, 12); // use attach index if he has one (check)
		Effect("beam", "point", "lgtning.spr", 30, startPos, SUM_POS, Vector3(0, 255, 0), 200, 30, 0.5f);
	}

	// update_cloud
	void OnUpdateCloud()
	{
		CallEventDelayed(FREQ_CLOUD, "update_cloud");
		if (!GOB_JUMP_SCANNING)
			return;
		// xdodamage $relpos(0,0,-32) 128 DMG_CLOUD 0 ent_me ent_me none poison
		POISON_LIST = LegacyFunction("get_tbox", "enemy", 128, RelativePosition(Vector3(0, 0, -32)));
		if (POISON_LIST == "none")
			return;
		POISON_LIST = TokenShuffle(POISON_LIST);
		ApplyEffect(GetToken(POISON_LIST, 0), "effects/dot_poison", 5.0f, self, DOT_POISON);
	}

	// stunburst_go
	// <pos> <radius> <repel:0|1> <dmg>
	void OnStunburstGo(string pos = "", int radius = 0, int repel = 0, string dmg = "")
	{
		STUN_BURST_POS = pos;
		STUN_BURST_RAD = radius;
		STUN_BURST_REPEL = repel != 0;
		STUN_BURST_DMG = dmg;
		DebugPrint("stunburst_go pos: " + STUN_BURST_POS + " rad: " + STUN_BURST_RAD + " repel: " + Text(STUN_BURST_REPEL) + " dmg: " + STUN_BURST_DMG);

		ClientEvent("update", "all", MY_CL_SCRIPT_IDX, "stunburst_go_cl", STUN_BURST_POS, STUN_BURST_RAD);
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
	void OnFreqCloud() {} // FREQ_CLOUD
	void OnFreqSpecial() {} // FREQ_SPECIAL
	void OnSummonPlantEffect() {} // summon_plant_effect

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/goblin2_boss.mdl");
		Precache("monsters/goblin_new_boss.mdl");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		VgoblinChief_FirstThink();
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
		if (name == "cycle_up") { OnCycleUp(Param(params, 0)); return true; }
		if (name == "do_jump") { OnDoJump(); return true; }
		if (name == "game_death") { OnGameDeath(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_precache") { OnGamePrecache(); return true; }
		if (name == "gob_jump_check") { OnGobJumpCheck(); return true; }
		if (name == "goblin_pre_spawn") { OnGoblinPreSpawn(); return true; }
		if (name == "goblin_spawn") { OnGoblinSpawn(); return true; }
		if (name == "jump_done") { OnJumpDone(Param(params, 0)); return true; }
		if (name == "leap_stun") { OnLeapStun(); return true; }
		if (name == "my_target_died") { OnMyTargetDied(Param(params, 0)); return true; }
		if (name == "push_forward") { OnPushForward(); return true; }
		if (name == "set_special") { OnSetSpecial(); return true; }
		if (name == "stun_targets") { OnStunTargets(); return true; }
		if (name == "stunburst_affect_targets") { OnStunburstAffectTargets(); return true; }
		if (name == "stunburst_go") { OnStunburstGo(Param(params, 0), Int(Param(params, 1)), Int(Param(params, 2)), Param(params, 3)); return true; }
		if (name == "summon_chew_skulls") { OnSummonChewSkulls(); return true; }
		if (name == "summon_chew_skulls2") { OnSummonChewSkulls2(); return true; }
		if (name == "summon_dewm") { OnSummonDewm(); return true; }
		if (name == "summon_effect") { OnSummonEffect(); return true; }
		if (name == "summon_splodie_skulls") { OnSummonSplodieSkulls(); return true; }
		if (name == "summon_splodie_skulls2") { OnSummonSplodieSkulls2(); return true; }
		if (name == "summon_splodie_skulls3") { OnSummonSplodieSkulls3(); return true; }
		if (name == "summon_splodie_skulls4") { OnSummonSplodieSkulls4(); return true; }
		if (name == "swing_axe") { OnSwingAxe(); return true; }
		if (name == "swing_dodamage") { OnSwingDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5)); return true; }
		if (name == "update_cloud") { OnUpdateCloud(); return true; }
		return BgoblinScript::DispatchEvent(name, params);
	}
}
