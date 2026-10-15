#pragma context server

// Converted from the_wall/telf_necro.script by msc_transpiler.
// Intended to be escorted by a messload of nasty undead

#include "runtime/ScriptEntity.as"
#include "converted/monsters/elf_wizard_base.as"

[script "the_wall/telf_necro"]
class TelfNecro : ElfWizardBaseScript
{
	// Constants
	float FREQ_BARRIER = 30.0f;
	float DMG_BARRIER = 200.0f;
	int BARRIER_RAD = 96;
	float FREQ_BEAM_CHANGE = 0.0f;
	string SOUND_BEAM_LOOP_HOLD = "ambience/dronemachine1.wav";
	string SOUND_BEAM_LOOP_LIGHTNING = "magic/bolt_loop.wav";
	string SOUND_BEAM_LOOP_FROST = "magic/freezeray_loop.wav";
	string SOUND_BARRIER_RAISE = "magic/spawn.wav";
	string SOUND_BARRIER_REPELL = "doors/aliendoor3.wav";

	// Variables (an unset .script variable reads as its own name)
	bool NPC_RETURN_HOME = false;
	bool CYCLES_ON = false;
	float NEXT_BARRIER = 0.0f;
	string NExT_BEAM_CHANGE = "NExT_BEAM_CHANGE";
	float NEXT_BEAM_CHANGE = 0.0f;
	float RND_BEAM = 0.0f;
	string SOUND_ELF_BEAM_LOOP = "SOUND_ELF_BEAM_LOOP";
	bool BARRIER_ON = false;
	string BARRIER_TARGS = "BARRIER_TARGS";

	// Variables declared by included files, with the value they start with in this script
	TelfNecro()
	{
		ELF_BEAM_RANGE = 1024;
	}

	// unnamed block (first think)
	void TelfNecro_FirstThink()
	{
		RETALIATE_CHANCE = "10%";

		if (ToLowerCase(MapName()) == "the_wall")
		{
			NPC_GIVE_EXP = 15000.0f;
			NPC_IS_BOSS = true;
		}
		else
		{
			NPC_GIVE_EXP = 5000.0f;
		}

		NPC_RETURN_HOME = true;
	}

	// game_precache
	void TelfNecro_OnGamePrecache()
	{
	}

	// game_precache
	void OnGamePrecache()
	{
		TelfNecro_OnGamePrecache();
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
		SayText("Death... Awaits you... Beyond the door...");
		SetModelBody(2, 0);
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
		ELF_BEAM_DMG = 300;
		ELF_BEAM_DOT = 100;
		ELF_BEAM_DMG_TYPE = "lightning";
		ELF_BEAM_PUSH_VEL = RelativeVelocity(Vector3(0, 300, 110));
		ELF_BEAM_DUR = 5.0f;
		ELF_BEAM_ATTACK = true;
		ELF_BEAM_COLOR = Vector3(255, 255, 0);
		ELF_BEAM_EFFECT = "effects/dot_lightning";

		ANIM_ATTACK = "ref_shoot_crowbar";
		ATTACK_RANGE = 64.0f;
		ATTACK_HITRANGE = 120.0f;
		ATTACK_MOVERANGE = 512.0f;
	}

	// npcatk_hunt
	void OnNpcatkHunt()
	{
		BaseNpcAttackNew_OnNpcatkHunt(); // monsters/base_npc_attack_new
		BaseAntiStuck_OnNpcatkHunt(); // monsters/base_anti_stuck
		ElfWizardBase_OnNpcatkHunt(); // monsters/elf_wizard_base
		float gameTime = GameTime();
		if (gameTime > NEXT_BEAM_CHANGE && !ELF_BEAM_ON)
		{
			// local RND_BEAM $rand(1,3) //fuck random
			RND_BEAM += 1.0f;
			if (RND_BEAM > 3.0f)
				RND_BEAM = 1.0f;
			if (RND_BEAM == 1.0f)
			{
				ELF_BEAM_COLOR = Vector3(255, 255, 0);
				ELF_BEAM_SPECIAL = "none";
				ELF_BEAM_DMG_TYPE = "lightning";
				ELF_BEAM_EFFECT = "effects/dot_lightning";
				ELF_BEAM_PUSH_VEL = RelativeVelocity(Vector3(0, 400, 110));
				ELF_BEAM_DMG = 300;
				ELF_BEAM_DOT = 100;
				SOUND_ELF_BEAM_LOOP = SOUND_BEAM_LOOP_LIGHTNING;
			}
			if (RND_BEAM == 2.0f)
			{
				ELF_BEAM_COLOR = Vector3(128, 128, 255);
				ELF_BEAM_SPECIAL = "none";
				ELF_BEAM_DMG_TYPE = "cold";
				ELF_BEAM_EFFECT = "effects/dot_cold";
				ELF_BEAM_PUSH_VEL = RelativeVelocity(Vector3(0, 400, 110));
				ELF_BEAM_DMG = 100;
				ELF_BEAM_DOT = 50;
				SOUND_ELF_BEAM_LOOP = SOUND_BEAM_LOOP_FROST;
			}
			if (RND_BEAM == 3.0f)
			{
				ELF_BEAM_COLOR = Vector3(255, 0, 0);
				ELF_BEAM_SPECIAL = "hold_person";
				ELF_BEAM_DMG_TYPE = "magic";
				ELF_BEAM_EFFECT = "effects/debuff_hold";
				ELF_BEAM_PUSH_VEL = RelativeVelocity(Vector3(0, 0, 0));
				ELF_BEAM_DMG = 50;
				ELF_BEAM_DOT = 0;
				SOUND_ELF_BEAM_LOOP = SOUND_BEAM_LOOP_HOLD;
			}
		}

		if (NPCATK_TARGET == "unset")
			return;

		if (!(gameTime > NEXT_BARRIER))
			return;
		NEXT_BARRIER = gameTime + FREQ_BARRIER;
		OnDoBarrier();
	}

	// cycle_up
	void OnCycleUp(string reason = "")
	{
		BaseNpcAttackNew_OnCycleUp(reason); // monsters/base_npc_attack_new
		if (CYCLES_ON)
			return;
		CYCLES_ON = true;
		SayText("Ah, fresh corpses...");

		PlayAnim("critical", "ref_shoot_trip");
		UseTrigger("spawn_aod");
		AS_ATTACKING = GameTime();

		float gameTime = GameTime();
		NEXT_BARRIER = gameTime + FREQ_BARRIER;
		NExT_BEAM_CHANGE = Text(gameTime);
		NEXT_BEAM_CHANGE += FREQ_BEAM_CHANGE;
	}

	// elf_spawn
	void OnElfSpawn()
	{
		GiveItem("item_telfh4");

		SetName("Ihotohr");
		SetHealth(10000);
		SetRace("necro");

		SetDamageTaken("all", 0.5f);
		SetDamageTaken("holy", 1);

		SetSayTextRange(2048);

		SetModelBody(1, 1); // 0=Unarmed 1=Dark_Staff 2=Dragon_Staff 3=H4xbow
		SetProp(ENT_ME, "skin", 5); // 0=Young_Black_Robe 1=Elder_Black_Robe 2=Young_Green_Robe 3=Elder_Green_Robe 4=Young_Puce_Robe 5=Elder_Puce_Robe 6=Good_Pale 7=Good_Pink
	}

	// elf_beam_special
	// <target>
	void OnElfBeamSpecial(string target = "")
	{
		ApplyEffect(target, "effects/debuff_hold", 10.0f);
	}

	// do_barrier
	void OnDoBarrier()
	{
		PlaySound(0, 10, SOUND_BARRIER_RAISE);
		// clientevent new all effects/sfx_barrier $get(ent_me,index) BARRIER_RAD (255,0,0) 20.0 1 1
		SetModelBody(2, 1);
		BARRIER_ON = true;
		CallEventDelayed(20.0f, "end_barrier");
		OnBarrierLoop();
	}

	// end_barrier
	void OnEndBarrier()
	{
		BARRIER_ON = false;
		SetModelBody(2, 0);
		PlaySound(0, 10, SOUND_BARRIER_RAISE);
	}

	// barrier_loop
	void OnBarrierLoop()
	{
		if (!BARRIER_ON)
			return;
		CallEventDelayed(0.5f, "barrier_loop");
		BARRIER_TARGS = FindInSphere("enemy", BARRIER_RAD);
		if (BARRIER_TARGS == "none")
			return;
		PlaySound(0, 10, SOUND_BARRIER_REPELL);
		int count = GetTokenCount(BARRIER_TARGS);
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnBarrierAffectTargets();
		}
	}

	// barrier_affect_targets
	void OnBarrierAffectTargets()
	{
		CBaseEntity@ curTarg = FindEntity(GetToken(BARRIER_TARGS, loopIteration));
		Vector3 targOrg = OriginOf(curTarg);
		float targAng = AnglesTo(MyOrigin(), targOrg);
		SetVelocity(curTarg, RelativeVelocity(Vector3(0, targAng, 0), Vector3(10, 1000, 0)));
		DoDamage(curTarg, "direct", DMG_BARRIER, "100%", ENT_ME, "magic");
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		TelfNecro_FirstThink();
		ElfWizardBase_FirstThink();
		ElfWizardBase_FirstThink2();
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
		if (name == "barrier_affect_targets") { OnBarrierAffectTargets(); return true; }
		if (name == "barrier_loop") { OnBarrierLoop(); return true; }
		if (name == "cycle_up") { OnCycleUp(Param(params, 0)); return true; }
		if (name == "do_barrier") { OnDoBarrier(); return true; }
		if (name == "elf_beam_special") { OnElfBeamSpecial(Param(params, 0)); return true; }
		if (name == "elf_spawn") { OnElfSpawn(); return true; }
		if (name == "end_barrier") { OnEndBarrier(); return true; }
		if (name == "game_death") { OnGameDeath(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_precache") { OnGamePrecache(); return true; }
		if (name == "npc_post_spawn") { OnNpcPostSpawn(); return true; }
		if (name == "npcatk_hunt") { OnNpcatkHunt(); return true; }
		return ElfWizardBaseScript::DispatchEvent(name, params);
	}
}
