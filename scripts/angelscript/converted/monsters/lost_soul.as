#pragma context server

// Converted from monsters/lost_soul.script by msc_transpiler.
// Flying munch on face skull in the spirit of dewm

#include "runtime/ScriptEntity.as"
#include "converted/monsters/eagle_base.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class LostSoul
{
	// Constants
	bool NO_DIVE = true;
	float DMG_ATTACK = 0.0f;
	string SOUND_WARCRY = "controller/con_pain3.wav";
	string SOUND_DEATH = "controller/con_die1.wav";
	string SOUND_ATTACK = "controller/con_pain2.wav";
	string SOUND_STRUCK = "debris/flesh2.wav";
	string SOUND_PAIN = "controller/con_pain1.wav";
	string SOUND_PAIN2 = "controller/con_die2.wav";
	string SOUND_VICTORY = "controller/con_die2.wav";
	int DMG_SPLODIE = 100;
	float DMG_POISON = 25.0f;

	// Variables (an unset .script variable reads as its own name)
	bool IS_UNHOLY = true;
	float MONSTER_HP = 300.0f;
	bool IMMUNE_VAMPIRE = false;
	float NPC_GIVE_EXP = 0.0f;
	string ANIM_IDLE = "ANIM_IDLE";
	string ANIM_ATTACK = "ANIM_ATTACK";
	string ANIM_DEATH = "ANIM_DEATH";
	string ANIM_WALK = "ANIM_WALK";
	string ANIM_RUN = "ANIM_RUN";
	float COUNT_ATK = 0.0f;
	string MY_OWNER = "MY_OWNER";
	bool AM_SUMMONED = false;
	float DEATH_TIME = 0.0f;
	bool AM_DEAD = false;
	bool DEATH_ATTACK = false;

	// unnamed block (first think)
	void LostSoul_FirstThink()
	{
		IS_UNHOLY = true;
		IMMUNE_VAMPIRE = true;
		NPC_GIVE_EXP = 100.0f;
		MONSTER_HP = 300.0f;
	}

	// unnamed block (first think)
	void LostSoul_FirstThink2()
	{
		// override anims
		ANIM_IDLE = "idle";
		ANIM_ATTACK = "attack";
		ANIM_DEATH = "idle";
		ANIM_WALK = "idle";
		ANIM_RUN = "idle";
	}

	// npc_spawn
	void LostSoul_OnNpcSpawn(string npc = "")
	{
		OnSkullSpawn();
	}

	// skull_spawn
	void LostSoul_OnSkullSpawn()
	{
		SetName("Lost Soul");
		SetRace("demon");
		if (Text(MONSTER_HP) == "MONSTER_HP")
			SetHealth(300);
		else
			SetHealth(MONSTER_HP);
		SetBlood("green");
		SetWidth(16);
		SetHeight(16);
		SetModel("monsters/skull.mdl");
		SetIdleAnim("idle");
		SetMoveAnim("idle");
		SetHearingSensitivity(11);
		SetRoam(true);
		SetFly(true);
		SetDamageTaken("poison", 0);
		SetDamageTaken("holy", 4);

		IMMUNE_VAMPIRE = true;
		COUNT_ATK = 0.0f;
	}

	// game_dynamically_created
	// <owner> <str> <duration>
	void LostSoul_OnGameDynamicallyCreated(string creatorValue1 = "", string creatorValue2 = "", string damage = "", string skill = "", string extraValue5 = "", string extraValue6 = "", float alwaysPush = 0.0f, string duration = "", string extraValue9 = "")
	{
		MY_OWNER = creatorValue1;
		SetRace(RaceOf(MY_OWNER));
		AM_SUMMONED = true;
		MONSTER_HP = 300.0f;

		SetMonsterClip(false);

		if (RaceOf(MY_OWNER) == "0")
			SetRace("demon");

		if (!creatorValue2.isEmpty())
		{
			SetDamageMultiplier(Float(creatorValue2));
			MONSTER_HP *= Float(creatorValue2);
		}

		SetHealth(MONSTER_HP);

		if (damage.isEmpty())
			return;
		CallEventOrDelay(damage, "self_destruct");
	}

	// self_destruct
	void LostSoul_OnSelfDestruct()
	{
		OnNpcSuicide();
	}

	// game_death
	void LostSoul_OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		OnSkullDeath();
	}

	// skull_death
	void LostSoul_OnSkullDeath()
	{
		DEATH_TIME = GameTime();
		AM_DEAD = true;
		DEATH_TIME += 0.2f;
		SetProp(ENT_ME, "rendermode", 5);
		SetProp(ENT_ME, "renderamt", 0);
		Vector3 splodePos = RelativePosition(Vector3(0, 0, 0));
		ClientEvent("new", "all", "effects/sfx_splodie", splodePos, Vector3(0, 255, 0));
		// if ( $get(ent_laststruck,range) < 64 )
		// {
		// addvelocity ent_laststruck $relvel(0,600,120)
		// applyeffect ent_laststruck effects/dot_poison 5.0 $get(ent_me,id) DMG_POISON
		// }
		DEATH_ATTACK = true;
		// dodamage SPLODE_POS 128 DMG_SPLODE 100% 0 reflective poison
		DoDamageEx(splodePos, 128, "DMG_SPLODE", 0, ENT_ME, ENT_ME, "none", "blunt");
	}

	// attack1
	void LostSoul_OnAttack1()
	{
		PlaySound(0, 5, SOUND_ATTACK);
		DoDamage(HUNT_LASTTARGET, ATTACK_HITRANGE, DMG_ATTACK, "90%", "slash");

		COUNT_ATK += 1.0f;

		if (COUNT_ATK > FLEE_COUNT)
		{
			COUNT_ATK = 0.0f;
			OnNpcatkSuspendAi("3.0");
			SetMoveDest(HUNT_LASTTARGET, 1000, "flee");
		}
	}

	// game_dodamage
	string LostSoul_OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";
		if (CUSTOM_DAMAGE)
			return result;

		if (DEATH_ATTACK)
		{
			if (GameTime() < DEATH_TIME && IsAlive(target) && RelationshipOf(target, ENT_ME) == "enemy") // delay so poison effect doesnt keep pushing player
			{
				Vector3 targetOrg = OriginOf(target);
				float targAng = AnglesTo(MyOrigin(), targetOrg);
				int newYaw = int(targAng);
				SetVelocity(target, RelativeVelocity(Vector3(0, newYaw, 0), Vector3(0, 1000, 0)));
				ApplyEffect(target, "effects/dot_poison", 5.0f, self, DMG_POISON);
			}
		}
		else if (hit && IsAlive(ENT_ME) && IsAlive(target))
			AddVelocity(target, RelativeVelocity(Vector3(20, 200, 10)));
		return result;
	}

	// unnamed block (timer)
	void LostSoul_Timer()
	{
		CallEventDelayed(Random(0.1f, 1), "LostSoul_Timer");
		// drift about
		if (NPCATK_TARGET != "unset")
			return;
		AddVelocity(ENT_ME, RelativePosition(Vector3(0, Random(0, 359), 0), Vector3(Random(-100, 100), 0, 0)));
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)

	// game_death
	void OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		DqMonsterExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // dq/externals/dq_monster_externals
		MonstersExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/externals
		BaseSelfAdjust_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_self_adjust
		BaseNpc_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseMonsterShared_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared
		EagleBase_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/eagle_base
		LostSoul_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4);
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck
		EagleBase_OnNpcSpawn(npc); // monsters/eagle_base
		LostSoul_OnNpcSpawn(npc);
	}

	// game_dodamage
	string OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";
		result = AppendResult(result, BaseAntiStuck_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BaseMonsterShared_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, EagleBase_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, LostSoul_OnGameDodamage(hit, target, start, end, damageType, damageText));
		return result;
	}

	void OnSkullSpawn() { LostSoul_OnSkullSpawn(); } // skull_spawn
	void OnGameDynamicallyCreated(string creatorValue1 = "", string creatorValue2 = "", string damage = "", string skill = "", string extraValue5 = "", string extraValue6 = "", float alwaysPush = 0.0f, string duration = "", string extraValue9 = "") { LostSoul_OnGameDynamicallyCreated(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); } // game_dynamically_created
	void OnSelfDestruct() { LostSoul_OnSelfDestruct(); } // self_destruct
	void OnSkullDeath() { LostSoul_OnSkullDeath(); } // skull_death
	void OnAttack1() { LostSoul_OnAttack1(); } // attack1
	void OnGoBoom() {} // GO_BOOM

	// This file's events and timers by their .script names
	bool LostSoul_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "attack1") { OnAttack1(); return true; }
		if (name == "game_death") { OnGameDeath(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_dodamage") { Return(OnGameDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5))); return true; }
		if (name == "game_dynamically_created") { OnGameDynamicallyCreated(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Float(Param(params, 6)), Param(params, 7), Param(params, 8)); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "self_destruct") { OnSelfDestruct(); return true; }
		if (name == "skull_death") { OnSkullDeath(); return true; }
		if (name == "skull_spawn") { OnSkullSpawn(); return true; }
		if (name == "LostSoul_Timer") { LostSoul_Timer(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "monsters/lost_soul"]
shared class LostSoulScript : EagleBaseScript, LostSoul
{
	// Variables every script that includes this file declares
	bool CUSTOM_DAMAGE = false;
	int DOT_COLD = 0;

	// Variables declared by included files, with the value they start with in this script
	LostSoulScript()
	{
		NO_DIVE = true;
		SOUND_WARCRY = "controller/con_pain3.wav";
		SOUND_DEATH = "controller/con_die1.wav";
		SOUND_ATTACK = "controller/con_pain2.wav";
		SOUND_PAIN = "controller/con_pain1.wav";
		SOUND_PAIN2 = "controller/con_die2.wav";
		SOUND_VICTORY = "controller/con_die2.wav";
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/eagle.mdl");
		Precache("monsters/skull.mdl");
		CallEventDelayed(0.5f, "EagleBase_Timer");
		CallEventDelayed(Float(Eval("$randf(0.1,1.0)")), "LostSoul_Timer");
		CallEventDelayed(Float(CYCLE_TIME), "hunting_mode_go");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		LostSoul_FirstThink();
		EagleBase_FirstThink();
		BaseFlyer_FirstThink();
		BaseNpcAttack_FirstThink();
		BaseNpc_FirstThink();
		MonstersExternals_FirstThink();
		BaseMonsterShared_FirstThink();
		LostSoul_FirstThink2();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return LostSoul_DispatchEvent(name, params)
			|| EagleBaseScript::DispatchEvent(name, params);
	}
}
