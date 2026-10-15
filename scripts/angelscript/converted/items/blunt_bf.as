#pragma context server

// Converted from items/blunt_bf.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/items/blunt_base_twohanded.as"

[script "items/blunt_bf"]
class BluntBf : BluntBaseTwohandedScript
{
	// Constants
	string BASE_LEVEL_REQ = "35";
	int STUN_BURST_MP = 40;
	float DEMON_DMG_DELAY = 0.25f;
	float DEMON_ATK_DURATION = 0.7f;
	int MODEL_VIEW_IDX = 12;

	// Variables (an unset .script variable reads as its own name)
	int GAME_PVP = 0;
	Vector3 BURST_POS = Vector3();
	float BURST_STUN_DURATION = 0.0f;
	float BURST_DMG = 0.0f;
	float DOT_FIRE = 0.0f;

	// Variables declared by included files, with the value they start with in this script
	BluntBf()
	{
		MELEE_RANGE = "90";
		MELEE_DMG_DELAY = 0.5f;
		MELEE_ATK_DURATION = 1.1f;
		MELEE_ENERGY = 2.0f;
		MELEE_DMG = 600;
		MELEE_DMG_RANGE = 40;
		MELEE_ACCURACY = "80%";
		MELEE_PARRY_AUGMENT = "20%";
		MELEE_DMG_TYPE = "fire";
		MODEL_VIEW = "viewmodels/v_2hblunts.mdl";
		MODEL_WORLD = "weapons/p_weapons4.mdl";
		MODEL_BODY_OFS = "34";
		ANIM_PREFIX = "standard";
	}

	// melee_damaged_other
	string BluntBf_OnMeleeDamagedOther(CBaseEntity@ target = null, float damage = 0.0f, string damageType = "", string damageEvent = "")
	{
		bool exitSub = false;
		string result = "";
		if (IsPlayer(target) && GAME_PVP == 0)
			exitSub = true;
		if (exitSub)
			return result;

		if (RelationshipOf(ENT_OWNER, @target) != "enemy")
			return result;

		float dot = SkillOf(ENT_OWNER, "spellcasting.fire") * 0.5f;
		ApplyEffect(target, "effects/dot_fire", 5.0f, @EntityOf(ENT_OWNER), dot, "bluntarms");
		return result;
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

		SetName("Fire Breaker");
		SetDescription("An Earth Breaker imbued with elemental fire");
		SetWeight(80);
		SetValue(7000);
		SetHudSprite("hand", "hammer");
		SetHudSprite("trade", "194");
	}

	// melee_damaged_other
	string OnMeleeDamagedOther(CBaseEntity@ target = null, float damage = 0.0f, string damageType = "", string damageEvent = "")
	{
		string result = "";
		result = AppendResult(result, BaseMelee_OnMeleeDamagedOther(target, damage, damageType, damageEvent));
		result = AppendResult(result, BluntBf_OnMeleeDamagedOther(target, damage, damageType, damageEvent));
		return result;
	}

	// special_02_strike
	void OnSpecial02Strike(string hitType = "", Vector3 endPos = Vector3(), CBaseEntity@ hitEntity = null, bool hit = false)
	{
		bool exitSub = false;
		Vector3 attackEndPos = endPos;
		// if $vec.z(ATTACK_END_POS) equals $get_ground_height(ATTACK_END_POS)
		if (ManaOf(ENT_OWNER) < STUN_BURST_MP)
		{
			PlayerMessageDark(ENT_OWNER, "Fire Breaker: Insufficient Mana for Fire Burst");
			exitSub = true;
		}
		if (exitSub)
			return;

		attackEndPos.z = GroundHeight(attackEndPos);

		GiveMana(ENT_OWNER, -STUN_BURST_MP);
		ClientEvent("new", "all", "effects/sfx_fire_burst", attackEndPos, 250, 1, Vector3(255, 128, 0));
		BURST_POS = attackEndPos + Vec(Text(32));

		// callexternal ent_owner ext_sphere_token enemy 128 BURST_POS
		// setvard BURST_TARGS $get(ent_owner,scriptvar,'PLR_SCAN_TOKEN')
		// setvard BURST_POS ATTACK_END_POS
		if (SkillOf(ENT_OWNER, "spellcasting.fire") > 20.0f)
			CallExternal(ENT_OWNER, "ext_fissure");

		// if BURST_TARGS isnot none
		BURST_STUN_DURATION = SkillOf(ENT_OWNER, "bluntarms");
		BURST_DMG = BURST_STUN_DURATION;
		BURST_STUN_DURATION *= 0.5f;
		BURST_DMG *= 4.0f;
		DebugPrint("special_02_strike stundur " + Text(BURST_STUN_DURATION));
		DOT_FIRE = SkillOf(ENT_OWNER, "spellcasting.fire");

		// calleventloop $get_token_amt(BURST_TARGS) burst_affect_targs
		// callevent 0.1 aoe_damage
		DoDamageEx(BURST_POS, 128, BURST_DMG, 0, ENT_OWNER, ENT_ME, "spellcasting.fire", "fire_effect", "dmgevent:*burst");
	}

	// burst_dodamage
	void OnBurstDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		bool exitSub = false;
		// $get_token(BURST_TARGS,game.script.iteration)
		if (RelationshipOf(target, ENT_OWNER) != "enemy")
			return;
		if (IsPlayer(target) && GAME_PVP == 0)
			exitSub = true;
		if (exitSub)
			return;
		ApplyEffect(target, "effects/debuff_stun", BURST_STUN_DURATION, self);
		if (DOT_FIRE >= 10.0f)
			ApplyEffect(target, "effects/dot_fire", 5.0f, @EntityOf(ENT_OWNER), DOT_FIRE, "bluntarms");
		Vector3 targOrg = OriginOf(target);
		Vector3 myOrg = BURST_POS;
		float newYaw = AnglesTo(myOrg, targOrg);
		AddVelocity(target, RelativeVelocity(Vector3(0, newYaw, 0), Vector3(0, 800, 110)));
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
		if (name == "burst_dodamage") { OnBurstDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5)); return true; }
		if (name == "game_deploy") { OnGameDeploy(); return true; }
		if (name == "melee_damaged_other") { Return(OnMeleeDamagedOther(EntityParam(params, 0), Float(Param(params, 1)), Param(params, 2), Param(params, 3))); return true; }
		if (name == "special_02_strike") { OnSpecial02Strike(Param(params, 0), Vec(Param(params, 1)), EntityParam(params, 2), Truthy(Param(params, 3))); return true; }
		if (name == "weapon_spawn") { OnWeaponSpawn(); return true; }
		return BluntBaseTwohandedScript::DispatchEvent(name, params);
	}
}
