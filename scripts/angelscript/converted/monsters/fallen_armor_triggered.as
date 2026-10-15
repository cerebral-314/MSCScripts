#pragma context server

// Converted from monsters/fallen_armor_triggered.script by msc_transpiler.
// new AI

#include "runtime/ScriptEntity.as"
#include "converted/monsters/fallen_armor.as"

[script "monsters/fallen_armor_triggered"]
class FallenArmorTriggered : FallenArmorScript
{
	// armor_spawn
	void OnArmorSpawn()
	{
		SetName("Armor of the Fallen");
		SetHealth(6000);
		SetWidth(32);
		SetHeight(96);
		SetRace("demon");
		SetModel("monsters/enemy.mdl");

		SetHearingSensitivity(11);

		SetIdleAnim(ANIM_SIT_IDLE);
		SetMoveAnim(ANIM_SIT_IDLE);

		PlayAnim("once", ANIM_SIT_IDLE);

		SetStat("parry", 30);

		SetInvincible(true); // invincible until combat begins
		SetDamageTaken("all", 0.1f);
		SetDamageTaken("fire", 0.5f);
		SetDamageTaken("lightning", 1.5f);
		SetDamageTaken("cold", 0.8f);
		SetDamageTaken("poison", 0);
		SetDamageTaken("holy", 1.5f);

		WAITING_FOR_PLAYER = true;
		OnNpcatkSuspendAi(); // suspend AI until combat begins
	}

	// armor_heardsound
	void OnArmorHeardsound()
	{
	}

	// enter_combat
	void OnEnterCombat()
	{
		if (!WAITING_FOR_PLAYER)
			return;

		WAITING_FOR_PLAYER = false;
		Look();
		FIRST_TARGET = EntityId(EntityOf(ENT_LASTSEEN));

		SetIdleAnim(ANIM_IDLE);
		SetMoveAnim(ANIM_WALK);
		TOSHIELD_DELAY = Random(10, 30);
		CallEventDelayed(TOSHIELD_DELAY, "setup_shield_check");
		PlayAnim("critical", ANIM_GETUP);
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "armor_heardsound") { OnArmorHeardsound(); return true; }
		if (name == "armor_spawn") { OnArmorSpawn(); return true; }
		if (name == "enter_combat") { OnEnterCombat(); return true; }
		return FallenArmorScript::DispatchEvent(name, params);
	}
}
