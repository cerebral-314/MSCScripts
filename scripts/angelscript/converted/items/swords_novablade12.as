#pragma context server

// Converted from items/swords_novablade12.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/items/swords_base_twohanded.as"

[script "items/swords_novablade12"]
class SwordsNovablade12 : SwordsBaseTwohandedScript
{
	// Constants
	string SOUND_CHARGE = "magic/fireball_powerup.wav";
	string SOUND_SHOOT = "magic/fireball_strike.wav";
	bool SWORD_MANUAL_PARRY = true;
	string ANIM_LUNGE = "3";
	int ANIM_PARRY1 = 4;
	int ANIM_PARRY1_RETRACT = 5;
	int ANIM_PARRY_DEBUG = 4;
	int ANIM_UNPARRY_DEBUG = 5;
	string MELEE_NEW_PARRY_CHANCE = "50";

	// Variables (an unset .script variable reads as its own name)
	int SWING_ANIM = 0;
	bool PARRY_ON = false;
	bool VOLCANO_ON = false;

	// Variables declared by included files, with the value they start with in this script
	SwordsNovablade12()
	{
		SOUND_PARRY = "weapons/parry.wav";
		ANIM_ATTACK2 = "2";
		ANIM_ATTACK3 = "2";
		ATTACK_ANIMS = 1;
		ANIM_UNSHEATH = 6;
		ANIM_SHEATH = 7;
		MODEL_VIEW = "viewmodels/v_2hswords.mdl";
		MODEL_VIEW_IDX = 4;
		MODEL_HANDS = "weapons/p_weapons2.mdl";
		MODEL_WORLD = "weapons/p_weapons2.mdl";
		SOUND_SWIPE = "weapons/swingsmall.wav";
		SOUND_DRAW = "weapons/swords/sworddraw.wav";
		BASE_LEVEL_REQ = "15";
		MODEL_BODY_OFS = "104";
		ANIM_PREFIX = "khopesh";
		MELEE_RANGE = "80";
		MELEE_DMG_DELAY = 0.6f;
		MELEE_ATK_DURATION = 1.3f;
		MELEE_ENERGY = 1.0f;
		MELEE_DMG = 200;
		MELEE_DMG_RANGE = 140;
		MELEE_DMG_TYPE = "fire";
		MELEE_ACCURACY = "75%";
		MELEE_STAT = "swordsmanship";
		MELEE_ALIGN_BASE = "3,10";
		MELEE_ALIGN_TIP = "0,-10";
		MELEE_PARRY_CHANCE = "60%";
		PLAYERANIM_AIM = "sword_double_idle";
		PLAYERANIM_SWING = "sword_double_swing";
	}

	// weapon_spawn
	void OnWeaponSpawn()
	{
		BaseMelee_OnWeaponSpawn(); // items/base_melee
		SwordsBaseTwohanded_OnWeaponSpawn(); // items/swords_base_twohanded

		SetName("Novablade");
		SetDescription("This is a twisted blade of elemental fire");
		SetWeight(75);
		SetValue(3750);
		SetHudSprite("trade", "115");

		OnRegisterCharge2();
		OnRegisterCharge3();

		SetHand("both");
	}

	// melee_start
	void OnMeleeStart()
	{
		int swing = RandomInt(1, 3);
		if (swing == 1)
			SWING_ANIM = Int(ANIM_ATTACK1);
		if (swing == 2)
			SWING_ANIM = Int(ANIM_ATTACK2);
		if (swing == 3)
			SWING_ANIM = Int(ANIM_ATTACK3);
		PlayOwnerAnim("once", "sword_double_swing");
		PlayViewAnim(SWING_ANIM);
		PlaySound(1, 10, SOUND_SWIPE);
	}

	// special_01_start
	void OnSpecial01Start()
	{
		PlayViewAnim(Int(ANIM_LUNGE));
		PlayOwnerAnim("once", "axe_twohand_swing");
		PlaySound(Int(Eval("const.snd.weapon")), Eval("const.snd.maxvol"), SPECIAL01_SND);
	}

	// special_01_strike
	// //PARAM1: "none"/"npc"/"world"   2: Attack end Position   3: Entity hit (if any)
	void OnSpecial01Strike(string hitType = "", Vector3 endPos = Vector3(), CBaseEntity@ hitEntity = null, bool hit = false)
	{
		bool exitSub = false;

		PlaySound(0, 10, "ambience/steamburst1.wav");

		if (RelationshipOf(hitEntity, ENT_OWNER) != "enemy")
			return;
		if ((IsPvp() ? 1 : 0) == 0 && IsPlayer(hitEntity)) // pvp
			exitSub = true;
		if (exitSub)
			return;

		float dmgFire = SkillOf(ENT_OWNER, "spellcasting.fire");

		ApplyEffect(hitEntity, "effects/dot_fire", 5, @EntityOf(ENT_OWNER), dmgFire, "swordsmanship");
	}

	// blockmode_start
	void OnBlockmodeStart()
	{
		PlayViewAnim(ANIM_PARRY1);
		PlayOwnerAnim("once", "sword_swing");
		PARRY_ON = true;
	}

	// blockmode_end
	void OnBlockmodeEnd()
	{
		PlayViewAnim(ANIM_PARRY1_RETRACT);
		PARRY_ON = false;
	}

	// register_charge1
	void OnRegisterCharge1()
	{
		// thothie made seperate so can override
		// Default charge up attack - Double damage for holding to 100%
		// ============================================================
		SetLocal("reg.attack.type", "strike-land");
		SetLocal("reg.attack.range", MELEE_RANGE);
		SetLocal("reg.attack.dmg", MELEE_DMG);
		SetLocal("reg.attack.dmg.range", MELEE_DMG_RANGE);
		SetLocal("reg.attack.dmg.type", MELEE_DMG_TYPE);
		SetLocal("reg.attack.energydrain", MELEE_ENERGY);
		SetLocal("reg.attack.stat", "spellcasting.fire");
		SetLocal("reg.attack.hitchance", MELEE_ACCURACY);
		SetLocal("reg.attack.delay.strike", MELEE_DMG_DELAY);
		SetLocal("reg.attack.delay.end", MELEE_ATK_DURATION);
		SetLocal("reg.attack.ofs.startpos", "MELEE_STARTPOS");
		SetLocal("reg.attack.ofs.aimang", "MELEE_AIMANGLE");
		SetLocal("reg.attack.noise", MELEE_NOISE);

		SetLocal("reg.attack.priority", 1);
		SetLocal("reg.attack.keys", "-attack1");
		SetLocal("reg.attack.callback", "special_01");
		LegacyCommand("multiply", "reg.attack.dmg", 2);
		SetLocal("reg.attack.chargeamt", "100%");
		SetLocal("reg.attack.reqskill", 10);

		RegisterAttack();
	}

	// register_charge2
	void OnRegisterCharge2()
	{
		SetLocal("reg.attack.type", "strike-land");
		SetLocal("reg.attack.range", MELEE_RANGE);
		SetLocal("reg.attack.dmg", MELEE_DMG);
		SetLocal("reg.attack.dmg.range", MELEE_DMG_RANGE);
		SetLocal("reg.attack.dmg.type", MELEE_DMG_TYPE);
		SetLocal("reg.attack.energydrain", MELEE_ENERGY);
		SetLocal("reg.attack.stat", "spellcasting.fire");
		SetLocal("reg.attack.hitchance", MELEE_ACCURACY);
		SetLocal("reg.attack.delay.strike", MELEE_DMG_DELAY);
		SetLocal("reg.attack.delay.end", MELEE_ATK_DURATION);
		SetLocal("reg.attack.ofs.startpos", "MELEE_STARTPOS");
		SetLocal("reg.attack.ofs.aimang", "MELEE_AIMANGLE");
		SetLocal("reg.attack.noise", MELEE_NOISE);

		SetLocal("reg.attack.priority", 2.5f);
		SetLocal("reg.attack.keys", "-attack1");
		SetLocal("reg.attack.callback", "special_02");
		LegacyCommand("multiply", "reg.attack.dmg", 3);
		SetLocal("reg.attack.chargeamt", "200%");
		SetLocal("reg.attack.reqskill", 20);

		RegisterAttack();
	}

	// register_charge3
	void OnRegisterCharge3()
	{
		SetLocal("reg.attack.type", "strike-land");
		SetLocal("reg.attack.range", MELEE_RANGE);
		SetLocal("reg.attack.dmg", MELEE_DMG);
		SetLocal("reg.attack.dmg.range", MELEE_DMG_RANGE);
		SetLocal("reg.attack.dmg.type", MELEE_DMG_TYPE);
		SetLocal("reg.attack.energydrain", MELEE_ENERGY);
		SetLocal("reg.attack.stat", "spellcasting.fire");
		SetLocal("reg.attack.hitchance", MELEE_ACCURACY);
		SetLocal("reg.attack.delay.strike", MELEE_DMG_DELAY);
		SetLocal("reg.attack.delay.end", MELEE_ATK_DURATION);
		SetLocal("reg.attack.ofs.startpos", "MELEE_STARTPOS");
		SetLocal("reg.attack.ofs.aimang", "MELEE_AIMANGLE");
		SetLocal("reg.attack.callback", "melee");
		SetLocal("reg.attack.noise", MELEE_NOISE);

		SetLocal("reg.attack.priority", 3);
		SetLocal("reg.attack.keys", "-attack1");
		SetLocal("reg.attack.callback", "special_03");
		LegacyCommand("multiply", "reg.attack.dmg", 3);
		SetLocal("reg.attack.chargeamt", "300%");
		SetLocal("reg.attack.reqskill", 30);

		RegisterAttack();
	}

	// special_02_start
	void OnSpecial02Start()
	{
		PlaySound(0, 10, SOUND_CHARGE);
		PlayViewAnim(Int(ANIM_LUNGE));
		PlayOwnerAnim("once", "axe_twohand_swing");
		PlaySound(Int(Eval("const.snd.weapon")), Eval("const.snd.maxvol"), SPECIAL01_SND);
	}

	// special_02_strike
	void OnSpecial02Strike(string hitType = "", Vector3 endPos = Vector3(), CBaseEntity@ hitEntity = null, bool hit = false)
	{
		bool exitSub = false;

		if (ManaOf(ENT_OWNER) < 100.0f)
		{
			OwnerMessage("Novablade: Flaming Skull - insufficient mana!");
			exitSub = true;
		}
		if (exitSub)
			return;

		GiveMana(-100);
		CallExternal(ENT_OWNER, "mana_drain"); // update mana on player hud readout, if using hud feedback

		PlaySound(0, 10, SOUND_SHOOT);

		float dmgFire = SkillOf(ENT_OWNER, "spellcasting.fire") * 0.4f;
		CreateNpc("monsters/summon/flame_skull", RelativePosition(Vector3(0, 0, 0)), @EntityOf(ENT_OWNER), dmgFire, 256, "spellcasting.fire");
	}

	// special_03_start
	void OnSpecial03Start()
	{
		PlaySound(0, 10, SOUND_CHARGE);
		PlayViewAnim(Int(ANIM_LUNGE));
		PlayOwnerAnim("once", "axe_twohand_swing");
		PlaySound(Int(Eval("const.snd.weapon")), Eval("const.snd.maxvol"), SPECIAL01_SND);
	}

	// special_03_strike
	void OnSpecial03Strike(string hitType = "", Vector3 endPos = Vector3(), CBaseEntity@ hitEntity = null, bool hit = false)
	{
		bool exitSub = false;

		if (ManaOf(ENT_OWNER) < 100.0f)
		{
			OwnerMessage("Novablade: Volcano - insufficient mana!");
			exitSub = true;
		}
		if (exitSub)
			return;

		if (VOLCANO_ON)
		{
			OwnerMessage("Novablade can only generate one volcano at a time");
			exitSub = true;
		}
		if (exitSub)
			return;

		VOLCANO_ON = true;
		CallEventDelayed(30.0f, "volcano_reset");

		GiveMana(-100);
		CallExternal(ENT_OWNER, "mana_drain"); // update mana on player hud readout, if using hud feedback

		Vector3 pos = OriginOf(ENT_OWNER);
		float temp = GroundHeight(pos);
		float x = pos.x;
		float y = pos.y;
		pos = Vector3(x, y, temp);
		CreateNpc("monsters/summon/preset_volcano", pos, @EntityOf(ENT_OWNER), 0, 20, "spellcasting.fire");
	}

	// volcano_reset
	void OnVolcanoReset()
	{
		VOLCANO_ON = false;
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("weapons/p_weapons2.mdl");
		Precache("viewmodels/v_2hswords.mdl");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "blockmode_end") { OnBlockmodeEnd(); return true; }
		if (name == "blockmode_start") { OnBlockmodeStart(); return true; }
		if (name == "melee_start") { OnMeleeStart(); return true; }
		if (name == "register_charge1") { OnRegisterCharge1(); return true; }
		if (name == "register_charge2") { OnRegisterCharge2(); return true; }
		if (name == "register_charge3") { OnRegisterCharge3(); return true; }
		if (name == "special_01_start") { OnSpecial01Start(); return true; }
		if (name == "special_01_strike") { OnSpecial01Strike(Param(params, 0), Vec(Param(params, 1)), EntityParam(params, 2), Truthy(Param(params, 3))); return true; }
		if (name == "special_02_start") { OnSpecial02Start(); return true; }
		if (name == "special_02_strike") { OnSpecial02Strike(Param(params, 0), Vec(Param(params, 1)), EntityParam(params, 2), Truthy(Param(params, 3))); return true; }
		if (name == "special_03_start") { OnSpecial03Start(); return true; }
		if (name == "special_03_strike") { OnSpecial03Strike(Param(params, 0), Vec(Param(params, 1)), EntityParam(params, 2), Truthy(Param(params, 3))); return true; }
		if (name == "volcano_reset") { OnVolcanoReset(); return true; }
		if (name == "weapon_spawn") { OnWeaponSpawn(); return true; }
		return SwordsBaseTwohandedScript::DispatchEvent(name, params);
	}
}
