#pragma context server

// Converted from items/swords_ub.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/items/swords_base_twohanded.as"

[script "items/swords_ub"]
class SwordsUb : SwordsBaseTwohandedScript
{
	// Constants
	string SOUND_MODE_SWITCH = "magic/energy1_loud.wav";
	float HP_RETURN_RATIO = 0.02f;
	int DARK_SHIELD_MP = 50;
	float DARK_SHIELD_DURATION = 40.0f;
	int RANGED_MP = 30;
	string RANGED_ATK_DURATION = "0.3";
	Vector3 RANGED_AIMANGLE = Vector3();
	Vector3 RANGED_STARTPOS = Vector3();
	string ANIM_LUNGE = "3";
	int ANIM_PARRY1 = 4;
	int ANIM_PARRY1_RETRACT = 5;
	string SOUND_DEPLOY = "magic/chant_loop.wav";
	string SOUND_BLOCK = "weapons/axemetal1.wav";
	string MELEE_NEW_PARRY_CHANCE = "30";

	// Variables (an unset .script variable reads as its own name)
	float CHANT_VOL = 0.0f;
	bool SWORD_FLYING = false;
	string SHADOW_PROJ_ID = "SHADOW_PROJ_ID";
	bool PARRY_ON = false;
	float NEXT_PARRY = 0.0f;
	string DS_START_TIME = "DS_START_TIME";
	float NEXT_DARK_SHIELD_ATTEMPT = 0.0f;
	bool DARK_SHIELD_ON = false;
	float DS_STILL_IN_RECHARGE = 0.0f;

	// Variables declared by included files, with the value they start with in this script
	SwordsUb()
	{
		BASE_LEVEL_REQ = "30";
		ANIM_ATTACK2 = "2";
		ANIM_ATTACK3 = "2";
		ATTACK_ANIMS = 1;
		ANIM_UNSHEATH = 6;
		ANIM_SHEATH = 7;
		MODEL_VIEW = "viewmodels/v_2hswords.mdl";
		MODEL_VIEW_IDX = 12;
		MODEL_HANDS = "weapons/p_weapons3.mdl";
		MODEL_WORLD = "weapons/p_weapons3.mdl";
		MODEL_BODY_OFS = "63";
		SOUND_SWIPE = "weapons/swingsmall.wav";
		SOUND_DRAW = "weapons/swords/sworddraw.wav";
		ANIM_PREFIX = "standard";
		MELEE_RANGE = "80";
		MELEE_DMG_DELAY = 0.6f;
		MELEE_ATK_DURATION = 1.1f;
		MELEE_ENERGY = 1.0f;
		MELEE_DMG = 650;
		MELEE_DMG_RANGE = 80;
		MELEE_DMG_TYPE = "dark";
		MELEE_ACCURACY = "85%";
		MELEE_STAT = "swordsmanship";
		MELEE_ALIGN_BASE = "3,10";
		MELEE_ALIGN_TIP = "0,-10";
		MELEE_PARRY_CHANCE = "30%";
		PLAYERANIM_AIM = "sword_double_idle";
		PLAYERANIM_SWING = "sword_double_swing";
	}

	// game_dodamage
	string SwordsUb_OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";

		if (!hit)
			return result;
		string relationship = RelationshipOf(target, ENT_OWNER);
		if (relationship == "ally")
			return result;
		if (relationship == "neutral")
			return result;
		if (target is EntityOf(ENT_OWNER))
		{
			SetDamageInfo("dmg", 0);
			result = AppendResult(result, "0");
			return result;
		}

		if (!Truthy(LegacyFunction("can_damage", ENT_OWNER, @target)))
			return result;
		if (RaceOf(target) == "undead")
			return result;
		if (Truthy(ScriptVarOf(target, "IMMUNE_VAMPIRE")))
			return result;

		if (!(HealthOf(ENT_OWNER) < MaxHealthOf(ENT_OWNER)))
			return result;

		float hpToGive = MaxHealthOf(ENT_OWNER) * HP_RETURN_RATIO;

		GiveHealth(ENT_OWNER, hpToGive);
		return result;
	}

	// game_takedamage
	// 1: Attacker  2: Inflictor  3: dmg  4: dmg type
	string SwordsUb_OnGameTakedamage(CBaseEntity@ attacker = null, CBaseEntity@ inflictor = null, float damage = 0.0f, string damageType = "")
	{
		bool exitSub = false;
		CBaseEntity@ blockTarg = null;
		string result = "";
		if (PARRY_ON)
		{
			if (Contains(damageType, "effect"))
				exitSub = true;
			if (Contains(damageType, "target"))
				exitSub = true;
			if (!exitSub)
			{
				bool projectileFired = IsProjectile(inflictor);
				if (projectileFired)
					@blockTarg = attacker;
				else
					@blockTarg = inflictor;

				Vector3 ownerOrg = OriginOf(ENT_OWNER);
				Vector3 ownerAng = AnglesOf(ENT_OWNER);
				Vector3 attackOrg = OriginOf(blockTarg);

				if (WithinCone2D(attackOrg, ownerOrg, ownerAng, 100)) // Attack must come from in front of player
				{
					float dmgTaken = damage;
					float origDmg = damage;
					dmgTaken *= 0.5f;

					SetDamageInfo("dmg", dmgTaken);
					origDmg -= dmgTaken;

					OwnerMessage("Unholy Blade absorbed " + int(origDmg) + " damage");

					PlaySound(3, 5, SOUND_BLOCK);
				}
			}
		}
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
		SwordsBaseTwohanded_OnGameDeploy(); // items/swords_base_twohanded
		// if CHANT_VOL == 0
		PlaySound(3, 10, SOUND_DEPLOY);
		CHANT_VOL = 10.0f;
		// callevent cl_cycle_sound_down
		CallEventDelayed(1.0f, "cycle_sound_down");
	}

	// bweapon_effect_remove
	void OnBweaponEffectRemove(string reason = "")
	{
		BaseItemExtras_OnBweaponEffectRemove(reason); // items/base_item_extras
		SwordsBaseTwohanded_OnBweaponEffectRemove(reason); // items/swords_base_twohanded
		DebugPrint("bweapon_effect_remove [ " + Text(DARK_SHIELD_ON) + " ]");
		OnEndParry("bweapon_effect_remove");
		if (!DARK_SHIELD_ON)
			return;
		OnDarkShieldAbort();
	}

	// weapon_spawn
	void OnWeaponSpawn()
	{
		BaseMelee_OnWeaponSpawn(); // items/base_melee
		SwordsBaseTwohanded_OnWeaponSpawn(); // items/swords_base_twohanded

		SetName("Unholy Blade");
		SetDescription("A corrupted blade of Felewyn");
		SetWeight(100);
		SetValue(7000);
		SetHudSprite("trade", "140");

		SetHand("both");
		OnCustomRegister();
	}

	// melee_start
	void OnMeleeStart()
	{
		BaseMelee_OnMeleeStart(); // items/base_melee
		AxesBaseOnehanded_OnMeleeStart(); // items/axes_base_onehanded
		OnEndParry("melee_start");
	}

	// game_takedamage
	string OnGameTakedamage(CBaseEntity@ attacker = null, CBaseEntity@ inflictor = null, float damage = 0.0f, string damageType = "")
	{
		string result = "";
		result = AppendResult(result, SwordsBaseTwohanded_OnGameTakedamage(attacker, inflictor, damage, damageType));
		result = AppendResult(result, SwordsUb_OnGameTakedamage(attacker, inflictor, damage, damageType));
		return result;
	}

	// game_+attack2
	void OnGamePressAttack2()
	{
		SwordsBaseTwohanded_OnGamePressAttack2(); // items/swords_base_twohanded
		if (Truthy(Eval("game.item.attacking")))
			return;
		if (!CanAttack(ENT_OWNER))
			return;

		if (!PARRY_ON && SkillOf(ENT_OWNER, "swordsmanship") >= Float(BASE_LEVEL_REQ) && GameTime() > NEXT_PARRY)
		{
			PARRY_ON = true;
			PlayItemViewAnim(ENT_ME, ANIM_PARRY1);
			if (Exists(SHADOW_PROJ_ID))
			{
				DebugPrint("remove " + SHADOW_PROJ_ID);
				CallExternal(SHADOW_PROJ_ID, "remove_me", "remote");
				OnExtProjectileLanded("remote");
			}
		}

		if (!(SkillOf(ENT_OWNER, "swordsmanship") > 34.0f))
			return;

		if (DARK_SHIELD_ON)
			return;

		if (DS_START_TIME == "DS_START_TIME")
		{
			DS_START_TIME = Text(GameTime());
			DS_START_TIME = Text(Float(DS_START_TIME) + 5.0f);
		}

		if (!(GameTime() > Float(DS_START_TIME)))
			return;

		if (GameTime() < NEXT_DARK_SHIELD_ATTEMPT)
		{
			DS_START_TIME = "DS_START_TIME";
			PlayerMessageDark(ENT_OWNER, "Unholy Blade: Shield of Darkness not ready");
		}

		if (!(GameTime() > NEXT_DARK_SHIELD_ATTEMPT))
			return;
		NEXT_DARK_SHIELD_ATTEMPT = GameTime() + 3.0f;

		if (ManaOf(ENT_OWNER) < DARK_SHIELD_MP)
			PlayerMessageDark(ENT_OWNER, "Unholy Blade: Not enough mana for Shield of Darkness");

		if (!(ManaOf(ENT_OWNER) >= DARK_SHIELD_MP))
			return;

		OnDoDarkShield();
	}

	// game_-attack2
	void OnGameReleaseAttack2()
	{
		SwordsBaseTwohanded_OnGameReleaseAttack2(); // items/swords_base_twohanded
		if (!PARRY_ON)
			return;
		if (!Truthy(Eval("game.item.attacking")))
			PlayItemViewAnim(ENT_ME, ANIM_PARRY1_RETRACT);
		PARRY_ON = false;
		DS_START_TIME = "DS_START_TIME"; // also set this at shield end
	}

	// cycle_sound_down
	void OnCycleSoundDown()
	{
		if (!(CHANT_VOL > 0.0f))
			return;
		CallEventDelayed(0.5f, "cycle_sound_down");
		CHANT_VOL -= 1.0f;
		PlaySound(3, CHANT_VOL, SOUND_DEPLOY);
	}

	// custom_register
	// doesn't follow player on either channel 1 or 3
	// { cl_cycle_sound_down
	// if CHANT_VOL > 0
	// callevent 0.1 cl_cycle_sound_down
	// subtract CHANT_VOL 0.1
	// sound.setvolume 3 SOUND_DEPLOY CHANT_VOL
	// }
	void OnCustomRegister()
	{
		// shadow
		SetLocal("reg.attack.mpdrain", RANGED_MP);
		SetLocal("reg.attack.ammodrain", 0);
		SetLocal("reg.attack.type", "charge-throw-projectile");
		SetLocal("reg.attack.hold_min&max", "1;1");
		SetLocal("reg.attack.dmg.type", "dark");
		SetLocal("reg.attack.range", 100);
		SetLocal("reg.attack.energydrain", MELEE_ENERGY);
		SetLocal("reg.attack.stat", MELEE_STAT);
		SetLocal("reg.attack.COF", 0);
		SetLocal("reg.attack.projectile", "proj_ub");
		SetLocal("reg.attack.priority", 2);
		SetLocal("reg.attack.delay.strike", 0.1f);
		SetLocal("reg.attack.chargeamt", "200%");
		SetLocal("reg.attack.delay.end", 0.1f);
		SetLocal("reg.attack.ofs.startpos", RANGED_STARTPOS);
		SetLocal("reg.attack.ofs.aimang", RANGED_AIMANGLE);
		SetLocal("reg.attack.noise", "RANGED_NOISE");
		SetLocal("reg.attack.callback", "dark_shard");
		SetLocal("reg.attack.reqskill", 34);

		SetLocal("reg.attack.keys", "-attack1");

		RegisterAttack();
	}

	// dark_shard_start
	void OnDarkShardStart()
	{
		OnEndParry("shard_fire");
		PlayViewAnim(Int(ANIM_ATTACK1));
		PlayOwnerAnim("once", "axe_twohand_swing");
		CallEventDelayed(0.3f, "vanish_sword");
	}

	// vanish_sword
	void OnVanishSword()
	{
		SetViewModelProp(ENT_ME, "rendermode", 1);
		SetViewModelProp(ENT_ME, "renderamt", 0);
		SWORD_FLYING = true;
	}

	// dark_shard_end
	void OnDarkShardEnd()
	{
		if (Truthy(Eval("game.item.attacking")))
			return;
		PlayViewAnim(Int(ANIM_IDLE1));
	}

	// special_01_start
	void OnSpecial01Start()
	{
		OnEndParry("special_01_start");
		PlayViewAnim(Int(ANIM_LUNGE));
		PlayOwnerAnim("once", "axe_twohand_swing");
		PlaySound(Int(Eval("const.snd.weapon")), Eval("const.snd.maxvol"), SPECIAL01_SND);
	}

	// ext_register_projectile
	void OnExtRegisterProjectile(CBaseEntity@ projectileId = null)
	{
		SHADOW_PROJ_ID = EntityId(projectileId);
		DebugPrint("ext_register_projectile " + SHADOW_PROJ_ID);
	}

	// ext_projectile_landed
	void OnExtProjectileLanded(string landingSource = "")
	{
		DebugPrint("ext_projectile_landed");
		if (landingSource != "remote")
			PlayItemViewAnim(ENT_ME, Int(ANIM_IDLE1));
		SetViewModelProp(ENT_ME, "rendermode", 1);
		SetViewModelProp(ENT_ME, "renderamt", 255);
		SWORD_FLYING = false;
	}

	// end_parry
	// <source>
	void OnEndParry(string source = "")
	{
		if (Exists(SHADOW_PROJ_ID))
		{
			SWORD_FLYING = false;
			if (source != "shard_fire")
			{
				DebugPrint("remove " + SHADOW_PROJ_ID);
				CallExternal(SHADOW_PROJ_ID, "remove_me", "remote");
				OnExtProjectileLanded("remote");
			}
		}

		if (!PARRY_ON)
			return;
		PARRY_ON = false;
		NEXT_PARRY = GameTime() + 2.0f;
	}

	string OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "") { return SwordsUb_OnGameDodamage(hit, target, start, end, damageType, damageText); } // game_dodamage

	// do_dark_shield
	void OnDoDarkShield()
	{
		// dbg do_dark_shield
		NEXT_DARK_SHIELD_ATTEMPT = GameTime() + 30.0f;

		DARK_SHIELD_ON = true;

		// clientevent new all effects/sfx_raura $get(ent_owner,index) DARK_SHIELD_DURATION
		// setvard DAURA_CL_SCRIPT game.script.last_sent_id
		CallExternal(ENT_OWNER, "ext_repel_shield", 20.0f, 128, "darkfire");

		CallEventDelayed(DARK_SHIELD_DURATION, "dark_shield_end");
	}

	// dark_shield_end
	void OnDarkShieldEnd()
	{
		DARK_SHIELD_ON = false;
		DS_START_TIME = "DS_START_TIME";

		DS_STILL_IN_RECHARGE = GameTime() + 10.0f;
	}

	// dark_shield_abort
	void OnDarkShieldAbort()
	{
		DebugPrint("dark_shield_abort");
		OnDarkShieldEnd();
		CallExternal(ENT_OWNER, "ext_end_repel_shield");
	}

	// ext_player_sit
	void OnExtPlayerSit()
	{
		DebugPrint("ext_player_sit");
		if (DARK_SHIELD_ON)
			OnDarkShieldAbort();
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files
	void OnDarkShieldDuration() {} // DARK_SHIELD_DURATION

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("weapons/p_weapons3.mdl");
		Precache("viewmodels/v_2hswords.mdl");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "bweapon_effect_remove") { OnBweaponEffectRemove(Param(params, 0)); return true; }
		if (name == "custom_register") { OnCustomRegister(); return true; }
		if (name == "cycle_sound_down") { OnCycleSoundDown(); return true; }
		if (name == "dark_shard_end") { OnDarkShardEnd(); return true; }
		if (name == "dark_shard_start") { OnDarkShardStart(); return true; }
		if (name == "dark_shield_abort") { OnDarkShieldAbort(); return true; }
		if (name == "dark_shield_end") { OnDarkShieldEnd(); return true; }
		if (name == "do_dark_shield") { OnDoDarkShield(); return true; }
		if (name == "end_parry") { OnEndParry(Param(params, 0)); return true; }
		if (name == "ext_player_sit") { OnExtPlayerSit(); return true; }
		if (name == "ext_projectile_landed") { OnExtProjectileLanded(Param(params, 0)); return true; }
		if (name == "ext_register_projectile") { OnExtRegisterProjectile(EntityParam(params, 0)); return true; }
		if (name == "game_+attack2") { OnGamePressAttack2(); return true; }
		if (name == "game_-attack2") { OnGameReleaseAttack2(); return true; }
		if (name == "game_deploy") { OnGameDeploy(); return true; }
		if (name == "game_dodamage") { Return(OnGameDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5))); return true; }
		if (name == "game_takedamage") { Return(OnGameTakedamage(EntityParam(params, 0), EntityParam(params, 1), Float(Param(params, 2)), Param(params, 3))); return true; }
		if (name == "melee_start") { OnMeleeStart(); return true; }
		if (name == "special_01_start") { OnSpecial01Start(); return true; }
		if (name == "vanish_sword") { OnVanishSword(); return true; }
		if (name == "weapon_spawn") { OnWeaponSpawn(); return true; }
		return SwordsBaseTwohandedScript::DispatchEvent(name, params);
	}
}
