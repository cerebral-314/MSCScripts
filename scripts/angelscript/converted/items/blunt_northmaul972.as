#pragma context server

// Converted from items/blunt_northmaul972.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/items/blunt_base_twohanded.as"

[script "items/blunt_northmaul972"]
class BluntNorthmaul972 : BluntBaseTwohandedScript
{
	// Constants
	bool CUSTOM_REGISTER_BLUNT = true;
	string BASE_LEVEL_REQ = "20";
	int ICEWAVE_MPDRAIN = 60;
	int BLIZZARD_MPDRAIN = 30;
	int MODEL_VIEW_IDX = 5;
	int ANIM_SWITCH = 11;
	int ANIM_PIERCE_IDLE = 12;
	int ANIM_PIERCE_SWING1 = 4;
	int ANIM_PIERCE_SWING2 = 5;
	int ANIM_GROUND_SMASH_NORM = 10;
	int ANIM_GROUND_SMASH_PIERCE = 13;
	int ANIM_BLIZZARD = 14;
	float SWIVEL_DELAY = 3.0f;
	float SWIVEL_TIME = 1.0f;
	string SOUND_COLD_HITWALL1 = "debris/glass1.wav";
	string SOUND_COLD_HITWALL2 = "debris/glass2.wav";
	string SOUND_PIERCE_HITWALL1 = "weapons/axemetal1.wav";
	string SOUND_PIERCE_HITWALL2 = "weapons/axemetal2.wav";

	// Variables (an unset .script variable reads as its own name)
	string ATTACK_MODE = "ATTACK_MODE";
	float LAST_SWIVEL = 0.0f;
	bool IN_PACK = false;

	// Variables declared by included files, with the value they start with in this script
	BluntNorthmaul972()
	{
		MODEL_VIEW = "viewmodels/v_2hblunts.mdl";
		MODEL_WORLD = "weapons/p_weapons3.mdl";
		MODEL_BODY_OFS = "7";
		ANIM_PREFIX = "standard";
		MELEE_RANGE = "80";
		MELEE_DMG_DELAY = 0.5f;
		MELEE_ATK_DURATION = 1.5f;
		MELEE_ENERGY = 2.0f;
		MELEE_DMG = 400;
		MELEE_DMG_RANGE = 20;
		MELEE_ACCURACY = "65%";
		MELEE_PARRY_AUGMENT = "10%";
		MELEE_DMG_TYPE = "cold";
	}

	// game_deploy
	void BluntNorthmaul972_OnGameDeploy()
	{
		ATTACK_MODE = "cold";
	}

	// game_deploy
	void BluntNorthmaul972_OnGameDeploy_2()
	{
		IN_PACK = false;
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
		BluntNorthmaul972_OnGameDeploy();
		BluntNorthmaul972_OnGameDeploy_2();
	}

	// game_putinpack
	void OnGamePutinpack()
	{
		BaseItemExtras_OnGamePutinpack(); // items/base_item_extras
		IN_PACK = true;
	}

	// weapon_spawn
	void OnWeaponSpawn()
	{
		BaseMelee_OnWeaponSpawn(); // items/base_melee
		BluntBaseOnehanded_OnWeaponSpawn(); // items/blunt_base_onehanded
		BluntBaseTwohanded_OnWeaponSpawn(); // items/blunt_base_twohanded

		SetName("North Maul");
		SetDescription("A gigantic hammer of solid elemental ice");
		SetWeight(80);
		SetValue(3750);
		SetHudSprite("hand", "125");
		SetHudSprite("trade", "125");
	}

	// register_charge1
	void OnRegisterCharge1()
	{
		BaseMelee_OnRegisterCharge1(); // items/base_melee

		OnRegisterCharge2();
	}

	// game_+attack2
	// mouse2 switches attack modes
	void OnGamePressAttack2()
	{
		if (!CanAttack(ENT_OWNER))
			return;

		float timeDiff = GameTime() - LAST_SWIVEL;
		if (!(timeDiff > SWIVEL_DELAY))
			return;
		LAST_SWIVEL = GameTime();

		if (ATTACK_MODE == "cold")
		{
			PlayItemViewAnim(ENT_ME, ANIM_SWITCH);
			ATTACK_MODE = "pierce";
			SetAttackProp(ENT_ME, 0, "dmg.type", "blunt"); // was "pierce", but realized this was over-nerf, as most cold resistant things are pierce resistant too
			SetAttackProp(ENT_ME, 1, "dmg.type", "blunt");
		}
		else
		{
			PlayItemViewAnim(ENT_ME, ANIM_LIFT1);
			ATTACK_MODE = "cold";
			SetAttackProp(ENT_ME, 0, "dmg.type", "cold");
			SetAttackProp(ENT_ME, 1, "dmg.type", "cold");
		}

		// dbg Attack_mode ATTACK_MODE
		ApplyEffect(ENT_OWNER, "effects/effect_templock");
		CallEventDelayed(SWIVEL_TIME, "remove_lock");
	}

	// remove_lock
	void OnRemoveLock()
	{
		CallExternal(ENT_OWNER, "ext_end_templock");
	}

	// register_charge2
	void OnRegisterCharge2()
	{
		RegisterAttack();

		// stun
		SetLocal("reg.attack.type", "strike-land");
		SetLocal("reg.attack.keys", "-attack1");
		SetLocal("reg.attack.range", MELEE_RANGE);
		SetLocal("reg.attack.dmg", "SECONDARY_DMG");
		SetLocal("reg.attack.dmg.range", MELEE_DMG_RANGE);
		SetLocal("reg.attack.dmg.type", MELEE_DMG_TYPE);
		// local reg.attack.aoe.range	100
		// local reg.attack.aoe.falloff	1.5
		SetLocal("reg.attack.energydrain", MELEE_ENERGY);
		LegacyCommand("multiply", "reg.attack.energydrain", 2);
		SetLocal("reg.attack.stat", MELEE_STAT);
		SetLocal("reg.attack.hitchance", MELEE_ACCURACY);
		LegacyCommand("add", "reg.attack.hitchance", "10%");
		SetLocal("reg.attack.priority", 2);
		SetLocal("reg.attack.delay.strike", 1.5f);
		SetLocal("reg.attack.delay.end", 2.0f);
		SetLocal("reg.attack.ofs.startpos", "MELEE_STARTPOS");
		SetLocal("reg.attack.ofs.aimang", "MELEE_AIMANGLE");
		SetLocal("reg.attack.callback", "special_02");
		SetLocal("reg.attack.noise", 1000);
		SetLocal("reg.attack.chargeamt", "200%");
		SetLocal("reg.attack.reqskill", 4);
		if (Float(BASE_LEVEL_REQ) > 0.0f)
			LegacyCommand("add", "reg.attack.reqskill", BASE_LEVEL_REQ);

		RegisterAttack();

		// blizzard
		SetLocal("reg.attack.type", "strike-land");
		SetLocal("reg.attack.keys", "-attack1");
		SetLocal("reg.attack.range", 0);
		SetLocal("reg.attack.dmg", 0);
		SetLocal("reg.attack.dmg.range", 0);
		SetLocal("reg.attack.dmg.type", "target");
		SetLocal("reg.attack.energydrain", MELEE_ENERGY);
		LegacyCommand("multiply", "reg.attack.energydrain", 2);
		SetLocal("reg.attack.stat", "spellcasting.ice");
		SetLocal("reg.attack.hitchance", "100%");
		SetLocal("reg.attack.priority", 3);
		SetLocal("reg.attack.delay.strike", 1.5f);
		SetLocal("reg.attack.delay.end", 2.0f);
		SetLocal("reg.attack.ofs.startpos", "MELEE_STARTPOS");
		SetLocal("reg.attack.ofs.aimang", "MELEE_AIMANGLE");
		SetLocal("reg.attack.callback", "blizzard");
		SetLocal("reg.attack.noise", 1000);
		SetLocal("reg.attack.chargeamt", "300%");
		SetLocal("reg.attack.mpdrain", BLIZZARD_MPDRAIN);
		SetLocal("reg.attack.reqskill", 15);
		RegisterAttack();

		// ice wave
		SetLocal("reg.attack.type", "strike-land");
		SetLocal("reg.attack.keys", "-attack1");
		SetLocal("reg.attack.range", 80);
		SetLocal("reg.attack.dmg", MELEE_DMG);
		LegacyCommand("multiply", "reg.attack.dmg", 4);
		SetLocal("reg.attack.dmg.range", MELEE_DMG_RANGE);
		SetLocal("reg.attack.dmg.type", "pierce");
		SetLocal("reg.attack.energydrain", MELEE_ENERGY);
		LegacyCommand("multiply", "reg.attack.energydrain", 2);
		SetLocal("reg.attack.stat", "bluntarms");
		SetLocal("reg.attack.hitchance", "100%");
		SetLocal("reg.attack.priority", 4);
		SetLocal("reg.attack.delay.strike", 0.75f);
		SetLocal("reg.attack.delay.end", 1.0f);
		SetLocal("reg.attack.ofs.startpos", "MELEE_STARTPOS");
		SetLocal("reg.attack.ofs.aimang", "MELEE_AIMANGLE");
		SetLocal("reg.attack.callback", "stomp");
		SetLocal("reg.attack.noise", 1000);
		SetLocal("reg.attack.chargeamt", "400%");
		SetLocal("reg.attack.mpdrain", ICEWAVE_MPDRAIN);
		SetLocal("reg.attack.reqskill", 27);
		RegisterAttack();
	}

	// blizzard_start
	void OnBlizzardStart()
	{
		bool exitSub = false;

		if (SkillOf(ENT_OWNER, "bluntarms.proficiency") < 20.0f)
		{
			PlayerMessageDark(ENT_OWNER, "Northmaul: You do not have sufficient blunt arms skill to use Blizzard attack");
			exitSub = true;
		}
		if (ManaOf(ENT_OWNER) < BLIZZARD_MPDRAIN)
		{
			PlayerMessageDark(ENT_OWNER, "Northmaul: Insufficient mana for Blizzard.");
			exitSub = true;
		}
		if (exitSub)
			return;

		PlayItemViewAnim(ENT_ME, ANIM_BLIZZARD);
		PlayOwnerAnim("once", PLAYERANIM_SWING, "global.anim.combatwalk", 3);
		CallEventDelayed(1.0f, "summon_blizzard");

		ServerPlaySound(2, 10, ScriptVarOf(ENT_OWNER, "PLR_SOUND_SHOUT1"));
	}

	// summon_blizzard
	void OnSummonBlizzard()
	{
		Vector3 pos = OriginOf(ENT_OWNER);
		float temp = GroundHeight(pos);
		float x = pos.x;
		float y = pos.y;
		pos = Vector3(x, y, temp);

		CreateNpc("monsters/summon/summon_blizzard", pos, @EntityOf(ENT_OWNER), AnglesOf(ENT_OWNER).y, 15, 15, "spellcasting.ice");
	}

	// stomp_start
	void OnStompStart()
	{
		bool exitSub = false;

		if (SkillOf(ENT_OWNER, "spellcasting.ice") < 15.0f)
		{
			PlayerMessageDark(ENT_OWNER, "Northmaul: You do not have sufficient ice magic skill to use Ice Wave attack");
			exitSub = true;
		}
		if (ManaOf(ENT_OWNER) < ICEWAVE_MPDRAIN)
		{
			PlayerMessageDark(ENT_OWNER, "Northmaul: Insufficient mana for Ice Wave.");
			exitSub = true;
		}
		if (exitSub)
			return;

		if (ATTACK_MODE == "cold")
			PlayItemViewAnim(ENT_ME, ANIM_GROUND_SMASH_NORM);
		if (ATTACK_MODE == "pierce")
			PlayItemViewAnim(ENT_ME, ANIM_GROUND_SMASH_PIERCE);
		PlayOwnerAnim("once", PLAYERANIM_SWING, "global.anim.combatwalk", 3);

		ServerPlaySound(2, 10, ScriptVarOf(ENT_OWNER, "PLR_SOUND_SHOUT1"));
	}

	// stomp_strike
	void OnStompStrike(string hitType = "", Vector3 endPos = Vector3(), CBaseEntity@ hitEntity = null, bool hit = false)
	{
		PlaySound(0, 10, "magic/boom.wav");
		CreateNpc("monsters/summon/ice_wave_player", OriginOf(ENT_OWNER), @EntityOf(ENT_OWNER), 10, 3);
	}

	// melee_start
	void OnMeleeStart()
	{
		int rndAnim = RandomInt(1, 2);
		if (ATTACK_MODE == "cold")
		{
			if (rndAnim == 1)
				PlayItemViewAnim(ENT_ME, Int(ANIM_ATTACK1));
			if (rndAnim == 2)
				PlayItemViewAnim(ENT_ME, Int(ANIM_ATTACK2));
		}
		if (ATTACK_MODE == "pierce")
		{
			if (rndAnim == 1)
				PlayItemViewAnim(ENT_ME, ANIM_PIERCE_SWING1);
			if (rndAnim == 2)
				PlayItemViewAnim(ENT_ME, ANIM_PIERCE_SWING2);
		}
		// playviewanim	 MELEE_VIEWANIM_ATK
		if (PLAYERANIM_SWING != "PLAYERANIM_SWING")
			PlayOwnerAnim("once", PLAYERANIM_SWING, "global.anim.combatwalk", 3);
		CallEventDelayed(MELEE_SOUND_DELAY, "melee_playsound");
	}

	// item_idle
	void OnItemIdle()
	{
		// dbg item_idle game.item.inhand game.item.attacking ATTACK_MODE
		if (Truthy(Eval("game.item.attacking")))
			return;
		if (!IsInHand(ENT_ME))
			return;
		if (IN_PACK)
			return;

		if (ATTACK_MODE == "cold")
			PlayItemViewAnim(ENT_ME, 1);
		if (ATTACK_MODE == "pierce")
			PlayItemViewAnim(ENT_ME, ANIM_PIERCE_IDLE);
	}

	// game_switchhands
	void OnGameSwitchhands()
	{
	}

	// hitwall
	void OnHitwall()
	{
		if (ATTACK_MODE == "cold")
			PlayRandomSound(Int(Eval("game.sound.weapon")), Eval("game.sound.maxvol"), SOUND_COLD_HITWALL1, SOUND_COLD_HITWALL2);
		if (ATTACK_MODE == "pierce")
			PlayRandomSound(Int(Eval("game.sound.weapon")), Eval("game.sound.maxvol"), SOUND_PIERCE_HITWALL1, SOUND_PIERCE_HITWALL2);
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files
	void OnSwivelTime() {} // SWIVEL_TIME

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("weapons/p_weapons3.mdl");
		Precache("viewmodels/v_2hblunts.mdl");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "blizzard_start") { OnBlizzardStart(); return true; }
		if (name == "game_+attack2") { OnGamePressAttack2(); return true; }
		if (name == "game_deploy") { OnGameDeploy(); return true; }
		if (name == "game_putinpack") { OnGamePutinpack(); return true; }
		if (name == "game_switchhands") { OnGameSwitchhands(); return true; }
		if (name == "hitwall") { OnHitwall(); return true; }
		if (name == "item_idle") { OnItemIdle(); return true; }
		if (name == "melee_start") { OnMeleeStart(); return true; }
		if (name == "register_charge1") { OnRegisterCharge1(); return true; }
		if (name == "register_charge2") { OnRegisterCharge2(); return true; }
		if (name == "remove_lock") { OnRemoveLock(); return true; }
		if (name == "stomp_start") { OnStompStart(); return true; }
		if (name == "stomp_strike") { OnStompStrike(Param(params, 0), Vec(Param(params, 1)), EntityParam(params, 2), Truthy(Param(params, 3))); return true; }
		if (name == "summon_blizzard") { OnSummonBlizzard(); return true; }
		if (name == "weapon_spawn") { OnWeaponSpawn(); return true; }
		return BluntBaseTwohandedScript::DispatchEvent(name, params);
	}
}
