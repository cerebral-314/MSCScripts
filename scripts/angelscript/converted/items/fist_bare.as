#pragma context server

// Converted from items/fist_bare.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/items/base_melee.as"
#include "converted/items/base_kick.as"

[script "items/fist_bare"]
class FistBare : BaseMeleeScript, BaseKick
{
	// Constants
	bool NO_PARRY = true;
	bool NO_IDLE = true;
	int ANIM_HANDS_DOWN = 3;
	string ANIM_LOWER = "3";
	int ANIM_IDLE_TOTAL = 1;
	string ANIM_ATTACK1 = "4";
	int ANIM_SHEATH = 3;
	string SOUND_SWIPE = "weapons/swingsmall.wav";
	string SOUND_HITWALL1 = "weapons/cbar_hitbod1.wav";
	string SOUND_HITWALL2 = "weapons/cbar_hitbod2.wav";
	string MELEE_RANGE = "50";
	float MELEE_DMG_DELAY = 0.3f;
	float MELEE_ATK_DURATION = 0.9f;
	float MELEE_ENERGY = 1.0f;
	int MELEE_DMG = 60;
	int MELEE_DMG_RANGE = 0;
	string MELEE_DMG_TYPE = "blunt";
	string MELEE_ACCURACY = "70%";
	string MELEE_STAT = "martialarts";
	string MELEE_VIEWANIM_ATK = "MELEE_VIEWANIM_ATK";
	string MELEE_SOUND = "MELEE_SOUND";
	float MELEE_SOUND_DELAY = 0.0f;
	string MELEE_PARRY_CHANCE = "0%";

	// Variables (an unset .script variable reads as its own name)
	int PUNCH_ATTACK = 0;
	float FISTS_LAST_ATTACK = 0.0f;

	// Variables declared by included files, with the value they start with in this script
	FistBare()
	{
		ANIM_LIFT1 = 2;
		ANIM_IDLE1 = "1";
		MODEL_VIEW = "viewmodels/v_martialarts.mdl";
		MODEL_HANDS = "none";
		MODEL_WORLD = "none";
		MODEL_BODY_OFS = "0";
		ANIM_PREFIX = "fists";
		PLAYERANIM_AIM = "fists";
	}

	// ext_activate_items
	void OnExtActivateItems(CBaseEntity@ playerId = null)
	{
		BaseItemExtras_OnExtActivateItems(playerId); // items/base_item_extras
		if (playerId !is EntityOf(ENT_OWNER))
			return;
		DebugPrint("ext_activate_items ext_register_fists");
		CallExternal(ENT_OWNER, "ext_register_fists", self);
	}

	// weapon_spawn
	void OnWeaponSpawn()
	{
		BaseMelee_OnWeaponSpawn(); // items/base_melee

		SetName("Bare Fists");
		SetDescription("Your bare fists");
		SetWeight(0);
		SetValue(0);
		SetHand("undroppable");
	}

	// hitwall
	void OnHitwall()
	{
		BaseMelee_OnHitwall(); // items/base_melee

		PlayRandomSound(Int(Eval("game.sound.weapon")), Eval("game.sound.maxvol"), SOUND_HITWALL1, SOUND_HITWALL2);
	}

	// weapon_deploy
	void OnWeaponDeploy()
	{
		PlayViewAnim(ANIM_HANDS_DOWN);
	}

	// melee_start
	void OnMeleeStart()
	{
		string punchAnim = "l.punch_anim";

		PlayViewAnim(Int(ANIM_ATTACK1));

		if (PUNCH_ATTACK == 0)
		{
			punchAnim = "stance_normal_lowjab_r1";
			PUNCH_ATTACK = 1;
		}
		else if (PUNCH_ATTACK == 1)
		{
			punchAnim = "stance_normal_lowjab_r2";
			PUNCH_ATTACK = 0;
		}

		PlayOwnerAnim("once", punchAnim, "global.anim.combatwalk", 3);

		// playsound game.sound.weapon game.sound.maxvol SOUND_SWIPE
		FISTS_LAST_ATTACK = GameTime();
		OnPunch1Done(); // Lower fists in 5 seconds
	}

	// punch1_done
	void OnPunch1Done()
	{
		CallEventDelayed(1.0f, "punch1_done");

		if (int(FISTS_LAST_ATTACK) == 0)
			return;
		float elapsedtime = GameTime() - FISTS_LAST_ATTACK;

		if (!(elapsedtime > 5.0f))
			return;

		PlayViewAnim(Int(ANIM_LOWER));
		FISTS_LAST_ATTACK = 0.0f;
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("viewmodels/v_martialarts.mdl");
		Precache("weapons/martialarts/foot.mdl");
		CallEventDelayed(1.0f, "punch1_done");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "ext_activate_items") { OnExtActivateItems(EntityParam(params, 0)); return true; }
		if (name == "hitwall") { OnHitwall(); return true; }
		if (name == "melee_start") { OnMeleeStart(); return true; }
		if (name == "punch1_done") { OnPunch1Done(); return true; }
		if (name == "weapon_deploy") { OnWeaponDeploy(); return true; }
		if (name == "weapon_spawn") { OnWeaponSpawn(); return true; }
		return BaseKick_DispatchEvent(name, params)
			|| BaseMeleeScript::DispatchEvent(name, params);
	}
}
