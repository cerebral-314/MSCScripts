#pragma context server

// Converted from items/axes_c.script by msc_transpiler.
// Axe o Chaos (model by truewarrior)

#include "runtime/ScriptEntity.as"
#include "converted/items/axes_base_twohanded.as"

[script "items/axes_c"]
class AxesC : AxesBaseTwohandedScript
{
	// Constants
	int MP_ELEMENT_BLAST = 50;
	int ECHAOS_AOE = 200;
	string ANIM_ATTACK3 = "4";
	int ANIM_SHEATH = 5;

	// Variables (an unset .script variable reads as its own name)
	bool ELEMENT_LOOP = false;
	int GAME_PVP = 0;
	float NEXT_RANDOM_ELEMENT = 0.0f;
	bool CAXE_SKILLED = false;
	string EFFECT_LIST = "EFFECT_LIST";
	string EFFECT_ELEMENTS = "EFFECT_ELEMENTS";
	string EFFECT_DURATIONS = "EFFECT_DURATIONS";
	string EFFECT_SKILLS = "EFFECT_SKILLS";
	string EFFECT_DOTS = "EFFECT_DOTS";
	string EFFECT_TARGET = "EFFECT_TARGET";
	float CAXE_EFFECT_COUNT = 0.0f;
	string CAXE_EFFECT = "CAXE_EFFECT";
	string CAXE_EFFECT_DUR = "CAXE_EFFECT_DUR";
	string CAXE_EFFECT_DOT = "CAXE_EFFECT_DOT";
	string CAXE_EFFECT_SKILL = "CAXE_EFFECT_SKILL";
	string CAXE_ELEMENT = "CAXE_ELEMENT";
	string MY_CL_IDX = "MY_CL_IDX";
	float NEXT_ELEMENT_BLAST = 0.0f;

	// Variables declared by included files, with the value they start with in this script
	AxesC()
	{
		BASE_LEVEL_REQ = "25";
		ANIM_IDLE1 = "1";
		ANIM_ATTACK1 = "2";
		ANIM_ATTACK2 = "3";
		MODEL_VIEW = "viewmodels/v_2haxesgreat.mdl";
		MODEL_VIEW_IDX = 8;
		MODEL_HANDS = "weapons/p_weapons4.mdl";
		MODEL_WORLD = "weapons/p_weapons4.mdl";
		SOUND_SWIPE = "weapons/swingsmall.wav";
		MODEL_BODY_OFS = "54";
		ANIM_PREFIX = "standard";
		MELEE_RANGE = "100";
		MELEE_DMG_DELAY = 0.6f;
		MELEE_ATK_DURATION = 1.5f;
		MELEE_ENERGY = 3.0f;
		MELEE_DMG = 450;
		MELEE_DMG_RANGE = 200;
		MELEE_DMG_TYPE = "slash";
		MELEE_ACCURACY = "50";
		MELEE_STAT = "axehandling";
		MELEE_PARRY_CHANCE = "25";
	}

	// melee_damaged_other
	string AxesC_OnMeleeDamagedOther(CBaseEntity@ target = null, float damage = 0.0f, string damageType = "", string damageEvent = "")
	{
		string result = "";
		if (CAXE_SKILLED)
			OnApplyDot(target);
		OnChooseDot(EntityId(target));
		NEXT_RANDOM_ELEMENT = GameTime() + 30.0f;
		return result;
	}

	// special_01_damaged_other
	string AxesC_OnSpecial01DamagedOther(CBaseEntity@ target = null, float damage = 0.0f, string damageType = "", string damageEvent = "")
	{
		string result = "";
		if (CAXE_SKILLED)
			OnApplyDot(target);
		OnChooseDot(EntityId(target));
		NEXT_RANDOM_ELEMENT = GameTime() + 30.0f;
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
		OnCaxeCheckSkill();
		if (ELEMENT_LOOP)
			return;
		ELEMENT_LOOP = true;
		CallEventDelayed(1.0f, "element_loop");
		GAME_PVP = (IsPvp() ? 1 : 0);
	}

	// bweapon_effect_remove
	void OnBweaponEffectRemove(string reason = "")
	{
		BaseItemExtras_OnBweaponEffectRemove(reason); // items/base_item_extras
		OnRemoveCl();
		ELEMENT_LOOP = false;
	}

	// weapon_spawn
	void OnWeaponSpawn()
	{
		BaseMelee_OnWeaponSpawn(); // items/base_melee

		SetName("Axe of Chaos");
		SetDescription("Elemental chaos, in weapon form.");
		SetWeight(90);
		SetValue(1200);
		SetHudSprite("hand", "198");
		SetHudSprite("trade", "198");
	}

	// melee_damaged_other
	string OnMeleeDamagedOther(CBaseEntity@ target = null, float damage = 0.0f, string damageType = "", string damageEvent = "")
	{
		string result = "";
		result = AppendResult(result, BaseMelee_OnMeleeDamagedOther(target, damage, damageType, damageEvent));
		result = AppendResult(result, AxesC_OnMeleeDamagedOther(target, damage, damageType, damageEvent));
		return result;
	}

	// element_loop
	void OnElementLoop()
	{
		if (!IsInHand(ENT_ME))
			return;
		if (!ELEMENT_LOOP)
			return;

		if (!(GameTime() > NEXT_RANDOM_ELEMENT))
			return;
		NEXT_RANDOM_ELEMENT = GameTime() + 5.0f;
		CallEventDelayed(10.0f, "element_loop");
		OnChooseDot("none");
	}

	// caxe_check_skill
	void OnCaxeCheckSkill()
	{
		CAXE_SKILLED = true;
		if (SkillOf(ENT_OWNER, "spellcasting.fire") < 10.0f)
			CAXE_SKILLED = false;
		if (SkillOf(ENT_OWNER, "spellcasting.ice") < 10.0f)
			CAXE_SKILLED = false;
		if (SkillOf(ENT_OWNER, "spellcasting.lightning") < 10.0f)
			CAXE_SKILLED = false;
		if (SkillOf(ENT_OWNER, "spellcasting.divination") < 10.0f)
			CAXE_SKILLED = false;
		if (SkillOf(ENT_OWNER, "spellcasting.affliction") < 10.0f)
			CAXE_SKILLED = false;
		if (!CAXE_SKILLED)
			PlayerMessageDark(ENT_OWNER, "Axe of Chaos: Insufficient magical talents for effects.");
	}

	string OnSpecial01DamagedOther(CBaseEntity@ target = null, float damage = 0.0f, string damageType = "", string damageEvent = "") { return AxesC_OnSpecial01DamagedOther(target, damage, damageType, damageEvent); } // special_01_damaged_other

	// special_02_damaged_other
	void OnSpecial02DamagedOther(CBaseEntity@ target = null, float damage = 0.0f, string damageType = "", string damageEvent = "")
	{
		if (CAXE_SKILLED)
			OnApplyDot(target);
		OnChooseDot(EntityId(target));
		NEXT_RANDOM_ELEMENT = GameTime() + 30.0f;
	}

	// apply_dot
	// <target>
	void OnApplyDot(CBaseEntity@ target = null)
	{
		if (IsPlayer(target) && GAME_PVP == 0)
			return;

		if (CAXE_EFFECT != "CAXE_EFFECT")
		{
			DebugPrint("apply_dot " + CAXE_EFFECT + " dur " + CAXE_EFFECT_DUR + " dot " + CAXE_EFFECT_DOT);
			ApplyEffect(target, CAXE_EFFECT, CAXE_EFFECT_DUR, @EntityOf(ENT_OWNER), CAXE_EFFECT_DOT);
		}
	}

	// choose_dot
	// [target] [noclupdate:0|1]
	void OnChooseDot(string target = "", string skipClientUpdate = "")
	{
		int count;

		EFFECT_LIST = "dot_acid;dot_fire;dot_cold;dot_poison;dot_dark;dot_lightning;dot_holy";
		EFFECT_ELEMENTS = "acid;fire;cold;poison;dark;lightning;holy";
		EFFECT_DURATIONS = "5.0;5.0;5.0;10.0;5.0;5.0;5.0";
		EFFECT_SKILLS = "affliction;fire;ice;affliction;affliction;lightning;holy";
		EFFECT_DOTS = "1.0;2.0;0.5;0.5;0.25;0.75;2.0";

		EFFECT_TARGET = target;

		// infomsg all PARAM1 PARAM2
		float nEffects = GetTokenCount(EFFECT_LIST);

		if (IsAlive(EFFECT_TARGET))
		{
			count = int(nEffects);
			for (int i = 0; i < count; i++)
			{
				loopIteration = i;
				OnFilterEffects();
			}
			CAXE_EFFECT_COUNT = 0.0f;
			count = int(nEffects);
			for (int i = 0; i < count; i++)
			{
				loopIteration = i;
				OnFilterEffects2();
			}
			nEffects = GetTokenCount(EFFECT_LIST);
		}

		if (!(nEffects > 0.0f)) // case immune to all, we'll just keep the last element
			return;

		nEffects -= 1.0f;
		int rndIdx = RandomInt(0, int(nEffects));

		string effect = "effects/" + GetToken(EFFECT_LIST, rndIdx);
		string dur = GetToken(EFFECT_DURATIONS, rndIdx);
		string skill = "skill.spellcasting." + GetToken(EFFECT_SKILLS, rndIdx);
		float dot = Float(GetProp(ENT_OWNER, skill));
		dot *= Float(GetToken(EFFECT_DOTS, rndIdx));

		// applyeffect EFFECT_TARGET L_EFFECT L_DUR $get(ent_owner,id) L_DOT
		CAXE_EFFECT = effect;
		CAXE_EFFECT_DUR = dur;
		CAXE_EFFECT_DOT = Text(dot);
		CAXE_EFFECT_SKILL = skill;
		CAXE_ELEMENT = GetToken(EFFECT_ELEMENTS, rndIdx);
		SetAttackProp(ENT_ME, 0, "type", CAXE_ELEMENT);
		SetAttackProp(ENT_ME, 1, "type", CAXE_ELEMENT);
		SetAttackProp(ENT_ME, 2, "type", CAXE_ELEMENT);

		// update client effect
		if (!Truthy(skipClientUpdate))
			OnUpdateCl();

		DebugPrint("choose_dot " + effect + " dr " + dur + " dot " + Text(dot));
	}

	// filter_effects
	void OnFilterEffects()
	{
		int curIdx = loopIteration;
		string curElement = GetToken(EFFECT_ELEMENTS, curIdx);
		if (DamageTakenOf(EFFECT_TARGET, curElement) == 0.0f)
			EFFECT_ELEMENTS = TokenSet(EFFECT_ELEMENTS, curIdx, "x");
	}

	// filter_effects2
	void OnFilterEffects2()
	{
		float curIdx = CAXE_EFFECT_COUNT;
		string curElement = GetToken(EFFECT_ELEMENTS, int(curIdx));
		if (curElement == "x")
		{
			EFFECT_LIST = TokenRemove(EFFECT_LIST, int(curIdx));
			EFFECT_ELEMENTS = TokenRemove(EFFECT_ELEMENTS, int(curIdx));
			EFFECT_DURATIONS = TokenRemove(EFFECT_DURATIONS, int(curIdx));
			EFFECT_SKILLS = TokenRemove(EFFECT_SKILLS, int(curIdx));
			LegacyCommand("token.del", "EFFECT_DOTS");
		}
		else
		{
			CAXE_EFFECT_COUNT += 1.0f;
		}
	}

	// update_cl
	void OnUpdateCl()
	{
		if (MY_CL_IDX == "MY_CL_IDX")
		{
			ClientEvent("new", ENT_OWNER, "items/axes_c_cl", IndexOf(ENT_OWNER));
			MY_CL_IDX = LastClientScriptId();
		}
		ClientEvent("update", ENT_OWNER, MY_CL_IDX, "update_caxe_sprite", CAXE_ELEMENT);
	}

	// remove_cl
	void OnRemoveCl()
	{
		if (MY_CL_IDX == "MY_CL_IDX")
			return;
		ClientEvent("update", ENT_OWNER, MY_CL_IDX, "end_fx");
		MY_CL_IDX = "MY_CL_IDX";
	}

	// game_+attack2
	void OnGamePressAttack2()
	{
		bool exitSub = false;

		if (Truthy(Eval("game.item.attacking")))
			return;
		if (!CanAttack(ENT_OWNER))
			return;

		if (!(GameTime() > NEXT_ELEMENT_BLAST))
			return;
		NEXT_ELEMENT_BLAST = GameTime() + 1.0f;

		if (ManaOf(ENT_OWNER) < MP_ELEMENT_BLAST)
		{
			string msg = "Chaos Axe: Not enough mana for elemental chaos. (" + MP_ELEMENT_BLAST + ")";
			PlayerMessageDark(ENT_OWNER, msg);
			exitSub = true;
		}

		if (!CAXE_SKILLED)
		{
			PlayerMessageDark(ENT_OWNER, "Chaos Axe: Insufficient magical talent for elemental chaos. (All Magic 10)");
			exitSub = true;
		}

		if (exitSub)
			return;

		GiveMana(ENT_OWNER, -MP_ELEMENT_BLAST);

		PlayItemViewAnim(ENT_ME, 9);
		PlayOwnerAnim("critical", "PLAYERANIM_PREPARE", "squatwalk1");

		// playsound game.sound.item 10 magic/temple.wav //different sfx, handel in clfx
		CallEventDelayed(0.1f, "do_chaos1");
	}

	// do_chaos1
	void OnDoChaos1()
	{
		Vector3 fxOrg = OriginOf(ENT_OWNER);
		fxOrg.z += -34.0f;
		if (Truthy(GetProp(ENT_OWNER, "ducking")))
			fxOrg.z += 24.0f;
		ClientEvent("new", "all", "effects/sfx_prism_blast", fxOrg, ECHAOS_AOE, CAXE_ELEMENT);
		CallEventDelayed(0.1f, "do_chaos2");
	}

	// do_chaos2
	void OnDoChaos2()
	{
		float dmg = Float(CAXE_EFFECT_DOT) * 3.0f;
		DoDamageEx(OriginOf(ENT_OWNER), ECHAOS_AOE, dmg, 0, ENT_OWNER, ENT_ME, "axehandling", CAXE_ELEMENT, "dmgevent:*chaos");
		CallEventDelayed(0.5f, "update_cl");
	}

	// chaos_dodamage
	void OnChaosDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		bool doPush = false;
		if (!hit)
			return;

		// callevent choose_dot PARAM2 1
		OnApplyDot(target);

		if (RelationshipOf(target, ENT_OWNER) != "enemy")
			return;

		if (IsPlayer(target) && GAME_PVP == 0)
			return;

		float targHp = HealthOf(target);
		float maxRepelHp = MaxHealthOf(ENT_OWNER) * 4.0f;
		if (targHp < maxRepelHp)
			doPush = true;
		if (!doPush)
			return;
		Vector3 targOrg = OriginOf(target);
		Vector3 ownerOrg = OriginOf(ENT_OWNER);
		float targAng = AnglesTo(ownerOrg, targOrg);
		SetVelocity(target, RelativeVelocity(Vector3(0, targAng, 0), Vector3(0, 1000, 0)));
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("3dmflagry.spr");
		Precache("weapons/p_weapons4.mdl");
		Precache("viewmodels/v_2haxesgreat.mdl");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "apply_dot") { OnApplyDot(EntityParam(params, 0)); return true; }
		if (name == "bweapon_effect_remove") { OnBweaponEffectRemove(Param(params, 0)); return true; }
		if (name == "caxe_check_skill") { OnCaxeCheckSkill(); return true; }
		if (name == "chaos_dodamage") { OnChaosDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5)); return true; }
		if (name == "choose_dot") { OnChooseDot(Param(params, 0), Param(params, 1)); return true; }
		if (name == "do_chaos1") { OnDoChaos1(); return true; }
		if (name == "do_chaos2") { OnDoChaos2(); return true; }
		if (name == "element_loop") { OnElementLoop(); return true; }
		if (name == "filter_effects") { OnFilterEffects(); return true; }
		if (name == "filter_effects2") { OnFilterEffects2(); return true; }
		if (name == "game_+attack2") { OnGamePressAttack2(); return true; }
		if (name == "game_deploy") { OnGameDeploy(); return true; }
		if (name == "melee_damaged_other") { Return(OnMeleeDamagedOther(EntityParam(params, 0), Float(Param(params, 1)), Param(params, 2), Param(params, 3))); return true; }
		if (name == "remove_cl") { OnRemoveCl(); return true; }
		if (name == "special_01_damaged_other") { Return(OnSpecial01DamagedOther(EntityParam(params, 0), Float(Param(params, 1)), Param(params, 2), Param(params, 3))); return true; }
		if (name == "special_02_damaged_other") { OnSpecial02DamagedOther(EntityParam(params, 0), Float(Param(params, 1)), Param(params, 2), Param(params, 3)); return true; }
		if (name == "update_cl") { OnUpdateCl(); return true; }
		if (name == "weapon_spawn") { OnWeaponSpawn(); return true; }
		return AxesBaseTwohandedScript::DispatchEvent(name, params);
	}
}
