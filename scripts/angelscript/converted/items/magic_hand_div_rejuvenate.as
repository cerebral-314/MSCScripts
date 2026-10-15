#pragma context server

// Converted from items/magic_hand_div_rejuvenate.script by msc_transpiler.
// Thothie - Increasing heal formula and mana use in an attempt to cut down on 'rejuv lag'

#include "runtime/ScriptEntity.as"
#include "converted/items/magic_hand_base.as"

[script "items/magic_hand_div_rejuvenate"]
class MagicHandDivRejuvenate : MagicHandBaseScript
{
	// Constants
	string MELEE_RANGE = "384";
	string MELEE_HITCHANCE = "100%";
	float MELEE_ATK_DURATION = 1.0f;
	string SPELL_DAMAGE_TYPE = "divination";
	int SPELL_MPDRAIN = 5;
	string SPELL_STAT = "spellcasting.divination";
	int EFFECT_MAXDURATION = 20;
	float EFFECT_MINDURATION = 10.0f;
	float EFFECT_DURATION_STAT = 0.0f;
	float EFFECT_DURATION_FORMULA = 0.0f;
	int HEAL_MAX = 75;
	int HEAL_MIN = 30;
	float HEAL_SKILL = 0.0f;
	float LOOP_SOUND = 0.0f;
	string LOOP_CHANNEL = "const.sound.item";

	// Variables (an unset .script variable reads as its own name)
	int SPELL_SKILL_REQUIRED = 5;
	float FAN_LOOP = 0.0f;
	bool BITCH_SLAPPED = false;
	float REGEN_DELAY = 0.0f;

	// Variables declared by included files, with the value they start with in this script
	MagicHandDivRejuvenate()
	{
		SOUND_SHOOT = "magic/heal_strike.wav";
		SPELL_PREPARE_TIME = 2.0f;
		SPELL_ENERGYDRAIN = 10;
	}

	// unnamed block (first think)
	void MagicHandDivRejuvenate_FirstThink()
	{
		SPELL_SKILL_REQUIRED = 5;
	}

	// game_takedamage
	// //PARAM1=attacker  PARAM2=inflictor? PARAM3=dmg PARAM4=dmg_type - use return to alter incoming damage
	string MagicHandDivRejuvenate_OnGameTakedamage(CBaseEntity@ attacker = null, CBaseEntity@ inflictor = null, float damage = 0.0f, string damageType = "")
	{
		string result = "";

		if (damageType == "target") // dont cancel heal for target tracking damage
			return result;
		if (!(damage > 0.01f))
			return result;
		BITCH_SLAPPED = true;
		OnSpellEnd();
		return result;
	}

	// spell_casted
	// PARAM1: "none"/"npc"/"world"   2: Attack end Position   3: Entity hit (if any)
	void OnSpellCasted(string hitType = "", Vector3 endPosition = Vector3(), CBaseEntity@ target = null)
	{
		MagicHandBase_OnSpellCasted(hitType, endPosition, target); // items/magic_hand_base
		bool exitSub = false;
		bool addBonus = false;
		bool gaveDmgPoints = false;

		int demonOn = Int(ScriptVarOf(ENT_OWNER, "DEMON_BLOOD"));
		if (demonOn != 0)
		{
			OwnerMessage("You cannot use divine magic while under the influence of Demon Blood!");
			OnSpellEnd();
			exitSub = true;
		}
		if (exitSub)
			return;

		CBaseEntity@ caster = EntityOf(ENT_OWNER);
		CBaseEntity@ spellTarget = EntityOf(ENT_OWNER);

		float healAmt = SkillOf(ENT_OWNER, "spellcasting.divination") + HEAL_MIN;

		if (hitType == "npc" && RelationshipOf(ENT_OWNER, @target) == "ally")
			@spellTarget = target;
		if (IsPlayer(target))
			@spellTarget = target;
		if (Truthy(ScriptVarOf(target, "IAM_PLAYER")))
			@spellTarget = target;

		if (caster !is spellTarget)
		{
			float tenPercent = MaxHealthOf(spellTarget) * 0.1f;
			healAmt += tenPercent;
			healAmt = int(healAmt); // $int() now so rounding doesn't confuse when reporting damage points vs healed

			// give damage point if other player or critical npc
			if (IsPlayer(spellTarget))
				addBonus = true;
			if (Truthy(ScriptVarOf(spellTarget, "NPC_CRITICAL")))
				addBonus = true;
			if (addBonus && HealthOf(spellTarget) < MaxHealthOf(spellTarget))
			{
				CallExternal(ENT_OWNER, "add_dmg_points", healAmt * 5.0f);
				gaveDmgPoints = true;
			}
		}
		else
		{
			healAmt *= 0.5f;
		}

		// //dbg HealAmt Final HEAL_AMT
		ServerPlaySound(Int(Eval("game.sound.voice")), 10, SOUND_SHOOT);

		OnHealTarget(spellTarget, Text(healAmt), Text(gaveDmgPoints));
		if (spellTarget !is caster)
			CallExternal("SPELL_TARGET", "display_health");
	}

	// spell_spawn
	void OnSpellSpawn()
	{
		SetName("Rejuvenation");
		SetDescription("Replenish yours or an ally's health.");

		FAN_LOOP = 0.0f;

		OnAddDelay();
		OnPassiveRegen();
	}

	// enable_passive_regen_check
	void OnEnablePassiveRegenCheck()
	{
		CallEventDelayed(1.0f, "enable_passive_regen_check");

		if (FAN_LOOP != 0.0f)
			return;

		if (REGEN_DELAY <= GameTime()) // Check if spell is ready to be used
		{
			FAN_LOOP = 1.0f; // Enable passive regen
		}
	}

	// heal_target
	// <target> <amt> <gave_dmgpts:0|1>
	void OnHealTarget(CBaseEntity@ target = null, string amount = "", string gaveDamagePoints = "")
	{
		bool healingOther = false;
		bool healed = false;

		CBaseEntity@ casterId = EntityOf(ENT_OWNER);

		float maxHealth = MaxHealthOf(target);
		float curHealth = HealthOf(target);

		if (target !is casterId)
			healingOther = true;

		if (curHealth < maxHealth)
		{
			GiveHealth(@target, amount);
			healed = true;
			if (healingOther)
			{
				PlayerMessageGreen(casterId, "You heal " + NameOf(target) + " for " + int(Float(amount)) + " hp");
				PlayerMessageGreen(target, NameOf(casterId) + " heals you for " + int(Float(amount)) + " hp");
				if (Truthy(gaveDamagePoints) && PlayerCount() > 1)
					PlayerMessageGreen(casterId, "(Credited " + int(Float(amount) * 5.0f) + " damage points.)");
			}
			else
			{
				PlayerMessageGreen(casterId, "You heal yourself for " + int(Float(amount)) + " hp");
			}
		}
		else if (healingOther)
			PlayerMessageGreen(casterId, NameOf(target) + " is at maximum health");
		else
			PlayerMessageGreen(casterId, "You are at maximum health");

		if (!healed)
			return;

		Effect("glow", @target, Vector3(0, 255, 0), 256, 1, 1);
	}

	// passive_regen
	void OnPassiveRegen()
	{
		CallEventDelayed(0.5f, "passive_regen");

		if (!(FAN_LOOP >= 1.0f))
			return;

		FAN_LOOP += 1.0f;
		if (FAN_LOOP == 3.0f)
		{
			PlaySound(Int(LOOP_CHANNEL), 10, LOOP_SOUND);
			Effect("glow", ENT_OWNER, Vector3(0, 255, 0), 64, 0.5f, 0.5f);
			FAN_LOOP = 1.0f;
		}

		float myMaxHealth = MaxHealthOf(ENT_OWNER);
		float myCurHealth = HealthOf(ENT_OWNER);

		float mySkill = SkillOf(ENT_OWNER, "spellcasting.divination");
		float myPassiveRate = mySkill * 0.1f + 4.0f;
		string myPassiveRateText = Text(myPassiveRate);

		if (myCurHealth < myMaxHealth)
			GiveHealth(myPassiveRateText);

		CallExternal(EntityOf(ENT_OWNER), "display_health");
	}

	string OnGameTakedamage(CBaseEntity@ attacker = null, CBaseEntity@ inflictor = null, float damage = 0.0f, string damageType = "") { return MagicHandDivRejuvenate_OnGameTakedamage(attacker, inflictor, damage, damageType); } // game_takedamage

	// spell_end
	void OnSpellEnd()
	{
		if (BITCH_SLAPPED)
			OwnerMessage("You cannot rejuvenate while being attacked!");
		if (!BITCH_SLAPPED)
			OwnerMessage("The spell's duration ends.");
		OnEndSpell();
	}

	// fake_precache
	void OnFakePrecache()
	{
		ServerPlaySound(0, 0, SOUND_SHOOT);
	}

	// end_spell
	void OnEndSpell()
	{
		// remove any cl effects here
		DeleteMe();
	}

	// add_delay
	void OnAddDelay()
	{
		REGEN_DELAY = GameTime() + SPELL_PREPARE_TIME;
		OnEnablePassiveRegenCheck();
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("viewmodels/v_martialarts.mdl");
		Precache("magic/heal_strike.wav");
		CallEventDelayed(1.0f, "enable_passive_regen_check");
		CallEventDelayed(0.5f, "passive_regen");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		MagicHandDivRejuvenate_FirstThink();
		MagicHandBase_FirstThink();
		BaseItem_FirstThink();
		BaseItemExtras_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "add_delay") { OnAddDelay(); return true; }
		if (name == "enable_passive_regen_check") { OnEnablePassiveRegenCheck(); return true; }
		if (name == "end_spell") { OnEndSpell(); return true; }
		if (name == "fake_precache") { OnFakePrecache(); return true; }
		if (name == "game_takedamage") { Return(OnGameTakedamage(EntityParam(params, 0), EntityParam(params, 1), Float(Param(params, 2)), Param(params, 3))); return true; }
		if (name == "heal_target") { OnHealTarget(EntityParam(params, 0), Param(params, 1), Param(params, 2)); return true; }
		if (name == "passive_regen") { OnPassiveRegen(); return true; }
		if (name == "spell_casted") { OnSpellCasted(Param(params, 0), Vec(Param(params, 1)), EntityParam(params, 2)); return true; }
		if (name == "spell_end") { OnSpellEnd(); return true; }
		if (name == "spell_spawn") { OnSpellSpawn(); return true; }
		return MagicHandBaseScript::DispatchEvent(name, params);
	}
}
