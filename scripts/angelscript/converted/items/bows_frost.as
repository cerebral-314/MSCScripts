#pragma context server

// Converted from items/bows_frost.script by msc_transpiler.
// Frost Bow. CrazyMonkeyDude Nov 2009 (From Phoenix Bow)
// 50/50 chance to frost or freeze
// 50% resistance to ice with a 10 second delay
// To prevent sploiting with other means of ice resistance (Ice based damage also helps)
// Updates by Thothie JAN2010_15

#include "runtime/ScriptEntity.as"
#include "converted/items/bows_base.as"

[script "items/bows_frost"]
class BowsFrost : BowsBaseScript
{
	// Constants
	string BASE_LEVEL_REQ = "25";
	int MODEL_VIEW_IDX = 8;
	string SOUND_RESISTUP = "magic/frost_reverse.wav";
	bool CUSTOM_ATTACK = true;
	string SOUND_RESIST_PREP = "magic/gaus_warmup.wav";
	string SOUND_RESIST_LOOP = "ambience/pulsemachine.wav";
	string SOUND_RESIST_LOCK = "weapons/egon_off1.wav";

	// Variables (an unset .script variable reads as its own name)
	bool NOT_BOGUS_SCRIPT = false;
	bool ABORT_PREP = false;
	bool REMOVE_LOOP_ACTIVE = false;
	bool BOW_PREPPING = false;
	string BOW_PREP_SCRIPT_ID = "BOW_PREP_SCRIPT_ID";
	bool RESIST_ACTIVE = false;

	// Variables declared by included files, with the value they start with in this script
	BowsFrost()
	{
		MODEL_VIEW = "viewmodels/v_bows.mdl";
		MODEL_HANDS = "weapons/p_weapons3.mdl";
		MODEL_WORLD = "weapons/p_weapons3.mdl";
		MODEL_WEAR = "weapons/p_weapons3.mdl";
		SOUND_SHOOT = "weapons/bow/bow.wav";
		ITEM_NAME = "longbow";
		ANIM_PREFIX = "standard";
		MODEL_BODY_OFS = "44";
	}

	// bweapon_effect_activate
	void OnBweaponEffectActivate()
	{
		BaseItemExtras_OnBweaponEffectActivate(); // items/base_item_extras
		DebugPrint("bweapon_effect_activate " + Text(BOW_PREPPING) + " " + Text(RESIST_ACTIVE));
		if (BOW_PREPPING)
			return;
		if (RESIST_ACTIVE)
			return;
		NOT_BOGUS_SCRIPT = true;
		OnSetupBow();
	}

	// bweapon_effect_remove
	void OnBweaponEffectRemove(string reason = "")
	{
		BaseItemExtras_OnBweaponEffectRemove(reason); // items/base_item_extras
		DebugPrint("bweapon_effect_remove " + Text(BOW_PREPPING) + " " + Text(RESIST_ACTIVE));
		REMOVE_LOOP_ACTIVE = false;
		if (BOW_PREPPING)
			OnAbortPrep();
		if (!RESIST_ACTIVE)
			return;
		CallExternal(ENT_OWNER, "ext_register_weapon", self, "cbow", "remove");
		RESIST_ACTIVE = false;
	}

	// bow_spawn
	void OnBowSpawn()
	{
		SetName("Frost Bow");
		SetDescription("An icy bow that fires icy projectiles.");
		SetWeight(100);
		SetValue(1500);
		SetHudSprite("trade", "135");

		OnCustomRegister();
	}

	// custom_register
	void OnCustomRegister()
	{
		SetLocal("reg.attack.type", "charge-throw-projectile");
		SetLocal("reg.attack.keys", "+attack1");
		SetLocal("reg.attack.hold_min&max", "1.1;1.3");
		SetLocal("reg.attack.dmg.type", "magic");
		SetLocal("reg.attack.range", 1500);
		SetLocal("reg.attack.energydrain", 1);
		SetLocal("reg.attack.stat", "archery");
		SetLocal("reg.attack.COF", "1;1");
		SetLocal("reg.attack.projectile", "proj_arrow_fbow");
		SetLocal("reg.attack.priority", 0);
		SetLocal("reg.attack.delay.strike", 1.2f);
		SetLocal("reg.attack.delay.end", 1.2f);
		SetLocal("reg.attack.ofs.startpos", Vector3(0, 0, 10));
		SetLocal("reg.attack.ofs.aimang", RANGED_AIMANGLE);
		SetLocal("reg.attack.ammodrain", 0);
		SetLocal("reg.attack.callback", "ranged");
		SetLocal("reg.attack.noise", 1000);

		RegisterAttack();
	}

	// setup_bow
	void OnSetupBow()
	{
		if (BOW_PREPPING)
			return;
		CallEventDelayed(0.1f, "prep_bow");
		if (!REMOVE_LOOP_ACTIVE)
		{
			ABORT_PREP = false;
			REMOVE_LOOP_ACTIVE = true;
			OnCheckToRemoveLoop();
		}
	}

	// prep_bow
	void OnPrepBow()
	{
		if (RESIST_ACTIVE)
			return;
		BOW_PREPPING = true;
		PlaySound(0, 10, SOUND_RESIST_PREP);
		CallEventDelayed(10.0f, "activate_resistance");
		ClientEvent("new", "all", "items/bows_frost_cl", IndexOf(ENT_OWNER));
		BOW_PREP_SCRIPT_ID = LastClientScriptId();
		CallEventDelayed(3.0f, "play_resist_loop");
	}

	// play_resist_loop
	void OnPlayResistLoop()
	{
		if (!BOW_PREPPING)
			return;
		ServerPlaySound(1, 10, SOUND_RESIST_LOOP);
	}

	// activate_resistance
	void OnActivateResistance()
	{
		if (!BOW_PREPPING)
			return;
		BOW_PREPPING = false;
		if (RESIST_ACTIVE)
			return;
		RESIST_ACTIVE = true;
		CallExternal(ENT_OWNER, "ext_register_weapon", self, "cbow", "cold", 75);
		PlaySound(2, 10, SOUND_RESIST_LOCK);
		ServerPlaySound(1, 0, SOUND_RESIST_LOOP);
	}

	// check_to_remove_loop
	void OnCheckToRemoveLoop()
	{
		if (!REMOVE_LOOP_ACTIVE)
			return;
		CallEventDelayed(1.0f, "check_to_remove_loop");
		if (!IsAlive(ENT_OWNER))
		{
			OnBweaponEffectRemove(); // owner died, remove effect
		}
	}

	// abort_prep
	void OnAbortPrep()
	{
		DebugPrint("abort_prep " + BOW_PREP_SCRIPT_ID);
		ServerPlaySound(1, 0, SOUND_RESIST_LOOP);
		REMOVE_LOOP_ACTIVE = false;
		RESIST_ACTIVE = false;
		BOW_PREPPING = false; // so bow will reinit if user dies
		ClientEvent("update", "all", BOW_PREP_SCRIPT_ID, "remove_sprites"); // remove CL script if user dies during prep
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("weapons/p_weapons3.mdl");
		Precache("viewmodels/v_bows.mdl");
		Precache("ambience/pulsemachine.wav");
		CallEventDelayed(3.35f, "BowsBase_Timer");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "abort_prep") { OnAbortPrep(); return true; }
		if (name == "activate_resistance") { OnActivateResistance(); return true; }
		if (name == "bow_spawn") { OnBowSpawn(); return true; }
		if (name == "bweapon_effect_activate") { OnBweaponEffectActivate(); return true; }
		if (name == "bweapon_effect_remove") { OnBweaponEffectRemove(Param(params, 0)); return true; }
		if (name == "check_to_remove_loop") { OnCheckToRemoveLoop(); return true; }
		if (name == "custom_register") { OnCustomRegister(); return true; }
		if (name == "play_resist_loop") { OnPlayResistLoop(); return true; }
		if (name == "prep_bow") { OnPrepBow(); return true; }
		if (name == "setup_bow") { OnSetupBow(); return true; }
		return BowsBaseScript::DispatchEvent(name, params);
	}
}
