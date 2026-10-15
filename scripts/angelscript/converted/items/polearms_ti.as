#pragma context server

// Converted from items/polearms_ti.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/items/polearms_base.as"

[script "items/polearms_ti"]
class PolearmsTi : PolearmsBaseScript
{
	// Constants
	int ICE_BURST_MP = 75;
	bool POLE_POKE1_ENHANCED = true;

	// Variables (an unset .script variable reads as its own name)
	float FREEZE_COUNT = 0.0f;
	float ICE_WAVE_YAW = 0.0f;
	string FREEZE_TARGS = "FREEZE_TARGS";
	CBaseEntity@ REPEAT_TARGET = null;
	CBaseEntity@ OLD_REPEAT_TARGET = null;

	// Variables declared by included files, with the value they start with in this script
	PolearmsTi()
	{
		BASE_LEVEL_REQ = "25";
		VMODEL_IDX = 5;
		PMODEL_FILE = "weapons/p_weapons4.mdl";
		PMODEL_IDX_FLOOR = 13;
		PMODEL_IDX_HANDS = 12;
		MELEE_DMG = 250;
		MELEE_RANGE = "100";
		MELEE_DMG_TYPE = "cold";
		POLE_MAX_DMG_MULTI = 1.75f;
		POLE_CAN_SWIPE = false;
		POLE_CAN_SPIN = false;
		POLE_BACKHAND_DMG = 300;
		POLE_BACKHAND_DMG_TYPE = "pierce";
		POLE_BACKHAND_ACCURACY = "90%";
		POLE_BACKHAND_REPEL = 400;
		POLE_CAN_POWER_THROW = true;
		POLE_THROW_POWER = 1000;
		POLE_THOW_PROJECTILE = "proj_pole_ti";
		SOUND_HITWALL1 = "debris/glass1.wav";
		SOUND_HITWALL2 = "debris/glass2.wav";
	}

	// game_takedamage
	// 50% ice damage reduction
	// PARAM1=attacker  PARAM2=inflictor? PARAM3=dmg PARAM4=dmg_type - use return to alter incoming damage
	string PolearmsTi_OnGameTakedamage(CBaseEntity@ attacker = null, CBaseEntity@ inflictor = null, float damage = 0.0f, string damageType = "")
	{
		string result = "";

		if (ScriptVarOf(ENT_OWNER, "PLR_ACTIVE_WEAPON") != EntityId(self))
			return result;

		if (!Contains(damageType, "ice"))
			return result;
		float inDmg = damage * 0.5f;
		SetDamageInfo("dmg", inDmg);
		result = AppendResult(result, "0.5");
		return result;
	}

	// game_dodamage
	string PolearmsTi_OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		bool exitSub = false;
		string result = "";
		if (!hit)
			return result;
		if (IsPlayer(target) && GAME_PVP == 0)
			exitSub = true;
		if (exitSub)
			return result;

		@REPEAT_TARGET = target;
		if (OLD_REPEAT_TARGET is REPEAT_TARGET)
			FREEZE_COUNT += 1.0f;
		else
			FREEZE_COUNT = 0.0f;
		@OLD_REPEAT_TARGET = target;

		float dotBurn = SkillOf(ENT_OWNER, "spellcasting.ice") * 0.25f;

		if (FREEZE_COUNT < 4.0f)
		{
			ApplyEffect(target, "effects/dot_cold", 5.0f, @EntityOf(ENT_OWNER), dotBurn);
			if (Truthy(ScriptVarOf(target, "I_R_FROZEN")))
				FREEZE_COUNT = 0.0f;
		}
		else
		{
			FREEZE_COUNT = 0.0f;

			if (Truthy(ScriptVarOf(target, "I_R_FROZEN")))
			{
				ApplyEffect(target, "effects/dot_cold", 5.0f, @EntityOf(ENT_OWNER), dotBurn);
				exitSub = true;
			}
			if (!exitSub)
			{
				dotBurn *= 0.25f;
				if (HealthOf(target) < 2000.0f)
					ApplyEffect(target, "effects/dot_cold_freeze", 5.0f, @EntityOf(ENT_OWNER), dotBurn, "spellcasting.ice", 2000);
			}
		}
		return result;
	}

	// polearm_register_attacks
	void OnPolearmRegisterAttacks()
	{
		PolearmsBase_OnPolearmRegisterAttacks(); // items/polearms_base
		// ice burst register
		SetLocal("reg.attack.mpdrain", 0);
		SetLocal("reg.attack.type", "strike-land");
		SetLocal("reg.attack.range", 10);
		SetLocal("reg.attack.dmg", 1);
		SetLocal("reg.attack.dmg.range", 0);
		SetLocal("reg.attack.dmg.type", "cold");
		SetLocal("reg.attack.energydrain", 5);
		SetLocal("reg.attack.stat", "spellcasting.ice");
		SetLocal("reg.attack.hitchance", 100);
		SetLocal("reg.attack.priority", 3);
		SetLocal("reg.attack.delay.strike", 0.1f);
		SetLocal("reg.attack.delay.end", 0.2f);
		SetLocal("reg.attack.ofs.startpos", 0);
		SetLocal("reg.attack.ofs.aimang", 0);
		SetLocal("reg.attack.noise", 5000);
		SetLocal("reg.attack.keys", "-attack1");
		SetLocal("reg.attack.callback", "attack_ice_burst");
		SetLocal("reg.attack.chargeamt", "300%");
		SetLocal("reg.attack.reqskill", 25);
		RegisterAttack();
	}

	// game_takedamage
	string OnGameTakedamage(CBaseEntity@ attacker = null, CBaseEntity@ inflictor = null, float damage = 0.0f, string damageType = "")
	{
		string result = "";
		result = AppendResult(result, PolearmsBase_OnGameTakedamage(attacker, inflictor, damage, damageType));
		result = AppendResult(result, PolearmsTi_OnGameTakedamage(attacker, inflictor, damage, damageType));
		return result;
	}

	// polearm_spawn
	void OnPolearmSpawn()
	{
		SetName("Ice Typhoon");
		SetDescription("A polearm tipped with elemental ice");
		SetWeight(60);
		SetValue(3000);
		SetHudSprite("trade", "184");

		FREEZE_COUNT = 0.0f;
	}

	// pole_poke1_enhance
	void OnPolePoke1Enhance(string hitTarget = "")
	{
		bool exitSub = false;

		if (RandomInt(1, 3) != 1)
			return;
		if (IsPlayer(hitTarget) && GAME_PVP == 0)
			exitSub = true;
		if (exitSub)
			return;

		float dot = SkillOf(ENT_OWNER, "spellcasting.ice") * 0.5f;
		ApplyEffect(hitTarget, "effects/dot_cold", 5.0f, @EntityOf(ENT_OWNER), dot);
	}

	// attack_ice_burst_start
	void OnAttackIceBurstStart()
	{
		PlayViewAnim(VANIM_WIDE);
		PlayOwnerAnim("once", PANIM_SWIPE2, "global.anim.combatwalk", 1);
		DebugPrint("attack_ice_burst_start");
	}

	// attack_ice_burst_strike
	void OnAttackIceBurstStrike(string hitType = "", Vector3 endPos = Vector3(), CBaseEntity@ hitEntity = null, bool hit = false)
	{
		bool exitSub = false;
		DebugPrint("attack_ice_burst_strike");

		if (ManaOf(ENT_OWNER) < ICE_BURST_MP)
		{
			PlayerMessageDark(ENT_OWNER, "Ice Typhoon: Insufficient mana for freezing burst");
			exitSub = true;
		}
		if (exitSub)
			return;

		GiveMana(ENT_OWNER, -ICE_BURST_MP);

		Vector3 burstPos = OriginOf(ENT_OWNER);
		burstPos.z = GroundHeight(burstPos);
		ICE_WAVE_YAW = AnglesOf(ENT_OWNER).y;
		ClientEvent("new", "all", "effects/sfx_ice_wave2", burstPos, ICE_WAVE_YAW, 45);

		// effects/sfx_ice_burst BURST_POS 128 1 (128,128,256)
		Vector3 scanPos = OriginOf(ENT_OWNER);
		scanPos += RelativePosition(Vector3(0, ICE_WAVE_YAW, 0), Vector3(0, 128, 32));

		CallExternal(ENT_OWNER, "ext_sphere_token", "enemy", 512, scanPos);
		FREEZE_TARGS = ScriptVarOf(ENT_OWNER, "PLR_SCAN_TOKEN");
		if (FREEZE_TARGS == "none")
			return;
		int count = GetTokenCount(FREEZE_TARGS);
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnIceBurstAffectTargs();
		}
	}

	// ice_burst_affect_targs
	void OnIceBurstAffectTargs()
	{
		bool exitSub = false;
		bool doFreeze = false;
		string curTarg = GetToken(FREEZE_TARGS, loopIteration);
		if (IsPlayer(curTarg) && GAME_PVP == 0)
			exitSub = true;
		if (exitSub)
			return;

		Vector3 ownerOrg = OriginOf(ENT_OWNER);
		Vector3 ownerAng = Vector3(0, ICE_WAVE_YAW, 0);
		Vector3 targOrg = OriginOf(curTarg);

		if (!WithinCone2D(targOrg, ownerOrg, ownerAng, 100))
			return;

		string traceStart = Text(ownerOrg);
		string traceEnd = Text(targOrg);
		string traceLine = LegacyFunction("get_traceline", traceStart, traceEnd, "worldonly");
		if (traceLine != traceEnd)
			return;

		float maxFreezeHp = MaxHealthOf(ENT_OWNER) * 4.0f;

		if (HealthOf(curTarg) < maxFreezeHp)
			doFreeze = true;
		if (HealthOf(curTarg) < 1500.0f)
			doFreeze = true;

		if (!doFreeze)
		{
			float dot = SkillOf(ENT_OWNER, "spellcasting.ice");
			ApplyEffect(curTarg, "effects/dot_cold", 5.0f, @EntityOf(ENT_OWNER), dot);
		}
		else
		{
			ApplyEffect(curTarg, "effects/dot_cold_freeze", Random(5, 8), @EntityOf(ENT_OWNER), 0, "spellcasting.ice", 1500);
		}
	}

	string OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "") { return PolearmsTi_OnGameDodamage(hit, target, start, end, damageType, damageText); } // game_dodamage

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
		if (name == "attack_ice_burst_start") { OnAttackIceBurstStart(); return true; }
		if (name == "attack_ice_burst_strike") { OnAttackIceBurstStrike(Param(params, 0), Vec(Param(params, 1)), EntityParam(params, 2), Truthy(Param(params, 3))); return true; }
		if (name == "game_dodamage") { Return(OnGameDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5))); return true; }
		if (name == "game_takedamage") { Return(OnGameTakedamage(EntityParam(params, 0), EntityParam(params, 1), Float(Param(params, 2)), Param(params, 3))); return true; }
		if (name == "ice_burst_affect_targs") { OnIceBurstAffectTargs(); return true; }
		if (name == "pole_poke1_enhance") { OnPolePoke1Enhance(Param(params, 0)); return true; }
		if (name == "polearm_register_attacks") { OnPolearmRegisterAttacks(); return true; }
		if (name == "polearm_spawn") { OnPolearmSpawn(); return true; }
		return PolearmsBaseScript::DispatchEvent(name, params);
	}
}
