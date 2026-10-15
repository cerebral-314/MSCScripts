#pragma context server

// Converted from monsters/sgoblin.script by msc_transpiler.
// Shadow Goblin from Blood Goblin Skirmisher by Thothie
// Spends most of the time doing invisible hit and runs

#include "runtime/ScriptEntity.as"
#include "converted/monsters/bgoblin.as"

[script "monsters/sgoblin"]
class Sgoblin : BgoblinScript
{
	// Constants
	int DMG_KNIFE = 0;
	string CL_SCRIPT = "monsters/sgoblin_cl";
	bool ORG_BODY = false;
	string SOUND_FADE = "monsters/gonome/gonome_melee2.wav";
	string SOUND_APPEAR = "ambience/alien_humongo.wav";

	// Variables (an unset .script variable reads as its own name)
	string CL_IDX = "CL_IDX";
	float SWING_COUNT = 0.0f;
	bool OVERHEAD_SMASH = false;
	bool AM_INVISIBLE = false;
	bool FIRST_ALERT = false;

	// Variables declared by included files, with the value they start with in this script
	Sgoblin()
	{
		NPC_BASE_EXP = "375";
	}

	// unnamed block (first think)
	void Sgoblin_FirstThink()
	{
		CAN_FIREBALL = false;

		DROP_GOLD = 1;
		DROP_GOLD_AMT = RandomInt(40, 50);
		BASE_FRAMERATE = "2.0";
		ATTACK_HITCHANCE = "90";

		CAN_STUN = false;
		FLINCH_HEALTH = 200.0f;
	}

	// game_dodamage
	string Sgoblin_OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";

		if (OVERHEAD_SMASH && AM_INVISIBLE)
			OnFadeIn();
		OVERHEAD_SMASH = false;
		return result;
	}

	// game_precache
	void OnGamePrecache()
	{
		PrecacheFile(CL_SCRIPT);
	}

	// game_death
	void OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		DqMonsterExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // dq/externals/dq_monster_externals
		MonstersExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/externals
		BaseSelfAdjust_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_self_adjust
		BaseNpc_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseMonsterShared_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared
		Bgoblin_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/bgoblin
		ClientEvent("remove", "all", CL_IDX);
		if (!AM_INVISIBLE)
			return;
		OnGoVisible();
	}

	// game_struck
	void OnGameStruck(float damage = 0.0f, string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		BaseNpc_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseNpcAttackNew_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc_attack_new
		BaseMonsterShared_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared
		Bgoblin_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/bgoblin
		if (AM_INVISIBLE)
			OnJumpAway();

		if (!(damage > 200.0f))
			return;
		if (RandomInt(1, 2) != 1)
			return;
		OnJumpAway();
	}

	// my_target_died
	void OnMyTargetDied(string offender = "")
	{
		BaseNpcAttackNew_OnMyTargetDied(offender); // monsters/base_npc_attack_new
		FIRST_ALERT = false;
		if (!AM_INVISIBLE)
			return;
		OnFadeIn();
	}

	// game_dodamage
	string OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";
		result = AppendResult(result, BaseNpcAttackNew_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BaseAntiStuck_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BaseMonsterShared_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, Sgoblin_OnGameDodamage(hit, target, start, end, damageType, damageText));
		return result;
	}

	// npc_selectattack
	// gonna swing, make visible
	void OnNpcSelectattack()
	{
		BaseAntiStuck_OnNpcSelectattack(); // monsters/base_anti_stuck
		BaseMonsterShared_OnNpcSelectattack(); // monsters/base_monster_shared
		if (AM_INVISIBLE)
			OnFadeIn();
	}

	// npc_targetsighted
	void OnNpcTargetsighted(string target = "")
	{
		BaseMonsterShared_OnNpcTargetsighted(target); // monsters/base_monster_shared
		if (FIRST_ALERT)
			return;
		if (AM_INVISIBLE)
			return;
		FIRST_ALERT = true;
		if (!(RangeTo(NPCATK_TARGET) > ATTACK_HITRANGE))
			return;
		OnFadeAndFlee();
	}

	// goblin_spawn
	void OnGoblinSpawn()
	{
		SetName("Shadow Goblin");
		SetRace("demon");
		SetBlood("red");
		SetHealth(1000);
		SetRoam(true);

		SetHearingSensitivity(4);

		SetAnimFrameRate(2);

		SetModel("monsters/goblin_new.mdl");
		SetWidth(24);
		SetHeight(50);

		SetModelBody(0, 0); // body: 0-Bare 1-Quiver&Strap 2-invisible
		SetModelBody(1, 0); // head: 0-Bare 1-Horns 2-Animal 3-Chief 4-Rag
		SetModelBody(2, 8); // weapon: 0-Unarmed 1-Axe 2-wbow 3-sbow 4-sword 5-rAxe 6-sword&shield 7-club 8-knife
		SetModelBody(3, 0); // arrow: On/off

		SetProp(ENT_ME, "skin", 3); // 0-norm 1-blood 2-vile 3-Shadow

		SetIdleAnim(ANIM_IDLE);
		SetMoveAnim(ANIM_WALK);

		ANIM_ATTACK = "swordswing1_L";

		ClientEvent("new", "all", CL_SCRIPT);
		CL_IDX = LastClientScriptId();

		SWING_COUNT = 0.0f;
	}

	// swing_axe
	void OnSwingAxe()
	{
		PlayRandomSound(0, 10, SOUND_ATTACK1, SOUND_ATTACK2, SOUND_ATTACK3);
		DoDamage(NPCATK_TARGET, ATTACK_HITRANGE, DMG_KNIFE, ATTACK_HITCHANCE, "slash");
		OVERHEAD_SMASH = true;
	}

	// swing_sword
	void OnSwingSword()
	{
		// if ( AM_INVISIBLE ) callevent fade_in
		PlayRandomSound(0, 10, SOUND_ATTACK1, SOUND_ATTACK2, SOUND_ATTACK3);
		DoDamage(NPCATK_TARGET, ATTACK_HITRANGE, DMG_KNIFE, ATTACK_HITCHANCE, "pierce");
		SWING_COUNT += 1.0f;
		if (!(SWING_COUNT > 5.0f))
			return;
		SWING_COUNT = 0.0f;
		OnFadeAndFlee();
	}

	// gob_jump_check
	void OnGobJumpCheck()
	{
		if (!GOB_JUMP_SCANNING)
			return;
		float gobHopDelay = Random(2, 4);
		CallEventDelayed(gobHopDelay, "gob_jump_check");

		// no jumpy if in stabby range
		if (!(RangeTo(NPCATK_TARGET) > ATTACK_HITRANGE))
			return;

		if (NPCATK_TARGET == "unset")
			return;
		if (I_R_FROZEN)
			return;
		if (IS_FLEEING)
			return;
		if (!(RangeTo(NPCATK_TARGET) < GOBLIN_JUMPRANGE))
			return;

		// jump at target if he's higher than I am
		Vector3 mePos = MyOrigin();
		float myZ = mePos.z;
		Vector3 targetPos = OriginOf(NPCATK_TARGET);
		float targetZ = targetPos.z;
		float targetZDifference = targetZ - myZ;

		if (targetZDifference > 0.0f)
		{
			if (targetZDifference < 500.0f) // not hoplessly high up
			{
				PlayAnim("critical", ANIM_SMASH);
				CallEventDelayed(0.1f, "gob_hop");
			}
		}
	}

	// jump_away
	void OnJumpAway()
	{
		if (!IS_FLEEING)
			OnNpcatkFlee(EntityId(EntityOf(ENT_LASTSTRUCK)), "100", "3.0");
		CallEventDelayed(0.1f, "gob_hop");
	}

	// fade_and_flee
	void OnFadeAndFlee()
	{
		ClientEvent("update", "all", CL_IDX, "poof_fx", OriginOf(ENT_ME));
		OnJumpAway();
		CallEventDelayed(0.25f, "go_invisible");
	}

	// go_invisible
	void OnGoInvisible()
	{
		if (!IsAlive(ENT_ME))
			return;
		DebugPrint("*** GOING INVISIBLE ***");
		AM_INVISIBLE = true;
		PlaySound(0, 10, SOUND_FADE);
		SetProp(ENT_ME, "rendermode", 2);
		SetProp(ENT_ME, "renderamt", 0);
		SetModelBody(0, 2); // body: 0-Bare 1-Quiver&Strap 2-invisible
		SetModelBody(1, 0); // head: 0-Bare 1-Horns 2-Animal 3-Chief 4-Rag
		SetModelBody(2, 0); // weapon: 0-Unarmed 1-Axe 2-wbow 3-sbow 4-sword 5-rAxe 6-sword&shield 7-club 8-knife
		SetModelBody(3, 0); // arrow: On/off
		OnEtherialImmunes();
	}

	// go_visible
	void OnGoVisible()
	{
		DebugPrint("*** GOING VISIBLE ***");
		AM_INVISIBLE = false;
		SetProp(ENT_ME, "rendermode", 0);
		SetProp(ENT_ME, "renderamt", 255);
		OnNormalImmunes();

		SetModelBody(0, 0); // body: 0-Bare 1-Quiver&Strap 2-invisible
		SetModelBody(1, 0); // head: 0-Bare 1-Horns 2-Animal 3-Chief 4-Rag
		SetModelBody(2, 8); // weapon: 0-Unarmed 1-Axe 2-wbow 3-sbow 4-sword 5-rAxe 6-sword&shield 7-club 8-knife
		SetModelBody(3, 0); // arrow: On/off
	}

	// fade_in
	void OnFadeIn()
	{
		if (!IsAlive(ENT_ME))
			return;
		PlaySound(0, 10, SOUND_APPEAR);
		ClientEvent("update", "all", CL_IDX, "unpoof_fx", OriginOf(ENT_ME));
		OnGoVisible();
	}

	// etherial_immunes
	void OnEtherialImmunes()
	{
		ClearEffects();
		SetInvincible(true);
		SetDamageTaken("fire", 0);
		SetDamageTaken("cold", 0);
		SetDamageTaken("poison", 0);
		SetDamageTaken("holy", 1); // blarg - wont work while invulnerable, but meh
	}

	// normal_immunes
	void OnNormalImmunes()
	{
		SetInvincible(false);
		SetDamageTaken("fire", 1);
		SetDamageTaken("cold", 1);
		SetDamageTaken("poison", 1);
		SetDamageTaken("holy", 0);
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/goblin_new.mdl");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		Sgoblin_FirstThink();
		Bgoblin_FirstThink();
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
		if (name == "etherial_immunes") { OnEtherialImmunes(); return true; }
		if (name == "fade_and_flee") { OnFadeAndFlee(); return true; }
		if (name == "fade_in") { OnFadeIn(); return true; }
		if (name == "game_death") { OnGameDeath(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_dodamage") { Return(OnGameDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5))); return true; }
		if (name == "game_precache") { OnGamePrecache(); return true; }
		if (name == "game_struck") { OnGameStruck(Float(Param(params, 0)), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "go_invisible") { OnGoInvisible(); return true; }
		if (name == "go_visible") { OnGoVisible(); return true; }
		if (name == "gob_jump_check") { OnGobJumpCheck(); return true; }
		if (name == "goblin_spawn") { OnGoblinSpawn(); return true; }
		if (name == "jump_away") { OnJumpAway(); return true; }
		if (name == "my_target_died") { OnMyTargetDied(Param(params, 0)); return true; }
		if (name == "normal_immunes") { OnNormalImmunes(); return true; }
		if (name == "npc_selectattack") { OnNpcSelectattack(); return true; }
		if (name == "npc_targetsighted") { OnNpcTargetsighted(Param(params, 0)); return true; }
		if (name == "swing_axe") { OnSwingAxe(); return true; }
		if (name == "swing_sword") { OnSwingSword(); return true; }
		return BgoblinScript::DispatchEvent(name, params);
	}
}
