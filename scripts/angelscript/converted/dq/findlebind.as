#pragma context server

// Converted from dq/findlebind.script by msc_transpiler.
// Spawn properties

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_npc.as"
#include "converted/monsters/base_chat.as"

[script "dq/findlebind"]
class Findlebind : BaseNpcScript, BaseChat
{
	// Constants
	string ANIM_DIEING = "c1a4_wounded_idle";
	string ANIM_DEAD = "dead_sitting";
	string SOUND_COUGH = "scientist/cough.wav";

	// Variables (an unset .script variable reads as its own name)
	float BRAP_DELAY = 3.5f;
	string ANIM_DEATH_SPEECH = "ANIM_DEATH_SPEECH";
	bool NO_JOB = false;
	bool NO_RUMOR = false;
	int CANCHAT = 1;
	bool GAVE_JOB = false;
	string QUEST_WINNER = "QUEST_WINNER";
	bool RECIEVED_CLAW = false;
	bool NO_HAIL = false;
	bool QUEST2_AVAILABLE = false;
	string QUEST_PLAYER = "QUEST_PLAYER";
	bool MENTIONED_PRIESTESS = false;
	bool I_R_DIEING = false;
	CBaseEntity@ TARGET_PLAYER = null;
	bool FOUND_WORTHY = false;
	float SAYSTEP_ELF = 0.0f;
	bool BEAR_DEAD = false;

	// Variables declared by included files, with the value they start with in this script
	Findlebind()
	{
		SOUND_DEATH = "scientist/sci_die1.wav";
	}

	// unnamed block (first think)
	void Findlebind_FirstThink()
	{
		ANIM_DEATH_SPEECH = "c1a4_dying_speech";

		BRAP_DELAY = 3.5f; // Chat delay is a const in an included script, so I changed it. -greatguys1 SEP2021

		NO_JOB = true;
		NO_RUMOR = true;
	}

	// game_menu_getoptions
	void OnGameMenuGetoptions(CBasePlayer@ player = null)
	{
		BaseChat_OnGameMenuGetoptions(player); // monsters/base_chat
		MenuItem menuItem;
		bool hasKey = false;

		if (I_R_DIEING)
			return;

		SetMoveDest(OriginOf(player), 9999);

		if (!RECIEVED_CLAW && BEAR_DEAD && Truthy(ItemExists(player, "item_bearclaw")))
		{
			menuItem.title = "Offer the Bear Claw";
			menuItem.type = "payment"; // _silent means don't say what's missing (also crashes)
			menuItem.data = "item_bearclaw";
			menuItem.callback = "gave_claw";
			RegisterMenuItem(menuItem);
		}

		if (!BEAR_DEAD && !QUEST2_AVAILABLE && GAVE_JOB)
		{
			menuItem.title = "Jobs";
			menuItem.type = "callback";
			menuItem.callback = "say_job";
			RegisterMenuItem(menuItem);
		}

		if (QUEST2_AVAILABLE)
		{
			if (Truthy(ItemExists(QUEST_PLAYER, "key_red")))
				hasKey = true;
			if (Truthy(ItemExists(player, "key_red")))
				hasKey = true;
			if (!hasKey)
				menuItem.title = "Another job?";
			else
				menuItem.title = "Where is Slithar?";
			menuItem.type = "callback";
			menuItem.callback = "say_job";
			RegisterMenuItem(menuItem);

			if (MENTIONED_PRIESTESS)
			{
				menuItem.title = "A preistess?";
				menuItem.type = "callback";
				menuItem.callback = "say_priest";
				RegisterMenuItem(menuItem);
			}
		}

		menuItem.title = "What's that large gate?";
		menuItem.type = "callback";
		menuItem.callback = "say_rumor";
		RegisterMenuItem(menuItem);

		menuItem.title = "You're an elf!";
		menuItem.type = "callback";
		menuItem.callback = "elf_joke";
		RegisterMenuItem(menuItem);
	}

	// say_rumor
	void OnSayRumor(CBasePlayer@ talkingPlayer = null)
	{
		BaseChat_OnSayRumor(talkingPlayer); // monsters/base_chat

		if (talkingPlayer is null)
			SetMoveDest(OriginOf(ENT_LASTSPOKE), 9999);

		SayText("That mine door has been sealed, though it once lead to the ruins of Melanion, our ancient elven capital.");
		PlayAnim("once", "lean");
		Say("[.3]", "[.1]", "[.3]", "[.2]", "[.1]", "[.3]");
		PlaySound(0, 10, "voices/bloodrose/findlebind/that_mine_door_is_sealed.wav");
		BRAP_DELAY = 6.0f;
		CallEventDelayed(BRAP_DELAY, "say_door2");
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		SetUniqueName("npc_findlebind");

		SetHealth(25);
		SetGold(25);
		SetName("Findlebind Goodheart");
		// fov 30
		SetWidth(32);
		SetHeight(72);
		SetRace("beloved");
		SetRoam(false); // Don't go roaming around
		SetModel("npc/elf1.mdl");
		SetInvincible(true);
		CANCHAT = 1;
		SetHearingSensitivity(6);

		CatchSpeech("say_hi", "hail", "hi", "hello", "j0", "wassup", "wazzup", "greet", "job", "gweets");
		CatchSpeech("say_rumor", "door", "melanion", "mine", "rumor");
		CatchSpeech("say_job", "job", "what", "yes", "sure", "yah");
		CatchSpeech("say_priest", "priest");
		CatchSpeech("say_elf", "elves", "elf");
	}

	// resetchat
	void OnResetchat()
	{
		CANCHAT = 1;
		CallEventDelayed(0.0f, "10");
	}

	// say_hi
	void OnSayHi(CBasePlayer@ talkingPlayer = null)
	{
		if (RECIEVED_CLAW)
			return;

		if (talkingPlayer is null)
			SetMoveDest(OriginOf(ENT_LASTSPOKE), 9999);

		PlayAnim("once", "converse1");
		SayText("Blessings to ye, adventurer! Would ye care to assist me with a bit of a problem?");
		Say("[.3]", "[.3]", "[.3]", "[.2]", "[.1]", "[.3]");
		PlaySound(0, 10, "voices/bloodrose/findlebind/greeting.wav");
		BRAP_DELAY = 5.1f;
		CallEventDelayed(0.0f, Text(BRAP_DELAY));
	}

	// say_hi2
	void OnSayHi2()
	{
		PlayAnim("once", "castspell");
		SayText("There's this large bear out there. I can't hardly go outside, and he's scared off all the good hunting!");
		Say("[.3]", "[.3]", "[.3]", "[.2]", "[.1]", "[.3]");
		UseTrigger("make_bear");
		PlaySound(0, 10, "voices/bloodrose/findlebind/theres_this_large_bear.wav");
		BRAP_DELAY = 5.7f;
		CallEventDelayed(0.0f, Text(BRAP_DELAY));
	}

	// say_hi3
	void OnSayHi3()
	{
		PlayAnim("once", "fear1");
		SayText("Aye! A kodiak, believe it or not! Bring me proof of its death, and I shall reward ye!");
		Say("[.3]", "[.3]", "[.3]", "[.2]", "[.1]", "[.3]");
		PlaySound(0, 10, "voices/bloodrose/findlebind/aye_a_kodiak.wav");
		GAVE_JOB = true;
	}

	// gave_claw
	void OnGaveClaw(CBasePlayer@ winner = null)
	{
		QUEST_WINNER = EntityId(winner);
		RECIEVED_CLAW = true;
		NO_HAIL = true;
		PlayAnim("once", "pondering");
		SayText("Wow! You actually killed it! ...and here I feared you'd only keep its belly full...");
		Say("[.1]", "[.2]", "[.3]", "[.2]", "[.1]", "[.3]");
		PlaySound(0, 10, "voices/bloodrose/findlebind/you_actually_killed_it.wav");
		BRAP_DELAY = 4.8f;
		CallEventDelayed(BRAP_DELAY, "gave_claw2");
	}

	// gave_claw2
	void OnGaveClaw2()
	{
		SayText("I suppose you've earned a reward for that...");
		Say("[.3]", "[.1]", "[.3]");
		PlaySound(0, 10, "voices/bloodrose/findlebind/i_suppose_youve.wav");
		BRAP_DELAY = 2.6f;
		CallEventDelayed(BRAP_DELAY, "gave_claw3");
	}

	// gave_claw3
	void OnGaveClaw3()
	{
		// local REWARD_TYPE $rand(1,100)
		// if ( REWARD_TYPE <= 10 )
		// {
		// healscroll
		// saytext I can't use this thing, but you look like ya know more than I.
		// offer QUEST_WINNER scroll2_acid_xolt
		// }
		SayText("Here... It's not as if I get to town often enough to spend this.");
		Say("[.3]", "[.1]", "[.3]", "[.2]", "[.1]", "[.3]");
		PlaySound(0, 10, "voices/bloodrose/findlebind/heres_a_reward.wav");
		BRAP_DELAY = 3.4f;
		CallEventDelayed(BRAP_DELAY, "offer_quest2");
		Offer(QUEST_WINNER, "gold", 50);
	}

	// say_door2
	void OnSayDoor2()
	{
		SayText("Kray Eldorad was later built upon its ruins... Those poor fools...");
		Say("[.3]", "[.1]", "[.3]", "[.2]", "[.1]", "[.3]");
		PlaySound(0, 10, "voices/bloodrose/findlebind/kray_eldorad.wav");
		BRAP_DELAY = 4.1f;
		CallEventDelayed(BRAP_DELAY, "say_door3");
	}

	// say_door3
	void OnSayDoor3()
	{
		PlayAnim("once", "panic");
		SayText("Beneath that veneer of elven paradise, lurk monsters that you cannot even imagine!");
		Say("[.3]", "[.1]", "[.3]", "[.2]", "[.1]", "[.3]");
		PlaySound(0, 10, "voices/bloodrose/findlebind/beneath_that_veneer.wav");
		BRAP_DELAY = 6.0f;
		CallEventDelayed(BRAP_DELAY, "say_door4");
	}

	// say_door4
	void OnSayDoor4()
	{
		SayText("That's why *I* live HERE! At least here, the horrors don't hide under your feet.");
		PlaySound(0, 10, "voices/bloodrose/findlebind/thats_why_i_live_here.wav");
		// setvard BRAP_DELAY 5.5
		Say("[.3]", "[.1]", "[.3]", "[.2]", "[.1]", "[.3]");
	}

	// offer_quest2
	void OnOfferQuest2()
	{
		PlayAnim("once", "lean");
		SayText("I... Have another job you could do for me... But it won't be nearly so easy.");
		Say("[.1]", "[.2]", "[.3]", "[.1]", "[.1]", "[.3]");
		PlaySound(0, 10, "voices/bloodrose/findlebind/i_have_another_job.wav");
		BRAP_DELAY = 5.5f;
		QUEST2_AVAILABLE = true;
	}

	// say_job
	void OnSayJob(CBasePlayer@ player = null)
	{
		bool exitSub = false;

		if (player is null)
			SetMoveDest(OriginOf(ENT_LASTSPOKE), 9999);

		if (!QUEST2_AVAILABLE)
		{
			SayText("That bear won't know what hit it, thanks!");
			PlaySound(0, 10, "voices/bloodrose/findlebind/that_bear_wont_know.wav");
		}

		if (!QUEST2_AVAILABLE)
			return;

		QUEST_PLAYER = EntityId(player);
		if (QUEST_PLAYER.isEmpty())
			QUEST_PLAYER = EntityId(EntityOf(ENT_LASTSPOKE));

		if (Truthy(ItemExists(QUEST_PLAYER, "key_red")))
		{
			SayText("Ah, I see you have the key, now you just have to find his lair!");
			Say("[.3]", "[.1]", "[.3]", "[.2]", "[.1]", "[.3]");
			PlaySound(0, 10, "voices/bloodrose/findlebind/ah_you_have_the_key.wav");
			BRAP_DELAY = 3.5f;
			CallEventDelayed(BRAP_DELAY, "say_lair2");
			exitSub = true;
		}
		if (exitSub)
			return;

		SayText("Well, there's this necromancer that's been causing all this pandemonium in these parts.");
		Say("[.3]", "[.1]", "[.3]", "[.2]", "[.1]", "[.3]");
		PlaySound(0, 10, "voices/bloodrose/findlebind/theres_this_necromancer.wav");
		BRAP_DELAY = 5.2f;
		CallEventDelayed(BRAP_DELAY, "say_job2");
	}

	// say_lair2
	void OnSayLair2()
	{
		SayText("There's a sinister door, up to the north, I'm not sure, but that maybe it.");
		Say("[.1]", "[.2]", "[.3]", "[.1]", "[.1]", "[.3]");
		PlaySound(0, 10, "voices/bloodrose/findlebind/the_sinister_looking_door.wav");
	}

	// say_job2
	void OnSayJob2(string target = "")
	{
		SayText("Rather, it's his apprentice that does all the dirty work, Lord of Snakes... Slithar, I believe.");
		Say("[.1]", "[.2]", "[.3]", "[.1]", "[.1]", "[.3]");
		PlaySound(0, 10, "voices/bloodrose/findlebind/rather_its_his_apprentice.wav");
		BRAP_DELAY = 6.5f;
		CallEventDelayed(BRAP_DELAY, "say_job3");
	}

	// say_job3
	void OnSayJob3()
	{
		SayText("Bring me proof that he has been slain, and I'll grant you something a lot better than pocket change.");
		Say("[.3]", "[.1]", "[.3]", "[.2]", "[.1]", "[.3]");
		PlaySound(0, 10, "voices/bloodrose/findlebind/bring_me_proof.wav");
		BRAP_DELAY = 5.2f;
		CallEventDelayed(BRAP_DELAY, "say_job4");
	}

	// say_job4
	void OnSayJob4()
	{
		if (QUEST_PLAYER.isEmpty())
			QUEST_PLAYER = EntityId(EntityOf(ENT_LASTSPOKE));

		if (MaxHealthOf(QUEST_PLAYER) >= 200.0f)
		{
			PlayAnim("once", "give_shot");
			UseTrigger("key_chest");
			// createitem key_red $relpos(0,40,32)
			MENTIONED_PRIESTESS = true;
			SayText("I once had a key that, if what the [priestess] said was true, would get you into his lair.");
			Say("[.1]", "[.2]", "[.3]", "[.1]", "[.1]", "[.3]");
			PlaySound(0, 10, "voices/bloodrose/findlebind/i_once_had_a_key.wav");
			BRAP_DELAY = 5.3f;
			CallEventDelayed(BRAP_DELAY, "say_key1");
		}

		if (!(MaxHealthOf(QUEST_PLAYER) < 200.0f))
			return;
		PlayAnim("once", "no");
		SayText("I warn ye though, ye do not look nearly prepared for this, he'd very likely mean be the end of you.");
		Say("[.1]", "[.2]", "[.3]", "[.1]", "[.1]", "[.3]");
		PlaySound(0, 10, "voices/bloodrose/findlebind/player_underprepared.wav");
		BRAP_DELAY = 5.2f;
		CallEventDelayed(BRAP_DELAY, "say_job5");
	}

	// say_key1
	void OnSayKey1()
	{
		SayText("Sadly, I left it behind in a wardrobe, when I had to make a hasty move from the old village.");
		Say("[.3]", "[.2]", "[.1]", "[.1]", "[.2]", "[.3]");
		PlaySound(0, 10, "voices/bloodrose/findlebind/sadly_i_left_it_behind.wav");
		BRAP_DELAY = 4.7f;
		CallEventDelayed(BRAP_DELAY, "say_key3"); // too chatty, skipping ahead abit
	}

	// say_key2
	void OnSayKey2()
	{
		SayText("Finding the key is nothing you can't handle, to be sure, after slaying that bear. But the Snake Lord...");
		Say("[.1]", "[.2]", "[.3]", "[.1]", "[.1]", "[.2]");
		PlaySound(0, 10, "voices/bloodrose/findlebind/finding_the_key.wav");
		BRAP_DELAY = 6.2f;
		CallEventDelayed(BRAP_DELAY, "say_key3");
	}

	// say_key3
	void OnSayKey3()
	{
		SayText("He's turned all the people who were once there into his minions!");
		Say("[.1]", "[.2]", "[.3]", "[.1]");
		PlaySound(0, 10, "voices/bloodrose/findlebind/he_turned_all_the_people.wav");
		BRAP_DELAY = 3.6f;
		CallEventDelayed(BRAP_DELAY, "say_key4");
	}

	// say_key4
	void OnSayKey4()
	{
		SayText("No matter... You may retain anything else you happen to find in that old dresser as well, should you find it of value.");
		Say("[.1]", "[.2]", "[.3]", "[.1]", "[.1]", "[.3]");
		PlaySound(0, 10, "voices/bloodrose/findlebind/no_matter_you_can.wav");
	}

	// say_job5
	void OnSayJob5()
	{
		PlayAnim("once", "retina");
		SayText("I think you should train some more first. I'll grant you the key to his lair when you appear ready.");
		Say("[.1]", "[.2]", "[.3]", "[.1]", "[.1]", "[.3]", "[.1]", "[.1]", "[.3]");
		PlaySound(0, 10, "voices/bloodrose/findlebind/player_underprepared2.wav");
	}

	// say_priest
	void OnSayPriest(CBasePlayer@ speaker = null)
	{
		if (!QUEST2_AVAILABLE)
			return;
		if (speaker is null)
			SetMoveDest(OriginOf(ENT_LASTSPOKE), 9999);
		PlayAnim("once", "yes");
		SayText("A priestess of Felewyn came here a few years back...");
		Say("[.1]", "[.1]", "[.3]");
		PlaySound(0, 10, "voices/bloodrose/findlebind/a_priestess_of_felewyn.wav");
		BRAP_DELAY = 3.2f;
		CallEventDelayed(BRAP_DELAY, "say_priest2");
	}

	// say_priest2
	void OnSayPriest2()
	{
		SayText("She said she was too weak to defeat the Snake Lord and his master, but...");
		Say("[.2]", "[.1]", "[.3]");
		PlaySound(0, 10, "voices/bloodrose/findlebind/she_said_she_was.wav");
		BRAP_DELAY = 4.2f;
		CallEventDelayed(BRAP_DELAY, "say_priest3");
	}

	// say_priest3
	void OnSayPriest3()
	{
		SayText("She also said that I should give that red key to anyone I thought strong enough to try.");
		Say("[.1]", "[.1]", "[.3]", "[.1]", "[.1]", "[.3]");
		PlaySound(0, 10, "voices/bloodrose/findlebind/she_said_i_should_give.wav");
	}

	// slithar_died
	void OnSlitharDied()
	{
		SetMenuAutoOpen(false);
		I_R_DIEING = true;
		NO_RUMOR = true;
		NO_JOB = true;
		NO_HAIL = true;
		SetIdleAnim(ANIM_DIEING);
		SetMoveAnim(ANIM_DIEING);
		PlayAnim("once", ANIM_DIEING);
		CallEventDelayed(0.1f, "scan_for_worthy");
	}

	// game_heardsound
	void OnGameHeardsound(string soundType = "", Vector3 origin = Vector3(), float dangerRadius = 0.0f)
	{
		if (I_R_DIEING && !FOUND_WORTHY && RangeTo(ENT_LASTHEARD) < 256.0f && IsPlayer(ENT_LASTHEARD))
		{
			@TARGET_PLAYER = EntityOf(ENT_LASTHEARD);
			OnFoundPlayer();
		}
		if (I_R_DIEING)
			return;
		SetMoveDest(OriginOf(ENT_LASTHEARD), 9999);
	}

	// scan_for_worthy
	void OnScanForWorthy()
	{
		if (FOUND_WORTHY)
			return;
		if (!(RangeTo(ENT_LASTSEEN) < 256.0f))
			return;
		if (IsPlayer(ENT_LASTSEEN))
		{
			@TARGET_PLAYER = EntityOf(ENT_LASTSEEN);
			OnFoundPlayer();
		}
		CallEventDelayed(0.2f, "scan_for_worthy");
	}

	// found_player
	void OnFoundPlayer()
	{
		if (MaxHealthOf(TARGET_PLAYER) >= 300.0f)
		{
			PlaySound(0, 10, SOUND_COUGH);
			PlayAnim("critical", ANIM_DEATH_SPEECH);
			FOUND_WORTHY = true;
			UseTrigger("findlebind_died");
			SetSayTextRange(2048);
			SayText("*cough* Good! I see you defeated the snake lord! *gasp*");
			Say("[.1]", "[.1]", "[.3]");
			PlaySound(0, 10, "voices/bloodrose/findlebind/you_killed_the_snake_lord.wav");
			BRAP_DELAY = 6.8f;
			CallEventDelayed(BRAP_DELAY, "found_player2");
		}
	}

	// found_player2
	void OnFoundPlayer2()
	{
		SetSayTextRange(2048);
		SayText("Sadly, his master did not take kindly to that. *cough*");
		Say("[.2]", "[.1]", "[.4]");
		PlaySound(0, 10, "voices/bloodrose/findlebind/his_master_didnt_like_that.wav");
		BRAP_DELAY = 6.2f;
		CallEventDelayed(BRAP_DELAY, "found_player3");
	}

	// found_player3
	void OnFoundPlayer3()
	{
		SetSayTextRange(2048);
		SayText("He said, to give you... This...");
		Say("[.1]", "[.1]", "[.3]", "[.1]", "[.1]", "[.3]", "[.1]", "[.1]", "[.4]");
		CreateItem("item_necro_note", RelativePosition(Vector3(20, 40, 32)));
		CreateItem("key_green", RelativePosition(Vector3(20, 40, 32)));
		SetIdleAnim(ANIM_DEAD);
		SetMoveAnim(ANIM_DEAD);
		// playsound 0 10 SOUND_DEATH
		PlaySound(0, 10, "voices/bloodrose/findlebind/he_told_me_to_give.wav");
		CallEventDelayed(8.0f, "death_rattle");
		CallEventDelayed(15.0f, "npc_fade_away");
	}

	// death_rattle
	void OnDeathRattle()
	{
		PlaySound(0, 10, "voices/bloodrose/findlebind/death_rattle.wav");
	}

	// say_elf
	void OnSayElf()
	{
		SAYSTEP_ELF = 0.0f;
		OnElfJoke();
	}

	// elf_joke
	void OnElfJoke(CBasePlayer@ value = null)
	{
		if (value is null)
			SetMoveDest(OriginOf(ENT_LASTSPOKE), 9999);

		SAYSTEP_ELF += 1.0f;
		Say("[.1]", "[.2]", "[.3]", "[.2]", "[.2]", "[.3]", "[.2]");
		if (SAYSTEP_ELF == 1.0f)
		{
			SayText("Yes, it is true, you don't see many of us these days.");
			PlaySound(0, 10, "voices/bloodrose/findlebind/you_dont_see_many_elves.wav");
			BRAP_DELAY = 3.6f;
		}
		if (SAYSTEP_ELF == 2.0f)
		{
			SayText("We've been hiding in this mess.");
			PlaySound(0, 10, "voices/bloodrose/findlebind/were_hiding_in_this_mess.wav");
			BRAP_DELAY = 3.0f;
		}
		if (SAYSTEP_ELF == 3.0f)
		{
			SayText("Bad magic, I say.");
			PlaySound(0, 10, "voices/bloodrose/findlebind/bad_magic_i_say.wav");
			BRAP_DELAY = 1.7f;
		}
		if (SAYSTEP_ELF < 3.0f)
			CallEventDelayed(BRAP_DELAY, "elf_joke");
		else
			SAYSTEP_ELF = 0.0f;
	}

	// da_bear_died
	// called externally from Kodiak
	void OnDaBearDied()
	{
		// dbg Recieved bear death notice
		BEAR_DEAD = true;
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseNpc_OnGameSpawn(playerRace, playerGender); // monsters/base_npc
		BaseChat_OnGameSpawn(playerRace, playerGender); // monsters/base_chat
	}

	void OnBrapDelay() {} // BRAP_DELAY

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("npc/elf1.mdl");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		Findlebind_FirstThink();
		BaseNpc_FirstThink();
		MonstersExternals_FirstThink();
		BaseChat_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "da_bear_died") { OnDaBearDied(); return true; }
		if (name == "death_rattle") { OnDeathRattle(); return true; }
		if (name == "elf_joke") { OnElfJoke(PlayerParam(params, 0)); return true; }
		if (name == "found_player") { OnFoundPlayer(); return true; }
		if (name == "found_player2") { OnFoundPlayer2(); return true; }
		if (name == "found_player3") { OnFoundPlayer3(); return true; }
		if (name == "game_heardsound") { OnGameHeardsound(Param(params, 0), Vec(Param(params, 1)), Float(Param(params, 2))); return true; }
		if (name == "game_menu_getoptions") { OnGameMenuGetoptions(PlayerParam(params, 0)); return true; }
		if (name == "gave_claw") { OnGaveClaw(PlayerParam(params, 0)); return true; }
		if (name == "gave_claw2") { OnGaveClaw2(); return true; }
		if (name == "gave_claw3") { OnGaveClaw3(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "offer_quest2") { OnOfferQuest2(); return true; }
		if (name == "resetchat") { OnResetchat(); return true; }
		if (name == "say_door2") { OnSayDoor2(); return true; }
		if (name == "say_door3") { OnSayDoor3(); return true; }
		if (name == "say_door4") { OnSayDoor4(); return true; }
		if (name == "say_elf") { OnSayElf(); return true; }
		if (name == "say_hi") { OnSayHi(PlayerParam(params, 0)); return true; }
		if (name == "say_hi2") { OnSayHi2(); return true; }
		if (name == "say_hi3") { OnSayHi3(); return true; }
		if (name == "say_job") { OnSayJob(PlayerParam(params, 0)); return true; }
		if (name == "say_job2") { OnSayJob2(Param(params, 0)); return true; }
		if (name == "say_job3") { OnSayJob3(); return true; }
		if (name == "say_job4") { OnSayJob4(); return true; }
		if (name == "say_job5") { OnSayJob5(); return true; }
		if (name == "say_key1") { OnSayKey1(); return true; }
		if (name == "say_key2") { OnSayKey2(); return true; }
		if (name == "say_key3") { OnSayKey3(); return true; }
		if (name == "say_key4") { OnSayKey4(); return true; }
		if (name == "say_lair2") { OnSayLair2(); return true; }
		if (name == "say_priest") { OnSayPriest(PlayerParam(params, 0)); return true; }
		if (name == "say_priest2") { OnSayPriest2(); return true; }
		if (name == "say_priest3") { OnSayPriest3(); return true; }
		if (name == "say_rumor") { OnSayRumor(PlayerParam(params, 0)); return true; }
		if (name == "scan_for_worthy") { OnScanForWorthy(); return true; }
		if (name == "slithar_died") { OnSlitharDied(); return true; }
		return BaseChat_DispatchEvent(name, params)
			|| BaseNpcScript::DispatchEvent(name, params);
	}
}
