#pragma context server

// Converted from items/polearms_h.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/items/polearms_base.as"

[script "items/polearms_h"]
class PolearmsH : PolearmsBaseScript
{
	// Constants
	int HOLY_CIRCLE_MP = 200;
	float HOLY_CIRCLE_DURATION = 30.0f;

	// Variables declared by included files, with the value they start with in this script
	PolearmsH()
	{
		BASE_LEVEL_REQ = "30";
		VMODEL_IDX = 4;
		PMODEL_FILE = "weapons/p_weapons4.mdl";
		PMODEL_IDX_FLOOR = 15;
		PMODEL_IDX_HANDS = 14;
		MELEE_DMG = 200;
		MELEE_RANGE = "120";
		MELEE_DMG_TYPE = "holy";
		POLE_MAX_DMG_MULTI = 1.75f;
		POLE_CAN_SWIPE = false;
		POLE_CAN_SPIN = false;
		POLE_BACKHAND_DMG = 150;
		POLE_BACKHAND_DMG_TYPE = "pierce";
		POLE_BACKHAND_ACCURACY = "90%";
		POLE_BACKHAND_REPEL = 500;
		POLE_CAN_POWER_THROW = true;
		POLE_THROW_POWER = 800;
		POLE_THOW_PROJECTILE = "proj_pole_holy";
	}

	// game_takedamage
	// 1: Attacker  2: Inflictor  3: dmg  4: dmg type
	string PolearmsH_OnGameTakedamage(CBaseEntity@ attacker = null, CBaseEntity@ inflictor = null, float damage = 0.0f, string damageType = "")
	{
		bool reduceDmg = false;
		string result = "";
		if (!Truthy(ScriptVarOf(ENT_OWNER, "PLR_HAURA_ACTIVE")))
			return result;
		if (RaceOf(attacker) == "undead")
			reduceDmg = true;
		if (Truthy(ScriptVarOf(attacker, "IS_UNHOLY")))
			reduceDmg = true;

		if (!reduceDmg)
			return result;
		float dmgTaken = damage * 0.5f;
		SetDamageInfo("dmg", dmgTaken);
		result = AppendResult(result, "0.5");
		return result;
	}

	// bweapon_effect_remove
	void OnBweaponEffectRemove(string reason = "")
	{
		BaseItemExtras_OnBweaponEffectRemove(reason); // items/base_item_extras
		PolearmsBase_OnBweaponEffectRemove(reason); // items/polearms_base
		DebugPrint("bweapon_effect_remove");
		CallExternal(ENT_OWNER, "ext_end_holy_aura");
	}

	// polearm_register_attacks
	void OnPolearmRegisterAttacks()
	{
		PolearmsBase_OnPolearmRegisterAttacks(); // items/polearms_base
		// holy circle register
		SetLocal("reg.attack.mpdrain", 0);
		SetLocal("reg.attack.type", "strike-land");
		SetLocal("reg.attack.range", 10);
		SetLocal("reg.attack.dmg", 1);
		SetLocal("reg.attack.dmg.range", 0);
		SetLocal("reg.attack.dmg.type", "holy");
		SetLocal("reg.attack.energydrain", 5);
		SetLocal("reg.attack.stat", "spellcasting.divination");
		SetLocal("reg.attack.hitchance", 100);
		SetLocal("reg.attack.priority", 3);
		SetLocal("reg.attack.delay.strike", 0.1f);
		SetLocal("reg.attack.delay.end", 0.2f);
		SetLocal("reg.attack.ofs.startpos", 0);
		SetLocal("reg.attack.ofs.aimang", 0);
		SetLocal("reg.attack.noise", 5000);
		SetLocal("reg.attack.keys", "-attack1");
		SetLocal("reg.attack.callback", "holy_circle");
		SetLocal("reg.attack.chargeamt", "300%");
		SetLocal("reg.attack.reqskill", 34);
		RegisterAttack();
	}

	// bs_global_command
	void OnBsGlobalCommand(CBasePlayer@ deadPlayer = null, string command = "", string reason = "")
	{
		PolearmsBase_OnBsGlobalCommand(deadPlayer, command, reason); // items/polearms_base
		if (reason != "death")
			return;
		if (deadPlayer !is EntityOf(ENT_OWNER))
			return;
		CallExternal(ENT_OWNER, "ext_end_holy_aura");
	}

	// game_takedamage
	string OnGameTakedamage(CBaseEntity@ attacker = null, CBaseEntity@ inflictor = null, float damage = 0.0f, string damageType = "")
	{
		string result = "";
		result = AppendResult(result, PolearmsBase_OnGameTakedamage(attacker, inflictor, damage, damageType));
		result = AppendResult(result, PolearmsH_OnGameTakedamage(attacker, inflictor, damage, damageType));
		return result;
	}

	// polearm_spawn
	void OnPolearmSpawn()
	{
		SetName("Holy Lance");
		SetDescription("A spear often wielded by Felewyn's Seekers");
		SetWeight(30);
		SetValue(4000);
		SetHudSprite("trade", "78");
	}

	// holy_circle_start
	void OnHolyCircleStart()
	{
		PlayViewAnim(VANIM_WIDE);
		PlayOwnerAnim("once", PANIM_SWIPE2, "global.anim.combatwalk", 1);
		DebugPrint("holy_circle_start");
	}

	// holy_circle_strike
	void OnHolyCircleStrike(string hitType = "", Vector3 endPos = Vector3(), CBaseEntity@ hitEntity = null, bool hit = false)
	{
		bool exitSub = false;

		if (ManaOf(ENT_OWNER) < HOLY_CIRCLE_MP)
		{
			PlayerMessageDark(ENT_OWNER, "Holy Lance: Insufficient Mana for Holy Aura");
			exitSub = true;
		}
		if (exitSub)
			return;

		if (Truthy(ScriptVarOf(ENT_OWNER, "PLR_HAURA_ACTIVE")))
		{
			PlayerMessageDark(ENT_OWNER, "Holy Lance: Holy aura already active");
			exitSub = true;
		}
		if (exitSub)
			return;

		GiveMana(ENT_OWNER, -HOLY_CIRCLE_MP);

		float healPower = Divide(SkillOf(ENT_OWNER, "spellcasting.divination"), 4.0f);

		CallExternal(ENT_OWNER, "ext_holy_aura", HOLY_CIRCLE_DURATION, 128, healPower);
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("weapons/p_weapons4.mdl");
		Precache("viewmodels/v_polearms.mdl");
		Precache("weapons/polearm_spin.wav");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "bs_global_command") { OnBsGlobalCommand(PlayerParam(params, 0), Param(params, 1), Param(params, 2)); return true; }
		if (name == "bweapon_effect_remove") { OnBweaponEffectRemove(Param(params, 0)); return true; }
		if (name == "game_takedamage") { Return(OnGameTakedamage(EntityParam(params, 0), EntityParam(params, 1), Float(Param(params, 2)), Param(params, 3))); return true; }
		if (name == "holy_circle_start") { OnHolyCircleStart(); return true; }
		if (name == "holy_circle_strike") { OnHolyCircleStrike(Param(params, 0), Vec(Param(params, 1)), EntityParam(params, 2), Truthy(Param(params, 3))); return true; }
		if (name == "polearm_register_attacks") { OnPolearmRegisterAttacks(); return true; }
		if (name == "polearm_spawn") { OnPolearmSpawn(); return true; }
		return PolearmsBaseScript::DispatchEvent(name, params);
	}
}
