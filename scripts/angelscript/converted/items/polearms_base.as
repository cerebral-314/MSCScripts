#pragma context server

// Converted from items/polearms_base.script by msc_transpiler.
// Polearms base JUL2010_27 by Thothie
// - Concept: Optimal damage when in optimal range
// - block on right click (for most, throw for some)
// - block + forward repels (for some)
// - holding block long enough does spin-block (for some) [make repel projectiles?]
// - double dmg attack spins
// - some can be thrown
// - some can slice for "standard" damage (no optimal) [when holding left/right]
// - others do the same thing with a slower backhand poke [when attack and +back +use]
// REQUIRES: (example values from polearms_qs)
// const BASE_LEVEL_REQ 0 //min skill requirement
// const PMODEL_FILE weapons/p_weapons3.mdl //p_weapons group model
// const PMODEL_IDX_FLOOR 61 //body offset (for floor) [all body offsets are JHLMV value -1]
// const PMODEL_IDX_HANDS 62 //body offset (for hands)
// const VMODEL_IDX 0 //body offset in the viewmodel
// const MELEE_DMG 120 //max damage
// const MELEE_RANGE 90 //max reach
// const MELEE_DMG_TYPE blunt //damage type
// const POLE_MIN_RANGE 60 //closer than this leads to min damage (max reach == max damage)
// const POLE_MIN_DMG_MULTI 0.5 //min damage multiplier
// const POLE_MAX_DMG_MULTI 1.5 //max damage multiplier
// final damage will be ( MELEE_DMG x SkillRatio ) * ( $ratio([range_ratio],POLE_MIN_DMG_MULTI,POLE_MAX_DMG_MULTI) )

#include "runtime/ScriptEntity.as"
#include "converted/items/base_item_extras.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class PolearmsBase
{
	// Constants
	string VMODEL_FILE = "viewmodels/v_polearms.mdl";
	float BWEAPON_DBL_CHARGE_ADJ = 2.0f;
	bool VANIM_IDLE1 = false;
	bool VANIM_IDLE2 = true;
	int VANIM_IDLE3 = 2;
	int VANIM_DRAW = 3;
	int VANIM_POKE1 = 4;
	int VANIM_POKE2 = 5;
	int VANIM_POKE_BACK = 6;
	int VANIM_SWIPE1 = 7;
	int VANIM_SWIPE2 = 8;
	int VANIM_WIDE = 9;
	int VANIM_SPIN_START = 10;
	int VANIM_SPIN_HOLD = 11;
	int VANIM_SPIN_END = 12;
	int VANIM_REPEL = 13;
	int VANIM_BLOCK_START = 14;
	int VANIM_BLOCK_HOLD = 15;
	int VANIM_BLOCK_END = 16;
	int VANIM_THROW_POWER = 17;
	int VANIM_THROW_PREP = 18;
	int VANIM_THROW_PREPED_THROW = 19;
	int VANIM_THROW_IDLE = 20;
	string WANIM_FLOOR = "standard_floor_idle";
	string WANIM_HAND = "standard_idle";
	string PANIM_IDLE = "aim_pole";
	string PANIM_POKE = "pole_swing";
	string PANIM_POKE_BACK = "Pattack2";
	string PANIM_SWIPE1 = "Pattack2";
	string PANIM_SWIPE2 = "Pattack3";
	string PANIM_SPIN_START = "Spin_start";
	string PANIM_SPIN_HOLD = "Spin";
	string PANIM_SPIN_END = "Spin_end";
	string PANIM_REPEL = "repel";
	string PANIM_BLOCK_START = "block_start";
	string PANIM_BLOCK_HOLD = "block";
	string PANIM_BLOCK_END = "block_end";
	string PANIM_THROW = "throw1";
	string PANIM_THROW_PREP = "throw2_start";
	string PANIM_THROW_IDLE = "throw2_aim";
	string PANIM_THROW_PREPED_THROW = "throw2_end";
	string SOUND_HITWALL1 = "weapons/bullet_hit1.wav";
	string SOUND_HITWALL2 = "weapons/bullet_hit2.wav";
	string SOUND_THRUST = "weapons/cbar_miss1.wav";
	string SOUND_SWIPE = "zombie/claw_miss2.wav";
	string SOUND_BACKHAND = "weapons/swingsmall.wav";
	string SOUND_BLOCK = "body/armour1.wav";
	string SOUND_READY = "SOUND_READY";
	string SOUND_CHARGE = "SOUND_CHARGE";
	string SOUND_SHOUT = "SOUND_SHOUT";
	string SOUND_SPIN_LOOP = "weapons/polearm_spin.wav";
	string SOUND_THROW = "zombie/claw_miss1.wav";
	int MELEE_DMG = 120;
	string MELEE_RANGE = "90";
	string MELEE_DMG_TYPE = "blunt";
	int MELEE_DMG_RANGE = 0;
	int POLE_MIN_RANGE = 60;
	float POLE_MIN_DMG_MULTI = 0.5f;
	float POLE_MAX_DMG_MULTI = 1.5f;
	float MELEE_DMG_DELAY = 0.6f;
	float MELEE_ATK_DURATION = 1.1f;
	float MELEE_ENERGY = 0.5f;
	string MELEE_ACCURACY = "90%";
	string MELEE_STAT = "polearms";
	Vector3 MELEE_STARTPOS = Vector3();
	bool MELEE_AIMANGLE = false;
	int MELEE_NOISE = 650;
	bool POLE_CAN_POKE1 = true;
	bool POLE_CAN_POKE2 = true;
	float POLE_POKE2_ATK_DURATION = 1.5f;
	bool POLE_CAN_SWIPE = true;
	bool POLE_CAN_BLOCK = true;
	bool POLE_CAN_SPIN = true;
	bool POLE_CAN_REPEL = true;
	bool POLE_CAN_BACKHAND = true;
	bool POLE_CAN_THROW = false;
	bool POLE_CAN_POWER_THROW = false;
	float POLE_BLOCK_PROT_RATIO = 0.3f;
	float POLE_BLOCK_DELAY = 3.0f;
	int POLE_REPEL_STRENGTH = 600;
	int POLE_SWIPE_DMG = 60;
	int POLE_SWIPE_DMG_RANGE = 20;
	string POLE_SWIPE_DMG_TYPE = "blunt";
	int POLE_SWIPE_RANGE = 60;
	string POLE_SWIPE_ACCURACY = "60%";
	float POLE_SWIPE_DMG_DELAY = 0.5f;
	float POLE_SWIPE_ATK_DURATION = 0.9f;
	int POLE_BACKHAND_DMG = 100;
	int POLE_BACKHAND_DMG_RANGE = 10;
	string POLE_BACKHAND_DMG_TYPE = "blunt";
	int POLE_BACKHAND_RANGE = 40;
	string POLE_BACKHAND_ACCURACY = "70%";
	float POLE_BACKHAND_DMG_DELAY = 0.8f;
	float POLE_BACKHAND_ATK_DURATION = 1.2f;
	bool POLE_BACKHAND_STUN = false;
	string POLE_BACKHAND_STUN_CHANCE = "0%";
	int POLE_BACKHAND_REPEL = 0;
	float POLE_THROW_PREPED_ATKDELAY = 0.1f;
	float POLE_THROW_PREP_DELAY = 0.3f;
	int POLE_THROW_POWER = 600;
	string POLE_THOW_PROJECTILE = "proj_pole_spear";
	float POLE_THROW_RECHARGE_TIME = 1.0f;
	float POLE_THROW_MAX_CHARGE_TIME = 3.0f;
	float POLE_THROW_COF = 1.0f;
	int POLE_THROW_MP = 0;
	string POLE_THROW_STAT = "polearms";

	// Variables (an unset .script variable reads as its own name)
	int GAME_PVP = 0;
	float POLE_IDLE_ANIM_COUNT_CL = 0.0f;
	bool POLE_IDLE_ACTIVE_CL = false;
	string WEAPON_PRIMARY_SKILL = "WEAPON_PRIMARY_SKILL";
	string POLE_POKE2_DMG = "POLE_POKE2_DMG";
	bool POLE_BACKHAND_ATTACK = false;
	bool POLE_SWIPE_ATTACK = false;
	bool WAS_UNDERSKILLED = false;
	float POLE_NEXT_IDLE_CL = 0.0f;
	float WEAPON_NEXT_SKILL_WARN = 0.0f;
	bool WEAPON_UNDERSKILLED = false;
	float POLE_NEXT_THROW = 0.0f;
	bool POLE_THROW_PREPING = false;
	float NEXT_BLOCK = 0.0f;
	bool POLE_THROW_PREPPED = false;
	float POLE_THROW_START_CHARGE_TIME = 0.0f;
	bool POLE_IN_BLOCK = false;
	bool POLE_IN_SPIN = false;
	string OWNER_YAW = "OWNER_YAW";
	string PUSH_TARGETS = "PUSH_TARGETS";
	bool POLE_THROW_PREPPING = false;
	float BWEAPON_CHARGE_PERCENT = 0.0f;

	// game_spawn
	void PolearmsBase_OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		SetHand("both");

		OnItemSpawn(); // compatibility
		OnWeaponSpawn(); // compatibility
		OnPolearmSpawn();

		OnPolearmRegisterAttacks();
	}

	// game_deploy
	void PolearmsBase_OnGameDeploy()
	{
		OnPoleDraw();
		// (always true here) if game.serverside

		GAME_PVP = (IsPvp() ? 1 : 0);
		OnPoleCheckSkill();
		CallEventDelayed(0.01f, "polearm_setup_model");
	}

	// game_show
	void PolearmsBase_OnGameShow(string raceType = "", string genderType = "", string debugFlag = "")
	{
		SetModel(PMODEL_FILE);
		SetWorldModel(PMODEL_FILE);
		SetModelBody(0, PMODEL_IDX_HANDS);
	}

	// game_drop
	void PolearmsBase_OnGameDrop()
	{
		OnItemDrop(); // compatibility
	}

	// game_switchhands
	void PolearmsBase_OnGameSwitchhands()
	{
		PlayViewAnim((VANIM_IDLE1 ? 1 : 0));
		POLE_IDLE_ANIM_COUNT_CL = 0.0f;

		OnItemSwitchhands(); // compatibility
	}

	// game_pickup
	void PolearmsBase_OnGamePickup()
	{
		OnPoleDraw();
	}

	// game_fall
	void PolearmsBase_OnGameFall()
	{
		SetModel(PMODEL_FILE);
		SetWorldModel(PMODEL_FILE);

		SetModelBody(0, PMODEL_IDX_FLOOR);
		PlayAnim(WANIM_FLOOR);

		OnWeaponFall(); // compatibility
	}

	// pole_draw
	void PolearmsBase_OnPoleDraw()
	{
		DebugPrint("pole_draw");

		PlayViewAnim(0);
		PlayAnim("break");

		SetViewModel(VMODEL_FILE);
		SetModel(PMODEL_FILE);
		SetWorldModel(PMODEL_FILE);
		SetModelBody(0, PMODEL_IDX_HANDS);

		SetAnimExtension("pole");

		POLE_IDLE_ANIM_COUNT_CL = 0.0f;
		// (never true here, the rest is skipped) if game.clientside
	}

	// polearm_setup_model
	void PolearmsBase_OnPolearmSetupModel()
	{
		SetViewModelProp(ENT_ME, "submodel", ScriptVarOf(ENT_OWNER, "PLR_HAND_SET"), VMODEL_IDX);
	}

	// polearm_register_attacks
	void PolearmsBase_OnPolearmRegisterAttacks()
	{
		// basic thrust
		// (or swipe if POLE_PRIMARY_SWIPE)
		SetLocal("reg.attack.type", "strike-land");
		SetLocal("reg.attack.keys", "+attack1");
		SetLocal("reg.attack.range", MELEE_RANGE);
		SetLocal("reg.attack.dmg", MELEE_DMG);
		SetLocal("reg.attack.dmg.range", MELEE_DMG_RANGE);
		SetLocal("reg.attack.dmg.type", MELEE_DMG_TYPE);
		SetLocal("reg.attack.energydrain", MELEE_ENERGY);
		SetLocal("reg.attack.stat", MELEE_STAT);
		SetLocal("reg.attack.hitchance", MELEE_ACCURACY);
		SetLocal("reg.attack.priority", 0);
		SetLocal("reg.attack.delay.strike", MELEE_DMG_DELAY);
		SetLocal("reg.attack.delay.end", MELEE_ATK_DURATION);
		SetLocal("reg.attack.ofs.startpos", MELEE_STARTPOS);
		SetLocal("reg.attack.ofs.aimang", MELEE_AIMANGLE);
		SetLocal("reg.attack.callback", "attack_poke1");
		SetLocal("reg.attack.noise", MELEE_NOISE);
		SetLocal("reg.attack.reqskill", BASE_LEVEL_REQ);
		RegisterAttack();

		WEAPON_PRIMARY_SKILL = "reg.attack.stat";

		// dbl damage spin thrust
		if (POLE_CAN_POKE2)
		{
			SetLocal("reg.attack.type", "strike-land");
			SetLocal("reg.attack.range", MELEE_RANGE);
			SetLocal("reg.attack.dmg", MELEE_DMG);
			SetLocal("reg.attack.dmg.range", MELEE_DMG_RANGE);
			SetLocal("reg.attack.dmg.type", MELEE_DMG_TYPE);
			SetLocal("reg.attack.energydrain", MELEE_ENERGY);
			SetLocal("reg.attack.stat", MELEE_STAT);
			SetLocal("reg.attack.hitchance", MELEE_ACCURACY);
			SetLocal("reg.attack.priority", 1);
			SetLocal("reg.attack.delay.strike", MELEE_DMG_DELAY);
			SetLocal("reg.attack.delay.end", POLE_POKE2_ATK_DURATION);
			SetLocal("reg.attack.ofs.startpos", MELEE_STARTPOS);
			SetLocal("reg.attack.ofs.aimang", MELEE_AIMANGLE);
			SetLocal("reg.attack.noise", MELEE_NOISE);

			SetLocal("reg.attack.keys", "-attack1");
			SetLocal("reg.attack.callback", "attack_poke2");
			LegacyCommand("multiply", "reg.attack.dmg", BWEAPON_DBL_CHARGE_ADJ);
			LegacyCommand("multiply", "reg.attack.energydrain", BWEAPON_DBL_CHARGE_ADJ);
			POLE_POKE2_DMG = "reg.attack.dmg";
			SetLocal("reg.attack.chargeamt", "100%");
			SetLocal("reg.attack.reqskill", BASE_LEVEL_REQ);
			LegacyCommand("add", "reg.attack.reqskill", 2);
			RegisterAttack();
		}

		if (POLE_CAN_POWER_THROW)
		{
			SetLocal("reg.attack.mpdrain", POLE_THROW_MP);
			SetLocal("reg.attack.ammodrain", 0);
			SetLocal("reg.attack.type", "charge-throw-projectile");
			SetLocal("reg.attack.hold_min&max", "1;1");
			SetLocal("reg.attack.dmg.type", "pierce");
			SetLocal("reg.attack.range", POLE_THROW_POWER);
			SetLocal("reg.attack.energydrain", MELEE_ENERGY);
			SetLocal("reg.attack.stat", POLE_THROW_STAT);
			SetLocal("reg.attack.COF", 1);
			SetLocal("reg.attack.projectile", POLE_THOW_PROJECTILE);
			SetLocal("reg.attack.priority", 2);
			SetLocal("reg.attack.delay.strike", 0.01f);
			SetLocal("reg.attack.chargeamt", "200%");
			SetLocal("reg.attack.delay.end", 0.2f);
			SetLocal("reg.attack.ofs.startpos", Vector3(5, 0, 4));
			SetLocal("reg.attack.ofs.aimang", Vector3(0, 0, 0));
			SetLocal("reg.attack.noise", MELEE_NOISE);
			SetLocal("reg.attack.callback", "pole_powerthrow");
			SetLocal("reg.attack.reqskill", BASE_LEVEL_REQ);
			LegacyCommand("add", "reg.attack.reqskill", 4);
			SetLocal("reg.attack.keys", "-attack1");
			RegisterAttack();
		}
	}

	// pole_powerthrow_start
	void PolearmsBase_OnPolePowerthrowStart()
	{
		PlayViewAnim(VANIM_THROW_POWER);
		PlayOwnerAnim("once", PANIM_THROW, "global.anim.combatwalk", 1);
		PlaySound(0, 10, SOUND_SHOUT);
		CallEventDelayed(0.5f, "pole_powerthrow_sound");
	}

	// pole_powerthrow_sound
	void PolearmsBase_OnPolePowerthrowSound()
	{
		PlaySound(0, 10, SOUND_THROW);
	}

	// attack_poke1_start
	void PolearmsBase_OnAttackPoke1Start()
	{
		bool abortThrow = false;
		if (!Truthy(GetVar("POLE_PRIMARY_SWIPE")))
			OnPoleAttack("poke1");
		else
			OnPoleAttack("priswipe");

		if (POLE_THROW_PREPING)
			abortThrow = true;
		if (POLE_THROW_PREPPED)
			abortThrow = true;
		if (abortThrow)
			OnPoleAbortThrow();
	}

	// attack_poke2_start
	void PolearmsBase_OnAttackPoke2Start()
	{
		bool abortThrow = false;
		PlaySound(1, 10, SOUND_CHARGE);
		OnPoleAttack("poke2");

		if (POLE_THROW_PREPING)
			abortThrow = true;
		if (POLE_THROW_PREPPED)
			abortThrow = true;
		if (abortThrow)
			OnPoleAbortThrow();
	}

	// pole_attack
	void PolearmsBase_OnPoleAttack(string attackType = "")
	{
		bool swipe = false;
		int viewAnim = 0;
		string ownerAnim = "OWNER_ANIM";
		bool sideSwipe = false;

		bool normalAttack = true;

		POLE_BACKHAND_ATTACK = false;
		POLE_SWIPE_ATTACK = false;

		if (POLE_CAN_SWIPE && attackType != "poke2")
		{
			if (IsKeyDown(ENT_OWNER, "moveright"))
			{
				POLE_SWIPE_ATTACK = true;
				swipe = true;
				viewAnim = VANIM_SWIPE1;
				ownerAnim = PANIM_SWIPE2;
				normalAttack = false;
			}
			if (IsKeyDown(ENT_OWNER, "moveleft"))
			{
				POLE_SWIPE_ATTACK = true;
				swipe = true;
				viewAnim = VANIM_SWIPE2;
				ownerAnim = PANIM_SWIPE1;
				normalAttack = false;
			}

			if (swipe)
			{
				SetAttackProp(ENT_ME, 0, "dmg", POLE_SWIPE_DMG);
				SetAttackProp(ENT_ME, 0, "dmg.range", POLE_SWIPE_DMG_RANGE);
				SetAttackProp(ENT_ME, 0, "dmg.type", POLE_SWIPE_DMG_TYPE);
				SetAttackProp(ENT_ME, 0, "range", POLE_SWIPE_RANGE);
				SetAttackProp(ENT_ME, 0, "hitchance", POLE_SWIPE_ACCURACY);
				CallEventDelayed(POLE_SWIPE_DMG_DELAY, "attack_swipe_strike");
			}
		}

		if (POLE_CAN_BACKHAND && attackType != "poke2" && IsKeyDown(ENT_OWNER, "back") && IsKeyDown(ENT_OWNER, "use"))
		{
			POLE_BACKHAND_ATTACK = true;
			viewAnim = VANIM_POKE_BACK;
			ownerAnim = PANIM_POKE_BACK;
			normalAttack = false;
			SetAttackProp(ENT_ME, 0, "dmg", POLE_BACKHAND_DMG);
			SetAttackProp(ENT_ME, 0, "hitchance", POLE_BACKHAND_DMG);
			SetAttackProp(ENT_ME, 0, "dmg.range", POLE_BACKHAND_DMG_RANGE);
			SetAttackProp(ENT_ME, 0, "dmg.type", POLE_BACKHAND_DMG_TYPE);
			SetAttackProp(ENT_ME, 0, "range", POLE_BACKHAND_RANGE);
			SetAttackProp(ENT_ME, 0, "hitchance", POLE_BACKHAND_ACCURACY);
			CallEventDelayed(POLE_BACKHAND_DMG_DELAY, "attack_backhand_strike");
		}

		if (normalAttack)
		{
			if (attackType == "poke1")
			{
				SetAttackProp(ENT_ME, 0, "dmg", MELEE_DMG);
				SetAttackProp(ENT_ME, 0, "dmg.range", MELEE_DMG_RANGE);
				SetAttackProp(ENT_ME, 0, "dmg.type", MELEE_DMG_TYPE);
				SetAttackProp(ENT_ME, 0, "range", MELEE_RANGE);
				SetAttackProp(ENT_ME, 0, "hitchance", MELEE_ACCURACY);

				viewAnim = VANIM_POKE1;
				ownerAnim = PANIM_POKE;
			}

			if (attackType == "poke2")
			{
				viewAnim = VANIM_POKE2;
				ownerAnim = PANIM_POKE;
			}

			if (attackType == "priswipe")
			{
				DebugPrint("pole_attack priswipe");

				SetAttackProp(ENT_ME, 0, "dmg", MELEE_DMG);
				SetAttackProp(ENT_ME, 0, "dmg.range", "L_MELEE_DMG_RANGE");
				SetAttackProp(ENT_ME, 0, "dmg.type", MELEE_DMG_TYPE);
				SetAttackProp(ENT_ME, 0, "range", MELEE_RANGE);
				SetAttackProp(ENT_ME, 0, "hitchance", MELEE_ACCURACY);

				if (IsKeyDown(ENT_OWNER, "moveleft"))
					sideSwipe = true;
				if (IsKeyDown(ENT_OWNER, "moveright"))
					sideSwipe = true;

				if (!sideSwipe)
				{
					viewAnim = VANIM_SWIPE1;
					ownerAnim = PANIM_SWIPE1;
				}
				else
				{
					viewAnim = VANIM_SWIPE2;
					ownerAnim = PANIM_SWIPE2;
				}
			}
		}

		if (WEAPON_UNDERSKILLED)
		{
			WAS_UNDERSKILLED = true;
			SetAttackProp(ENT_ME, 0, "dmg.multi", 0.1f);
		}
		else if (WAS_UNDERSKILLED)
		{
			SetAttackProp(ENT_ME, 0, "dmg.multi", 1.0f);
			WAS_UNDERSKILLED = false;
		}

		PlayOwnerAnim("critical", ownerAnim, "global.anim.combatwalk", 3);
		PlayItemViewAnim(ENT_ME, viewAnim);
	}

	// attack_poke1_strike
	void PolearmsBase_OnAttackPoke1Strike(string hitType = "", Vector3 endPos = Vector3(), CBaseEntity@ hitEntity = null, bool hit = false)
	{
		PlaySound(1, 10, SOUND_THRUST);
	}

	// attack_poke2_strike
	void PolearmsBase_OnAttackPoke2Strike(string hitType = "", Vector3 endPos = Vector3(), CBaseEntity@ hitEntity = null, bool hit = false)
	{
		PlaySound(1, 10, SOUND_THRUST);
	}

	// attack_swipe_strike
	void PolearmsBase_OnAttackSwipeStrike()
	{
		PlaySound(1, 10, SOUND_SWIPE);
	}

	// attack_backhand_strike
	void PolearmsBase_OnAttackBackhandStrike()
	{
		PlaySound(1, 10, SOUND_BACKHAND);
	}

	// attack_poke1_damaged_other
	// PARAM1=target_hit PARAM2=dmg
	string PolearmsBase_OnAttackPoke1DamagedOther(CBaseEntity@ target = null, float damage = 0.0f, string damageType = "", string damageEvent = "")
	{
		string result = "";
		// (always true here) if game.serverside

		OnPoleAdjustDamage(target, damage);
		return result;
	}

	// attack_poke2_damaged_other
	// PARAM1=target_hit PARAM2=dmg
	void PolearmsBase_OnAttackPoke2DamagedOther(CBaseEntity@ target = null, float damage = 0.0f, string damageType = "", string damageEvent = "")
	{
		OnPoleAdjustDamage(target, damage);
	}

	// pole_adjust_damage
	// PARAM1=target_hit PARAM2=dmg
	string PolearmsBase_OnPoleAdjustDamage(CBaseEntity@ target = null, float damageDone = 0.0f)
	{
		bool exitSub = false;
		bool exitSub1 = false;
		string result = "";

		// these attacks do not adjust damage
		CBaseEntity@ targetHit = target;

		// infomsg all $get(TARGET_HIT,origin) $vec(0,0,0) //$vec and origins format their vectors differently, and comparisons do not work. Have to make a string comparison here.
		if (Text(OriginOf(targetHit)) == "(0.00,0.00,0.00)") // Breakables origin are at 0,0,0. If the entity is there, it is likely a breakable.
			return result;

		if (POLE_SWIPE_ATTACK)
		{
			POLE_SWIPE_ATTACK = false;
			exitSub = true;
		}
		if (POLE_BACKHAND_ATTACK)
		{
			POLE_BACKHAND_ATTACK = false;
			if (POLE_BACKHAND_STUN)
			{
				@targetHit = target;
				if (IsPlayer(targetHit) && GAME_PVP == 0)
					exitSub1 = true;
				if (!exitSub1)
				{
					if (Truthy(GetVar("POLE_BACKHAND_SPECIAL")))
						OnPoleBackhandSpecial(targetHit);
					if (RandomInt(1, 100) < Float(POLE_BACKHAND_STUN_CHANCE))
						ApplyEffect(targetHit, "effects/debuff_stun", 5.0f, self);
				}
			}
			if (POLE_BACKHAND_REPEL > 0 && RelationshipOf(targetHit, ENT_OWNER) == "enemy")
				AddVelocity(targetHit, RelativeVelocity(Vector3(0, POLE_BACKHAND_REPEL, 110)));
			exitSub = true;
		}
		if (exitSub)
			return result;

		float dmgDone = damageDone;
		if (!(dmgDone > 0.0f))
			return result;

		float targetRange = RangeTo(targetHit);

		// only called for damage adjusted events (thurst and power thrust)
		if (Truthy(GetVar("POLE_POKE1_ENHANCED")))
			OnPolePokeEnhance();

		if (targetRange < POLE_MIN_RANGE)
		{
			dmgDone *= POLE_MIN_DMG_MULTI;
			SetDamageInfo("dmg", dmgDone);
			result = AppendResult(result, Text(POLE_MIN_DMG_MULTI));
			DebugPrint("pole_adjust_damage short");
		}
		else
		{
			float rangeRatio = Divide(targetRange, Float(MELEE_RANGE));

			float adjustRatio = Ratio(rangeRatio, POLE_MIN_DMG_MULTI, POLE_MAX_DMG_MULTI);

			dmgDone *= adjustRatio;
			SetDamageInfo("dmg", dmgDone);
			result = AppendResult(result, Text(adjustRatio));
			DebugPrint("pole_adjust_damage " + Text(adjustRatio) + " ( " + Text(targetRange) + " vs " + MELEE_RANGE + " )");
		}
		return result;
	}

	// game_attack_cancel
	void PolearmsBase_OnGameAttackCancel()
	{
		// dbg game_attack_cancel
		PlayOwnerAnim("once", PANIM_IDLE, "global.anim.combatwalk", 3);
	}

	// game_viewanimdone
	// this is in code, but never seems to go off
	void PolearmsBase_OnGameViewanimdone(string value = "")
	{
		DebugPrint("game_viewanimdone " + value);
	}

	// pole_idle_anim_cl
	void PolearmsBase_OnPoleIdleAnimCl()
	{
		// (never true here, the rest is skipped) if game.clientside
	}

	// game_attack1
	void PolearmsBase_OnGameAttack1()
	{
		if (!WEAPON_UNDERSKILLED)
			return;
		if (!(GameTime() > WEAPON_NEXT_SKILL_WARN))
			return;
		WEAPON_NEXT_SKILL_WARN = GameTime() + 15.0f;
		OnPoleCheckSkill();
	}

	// pole_check_skill
	void PolearmsBase_OnPoleCheckSkill()
	{
		if (!Truthy(ScriptVarOf(ENT_OWNER, "PLR_IN_WORLD")))
			return;

		string findMeleeStat = "skill." + MELEE_STAT;
		if (Float(GetProp(ENT_OWNER, findMeleeStat)) < Float(BASE_LEVEL_REQ))
		{
			PlayerMessageDark(ENT_OWNER, "You lack the skill to properly wield this weapon!");
			string outStr = "You lack the proficiency to wield this weapon. ( requires: " + MELEE_STAT;
			outStr += " proficiency " + BASE_LEVEL_REQ + " )";
			InfoMessage(ENT_OWNER, "Insufficient Skill", outStr);
			WEAPON_UNDERSKILLED = true;
			WAS_UNDERSKILLED = true;
		}
		else
		{
			WEAPON_UNDERSKILLED = false;
		}
	}

	// game_+attack2
	void PolearmsBase_OnGamePressAttack2()
	{
		if (!CanAttack(ENT_OWNER))
			return;

		if (POLE_CAN_THROW && !Truthy(Eval("game.item.attacking")) && !POLE_THROW_PREPING && !POLE_THROW_PREPPED && GameTime() > POLE_NEXT_THROW)
		{
			POLE_NEXT_THROW = GameTime() + 1.0f;
			POLE_THROW_PREPING = true;
			PlayItemViewAnim(ENT_ME, VANIM_THROW_PREP);
			PlayOwnerAnim("once", PANIM_THROW_PREP, "global.anim.combatwalk", 1.0f);
			CallClientItemEvent(ENT_ME, "pole_toggle_idle_cl", 1);
			CallEventDelayed(POLE_THROW_PREP_DELAY, "pole_throw_ready");
		}

		if (POLE_CAN_BLOCK && !POLE_IN_BLOCK && !POLE_IN_SPIN && GameTime() > NEXT_BLOCK && !Truthy(Eval("game.item.attacking")))
		{
			NEXT_BLOCK = GameTime() + POLE_BLOCK_DELAY;

			if (POLE_CAN_REPEL)
			{
				if (!IsKeyDown(ENT_OWNER, "forward"))
					OnPoleBlockStart();
				else
					OnPoleRepel();
			}
			else
			{
				OnPoleBlockStart();
			}
		}
	}

	// pole_throw_ready
	void PolearmsBase_OnPoleThrowReady()
	{
		POLE_THROW_PREPING = false;
		POLE_THROW_PREPPED = true;
		POLE_THROW_START_CHARGE_TIME = GameTime();
		PlayOwnerAnim("once", PANIM_THROW_IDLE, "global.anim.combatwalk", 10.0f);
	}

	// game_-attack2
	void PolearmsBase_OnGameReleaseAttack2()
	{
		if (POLE_THROW_PREPPING && !Truthy(Eval("game.item.attacking")))
		{
			PlayItemViewAnim(ENT_ME, 0);
			PlayOwnerAnim("once", PANIM_IDLE, "global.anim.combatwalk", 1.0f);
		}

		if (POLE_THROW_PREPPED && !Truthy(Eval("game.item.attacking")))
			OnPoleDoThrow();

		if (POLE_IN_BLOCK)
		{
			if (POLE_IN_SPIN)
				OnPoleSpinEnd();
			else
				OnPoleBlockEnd();
		}
	}

	// pole_block_start
	void PolearmsBase_OnPoleBlockStart()
	{
		PlayOwnerAnim("critical", PANIM_BLOCK_START, "global.anim.combatwalk", 3);
		PlayItemViewAnim(ENT_ME, VANIM_BLOCK_START);

		// setplayerflags ent_owner canattack 0
		// dbg pole_block_start canattack $get(ent_owner,canattack)
		ApplyEffect(ENT_OWNER, "effects/effect_templock");

		CallClientItemEvent(ENT_ME, "pole_toggle_idle_cl", 1);

		CallEventDelayed(1.0f, "pole_block_hold");

		if (!POLE_CAN_SPIN)
			return;
		if (!IsKeyDown(ENT_OWNER, "back"))
			return;
		CallEventDelayed(5.0f, "pole_spin_start");
	}

	// pole_block_hold
	void PolearmsBase_OnPoleBlockHold()
	{
		DebugPrint("pole_block_start canattack " + Text(CanAttack(ENT_OWNER)));
		PlayOwnerAnim("hold", PANIM_BLOCK_HOLD, "global.anim.combatwalk", 99);
		PlayItemViewAnim(ENT_ME, VANIM_BLOCK_HOLD);

		POLE_IN_BLOCK = true;
	}

	// pole_block_end
	void PolearmsBase_OnPoleBlockEnd()
	{
		DebugPrint("pole_block_end");

		POLE_IN_BLOCK = false;
		NEXT_BLOCK = GameTime() + 3.0f;

		CallExternal(ENT_OWNER, "ext_end_templock");
		// setplayerflags ent_owner canattack 1
		PlayOwnerAnim("break");
		PlayOwnerAnim("critical", PANIM_BLOCK_END, "global.anim.combatwalk", 3);
		CallClientItemEvent(ENT_ME, "pole_block_end_cl");
	}

	// pole_spin_start
	void PolearmsBase_OnPoleSpinStart()
	{
		if (!POLE_IN_BLOCK)
			return;
		DebugPrint("pole_spin_start");
		// setplayerflags ent_owner canrun 0
		PlayItemViewAnim(ENT_ME, VANIM_SPIN_START);
		PlayOwnerAnim("break");
		PlayOwnerAnim("once", PANIM_SPIN_START, "global.anim.combatwalk", 3);
		ServerPlaySound(2, 10, SOUND_SPIN_LOOP);
		CallEventDelayed(0.5f, "pole_spin_hold");
		CallEventDelayed(30.0f, "pole_spin_end"); // max 30 seconds
	}

	// pole_spin_hold
	void PolearmsBase_OnPoleSpinHold()
	{
		DebugPrint("pole_spin_hold canattack " + Text(CanAttack(ENT_OWNER)));
		POLE_IN_SPIN = true;
		PlayItemViewAnim(ENT_ME, VANIM_SPIN_HOLD);
		PlayOwnerAnim("hold", PANIM_SPIN_HOLD, "global.anim.combatwalk", 99);
	}

	// pole_spin_end
	void PolearmsBase_OnPoleSpinEnd()
	{
		if (!POLE_IN_SPIN)
			return;
		DebugPrint("pole_spin_end");

		NEXT_BLOCK = GameTime() + 3.0f;

		// setplayerflags ent_owner canattack 1
		// setplayerflags ent_owner canrun 1
		CallExternal(ENT_OWNER, "ext_end_templock");

		POLE_IN_SPIN = false;
		POLE_IN_BLOCK = false;
		ServerPlaySound(2, 0, SOUND_SPIN_LOOP);
		PlayOwnerAnim("break");
		PlayOwnerAnim("critical", PANIM_SPIN_END, "global.anim.combatwalk", 3);

		CallClientItemEvent(ENT_ME, "pole_spin_end_cl");
	}

	// bs_global_command
	void PolearmsBase_OnBsGlobalCommand(CBasePlayer@ deadPlayer = null, string command = "", string reason = "")
	{
		if (reason != "death")
			return;
		if (deadPlayer !is EntityOf(ENT_OWNER))
			return;
		if (POLE_IN_SPIN)
			OnPoleSpinEnd();
		if (POLE_IN_BLOCK)
			OnPoleBlockEnd();
	}

	// bweapon_effect_remove
	void PolearmsBase_OnBweaponEffectRemove(string reason = "")
	{
		if (POLE_IN_SPIN)
			OnPoleSpinEnd();
		if (POLE_IN_BLOCK)
			OnPoleBlockEnd();
	}

	// game_takedamage
	// 1: Attacker  2: Inflictor  3: dmg  4: dmg type
	string PolearmsBase_OnGameTakedamage(CBaseEntity@ attacker = null, CBaseEntity@ inflictor = null, float damage = 0.0f, string damageType = "")
	{
		bool exitSub = false;
		CBaseEntity@ blockTarg = null;
		bool projectileBlocked = false;
		string result = "";
		if (POLE_IN_BLOCK)
		{
			// stops you blocking when hit, hrmm...
			// if ( !$get(ent_owner,canattack) )
			// {
			// callevent pole_block_end
			// local EXIT_SUB 1
			// }
			// if !EXIT_SUB
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
					dmgTaken *= POLE_BLOCK_PROT_RATIO;

					if (POLE_IN_SPIN)
					{
						dmgTaken *= POLE_BLOCK_PROT_RATIO;
						if (projectileFired)
							projectileBlocked = true;
					}

					if (!projectileBlocked)
					{
						SetDamageInfo("dmg", dmgTaken);
						origDmg -= dmgTaken;
						OwnerMessage("Polearm blocked " + Text(origDmg) + " damage");
					}
					else
					{
						SetDamageInfo("hit", 0);
						SetDamageInfo("dmg", 0);
						OwnerMessage("Polearm deflected " + NameOf(inflictor));
					}
					if (!POLE_IN_SPIN) // twich a bit
						PlayItemViewAnim(ENT_ME, VANIM_BLOCK_HOLD);
					PlaySound(1, 10, SOUND_BLOCK);
				}
			}
		}
		return result;
	}

	// game_hitworld
	void PolearmsBase_OnGameHitworld()
	{
		// dbg game_hitworld
		PlayRandomSound(2, 10, SOUND_HITWALL1, SOUND_HITWALL2);
	}

	// pole_repel
	void PolearmsBase_OnPoleRepel()
	{
		PlaySound(1, 10, SOUND_READY);
		PlayItemViewAnim(ENT_ME, VANIM_REPEL);
		PlayOwnerAnim("critical", PANIM_REPEL, "global.anim.combatwalk", 3);
		CallClientItemEvent(ENT_ME, "pole_suspend_idle_cl", 3.0f);
		Vector3 scanLoc = OriginOf(ENT_OWNER);
		OWNER_YAW = Text(AnglesOf(ENT_OWNER).y);
		scanLoc += RelativePosition(Vector3(0, Float(OWNER_YAW), 0), Vector3(0, 32, 0));
		CallExternal(ENT_OWNER, "ext_sphere_token", "enemy", 64, scanLoc);
		PUSH_TARGETS = ScriptVarOf(ENT_OWNER, "PLR_SCAN_TOKEN");
		if (PUSH_TARGETS == "none")
			return;
		int count = GetTokenCount(PUSH_TARGETS);
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnPoleRepelAffectTargets();
		}
	}

	// pole_repel_affect_targets
	void PolearmsBase_OnPoleRepelAffectTargets()
	{
		bool exitSub = false;
		string curTarget = GetToken(PUSH_TARGETS, loopIteration);
		if (GAME_PVP == 0 && IsPlayer(curTarget))
			exitSub = true;
		if (exitSub)
			return;

		float maxHpPush = MaxHealthOf(ENT_OWNER) * 2.0f;
		if (maxHpPush < 1500.0f)
			maxHpPush = 1500.0f;

		if (!(MaxHealthOf(curTarget) < maxHpPush))
			return;
		AddVelocity(curTarget, RelativePosition(Vector3(0, Float(OWNER_YAW), 0), Vector3(0, POLE_REPEL_STRENGTH, 10)));
	}

	// pole_do_throw
	void PolearmsBase_OnPoleDoThrow()
	{
		DebugPrint("pole_do_throw");
		POLE_THROW_PREPPED = false;
		PlayItemViewAnim(ENT_ME, VANIM_THROW_PREPED_THROW);
		PlayOwnerAnim("once", PANIM_THROW_PREPED_THROW, "global.anim.combatwalk", 1.0f);
		CallEventDelayed(POLE_THROW_PREPED_ATKDELAY, "pole_do_throw2");
	}

	// pole_do_throw2
	void PolearmsBase_OnPoleDoThrow2()
	{
		PlaySound(1, 10, SOUND_THROW);

		float chargeRatio = GameTime() - POLE_THROW_START_CHARGE_TIME;

		if (chargeRatio >= POLE_THROW_MAX_CHARGE_TIME)
		{
			chargeRatio = 1.0f;
		}
		else
		{
			chargeRatio = Divide(chargeRatio, POLE_THROW_MAX_CHARGE_TIME);
			chargeRatio = Ratio(chargeRatio, 0.01f, 1);
		}

		DebugPrint("pole_do_throw2 " + Text(chargeRatio));

		float throwPower = POLE_THROW_POWER;
		float cof = POLE_THROW_COF;
		if (WEAPON_UNDERSKILLED)
		{
			float skillDiff = 1.0f;
			float skillRatio = Divide(SkillOf(ENT_OWNER, "polearms"), Float(BASE_LEVEL_REQ));
			skillDiff -= skillRatio;
			cof += skillDiff;
			throwPower *= skillRatio;
			if (chargeRatio > 0.1f)
				chargeRatio = 0.1f;

			DebugPrint("skildiff " + Text(skillDiff) + " cof " + Text(cof) + " thr " + Text(throwPower) + " rat " + Text(skillRatio));
		}
		else
		{
			// increase range with hold time
			string crPlusOne = Text(chargeRatio);
			chargeRatio += 1.0f;
			throwPower *= chargeRatio;
		}

		CallExternal(ENT_OWNER, "ext_toss_spear", chargeRatio, POLE_THOW_PROJECTILE, "view", "none", throwPower, 0, cof, "polearms"); // <projectile scriptname> <"view"|(src_origin)> <target|(targ_origin)|none> <speed> <damage> <cof> <skill|none> //Converted to use new tossprojectile //greatguys1@FEB2022
		CallClientItemEvent(ENT_ME, "pole_toggle_idle_cl", 0);
		POLE_NEXT_THROW = GameTime() + POLE_THROW_RECHARGE_TIME;
	}

	// pole_abort_throw
	void PolearmsBase_OnPoleAbortThrow()
	{
		POLE_THROW_PREPPED = false;
		POLE_THROW_PREPPING = false;
	}

	// game_drop
	void PolearmsBase_OnGameDrop_2()
	{
		int rlHand = ItemHandIndex();
		CallExternal(ENT_OWNER, "ext_set_hand_id", rlHand, 0);
	}

	// ext_player_sit
	// { game_deploy
	// local RL_HAND game.item.hand_index
	// callexternal ent_owner ext_set_hand_id RL_HAND $get(ent_me,id)
	// }
	void PolearmsBase_OnExtPlayerSit()
	{
		DebugPrint("ext_player_sit");
		if (POLE_IN_SPIN)
			OnPoleSpinEnd();
		if (POLE_IN_BLOCK)
			OnPoleBlockEnd();
	}

	// game_setchargepercent
	void PolearmsBase_OnGameSetchargepercent(float chargePercent = 0.0f)
	{
		// dbg game_setchargepercent PARAM1
		BWEAPON_CHARGE_PERCENT = chargePercent;
	}

	// attack_poke1_damaged_other
	string PolearmsBase_OnAttackPoke1DamagedOther_2(CBaseEntity@ target = null, float damage = 0.0f, string damageType = "", string damageEvent = "")
	{
		string result = "";
		if (!(BWEAPON_CHARGE_PERCENT < 1.0f)) // No need to do more damage with more charging past 100%...
			return result;
		if (BWEAPON_CHARGE_PERCENT > 0.25f)
		{
			BWEAPON_CHARGE_PERCENT -= 0.25f;

			float chargeRatio = Ratio(BWEAPON_CHARGE_PERCENT, 1.25f, BWEAPON_DBL_CHARGE_ADJ);

			float newDmg = damage * chargeRatio;
			SetDamageInfo("dmg", newDmg);
			result = AppendResult(result, Text(chargeRatio));
			DebugPrint("Adjusted dmg x " + Text(chargeRatio));
			BWEAPON_CHARGE_PERCENT = 0.0f;

			float curDrain = MELEE_ENERGY * BWEAPON_CHARGE_PERCENT;
			LegacyCommand("drainstamina", ENT_OWNER, curDrain);
		}
		return result;
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseItemExtras_OnGameSpawn(playerRace, playerGender); // items/base_item_extras
		PolearmsBase_OnGameSpawn(playerRace, playerGender);
	}

	// game_fall
	void OnGameFall()
	{
		BaseItemExtras_OnGameFall(); // items/base_item_extras
		BaseItemExtras_OnGameFall_2(); // items/base_item_extras
		PolearmsBase_OnGameFall();
	}

	// game_deploy
	void OnGameDeploy()
	{
		BaseItemExtras_OnGameDeploy(); // items/base_item_extras
		BaseItemExtras_OnGameDeploy_2(); // items/base_item_extras
		BaseItemExtras_OnGameDeploy_3(); // items/base_item_extras
		PolearmsBase_OnGameDeploy();
	}

	// game_drop
	void OnGameDrop()
	{
		BaseItemExtras_OnGameDrop(); // items/base_item_extras
		PolearmsBase_OnGameDrop();
		PolearmsBase_OnGameDrop_2();
	}

	// bweapon_effect_remove
	void OnBweaponEffectRemove(string reason = "")
	{
		BaseItemExtras_OnBweaponEffectRemove(reason); // items/base_item_extras
		PolearmsBase_OnBweaponEffectRemove(reason);
	}

	void OnGameShow(string raceType = "", string genderType = "", string debugFlag = "") { PolearmsBase_OnGameShow(raceType, genderType, debugFlag); } // game_show
	void OnGameSwitchhands() { PolearmsBase_OnGameSwitchhands(); } // game_switchhands
	void OnGamePickup() { PolearmsBase_OnGamePickup(); } // game_pickup
	void OnPoleDraw() { PolearmsBase_OnPoleDraw(); } // pole_draw
	void OnPolearmSetupModel() { PolearmsBase_OnPolearmSetupModel(); } // polearm_setup_model
	void OnPolearmRegisterAttacks() { PolearmsBase_OnPolearmRegisterAttacks(); } // polearm_register_attacks
	void OnPolePowerthrowStart() { PolearmsBase_OnPolePowerthrowStart(); } // pole_powerthrow_start
	void OnPolePowerthrowSound() { PolearmsBase_OnPolePowerthrowSound(); } // pole_powerthrow_sound
	void OnAttackPoke1Start() { PolearmsBase_OnAttackPoke1Start(); } // attack_poke1_start
	void OnAttackPoke2Start() { PolearmsBase_OnAttackPoke2Start(); } // attack_poke2_start
	void OnPoleAttack(string attackType = "") { PolearmsBase_OnPoleAttack(attackType); } // pole_attack
	void OnAttackPoke1Strike(string hitType = "", Vector3 endPos = Vector3(), CBaseEntity@ hitEntity = null, bool hit = false) { PolearmsBase_OnAttackPoke1Strike(hitType, endPos, hitEntity, hit); } // attack_poke1_strike
	void OnAttackPoke2Strike(string hitType = "", Vector3 endPos = Vector3(), CBaseEntity@ hitEntity = null, bool hit = false) { PolearmsBase_OnAttackPoke2Strike(hitType, endPos, hitEntity, hit); } // attack_poke2_strike
	void OnAttackSwipeStrike() { PolearmsBase_OnAttackSwipeStrike(); } // attack_swipe_strike
	void OnAttackBackhandStrike() { PolearmsBase_OnAttackBackhandStrike(); } // attack_backhand_strike

	// attack_poke1_damaged_other
	string OnAttackPoke1DamagedOther(CBaseEntity@ target = null, float damage = 0.0f, string damageType = "", string damageEvent = "")
	{
		string result = "";
		result = AppendResult(result, PolearmsBase_OnAttackPoke1DamagedOther(target, damage, damageType, damageEvent));
		result = AppendResult(result, PolearmsBase_OnAttackPoke1DamagedOther_2(target, damage, damageType, damageEvent));
		return result;
	}

	void OnAttackPoke2DamagedOther(CBaseEntity@ target = null, float damage = 0.0f, string damageType = "", string damageEvent = "") { PolearmsBase_OnAttackPoke2DamagedOther(target, damage, damageType, damageEvent); } // attack_poke2_damaged_other
	string OnPoleAdjustDamage(CBaseEntity@ target = null, float damageDone = 0.0f) { return PolearmsBase_OnPoleAdjustDamage(target, damageDone); } // pole_adjust_damage
	void OnGameAttackCancel() { PolearmsBase_OnGameAttackCancel(); } // game_attack_cancel
	void OnGameViewanimdone(string value = "") { PolearmsBase_OnGameViewanimdone(value); } // game_viewanimdone
	void OnPoleIdleAnimCl() { PolearmsBase_OnPoleIdleAnimCl(); } // pole_idle_anim_cl
	void OnGameAttack1() { PolearmsBase_OnGameAttack1(); } // game_attack1
	void OnPoleCheckSkill() { PolearmsBase_OnPoleCheckSkill(); } // pole_check_skill
	void OnGamePressAttack2() { PolearmsBase_OnGamePressAttack2(); } // game_+attack2
	void OnPoleThrowReady() { PolearmsBase_OnPoleThrowReady(); } // pole_throw_ready
	void OnGameReleaseAttack2() { PolearmsBase_OnGameReleaseAttack2(); } // game_-attack2
	void OnPoleBlockStart() { PolearmsBase_OnPoleBlockStart(); } // pole_block_start
	void OnPoleBlockHold() { PolearmsBase_OnPoleBlockHold(); } // pole_block_hold
	void OnPoleBlockEnd() { PolearmsBase_OnPoleBlockEnd(); } // pole_block_end
	void OnPoleSpinStart() { PolearmsBase_OnPoleSpinStart(); } // pole_spin_start
	void OnPoleSpinHold() { PolearmsBase_OnPoleSpinHold(); } // pole_spin_hold
	void OnPoleSpinEnd() { PolearmsBase_OnPoleSpinEnd(); } // pole_spin_end
	void OnBsGlobalCommand(CBasePlayer@ deadPlayer = null, string command = "", string reason = "") { PolearmsBase_OnBsGlobalCommand(deadPlayer, command, reason); } // bs_global_command
	string OnGameTakedamage(CBaseEntity@ attacker = null, CBaseEntity@ inflictor = null, float damage = 0.0f, string damageType = "") { return PolearmsBase_OnGameTakedamage(attacker, inflictor, damage, damageType); } // game_takedamage
	void OnGameHitworld() { PolearmsBase_OnGameHitworld(); } // game_hitworld
	void OnPoleRepel() { PolearmsBase_OnPoleRepel(); } // pole_repel
	void OnPoleRepelAffectTargets() { PolearmsBase_OnPoleRepelAffectTargets(); } // pole_repel_affect_targets
	void OnPoleDoThrow() { PolearmsBase_OnPoleDoThrow(); } // pole_do_throw
	void OnPoleDoThrow2() { PolearmsBase_OnPoleDoThrow2(); } // pole_do_throw2
	void OnPoleAbortThrow() { PolearmsBase_OnPoleAbortThrow(); } // pole_abort_throw
	void OnExtPlayerSit() { PolearmsBase_OnExtPlayerSit(); } // ext_player_sit
	void OnGameSetchargepercent(float chargePercent = 0.0f) { PolearmsBase_OnGameSetchargepercent(chargePercent); } // game_setchargepercent
	void OnPoleBackhandDmgDelay() {} // POLE_BACKHAND_DMG_DELAY
	void OnPoleSwipeDmgDelay() {} // POLE_SWIPE_DMG_DELAY
	void OnPoleThrowPrepedAtkdelay() {} // POLE_THROW_PREPED_ATKDELAY
	void OnPoleThrowPrepDelay() {} // POLE_THROW_PREP_DELAY
	void OnItemDrop() {} // item_drop
	void OnItemSpawn() {} // item_spawn
	void OnItemSwitchhands() {} // item_switchhands
	void OnPoleBackhandSpecial(CBaseEntity@ target = null) {} // pole_backhand_special
	void OnPolePokeEnhance() {} // pole_poke_enhance
	void OnPolearmSpawn() {} // polearm_spawn
	void OnWeaponFall() {} // weapon_fall
	void OnWeaponSpawn() {} // weapon_spawn

	// This file's events and timers by their .script names
	bool PolearmsBase_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "attack_backhand_strike") { OnAttackBackhandStrike(); return true; }
		if (name == "attack_poke1_damaged_other") { Return(OnAttackPoke1DamagedOther(EntityParam(params, 0), Float(Param(params, 1)), Param(params, 2), Param(params, 3))); return true; }
		if (name == "attack_poke1_start") { OnAttackPoke1Start(); return true; }
		if (name == "attack_poke1_strike") { OnAttackPoke1Strike(Param(params, 0), Vec(Param(params, 1)), EntityParam(params, 2), Truthy(Param(params, 3))); return true; }
		if (name == "attack_poke2_damaged_other") { OnAttackPoke2DamagedOther(EntityParam(params, 0), Float(Param(params, 1)), Param(params, 2), Param(params, 3)); return true; }
		if (name == "attack_poke2_start") { OnAttackPoke2Start(); return true; }
		if (name == "attack_poke2_strike") { OnAttackPoke2Strike(Param(params, 0), Vec(Param(params, 1)), EntityParam(params, 2), Truthy(Param(params, 3))); return true; }
		if (name == "attack_swipe_strike") { OnAttackSwipeStrike(); return true; }
		if (name == "bs_global_command") { OnBsGlobalCommand(PlayerParam(params, 0), Param(params, 1), Param(params, 2)); return true; }
		if (name == "bweapon_effect_remove") { OnBweaponEffectRemove(Param(params, 0)); return true; }
		if (name == "ext_player_sit") { OnExtPlayerSit(); return true; }
		if (name == "game_+attack2") { OnGamePressAttack2(); return true; }
		if (name == "game_-attack2") { OnGameReleaseAttack2(); return true; }
		if (name == "game_attack1") { OnGameAttack1(); return true; }
		if (name == "game_attack_cancel") { OnGameAttackCancel(); return true; }
		if (name == "game_deploy") { OnGameDeploy(); return true; }
		if (name == "game_drop") { OnGameDrop(); return true; }
		if (name == "game_fall") { OnGameFall(); return true; }
		if (name == "game_hitworld") { OnGameHitworld(); return true; }
		if (name == "game_pickup") { OnGamePickup(); return true; }
		if (name == "game_setchargepercent") { OnGameSetchargepercent(Float(Param(params, 0))); return true; }
		if (name == "game_show") { OnGameShow(Param(params, 0), Param(params, 1), Param(params, 2)); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "game_switchhands") { OnGameSwitchhands(); return true; }
		if (name == "game_takedamage") { Return(OnGameTakedamage(EntityParam(params, 0), EntityParam(params, 1), Float(Param(params, 2)), Param(params, 3))); return true; }
		if (name == "game_viewanimdone") { OnGameViewanimdone(Param(params, 0)); return true; }
		if (name == "pole_abort_throw") { OnPoleAbortThrow(); return true; }
		if (name == "pole_adjust_damage") { Return(OnPoleAdjustDamage(EntityParam(params, 0), Float(Param(params, 1)))); return true; }
		if (name == "pole_attack") { OnPoleAttack(Param(params, 0)); return true; }
		if (name == "pole_block_end") { OnPoleBlockEnd(); return true; }
		if (name == "pole_block_hold") { OnPoleBlockHold(); return true; }
		if (name == "pole_block_start") { OnPoleBlockStart(); return true; }
		if (name == "pole_check_skill") { OnPoleCheckSkill(); return true; }
		if (name == "pole_do_throw") { OnPoleDoThrow(); return true; }
		if (name == "pole_do_throw2") { OnPoleDoThrow2(); return true; }
		if (name == "pole_draw") { OnPoleDraw(); return true; }
		if (name == "pole_idle_anim_cl") { OnPoleIdleAnimCl(); return true; }
		if (name == "pole_powerthrow_sound") { OnPolePowerthrowSound(); return true; }
		if (name == "pole_powerthrow_start") { OnPolePowerthrowStart(); return true; }
		if (name == "pole_repel") { OnPoleRepel(); return true; }
		if (name == "pole_repel_affect_targets") { OnPoleRepelAffectTargets(); return true; }
		if (name == "pole_spin_end") { OnPoleSpinEnd(); return true; }
		if (name == "pole_spin_hold") { OnPoleSpinHold(); return true; }
		if (name == "pole_spin_start") { OnPoleSpinStart(); return true; }
		if (name == "pole_throw_ready") { OnPoleThrowReady(); return true; }
		if (name == "polearm_register_attacks") { OnPolearmRegisterAttacks(); return true; }
		if (name == "polearm_setup_model") { OnPolearmSetupModel(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "items/polearms_base"]
shared class PolearmsBaseScript : BaseItemExtrasScript, PolearmsBase
{
	// Variables every script that includes this file declares
	string BASE_LEVEL_REQ = "BASE_LEVEL_REQ";
	string PMODEL_FILE = "PMODEL_FILE";
	int PMODEL_IDX_FLOOR = 0;
	int PMODEL_IDX_HANDS = 0;
	int VMODEL_IDX = 0;

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("viewmodels/v_polearms.mdl");
		Precache("weapons/polearm_spin.wav");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return PolearmsBase_DispatchEvent(name, params)
			|| BaseItemExtrasScript::DispatchEvent(name, params);
	}
}
