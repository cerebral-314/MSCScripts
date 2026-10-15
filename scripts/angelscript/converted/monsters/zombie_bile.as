#pragma context server

// Converted from monsters/zombie_bile.script by msc_transpiler.
// This is an older script and may have some bad conventions as a result.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/zombie.as"

[script "monsters/zombie_bile"]
class ZombieBile : MonstersZombieScript
{
	// Constants
	int DMG_PROJECTILE = 20;
	string NPC_BASE_EXP = "80";
	string SOUND_SHOOT1 = "bullchicken/bc_attack2.wav";
	string SOUND_SHOOT2 = "bullchicken/bc_attack3.wav";

	// Variables (an unset .script variable reads as its own name)
	float NEXT_BILE = 0.0f;
	bool DOING_PROJECTILE = false;

	// Variables declared by included files, with the value they start with in this script
	ZombieBile()
	{
		ZOMBIE_NAME = "Byle Zombie";
	}

	// npc_targetsighted
	void OnNpcTargetsighted(string target = "")
	{
		BaseMonsterShared_OnNpcTargetsighted(target); // monsters/base_monster_shared
		if (!(GameTime() > NEXT_BILE))
			return;
		NEXT_BILE = GameTime() + 3.0f;
		if (!(RangeTo(NPCATK_TARGET) > 256.0f))
			return;
		AS_ATTACKING = GameTime() + 5.0f;
		PlayAnim("critical", ANIM_DISEASE);
		DOING_PROJECTILE = true;
	}

	// attack_2
	void OnAttack22()
	{
		I_ATTACKING = true;
		OnNpcatkDodamage(NPCATK_TARGET, Text(ATTACK_HITRANGE), ATTACK_DAMAGE, ATTACK_HITCHANCE, "blunt");

		if (DOING_PROJECTILE)
		{
			PlayRandomSound(0, 10, SOUND_SHOOT1, SOUND_SHOOT2);
			if (RandomInt(1, 5) == 1)
			{
				// <projectile scriptname> <"view"|(src_origin)> <target|(targ_origin)|none> <speed> <damage> <cof> <skill|none> //Converted to use new tossprojectile //greatguys1@FEB2022
				TossProjectile("proj_poison_spit2", RelativePosition(Vector3(0, 10, 24)), NPCATK_TARGET, 300, DMG_PROJECTILE, 2, "none");
				Effect("glow", ENT_LASTPROJECTILE, Vector3(0, 255, 0), 64, -1, 0);
			}
			else
			{
				TossProjectile("proj_poison", RelativePosition(Vector3(0, 10, 24)), NPCATK_TARGET, 300, DMG_PROJECTILE, 2, "none");
			}
		}

		if (!DOING_PROJECTILE)
		{
			I_DISEASE = true;
			ANIM_ATTACK = ANIM_SWIPE;
		}

		DOING_PROJECTILE = false;
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "attack_2") { OnAttack22(); return true; }
		if (name == "npc_targetsighted") { OnNpcTargetsighted(Param(params, 0)); return true; }
		return MonstersZombieScript::DispatchEvent(name, params);
	}
}
