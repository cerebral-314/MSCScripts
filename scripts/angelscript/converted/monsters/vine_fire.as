#pragma context server

// Converted from monsters/vine_fire.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_stripped_ai.as"

[script "monsters/vine_fire"]
class VineFire : BaseStrippedAiScript
{
	// Constants
	string ANIM_ATTACK = "attack1";
	string ANIM_GROW = "raise";
	int DMG_ATK = 100;
	int DOT_ATK = 50;
	string SOUND_ATTACK1 = "tentacle/te_roar1.wav";
	string SOUND_ATTACK2 = "tentacle/te_roar1.wav";
	string SOUND_BURN = "ambience/burning1.wav";
	float FREQ_SOUND_BURN = 30.0f;

	// Variables (an unset .script variable reads as its own name)
	bool IMMUNE_VAMPIRE = false;
	float SKIN_CYCLE = 0.0f;
	bool VINE_SUSPEND = false;
	float NEXT_BURN_SOUND = 0.0f;
	bool SWING_ATTACK = false;
	bool PHLAMES_VINE = false;
	string MY_MASTER = "MY_MASTER";
	bool QUIET_DEATH = false;

	// Variables declared by included files, with the value they start with in this script
	VineFire()
	{
		NPC_GIVE_EXP = 200.0f;
		ANIM_IDLE = "idle";
		ATTACK_HITRANGE = 200.0f;
		SOUND_STRUCK1 = "debris/flesh1.wav";
		SOUND_STRUCK2 = "debris/flesh2.wav";
		SOUND_STRUCK3 = "debris/flesh3.wav";
		SOUND_PAIN1 = "tentacle/te_alert1.wav";
		SOUND_PAIN2 = "tentacle/te_alert2.wav";
		SOUND_DEATH = "tentacle/te_move2.wav";
	}

	// unnamed block (first think)
	void VineFire_FirstThink()
	{
		NPC_GIVE_EXP = 200.0f;
		ANIM_DEATH = "lower";
	}

	// unnamed block (timer)
	void VineFire_Timer()
	{
		CallEventDelayed(0.1f, "VineFire_Timer");

		if (!IsAlive(ENT_ME))
			return;
		if (QUIET_DEATH)
			return;
		SetProp(ENT_ME, "skin", SKIN_CYCLE);
		SKIN_CYCLE += 1.0f;
		if (SKIN_CYCLE > 7.0f)
			SKIN_CYCLE = 0.0f;

		if (VINE_SUSPEND)
			return;
		if (!IsAlive(ENT_ME))
			return;
		if (!(GameTime() > NEXT_BURN_SOUND))
			return;
		NEXT_BURN_SOUND = GameTime() + FREQ_SOUND_BURN;
		ServerPlaySound(2, 0, SOUND_BURN);
		ServerPlaySound(2, 5, SOUND_BURN);
	}

	// game_dodamage
	string VineFire_OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";
		if (!hit)
			return result;
		if (SWING_ATTACK)
		{
			ApplyEffect(target, "effects/dot_fire", 5.0f, self, DOT_ATK);
			AddVelocity(target, RelativeVelocity(Vector3(-200, -300, 110)));
		}
		SWING_ATTACK = false;
		return result;
	}

	// game_death
	void OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		BaseSelfAdjust_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_self_adjust
		DqMonsterExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // dq/externals/dq_monster_externals
		MonstersExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/externals
		BaseStrippedAi_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_stripped_ai
		if (QUIET_DEATH)
			return;
		PlayAnim("critical", ANIM_DEATH);
		ServerPlaySound(2, 0, SOUND_BURN);
		PlaySound(1, 10, SOUND_DEATH);
		ClearEffects();
	}

	// ext_summon_fade
	void OnExtSummonFade()
	{
		MonstersExternals_OnExtSummonFade(); // monsters/externals

		DebugPrint("ext_summon_fade " + Text(NPC_SUMMON) + " " + GetVar("G_NPC_SUMMON_COUNT"));

		if (PHLAMES_VINE)
		{
			DebugPrint("Birds present - fading");
			SetAnimFrameRate(0);
			SetAnimMoveSpeed(0);
			SetGravity(0);
			SetVelocity(ENT_ME, Vector3(0, 0, 0));
			NPC_DID_DEATH = true;
			NPC_OVERRIDE_DEATH = true;
			SKEL_RESPAWN_TIMES = 99.0f;
			QUIET_DEATH = true;
			DoDamage(ENT_ME, "direct", 99999, 100, GetVar("GAME_MASTER"), "target");
			DeleteEntity(ENT_ME, "fade");
		}
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseStrippedAi_OnGameSpawn(playerRace, playerGender); // monsters/base_stripped_ai
		SetName("Lava Root");
		SetModel("monsters/deadlyvine.mdl");
		SetWidth(32);
		SetHeight(64);
		SetHealth(1000);
		SetRace("demon");
		SetBlood("none");
		SetNoPush(true);
		IMMUNE_VAMPIRE = true; // tiger blood
		SKIN_CYCLE = 0.0f;
		SetHearingSensitivity(11);
		SetIdleAnim(ANIM_GROW);
		SetMoveAnim(ANIM_GROW);
		PlayAnim("once", ANIM_IDLE);
		VINE_SUSPEND = true;
		SetProp(ENT_ME, "rendermode", 2);
		SetProp(ENT_ME, "renderamt", 0);
		SetSkillLevel(NPC_GIVE_EXP);
		SetDamageTaken("fire", 0);
		SetDamageTaken("cold", 2);
		CallEventDelayed(2.0f, "grow_in");
	}

	// grow_in
	void OnGrowIn()
	{
		SetProp(ENT_ME, "rendermode", 0);
		SetProp(ENT_ME, "renderamt", 255);

		SetIdleAnim(ANIM_IDLE);
		SetMoveAnim(ANIM_IDLE);
		VINE_SUSPEND = false;
		PlayAnim("critical", ANIM_GROW);
		PlaySound(1, 10, "tentacle/te_move1.wav");
	}

	// game_heardsound
	void OnGameHeardsound(string soundType = "", Vector3 origin = Vector3(), float dangerRadius = 0.0f)
	{
		if (!IsAlive(ENT_ME))
			return;
		if (VINE_SUSPEND)
			return;
		CBaseEntity@ heardId = EntityOf(ENT_LASTHEARD);
		// dbg game_heardsound $get(ent_lastheard,name) $get(HEARD_ID,range) $get(ent_me,relationship,HEARD_ID)
		if (RelationshipOf(ENT_ME, @heardId) != "enemy")
			return;
		NPCATK_TARGET = EntityId(heardId);
		SetMoveDest(NPCATK_TARGET, 9999);
		if (!(RangeTo(heardId) < ATTACK_HITRANGE))
			return;
		PlayAnim("once", ANIM_ATTACK);
	}

	// game_struck
	void OnGameStruck(float damage = 0.0f, string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		if (!IsAlive(ENT_ME))
			return;
		PlaySound(0, 5, SOUND_STRUCK1, SOUND_STRUCK2, SOUND_STRUCK3, SOUND_STRUCK1, SOUND_STRUCK2, SOUND_STRUCK3, SOUND_PAIN1, SOUND_PAIN2);

		if (VINE_SUSPEND)
			return;
		if (!(RangeTo(ENT_LASTSTRUCK) < ATTACK_HITRANGE))
			return;
		NPCATK_TARGET = EntityId(EntityOf(ENT_LASTSTRUCK));
		SetMoveDest(NPCATK_TARGET, 9999);
		PlayAnim("once", ANIM_ATTACK);
	}

	// frame_attack
	void OnFrameAttack()
	{
		SWING_ATTACK = true;
		PlayRandomSound(0, 10, SOUND_ATTACK1, SOUND_ATTACK2);
		DoDamage(NPCATK_TARGET, ATTACK_HITRANGE, DMG_ATK, "100%", "pierce");
	}

	string OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "") { return VineFire_OnGameDodamage(hit, target, start, end, damageType, damageText); } // game_dodamage

	// phlames_vine
	void OnPhlamesVine()
	{
		bool autoRemove = false;

		PHLAMES_VINE = true;
		MY_MASTER = EntityId(FindByName("phlame_wiz"));

		// don't spawn if phlames is in bird form, or eagles are in air (case I get stuck in em)
		if (Truthy(ScriptVarOf(MY_MASTER, "AM_TRANSFORMED")))
			autoRemove = true;
		if (Float(GetVar("G_FLAMES_EAGLES")) > 0.0f)
			autoRemove = true;

		DebugPrint("set phlames_vine " + NameOf(MY_MASTER) + " " + ScriptVarOf(MY_MASTER, "AM_TRANSFORMED"));

		if (!autoRemove)
			return;
		SetProp(ENT_ME, "rendermode", 5);
		SetProp(ENT_ME, "renderamt", 0);
		QUIET_DEATH = true;
		OnNpcSuicide();
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/deadlyvine.mdl");
		Precache("ambience/burning1.wav");
		CallEventDelayed(0.1f, "VineFire_Timer");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		VineFire_FirstThink();
		MonstersExternals_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "ext_summon_fade") { OnExtSummonFade(); return true; }
		if (name == "frame_attack") { OnFrameAttack(); return true; }
		if (name == "game_death") { OnGameDeath(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_dodamage") { Return(OnGameDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5))); return true; }
		if (name == "game_heardsound") { OnGameHeardsound(Param(params, 0), Vec(Param(params, 1)), Float(Param(params, 2))); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "game_struck") { OnGameStruck(Float(Param(params, 0)), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "grow_in") { OnGrowIn(); return true; }
		if (name == "phlames_vine") { OnPhlamesVine(); return true; }
		if (name == "VineFire_Timer") { VineFire_Timer(); return true; }
		return BaseStrippedAiScript::DispatchEvent(name, params);
	}
}
