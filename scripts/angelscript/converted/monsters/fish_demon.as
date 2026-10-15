#pragma context server

// Converted from monsters/fish_demon.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/fish_base.as"

[script "monsters/fish_demon"]
class FishDemon : FishBaseScript
{
	// Variables declared by included files, with the value they start with in this script
	FishDemon()
	{
		ANIM_IDLE = "idle";
		ANIM_WALK = "swim";
		ANIM_RUN = "thrust";
		ANIM_ATK_BIG = "srattack1";
		ANIM_ATK1 = "bite_r";
		ANIM_ATK2 = "bite_l";
		CHANCE_SWALLOW = "10%";
		PUSH_RANGE = 140;
		ATTACK_HITCHANCE = "70";
		SOUND_IDLE1 = "ichy/ichy_idle1.wav";
		SOUND_IDLE2 = "ichy/ichy_idle2.wav";
		SOUND_ATTACK1 = "ichy/ichy_bite1.wav";
		SOUND_ATTACK2 = "ichy/ichy_bite2.wav";
		SOUND_STRUCK1 = "ichy/ichy_pain2.wav";
		SOUND_STRUCK2 = "ichy/ichy_pain3.wav";
		SOUND_STRUCK3 = "ichy/ichy_pain5.wav";
		SOUND_STRUCK4 = "ichy/ichy_pain3.wav";
		SOUND_STRUCK5 = "ichy/ichy_pain5.wav";
		SOUND_DEATH = "ichy/ichy_die2.wav";
		NPC_HACKED_MOVE_SPEED = 300.0f;
	}

	// unnamed block (first think)
	void FishDemon_FirstThink()
	{
		// from shark
		ANIM_IDLE = "idle";
		ANIM_WALK = "swim";
		ANIM_RUN = "thrust";
		ANIM_DEATH = "die1";
		ANIM_ATTACK = "bite_r";

		MOVE_RANGE = "40";
		ATTACK_RANGE = 140.0f;
		ATTACK_HITRANGE = 200.0f;

		NPC_HACKED_MOVE_SPEED = 300.0f; // base_propelled

		NPC_GIVE_EXP = 300.0f;
	}

	// unnamed block (timer)
	void FishDemon_Timer()
	{
		CallEventDelayed(0.1f, "FishDemon_Timer");
		// push target around in water
		if (!IsAlive(HUNT_LASTTARGET))
			return;
		if (!(RangeTo(HUNT_LASTTARGET) < PUSH_RANGE))
			return;
		AddVelocity(HUNT_LASTTARGET, RelativeVelocity(Vector3(0, 125, 0)));
	}

	// unnamed block (timer)
	// fly mods
	void FishDemon_Timer2()
	{
		CallEventDelayed(0.5f, "FishDemon_Timer2");

		if (RangeTo(HUNT_LASTTARGET) < ATTACK_RANGE)
			PlayAnim("once", ANIM_ATTACK);

		if (!IS_HUNTING)
			return;
		OnNpcatkFaceattacker();
		if (RangeTo(HUNT_LASTTARGET) > Float(MOVE_RANGE))
			SetVelocity(ENT_ME, RelativeVelocity(Vector3(0, 200, 0)));
		if (RangeTo(HUNT_LASTTARGET) <= Float(MOVE_RANGE))
			SetVelocity(ENT_ME, Vector3(0, 0, 0));

		// if ( SPITTING ) setvelocity ent_me $vec(0,0,0)
		if (FLIGHT_STUCK > 4.0f)
		{
			// callevent chicken_run 1.0
			OnDoRandTweedee();
			OnNpcatkSuspendAi(Text(Random(0.3f, 0.9f)));
			SetMoveDest("NEW_DEST", Eval("game.monster.moveprox"));
			CallEventDelayed(0.1f, "horror_boost");
			FLIGHT_STUCK = 0.0f;
		}

		Vector3 targPos = OriginOf(NPCATK_TARGET);
		if (!SUSPEND_AI)
			SetAngle("face_origin", targPos);

		if (IS_FLEEING)
			return;
		if (!(RangeTo(NPCATK_TARGET) > ATTACK_RANGE))
			return;
		float curProg = Distance(MyOrigin(), targPos);
		if (LAST_PROG >= curProg)
			FLIGHT_STUCK += 1.0f;
		LAST_PROG = Distance(MyOrigin(), targPos);
		LAST_POS = MyOrigin();
	}

	// chicken_run
	void OnChickenRun(float duration = 0.0f)
	{
		BaseNpcAttack_OnChickenRun(duration); // monsters/base_npc_attack
		CallEventDelayed(0.1f, "horror_boost");
	}

	// cycle_up
	// end anim events ============================================
	void OnCycleUp(string reason = "")
	{
		BaseNpcAttack_OnCycleUp(reason); // monsters/base_npc_attack
		if (CYCLES_ON)
			return;
		CYCLES_ON = true;
		CallEventDelayed(FREQ_SWALLOW, "do_swallow");
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck
		FishBase_OnNpcSpawn(npc); // monsters/fish_base

		SetHealth(1500);
		SetName("Demon Fish");
		SetModel("monsters/devil_fish1.mdl");
		SetBoundingBox("animsize");
		SetWidth(96);
		SetHeight(96);
		SetHearingSensitivity(10);
		SetGravity(0.02f);
	}

	// bite_r
	// anim events ============================================
	// called from both bite_r and bite_l
	void OnBiteR()
	{
		PlayRandomSound(0, 7, SOUND_ATTACK1, SOUND_ATTACK2);

		if (ANIM_ATTACK == "bite_l")
		{
			// dodamage <target> <range> <dmg> <cth> [type]
			OnNpcatkDodamage(HUNT_LASTTARGET, Text(ATTACK_HITRANGE), Text(DMG_BITE), ATTACK_HITCHANCE, EntityId(self), "slash");
			AddVelocity(HUNT_LASTTARGET, Vector3(100, 0, 0));
			ANIM_ATTACK = "bite_r";
		}
		else
		{
			OnNpcatkDodamage(HUNT_LASTTARGET, Text(ATTACK_HITRANGE), Text(DMG_BITE), ATTACK_HITCHANCE, EntityId(self), "slash");
			AddVelocity(HUNT_LASTTARGET, Vector3(-100, 0, 0));
			ANIM_ATTACK = "bite_l";
		}
	}

	// big_bite1
	void OnBigBite1()
	{
		PlayRandomSound(0, 10, SOUND_ATTACK1, SOUND_ATTACK2);
		OnNpcatkDodamage(HUNT_LASTTARGET, Text(ATTACK_HITRANGE), Text(DMG_BITE2), ATTACK_HITCHANCE, EntityId(self), "slash");
		AddVelocity(HUNT_LASTTARGET, Vector3(-100, 200, 0));
		ANIM_ATTACK = "bite_l";
	}

	// big_bite2
	void OnBigBite2()
	{
		PlayRandomSound(0, 10, SOUND_ATTACK1, SOUND_ATTACK2);
		OnNpcatkDodamage(HUNT_LASTTARGET, Text(ATTACK_HITRANGE), Text(DMG_BITE3), ATTACK_HITCHANCE, EntityId(self), "slash");
		AddVelocity(HUNT_LASTTARGET, Vector3(100, 200, 0));
		ANIM_ATTACK = "bite_r";
	}

	// do_swallow
	void OnDoSwallow()
	{
		CallEventDelayed(FREQ_SWALLOW, "do_swallow");
		if (HUNT_LASTTARGET == "\xEF\xBF\xBDNONE\xEF\xBF\xBD")
			return;
		ANIM_ATTACK = ANIM_ATK_BIG;
	}

	// horror_boost
	void OnHorrorBoost()
	{
		SetVelocity(ENT_ME, RelativeVelocity(Vector3(0, 500, 0)));
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files
	void OnFreqSwallow() {} // FREQ_SWALLOW
	void OnDoRandTweedee() {} // do_rand_tweedee

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/devil_fish1.mdl");
		CallEventDelayed(Float(Eval("$rand(10,25)")), "FishBase_Timer");
		CallEventDelayed(0.1f, "FishDemon_Timer");
		CallEventDelayed(0.5f, "FishDemon_Timer2");
		CallEventDelayed(Float(CYCLE_TIME), "hunting_mode_go");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		FishDemon_FirstThink();
		FishBase_FirstThink();
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
		if (name == "big_bite1") { OnBigBite1(); return true; }
		if (name == "big_bite2") { OnBigBite2(); return true; }
		if (name == "bite_r") { OnBiteR(); return true; }
		if (name == "chicken_run") { OnChickenRun(Float(Param(params, 0))); return true; }
		if (name == "cycle_up") { OnCycleUp(Param(params, 0)); return true; }
		if (name == "do_swallow") { OnDoSwallow(); return true; }
		if (name == "horror_boost") { OnHorrorBoost(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "FishDemon_Timer") { FishDemon_Timer(); return true; }
		if (name == "FishDemon_Timer2") { FishDemon_Timer2(); return true; }
		return FishBaseScript::DispatchEvent(name, params);
	}
}
