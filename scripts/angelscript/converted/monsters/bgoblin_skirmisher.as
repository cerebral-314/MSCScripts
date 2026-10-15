#pragma context server

// Converted from monsters/bgoblin_skirmisher.script by msc_transpiler.
// Fast moving, aggressive Blood Goblin with a knife

#include "runtime/ScriptEntity.as"
#include "converted/monsters/bgoblin.as"

[script "monsters/bgoblin_skirmisher"]
class BgoblinSkirmisher : BgoblinScript
{
	// Constants
	int DMG_KNIFE = 0;

	// Variables declared by included files, with the value they start with in this script
	BgoblinSkirmisher()
	{
		NPC_BASE_EXP = "350";
		DMG_FIREBALL = 100;
		DMG_FIREBALL_DOT = 25;
		FREQ_FIREBALL = 20.0f;
	}

	// unnamed block (first think)
	void BgoblinSkirmisher_FirstThink()
	{
		CAN_FIREBALL = true;

		DROP_GOLD = 1;
		DROP_GOLD_AMT = RandomInt(25, 50);
		BASE_FRAMERATE = "2.0";
		ATTACK_HITCHANCE = "80";

		CAN_STUN = false;
		FLINCH_HEALTH = 200.0f;
	}

	// game_struck
	void OnGameStruck(float damage = 0.0f, string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		BaseNpc_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseNpcAttackNew_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc_attack_new
		BaseMonsterShared_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared
		Bgoblin_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/bgoblin
		if (!(damage > 50.0f))
			return;
		if (RandomInt(1, 5) != 1)
			return;
		OnJumpAway();
	}

	// goblin_spawn
	void OnGoblinSpawn()
	{
		SetName("Blood Goblin Skirmisher");
		SetRace("goblin");
		SetBlood("red"); // green for v_goblin
		SetHealth(1000);
		SetRoam(true);

		SetHearingSensitivity(4);

		SetAnimFrameRate(2);

		if (!NEW_MODEL)
		{
			SetModel("monsters/goblin2.mdl");
			SetWidth(32);
			SetHeight(60);

			SetModelBody(0, 1); // body: 0-Bare 1-Archer 2-Armor 3-Sniper
			SetModelBody(1, 4); // head: 0-Horns 1-Spikes 2-Animal 3-Chief 4-Cowl
			SetModelBody(2, 8); // weapon: 0-Unarmed 1-Axe 2-wbow 3-sbow 4-sword 5-rAxe 6-sword&shield 7-club 8-knife
			SetModelBody(3, 0); // arrow: on/off

			SetProp(ENT_ME, "skin", 2);
		}
		else
		{
			SetModel("monsters/goblin_new.mdl");
			SetWidth(24);
			SetHeight(50);

			SetModelBody(0, 1); // body: 0-Bare 1-Quiver&Strap
			SetModelBody(1, 4); // head: 0-Bare 1-Horns 2-Animal 3-Chief 4-Rag
			SetModelBody(2, 8); // weapon: 0-Unarmed 1-Axe 2-wbow 3-sbow 4-sword 5-rAxe 6-sword&shield 7-club 8-knife
			SetModelBody(3, 0); // arrow: On/off

			SetProp(ENT_ME, "skin", 1); // 0-norm 1-blood 2-vile
		}

		SetIdleAnim(ANIM_IDLE);
		SetMoveAnim(ANIM_WALK);

		SetDamageTaken("fire", 0.25f); // blood goblins only
		SetDamageTaken("cold", 1.25f);

		ANIM_ATTACK = "swordswing1_L";
	}

	// swing_axe
	void OnSwingAxe()
	{
		PlayRandomSound(0, 10, SOUND_ATTACK1, SOUND_ATTACK2, SOUND_ATTACK3);
		DoDamage(NPCATK_TARGET, ATTACK_HITRANGE, DMG_KNIFE, ATTACK_HITCHANCE, "slash");
	}

	// swing_sword
	void OnSwingSword()
	{
		if (TOSS_FIREBALL)
		{
			TOSS_FIREBALL = false;

			// <projectile scriptname> <"view"|(src_origin)> <target|(targ_origin)|none> <speed> <damage> <cof> <skill|none> //Converted to use new tossprojectile //greatguys1@FEB2022
			TossProjectile("proj_fire_ball", RelativePosition(Vector3(0, 48, 0)), NPCATK_TARGET, 400, DMG_FIREBALL, 0.5f, "none");
			CallExternal(ENT_LASTPROJECTILE, "lighten", DMG_FIREBALL_DOT, 0.01f);
			PlaySound(0, 10, SOUND_FIREBALL);
		}
		if (TOSS_FIREBALL)
			return;
		PlayRandomSound(0, 10, SOUND_ATTACK1, SOUND_ATTACK2, SOUND_ATTACK3);
		DoDamage(NPCATK_TARGET, ATTACK_HITRANGE, DMG_KNIFE, ATTACK_HITCHANCE, "pierce");
	}

	// gob_jump_check
	void OnGobJumpCheck()
	{
		if (!GOB_JUMP_SCANNING)
			return;
		float gobHopDelay = Random(2, 4);
		CallEventDelayed(gobHopDelay, "gob_jump_check");

		// no jumpy if in stabby range
		if (!(RangeTo(NPCATK_TARGET) > ATTACK_HITRANGE))
			return;

		if (NPCATK_TARGET == "unset")
			return;
		if (I_R_FROZEN)
			return;
		if (IS_FLEEING)
			return;
		if (!(RangeTo(NPCATK_TARGET) < GOBLIN_JUMPRANGE))
			return;

		// jump at target if he's higher than I am
		Vector3 mePos = MyOrigin();
		float myZ = mePos.z;
		Vector3 targetPos = OriginOf(NPCATK_TARGET);
		float targetZ = targetPos.z;
		float targetZDifference = targetZ - myZ;

		if (targetZDifference > 0.0f)
		{
			if (targetZDifference < 500.0f) // not hoplessly high up
			{
				PlayAnim("critical", ANIM_SMASH);
				CallEventDelayed(0.1f, "gob_hop");
			}
		}
	}

	// jump_away
	void OnJumpAway()
	{
		OnNpcatkFlee(EntityId(EntityOf(ENT_LASTSTRUCK)), "100", "1.0");
		CallEventDelayed(0.1f, "gob_hop");
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		BgoblinSkirmisher_FirstThink();
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
		if (name == "game_struck") { OnGameStruck(Float(Param(params, 0)), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "gob_jump_check") { OnGobJumpCheck(); return true; }
		if (name == "goblin_spawn") { OnGoblinSpawn(); return true; }
		if (name == "jump_away") { OnJumpAway(); return true; }
		if (name == "swing_axe") { OnSwingAxe(); return true; }
		if (name == "swing_sword") { OnSwingSword(); return true; }
		return BgoblinScript::DispatchEvent(name, params);
	}
}
