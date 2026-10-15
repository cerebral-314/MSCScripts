#pragma context server

// Converted from items/blunt_lrod11.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/items/blunt_base_onehanded.as"

[script "items/blunt_lrod11"]
class BluntLrod11 : BluntBaseOnehandedScript
{
	// Constants
	string BASE_LEVEL_REQ = "20";
	int MODEL_VIEW_IDX = 5;
	string SOUND_CHARGE = "magic/lightning_powerup.wav";
	string SOUND_THUNDER = "weather/Storm_exclamation.wav";
	string SOUND_SHOCK1 = "debris/zap8.wav";
	string SOUND_SHOCK2 = "debris/zap3.wav";
	string SOUND_SHOCK3 = "debris/zap4.wav";

	// Variables (an unset .script variable reads as its own name)
	int SPEC_ATTACK = 0;

	// Variables declared by included files, with the value they start with in this script
	BluntLrod11()
	{
		MODEL_VIEW = "viewmodels/v_1hblunts.mdl";
		MODEL_HANDS = "weapons/p_weapons2.mdl";
		MODEL_WORLD = "weapons/p_weapons2.mdl";
		MODEL_BODY_OFS = "94";
		MELEE_ATK_DURATION = 1.1f;
		MELEE_DMG_TYPE = "lightning";
		MELEE_RANGE = "60";
		MELEE_DMG_DELAY = 0.6f;
		MELEE_ENERGY = 8.0f;
		MELEE_DMG = 230;
		MELEE_DMG_RANGE = 140;
		MELEE_ACCURACY = "75%";
		ANIM_PREFIX = "dagger";
	}

	// game_dodamage
	// 1: Attack Hit (1/0)  2: Entity Attack hit  3:  Start Position  4:  End Position
	string BluntLrod11_OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		bool exitSub = false;
		string result = "";

		if (!hit)
			return result;
		if (SPEC_ATTACK == 0 && RandomInt(1, 5) != 1)
			exitSub = true;
		if (exitSub)
			return result;

		SPEC_ATTACK = 0;
		float burnDamage = Divide(SkillOf(ENT_OWNER, "spellcasting.lightning"), 2.0f) + Random(1, 3);
		if (burnDamage < 5.0f)
			burnDamage = 5.0f;
		ApplyEffect(target, "effects/dot_lightning", 5, @EntityOf(ENT_OWNER), burnDamage);
		return result;
	}

	// repulse_start
	void BluntLrod11_OnRepulseStart()
	{
		PlayViewAnim(5);
		PlaySound(0, 10, SOUND_CHARGE);
	}

	// repulse_start
	void BluntLrod11_OnRepulseStart_2()
	{
		PlayViewAnim(5);
		PlayOwnerAnim("critical", "bow_release");

		CreateNpc("monsters/summon/lightning_repulse", OriginOf(ENT_OWNER), @EntityOf(ENT_OWNER), 512, 3.0f, 0, "spellcasting.lightning");
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

		PlaySound(0, 10, SOUND_THUNDER);
	}

	// weapon_spawn
	void OnWeaponSpawn()
	{
		BaseMelee_OnWeaponSpawn(); // items/base_melee
		BluntBaseOnehanded_OnWeaponSpawn(); // items/blunt_base_onehanded

		SetName("Lightning Rod");
		SetDescription("A rare enchanted mace.");
		SetValue(3000);
		SetHudSprite("hand", "112");
		SetHudSprite("trade", "112");
	}

	// register_charge1
	void OnRegisterCharge1()
	{
		BaseMelee_OnRegisterCharge1(); // items/base_melee

		SetLocal("reg.attack.type", "strike-land");
		SetLocal("reg.attack.noautoaim", 1);
		SetLocal("reg.attack.keys", "-attack1");
		SetLocal("reg.attack.range", 4096);
		SetLocal("reg.attack.dmg", 800);
		SetLocal("reg.attack.dmg.range", 0);
		SetLocal("reg.attack.dmg.type", "lightning");
		SetLocal("reg.attack.energydrain", 2);
		SetLocal("reg.attack.stat", "spellcasting.lightning");
		SetLocal("reg.attack.hitchance", "100%");
		SetLocal("reg.attack.priority", 3);
		SetLocal("reg.attack.delay.strike", 0.2f);
		SetLocal("reg.attack.delay.end", 0.9f);
		SetLocal("reg.attack.ofs.startpos", "MELEE_STARTPOS");
		SetLocal("reg.attack.ofs.aimang", "MELEE_AIMANGLE");
		SetLocal("reg.attack.callback", "bolt");
		SetLocal("reg.attack.noise", MELEE_NOISE);
		SetLocal("reg.attack.chargeamt", "300%");
		SetLocal("reg.attack.reqskill", 18);
		SetLocal("reg.attack.mpdrain", 50);
		RegisterAttack();

		SetLocal("reg.attack.type", "strike-land");
		SetLocal("reg.attack.keys", "-attack1");
		SetLocal("reg.attack.range", 4096);
		SetLocal("reg.attack.dmg", 1);
		SetLocal("reg.attack.dmg.range", 1);
		SetLocal("reg.attack.dmg.type", "target");
		SetLocal("reg.attack.energydrain", 2);
		SetLocal("reg.attack.stat", "spellcasting.lightning");
		SetLocal("reg.attack.hitchance", "100%");
		SetLocal("reg.attack.priority", 4);
		SetLocal("reg.attack.delay.strike", 0.2f);
		SetLocal("reg.attack.delay.end", 0.9f);
		SetLocal("reg.attack.ofs.startpos", "MELEE_STARTPOS");
		SetLocal("reg.attack.ofs.aimang", "MELEE_AIMANGLE");
		SetLocal("reg.attack.callback", "repulse");
		SetLocal("reg.attack.noise", MELEE_NOISE);
		SetLocal("reg.attack.chargeamt", "400%");
		SetLocal("reg.attack.reqskill", 20);
		SetLocal("reg.attack.mpdrain", 75);
		RegisterAttack();
	}

	// special_02_start
	void OnSpecial02Start()
	{
		BluntBaseOnehanded_OnSpecial02Start(); // items/blunt_base_onehanded
		SPEC_ATTACK = 1;
	}

	string OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "") { return BluntLrod11_OnGameDodamage(hit, target, start, end, damageType, damageText); } // game_dodamage

	// bolt_start
	void OnBoltStart()
	{
		PlayViewAnim(5);
		PlaySound(0, 10, SOUND_CHARGE);
	}

	// bolt_strike
	// PARAM1: "none"/"npc"/"world"   2: Attack end Position   3: Entity hit (if any)
	void OnBoltStrike(string hitType = "", Vector3 endPos = Vector3(), CBaseEntity@ hitEntity = null, bool hit = false)
	{
		bool noEffect = false;

		PlayViewAnim(5);
		PlayOwnerAnim("critical", "bow_release");

		Effect("beam", "point", "lgtning.spr", 30, OriginOf(ENT_ME), endPos, Vector3(200, 255, 50), 200, 30, 1.0f);
		PlayRandomSound(0, 10, SOUND_SHOCK1, SOUND_SHOCK2, SOUND_SHOCK3);
		float burnDamage = SkillOf(ENT_OWNER, "spellcasting.lightning") + Random(1, 3);
		if (burnDamage < 5.0f)
			burnDamage = 5.0f;
		burnDamage *= 2.0f;

		if (IsAlive(hitEntity))
		{
			if (IsPlayer(hitEntity) && (IsPvp() ? 1 : 0) < 1)
				noEffect = true;
			if (!noEffect)
				ApplyEffect(hitEntity, "effects/dot_lightning", 5, @EntityOf(ENT_OWNER), burnDamage, "spellcasting.lightning");
		}
	}

	// repulse_start
	void OnRepulseStart()
	{
		BluntLrod11_OnRepulseStart();
		BluntLrod11_OnRepulseStart_2();
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("weapons/p_weapons2.mdl");
		Precache("viewmodels/v_1hblunts.mdl");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "bolt_start") { OnBoltStart(); return true; }
		if (name == "bolt_strike") { OnBoltStrike(Param(params, 0), Vec(Param(params, 1)), EntityParam(params, 2), Truthy(Param(params, 3))); return true; }
		if (name == "game_deploy") { OnGameDeploy(); return true; }
		if (name == "game_dodamage") { Return(OnGameDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5))); return true; }
		if (name == "register_charge1") { OnRegisterCharge1(); return true; }
		if (name == "repulse_start") { OnRepulseStart(); return true; }
		if (name == "special_02_start") { OnSpecial02Start(); return true; }
		if (name == "weapon_spawn") { OnWeaponSpawn(); return true; }
		return BluntBaseOnehandedScript::DispatchEvent(name, params);
	}
}
