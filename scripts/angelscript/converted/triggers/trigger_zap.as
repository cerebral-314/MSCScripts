#pragma context server

// Converted from triggers/trigger_zap.script by msc_transpiler.
// Targetname [PARAM2] = name to use
// target [PARAM3] = damage

#include "runtime/ScriptEntity.as"
#include "converted/other/trigger_base.as"

[script "triggers/trigger_zap"]
class TriggerZap : OtherTriggerBaseScript
{
	// apply_damage
	void OnApplyDamage(CBaseEntity@ target = null)
	{
		if (!IsPlayer(target))
			return;

		DebugPrint("apply_damage tim " + EFFECT_TIME + " dmg " + EFFECT_DAMAGE);

		// applyeffect PARAM1 effects/dot_lightning EFFECT_TIME GAME_MASTER EFFECT_DAMAGE
		DoDamageEx(@target, "direct", EFFECT_DAMAGE, "100%", GetVar("GAME_MASTER"), GetVar("GAME_MASTER"), "none", "lightning");
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "apply_damage") { OnApplyDamage(EntityParam(params, 0)); return true; }
		return OtherTriggerBaseScript::DispatchEvent(name, params);
	}
}
