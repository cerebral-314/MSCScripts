#pragma context server

// Converted from items/item_torch.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/items/base_melee.as"

[script "items/item_torch"]
class ItemTorch : BaseMeleeScript
{
	// Constants
	bool ANIM_THRUST = true;
	string SOUND_HITWALL = "debris/wood2.wav";
	string SOUND_SWIPE = "weapons/swingsmall.wav";
	string ITEM_NAME = "torch";
	string SPRITE_FIRE = "fire1_fixed.spr";
	string SPRITE_FIRE_FIXED = "fire1_fixed.spr";
	string MELEE_RANGE = "60";
	float MELEE_DMG_DELAY = 0.6f;
	float MELEE_ATK_DURATION = 1.2f;
	float MELEE_ENERGY = 1.0f;
	int MELEE_DMG = 60;
	int MELEE_DMG_RANGE = 60;
	string MELEE_DMG_TYPE = "fire";
	string MELEE_ACCURACY = "30";
	string MELEE_STAT = "bluntarms";
	string MELEE_ALIGN_BASE = "4,-6";
	string MELEE_ALIGN_TIP = "0,6";
	string MELEE_VIEWANIM_ATK = "MELEE_VIEWANIM_ATK";
	string MELEE_SOUND = "MELEE_SOUND";
	float MELEE_SOUND_DELAY = 0.0f;
	string MELEE_PARRY_CHANCE = "0";
	string PLAYERANIM_SWING = "axe_onehand_swing";
	string TORCH_LIGHT_SCRIPT = "items/item_torch_light";
	string LOOPSND_NAME = "items/torch1.wav";
	int LOOPSND_LENGTH = 6;

	// Variables (an unset .script variable reads as its own name)
	string SCRIPT_ID = "SCRIPT_ID";

	// Variables declared by included files, with the value they start with in this script
	ItemTorch()
	{
		MODEL_VIEW = "misc/item_torch_rview.mdl";
		MODEL_HANDS = "misc/p_misc.mdl";
		MODEL_WORLD = "misc/p_misc.mdl";
		MODEL_BODY_OFS = "36";
		ANIM_PREFIX = "torch";
		PLAYERANIM_AIM = "axe_onehand";
	}

	// unnamed block (timer)
	void ItemTorch_Timer()
	{
		CallEventDelayed(LOOPSND_LENGTH, "ItemTorch_Timer");
		if (!Truthy(SCRIPT_ID))
			return;
		ServerPlaySound(Int(Eval("const.sound.item")), 5, LOOPSND_NAME);
	}

	// game_fall
	void OnGameFall()
	{
		BaseItemExtras_OnGameFall(); // items/base_item_extras
		BaseItemExtras_OnGameFall_2(); // items/base_item_extras
		BaseWeapon_OnGameFall(); // items/base_weapon

		OnDoTorchFx("game_fall");
	}

	// game_deploy
	void OnGameDeploy()
	{
		BaseItemExtras_OnGameDeploy(); // items/base_item_extras
		BaseItemExtras_OnGameDeploy_2(); // items/base_item_extras
		BaseItemExtras_OnGameDeploy_3(); // items/base_item_extras
		BaseItem_OnGameDeploy(); // items/base_item
		BaseWeapon_OnGameDeploy(); // items/base_weapon
		BaseWeapon_OnGameDeploy_2(); // items/base_weapon
		BaseMelee_OnGameDeploy(); // items/base_melee

		PlayViewAnim(Int(ANIM_IDLE1));
		PlayAnim("idle");
		OnWeaponDeploy();
	}

	// game_putinpack
	void OnGamePutinpack()
	{
		BaseItemExtras_OnGamePutinpack(); // items/base_item_extras

		OnEndTorchFx();
	}

	// bweapon_effect_activate
	void OnBweaponEffectActivate()
	{
		BaseItemExtras_OnBweaponEffectActivate(); // items/base_item_extras

		OnEndTorchFx();
		OnDoTorchFx("game_deploy");
	}

	// bweapon_effect_remove
	void OnBweaponEffectRemove(string reason = "")
	{
		BaseItemExtras_OnBweaponEffectRemove(reason); // items/base_item_extras

		OnEndTorchFx();
	}

	// weapon_spawn
	void OnWeaponSpawn()
	{
		BaseMelee_OnWeaponSpawn(); // items/base_melee

		SetName("Torch");
		SetDescription("A torch");
		SetWeight(1);
		SetValue(1);
		SetHand("left");

		SetHudSprite("hand", ITEM_NAME);
		SetHudSprite("trade", ITEM_NAME);

		SetViewModel(MODEL_VIEW);
		SetModel(MODEL_HANDS);
		SetModelBody(0, Int(MODEL_BODY_OFS));
	}

	// melee_strike
	void OnMeleeStrike(string hitType = "", Vector3 endPos = Vector3(), CBaseEntity@ hitEntity = null, bool hit = false)
	{
		if (hitType != "npc")
			return;
		if (!hit)
			return;

		float dmg = 30.0f * SkillOf(ENT_OWNER, "bluntarms.ratio");
		ApplyEffect(hitEntity, "effects/dot_fire", 3, @EntityOf(ENT_OWNER), dmg, "bluntarms");
	}

	// do_torch_fx
	// PARAM1 = ("game_deploy"|"game_fall")
	void OnDoTorchFx(string fxType = "")
	{
		if (Truthy(SCRIPT_ID))
			return;
		if (fxType == "game_deploy")
		{
			float body = ItemHandIndex() + 1.0f;
			ClientEvent("persist", "all", TORCH_LIGHT_SCRIPT, IndexOf(ENT_OWNER), body);
			SCRIPT_ID = LastClientScriptId();
		}
		else if (fxType == "game_fall")
		{
			ClientEvent("persist", "all", TORCH_LIGHT_SCRIPT, IndexOf(ENT_ME), 1);
			SCRIPT_ID = LastClientScriptId();

			PlayAnim("torch_floor_idle");
		}
	}

	// end_torch_fx
	void OnEndTorchFx()
	{
		if (!Truthy(SCRIPT_ID))
			return;
		ClientEvent("update", "all", SCRIPT_ID, "remove_me");
		SCRIPT_ID = "0";
		ServerPlaySound(Int(Eval("const.sound.item")), 0, LOOPSND_NAME);
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("misc/p_misc.mdl");
		Precache("misc/item_torch_rview.mdl");
		Precache("items/torch1.wav");
		CallEventDelayed(LOOPSND_LENGTH, "ItemTorch_Timer");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "bweapon_effect_activate") { OnBweaponEffectActivate(); return true; }
		if (name == "bweapon_effect_remove") { OnBweaponEffectRemove(Param(params, 0)); return true; }
		if (name == "do_torch_fx") { OnDoTorchFx(Param(params, 0)); return true; }
		if (name == "end_torch_fx") { OnEndTorchFx(); return true; }
		if (name == "game_deploy") { OnGameDeploy(); return true; }
		if (name == "game_fall") { OnGameFall(); return true; }
		if (name == "game_putinpack") { OnGamePutinpack(); return true; }
		if (name == "melee_strike") { OnMeleeStrike(Param(params, 0), Vec(Param(params, 1)), EntityParam(params, 2), Truthy(Param(params, 3))); return true; }
		if (name == "weapon_spawn") { OnWeaponSpawn(); return true; }
		if (name == "ItemTorch_Timer") { ItemTorch_Timer(); return true; }
		return BaseMeleeScript::DispatchEvent(name, params);
	}
}
