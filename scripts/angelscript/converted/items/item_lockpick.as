#pragma context server

// Converted from items/item_lockpick.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/items/base_miscitem.as"

[script "items/item_lockpick"]
class ItemLockpick : BaseMiscitemScript
{
	// Constants
	int ANIM_LIFT1 = 18;
	string ANIM_IDLE = "18";
	string ANIM_IDLE1 = "18";
	string ANIM_IDLE2 = "18";
	string ANIM_IDLE3 = "18";
	int ANIM_IDLE4 = 18;
	int ANIM_IDLE5 = 18;
	int ANIM_IDLE_DELAY_LOW = 2;
	int ANIM_IDLE_DELAY_HIGH = 5;
	string ANIM_USE = "19";
	int ANIM_FAIL = 16;
	int ITEM_MODEL_VIEW_IDX = 9;
	string ICO_LOCKPICK_STATUS = "hud/status/alpha_lockpick";

	// Variables (an unset .script variable reads as its own name)
	float NEXT_USE = 0.0f;
	bool LOCKPICK_FAIL = false;
	bool AM_LOCKPICKING = false;
	CBaseEntity@ LOCK_TARGET = null;

	// Variables declared by included files, with the value they start with in this script
	ItemLockpick()
	{
		MODEL_BODY_OFS = "13";
		MODEL_VIEW = "viewmodels/v_martialarts.mdl";
		ANIM_PREFIX = "rustedkey";
	}

	// game_takedamage
	// 1: Attacker  2: Inflictor  3: dmg  4: dmg type
	string ItemLockpick_OnGameTakedamage(CBaseEntity@ attacker = null, CBaseEntity@ inflictor = null, float damage = 0.0f, string damageType = "")
	{
		string result = "";
		if (RelationshipOf(attacker, ENT_OWNER) != "enemy")
			return result;
		if (IsPlayer(attacker)) // anti-troll
			return result;
		PlayItemViewAnim(ENT_ME, ANIM_LIFT1);
		PlayerMessageRed(ENT_OWNER, "Your lock picking is interrupted!");
		LegacyCommand("hud.killstatusicon", ENT_OWNER, "lockpick");
		NEXT_USE = GameTime() + 0.5f;
		AM_LOCKPICKING = false;
		return result;
	}

	// game_deploy
	void OnGameDeploy()
	{
		BaseItemExtras_OnGameDeploy(); // items/base_item_extras
		BaseItemExtras_OnGameDeploy_2(); // items/base_item_extras
		BaseItemExtras_OnGameDeploy_3(); // items/base_item_extras
		BaseMiscitem_OnGameDeploy(); // items/base_miscitem
		PlayViewAnim(ANIM_LIFT1);
		NEXT_USE = GameTime() + 0.5f;
		CallEventDelayed(0.1f, "bi_setup_model");
	}

	// miscitem_spawn
	void OnMiscitemSpawn()
	{
		SetName("Lockpick");
		SetDescription("This can be used to disarm traps and open certain chests");
		SetGroupable(100);
		SetWeight(0);
		SetValue(300);
		SetHudSprite("trade", "195");
	}

	// game_attack1
	void OnGameAttack1()
	{
		if (!(GameTime() > NEXT_USE))
			return;
		if (AM_LOCKPICKING)
			return;
		NEXT_USE = GameTime() + 0.5f;
		if (!CanAttack(ENT_OWNER))
			return;
		CBaseEntity@ targ = TargetOf(ENT_OWNER);
		LOCKPICK_FAIL = false;
		OnValidateTarget(targ);
		if (LOCKPICK_FAIL)
			return;

		AddStatusIcon(ENT_OWNER, ICO_LOCKPICK_STATUS, "lockpick", 10.0f);

		PlayItemViewAnim(ENT_ME, Int(ANIM_USE));

		AM_LOCKPICKING = true;
		@LOCK_TARGET = targ;
		CallEventDelayed(10.0f, "lockpick_complete");
	}

	string OnGameTakedamage(CBaseEntity@ attacker = null, CBaseEntity@ inflictor = null, float damage = 0.0f, string damageType = "") { return ItemLockpick_OnGameTakedamage(attacker, inflictor, damage, damageType); } // game_takedamage

	// lockpick_complete
	void OnLockpickComplete()
	{
		if (!AM_LOCKPICKING)
			return;
		AM_LOCKPICKING = false;

		NEXT_USE = GameTime() + 1.0f;

		// check again in case moved away, or someone else unlocked
		CBaseEntity@ targ = LOCK_TARGET;
		LOCKPICK_FAIL = false;
		OnValidateTarget(targ);

		if (LOCKPICK_FAIL)
			return;

		CallExternal(LOCK_TARGET, "ext_picked", @EntityOf(ENT_OWNER));

		float count = QuantityOf(ENT_ME);
		DebugPrint("lockpick_complete " + Text(count));
		count -= 1.0f;
		if (count <= 0.0f)
			DeleteEntity(ENT_ME);
		else
			LegacyCommand("setquantity", ENT_ME, count);
	}

	// resume_idle
	void OnResumeIdle()
	{
		PlayItemViewAnim(ENT_ME, Int(ANIM_IDLE1));
	}

	// bi_setup_model
	void OnBiSetupModel()
	{
		DebugPrint("setting up model");
		SetViewModelProp(ENT_ME, "submodel", ScriptVarOf(ENT_OWNER, "PLR_HAND_SET"), ITEM_MODEL_VIEW_IDX);
	}

	// validate_target
	void OnValidateTarget(CBaseEntity@ target = null)
	{
		bool fail = false;
		bool tooFar = false;
		string msg = "L_MSG";

		if (!IsAlive(target))
		{
			PlayerMessageDark(ENT_OWNER, "Lockpick: No target.");
			LOCKPICK_FAIL = true;
			return;
		}
		if (!Truthy(ScriptVarOf(target, "BC_REQ_PICK")) && !Truthy(ScriptVarOf(target, "BC_TRAPPED")))
			fail = true;

		if (!fail)
		{
			Vector3 targOrg = OriginOf(target);
			Vector3 ownerOrg = OriginOf(ENT_OWNER);
			if (Distance(targOrg, ownerOrg) > 96.0f)
			{
				tooFar = true;
				fail = true;
			}
			if (tooFar)
				msg = "Lockpick: You are too far away...";
		}

		if (fail)
		{
			LOCKPICK_FAIL = true;
			PlayItemViewAnim(ENT_ME, ANIM_FAIL);
			CallEventDelayed(1.0f, "resume_idle");
			NEXT_USE = GameTime() + 1.0f;
			if (!tooFar)
				msg = "Lockpick: This is not a valid target.";
			if (Truthy(ScriptVarOf(target, "BC_AM_CHEST")) && !tooFar)
			{
				if (Truthy(ScriptVarOf(target, "CHEST_LOCKED")))
					msg = "Lockpick: This chest cannot be picked.";
				if (!Truthy(ScriptVarOf(target, "CHEST_LOCKED")))
					msg = "Lockpick: This chest is neither locked nor trapped.";
			}
			PlayerMessageDark(ENT_OWNER, msg);
		}
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("misc/p_misc.mdl");
		Precache("viewmodels/v_martialarts.mdl");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "bi_setup_model") { OnBiSetupModel(); return true; }
		if (name == "game_attack1") { OnGameAttack1(); return true; }
		if (name == "game_deploy") { OnGameDeploy(); return true; }
		if (name == "game_takedamage") { Return(OnGameTakedamage(EntityParam(params, 0), EntityParam(params, 1), Float(Param(params, 2)), Param(params, 3))); return true; }
		if (name == "lockpick_complete") { OnLockpickComplete(); return true; }
		if (name == "miscitem_spawn") { OnMiscitemSpawn(); return true; }
		if (name == "resume_idle") { OnResumeIdle(); return true; }
		if (name == "validate_target") { OnValidateTarget(EntityParam(params, 0)); return true; }
		return BaseMiscitemScript::DispatchEvent(name, params);
	}
}
