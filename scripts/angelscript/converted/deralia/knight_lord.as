#pragma context server

// Converted from deralia/knight_lord.script by msc_transpiler.
// Thothie - Moved to New AI 8/Sep/2006 10:21
// Lord of Deralia

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_monster_new.as"
#include "converted/monsters/base_guard_friendly_new.as"

[script "deralia/knight_lord"]
class KnightLord : BaseMonsterNewScript, BaseGuardFriendlyNew
{
	// Constants
	string SOUND_STRUCK1 = "body/armour1.wav";
	string SOUND_STRUCK2 = "body/armour2.wav";
	string SOUND_STRUCK3 = "body/armour3.wav";
	string SOUND_WARCRY = "voices/human/male_guard_dismiss.wav";
	string SOUND_ATTACK = "weapons/swingsmall.wav";
	string SOUND_PAIN = "voices/human/male_hit1.wav";
	string SOUND_IDLE = "voices/human/male_idle2.wav";
	string ATTACK_HITCHANCE = "90%";
	string ATTACK_DAMAGE = "45";
	string ATTACK_STUNCHANCE = "50%";
	int FLEE_HEALTH = 15;
	string FLEE_CHANCE = "5%";
	bool BG_NO_GO_HOME = true;
	int BG_ROAM = 1;
	int BG_MAX_HEAR_CIV = 32000;
	bool NO_CHAT = true;

	// Variables (an unset .script variable reads as its own name)
	string ANIM_ATTACK = "ANIM_ATTACK";
	int NORMAL_MENU = 0;
	int JOBS_DONE = 0;
	bool GAVE_RING = false;

	// Variables declared by included files, with the value they start with in this script
	KnightLord()
	{
		SOUND_DEATH = "voices/human/male_die.wav";
		ANIM_IDLE = "idle1";
		ANIM_RUN = "run";
		ANIM_WALK = "walk";
	}

	// unnamed block (first think)
	void KnightLord_FirstThink()
	{
		DROP_GOLD = RandomInt(10, 50);
		ANIM_IDLE = "idle1";
		ANIM_RUN = "run";
		ANIM_WALK = "walk";
		ANIM_ATTACK = "swordswing1_L";
		ANIM_DEATH = "dieforward";
		ATTACK_MOVERANGE = 45.0f;
		ATTACK_RANGE = 65.0f;
		ATTACK_HITRANGE = 150.0f;
		NORMAL_MENU = 1;

		JOBS_DONE = 0;

		NO_STEP_ADJ = true;

		// Precache
		// catchspeech say_hail hi hullo greet yo hai hello //Giving it the "standard" catchspeeches
		CatchSpeech("say_hi", "hail", "hi", "j0", "yo", "waddup", "wassup", "gweets", "greet");
		CatchSpeech("say_job", "job", "work");
		CatchSpeech("say_rumor", "rumour", "rumor");
	}

	// unnamed block (timer)
	// Idling
	void KnightLord_Timer()
	{
		CallEventDelayed(10.0f, "KnightLord_Timer");
		if (IS_HUNTING)
			return;
		PlaySound(0, 10, SOUND_IDLE);
	}

	// game_dodamage
	// 1: Attack Hit (1/0)  2: Entity Attack hit  3:  Start Origin  4:  End Origin
	string KnightLord_OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";

		if (!hit)
			return result;
		if (RandomInt(1, 100) <= Float(ATTACK_STUNCHANCE))
			ApplyEffect(ENT_LASTSTRUCKBYME, "effects/debuff_stun", 3, self);
		return result;
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseNpcAttackNew_OnNpcSpawn(npc); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck
		BaseGuardFriendlyNew_OnNpcSpawn(npc); // monsters/base_guard_friendly_new

		SetUniqueName("knight_lord");

		SetMenuAutoOpen(true);

		SetHealth(800);
		SetGold(DROP_GOLD);
		SetWidth(32);
		SetHeight(72);
		SetRace("hguard");
		SetName("Lord of the land");
		SetRoam(true);
		SetHearingSensitivity(10);
		NPC_GIVE_EXP = 100.0f;
		SetDamageTaken("all", 0.4f);
		SetMoveSpeed(1);

		SetBlood("red");

		SetModel("npc/guard2.mdl");
		SetModelBody(1, 0);
		SetIdleAnim(ANIM_IDLE);
		SetMoveAnim(ANIM_WALK);

		// setactionanim   swordswing1_L
		GiveItem("ring_light2");
	}

	// game_dodamage
	string OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";
		result = AppendResult(result, BaseNpcAttackNew_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BaseAntiStuck_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BaseMonsterShared_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, KnightLord_OnGameDodamage(hit, target, start, end, damageType, damageText));
		return result;
	}

	// baseguard_tobattle
	// called from base_guard_friendly
	void OnBaseguardTobattle(CBaseEntity@ enemy = null)
	{
		BaseGuardFriendlyNew_OnBaseguardTobattle(enemy); // monsters/base_guard_friendly_new

		PlaySound(0, 10, SOUND_WARCRY);
	}

	// say_hail
	void OnSayHail()
	{
		int rand = RandomInt(0, 1);

		if (rand == 0)
			SayText("Well met, adventurer.");
		else if (rand == 1)
			SayText("How do you do?");
	}

	// say_rumor
	void OnSayRumor(CBasePlayer@ talkingPlayer = null)
	{
		int rand = RandomInt(0, 2);

		if (rand == 0)
		{
			SayText("Cathlain seems to be losing guards in the sewers... perhaps he could use some help.");
		}
		else if (rand == 1)
		{
			SayText("Master Proffund likes gambling too much. Hopefully he doesn't get in trouble with the wrong people.");
		}
		else if (rand == 2)
		{
			SayText("I recently stored one of Thordac's weapons in Galat's Wondrous Chest of Storage, but it was gone when I went to retrieve it...");
			SayText("Guilda wasn't very helpful when trying to figure out where it went.");
		}
	}

	// say_job
	void OnSayJob(CBasePlayer@ player = null)
	{
		if (JOBS_DONE == 0)
		{
			SayText("I have been looking for a sneaky pick pocket, who has been troubling the townsfolk.");
			SayText("If you spot him, do try to apprehend him, as I am also quite busy with other matters.");
			SayText("Do not worry, for you will be generously rewarded for your actions.");
		}

		if (JOBS_DONE == 0)
			return;
		SayText("I am afraid that, at the moment, I've no other tasks for good samaritans such as yourself.");
	}

	// say_jail
	void OnSayJail()
	{
		SetRoam(false);
		SetMoveDest(@FindByName("thief"));
		SetMoveAnim(ANIM_IDLE);
		SayText("You shall be taken away and locked behind bars, thief!");
		string questCompleter = NameOf(GetVar("APPREHENDER"));
		SayText(questCompleter + " , you have done well.");
		SayText("Please accept this ring as a token of my gratitude.");
		SayText("May it bring light in even the darkest of dungeons and caves.");
		CallExternal(FindByName("thief"), "quest_done");
		JOBS_DONE = 1;
		NORMAL_MENU = 0;
		OpenMenu(GetVar("APPREHENDER"));
		CallEventDelayed(10.0f, "resume_roam");
	}

	// offer_ring
	void OnOfferRing()
	{
		Offer(GetVar("APPREHENDER"), "ring_light2");
		NORMAL_MENU = 1;
		GAVE_RING = true;
	}

	// game_menu_cancel
	void OnGameMenuCancel(CBasePlayer@ player = null)
	{
		int rand = RandomInt(0, 1);

		if (rand == 0)
			SayText("Very well then.");
		else if (rand == 1)
			SayText("As you were.");

		NORMAL_MENU = 1;
	}

	// game_menu_getoptions
	void OnGameMenuGetoptions(CBasePlayer@ player = null)
	{
		MenuItem menuItem;

		if (NORMAL_MENU == 1)
		{
			menuItem.title = "Hail";
			menuItem.type = "callback";
			menuItem.callback = "say_hail";
			RegisterMenuItem(menuItem);

			menuItem.title = "Ask about Rumors";
			menuItem.type = "callback";
			menuItem.callback = "say_rumor";
			RegisterMenuItem(menuItem);

			menuItem.title = "Ask about Jobs";
			menuItem.type = "callback";
			menuItem.callback = "say_job";
			RegisterMenuItem(menuItem);
		}

		if (JOBS_DONE == 1 && !GAVE_RING)
		{
			menuItem.title = "Accept";
			menuItem.type = "callback";
			menuItem.callback = "offer_ring";
			RegisterMenuItem(menuItem);
		}
	}

	// resume_roam
	void OnResumeRoam()
	{
		SetRoam(true);
		SetMoveAnim(ANIM_WALK);
	}

	// attack_1
	void OnAttack12()
	{
		PlaySound(0, 10, SOUND_ATTACK);
		OnNpcatkDodamage(NPCATK_TARGET, Text(ATTACK_HITRANGE), ATTACK_DAMAGE, ATTACK_HITCHANCE);
	}

	// npc_struck
	void OnNpcStruck(float damage = 0.0f)
	{
		PlayRandomSound(0, 8, SOUND_STRUCK1, SOUND_STRUCK2, SOUND_STRUCK3, SOUND_STRUCK1, SOUND_PAIN);
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files

	// game_struck
	void OnGameStruck(float damage = 0.0f, string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		BaseNpc_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseNpcAttackNew_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc_attack_new
		BaseMonsterShared_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared
		BaseGuardFriendlyNew_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_guard_friendly_new
	}

	// npcatk_setmovedest
	void OnNpcatkSetmovedest(string destination = "", string range = "")
	{
		BaseNpcAttackNew_OnNpcatkSetmovedest(destination, range); // monsters/base_npc_attack_new
		BaseAntiStuck_OnNpcatkSetmovedest(destination, range); // monsters/base_anti_stuck
	}

	// npcatk_settarget
	void OnNpcatkSettarget(string target = "", string debug = "")
	{
		BaseNpcAttackNew_OnNpcatkSettarget(target, debug); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcatkSettarget(target, debug); // monsters/base_monster_shared
	}

	// npcatk_targetvalidate
	void OnNpcatkTargetvalidate(string target = "")
	{
		BaseNpcAttackNew_OnNpcatkTargetvalidate(target); // monsters/base_npc_attack_new
		BaseGuardFriendlyNew_OnNpcatkTargetvalidate(target); // monsters/base_guard_friendly_new
	}

	// npcatk_clear_targets
	void OnNpcatkClearTargets(string reason = "")
	{
		BaseNpcAttackNew_OnNpcatkClearTargets(reason); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcatkClearTargets(reason); // monsters/base_monster_shared
		BaseMonsterShared_OnNpcatkClearTargets_2(reason); // monsters/base_monster_shared
		BaseGuardFriendlyNew_OnNpcatkClearTargets(reason); // monsters/base_guard_friendly_new
	}

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("npc/guard2.mdl");
		CallEventDelayed(10.0f, "KnightLord_Timer");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		KnightLord_FirstThink();
		BaseNpc_FirstThink();
		MonstersExternals_FirstThink();
		BaseNpcAttackNew_FirstThink();
		BaseMonsterShared_FirstThink();
		BaseGuardFriendlyNew_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "attack_1") { OnAttack12(); return true; }
		if (name == "baseguard_tobattle") { OnBaseguardTobattle(EntityParam(params, 0)); return true; }
		if (name == "game_dodamage") { Return(OnGameDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5))); return true; }
		if (name == "game_menu_cancel") { OnGameMenuCancel(PlayerParam(params, 0)); return true; }
		if (name == "game_menu_getoptions") { OnGameMenuGetoptions(PlayerParam(params, 0)); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "npc_struck") { OnNpcStruck(Float(Param(params, 0))); return true; }
		if (name == "offer_ring") { OnOfferRing(); return true; }
		if (name == "resume_roam") { OnResumeRoam(); return true; }
		if (name == "say_hail") { OnSayHail(); return true; }
		if (name == "say_jail") { OnSayJail(); return true; }
		if (name == "say_job") { OnSayJob(PlayerParam(params, 0)); return true; }
		if (name == "say_rumor") { OnSayRumor(PlayerParam(params, 0)); return true; }
		if (name == "KnightLord_Timer") { KnightLord_Timer(); return true; }
		return BaseGuardFriendlyNew_DispatchEvent(name, params)
			|| BaseMonsterNewScript::DispatchEvent(name, params);
	}
}
