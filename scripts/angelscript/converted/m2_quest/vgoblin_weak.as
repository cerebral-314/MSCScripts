#pragma context server

// Converted from m2_quest/vgoblin_weak.script by msc_transpiler.
// Vile Goblin Fodder
// - Slightly weaker than the blood goblins, but just as rambunctious

#include "runtime/ScriptEntity.as"
#include "converted/monsters/bgoblin.as"

[script "m2_quest/vgoblin_weak"]
class VgoblinWeak : BgoblinScript
{
	// Constants
	float DOT_POISON = 0.0f;

	// Variables (an unset .script variable reads as its own name)
	bool CAN_POISON = false;
	string DROP_ITEM1 = "DROP_ITEM1";

	// Variables declared by included files, with the value they start with in this script
	VgoblinWeak()
	{
		NPC_BASE_EXP = "150";
		DMG_FIREBALL = 20;
		SOUND_FIREBALL = "bullchicken/bc_attack2.wav";
	}

	// goblin_spawn
	void OnGoblinSpawn()
	{
		SetName("Vile Goblin");
		SetHealth(300);
		if (!NEW_MODEL)
		{
			SetModel("monsters/goblin2.mdl");
			SetWidth(32);
			SetHeight(60);
		}
		else
		{
			SetModel("monsters/goblin_new.mdl");
			SetWidth(24);
			SetHeight(50);
		}
		SetRace("goblin");
		SetBlood("green");
		SetRoam(true);

		SetHearingSensitivity(2);

		if (!NEW_MODEL)
		{
			SetModelBody(0, 2); // body: 0-Runed 1-Archer 2-Leathers 3-Sniper
			SetModelBody(1, 4); // head: 0-Horns* 1-Spikes* 2-Animal 3-Chief 4-Cowl *redcap
			SetModelBody(2, 0); // weapon: 0-Unarmed 1-Axe 2-wbow 3-sbow 4-sword 5-rAxe 6-sword&shield 7-club 8-knife
			SetModelBody(3, 0); // arrow: on/off

			SetProp(ENT_ME, "skin", 3);
		}
		else
		{
			SetModelBody(0, 0); // body: 0-Bare 1-Quiver&Strap
			SetModelBody(1, 0); // head: 0-Bare 1-Horns 2-Animal 3-Chief 4-Rag
			SetModelBody(2, 0); // weapon: 0-Unarmed 1-Axe 2-wbow 3-sbow 4-sword 5-rAxe 6-sword&shield 7-club 8-knife
			SetModelBody(3, 0); // arrow: On/off

			SetProp(ENT_ME, "skin", 2); // 0-norm 1-blood 2-vile
		}

		SetIdleAnim(ANIM_IDLE);
		SetMoveAnim(ANIM_WALK);

		SetDamageTaken("poison", 0.5f);
		SetDamageTaken("lightning", 1.5f);

		CallEventDelayed(0.01f, "goblin_set_weapon");
	}

	// goblin_set_weapon
	void OnGoblinSetWeapon(string weaponType = "")
	{
		float myHp = 0.0f;

		if (GOB_TYPE_SET)
			return;
		GOB_TYPE_SET = true;

		F_GOB_TYPE = GOB_TYPE;

		if (weaponType.isEmpty())
		{
			bool doNadda = true;
		}
		else
		{
			F_GOB_TYPE = weaponType;
		}

		if (Float(F_GOB_TYPE) == 1.0f)
		{
			// clubber
			SetDamageTaken("all", 0.75f);
			SetModelBody(2, 7);
			ANIM_ATTACK = ANIM_SMASH;
			ATTACK_HITCHANCE = "75%";
			myHp = HealthOf(ENT_ME) * 1.5f;
			SetHealth(myHp);
			CAN_STUN = false;
		}

		if (Float(F_GOB_TYPE) == 2.0f)
		{
			// enevomed axe
			SetDamageTaken("all", 0.75f);
			SetModelBody(2, 1);
			ANIM_ATTACK = ANIM_SMASH;
			ATTACK_HITCHANCE = "80%";
			myHp = HealthOf(ENT_ME) * 1.25f;
			SetHealth(myHp);
			CAN_STUN = false;
			CAN_POISON = true;
			DROP_ITEM1 = "axes_poison1";
			DROP_ITEM1_CHANCE = "5%";
		}

		if (Float(F_GOB_TYPE) == 3.0f)
		{
			// enevomed sword
			CAN_FIREBALL = true;
			SetModelBody(0, 1);
			SetModelBody(2, 4);
			ANIM_ATTACK = ANIM_SWIPE;
			ATTACK_HITCHANCE = "90%";
			CAN_STUN = false;
			CAN_POISON = true;
			DROP_ITEM1 = "swords_poison1";
			DROP_ITEM1_CHANCE = "5%";
		}
	}

	// toss_fireball
	// Tosses globs of poison instead of fireballs
	void OnTossFireball()
	{
		TOSS_FIREBALL = false;
		// <projectile scriptname> <"view"|(src_origin)> <target|(targ_origin)> <speed> <damage> <cof> <skill|none> //Converted to use new tossprojectile //greatguys1@FEB2022
		TossProjectile("proj_poison_spit2", RelativePosition(Vector3(0, 48, 0)), NPCATK_TARGET, 400, DMG_FIREBALL, 0.5f, "none");
		PlaySound(0, 10, SOUND_FIREBALL);
	}

	// swing_dodamage
	void OnSwingDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		if (!hit)
			return;
		if (!CAN_POISON)
			return;
		if (RandomInt(1, 3) != 1)
			return;
		ApplyEffect(target, "effects/dot_poison", 5, self, DOT_POISON);
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "goblin_set_weapon") { OnGoblinSetWeapon(Param(params, 0)); return true; }
		if (name == "goblin_spawn") { OnGoblinSpawn(); return true; }
		if (name == "swing_dodamage") { OnSwingDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5)); return true; }
		if (name == "toss_fireball") { OnTossFireball(); return true; }
		return BgoblinScript::DispatchEvent(name, params);
	}
}
