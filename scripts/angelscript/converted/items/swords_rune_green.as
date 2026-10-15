#pragma context server

// Converted from items/swords_rune_green.script by msc_transpiler.
// Green Rune Blade from ESS by Thothie
// abilities-
// - cast acidic bolt (req: affliction level 5)
// - cast poison cloud (req: affliction level 20)
// - Offers 50% poison damage reduction

#include "runtime/ScriptEntity.as"
#include "converted/items/base_elemental_resist.as"
#include "converted/items/swords_base_onehanded.as"
#include "converted/items/base_varied_attacks.as"

[script "items/swords_rune_green"]
class SwordsRuneGreen : SwordsBaseOnehandedScript, BaseElementalResist, BaseVariedAttacks
{
	// Constants
	string ELM_NAME = "possw";
	string ELM_TYPE = "poison";
	float ELM_AMT = 50.0f;
	bool ELM_WEAPON = true;
	string SOUND_CHARGE = "bullchicken/bc_attack1.wav";
	string SOUND_SHOOT = "bullchicken/bc_attack3.wav";
	string SOUND_SPAWN_CLOUD = "ambience/steamburst1.wav";
	string BASE_LEVEL_REQ = "15";
	int ANIM_ATTACK4 = 5;
	int ANIM_ATTACK5 = 6;
	int MODEL_VIEW_IDX = 4;
	string SOUND_SHOUT = "SOUND_SHOUT";

	// Variables (an unset .script variable reads as its own name)
	int SWING_ANIM = 0;

	// Variables declared by included files, with the value they start with in this script
	SwordsRuneGreen()
	{
		ANIM_SHEATH = 7;
		ATTACK_ANIMS = 4;
		MODEL_VIEW = "viewmodels/v_1hswordssb.mdl";
		MODEL_HANDS = "weapons/p_weapons2.mdl";
		MODEL_WORLD = "weapons/p_weapons2.mdl";
		SOUND_SWIPE = "weapons/swingsmall.wav";
		SOUND_HITWALL1 = "bullchicken/bc_acid1.wav";
		SOUND_HITWALL2 = "bullchicken/bc_acid2.wav";
		MODEL_BODY_OFS = "108";
		ANIM_PREFIX = "dagger";
		MELEE_RANGE = "64";
		MELEE_DMG_DELAY = 0.4f;
		MELEE_ATK_DURATION = 0.8f;
		MELEE_ENERGY = 1.0f;
		MELEE_DMG = 150;
		MELEE_DMG_RANGE = 70;
		MELEE_DMG_TYPE = "acid";
		MELEE_ACCURACY = "75%";
		MELEE_STAT = "swordsmanship";
		MELEE_ALIGN_BASE = "4,-6";
		MELEE_ALIGN_TIP = "0,6";
		MELEE_PARRY_CHANCE = "5%";
	}

	// weapon_spawn
	void SwordsRuneGreen_OnWeaponSpawn()
	{
		SetName("Rune Blade of Affliction");
		SetDescription("A blade of vile magics");
		SetWeight(35);
		SetValue(3500);
		SetHudSprite("trade", "116");
	}

	// weapon_spawn
	void SwordsRuneGreen_OnWeaponSpawn_2()
	{
		SetLocal("reg.attack.type", "charge-throw-projectile");
		SetLocal("reg.attack.hold_min&max", "2;2");
		SetLocal("reg.attack.dmg.type", "acid");
		SetLocal("reg.attack.range", 600);
		SetLocal("reg.attack.COF", 0);
		SetLocal("reg.attack.stat", "spellcasting.affliction");
		SetLocal("reg.attack.keys", "-attack1");
		SetLocal("reg.attack.noise", 1000);
		SetLocal("reg.attack.energydrain", 5);
		SetLocal("reg.attack.noautoaim", 0);
		SetLocal("reg.attack.projectile", "proj_acid_bolt");
		SetLocal("reg.attack.priority", 2);
		SetLocal("reg.attack.delay.strike", 0);
		SetLocal("reg.attack.delay.end", 0);
		SetLocal("reg.attack.ofs.startpos", Vector3(5, 10, -5));
		SetLocal("reg.attack.ofs.aimang", "RANGED_AIMANGLE");
		SetLocal("reg.attack.ammodrain", 0);
		SetLocal("reg.attack.callback", "bolt");
		SetLocal("reg.attack.chargeamt", "200%");
		SetLocal("reg.attack.reqskill", 5);

		RegisterAttack();

		SetLocal("reg.attack.type", "strike-land");
		SetLocal("reg.attack.keys", "-attack1");
		SetLocal("reg.attack.range", 800);
		SetLocal("reg.attack.dmg", 1);
		SetLocal("reg.attack.dmg.range", MELEE_DMG_RANGE);
		SetLocal("reg.attack.dmg.type", "poison");
		SetLocal("reg.attack.energydrain", MELEE_ENERGY);
		LegacyCommand("multiply", "reg.attack.energydrain", 2);
		SetLocal("reg.attack.stat", "spellcasting.affliction");
		SetLocal("reg.attack.hitchance", "100%");
		SetLocal("reg.attack.priority", 3);
		SetLocal("reg.attack.delay.strike", 1.5f);
		SetLocal("reg.attack.delay.end", 2.0f);
		SetLocal("reg.attack.ofs.startpos", "MELEE_STARTPOS");
		SetLocal("reg.attack.ofs.aimang", "MELEE_AIMANGLE");
		SetLocal("reg.attack.callback", "cloudon");
		SetLocal("reg.attack.noise", 1000);
		SetLocal("reg.attack.chargeamt", "300%");
		SetLocal("reg.attack.reqskill", 20);

		RegisterAttack();
	}

	// game_deploy
	void OnGameDeploy()
	{
		BaseElementalResist_OnGameDeploy(); // items/base_elemental_resist
		BaseItemExtras_OnGameDeploy(); // items/base_item_extras
		BaseItemExtras_OnGameDeploy_2(); // items/base_item_extras
		BaseItemExtras_OnGameDeploy_3(); // items/base_item_extras
		BaseItem_OnGameDeploy(); // items/base_item
		BaseWeapon_OnGameDeploy(); // items/base_weapon
		BaseWeapon_OnGameDeploy_2(); // items/base_weapon
		BaseMelee_OnGameDeploy(); // items/base_melee
		CallEventDelayed(0.1f, "elm_activate_effect");
	}

	// weapon_spawn
	void OnWeaponSpawn()
	{
		BaseMelee_OnWeaponSpawn(); // items/base_melee
		SwordsRuneGreen_OnWeaponSpawn();
		SwordsRuneGreen_OnWeaponSpawn_2();
	}

	// cloudon_start
	void OnCloudonStart()
	{
		PlayViewAnim(ANIM_ATTACK4);
		PlaySound(0, 10, SOUND_CHARGE);
		CallEventDelayed(0.5f, "cloud_spawn");
	}

	// cloud_spawn
	void OnCloudSpawn()
	{
		Vector3 targetPos = Vec("TARGET_POS");

		PlaySound(0, 10, SOUND_SPAWN_CLOUD);

		CBaseEntity@ myOwner = EntityOf(ENT_OWNER);
		float effectDmg = SkillOf(myOwner, "spellcasting.affliction");
		// multiply EFFECT_DMG 0.3
		float effectDuration = Divide(StatOf(myOwner, "concentration"), 2.0f) + effectDmg;

		CBaseEntity@ ownerTarget = TargetOf(ENT_OWNER);
		if (IsAlive(ownerTarget))
			targetPos = OriginOf(ownerTarget);
		if (!IsAlive(ownerTarget))
			targetPos = OriginOf(myOwner);
		if (IsPlayer(ownerTarget))
			targetPos.z += -32.0f;

		CreateNpc("monsters/summon/poison_cloud2", targetPos, @myOwner, 180, effectDmg, effectDuration, "spellcasting.affliction");
	}

	// bolt_start
	void OnBoltStart()
	{
		PlayViewAnim(ANIM_ATTACK4);
		PlaySound(0, 10, SOUND_CHARGE);
		CallEventDelayed(1.2f, "fire_bolt");
	}

	// fire_bolt
	void OnFireBolt(string startPosition = "", string endPosition = "", string ownerAngles = "", string explode = "")
	{
		PlayViewAnim(ANIM_ATTACK5);
		PlayOwnerAnim("once", PLAYERANIM_SWING, "global.anim.combatwalk", 3);
		CallEventDelayed(0.5f, "fire_sound");
	}

	// fire_sound
	void OnFireSound()
	{
		PlaySound(0, 10, SOUND_SHOOT);
	}

	// melee_start
	void OnMeleeStart()
	{
		// local SWING $rand(1,ATTACK_ANIMS)
		// local SWING_ANIM ANIM_ATTACK1
		// if( SWING == 2 ) setvard SWING_ANIM ANIM_ATTACK2
		// else if( SWING == 3 ) setvard SWING_ANIM ANIM_ATTACK3
		// else if( SWING == 4 ) setvard SWING_ANIM ANIM_ATTACK4
		// else if( SWING == 5 ) setvard SWING_ANIM ANIM_ATTACK5
		PlaySound(1, 10, SOUND_SWIPE);

		PlayOwnerAnim("once", "sword_swing"); // global.anim.combatwalk 3
		OnCheckAttackAnim();
		SWING_ANIM = CUR_ATTACK_ANIM;
		PlayItemViewAnim(ENT_ME, SWING_ANIM);
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files

	// game_putinpack
	void OnGamePutinpack()
	{
		BaseElementalResist_OnGamePutinpack(); // items/base_elemental_resist
		BaseItemExtras_OnGamePutinpack(); // items/base_item_extras
	}

	// game_drop
	void OnGameDrop()
	{
		BaseElementalResist_OnGameDrop(); // items/base_elemental_resist
		BaseItemExtras_OnGameDrop(); // items/base_item_extras
		BaseItem_OnGameDrop(); // items/base_item
	}

	// game_remove
	void OnGameRemove()
	{
		BaseElementalResist_OnGameRemove(); // items/base_elemental_resist
		BaseItemExtras_OnGameRemove(); // items/base_item_extras
	}

	// game_fall
	void OnGameFall()
	{
		BaseElementalResist_OnGameFall(); // items/base_elemental_resist
		BaseItemExtras_OnGameFall(); // items/base_item_extras
		BaseItemExtras_OnGameFall_2(); // items/base_item_extras
		BaseWeapon_OnGameFall(); // items/base_weapon
	}

	// game_sheath
	void OnGameSheath()
	{
		BaseElementalResist_OnGameSheath(); // items/base_elemental_resist
		BaseItemExtras_OnGameSheath(); // items/base_item_extras
		BaseWeapon_OnGameSheath(); // items/base_weapon
	}

	// game_deleted
	void OnGameDeleted()
	{
		BaseElementalResist_OnGameDeleted(); // items/base_elemental_resist
		BaseItemExtras_OnGameDeleted(); // items/base_item_extras
	}

	// game_wear
	void OnGameWear(string race = "", string gender = "", string source = "")
	{
		BaseElementalResist_OnGameWear(race, gender, source); // items/base_elemental_resist
		BaseItemExtras_OnGameWear(race, gender, source); // items/base_item_extras
		BaseMelee_OnGameWear(race, gender, source); // items/base_melee
	}

	// ext_activate_items
	void OnExtActivateItems(CBaseEntity@ playerId = null)
	{
		BaseElementalResist_OnExtActivateItems(playerId); // items/base_elemental_resist
		BaseItemExtras_OnExtActivateItems(playerId); // items/base_item_extras
	}

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("weapons/p_weapons2.mdl");
		Precache("viewmodels/v_1hswordssb.mdl");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		BaseElementalResist_FirstThink();
		BaseWeapon_FirstThink();
		BaseItem_FirstThink();
		BaseItemExtras_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "bolt_start") { OnBoltStart(); return true; }
		if (name == "cloud_spawn") { OnCloudSpawn(); return true; }
		if (name == "cloudon_start") { OnCloudonStart(); return true; }
		if (name == "fire_bolt") { OnFireBolt(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "fire_sound") { OnFireSound(); return true; }
		if (name == "game_deploy") { OnGameDeploy(); return true; }
		if (name == "melee_start") { OnMeleeStart(); return true; }
		if (name == "weapon_spawn") { OnWeaponSpawn(); return true; }
		return BaseElementalResist_DispatchEvent(name, params)
			|| BaseVariedAttacks_DispatchEvent(name, params)
			|| SwordsBaseOnehandedScript::DispatchEvent(name, params);
	}
}
