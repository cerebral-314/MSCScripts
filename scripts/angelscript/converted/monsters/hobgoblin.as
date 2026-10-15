#pragma context server

// Converted from monsters/hobgoblin.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/bgoblin.as"

[script "monsters/hobgoblin"]
class Hobgoblin : BgoblinScript
{
	// Constants
	string SOUND_BREATH = "monsters/goblin/sps_fogfire.wav";
	int STEP_SIZE_NORM = 36;
	int DMG_CHARGE = 50;

	// Variables declared by included files, with the value they start with in this script
	Hobgoblin()
	{
		NPC_BASE_EXP = "150";
		SOUND_ATTACK1 = "monsters/goblin/c_gargoyle_atk1.wav";
		SOUND_ATTACK2 = "monsters/goblin/c_gargoyle_atk2.wav";
		SOUND_ATTACK3 = "monsters/goblin/c_gargoyle_atk3.wav";
	}

	// unnamed block (first think)
	void Hobgoblin_FirstThink()
	{
		CAN_STUN = true;

		DROP_GOLD = 1;
		DROP_GOLD_AMT = RandomInt(20, 40);

		ANIM_ATTACK = "swordswing1_L";

		ATTACK_HITCHANCE = "80%";
	}

	// my_target_died
	void OnMyTargetDied(string offender = "")
	{
		BaseNpcAttackNew_OnMyTargetDied(offender); // monsters/base_npc_attack_new
		CallEventDelayed(1.0f, "npcatk_go_home");
	}

	// game_parry
	void OnGameParry(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float parryRoll = 0.0f, float accuracyRoll = 0.0f, float parryValue = 0.0f)
	{
		BaseMonsterShared_OnGameParry(attacker, damage, damageType, parryRoll, accuracyRoll, parryValue); // monsters/base_monster_shared
		PlayAnim("critical", ANIM_PARRY);
		PlayRandomSound(0, 10, SOUND_PARRY1, SOUND_PARRY2, SOUND_PARRY3);
		CallEventDelayed(0.75f, "swing_sword"); // counter
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

	// goblin_spawn
	void OnGoblinSpawn()
	{
		SetName("Hobgoblin");
		SetRace("goblin");
		SetBlood("red");
		SetHealth(500);
		SetRoam(true);

		SetAnimFrameRate(1.5f);

		SetHearingSensitivity(4);

		SetModel("monsters/goblin_new_boss.mdl");
		SetWidth(32);
		SetHeight(72);

		SetModelBody(0, 0); // body: 0-Bare 1-Quiver&Strap
		SetModelBody(1, 1); // head: 0-Bare 1-Horns 2-Animal 3-Chief 4-Rag
		SetModelBody(2, 6); // weapon: 0-Unarmed 1-SkullClub 2-DragonAxe 3-Knife 4-Bow 5-Raxe 6-SW&SH
		SetModelBody(3, 0); // arrow: On/off

		SetProp(ENT_ME, "skin", 0); // 0-norm 1-blood 2-vile

		SetIdleAnim(ANIM_IDLE);
		SetMoveAnim(ANIM_WALK);

		SetDamageTaken("all", 0.7f);
		SetStat("parry", 120);
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

	// swing_axe
	void OnSwingAxe()
	{
		DoDamage(NPCATK_TARGET, ATTACK_HITRANGE, DMG_AXE, ATTACK_HITCHANCE, "slash");
		ANIM_ATTACK = ANIM_SWIPE;
	}

	// swing_sword
	// ANIM_SWIPE
	void OnSwingSword()
	{
		PlayRandomSound(0, 10, SOUND_ATTACK1, SOUND_ATTACK2, SOUND_ATTACK3);
		DoDamage(NPCATK_TARGET, ATTACK_HITRANGE, DMG_SWORD, ATTACK_HITCHANCE, "slash");
		if (RandomInt(1, 3) == 1)
			ANIM_ATTACK = ANIM_SMASH;
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/goblin_new_boss.mdl");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		Hobgoblin_FirstThink();
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
		if (name == "do_jump") { OnDoJump(); return true; }
		if (name == "game_parry") { OnGameParry(EntityParam(params, 0), Float(Param(params, 1)), Param(params, 2), Float(Param(params, 3)), Float(Param(params, 4)), Float(Param(params, 5))); return true; }
		if (name == "gob_jump_check") { OnGobJumpCheck(); return true; }
		if (name == "goblin_pre_spawn") { OnGoblinPreSpawn(); return true; }
		if (name == "goblin_spawn") { OnGoblinSpawn(); return true; }
		if (name == "jump_done") { OnJumpDone(Param(params, 0)); return true; }
		if (name == "my_target_died") { OnMyTargetDied(Param(params, 0)); return true; }
		if (name == "push_forward") { OnPushForward(); return true; }
		if (name == "swing_axe") { OnSwingAxe(); return true; }
		if (name == "swing_sword") { OnSwingSword(); return true; }
		return BgoblinScript::DispatchEvent(name, params);
	}
}
