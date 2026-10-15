#pragma context server

// Converted from items/bows_crossbow_heavy33.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/items/base_weapon.as"

[script "items/bows_crossbow_heavy33"]
class BowsCrossbowHeavy33 : BaseWeaponScript
{
	// Constants
	string BASE_LEVEL_REQ = "20";
	bool NO_PARRY = true;
	string ANIM_IDLE = "12";
	int ANIM_IDLE_DEEP1 = 13;
	int ANIM_IDLE_DEEP2 = 14;
	string ANIM_DEPLOY = "20";
	string ANIM_RELOAD = "19";
	string ANIM_FIRE = "16";
	int MODEL_VIEW_IDX = 1;
	string MODEL_WEAR = "weapons/p_weapons3.mdl";
	string SOUND_SHOOT = "weapons/bow/crossbow.wav";
	string ITEM_NAME = "xbow";
	string MODEL_BODY_OFS = "13";
	bool NO_WORLD_MODEL = true;
	float XBOW_RELOAD_TIME = 3.0f;
	string ANIM_PREFIX = "standard";
	string RANGED_PROJECTILE = "bolt";
	string RANGED_HOLD_MINMAX = "0;0";
	string RANGED_ATK_DURATION = "0.0";
	string RANGED_DMG_TYPE = "pierce";
	string RANGED_STAT = "archery";
	float RANGED_DMG_DELAY = 0.0f;
	int RANGED_NOISE = 10;
	float RANGED_ENERGY = 20.0f;
	float RANGED_DMG_MULTI = 2.0f;
	Vector3 RANGED_AIMANGLE = Vector3();
	Vector3 RANGED_STARTPOS = Vector3();
	string RANGED_ACCURACY = "0;0";
	int RANGED_FORCE = 1000;
	bool NO_IDLE = true;

	// Variables (an unset .script variable reads as its own name)
	string WEAPON_PRIMARY_SKILL = "WEAPON_PRIMARY_SKILL";
	bool STRETCHED = false;
	bool XBOW_RELOADING = false;
	bool UNDER_SKILLED = false;
	float HITSCAN_DMG_MULTI = 0.0f;

	// Variables declared by included files, with the value they start with in this script
	BowsCrossbowHeavy33()
	{
		MODEL_VIEW = "viewmodels/v_xbows.mdl";
		MODEL_HANDS = "weapons/p_weapons3.mdl";
		MODEL_WORLD = "weapons/p_weapons3.mdl";
	}

	// unnamed block (first think)
	void BowsCrossbowHeavy33_FirstThink()
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

		if (!Truthy(ScriptVarOf(ENT_OWNER, "GAVE_MAP_INTRO")))
			return;

		CallEventDelayed(0.1f, "check_newb");
	}

	// weapon_spawn
	void OnWeaponSpawn()
	{
		SetName("Heavy Crossbow");
		SetDescription("This mighty crossbow has some kick to it");
		SetWeight(1);
		SetValue(3000);
		SetWearable(0);
		SetAnimExtension("bow");
		SetWorldModel(MODEL_WORLD);
		SetViewModel(MODEL_VIEW);
		SetPlayerModel(MODEL_HANDS);
		SetHand("both");
		SetHudSprite("hand", "127");
		SetHudSprite("trade", "127");
		OnRegisterBow();
	}

	// register_bow
	void OnRegisterBow()
	{
		// Normal attack
		SetLocal("reg.attack.type", "charge-throw-projectile");
		SetLocal("reg.attack.keys", "+attack1");
		SetLocal("reg.attack.hold_min&max", "0.1;0.1");
		SetLocal("reg.attack.noautoaim", 1);
		SetLocal("reg.attack.dmg.type", "pierce");
		SetLocal("reg.attack.range", 600);
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
		SetLocal("reg.attack.dmg.multi", RANGED_DMG_MULTI); // this has no affect on hitscan arrows, thus we define this in game_deploy and let the arrows read the value from the weapon
		SetLocal("reg.attack.noise", 10);

		RegisterAttack();
	}

	// ranged_start
	// Call from dll
	void OnRangedStart()
	{
		if (XBOW_RELOADING)
			CancelAttack();

		if (XBOW_RELOADING)
			return;
		PlayOwnerAnim("hold", "xbow_idle", "global.anim.combatwalk");
	}

	// ranged_toss
	// { //Stretched animation loop
	// repeatdelay 3.35
	// playowneranim hold xbow_idle
	// }
	// Called from dll
	void OnRangedToss()
	{
		PlayViewAnim(Int(ANIM_FIRE));
		PlaySound(Int(Eval("game.sound.weapon")), Eval("game.sound.maxvol"), SOUND_SHOOT);
		PlayOwnerAnim("critical", "xbow_reload", "global.anim.combatwalk");
		XBOW_RELOADING = true;
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
		PlayOwnerAnim("critical", "xbow_reload", "global.anim.combatwalk");
		CallEventDelayed(XBOW_RELOAD_TIME, "done_reload");
	}

	// done_reload
	// { ranged_end	//Called from dll
	// callevent done_reload
	// }
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

	// check_newb
	void OnCheckNewb()
	{
		string findMeleeStat = "skill." + RANGED_STAT;
		if (Float(GetProp(ENT_OWNER, findMeleeStat)) < Float(BASE_LEVEL_REQ))
		{
			PlayerMessageDark(ENT_OWNER, "You lack the skill to properly wield this weapon!");
			string outStr = "You lack the proficiency to wield this weapon. ( requires: " + RANGED_STAT;
			outStr += " proficiency " + BASE_LEVEL_REQ + " )";
			InfoMessage(ENT_OWNER, "Insufficient Skill", outStr);
			SetAttackProp(ENT_ME, 0, "COF.l", 40);
			SetAttackProp(ENT_ME, 0, "COF.r", 40);
			SetAttackProp(ENT_ME, 0, "dmg.multi", 0.1f);
			UNDER_SKILLED = true;
		}
		else
		{
			if (UNDER_SKILLED)
			{
				SetAttackProp(ENT_ME, 0, "COF.l", 0);
				SetAttackProp(ENT_ME, 0, "COF.r", 0);
				SetAttackProp(ENT_ME, 0, "dmg.multi", RANGED_DMG_MULTI);
			}
			UNDER_SKILLED = false;
		}

		if (!UNDER_SKILLED)
			HITSCAN_DMG_MULTI = RANGED_DMG_MULTI;
		else
			HITSCAN_DMG_MULTI = 0.1f;
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files
	void OnXbowReloadTime() {} // XBOW_RELOAD_TIME

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("weapons/p_weapons3.mdl");
		Precache("viewmodels/v_xbows.mdl");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		BowsCrossbowHeavy33_FirstThink();
		BaseWeapon_FirstThink();
		BaseItem_FirstThink();
		BaseItemExtras_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "check_newb") { OnCheckNewb(); return true; }
		if (name == "done_reload") { OnDoneReload(); return true; }
		if (name == "game_deploy") { OnGameDeploy(); return true; }
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
