#pragma context server

// Converted from items/dev_staff.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/items/base_item_extras.as"
#include "converted/items/dev_staff/physgun.as"
#include "converted/items/dev_staff/copypaste.as"
#include "converted/items/dev_staff/remover.as"
#include "converted/items/dev_staff/afflicter.as"
#include "converted/items/dev_staff/damager.as"

[script "items/dev_staff"]
class DevStaff : BaseItemExtrasScript, Physgun, Copypaste, Remover, Afflicter, Damager
{
	// Constants
	bool NO_BANK = true;

	// Variables (an unset .script variable reads as its own name)
	string BEAM_TYPE = "0";
	string BEAM_TARGET = "none";
	string MENU_ID = "none";
	bool AM_NOCLIPPING = false;

	// unnamed block (first think)
	void DevStaff_FirstThink()
	{
		BEAM_TYPE = "0"; // 0 = physgun; 1 = remover; 2 = afflicter;
		BEAM_TARGET = "none";

		MENU_ID = "none";
	}

	// game_removefromowner
	void OnGameRemovefromowner()
	{
		OnValidationCheck();
	}

	// validation_check
	void OnValidationCheck()
	{
		if (Truthy(Eval("game.central")))
		{
			string me = SteamIdOf(ENT_OWNER);
			if (!Contains(GetVar("G_DEVSTAFF_OWNERS"), me))
				DeleteMe();
		}
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseItemExtras_OnGameSpawn(playerRace, playerGender); // items/base_item_extras

		SetName("Jester's Staff");
		SetDescription("For the real clowns who spend days troubleshooting simple problems.");

		SetWeight(0);
		SetValue(0);
		SetHudSprite("hand", "item");
		SetHudSprite("trade", "21");

		SetModel("weapons/p_weapons1.mdl");
		SetModelBody(0, 20);

		SetViewModel("viewmodels/v_1hblunts.mdl");

		SetHand("both");
		LegacyCommand("expiretime", 0);
	}

	// bweapon_effect_activate
	void OnBweaponEffectActivate()
	{
		BaseItemExtras_OnBweaponEffectActivate(); // items/base_item_extras

		PlayerMessageBlue(ENT_OWNER, "Hold 'e' then push mouse1 to access the menu.");
		PlayerMessageBlue(ENT_OWNER, "Mouse2 instead to copy your target. Left click will be replaced with paste.");
		PlayerMessageBlue(ENT_OWNER, "Clear the clipboard (copy nothing) to restore other left click function.");

		CallEventDelayed(0.1f, "submodel_me_baby");

		if (MENU_ID != "none")
			return;
		CreateNpc("items/dev_staff/menus/main", Vec("(0,0,0)"), @EntityOf(ENT_OWNER), self);
		MENU_ID = EntityId(EntityOf(ENT_LASTCREATED));
	}

	// bweapon_effect_remove
	void OnBweaponEffectRemove(string reason = "")
	{
		BaseItemExtras_OnBweaponEffectRemove(reason); // items/base_item_extras

		// callevent 0.1 wmodel_me_baby
		DeleteEntity(MENU_ID);
		MENU_ID = "none";
	}

	// game_pickup
	void OnGamePickup()
	{
		PlayViewAnim(0);
	}

	// game_attack1
	// Paste npc
	void OnGameAttack1()
	{
		if (IsKeyDown(ENT_OWNER, "use"))
			CallExternal(MENU_ID, "ext_menu_main");
		else if (NPC_CLIPBOARD != "none")
			OnPasteTarget();
	}

	// game_attack1_down
	void OnGameAttack1Down()
	{
		if (!IsKeyDown(ENT_OWNER, "use") && NPC_CLIPBOARD == "none")
		{
			if (Float(BEAM_TYPE) == 0.0f)
				OnTryPhysgun();
			if (Float(BEAM_TYPE) == 1.0f)
				OnTryRemove();
			if (Float(BEAM_TYPE) == 2.0f)
				OnTryApplyeffect();
			if (Float(BEAM_TYPE) == 3.0f)
				OnTryDamage();
		}
	}

	// game_attack2
	void OnGameAttack2()
	{
		if (IsKeyDown(ENT_OWNER, "use"))
		{
			OnCopyTarget();
		}
		else
		{
			// No keydown
			if (AM_NOCLIPPING)
			{
				AM_NOCLIPPING = false;
				SetProp(ENT_OWNER, "movetype", 3);
				SetProp(ENT_OWNER, "solid", 2);
			}
			else
			{
				AM_NOCLIPPING = true;
				SetProp(ENT_OWNER, "movetype", 8);
				SetProp(ENT_OWNER, "solid", 0);
			}
		}
	}

	// find_beam_target
	void OnFindBeamTarget()
	{
		Vector3 start = EyePositionOf(ENT_OWNER);

		Vector3 end = RelativePosition(ViewAnglesOf(ENT_OWNER), Vector3(0, 10000, 0)) + start;

		BEAM_TARGET = "none";
		string target = LegacyFunction("get_traceline", start, end, "ent", @EntityOf(ENT_OWNER));
		if (Exists(target) && IsAlive(target))
			BEAM_TARGET = target;
	}

	// set_beam_type
	void OnSetBeamType(string beamType = "", float beamMode = 0.0f)
	{
		BEAM_TYPE = beamType;
	}

	// submodel_me_baby
	void OnSubmodelMeBaby()
	{
		SetViewModelProp(ENT_ME, "submodel", 0, 6);
	}

	// wmodel_me_baby
	void OnWmodelMeBaby()
	{
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("weapons/p_weapons1.mdl");
		Precache("viewmodels/v_1hblunts.mdl");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		DevStaff_FirstThink();
		BaseItemExtras_FirstThink();
		Physgun_FirstThink();
		Copypaste_FirstThink();
		Afflicter_FirstThink();
		Damager_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "bweapon_effect_activate") { OnBweaponEffectActivate(); return true; }
		if (name == "bweapon_effect_remove") { OnBweaponEffectRemove(Param(params, 0)); return true; }
		if (name == "find_beam_target") { OnFindBeamTarget(); return true; }
		if (name == "game_attack1") { OnGameAttack1(); return true; }
		if (name == "game_attack1_down") { OnGameAttack1Down(); return true; }
		if (name == "game_attack2") { OnGameAttack2(); return true; }
		if (name == "game_pickup") { OnGamePickup(); return true; }
		if (name == "game_removefromowner") { OnGameRemovefromowner(); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "set_beam_type") { OnSetBeamType(Param(params, 0), Float(Param(params, 1))); return true; }
		if (name == "submodel_me_baby") { OnSubmodelMeBaby(); return true; }
		if (name == "validation_check") { OnValidationCheck(); return true; }
		if (name == "wmodel_me_baby") { OnWmodelMeBaby(); return true; }
		return Physgun_DispatchEvent(name, params)
			|| Copypaste_DispatchEvent(name, params)
			|| Remover_DispatchEvent(name, params)
			|| Afflicter_DispatchEvent(name, params)
			|| Damager_DispatchEvent(name, params)
			|| BaseItemExtrasScript::DispatchEvent(name, params);
	}
}
