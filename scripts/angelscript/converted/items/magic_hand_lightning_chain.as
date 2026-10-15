#pragma context server

// Converted from items/magic_hand_lightning_chain.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/items/magic_hand_base.as"

[script "items/magic_hand_lightning_chain"]
class MagicHandLightningChain : MagicHandBaseScript
{
	// Constants
	string MELEE_RANGE = "2000";
	string MELEE_HITCHANCE = "100%";
	float MELEE_ATK_DURATION = 1.0f;
	string SPELL_DAMAGE_TYPE = "lightning";
	int SPELL_MPDRAIN = 5;
	string SPELL_STAT = "spellcasting.lightning";
	string SOUND_ZAP1 = "debris/beamstart14.wav";
	string SOUND_ZAP2 = "debris/beamstart15.wav";
	string SOUND_ZAP3 = "debris/zap1.wav";
	float SCRIPT_SFX_DURATION = 0.5f;
	string LIGHT_COLOR = "LIGHT_COLOR";
	int SCAN_RANGE = 400;

	// Variables (an unset .script variable reads as its own name)
	int SPELL_SKILL_REQUIRED = 1;
	string CLIENT_SCRIPT_IDX = "CLIENT_SCRIPT_IDX";
	int GAME_PVP = 0;
	string TARGET_LIST = "TARGET_LIST";
	string IDX_LIST = "IDX_LIST";

	// Variables declared by included files, with the value they start with in this script
	MagicHandLightningChain()
	{
		SOUND_SHOOT = "weather/Storm_exclamation.wav";
		MELEE_TYPE = "strike-land";
		MELEE_NOAUTOAIM = true;
		MELEE_DMG_DELAY = 0.4f;
		SPELL_ENERGYDRAIN = 10;
		SCRIPT_SFX_PREP = "items/magic_hand_lightning_weak_cl";
	}

	// unnamed block (first think)
	void MagicHandLightningChain_FirstThink()
	{
		SPELL_SKILL_REQUIRED = 1;
	}

	// spell_end
	void OnSpellEnd()
	{
		MagicHandBase_OnSpellEnd(); // items/magic_hand_base

		ClientEvent("remove", "all", CLIENT_SCRIPT_IDX); // remove script from clients
	}

	// spell_casted
	// PARAM1: "none"/"npc"/"world"   2: Attack end Position   3: Entity hit (if any)
	void OnSpellCasted(string hitType = "", Vector3 endPosition = Vector3(), CBaseEntity@ target = null)
	{
		MagicHandBase_OnSpellCasted(hitType, endPosition, target); // items/magic_hand_base
		bool exitIf = false;
		CBaseEntity@ firstTarget = null;

		Vector3 scanOrigin = OriginOf(ENT_OWNER);
		if (IsAlive(target))
		{
			// if first target is player, and not PVP, do not use him as first target
			if (RelationshipOf(target, ENT_OWNER) == "enemy" && IsPlayer(target) && GAME_PVP == 0)
				exitIf = true;
			if (!exitIf)
			{
				@firstTarget = target; // if I hit a target, use it as first jump
				scanOrigin = OriginOf(target); // and use it as the start scan point
			}
		}

		// otherwise I'll just zap everything withing SCAN_RANGE of the caster
		// get targets from owner since $get_tsphere does not work from inside an item script:
		CallExternal(ENT_OWNER, "ext_sphere_token", "enemy", SCAN_RANGE, scanOrigin);
		TARGET_LIST = ScriptVarOf(ENT_OWNER, "PLR_SCAN_TOKEN");

		// make sure first beam goes to targeted ent, if any:
		if (IsAlive(firstTarget))
		{
			string tempList = TARGET_LIST;
			TARGET_LIST = EntityId(firstTarget);
			TARGET_LIST += ";" + tempList;
		}

		// if no targets, stop here
		if (TARGET_LIST == "none")
			return;

		// send damage in a single AOE burst:
		float dmgLightning = SkillOf(ENT_OWNER, "spellcasting.lightning") * 0.75f;
		DoDamageEx(scanOrigin, SCAN_RANGE, dmgLightning, 0, ENT_OWNER, ENT_OWNER, "spellcasting.lightning", "lightning");

		// convert target list to client indexes
		IDX_LIST = ""; // init idx list
		int count = GetTokenCount(TARGET_LIST);
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnConvertTargetsToIdxs();
		}

		// send target indexes to clients and draw beams accordingly
		ClientEvent("update", "all", CLIENT_SCRIPT_IDX, "draw_beams", IDX_LIST);

		// zappy sound
		PlayRandomSound(0, 10, SOUND_ZAP1, SOUND_ZAP2, SOUND_ZAP3);
	}

	// spell_spawn
	void OnSpellSpawn()
	{
		SetName("Chain Lightning");
		SetDescription("Fires lightning bolts at multiple targets");
	}

	// spell_deploy
	// have to use this becaue magic_hand_base overrides [game_deploy]
	void OnSpellDeploy()
	{
		// setup client script, send owner index
		ClientEvent("new", "all", "items/magic_hand_lightning_chain_cl", IndexOf(ENT_OWNER));
		CLIENT_SCRIPT_IDX = LastClientScriptId(); // store client script index for later removal

		GAME_PVP = (IsPvp() ? 1 : 0); // for player vs. player targeting
	}

	// convert_targets_to_idxs
	void OnConvertTargetsToIdxs()
	{
		string curTarget = GetToken(TARGET_LIST, loopIteration);
		IDX_LIST = TokenAdd(IDX_LIST, Text(IndexOf(curTarget)));
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		MagicHandLightningChain_FirstThink();
		MagicHandBase_FirstThink();
		BaseItem_FirstThink();
		BaseItemExtras_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "convert_targets_to_idxs") { OnConvertTargetsToIdxs(); return true; }
		if (name == "spell_casted") { OnSpellCasted(Param(params, 0), Vec(Param(params, 1)), EntityParam(params, 2)); return true; }
		if (name == "spell_deploy") { OnSpellDeploy(); return true; }
		if (name == "spell_end") { OnSpellEnd(); return true; }
		if (name == "spell_spawn") { OnSpellSpawn(); return true; }
		return MagicHandBaseScript::DispatchEvent(name, params);
	}
}
