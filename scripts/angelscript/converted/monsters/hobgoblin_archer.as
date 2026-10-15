#pragma context server

// Converted from monsters/hobgoblin_archer.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/bgoblin.as"

[script "monsters/hobgoblin_archer"]
class HobgoblinArcher : BgoblinScript
{
	// Constants
	string SOUND_BREATH = "monsters/goblin/sps_fogfire.wav";
	int STEP_SIZE_NORM = 36;
	string SOUND_BOW = "weapons/bow/bow.wav";
	int DMG_BOW = 0;
	string DMG_KICK = "DMG_KICK";
	int KICK_RANGE = 128;
	int KICK_HITCHANCE = 90;
	float FREQ_KICK = 10.0f;
	int DMG_CHARGE = 50;

	// Variables (an unset .script variable reads as its own name)
	int DROPS_CONTAINER = 0;
	string CONTAINER_SCRIPT = "CONTAINER_SCRIPT";
	float NEXT_KICK = 0.0f;
	bool KICK_ATTACK = false;

	// Variables declared by included files, with the value they start with in this script
	HobgoblinArcher()
	{
		NPC_BASE_EXP = "150";
		SOUND_ATTACK1 = "monsters/goblin/c_gargoyle_atk1.wav";
		SOUND_ATTACK2 = "monsters/goblin/c_gargoyle_atk2.wav";
		SOUND_ATTACK3 = "monsters/goblin/c_gargoyle_atk3.wav";
		GOB_JUMPER = false;
		GOB_CHARGER = false;
	}

	// unnamed block (first think)
	void HobgoblinArcher_FirstThink()
	{
		CAN_STUN = false;

		CAN_FIREBALL = false;
		NPC_RANGED = "1";

		DROPS_CONTAINER = 1;
		CONTAINER_DROP_CHANCE = "10%";
		CONTAINER_SCRIPT = "chests/quiver_of_jagged";

		DROP_GOLD = 1;
		DROP_GOLD_AMT = RandomInt(20, 40);

		ANIM_ATTACK = "shootorcbow";

		ATTACK_HITCHANCE = "95%";
	}

	// game_dodamage
	string HobgoblinArcher_OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";

		if (KICK_ATTACK && hit && RangeTo(target) < KICK_RANGE)
			ApplyEffect(target, "effects/debuff_stun", 5, self);
		KICK_ATTACK = false;
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
		Bgoblin_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/bgoblin
		SetModelBody(3, 0);
	}

	// npcatk_flee
	void OnNpcatkFlee(string threatEntity = "", string fleeDistance = "", string fleeDuration = "")
	{
		BaseNpcAttackNew_OnNpcatkFlee(threatEntity, fleeDistance, fleeDuration); // monsters/base_npc_attack_new
		SetMoveSpeed(2);
	}

	// npcatk_stopflee
	void OnNpcatkStopflee()
	{
		BaseNpcAttackNew_OnNpcatkStopflee(); // monsters/base_npc_attack_new
		SetMoveSpeed(1);
	}

	// game_dodamage
	string OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";
		result = AppendResult(result, BaseNpcAttackNew_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BaseAntiStuck_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BaseMonsterShared_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, HobgoblinArcher_OnGameDodamage(hit, target, start, end, damageType, damageText));
		return result;
	}

	// gob_hunt
	void OnGobHunt()
	{
		Bgoblin_OnGobHunt(); // monsters/bgoblin
		if (!IsAlive(NPCATK_TARGET))
			return;
		if (!(RangeTo(NPCATK_TARGET) < KICK_RANGE))
			return;
		if (!(GameTime() > NEXT_KICK))
			return;
		NEXT_KICK = GameTime();
		PlayAnim("break");
		SetModelBody(3, 0);
		NEXT_KICK += FREQ_KICK;
		ANIM_ATTACK = ANIM_KICK;
	}

	// goblin_spawn
	void OnGoblinSpawn()
	{
		SetName("Hobgoblin Ranger");
		SetRace("goblin");
		SetBlood("red");
		SetHealth(500);
		SetRoam(true);

		SetAnimFrameRate(1.5f);

		SetHearingSensitivity(4);

		SetModel("monsters/goblin_new_boss.mdl");
		SetWidth(32);
		SetHeight(72);

		SetModelBody(0, 1); // body: 0-Bare 1-Quiver&Strap
		SetModelBody(1, 1); // head: 0-Bare 1-Horns 2-Animal 3-Chief 4-Rag
		SetModelBody(2, 4); // weapon: 0-Unarmed 1-SkullClub 2-DragonAxe 3-Knife 4-Bow 5-Raxe 6-SW&SH
		SetModelBody(3, 0); // arrow: On/off

		SetProp(ENT_ME, "skin", 0); // 0-norm 1-blood 2-vile

		SetIdleAnim(ANIM_IDLE);
		SetMoveAnim(ANIM_WALK);

		CallEventDelayed(0.01f, "gob_extras");
	}

	// gob_extras
	void OnGobExtras()
	{
		// these are not setting right for some damned reason
		MOVE_RANGE = "2000";
		ATTACK_RANGE = 2000.0f;
		ATTACK_HITRANGE = 2000.0f;

		DROP_GOLD_AMT = RandomInt(30, 50);
	}

	// grab_arrow
	void OnGrabArrow()
	{
		SetModelBody(3, 1);
	}

	// shoot_arrow
	void OnShootArrow()
	{
		float targetDist = RangeTo(ENT_LASTSEEN);
		Vector3 finalTarget = OriginOf(ENT_LASTSEEN);
		finalTarget += RelativePosition(Vector3(0, 0, 0), Vector3(0, 0, targetDist));
		targetDist = Divide(targetDist, 100.0f);
		SetAngle("add_view.pitch", targetDist);

		// <projectile scriptname> <"view"|(src_origin)> <target|(targ_origin)|none> <speed> <damage> <cof> <skill|none> //Converted to use new tossprojectile //greatguys1@FEB2022
		TossProjectile("proj_arrow_npc", RelativePosition(Vector3(0, 0, -4)), "none", 900, DMG_BOW, 2, "none");
		CallExternal(EntityOf(ENT_LASTPROJECTILE), "ext_lighten", 0.4f);

		SetModelBody(3, 0);

		PlaySound(2, SOUND_BOW);
	}

	// kick_land
	void OnKickLand()
	{
		PlaySound(0, 10, SOUND_BOW);
		KICK_ATTACK = true;
		DoDamage(NPCATK_TARGET, KICK_RANGE, DMG_KICK, KICK_HITCHANCE, "blunt");
		ANIM_ATTACK = ANIM_BOW;
		OnNpcatkFlee(NPCATK_TARGET, "1024", "3.0");
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/goblin_new_boss.mdl");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		HobgoblinArcher_FirstThink();
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
		if (name == "game_death") { OnGameDeath(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_dodamage") { Return(OnGameDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5))); return true; }
		if (name == "gob_extras") { OnGobExtras(); return true; }
		if (name == "gob_hunt") { OnGobHunt(); return true; }
		if (name == "goblin_spawn") { OnGoblinSpawn(); return true; }
		if (name == "grab_arrow") { OnGrabArrow(); return true; }
		if (name == "kick_land") { OnKickLand(); return true; }
		if (name == "npcatk_flee") { OnNpcatkFlee(Param(params, 0), Param(params, 1), Param(params, 2)); return true; }
		if (name == "npcatk_stopflee") { OnNpcatkStopflee(); return true; }
		if (name == "shoot_arrow") { OnShootArrow(); return true; }
		return BgoblinScript::DispatchEvent(name, params);
	}
}
