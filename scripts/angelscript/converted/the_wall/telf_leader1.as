#pragma context server

// Converted from the_wall/telf_leader1.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/telf_warrior_idagger.as"

[script "the_wall/telf_leader1"]
class TelfLeader1 : TelfWarriorIdaggerScript
{
	// Variables declared by included files, with the value they start with in this script
	TelfLeader1()
	{
		NPC_BASE_EXP = "5000";
		OVR_DROP_GOLD_AMT = "5000";
	}

	// unnamed block (first think)
	void TelfLeader1_FirstThink()
	{
		NPC_IS_BOSS = true;

		SetGlobal("G_DID_ESCORT_ALERT", 0);
		SetGlobal("G_ESCORT_ALERT_SAYTEXT", "Azura! The Felewyn seekers have sent humans after us!");
	}

	// game_death
	void OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		DqMonsterExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // dq/externals/dq_monster_externals
		MonstersExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/externals
		BaseSelfAdjust_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_self_adjust
		BaseNpc_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseMonsterShared_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared
		SetGlobal("G_ESCORT_ALERT_SAYTEXT", "G_ESCORT_ALERT_SAYTEXT");
	}

	// npc_targetsighted
	void OnNpcTargetsighted(string target = "")
	{
		BaseMonsterShared_OnNpcTargetsighted(target); // monsters/base_monster_shared
		ElfWarriorBase_OnNpcTargetsighted(target); // monsters/elf_warrior_base
		if (!IsPlayer(NPCATK_TARGET))
			return;
		if (DID_INTRO != 0)
			return;
		DID_INTRO = 1;
		SayText("No! I'll not be taken back! Not even by humans!");
	}

	// elf_spawn
	void OnElfSpawn()
	{
		SetName("Frostmistress Azura");
		// Torkalath Warrior - Club (stun)
		// Torkalath Assasin - Dagger (poison - maybe throw?)
		// Torkalath Slasher - Axe (more hp)
		// Torkalath Blademistress - Dbl Sword (more dmg)
		// Torkalath Shadowarcher - different base? (spiral arrows)
		SetHealth(6000);
		SetDamageTaken("all", 0.5f);
		SetRace("torkie");

		SetModelBody(1, 6); // 0=Unarmed 1=Dagger 2=Mace 3=Axe 4=Sword 5=Bow 6=Litchtounge

		GiveItem("item_telfh1");

		SetSayTextRange(1024);
		CatchSpeech("say_no", "elf", "no", "elves");

		LegacyCommand("add", "G_TELF_LEADER_COUNTER", 1);
	}

	// say_no
	void OnSayNo(CBasePlayer@ player = null)
	{
		if (Float(GetVar("G_TELF_ESCORTS")) > 1.0f)
			SayText("Lies! Kill them! KILL THEM NOW!");
		else
			SayText("Lies! You'll not take any of us alive!");
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		TelfLeader1_FirstThink();
		TelfWarriorIdagger_FirstThink();
		ElfWarriorBase_FirstThink();
		ElfWarriorBase_FirstThink2();
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
		if (name == "elf_spawn") { OnElfSpawn(); return true; }
		if (name == "game_death") { OnGameDeath(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "npc_targetsighted") { OnNpcTargetsighted(Param(params, 0)); return true; }
		if (name == "say_no") { OnSayNo(PlayerParam(params, 0)); return true; }
		return TelfWarriorIdaggerScript::DispatchEvent(name, params);
	}
}
