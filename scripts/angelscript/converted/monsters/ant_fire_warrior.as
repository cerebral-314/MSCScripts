#pragma context server

// Converted from monsters/ant_fire_warrior.script by msc_transpiler.
// idea: workers non-agro, follow set_leader

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_monster_new.as"

[script "monsters/ant_fire_warrior"]
class AntFireWarrior : BaseMonsterNewScript
{
	// Constants
	string ANIM_WALK1 = "walk";
	string ANIM_WALK2 = "walk2";
	string ANIM_ATTACK1 = "attack";
	string ANIM_ATTACK2 = "attack2";
	float FREQ_SWITCH_ANIM = 0.0f;
	float FREQ_BREATH = 0.0f;
	float DMG_BITE = 50.0f;
	float DOT_FIRE = 10.0f;
	string SOUND_PAIN = "monsters/spider/spiderhiss.wav";
	string SND_STRUCK1 = "body/flesh1.wav";
	string SND_STRUCK2 = "body/flesh2.wav";
	string SND_STRUCK3 = "body/flesh3.wav";
	string SOUND_IDLE1 = "monsters/spider/spideridle.wav";
	string SOUND_BREATH = "monsters/goblin/sps_fogfire.wav";
	string SOUND_ATTACK1 = "monsters/spider/spiderhiss2.wav";
	string SOUND_ATTACK2 = "monsters/spider/spiderhiss.wav";

	// Variables (an unset .script variable reads as its own name)
	string ANIM_ATTACK = "ANIM_ATTACK";
	int DID_INTRO = 0;
	float NEXT_BREATH = 0.0f;
	float NEXT_SWITCH_ANIM = 0.0f;
	string BREATH_TARG = "BREATH_TARG";
	string BREATH_ON = "BREATH_ON";
	string CL_BREATH_IDX = "CL_BREATH_IDX";
	Vector3 SCAN_POINT = Vector3();
	string BREATH_TARGETS = "BREATH_TARGETS";

	// Variables declared by included files, with the value they start with in this script
	AntFireWarrior()
	{
		ANIM_IDLE = "idle";
		ANIM_WALK = "walk";
		NPC_ALLY_RESPONSE_RANGE = 1024.0f;
		SOUND_DEATH = "monsters/spider/spiderdie.wav";
	}

	// unnamed block (first think)
	void AntFireWarrior_FirstThink()
	{
		ANIM_IDLE = "idle";
		ANIM_WALK = "walk";
		ANIM_ATTACK = "attack"; // frame_attack
		ANIM_RUN = "walk";
		ANIM_DEATH = "die";

		NPC_GIVE_EXP = 150.0f;

		NPC_ALLY_RESPONSE_RANGE = 1024.0f; // larger response range than hp would suggest for better swarming

		ATTACK_RANGE = 32.0f;
		MOVE_RANGE = "16";
		ATTACK_MOVERANGE = 16.0f;
		ATTACK_HITRANGE = 64.0f;
	}

	// unnamed block (timer)
	void AntFireWarrior_Timer()
	{
		CallEventDelayed(3.6f, "AntFireWarrior_Timer");
		if (!IsAlive(ENT_ME))
			return;
		ServerPlaySound(4, 5, SOUND_IDLE1);
	}

	// game_death
	void OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		DqMonsterExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // dq/externals/dq_monster_externals
		MonstersExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/externals
		BaseSelfAdjust_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_self_adjust
		BaseNpc_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseMonsterShared_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared
		if (Truthy(BREATH_ON))
			ClientEvent("update", "all", CL_BREATH_IDX, "end_fx");
		ServerPlaySound(4, 0, SOUND_IDLE1);
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
		if (RandomInt(1, 2) == 1)
			ANIM_ATTACK = ANIM_ATTACK1;
		else
			ANIM_ATTACK = ANIM_ATTACK2;
	}

	// game_struck
	void OnGameStruck(float damage = 0.0f, string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		BaseNpc_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseNpcAttackNew_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc_attack_new
		BaseMonsterShared_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared
		PlayRandomSound(2, 10, SND_STRUCK1, SND_STRUCK2, SND_STRUCK3, SND_STRUCK1, SND_STRUCK2, SND_STRUCK3, SOUND_PAIN, SOUND_PAIN);
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseNpcAttackNew_OnNpcSpawn(npc); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck

		SetName("Fire Ant Warrior");
		SetModel("monsters/ant_size2.mdl");
		SetWidth(32);
		SetHeight(16);
		SetBlood("green");
		SetRace("ant_red");
		SetHealth(500);
		SetDamageTaken("pierce", 1.25f);
		SetRoam(true);
		SetHearingSensitivity(5);

		SetMoveAnim(ANIM_WALK);
		SetIdleAnim(ANIM_IDLE);
		PlayAnim("once", ANIM_IDLE);

		SetDamageTaken("cold", 1.25f);
		SetDamageTaken("fire", 0.5f);

		// movespeed's too slow, and I ain't redoing the anims again! ><
		SetAnimMoveSpeed(2);
		SetMoveSpeed(2);
	}

	// npcatk_hunt
	void OnNpcatkHunt()
	{
		BaseNpcAttackNew_OnNpcatkHunt(); // monsters/base_npc_attack_new
		BaseAntiStuck_OnNpcatkHunt(); // monsters/base_anti_stuck
		bool exitSub = false;

		if (SUSPEND_AI)
			return;

		if (NPCATK_TARGET != "unset" && GameTime() > NEXT_BREATH)
		{
			NEXT_BREATH = GameTime() + FREQ_BREATH;
			OnDoBreath();
			exitSub = true;
		}
		if (exitSub)
			return;

		if (!(GameTime() > NEXT_SWITCH_ANIM))
			return;
		NEXT_SWITCH_ANIM = GameTime() + FREQ_SWITCH_ANIM;

		if (RandomInt(1, 2) == 1)
		{
			ANIM_RUN = ANIM_WALK1;
			ANIM_WALK = ANIM_WALK1;
			SetMoveAnim(ANIM_RUN);
		}
		else
		{
			ANIM_RUN = ANIM_WALK2;
			ANIM_WALK = ANIM_WALK2;
			SetMoveAnim(ANIM_RUN);
		}
	}

	// my_target_died
	void OnMyTargetDied(string offender = "")
	{
		BaseNpcAttackNew_OnMyTargetDied(offender); // monsters/base_npc_attack_new
		DID_INTRO = 0;
	}

	// npc_targetsighted
	void OnNpcTargetsighted(string target = "")
	{
		BaseMonsterShared_OnNpcTargetsighted(target); // monsters/base_monster_shared
		if (DID_INTRO != 0)
			return;
		DID_INTRO = 1;
		NEXT_BREATH = GameTime() + FREQ_BREATH;
	}

	// frame_attack
	void OnFrameAttack()
	{
		PlayRandomSound(0, 10, SOUND_ATTACK1, SOUND_ATTACK2, "none", "none", "none", "none");
		// dodamage NPCATK_TARGET ATTACK_HITRANGE DMG_BITE 90% pierce
		DoDamageEx(NPCATK_TARGET, ATTACK_HITRANGE, DMG_BITE, "90%", ENT_ME, ENT_ME, "none", "pierce", "dmgevent:bite");

		if (RandomInt(1, 2) == 1)
			ANIM_ATTACK = ANIM_ATTACK1;
		else
			ANIM_ATTACK = ANIM_ATTACK2;
	}

	// bite_dodamage
	void OnBiteDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		if (!hit)
			return;
		if (RelationshipOf(target, ENT_ME) != "enemy")
			return;
		if (HasEffect(target, "DOT_fire"))
			return;
		ApplyEffect(target, "effects/dot_fire", 5.0f, self, DOT_FIRE);
	}

	// do_breath
	void OnDoBreath()
	{
		SetMoveDest(BREATH_TARG, 9999);
		BREATH_TARG = NPCATK_TARGET;
		OnNpcatkSuspendMovement("attack2", "5.0");
		OnNpcatkSuspendAi("5.0");
		BREATH_ON = "1";
		PlaySound(0, 10, SOUND_BREATH);
		ClientEvent("new", "all", "monsters/ant_fire_cl", IndexOf(ENT_ME), 5.0f, 0.25f);
		CL_BREATH_IDX = LastClientScriptId();
		SCAN_POINT = RelativePosition(Vector3(0, 64, 32));
		OnBreathLoop();
		CallEventDelayed(5.0f, "breath_end");
	}

	// breath_loop
	void OnBreathLoop()
	{
		if (!Truthy(BREATH_ON))
			return;
		SetMoveDest(SCAN_POINT, 9999);
		CallEventDelayed(1.0f, "breath_loop");
		BREATH_TARGETS = LegacyFunction("get_tsphere", "enemy", 128, SCAN_POINT);
		if (BREATH_TARGETS == "none")
			return;
		int count = GetTokenCount(BREATH_TARGETS);
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnBreathAffectTargets();
		}
	}

	// breath_affect_targets
	void OnBreathAffectTargets()
	{
		CBaseEntity@ curTarg = FindEntity(GetToken(BREATH_TARGETS, loopIteration));
		Vector3 targOrg = OriginOf(curTarg);
		if (!WithinCone2D(targOrg, MyOrigin(), MyAngles(), 30))
			return;
		if (!(RangeTo(curTarg) < 256.0f))
			return;
		if (HasEffect(curTarg, "DOT_fire"))
			return;
		ApplyEffect(curTarg, "effects/dot_fire", 5.0f, self, DOT_FIRE);
	}

	// breath_end
	void OnBreathEnd()
	{
		BREATH_ON = "0";
		OnNpcatkResumeAi();
		OnNpcatkResumeMovement();
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/ant_size2.mdl");
		Precache("monsters/spider/spideridle.wav");
		CallEventDelayed(3.6f, "AntFireWarrior_Timer");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		AntFireWarrior_FirstThink();
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
		if (name == "bite_dodamage") { OnBiteDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5)); return true; }
		if (name == "breath_affect_targets") { OnBreathAffectTargets(); return true; }
		if (name == "breath_end") { OnBreathEnd(); return true; }
		if (name == "breath_loop") { OnBreathLoop(); return true; }
		if (name == "do_breath") { OnDoBreath(); return true; }
		if (name == "frame_attack") { OnFrameAttack(); return true; }
		if (name == "game_death") { OnGameDeath(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_struck") { OnGameStruck(Float(Param(params, 0)), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "my_target_died") { OnMyTargetDied(Param(params, 0)); return true; }
		if (name == "npc_post_spawn") { OnNpcPostSpawn(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "npc_targetsighted") { OnNpcTargetsighted(Param(params, 0)); return true; }
		if (name == "npcatk_hunt") { OnNpcatkHunt(); return true; }
		if (name == "AntFireWarrior_Timer") { AntFireWarrior_Timer(); return true; }
		return BaseMonsterNewScript::DispatchEvent(name, params);
	}
}
