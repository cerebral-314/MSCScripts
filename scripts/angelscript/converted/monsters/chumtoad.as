#pragma context server

// Converted from monsters/chumtoad.script by msc_transpiler.
// Chumtoad by greatguys1
// This doens't follow the original concept of it from hl1 what-so-ever.
// The idea is to have it like "zerg" where they're most effective in numbers, having damage scale higher the more it attacks, and even more when more are attacking the same target.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_monster_new.as"
#include "converted/monsters/base_monster_explode.as"
#include "converted/monsters/base_damage_stack.as"

[script "monsters/chumtoad"]
class Chumtoad : BaseMonsterNewScript, BaseMonsterExplode, BaseDamageStack
{
	// Constants
	string ATTACK_HITCHANCE = "80";
	int FLEE_HEALTH = 0;
	string FLEE_CHANCE = "0";
	int EXPLOSION_DAMAGE = 65;
	string ANIM_CHARGE = "idle2";
	string ANIM_SUICIDE = "flinch1";
	int LONG_ATTACK = 35;
	int SHORT_ATTACK = 15;
	float MONSTER_HEALTH = 0.0f;
	string GIB_BURSTER_SCRIPT = "effects/sfx_gib_burst";
	int GIB_BURSTER_FORCE = 200;
	string EXPLOSION_SFX = "effects/sfx_sprite";
	string EXPLOSION_SPRITE = "oculus/exp_green.spr";
	string EXPLOSION_SFX_SOUND = "monsters/tube/Tube_ExplodingDeath.wav";
	string IDLE_SOUND1 = "monsters/ogre_welp/bc_idle2.wav";
	string IDLE_SOUND2 = "monsters/ogre_welp/bc_idle3.wav";
	string IDLE_SOUND3 = "monsters/ogre_welp/bc_idle4.wav";
	string DEATH_SOUND1 = "monsters/bat/pain1.wav";
	string DEATH_SOUND2 = "monsters/bat/pain2.wav";
	string DEATH_SOUND3 = "monsters/beetle/idle.wav2";
	string DEATH_SOUND4 = "monsters/beetle/idle3.wav";
	string PAIN_SOUND1 = "monsters/ogre_welp/bc_pain1.wav";
	string PAIN_SOUND2 = "monsters/ogre_welp/bc_pain2.wav";
	string PAIN_SOUND3 = "monsters/ogre_welp/bc_pain3.wav";
	string HIT_SOUNDS = "monsters/tube/TubeCritter_Hit1.wav;monsters/tube/TuberCritter_Hit2.wav;monsters/tube/TubeCritter_Hit3.wav";
	int PITCH_MIN = 30;
	int PITCH_MAX = 200;
	float SUICIDE_THRESHOLD = 0.7f;
	int SUICIDE_DISTANCE = 100;
	int BLINK_FREQ = 5;
	float BLINK_DUR = 0.2f;
	int BLINK_MAX = 2;
	int IDLE_NOISE_FREQ = 5;

	// Variables (an unset .script variable reads as its own name)
	string ANIM_ATTACK = "ANIM_ATTACK";
	bool CANT_FLEE = false;
	int ANIM_IDLE3_CHANCE = 0;
	string SUICIDE_CHANCE = "SUICIDE_CHANCE";
	bool SUICIDING = false;
	bool TRIED_SUICIDE = false;
	float BLINK_STEP = 0.0f;
	int BLINK_CYCLE = 0;
	bool HACKING_ATK_DIST = false;
	bool DO_IDLE_NOISES = false;
	int SOUND_CHANNEL = 0;

	// Variables declared by included files, with the value they start with in this script
	Chumtoad()
	{
		ANIM_RUN = "hop_1";
		ANIM_WALK = "hop_1";
		ANIM_IDLE = "idle";
	}

	// unnamed block (first think)
	void Chumtoad_FirstThink()
	{
		// Settings for base monster new
		ANIM_RUN = "hop_1";
		ANIM_WALK = "hop_1";
		ANIM_IDLE = "idle";
		ANIM_ATTACK = "flinch2";

		NPC_NO_ATTACK = false;

		ATTACK_MOVERANGE = 10.0f;
		ATTACK_RANGE = 50.0f;
		ATTACK_HITRANGE = 70.0f;

		CANT_FLEE = true;
		CAN_RETALIATE = "1";
		CAN_FLINCH = "0";
		ANIM_IDLE3_CHANCE = 5; // % chance to use the idle3 animation, slower but more damage

		SUICIDE_CHANCE = "5"; // % chance
		SUICIDING = false;
		TRIED_SUICIDE = false;
		BLINK_STEP = 0.0f;
		BLINK_CYCLE = 1; // 1 for up, -1 for down

		HACKING_ATK_DIST = false;

		DO_IDLE_NOISES = true;

		NPC_GIVE_EXP = 200.0f;
	}

	// game_damaged
	string Chumtoad_OnGameDamaged(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float accuracyRoll = 0.0f, CBaseEntity@ inflictor = null, string skill = "")
	{
		string result = "";

		float hp = HealthOf(ENT_ME);

		if (hp <= MONSTER_HEALTH * SUICIDE_THRESHOLD && !TRIED_SUICIDE)
		{
			TRIED_SUICIDE = true;

			if (RandomInt(1, 100) <= Float(SUICIDE_CHANCE))
				OnDoSuicideCharge();
		}

		PlayRandomSound(SOUND_CHANNEL, 10, PAIN_SOUND1, PAIN_SOUND2, PAIN_SOUND3);
		return result;
	}

	// game_damaged_other
	// PARAM1=target_hit PARAM2=dmg PARAM3=dmg_type
	string Chumtoad_OnGameDamagedOther(CBaseEntity@ target = null, float damage = 0.0f, string damageType = "", string damageEvent = "")
	{
		string result = "";

		DebugPrint("chumtoad-game_damaged_other " + damageEvent);

		if (HACKING_ATK_DIST) // Unfortunately, I don't think this will have effect on the damage stacker without adding another flag. I already have too many. If it missed here, it likely added a stack. Hopefully shouldn't be too detrimental
		{
			Vector3 hackStart = OriginOf(ENT_ME);
			Vector3 hackEnd = OriginOf(target);

			float hackHitrange = ATTACK_HITRANGE + Divide(WidthOf(target), 2.0f); // Unfortunately need to hack hitrange because of varying enemies width.

			if (IsPlayer(target)) // Hack in extra distance with a player because their origin is in the middle of the ent while others are at their feet.
				hackHitrange += Divide(HeightOf(target), 2.0f);

			if (Distance(hackStart, hackEnd) >= hackHitrange)
				result = AppendResult(result, "0");
			else if (Truthy(LegacyFunction("get_traceline", hackStart, hackEnd, "worldonly")))
				result = AppendResult(result, "0");

			HACKING_ATK_DIST = false;
		}
		return result;
	}

	// game_death
	void OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		DqMonsterExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // dq/externals/dq_monster_externals
		MonstersExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/externals
		BaseSelfAdjust_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_self_adjust
		BaseNpc_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseMonsterShared_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared

		PlayRandomSound(SOUND_CHANNEL, 10, DEATH_SOUND1, DEATH_SOUND2, DEATH_SOUND3, DEATH_SOUND4);
	}

	// game_damaged_other
	string OnGameDamagedOther(CBaseEntity@ target = null, float damage = 0.0f, string damageType = "", string damageEvent = "")
	{
		string result = "";
		result = AppendResult(result, MonstersExternals_OnGameDamagedOther(target, damage, damageType, damageEvent));
		result = AppendResult(result, BaseAntiStuck_OnGameDamagedOther(target, damage, damageType, damageEvent));
		result = AppendResult(result, BaseMonsterShared_OnGameDamagedOther(target, damage, damageType, damageEvent));
		result = AppendResult(result, BaseDamageStack_OnGameDamagedOther(target, damage, damageType, damageEvent));
		result = AppendResult(result, Chumtoad_OnGameDamagedOther(target, damage, damageType, damageEvent));
		return result;
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseNpcAttackNew_OnNpcSpawn(npc); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck

		SetName("Chumtoad");
		SetRace("evil");
		SetHealth(300);
		SetModel("monsters/chumtoad.mdl");
		SetWidth(20);
		SetHeight(8);
		SetMoveAnim(ANIM_RUN);
		SetIdleAnim(ANIM_IDLE);
		SetBlood("green");
		SetRoam(false);

		PlayAnim("once", ANIM_IDLE);
		SOUND_CHANNEL = Int(GetVar("CHAN_VOICE"));

		CallEventDelayed(BLINK_FREQ, "do_blinking");
		CallEventDelayed(IDLE_NOISE_FREQ, "play_idle");
	}

	// cycle_up
	void OnCycleUp(string reason = "")
	{
		BaseNpcAttackNew_OnCycleUp(reason); // monsters/base_npc_attack_new

		DO_IDLE_NOISES = false;
	}

	// cycle_down
	void OnCycleDown()
	{
		BaseNpcAttackNew_OnCycleDown(); // monsters/base_npc_attack_new
		BaseMonsterShared_OnCycleDown(); // monsters/base_monster_shared
		BaseMonsterShared_OnCycleDown_2(); // monsters/base_monster_shared

		DO_IDLE_NOISES = true;
	}

	// npc_selectattack
	void OnNpcSelectattack()
	{
		BaseAntiStuck_OnNpcSelectattack(); // monsters/base_anti_stuck
		BaseMonsterShared_OnNpcSelectattack(); // monsters/base_monster_shared

		if (RandomInt(0, 100) <= ANIM_IDLE3_CHANCE)
			ANIM_ATTACK = "idle3";
		else
			ANIM_ATTACK = "flinch2";
	}

	// game_damaged - Return a damage multiplier to scale the damage
	string OnGameDamaged(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float accuracyRoll = 0.0f, CBaseEntity@ inflictor = null, string skill = "")
	{
		string result = "";
		result = AppendResult(result, BaseAntiStuck_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, BaseMonsterShared_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, BaseMonsterShared_OnGameDamaged_2(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, Chumtoad_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		return result;
	}

	// do_explode
	void OnDoExplode(string value = "")
	{
		BaseMonsterExplode_OnDoExplode(value); // monsters/base_monster_explode

		Vector3 vec = OriginOf(ENT_ME) + Vector3(0, 0, 30);

		string col = LegacyFunction("clcol", 0, 0, 0);
		string str = "0;3;255;add;" + col + ";20;10";

		ClientEvent("new", "all", EXPLOSION_SFX, vec, EXPLOSION_SPRITE, str, 0.5f);

		// <origin> <model_name;model_name> <submodel;submodel> <render_props> <amt> <force> <duration>
		// render props format: fadeout:0|1;scale;renderamt;rendermode
		ClientEvent("new", "all", GIB_BURSTER_SCRIPT, vec, "agibs.mdl", "0;1;2;3", "1;0.5;255;normal", 4, GIB_BURSTER_FORCE, 5);
		PlaySound(0, 10, EXPLOSION_SFX_SOUND);
	}

	// beam_dodamage
	// PARAM1=hit:0|1 PARAM2=ent_hit PARAM3=(start) PARAM4=(end) PARAM5=DmgType PARAM6=DmgAmt
	void OnBeamDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		BaseMonsterExplode_OnBeamDodamage(hit, target, start, end, damageType, damageText); // monsters/base_monster_explode

		if (hit) // Hack for explosion to do stack damage. Really getting tired of ""hacking"" all this. This script is gonna turn out a mess.
		{
			CBaseEntity@ targetValue = target;

			if (RelationshipOf(targetValue, ENT_ME) == "enemy")
			{
				string passParam = damageText;
				OnDoStack(targetValue, passParam);
			}
		}
	}

	// dmgstk_dodamage
	// PARAM1=hit:0|1 PARAM2=ent_hit PARAM3=(start) PARAM4=(end) PARAM5=DmgType PARAM6=DmgAmt
	void OnDmgstkDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		BaseDamageStack_OnDmgstkDodamage(hit, target, start, end, damageType, damageText); // monsters/base_damage_stack

		// Thanks Thothie for most of this event
		if (hit) // I hit
		{
			CBaseEntity@ targetValue = target;

			HACKING_ATK_DIST = true;

			float mult = Float(ScriptFlag(targetValue, STACK_FLAG_NAME, "name_value"));
			mult -= 0.1f; // Upon the first attack, the get scriptflag will always return 1.1, 'cuz the system added it already. I did a 1.0 attack though. Compensating here.
			float pitch = Ratio(Divide(mult, STACK_MULT_MAX), PITCH_MIN, PITCH_MAX); // The math gets a number between 0-1 depending on how much it stacked already.

			PlaySound(SOUND_CHANNEL, 10, GetRandomToken(HIT_SOUNDS), 0.8f, pitch);
		}
	}

	// game_precache
	void OnGamePrecache()
	{
	}

	// play_idle
	void OnPlayIdle()
	{
		if (DO_IDLE_NOISES)
			PlayRandomSound(SOUND_CHANNEL, 10, IDLE_SOUND1, IDLE_SOUND2, IDLE_SOUND3);

		CallEventDelayed(IDLE_NOISE_FREQ, "play_idle");
	}

	// do_blinking
	void OnDoBlinking()
	{
		string props = GetProp(ENT_ME, "renderprops");
		int skin = Int(GetToken(props, 4));

		BLINK_STEP = BLINK_STEP + BLINK_CYCLE;

		if (BLINK_STEP >= BLINK_MAX)
			BLINK_CYCLE = -1;
		else if (BLINK_STEP <= 0.0f)
			BLINK_CYCLE = 1;

		if (skin < 3) // In case a mapper changes the skin
			SetProp(ENT_ME, "skin", BLINK_STEP);

		if (BLINK_STEP == 0.0f)
			CallEventDelayed(BLINK_FREQ, "do_blinking");
		else
			CallEventDelayed(BLINK_DUR, "do_blinking");
	}

	// do_suicide_charge
	void OnDoSuicideCharge()
	{
		OnNpcatkSuspendAi();
		PlayAnim("critical", ANIM_CHARGE);
		SUICIDING = true;
	}

	// finish_charge
	// Called from the model
	void OnFinishCharge()
	{
		PlayAnim("critical", ANIM_SUICIDE);
	}

	// finish_suicide
	// Called from the model
	void OnFinishSuicide()
	{
		SetProp(ENT_ME, "rendermode", 5);
		SetProp(ENT_ME, "renderamt", 0);

		OnDoExplode();
		OnNpcSuicide();
	}

	// attack_1
	// Called from the model
	void OnAttack12()
	{
		OnDoAttack(Text(LONG_ATTACK));
	}

	// attack_2
	// Called from the model
	void OnAttack22()
	{
		OnDoAttack(Text(SHORT_ATTACK));
	}

	// do_attack
	// PARAM1 = damage
	void OnDoAttack(string damage = "")
	{
		DoDamageEx(NPCATK_TARGET, "direct", damage, ATTACK_HITCHANCE, ENT_ME, ENT_ME, "none", "pierce", "dmgevent:dmgstk");
	}

	// dmgstk_damaged_other
	void OnDmgstkDamagedOther(string entity = "", string value = "", string value2 = "")
	{
		DebugPrint("dmgstk_damaged_other " + entity + " " + value + " " + value2);
	}

	// ext_suicide_chance
	// PARAM1 = new suicide chance //Intended to be called via the map.
	void OnExtSuicideChance(string suicideChance = "")
	{
		SUICIDE_CHANCE = suicideChance;
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files

	// game_dodamage
	string OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";
		result = AppendResult(result, BaseNpcAttackNew_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BaseAntiStuck_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BaseMonsterShared_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BaseDamageStack_OnGameDodamage(hit, target, start, end, damageType, damageText));
		return result;
	}

	void OnBlinkDur() {} // BLINK_DUR
	void OnBlinkFreq() {} // BLINK_FREQ
	void OnIdleNoiseFreq() {} // IDLE_NOISE_FREQ

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/chumtoad.mdl");
		Precache("oculus/exp_green.spr");
		Precache("agibs.mdl");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		Chumtoad_FirstThink();
		BaseNpc_FirstThink();
		MonstersExternals_FirstThink();
		BaseNpcAttackNew_FirstThink();
		BaseMonsterShared_FirstThink();
		BaseDamageStack_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "attack_1") { OnAttack12(); return true; }
		if (name == "attack_2") { OnAttack22(); return true; }
		if (name == "beam_dodamage") { OnBeamDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5)); return true; }
		if (name == "cycle_down") { OnCycleDown(); return true; }
		if (name == "cycle_up") { OnCycleUp(Param(params, 0)); return true; }
		if (name == "dmgstk_damaged_other") { OnDmgstkDamagedOther(Param(params, 0), Param(params, 1), Param(params, 2)); return true; }
		if (name == "dmgstk_dodamage") { OnDmgstkDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5)); return true; }
		if (name == "do_attack") { OnDoAttack(Param(params, 0)); return true; }
		if (name == "do_blinking") { OnDoBlinking(); return true; }
		if (name == "do_explode") { OnDoExplode(Param(params, 0)); return true; }
		if (name == "do_suicide_charge") { OnDoSuicideCharge(); return true; }
		if (name == "ext_suicide_chance") { OnExtSuicideChance(Param(params, 0)); return true; }
		if (name == "finish_charge") { OnFinishCharge(); return true; }
		if (name == "finish_suicide") { OnFinishSuicide(); return true; }
		if (name == "game_damaged") { Return(OnGameDamaged(EntityParam(params, 0), Float(Param(params, 1)), Param(params, 2), Float(Param(params, 3)), EntityParam(params, 4), Param(params, 5))); return true; }
		if (name == "game_damaged_other") { Return(OnGameDamagedOther(EntityParam(params, 0), Float(Param(params, 1)), Param(params, 2), Param(params, 3))); return true; }
		if (name == "game_death") { OnGameDeath(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_precache") { OnGamePrecache(); return true; }
		if (name == "npc_selectattack") { OnNpcSelectattack(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "play_idle") { OnPlayIdle(); return true; }
		return BaseMonsterExplode_DispatchEvent(name, params)
			|| BaseDamageStack_DispatchEvent(name, params)
			|| BaseMonsterNewScript::DispatchEvent(name, params);
	}
}
