#pragma context server

// Converted from monsters/summon/snake_cursed.script by msc_transpiler.
// Cursed snake by Thothie (From Sidewinder)
// - This is the variant humans summon, it does not respond to commands ala base summon

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_monster_new.as"

[script "monsters/summon/snake_cursed"]
class MonstersSummonSnakeCursed : BaseMonsterNewScript
{
	// Constants
	string ATTACK_HITCHANCE = "80%";
	string ATTACK_DAMAGE = "$randf(5,20)";
	string POISON_DAMAGE = "$randf(2,10)";
	string POISON_DURATION = "$rand(10,20)";
	string SOUND_ALERT = "monsters/snake_idle1.wav";
	string SOUND_IDLE = "monsters/snake_idle2.wav";
	string SOUND_ATTACK = "bullchicken/bc_bite2.wav";
	string SOUND_PAIN1 = "monsters/snake_pain1.wav";
	string SOUND_PAIN2 = "monsters/snake_pain2.wav";
	string SOUND_POISON = "monsters/snakeman/sm_alert1.wav";
	string SOUND_STRUCK = "debris/flesh2.wav";
	string MONSTER_MODEL = "monsters/giant_rat.mdl";

	// Variables (an unset .script variable reads as its own name)
	string ANIM_ATTACK = "ANIM_ATTACK";
	bool BITE_SOUND = false;
	bool DID_ALERT = false;
	string MY_OWNER = "MY_OWNER";

	// Variables declared by included files, with the value they start with in this script
	MonstersSummonSnakeCursed()
	{
		ANIM_WALK = "snake_walk";
		ANIM_RUN = "snake_walk";
		ANIM_IDLE = "snake_idle1";
		CYCLE_TIME_IDLE = 0.1f;
		CYCLE_TIME_NPC = 0.1f;
	}

	// unnamed block (first think)
	void MonstersSummonSnakeCursed_FirstThink()
	{
		ANIM_WALK = "snake_walk";
		ANIM_RUN = "snake_walk";
		ANIM_DEATH = "snake_diesimple";
		ANIM_IDLE = "snake_idle1";
		ANIM_ATTACK = "snake_attack1";
		ATTACK_RANGE = 80.0f;
		ATTACK_HITRANGE = 120.0f;
		ATTACK_MOVERANGE = 35.0f;

		NO_SPAWN_STUCK_CHECK = true;
		CYCLE_TIME = Text(CYCLE_TIME_BATTLE);

		NPC_NO_PLAYER_DMG = true;
	}

	// game_dynamically_created
	// { [override] npcatk_attack
	// setvard NPC_DELAYING_UNSTUCK NPC_UNSTUCK_DELAY //I've stopped moving to attack, I'm not stuck
	// if !ATTACK_DELAY
	// playanim critical ANIM_ATTACK
	// playsound 0 10 SOUND_ATTACK
	// setvard ATTACK_DELAY 1
	// callevent 1.0 reset_attack_delay
	// }
	// { reset_attack_delay
	// setvard ATTACK_DELAY 0
	// }
	void OnGameDynamicallyCreated(string creatorValue1 = "", string creatorValue2 = "", string damage = "", string skill = "", string extraValue5 = "", string extraValue6 = "", float alwaysPush = 0.0f, string duration = "", string extraValue9 = "")
	{
		BaseSelfAdjust_OnGameDynamicallyCreated(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/base_self_adjust
		BaseSelfAdjust_OnGameDynamicallyCreated_2(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/base_self_adjust
		BaseAntiStuck_OnGameDynamicallyCreated(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/base_anti_stuck
		BaseAntiStuck_OnGameDynamicallyCreated_2(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/base_anti_stuck

		// dbg temp My owner is $get(ent_creationowner,name)
		MY_OWNER = creatorValue1;
		DebugPrint("game_dynamically_created " + NameOf(creatorValue1));
		string firstTarg = EntityId(TargetOf(MY_OWNER));
		if (IsAlive(firstTarg) && RelationshipOf(firstTarg, MY_OWNER) == "enemy")
			OnNpcatkSettarget(EntityId(EntityOf(firstTarg)));
		CallEventDelayed(30.0f, "npc_fade_away");
		SetAngle("face", AnglesOf(MY_OWNER));

		SetAnimMoveSpeed(5);
		SetAnimFrameRate(1.5f);
		CallEventDelayed(0.01f, "set_hp");

		if (IsAlive(firstTarg))
			return;
		firstTarg = FindOneInSphere("monster", 1024);
		if (!IsAlive(firstTarg))
			return;
		if (RelationshipOf(firstTarg, MY_OWNER) != "enemy")
			return;
		OnNpcatkTarget2(firstTarg);
	}

	// game_struck
	void OnGameStruck(float damage = 0.0f, string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		BaseNpc_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseNpcAttackNew_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc_attack_new
		BaseMonsterShared_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared

		PlayRandomSound(0, 10, SOUND_PAIN1, SOUND_PAIN2, SOUND_STRUCK, SOUND_STRUCK);
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseNpcAttackNew_OnNpcSpawn(npc); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck

		SetName("Cursed Snake");
		SetHealth(1);
		SetWidth(48);
		SetHeight(32);
		SetRoam(false);
		SetRace("human");
		SetModel(MONSTER_MODEL);
		SetModelBody(0, 6);
		SetIdleAnim(ANIM_IDLE);
		SetMoveAnim(ANIM_WALK);
		SetHearingSensitivity(4);
		CallEventDelayed(1.0f, "idle_sounds");
		SetDamageTaken("poison", 0);
		SetDamageTaken("stun", 0);
		SetSolid("none");
	}

	// npcatk_targetvalidate
	void OnNpcatkTargetvalidate(string target = "")
	{
		BaseNpcAttackNew_OnNpcatkTargetvalidate(target); // monsters/base_npc_attack_new

		if (IsPlayer(target)) // invalidate players (cuz they can't hurt me)
			NPCATK_TARGET = "unset";

		if (DID_ALERT)
			return;
		PlaySound(0, 10, SOUND_ALERT);
		SetRoam(true);
		DID_ALERT = true;
	}

	// my_target_died
	void OnMyTargetDied(string offender = "")
	{
		BaseNpcAttackNew_OnMyTargetDied(offender); // monsters/base_npc_attack_new

		// vanishes on kill
		DeleteEntity(ENT_ME, "fade");
	}

	// idle_sounds
	void OnIdleSounds()
	{
		PlaySound(0, 10, SOUND_IDLE);
		CallEventDelayed(Random(5, 10), "idle_sounds");
	}

	// bite1
	void OnBite1()
	{
		BITE_SOUND = true;

		if (!(RangeTo(NPCATK_TARGET) < ATTACK_HITRANGE))
			return;

		// has to be direct, or traceline may damage itself!
		DoDamageEx(NPCATK_TARGET, "direct", ATTACK_DAMAGE, ATTACK_HITCHANCE, MY_OWNER, ENT_ME, "spellcasting.affliction", "pierce", "*dmgevent:bite");
	}

	// bite_dodamage
	void OnBiteDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		if (!hit)
			return;

		DebugPrint("game_dodamage " + NameOf(target));

		if (!BITE_SOUND)
			return;
		BITE_SOUND = false;
		if (RandomInt(1, 5) != 1)
			return;
		PlaySound(0, 10, SOUND_POISON);

		DebugPrint("dot_poison " + NameOf(target));

		float dot = Float(POISON_DAMAGE);
		dot *= SkillOf(MY_OWNER, "spellcasting.affliction");
		dot *= 0.2f;
		ApplyEffect(target, "effects/dot_poison", POISON_DURATION, MY_OWNER, dot);
		// storeentity ent_expowner MY_OWNER
		CallEventDelayed(0.1f, "npc_fade_away");
	}

	// set_hp
	void OnSetHp()
	{
		SetHealth(SkillOf(MY_OWNER, "spellcasting.affliction"));
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/giant_rat.mdl");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		MonstersSummonSnakeCursed_FirstThink();
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
		if (name == "bite1") { OnBite1(); return true; }
		if (name == "bite_dodamage") { OnBiteDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5)); return true; }
		if (name == "game_dynamically_created") { OnGameDynamicallyCreated(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Float(Param(params, 6)), Param(params, 7), Param(params, 8)); return true; }
		if (name == "game_struck") { OnGameStruck(Float(Param(params, 0)), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "idle_sounds") { OnIdleSounds(); return true; }
		if (name == "my_target_died") { OnMyTargetDied(Param(params, 0)); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "npcatk_targetvalidate") { OnNpcatkTargetvalidate(Param(params, 0)); return true; }
		if (name == "set_hp") { OnSetHp(); return true; }
		return BaseMonsterNewScript::DispatchEvent(name, params);
	}
}
