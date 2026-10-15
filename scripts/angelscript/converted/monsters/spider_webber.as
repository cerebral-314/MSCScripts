#pragma context server

// Converted from monsters/spider_webber.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_monster_new.as"

[script "monsters/spider_webber"]
class SpiderWebber : BaseMonsterNewScript
{
	// Constants
	string ANIM_JUMP = "latch_jump";
	string ANIM_BURROW_IN = "BurrowIn";
	string ANIM_BURROW_OUT = "BurrowOut";
	string HITCHANCE_BITE = "80%";
	float DMG_BITE = 10.0f;
	float DOT_POISON = 5.0f;
	float FREQ_FLIP = 0.0f;
	string SOUND_SHOOT = "bullchicken/bc_attack3.wav";
	string SND_STRUCK1 = "body/flesh1.wav";
	string SND_STRUCK2 = "body/flesh2.wav";
	string SND_STRUCK3 = "body/flesh3.wav";
	string SND_STRUCK4 = "monsters/spider/spiderhiss.wav";
	string SOUND_ATTACK1 = "zombie/claw_miss1.wav";
	string SOUND_ATTACK2 = "zombie/claw_miss2.wav";

	// Variables (an unset .script variable reads as its own name)
	string ANIM_ATTACK = "ANIM_ATTACK";
	float WEB_STRENGTH = 0.0f;
	int PROJECTILE_RANGE = 0;
	bool AM_BURROWED = false;
	bool SILENT_BURROW = false;
	bool START_BURROWED = false;
	string NPC_PROXACT_RANGE = "NPC_PROXACT_RANGE";
	bool NPC_PROX_ACTIVATE = false;
	string NPC_PROXACT_EVENT = "NPC_PROXACT_EVENT";
	bool NPC_PROXACT_IFSEEN = false;
	bool NPC_PROXACT_FOV = false;
	string NPC_PROXACT_DELAY = "NPC_PROXACT_DELAY";
	bool DEFAULT_CEILING = false;
	bool AM_FLIPPED = false;
	float NEXT_FLIP = 0.0f;
	bool CAN_FLIP = false;
	float NEXT_QUICK_SPIT = 0.0f;
	bool BITE_ATTACK = false;

	// Variables declared by included files, with the value they start with in this script
	SpiderWebber()
	{
		ANIM_IDLE = "idle";
		ANIM_WALK = "walk";
		SOUND_DEATH = "monsters/spider/spiderdie.wav";
	}

	// unnamed block (first think)
	void SpiderWebber_FirstThink()
	{
		ANIM_IDLE = "idle";
		ANIM_WALK = "walk";
		ANIM_RUN = "walk";
		ANIM_DEATH = "death";
		ANIM_ATTACK = "spit"; // frame_spit

		WEB_STRENGTH = 1.0f; // determines # of webs required to cocoon a target (11-WEB_STRENGTH)

		ATTACK_MOVERANGE = 250.0f;
		PROJECTILE_RANGE = 400;
		ATTACK_HITRANGE = 90.0f;
		ATTACK_RANGE = 70.0f;

		NPC_GIVE_EXP = 80.0f;
	}

	// game_dodamage
	string SpiderWebber_OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";

		if (hit && BITE_ATTACK)
		{
			PlayRandomSound(0, 10, SOUND_ATTACK1, SOUND_ATTACK2);
			ApplyEffect(target, "effects/dot_poison", 10.0f, self, DOT_POISON);
		}
		BITE_ATTACK = false;
		return result;
	}

	// game_death
	void OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		DqMonsterExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // dq/externals/dq_monster_externals
		MonstersExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/externals
		BaseSelfAdjust_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_self_adjust
		BaseNpc_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseMonsterShared_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared
		SetGravity(1);
	}

	// game_struck
	void OnGameStruck(float damage = 0.0f, string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		BaseNpc_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseNpcAttackNew_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc_attack_new
		BaseMonsterShared_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared
		if (damage > HealthOf(ENT_ME))
			SetGravity(1);

		if (!AM_BURROWED)
			return;
		OnBurrowOut();
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseNpcAttackNew_OnNpcSpawn(npc); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck
		SetName("Constrictor Spider");
		SetHealth(100);
		SetModel("monsters/spider_fuzzy.mdl");
		SetWidth(32);
		SetHeight(32);
		SetRace("spider");
		SetRoam(true);

		SetIdleAnim(ANIM_IDLE);
		SetMoveAnim(ANIM_WALK);
		// (always true here) if game.serverside

		// takedmg cold 0.0
		// takedmg fire 1.25
		SetHearingSensitivity(4);

		CallEventDelayed(0.5f, "start_ai");
		CallEventDelayed(1.5f, "post_activated");
	}

	// npcatk_hunt
	void OnNpcatkHunt()
	{
		BaseNpcAttackNew_OnNpcatkHunt(); // monsters/base_npc_attack_new
		BaseAntiStuck_OnNpcatkHunt(); // monsters/base_anti_stuck

		if (NPCATK_TARGET == "unset")
			return;

		bool targCocooned = false;
		if (!CanAttack(NPCATK_TARGET))
			targCocooned = true;

		if (CanSee(NPCATK_TARGET))
		{
			if (targCocooned)
				ATTACK_MOVERANGE = 32.0f;
			else
				ATTACK_MOVERANGE = 250.0f;
		}
		else
		{
			ATTACK_MOVERANGE = 32.0f;
		}

		if (CAN_FLIP && GameTime() > NEXT_FLIP)
		{
			NEXT_FLIP = GameTime() + FREQ_FLIP;

			if (AM_FLIPPED)
				OnSetGroundSpider();
			else
				OnSetCeilingSpider();
		}

		if (targCocooned && Range2DTo(NPCATK_TARGET) < 100.0f)
			OnSetGroundSpider();

		if (AM_FLIPPED)
			AddVelocity(ENT_ME, RelativeVelocity(Vector3(0, 0, 1000)));
	}

	// my_target_died
	void OnMyTargetDied(string offender = "")
	{
		BaseNpcAttackNew_OnMyTargetDied(offender); // monsters/base_npc_attack_new
		if (!DEFAULT_CEILING)
			return;
		OnSetCeilingSpider();
	}

	// game_dodamage
	string OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";
		result = AppendResult(result, BaseNpcAttackNew_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BaseAntiStuck_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BaseMonsterShared_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, SpiderWebber_OnGameDodamage(hit, target, start, end, damageType, damageText));
		return result;
	}

	// npc_targetsighted
	void OnNpcTargetsighted(string target = "")
	{
		BaseMonsterShared_OnNpcTargetsighted(target); // monsters/base_monster_shared

		if (!CanAttack(NPCATK_TARGET))
			return;

		if (RangeTo(NPCATK_TARGET) > ATTACK_RANGE && GameTime() > NEXT_QUICK_SPIT)
		{
			NEXT_QUICK_SPIT = GameTime() + 2.0f;
			if (RangeTo(NPCATK_TARGET) < PROJECTILE_RANGE)
			{
				AS_ATTACKING = GameTime() + 2.0f;
				PlayAnim("once", ANIM_ATTACK);
			}
		}
	}

	// game_precache
	void OnGamePrecache()
	{
		PrecacheFile("effects/webbed");
	}

	// npc_struck
	void OnNpcStruck(float damage = 0.0f)
	{
		PlayRandomSound(Int(Eval("game.sound.body")), 10, SND_STRUCK1, SND_STRUCK2, SND_STRUCK3, SND_STRUCK4);
	}

	// render_normal
	void OnRenderNormal()
	{
		SetProp(ENT_ME, "renderamt", 255);
		SetProp(ENT_ME, "rendermode", 0);
	}

	// burrow_in
	void OnBurrowIn()
	{
		OnNpcatkSuspendAi();
		PlayAnim("break");
		PlayAnim("hold", ANIM_BURROW_IN);
		AM_BURROWED = true;
		if (!SILENT_BURROW)
			PlaySound(0, 10, "SOUND_BURROW");
		SILENT_BURROW = false;
	}

	// burrow_out
	void OnBurrowOut()
	{
		if (START_BURROWED)
		{
			SetMoveDest(@NPC_PROXACT_PLAYERID, 9999);
			START_BURROWED = false;
		}
		OnNpcatkResumeAi();
		PlayAnim("break");
		PlayAnim("critical", ANIM_BURROW_OUT);
		AM_BURROWED = false;
	}

	// set_start_burrowed
	// [proxactivate range]
	void OnSetStartBurrowed(string value = "", float proxRange = 0.0f)
	{
		NPC_NO_AUTO_ACTIVATE = true;
		START_BURROWED = true;
		if (proxRange > 32.0f)
			NPC_PROXACT_RANGE = Text(proxRange);
		else
			NPC_PROXACT_RANGE = "256";
		NPC_PROX_ACTIVATE = true; // suspend AI on spawn, wait for player to come..
		NPC_PROXACT_EVENT = "burrow_out"; // this event.
		NPC_PROXACT_IFSEEN = true; // activate if a player can see me, or targets me, regardless of range
		NPC_PROXACT_FOV = false; // Require player must be in field of vision to activate
		NPC_PROXACT_DELAY = "0.5"; // give me a moment to burrow

		SetProp(ENT_ME, "rendermode", 5);
		SetProp(ENT_ME, "renderamt", 0);
		SILENT_BURROW = true;

		CallEventDelayed(0.01f, "burrow_in");
		CallEventDelayed(1.5f, "render_normal");
	}

	// set_start_ceiling
	void OnSetStartCeiling()
	{
		DEFAULT_CEILING = true;
		AM_FLIPPED = true;
		ANIM_IDLE = "up_idle";
		ANIM_WALK = "up_walk";
		ANIM_RUN = "up_walk";
		ANIM_DEATH = "up_death";
		ANIM_ATTACK = "up_spit"; // frame_spit
		SetIdleAnim(ANIM_IDLE);
		SetMoveAnim(ANIM_WALK);
		SetGravity(-1);
		AddVelocity(ENT_ME, RelativeVelocity(Vector3(0, 0, 10000)));
		CallEventDelayed(2.0f, "set_ceiling_spider");
	}

	// set_ceiling_spider
	void OnSetCeilingSpider()
	{
		AM_FLIPPED = true;
		ANIM_IDLE = "up_idle";
		ANIM_WALK = "up_walk";
		ANIM_RUN = "up_walk";
		ANIM_DEATH = "up_death";
		ANIM_ATTACK = "up_spit"; // frame_spit
		SetIdleAnim(ANIM_IDLE);
		SetMoveAnim(ANIM_WALK);
		SetGravity(-1);
		AddVelocity(ENT_ME, RelativeVelocity(Vector3(0, 0, 10000)));
	}

	// set_ground_spider
	void OnSetGroundSpider()
	{
		AM_FLIPPED = false;
		ANIM_IDLE = "idle";
		ANIM_WALK = "walk";
		ANIM_RUN = "walk";
		ANIM_DEATH = "death";
		ANIM_ATTACK = "spit"; // frame_spit
		SetIdleAnim(ANIM_IDLE);
		SetMoveAnim(ANIM_WALK);
		SetGravity(1);
	}

	// set_can_flip
	void OnSetCanFlip()
	{
		NEXT_FLIP = GameTime() + FREQ_FLIP;
		CAN_FLIP = true;
	}

	// frame_spit
	void OnFrameSpit()
	{
		Vector3 startOfs = Vec("L_START_OFS");
		if (RangeTo(NPCATK_TARGET) > ATTACK_RANGE)
		{
			if (AM_FLIPPED)
				startOfs = RelativePosition(Vector3(0, 32, -48));
			else
				startOfs = RelativePosition(Vector3(0, 32, 0));

			Vector3 endPos = OriginOf(NPCATK_TARGET) + Vector3(0, 0, HeightOf(NPCATK_TARGET) * 0.75f);
			// <projectile scriptname> <"view"|(src_origin)> <target|(targ_origin)|none> <speed> <damage> <cof> <skill|none> //Converted to use new tossprojectile //greatguys1@FEB2022
			TossProjectile("proj_web", startOfs, endPos, 275, 10, 0.1f, "none");
			PlaySound(0, 5, SOUND_SHOOT);
			NEXT_QUICK_SPIT = GameTime() + 1.0f;
		}
		else
		{
			BITE_ATTACK = true;
			if (!CanAttack(NPCATK_TARGET))
			{
				DoDamage(NPCATK_TARGET, ATTACK_HITRANGE, DMG_BITE, HITCHANCE_BITE, "pierce");
			}
			else
			{
				// direct damage, or cocoon will block attack
				DoDamage(NPCATK_TARGET, "direct", DMG_BITE, "100%", ENT_ME, "pierce");
			}
		}
	}

	// post_activated
	void OnPostActivated()
	{
		if (NPC_ADJ_LEVEL > 0.0f)
		{
			float addToWs = Clamp(NPC_ADJ_LEVEL, 1.0f, 7.0f); // in case level caps increase in future
			WEB_STRENGTH += addToWs;
		}
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/spider_fuzzy.mdl");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		SpiderWebber_FirstThink();
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
		if (name == "burrow_in") { OnBurrowIn(); return true; }
		if (name == "burrow_out") { OnBurrowOut(); return true; }
		if (name == "frame_spit") { OnFrameSpit(); return true; }
		if (name == "game_death") { OnGameDeath(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_dodamage") { Return(OnGameDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5))); return true; }
		if (name == "game_precache") { OnGamePrecache(); return true; }
		if (name == "game_struck") { OnGameStruck(Float(Param(params, 0)), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "my_target_died") { OnMyTargetDied(Param(params, 0)); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "npc_struck") { OnNpcStruck(Float(Param(params, 0))); return true; }
		if (name == "npc_targetsighted") { OnNpcTargetsighted(Param(params, 0)); return true; }
		if (name == "npcatk_hunt") { OnNpcatkHunt(); return true; }
		if (name == "post_activated") { OnPostActivated(); return true; }
		if (name == "render_normal") { OnRenderNormal(); return true; }
		if (name == "set_can_flip") { OnSetCanFlip(); return true; }
		if (name == "set_ceiling_spider") { OnSetCeilingSpider(); return true; }
		if (name == "set_ground_spider") { OnSetGroundSpider(); return true; }
		if (name == "set_start_burrowed") { OnSetStartBurrowed(Param(params, 0), Float(Param(params, 1))); return true; }
		if (name == "set_start_ceiling") { OnSetStartCeiling(); return true; }
		return BaseMonsterNewScript::DispatchEvent(name, params);
	}
}
