#pragma context server

// Converted from monsters/horror_lightning_old.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/horror.as"

[script "monsters/horror_lightning_old"]
class HorrorLightningOld : HorrorScript
{
	// Constants
	string SOUND_SHOCK1 = "debris/zap8.wav";
	string SOUND_SHOCK2 = "debris/zap3.wav";
	string SOUND_SHOCK3 = "debris/zap4.wav";

	// Variables (an unset .script variable reads as its own name)
	float BALL_SIZE = 0.0f;
	float BALL_DMG = 0.0f;

	// Variables declared by included files, with the value they start with in this script
	HorrorLightningOld()
	{
		SOUND_SPRAY = "debris/beamstart1.wav";
	}

	// unnamed block (first think)
	void HorrorLightningOld_FirstThink()
	{
		AS_SUMMON_TELE_CHECK = true;

		IS_UNHOLY = true;

		BALL_SIZE = 5.0f;
		BALL_DMG = 50.0f;
	}

	// game_precache
	void OnGamePrecache()
	{
		PrecacheFile("monsters/horror");
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseNpcAttackNew_OnNpcSpawn(npc); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck
		Horror_OnNpcSpawn(npc); // monsters/horror

		SetName("Electric Horror");

		SetHealth(500); // hi HP, no armor
		SetWidth(22);
		SetHeight(22);
		SetBoundingBox("npcsize");
		SetRoam(true);
		SetFly(true);
		I_FLY = true;
		LegacyCommand("float", 0);
		SetRace("demon");
		SetIdleAnim(ANIM_WALK);
		SetMoveAnim(ANIM_WALK);
		SetHearingSensitivity(5);
		SetModel("monsters/edwardgorey.mdl");
		NPC_GIVE_EXP = 200.0f;
		CallEventDelayed(1.0f, "idle_sounds");
		FLIGHT_SCANNING = true;

		SetModelBody(0, 2);
		SetDamageTaken("poison", 2);
		SetDamageTaken("holy", 2);
		SetDamageTaken("lightning", 0);
	}

	// attack1
	// called by model anim: bite1
	void OnAttack1()
	{
		bool exitSub = false;

		if (SPITTING)
		{
			// <projectile scriptname> <"view"|(src_origin)> <target|(targ_origin)|none> <speed> <damage> <cof> <skill|none> //Converted to use new tossprojectile //greatguys1@FEB2022
			TossProjectile("proj_lightning_ball", "view", "none", 500, SPIT_DAMAGE, 0.5f, "none");
			SPITTING = false;
			PlayRandomSound(0, 10, SOUND_SHOCK1, SOUND_SHOCK2, SOUND_SHOCK3);
			if (SPIT_AMMO == 0.0f)
				OnFlyMode();
			exitSub = true;
		}
		if (exitSub)
			return;

		DoDamage(ENTITY_ENEMY, ATTACK_HITRANGE, ATTACK_DAMAGE, ATTACK_ACCURACY);
		PlayRandomSound(0, 10, SOUND_ATTACK1, SOUND_ATTACK2, SOUND_ATTACK3);
		if (RandomInt(1, 2) == 1) // developer - set back to 20
			ANIM_ATTACK = ANIM_GORE;
	}

	// breath_attack
	// called by model anim: breath
	void OnBreathAttack()
	{
		Effect("glow", ENT_ME, Vector3(255, 255, 0), 768, 2, 2);
		PlaySound(0, 10, SOUND_SPRAY);

		SPRAYING_GAS = true;
		// dodamage $relpos(0,64,0) 250 10 100% 0 reflective	//crash - wtf?
		CallEventDelayed(1.0f, "stop_spraying");

		if (!(RangeTo(ENT_LASTSEEN) <= ATTACK_BLIND_RANGE))
			return;
		// dbg Trying to poison Range $get(ent_laststruckbyme,range) of ATTACK_HITRANGE
		ApplyEffect(ENT_LASTSEEN, "effects/dot_lightning", RandomInt(3, 8), self, RandomInt(10, 20));

		if (!(BREATH_AMMO <= 0.0f))
			return;
		CallEventDelayed(20.0f, "breath_reload");
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		HorrorLightningOld_FirstThink();
		Horror_FirstThink();
		BaseFlyer_FirstThink();
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
		if (name == "attack1") { OnAttack1(); return true; }
		if (name == "breath_attack") { OnBreathAttack(); return true; }
		if (name == "game_precache") { OnGamePrecache(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		return HorrorScript::DispatchEvent(name, params);
	}
}
