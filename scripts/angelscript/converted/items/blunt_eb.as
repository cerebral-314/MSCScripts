#pragma context server

// Converted from items/blunt_eb.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/items/blunt_base_twohanded.as"

[script "items/blunt_eb"]
class BluntEb : BluntBaseTwohandedScript
{
	// Constants
	string BASE_LEVEL_REQ = "35";
	int STUN_BURST_MP = 40;
	float DEMON_DMG_DELAY = 0.25f;
	float DEMON_ATK_DURATION = 0.7f;
	int MODEL_VIEW_IDX = 10;

	// Variables (an unset .script variable reads as its own name)
	int GAME_PVP = 0;
	Vector3 BURST_POS = Vector3();
	string BURST_TARGS = "BURST_TARGS";
	float BURST_STUN_DURATION = 0.0f;
	float BURST_DMG = 0.0f;

	// Variables declared by included files, with the value they start with in this script
	BluntEb()
	{
		MELEE_RANGE = "90";
		MELEE_DMG_DELAY = 0.5f;
		MELEE_ATK_DURATION = 1.1f;
		MELEE_ENERGY = 2.0f;
		MELEE_DMG = 600;
		MELEE_DMG_RANGE = 40;
		MELEE_ACCURACY = "80%";
		MELEE_PARRY_AUGMENT = "20%";
		MODEL_VIEW = "viewmodels/v_2hblunts.mdl";
		MODEL_WORLD = "weapons/p_weapons4.mdl";
		MODEL_BODY_OFS = "22";
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

	// weapon_spawn
	void OnWeaponSpawn()
	{
		BaseMelee_OnWeaponSpawn(); // items/base_melee
		BluntBaseOnehanded_OnWeaponSpawn(); // items/blunt_base_onehanded
		BluntBaseTwohanded_OnWeaponSpawn(); // items/blunt_base_twohanded

		SetName("Earth Breaker");
		SetDescription("A gigantic hammer of ground breaking proportions");
		SetWeight(80);
		SetValue(7000);
		SetHudSprite("hand", "hammer");
		SetHudSprite("trade", "51");
	}

	// special_02_strike
	void OnSpecial02Strike(string hitType = "", Vector3 endPos = Vector3(), CBaseEntity@ hitEntity = null, bool hit = false)
	{
		bool exitSub = false;

		if (ManaOf(ENT_OWNER) < STUN_BURST_MP)
		{
			PlayerMessageDark(ENT_OWNER, "Earth Breaker: Insufficient Mana for Stun Burst");
			exitSub = true;
		}
		if (exitSub)
			return;

		GiveMana(ENT_OWNER, -STUN_BURST_MP);
		ClientEvent("new", "all", "effects/sfx_stun_burst", endPos, 250, 1, Vector3(255, 0, 0));
		BURST_POS = endPos + Vec(Text(32));
		CallExternal(ENT_OWNER, "ext_sphere_token", "enemy", 128, BURST_POS);
		BURST_TARGS = ScriptVarOf(ENT_OWNER, "PLR_SCAN_TOKEN");
		BURST_POS = endPos;
		if (BURST_TARGS == "none")
			return;
		BURST_STUN_DURATION = SkillOf(ENT_OWNER, "bluntarms");
		BURST_DMG = BURST_STUN_DURATION;
		BURST_STUN_DURATION *= 0.5f;
		BURST_DMG *= 4.0f;
		DebugPrint("special_02_strike stundur " + Text(BURST_STUN_DURATION));
		int count = GetTokenCount(BURST_TARGS);
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnBurstAffectTargs();
		}
	}

	// burst_affect_targs
	// { aoe_damage
	// local DMG_AMT BURST_STUN_DURATION
	// multiply DMG_AMT 2
	// xdodamage BURST_POS 256 DMG_AMT 0.1 ent_owner ent_me bluntarms blunt
	// }
	void OnBurstAffectTargs()
	{
		bool exitSub = false;
		string curTarg = GetToken(BURST_TARGS, loopIteration);
		if (IsPlayer(curTarg) && GAME_PVP == 0)
			exitSub = true;
		if (exitSub)
			return;
		ApplyEffect(curTarg, "effects/debuff_stun", BURST_STUN_DURATION, self);
		Vector3 targOrg = OriginOf(curTarg);
		Vector3 myOrg = BURST_POS;
		float newYaw = AnglesTo(myOrg, targOrg);
		AddVelocity(curTarg, RelativeVelocity(Vector3(0, newYaw, 0), Vector3(0, 800, 110)));
		DoDamageEx(curTarg, 256, BURST_DMG, "100%", ENT_OWNER, ENT_ME, "bluntarms", "blunt");
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("weapons/p_weapons4.mdl");
		Precache("viewmodels/v_2hblunts.mdl");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "burst_affect_targs") { OnBurstAffectTargs(); return true; }
		if (name == "game_deploy") { OnGameDeploy(); return true; }
		if (name == "special_02_strike") { OnSpecial02Strike(Param(params, 0), Vec(Param(params, 1)), EntityParam(params, 2), Truthy(Param(params, 3))); return true; }
		if (name == "weapon_spawn") { OnWeaponSpawn(); return true; }
		return BluntBaseTwohandedScript::DispatchEvent(name, params);
	}
}
