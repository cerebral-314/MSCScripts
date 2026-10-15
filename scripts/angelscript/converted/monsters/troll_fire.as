#pragma context server

// Converted from monsters/troll_fire.script by msc_transpiler.
// This is an older script and may have some bad conventions as a result.
// Thothie - include override not working, so copying from original Troll (monsters/troll)
// - Changed model accordingly, increased fire sensitivity / HP
// - Adjusted Anims for Model
// - %chance of applying frostbite effect
// Standard Troll

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_monster.as"

[script "monsters/troll_fire"]
class TrollFire : BaseMonsterScript
{
	// Constants
	string SOUND_STRUCK1 = "weapons/cbar_hitbod1.wav";
	string SOUND_STRUCK2 = "monsters/troll/trollpain.wav";
	string SOUND_STRUCK3 = "monsters/troll/trollpain.wav";
	string SOUND_PAIN = "monsters/troll/trollpain.wav";
	string SOUND_ATTACK1 = "monsters/troll/trollattack.wav";
	string SOUND_ATTACK2 = "monsters/troll/trollattack.wav";
	string SOUND_WALK = "monsters/troll/trollidle.wav";
	string SOUND_WALK1 = "monsters/troll/step1.wav";
	string SOUND_WALK2 = "monsters/troll/step2.wav";
	string SOUND_IDLE = "monsters/troll/trollidle.wav";
	string FIRE_DAMAGE = "$rand(20,100)";
	string ATTACK1_DAMAGE = "$randf(30,80)";
	string ATTACK2_DAMAGE = "$randf(100,300)";

	// Variables (an unset .script variable reads as its own name)
	int DROP_GOLD_MIN = 0;
	int DROP_GOLD_MAX = 0;
	string ANIM_ATTACK = "ANIM_ATTACK";
	bool I_AM_TURNABLE = false;
	string DROP_ITEM1 = "DROP_ITEM1";
	string PUSH_VEL = "PUSH_VEL";
	bool I_R_SUMMONED = false;
	string MY_MASTER = "MY_MASTER";
	float STEP_COUNT = 0.0f;

	// Variables declared by included files, with the value they start with in this script
	TrollFire()
	{
		SOUND_DEATH = "monsters/troll/trolldeath.wav";
		ANIM_RUN = "walk";
		ANIM_WALK = "walk";
		ANIM_IDLE = "idle1";
	}

	// unnamed block (first think)
	void TrollFire_FirstThink()
	{
		DROP_GOLD = 1;
		DROP_GOLD_MIN = 10;
		DROP_GOLD_MAX = 35;
		ANIM_RUN = "walk";
		ANIM_WALK = "walk";
		ANIM_IDLE = "idle1";
		ANIM_ATTACK = "attack1";
		ANIM_DEATH = "dieheadshot2";
		ATTACK_RANGE = 125.0f;
		ATTACK_HITRANGE = 200.0f;
		CAN_FLINCH = "0";
		MOVE_RANGE = "100";
		CAN_HUNT = "1";
		HUNT_AGRO = "1";
	}

	// game_dynamically_created
	void OnGameDynamicallyCreated(string creatorValue1 = "", string creatorValue2 = "", string damage = "", string skill = "", string extraValue5 = "", string extraValue6 = "", float alwaysPush = 0.0f, string duration = "", string extraValue9 = "")
	{
		BaseSelfAdjust_OnGameDynamicallyCreated(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/base_self_adjust
		BaseSelfAdjust_OnGameDynamicallyCreated_2(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/base_self_adjust
		BaseAntiStuck_OnGameDynamicallyCreated(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/base_anti_stuck
		BaseAntiStuck_OnGameDynamicallyCreated_2(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/base_anti_stuck

		SetSolid("none");
		CallEventDelayed(1.0f, "ice_solidify");

		I_R_SUMMONED = true;

		MY_MASTER = EntityId(EntityOf(ENT_CREATIONOWNER));
		bool myMasterLives = IsAlive(ENT_CREATIONOWNER);
		// dbg Mastah Alive MY_MASTER_LIVES
		if (!myMasterLives)
			return;
		CallEventDelayed(2.0f, "npcatk_flee");
		OnAntiStuckChecks(); // liable to be stuck on spawn, so start anti-stuck checks immediately
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck

		I_AM_TURNABLE = false;

		// ov 359
		SetWidth(72);
		SetHeight(135);
		SetRace("demon");
		SetIdleAnim("idle1");
		SetMoveAnim(ANIM_WALK);
		SetHealth(1000);
		SetName("Efreeti");
		SetRoam(true);
		NPC_GIVE_EXP = 200.0f;
		SetDamageTaken("all", 1);
		SetDamageTaken("holy", 1);
		SetDamageTaken("cold", 1.75f);
		SetDamageTaken("fire", 0);
		SetHearingSensitivity(8);
		SetModel("monsters/firetroll.mdl");

		if (RandomInt(1, 32) < ActivePlayerCount())
		{
			DROP_ITEM1 = "item_eh";
			DROP_ITEM1_CHANCE = "100";
		}
		else if (ToLowerCase(MapName()) == "phlames")
		{
			DROP_ITEM1 = "item_eh";
			DROP_ITEM1_CHANCE = "100";
		}

		Effect("glow", ENT_ME, Vector3(255, 64, 48), 512, 3, 3);

		OnTrollSpawn(); // holdover from troll - not what it's here for
	}

	// attack_1
	void OnAttack12()
	{
		PUSH_VEL = Text(RelativeVelocity(Vector3(10, 200, 10)));
		DoDamage(ENTITY_ENEMY, ATTACK_HITRANGE, ATTACK1_DAMAGE, "75%");

		if (RandomInt(0, 3) == 0)
			ANIM_ATTACK = "attack2";

		if (RandomInt(1, 8) == 1)
			ApplyEffect(ENT_LASTSTRUCKBYME, "effects/dot_fire", 10, self, FIRE_DAMAGE);

		if (RandomInt(1, 20) == 1)
		{
			SetVolume(10);
			PlaySound(1, 10, SOUND_IDLE);
		}
		SetVolume(8);
		PlaySound(2, 8, SOUND_ATTACK1);
	}

	// attack_2
	void OnAttack22()
	{
		ANIM_ATTACK = "attack1";

		ApplyEffect(ENT_LASTSTRUCKBYME, "effects/dot_fire", 5, self, FIRE_DAMAGE);

		DoDamage(ENTITY_ENEMY, ATTACK_HITRANGE, ATTACK2_DAMAGE, "75%");

		PlayRandomSound(2, SOUND_ATTACK1);
	}

	// npc_struck
	void OnNpcStruck(float damage = 0.0f)
	{
		SetVolume(5);
		PlayRandomSound(Int(Eval("game.sound.voice")), 5, SOUND_PAIN, SOUND_PAIN, SOUND_STRUCK2, SOUND_STRUCK1, SOUND_STRUCK3);
	}

	// game_hearsound
	void OnGameHearsound()
	{
		SetVolume(10);
		PlaySound(Int(Eval("game.sound.voice")), 10, SOUND_IDLE);
	}

	// ice_solidify
	void OnIceSolidify()
	{
		// check if pet is clear, if so, go back to solid, if not, try again 5 secs
		Vector3 myLoc = OriginOf(ENT_ME);
		Vector3 myMasterLoc = OriginOf(ENT_CREATIONOWNER);
		float masterDistance = Distance(myLoc, myMasterLoc);
		// dbg Master Distance MASTER_DISTANCE
		if (masterDistance > 80.0f)
		{
			// dbg Ice Troll Going Solid
			SetSolid("box");
		}
		if (masterDistance <= 80.0f)
		{
			if (!IS_FLEEING)
				OnNpcatkFlee(EntityId(EntityOf(ENT_CREATIONOWNER)), "512", "3");
			CallEventDelayed(0.25f, "ice_solidify");
		}
	}

	// anti_stuck_checks
	void OnAntiStuckChecks()
	{
		if (!I_R_SUMMONED)
			return;
		if (STUCK_COUNT != 2.0f)
			return;
		// dbg Mastah - I am stuck - Resummon me!
		CallExternal(EntityOf(ENT_CREATIONOWNER), "my_pet_stuck");
	}

	// walk_step
	// fired by model anim: walk @ frames 2 12 22 31 41 51
	void OnWalkStep()
	{
		STEP_COUNT += 1.0f;
		if (STEP_COUNT == 1.0f)
			PlaySound(0, 10, SOUND_WALK1);
		if (STEP_COUNT == 2.0f)
		{
			PlaySound(0, 10, SOUND_WALK2);
			STEP_COUNT = 0.0f;
		}
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files
	void OnTrollSpawn() {} // troll_spawn

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/firetroll.mdl");
		CallEventDelayed(Float(CYCLE_TIME), "hunting_mode_go");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		TrollFire_FirstThink();
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
		if (name == "anti_stuck_checks") { OnAntiStuckChecks(); return true; }
		if (name == "attack_1") { OnAttack12(); return true; }
		if (name == "attack_2") { OnAttack22(); return true; }
		if (name == "game_dynamically_created") { OnGameDynamicallyCreated(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Float(Param(params, 6)), Param(params, 7), Param(params, 8)); return true; }
		if (name == "game_hearsound") { OnGameHearsound(); return true; }
		if (name == "ice_solidify") { OnIceSolidify(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "npc_struck") { OnNpcStruck(Float(Param(params, 0))); return true; }
		if (name == "walk_step") { OnWalkStep(); return true; }
		return BaseMonsterScript::DispatchEvent(name, params);
	}
}
