#pragma context server

// Converted from m2_quest/goblin_needler.script by msc_transpiler.
// Vile Goblin Fodder
// - Slightly weaker than the blood goblins, but just as rambunctious

#include "runtime/ScriptEntity.as"
#include "converted/monsters/bgoblin.as"

[script "m2_quest/goblin_needler"]
class GoblinNeedler : BgoblinScript
{
	// Constants
	string SOUND_BOW = "weapons/bow/bow.wav";
	int DMG_BOW = 0;
	string DMG_KICK = "DMG_KICK";
	int KICK_RANGE = 64;
	int KICK_HITCHANCE = 90;
	float FREQ_KICK = 10.0f;
	string ARROW_SCRIPT = "proj_arrow_npc";

	// Variables (an unset .script variable reads as its own name)
	int DROPS_CONTAINER = 0;
	string CONTAINER_SCRIPT = "CONTAINER_SCRIPT";
	float NEXT_KICK = 0.0f;
	bool KICK_ATTACK = false;

	// Variables declared by included files, with the value they start with in this script
	GoblinNeedler()
	{
		NPC_BASE_EXP = "50";
		GOB_JUMPER = false;
		GOB_CHARGER = false;
	}

	// unnamed block (first think)
	void GoblinNeedler_FirstThink()
	{
		CAN_FIREBALL = false;

		NPC_RANGED = "1";

		DROPS_CONTAINER = 1;
		CONTAINER_DROP_CHANCE = "10%";
		CONTAINER_SCRIPT = "chests/quiver_of_gpoison";

		ANIM_ATTACK = "shootorcbow";
	}

	// game_dodamage
	string GoblinNeedler_OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
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
		result = AppendResult(result, GoblinNeedler_OnGameDodamage(hit, target, start, end, damageType, damageText));
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
		SetName("Goblin Needler");
		SetRace("goblin");
		SetBlood("red");
		SetHealth(100);
		if (!NEW_MODEL)
		{
			SetModel("monsters/goblin2.mdl");
			SetWidth(32);
			SetHeight(60);

			SetModelBody(0, 3); // body: 0-Runed 1-Archer 2-Leathers 3-Sniper
			SetModelBody(1, 4); // head: 0-Horns* 1-Spikes* 2-Animal 3-Chief 4-Cowl *redcap
			SetModelBody(2, 2); // weapon: 0-Unarmed 1-Axe 2-wbow 3-sbow 4-sword 5-rAxe 6-sword&shield 7-club 8-knife
			SetModelBody(3, 0); // arrow: on/off

			SetProp(ENT_ME, "skin", 0);
		}
		else
		{
			SetModel("monsters/goblin_new.mdl");
			SetWidth(24);
			SetHeight(50);

			SetModelBody(0, 1); // body: 0-Bare 1-Quiver&Strap
			SetModelBody(1, 2); // head: 0-Bare 1-Horns 2-Animal 3-Chief 4-Rag
			SetModelBody(2, 2); // weapon: 0-Unarmed 1-Axe 2-wbow 3-sbow 4-sword 5-rAxe 6-sword&shield 7-club 8-knife
			SetModelBody(3, 0); // arrow: On/off

			SetProp(ENT_ME, "skin", 0); // 0-norm 1-blood 2-vile
		}

		SetRoam(true);

		SetHearingSensitivity(2);

		SetIdleAnim(ANIM_IDLE);
		SetMoveAnim(ANIM_WALK);

		// takedmg poison 0.25
		// takedmg lightning 1.25
		CallEventDelayed(0.01f, "gob_extras");
	}

	// gob_extras
	void OnGobExtras()
	{
		// these are not setting right for some damned reason
		MOVE_RANGE = "2000";
		ATTACK_RANGE = 2000.0f;
		ATTACK_HITRANGE = 2000.0f;

		DROP_GOLD_AMT = RandomInt(10, 30);
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

		// <projectile scriptname> <"view"|(src_origin)> <target|(targ_origin)> <speed> <damage> <cof> <skill|none> //Converted to use new tossprojectile //greatguys1@FEB2022
		TossProjectile(ARROW_SCRIPT, RelativePosition(Vector3(0, 0, 4)), "none", 900, DMG_BOW, 2, "none");
		CallExternal(EntityOf(ENT_LASTPROJECTILE), "ext_lighten", 0.4f);

		SetModelBody(3, 0);

		PlaySound(2, SOUND_BOW);
	}

	// kick_land
	void OnKickLand()
	{
		DoDamage(NPCATK_TARGET, KICK_RANGE, DMG_KICK, KICK_HITCHANCE, "blunt");
		KICK_ATTACK = true;
		ANIM_ATTACK = ANIM_BOW;
		OnNpcatkFlee(NPCATK_TARGET, "1024", "3.0");
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		GoblinNeedler_FirstThink();
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
