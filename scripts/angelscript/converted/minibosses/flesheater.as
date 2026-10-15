#pragma context server

// Converted from minibosses/flesheater.script by msc_transpiler.
// This is an older script and may have some bad conventions as a result.
// Thothie - for MS 1.35 compatitbility - and because mini-bosses are kewl! ;)
// - Notable Differences from Calrian <damage <hp <gold sounds model size trigger text poison damage
// - Weak for a Boss - but has a habit of getting back up
// - BUG: Reports of not getting back up after death - took a stab at it on 6/Sep/2006 16:11
// Flesheater (from Calrian)

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_monster_new.as"

[script "minibosses/flesheater"]
class Flesheater : BaseMonsterNewScript
{
	// Constants
	string ANIM_CLOUDCAST = "attack2";
	string ATTACK_DAMAGE = "ATTACK_DAMAGE";
	string ATTACK_HITCHANCE = "85%";
	string SOUND_STRUCK1 = "controller/con_pain3.wav";
	string SOUND_STRUCK2 = "controller/con_pain3.wav";
	string SOUND_STRUCK3 = "controller/con_pain2.wav";
	string SOUND_PAIN = "zombie/zo_pain2.wav";
	string SOUND_ATTACK1 = "controller/con_attack1.wav";
	string SOUND_ATTACK2 = "controller/con_attack2.wav";
	string SOUND_DEATH1 = "zombie/zo_pain1.wav";
	string SOUND_DEATH2 = "monsters/troll/trolldeath.wav";
	string SOUND_IDLE = "controller/con_attack3.wav";
	string SOUND_SPAWN = "monsters/skeleton/calrian2.wav";
	string SKEL_RESPAWN_CHANCE = "100%";
	int SKEL_HP = 3000;
	int POISON_CLAW_DMG = 0;
	float CLOUD_DURATION = 10.0f;
	int CLOUD_DAMAGE = 20;
	string MONSTER_MODEL = "monsters/flesheater.mdl";
	string ANIM_RESPAWN_DEADIDLE = "dead_on_stomach";

	// Variables (an unset .script variable reads as its own name)
	string ANIM_ATTACK = "ANIM_ATTACK";
	int DROP_GOLD_MIN = 0;
	int DROP_GOLD_MAX = 0;
	bool I_AM_TURNABLE = false;
	string MY_SCRIPT_ID = "MY_SCRIPT_ID";
	bool GONE_ROAM = false;
	bool DIED_ONCE = false;
	float CLOUD_DELAY = 0.0f;
	string MY_LIGHT_SCRIPT = "MY_LIGHT_SCRIPT";

	// Variables declared by included files, with the value they start with in this script
	Flesheater()
	{
		ANIM_IDLE = "idle1";
		ANIM_WALK = "walk";
		ANIM_RUN = "walk";
	}

	// unnamed block (first think)
	void Flesheater_FirstThink()
	{
		ANIM_IDLE = "idle1";
		ANIM_WALK = "walk";
		ANIM_RUN = "walk";
		ANIM_ATTACK = "attack1";
		ATTACK_RANGE = 120.0f;
		MOVE_RANGE = "80";
		ATTACK_HITRANGE = 200.0f;

		DROP_GOLD = 1;
		DROP_GOLD_MIN = 100;
		DROP_GOLD_MAX = 150;
	}

	// npcatk_targetvalidate
	void Flesheater_OnNpcatkTargetvalidate(string target = "")
	{
		Vector3 orig;

		if (Truthy(PLAYING_DEAD))
			return;
		if (int(CLOUD_DELAY) != 0)
			return;

		if (CanSee(NPCATK_TARGET))
			orig = OriginOf(NPCATK_TARGET);
		else
			orig = OriginOf(ENT_ME);

		CreateNpc("monsters/summon/npc_poison_cloud2", orig, self, CLOUD_DAMAGE, CLOUD_DURATION, 1);

		PlayAnim("once", ANIM_CLOUDCAST);
		CLOUD_DELAY = 1.0f;
		CallEventDelayed(10.0f, "reset_cloud_delay");
	}

	// npcatk_targetvalidate
	void Flesheater_OnNpcatkTargetvalidate_2(string target = "")
	{
		if (GONE_ROAM)
			return;
		GONE_ROAM = true;
		SetRoam(true);
		PlaySound(2, 10, SOUND_SPAWN);
		OnLightLoop();
	}

	// game_damaged_other
	// P1=target P2=damage
	string Flesheater_OnGameDamagedOther(CBaseEntity@ target = null, float damage = 0.0f, string damageType = "", string damageEvent = "")
	{
		string result = "";

		// //dbg temp Damaged other got PARAM1 PARAM2 PARAM3 PARAM4 PARAM5
		if (!IsAlive(ENT_ME))
			return result;
		if (Truthy(PLAYING_DEAD))
			return result;
		if (!(HealthOf(ENT_ME) > 500.0f))
			return result;
		float hpToGive = damage * 0.25f;
		float maxCheck = MyHealth() + hpToGive;
		if (!(maxCheck < MyMaxHealth()))
			return result;
		GiveHealth(hpToGive);
		Effect("glow", ENT_ME, Vector3(0, 255, 0), 80, 0.25f, 0.25f);
		PlaySound(0, 10, "player/heartbeat_noloop.wav");
		return result;
	}

	// game_damaged_other
	string OnGameDamagedOther(CBaseEntity@ target = null, float damage = 0.0f, string damageType = "", string damageEvent = "")
	{
		string result = "";
		result = AppendResult(result, MonstersExternals_OnGameDamagedOther(target, damage, damageType, damageEvent));
		result = AppendResult(result, BaseAntiStuck_OnGameDamagedOther(target, damage, damageType, damageEvent));
		result = AppendResult(result, BaseMonsterShared_OnGameDamagedOther(target, damage, damageType, damageEvent));
		result = AppendResult(result, Flesheater_OnGameDamagedOther(target, damage, damageType, damageEvent));
		return result;
	}

	// game_postspawn
	void OnGamePostspawn(string title = "", string damageMultiplier = "", string healthMultiplier = "", string params = "")
	{
		BaseSelfAdjust_OnGamePostspawn(title, damageMultiplier, healthMultiplier, params); // monsters/base_self_adjust
		BaseNpc_OnGamePostspawn(title, damageMultiplier, healthMultiplier, params); // monsters/base_npc
	}

	// game_struck
	// Hit by someone
	void OnGameStruck(float damage = 0.0f, string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		BaseNpc_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseNpcAttackNew_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc_attack_new
		BaseMonsterShared_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared

		// dbg temp MyHp game.monster.hp ( FLINCH_DMG_REQ )
		if (!GONE_ROAM)
		{
			SetRoam(true);
			GONE_ROAM = true;
		}

		float myHp = HealthOf(ENT_ME);
		if (myHp <= 500.0f)
		{
			if (myHp > 1.0f && !DIED_ONCE) // weird instant-fake-death going on
			{
				OnNpcatkClearTargets();
				OnFakeDeath();
			}
		}

		PlayRandomSound(2, 5, SOUND_PAIN, SOUND_PAIN, SOUND_STRUCK1, SOUND_STRUCK2, SOUND_STRUCK3);
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseNpcAttackNew_OnNpcSpawn(npc); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck

		I_AM_TURNABLE = false;

		MY_SCRIPT_ID = "unset";

		SetHealth(3000);
		int onUnrest = 0;
		string mapName = MapName();
		if (mapName == "unrest2")
			onUnrest = 1;
		if (mapName == "unrest2_beta1")
			onUnrest = 2;

		if (onUnrest == 0)
		{
			SetWidth(50);
			SetHeight(100);
		}
		if (onUnrest != 0)
		{
			SetProp(ENT_ME, "rendermode", 5);
			SetProp(ENT_ME, "renderamt", 255);
			SetWidth(20);
			SetHeight(72);
		}

		SetName("Flesh Eater");
		SetRoam(false);
		SetHearingSensitivity(8);
		NPC_GIVE_EXP = 250.0f;
		SetRace("undead");
		// setidleanim ANIM_IDLE
		// setmoveanim ANIM_WALK
		SetModel(MONSTER_MODEL);
		SetModelBody(1, 0);
		SetDamageTaken("all", 0.65f);
		SetDamageTaken("poison", 0);
		SetDamageTaken("holy", 2);
	}

	// npcatk_targetvalidate
	void OnNpcatkTargetvalidate(string target = "")
	{
		BaseNpcAttackNew_OnNpcatkTargetvalidate(target); // monsters/base_npc_attack_new
		Flesheater_OnNpcatkTargetvalidate(target);
		Flesheater_OnNpcatkTargetvalidate_2(target);
	}

	// my_target_died
	void OnMyTargetDied(string offender = "")
	{
		BaseNpcAttackNew_OnMyTargetDied(offender); // monsters/base_npc_attack_new

		Effect("glow", ENT_ME, Vector3(0, 255, 0), 255, 1.0f, 1.0f);
		CallEventDelayed(0.4f, "skele_laugh");
		PlaySound(0, 10, "ambience/particle_suck1.wav");
		SetHealth(MyMaxHealth());
	}

	// attack_1
	void OnAttack12()
	{
		OnNpcatkDodamage(NPCATK_TARGET, Text(ATTACK_HITRANGE), ATTACK_DAMAGE, ATTACK_HITCHANCE, "slash");

		ApplyEffect(ENT_LASTSTRUCKBYME, "effects/dot_poison", 5, ENT_ME, POISON_CLAW_DMG);

		if (RandomInt(0, 1) == 0)
			PlayRandomSound(2, 5, SOUND_ATTACK1, SOUND_ATTACK2);
	}

	// attack_2
	void OnAttack22()
	{
		OnNpcatkDodamage(NPCATK_TARGET, Text(ATTACK_HITRANGE), ATTACK_DAMAGE, ATTACK_HITCHANCE, "slash");

		ApplyEffect(ENT_LASTSTRUCKBYME, "effects/dot_poison", 5, ENT_ME, POISON_CLAW_DMG);

		if (RandomInt(0, 1) == 0)
			PlayRandomSound(2, 5, SOUND_ATTACK1, SOUND_ATTACK2);
	}

	// fake_death
	void OnFakeDeath()
	{
		OnNpcatkSuspendAi();

		PlayAnim("critical", ANIM_DEATH);

		PLAYING_DEAD = "1";

		PlaySound(0, 10, SOUND_DEATH1);

		int deathanim = RandomInt(0, 1);

		ANIM_DEATH = "diesimple";

		DIED_ONCE = true;

		PLAYING_DEAD = "1";

		CAN_HEAR = "0";
		SetAlive(true);
		SetMoveDest("none");
		SetIdleAnim(ANIM_RESPAWN_DEADIDLE);
		SetInvincible(true);
		SetRoam(false);

		CallEventDelayed(8.0f, "skel_respawn");
	}

	// npc_death
	void OnNpcDeath()
	{
		UseTrigger("bloodreaver_died");

		// playsound 0 10 SOUND_DEATH2
		// if ( MY_LIGHT_SCRIPT isnot 'MY_LIGHT_SCRIPT' ) clientevent update all MY_LIGHT_SCRIPT remove_light
		string mapName = ToLowerCase(MapName());

		if (mapName != "bloodrose")
			SayText("I shall return one day! ...and then your flesh shall adorn my bones!");

		if (mapName == "bloodrose")
		{
			CBaseEntity@ spawn = FindByName("slithar_caves1");
			if (Exists(spawn))
				DeleteEntity(spawn, "remove");

			@spawn = FindByName("slithar_caves1_tele");
			if (Exists(spawn))
				DeleteEntity(spawn, "remove");

			@spawn = FindByName("slithar_caves2");
			if (Exists(spawn))
				DeleteEntity(spawn, "remove");

			@spawn = FindByName("slithar_caves2_tele");
			if (Exists(spawn))
				DeleteEntity(spawn, "remove");

			@spawn = FindByName("slithar_caves3");
			if (Exists(spawn))
				DeleteEntity(spawn, "remove");

			@spawn = FindByName("slithar_caves3_tele");
			if (Exists(spawn))
				DeleteEntity(spawn, "remove");

			@spawn = FindByName("slithar_caves4");
			if (Exists(spawn))
				DeleteEntity(spawn, "remove");

			CBaseEntity@ masterId = FindByName("snake_lord");
			if (IsAlive(masterId))
			{
				SayText("Slithar, I have failed! Finish them!");
				CallExternal(masterId, "slithar_resume");
			}
			else
			{
				SayText("For now, you have won, but you have not seen the last of me nor my master!");
			}
		}
	}

	// skel_respawn
	void OnSkelRespawn()
	{
		SetIdleAnim(ANIM_IDLE);
		PlayAnim("critical", "getup");
		SetHealth(3000);
		SetSayTextRange(1024);
		SayText("No! I shall not be defeated so easily!");

		CallEventDelayed(2.5f, "skel_respawn_revived");
	}

	// skel_respawn_revived
	void OnSkelRespawnRevived()
	{
		PLAYING_DEAD = "0";
		SetMoveDest(HUNT_LASTTARGET, 9999);

		OnNpcatkResumeAi();
		CAN_HEAR = "1";

		SetRoam(true);
		SetInvincible(false);
	}

	// reset_cloud_delay
	void OnResetCloudDelay()
	{
		CLOUD_DELAY = 0.0f;
	}

	// light_loop
	void OnLightLoop()
	{
		if (!IsAlive(ENT_ME))
			return;
		CallEventDelayed(10.0f, "light_loop");
		ClientEvent("new", "all", "effects/sfx_follow_glow_cl", IndexOf(ENT_ME), Vector3(0, 255, 0), 256, 10.0f);
		MY_LIGHT_SCRIPT = LastClientScriptId();
	}

	// skele_laugh
	void OnSkeleLaugh()
	{
		PlaySound(0, 10, "x/x_laugh1.wav");
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("poison_cloud.spr");
		Precache("monsters/flesheater.mdl");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		Flesheater_FirstThink();
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
		if (name == "attack_1") { OnAttack12(); return true; }
		if (name == "attack_2") { OnAttack22(); return true; }
		if (name == "fake_death") { OnFakeDeath(); return true; }
		if (name == "game_damaged_other") { Return(OnGameDamagedOther(EntityParam(params, 0), Float(Param(params, 1)), Param(params, 2), Param(params, 3))); return true; }
		if (name == "game_postspawn") { OnGamePostspawn(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_struck") { OnGameStruck(Float(Param(params, 0)), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "light_loop") { OnLightLoop(); return true; }
		if (name == "my_target_died") { OnMyTargetDied(Param(params, 0)); return true; }
		if (name == "npc_death") { OnNpcDeath(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "npcatk_targetvalidate") { OnNpcatkTargetvalidate(Param(params, 0)); return true; }
		if (name == "reset_cloud_delay") { OnResetCloudDelay(); return true; }
		if (name == "skel_respawn") { OnSkelRespawn(); return true; }
		if (name == "skel_respawn_revived") { OnSkelRespawnRevived(); return true; }
		if (name == "skele_laugh") { OnSkeleLaugh(); return true; }
		return BaseMonsterNewScript::DispatchEvent(name, params);
	}
}
