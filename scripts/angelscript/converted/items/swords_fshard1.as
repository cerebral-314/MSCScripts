#pragma context server

// Converted from items/swords_fshard1.script by msc_transpiler.
// FShard Redesign
// Attacks should switch type automagically to either slash or holy depending on what the enemy is more vulnerable to.
// Alt ablility should toggle a haste ability where mana is consumed, but player abilities are enhanced, like hp regen, speed, damage, w/e

#include "runtime/ScriptEntity.as"
#include "converted/items/swords_base_twohanded.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class SwordsFshard1
{
	// Constants
	string SOUND_MODE_SWITCH = "magic/energy1_loud.wav";
	bool CUSTOM_REGISTER_CHARGE1 = true;
	int MP_HOLY_WAVE = 30;
	string BASE_LEVEL_REQ = "30";
	bool ANIM_LIFT = false;
	string ANIM_IDLE1 = "1";
	string ANIM_ATTACK1 = "2";
	string ANIM_ATTACK2 = "2";
	string ANIM_ATTACK3 = "2";
	int ATTACK_ANIMS = 1;
	string ANIM_LUNGE = "3";
	int ANIM_PARRY1 = 4;
	int ANIM_PARRY1_RETRACT = 5;
	int ANIM_UNSHEATH = 6;
	int ANIM_SHEATH = 7;
	string MODEL_VIEW = "viewmodels/v_2hswords.mdl";
	int MODEL_VIEW_IDX = 8;
	int HOLY_VIEW_IDX = 9;
	string MODEL_HANDS = "weapons/p_weapons4.mdl";
	string MODEL_WORLD = "weapons/p_weapons4.mdl";
	string MODEL_BODY_OFS = "51";
	int MODEL_HOLY_OFS = 53;
	int PMODEL_IDX_FLOOR = 52;
	string SOUND_SWIPE = "weapons/swingsmall.wav";
	string SOUND_HITWALL1 = "weapons/cbar_hit1.wav";
	string SOUND_HITWALL2 = "weapons/cbar_hit2.wav";
	string SOUND_DRAW = "weapons/swords/sworddraw.wav";
	string SOUND_SHOUT = "SOUND_SHOUT";
	string ANIM_PREFIX = "standard";
	string MELEE_RANGE = "80";
	float MELEE_DMG_DELAY = 0.6f;
	float MELEE_ATK_DURATION = 1.1f;
	float MELEE_ENERGY = 1.0f;
	int MELEE_DMG = 450;
	int MELEE_DMG_RANGE = 80;
	string MELEE_DMG_TYPE = "slash";
	string MELEE_ACCURACY = "75%";
	string MELEE_STAT = "swordsmanship";
	string MELEE_ALIGN_BASE = "3,10";
	string MELEE_ALIGN_TIP = "0,-10";
	string MELEE_VIEWANIM_ATK = "MELEE_VIEWANIM_ATK";
	string MELEE_SOUND = "MELEE_SOUND";
	float MELEE_SOUND_DELAY = 0.0f;
	string MELEE_PARRY_CHANCE = "30%";
	string MELEE_NEW_PARRY_CHANCE = "30";
	string PLAYERANIM_AIM = "sword_double_idle";
	string PLAYERANIM_SWING = "sword_double_swing";

	// Variables (an unset .script variable reads as its own name)
	float NEXT_WARN_MSG = 0.0f;
	float NEXT_ALLOWED_PARRY = 0.0f;
	bool SHARD_SHIELD_ON = false;
	bool REGEN_LOOP = false;
	float ALLOW_MODE_SWITCH = 0.0f;
	bool HOLY_MODE = false;

	// weapon_spawn
	void SwordsFshard1_OnWeaponSpawn()
	{
		SetName("Felewyn Shard I");
		SetDescription("A shard of the legendary Felewyn Blade");
		SetWeight(100);
		SetValue(5000);
		SetHudSprite("trade", "132");

		SetHand("both");
	}

	// game_deploy
	void SwordsFshard1_OnGameDeploy()
	{
		CallEventDelayed(0.1f, "render_props");
	}

	// render_props
	void SwordsFshard1_OnRenderProps()
	{
		if (!HOLY_MODE)
		{
			SetModelBody(0, Int(MODEL_BODY_OFS));
			SetViewModelProp(ENT_ME, "submodel", ScriptVarOf(ENT_OWNER, "PLR_HAND_SET"), MODEL_VIEW_IDX);
		}
		else
		{
			SetModelBody(0, MODEL_HOLY_OFS);
			SetViewModelProp(ENT_ME, "submodel", ScriptVarOf(ENT_OWNER, "PLR_HAND_SET"), HOLY_VIEW_IDX);
		}
	}

	// register_charge1
	void SwordsFshard1_OnRegisterCharge1()
	{
		// stabby
		SetLocal("reg.attack.type", "strike-land");
		SetLocal("reg.attack.range", MELEE_RANGE);
		SetLocal("reg.attack.dmg", MELEE_DMG);
		SetLocal("reg.attack.dmg.range", MELEE_DMG_RANGE);
		SetLocal("reg.attack.dmg.type", MELEE_DMG_TYPE);
		SetLocal("reg.attack.energydrain", MELEE_ENERGY);
		SetLocal("reg.attack.stat", MELEE_STAT);
		SetLocal("reg.attack.hitchance", MELEE_ACCURACY);
		SetLocal("reg.attack.delay.strike", MELEE_DMG_DELAY);
		LegacyCommand("add", "reg.attack.delay.strike", 0.5f);
		SetLocal("reg.attack.delay.end", MELEE_ATK_DURATION);
		LegacyCommand("add", "reg.attack.delay.end", 0.5f);
		SetLocal("reg.attack.ofs.startpos", "MELEE_STARTPOS");
		SetLocal("reg.attack.ofs.aimang", "MELEE_AIMANGLE");
		SetLocal("reg.attack.noise", MELEE_NOISE);

		SetLocal("reg.attack.priority", 1);
		SetLocal("reg.attack.keys", "-attack1");
		SetLocal("reg.attack.callback", "special_01");
		LegacyCommand("multiply", "reg.attack.dmg", 2);
		SetLocal("reg.attack.chargeamt", "100%");
		SetLocal("reg.attack.reqskill", 32);
		RegisterAttack();

		// shield
		SetLocal("reg.attack.type", "strike-land");
		SetLocal("reg.attack.noautoaim", 1);
		SetLocal("reg.attack.keys", "-attack1");
		SetLocal("reg.attack.range", 0);
		SetLocal("reg.attack.dmg", 0);
		SetLocal("reg.attack.dmg.range", 0);
		SetLocal("reg.attack.dmg.type", "slash");
		SetLocal("reg.attack.energydrain", 2);
		SetLocal("reg.attack.stat", "swordsmanship");
		SetLocal("reg.attack.hitchance", "100%");
		SetLocal("reg.attack.priority", 2);
		SetLocal("reg.attack.delay.strike", 0.1f);
		SetLocal("reg.attack.delay.end", 0.2f);
		SetLocal("reg.attack.ofs.startpos", "MELEE_STARTPOS");
		SetLocal("reg.attack.ofs.aimang", "MELEE_AIMANGLE");
		SetLocal("reg.attack.callback", "shield");
		SetLocal("reg.attack.noise", MELEE_NOISE);
		SetLocal("reg.attack.mpdrain", "SHIELD_MP");
		SetLocal("reg.attack.chargeamt", "200%");
		SetLocal("reg.attack.reqskill", 34);
		RegisterAttack();
	}

	// special_01_start
	void SwordsFshard1_OnSpecial01Start()
	{
		PlayViewAnim(Int(ANIM_LUNGE));
		PlayOwnerAnim("once", "axe_twohand_swing");
		PlaySound(Int(Eval("const.snd.weapon")), Eval("const.snd.maxvol"), SPECIAL01_SND);
	}

	// shield_start
	// Shield system moved to secondary attack
	void SwordsFshard1_OnShieldStart()
	{
		bool fail = false;

		DebugPrint("shield_start " + Text(IsKeyDown(ENT_OWNER, "use")));

		if (!IsKeyDown(ENT_OWNER, "use"))
		{
			if (ManaOf(ENT_OWNER) < MP_HOLY_WAVE)
			{
				fail = true;
				PlayerMessageDark(ENT_OWNER, "Felewyn Shard: Insufficient mana for Holy Wave (20)");
				PlayerMessageDark(ENT_OWNER, "Hold +Use to use Holy Shield instead.");
			}
			if (!fail)
				OnDoHolyWave();
		}

		if (!IsKeyDown(ENT_OWNER, "use"))
			return;
		if (GameTime() <= NEXT_ALLOWED_PARRY && GameTime() > NEXT_WARN_MSG)
		{
			NEXT_WARN_MSG = GameTime() + 1.0f;
			PlayerMessageDark(ENT_OWNER, "Felewyn Shard: Shield needs time to recharge");
		}
		if (!(GameTime() > NEXT_ALLOWED_PARRY))
			return;
		NEXT_ALLOWED_PARRY = GameTime() + 20.0f;
		PlayItemViewAnim(ENT_ME, ANIM_PARRY1);
		ApplyEffect(ENT_OWNER, "effects/effect_shardshield", 10.0f, 0.1f);
		SHARD_SHIELD_ON = true;
		CallEventDelayed(10.0f, "end_parry");
	}

	// game_takedamage
	string SwordsFshard1_OnGameTakedamage(CBaseEntity@ attacker = null, CBaseEntity@ inflictor = null, float damage = 0.0f, string damageType = "")
	{
		string result = "";

		if (!SHARD_SHIELD_ON)
			return result;
		if (!HOLY_MODE)
			return result;
		float maxHpRepel = MaxHealthOf(ENT_OWNER) * 2.0f;
		if (!(MaxHealthOf(attacker) < maxHpRepel))
			return result;
		float repelVel = AnglesOf(attacker).y;
		AddVelocity(attacker, RelativeVelocity(Vector3(0, repelVel, 0), Vector3(0, -400, 200)));
		return result;
	}

	// end_parry
	void SwordsFshard1_OnEndParry(string source = "")
	{
		SHARD_SHIELD_ON = false;
		PlayItemViewAnim(ENT_ME, ANIM_PARRY1_RETRACT);
	}

	// bweapon_effect_activate
	void SwordsFshard1_OnBweaponEffectActivate()
	{
		REGEN_LOOP = true;
	}

	// bweapon_effect_remove
	void SwordsFshard1_OnBweaponEffectRemove(string reason = "")
	{
		REGEN_LOOP = false;
	}

	// unnamed block (timer)
	void SwordsFshard1_Timer()
	{
		CallEventDelayed(1.0f, "SwordsFshard1_Timer");

		if (!REGEN_LOOP)
			return;
		if (!(HealthOf(ENT_OWNER) < MaxHealthOf(ENT_OWNER)))
			return;
		if (!HOLY_MODE)
			GiveHealth(ENT_OWNER, 1);
		else
			GiveHealth(ENT_OWNER, 2);
	}

	// game_+attack2
	void SwordsFshard1_OnGamePressAttack2()
	{
		if (!(GameTime() > ALLOW_MODE_SWITCH))
			return;
		ALLOW_MODE_SWITCH = GameTime() + 1.0f;
		PlaySound(0, 10, SOUND_MODE_SWITCH);

		if (HOLY_MODE)
		{
			HOLY_MODE = false;
			SetAttackProp(ENT_ME, 0, "dmg.type", "slash");
			SetAttackProp(ENT_ME, 1, "dmg.type", "pierce");
			// phayle
			// setprop ent_me rendermode 0
			// setprop ent_me renderamt 255
			SetModelBody(0, Int(MODEL_BODY_OFS));
			SetViewModelProp(ENT_ME, "submodel", ScriptVarOf(ENT_OWNER, "PLR_HAND_SET"), MODEL_VIEW_IDX);
		}
		else
		{
			HOLY_MODE = true;
			SetAttackProp(ENT_ME, 0, "dmg.type", "holy");
			SetAttackProp(ENT_ME, 1, "dmg.type", "holy");
			// phayle
			// setprop ent_me rendermode 5
			// setprop ent_me renderamt 255
			SetModelBody(0, MODEL_HOLY_OFS);
			SetViewModelProp(ENT_ME, "submodel", ScriptVarOf(ENT_OWNER, "PLR_HAND_SET"), HOLY_VIEW_IDX);
		}
	}

	// game_show
	void SwordsFshard1_OnGameShow(string raceType = "", string genderType = "", string debugFlag = "")
	{
		OnRenderProps();
	}

	// ext_activate_items
	void SwordsFshard1_OnExtActivateItems(CBaseEntity@ playerId = null)
	{
		DebugPrint("items/swords_fshard1 ext_activate_items");
		if (!IsInHand(ENT_ME))
			return;
		if (playerId !is EntityOf(ENT_OWNER))
			return;
		OnRenderProps();
	}

	// do_holy_wave
	void SwordsFshard1_OnDoHolyWave()
	{
		GiveMana(ENT_OWNER, -MP_HOLY_WAVE);
		PlayItemViewAnim(ENT_ME, 3);
		string ownerYaw = Text(ViewAnglesOf(ENT_OWNER));
		ownerYaw = Text(Vec(ownerYaw).y);
		Vector3 projStart = OriginOf(ENT_OWNER);
		projStart.z = GroundHeight(projStart);
		// createnpc monsters/summon/wave L_PROJ_START $get(ent_owner,id) L_OWNER_YAW holy
		CreateNpc("effects/sfx_wave", projStart, @EntityOf(ENT_OWNER), ownerYaw, 20, "swordsmanship"); // <owner> <yaw> <level cast as> <skill to level>
	}

	// game_fall
	void SwordsFshard1_OnGameFall()
	{
		SetModelBody(0, PMODEL_IDX_FLOOR);
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)

	// game_fall
	void OnGameFall()
	{
		BaseItemExtras_OnGameFall(); // items/base_item_extras
		BaseItemExtras_OnGameFall_2(); // items/base_item_extras
		BaseWeapon_OnGameFall(); // items/base_weapon
		SwordsFshard1_OnGameFall();
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
		SwordsBaseTwohanded_OnGameDeploy(); // items/swords_base_twohanded
		SwordsFshard1_OnGameDeploy();
	}

	// ext_activate_items
	void OnExtActivateItems(CBaseEntity@ playerId = null)
	{
		BaseItemExtras_OnExtActivateItems(playerId); // items/base_item_extras
		SwordsFshard1_OnExtActivateItems(playerId);
	}

	// bweapon_effect_activate
	void OnBweaponEffectActivate()
	{
		BaseItemExtras_OnBweaponEffectActivate(); // items/base_item_extras
		SwordsFshard1_OnBweaponEffectActivate();
	}

	// bweapon_effect_remove
	void OnBweaponEffectRemove(string reason = "")
	{
		BaseItemExtras_OnBweaponEffectRemove(reason); // items/base_item_extras
		SwordsBaseTwohanded_OnBweaponEffectRemove(reason); // items/swords_base_twohanded
		SwordsFshard1_OnBweaponEffectRemove(reason);
	}

	// weapon_spawn
	void OnWeaponSpawn()
	{
		BaseMelee_OnWeaponSpawn(); // items/base_melee
		SwordsBaseTwohanded_OnWeaponSpawn(); // items/swords_base_twohanded
		SwordsFshard1_OnWeaponSpawn();
	}

	// register_charge1
	void OnRegisterCharge1()
	{
		BaseMelee_OnRegisterCharge1(); // items/base_melee
		SwordsBaseTwohanded_OnRegisterCharge1(); // items/swords_base_twohanded
		SwordsFshard1_OnRegisterCharge1();
	}

	// game_takedamage
	string OnGameTakedamage(CBaseEntity@ attacker = null, CBaseEntity@ inflictor = null, float damage = 0.0f, string damageType = "")
	{
		string result = "";
		result = AppendResult(result, SwordsBaseTwohanded_OnGameTakedamage(attacker, inflictor, damage, damageType));
		result = AppendResult(result, SwordsFshard1_OnGameTakedamage(attacker, inflictor, damage, damageType));
		return result;
	}

	// game_+attack2
	void OnGamePressAttack2()
	{
		SwordsBaseTwohanded_OnGamePressAttack2(); // items/swords_base_twohanded
		SwordsFshard1_OnGamePressAttack2();
	}

	void OnRenderProps() { SwordsFshard1_OnRenderProps(); } // render_props
	void OnSpecial01Start() { SwordsFshard1_OnSpecial01Start(); } // special_01_start
	void OnShieldStart() { SwordsFshard1_OnShieldStart(); } // shield_start
	void OnEndParry(string source = "") { SwordsFshard1_OnEndParry(source); } // end_parry
	void OnGameShow(string raceType = "", string genderType = "", string debugFlag = "") { SwordsFshard1_OnGameShow(raceType, genderType, debugFlag); } // game_show
	void OnDoHolyWave() { SwordsFshard1_OnDoHolyWave(); } // do_holy_wave

	// This file's events and timers by their .script names
	bool SwordsFshard1_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "bweapon_effect_activate") { OnBweaponEffectActivate(); return true; }
		if (name == "bweapon_effect_remove") { OnBweaponEffectRemove(Param(params, 0)); return true; }
		if (name == "do_holy_wave") { OnDoHolyWave(); return true; }
		if (name == "end_parry") { OnEndParry(Param(params, 0)); return true; }
		if (name == "ext_activate_items") { OnExtActivateItems(EntityParam(params, 0)); return true; }
		if (name == "game_+attack2") { OnGamePressAttack2(); return true; }
		if (name == "game_deploy") { OnGameDeploy(); return true; }
		if (name == "game_fall") { OnGameFall(); return true; }
		if (name == "game_show") { OnGameShow(Param(params, 0), Param(params, 1), Param(params, 2)); return true; }
		if (name == "game_takedamage") { Return(OnGameTakedamage(EntityParam(params, 0), EntityParam(params, 1), Float(Param(params, 2)), Param(params, 3))); return true; }
		if (name == "register_charge1") { OnRegisterCharge1(); return true; }
		if (name == "render_props") { OnRenderProps(); return true; }
		if (name == "shield_start") { OnShieldStart(); return true; }
		if (name == "special_01_start") { OnSpecial01Start(); return true; }
		if (name == "weapon_spawn") { OnWeaponSpawn(); return true; }
		if (name == "SwordsFshard1_Timer") { SwordsFshard1_Timer(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "items/swords_fshard1"]
shared class SwordsFshard1Script : SwordsBaseTwohandedScript, SwordsFshard1
{
	// Variables declared by included files, with the value they start with in this script
	SwordsFshard1Script()
	{
		BASE_LEVEL_REQ = "30";
		ANIM_ATTACK2 = "2";
		ANIM_ATTACK3 = "2";
		ATTACK_ANIMS = 1;
		ANIM_UNSHEATH = 6;
		ANIM_SHEATH = 7;
		MODEL_VIEW = "viewmodels/v_2hswords.mdl";
		MODEL_VIEW_IDX = 8;
		MODEL_HANDS = "weapons/p_weapons4.mdl";
		MODEL_WORLD = "weapons/p_weapons4.mdl";
		MODEL_BODY_OFS = "51";
		SOUND_SWIPE = "weapons/swingsmall.wav";
		SOUND_DRAW = "weapons/swords/sworddraw.wav";
		ANIM_PREFIX = "standard";
		MELEE_RANGE = "80";
		MELEE_DMG_DELAY = 0.6f;
		MELEE_ATK_DURATION = 1.1f;
		MELEE_ENERGY = 1.0f;
		MELEE_DMG = 450;
		MELEE_DMG_RANGE = 80;
		MELEE_DMG_TYPE = "slash";
		MELEE_ACCURACY = "75%";
		MELEE_STAT = "swordsmanship";
		MELEE_ALIGN_BASE = "3,10";
		MELEE_ALIGN_TIP = "0,-10";
		MELEE_PARRY_CHANCE = "30%";
		PLAYERANIM_AIM = "sword_double_idle";
		PLAYERANIM_SWING = "sword_double_swing";
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("weapons/p_weapons4.mdl");
		Precache("viewmodels/v_2hswords.mdl");
		CallEventDelayed(1.0f, "SwordsFshard1_Timer");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return SwordsFshard1_DispatchEvent(name, params)
			|| SwordsBaseTwohandedScript::DispatchEvent(name, params);
	}
}
