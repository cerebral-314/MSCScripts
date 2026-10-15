#pragma context server

// Converted from items/bows_firebird.script by msc_transpiler.
// Phoenix Bow. CrazyMonkeyDude Oct 2009
// Shoots projectiles that explode when they hit the ground.
// Damage increases as range increases (Max distance 1024)

#include "runtime/ScriptEntity.as"
#include "converted/items/bows_base.as"

[script "items/bows_firebird"]
class BowsFirebird : BowsBaseScript
{
	// Constants
	string BASE_LEVEL_REQ = "25";
	int MODEL_VIEW_IDX = 7;
	bool CUSTOM_ATTACK = true;

	// Variables declared by included files, with the value they start with in this script
	BowsFirebird()
	{
		MODEL_VIEW = "viewmodels/v_bows.mdl";
		MODEL_HANDS = "weapons/p_weapons3.mdl";
		MODEL_WORLD = "weapons/p_weapons3.mdl";
		MODEL_WEAR = "weapons/p_weapons3.mdl";
		SOUND_SHOOT = "weapons/bow/bow.wav";
		ITEM_NAME = "longbow";
		ANIM_PREFIX = "standard";
		MODEL_BODY_OFS = "40";
	}

	// bow_spawn
	void OnBowSpawn()
	{
		SetName("Phoenix Bow");
		SetDescription("A magical bow that shoots explosive projectiles.");
		SetWeight(100);
		SetValue(1500);
		SetHudSprite("trade", "129");

		OnCustomRegister();
	}

	// custom_register
	void OnCustomRegister()
	{
		SetLocal("reg.attack.type", "charge-throw-projectile");
		SetLocal("reg.attack.keys", "+attack1");
		SetLocal("reg.attack.hold_min&max", "1.1;1.3");
		SetLocal("reg.attack.dmg.type", "magic");
		SetLocal("reg.attack.range", 1324);
		SetLocal("reg.attack.energydrain", 1);
		SetLocal("reg.attack.stat", "archery");
		SetLocal("reg.attack.COF", "1;1");
		SetLocal("reg.attack.projectile", "proj_arrow_phx");
		SetLocal("reg.attack.priority", 0);
		SetLocal("reg.attack.delay.strike", 0.8f);
		SetLocal("reg.attack.delay.end", 0.8f);
		SetLocal("reg.attack.ofs.startpos", Vector3(0, 0, 10));
		SetLocal("reg.attack.ofs.aimang", RANGED_AIMANGLE);
		SetLocal("reg.attack.ammodrain", 0);
		SetLocal("reg.attack.callback", "ranged");
		SetLocal("reg.attack.noise", 1000);

		RegisterAttack();
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("weapons/p_weapons3.mdl");
		Precache("viewmodels/v_bows.mdl");
		CallEventDelayed(3.35f, "BowsBase_Timer");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "bow_spawn") { OnBowSpawn(); return true; }
		if (name == "custom_register") { OnCustomRegister(); return true; }
		return BowsBaseScript::DispatchEvent(name, params);
	}
}
