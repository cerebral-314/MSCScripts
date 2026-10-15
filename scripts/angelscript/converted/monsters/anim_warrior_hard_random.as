#pragma context server

// Converted from monsters/anim_warrior_hard_random.script by msc_transpiler.
// Thothie - Greater Animated Warrior - Keledros's Personal Summoned Guards
// - In attempt to solve Keledros brain death issue
// - Differences >HP >Damage BurnEffect FireResistant ColdVulnerable
// Orc base

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_monster_new.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class AnimWarriorHardRandom
{
	// Constants
	string SOUND_STRUCK1 = "body/armour1.wav";
	string SOUND_STRUCK2 = "body/armour2.wav";
	string SOUND_STRUCK3 = "body/armour3.wav";
	string SOUND_HIT = "body/armour3.wav";
	string SOUND_HIT2 = "body/armour2.wav";
	string SOUND_HIT3 = "body/armour1.wav";
	string SOUND_PAIN = "body/armour1.wav";
	string SOUND_ATTACK1 = "none";
	string SOUND_ATTACK2 = "none";
	string SOUND_ATTACK3 = "none";
	string SOUND_DEATH = "none";
	string ATTACK_ACCURACY = "85%";
	float ATTACK_DMG_LOW = 50.0f;
	float ATTACK_DMG_HIGH = 100.0f;
	int LIGHT_RAD = 64;

	// Variables (an unset .script variable reads as its own name)
	bool IS_UNHOLY = true;
	string ANIM_RUN = "run";
	string ANIM_IDLE = "idle1";
	string ANIM_WALK = "walk";
	string LAST_ENEMY = "`NONE`";
	bool IMMUNE_VAMPIRE = false;
	string ANIM_DEATH = "ANIM_DEATH";
	string MOVE_RANGE = "MOVE_RANGE";
	float ATTACK_RANGE = 0.0f;
	float ATTACK_HITRANGE = 0.0f;
	int DROP_GOLD = 0;
	float DROP_GOLD_AMT = 0.0f;
	float NPC_GIVE_EXP = 0.0f;
	string FLINCH_CHANCE = "FLINCH_CHANCE";
	string FLINCH_DELAY = "FLINCH_DELAY";
	string CAN_FLINCH = "CAN_FLINCH";
	bool IMMUNE_POISON = false;
	string ARMOR_TYPE = "ARMOR_TYPE";
	string DAMAGE_TYPE = "DAMAGE_TYPE";
	string ANIM_ATTACK = "ANIM_ATTACK";
	string LIGHT_COLOR = "LIGHT_COLOR";
	string ANIM_FLINCH = "ANIM_FLINCH";
	string MY_LIGHT_SCRIPT = "MY_LIGHT_SCRIPT";

	// unnamed block (first think)
	void AnimWarriorHardRandom_FirstThink()
	{
		IS_UNHOLY = true;
		IMMUNE_VAMPIRE = true;
		ANIM_RUN = "run";
		ANIM_IDLE = "idle1";
		ANIM_WALK = "walk";
		ANIM_DEATH = "die";
		LAST_ENEMY = "`NONE`";
		MOVE_RANGE = "44";
		ATTACK_RANGE = 82.0f;
		ATTACK_HITRANGE = 128.0f;
		DROP_GOLD = 1; // Gold Drops
		DROP_GOLD_AMT = RandomInt(20, 40);
		NPC_GIVE_EXP = 450.0f;

		FLINCH_CHANCE = "10%";
		FLINCH_DELAY = "20.0";
		CAN_FLINCH = "1";

		IMMUNE_VAMPIRE = true;

		IMMUNE_POISON = true;
	}

	// npc_spawn
	void AnimWarriorHardRandom_OnNpcSpawn(string npc = "")
	{
		SetModel("monsters/animarmor.mdl");
		SetWidth(40);
		SetHeight(90);
		SetBlood("none");

		SetRoam(true);
		SetRace("demon");
		SetHealth(800);

		SetHearingSensitivity(4);

		SetDamageTaken("poison", 0);
		SetDamageTaken("holy", 1);
		SetIdleAnim(ANIM_IDLE);
		SetMoveAnim(ANIM_WALK);

		CallEventDelayed(0.1f, "select_armor");
	}

	// select_armor
	void AnimWarriorHardRandom_OnSelectArmor()
	{
		if (ARMOR_TYPE == "ARMOR_TYPE")
			ARMOR_TYPE = RandomInt(1, 4);

		if (Float(ARMOR_TYPE) == 1.0f)
		{
			SetName("Enchanted Armor of Fire");
			DAMAGE_TYPE = "fire";
			SetDamageTaken("all", 0.4f);
			SetDamageTaken("lightning", 1.5f);
			SetDamageTaken("fire", 0);
			SetDamageTaken("cold", 2.5f);
			ANIM_ATTACK = "battleaxe_swing1_L";
			SetModelBody(0, 0);
			SetModelBody(1, 2); // Head: 0=CapW/horns 1=Capw/Spikes 2=Skull
			SetModelBody(2, 5); // Weapon: 0=Unarmed(Litterally!) 1=Axe 2=woodbow 3=steelbow 4=sword 5=bloodaxe
			LIGHT_COLOR = Text(Vector3(255, 0, 0));
		}

		if (Float(ARMOR_TYPE) == 2.0f)
		{
			SetName("Enchanted Armor of Thunder");
			DAMAGE_TYPE = "lightning";
			SetDamageTaken("all", 0.4f);
			SetDamageTaken("lightning", 0);
			SetDamageTaken("acid", 3);
			SetDamageTaken("fire", 1);
			SetDamageTaken("cold", 1);
			ANIM_ATTACK = "swordswing1_L";
			SetModelBody(0, 0);
			SetModelBody(1, 2); // Head: 0=CapW/horns 1=Capw/Spikes 2=Skull
			SetModelBody(2, 4); // Weapon: 0=Unarmed(Litterally!) 1=Axe 2=woodbow 3=steelbow 4=sword 5=bloodaxe
			LIGHT_COLOR = Text(Vector3(255, 255, 0));
		}

		if (Float(ARMOR_TYPE) == 3.0f)
		{
			SetName("Enchanted Armor of Frost");
			DAMAGE_TYPE = "cold";
			SetDamageTaken("all", 0.4f);
			SetDamageTaken("lightning", 1.5f);
			SetDamageTaken("fire", 2.5f);
			SetDamageTaken("cold", 0);
			ANIM_ATTACK = "battleaxe_swing1_L";
			SetModelBody(0, 0);
			SetModelBody(1, 2); // Head: 0=CapW/horns 1=Capw/Spikes 2=Skull
			SetModelBody(2, 1); // Weapon: 0=Unarmed(Litterally!) 1=Axe 2=woodbow 3=steelbow 4=sword 5=bloodaxe
			LIGHT_COLOR = Text(Vector3(200, 200, 255));
		}

		if (Float(ARMOR_TYPE) == 4.0f)
		{
			SetName("Enchanted Armor of Venom");
			DAMAGE_TYPE = "poison";
			SetDamageTaken("all", 0.4f);
			SetDamageTaken("lightning", 3);
			ANIM_ATTACK = "swordswing1_L";
			SetModelBody(0, 0);
			SetModelBody(1, 2); // Head: 0=CapW/horns 1=Capw/Spikes 2=Skull
			SetModelBody(2, 4); // Weapon: 0=Unarmed(Litterally!) 1=Axe 2=woodbow 3=steelbow 4=sword 5=bloodaxe
			LIGHT_COLOR = Text(Vector3(0, 255, 0));
		}

		Effect("glow", ENT_ME, LIGHT_COLOR, 64, -1, 0);
	}

	// npc_death
	// On death, don't display weapon
	void AnimWarriorHardRandom_OnNpcDeath()
	{
		SetModelBody(2, 0); // Hide weapon
		SetModelBody(4, 0); // Hide Shield
	}

	// npc_struck
	// Hit by someone
	void AnimWarriorHardRandom_OnNpcStruck(float damage = 0.0f)
	{
		PlayRandomSound(0, 10, SOUND_PAIN, SOUND_STRUCK2, SOUND_PAIN, "none", "none");
	}

	// swing_dodamage
	void AnimWarriorHardRandom_OnSwingDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		if (DAMAGE_TYPE == "fire")
			ApplyEffect(target, "effects/dot_fire", 30, self, RandomInt(5, 12));
		if (DAMAGE_TYPE == "cold")
			ApplyEffect(target, "effects/dot_cold", 10, self, RandomInt(5, 12));
		if (DAMAGE_TYPE == "lightning")
			ApplyEffect(target, "effects/dot_lightning", 10, self, RandomInt(5, 12));
		if (DAMAGE_TYPE == "poison")
			ApplyEffect(target, "effects/dot_poison", 30, self, RandomInt(5, 12));
		// (never true here, the rest is skipped) if ATTACK_PUSH isnot 'ATTACK_PUSH'
	}

	// swing_axe
	// called from model
	void AnimWarriorHardRandom_OnSwingAxe()
	{
		float dmg = Random(ATTACK_DMG_LOW, ATTACK_DMG_HIGH);
		DoDamageEx(NPCATK_TARGET, ATTACK_HITRANGE, dmg, ATTACK_ACCURACY, ENT_ME, ENT_ME, "none", DAMAGE_TYPE, "dmgevent:swing");
	}

	// swing_sword
	// called from model
	void AnimWarriorHardRandom_OnSwingSword()
	{
		OnSwingAxe();
	}

	// npc_flinch
	void AnimWarriorHardRandom_OnNpcFlinch(float damage = 0.0f)
	{
		ANIM_FLINCH = "flinch";
		if (damage > 100.0f)
			ANIM_FLINCH = "flinch2";
		if (damage > 200.0f)
			ANIM_FLINCH = "flinch3";
	}

	// npc_post_spawn
	// ===light system
	// call at spawn or cycle_up
	void AnimWarriorHardRandom_OnNpcPostSpawn()
	{
		ClientEvent("persist", "all", "monsters/lighted_cl", IndexOf(ENT_ME), LIGHT_COLOR, LIGHT_RAD);
		MY_LIGHT_SCRIPT = LastClientScriptId();
	}

	// game_death
	void AnimWarriorHardRandom_OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		ClientEvent("remove", "all", MY_LIGHT_SCRIPT);
		ClientEvent("update", "all", MY_LIGHT_SCRIPT, "remove_me");
	}

	// unnamed block (timer)
	// ===end light system
	void AnimWarriorHardRandom_Timer()
	{
		CallEventDelayed(20.0f, "AnimWarriorHardRandom_Timer");
		Effect("glow", ENT_ME, LIGHT_COLOR, 64, -1, 0);
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
		AnimWarriorHardRandom_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4);
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
		AnimWarriorHardRandom_OnNpcPostSpawn();
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseNpcAttackNew_OnNpcSpawn(npc); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck
		AnimWarriorHardRandom_OnNpcSpawn(npc);
	}

	void OnSelectArmor() { AnimWarriorHardRandom_OnSelectArmor(); } // select_armor
	void OnNpcDeath() { AnimWarriorHardRandom_OnNpcDeath(); } // npc_death
	void OnNpcStruck(float damage = 0.0f) { AnimWarriorHardRandom_OnNpcStruck(damage); } // npc_struck
	void OnSwingDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "") { AnimWarriorHardRandom_OnSwingDodamage(hit, target, start, end, damageType, damageText); } // swing_dodamage
	void OnSwingAxe() { AnimWarriorHardRandom_OnSwingAxe(); } // swing_axe
	void OnSwingSword() { AnimWarriorHardRandom_OnSwingSword(); } // swing_sword
	void OnNpcFlinch(float damage = 0.0f) { AnimWarriorHardRandom_OnNpcFlinch(damage); } // npc_flinch

	// This file's events and timers by their .script names
	bool AnimWarriorHardRandom_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "game_death") { OnGameDeath(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "npc_death") { OnNpcDeath(); return true; }
		if (name == "npc_flinch") { OnNpcFlinch(Float(Param(params, 0))); return true; }
		if (name == "npc_post_spawn") { OnNpcPostSpawn(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "npc_struck") { OnNpcStruck(Float(Param(params, 0))); return true; }
		if (name == "select_armor") { OnSelectArmor(); return true; }
		if (name == "swing_axe") { OnSwingAxe(); return true; }
		if (name == "swing_dodamage") { OnSwingDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5)); return true; }
		if (name == "swing_sword") { OnSwingSword(); return true; }
		if (name == "AnimWarriorHardRandom_Timer") { AnimWarriorHardRandom_Timer(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "monsters/anim_warrior_hard_random"]
shared class AnimWarriorHardRandomScript : BaseMonsterNewScript, AnimWarriorHardRandom
{
	// Variables declared by included files, with the value they start with in this script
	AnimWarriorHardRandomScript()
	{
		ANIM_RUN = "run";
		ANIM_IDLE = "idle1";
		ANIM_WALK = "walk";
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/animarmor.mdl");
		CallEventDelayed(20.0f, "AnimWarriorHardRandom_Timer");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		AnimWarriorHardRandom_FirstThink();
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
		return AnimWarriorHardRandom_DispatchEvent(name, params)
			|| BaseMonsterNewScript::DispatchEvent(name, params);
	}
}
