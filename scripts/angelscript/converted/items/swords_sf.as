#pragma context server

// Converted from items/swords_sf.script by msc_transpiler.
// (Dark dmg, 100% fire DOT, 50% fire dmg deduct, fire burst, fire wave)

#include "runtime/ScriptEntity.as"
#include "converted/items/swords_base_twohanded.as"

[script "items/swords_sf"]
class SwordsSf : SwordsBaseTwohandedScript
{
	// Constants
	int FIRE_WAVE_MP = 20;
	int FIRE_BURST_MP = 30;
	string ANIM_LUNGE = "3";
	int ANIM_PARRY1 = 4;
	int ANIM_PARRY1_RETRACT = 5;
	string MELEE_NEW_PARRY_CHANCE = "50";

	// Variables (an unset .script variable reads as its own name)
	int GAME_PVP = 0;
	float OWNER_SWORDSKILL = 0.0f;
	float OWNER_FIRESKILL = 0.0f;
	Vector3 FIRE_WAVE_START_POS = Vector3();
	float FIRE_WAVE_YAW = 0.0f;
	string FIRE_WAVE_TARGS = "FIRE_WAVE_TARGS";
	float WAVE_DOT_BURN = 0.0f;
	string OWNER_ORG = "OWNER_ORG";
	Vector3 OWNER_ANG = Vector3();
	float FIRE_AURA_BEGIN = 0.0f;
	bool PARRY_ON = false;
	float NEXT_PARRY = 0.0f;
	int FAURA_RAD = 0;
	bool FAURA_ACTIVE = false;
	Vector3 BURST_POS = Vector3();
	string FIRE_BURST_TARGS = "FIRE_BURST_TARGS";
	float BURST_DOT_BURN = 0.0f;

	// Variables declared by included files, with the value they start with in this script
	SwordsSf()
	{
		BASE_LEVEL_REQ = "25";
		ANIM_ATTACK2 = "2";
		ANIM_ATTACK3 = "2";
		ATTACK_ANIMS = 1;
		ANIM_UNSHEATH = 6;
		ANIM_SHEATH = 7;
		MODEL_HANDS = "weapons/p_weapons3.mdl";
		MODEL_WORLD = "weapons/p_weapons3.mdl";
		MODEL_VIEW = "viewmodels/v_2hswords.mdl";
		MODEL_VIEW_IDX = 11;
		MODEL_BODY_OFS = "84";
		ANIM_PREFIX = "standard";
		MELEE_RANGE = "80";
		MELEE_DMG_DELAY = 0.6f;
		MELEE_ATK_DURATION = 1.3f;
		MELEE_ENERGY = 1.0f;
		MELEE_DMG = 275;
		MELEE_DMG_RANGE = 140;
		MELEE_DMG_TYPE = "dark";
		MELEE_ACCURACY = "75%";
		MELEE_STAT = "swordsmanship";
		MELEE_ALIGN_BASE = "3,10";
		MELEE_ALIGN_TIP = "0,-10";
		MELEE_PARRY_CHANCE = "60%";
		PLAYERANIM_AIM = "sword_double_idle";
		PLAYERANIM_SWING = "sword_double_swing";
		SOUND_SWIPE = "weapons/swingsmall.wav";
		SOUND_DRAW = "weapons/swords/sworddraw.wav";
	}

	// game_dodamage
	string SwordsSf_OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		bool exitSub = false;
		string result = "";
		if (!hit)
			return result;
		if (IsPlayer(target) && GAME_PVP == 0)
			exitSub = true;
		if (exitSub)
			return result;

		float dotBurn = SkillOf(ENT_OWNER, "spellcasting.fire") * 0.75f;
		ApplyEffect(target, "effects/dot_fire", 5.0f, @EntityOf(ENT_OWNER), dotBurn, "swordsmanship");
		return result;
	}

	// bweapon_effect_remove
	void SwordsSf_OnBweaponEffectRemove(string reason = "")
	{
		if (FAURA_ACTIVE)
			OnEndFaura();
	}

	// game_takedamage
	// 50% fire damage reduction
	// PARAM1=attacker  PARAM2=inflictor? PARAM3=dmg PARAM4=dmg_type - use return to alter incoming damage
	string SwordsSf_OnGameTakedamage(CBaseEntity@ attacker = null, CBaseEntity@ inflictor = null, float damage = 0.0f, string damageType = "")
	{
		bool noAbsorb = false;
		float inDmg = 0.0f;
		string result = "";

		if (ScriptVarOf(ENT_OWNER, "PLR_ACTIVE_WEAPON") != EntityId(self))
			return result;

		if (PARRY_ON)
		{
			if (Contains(damageType, "effect"))
				noAbsorb = true;
			if (!noAbsorb)
			{
				inDmg = damage * 0.5f;
				SetDamageInfo("dmg", inDmg);
				result = AppendResult(result, "0.5");
			}
		}

		if (!Contains(damageType, "fire"))
			return result;
		inDmg = damage * 0.5f;
		SetDamageInfo("dmg", inDmg);
		result = AppendResult(result, "0.5");
		return result;
	}

	// bweapon_effect_remove
	void SwordsSf_OnBweaponEffectRemove_2(string reason = "")
	{
		PARRY_ON = false;
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
		GAME_PVP = (IsPvp() ? 1 : 0);
		OWNER_SWORDSKILL = SkillOf(ENT_OWNER, "swordsmanship");
		OWNER_FIRESKILL = SkillOf(ENT_OWNER, "spellcasting.fire");
	}

	// bweapon_effect_remove
	void OnBweaponEffectRemove(string reason = "")
	{
		BaseItemExtras_OnBweaponEffectRemove(reason); // items/base_item_extras
		SwordsBaseTwohanded_OnBweaponEffectRemove(reason); // items/swords_base_twohanded
		SwordsSf_OnBweaponEffectRemove(reason);
		SwordsSf_OnBweaponEffectRemove_2(reason);
	}

	// weapon_spawn
	void OnWeaponSpawn()
	{
		BaseMelee_OnWeaponSpawn(); // items/base_melee
		SwordsBaseTwohanded_OnWeaponSpawn(); // items/swords_base_twohanded

		SetName("Shadowfire Blade");
		SetDescription("This is a twisted blade of elemental fire");
		SetWeight(75);
		SetValue(3750);
		SetHudSprite("trade", "167");

		SetHand("both");
	}

	// register_charge1
	void OnRegisterCharge1()
	{
		BaseMelee_OnRegisterCharge1(); // items/base_melee
		SwordsBaseTwohanded_OnRegisterCharge1(); // items/swords_base_twohanded

		SetLocal("reg.attack.type", "strike-land");
		SetLocal("reg.attack.range", MELEE_RANGE);
		LegacyCommand("multiply", "reg.attack.range", 1.5f);
		SetLocal("reg.attack.noautoaim", 1);
		SetLocal("reg.attack.dmg", MELEE_DMG);
		LegacyCommand("multiply", "reg.attack.dmg", 4.0f);
		SetLocal("reg.attack.dmg.range", MELEE_DMG_RANGE);
		SetLocal("reg.attack.dmg.type", MELEE_DMG_TYPE);
		SetLocal("reg.attack.energydrain", MELEE_ENERGY);
		SetLocal("reg.attack.stat", MELEE_STAT);
		SetLocal("reg.attack.hitchance", MELEE_ACCURACY);
		SetLocal("reg.attack.delay.strike", 1.4f);
		SetLocal("reg.attack.delay.end", 2.0f);
		SetLocal("reg.attack.ofs.startpos", "MELEE_STARTPOS");
		SetLocal("reg.attack.ofs.aimang", "MELEE_AIMANGLE");
		SetLocal("reg.attack.noise", MELEE_NOISE);

		SetLocal("reg.attack.priority", 2);
		SetLocal("reg.attack.keys", "-attack1");
		SetLocal("reg.attack.callback", "fire_wave");
		SetLocal("reg.attack.chargeamt", "200%");
		SetLocal("reg.attack.reqskill", 34);
		RegisterAttack();
	}

	// game_takedamage
	string OnGameTakedamage(CBaseEntity@ attacker = null, CBaseEntity@ inflictor = null, float damage = 0.0f, string damageType = "")
	{
		string result = "";
		result = AppendResult(result, SwordsBaseTwohanded_OnGameTakedamage(attacker, inflictor, damage, damageType));
		result = AppendResult(result, SwordsSf_OnGameTakedamage(attacker, inflictor, damage, damageType));
		return result;
	}

	// game_+attack2
	void OnGamePressAttack2()
	{
		SwordsBaseTwohanded_OnGamePressAttack2(); // items/swords_base_twohanded
		bool exitSub = false;
		if (Truthy(Eval("game.item.attacking")))
			return;

		if (!CanAttack(ENT_OWNER))
			return;

		if (!PARRY_ON && GameTime() > NEXT_PARRY)
		{
			PlayItemViewAnim(ENT_ME, ANIM_PARRY1);
			FIRE_AURA_BEGIN = GameTime() + 2.0f;
			PARRY_ON = true;
			NEXT_PARRY = GameTime() + 1.0f;
		}

		if (PARRY_ON && !FAURA_ACTIVE && OWNER_FIRESKILL >= 30.0f && GameTime() > FIRE_AURA_BEGIN)
		{
			FAURA_RAD = 64;
			FAURA_ACTIVE = true;
			if (ManaOf(ENT_OWNER) <= 10.0f)
			{
				PlayerMessageDark(ENT_OWNER, "Shadowfire Blade: Insufficient mana for Shadowfire Aura");
				FIRE_AURA_BEGIN = GameTime() + 5.0f;
				exitSub = true;
				if (FAURA_ACTIVE)
					OnEndFaura();
			}
			if (!exitSub)
			{
				FAURA_ACTIVE = true;
				CallExternal(ENT_OWNER, "ext_sfaura_start", self);
			}
		}
	}

	// game_-attack2
	void OnGameReleaseAttack2()
	{
		SwordsBaseTwohanded_OnGameReleaseAttack2(); // items/swords_base_twohanded
		if (PARRY_ON)
			OnExitParry();
	}

	// melee_start
	void OnMeleeStart()
	{
		int swingAnim = 0;

		if (PARRY_ON)
			OnExitParry();

		int rSwing = RandomInt(1, 3);
		if (rSwing == 1)
			swingAnim = Int(ANIM_ATTACK1);
		if (rSwing == 2)
			swingAnim = Int(ANIM_ATTACK2);
		if (rSwing == 3)
			swingAnim = Int(ANIM_ATTACK3);
		PlayOwnerAnim("once", "sword_double_swing");
		PlayViewAnim(swingAnim);
		PlaySound(1, 10, SOUND_SWIPE);
	}

	// special_01_start
	void OnSpecial01Start()
	{
		if (PARRY_ON)
			OnExitParry();
		PlayViewAnim(Int(ANIM_LUNGE));
		PlayOwnerAnim("once", "axe_twohand_swing");
		PlaySound(Int(Eval("const.snd.weapon")), Eval("const.snd.maxvol"), SPECIAL01_SND);
	}

	// fire_wave_start
	void OnFireWaveStart()
	{
		PlayViewAnim(Int(ANIM_LUNGE));
		PlayOwnerAnim("once", "axe_twohand_swing");
		PlaySound(Int(Eval("const.snd.weapon")), Eval("const.snd.maxvol"), SOUND_SHOUT);
	}

	string OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "") { return SwordsSf_OnGameDodamage(hit, target, start, end, damageType, damageText); } // game_dodamage

	// fire_wave_strike
	// //PARAM1: "none"/"npc"/"world"   2: Attack end Position   3: Entity hit (if any)
	void OnFireWaveStrike(string hitType = "", Vector3 endPos = Vector3(), CBaseEntity@ hitEntity = null, bool hit = false)
	{
		bool exitSub = false;

		if (endPos.z != GroundHeight(endPos))
			return;

		if (!(SkillOf(ENT_OWNER, "spellcasting.fire") >= 25.0f))
			return;

		if (ManaOf(ENT_OWNER) < FIRE_WAVE_MP)
		{
			PlayerMessageDark(ENT_OWNER, "Shadowfire Blade: Insufficient MP for Fire Wave");
			exitSub = true;
		}
		if (exitSub)
			return;

		GiveMana(ENT_OWNER, -FIRE_WAVE_MP);

		OnDoFireWave(OriginOf(ENT_OWNER));
	}

	// do_fire_wave
	void OnDoFireWave(Vector3 startPosition = Vector3())
	{
		PlaySound(0, 7, "magic/flame_loop_start.wav");

		FIRE_WAVE_START_POS = startPosition;
		FIRE_WAVE_YAW = AnglesOf(ENT_OWNER).y;
		ClientEvent("new", "all", "effects/sfx_fire_wave", FIRE_WAVE_START_POS, FIRE_WAVE_YAW);

		Vector3 fireWaveScanPos = FIRE_WAVE_START_POS;
		fireWaveScanPos += RelativePosition(Vector3(0, FIRE_WAVE_YAW, 0), Vector3(0, 128, 32));

		CallExternal(ENT_OWNER, "ext_sphere_token", "enemy", 1024, fireWaveScanPos);
		FIRE_WAVE_TARGS = ScriptVarOf(ENT_OWNER, "PLR_SCAN_TOKEN");

		if (FIRE_WAVE_TARGS == "none")
			return;
		WAVE_DOT_BURN = SkillOf(ENT_OWNER, "spellcasting.fire") * 1.5f;
		OWNER_ORG = Text(FIRE_WAVE_START_POS);
		OWNER_ANG = Vector3(0, FIRE_WAVE_YAW, 0);
		int count = GetTokenCount(FIRE_WAVE_TARGS);
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnFireWaveAffectTargs();
		}

		CallEventDelayed(1.0f, "do_fire_wave2");
	}

	// do_fire_wave2
	void OnDoFireWave2()
	{
		// this repeats, to simiulate the fire wave lasting more than a second
		Vector3 fireWaveScanPos = FIRE_WAVE_START_POS;
		fireWaveScanPos += RelativePosition(Vector3(0, FIRE_WAVE_YAW, 0), Vector3(0, 128, 32));
		CallExternal(ENT_OWNER, "ext_sphere_token", "enemy", 1024, fireWaveScanPos);
		FIRE_WAVE_TARGS = ScriptVarOf(ENT_OWNER, "PLR_SCAN_TOKEN");

		if (FIRE_WAVE_TARGS == "none")
			return;
		int count = GetTokenCount(FIRE_WAVE_TARGS);
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnFireWaveAffectTargs();
		}
	}

	// fire_wave_affect_targs
	void OnFireWaveAffectTargs()
	{
		bool exitSub = false;

		string curTarg = GetToken(FIRE_WAVE_TARGS, loopIteration);

		if (IsPlayer(curTarg) && GAME_PVP == 0)
			exitSub = true;
		if (exitSub)
			return;

		Vector3 targOrg = OriginOf(curTarg);

		DebugPrint("fire_wave_affect_targs " + Text(WithinCone2D(targOrg, Vec(OWNER_ORG), OWNER_ANG, 120)) + " " + NameOf(curTarg));

		if (!WithinCone2D(targOrg, Vec(OWNER_ORG), OWNER_ANG, 120))
			return;

		Vector3 traceStart = FIRE_WAVE_START_POS;
		string traceEnd = Text(targOrg);
		string traceLine = LegacyFunction("get_traceline", traceStart, traceEnd, "worldonly");
		if (traceLine != traceEnd)
			return;

		ApplyEffect(curTarg, "effects/dot_fire", 5.0f, @EntityOf(ENT_OWNER), WAVE_DOT_BURN, "swordsmanship");
	}

	// exit_parry
	void OnExitParry()
	{
		NEXT_PARRY = GameTime() + 1.0f;
		PARRY_ON = false;
		if (FAURA_ACTIVE)
			OnEndFaura();
		if (!Truthy(Eval("game.item.attacking")))
			PlayItemViewAnim(ENT_ME, ANIM_PARRY1_RETRACT);
	}

	// bs_global_command
	void OnBsGlobalCommand(CBasePlayer@ deadPlayer = null, string command = "", string reason = "")
	{
		if (reason != "death")
			return;
		if (deadPlayer !is EntityOf(ENT_OWNER))
			return;
		if (FAURA_ACTIVE)
			OnEndFaura();
	}

	// end_faura
	void OnEndFaura()
	{
		FAURA_ACTIVE = false;
		CallExternal(ENT_OWNER, "ext_sfaura_end", "remote");
	}

	// ext_faura_ended
	void OnExtFauraEnded()
	{
		FAURA_ACTIVE = false;
	}

	// special_01_strike
	void OnSpecial01Strike(string hitType = "", Vector3 endPos = Vector3(), CBaseEntity@ hitEntity = null, bool hit = false)
	{
		bool exitSub = false;
		if (ManaOf(ENT_OWNER) < FIRE_BURST_MP)
		{
			PlayerMessageDark("Shadowfire", "Blade: Insufficient Mana for Flame Burst");
			exitSub = true;
		}
		if (exitSub)
			return;

		if (!(SkillOf(ENT_OWNER, "spellcasting.fire") >= 25.0f))
			return;
		BURST_POS = OriginOf(ENT_OWNER);
		BURST_POS.z = GroundHeight(BURST_POS);
		ClientEvent("new", "all", "effects/sfx_fire_burst", BURST_POS, 256, 1, Vector3(255, 128, 0));

		CallExternal(ENT_OWNER, "ext_sphere_token", "enemy", 512, BURST_POS);
		FIRE_BURST_TARGS = ScriptVarOf(ENT_OWNER, "PLR_SCAN_TOKEN");

		if (FIRE_BURST_TARGS == "none")
			return;
		BURST_DOT_BURN = SkillOf(ENT_OWNER, "spellcasting.fire") * 0.75f;
		int count = GetTokenCount(FIRE_BURST_TARGS);
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnFireBurstAffectTargs();
		}
	}

	// fire_burst_affect_targs
	void OnFireBurstAffectTargs()
	{
		bool exitSub = false;

		string curTarg = GetToken(FIRE_BURST_TARGS, loopIteration);

		if (IsPlayer(curTarg) && GAME_PVP == 0)
			exitSub = true;
		if (exitSub)
			return;

		Vector3 targOrg = OriginOf(curTarg);
		Vector3 traceStart = BURST_POS;
		string traceEnd = Text(targOrg);
		string traceLine = LegacyFunction("get_traceline", traceStart, traceEnd, "worldonly");
		if (traceLine != traceEnd)
			return;

		targOrg = OriginOf(curTarg);
		Vector3 myOrg = OriginOf(ENT_OWNER);
		float targAng = AnglesTo(myOrg, targOrg);
		int newYaw = int(targAng);
		AddVelocity(curTarg, RelativeVelocity(Vector3(0, newYaw, 0), Vector3(0, 800, 0)));

		ApplyEffect(curTarg, "effects/dot_fire", 5.0f, @EntityOf(ENT_OWNER), BURST_DOT_BURN, "swordsmanship");
	}

	// ext_player_sit
	void OnExtPlayerSit()
	{
		DebugPrint("ext_player_sit");
		if (FAURA_ACTIVE)
			OnEndFaura();
	}

	// ---- Engine wiring (generated) ----

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
		if (name == "bs_global_command") { OnBsGlobalCommand(PlayerParam(params, 0), Param(params, 1), Param(params, 2)); return true; }
		if (name == "bweapon_effect_remove") { OnBweaponEffectRemove(Param(params, 0)); return true; }
		if (name == "do_fire_wave") { OnDoFireWave(Vec(Param(params, 0))); return true; }
		if (name == "do_fire_wave2") { OnDoFireWave2(); return true; }
		if (name == "end_faura") { OnEndFaura(); return true; }
		if (name == "exit_parry") { OnExitParry(); return true; }
		if (name == "ext_faura_ended") { OnExtFauraEnded(); return true; }
		if (name == "ext_player_sit") { OnExtPlayerSit(); return true; }
		if (name == "fire_burst_affect_targs") { OnFireBurstAffectTargs(); return true; }
		if (name == "fire_wave_affect_targs") { OnFireWaveAffectTargs(); return true; }
		if (name == "fire_wave_start") { OnFireWaveStart(); return true; }
		if (name == "fire_wave_strike") { OnFireWaveStrike(Param(params, 0), Vec(Param(params, 1)), EntityParam(params, 2), Truthy(Param(params, 3))); return true; }
		if (name == "game_+attack2") { OnGamePressAttack2(); return true; }
		if (name == "game_-attack2") { OnGameReleaseAttack2(); return true; }
		if (name == "game_deploy") { OnGameDeploy(); return true; }
		if (name == "game_dodamage") { Return(OnGameDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5))); return true; }
		if (name == "game_takedamage") { Return(OnGameTakedamage(EntityParam(params, 0), EntityParam(params, 1), Float(Param(params, 2)), Param(params, 3))); return true; }
		if (name == "melee_start") { OnMeleeStart(); return true; }
		if (name == "register_charge1") { OnRegisterCharge1(); return true; }
		if (name == "special_01_start") { OnSpecial01Start(); return true; }
		if (name == "special_01_strike") { OnSpecial01Strike(Param(params, 0), Vec(Param(params, 1)), EntityParam(params, 2), Truthy(Param(params, 3))); return true; }
		if (name == "weapon_spawn") { OnWeaponSpawn(); return true; }
		return SwordsBaseTwohandedScript::DispatchEvent(name, params);
	}
}
