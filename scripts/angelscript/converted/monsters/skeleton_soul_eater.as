#pragma context server

// Converted from monsters/skeleton_soul_eater.script by msc_transpiler.
// Generic Calruin for maps that need a monster of similar power

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_monster.as"

[script "monsters/skeleton_soul_eater"]
class SkeletonSoulEater : BaseMonsterScript
{
	// Constants
	string ATTACK_DAMAGE = "30";
	string ATTACK_HITCHANCE = "85%";
	string SOUND_STRUCK1 = "controller/con_pain3.wav";
	string SOUND_STRUCK2 = "controller/con_pain3.wav";
	string SOUND_STRUCK3 = "none";
	string SOUND_PAIN = "zombie/zo_pain2.wav";
	string SOUND_ATTACK1 = "controller/con_attack1.wav";
	string SOUND_HEAL = "monsters/skeleton/calrian2.wav";
	string SOUND_ATTACK2 = "controller/con_attack2.wav";
	string SOUND_IDLE1 = "controller/con_attack3.wav";
	string SOUND_SPAWN = "monsters/skeleton/calrian2.wav";
	string SOUND_PUSH = "monsters/skeleton/calrain3.wav";

	// Variables (an unset .script variable reads as its own name)
	string MY_ENEMY = "enemy";
	string ANIM_ATTACK = "ANIM_ATTACK";
	bool LEGIT_MAP = false;
	float LAST_STOLE_HP = 0.0f;
	int DID_PUSH = 0;

	// Variables declared by included files, with the value they start with in this script
	SkeletonSoulEater()
	{
		ANIM_RUN = "walk";
		ANIM_WALK = "walk";
		SOUND_DEATH = "controller/con_die1.wav";
	}

	// unnamed block (first think)
	void SkeletonSoulEater_FirstThink()
	{
		ANIM_RUN = "walk";
		ANIM_WALK = "walk";
		ANIM_ATTACK = "attack1";
		ATTACK_RANGE = 150.0f;
		MOVE_RANGE = "125";
		ATTACK_HITRANGE = 175.0f;
		MY_ENEMY = "enemy"; // base_npc_attack - Premptive attack
		RETALIATE_CHANCE = "75%"; // base_npc_attack - Automatically switch targets to the last damaging player
		CAN_FLEE = "0"; // base_npc_attack - Whether I run away at low health
	}

	// game_dodamage
	// 1: Attack Hit (1/0)  2: Entity Attack hit  3:  Start Position  4:  End Position
	string SkeletonSoulEater_OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";

		if (!hit)
			return result;

		if (RandomInt(1, 30) == 1)
		{
			// push to cut down on shielders
			PlayAnim("critical", "attack2");
			SetVolume(10);
			PlaySound(2, 10, SOUND_PUSH);
			Vector3 myLoc = OriginOf(ENT_ME);
			Vector3 nmeLoc = OriginOf(ENT_LASTSTRUCKBYME);
			float nmeDistance = Distance(myLoc, nmeLoc);
			if (nmeDistance < ATTACK_HITRANGE)
				ApplyEffect(EntityOf(ENT_LASTSTRUCKBYME), "effects/effect_push", 3, RelativeVelocity(Vector3(0, 400, 400)), 0);
			DID_PUSH = 1;
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
		OnBmGoldSpew(25, "1", 50, 4, 8);
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck

		SetHealth(1500);
		// ov 359
		SetWidth(32);
		SetHeight(80);
		SetName("Soul Eater");
		SetRoam(true);
		SetHearingSensitivity(8);
		NPC_GIVE_EXP = 200.0f;
		SetRace("undead");
		SetModel("monsters/skeleton2.mdl");
		SetModelBody(1, 0);
		SetDamageTaken("all", 0.65f);
		SetDamageTaken("holy", 2);
		SetDamageTaken("fire", 0.25f);
		SetDamageTaken("cold", 0.25f);
		SetDamageTaken("stun", 0);
		SetIdleAnim("idle1");
		SetMoveAnim(ANIM_WALK);

		string mapName = MapName();
		LEGIT_MAP = false;

		LAST_STOLE_HP = 10.0f; // no soul stealing for first 10 atks
	}

	// game_dodamage
	string OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";
		result = AppendResult(result, BaseAntiStuck_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BaseMonsterShared_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, SkeletonSoulEater_OnGameDodamage(hit, target, start, end, damageType, damageText));
		return result;
	}

	// attack_1
	void OnAttack12()
	{
		DoDamage(ENT_LASTSEEN, ATTACK_HITRANGE, ATTACK_DAMAGE, ATTACK_HITCHANCE);

		float enemyHp = HealthOf(ENT_LASTSTRUCKBYME);
		float divAttackDamage = Float(ATTACK_DAMAGE);
		divAttackDamage *= 0.6f;

		if (LAST_STOLE_HP > 0.0f)
			LAST_STOLE_HP -= 1.0f;

		if (enemyHp <= divAttackDamage && LAST_STOLE_HP < 1.0f && RelationshipOf(ENT_LASTSTRUCKBYME, ENT_ME) == "enemy")
		{
			float enemyMaxhp = MaxHealthOf(ENT_LASTSTRUCKBYME);
			string iceCreamName = "Ice Wall";
			string nmeName = NameOf(ENT_LASTSTRUCKBYME);
			InfoMessage(ENT_LASTSTRUCKBYME, "SOUL_EATER", "Beware, soul eaters gain double their victim's health when they slay a living opponent.");
			SetSayTextRange(1024);
			if (nmeName == iceCreamName)
				SayText("Mmmmmmm... Ice cream!");
			if (nmeName != iceCreamName)
				SayText("I'll swallow your soul!");
			SetVolume(10);
			PlaySound(2, 10, SOUND_HEAL);
			// dbg HPBefore $get(ent_me,hp)
			enemyMaxhp *= 2.0f;
			GiveHealth(enemyMaxhp);
			// dbg HPAfter $get(ent_me,hp)
			Effect("glow", ENT_ME, Vector3(0, 255, 0), 255, 2, 2);
			LAST_STOLE_HP = 10.0f; // can't aborb again for 10 atks
		}

		bool iDidPush = false;
		if (DID_PUSH == 1)
		{
			DID_PUSH = 0;
			iDidPush = true;
		}

		if (iDidPush)
			return;

		if (RandomInt(0, 1) == 0)
		{
			SetVolume(5);
			if (LAST_STOLE_HP < 3.0f)
				PlayRandomSound(2, 10, SOUND_ATTACK1, SOUND_ATTACK2);
		}
	}

	// npc_struck
	// Hit by someone
	void OnNpcStruck(float damage = 0.0f)
	{
		SetVolume(5);
		PlayRandomSound(2, 10, SOUND_PAIN, SOUND_PAIN, SOUND_STRUCK1, SOUND_STRUCK2, SOUND_STRUCK3);
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/skeleton2.mdl");
		CallEventDelayed(Float(CYCLE_TIME), "hunting_mode_go");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		SkeletonSoulEater_FirstThink();
		BaseNpcAttack_FirstThink();
		BaseNpc_FirstThink();
		MonstersExternals_FirstThink();
		BaseMonsterShared_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "attack_1") { OnAttack12(); return true; }
		if (name == "game_death") { OnGameDeath(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_dodamage") { Return(OnGameDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5))); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "npc_struck") { OnNpcStruck(Float(Param(params, 0))); return true; }
		return BaseMonsterScript::DispatchEvent(name, params);
	}
}
