#pragma context server

// Converted from items/smallarms_frozentongueonflagpole.script by msc_transpiler.
// MiB
// Frozen Tongue on a Flag Pole from flame lick
// GET IT? FLAME LICK -> THIS?! LOLOLOL. I'll stop now.
// redux by Age

#include "runtime/ScriptEntity.as"
#include "converted/items/smallarms_base.as"

[script "items/smallarms_frozentongueonflagpole"]
class SmallarmsFrozentongueonflagpole : SmallarmsBaseScript
{
	// Constants
	string BASE_LEVEL_REQ = "23";
	bool CUSTOM_REGISTER_SECONDARY = true;
	string ANIM_ATTACK3 = "35";
	int ANIM_ATTACK4 = 36;
	int ANIM_ATTACK5 = 37;
	string MELEE_ALIGN_BASE = "3.6,-6";
	string MELEE_ALIGN_TIP = "0,0";
	bool CUSTOM_REGISTER_CHARGE1 = true;

	// Variables (an unset .script variable reads as its own name)
	string TARG_LIST = "TARG_LIST";
	float BURST_DAMAGE = 0.0f;
	float NEXT_LITCH_BURST = 0.0f;
	float TARGETS_AFFECTED = 0.0f;

	// Variables declared by included files, with the value they start with in this script
	SmallarmsFrozentongueonflagpole()
	{
		MODEL_VIEW = "viewmodels/v_smallarms.mdl";
		MODEL_VIEW_IDX = 6;
		ANIM_LIFT1 = 31;
		ANIM_IDLE1 = "32";
		ANIM_WIELD = 31;
		ANIM_UNWIELD = 38;
		ANIM_WIELDEDIDLE1 = 32;
		ANIM_ATTACK1 = "33";
		ANIM_ATTACK2 = "34";
		MODEL_HANDS = "weapons/p_weapons3.mdl";
		MODEL_WORLD = "weapons/p_weapons3.mdl";
		MELEE_DMG_TYPE = "cold";
		MELEE_RANGE = "50";
		MELEE_DMG_DELAY = 0.2f;
		MELEE_ATK_DURATION = 0.9f;
		MELEE_ENERGY = 0.6f;
		MELEE_DMG = 275;
		MELEE_DMG_RANGE = 20;
		MELEE_ACCURACY = "100%";
		MELEE_PARRY_CHANCE = "25%";
		SOUND_HITWALL1 = "debris/glass1.wav";
		SOUND_HITWALL2 = "debris/glass2.wav";
		MODEL_BODY_OFS = "17";
		ANIM_PREFIX = "standard";
	}

	// game_dodamage
	// 1: Attack Hit (1/0)  2: Entity Attack hit  3:  Start Position  4:  End Position
	string SmallarmsFrozentongueonflagpole_OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";

		if (!hit)
			return result;
		if (RandomInt(1, 5) != 1)
			return result;
		if (BITEM_UNDERSKILLED) // Not underskilled to use the weapon
			return result;

		// okay this is hard to read but, it's taking 66% of Smallarms, adding it to 34% of Ice, and multiplying that by 2 to create a linear scaling ratio that has varying contribution from each considered skill
		float freezeDamage = (SkillOf(ENT_OWNER, "smallarms") * 0.66f + SkillOf(ENT_OWNER, "spellcasting.ice") * 0.34f) * 2.0f;
		freezeDamage += Random(1, Divide(SkillOf(ENT_OWNER, "spellcasting.ice"), 4.0f));
		if (freezeDamage < 5.0f)
			freezeDamage = 5.0f;
		PlaySound(0, 10, "magic/frost_reverse.wav", 0.8f, 50);
		ApplyEffect(target, "effects/dot_cold", 3, @EntityOf(ENT_OWNER), freezeDamage, "smallarms");
		return result;
	}

	// weapon_spawn
	// Called whenever the dagger spawns
	// Setup the basic info specific to this weapon
	void OnWeaponSpawn()
	{
		BaseMelee_OnWeaponSpawn(); // items/base_melee
		SmallarmsBase_OnWeaponSpawn(); // items/smallarms_base

		SetName("Litch Tongue");
		SetDescription("A dagger carved from the bones of an ancient ice mage.");
		SetWeight(3);
		SetValue(2500);
		SetHudSprite("hand", "128");
		SetHudSprite("trade", "128");
	}

	// register_secondary
	void OnRegisterSecondary()
	{
		SmallarmsBase_OnRegisterSecondary(); // items/smallarms_base

		SetLocal("reg.attack.type", "strike-land");
		SetLocal("reg.attack.keys", "-attack1");
		SetLocal("reg.attack.dmg", 550);
		SetLocal("reg.attack.range", MELEE_RANGE);
		SetLocal("reg.attack.dmg.range", 1);
		SetLocal("reg.attack.dmg.type", "cold");
		SetLocal("reg.attack.energydrain", 0);
		SetLocal("reg.attack.stat", "smallarms");
		SetLocal("reg.attack.hitchance", MELEE_ACCURACY);
		SetLocal("reg.attack.priority", 2);
		SetLocal("reg.attack.delay.strike", 0.25f);
		SetLocal("reg.attack.delay.end", 1.3f);
		SetLocal("reg.attack.ofs.startpos", "MELEE_STARTPOS");
		SetLocal("reg.attack.ofs.aimang", "MELEE_AIMANGLE");
		SetLocal("reg.attack.callback", "special_02");
		SetLocal("reg.attack.noise", 1000);
		SetLocal("reg.attack.chargeamt", "100%");
		SetLocal("reg.attack.reqskill", 25);
		SetLocal("reg.attack.dmg.ignore", 0);
		SetLocal("reg.attack.mpdrain", 0);

		RegisterAttack();
	}

	string OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "") { return SmallarmsFrozentongueonflagpole_OnGameDodamage(hit, target, start, end, damageType, damageText); } // game_dodamage

	// special_02_start
	void OnSpecial02Start()
	{
		PlayViewAnim(Int(ANIM_ATTACK1));
		Effect("glow", ENT_ME, Vector3(0, 75, 255), 128, 5.0f, 5.0f);
	}

	// special_02_strike
	void OnSpecial02Strike(string hitType = "", Vector3 endPos = Vector3(), CBaseEntity@ hitEntity = null, bool hit = false)
	{
		int count;

		// createnpc monsters/summon/ice_burst $relpos(0,0,-32) $get(ent_owner,id) ICE_BURST_DAMAGE smallarms
		// check time since last "litch burst" to create a "cooldown"
		// cleaner cooldown code
		if (GameTime() <= NEXT_LITCH_BURST)
			PlayerMessageDark(ENT_OWNER, "Special attack is on cooldown");
		if (!(GameTime() > NEXT_LITCH_BURST))
			return;

		// scan area and populate token list, then assign token list to variable
		CallExternal(ENT_OWNER, "ext_sphere_token_x", "enemy", 256);
		TARG_LIST = ScriptVarOf(ENT_OWNER, "PLR_SCAN_TOKEN");

		// check if assigned token list is empty
		if (TARG_LIST == "none")
		{
			PlayerMessageDark(ENT_OWNER, "No targets in range, cooldown reset");
			PlaySound(0, 10, "magic/frost_pulse.wav", 0.8f, RandomInt(20, 60));
		}
		else
		{
			// release attack if assigned token list is not empty (note the if-else relationship with above)
			PlaySound(0, 10, "magic/frost_reverse.wav");
			ClientEvent("new", "all", "monsters/summon/ice_burst_cl", IndexOf(ENT_OWNER));

			// check which hand this weapon is in, and display appropriate sprite (without this, dual wielding will cause the "cooldown" sprite to be overwritten constantly)
			if (Float(GetProp(ENT_ME, "hand_index")) == 1.0f)
				AddStatusIcon(ENT_OWNER, "hud/status/alpha_specialcooldownright", "litchcooldownright", 20);
			else
				AddStatusIcon(ENT_OWNER, "hud/status/alpha_specialcooldownleft", "litchcooldownleft", 20);

			// scale special attack damage dynamically both smallarms and ice
			BURST_DAMAGE = (SkillOf(ENT_OWNER, "smallarms") * 0.60f + SkillOf(ENT_OWNER, "spellcasting.ice") * 0.40f) * 2.5f;

			NEXT_LITCH_BURST = GameTime();
			// set special attack cooldown here vvv -- REMEMBER TO CHANGE HUD ICON TIMER AS WELL
			NEXT_LITCH_BURST += 20.0f;
			TARG_LIST = LegacyFunction("sort_entlist", TARG_LIST, "range", OriginOf(ENT_OWNER));
			TARGETS_AFFECTED = 0.0f;
			count = GetTokenCount(TARG_LIST);
			for (int i = 0; i < count; i++)
			{
				loopIteration = i;
				OnBurstAffectTargets();
				if (breakLoop)
				{
					breakLoop = false;
					break;
				}
			}
		}
	}

	// burst_affect_targets
	// can't use specific quantity for this eventloop because the enemy scan might pick up "Deadly" players and count them toward the loop iterations
	// instead, use $get_token_amt on TARG_LIST and add a counter to the eventloop that will breakloop when exceeded
	void OnBurstAffectTargets()
	{
		string curTarg = GetToken(TARG_LIST, loopIteration);

		if (!IsPvp() && IsPlayer(curTarg))
			return;
		// should only iterate TARGETS_AFFECTED if no "Deadly" player is detected, and stop looping after 3 iterations - basically calleventloop 3 but more complicated
		TARGETS_AFFECTED += 1.0f;
		if (TARGETS_AFFECTED == 3.0f)
			breakLoop = true;

		ApplyEffect(curTarg, "effects/dot_cold", 7, @EntityOf(ENT_OWNER), BURST_DAMAGE, "smallarms");
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("weapons/p_weapons3.mdl");
		Precache("viewmodels/v_smallarms.mdl");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "burst_affect_targets") { OnBurstAffectTargets(); return true; }
		if (name == "game_dodamage") { Return(OnGameDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5))); return true; }
		if (name == "register_secondary") { OnRegisterSecondary(); return true; }
		if (name == "special_02_start") { OnSpecial02Start(); return true; }
		if (name == "special_02_strike") { OnSpecial02Strike(Param(params, 0), Vec(Param(params, 1)), EntityParam(params, 2), Truthy(Param(params, 3))); return true; }
		if (name == "weapon_spawn") { OnWeaponSpawn(); return true; }
		return SmallarmsBaseScript::DispatchEvent(name, params);
	}
}
