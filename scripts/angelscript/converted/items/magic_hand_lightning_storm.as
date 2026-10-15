#pragma context server

// Converted from items/magic_hand_lightning_storm.script by msc_transpiler.
// Thothie-lightning storm

#include "runtime/ScriptEntity.as"
#include "converted/items/magic_hand_base.as"

[script "items/magic_hand_lightning_storm"]
class MagicHandLightningStorm : MagicHandBaseScript
{
	// Constants
	string MELEE_RANGE = "1000";
	string MELEE_HITCHANCE = "100";
	float MELEE_ATK_DURATION = 1.0f;
	string SPELL_DAMAGE_TYPE = "lightning";
	int SPELL_MPDRAIN = 30;
	string SPELL_STAT = "spellcasting.lightning";
	string SOUND_LOOP = "magic/shock_noloop.wav";
	string SOUND_SHOOT1 = "debris/zap1.wav";
	string SOUND_SHOOT2 = "debris/zap2.wav";
	string SOUND_SHOOT3 = "debris/zap3.wav";
	string SCRIPT_SFX_CAST = "effects/sfx_lightning";

	// Variables (an unset .script variable reads as its own name)
	int SPELL_SKILL_REQUIRED = 10;
	bool DRAIN_COUNT = false;
	float EFFECT_DMG = 0.0f;
	CBaseEntity@ STORM_ID = null;
	bool STORM_UP = false;

	// Variables declared by included files, with the value they start with in this script
	MagicHandLightningStorm()
	{
		MELEE_TYPE = "strike-land";
		MELEE_NOAUTOAIM = true;
		SCRIPT_SFX_PREP = "items/magic_hand_lightning_weak_cl";
		SOUND_SHOOT = "debris/beamstart14.wav";
	}

	// unnamed block (first think)
	void MagicHandLightningStorm_FirstThink()
	{
		SPELL_SKILL_REQUIRED = 10;

		DRAIN_COUNT = false;
	}

	// game_precache
	void MagicHandLightningStorm_OnGamePrecache()
	{
		PrecacheFile(SCRIPT_SFX_CAST);
	}

	// game_precache
	void OnGamePrecache()
	{
		MagicHandLightningStorm_OnGamePrecache();
		MagicHandBase_OnGamePrecache(); // items/magic_hand_base
	}

	// spell_casted
	// PARAM1: "none"/"npc"/"world"   2: Attack end Position   3: Entity hit (if any)
	void OnSpellCasted(string hitType = "", Vector3 endPosition = Vector3(), CBaseEntity@ target = null)
	{
		MagicHandBase_OnSpellCasted(hitType, endPosition, target); // items/magic_hand_base

		DRAIN_COUNT = false;

		if (STORM_UP)
		{
			Effect("beam", "point", "lgtning.spr", 200, OriginOf(ENT_OWNER), endPosition, Vector3(255, 255, 0), 64, 10, 0.5f);
			CallExternal(STORM_ID, "sustain_storm", endPosition);
		}
		else
		{
			// no storm up
			CBaseEntity@ myOwner = EntityOf(ENT_OWNER);

			EFFECT_DMG = SkillOf(myOwner, "spellcasting.lightning") * 1.5f;

			CreateNpc("monsters/summon/summon_lightning_storm", endPosition, self, AnglesOf(myOwner).y, EFFECT_DMG, 15, "spellcasting.lightning");
			@STORM_ID = EntityOf(ENT_LASTCREATED);
			STORM_UP = true;
		}

		LegacyCommand("svplayrandomsound", 0, 8, SOUND_SHOOT1, SOUND_SHOOT2, SOUND_SHOOT3);

		CallExternal(STORM_ID, "sustain_storm", endPosition);
	}

	// spell_spawn
	void OnSpellSpawn()
	{
		SetName("Lightning Storm");
		SetDescription("An electrical storm");
	}

	// storm_ended
	void OnStormEnded()
	{
		STORM_UP = false;
	}

	// 9.8
	void On_98()
	{
		PlaySound(0, 5, SOUND_LOOP);
	}

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
		Precache("debris/zap1.wav");
		Precache("debris/zap2.wav");
		Precache("debris/zap3.wav");
		Precache("debris/beamstart14.wav");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		MagicHandLightningStorm_FirstThink();
		MagicHandBase_FirstThink();
		BaseItem_FirstThink();
		BaseItemExtras_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "9.8") { On_98(); return true; }
		if (name == "fake_precache") { OnFakePrecache(); return true; }
		if (name == "game_precache") { OnGamePrecache(); return true; }
		if (name == "spell_casted") { OnSpellCasted(Param(params, 0), Vec(Param(params, 1)), EntityParam(params, 2)); return true; }
		if (name == "spell_spawn") { OnSpellSpawn(); return true; }
		if (name == "storm_ended") { OnStormEnded(); return true; }
		return MagicHandBaseScript::DispatchEvent(name, params);
	}
}
