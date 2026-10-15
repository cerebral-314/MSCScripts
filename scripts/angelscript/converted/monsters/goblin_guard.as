#pragma context server

// Converted from monsters/goblin_guard.script by msc_transpiler.
// Goblin Guard
// This guy is tougher than the normal goblin!

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_monster_new.as"

[script "monsters/goblin_guard"]
class GoblinGuard : BaseMonsterNewScript
{
	// Constants
	string SOUND_STRUCK1 = "body/flesh1.wav";
	string SOUND_STRUCK2 = "body/flesh2.wav";
	string SOUND_STRUCK3 = "body/flesh3.wav";
	string SOUND_HIT = "monsters/goblin/c_gargoyle_hit1.wav";
	string SOUND_HIT1 = "monsters/goblin/c_gargoyle_hit1.wav";
	string SOUND_HIT2 = "monsters/goblin/c_gargoyle_hit2.wav";
	string SOUND_PAINYELL = "monsters/orc/pain.wav";
	string SOUND_WARCRY1 = "monsters/goblin/c_goblin_bat1.wav";
	string SOUND_ATTACK1 = "monsters/goblin/c_goblin_atk1.wav";
	string SOUND_ATTACK2 = "monsters/goblin/c_goblin_atk2.wav";
	string SOUND_ATTACK3 = "monsters/goblin/c_goblin_atk3.wav";
	string SOUND_DEATH2 = "monsters/goblin/c_goblin_dead.wav";
	string SOUND_HELP = "monsters/goblin/c_goblin_bat2.wav";
	string ATTACK_HITCHANCE = "80%";

	// Variables (an unset .script variable reads as its own name)
	string ANIM_ATTACK = "ANIM_ATTACK";
	string CAN_HUNT = "CAN_HUNT";
	string HUNT_AGRO = "HUNT_AGRO";
	int DROP_GOLD_MIN = 0;
	int DROP_GOLD_MAX = 0;
	string ATTACK_DAMAGE = "ATTACK_DAMAGE";
	string LAST_ENEMY = "LAST_ENEMY";

	// Variables declared by included files, with the value they start with in this script
	GoblinGuard()
	{
		ANIM_RUN = "run";
		ANIM_WALK = "walk";
		SOUND_DEATH = "monsters/goblin/c_goblin_dead.wav";
	}

	// unnamed block (first think)
	void GoblinGuard_FirstThink()
	{
		ANIM_RUN = "run";
		ANIM_WALK = "walk";
		ANIM_ATTACK = "swordswing1_L";
		ANIM_DEATH = "die_fallback";
		ATTACK_RANGE = 100.0f;
		ATTACK_HITRANGE = 130.0f;
		MOVE_RANGE = "50";
		CAN_HUNT = "1";
		HUNT_AGRO = "1";
		RETALIATE_CHANCE = "75%"; // base_npc_attack - Automatically switch targets to the last damaging player
		CAN_FLEE = "0"; // base_npc_attack - Whether I run away at low health
		DROP_GOLD = RandomInt(0, 1);
		DROP_GOLD_MIN = 3;
		DROP_GOLD_MAX = 5;
		NPC_MUST_SEE_TARGET = "0";
	}

	// game_death
	void OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		DqMonsterExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // dq/externals/dq_monster_externals
		MonstersExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/externals
		BaseSelfAdjust_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_self_adjust
		BaseNpc_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseMonsterShared_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared
		SetModelBody(2, 0);
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseNpcAttackNew_OnNpcSpawn(npc); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck

		SetHealth(120);
		// ov 180
		SetWidth(32);
		SetHeight(60);
		SetName("Goblin Guard");
		SetRoam(true);
		SetHearingSensitivity(6);
		SetSkillLevel(35);
		SetRace("goblin");

		SetModel("monsters/goblin_new.mdl");
		SetModelBody(0, 0); // body: no options currently
		SetModelBody(1, 1); // head: 0-bare 1-animal 2-chief 3-slickback
		SetModelBody(2, 4); // weapon: 0-Unarmed 1-Axe 2-wbow 3-sbow 4-sword 5-rAxe 6-sword&shield 7-club 8-knife
		SetModelBody(3, 0); // quiver: On/off
		SetModelBody(4, 0); // arrow: On/off

		SetIdleAnim("idle1");
		SetMoveAnim(ANIM_WALK);
	}

	// npc_targetsighted
	// Warcry
	void OnNpcTargetsighted(string target = "")
	{
		BaseMonsterShared_OnNpcTargetsighted(target); // monsters/base_monster_shared

		CBaseEntity@ lastseenEnemy = EntityOf(ENT_LASTSEEN);
		if (EntityId(lastseenEnemy) == LAST_ENEMY)
			return;

		PlaySound(Int(Eval("game.sound.voice")), 5, SOUND_WARCRY1);
		LAST_ENEMY = EntityId(lastseenEnemy);
	}

	// swing_sword
	void OnSwingSword()
	{
		ATTACK_DAMAGE = Text(Random(8, 12));
		if (RangeTo(NPCATK_TARGET) < ATTACK_HITRANGE)
			OnNpcatkDodamage(NPCATK_TARGET, "direct", ATTACK_DAMAGE, ATTACK_HITCHANCE, EntityId(self), "slash");

		OnAttackSound();
	}

	// npc_struck
	// Hit by someone
	void OnNpcStruck(float damage = 0.0f)
	{
		SetVolume(5);
		PlayRandomSound(2, 5, SOUND_HIT, SOUND_HIT2, SOUND_STRUCK1, SOUND_STRUCK2, SOUND_STRUCK3);
	}

	// attack_sound
	// Attack grunts
	void OnAttackSound(float pitch = 0.0f)
	{
		if (RandomInt(0, 1) == 0)
		{
			SetVolume(5);
			PlayRandomSound(2, 5, SOUND_ATTACK1, SOUND_ATTACK2, SOUND_ATTACK3);
		}
		else if (RandomInt(0, 5) == 2)
			PlaySound(4, 5, SOUND_WARCRY1);
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/goblin_new.mdl");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		GoblinGuard_FirstThink();
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
		if (name == "attack_sound") { OnAttackSound(Float(Param(params, 0))); return true; }
		if (name == "game_death") { OnGameDeath(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "npc_struck") { OnNpcStruck(Float(Param(params, 0))); return true; }
		if (name == "npc_targetsighted") { OnNpcTargetsighted(Param(params, 0)); return true; }
		if (name == "swing_sword") { OnSwingSword(); return true; }
		return BaseMonsterNewScript::DispatchEvent(name, params);
	}
}
