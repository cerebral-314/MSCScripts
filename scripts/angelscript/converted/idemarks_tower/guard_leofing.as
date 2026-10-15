#pragma context server

// Converted from idemarks_tower/guard_leofing.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_chat_array.as"
#include "converted/monsters/skeleton_base.as"

[script "idemarks_tower/guard_leofing"]
class GuardLeofing : SkeletonBaseScript, BaseChatArray
{
	// Constants
	bool CHAT_AUTO_HAIL = true;
	float ATTACK_DAMAGE_LOW = 10.0f;
	float ATTACK_DAMAGE_HIGH = 25.0f;
	string SKEL_RESPAWN_CHANCE = "100%";
	int SKEL_RESPAWN_LIVES = 1;

	// Variables (an unset .script variable reads as its own name)
	int DROP_GOLD_MIN = 0;
	int DROP_GOLD_MAX = 0;
	bool CHAT_MENU_ON = false;
	bool MET_ISHMEEA = false;
	bool BECOME_HOSTILE = false;

	// Variables declared by included files, with the value they start with in this script
	GuardLeofing()
	{
		SKEL_HP = 1600;
		ATTACK_HITCHANCE = "80%";
	}

	// unnamed block (first think)
	void GuardLeofing_FirstThink()
	{
		NPC_GIVE_EXP = 680.0f;

		DROP_GOLD = 1;
		DROP_GOLD_MIN = 30;
		DROP_GOLD_MAX = 65;
	}

	// game_menu_getoptions
	void OnGameMenuGetoptions(CBasePlayer@ player = null)
	{
		BaseChatArray_OnGameMenuGetoptions(player); // monsters/base_chat_array
		MenuItem menuItem;

		// Hail is automatically regiestered
		if (BECOME_HOSTILE)
		{
			menuItem.title = "Hostile";
			menuItem.type = "callback";
			menuItem.callback = "say_hostile";
			RegisterMenuItem(menuItem);
		}
		else if (MET_ISHMEEA)
		{
			menuItem.title = "Ishme'Ea";
			menuItem.type = "callback";
			menuItem.callback = "say_met_ishmeea";
			RegisterMenuItem(menuItem);
		}

		SetDamageTaken("holy", 3); // hax because skeleton base doesn't want to play nice
	}

	// game_death
	// hax because skeleton base doesn't want to play nice
	void OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		BaseChatArray_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_chat_array
		DqMonsterExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // dq/externals/dq_monster_externals
		MonstersExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/externals
		BaseSelfAdjust_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_self_adjust
		BaseNpc_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseMonsterShared_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared
		SKELE_TURNED = false;
		STRUCK_HOLY = false;
		SKEL_RESPAWN_TIMES = 0.0f;
		OnSkelFakeDeath();
	}

	// skel_setup_body
	void OnSkelSetupBody()
	{
		SkeletonBase_OnSkelSetupBody(); // monsters/skeleton_base

		SetName("Captain of the Guard|Leofing");
		SetUniqueName("leofing");

		SetInvincible(true);
		SetRace("beloved");

		SetRoam(false);

		SetModel("monsters/skeleton2.mdl");

		SetWidth(32);
		SetHeight(72);

		PlayAnim("hold", 0);

		SetMenuAutoOpen(true);

		SetSayTextRange(1000);

		CatchSpeech("say_ishmeea", "ishmeea", "ishme'ea");
		CatchSpeech("say_prisoner", "prisoner");
	}

	// say_hi
	void OnSayHi(CBasePlayer@ talkingPlayer = null)
	{
		if (CHAT_BUSY)
			return;
		OnChatNow("You are not one of them? How could... excuse myself, hello! You appear to be quite able-bodied, indeed.", "8", "none", "none");
		OnChatNow("Before you judge a [prisoner], a rather unlively one, please use your ears and not your eyes. We can help each other! *laughs*", "7", "none", "none");
		OnChatNow("I need you to find someone for me, and apologize to them, say that I'm sorry. For everything, this whole mess.", "7", "none", "none");
		OnChatNow("Hmm? No, I'm not talking of this blasted tangle of undead, Lost, and bandit corpses!", "7", "none", "none");
		OnChatNow("Our relationship mess my dear lad, please try to be snappy and use some context clues here.", "7", "none", "none");
		OnChatNow("I knew her as [Ishme'Ea], say, if she's looking a little... skeletal these days, let her know that old Leofing still has his connective tissues, mostly.", "12", "none", "none");
		OnChatNow("If she's joined ranks with the Lost, then eh, not really my type any more. GET MOVING! Please?", "9", "none", "none");
	}

	// say_met_ishmeea
	void OnSayMetIshmeea()
	{
		if (CHAT_BUSY)
			return;
		OnChatNow("I expected nothing less. It is my final honor as Idemark's Captain, lover of Ishme'Ea, and as a disciple of Pathos.", "10", "none", "none");
		OnChatNow("The key to this cell is held by my dear First Officer Reinold, in the shadowed courtyard.", "6", "none", "none");
		OnChatNow("The rest of Idemark's Guard, the undead you have slain to get here, have lost their minds soon after the onset of the war.", "7", "none", "none");
		OnChatNow("The only option I saw, at the time, was to lock myself away and rally our ravaged bodies in an eternal fight against the Lost.", "8", "none", "none");
	}

	// say_hostile
	void OnSayHostile()
	{
		if (CHAT_BUSY)
			return;
		OnChatNow("I wore Leofing's personality as a cloak to gain your trust. You are being used as puppets to do our bidding, just as he was.", "9", "none", "none");
		OnChatNow("The Lost was before all, and it will be the last. You are material, soon to rot and fall apart.", "7", "none", "none");
		OnChatNow("A testament to Pathos's arrogance, life will be snuffed out, now die!", "6", "none", "leofing_hostile");
	}

	// say_ishmeea
	void OnSayIshmeea()
	{
		if (CHAT_BUSY)
			return;
		if (!MET_ISHMEEA)
		{
			OnChatNow("*squints* Alright my new friend, you're pretty cool in my eye sockets, but how do you know of my Ishme'Ea?", "5", "none", "none");
			OnChatNow("Oh wait, I've just told you about her haven't I? *cackles*", "7", "none", "none");
			OnChatNow("Oh gods, the times we had together, sneaking off to someplace or another on the grounds at night.", "7", "none", "none");
			OnChatNow("You know, even in those days she was a force to be reckoned with, exceeding the knowledge of some of her masters.", "7", "none", "none");
		}
		else
		{
			OnSayMetIshmeea();
		}
	}

	// say_prisoner
	void OnSayPrisoner()
	{
		if (CHAT_BUSY)
			return;
		OnChatNow("I died a Soldier, Captain of Idemark's guard, and now I live on as this monster stuck in a cell. Maybe you can imagine my disappointment.", "9", "none", "none");
		OnChatNow("I swore an oath to give my life, my afterlife, and my soul to defend Idemark and her lands.", "7", "none", "none");
		OnChatNow("Pathos help me, Loreldians do not take kindly to failure.", "4", "none", "none");
		OnChatNow("I suffer from bouts of delusion, times where I lose myself to the pull of the Lost. The whispers of what they have to offer...", "8", "none", "none");
		OnChatNow("Some days, truthfully, every day, I question everything. But my mind always comes back to it.", "7", "none", "none");
		OnChatNow("To the wretches wandering these halls, Lost and undead alike. I would be counted among them if not for this self-imprisonment.", "9", "none", "none");
	}

	// ext_met_ishmeea
	void OnExtMetIshmeea()
	{
		CHAT_MENU_ON = false; // disable say_hi
		MET_ISHMEEA = true;
	}

	// ext_cell_key
	void OnExtCellKey()
	{
		BECOME_HOSTILE = true;
		MET_ISHMEEA = false;
	}

	// leofing_hostile
	void OnLeofingHostile()
	{
		SetRoam(true);
		SetRace("undead");
		SetInvincible(false);
	}

	// skel_rebirth
	void OnSkelRebirth()
	{
		OnChatNow("I shall but love thee better after death.", "2", "none", "none");
		OnChatNow("Just look for me beyond the sky, for high above I do fly.", "3.2");
		OnChatNow("Fond memories linger every day.", "2");
		OnChatNow("Resting where no shadows fall.", "3.3");
		OnChatNow("Loved with everlasting love.", "2.3");
		OnChatNow("Life is not forever, love is.", "3");
		OnChatNow("A free spirit.", "1.5");
		OnChatNow("Your love will light our way.", "1.5");
		OnChatNow("Resting where no shadows fall.", "3.3");
		OnChatNow("I leave you with my legacy of love.", "5.0", "none", "leofing_remove");
	}

	// leofing_remove
	void OnLeofingRemove()
	{
		UseTrigger("jl_mm");
		DeleteEntity(ENT_ME, "fade");
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseChatArray_OnGameSpawn(playerRace, playerGender); // monsters/base_chat_array
		BaseNpc_OnGameSpawn(playerRace, playerGender); // monsters/base_npc
		BaseNpcAttack_OnGameSpawn(playerRace, playerGender); // monsters/base_npc_attack
		BaseMonsterShared_OnGameSpawn(playerRace, playerGender); // monsters/base_monster_shared
	}

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/skeleton.mdl");
		Precache("monsters/skeleton2.mdl");
		CallEventDelayed(Float(CYCLE_TIME), "hunting_mode_go");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		GuardLeofing_FirstThink();
		BaseChatArray_FirstThink();
		SkeletonBase_FirstThink();
		SkeletonBase_FirstThink2();
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
		if (name == "ext_cell_key") { OnExtCellKey(); return true; }
		if (name == "ext_met_ishmeea") { OnExtMetIshmeea(); return true; }
		if (name == "game_death") { OnGameDeath(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_menu_getoptions") { OnGameMenuGetoptions(PlayerParam(params, 0)); return true; }
		if (name == "leofing_hostile") { OnLeofingHostile(); return true; }
		if (name == "leofing_remove") { OnLeofingRemove(); return true; }
		if (name == "say_hi") { OnSayHi(PlayerParam(params, 0)); return true; }
		if (name == "say_hostile") { OnSayHostile(); return true; }
		if (name == "say_ishmeea") { OnSayIshmeea(); return true; }
		if (name == "say_met_ishmeea") { OnSayMetIshmeea(); return true; }
		if (name == "say_prisoner") { OnSayPrisoner(); return true; }
		if (name == "skel_rebirth") { OnSkelRebirth(); return true; }
		if (name == "skel_setup_body") { OnSkelSetupBody(); return true; }
		return BaseChatArray_DispatchEvent(name, params)
			|| SkeletonBaseScript::DispatchEvent(name, params);
	}
}
