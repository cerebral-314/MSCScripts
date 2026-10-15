#pragma context server

// Converted from items/magic_hand_div_glow.script by msc_transpiler.
// Thothie - Divination can't be raised, switching raise skill to raw SC
// - The original formula, in addition to being unused in output, tis a bit funky, hopefully this works.

#include "runtime/ScriptEntity.as"
#include "converted/items/magic_hand_base.as"

[script "items/magic_hand_div_glow"]
class MagicHandDivGlow : MagicHandBaseScript
{
	// Constants
	string MELEE_RANGE = "1024";
	string MELEE_HITCHANCE = "100%";
	float MELEE_ATK_DURATION = 0.5f;
	string SPELL_DAMAGE_TYPE = "generic";
	int SPELL_MPDRAIN = 1;
	string SPELL_STAT = "none";
	int EFFECT_MAXDURATION = 240;
	float EFFECT_MINDURATION = 60.0f;
	float EFFECT_DURATION_STAT = 0.0f;
	float EFFECT_DURATION_FORMULA = 0.0f;
	int LIGHTRNG_MAX = 384;
	int LIGHTRNG_MIN = 96;
	string LIGHTRNG_SKILL = "l.skillratio";
	float LIGHTRNG_FORMULA = 0.0f;
	bool EFFECT_STACK = true;
	float FREQ_INC_LIGHT = 0.2f;

	// Variables (an unset .script variable reads as its own name)
	int SPELL_SKILL_REQUIRED = 1;
	float CAST_DELAY = 0.0f;
	bool CAST_STARTED = false;
	float LIGHT_POWER = 0.0f;
	float MAX_LIGHT_POWER = 0.0f;
	float NEXT_LIGHT_UPDATE = 0.0f;

	// Variables declared by included files, with the value they start with in this script
	MagicHandDivGlow()
	{
		SPELL_PREPARE_TIME = 0.5f;
		SPELL_ENERGYDRAIN = 5;
	}

	// unnamed block (first think)
	void MagicHandDivGlow_FirstThink()
	{
		SPELL_SKILL_REQUIRED = 1;
		EFFECT_DURATION_STAT = Divide(EFFECT_DURATION_STAT, 100.0f);
	}

	// game_deploy
	void OnGameDeploy()
	{
		BaseItemExtras_OnGameDeploy(); // items/base_item_extras
		BaseItemExtras_OnGameDeploy_2(); // items/base_item_extras
		BaseItemExtras_OnGameDeploy_3(); // items/base_item_extras
		BaseItem_OnGameDeploy(); // items/base_item
		MagicHandBase_OnGameDeploy(); // items/magic_hand_base
		CAST_DELAY = GameTime() + 0.2f;

		if (Truthy(ScriptVarOf(ENT_OWNER, "PLR_HAS_GLOW")) && !CAST_STARTED)
		{
			OwnerMessage("Glow: Extinguishing spell...");
			CallExternal(GetVar("GAME_MASTER"), "gm_light_update", "remove", IndexOf(ENT_OWNER)); // $vec(COLOR_RATIO_R,COLOR_RATIO_G,COLOR_RATIO_B) RAD_RATIO "magic_hand_div_glow"
			CallExternal(ENT_OWNER, "ext_set_glow", 0);
			PlaySound(0, 5, "magic/elecidlepop.wav");
			OnGlowDone("remove_glow");
		}
	}

	// spell_spawn
	void OnSpellSpawn()
	{
		SetName("Glow");
		SetDescription("Create artificial light");
	}

	// game_attack1_down
	void OnGameAttack1Down()
	{
		bool exitSub = false;
		int colorRatioR = 0;
		float colorRatioG = 0.0f;
		float colorRatioB = 0.0f;
		float radRatio = 0.0f;
		if (!(GameTime() > CAST_DELAY))
			return;

		// if ( $get(ent_owner,scriptvar,'PLR_HAS_GLOW') )
		// {
		// if !CAST_STARTED
		// playermessage Glow: Extinguishing spell...
		// callexternal GAME_MASTER gm_light_update remove $get(ent_owner,index) //$vec(COLOR_RATIO_R,COLOR_RATIO_G,COLOR_RATIO_B) RAD_RATIO "magic_hand_div_glow"
		// callexternal ent_owner ext_set_glow 0
		// playsound 0 5 magic/elecidlepop.wav
		// callevent glow_done remove_glow
		// local EXIT_SUB 1
		// }
		// if !EXIT_SUB
		if (Truthy(ScriptVarOf(ENT_OWNER, "DEMON_BLOOD")))
		{
			OwnerMessage("You cannot use divine magic while under the influence of Demon Blood!");
			OnGlowDone("demon_blood");
			exitSub = true;
		}
		if (exitSub)
			return;

		if (Truthy(ScriptVarOf(ENT_OWNER, "PLR_GLOW_BLOCK")))
		{
			OwnerMessage("A dark force is blocking the glow spell!");
			if (CAST_STARTED)
			{
				// case someone gets clever and starts charging before crossing the brush
				CallExternal(GetVar("GAME_MASTER"), "gm_light_update", "remove", IndexOf(ENT_OWNER)); // $vec(COLOR_RATIO_R,COLOR_RATIO_G,COLOR_RATIO_B) RAD_RATIO "magic_hand_div_glow"
				CallExternal(ENT_OWNER, "ext_set_glow", 0);
				PlaySound(0, 5, "magic/elecidlepop.wav");
				OnGlowDone("dark_force");
			}
			OnSpellEnd();
			exitSub = true;
		}
		if (exitSub)
			return;

		if (!CAST_STARTED)
		{
			CAST_STARTED = true;
			LIGHT_POWER = 0.05f;
			MAX_LIGHT_POWER = SkillOf(ENT_OWNER, "spellcasting") * 0.1f;
			if (MAX_LIGHT_POWER > 1.0f)
				MAX_LIGHT_POWER = 1.0f;
			PlaySound(0, 5, "magic/elecidlepop.wav");
			ServerPlaySound(2, 5, "ambience/labdrone2.wav", 0.8f, 50);
			colorRatioR = 255;
			colorRatioG = Ratio(LIGHT_POWER, 0, 255);
			colorRatioB = Ratio(LIGHT_POWER, 128, 255);
			radRatio = Ratio(LIGHT_POWER, 50, 255);
			OwnerMessage("Glow: Charging...");
			CallExternal(GetVar("GAME_MASTER"), "gm_light_update", "new", IndexOf(ENT_OWNER), Vector3(colorRatioR, colorRatioG, colorRatioB), radRatio, "magic_hand_div_glow");
			NEXT_LIGHT_UPDATE = GameTime() + FREQ_INC_LIGHT;
			CallExternal(ENT_OWNER, "ext_set_glow", 1);
		}

		if (GameTime() > NEXT_LIGHT_UPDATE)
		{
			NEXT_LIGHT_UPDATE = GameTime() + FREQ_INC_LIGHT;
			LIGHT_POWER += 0.05f;
			if (LIGHT_POWER >= MAX_LIGHT_POWER)
				OnGlowDone("max_power");
			if (LIGHT_POWER < MAX_LIGHT_POWER)
			{
				float pitchRatio = Ratio(LIGHT_POWER, 50, 200);
				ServerPlaySound(2, 5, "ambience/labdrone2.wav", 0.8f, pitchRatio);

				DebugPrint("cur_power " + Text(LIGHT_POWER));

				colorRatioR = 100;
				colorRatioG = Ratio(LIGHT_POWER, 64, 100);
				colorRatioB = Ratio(LIGHT_POWER, 32, 100);
				radRatio = Ratio(LIGHT_POWER, 50, 400);

				CallExternal(GetVar("GAME_MASTER"), "gm_light_update", "update", IndexOf(ENT_OWNER), Vector3(colorRatioR, colorRatioG, colorRatioB), radRatio, "magic_hand_div_glow");
			}
		}
	}

	// game_-attack1
	void OnGameReleaseAttack1()
	{
		if (!CAST_STARTED)
			return;
		OnGlowDone("mouse_release");
	}

	// glow_done
	void OnGlowDone(string glowType = "")
	{
		DebugPrint("glow_done " + glowType);
		if (CAST_STARTED)
			ServerPlaySound(2, 0, "ambience/labdrone2.wav");
		if (glowType == "max_power")
		{
			OwnerMessage("Glow: Maximum charge reached.");
		}
		else if (CAST_STARTED)
		{
			string dispPower = "(";
			float lightPower = LIGHT_POWER * 100.0f;
			lightPower = int(lightPower);
			dispPower += Text(lightPower) + "%" + ")";

			OwnerMessage("Glow: Charge set " + dispPower);
		}
		DeleteMe();
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("viewmodels/v_martialarts.mdl");
		Precache("ambience/labdrone2.wav");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		MagicHandDivGlow_FirstThink();
		MagicHandBase_FirstThink();
		BaseItem_FirstThink();
		BaseItemExtras_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "game_-attack1") { OnGameReleaseAttack1(); return true; }
		if (name == "game_attack1_down") { OnGameAttack1Down(); return true; }
		if (name == "game_deploy") { OnGameDeploy(); return true; }
		if (name == "glow_done") { OnGlowDone(Param(params, 0)); return true; }
		if (name == "spell_spawn") { OnSpellSpawn(); return true; }
		return MagicHandBaseScript::DispatchEvent(name, params);
	}
}
