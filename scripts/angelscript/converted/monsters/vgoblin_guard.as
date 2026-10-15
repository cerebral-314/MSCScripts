#pragma context server

// Converted from monsters/vgoblin_guard.script by msc_transpiler.
// Beefier Vile Goblins
// Less agile, but meaner
// randoms between envnomed axe and shielder

#include "runtime/ScriptEntity.as"
#include "converted/monsters/bgoblin.as"

[script "monsters/vgoblin_guard"]
class VgoblinGuard : BgoblinScript
{
	// Constants
	float DOT_FIRE = 40.0f;

	// Variables (an unset .script variable reads as its own name)
	bool AXE_SWING = false;

	// Variables declared by included files, with the value they start with in this script
	VgoblinGuard()
	{
		NPC_BASE_EXP = "500";
		GOB_JUMPER = false;
		CHARGE_SPEED = 300;
		FREQ_CHARGE = 10.0f;
		GOB_CHARGE_MAX_DIST = 128;
	}

	// unnamed block (first think)
	void VgoblinGuard_FirstThink()
	{
		CAN_FIREBALL = false;

		CAN_FIREBALL = false;

		DROP_GOLD = 1;
		DROP_GOLD_AMT = RandomInt(25, 50);

		ATTACK_HITCHANCE = "80";

		CAN_STUN = true;

		FLINCH_HEALTH = 300.0f;
	}

	// game_parry
	void OnGameParry(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float parryRoll = 0.0f, float accuracyRoll = 0.0f, float parryValue = 0.0f)
	{
		BaseMonsterShared_OnGameParry(attacker, damage, damageType, parryRoll, accuracyRoll, parryValue); // monsters/base_monster_shared
		PlayAnim("critical", ANIM_PARRY);
		PlayRandomSound(0, 10, SOUND_PARRY1, SOUND_PARRY2, SOUND_PARRY3);
		CallEventDelayed(0.75f, "swing_sword"); // counter
	}

	// goblin_spawn
	void OnGoblinSpawn()
	{
		SetName("Vile Goblin Guard");
		SetRace("goblin");
		SetBlood("green");
		SetHealth(1500);
		SetRoam(true);

		SetHearingSensitivity(2);

		if (!NEW_MODEL)
		{
			SetModel("monsters/goblin2.mdl");
			SetWidth(32);
			SetHeight(60);

			SetModelBody(0, 2); // body: 0-Runed 1-Archer 2-Leathers 3-Sniper
			SetModelBody(1, 2); // head: 0-Horns* 1-Spikes* 2-Animal 3-Chief 4-Cowl *redcap
			SetModelBody(2, 0); // weapon: 0-Unarmed 1-Axe 2-wbow 3-sbow 4-sword 5-rAxe 6-sword&shield 7-club 8-knife
			SetModelBody(3, 0); // arrow: on/off

			SetProp(ENT_ME, "skin", 3);
		}
		else
		{
			SetModel("monsters/goblin_new.mdl");
			SetWidth(24);
			SetHeight(50);

			SetModelBody(0, 0); // body: 0-Bare 1-Quiver&Strap
			SetModelBody(1, RandomInt(1, 2)); // head: 0-Bare 1-Horns 2-Animal 3-Chief 4-Rag
			SetModelBody(2, 0); // weapon: 0-Unarmed 1-Axe 2-wbow 3-sbow 4-sword 5-rAxe 6-sword&shield 7-club 8-knife
			SetModelBody(3, 0); // arrow: On/off

			SetProp(ENT_ME, "skin", 2); // 0-norm 1-blood 2-vile
		}

		SetIdleAnim(ANIM_IDLE);
		SetMoveAnim(ANIM_WALK);

		SetDamageTaken("all", 0.75f);
		SetDamageTaken("poison", 0.25f);
		SetDamageTaken("cold", 1.25f);

		CallEventDelayed(0.01f, "gob_guard_set_weapon");
	}

	// gob_guard_set_weapon
	void OnGobGuardSetWeapon()
	{
		F_GOB_TYPE = GOB_TYPE;

		if (Float(F_GOB_TYPE) == 1.0f)
		{
			// raxe
			SetModelBody(2, 1);
			ANIM_ATTACK = ANIM_SMASH;
			ATTACK_HITCHANCE = "80%";
			CAN_STUN = true;
		}

		if (Float(F_GOB_TYPE) == 2.0f)
		{
			// sword&shield
			SetModelBody(2, 6);
			ANIM_ATTACK = ANIM_SWIPE;
			ATTACK_HITCHANCE = "90%";
			SetStat("parry", 120);
			FLINCH_ANIM = "shielddeflect1";
			CAN_STUN = true;
		}
	}

	// swing_axe
	// ANIM_SMASH
	void OnSwingAxe()
	{
		AXE_SWING = true;
		PlayRandomSound(0, 10, SOUND_ATTACK1, SOUND_ATTACK2, SOUND_ATTACK3);
		DoDamageEx(NPCATK_TARGET, ATTACK_HITRANGE, DMG_AXE, ATTACK_HITCHANCE, ENT_ME, ENT_ME, "none", "slash", "dmgevent:swing");
	}

	// swing_dodamage
	// PARAM1=hit:0|1 PARAM2=ent_hit PARAM3=(start) PARAM4=(end)
	void OnSwingDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		// fire axe effect
		ApplyEffect(NPCATK_TARGET, "effects/dot_poison", 10.0f, self, DOT_FIRE);
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		VgoblinGuard_FirstThink();
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
		if (name == "game_parry") { OnGameParry(EntityParam(params, 0), Float(Param(params, 1)), Param(params, 2), Float(Param(params, 3)), Float(Param(params, 4)), Float(Param(params, 5))); return true; }
		if (name == "gob_guard_set_weapon") { OnGobGuardSetWeapon(); return true; }
		if (name == "goblin_spawn") { OnGoblinSpawn(); return true; }
		if (name == "swing_axe") { OnSwingAxe(); return true; }
		if (name == "swing_dodamage") { OnSwingDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5)); return true; }
		return BgoblinScript::DispatchEvent(name, params);
	}
}
