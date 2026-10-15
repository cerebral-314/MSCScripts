#pragma context server

// Converted from items/axes_sp.script by msc_transpiler.
// Spider Axe (model by truewarrior)

#include "runtime/ScriptEntity.as"
#include "converted/items/axes_base_twohanded.as"

[script "items/axes_sp"]
class AxesSp : AxesBaseTwohandedScript
{
	// Constants
	string ANIM_ATTACK3 = "4";
	int ANIM_SHEATH = 5;
	int RANGED_MP = 5;
	float THROW_ATTACK_DELAY = 0.5f;
	int MP_CIRCLE_OF_WEBS = 90;

	// Variables (an unset .script variable reads as its own name)
	bool AXE_DEPLOYED = false;
	float AXE_IDLE_COUNT = 0.0f;
	float NEXT_IDLE = 0.0f;
	float NEXT_WEB = 0.0f;
	float NEXT_CIRCLE = 0.0f;

	// Variables declared by included files, with the value they start with in this script
	AxesSp()
	{
		BASE_LEVEL_REQ = "25";
		ANIM_IDLE1 = "1";
		ANIM_ATTACK1 = "2";
		ANIM_ATTACK2 = "3";
		MODEL_VIEW = "viewmodels/v_2haxesgreat.mdl";
		MODEL_VIEW_IDX = 9;
		MODEL_HANDS = "weapons/p_weapons4.mdl";
		MODEL_WORLD = "weapons/p_weapons4.mdl";
		SOUND_SWIPE = "weapons/swingsmall.wav";
		MODEL_BODY_OFS = "57";
		ANIM_PREFIX = "standard";
		MELEE_RANGE = "100";
		MELEE_DMG_DELAY = 0.6f;
		MELEE_ATK_DURATION = 1.5f;
		MELEE_ENERGY = 3.0f;
		MELEE_DMG = 375;
		MELEE_DMG_RANGE = 150;
		MELEE_DMG_TYPE = "slash";
		MELEE_ACCURACY = "65";
		MELEE_STAT = "axehandling";
		MELEE_PARRY_CHANCE = "25";
	}

	// melee_damaged_other
	// PARAM1=target_hit PARAM2=dmg PARAM3=dmg_type PARAM4=dmgevent //items return <attack_callback>_damaged_other
	string AxesSp_OnMeleeDamagedOther(CBaseEntity@ target = null, float damage = 0.0f, string damageType = "", string damageEvent = "")
	{
		string result = "";
		if (!Contains(ItemNameOf(target), "spid"))
			return result;
		SetDamageInfo("dmg", damage * 3.0f);
		result = AppendResult(result, "3.0");
		OnSpiderDefile(target);
		return result;
	}

	// special_01_damaged_other
	// PARAM1=target_hit PARAM2=dmg PARAM3=dmg_type PARAM4=dmgevent //items return <attack_callback>_damaged_other
	string AxesSp_OnSpecial01DamagedOther(CBaseEntity@ target = null, float damage = 0.0f, string damageType = "", string damageEvent = "")
	{
		string result = "";
		if (!Contains(ItemNameOf(target), "spid"))
			return result;
		SetDamageInfo("dmg", damage * 3.0f);
		result = AppendResult(result, "3.0");
		OnSpiderDefile(target);
		return result;
	}

	// game_takedamage
	// PARAM1=attacker  PARAM2=inflictor? PARAM3=dmg PARAM4=dmg_type - use return to alter incoming damage
	string AxesSp_OnGameTakedamage(CBaseEntity@ attacker = null, CBaseEntity@ inflictor = null, float damage = 0.0f, string damageType = "")
	{
		bool reduceDmg = false;
		string result = "";
		if (!IsInHand(ENT_ME))
			return result;
		if (RaceOf(attacker) == "spider")
			reduceDmg = true;
		if (RaceOf(inflictor) == "spider")
			reduceDmg = true;

		string name = NameOf(attacker);
		name = ToLowerCase(name);
		if (Contains(name, "spider"))
			reduceDmg = true;

		if (Contains(ItemNameOf(attacker), "spid"))
			reduceDmg = true;
		if (Contains(ItemNameOf(inflictor), "spid"))
			reduceDmg = true;

		if (!reduceDmg)
			return result;
		float dmg = damage * 0.5f;
		SetDamageInfo("hit", 1);
		SetDamageInfo("dmg", dmg);
		result = AppendResult(result, "0.5");
		return result;
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseItemExtras_OnGameSpawn(playerRace, playerGender); // items/base_item_extras
		BaseItem_OnGameSpawn(playerRace, playerGender); // items/base_item
		AxesBaseTwohanded_OnGameSpawn(playerRace, playerGender); // items/axes_base_twohanded
		AxesBaseTwohanded_OnGameSpawn_2(playerRace, playerGender); // items/axes_base_twohanded

		SetLocal("reg.attack.type", "strike-land");
		SetLocal("reg.attack.keys", "-attack1");
		SetLocal("reg.attack.range", 0);
		SetLocal("reg.attack.dmg", 0);
		SetLocal("reg.attack.dmg.range", 0);
		SetLocal("reg.attack.dmg.type", "none");
		SetLocal("reg.attack.energydrain", 0);
		SetLocal("reg.attack.stat", "axehandling");
		SetLocal("reg.attack.hitchance", 100);
		SetLocal("reg.attack.priority", 3);
		SetLocal("reg.attack.delay.strike", 1.5f);
		SetLocal("reg.attack.delay.end", 2.0f);
		SetLocal("reg.attack.ofs.startpos", "MELEE_STARTPOS");
		SetLocal("reg.attack.ofs.aimang", "MELEE_AIMANGLE");
		SetLocal("reg.attack.callback", "makewebs");
		SetLocal("reg.attack.noise", 1000);
		SetLocal("reg.attack.chargeamt", 200);
		SetLocal("reg.attack.reqskill", 27);
		SetLocal("reg.attack.mpdrain", MP_CIRCLE_OF_WEBS);

		RegisterAttack();
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
		// (never true here, the rest is skipped) if game.clientside
	}

	// bweapon_effect_activate
	void OnBweaponEffectActivate()
	{
		BaseItemExtras_OnBweaponEffectActivate(); // items/base_item_extras
		// this may have created a global fubar in ext_activate_items due to the precent fail
		// scratch that, problem was not here despite the percent sign... (see above)
		if (!Truthy(ScriptVarOf(ENT_OWNER, "PLR_IN_WORLD")))
			return;
		OwnerMessage("You are now immune to web effects and take half damage from spiders.");
		ScriptFlags(ENT_OWNER, "add", "spideraxe", "spider_resist", 0.5f, -1);
	}

	// bweapon_effect_remove
	void OnBweaponEffectRemove(string reason = "")
	{
		BaseItemExtras_OnBweaponEffectRemove(reason); // items/base_item_extras
		DebugPrint("items/axes_sp bweapon_effect_remove " + reason);
		// problem was here actually... though I dun see what.
		// apparently it had something to do with this being called on game_deleted by the item manager.
		if (!Truthy(ScriptFlag(ENT_OWNER, "spideraxe", "name_exists")))
			return;
		OwnerMessage("You are no longer resistant to spiders.");
		ScriptFlags(ENT_OWNER, "remove", "spideraxe");
	}

	// weapon_spawn
	void OnWeaponSpawn()
	{
		BaseMelee_OnWeaponSpawn(); // items/base_melee

		SetName("Spider Axe");
		if (RandomInt(1, 3) == 1)
			SetDescription("How do I shot web?");
		else
			SetDescription("This red amber axe debilitates spiders and ensnares other enemies");
		SetWeight(90);
		SetValue(1200);
		SetHudSprite("hand", "197");
		SetHudSprite("trade", "197");
	}

	// melee_start
	void OnMeleeStart()
	{
		BaseMelee_OnMeleeStart(); // items/base_melee
		NEXT_IDLE = GameTime() + 4.0f;
	}

	// special_01_start
	void OnSpecial01Start()
	{
		BaseMelee_OnSpecial01Start(); // items/base_melee
		NEXT_IDLE = GameTime() + 4.0f;
	}

	// melee_damaged_other
	string OnMeleeDamagedOther(CBaseEntity@ target = null, float damage = 0.0f, string damageType = "", string damageEvent = "")
	{
		string result = "";
		result = AppendResult(result, BaseMelee_OnMeleeDamagedOther(target, damage, damageType, damageEvent));
		result = AppendResult(result, AxesSp_OnMeleeDamagedOther(target, damage, damageType, damageEvent));
		return result;
	}

	// spec_idle_loop
	void OnSpecIdleLoop()
	{
		if (!AXE_DEPLOYED)
			return;
		if (!IsInHand(ENT_ME))
			return;

		if (!(GameTime() > NEXT_IDLE))
			return;

		if (Truthy(Eval("game.item.attacking")))
		{
			NEXT_IDLE = GameTime() + 3.0f;
			CallEventDelayed(4.0f, "spec_idle_loop");
		}
		else
		{
			AXE_IDLE_COUNT += 1.0f;
			if (AXE_IDLE_COUNT == 1.0f)
			{
				PlayViewAnim(1);
				CallEventDelayed(20.0f, "spec_idle_loop");
			}
			else
			{
				PlayViewAnim(4);
				CallEventDelayed(5.0f, "spec_idle_loop");
				AXE_IDLE_COUNT = 0.0f;
			}
		}
	}

	string OnSpecial01DamagedOther(CBaseEntity@ target = null, float damage = 0.0f, string damageType = "", string damageEvent = "") { return AxesSp_OnSpecial01DamagedOther(target, damage, damageType, damageEvent); } // special_01_damaged_other

	// spider_defile
	void OnSpiderDefile(CBaseEntity@ target = null)
	{
		float dot = SkillOf(ENT_OWNER, "spellcasting.affliction");
		ApplyEffect(target, "effects/dot_dark", 30.0f, @EntityOf(ENT_OWNER), dot, "axehandling");
	}

	// game_+attack2
	void OnGamePressAttack2()
	{
		if (Truthy(Eval("game.item.attacking")))
			return;
		if (!CanAttack(ENT_OWNER))
			return;

		if (!(GameTime() > NEXT_WEB))
			return;
		NEXT_WEB = GameTime() + 1.2f;

		if (SkillOf(ENT_OWNER, "axehandling.proficiency") < 25.0f)
			return;

		if (ManaOf(ENT_OWNER) < RANGED_MP)
		{
			PlayerMessageDark(ENT_OWNER, "Spider Axe: Not enough mana for web projectile (5)");
			return;
		}

		GiveMana(ENT_OWNER, -RANGED_MP);

		NEXT_IDLE = GameTime() + 4.0f;

		PlayItemViewAnim(ENT_ME, 8);

		CallEventDelayed(THROW_ATTACK_DELAY, "do_web");
	}

	// do_web
	void OnDoWeb()
	{
		PlaySound(0, 10, "bullchicken/bc_attack2.wav", 0.8f, RandomInt(80, 120));

		// <projectile scriptname> <"view"|(src_origin)> <target|(targ_origin)> <speed> <damage> <cof> <skill|none>
		CallExternal(ENT_OWNER, "ext_tossprojectile", "proj_web", "view", "none", 700, Random(50, 60), 0, "axehandling"); // proj_web
	}

	// makewebs_start
	void OnMakewebsStart()
	{
		NEXT_IDLE = GameTime() + 4.0f;

		if (!(ManaOf(ENT_OWNER) > MP_CIRCLE_OF_WEBS))
			return;

		bool reqsMet = true;

		if (SkillOf(ENT_OWNER, "spellcasting.affliction") < 5.0f)
		{
			PlayerMessageDark(ENT_OWNER, "Spider Axe: Insufficient affliction talent for web projectile (5)");
			reqsMet = false;
		}

		if (GameTime() < NEXT_CIRCLE)
		{
			OwnerMessage("Spider axe can only maintain one web trap at a time.");
			reqsMet = false;
		}

		if (!reqsMet)
		{
			CancelAttack();
			return;
		}

		PlayItemViewAnim(ENT_ME, 9);
		PlayOwnerAnim("critical", "PLAYERANIM_PREPARE", "squatwalk1");
		PlaySound(Int(Eval("game.sound.item")), 10, "magic/temple.wav");
	}

	// makewebs_strike
	void OnMakewebsStrike(string hitType = "", Vector3 endPos = Vector3(), CBaseEntity@ hitEntity = null, bool hit = false)
	{
		CreateNpc("monsters/summon/circle_of_lolth", OriginOf(ENT_OWNER), @EntityOf(ENT_OWNER), 5.0f);
		NEXT_CIRCLE = GameTime() + 5.0f;
	}

	string OnGameTakedamage(CBaseEntity@ attacker = null, CBaseEntity@ inflictor = null, float damage = 0.0f, string damageType = "") { return AxesSp_OnGameTakedamage(attacker, inflictor, damage, damageType); } // game_takedamage

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files
	void OnThrowAttackDelay() {} // THROW_ATTACK_DELAY

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("weapons/p_weapons4.mdl");
		Precache("viewmodels/v_2haxesgreat.mdl");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "bweapon_effect_activate") { OnBweaponEffectActivate(); return true; }
		if (name == "bweapon_effect_remove") { OnBweaponEffectRemove(Param(params, 0)); return true; }
		if (name == "do_web") { OnDoWeb(); return true; }
		if (name == "game_+attack2") { OnGamePressAttack2(); return true; }
		if (name == "game_deploy") { OnGameDeploy(); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "game_takedamage") { Return(OnGameTakedamage(EntityParam(params, 0), EntityParam(params, 1), Float(Param(params, 2)), Param(params, 3))); return true; }
		if (name == "makewebs_start") { OnMakewebsStart(); return true; }
		if (name == "makewebs_strike") { OnMakewebsStrike(Param(params, 0), Vec(Param(params, 1)), EntityParam(params, 2), Truthy(Param(params, 3))); return true; }
		if (name == "melee_damaged_other") { Return(OnMeleeDamagedOther(EntityParam(params, 0), Float(Param(params, 1)), Param(params, 2), Param(params, 3))); return true; }
		if (name == "melee_start") { OnMeleeStart(); return true; }
		if (name == "spec_idle_loop") { OnSpecIdleLoop(); return true; }
		if (name == "special_01_damaged_other") { Return(OnSpecial01DamagedOther(EntityParam(params, 0), Float(Param(params, 1)), Param(params, 2), Param(params, 3))); return true; }
		if (name == "special_01_start") { OnSpecial01Start(); return true; }
		if (name == "spider_defile") { OnSpiderDefile(EntityParam(params, 0)); return true; }
		if (name == "weapon_spawn") { OnWeaponSpawn(); return true; }
		return AxesBaseTwohandedScript::DispatchEvent(name, params);
	}
}
