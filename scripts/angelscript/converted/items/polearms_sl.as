#pragma context server

// Converted from items/polearms_sl.script by msc_transpiler.
// � Shadow Lance (Polearms 35, Affliction 15)
// - From Echo717's [url=http://www.msremake.com/forums/viewtopic.php?f=52&t=9382]media contest entry[/url] (finally).
// - This sinious lance does dark damage, and can apply a defile effect that reduces enemy's damage output and does damage over time.
// - This can be applied with a power attack, by throwing the lance, or by using the third charge, providing a large burst that also repells nearby enemies.

#include "runtime/ScriptEntity.as"
#include "converted/items/polearms_base.as"

[script "items/polearms_sl"]
class PolearmsSl : PolearmsBaseScript
{
	// Constants
	int MP_SHADOWBURST = 100;

	// Variables declared by included files, with the value they start with in this script
	PolearmsSl()
	{
		BASE_LEVEL_REQ = "35";
		VMODEL_IDX = 16;
		PMODEL_FILE = "weapons/p_weapons4.mdl";
		PMODEL_IDX_HANDS = 60;
		PMODEL_IDX_FLOOR = 61;
		MELEE_DMG = 250;
		MELEE_RANGE = "120";
		MELEE_DMG_TYPE = "dark";
		POLE_MAX_DMG_MULTI = 2.0f;
		POLE_CAN_SWIPE = false;
		POLE_CAN_SPIN = false;
		POLE_BACKHAND_DMG_TYPE = "dark";
		POLE_BACKHAND_ACCURACY = "90%";
		POLE_BACKHAND_REPEL = 500;
		POLE_CAN_POWER_THROW = true;
		POLE_THROW_POWER = 700;
		POLE_THOW_PROJECTILE = "proj_pole_sl";
		POLE_THROW_MP = 10;
	}

	// polearm_register_attacks
	void OnPolearmRegisterAttacks()
	{
		PolearmsBase_OnPolearmRegisterAttacks(); // items/polearms_base
		SetLocal("reg.attack.mpdrain", MP_SHADOWBURST);
		SetLocal("reg.attack.type", "strike-land");
		SetLocal("reg.attack.range", 10);
		SetLocal("reg.attack.dmg", 1);
		SetLocal("reg.attack.dmg.range", 0);
		SetLocal("reg.attack.dmg.type", "dark");
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
		SetLocal("reg.attack.callback", "shadow_burst");
		SetLocal("reg.attack.chargeamt", "300%");
		SetLocal("reg.attack.reqskill", 30);
		RegisterAttack();
	}

	// attack_poke2_damaged_other
	void OnAttackPoke2DamagedOther(CBaseEntity@ target = null, float damage = 0.0f, string damageType = "", string damageEvent = "")
	{
		PolearmsBase_OnAttackPoke2DamagedOther(target, damage, damageType, damageEvent); // items/polearms_base
		DebugPrint("attack_poke2_damaged_other");
		if (IsPlayer(target) && GAME_PVP == 0)
			return;
		float dotSkill = SkillOf(ENT_OWNER, "spellcasting.affliction") * 0.5f;
		ApplyEffect(target, "effects/dot_dark", 5.0f, @EntityOf(ENT_OWNER), dotSkill, "polearms");
	}

	// polearm_spawn
	void OnPolearmSpawn()
	{
		SetName("Shadow Lance");
		SetDescription("A sinuous lance of destructive energies");
		SetWeight(30);
		SetValue(5000);
		SetHudSprite("trade", "196");
	}

	// shadow_burst_start
	void OnShadowBurstStart()
	{
		bool reqsMet = true;
		if (ManaOf(ENT_OWNER) < MP_SHADOWBURST)
			reqsMet = false;
		if (SkillOf(ENT_OWNER, "spellcasting.affliction") < 15.0f)
		{
			PlayerMessageDark(ENT_OWNER, "Shadowlance: Insufficient Affliction skill for Defiling Burst.");
			reqsMet = false;
		}

		if (reqsMet)
		{
			PlayItemViewAnim(ENT_ME, VANIM_WIDE);
			PlayOwnerAnim("once", PANIM_SWIPE2, "global.anim.combatwalk", 1);
		}
		else
		{
			CancelAttack();
		}
	}

	// shadow_burst_strike
	void OnShadowBurstStrike(string hitType = "", Vector3 endPos = Vector3(), CBaseEntity@ hitEntity = null, bool hit = false)
	{
		// givemp ent_owner $neg(VENOM_BURST_MP)
		Vector3 burstOrg = OriginOf(ENT_OWNER);
		burstOrg.z += -34.0f;
		if (Truthy(GetProp(ENT_OWNER, "ducking")))
			burstOrg.z += 24.0f;
		CallExternal(ENT_OWNER, "ext_dburst", burstOrg, 170, 1, 1);
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
		if (name == "attack_poke2_damaged_other") { OnAttackPoke2DamagedOther(EntityParam(params, 0), Float(Param(params, 1)), Param(params, 2), Param(params, 3)); return true; }
		if (name == "polearm_register_attacks") { OnPolearmRegisterAttacks(); return true; }
		if (name == "polearm_spawn") { OnPolearmSpawn(); return true; }
		if (name == "shadow_burst_start") { OnShadowBurstStart(); return true; }
		if (name == "shadow_burst_strike") { OnShadowBurstStrike(Param(params, 0), Vec(Param(params, 1)), EntityParam(params, 2), Truthy(Param(params, 3))); return true; }
		return PolearmsBaseScript::DispatchEvent(name, params);
	}
}
