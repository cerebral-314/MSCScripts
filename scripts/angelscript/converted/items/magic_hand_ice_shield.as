#pragma context server

// Converted from items/magic_hand_ice_shield.script by msc_transpiler.
// Ice Shield
// Level req: 5
// 50% damage reduction

#include "runtime/ScriptEntity.as"
#include "converted/items/magic_hand_base.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class MagicHandIceShield
{
	// Constants
	bool NO_REGISTER = true;
	string SOUND_SHOOT = "magic/cast.wav";
	int ICESHIELD_RANGE = 389;
	float MELEE_ATK_DURATION = 0.65f;
	int MANA_COST = 50;
	float ICESHIELD_FORMULA = 0.5f;
	string SPELL_SCRIPT = "effects/iceshield";

	// Variables (an unset .script variable reads as its own name)
	float LAST_ATTACK = 0.0f;

	// spell_spawn
	void MagicHandIceShield_OnSpellSpawn()
	{
		SetName("Ice Shield");
		SetDescription("Provides 50% damage reduction for you or allies, for a time.");

		LAST_ATTACK = GameTime() + MELEE_ATK_DURATION;
	}

	// game_attack1
	void MagicHandIceShield_OnGameAttack1()
	{
		float timeDiff = GameTime() - LAST_ATTACK;

		if (!(timeDiff > MELEE_ATK_DURATION))
			return;

		LAST_ATTACK = GameTime();

		PlayViewAnim(Int(ANIM_CAST));
		PlayOwnerAnim("critical", PLAYERANIM_PREPARE, "squatwalk1");

		if (ManaOf(ENT_OWNER) < MANA_COST)
			PlayerMessageDark(ENT_OWNER, "Insufficient mana.");
		if (!(ManaOf(ENT_OWNER) >= MANA_COST))
			return;

		// local SPELL_TARGET $get(ent_owner,target)
		string spellTarget = OnFuncGetRayTarget(ENT_OWNER, ICESHIELD_RANGE);

		// is this target valid, if not, make owner target
		if (!IsAlive(spellTarget))
			spellTarget = EntityId(EntityOf(ENT_OWNER));
		if (!IsPlayer(spellTarget) && RelationshipOf(ENT_OWNER, spellTarget) != "ally")
			spellTarget = EntityId(EntityOf(ENT_OWNER));

		int finalDuration = 150;
		if (EntityOf(spellTarget) !is EntityOf(ENT_OWNER))
			finalDuration = 412;

		GiveMana(-MANA_COST);
		CallExternal(ENT_OWNER, "mana_drain"); // update mana on player hud readout, if using hud feedback

		bool alreadyShielded = HasEffect(spellTarget, "iceshield");
		if (alreadyShielded) // If target is already shielded, refresh their duration.
		{
			CallExternal(spellTarget, "ext_refresh_ice_shield", finalDuration, @EntityOf(ENT_OWNER)); // <duration> <shielder>
		}
		else
		{
			ApplyEffect(spellTarget, SPELL_SCRIPT, finalDuration, @EntityOf(ENT_OWNER), ICESHIELD_FORMULA); // <duration> <shielder> <damage_reduction>
		}
	}

	// func_get_ray_target
	// <player> <range> returns eyetarget entity
	string MagicHandIceShield_OnFuncGetRayTarget(string player = "", float range = 0.0f)
	{
		string result = "";
		CBaseEntity@ plrId = EntityOf(player);
		Vector3 plrOrg = EyePositionOf(player);
		Vector3 plrAng = ViewAnglesOf(player);
		if (Float(GetProp(player, "sitting")) == 1.0f) // account for where eyes are
			plrOrg.z += -27.0f;
		string traceStart = Text(plrOrg);
		string traceEnd = Text(plrOrg);
		traceEnd = Text(Vec(traceEnd) + RelativePosition(plrAng, Vector3(0, range, 0)));
		string tracedLine = LegacyFunction("get_traceline", traceStart, traceEnd, "ent", @plrId);

		// DEBUG
		// effect beam point laserbeam.spr 20 TRACE_START TRACE_END (255,255,0) 255 0.7 30
		result = "";
		result = AppendResult(result, tracedLine);
		return result;
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)
	void OnSpellSpawn() { MagicHandIceShield_OnSpellSpawn(); } // spell_spawn
	void OnGameAttack1() { MagicHandIceShield_OnGameAttack1(); } // game_attack1
	string OnFuncGetRayTarget(string player = "", float range = 0.0f) { return MagicHandIceShield_OnFuncGetRayTarget(player, range); } // func_get_ray_target

	// This file's events and timers by their .script names
	bool MagicHandIceShield_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "func_get_ray_target") { Return(OnFuncGetRayTarget(Param(params, 0), Float(Param(params, 1)))); return true; }
		if (name == "game_attack1") { OnGameAttack1(); return true; }
		if (name == "spell_spawn") { OnSpellSpawn(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "items/magic_hand_ice_shield"]
shared class MagicHandIceShieldScript : MagicHandBaseScript, MagicHandIceShield
{
	// Variables every script that includes this file declares
	bool CSKILL_REQ = false;
	int SPELL_MPDRAIN = 0;

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return MagicHandIceShield_DispatchEvent(name, params)
			|| MagicHandBaseScript::DispatchEvent(name, params);
	}
}
