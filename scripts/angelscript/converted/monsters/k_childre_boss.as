#pragma context server

// Converted from monsters/k_childre_boss.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/k_childre.as"

[script "monsters/k_childre_boss"]
class KChildreBoss : KChildreScript
{
	// Constants
	float FREQ_NOVA = 30.0f;
	float DUR_NOVA = 5.0f;
	int DOT_NOVA = 50;
	float FREQ_RANDOM_JUMP = 0.0f;

	// Variables (an unset .script variable reads as its own name)
	float NEXT_NOVA = 0.0f;
	string NOVA_LIST = "NOVA_LIST";

	// Variables declared by included files, with the value they start with in this script
	KChildreBoss()
	{
		PROJECTILE_SCRIPT = "proj_spore";
		NPC_IS_BOSS = true;
	}

	// unnamed block (first think)
	void KChildreBoss_FirstThink()
	{
		SPORE_POISON_DMG = "100";

		NPC_IS_BOSS = true;
	}

	// unnamed block (timer)
	void KChildreBoss_Timer()
	{
		CallEventDelayed(0.5f, "KChildreBoss_Timer");

		Vector3 myPos = OriginOf(ENT_ME);
		float myZ = myPos.z;
		float myGround = GroundHeight(myPos);
		if (Text(myGround) == "none") // I dunno how $get_ground_height returns 'none' but it does
			return;
		float zDiff = myGround - myZ;
		string zDiffText = Text(zDiff);
		if (zDiff < 0.0f)
		{
			zDiff *= -1.0f;
			zDiffText = Text(zDiff);
		}
		if (!(zDiff > 256.0f))
			return;
		DebugPrint("Bombs away ( " + zDiffText + " - " + Text(myZ) + " vs " + Text(myGround) + " )");
		Vector3 groundPos = OriginOf(ENT_ME);
		groundPos.z = myGround;

		// <projectile scriptname> <"view"|(src_origin)> <target|(targ_origin)|none> <speed> <damage> <cof> <skill|none> //Converted to use new tossprojectile //greatguys1@FEB2022
		TossProjectile(PROJECTILE_SCRIPT, RelativePosition(Vector3(0, 24, -102)), groundPos, 400, 200, 30, "none");
	}

	// game_death
	void OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		DqMonsterExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // dq/externals/dq_monster_externals
		MonstersExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/externals
		BaseSelfAdjust_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_self_adjust
		BaseNpc_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseMonsterShared_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared
		KChildre_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/k_childre
		if (ToLowerCase(MapName()) != "kfortress")
			return;

		// start 128 units from ground pos (in case monster dies in air)
		Vector3 startPos = OriginOf(ENT_ME);
		float startGroundZ = GroundHeight(startPos);
		startPos.z = startGroundZ;
		startPos.z += 96.0f;

		// spawn ostentatious client effect
		ClientEvent("new", "all", "kfortress/nh_appear_cl", startPos);

		// time item spawn, more or less, with client script effect end
		CallExternal(GetVar("GAME_MASTER"), "gm_createitem", 15.0f, "smallarms_nh", startPos);
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
		KChildre_OnNpcPostSpawn(); // monsters/k_childre

		// resistances
		SetDamageTaken("all", 0.5f);
		SetDamageTaken("fire", 1);
		SetDamageTaken("cold", 0.5f);
		SetDamageTaken("holy", 1);
		SetDamageTaken("poison", 0);
		SetDamageTaken("lightning", 2);
		SetDamageTaken("stun", 0.5f);

		// post-load stats used by base
		ANIM_FLINCH = "new_flinch";
		CAN_FLINCH = "1";
		FLINCH_HEALTH = 500.0f;
		FLINCH_DELAY = "5.0";
		FLINCH_CHANCE = "50";

		SetMoveAnim(ANIM_WALK);
		SetIdleAnim(ANIM_IDLE);
		SetStat("parry", 100);
	}

	// game_struck
	void OnGameStruck(float damage = 0.0f, string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		BaseNpc_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseNpcAttackNew_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc_attack_new
		BaseMonsterShared_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared
		KChildre_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/k_childre
		PlaySound(0, 8, SOUND_STRUCK1, SOUND_STRUCK2, SOUND_STRUCK1, SOUND_STRUCK2, SOUND_PAIN1, SOUND_PAIN2);
		if (GameTime() > NEXT_NOVA)
		{
			NEXT_NOVA = GameTime() + FREQ_NOVA;
			OnDoNova();
		}
		if (!AM_CRAWLING)
			return;
		if (!DOING_FADE)
			return;
		SetMoveAnim(ANIM_RUN);
		AM_CRAWLING = false;
		WAS_STRUCK = true;
		OnChickenRun(1.5f);
	}

	// game_precache
	void OnGamePrecache()
	{
		PrecacheFile("monsters/summon/poison_burst");
	}

	// childre_spawn
	void OnChildreSpawn()
	{
		bool exitSub = false;

		if (ToLowerCase(MapName()) == "kfortress")
		{
			SetName("Kruxus the Corrupting Shadow");
			NPC_GIVE_EXP = 10000.0f;
		}
		else
		{
			SetName("Black Kharaztorant Hierophant");
			NPC_GIVE_EXP = 800.0f;
		}
		SetModel("monsters/k_childre_black.mdl");
		SetHealth(9001);
		SetRace("demon");
		SetWidth(32);
		SetHeight(68);
		SetRoam(true);
		SetBoundingBox("npcsize");
		SetHearingSensitivity(4);
		string mapName = ToLowerCase(MapName());
		if (Contains(mapName, "helena"))
		{
			STEP_SIZE_NORM = 18;
			exitSub = true;
		}
		if (Contains(mapName, "demontemple"))
		{
			STEP_SIZE_NORM = 24;
			exitSub = true;
		}
		if (Contains(mapName, "islesofdread"))
		{
			STEP_SIZE_NORM = 24;
			exitSub = true;
		}
		if (exitSub)
			return;
		SetStepSize(STEP_SIZE_NORM);
	}

	// normal_immunes
	void OnNormalImmunes()
	{
		AM_INVISIBLE = false;
		SetInvincible(false);
		SetDamageTaken("all", 0.5f);
		SetDamageTaken("fire", 1);
		SetDamageTaken("cold", 0.5f);
		SetDamageTaken("holy", 1);
		SetDamageTaken("poison", 0);
		SetDamageTaken("lightning", 2);
	}

	// do_fireball
	void OnDoFireball()
	{
		PlaySound(0, 10, SOUND_FIREBALL);
		FIREBALL_TOSS = true;
		PlayAnim("critical", ANIM_ATTACK);
		// <projectile scriptname> <"view"|(src_origin)> <target|(targ_origin)|none> <speed> <damage> <cof> <skill|none> //Converted to use new tossprojectile //greatguys1@FEB2022
		TossProjectile(PROJECTILE_SCRIPT, RelativePosition(Vector3(0, 48, 62)), NPCATK_TARGET, 400, 200, 0, "none");
		FIREBALL_AMMO -= 1.0f;
		if (FIREBALL_AMMO == 0.0f)
			SetProp(ENT_ME, "skin", 0);
		OnNpcatkResumeAi();
		SetRoam(true);
	}

	// do_fade
	void OnDoFade()
	{
		CreateNpc("monsters/summon/poison_burst", OriginOf(ENT_ME), self, 128, 1, 100, 30);
		OnNpcatkFlee(NPCATK_TARGET, "2048", "3.0");
		FADE_TARGET = NPCATK_TARGET;
		DOING_FADE = true;
		OnNpcatkSuspendAi("2.0");
		SetMoveAnim(ANIM_RUN);
		WAS_STRUCK = false;
		CallEventDelayed(0.1f, "do_fade2");
		CallEventDelayed(1.0f, "resume_attack");
	}

	// do_nova
	void OnDoNova()
	{
		PlaySound(0, 10, "magic/spookie1.wav");
		NOVA_LIST = FindInSphere("enemy", 256);
		OnDoNovaFx();
		if (NOVA_LIST == "none")
			return;
		int count = GetTokenCount(NOVA_LIST);
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnNovaTargets();
		}
	}

	// nova_targets
	void OnNovaTargets()
	{
		CBaseEntity@ curTarg = FindEntity(GetToken(NOVA_LIST, loopIteration));
		// xdodamage CUR_TARG direct NOVA_DMG 100% ent_me ent_me none poison  //Thothie: save server cycles: let the DOT handle the damage
		ApplyEffect(curTarg, "effects/dot_poison", DUR_NOVA, self, DOT_NOVA);

		// The pushing effect of the nova
		// playsound 0 10 magic/spookie1.wav //Thothie: Moved to 'do_nova', otherwise sound flood will result when striking multiple targets
		Vector3 targetOrg = OriginOf(curTarg);
		Vector3 myOrg = OriginOf(ENT_ME);
		float targAng = AnglesTo(myOrg, targetOrg);
		SetVelocity(curTarg, RelativeVelocity(Vector3(0, targAng, 0), Vector3(10, 1000, 0)));
	}

	// npc_targetsighted
	void OnNpcTargetsighted(string target = "")
	{
		if (!CanSee("enemy"))
			return;
		if (!DID_WARCRY)
		{
			DID_WARCRY = true;
			OnDoWarcry();
		}

		if (STARTED_CYCLES)
			return;
		STARTED_CYCLES = true;
		CallEventDelayed(FREQ_FADE, "fade_check");
		CallEventDelayed(1.0f, "fireball_check");
		CallEventDelayed(1.0f, "jump_check");
		CallEventDelayed(FREQ_RANDOM_JUMP, "do_random_jump");
	}

	// do_random_jump
	void OnDoRandomJump()
	{
		CallEventDelayed(FREQ_RANDOM_JUMP, "do_random_jump");
		OnChickenRun(1.0f);
		CallEventDelayed(0.1f, "do_jump");
	}

	// etherial_immunes
	void OnEtherialImmunes()
	{
		ClearEffects();
		Effect("glow", ENT_ME, Vector3(0, 0, 0), 10, -1, 0);
		SetInvincible(true);
		AM_INVISIBLE = true;
		SetDamageTaken("fire", 0);
		SetDamageTaken("cold", 0);
		SetDamageTaken("poison", 0);
		SetDamageTaken("holy", 0);
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files
	void OnFreqRandomJump() {} // FREQ_RANDOM_JUMP
	void OnDoNovaFx() {} // do_nova_FX

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/k_childre_black.mdl");
		CallEventDelayed(FREQ_RELOAD, "KChildre_Timer");
		CallEventDelayed(FREQ_IDLE, "KChildre_Timer2");
		CallEventDelayed(0.5f, "KChildreBoss_Timer");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		KChildreBoss_FirstThink();
		KChildre_FirstThink();
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
		if (name == "childre_spawn") { OnChildreSpawn(); return true; }
		if (name == "do_fade") { OnDoFade(); return true; }
		if (name == "do_fireball") { OnDoFireball(); return true; }
		if (name == "do_nova") { OnDoNova(); return true; }
		if (name == "do_random_jump") { OnDoRandomJump(); return true; }
		if (name == "etherial_immunes") { OnEtherialImmunes(); return true; }
		if (name == "game_death") { OnGameDeath(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_precache") { OnGamePrecache(); return true; }
		if (name == "game_struck") { OnGameStruck(Float(Param(params, 0)), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "normal_immunes") { OnNormalImmunes(); return true; }
		if (name == "nova_targets") { OnNovaTargets(); return true; }
		if (name == "npc_post_spawn") { OnNpcPostSpawn(); return true; }
		if (name == "npc_targetsighted") { OnNpcTargetsighted(Param(params, 0)); return true; }
		if (name == "KChildreBoss_Timer") { KChildreBoss_Timer(); return true; }
		return KChildreScript::DispatchEvent(name, params);
	}
}
