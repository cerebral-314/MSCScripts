#pragma context server

// Converted from edana/guard.script by msc_transpiler.
// Human Guard

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_monster_new.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class EdanaGuard
{
	// Variables (an unset .script variable reads as its own name)
	string ANIM_WALK = "walk";
	string ANIM_RUN = "run";
	string SOUND_STRUCK1 = "body/armour4.wav";
	string SOUND_HIT = "voices/human/male_hit1.wav";
	string SOUND_HIT2 = "voices/human/male_hit2.wav";
	string SOUND_HIT3 = "voices/human/male_hit3.wav";
	string SOUND_DIE = "voices/human/male_die.wav";
	string SND_SHOUT = "voices/human/male_guard_shout.wav";
	string SND_SHOUT2 = "voices/human/male_guard_shout2.wav";
	string SND_DISMISS = "voices/human/male_guard_dismiss.wav";
	string SND_DISMISS2 = "voices/human/male_guard_dismiss2.wav";
	float ATTACK_RANGE = 0.0f;
	string ATTACK1_DAMAGE = "ATTACK1_DAMAGE";
	string ATTACK_PERCENTAGE = "ATTACK_PERCENTAGE";
	string ANIM_ATTACK = "ANIM_ATTACK";
	string ANIM_DEATH = "ANIM_DEATH";
	string MOVE_RANGE = "MOVE_RANGE";
	string SEE_ENEMY_NOW = "SEE_ENEMY_NOW";
	bool SEE_ENEMY = false;
	bool INNOCENT = false;
	int SURRENDER = 0;
	bool SURRENDERED = false;
	string CAN_RETALIATE = "CAN_RETALIATE";
	string RETALIATE_CHANGETARGET_CHANCE = "RETALIATE_CHANGETARGET_CHANCE";
	string CAN_HUNT = "CAN_HUNT";
	string CAN_ATTACK = "CAN_ATTACK";
	string HUNT_AGRO = "HUNT_AGRO";
	string PERP = "";
	string NPC_MOVE_TARGET = "NPC_MOVE_TARGET";

	// unnamed block (first think)
	void EdanaGuard_FirstThink()
	{
		ATTACK_RANGE = 100.0f;
		ATTACK1_DAMAGE = "5";
		ATTACK_PERCENTAGE = "80%";
		ANIM_WALK = "walk";
		ANIM_RUN = "run";
		ANIM_ATTACK = "swordswing1_L";
		ANIM_DEATH = "diesimple";
		MOVE_RANGE = "64";
		SEE_ENEMY_NOW = "equals0";
		SEE_ENEMY = false;
		INNOCENT = false;
		SURRENDER = 0;
		SURRENDERED = false;
		CAN_RETALIATE = "1";
		RETALIATE_CHANGETARGET_CHANCE = "75%";
		CAN_HUNT = "1";
		CAN_ATTACK = "1";
		HUNT_AGRO = "0";

		SOUND_STRUCK1 = "body/armour4.wav";

		SOUND_HIT = "voices/human/male_hit1.wav";
		SOUND_HIT2 = "voices/human/male_hit2.wav";
		SOUND_HIT3 = "voices/human/male_hit3.wav";
		SOUND_DIE = "voices/human/male_die.wav";

		SND_SHOUT = "voices/human/male_guard_shout.wav";
		SND_SHOUT2 = "voices/human/male_guard_shout2.wav";

		SND_DISMISS = "voices/human/male_guard_dismiss.wav";
		SND_DISMISS2 = "voices/human/male_guard_dismiss2.wav";
	}

	// npc_spawn
	void EdanaGuard_OnNpcSpawn(string npc = "")
	{
		SetHealth(60);
		SetGold(RandomInt(1, 4));
		// ov		345
		SetWidth(32);
		SetHeight(72);
		SetRace("hguard");
		SetSkillLevel(13);
		SetName("Guard");
		SetRoam(true);
		SetModel("npc/guard1.mdl");
		SetMoveAnim(ANIM_WALK);
		SetStepSize(25);

		CatchSpeech("say_surrender", "I", "surrender");
		CatchSpeech("say_surrender", "give", "up");
		CatchSpeech("say_surrender", "mercy");

		CatchSpeech("say_nothing", "I'm", "innocent");
		CatchSpeech("say_nothing", "I", "didn't", "do", "it");
		CatchSpeech("say_nothing", "I", "had", "nothing", "to", "do", "with", "it");
		CatchSpeech("say_nothing", "I", "am", "innocent");
		CatchSpeech("say_nothing", "innocent");
	}

	// unnamed block (timer)
	// Greet player and other NPCs
	void EdanaGuard_Timer()
	{
		CallEventDelayed(45.0f, "EdanaGuard_Timer");

		SetMoveDest(ENT_LASTSEEN, 128);

		if ((SURRENDERED ? 1 : 0) != 1)
			return;

		PlayRandomSound(2, 7, SND_DISMISS, SND_DISMISS2);
	}

	// game_dynamically_created
	void EdanaGuard_OnGameDynamicallyCreated(string creatorValue1 = "", string creatorValue2 = "", string damage = "", string skill = "", string extraValue5 = "", string extraValue6 = "", float alwaysPush = 0.0f, string duration = "", string extraValue9 = "")
	{
		NPC_MOVE_TARGET = creatorValue1;
		PERP = creatorValue1;

		CallEventDelayed(1.0f, "set_target");
	}

	// set_target
	void EdanaGuard_OnSetTarget(string target = "")
	{
		OnNpcatkSettarget(NPC_MOVE_TARGET);
	}

	// unnamed block (timer)
	void EdanaGuard_Timer2()
	{
		CallEventDelayed(2.0f, "EdanaGuard_Timer2");

		if (SURRENDERED)
			return;
		NPC_MOVE_TARGET = PERP;
	}

	// say_surrender
	void EdanaGuard_OnSaySurrender()
	{
		SURRENDERED = true;
		SURRENDER = RandomInt(1, 2);
		SetRace("human");

		OnSurrender1();
		OnSurrender2();

		NPC_MOVE_TARGET = "enemy";
		CallEventDelayed(0.0f, "60");
	}

	// surrender1
	void EdanaGuard_OnSurrender1()
	{
		if (SURRENDER != 1)
			return;
		SayText("All right, but stay out of trouble next time.");
		OnNpcatkClearTargets();
	}

	// surrender2
	void EdanaGuard_OnSurrender2()
	{
		if (SURRENDER != 2)
			return;

		SayText("All right, but stay out of trouble next time.");
		OnNpcatkClearTargets();
	}

	// say_nothing
	void EdanaGuard_OnSayNothing()
	{
		if ((SURRENDERED ? 1 : 0) != 0)
			return;
		if ((INNOCENT ? 1 : 0) != 0)
			return;

		// race neutral
		SetMoveAnim(ANIM_WALK);

		SayText("Is that so? Well, off with you, then, and don't let me see you again, because if I do, you're in trouble!");
		INNOCENT = true;

		OnNpcatkClearTargets();

		CallEventDelayed(0.0f, "40");
	}

	// attack_1
	void EdanaGuard_OnAttack12()
	{
		// Deal damage
		DoDamage(ENT_LASTSEEN, ATTACK_RANGE, ATTACK1_DAMAGE, ATTACK_PERCENTAGE);
	}

	// npc_struck
	// Hit by someone
	void EdanaGuard_OnNpcStruck(float damage = 0.0f)
	{
		PlayRandomSound(2, 10, SOUND_STRUCK1);
		PlayRandomSound(1, 10, SOUND_HIT, SOUND_HIT2, SOUND_HIT3);
	}

	// disappear
	void EdanaGuard_OnDisappear()
	{
		DeleteEntity(ENT_ME, "fade");
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)

	// game_dynamically_created
	void OnGameDynamicallyCreated(string creatorValue1 = "", string creatorValue2 = "", string damage = "", string skill = "", string extraValue5 = "", string extraValue6 = "", float alwaysPush = 0.0f, string duration = "", string extraValue9 = "")
	{
		BaseSelfAdjust_OnGameDynamicallyCreated(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/base_self_adjust
		BaseSelfAdjust_OnGameDynamicallyCreated_2(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/base_self_adjust
		BaseAntiStuck_OnGameDynamicallyCreated(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/base_anti_stuck
		BaseAntiStuck_OnGameDynamicallyCreated_2(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/base_anti_stuck
		EdanaGuard_OnGameDynamicallyCreated(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9);
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseNpcAttackNew_OnNpcSpawn(npc); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck
		EdanaGuard_OnNpcSpawn(npc);
	}

	void OnSetTarget(string target = "") { EdanaGuard_OnSetTarget(target); } // set_target
	void OnSaySurrender() { EdanaGuard_OnSaySurrender(); } // say_surrender
	void OnSurrender1() { EdanaGuard_OnSurrender1(); } // surrender1
	void OnSurrender2() { EdanaGuard_OnSurrender2(); } // surrender2
	void OnSayNothing() { EdanaGuard_OnSayNothing(); } // say_nothing
	void OnAttack12() { EdanaGuard_OnAttack12(); } // attack_1
	void OnNpcStruck(float damage = 0.0f) { EdanaGuard_OnNpcStruck(damage); } // npc_struck
	void OnDisappear() { EdanaGuard_OnDisappear(); } // disappear

	// This file's events and timers by their .script names
	bool EdanaGuard_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "attack_1") { OnAttack12(); return true; }
		if (name == "disappear") { OnDisappear(); return true; }
		if (name == "game_dynamically_created") { OnGameDynamicallyCreated(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Float(Param(params, 6)), Param(params, 7), Param(params, 8)); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "npc_struck") { OnNpcStruck(Float(Param(params, 0))); return true; }
		if (name == "say_nothing") { OnSayNothing(); return true; }
		if (name == "say_surrender") { OnSaySurrender(); return true; }
		if (name == "set_target") { OnSetTarget(Param(params, 0)); return true; }
		if (name == "surrender1") { OnSurrender1(); return true; }
		if (name == "surrender2") { OnSurrender2(); return true; }
		if (name == "EdanaGuard_Timer") { EdanaGuard_Timer(); return true; }
		if (name == "EdanaGuard_Timer2") { EdanaGuard_Timer2(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "edana/guard"]
shared class EdanaGuardScript : BaseMonsterNewScript, EdanaGuard
{
	// Variables declared by included files, with the value they start with in this script
	EdanaGuardScript()
	{
		ANIM_WALK = "walk";
		ANIM_RUN = "run";
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("npc/guard1.mdl");
		CallEventDelayed(45.0f, "EdanaGuard_Timer");
		CallEventDelayed(2.0f, "EdanaGuard_Timer2");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		EdanaGuard_FirstThink();
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
		return EdanaGuard_DispatchEvent(name, params)
			|| BaseMonsterNewScript::DispatchEvent(name, params);
	}
}
