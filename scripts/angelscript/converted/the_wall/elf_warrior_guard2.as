#pragma context server

// Converted from the_wall/elf_warrior_guard2.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/elf_warrior_base.as"
#include "converted/monsters/base_chat.as"

[script "the_wall/elf_warrior_guard2"]
class ElfWarriorGuard2 : ElfWarriorBaseScript, BaseChat
{
	// Constants
	string ATTACK_TYPE = "blunt";
	string ATTACK_STANCE = "1h";
	bool NO_CHAT = true;
	bool NPC_BATTLE_ALLY = true;
	string SOUND_HELLO = "npc/elvenfemale/vs_nnwnobf1_hi.wav";
	string SOUND_VELEND = "npc/elvenfemale/vs_nnwnobf1_warn.wav";

	// Variables (an unset .script variable reads as its own name)
	bool NPC_RETURN_HOME = false;
	string CHAT_STEP1 = "CHAT_STEP1";
	string CHAT_STEP2 = "CHAT_STEP2";
	int CHAT_STEPS = 0;

	// Variables declared by included files, with the value they start with in this script
	ElfWarriorGuard2()
	{
		CHANCE_STUN = "20%";
		DMG_MELEE = 800;
		CAN_BLOCK = true;
	}

	// unnamed block (first think)
	void ElfWarriorGuard2_FirstThink()
	{
		NPC_GIVE_EXP = 0.0f;

		NPC_NO_PLAYER_DMG = true;

		NPC_RETURN_HOME = true;
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
		ElfWarriorBase_OnNpcPostSpawn(); // monsters/elf_warrior_base
		ANIM_ATTACK = "swordswing1_R";
	}

	// game_menu_getoptions
	void OnGameMenuGetoptions(CBasePlayer@ player = null)
	{
		BaseChat_OnGameMenuGetoptions(player); // monsters/base_chat
		MenuItem menuItem;
		bool exitSub = false;
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

		if (BUSY_CHATTING)
			return;

		PlaySound(2, 10, SOUND_HELLO);

		Say("[0.1]", "[0.3]");
		CallEventDelayed(0.6f, "bchat_close_mouth");

		menuItem.title = "Hail";
		menuItem.type = "callback";
		menuItem.callback = "say_hi";
		RegisterMenuItem(menuItem);
	}

	// elf_spawn
	void OnElfSpawn()
	{
		SetName("Elven Warrior");
		// Torkalath Warrior - Club (stun)
		// Torkalath Assasin - Dagger (poison - maybe throw?)
		// Torkalath Slasher - Axe (more hp)
		// Torkalath Blademistress - Dbl Sword (more dmg)
		// Torkalath Shadowarcher - different base? (spiral arrows)
		SetHealth(2000);
		SetDamageTaken("all", 0.5f);
		SetRace("human");
		SetRoam(false);

		SetProp(ENT_ME, "skin", 1); // 0=torkie 1=elf_armored 2=elf_skimpy 3=elf_tanned

		SetModelBody(1, 11); // 0=Unarmed 1=Dagger 2=FMace 3=LAxe 4=ESword 5=Bow_evil 6=Litchtounge 7=Spear 8=norm_axe 9=bow_orion 10=dagger 11=norm_mace
		SetModelBody(2, 3); // 0=no_shield 1=demon_shield 2=wood_shield 3=white_shield
	}

	// say_hi
	void OnSayHi(CBasePlayer@ talkingPlayer = null)
	{
		if (BUSY_CHATTING)
			return;
		PlaySound(2, 10, SOUND_VELEND);

		CBaseEntity@ leaderId = FindByName("elf_leader");
		if (IsAlive(leaderId))
		{
			CHAT_STEP1 = "Velend Varon speaks for us.";

			if (RaceOf(talkingPlayer) == "human")
				CHAT_STEP2 = "Address any questions you have to him, child of Torkaloth.";
			else
				CHAT_STEP2 = "Address any questions you have to him.";
			CHAT_STEPS = 2;
			OnChatLoop();
		}
		else
		{
			SayText("Seeker Varon maybe dead, but I must still stand guard, as I await our reinforcements.");
		}
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
		ElfWarriorBase_OnNpcatkSuspendAi(seconds, debugTag); // monsters/elf_warrior_base
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		ElfWarriorGuard2_FirstThink();
		ElfWarriorBase_FirstThink();
		ElfWarriorBase_FirstThink2();
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
		if (name == "elf_spawn") { OnElfSpawn(); return true; }
		if (name == "game_menu_getoptions") { OnGameMenuGetoptions(PlayerParam(params, 0)); return true; }
		if (name == "npc_post_spawn") { OnNpcPostSpawn(); return true; }
		if (name == "say_hi") { OnSayHi(PlayerParam(params, 0)); return true; }
		return BaseChat_DispatchEvent(name, params)
			|| ElfWarriorBaseScript::DispatchEvent(name, params);
	}
}
