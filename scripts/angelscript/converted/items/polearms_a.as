#pragma context server

// Converted from items/polearms_a.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/items/polearms_base.as"

[script "items/polearms_a"]
class PolearmsA : PolearmsBaseScript
{
	// Constants
	int VENOM_BURST_MP = 50;

	// Variables declared by included files, with the value they start with in this script
	PolearmsA()
	{
		BASE_LEVEL_REQ = "30";
		VMODEL_IDX = 14;
		PMODEL_FILE = "weapons/p_weapons4.mdl";
		PMODEL_IDX_FLOOR = 31;
		PMODEL_IDX_HANDS = 30;
		MELEE_DMG = 350;
		MELEE_RANGE = "120";
		MELEE_DMG_TYPE = "acid";
		POLE_MAX_DMG_MULTI = 2.0f;
		POLE_CAN_SWIPE = false;
		POLE_CAN_SPIN = false;
		POLE_BACKHAND_DMG = 150;
		POLE_BACKHAND_DMG_TYPE = "pierce";
		POLE_BACKHAND_ACCURACY = "90%";
		POLE_BACKHAND_REPEL = 500;
		POLE_CAN_POWER_THROW = true;
		POLE_THROW_POWER = 700;
		POLE_THOW_PROJECTILE = "proj_pole_a";
	}

	// attack_poke1_damaged_other
	string PolearmsA_OnAttackPoke1DamagedOther(CBaseEntity@ target = null, float damage = 0.0f, string damageType = "", string damageEvent = "")
	{
		bool exitSub = false;
		string result = "";

		if (RandomInt(1, 4) != 1)
			return result;

		if (GAME_PVP == 0 && IsPlayer(target))
			exitSub = true;
		if (exitSub)
			return result;

		float dotBurn = SkillOf(ENT_OWNER, "spellcasting.affliction") * 0.25f;
		ApplyEffect(target, "effects/dot_acid", 5.0f, @EntityOf(ENT_OWNER), dotBurn, "none");
		return result;
	}

	// game_deploy
	void OnGameDeploy()
	{
		BaseItemExtras_OnGameDeploy(); // items/base_item_extras
		BaseItemExtras_OnGameDeploy_2(); // items/base_item_extras
		BaseItemExtras_OnGameDeploy_3(); // items/base_item_extras
		PolearmsBase_OnGameDeploy(); // items/polearms_base
		CallExternal(ENT_OWNER, "ext_alance_init");
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
		SetLocal("reg.attack.dmg.type", "acid");
		SetLocal("reg.attack.energydrain", 5);
		SetLocal("reg.attack.stat", "spellcasting.affliction");
		SetLocal("reg.attack.hitchance", 100);
		SetLocal("reg.attack.priority", 3);
		SetLocal("reg.attack.delay.strike", 0.1f);
		SetLocal("reg.attack.delay.end", 0.2f);
		SetLocal("reg.attack.ofs.startpos", 0);
		SetLocal("reg.attack.ofs.aimang", 0);
		SetLocal("reg.attack.noise", 5000);
		SetLocal("reg.attack.keys", "-attack1");
		SetLocal("reg.attack.callback", "venom_burst");
		SetLocal("reg.attack.chargeamt", "300%");
		SetLocal("reg.attack.reqskill", 30);
		RegisterAttack();
	}

	// attack_poke1_damaged_other
	string OnAttackPoke1DamagedOther(CBaseEntity@ target = null, float damage = 0.0f, string damageType = "", string damageEvent = "")
	{
		string result = "";
		result = AppendResult(result, PolearmsBase_OnAttackPoke1DamagedOther(target, damage, damageType, damageEvent));
		result = AppendResult(result, PolearmsBase_OnAttackPoke1DamagedOther_2(target, damage, damageType, damageEvent));
		result = AppendResult(result, PolearmsA_OnAttackPoke1DamagedOther(target, damage, damageType, damageEvent));
		return result;
	}

	// attack_poke2_damaged_other
	void OnAttackPoke2DamagedOther(CBaseEntity@ target = null, float damage = 0.0f, string damageType = "", string damageEvent = "")
	{
		PolearmsBase_OnAttackPoke2DamagedOther(target, damage, damageType, damageEvent); // items/polearms_base
		bool exitSub = false;
		if (GAME_PVP == 0 && IsPlayer(target))
			exitSub = true;
		if (exitSub)
			return;

		float dotBurn = SkillOf(ENT_OWNER, "spellcasting.affliction") * 0.5f;
		ApplyEffect(target, "effects/dot_acid", 5.0f, @EntityOf(ENT_OWNER), dotBurn, "none");
	}

	// polearm_spawn
	void OnPolearmSpawn()
	{
		SetName("Lance of Affliction");
		SetDescription("An accursed lance of profane magic");
		SetWeight(30);
		SetValue(5000);
		SetHudSprite("trade", "57");
	}

	// venom_burst_start
	void OnVenomBurstStart()
	{
		PlayViewAnim(VANIM_WIDE);
		PlayOwnerAnim("once", PANIM_SWIPE2, "global.anim.combatwalk", 1);
		DebugPrint("holy_circle_start");
	}

	// venom_burst_strike
	void OnVenomBurstStrike(string hitType = "", Vector3 endPos = Vector3(), CBaseEntity@ hitEntity = null, bool hit = false)
	{
		bool exitSub = false;

		if (ManaOf(ENT_OWNER) < VENOM_BURST_MP)
		{
			PlayerMessageDark(ENT_OWNER, "Affliction Lance: Insufficient Mana for Venom Burst");
			exitSub = true;
		}
		if (exitSub)
			return;

		GiveMana(ENT_OWNER, -VENOM_BURST_MP);

		Vector3 burstTargOrg = OriginOf(ENT_OWNER);
		ClientEvent("new", "all", "effects/sfx_poison_explode", burstTargOrg, 256);
		DoDamageEx(burstTargOrg, 512, SkillOf(ENT_OWNER, "spellcasting.affliction"), 0.1f, ENT_OWNER, ENT_ME, "spellcasting.affliction", "poison", "dmgevent:alance");
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
		if (name == "attack_poke1_damaged_other") { Return(OnAttackPoke1DamagedOther(EntityParam(params, 0), Float(Param(params, 1)), Param(params, 2), Param(params, 3))); return true; }
		if (name == "attack_poke2_damaged_other") { OnAttackPoke2DamagedOther(EntityParam(params, 0), Float(Param(params, 1)), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_deploy") { OnGameDeploy(); return true; }
		if (name == "polearm_register_attacks") { OnPolearmRegisterAttacks(); return true; }
		if (name == "polearm_spawn") { OnPolearmSpawn(); return true; }
		if (name == "venom_burst_start") { OnVenomBurstStart(); return true; }
		if (name == "venom_burst_strike") { OnVenomBurstStrike(Param(params, 0), Vec(Param(params, 1)), EntityParam(params, 2), Truthy(Param(params, 3))); return true; }
		return PolearmsBaseScript::DispatchEvent(name, params);
	}
}
