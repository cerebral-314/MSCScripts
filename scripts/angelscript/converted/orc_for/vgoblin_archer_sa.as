#pragma context server

// Converted from orc_for/vgoblin_archer_sa.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/orc_for/tiers2.as"
#include "converted/orc_for/goblin_base.as"

[script "orc_for/vgoblin_archer_sa"]
class VgoblinArcherSa : GoblinBaseScript, Tiers2
{
	// Constants
	int NPC_CAP_EXP = 1000;
	string SOUND_BOW = "weapons/bow/bow.wav";
	int DMG_BOW = 20;
	string DMG_KICK = "10";
	float DOT_POISON = 5.0f;
	int KICK_RANGE = 64;
	int KICK_HITCHANCE = 90;
	float FREQ_KICK = 10.0f;

	// Variables (an unset .script variable reads as its own name)
	bool CAN_FIREBALL = false;
	float NEXT_KICK = 0.0f;
	bool KICK_ATTACK = false;

	// Variables declared by included files, with the value they start with in this script
	VgoblinArcherSa()
	{
		NPC_BASE_EXP = "75";
		GOB_JUMPER = false;
		GOB_CHARGER = false;
		NPC_SELF_ADJUST = true; // from orc_for/tiers2
		NPC_ADJ_TIERS = "0;750;1500;2000;3000;5000"; // from orc_for/tiers2
		NPC_ADJ_DMG_MUTLI_TOKENS = "1.0;1.5;2.0;5.0;7.5;15.0;"; // from orc_for/tiers2
		NPC_ADJ_HP_MUTLI_TOKENS = "1.0;2.0;3.0;5.0;7.5;10.0;"; // from orc_for/tiers2
	}

	// unnamed block (first think)
	void VgoblinArcherSa_FirstThink()
	{
		CAN_FIREBALL = false;

		NPC_RANGED = "1";

		ANIM_ATTACK = "shootorcbow";
	}

	// game_dodamage
	string VgoblinArcherSa_OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";

		if (KICK_ATTACK && hit && RangeTo(target) < KICK_RANGE)
		{
			ApplyEffect(target, "effects/debuff_stun", 5, self);
			if (NPC_ADJ_LEVEL > 2.0f)
				AddVelocity(target, RelativeVelocity(Vector3(0, 600, 110)));
		}
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
		GoblinBase_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // orc_for/goblin_base
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
		result = AppendResult(result, VgoblinArcherSa_OnGameDodamage(hit, target, start, end, damageType, damageText));
		return result;
	}

	// goblin_spawn
	void OnGoblinSpawn()
	{
		GoblinBase_OnGoblinSpawn(); // orc_for/goblin_base

		SetName("Vile Goblin Needler");
		SetRace("goblin");
		SetBlood("red");
		SetHealth(125);

		SetModel("monsters/goblin_new.mdl");
		SetWidth(24);
		SetHeight(50);

		SetProp(ENT_ME, "skin", 2); // 0-norm 1-blood 2-vile

		SetModelBody(0, 1); // body: 0-Bare 1-Quiver&Strap
		SetModelBody(1, 2); // head: 0-Bare 1-Horns 2-Animal 3-Chief 4-Rag
		SetModelBody(2, 2); // weapon: 0-Unarmed 1-Axe 2-wbow 3-sbow 4-sword 5-rAxe 6-sword&shield 7-club 8-knife
		SetModelBody(3, 0); // arrow: On/off

		SetRoam(true);

		SetHearingSensitivity(2);

		SetDamageTaken("poison", 0);
		SetDamageTaken("lightning", 1.25f);

		SetIdleAnim(ANIM_IDLE);
		SetMoveAnim(ANIM_WALK);

		CallEventDelayed(0.01f, "gob_extras");
	}

	// gob_hunt
	void OnGobHunt()
	{
		GoblinBase_OnGobHunt(); // orc_for/goblin_base
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

		TossProjectile("proj_arrow_npc_dyn", RelativePosition(Vector3(0, 0, 7)), "none", 900, DMG_BOW, 2, "none");
		CallExternal(ENT_LASTPROJECTILE, "ext_lighten", 0.4f, 1, Vector3(0, 255, 0));

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

	// ext_arrow_hit
	void OnExtArrowHit(string hit = "", CBaseEntity@ hitEntity = null, Vector3 startPosition = Vector3())
	{
		if (RelationshipOf(ENT_ME, @hitEntity) != "enemy")
			return;

		if (NPC_ADJ_LEVEL > 2.0f)
			AddVelocity(hitEntity, RelativeVelocity(Vector3(0, 600, 110)));

		ApplyEffect(hitEntity, "effects/dot_poison", 5.0f, self, DOT_POISON);
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
		VgoblinArcherSa_FirstThink();
		Tiers2_FirstThink();
		GoblinBase_FirstThink();
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
		if (name == "ext_arrow_hit") { OnExtArrowHit(Param(params, 0), EntityParam(params, 1), Vec(Param(params, 2))); return true; }
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
		return GoblinBaseScript::DispatchEvent(name, params);
	}
}
