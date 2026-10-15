#pragma context server

// Converted from edana/mayorguard.script by msc_transpiler.
// Mayor's Guard

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_npc.as"
#include "converted/monsters/base_xmass.as"

[script "edana/mayorguard"]
class Mayorguard : BaseNpcScript, BaseXmass
{
	// Constants
	string ATTACK1_DAMAGE = "30";
	bool NO_RUMOR = true;
	int HEAR_RANGE = 100;
	bool NPC_REACTS = true;

	// Variables (an unset .script variable reads as its own name)
	string ANIM_ATTACK = "ANIM_ATTACK";
	int EVIDENCE_FOUND = 0;
	int BRIBED = 0;
	int THIEF_1 = 5;
	bool SHOW_APPLE = false;

	// unnamed block (first think)
	void Mayorguard_FirstThink()
	{
		ANIM_ATTACK = "swordswing1_L";
		ATTACK_RANGE = 128.0f;
	}

	// say_thief
	// Thief Quest, part 2
	void Mayorguard_OnSayThief()
	{
		if (THIEF_1 != 5)
			return;
		THIEF_1 = 6;
		PlaySound(Int(GetVar("CHAN_VOICE")), "npc/suspicious.wav");
		SayText("If you see anything suspicious around here, you let me know.");
	}

	// say_thief
	// After telling him about thieves one second time
	void Mayorguard_OnSayThief_2()
	{
		if (THIEF_1 != 6)
			return;
		THIEF_1 = 7;
		SayText("If you see any thieves, try bribing them for information, or give threats that I will lock them up for good.");
		CallEventDelayed(0.0f, "4");
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		SetUniqueName("mayorguard");
		SetHealth(1);
		SetName("Mayor's Guard");
		// ov			180
		SetWidth(32);
		SetHeight(72);
		SetRace("beloved");
		SetRoam(false);
		SetModel("npc/guard1.mdl");
		SetInvincible(true);

		EVIDENCE_FOUND = 0;
		BRIBED = 0;
		THIEF_1 = 5;
		SHOW_APPLE = false;
		SetMenuAutoOpen(true);

		CatchSpeech("say_hi", "hi", "hello", "hail", "greet");
		CatchSpeech("say_mayor", "mayor");
		CatchSpeech("say_thief", "thief", "theives", "bandit", "catpurse", "poacher");
		CatchSpeech("say_job", "job", "work", "quest");
		CatchSpeech("say_name", "name");
	}

	// say_name
	void OnSayName()
	{
		PlaySound(Int(Eval("game.sound.voice")), 9, "npc/hello1.wav");
		SetName("Dorian");
		SayText("My name is Dorian.");
	}

	// say_hi
	// //// Greets ///////
	void OnSayHi(CBasePlayer@ talkingPlayer = null)
	{
		if (BRIBED != 0)
			return;
		if (!(DistanceTo(ENT_LASTSPOKE) <= HEAR_RANGE)) // Range check, cuz I'm so close to the blacksmith
			return;

		PlaySound(Int(Eval("game.sound.voice")), 7, "npc/edrin1.wav");
		SayText("If you do not have business with the mayor, be on your way.");
	}

	// say_mayor
	void OnSayMayor()
	{
		if (BRIBED == 0 && EVIDENCE_FOUND == 0)
		{
			SayText("He is much too busy for the likes of you, move on!");
			PlayAnim("once", "no");
		}
		if (EVIDENCE_FOUND == 1)
		{
			SayText("The house is going to be locked until a new mayor is found");
			PlayAnim("once", "no");
		}
	}

	// npcreact_targetsighted
	void OnNpcreactTargetsighted(CBaseEntity@ player = null)
	{
		if (BRIBED != 0)
			return;
		SayText("Halt! What is your business?");
		PlayAnim("once", "pushbutton2");
	}

	// give_apple
	// /////////// Bribe /////////////
	void OnGiveApple()
	{
		if (EVIDENCE_FOUND != 0)
			return;

		ReceiveOffer("accept");
		SayText("A delicious treat, proceed traveller");
		UseTrigger("mayorsdoor");
		BRIBED = 1;
	}

	// give_map
	void OnGiveMap()
	{
		if (THIEF_1 != 7)
			return;

		ReceiveOffer("accept");
		PlayAnim("once", "return_needle");
		SayText("Ah, what's this? A map of the thieves whereabouts? You have done well, my friend.");
		CallEventDelayed(4.0f, "say_thiefloc");
	}

	// bribe
	void OnBribe()
	{
		ReceiveOffer("accept");
		SayText("*whispering* Thank you, traveller. Proceed.");
		PlayAnim("once", "lean");
		UseTrigger("mayorsdoor");
		BRIBED = 1;
	}

	// bribe_failed
	void OnBribeFailed()
	{
		SayText("You call that a bribe? HA! If you offer 500, give me 500!");
		PlayAnim("once", "no");
	}

	// attack_1
	void OnAttack12()
	{
		DoDamage(ENT_LASTSTOLE, ATTACK_RANGE, ATTACK1_DAMAGE, "ATTACK_PERCENTAGE");
	}

	// say_job
	void OnSayJob(CBasePlayer@ player = null)
	{
		if (!(DistanceTo(ENT_LASTSPOKE) <= HEAR_RANGE)) // Range check, cuz I'm so close to the blacksmith
			return;

		SayText("What, do I look like a tourguide? My job is to protect the mayor, now leave!");
		PlayAnim("once", "no");
	}

	// say_thief
	void OnSayThief()
	{
		Mayorguard_OnSayThief();
		Mayorguard_OnSayThief_2();
	}

	// say_thief2
	void OnSayThief2()
	{
		SayText("Aye, I will have them thieves locked up, if not killed should I get my hands on them.");
	}

	// say_thiefloc
	// After getting map
	void OnSayThiefloc()
	{
		SayText("Hmmmm... this map shows bandits in a few of the local areas, one being in the Thornlands.");
		CallEventDelayed(4.0f, "say_thiefloc2");
	}

	// say_thiefloc2
	void OnSayThiefloc2()
	{
		SayText("There will probably be thieves around the area. If not, look in the caves near the road to Edana.");
		CallEventDelayed(4.0f, "say_thiefloc3");
	}

	// say_thiefloc3
	void OnSayThiefloc3()
	{
		SayText("Bring me proof that you've killed them and I'll reward you, if not killing them is reward enough.");
		CallEventDelayed(4.0f, "say_thiefloc4");
	}

	// say_thiefloc4
	void OnSayThiefloc4()
	{
		SetVolume(8);
		Say("guardwarn");
		SayText("Be wary, it is dangerous outside.");
	}

	// worldevent_evidence_found
	void OnWorldeventEvidenceFound()
	{
		EVIDENCE_FOUND = 1;
	}

	// game_menu_getoptions
	void OnGameMenuGetoptions(CBasePlayer@ player = null)
	{
		MenuItem menuItem;

		if (EVIDENCE_FOUND != 0)
			return;

		if (Truthy(ItemExists(player, "health_apple")))
		{
			menuItem.title = "Bribe with apple";
			menuItem.type = "payment";
			menuItem.data = "health_apple";
			menuItem.callback = "give_apple";
			RegisterMenuItem(menuItem);
		}

		menuItem.title = "Bribe (500g)";
		menuItem.type = "payment";
		menuItem.data = "gold:500";
		menuItem.callback = "bribe";
		menuItem.cb_failed = "bribe_failed";
		RegisterMenuItem(menuItem);
	}

	// bryan_said_so
	void OnBryanSaidSo()
	{
		SHOW_APPLE = true;
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseNpc_OnGameSpawn(playerRace, playerGender); // monsters/base_npc
		BaseXmass_OnGameSpawn(playerRace, playerGender); // monsters/base_xmass
	}

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("npc/guard1.mdl");
		Precache("npc/guardwarn.wav");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		Mayorguard_FirstThink();
		BaseNpc_FirstThink();
		MonstersExternals_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "attack_1") { OnAttack12(); return true; }
		if (name == "bribe") { OnBribe(); return true; }
		if (name == "bribe_failed") { OnBribeFailed(); return true; }
		if (name == "bryan_said_so") { OnBryanSaidSo(); return true; }
		if (name == "game_menu_getoptions") { OnGameMenuGetoptions(PlayerParam(params, 0)); return true; }
		if (name == "give_apple") { OnGiveApple(); return true; }
		if (name == "give_map") { OnGiveMap(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "npcreact_targetsighted") { OnNpcreactTargetsighted(EntityParam(params, 0)); return true; }
		if (name == "say_hi") { OnSayHi(PlayerParam(params, 0)); return true; }
		if (name == "say_job") { OnSayJob(PlayerParam(params, 0)); return true; }
		if (name == "say_mayor") { OnSayMayor(); return true; }
		if (name == "say_name") { OnSayName(); return true; }
		if (name == "say_thief") { OnSayThief(); return true; }
		if (name == "say_thief2") { OnSayThief2(); return true; }
		if (name == "say_thiefloc") { OnSayThiefloc(); return true; }
		if (name == "say_thiefloc2") { OnSayThiefloc2(); return true; }
		if (name == "say_thiefloc3") { OnSayThiefloc3(); return true; }
		if (name == "say_thiefloc4") { OnSayThiefloc4(); return true; }
		if (name == "worldevent_evidence_found") { OnWorldeventEvidenceFound(); return true; }
		return BaseXmass_DispatchEvent(name, params)
			|| BaseNpcScript::DispatchEvent(name, params);
	}
}
