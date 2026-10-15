#pragma context server

// Converted from items/polearms_ph.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/items/polearms_base.as"

[script "items/polearms_ph"]
class PolearmsPh : PolearmsBaseScript
{
	// Constants
	int ZAP_MP = 20;
	bool POLE_BACKHAND_SPECIAL = true;
	string SOUND_THUNDER = "magic/bolt_end.wav";
	string SOUND_SHOCK1 = "debris/zap8.wav";
	string SOUND_SHOCK2 = "debris/zap3.wav";
	string SOUND_SHOCK3 = "debris/zap4.wav";

	// Variables (an unset .script variable reads as its own name)
	string LIGHTNING_CL_IDX = "LIGHTNING_CL_IDX";

	// Variables declared by included files, with the value they start with in this script
	PolearmsPh()
	{
		BASE_LEVEL_REQ = "25";
		VMODEL_IDX = 2;
		PMODEL_FILE = "weapons/p_weapons4.mdl";
		PMODEL_IDX_FLOOR = 17;
		PMODEL_IDX_HANDS = 16;
		MELEE_DMG = 300;
		MELEE_RANGE = "120";
		MELEE_DMG_TYPE = "lightning";
		POLE_MAX_DMG_MULTI = 1.75f;
		POLE_CAN_SWIPE = false;
		POLE_BACKHAND_DMG = 150;
		POLE_BACKHAND_ACCURACY = "90%";
		POLE_BACKHAND_STUN_CHANCE = "100%";
		POLE_BACKHAND_REPEL = 500;
		POLE_CAN_POWER_THROW = true;
		POLE_THROW_MP = 10;
		POLE_THROW_POWER = 800;
		POLE_THOW_PROJECTILE = "proj_pole_ph";
	}

	// game_dodamage
	string PolearmsPh_OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		bool exitSub = false;
		string result = "";
		if (!hit)
			return result;
		if (IsPlayer(target) && GAME_PVP == 0)
			exitSub = true;
		if (exitSub)
			return result;

		if (RandomInt(1, 3) != 1)
			return result;
		float dotBurn = SkillOf(ENT_OWNER, "spellcasting.lightning") * 1.5f;
		ApplyEffect(target, "effects/dot_lightning", 5.0f, @EntityOf(ENT_OWNER), dotBurn);
		return result;
	}

	// attack_poke2_start
	void OnAttackPoke2Start()
	{
		PolearmsBase_OnAttackPoke2Start(); // items/polearms_base
		ClientEvent("new", "all", "items/polearms_ph_cl", IndexOf(ENT_OWNER));
		LIGHTNING_CL_IDX = LastClientScriptId();
		PlayRandomSound(1, 10, SOUND_SHOCK1, SOUND_SHOCK2, SOUND_SHOCK3);
	}

	// attack_poke2_strike
	// PARAM1: "none"/"npc"/"world"   2: Attack end Position   3: Entity hit (if any)
	void OnAttackPoke2Strike(string hitType = "", Vector3 endPos = Vector3(), CBaseEntity@ hitEntity = null, bool hit = false)
	{
		PolearmsBase_OnAttackPoke2Strike(hitType, endPos, hitEntity, hit); // items/polearms_base
		bool exitSub = false;
		Vector3 beamEnd;
		string beamTarg = "BEAM_TARG";
		// get lightning target
		if (!(SkillOf(ENT_OWNER, "spellcasting.lightning") > 25.0f))
			return;

		if (ManaOf(ENT_OWNER) < ZAP_MP)
		{
			PlayerMessageDark(ENT_OWNER, "Stormpharaoh's Lance: Insufficient mana for Lightning Strike");
			exitSub = true;
		}
		if (exitSub)
			return;

		// trace from end position, and extend
		string traceEnd = Text(endPos);
		Vector3 ownerView = ViewAnglesOf(ENT_OWNER);
		traceEnd = Text(Vec(traceEnd) + RelativePosition(ownerView, Vector3(0, 1024, 0)));

		string traceLine = LegacyFunction("get_traceline", endPos, traceEnd, "ent");

		if (!IsAlive(traceLine))
		{
			beamEnd = Vec(LegacyFunction("get_traceline", endPos, traceEnd, "worldonly"));
		}
		else
		{
			beamTarg = traceLine;
			beamEnd = OriginOf(beamTarg);
			if (!IsPlayer(beamTarg))
				beamEnd.z += 32.0f;
		}

		if (IsPlayer(beamTarg) && GAME_PVP == 0)
			exitSub = true;
		exitSub = true;

		GiveMana(ENT_OWNER, -ZAP_MP);

		ClientEvent("update", "all", LIGHTNING_CL_IDX, "do_lightning", beamEnd);
		PlaySound(0, 10, SOUND_THUNDER);

		if (!IsAlive(beamTarg))
			return;

		float dbeamDmg = SkillOf(ENT_OWNER, "spellcasting.lightning") * 3.0f;
		DoDamageEx(beamTarg, "direct", dbeamDmg, "100%", ENT_OWNER, ENT_ME, "spellcasting.lightning", "lightning");
		float dotShock = SkillOf(ENT_OWNER, "spellcasting.lightning") * 1.5f;
		ApplyEffect(beamTarg, "effects/dot_lightning", 10.0f, @EntityOf(ENT_OWNER), dotShock);
		float pushStr = 500.0f * DamageTakenOf(beamTarg, "lightning");
		AddVelocity(beamTarg, RelativeVelocity(Vector3(0, pushStr, 110)));
	}

	// pole_spin_hold
	void OnPoleSpinHold()
	{
		PolearmsBase_OnPoleSpinHold(); // items/polearms_base
		if (!(SkillOf(ENT_OWNER, "spellcasting.lightning") > 25.0f))
			return;
		CallExternal(ENT_OWNER, "ext_pole_lshield");
	}

	// pole_spin_end
	void OnPoleSpinEnd()
	{
		PolearmsBase_OnPoleSpinEnd(); // items/polearms_base
		CallExternal(ENT_OWNER, "ext_pole_lshield_end", "abort");
	}

	// polearm_spawn
	void OnPolearmSpawn()
	{
		SetName("Stormpharaoh's Lance");
		SetDescription("A spear once hefted by a mighty lord of the dead");
		SetWeight(40);
		SetValue(6000);
		SetHudSprite("trade", "109");
	}

	// pole_backhand_special
	void OnPoleBackhandSpecial(CBaseEntity@ target = null)
	{
		float dot = SkillOf(ENT_OWNER, "spellcasting.lightning") * 0.5f;
		ApplyEffect(target, "effects/dot_lightning", 5.0f, @EntityOf(ENT_OWNER), dot);
	}

	string OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "") { return PolearmsPh_OnGameDodamage(hit, target, start, end, damageType, damageText); } // game_dodamage

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
		if (name == "attack_poke2_start") { OnAttackPoke2Start(); return true; }
		if (name == "attack_poke2_strike") { OnAttackPoke2Strike(Param(params, 0), Vec(Param(params, 1)), EntityParam(params, 2), Truthy(Param(params, 3))); return true; }
		if (name == "game_dodamage") { Return(OnGameDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5))); return true; }
		if (name == "pole_backhand_special") { OnPoleBackhandSpecial(EntityParam(params, 0)); return true; }
		if (name == "pole_spin_end") { OnPoleSpinEnd(); return true; }
		if (name == "pole_spin_hold") { OnPoleSpinHold(); return true; }
		if (name == "polearm_spawn") { OnPolearmSpawn(); return true; }
		return PolearmsBaseScript::DispatchEvent(name, params);
	}
}
