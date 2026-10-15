#pragma context server

// Converted from items/magic_hand_turn_undead.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/items/magic_hand_base.as"

[script "items/magic_hand_turn_undead"]
class MagicHandTurnUndead : MagicHandBaseScript
{
	// Constants
	string MELEE_RANGE = "500";
	string MELEE_HITCHANCE = "100%";
	float MELEE_ATK_DURATION = 1.5f;
	string SPELL_DAMAGE_TYPE = "holy";
	int SPELL_MPDRAIN = 2;
	string SPELL_STAT = "spellcasting.divination";
	string SCRIPT_SFX_CAST = "effects/sfx_lightning";
	float SCRIPT_SFX_DURATION = 0.5f;
	string LIGHT_COLOR = "LIGHT_COLOR";

	// Variables (an unset .script variable reads as its own name)
	int SPELL_SKILL_REQUIRED = 1;
	int TARGET_VALID = 0;
	CBaseEntity@ TARGET_NPC = null;
	float HOLY_DMG = 0.0f;

	// Variables declared by included files, with the value they start with in this script
	MagicHandTurnUndead()
	{
		SOUND_SHOOT = "fvox/hiss.wav";
		MELEE_TYPE = "holy";
		MELEE_NOAUTOAIM = true;
		MELEE_DMG_DELAY = 0.4f;
		SPELL_PREPARE_TIME = 2.0f;
		SPELL_ENERGYDRAIN = 10;
		SCRIPT_SFX_PREP = "items/magic_hand_lightning_weak_cl";
	}

	// unnamed block (first think)
	void MagicHandTurnUndead_FirstThink()
	{
		// -------------------------------------------------------
		SPELL_SKILL_REQUIRED = 1;
		PrecacheFile(SCRIPT_SFX_CAST);
	}

	// game_dodamage
	// 1: Attack Hit (1/0)  2: Entity Attack hit  3:  Start Position  4:  End Position
	string MagicHandTurnUndead_OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";

		if (!hit)
			return result;

		// //dbg Damge_OtherParm Par1 PARAM1 Par2 PARAM2 Par3 PARAM3 Par4 PARAM4
		TARGET_VALID = 1;
		@TARGET_NPC = target;
		if (DamageTakenOf(TARGET_NPC, "holy") == 0.0f)
			TARGET_VALID = 0;

		if (TARGET_VALID == 0 && (Exists(target) ? 1 : 0) == 1)
			OwnerMessage("Holy Light only affects the Undead and Unholy.");

		if (TARGET_VALID == 0)
			return result;

		// dbg valid target
		HOLY_DMG = SkillOf(ENT_OWNER, "spellcasting.divination") * 0.5f;

		// local TARGET_ORIGIN $get(TARGET_NPC,origin)
		// cleffect light new TARGET_ORIGIN 128 (255,255,0) 10
		CBaseEntity@ myOwner = EntityOf(ENT_OWNER);

		CallExternal(TARGET_NPC, "turn_undead", HOLY_DMG, @myOwner);
		return result;
	}

	// spell_casted
	// PARAM1: "none"/"npc"/"world"   2: Attack end Position   3: Entity hit (if any)
	void OnSpellCasted(string hitType = "", Vector3 endPosition = Vector3(), CBaseEntity@ target = null)
	{
		MagicHandBase_OnSpellCasted(hitType, endPosition, target); // items/magic_hand_base
		bool exitSub = false;

		int demonOn = Int(ScriptVarOf(ENT_OWNER, "DEMON_BLOOD"));
		if (demonOn != 0)
		{
			OwnerMessage("You cannot use divine magic while under the influence of Demon Blood!");
			OnSpellEnd();
			exitSub = true;
		}
		if (exitSub)
			return;

		if (TARGET_VALID == 0)
			return;
		ServerPlaySound(2, 5, SOUND_SHOOT);
		TARGET_VALID = 0;
	}

	// spell_spawn
	void OnSpellSpawn()
	{
		SetName("Rebuke Undead");
		SetDescription("Sets the wrath of the divine upon the Unholy");
	}

	string OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "") { return MagicHandTurnUndead_OnGameDodamage(hit, target, start, end, damageType, damageText); } // game_dodamage

	// fake_precache
	void OnFakePrecache()
	{
		ServerPlaySound(0, 0, SOUND_SHOOT);
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("viewmodels/v_martialarts.mdl");
		Precache("fvox/hiss.wav");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		MagicHandTurnUndead_FirstThink();
		MagicHandBase_FirstThink();
		BaseItem_FirstThink();
		BaseItemExtras_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "fake_precache") { OnFakePrecache(); return true; }
		if (name == "game_dodamage") { Return(OnGameDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5))); return true; }
		if (name == "spell_casted") { OnSpellCasted(Param(params, 0), Vec(Param(params, 1)), EntityParam(params, 2)); return true; }
		if (name == "spell_spawn") { OnSpellSpawn(); return true; }
		return MagicHandBaseScript::DispatchEvent(name, params);
	}
}
