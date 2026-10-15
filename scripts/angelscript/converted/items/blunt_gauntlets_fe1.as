#pragma context server

// Converted from items/blunt_gauntlets_fe1.script by msc_transpiler.
// Flesheater Gauntlets by CrazyMonkeyDude
// from blunt_gauntlets_demon and blunt_gauntlets_fire

#include "runtime/ScriptEntity.as"
#include "converted/items/base_melee.as"
#include "converted/items/base_vampire.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class BluntGauntletsFe1
{
	// Constants
	int SPELL_SKILL_REQUIRED = 20;
	string BASE_LEVEL_REQ = "20";
	int ANIM_HANDS_DOWN = 20;
	int ANIM_LIFT1 = 12;
	string ANIM_LOWER = "11";
	string ANIM_IDLE1 = "11";
	int ANIM_IDLE_TOTAL = 12;
	string ANIM_ATTACK1 = "16";
	string ANIM_ATTACK2 = "17";
	string ANIM_ATTACK3 = "18";
	int ANIM_ATTACK4 = 19;
	int ANIM_SPEC_ATTACK = 14;
	int ANIM_SHEATH = 16;
	string MODEL_VIEW = "viewmodels/v_martialarts_claws.mdl";
	int MODEL_VIEW_IDX = 1;
	string MODEL_HANDS = "weapons/p_weapons3.mdl";
	string MODEL_WORLD = "weapons/p_weapons3.mdl";
	string MODEL_BODY_OFS = "60";
	int MELEE_DMG = 200;
	int MELEE_DMG_RANGE = 0;
	string MELEE_DMG_TYPE = "acid";
	string MELEE_ACCURACY = "100";
	float MELEE_DMG_DELAY = 0.35f;
	float MELEE_ATK_DURATION = 0.45f;
	float MELEE_AFFLIC_RATIO = 0.5f;
	int MELEE_AFFLICDMG_MIN = 10;
	int GOUGE_MPDRAIN = 15;
	int GOUGE_MPSTEAL = 10;
	float GOUGE_LIFESTEAL_RATIO = 0.10f;
	float AURA_DOT_RATIO = 0.3f;
	int AURA_RADIUS = 80;
	string SOUND_SWIPE = "zombie/claw_miss1.wav";
	string SOUND_HITWALL1 = "weapons/cbar_hit1.wav";
	string SOUND_HITWALL2 = "weapons/cbar_hit2.wav";
	string SOUND_SWING = "zombie/claw_miss2.wav";
	string SOUND_DEPLOY = "monsters/skeleton/calrain3.wav";
	string SOUND_GOUGE = "monsters/gonome/gonome_jumpattack.wav";
	string ANIM_PREFIX = "gauntlets";
	bool NO_WORLD_MODEL = true;
	string MELEE_RANGE = "50";
	int REACH_MELEE_RANGE = 100;
	float MELEE_ENERGY = 1.0f;
	string MELEE_STAT = "spellcasting.affliction";
	string MELEE_VIEWANIM_ATK = "MELEE_VIEWANIM_ATK";
	string MELEE_SOUND = "MELEE_SOUND";
	float MELEE_SOUND_DELAY = 0.0f;
	string MELEE_PARRY_CHANCE = "5%";
	string PLAYERANIM_AIM = "axe_onehand";
	string SOUND_GAS_ON = "ambience/steamburst1.wav";

	// Variables (an unset .script variable reads as its own name)
	bool NO_BANK = true;
	int PUNCH_ATTACK = 0;
	bool CAN_VAMPIRE_TARGET = false;

	// unnamed block (first think)
	void BluntGauntletsFe1_FirstThink()
	{
		NO_BANK = true;
	}

	// game_precache
	void BluntGauntletsFe1_OnGamePrecache()
	{
	}

	// game_pickup
	void BluntGauntletsFe1_OnGamePickup()
	{
		CallEventDelayed(0.1f, "facid_aura");
	}

	// weapon_spawn
	void BluntGauntletsFe1_OnWeaponSpawn()
	{
		SetName("Venom Claws");
		SetDescription("Vicious claws have burst from your hands!");
		SetWeight(3);
		SetValue(1500);
		SetHand("both");
		SetHudSprite("hand", "gauntlets");
		SetHudSprite("trade", "gauntlets");

		SetLocal("reg.spell.reqskill", BASE_LEVEL_REQ);
		SetLocal("reg.spell.fizzletime", 99999); // Practically no fizzle time. fizzle time is not fun.
		SetLocal("reg.spell.castsuccess", "100%");
		SetLocal("reg.spell.preparetime", 1);
		LegacyCommand("registerspell");
	}

	// melee_start
	void BluntGauntletsFe1_OnMeleeStart()
	{
		string punchAnim = "l.punch_anim";

		PlayRandomSound(Int(Eval("const.sound.item")), 10, SOUND_SWING, SOUND_SWIPE);

		int rndAttack = RandomInt(1, 4);
		if (rndAttack == 1)
			PlayViewAnim(Int(ANIM_ATTACK1));
		if (rndAttack == 2)
			PlayViewAnim(Int(ANIM_ATTACK2));
		if (rndAttack == 3)
			PlayViewAnim(Int(ANIM_ATTACK3));
		if (rndAttack == 4)
			PlayViewAnim(ANIM_ATTACK4);

		if (PUNCH_ATTACK == 0)
		{
			punchAnim = "stance_normal_lowjab_r1";
			PUNCH_ATTACK = 1;
		}
		else if (PUNCH_ATTACK == 1)
		{
			punchAnim = "stance_normal_lowjab_r2";
			PUNCH_ATTACK = 0;
		}

		PlayOwnerAnim("once", punchAnim, "global.anim.combatwalk", 3);

		PlaySound(Int(Eval("const.sound.item")), 5, SOUND_SWING);
	}

	// game_dodamage
	// 1: Attack Hit (1/0)  2: Entity Attack hit  3:  Start Position  4:  End Position
	string BluntGauntletsFe1_OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";

		if (!hit)
			return result;
		OnDoSpecialDamage(target);
		return result;
	}

	// do_special_damage
	void BluntGauntletsFe1_OnDoSpecialDamage(CBaseEntity@ target = null)
	{
		bool exitSub = false;
		if (RandomInt(1, 2) != 1)
			return;

		if (IsPlayer(target))
			exitSub = true;
		if (exitSub)
			return;

		float afflicDamage = SkillOf(ENT_OWNER, "spellcasting.affliction") * 0.0f + Random(3, 6);
		if (afflicDamage < 10.0f)
			afflicDamage = MELEE_AFFLICDMG_MIN;

		ApplyEffect(target, "effects/dot_poison", 5, @EntityOf(ENT_OWNER), afflicDamage, "spellcasting.affliction");
	}

	// weapon_spawn
	void BluntGauntletsFe1_OnWeaponSpawn_2()
	{
		int charge2Req = 22;

		// Gouge Attack
		SetLocal("reg.attack.type", "strike-land");
		SetLocal("reg.attack.keys", "-attack1");
		SetLocal("reg.attack.range", REACH_MELEE_RANGE);
		SetLocal("reg.attack.dmg", 0);
		SetLocal("reg.attack.dmg.range", 0);
		SetLocal("reg.attack.dmg.type", "pierce");
		SetLocal("reg.attack.energydrain", 2);
		SetLocal("reg.attack.stat", "spellcasting.affliction");
		SetLocal("reg.attack.hitchance", 100);
		SetLocal("reg.attack.priority", 2);
		SetLocal("reg.attack.delay.strike", 0.2f);
		SetLocal("reg.attack.delay.end", 0.9f);
		SetLocal("reg.attack.ofs.startpos", "MELEE_STARTPOS");
		SetLocal("reg.attack.ofs.aimang", "MELEE_AIMANGLE");
		SetLocal("reg.attack.callback", "gouge");
		SetLocal("reg.attack.noise", MELEE_NOISE);
		SetLocal("reg.attack.mpdrain", 0);
		SetLocal("reg.attack.chargeamt", "100%");
		SetLocal("reg.attack.reqskill", charge2Req);
		RegisterAttack();
	}

	// gouge_start
	void BluntGauntletsFe1_OnGougeStart()
	{
		bool exitSub = false;
		if (ManaOf(ENT_OWNER) < GOUGE_MPDRAIN)
		{
			PlayerMessageDark(ENT_OWNER, "Flesheater Gauntlets: Insufficient mana for Gouge Attack.");
			exitSub = true;
		}
		if (exitSub)
			return;
		PlayItemViewAnim(ENT_ME, ANIM_SPEC_ATTACK);
		PlaySound(0, 10, SOUND_GOUGE);
	}

	// gouge_strike
	void BluntGauntletsFe1_OnGougeStrike(string hitType = "", Vector3 endPos = Vector3(), CBaseEntity@ hitEntity = null, bool hit = false)
	{
		bool exitSub = false;
		if (ManaOf(ENT_OWNER) < GOUGE_MPDRAIN)
			exitSub = true;
		if (exitSub)
			return;

		if (!IsAlive(hitEntity))
			return;

		if ((IsPvp() ? 1 : 0) == 0 && IsPlayer(hitEntity))
			exitSub = true;
		if (exitSub)
			return;

		if (!Truthy(LegacyFunction("can_damage", ENT_OWNER, @hitEntity)))
			return;
		float dmgSet = SkillOf(ENT_OWNER, "spellcasting.affliction.ratio") * MELEE_DMG * 3.0f; // 6 = double melee damage (don't really know why, but that's how it works out)
		DoDamageEx(@hitEntity, REACH_MELEE_RANGE, dmgSet, "100%", @EntityOf(ENT_OWNER), @EntityOf(ENT_OWNER), "spellcasting.affliction", "acid");

		CAN_VAMPIRE_TARGET = false;
		OnCheckCanVampire(EntityOf(ENT_OWNER), FindEntity(EntityId(hitEntity)));
		if (CAN_VAMPIRE_TARGET)
		{
			float lifeStolen = dmgSet;
			string lifeStolenText;
			lifeStolen *= DamageTakenOf(hitEntity, "all");
			lifeStolen *= DamageTakenOf(hitEntity, "acid");
			lifeStolen *= GOUGE_LIFESTEAL_RATIO;
			lifeStolenText = Text(lifeStolen);
			GiveHealth(ENT_OWNER, lifeStolenText);
			GiveMana(ENT_OWNER, -GOUGE_MPDRAIN);
		}
		else
		{
			GiveMana(ENT_OWNER, GOUGE_MPSTEAL);
		}

		CallExternal(ENT_OWNER, "mana_drain"); // update mana on player hud readout, if using hud feedback
	}

	// facid_aura
	void BluntGauntletsFe1_OnFacidAura()
	{
		float auraDot = SkillOf(ENT_OWNER, "spellcasting.affliction") * AURA_DOT_RATIO;
		CallExternal(ENT_OWNER, "ext_acid_feaura_activate", auraDot, AURA_RADIUS);
		PlaySound(3, 10, SOUND_GAS_ON);
	}

	// game_removefromowner
	void BluntGauntletsFe1_OnGameRemovefromowner()
	{
		CallExternal(ENT_OWNER, "ext_acid_feaura_remove");
	}

	// game_fall
	void BluntGauntletsFe1_OnGameFall()
	{
		DeleteMe();
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)
	void OnGamePrecache() { BluntGauntletsFe1_OnGamePrecache(); } // game_precache

	// game_pickup
	void OnGamePickup()
	{
		BluntGauntletsFe1_OnGamePickup();
		BaseItem_OnGamePickup(); // items/base_item
	}

	// game_fall
	void OnGameFall()
	{
		BaseItemExtras_OnGameFall(); // items/base_item_extras
		BaseItemExtras_OnGameFall_2(); // items/base_item_extras
		BaseWeapon_OnGameFall(); // items/base_weapon
		BluntGauntletsFe1_OnGameFall();
	}

	// weapon_spawn
	void OnWeaponSpawn()
	{
		BaseMelee_OnWeaponSpawn(); // items/base_melee
		BluntGauntletsFe1_OnWeaponSpawn();
		BluntGauntletsFe1_OnWeaponSpawn_2();
	}

	// game_removefromowner
	void OnGameRemovefromowner()
	{
		BaseMelee_OnGameRemovefromowner(); // items/base_melee
		BluntGauntletsFe1_OnGameRemovefromowner();
	}

	void OnMeleeStart() { BluntGauntletsFe1_OnMeleeStart(); } // melee_start
	string OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "") { return BluntGauntletsFe1_OnGameDodamage(hit, target, start, end, damageType, damageText); } // game_dodamage
	void OnDoSpecialDamage(CBaseEntity@ target = null) { BluntGauntletsFe1_OnDoSpecialDamage(target); } // do_special_damage
	void OnGougeStart() { BluntGauntletsFe1_OnGougeStart(); } // gouge_start
	void OnGougeStrike(string hitType = "", Vector3 endPos = Vector3(), CBaseEntity@ hitEntity = null, bool hit = false) { BluntGauntletsFe1_OnGougeStrike(hitType, endPos, hitEntity, hit); } // gouge_strike
	void OnFacidAura() { BluntGauntletsFe1_OnFacidAura(); } // facid_aura

	// This file's events and timers by their .script names
	bool BluntGauntletsFe1_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "do_special_damage") { OnDoSpecialDamage(EntityParam(params, 0)); return true; }
		if (name == "facid_aura") { OnFacidAura(); return true; }
		if (name == "game_dodamage") { Return(OnGameDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5))); return true; }
		if (name == "game_fall") { OnGameFall(); return true; }
		if (name == "game_pickup") { OnGamePickup(); return true; }
		if (name == "game_precache") { OnGamePrecache(); return true; }
		if (name == "game_removefromowner") { OnGameRemovefromowner(); return true; }
		if (name == "gouge_start") { OnGougeStart(); return true; }
		if (name == "gouge_strike") { OnGougeStrike(Param(params, 0), Vec(Param(params, 1)), EntityParam(params, 2), Truthy(Param(params, 3))); return true; }
		if (name == "melee_start") { OnMeleeStart(); return true; }
		if (name == "weapon_spawn") { OnWeaponSpawn(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "items/blunt_gauntlets_fe1"]
shared class BluntGauntletsFe1Script : BaseMeleeScript, BluntGauntletsFe1, BaseVampire
{
	// Variables every script that includes this file declares
	float DELAY_NOVA = 0.0f;
	int DMG_NOVA = 0;
	float LAST_ERR = 0.0f;
	float NOVA_ATKDELAY = 0.0f;
	int NOVA_MPDRAIN = 0;
	string NOVA_SCRIPT = "NOVA_SCRIPT";
	float RAND_GROWL = 0.0f;
	string SOUND_GROWL1 = "SOUND_GROWL1";
	string SOUND_GROWL2 = "SOUND_GROWL2";
	string SOUND_GROWL3 = "SOUND_GROWL3";
	string SOUND_GROWL4 = "SOUND_GROWL4";
	string SOUND_GROWL5 = "SOUND_GROWL5";
	string SOUND_GROWL6 = "SOUND_GROWL6";

	// Variables declared by included files, with the value they start with in this script
	BluntGauntletsFe1Script()
	{
		ANIM_LIFT1 = 12;
		ANIM_IDLE1 = "11";
		MODEL_VIEW = "viewmodels/v_martialarts_claws.mdl";
		MODEL_HANDS = "weapons/p_weapons3.mdl";
		MODEL_WORLD = "weapons/p_weapons3.mdl";
		MODEL_BODY_OFS = "60";
		ANIM_PREFIX = "gauntlets";
		PLAYERANIM_AIM = "axe_onehand";
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("poison_cloud.spr");
		Precache("weapons/p_weapons3.mdl");
		Precache("viewmodels/v_martialarts_claws.mdl");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		BluntGauntletsFe1_FirstThink();
		BaseWeapon_FirstThink();
		BaseItem_FirstThink();
		BaseItemExtras_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return BluntGauntletsFe1_DispatchEvent(name, params)
			|| BaseVampire_DispatchEvent(name, params)
			|| BaseMeleeScript::DispatchEvent(name, params);
	}
}
