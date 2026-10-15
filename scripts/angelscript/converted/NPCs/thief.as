#pragma context server

// Converted from NPCs/thief.script by msc_transpiler.
// *** Default human script ***
// Spawn properties

#include "runtime/ScriptEntity.as"

[script "NPCs/thief"]
class NPCsThief : ScriptEntity
{
	// Variables (an unset .script variable reads as its own name)
	float ATTACK_RANGE = 90.0f;
	string ATTACK1_DAMAGE = "5";
	string ATTACK_PERCENTAGE = "60%";
	int THIEF = 0;
	bool STEAL = false;
	int FLEE_HEALTH = 40;
	string FLEE_CHANCE = "100%";
	bool IS_FLEEING = false;
	int STEALING = 0;
	float gold = 0.0f;
	string CURRENT_ENEMY = "ent_laststole";
	bool SEE_ENEMY = true;

	// unnamed block (timer)
	// Greet player and other NPCs
	void NPCsThief_Timer()
	{
		// repeatdelay: How soon this event can be repeated.
		CallEventDelayed(4.0f, "NPCsThief_Timer");
		// (always true here) see enemy 128

		// Face ally
		SetMoveDest(ENT_LASTSEEN, 128);

		// Action: Say hello
		// Volume min-max: 0-10
		if ((STEAL ? 1 : 0) != 0)
			return;
		STEALING = RandomInt(-40, -20);
		Offer(ENT_LASTSEEN, gold, STEALING);
		gold += STEALING;
		PlayAnim("once", "return_needle");
		SetRoam(false);
		CallEventDelayed(0.0f, "4");
	}

	// unnamed block (first think)
	// Action: Say hello
	// Volume min-max: 0-10
	void NPCsThief_FirstThink()
	{
		if ((STEAL ? 1 : 0) != 1)
			return;
		SetVolume(8);
		Say("hello1[50]", "*[20]", "*[55]", "*[55]", "*[23]", "*[22]");
		SetRoam(false);
		CallEventDelayed(0.0f, "4");
	}

	// unnamed block (timer)
	// Hunting
	void NPCsThief_Timer2()
	{
		CallEventDelayed(0.2f, "NPCsThief_Timer2");

		if (!Truthy(CURRENT_ENEMY))
			return;

		SetMoveAnim("run");
		SetMoveDest(ENT_LASTSEEN, ATTACK_RANGE);
		SEE_ENEMY = true;
	}

	// unnamed block (timer)
	// Attack
	void NPCsThief_Timer3()
	{
		CallEventDelayed(0.3f, "NPCsThief_Timer3");

		SetMoveDest(ENT_LASTSEEN, 9999);
		PlayAnim("once", "beatdoor");
	}

	// say_gold
	// Thief Quest, Step 1
	void NPCsThief_OnSayGold()
	{
		if (THIEF != 0)
			return;
		THIEF = 1;
		SayText("I don't know what you're talking about.");
	}

	// say_gold
	// After he've given away the map
	void NPCsThief_OnSayGold_2()
	{
		if (THIEF != 3)
			return;
		SayText("Go away.");
	}

	// spawn
	void OnSpawn()
	{
		SetHealth(45); // Start with 45 of 45 max hit points
		SetGold(10); // Start with 10 gold
		// ov 180
		SetWidth(32);
		SetHeight(72);
		SetRace("orc");
		SetName("Shifty Person");
		SetRoam(true); // Roam freely
		SetModel("npc/human1.mdl");
		SetDamageTaken("all", 0.9f);
		SetModelBody(0, 1);
		SetModelBody(1, 5);
		SetMoveAnim("walk");
		ATTACK_RANGE = 90.0f;
		ATTACK1_DAMAGE = "5";
		ATTACK_PERCENTAGE = "60%";

		THIEF = 0;
		STEAL = false;

		FLEE_HEALTH = 40;
		FLEE_CHANCE = "100%";
		IS_FLEEING = false;

		CatchSpeech("say_gold", gold);
		CatchSpeech("say_gold", "money");
		CatchSpeech("say_gold", "thief");
		CatchSpeech("say_gold", "bandit");
		CatchSpeech("say_gold", "back");

		CatchSpeech("say_gold2", gold);
		CatchSpeech("say_gold2", "money");
		CatchSpeech("say_gold2", "thief");
		CatchSpeech("say_gold2", "bandit");
		CatchSpeech("say_gold2", "back");

		CatchSpeech("say_thief", "lock");
		CatchSpeech("say_thief", "kill");
		CatchSpeech("say_thief", "execute");
		CatchSpeech("say_thief", "execution");
		CatchSpeech("say_thief", "prison");
	}

	// resumeroam
	void OnResumeroam()
	{
		SetRoam(true);
	}

	// robbed
	// -- Attack thieves --
	void OnRobbed()
	{
		CURRENT_ENEMY = ENT_LASTSTOLE;

		SayText("Aha! Thief!");
		SetMoveDest(ENT_LASTSTOLE, 9999);
	}

	// wander
	void OnWander()
	{
		SetMoveAnim("walk");
		SEE_ENEMY = false;
		CallEventDelayed(0.0f, "12");
	}

	// losethief
	void OnLosethief()
	{
		CURRENT_ENEMY = "noenemy";
	}

	// attack_1
	void OnAttack12()
	{
		// Deal damage
		DoDamage(ENT_LASTSEEN, ATTACK_RANGE, ATTACK1_DAMAGE, ATTACK_PERCENTAGE);
	}

	// struck
	void OnStruck()
	{
		// Chance of fleeing if hit
		if (!(0.0f <= FLEE_HEALTH))
			return;
		if (!(RandomInt(0, 100) <= Float(FLEE_CHANCE)))
			return;

		SetMoveAnim("run");
		SetMoveDest("flee", ENT_LASTSTRUCK, 600);
		IS_FLEEING = true;
		CallEventDelayed(0.0f, "0.5");
	}

	// say_gold
	void OnSayGold()
	{
		NPCsThief_OnSayGold();
		NPCsThief_OnSayGold_2();
	}

	// say_gold2
	// After being bothered once again
	void OnSayGold2()
	{
		if (THIEF != 1)
			return;
		THIEF = 2;
		SayText("Look, I don't know what you're talking about. With guards around, nobody would dare to steal.");
	}

	// say_thief
	// After spoken to Tristan and told to investigate the whole thief thing
	void OnSayThief()
	{
		if (THIEF != 2)
			return;
		THIEF = 3;
		STEAL = true;
		SayText("Oh... he told you that, did he? Look, if you don't report me, I'll give you this.");
		CallEventDelayed(0.0f, "4");
	}

	// say_thief2
	void OnSayThief2()
	{
		SayText("It's a map of where the band is. I'm just a nobody among those. If you want to catch real thieves, go for them, not me.");
		Offer(ENT_LASTSPOKE, "item_thiefmap");
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("npc/human1.mdl");
		Precache("npc/hello1.wav");
		CallEventDelayed(4.0f, "NPCsThief_Timer");
		CallEventDelayed(0.2f, "NPCsThief_Timer2");
		CallEventDelayed(0.3f, "NPCsThief_Timer3");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		NPCsThief_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "attack_1") { OnAttack12(); return true; }
		if (name == "losethief") { OnLosethief(); return true; }
		if (name == "resumeroam") { OnResumeroam(); return true; }
		if (name == "robbed") { OnRobbed(); return true; }
		if (name == "say_gold") { OnSayGold(); return true; }
		if (name == "say_gold2") { OnSayGold2(); return true; }
		if (name == "say_thief") { OnSayThief(); return true; }
		if (name == "say_thief2") { OnSayThief2(); return true; }
		if (name == "spawn") { OnSpawn(); return true; }
		if (name == "struck") { OnStruck(); return true; }
		if (name == "wander") { OnWander(); return true; }
		if (name == "NPCsThief_Timer") { NPCsThief_Timer(); return true; }
		if (name == "NPCsThief_Timer2") { NPCsThief_Timer2(); return true; }
		if (name == "NPCsThief_Timer3") { NPCsThief_Timer3(); return true; }
		return false;
	}
}
