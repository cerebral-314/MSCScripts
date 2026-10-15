#pragma context server

// Converted from calruin/reanimate.script by msc_transpiler.
// Thothie - Naming convention error causing spawn sound not to play
// - Now drops 1 of 3 scroll/tomes
// Calrian Himself! *gasp*

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_monster_new.as"

[script "calruin/reanimate"]
class Reanimate : BaseMonsterNewScript
{
	// Constants
	string ANIM_SIT = "sitidle";
	string ANIM_GETUP = "sitstand";
	string ANIM_SWING = "attack3";
	string ANIM_THROW = "attack2";
	string ATTACK_DAMAGE = "30";
	string ATTACK_HITCHANCE = "85%";
	string SOUND_STRUCK1 = "controller/con_pain3.wav";
	string SOUND_STRUCK2 = "controller/con_pain3.wav";
	string SOUND_STRUCK3 = "none";
	string SOUND_PAIN = "zombie/zo_pain2.wav";
	string SOUND_ATTACK1 = "controller/con_attack1.wav";
	string SOUND_HEAL = "monsters/skeleton/calrian2.wav";
	string SOUND_ATTACK2 = "controller/con_attack2.wav";
	string SOUND_BROTHER = "monsters/skeleton/calrian.wav";
	string SOUND_IDLE1 = "controller/con_attack3.wav";
	string SOUND_SPAWN = "monsters/skeleton/calrian2.wav";
	string SOUND_PUSH = "monsters/skeleton/calrain3.wav";
	string MONSTER_MODEL = "monsters/skeleton_boss1.mdl";

	// Variables (an unset .script variable reads as its own name)
	string ANIM_IDLE_NORM = "idle1";
	string NPC_EXP_MULTI = "NPC_EXP_MULTI";
	string ANIM_ATTACK = "ANIM_ATTACK";
	string ANIM_FLINCH = "ANIM_FLINCH";
	float THROW_CHANCE = 0.0f;
	bool I_AM_TURNABLE = false;
	bool LEGIT_MAP = false;
	float LAST_STOLE_HP = 0.0f;
	bool NPC_NO_MOVE = false;
	int DID_PUSH = 0;

	// Variables declared by included files, with the value they start with in this script
	Reanimate()
	{
		NPC_BOSS_REGEN_RATE = 0.0f;
		ANIM_RUN = "run";
		ANIM_WALK = "walk";
	}

	// unnamed block (first think)
	void Reanimate_FirstThink()
	{
		if (StartsWith(ToLowerCase(MapName()), "calruin"))
			NPC_IS_BOSS = true;
		if (!NPC_IS_BOSS)
			NPC_EXP_MULTI = "0.25";

		ANIM_RUN = "run";
		ANIM_WALK = "walk";
		ANIM_IDLE_NORM = "idle1";

		ANIM_ATTACK = ANIM_SWING;
		ATTACK_RANGE = 140.0f;
		MOVE_RANGE = "65";
		ATTACK_HITRANGE = 175.0f;
		ANIM_IDLE = ANIM_IDLE_NORM;
		ANIM_FLINCH = "laflinch";

		THROW_CHANCE = 30.0f;
	}

	// game_dodamage
	// 1: Attack Hit (1/0)  2: Entity Attack hit  3:  Start Position  4:  End Position
	string Reanimate_OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";

		if (!hit)
			return result;

		if (RandomInt(1, int(THROW_CHANCE)) == 1)
		{
			// push to cut down on shielders
			PlayAnim("critical", ANIM_THROW);
			PlaySound(2, 10, SOUND_PUSH);
			Vector3 myLoc = MyOrigin();
			Vector3 nmeLoc = OriginOf(ENT_LASTSTRUCKBYME);
			float nmeDistance = Distance(myLoc, nmeLoc);
			if (nmeDistance < ATTACK_HITRANGE)
				ApplyEffect(target, "effects/effect_push", 3, RelativeVelocity(Vector3(0, 400, 400)), 0);
			DID_PUSH = 1;
		}
		return result;
	}

	// game_damaged
	// PARAM1=attacker PARAM2=Damage PARAM3=Type
	string Reanimate_OnGameDamaged(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float accuracyRoll = 0.0f, CBaseEntity@ inflictor = null, string skill = "")
	{
		string result = "";

		if (!Contains(damageType, "fire"))
			return result;
		if (THROW_CHANCE == 10.0f)
			return result;
		THROW_CHANCE = 10.0f;
		CallEventDelayed(3.0f, "throw_reset");
		return result;
	}

	// game_struck
	// Hit by someone
	void OnGameStruck(float damage = 0.0f, string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		BaseNpc_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseNpcAttackNew_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc_attack_new
		BaseMonsterShared_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared

		PlayRandomSound(2, 5, SOUND_PAIN, SOUND_PAIN, SOUND_STRUCK1, SOUND_STRUCK2, SOUND_STRUCK3);
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseNpcAttackNew_OnNpcSpawn(npc); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck

		I_AM_TURNABLE = false;

		SetHealth(2000);
		SetWidth(32);
		SetHeight(80);
		SetName("the re-animated bones of|Lord Calrian");
		SetRoam(false);
		SetHearingSensitivity(8);
		NPC_GIVE_EXP = 1000.0f;
		SetRace("undead");
		SetModel(MONSTER_MODEL);
		SetModelBody(0, 1); // 0=standard 1=ash 2=green 3=bloody 4=decayed 5=ice 6=gold 7=stone 8=crystal 9=weirdgel
		SetModelBody(1, 1); // 0=Unarmed 1=darkmace 2=sword 3=hammahs 4=bigsword+shield 5=iceclubs 6=fireclubs 7=highsword 8=wand

		SetDamageTaken("all", 0.65f);
		SetIdleAnim(ANIM_SIT);
		SetMoveAnim(ANIM_SIT);

		SetInvincible(true);

		SetDamageTaken("holy", 1.5f);
		SetDamageTaken("fire", 0.25f);
		SetDamageTaken("cold", 0.25f);
		SetDamageTaken("stun", 0.6f);

		string mapName = MapName();
		LEGIT_MAP = false;

		if (mapName == "calruin")
			LEGIT_MAP = true;
		if (mapName == "calruin2")
			LEGIT_MAP = true;

		if (LEGIT_MAP)
		{
			int chance = RandomInt(1, 3);
			if (chance == 1)
				GiveItem("scroll_summon_undead");
			if (chance == 2)
				GiveItem("scroll2_summon_undead");
			if (chance == 3)
				GiveItem("scroll2_turn_undead");

			GiveItem("blunt_calrianmace");
		}

		LAST_STOLE_HP = 10.0f; // no soul stealing for first 10 atks

		OnNpcatkSuspendAi();

		CallEventDelayed(8.0f, "bring_it_on");
	}

	// npcatk_hunt
	void OnNpcatkHunt()
	{
		BaseNpcAttackNew_OnNpcatkHunt(); // monsters/base_npc_attack_new
		BaseAntiStuck_OnNpcatkHunt(); // monsters/base_anti_stuck

		if (NPCATK_TARGET == "unset" && Truthy(LegacyFunction("cansee", "enemy", 700)))
			OnNpcatkSettarget(EntityId(EntityOf(ENT_LASTSEEN)), "saw_new_enemy");
	}

	// my_target_died
	void OnMyTargetDied(string offender = "")
	{
		BaseNpcAttackNew_OnMyTargetDied(offender); // monsters/base_npc_attack_new

		// dbg Killed $get(PARAM1,name) maxhp $get(PARAM1,maxhp)
		if ("SOUL_TARGET" != EntityId(EntityOf(offender)))
			return;

		if (LAST_STOLE_HP != 0.0f)
			return;

		float enemyMaxhp = MaxHealthOf(offender);
		string iceCreamName = "Ice Wall";
		string nmeName = NameOf(ENT_LASTSTRUCKBYME);
		InfoMessage(offender, "Lord_Calrian", "Beware, Lord Calrian gains double your max health when he slays you!");
		SetSayTextRange(1024);
		if (nmeName == iceCreamName)
			SayText("Mmmmmmm... Ice cream!");
		if (nmeName != iceCreamName)
			SayText("Not even death can save you from me!");

		PlaySound(2, 10, SOUND_HEAL);
		// dbg HPBefore $get(ent_me,hp)
		enemyMaxhp *= 2.0f;
		if (MyHealth() < MyMaxHealth())
			GiveHealth(enemyMaxhp);
		// dbg HPAfter $get(ent_me,hp)
		Effect("glow", ENT_ME, Vector3(0, 255, 0), 255, 2, 2);
		LAST_STOLE_HP = 10.0f; // can't aborb again for 10 atks
	}

	// game_dodamage
	string OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";
		result = AppendResult(result, BaseNpcAttackNew_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BaseAntiStuck_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BaseMonsterShared_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, Reanimate_OnGameDodamage(hit, target, start, end, damageType, damageText));
		return result;
	}

	// game_damaged - Return a damage multiplier to scale the damage
	string OnGameDamaged(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float accuracyRoll = 0.0f, CBaseEntity@ inflictor = null, string skill = "")
	{
		string result = "";
		result = AppendResult(result, BaseAntiStuck_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, BaseMonsterShared_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, BaseMonsterShared_OnGameDamaged_2(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, Reanimate_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		return result;
	}

	// bring_it_on
	void OnBringItOn()
	{
		PlayAnim("critical", ANIM_GETUP);
		PlaySound(0, 10, "x/x_recharge1.wav");
	}

	// stand_complete
	// called from model ANIM_GETUP
	void OnStandComplete()
	{
		SetInvincible(false);
		SetIdleAnim(ANIM_IDLE);
		SetMoveAnim(ANIM_WALK);
		NPC_NO_MOVE = false;
		CYCLE_TIME = Text(CYCLE_TIME_BATTLE);
		OnNpcatkResumeAi();
		Look();
	}

	// attack_3
	void OnAttack3()
	{
		bool iDidPush = false;

		OnNpcatkDodamage(NPCATK_TARGET, Text(ATTACK_HITRANGE), ATTACK_DAMAGE, ATTACK_HITCHANCE);

		if (LAST_STOLE_HP > 0.0f)
			LAST_STOLE_HP -= 1.0f;

		if (DID_PUSH == 1)
		{
			DID_PUSH = 0;
			iDidPush = true;
		}

		if (iDidPush)
			return;

		if (RandomInt(0, 1) == 0 && LAST_STOLE_HP < 3.0f)
			PlayRandomSound(2, 5, SOUND_ATTACK1, SOUND_ATTACK2);
	}

	// npc_death
	void OnNpcDeath()
	{
		UseTrigger("endboss");

		if (!LEGIT_MAP)
			return;

		PlaySound(2, 10, SOUND_BROTHER);

		OnBmGoldSpew(10, "3", 40, 4, 20);

		SayText("You're too late! ... My brother is already here!");
	}

	// throw_reset
	void OnThrowReset()
	{
		THROW_CHANCE = 30.0f;
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/skeleton_boss1.mdl");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		Reanimate_FirstThink();
		BaseNpc_FirstThink();
		MonstersExternals_FirstThink();
		BaseNpcAttackNew_FirstThink();
		BaseMonsterShared_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "attack_3") { OnAttack3(); return true; }
		if (name == "bring_it_on") { OnBringItOn(); return true; }
		if (name == "game_damaged") { Return(OnGameDamaged(EntityParam(params, 0), Float(Param(params, 1)), Param(params, 2), Float(Param(params, 3)), EntityParam(params, 4), Param(params, 5))); return true; }
		if (name == "game_dodamage") { Return(OnGameDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5))); return true; }
		if (name == "game_struck") { OnGameStruck(Float(Param(params, 0)), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "my_target_died") { OnMyTargetDied(Param(params, 0)); return true; }
		if (name == "npc_death") { OnNpcDeath(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "npcatk_hunt") { OnNpcatkHunt(); return true; }
		if (name == "stand_complete") { OnStandComplete(); return true; }
		if (name == "throw_reset") { OnThrowReset(); return true; }
		return BaseMonsterNewScript::DispatchEvent(name, params);
	}
}
