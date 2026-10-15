#pragma context server

// Converted from the_wall/elf_wizard_guard.script by msc_transpiler.
// to do's
// make race aware

#include "runtime/ScriptEntity.as"
#include "converted/monsters/elf_wizard_base.as"
#include "converted/monsters/base_chat.as"

[script "the_wall/elf_wizard_guard"]
class ElfWizardGuard : ElfWizardBaseScript, BaseChat
{
	// Constants
	bool ELF_LIGHTNING_WIZARD = true;
	float DMG_SHOCK = 100.0f;
	float DOT_SHOCK = 50.0f;
	bool NO_CHAT = true;
	string SOUND_ELF_BEAM_LOOP = "magic/bolt_loop.wav";
	bool NPC_BATTLE_ALLY = true;

	// Variables (an unset .script variable reads as its own name)
	string REWARD_LIST1 = "REWARD_LIST1";
	string REWARD_LIST2 = "REWARD_LIST2";
	string REWARD_LIST3 = "REWARD_LIST3";
	string REWARD_LIST4 = "REWARD_LIST4";
	string REWARD_NAMES4 = "REWARD_NAMES4";
	bool NPC_RETURN_HOME = false;
	bool NPC_PROX_ACTIVATE = false;
	string NPC_PROXACT_RANGE = "NPC_PROXACT_RANGE";
	string NPC_PROXACT_EVENT = "NPC_PROXACT_EVENT";
	bool NPC_PROXACT_IFSEEN = false;
	bool ON_SECOND_SPAWN = false;
	CBaseEntity@ INTRO_ID = null;
	string CHAT_STEP1 = "CHAT_STEP1";
	string CHAT_DELAY_STEP1 = "CHAT_DELAY_STEP1";
	string CHAT_SOUND1 = "CHAT_SOUND1";
	string CHAT_STEP2 = "CHAT_STEP2";
	string CHAT_DELAY_STEP2 = "CHAT_DELAY_STEP2";
	string CHAT_SOUND2 = "CHAT_SOUND2";
	string CHAT_STEP3 = "CHAT_STEP3";
	string CHAT_DELAY_STEP3 = "CHAT_DELAY_STEP3";
	string CHAT_SOUND3 = "CHAT_SOUND3";
	int CHAT_STEPS = 0;
	string CHAT_STEP4 = "CHAT_STEP4";
	string CHAT_SOUND4 = "CHAT_SOUND4";
	string CHAT_DELAY_STEP4 = "CHAT_DELAY_STEP4";
	string CHAT_STEP5 = "CHAT_STEP5";
	string CHAT_SOUND5 = "CHAT_SOUND5";
	string CHAT_DELAY_STEP5 = "CHAT_DELAY_STEP5";
	string CHAT_STEP6 = "CHAT_STEP6";
	string CHAT_SOUND6 = "CHAT_SOUND6";
	string CHAT_DELAY_STEP6 = "CHAT_DELAY_STEP6";
	string CHAT_STEP7 = "CHAT_STEP7";
	string CHAT_SOUND7 = "CHAT_SOUND7";
	string CHAT_DELAY_STEP7 = "CHAT_DELAY_STEP7";
	string CHAT_STEP8 = "CHAT_STEP8";
	string CHAT_SOUND8 = "CHAT_SOUND8";
	string CHAT_DELAY_STEP8 = "CHAT_DELAY_STEP8";
	string CHAT_STEP9 = "CHAT_STEP9";
	string CHAT_SOUND9 = "CHAT_SOUND9";
	string CHAT_DELAY_STEP9 = "CHAT_DELAY_STEP9";
	bool REWARED_SYMBOL = false;
	string PLAYERS_TO_REWARD = "PLAYERS_TO_REWARD";
	float PLAYERS_REWARDED = 0.0f;
	float NEXT_DMG_ALERT = 0.0f;
	string REWARD_LIST = "REWARD_LIST";
	string ANIM_STEP1 = "ANIM_STEP1";
	string ANIM_STEP3 = "ANIM_STEP3";
	string QUEST_WINNER = "QUEST_WINNER";
	string CHAT_MODE = "CHAT_MODE";

	// Variables declared by included files, with the value they start with in this script
	ElfWizardGuard()
	{
		DMG_MELEE = 300;
		ATTACK_HITRANGE_MELEE = 128;
	}

	// unnamed block (first think)
	void ElfWizardGuard_FirstThink()
	{
		// theme these by element
		// one random - cold
		REWARD_LIST1 = "scroll_volcano;armor_helm_gaz2;mana_immune_cold;mana_gprotection;swords_giceblade;shields_rune;scroll2_frost_xolt;scroll_ice_wall";

		// one random - lightning
		REWARD_LIST2 = "scroll2_lightning_chain;scroll2_lightning_storm;mana_leadfoot;mana_demon_blood;mana_immune_lightning";

		// one random - fire
		REWARD_LIST3 = "armor_helm_gaz1;mana_immune_fire;mana_vampire;item_gwond;axes_dragon;scroll_fire_wall;swords_novablade12;blunt_gauntlets_fire";

		// one of each, awarded in order of points
		// add a felewyn shard if players > 3
		REWARD_LIST4 = "mana_leadfoot;axes_gthunder11;axes_vaxe;blunt_gauntlets_demon;mana_forget;mana_speed;mana_regen;polearms_nag";
		REWARD_NAMES4 = "Leadfoot Potion;Greater Thunderaxe;Blood Axe;Demon Gauntlets;Forgetfulness Potion;Speed Potion;Regeneration Potion;Elven Glaive";

		NPC_NO_PLAYER_DMG = true; // don't take damage from players

		NPC_RETURN_HOME = true;

		NPC_PROX_ACTIVATE = true; // suspend AI on spawn, wait for player to come..
		NPC_PROXACT_RANGE = "256"; // within this range then activate...
		NPC_PROXACT_EVENT = "do_intro"; // this event.
		NPC_PROXACT_IFSEEN = false; // activate if a player can see me, or targets me, regardless of range
	}

	// game_precache
	void ElfWizardGuard_OnGamePrecache()
	{
	}

	// game_precache
	void OnGamePrecache()
	{
		ElfWizardGuard_OnGamePrecache();
		ElfWizardBase_OnGamePrecache(); // monsters/elf_wizard_base
	}

	// game_death
	void OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		DqMonsterExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // dq/externals/dq_monster_externals
		MonstersExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/externals
		BaseSelfAdjust_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_self_adjust
		BaseNpc_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseMonsterShared_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared
		ElfWizardBase_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/elf_wizard_base
		InfoMessage("all", "A CRITICAL NPC HAS BEEN SLAIN!", "Velend Varon is dead!");
	}

	// npc_post_spawn
	void OnNpcPostSpawn()
	{
		MonstersExternals_OnNpcPostSpawn(); // monsters/externals
		MonstersExternals_OnNpcPostSpawn_2(); // monsters/externals
		MonstersExternals_OnNpcPostSpawn_3(); // monsters/externals
		BaseSelfAdjust_OnNpcPostSpawn(); // monsters/base_self_adjust
		BaseNpc_OnNpcPostSpawn(); // monsters/base_npc
		BaseMonsterShared_OnNpcPostSpawn(); // monsters/base_monster_shared
		// double check setmodel settings
		SetModelBody(2, 0);

		ANIM_ATTACK = "ref_shoot_crowbar";
		ATTACK_RANGE = 64.0f;
		ATTACK_HITRANGE = 120.0f;

		ON_SECOND_SPAWN = true;
	}

	// game_struck
	void OnGameStruck(float damage = 0.0f, string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		BaseNpc_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseNpcAttackNew_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc_attack_new
		BaseMonsterShared_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared
		if (IsPlayer(ENT_LASTSTRUCK))
			return;
		if (!(damage > 0.0f))
			return;
		if (!(GameTime() > NEXT_DMG_ALERT))
			return;
		NEXT_DMG_ALERT = GameTime() + 10.0f;
		InfoMessage("all", "CRITICAL NPC UNDER ATTACK", "Velend Varon is under attack!");
	}

	// frame_melee
	void OnFrameMelee()
	{
		ElfWizardBase_OnFrameMelee(); // monsters/elf_wizard_base
		DoDamage(NPCATK_TARGET, ATTACK_HITRANGE, DMG_MELEE, "90%", "blunt");
		AddVelocity(NPCATK_TARGET, RelativeVelocity(Vector3(10, 800, 110)));
	}

	// game_menu_getoptions
	void OnGameMenuGetoptions(CBasePlayer@ player = null)
	{
		BaseChat_OnGameMenuGetoptions(player); // monsters/base_chat
		MenuItem menuItem;
		bool exitSub = false;
		bool giveReward = false;
		string nameAdd = "NAME_ADD";
		string itemAdd = "ITEM_ADD";

		SetMoveDest(@player, 9999);

		if (BUSY_CHATTING && CHAT_MODE != "final_reward")
		{
			menuItem.title = "(Talking...)";
			menuItem.type = "disabled";
			RegisterMenuItem(menuItem);
			exitSub = true;
		}
		if (exitSub)
			return;

		if (NPCATK_TARGET != "unset")
		{
			menuItem.title = "(In combat...)";
			menuItem.type = "disabled";
			RegisterMenuItem(menuItem);
			exitSub = true;
		}
		if (exitSub)
			return;

		SetMoveDest(@player, 9999);

		bool hasHead = false;
		if (Truthy(ItemExists(player, "item_telfh1")))
		{
			hasHead = true;
			menuItem.title = "Give Azura's Head";
			menuItem.type = "payment";
			menuItem.data = "item_telfh1";
			menuItem.callback = "got_head1";
			RegisterMenuItem(menuItem);
		}
		if (Truthy(ItemExists(player, "item_telfh2")))
		{
			hasHead = true;
			menuItem.title = "Give Ulectrath's Head";
			menuItem.type = "payment";
			menuItem.data = "item_telfh2";
			menuItem.callback = "got_head2";
			RegisterMenuItem(menuItem);
		}
		if (Truthy(ItemExists(player, "item_telfh3")))
		{
			hasHead = true;
			menuItem.title = "Give Ivicta's Head";
			menuItem.type = "payment";
			menuItem.data = "item_telfh3";
			menuItem.callback = "got_head3";
			RegisterMenuItem(menuItem);
		}
		if (Truthy(ItemExists(player, "item_telfh4")))
		{
			hasHead = true;
			menuItem.title = "Give Ihotohr's Head";
			menuItem.type = "payment";
			menuItem.data = "item_telfh4";
			menuItem.callback = "got_head4";
			RegisterMenuItem(menuItem);
		}

		if (!hasHead && CHAT_MODE != "final_reward")
		{
			menuItem.title = "Hail";
			menuItem.type = "callback";
			menuItem.callback = "say_hi";
			RegisterMenuItem(menuItem);

			menuItem.title = "About The Wall";
			menuItem.type = "callback";
			menuItem.callback = "say_the_wall";
			RegisterMenuItem(menuItem);

			menuItem.title = "About Rammata";
			menuItem.type = "callback";
			menuItem.callback = "say_traitors";
			RegisterMenuItem(menuItem);

			menuItem.title = "About Azura";
			menuItem.type = "callback";
			menuItem.callback = "say_azura";
			RegisterMenuItem(menuItem);

			menuItem.title = "About Ulectrath";
			menuItem.type = "callback";
			menuItem.callback = "say_ulectrath";
			RegisterMenuItem(menuItem);

			menuItem.title = "About Ivicta";
			menuItem.type = "callback";
			menuItem.callback = "say_ivicta";
			RegisterMenuItem(menuItem);

			menuItem.title = "About Ihotohr";
			menuItem.type = "callback";
			menuItem.callback = "say_ihotohr";
			RegisterMenuItem(menuItem);
		}

		if (CHAT_MODE != "final_reward")
			return;

		if (MaxHealthOf(player) < 200.0f)
		{
			SayText("Yes... You're cute, but you couldn't have possibly had anything to do with this.");
			exitSub = true;
		}
		if (exitSub)
			return;

		if (Contains(PLAYERS_TO_REWARD, EntityId(player)))
			giveReward = true;
		if (!giveReward)
		{
			SayText("Thank you again, for all you have done for us, child of Torkalath.");
			PlaySound(2, 10, "voices/the_wall/vv_givereward.wav");
			OnBchatMouthMove();
		}

		if (!giveReward)
			return;

		if (PLAYERS_REWARDED > 1.0f)
		{
			PlaySound(2, 10, "voices/the_wall/vv_playersrewarded.wav");
			SayText("Please, select a reward for the part you played in the defeat of Ihotohr.");
			OnBchatMouthMove();
		}

		int count = GetTokenCount(REWARD_LIST4);
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnBuildRewardList();
		}

		if (!REWARED_SYMBOL && RandomInt(1, 100) <= 25)
		{
			REWARED_SYMBOL = true;
			string curItemName = "Symbol of Felewyn ";
			string curItem = "item_s";

			int randSymb = RandomInt(1, 5);
			if (randSymb == 1)
			{
				nameAdd = "I";
				itemAdd = "1";
			}
			if (randSymb == 2)
			{
				nameAdd = "II";
				itemAdd = "2";
			}
			if (randSymb == 3)
			{
				nameAdd = "III";
				itemAdd = "3";
			}
			if (randSymb == 4)
			{
				nameAdd = "IV";
				itemAdd = "4";
			}
			if (randSymb == 5)
			{
				nameAdd = "V";
				itemAdd = "5";
			}

			curItemName += nameAdd;
			curItem += itemAdd;

			// add random felewyn symbol option
			menuItem.title = curItemName;
			menuItem.data = curItem;
			menuItem.type = "callback";
			menuItem.callback = "give_reward_final";
			RegisterMenuItem(menuItem);
		}
	}

	// elf_spawn
	void OnElfSpawn()
	{
		SetName("Velend Varon");
		SetHealth(3500);
		SetRace("human");

		SetUniqueName("elf_leader");

		SetModelBody(1, 2); // 0=Unarmed 1=Dark_Staff 2=Dragon_Staff 3=H4xbow
		SetModelBody(2, 0);
		SetProp(ENT_ME, "skin", 6); // 0=Young_Black_Robe 1=Elder_Black_Robe 2=Young_Green_Robe 3=Elder_Green_Robe 4=Young_Puce_Robe 5=Elder_Puce_Robe 6=Good_Pale 7=Good_Pink

		SetRoam(false);
		SetSayTextRange(1024);

		CatchSpeech("say_hi", "hail", "hi", "j0", "waddup", "gweets", "greet", "salu");
		CatchSpeech("say_the_wall", "wall");
		CatchSpeech("say_traitors", "ram", "tork", "traitor", "escape");
		CatchSpeech("say_azura", "azur");
		CatchSpeech("say_ulectrath", "ulec");
		CatchSpeech("say_ivicta", "ivict");
		CatchSpeech("say_ihotohr", "iho", "necro");
		CatchSpeech("say_melanion", "mel", "ruin");

		SetHearingSensitivity(10);

		SetMenuAutoOpen(false);

		OnNpcatkSuspendAi();
	}

	// do_intro
	void OnDoIntro()
	{
		@INTRO_ID = NPC_PROXACT_PLAYERID;

		SetModelBody(2, 0); // dbl check

		OnNpcatkResumeAi();

		SetMoveDest(@INTRO_ID, 9999);

		if (ON_SECOND_SPAWN)
			return;

		SayText("Hold there!");
		PlaySound(2, 10, "voices/the_wall/vv_holdthere.wav");

		Say("[0.2]", "[0.4]");

		PlayAnim("critical", "look_idle");

		CHAT_STEP1 = "Several [Rammata] have escaped us by traveling into the fortresses.";
		CHAT_DELAY_STEP1 = "3.4";
		CHAT_SOUND1 = "voices/the_wall/vv_holdthere1.wav";

		CHAT_STEP2 = "I'm afraid we three aren't enough to dare try to flush them out.";
		CHAT_DELAY_STEP2 = "4.0";
		CHAT_SOUND2 = "voices/the_wall/vv_holdthere2.wav";

		CHAT_STEP3 = "There's too many powerful undead occupying [The Wall] for us to go in.";
		CHAT_DELAY_STEP3 = "4.4";
		CHAT_SOUND3 = "voices/the_wall/vv_holdthere3.wav";

		CHAT_STEPS = 3;
		CallEventDelayed(3.0f, "chat_loop");
	}

	// say_the_wall
	void OnSayTheWall()
	{
		if (BUSY_CHATTING)
			CallEventDelayed(5.0f, "say_the_wall");
		if (BUSY_CHATTING)
			return;

		CHAT_STEP1 = "The Wall is a series of elven fortresses that once stood as the last line of defense";
		CHAT_DELAY_STEP1 = "4.6";
		CHAT_SOUND1 = "voices/the_wall/vv_thewall1-2.wav";

		CHAT_STEP2 = "against Lor Malgoriand's armies during the Age of Blood.";
		CHAT_DELAY_STEP2 = "3.2";

		CHAT_STEP3 = "The former Eswen Empire no longer has the forces to maintain the lines.";
		CHAT_DELAY_STEP3 = "5.1";
		CHAT_SOUND3 = "voices/the_wall/vv_thewall3.wav";

		CHAT_STEP4 = "As a result, the remains of the dark one's armies moved into the ruins.";
		CHAT_SOUND4 = "voices/the_wall/vv_thewall4.wav";
		CHAT_DELAY_STEP4 = "4.5";

		CHAT_STEPS = 4;

		CallEventDelayed(20.0f, "enable_menu");

		OnChatLoop();
	}

	// enable_menu
	void OnEnableMenu()
	{
		SetMenuAutoOpen(true);
	}

	// say_traitors
	void OnSayTraitors()
	{
		if (BUSY_CHATTING)
			CallEventDelayed(5.0f, "say_traitors");
		if (BUSY_CHATTING)
			return;

		CHAT_STEP1 = "Rammata te Mal are elven worshippers of Torkalath.";
		CHAT_SOUND1 = "voices/the_wall/vv_traitors1.wav";
		CHAT_DELAY_STEP1 = "3.0";

		CHAT_STEP2 = "They're insane, evil. They'll show no mercy, even to you, a legitmate child of their god.";
		CHAT_SOUND2 = "voices/the_wall/vv_traitors2.wav";
		CHAT_DELAY_STEP2 = "5.5";

		CHAT_STEP3 = "We cannot allow traitors of Felewyn to escape justice.";
		CHAT_SOUND3 = "voices/the_wall/vv_traitors3.wav";
		CHAT_DELAY_STEP3 = "4.0";

		CHAT_STEP4 = "This pack's leaders are named [Azura], [Ulectrath], and [Ivicta].";
		CHAT_SOUND4 = "voices/the_wall/vv_traitors4.wav";
		CHAT_DELAY_STEP4 = "4.0";

		CHAT_STEP5 = "They've also several acolytes with them we've no records of.";
		CHAT_SOUND5 = "voices/the_wall/vv_traitors5.wav";
		CHAT_DELAY_STEP5 = "4.5";

		CHAT_STEP6 = "They are all likely seeking the protection of the Rammata [necromancer], Ihotohr, who dwells within.";
		CHAT_SOUND6 = "voices/the_wall/vv_traitors6.wav";
		CHAT_DELAY_STEP6 = "6.2";

		CHAT_STEP7 = "He's insane, and likely not be anymore pleased to see them than will the undead he masters.";
		CHAT_SOUND7 = "voices/the_wall/vv_traitors7.wav";
		CHAT_DELAY_STEP7 = "6.0";

		CHAT_STEP8 = "We don't have authority to enter the ruins, but if you can bring us proof of their deaths...";
		CHAT_SOUND8 = "voices/the_wall/vv_traitors8.wav";
		CHAT_DELAY_STEP8 = "3.5";

		CHAT_STEP9 = "I do have the authority to reward you for each head retrieved.";
		CHAT_SOUND9 = "voices/the_wall/vv_traitors9.wav";
		CHAT_DELAY_STEP9 = "5.7";

		CHAT_STEPS = 9;

		OnChatLoop();
	}

	// say_azura
	void OnSayAzura()
	{
		if (BUSY_CHATTING)
			return;

		CHAT_STEP1 = "Azura is actually from north of The Wall, living among the undead around The Bleak.";
		CHAT_DELAY_STEP1 = "4.7";
		CHAT_SOUND1 = "voices/the_wall/vv_azura1.wav";

		CHAT_STEP2 = "She journeyed down from the frozen wastelands to join up with the other two in their effort to assassinate Magistrate Tal'san.";
		CHAT_DELAY_STEP2 = "6.5";
		CHAT_SOUND2 = "voices/the_wall/vv_azura2.wav";

		CHAT_STEP3 = "Apprarently, part of a vendetta, to avenge the slaughter of a coven of Rammata found hiding in [Melanion].";
		CHAT_DELAY_STEP3 = "7.3";
		CHAT_SOUND3 = "voices/the_wall/vv_azura3.wav";

		CHAT_STEPS = 3;
		OnChatLoop();
	}

	// say_ulectrath
	void OnSayUlectrath()
	{
		if (BUSY_CHATTING)
			return;
		PlaySound(2, 10, "voices/the_wall/vv_ulectrath1.wav");
		SayText("Ulectrath the Storm hails from Aluhandra where it is rumored she either bargained for or stole magical powers from the desert orc clans.");
		OnBchatAutoMouthMove("7.0");
	}

	// say_ivicta
	void OnSayIvicta()
	{
		if (BUSY_CHATTING)
			return;

		CHAT_STEP1 = "Ivicta was the sole survivor of a [Melanion] cult, subsequently forced into the Badlands.";
		CHAT_DELAY_STEP1 = "6.0";
		CHAT_SOUND1 = "voices/the_wall/vv_ivicta1.wav";

		CHAT_STEP2 = "The slaughter of the cult was ordered by Magistrate Tal'san, so it is likely she who began this mad quest to assassinate him. ";
		CHAT_DELAY_STEP2 = "7.0";
		CHAT_SOUND2 = "voices/the_wall/vv_ivicta2.wav";

		CHAT_STEP3 = "However, how she contacted or organized the other two women is beyond the scope of our knowledge.";
		CHAT_DELAY_STEP3 = "5.5";
		CHAT_SOUND3 = "voices/the_wall/vv_ivicta3.wav";

		CHAT_STEPS = 3;
		OnChatLoop();
	}

	// say_melanion
	void OnSayMelanion()
	{
		SayText("The Melanion Ruins lie beneath and around the new elven capital of Kray Eldorad and run all the way to Blood Rose valley.");
		PlaySound(2, 10, "voices/the_wall/vv_melanion.wav");
		OnBchatAutoMouthMove("7.0");
	}

	// say_ihotohr
	void OnSayIhotohr()
	{
		if (BUSY_CHATTING)
			return;

		CHAT_STEP1 = "Ihotohr brought an army of the undead to the elven capital of Kray Eldorad nearly a century ago.";
		CHAT_DELAY_STEP1 = "5.2";
		CHAT_SOUND1 = "voices/the_wall/vv_ihotohr1.wav";

		CHAT_STEP2 = "He was soundly defeated, and has been biding his time in the maze of fortresses that make up The Wall ever since.";
		CHAT_DELAY_STEP2 = "6.7";
		CHAT_SOUND2 = "voices/the_wall/vv_ihotohr2.wav";

		CHAT_STEP3 = "Rammata have sought him out to form alliances before, but none have returned..";
		CHAT_DELAY_STEP3 = "4.3";
		CHAT_SOUND3 = "voices/the_wall/vv_ihotohr3.wav";

		CHAT_STEP4 = "I fear that desperation and fear have driven this trio and their cohorts to attempt it.";
		CHAT_DELAY_STEP4 = "4.5";
		CHAT_SOUND4 = "voices/the_wall/vv_ihotohr4.wav";

		CHAT_STEP5 = "We cannot depend on the necromancer to dispatch our foes for us though. Sooner or later, we must pursue them.";
		CHAT_DELAY_STEP5 = "6.0";
		CHAT_SOUND5 = "voices/the_wall/vv_ihotohr5.wav";

		CHAT_STEPS = 5;
		OnChatLoop();
	}

	// say_hi
	void OnSayHi(CBasePlayer@ talkingPlayer = null)
	{
		if (BUSY_CHATTING)
			return;

		CHAT_STEP1 = "Hail, child of Torkaloth...";
		CHAT_DELAY_STEP1 = "1.5";
		CHAT_SOUND1 = "voices/the_wall/vv_hi1.wav";

		CHAT_STEP2 = "As I explained, serveral [Rammata] have escaped into the fortresses.";
		CHAT_DELAY_STEP2 = "4.5";
		CHAT_SOUND2 = "voices/the_wall/vv_hi2.wav";

		CHAT_STEP3 = "Bring us proof of their demise, and I shall reward you.";
		CHAT_DELAY_STEP3 = "3.0";
		CHAT_SOUND3 = "voices/the_wall/vv_hi3.wav";

		CHAT_STEPS = 3;
		OnChatLoop();
	}

	// build_reward_list
	void OnBuildRewardList()
	{
		MenuItem menuItem;
		int curIdx = loopIteration;
		string curItem = GetToken(REWARD_LIST4, curIdx);
		string curItemName = GetToken(REWARD_NAMES4, curIdx);
		menuItem.title = curItemName;
		menuItem.data = curItem;
		menuItem.type = "callback";
		menuItem.callback = "give_reward_final";
		RegisterMenuItem(menuItem);
	}

	// give_reward_final
	void OnGiveRewardFinal(CBasePlayer@ player = null, string reward = "")
	{
		int plrIdx = FindToken(PLAYERS_TO_REWARD, EntityId(player));
		PLAYERS_TO_REWARD = TokenRemove(PLAYERS_TO_REWARD, plrIdx);
		PLAYERS_REWARDED += 1.0f;
		DebugPrint("give_reward_final " + NameOf(player) + " " + reward);
		Offer(player, reward);
	}

	// got_head1
	// { game_heardsound
	// if !NPC_RETURNING_HOME
	// if NPCATK_TARGET equals unset
	// if $get(ent_lastheard,isplayer)
	// setvard NPC_FORCED_MOVEDEST 1
	// dbg heard_player
	// setmovedest ent_lastheard 9999
	// }
	void OnGotHead1(CBasePlayer@ player = null)
	{
		DebugPrint("got_head1 step 1");

		if (BUSY_CHATTING)
			CallEventDelayed(1.0f, "got_head1");
		DebugPrint("got_head1 step 2");
		if (BUSY_CHATTING)
			return;

		DebugPrint("got_head1 step 3");

		CHAT_STEP1 = "Ah yes, the head of Azura. Finally her cold soul can be brought to rest.";
		CHAT_DELAY_STEP1 = "5.3";
		CHAT_SOUND1 = "voices/the_wall/vv_azura_dead.wav";

		CHAT_STEP2 = "Please take token of gratitude from the faithful of the Empire of Eswen.";
		CHAT_DELAY_STEP2 = "4.3";
		CHAT_SOUND2 = "voices/the_wall/vv_token.wav";

		CHAT_STEPS = 2;
		OnChatLoop();

		DebugPrint("got_head1 step 4");

		REWARD_LIST = REWARD_LIST1;
		OnRewardRandomItem(player);
	}

	// got_head2
	void OnGotHead2(CBasePlayer@ player = null)
	{
		if (BUSY_CHATTING)
			CallEventDelayed(1.0f, "got_head2");
		if (BUSY_CHATTING)
			return;

		CHAT_STEP1 = "Ulectrath made many shake with fear, like thunder in the night. They may sleep easy, knowing that you have defeated her at last.";
		CHAT_SOUND1 = "voices/the_wall/vv_ulectrath_dead.wav";
		CHAT_DELAY_STEP1 = "5.9";

		CHAT_STEP2 = "Please take token of gratitude from the faithful of the Empire of Eswen.";
		CHAT_DELAY_STEP2 = "4.3";
		CHAT_SOUND2 = "voices/the_wall/vv_token.wav";

		CHAT_STEPS = 2;
		OnChatLoop();

		REWARD_LIST = REWARD_LIST2;
		OnRewardRandomItem(player);
	}

	// got_head3
	void OnGotHead3(CBasePlayer@ player = null)
	{
		if (BUSY_CHATTING)
			CallEventDelayed(1.0f, "got_head3");
		if (BUSY_CHATTING)
			return;

		CHAT_STEP1 = "Ivicta hatred was not without reason, but it was beyond it. We can only pray that she may now finally be free of it.";
		CHAT_SOUND1 = "voices/the_wall/vv_ivicta_dead.wav";
		CHAT_DELAY_STEP1 = "8.5";

		CHAT_STEP2 = "Please take token of gratitude from the faithful of the Empire of Eswen.";
		CHAT_DELAY_STEP2 = "4.3";
		CHAT_SOUND2 = "voices/the_wall/vv_token.wav";

		CHAT_STEPS = 2;
		OnChatLoop();

		REWARD_LIST = REWARD_LIST3;
		OnRewardRandomItem(player);
	}

	// got_head4
	void OnGotHead4(CBasePlayer@ player = null)
	{
		if (BUSY_CHATTING)
			CallEventDelayed(1.0f, "got_head4");
		if (BUSY_CHATTING)
			return;

		float chatDelayTotal = 0.0f;
		CHAT_STEP1 = "You... You slew Ihotohr himself!? This is more than I ever dared even hope for, let alone ask!";
		CHAT_SOUND1 = "voices/the_wall/vv_ihotohr_dead1.wav";
		CHAT_DELAY_STEP1 = "8.5";
		chatDelayTotal += 8.5f;

		ANIM_STEP1 = "ref_aim_squeak";
		if (PlayerCount() > 1)
		{
			CHAT_STEP2 = "All of you must be rewarded! Please, choose from among any of these, each of you!";
			CHAT_SOUND2 = "voices/the_wall/vv_ihotohr_dead2.wav";
			CHAT_DELAY_STEP2 = "5.5";
			chatDelayTotal += 5.5f;

			CHAT_STEP3 = "Tell your allys to come forth! I shall reward each of them in turn.";
			CHAT_SOUND3 = "voices/the_wall/vv_ihotohr_dead3.wav";
			CHAT_DELAY_STEP3 = "3.5";
		}
		else
		{
			CHAT_STEP2 = "And on your own no less? I truly underestimated you. Without doubt Felewyn walks by your side!";
			CHAT_SOUND2 = "voices/the_wall/vv_ihotohr_dead2_solo.wav";
			CHAT_DELAY_STEP2 = "7.9";
			chatDelayTotal += 7.9f;

			CHAT_STEP3 = "Please, select from any of these items.";
			CHAT_SOUND3 = "voices/the_wall/vv_ihotohr_dead3_solo.wav";
			CHAT_DELAY_STEP3 = "2.3";
		}
		ANIM_STEP3 = "deep_idle";
		CHAT_STEPS = 3;
		OnChatLoop();

		InfoMessage("all", "QUEST REWARD", "Velend Varon has a gift waiting for you, please see him.");

		PLAYERS_TO_REWARD = "";
		PLAYERS_TO_REWARD = GetActivePlayers();

		PLAYERS_REWARDED = 1.0f;

		QUEST_WINNER = EntityId(player);
		CallEventDelayed(chatDelayTotal, "reward_final_items");
	}

	// reward_random_item
	void OnRewardRandomItem(CBasePlayer@ winner = null)
	{
		DebugPrint("reward_random_item step1");

		float nRewards = GetTokenCount(REWARD_LIST) - 1.0f;
		int rndReward = RandomInt(0, int(nRewards));

		DebugPrint("reward_random_item step2");

		string rndItem = GetToken(REWARD_LIST, rndReward);

		DebugPrint("reward_random_item step3");
		Offer(winner, rndItem);
	}

	// reward_final_items
	void OnRewardFinalItems()
	{
		CHAT_MODE = "final_reward";
		CallEventDelayed(0.1f, "resend_menu");
	}

	// resend_menu
	void OnResendMenu()
	{
		OpenMenu(QUEST_WINNER);
	}

	// second_spawn
	void OnSecondSpawn()
	{
		ON_SECOND_SPAWN = true;
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseNpc_OnGameSpawn(playerRace, playerGender); // monsters/base_npc
		BaseMonsterShared_OnGameSpawn(playerRace, playerGender); // monsters/base_monster_shared
		BaseChat_OnGameSpawn(playerRace, playerGender); // monsters/base_chat
	}

	// npcatk_suspend_ai
	void OnNpcatkSuspendAi(string seconds = "", string debugTag = "")
	{
		BaseNpcAttackNew_OnNpcatkSuspendAi(seconds, debugTag); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcatkSuspendAi(seconds, debugTag); // monsters/base_monster_shared
	}

	void OnChatDelayTotal() {} // CHAT_DELAY_TOTAL

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("weapons/bows/boltexplosive.mdl");
		Precache("explode1.spr");
		Precache("rain_ripple.spr");
		Precache("3dmflaora.spr");
		Precache("npc/elf_m_wizard.mdl");
		Precache("magic/bolt_loop.wav");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		ElfWizardGuard_FirstThink();
		ElfWizardBase_FirstThink();
		ElfWizardBase_FirstThink2();
		BaseNpc_FirstThink();
		MonstersExternals_FirstThink();
		BaseNpcAttackNew_FirstThink();
		BaseMonsterShared_FirstThink();
		BaseChat_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "build_reward_list") { OnBuildRewardList(); return true; }
		if (name == "do_intro") { OnDoIntro(); return true; }
		if (name == "elf_spawn") { OnElfSpawn(); return true; }
		if (name == "enable_menu") { OnEnableMenu(); return true; }
		if (name == "frame_melee") { OnFrameMelee(); return true; }
		if (name == "game_death") { OnGameDeath(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_menu_getoptions") { OnGameMenuGetoptions(PlayerParam(params, 0)); return true; }
		if (name == "game_precache") { OnGamePrecache(); return true; }
		if (name == "game_struck") { OnGameStruck(Float(Param(params, 0)), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "give_reward_final") { OnGiveRewardFinal(PlayerParam(params, 0), Param(params, 1)); return true; }
		if (name == "got_head1") { OnGotHead1(PlayerParam(params, 0)); return true; }
		if (name == "got_head2") { OnGotHead2(PlayerParam(params, 0)); return true; }
		if (name == "got_head3") { OnGotHead3(PlayerParam(params, 0)); return true; }
		if (name == "got_head4") { OnGotHead4(PlayerParam(params, 0)); return true; }
		if (name == "npc_post_spawn") { OnNpcPostSpawn(); return true; }
		if (name == "resend_menu") { OnResendMenu(); return true; }
		if (name == "reward_final_items") { OnRewardFinalItems(); return true; }
		if (name == "reward_random_item") { OnRewardRandomItem(PlayerParam(params, 0)); return true; }
		if (name == "say_azura") { OnSayAzura(); return true; }
		if (name == "say_hi") { OnSayHi(PlayerParam(params, 0)); return true; }
		if (name == "say_ihotohr") { OnSayIhotohr(); return true; }
		if (name == "say_ivicta") { OnSayIvicta(); return true; }
		if (name == "say_melanion") { OnSayMelanion(); return true; }
		if (name == "say_the_wall") { OnSayTheWall(); return true; }
		if (name == "say_traitors") { OnSayTraitors(); return true; }
		if (name == "say_ulectrath") { OnSayUlectrath(); return true; }
		if (name == "second_spawn") { OnSecondSpawn(); return true; }
		return BaseChat_DispatchEvent(name, params)
			|| ElfWizardBaseScript::DispatchEvent(name, params);
	}
}
