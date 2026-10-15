#pragma context server

// Converted from orc_for/goblin_sa.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/orc_for/tiers1.as"
#include "converted/orc_for/goblin_base.as"

[script "orc_for/goblin_sa"]
class GoblinSa : GoblinBaseScript, Tiers1
{
	// Constants
	int NPC_CAP_EXP = 750;

	// Variables (an unset .script variable reads as its own name)
	bool GOB_TYPE_SET = false;
	string F_GOB_TYPE = "F_GOB_TYPE";
	string ATTACK_HITCHANCE = "ATTACK_HITCHANCE";
	string STUN_CHANCE = "STUN_CHANCE";
	bool STUN_ATTACK = false;

	// Variables declared by included files, with the value they start with in this script
	GoblinSa()
	{
		NPC_BASE_EXP = "75";
		DMG_CLUB = 20;
		DMG_AXE = 30.0f;
		DMG_SWORD = 15.0f;
		NPC_SELF_ADJUST = true; // from orc_for/tiers1
		NPC_ADJ_DMG_MUTLI_TOKENS = "1.0;1.5;2.0;5.0;7.5;10.0;"; // from orc_for/tiers1
		NPC_ADJ_HP_MUTLI_TOKENS = "1.0;2.0;3.0;5.0;7.5;10.0;"; // from orc_for/tiers1
	}

	// game_dodamage
	string GoblinSa_OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";
		if (hit && STUN_ATTACK)
			if (RandomInt(1, 100) < Float(STUN_CHANCE)) {}
		STUN_ATTACK = false;
		return result;
	}

	// game_dodamage
	string OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";
		result = AppendResult(result, BaseNpcAttackNew_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BaseAntiStuck_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BaseMonsterShared_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, GoblinSa_OnGameDodamage(hit, target, start, end, damageType, damageText));
		return result;
	}

	// goblin_spawn
	void OnGoblinSpawn()
	{
		GoblinBase_OnGoblinSpawn(); // orc_for/goblin_base
		SetName("Goblin Warrior");
		SetModel("monsters/goblin_new.mdl");
		SetHealth(100);
		SetWidth(24);
		SetHeight(50);
		SetRace("goblin");
		SetBlood("red");
		SetRoam(true);
		SetHearingSensitivity(2);
		SetModelBody(0, 0); // body: 0-Bare 1-Quiver&Strap
		SetModelBody(1, 0); // head: 0-Bare 1-Horns 2-Animal 3-Chief 4-Rag
		SetModelBody(2, 0); // weapon: 0-Unarmed 1-Axe 2-wbow 3-sbow 4-sword 5-rAxe 6-sword&shield 7-club 8-knife
		SetModelBody(3, 0); // arrow: On/off

		SetIdleAnim(ANIM_IDLE);
		SetMoveAnim(ANIM_WALK);
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
			SetModelBody(2, 7);
			ANIM_ATTACK = ANIM_SMASH;
			ATTACK_HITCHANCE = "70%";
			STUN_CHANCE = "25%";
			myHp = MaxHealthOf(ENT_ME) * 1.5f;
			SetHealth(myHp);
		}

		if (Float(F_GOB_TYPE) == 2.0f)
		{
			// axe
			SetModelBody(2, 1);
			ANIM_ATTACK = ANIM_SMASH;
			ATTACK_HITCHANCE = "75%";
			myHp = MaxHealthOf(ENT_ME) * 1.25f;
			SetHealth(myHp);
		}

		if (Float(F_GOB_TYPE) == 3.0f)
		{
			// sword
			SetModelBody(0, 0);
			SetModelBody(2, 4);
			ANIM_ATTACK = ANIM_SWIPE;
			ATTACK_HITCHANCE = "80%";
		}
	}

	// swing_axe
	// ANIM_SMASH
	void OnSwingAxe()
	{
		PlayRandomSound(0, 10, SOUND_ATTACK1, SOUND_ATTACK2, SOUND_ATTACK3);
		if (Float(F_GOB_TYPE) == 1.0f)
		{
			STUN_ATTACK = true;
			DoDamage(NPCATK_TARGET, ATTACK_HITRANGE, DMG_CLUB, ATTACK_HITCHANCE, "blunt");
		}
		if (Float(F_GOB_TYPE) == 2.0f)
			DoDamage(NPCATK_TARGET, ATTACK_HITRANGE, DMG_AXE, ATTACK_HITCHANCE, "slash");
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/goblin_new.mdl");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		Tiers1_FirstThink();
		GoblinBase_FirstThink();
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
		if (name == "game_dodamage") { Return(OnGameDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5))); return true; }
		if (name == "goblin_set_weapon") { OnGoblinSetWeapon(Param(params, 0)); return true; }
		if (name == "goblin_spawn") { OnGoblinSpawn(); return true; }
		if (name == "swing_axe") { OnSwingAxe(); return true; }
		return GoblinBaseScript::DispatchEvent(name, params);
	}
}
