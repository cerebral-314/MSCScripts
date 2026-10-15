#pragma context server

// Converted from dq/quest_dwarf.script by msc_transpiler.
// Optionals for the quest_dwarf script only:
// const USE_LANTERN <0|1> - has lantern
// const LANTERN_COLOR <(R,G,B)> defaults to: (128,64,0)
// setvard INIT_IDLE_MODE <sitting|wounded|standing> - defaults to <wounded> for non-combatants, and <sitting> for combatants based on QUEST_COMBATANT setting
// const QUEST_EXPERT_COMBATANT 0|1 //if combatant, unlocks special stun attack
// THOTHIE: also, how is defendie's HP determined?
// - I realize I said, "dwarf will have double the HP of the player who picked up the quest (1000hp and beloved until activated)"
// - But I suspect this would suck, if a weak player activated the quest...
// - ...maybe multiply game.players.avghp x2?
// - Other bugger I see in planning stage, is getting this guy to stay around to reward all players present, if that's to be a thing (otherwise players are going to fight on who
// activates and/or refuse to help.) That's less of a problem for the dynamic quests acquired by the player, but maybe one for Oyster's Quest Dwarf purposes.
// - If QUEST_COMBATANT is set, will do 5% of the quest taker's HP per attack, has no special attacks, but they can be rigged up in top script
// - quest dwarf heals as CRITICAL_NPC and provides damage points accordingly
// Be sure to set angles on your info_target's	(Actually this doesn't matter as the dwarf has a tendancy of looking around :I) greatguys1@August2016

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_monster_new.as"
#include "converted/monsters/base_battle_ally.as"
#include "converted/monsters/base_chat_array.as"
#include "converted/monsters/base_struck.as"
#include "converted/NPCs/dwarf_lantern_base.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class QuestDwarf
{
	// Constants
	string CHAT_CONV_ANIMS = "CHAT_CONV_ANIMS";
	float ATTACK_DAMAGE_MULT = 0.05f;
	float ATTACK2_DAMAGE_MULT = 0.15f;
	int HEALTH_MULT = 2;
	string ANIM_ALLY_JUMP = "anim_roll_back";
	string SOUND_ALLY_JUMP = "voices/dwarf/vs_nx0drogm_hit2.wav";
	int ALLY_MOVE_AWAY_DIST = 128;
	string NPC_MATERIAL_TYPE = "flesh";
	bool NPC_USE_PAIN = true;
	bool NPC_USE_IDLE = false;
	bool NPC_USE_FLINCH = true;
	string SOUND_PAIN1 = "voices/dwarf/vs_ndwarfm1_hit1.wav";
	string SOUND_PAIN2 = "voices/dwarf/vs_ndwarfm1_bat1.wav";
	string SOUND_PAIN3 = "voices/dwarf/vs_ndwarfm1_hit3.wav";
	string SOUND_FLINCH1 = "voices/dwarf/vs_nx0drogm_heal.wav";
	string SOUND_FLINCH2 = "voices/dwarf/vs_nx0drogm_help.wav";
	string SOUND_FLINCH3 = "voices/dwarf/vs_nx0drogm_hit1.wav";
	string NPC_BASE_EXP = "0";
	string SOUND_DEATH = "voices/dwarf/vs_nx0drogm_hit3.wav";
	string ATTACK_ACCURACY = "80";
	string ATTACK2_ACCURACY = "90";
	string SOUND_ALERT1 = "voices/dwarf/voices/dwarf/vs_nx0drogm_bat3.wav";
	string SOUND_ALERT2 = "voices/dwarf/voices/dwarf/vs_nx0drogm_bat1.wav";
	string SOUND_ALERT3 = "voices/dwarf/voices/dwarf/vs_ndwarfm1_bat3.wav";
	string SOUND_ATTACK1 = "voices/dwarf/voices/dwarf/vs_nx0drogm_atk1.wav";
	string SOUND_ATTACK2 = "voices/dwarf/voices/dwarf/vs_nx0drogm_atk2.wav";
	string ANIM_SIT_IDLE = "anim_sit_idle_lantern";
	string ANIM_SIT_IDLE_NOLANTERN = "anim_sit_idle_nolantern";
	string ANIM_SIT_IDLE_WOUNDED = "anim_sit_wounded";
	string ANIM_SIT_IDLE_CONVO1 = "anim_convo1";
	string ANIM_SIT_IDLE_CONVO2 = "anim_convo2";

	// Variables (an unset .script variable reads as its own name)
	string ANIM_IDLE = "idle";
	string ANIM_WALK = "walk";
	string ANIM_RUN = "run";
	bool ALLY_FOLLOW_ON = false;
	string ANIM_FLINCH = "ANIM_FLINCH";
	string ANIM_DEATH = "ANIM_DEATH";
	string ANIM_ATTACK = "ANIM_ATTACK";
	bool NPC_NO_PLAYER_DMG = false;
	float ATTACK_RANGE = 0.0f;
	float ATTACK_HITRANGE = 0.0f;
	float ATTACK_MOVERANGE = 0.0f;
	string ATTACK_DAMAGE = "ATTACK_DAMAGE";
	string ATTACK2_DAMAGE = "ATTACK2_DAMAGE";
	int ATTACK2_CHANCE = 0;
	string INIT_IDLE_MODE = "INIT_IDLE_MODE";
	bool AM_SITTING = false;
	string DWARF_CONVO_ANIMS = "DWARF_CONVO_ANIMS";
	string DWARF_COMVO_ANIMS = "DWARF_COMVO_ANIMS";
	float NEXT_DZOMB_FLEE = 0.0f;
	float AS_ATTACKING = 0.0f;

	// unnamed block (first think)
	void QuestDwarf_FirstThink()
	{
		// =========================================== Dwarf Init
		// base ally
		ALLY_FOLLOW_ON = false;
		ANIM_FLINCH = "none"; // anim_xbow_flinch //Setvard becaues if the dwarf is sitting, he'll stand up if he does this

		// base anims
		ANIM_IDLE = "idle";
		ANIM_WALK = "walk";
		ANIM_RUN = "run";
		ANIM_DEATH = "death";
		ANIM_ATTACK = "attack"; // alternates between leap and slash
		NPC_NO_PLAYER_DMG = true;
		ATTACK_RANGE = 75.0f;
		ATTACK_HITRANGE = 100.0f;
		ATTACK_MOVERANGE = 48.0f;

		// top
		ATTACK_DAMAGE = "50"; // adjusts based on quest taker HP (5%)
		ATTACK2_DAMAGE = "150"; // adjusts based on quest taker HP (15%)
		ATTACK2_CHANCE = 30; // only if QUEST_EXPERT_COMBATANT
	}

	// game_spawn
	void QuestDwarf_OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		OnDwarfSpawn();
	}

	// dwarf_spawn
	void QuestDwarf_OnDwarfSpawn()
	{
		SetName("Dwarven Miner");
		SetModel("dwarf/male1.mdl");
		// setmodelbody 1 8
		SetWidth(32);
		SetHeight(48);
		SetRoam(true);
		SetHealth(1000);
		SetHearingSensitivity(8);

		if (USE_LANTERN)
			OnSetLantern(LANTERN_COLOR);

		if (!Truthy(NEW_RACE))
			SetRace("human");

		OnInitIdleAnims();
	}

	// init_idle_anims
	void QuestDwarf_OnInitIdleAnims()
	{
		if (INIT_IDLE_MODE == "INIT_IDLE_MODE")
		{
			if (QUEST_COMBATANT == 0)
				INIT_IDLE_MODE = "wounded";
			else if (QUEST_COMBATANT == 1)
				INIT_IDLE_MODE = "sitting";
			else
				INIT_IDLE_MODE = "wounded";
		}

		if (INIT_IDLE_MODE == "sitting")
		{
			if (USE_LANTERN)
				SetIdleAnim(ANIM_SIT_IDLE);
			else
				SetIdleAnim(ANIM_SIT_IDLE_NOLANTERN);
			AM_SITTING = true;
		}
		else if (INIT_IDLE_MODE == "wounded")
		{
			SetIdleAnim(ANIM_SIT_IDLE_WOUNDED);
			AM_SITTING = true;
		}
		else if (INIT_IDLE_MODE == "standing")
		{
			SetIdleAnim(ANIM_IDLE);
			AM_SITTING = false;
		}

		if (AM_SITTING)
		{
			ANIM_FLINCH = "none"; // Setvard becaues if the dwarf is sitting, he'll stand up if he does this
			DWARF_CONVO_ANIMS = "anim_sit_convo1;anim_sit_convo2";
		}
		else
		{
			ANIM_FLINCH = "anim_xbow_flinch"; // Setvard becaues if the dwarf is sitting, he'll stand up if he does this
			DWARF_COMVO_ANIMS = "anim_convo1;anim_convo2";
		}
	}

	// attack_1
	// called by modelanim attack @frame 6
	void QuestDwarf_OnAttack12()
	{
		// copypasta lazyness from dzomb
		DoDamage(NPCATK_TARGET, ATTACK_HITRANGE, ATTACK_DAMAGE, ATTACK_ACCURACY);
		if (QUEST_EXPERT_COMBATANT && RandomInt(1, 100) < ATTACK2_CHANCE)
			ANIM_ATTACK = "attack2";
	}

	// attack_2
	// called by modelanim attack2 @frame 9
	void QuestDwarf_OnAttack22()
	{
		PlayRandomSound(0, 10, SOUND_ATTACK1, SOUND_ATTACK2, "SOUND_ATTACK3");

		// copypasta lazyness from dzomb
		DoDamage(NPCATK_TARGET, ATTACK_HITRANGE, ATTACK2_DAMAGE, ATTACK2_ACCURACY);
		ANIM_ATTACK = "attack";
		if (RangeTo(ENT_LASTSTRUCKBYME) <= ATTACK_HITRANGE)
		{
			ApplyEffect(EntityOf(ENT_LASTSTRUCKBYME), "effects/debuff_stun", RandomInt(2, 8), self);
			ApplyEffect(EntityOf(ENT_LASTSTRUCKBYME), "effects/effect_push", 2, RelativeVelocity(Vector3(10, -200, 10)), 0);
		}
	}

	// set_leader
	void QuestDwarf_OnSetLeader(int isLeader = 0)
	{
		if (isLeader != 0)
		{
			// speed up to stay in front
			SetMoveSpeed(2.5f);
			SetAnimMoveSpeed(2.5f);
		}
		else
		{
			SetMoveSpeed(1);
			SetAnimMoveSpeed(1);
		}
	}

	// game_damaged
	string QuestDwarf_OnGameDamaged(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float accuracyRoll = 0.0f, CBaseEntity@ inflictor = null, string skill = "")
	{
		string result = "";
		// roll away if struck
		if (!AM_SITTING && !NPC_IS_TURRET && GameTime() > NEXT_DZOMB_FLEE)
		{
			NEXT_DZOMB_FLEE = GameTime() + Random(5, 10);
			AS_ATTACKING = GameTime() + 5.0f;
			ServerPlaySound(2, 10, SOUND_PAIN1);
			PlayAnim("critical", "ANIM_DODGE");

			int rollDir = -200;
			AddVelocity(ENT_ME, RelativeVelocity(Vector3(50, rollDir, 100)));
		}
		return result;
	}

	// frame_roll_back_push
	// ANIM_DODGE
	void QuestDwarf_OnFrameRollBackPush()
	{
		int rollDir = -100;
		AddVelocity(ENT_ME, RelativeVelocity(Vector3(Random(-50, 50), rollDir, 100)));
	}

	// quest_activate
	// called from dq/dq_base
	void QuestDwarf_OnQuestActivate(CBasePlayer@ menuOwner = null)
	{
		if (QUEST_COMBATANT == 1)
		{
			INIT_IDLE_MODE = "standing";
			OnInitIdleAnims();
		}
		else if (QUEST_ACTIVE_COMBATANT == 1)
		{
			INIT_IDLE_MODE = "standing";
			OnInitIdleAnims();
		}
		else if (QUEST_FOLLOWER == 1)
		{
			INIT_IDLE_MODE = "standing";
			OnInitIdleAnims();
		}
		else if (IS_LEADER == 1)
		{
			INIT_IDLE_MODE = "standing";
			OnInitIdleAnims();
		}

		float setHealth = Float(Eval("game.players.avghp")) * HEALTH_MULT;
		OnExtSetHealth(setHealth, setHealth);
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)

	// game_death
	void OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		DqMonsterExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // dq/externals/dq_monster_externals
		MonstersExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/externals
		BaseSelfAdjust_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_self_adjust
		BaseNpc_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseMonsterShared_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared
		BaseChatArray_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_chat_array
		DwarfLanternBase_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // NPCs/dwarf_lantern_base
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseNpc_OnGameSpawn(playerRace, playerGender); // monsters/base_npc
		BaseMonsterShared_OnGameSpawn(playerRace, playerGender); // monsters/base_monster_shared
		BaseChatArray_OnGameSpawn(playerRace, playerGender); // monsters/base_chat_array
		BaseStruck_OnGameSpawn(playerRace, playerGender); // monsters/base_struck
		QuestDwarf_OnGameSpawn(playerRace, playerGender);
	}

	// npcatk_hunt
	void OnNpcatkHunt()
	{
		BaseNpcAttackNew_OnNpcatkHunt(); // monsters/base_npc_attack_new
		BaseAntiStuck_OnNpcatkHunt(); // monsters/base_anti_stuck
		BaseBattleAlly_OnNpcatkHunt(); // monsters/base_battle_ally
		BaseStruck_OnNpcatkHunt(); // monsters/base_struck
		DwarfLanternBase_OnNpcatkHunt(); // NPCs/dwarf_lantern_base
	}

	// game_damaged - Return a damage multiplier to scale the damage
	string OnGameDamaged(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float accuracyRoll = 0.0f, CBaseEntity@ inflictor = null, string skill = "")
	{
		string result = "";
		result = AppendResult(result, BaseAntiStuck_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, BaseMonsterShared_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, BaseMonsterShared_OnGameDamaged_2(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, BaseBattleAlly_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, BaseStruck_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, QuestDwarf_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		return result;
	}

	// set_leader
	void OnSetLeader(int isLeader = 0)
	{
		BaseBattleAlly_OnSetLeader(isLeader); // monsters/base_battle_ally
		QuestDwarf_OnSetLeader(isLeader);
	}

	void OnDwarfSpawn() { QuestDwarf_OnDwarfSpawn(); } // dwarf_spawn
	void OnInitIdleAnims() { QuestDwarf_OnInitIdleAnims(); } // init_idle_anims
	void OnAttack12() { QuestDwarf_OnAttack12(); } // attack_1
	void OnAttack22() { QuestDwarf_OnAttack22(); } // attack_2
	void OnFrameRollBackPush() { QuestDwarf_OnFrameRollBackPush(); } // frame_roll_back_push
	void OnQuestActivate(CBasePlayer@ menuOwner = null) { QuestDwarf_OnQuestActivate(menuOwner); } // quest_activate

	// This file's events and timers by their .script names
	bool QuestDwarf_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "attack_1") { OnAttack12(); return true; }
		if (name == "attack_2") { OnAttack22(); return true; }
		if (name == "dwarf_spawn") { OnDwarfSpawn(); return true; }
		if (name == "frame_roll_back_push") { OnFrameRollBackPush(); return true; }
		if (name == "game_damaged") { Return(OnGameDamaged(EntityParam(params, 0), Float(Param(params, 1)), Param(params, 2), Float(Param(params, 3)), EntityParam(params, 4), Param(params, 5))); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "init_idle_anims") { OnInitIdleAnims(); return true; }
		if (name == "quest_activate") { OnQuestActivate(PlayerParam(params, 0)); return true; }
		if (name == "set_leader") { OnSetLeader(Int(Param(params, 0))); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "dq/quest_dwarf"]
shared class QuestDwarfScript : BaseMonsterNewScript, QuestDwarf, BaseBattleAlly, BaseChatArray, BaseStruck, DwarfLanternBase
{
	// Variables every script that includes this file declares
	bool AM_INVINCIBLE = false;
	int IS_LEADER = 0;
	string MONSTER_MODEL = "MONSTER_MODEL";
	int NEW_HEIGHT = 0;
	string NEW_RACE = "NEW_RACE";
	int NEW_WIDTH = 0;
	CBasePlayer@ OFFER_MENU_ID = null;
	string QUEST_ACTIVE = "QUEST_ACTIVE";
	int QUEST_ACTIVE_COMBATANT = 0;
	string QUEST_ACTIVE_TEXT = "QUEST_ACTIVE_TEXT";
	string QUEST_ASKING = "QUEST_ASKING";
	string QUEST_ASKING_TEXT = "QUEST_ASKING_TEXT";
	int QUEST_COMBATANT = 0;
	string QUEST_COMPLETE = "QUEST_COMPLETE";
	string QUEST_COMPLETE_TEXT = "QUEST_COMPLETE_TEXT";
	int QUEST_CURRENTLY_COMBATING = 0;
	string QUEST_DATA1 = "QUEST_DATA1";
	bool QUEST_EXPERT_COMBATANT = false;
	string QUEST_FADE_ON_COMPLETE = "QUEST_FADE_ON_COMPLETE";
	string QUEST_FAILED = "QUEST_FAILED";
	int QUEST_FOLLOWER = 0;
	string QUEST_GIVER_NAME = "QUEST_GIVER_NAME";
	string QUEST_MODE = "QUEST_MODE";
	bool QUEST_REWARD_ALL = false;
	string QUEST_REWARD_EVENT = "QUEST_REWARD_EVENT";
	string QUEST_REWARD_TYPE = "QUEST_REWARD_TYPE";
	CBasePlayer@ QUEST_TAKER = null;
	float QUEST_TAKER_MAXHP = 0.0f;
	string QUEST_TYPE = "QUEST_TYPE";
	string QUEST_WAITING = "QUEST_WAITING";
	string QUEST_WAITING_TEXT = "QUEST_WAITING_TEXT";
	int SET_SIEGE_MODE = 0;
	string SUBMODEL_GROUPS = "SUBMODEL_GROUPS";
	bool USE_LANTERN = false;
	string USE_SKIN = "USE_SKIN";
	bool USING_BASE_QUEST = false;

	// Variables declared by included files, with the value they start with in this script
	QuestDwarfScript()
	{
		ANIM_IDLE = "idle";
		ANIM_WALK = "walk";
		ANIM_RUN = "run";
		SOUND_DEATH = "voices/dwarf/vs_nx0drogm_hit3.wav";
		NPC_FIGHTS_NPCS = true; // from monsters/base_battle_ally
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files

	// npcatk_suspend_ai
	void OnNpcatkSuspendAi(string seconds = "", string debugTag = "")
	{
		BaseNpcAttackNew_OnNpcatkSuspendAi(seconds, debugTag); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcatkSuspendAi(seconds, debugTag); // monsters/base_monster_shared
	}

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("3dmflagry.spr");
		Precache("dwarf/male1.mdl");
		Precache("voices/dwarf/vs_ndwarfm1_hit1.wav");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		QuestDwarf_FirstThink();
		BaseNpc_FirstThink();
		MonstersExternals_FirstThink();
		BaseNpcAttackNew_FirstThink();
		BaseMonsterShared_FirstThink();
		BaseBattleAlly_FirstThink();
		BaseChatArray_FirstThink();
		BaseStruck_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return QuestDwarf_DispatchEvent(name, params)
			|| BaseBattleAlly_DispatchEvent(name, params)
			|| BaseChatArray_DispatchEvent(name, params)
			|| BaseStruck_DispatchEvent(name, params)
			|| DwarfLanternBase_DispatchEvent(name, params)
			|| BaseMonsterNewScript::DispatchEvent(name, params);
	}
}
