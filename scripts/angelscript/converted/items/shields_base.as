#pragma context server

// Converted from items/shields_base.script by msc_transpiler.
// Thothie - long awaited "make sheilds useful" patch up
// Shields
// System:
// - Shields have a small chance to "deflect" a damage while equipped
// - When activated, shields absorb a percentage of incoming damage
// - Players cannot attack while shield is active
// - Shields break after absorbing/deflecting a certain amount of damage
// - Rune Shields have other effects
// - when a shield is blocking, players cannot be pushed nor stunned
// requires:
// setvard SHIELD_HEALTH
// const PARRY_MULTI 1.3
// const SHIELD_BASE_PARRY 10
// const MODEL_VIEW viewmodels/v_shields.mdl
// const MODEL_VIEW_IDX 1
// const MODEL_BODY_OFS 61
// const MELEE_ENERGY 15
// const BLOCK_CHANCE_UP 100
// const DMG_BLOCK_UP 0.4	//%Damage player takes when blocks (0.0=none 1.0=all)
// const BLOCK_CHANCE_DOWN 15	//%Chance of blocking all damage while down
// const SHIELD_MAXHEALTH 500

#include "runtime/ScriptEntity.as"
#include "converted/items/base_melee.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class ShieldsBase
{
	// Constants
	string ANIM_IDLE1 = "0";
	int ANIM_IDLE_TOTAL = 1;
	int ANIM_LIFT1 = 0;
	bool ANIM_THRUST1 = true;
	int ANIM_RETRACT1 = 2;
	string MELEE_VIEWANIM_ATK = "MELEE_VIEWANIM_ATK";
	bool BASEWEAPON_NO_HAND_IDLE = true;
	string MODEL_WORLD = "weapons/p_weapons2.mdl";
	string MODEL_HANDS = "weapons/p_weapons2.mdl";
	string MODEL_WEAR = "weapons/p_weapons2.mdl";
	string ANIM_PREFIX = "allshields";
	string PLAYERANIM_AIM = "battleaxe";
	string MELEE_STAT = "parry";
	string MELEE_ACCURACY = "40";
	float MELEE_DMG_DELAY = 0.1f;
	float MELEE_ATK_DURATION = 1.0f;
	string MELEE_CALLBACK = "melee";
	int MELEE_NOISE = 400;
	float MELEE_SOUND_DELAY = 0.0f;
	float SHIELD_TAKEDMG = 0.5f;
	string SHIELD_BREAK_SOUND = "debris/bustmetal1.wav";
	string SOUND_THRUST = "weapons/cbar_miss1.wav";
	string SOUND_SWIPE = "SOUND_SWIPE";
	string SOUND_BLOCK = "body/armour3.wav";

	// Variables (an unset .script variable reads as its own name)
	bool AM_SHIELD = true;
	float PARRY_MULTI_OUT = 0.0f;
	bool IS_DEPLOYED = false;
	bool EXIT_BLOCK = false;
	float SHIELD_DMG_TAKEN = 0.0f;

	// unnamed block (first think)
	void ShieldsBase_FirstThink()
	{
		AM_SHIELD = true;
	}

	// weapon_spawn
	void ShieldsBase_OnWeaponSpawn()
	{
		SetHand("left");
		SetWearable(1, "bow");

		// Normal swing attack
		// ===================
		SetLocal("reg.attack.type", "hold-strike");
		SetLocal("reg.attack.keys", "+attack1");
		SetLocal("reg.attack.range", 0);
		SetLocal("reg.attack.dmg", 0);
		SetLocal("reg.attack.dmg.range", 100);
		SetLocal("reg.attack.dmg.type", "block");
		SetLocal("reg.attack.energydrain", 0);
		SetLocal("reg.attack.stat", MELEE_STAT);
		SetLocal("reg.attack.hitchance", MELEE_ACCURACY);
		SetLocal("reg.attack.priority", 0);
		SetLocal("reg.attack.delay.strike", MELEE_DMG_DELAY);
		SetLocal("reg.attack.delay.end", MELEE_ATK_DURATION);
		SetLocal("reg.attack.ofs.startpos", "MELEE_STARTPOS");
		SetLocal("reg.attack.ofs.aimang", "MELEE_AIMANGLE");
		SetLocal("reg.attack.callback", MELEE_CALLBACK);
		SetLocal("reg.attack.noise", MELEE_NOISE);
		SetLocal("reg.attack.dmg.ignore", 1);

		RegisterAttack();

		// Charge up attack (200%) - Shield bash
		// =====================================
		// local reg.attack.priority	1
		// local reg.attack.keys	-attack1
		// local reg.attack.callback	special_02
		// multiply reg.attack.dmg	2
		// local reg.attack.chargeamt	200%
		// local reg.attack.reqskill	5
		// registerattack
		PARRY_MULTI_OUT = PARRY_MULTI;

		OnShieldSpawn();
	}

	// melee_start
	void ShieldsBase_OnMeleeStart()
	{
		// if $rand(1,100) < NOPUSH_CHANCE
		if (!Truthy(ScriptVarOf(ENT_OWNER, "PLR_IN_WORLD")))
			return;
		CallExternal(ENT_OWNER, "ext_shield_up", 1);
	}

	// melee_hold
	void ShieldsBase_OnMeleeHold()
	{
		PlayOwnerAnim("hold", "aim_axe_onehand", "squatwalk1");
	}

	// melee_end
	void ShieldsBase_OnMeleeEnd()
	{
		if (Truthy(ScriptVarOf(ENT_OWNER, "PLR_IN_WORLD")))
		{
			CallExternal(ENT_OWNER, "ext_shield_up", 0);
			PlayOwnerAnim("break");
		}
	}

	// bweapon_effect_remove
	void ShieldsBase_OnBweaponEffectRemove(string reason = "")
	{
		if (!Truthy(ScriptVarOf(ENT_OWNER, "PLR_IN_WORLD")))
			return;
		CallExternal(ENT_OWNER, "ext_shield_up", 0);
	}

	// game_wear
	void ShieldsBase_OnGameWear(string race = "", string gender = "", string source = "")
	{
		IS_DEPLOYED = false;
		SetModel(MODEL_WEAR);
		float submodel = Float(MODEL_BODY_OFS);
		submodel += 3.0f;
		// add		L_SUBMODEL 1 //for new p_body
		SetModelBody(0, int(submodel));
	}

	// game_show
	void ShieldsBase_OnGameShow(string raceType = "", string genderType = "", string debugFlag = "")
	{
		SetModel(MODEL_WEAR);
		float submodel = Float(MODEL_BODY_OFS);
		submodel += 3.0f;
		SetModelBody(0, int(submodel));
	}

	// weapon_deploy
	void ShieldsBase_OnWeaponDeploy()
	{
		IS_DEPLOYED = true;
		string animIdle = ANIM_PREFIX + "_idle";
		PlayAnim(animIdle);
	}

	// game_viewanimdone
	void ShieldsBase_OnGameViewanimdone(string value = "")
	{
		if (!(ANIM_IDLE_TOTAL > 0))
			return;
		if (Truthy(Eval("game.item.attacking")))
			return;
		if (!Truthy(Eval("game.item.wielded")))
			return;
		CallEventDelayed(RandomInt(ANIM_IDLE_DELAY_LOW, ANIM_IDLE_DELAY_HIGH), "item_idle");
	}

	// game_takedamage
	// 1: Attacker  2: Inflictor  3: dmg  4: dmg type
	string ShieldsBase_OnGameTakedamage(CBaseEntity@ attacker = null, CBaseEntity@ inflictor = null, float damage = 0.0f, string damageType = "")
	{
		bool cantBlock = false;
		string result = "";

		if (!IS_DEPLOYED)
			return result;

		if (Truthy(GetVar("SHIELD_PRE_BLOCK_EFFECT")))
		{
			EXIT_BLOCK = false;
			CBaseEntity@ outPar1 = attacker;
			CBaseEntity@ outPar2 = inflictor;
			string outPar4 = damageType;
			OnShieldPreBlockEffect(outPar1, outPar2, SHIELD_DMG_TAKEN, outPar4);
		}
		if (EXIT_BLOCK)
			return result;

		// //dbg temp shield_dmgtype PARAM4
		// if ( PARAM4 startswith cold ) local CANT_BLOCK 1
		// if ( PARAM4 startswith fire ) local CANT_BLOCK 1
		// if ( PARAM4 startswith poison ) local CANT_BLOCK 1
		if (StartsWith(damageType, "target"))
			cantBlock = true;
		if (Contains(damageType, "effect"))
			cantBlock = true;
		if (cantBlock)
			return result;

		// if PARAM4 isnot magic //use magic to bypass parry without bypassing shield
		// if PARAM4 isnot lightning //going to be kind and let peeps deflect lightning
		// //dbg DamgeType DMG_TYPE
		// This is pointless as DMG_TYPE is not working (PARAM4 always empty)
		// However, sheilds don't block any of these types anyways
		// Keeping here in case this is fixed later
		CBaseEntity@ myOwner = EntityOf(ENT_OWNER);
		if (attacker is EntityOf(ENT_OWNER)) // don't freeze self shielding from effects
			return result;

		Vector3 pos = OriginOf(ENT_OWNER);
		Vector3 mypos = OriginOf(ENT_OWNER);
		Vector3 myang = AnglesOf(ENT_OWNER);
		Vector3 attpos = OriginOf(attacker);

		if (!WithinCone2D(attpos, mypos, myang, 175)) // Attack must come from in front of player
			return result;

		if (Truthy(GetVar("SHIELD_REPORT_HITS")))
		{
			CBaseEntity@ theInflictor = inflictor;
			OnShieldHit(inflictor, theInflictor);
		}

		// if $rand(0,100) < MELEE_ACCURACY	//Chance to block at all (reduce damage or eliminate it)
		// local l.deflectroll $rand(0,100)
		// if( game.item.attacking ) multiply l.deflectroll 0.75	//Bonus for holding shield up
		// //dbg ItemUp game.item.attacking UpChance BLOCK_CHANCE_UP downchance BLOCK_CHANCE_DOWN
		if (Truthy(Eval("game.item.attacking")))
		{
			// //dbg Sheild is up
			if (RandomInt(1, 100) <= BLOCK_CHANCE_UP)
			{
				SHIELD_DMG_TAKEN = damage;
				float origDmg = damage;
				SHIELD_DMG_TAKEN *= DMG_BLOCK_UP;

				// if ( SHIELD_IMMORTAL == 0 )
				// {
				// subtract ORIG_DMG SHIELD_DMG_TAKEN
				// subtract SHIELD_HEALTH ORIG_DMG
				// local SHIELD_STATUS SHIELD_HEALTH
				// divide SHIELD_STATUS SHIELD_MAXHEALTH
				// multiply SHIELD_STATUS 100
				// local SHIELD_STATUS $int(SHIELD_STATUS)
				// }
				// if ( SHIELD_IMMORTAL == 1 ) local SHIELD_STATUS 100
				// if ( ORIG_DMG > 0 )
				// {
				// stradd SHIELD_STATUS "%%"
				// playermessage Shield absorbed: ORIG_DMG hp ( shield hp: SHIELD_STATUS )
				// }
				SetDamageInfo("dmg", SHIELD_DMG_TAKEN);
				OnShieldDeflect();
			}
		}

		if (!Truthy(Eval("game.item.attacking")))
		{
			// //dbg Sheild is down
			if (Truthy(Eval("game.item.wielded")) && RandomInt(1, 100) <= BLOCK_CHANCE_DOWN)
			{
				// if ( SHIELD_IMMORTAL == 0 )
				// {
				// subtract SHIELD_HEALTH PARAM3
				// local SHIELD_STATUS SHIELD_HEALTH
				// divide SHIELD_STATUS SHIELD_MAXHEALTH
				// multiply SHIELD_STATUS 100
				// local SHIELD_STATUS $int(SHIELD_STATUS)
				// }
				// if ( SHIELD_IMMORTAL == 1 ) local SHIELD_STATUS 100
				SHIELD_DMG_TAKEN = damage;
				if (damage > 0.0f)
					OwnerMessage("Deflected!");
				SetDamageInfo("hit", 0);
				SetDamageInfo("dmg", 0);
				// clientevent update ent_owner DMG_BLOCK_DOWN shield_absorb
				OnShieldDeflect();
			}
		}
		return result;
	}

	// shield_deflect
	// PARAM1 = attacker
	void ShieldsBase_OnShieldDeflect()
	{
		PlaySound(Int(Eval("const.snd.body")), Eval("const.snd.fullvol"), SOUND_BLOCK);

		// if ( !SHIELD_IMMORTAL )
		// {
		// if ( SHIELD_HEALTH <= 0 )
		// {
		// dbg Fuggin shield broke!
		// playsound 2 const.snd.fullvol SHIELD_BREAK_SOUND
		// playermessage YOUR SHIELD HAS BROKEN!
		// removeitem ent_me
		// deleteme
		// }
		// }
		if (Truthy(Eval("game.item.attacking")))
			return;

		PlayViewAnim(ANIM_RETRACT1);
	}

	// game_pickup
	void ShieldsBase_OnGamePickup()
	{
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)

	// game_wear
	void OnGameWear(string race = "", string gender = "", string source = "")
	{
		BaseItemExtras_OnGameWear(race, gender, source); // items/base_item_extras
		BaseMelee_OnGameWear(race, gender, source); // items/base_melee
		ShieldsBase_OnGameWear(race, gender, source);
	}

	// bweapon_effect_remove
	void OnBweaponEffectRemove(string reason = "")
	{
		BaseItemExtras_OnBweaponEffectRemove(reason); // items/base_item_extras
		ShieldsBase_OnBweaponEffectRemove(reason);
	}

	// game_pickup
	void OnGamePickup()
	{
		BaseItem_OnGamePickup(); // items/base_item
		ShieldsBase_OnGamePickup();
	}

	// melee_start
	void OnMeleeStart()
	{
		BaseMelee_OnMeleeStart(); // items/base_melee
		ShieldsBase_OnMeleeStart();
	}

	void OnWeaponSpawn() { ShieldsBase_OnWeaponSpawn(); } // weapon_spawn
	void OnMeleeHold() { ShieldsBase_OnMeleeHold(); } // melee_hold
	void OnMeleeEnd() { ShieldsBase_OnMeleeEnd(); } // melee_end
	void OnGameShow(string raceType = "", string genderType = "", string debugFlag = "") { ShieldsBase_OnGameShow(raceType, genderType, debugFlag); } // game_show
	void OnWeaponDeploy() { ShieldsBase_OnWeaponDeploy(); } // weapon_deploy
	void OnGameViewanimdone(string value = "") { ShieldsBase_OnGameViewanimdone(value); } // game_viewanimdone
	string OnGameTakedamage(CBaseEntity@ attacker = null, CBaseEntity@ inflictor = null, float damage = 0.0f, string damageType = "") { return ShieldsBase_OnGameTakedamage(attacker, inflictor, damage, damageType); } // game_takedamage
	void OnShieldDeflect() { ShieldsBase_OnShieldDeflect(); } // shield_deflect
	void OnShieldHit(CBaseEntity@ attacker = null, CBaseEntity@ inflictor = null) {} // shield_hit
	void OnShieldPreBlockEffect(CBaseEntity@ attacker = null, CBaseEntity@ inflictor = null, float damage = 0.0f, string damageType = "") {} // shield_pre_block_effect
	void OnShieldSpawn() {} // shield_spawn

	// This file's events and timers by their .script names
	bool ShieldsBase_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "bweapon_effect_remove") { OnBweaponEffectRemove(Param(params, 0)); return true; }
		if (name == "game_pickup") { OnGamePickup(); return true; }
		if (name == "game_show") { OnGameShow(Param(params, 0), Param(params, 1), Param(params, 2)); return true; }
		if (name == "game_takedamage") { Return(OnGameTakedamage(EntityParam(params, 0), EntityParam(params, 1), Float(Param(params, 2)), Param(params, 3))); return true; }
		if (name == "game_viewanimdone") { OnGameViewanimdone(Param(params, 0)); return true; }
		if (name == "game_wear") { OnGameWear(Param(params, 0), Param(params, 1), Param(params, 2)); return true; }
		if (name == "melee_end") { OnMeleeEnd(); return true; }
		if (name == "melee_hold") { OnMeleeHold(); return true; }
		if (name == "melee_start") { OnMeleeStart(); return true; }
		if (name == "shield_deflect") { OnShieldDeflect(); return true; }
		if (name == "weapon_deploy") { OnWeaponDeploy(); return true; }
		if (name == "weapon_spawn") { OnWeaponSpawn(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "items/shields_base"]
shared class ShieldsBaseScript : BaseMeleeScript, ShieldsBase
{
	// Variables every script that includes this file declares
	int BLOCK_CHANCE_DOWN = 0;
	int BLOCK_CHANCE_UP = 0;
	float DMG_BLOCK_UP = 0.0f;
	float MELEE_ENERGY = 0.0f;
	int MODEL_VIEW_IDX = 0;
	string NOPUSH_CHANCE = "NOPUSH_CHANCE";
	float PARRY_MULTI = 0.0f;
	int SHIELD_BASE_PARRY = 0;
	bool SHIELD_IMMORTAL = false;

	// Variables declared by included files, with the value they start with in this script
	ShieldsBaseScript()
	{
		MODEL_WORLD = "weapons/p_weapons2.mdl";
		MODEL_HANDS = "weapons/p_weapons2.mdl";
		ANIM_PREFIX = "allshields";
		PLAYERANIM_AIM = "battleaxe";
		MELEE_NOISE = 400;
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("weapons/p_weapons2.mdl");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		ShieldsBase_FirstThink();
		BaseWeapon_FirstThink();
		BaseItem_FirstThink();
		BaseItemExtras_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return ShieldsBase_DispatchEvent(name, params)
			|| BaseMeleeScript::DispatchEvent(name, params);
	}
}
