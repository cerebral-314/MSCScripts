#pragma context server

// Converted from helena/archer.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/NPCs/human_guard_archer.as"

[script "helena/archer"]
class HelenaArcher : HumanGuardArcherScript
{
	// Variables declared by included files, with the value they start with in this script
	HelenaArcher()
	{
		NO_CHAT = true;
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseNpcAttackNew_OnNpcSpawn(npc); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck
		BaseGuardFriendlyNew_OnNpcSpawn(npc); // monsters/base_guard_friendly_new
		HumanGuardArcher_OnNpcSpawn(npc); // NPCs/human_guard_archer

		SetUniqueName("Archer");

		if (ToLowerCase(MapName()) == "foutpost")
		{
			SetRace("human");
			NPC_NO_PLAYER_DMG = true; // foutpost guards maybe forced to work amongst AOE player spells
		}

		if (MapName() != "helena")
			return;
		SetAngle("face", Vector3(0, 90, 0)); // in the future, please do not force your NPCs to face a paticular dir (let mapper)
	}

	// LightAttack
	void OnLightAttack()
	{
		int rand = RandomInt(1, 100);
		if (rand > 60)
		{
			SetSayTextRange(500);
			if (rand < 85)
				SayText("Small attack party incoming!");
			else
				SayText("Raiding party!");
		}
	}

	// MediumAttack
	void OnMediumAttack()
	{
		int rand = RandomInt(1, 100);
		if (rand > 60)
		{
			SetSayTextRange(500);
			if (rand < 85)
				SayText("Large attack group heading for us!");
			else
				SayText("Stand ready for the attack!");
		}
	}

	// HeavyAttack
	void OnHeavyAttack()
	{
		int rand = RandomInt(1, 100);
		if (rand > 60)
		{
			SetSayTextRange(500);
			if (rand < 85)
				SayText("It's a siege!");
			else
				SayText("We need everyone at the gates! NOW!");
		}
	}

	// CatapaultsIncoming
	void OnCatapaultsIncoming()
	{
		int rand = RandomInt(1, 100);
		if (rand > 60)
		{
			SetSayTextRange(500);
			if (rand < 85)
				SayText("Take cover!");
			else
				SayText("Projectiles inbound!");
		}
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "CatapaultsIncoming") { OnCatapaultsIncoming(); return true; }
		if (name == "HeavyAttack") { OnHeavyAttack(); return true; }
		if (name == "LightAttack") { OnLightAttack(); return true; }
		if (name == "MediumAttack") { OnMediumAttack(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		return HumanGuardArcherScript::DispatchEvent(name, params);
	}
}
