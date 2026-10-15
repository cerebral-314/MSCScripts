#pragma context server

// Converted from items/shields_f.script by msc_transpiler.
// Fire Shield

#include "runtime/ScriptEntity.as"
#include "converted/items/shields_base.as"

[script "items/shields_f"]
class ShieldsF : ShieldsBaseScript
{
	// Constants
	int MP_DRAIN_RATE = 2;
	bool SHIELD_PRE_BLOCK_EFFECT = true;
	string SOUND_BREATH_LOOP = "monsters/goblin/sps_fogfire.wav";

	// Variables (an unset .script variable reads as its own name)
	int GAME_PVP = 0;
	bool SCAN_KEYS = false;
	float NEXT_MP_WARN = 0.0f;
	string BREATH_ON = "BREATH_ON";
	string CL_SCRIPT_DX = "CL_SCRIPT_DX";
	Vector3 OWNER_ANG = Vector3();
	string OWNER_ORG = "OWNER_ORG";
	float NEXT_SCAN = 0.0f;
	string BURN_DAMAGE = "BURN_DAMAGE";
	string BURN_LIST = "BURN_LIST";
	Vector3 TRACE_START = Vector3();

	// Variables declared by included files, with the value they start with in this script
	ShieldsF()
	{
		NOPUSH_CHANCE = "100%";
		PARRY_MULTI = 1.5f;
		SHIELD_BASE_PARRY = 35;
		MODEL_VIEW = "viewmodels/v_shields.mdl";
		MODEL_VIEW_IDX = 4;
		MODEL_WORLD = "weapons/p_weapons4.mdl";
		MODEL_HANDS = "weapons/p_weapons4.mdl";
		MODEL_WEAR = "weapons/p_weapons4.mdl";
		MODEL_BODY_OFS = "46";
		MELEE_ENERGY = 15.0f;
		MELEE_ACCURACY = "90%";
		BLOCK_CHANCE_UP = 100;
		DMG_BLOCK_UP = 0.5f;
		BLOCK_CHANCE_DOWN = 10;
		SHIELD_IMMORTAL = true;
		SOUND_BLOCK = "debris/metal3.wav";
		ANIM_PREFIX = "standard";
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
		GAME_PVP = (IsPvp() ? 1 : 0);
	}

	// game_wear
	void OnGameWear(string race = "", string gender = "", string source = "")
	{
		BaseItemExtras_OnGameWear(race, gender, source); // items/base_item_extras
		BaseMelee_OnGameWear(race, gender, source); // items/base_melee
		ShieldsBase_OnGameWear(race, gender, source); // items/shields_base

		OwnerMessage("You sling a Demon Shield over your shoulder.");
	}

	// bweapon_effect_activate
	void OnBweaponEffectActivate()
	{
		BaseItemExtras_OnBweaponEffectActivate(); // items/base_item_extras
		if (SCAN_KEYS)
			return;
		SCAN_KEYS = true;
		OnScanKeys();
	}

	// bweapon_effect_remove
	void OnBweaponEffectRemove(string reason = "")
	{
		BaseItemExtras_OnBweaponEffectRemove(reason); // items/base_item_extras
		ShieldsBase_OnBweaponEffectRemove(reason); // items/shields_base
		SCAN_KEYS = false;
		if (!Truthy(BREATH_ON))
			return;
		OnEndBreath();
	}

	// melee_end
	void OnMeleeEnd()
	{
		ShieldsBase_OnMeleeEnd(); // items/shields_base
		if (!Truthy(BREATH_ON))
			return;
		OnEndBreath();
	}

	// shield_spawn
	void OnShieldSpawn()
	{
		SetName("Demon Shield");
		SetDescription("For when it's time to get out of the kitchen");
		SetWeight(120);
		SetValue(5000);
		LegacyCommand("quality", 2000);
		// sethudsprite hand 191
		SetHudSprite("trade", "191");
	}

	// scan_keys
	void OnScanKeys()
	{
		if (!SCAN_KEYS)
			return;
		if (!Truthy(Eval("game.item.wielded")))
			return;
		CallEventDelayed(0.25f, "scan_keys");
		// dbg scan_keys use $get(ent_owner,keydown,use) atk game.item.attacking
		bool doBreath = false;

		// local L_DBG1 $get(ent_owner,hand0)
		// local L_DBG1 $get(L_DBG1,itemname)
		// local L_DBG2 $get(ent_me,itemname)
		// dbg scan_keys atk1 $get(ent_owner,keydown,attack1) atk2 $get(ent_owner,keydown,attack2) h0 L_DBG1 vs L_DBG2
		if (Truthy(Eval("game.item.attacking")))
		{
			if (IsKeyDown(ENT_OWNER, "use"))
				doBreath = true;
			string active = EntityId(ActiveItemOf(ENT_OWNER));
			active = ItemNameOf(active);
			if (active == ItemNameOf(ENT_ME))
			{
				if (IsKeyDown(ENT_OWNER, "attack2"))
					doBreath = true;
			}
			else if (IsKeyDown(ENT_OWNER, "attack1"))
				doBreath = true;
			DebugPrint("scan_keys atk1 " + Text(IsKeyDown(ENT_OWNER, "attack1")) + " atk2 " + Text(IsKeyDown(ENT_OWNER, "attack2")) + " - " + active + " vs " + ItemNameOf(ENT_ME));
		}

		if (ManaOf(ENT_OWNER) < MP_DRAIN_RATE)
		{
			doBreath = false;
			if (GameTime() > NEXT_MP_WARN)
			{
				NEXT_MP_WARN = GameTime() + 5.0f;
				PlayerMessageDark(ENT_OWNER, "Demonshield: Insufficient mana for fire breath");
			}
		}

		if (doBreath)
		{
			if (!Truthy(BREATH_ON))
				OnStartBreath();
		}
		else if (Truthy(BREATH_ON))
			OnEndBreath();
	}

	// end_breath
	void OnEndBreath()
	{
		BREATH_ON = "0";
		ClientEvent("update", "all", CL_SCRIPT_DX, "end_fx");
		CL_SCRIPT_DX = "CL_SCRIPT_DX";
		ServerPlaySound(2, 0, SOUND_BREATH_LOOP);
	}

	// start_breath
	void OnStartBreath()
	{
		DebugPrint("start_breath");
		if (!(SkillOf(ENT_OWNER, "spellcasting.fire") >= 30.0f))
			return;

		if (CL_SCRIPT_DX == "CL_SCRIPT_DX")
		{
			ClientEvent("new", "all", "items/axes_dragon_cl", IndexOf(ENT_OWNER));
			CL_SCRIPT_DX = LastClientScriptId();
			ServerPlaySound(1, 10, SOUND_BREATH_LOOP);
		}
		BREATH_ON = "1";
		CallEventDelayed(0.1f, "breath_loop");
	}

	// breath_loop
	void OnBreathLoop()
	{
		if (!Truthy(BREATH_ON))
			return;
		CallEventDelayed(0.1f, "breath_loop");

		GiveMana(ENT_OWNER, -MP_DRAIN_RATE);

		OWNER_ANG = AnglesOf(ENT_OWNER);
		OWNER_ORG = Text(OriginOf(ENT_OWNER));

		Vector3 cloudStart = BonePositionOf(ENT_OWNER, 15);
		cloudStart += RelativePosition(OWNER_ANG, Vector3(0, 32, -30)); // a little in front of face (and now down, due to change in player model, I guess)
		Vector3 cloudAng = OWNER_ANG;
		cloudAng.x = -OWNER_ANG.x;

		// offset right or left, based on hand shield is in (only slightly, shield is near center when blocking)
		if (ItemHandIndex() == 0)
			cloudStart += RelativePosition(Vector3(0, 0, 0), Vector3(-10, 0, 0));
		else
			cloudStart += RelativePosition(Vector3(0, 0, 0), Vector3(10, 0, 0));

		ClientEvent("update", "all", CL_SCRIPT_DX, "make_clouds", cloudStart, cloudAng);

		if (!(GameTime() > NEXT_SCAN))
			return;

		NEXT_SCAN = GameTime() + 0.5f;

		BURN_DAMAGE = Text(SkillOf(ENT_OWNER, "spellcasting.fire"));
		BURN_DAMAGE = Text(Divide(Float(BURN_DAMAGE), 2.0f));

		string scanPos = Text(cloudStart);
		scanPos = Text(Vec(scanPos) + RelativePosition(OWNER_ANG, Vector3(0, 128, 0)));

		CallExternal(ENT_OWNER, "ext_box_token", "enemy", 96, scanPos);
		BURN_LIST = ScriptVarOf(ENT_OWNER, "PLR_SCAN_TOKEN");
		if (BURN_LIST == "none")
			return;
		TRACE_START = cloudStart;
		int count = GetTokenCount(BURN_LIST);
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnBurnTargets();
		}
	}

	// burn_targets
	void OnBurnTargets()
	{
		bool exitSub = false;
		string curTarg = GetToken(BURN_LIST, loopIteration);

		// dont burn players outside of PVP
		if (IsPlayer(curTarg) && GAME_PVP == 0)
			exitSub = true;
		if (exitSub)
			return;

		// within the cone
		if (!IsAlive(curTarg))
			return;
		Vector3 targOrg = OriginOf(curTarg);
		if (!WithinCone2D(targOrg, Vec(OWNER_ORG), OWNER_ANG, 30))
			return;
		if (!(RangeTo(curTarg) < 256.0f))
			return;

		// make sure I'm not trying to burn through a wall
		Vector3 traceEnd = OriginOf(curTarg);
		if (!IsPlayer(curTarg))
		{
			// adjust for origin center
			float halfMonHeight = HeightOf(curTarg) * 0.5f;
			traceEnd.z += halfMonHeight;
		}
		string traceCheck = LegacyFunction("get_traceline", TRACE_START, traceEnd, "worldonly");
		if (traceCheck != Text(traceEnd))
			return;

		// burn em
		ApplyEffect(curTarg, "effects/dot_fire", 5.0f, @EntityOf(ENT_OWNER), BURN_DAMAGE, "spellcasting.fire");
		if (!(MaxHealthOf(curTarg) < 10000.0f))
			return;
		if (!(HeightOf(curTarg) < 120.0f))
			return;
		if (Truthy(ScriptVarOf(curTarg, "NPC_OVERSIZED")))
			return;
		Vector3 pushVel = RelativeVelocity(Vector3(0, 200, 110));
		AddVelocity(curTarg, pushVel);
	}

	// shield_pre_block_effect
	// 1: Attacker  2: Inflictor  3: dmg  4: dmg type
	void OnShieldPreBlockEffect(CBaseEntity@ attacker = null, CBaseEntity@ inflictor = null, float damage = 0.0f, string damageType = "")
	{
		if (!Truthy(Eval("game.item.attacking")))
			return;
		if (!Contains(damageType, "fire"))
			return;
		SetDamageInfo("dmg", 0);
		EXIT_BLOCK = true;
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("weapons/p_weapons4.mdl");
		Precache("viewmodels/v_shields.mdl");
		Precache("monsters/goblin/sps_fogfire.wav");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "breath_loop") { OnBreathLoop(); return true; }
		if (name == "burn_targets") { OnBurnTargets(); return true; }
		if (name == "bweapon_effect_activate") { OnBweaponEffectActivate(); return true; }
		if (name == "bweapon_effect_remove") { OnBweaponEffectRemove(Param(params, 0)); return true; }
		if (name == "end_breath") { OnEndBreath(); return true; }
		if (name == "game_deploy") { OnGameDeploy(); return true; }
		if (name == "game_wear") { OnGameWear(Param(params, 0), Param(params, 1), Param(params, 2)); return true; }
		if (name == "melee_end") { OnMeleeEnd(); return true; }
		if (name == "scan_keys") { OnScanKeys(); return true; }
		if (name == "shield_pre_block_effect") { OnShieldPreBlockEffect(EntityParam(params, 0), EntityParam(params, 1), Float(Param(params, 2)), Param(params, 3)); return true; }
		if (name == "shield_spawn") { OnShieldSpawn(); return true; }
		if (name == "start_breath") { OnStartBreath(); return true; }
		return ShieldsBaseScript::DispatchEvent(name, params);
	}
}
