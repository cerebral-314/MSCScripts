#pragma context server

// Converted from items/smallarms_vt.script by msc_transpiler.
// Vorpal Tongue (Vampyric + FireDOT + FreezeBurst)

#include "runtime/ScriptEntity.as"
#include "converted/items/smallarms_eth.as"

[script "items/smallarms_vt"]
class SmallarmsVt : SmallarmsEthScript
{
	// Variables declared by included files, with the value they start with in this script
	SmallarmsVt()
	{
		BASE_LEVEL_REQ = "30";
		CUSTOM_REGISTER_SECONDARY = true;
		CUSTOM_SWING = true;
		ANIM_LIFT1 = 0;
		ANIM_IDLE1 = "1";
		ANIM_WIELD = 2;
		ANIM_UNWIELD = 3;
		ANIM_WIELDEDIDLE1 = 4;
		ANIM_ATTACK1 = "23";
		ANIM_ATTACK2 = "6";
		MODEL_VIEW_IDX = 13;
		MODEL_BODY_OFS = "66";
		MELEE_DMG = 250;
		MELEE_ATK_DURATION = 0.5f;
	}

	// game_dodamage
	string SmallarmsVt_OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		bool exitSub = false;
		string result = "";
		if (!hit)
			return result;
		if (IsPlayer(target) && GAME_PVP == 0)
			exitSub = true;
		if (exitSub)
			return result;

		float dotBurn = SkillOf(ENT_OWNER, "spellcasting.fire") * 0.5f;
		ApplyEffect(target, "effects/dot_fire", 5.0f, @EntityOf(ENT_OWNER), dotBurn, "smallarms");
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
		SmallarmsBase_OnGameDeploy(); // items/smallarms_base
		GAME_PVP = (IsPvp() ? 1 : 0);
	}

	// weapon_spawn
	void OnWeaponSpawn()
	{
		BaseMelee_OnWeaponSpawn(); // items/base_melee
		SmallarmsBase_OnWeaponSpawn(); // items/smallarms_base
		SmallarmsEth_OnWeaponSpawn(); // items/smallarms_eth
		SetName("Vorpal Tongue");
		SetDescription("Layers of magic have been sewn into this ethereal dagger");
		SetWeight(3);
		SetValue(5000);
		SetHudSprite("hand", "141");
		SetHudSprite("trade", "141");
	}

	// register_secondary
	void OnRegisterSecondary()
	{
		SmallarmsBase_OnRegisterSecondary(); // items/smallarms_base

		SetLocal("reg.attack.type", "strike-land");
		SetLocal("reg.attack.keys", "-attack1");
		SetLocal("reg.attack.range", MELEE_RANGE);
		SetLocal("reg.attack.dmg", 1);
		SetLocal("reg.attack.dmg.range", 1);
		SetLocal("reg.attack.dmg.type", "ice");
		SetLocal("reg.attack.energydrain", 9999);
		SetLocal("reg.attack.stat", "spellcasting.ice");
		SetLocal("reg.attack.hitchance", MELEE_ACCURACY);
		SetLocal("reg.attack.priority", 2);
		SetLocal("reg.attack.delay.strike", 1.5f);
		SetLocal("reg.attack.delay.end", 1.8f);
		SetLocal("reg.attack.ofs.startpos", "MELEE_STARTPOS");
		SetLocal("reg.attack.ofs.aimang", "MELEE_AIMANGLE");
		SetLocal("reg.attack.callback", "freeze_burst");
		SetLocal("reg.attack.noise", 1000);
		SetLocal("reg.attack.chargeamt", "200%");
		SetLocal("reg.attack.reqskill", 1);
		SetLocal("reg.attack.dmg.ignore", 1);
		SetLocal("reg.attack.mpdrain", 75);

		RegisterAttack();
	}

	// special_01_start
	void OnSpecial01Start()
	{
		PlayViewAnim(Int(ANIM_ATTACK2));
		ServerPlaySound(1, 10, ScriptVarOf(ENT_OWNER, "PLR_SOUND_JAB2"));
	}

	// freeze_burst_start
	void OnFreezeBurstStart()
	{
		PlayViewAnim(2);

		PlaySound(0, 10, "magic/frost_reverse.wav");

		Effect("glow", ENT_OWNER, Vector3(0, 75, 255), 128, 5.0f, 5.0f);
	}

	// freeze_burst_strike
	void OnFreezeBurstStrike(string hitType = "", Vector3 endPos = Vector3(), CBaseEntity@ hitEntity = null, bool hit = false)
	{
		// local ICE_BURST_DAMAGE $get(ent_owner,skill.spellcasting.ice)
		// createnpc monsters/summon/ice_burst $relpos(0,0,-32) $get(ent_owner,id) ICE_BURST_DAMAGE smallarms
		ClientEvent("new", "all", "monsters/summon/ice_burst_cl", IndexOf(ENT_OWNER));

		BURST_DAMAGE = SkillOf(ENT_OWNER, "spellcasting.ice");
		CallExternal(ENT_OWNER, "ext_sphere_token_x", "enemy", 256);
		TARG_LIST = ScriptVarOf(ENT_OWNER, "PLR_SCAN_TOKEN");
		if (TARG_LIST == "none")
			return;
		int count = GetTokenCount(TARG_LIST);
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnBurstAffectTargets();
			if (breakLoop)
			{
				breakLoop = false;
				break;
			}
		}
	}

	// burst_affect_targets
	void OnBurstAffectTargets()
	{
		bool exitSub = false;
		string curTarg = GetToken(TARG_LIST, loopIteration);

		if (GAME_PVP == 0 && IsPlayer(curTarg))
			exitSub = true;
		if (exitSub)
			return;

		int freezeOnChance = RandomInt(1, 2);
		if (freezeOnChance == 1)
			ApplyEffect(curTarg, "effects/dot_cold", 10, @EntityOf(ENT_OWNER), RandomInt(10, int(BURST_DAMAGE)), "smallarms");
		if (freezeOnChance == 2)
		{
			if (HealthOf(curTarg) > 1500.0f)
				ApplyEffect(curTarg, "effects/dot_cold", 10, "MY_OWNER", RandomInt(10, int(BURST_DAMAGE)), "smallarms");
			if (HealthOf(curTarg) <= 1500.0f)
				ApplyEffect(curTarg, "effects/dot_cold_freeze", 5, @EntityOf(ENT_OWNER), RandomInt(10, 20));
		}
	}

	string OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "") { return SmallarmsVt_OnGameDodamage(hit, target, start, end, damageType, damageText); } // game_dodamage

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "burst_affect_targets") { OnBurstAffectTargets(); return true; }
		if (name == "freeze_burst_start") { OnFreezeBurstStart(); return true; }
		if (name == "freeze_burst_strike") { OnFreezeBurstStrike(Param(params, 0), Vec(Param(params, 1)), EntityParam(params, 2), Truthy(Param(params, 3))); return true; }
		if (name == "game_deploy") { OnGameDeploy(); return true; }
		if (name == "game_dodamage") { Return(OnGameDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5))); return true; }
		if (name == "register_secondary") { OnRegisterSecondary(); return true; }
		if (name == "special_01_start") { OnSpecial01Start(); return true; }
		if (name == "weapon_spawn") { OnWeaponSpawn(); return true; }
		return SmallarmsEthScript::DispatchEvent(name, params);
	}
}
