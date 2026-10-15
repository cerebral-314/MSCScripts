#pragma context server

// Converted from items/bows_crossbow_light.script by msc_transpiler.
// Thothie - Adding more conventional naming terms in hopes of matching Jester's model

#include "runtime/ScriptEntity.as"
#include "converted/items/base_weapon.as"

[script "items/bows_crossbow_light"]
class BowsCrossbowLight : BaseWeaponScript
{
	// Constants
	bool NO_PARRY = true;
	string ANIM_IDLE = "0";
	string ANIM_DEPLOY = "8";
	string ANIM_RELOAD = "7";
	string ANIM_FIRE = "4";
	string MODEL_WEAR = "weapons/p_weapons2.mdl";
	string SOUND_SHOOT = "weapons/bow/crossbow.wav";
	string ITEM_NAME = "xbow";
	string MODEL_BODY_OFS = "52";
	bool NO_WORLD_MODEL = true;
	float XBOW_RELOAD_TIME = 2.0f;
	string ANIM_PREFIX = "orcbow";
	string RANGED_PROJECTILE = "bolt";
	string RANGED_HOLD_MINMAX = "0;0";
	string RANGED_ATK_DURATION = "0.0";
	string RANGED_DMG_TYPE = "pierce";
	string RANGED_STAT = "archery";
	Vector3 RANGED_AIMANGLE = Vector3();
	float RANGED_DMG_DELAY = 0.0f;
	int RANGED_NOISE = 10;
	float RANGED_ENERGY = 20.0f;
	Vector3 RANGED_STARTPOS = Vector3();
	string RANGED_ACCURACY = "0;0";
	int RANGED_FORCE = 1000;

	// Variables (an unset .script variable reads as its own name)
	string WEAPON_PRIMARY_SKILL = "WEAPON_PRIMARY_SKILL";
	bool STRETCHED = false;
	bool XBOW_RELOADING = false;

	// Variables declared by included files, with the value they start with in this script
	BowsCrossbowLight()
	{
		MODEL_VIEW = "viewmodels/v_xbows.mdl";
		MODEL_HANDS = "weapons/p_weapons2.mdl";
		MODEL_WORLD = "weapons/p_weapons2.mdl";
	}

	// unnamed block (first think)
	void BowsCrossbowLight_FirstThink()
	{
		WEAPON_PRIMARY_SKILL = RANGED_STAT;
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
		// (never true here, the rest is skipped) if game.clientside
	}

	// weapon_spawn
	void OnWeaponSpawn()
	{
		SetName("Crossbow");
		SetDescription("An accurate, long range crossbow");
		SetWeight(1);
		SetValue(300);
		SetWearable(0);
		SetAnimExtension("bow");
		SetWorldModel(MODEL_WORLD);
		SetViewModel(MODEL_VIEW);
		SetPlayerModel(MODEL_HANDS);
		SetHand("both");
		SetHudSprite("hand", "bow");
		SetHudSprite("trade", "xbow");
		OnRegisterBow();
		SetModelBody(0, 0); // For Jesters upcoming model
	}

	// register_bow
	void OnRegisterBow()
	{
		// Normal attack
		SetLocal("reg.attack.type", "charge-throw-projectile");
		SetLocal("reg.attack.keys", "+attack1");
		SetLocal("reg.attack.hold_min&max", "0.1;0.1");
		SetLocal("reg.attack.dmg.type", "pierce");
		SetLocal("reg.attack.range", 400);
		SetLocal("reg.attack.energydrain", 0);
		SetLocal("reg.attack.stat", "archery");
		SetLocal("reg.attack.COF", 0);
		SetLocal("reg.attack.projectile", "bolt");
		SetLocal("reg.attack.priority", 10);
		SetLocal("reg.attack.delay.strike", 0.0f);
		SetLocal("reg.attack.delay.end", XBOW_RELOAD_TIME); // reload time, I think
		SetLocal("reg.attack.ofs.startpos", RANGED_STARTPOS);
		SetLocal("reg.attack.ofs.aimang", RANGED_AIMANGLE);
		SetLocal("reg.attack.callback", "ranged");
		SetLocal("reg.attack.noise", 10);

		RegisterAttack();
	}

	// ranged_start
	// Call from dll
	void OnRangedStart()
	{
		if (XBOW_RELOADING)
			return;
		PlayOwnerAnim("hold", "xbow_idle", "global.anim.combatwalk");
	}

	// ranged_toss
	// { //Stretched animation loop
	// repeatdelay 3.35
	// playowneranim hold xbow_idle global.anim.combatwalk
	// }
	// Called from dll
	void OnRangedToss()
	{
		PlayViewAnim(Int(ANIM_FIRE));
		PlaySound(Int(Eval("game.sound.weapon")), Eval("game.sound.maxvol"), SOUND_SHOOT);
		PlayOwnerAnim("critical", "xbow_reload", "global.anim.combatwalk");
		STRETCHED = false;
		CallEventDelayed(0.2f, "reload_now");
		string heavyoneText = ScriptVarOf(ENT_LASTPROJECTILE, "HEAVY_BOLT");
		int heavyone = Int(heavyoneText);
		if (heavyoneText == "HEAVY_BOLT")
			CallExternal(ENT_LASTPROJECTILE, "ext_lighten", 0.01f);
		if (heavyone > 0)
			CallExternal(ENT_LASTPROJECTILE, "ext_lighten", heavyoneText);
	}

	// reload_now
	void OnReloadNow()
	{
		PlayViewAnim(Int(ANIM_RELOAD));
	}

	// ranged_end
	// Called from dll
	void OnRangedEnd()
	{
		OnDoneReload();
	}

	// done_reload
	void OnDoneReload()
	{
		PlayViewAnim(Int(ANIM_IDLE));
		XBOW_RELOADING = false;
	}

	// ranged_returnstanding
	void OnRangedReturnstanding()
	{
		if (Truthy(Eval("game.item.attacking")))
			return;
		PlayOwnerAnim("critical", "bow_aim_to_stand", "global.anim.combatwalk");
	}

	// ranged_noammo
	// testing MS.DLL tweaks, no go so far
	void OnRangedNoammo()
	{
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("weapons/p_weapons2.mdl");
		Precache("viewmodels/v_xbows.mdl");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		BowsCrossbowLight_FirstThink();
		BaseWeapon_FirstThink();
		BaseItem_FirstThink();
		BaseItemExtras_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "done_reload") { OnDoneReload(); return true; }
		if (name == "game_deploy") { OnGameDeploy(); return true; }
		if (name == "ranged_end") { OnRangedEnd(); return true; }
		if (name == "ranged_noammo") { OnRangedNoammo(); return true; }
		if (name == "ranged_returnstanding") { OnRangedReturnstanding(); return true; }
		if (name == "ranged_start") { OnRangedStart(); return true; }
		if (name == "ranged_toss") { OnRangedToss(); return true; }
		if (name == "register_bow") { OnRegisterBow(); return true; }
		if (name == "reload_now") { OnReloadNow(); return true; }
		if (name == "weapon_spawn") { OnWeaponSpawn(); return true; }
		return BaseWeaponScript::DispatchEvent(name, params);
	}
}
