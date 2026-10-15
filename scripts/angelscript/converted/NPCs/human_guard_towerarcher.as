#pragma context server

// Converted from NPCs/human_guard_towerarcher.script by msc_transpiler.
// Variant of arhcer for uses with archers with high perches
// - This has not yet achieved the desired effect :/

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_monster_new.as"

[script "NPCs/human_guard_towerarcher"]
class HumanGuardTowerarcher : BaseMonsterNewScript
{
	// Constants
	string SOUND_STRUCK = "body/flesh1.wav";
	string SOUND_WARCRY = "voices/human/male_guard_shout.wav";
	string SOUND_ATTACK = "weapons/bow/bowslow.wav";
	int ATTACK_SPEED = 900;
	string ARROW_TYPE = "proj_arrow_jagged";
	string ATTACK_DAMAGE = "$rand(8,12)";
	int ATTACK_COF = 5;

	// Variables (an unset .script variable reads as its own name)
	string ANIM_ATTACK = "ANIM_ATTACK";
	string CAN_HUNT = "CAN_HUNT";
	string CAN_ATTACK = "CAN_ATTACK";
	string HUNT_AGRO = "HUNT_AGRO";
	string ARROW_TARGET = "ARROW_TARGET";

	// Variables declared by included files, with the value they start with in this script
	HumanGuardTowerarcher()
	{
		SOUND_DEATH = "voices/human/male_die.wav";
		ANIM_IDLE = "idle1";
		ANIM_RUN = "run";
		ANIM_WALK = "walk";
	}

	// unnamed block (first think)
	void HumanGuardTowerarcher_FirstThink()
	{
		ANIM_IDLE = "idle1";
		ANIM_RUN = "run";
		ANIM_WALK = "walk";
		ANIM_DEATH = "die_fallback";
		ANIM_ATTACK = "shootorcbow";

		MOVE_RANGE = ATTACK_SPEED;
		ATTACK_RANGE = 2000.0f;
		ATTACK_HITRANGE = 2000.0f;

		CAN_HUNT = "1";
		CAN_ATTACK = "1";
		HUNT_AGRO = "1";
		CAN_RETALIATE = "1";

		NPC_GIVE_EXP = 0.0f;
	}

	// game_struck
	void OnGameStruck(float damage = 0.0f, string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		BaseNpc_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseNpcAttackNew_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc_attack_new
		BaseMonsterShared_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared

		ARROW_TARGET = EntityId(EntityOf(ENT_LASTSTRUCK));
		OnShootTarget();
		PlaySound(0, 5, SOUND_STRUCK);
	}

	// npc_spawn
	// in helena 	name_unique	Archer
	void OnNpcSpawn(string npc = "")
	{
		BaseNpcAttackNew_OnNpcSpawn(npc); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck

		SetName("Human Archer");
		SetHealth(120);
		// ov	359
		SetHearingSensitivity(12);
		SetWidth(32);
		SetHeight(85);
		LegacyCommand("blind", 1); // cant really 'see' anything up here, to don't waste the cycles
		SetRace("hguard");
		SetRoam(false);
		SetModel("npc/archer.mdl");
		SetDamageTaken("all", 0.9f);
		SetModelBody(2, 2);
		SetStat("parry", 2, 2, 2);
		SetMoveSpeed(0);

		SetAnimMoveSpeed(0);

		OnNpcatkSuspendAi();
		CallEventDelayed(1.0f, "scan_for_nme");
		PLAYING_DEAD = "1"; // monsters can't reach me, so ignore me

		if (ToLowerCase(MapName()) != "foutpost")
			return;
		SetRace("human");
		NPC_NO_PLAYER_DMG = true; // foutpost guards maybe forced to work amongst AOE player spells
	}

	// scan_for_nme
	void OnScanForNme()
	{
		bool exitSub = false;
		CallEventDelayed(1.0f, "scan_for_nme");
		string tBox = FindInBox("enemy", 1800);
		if (tBox == "none")
			return;
		tBox = SortEntities(tBox, "range");
		ARROW_TARGET = GetToken(tBox, 0);
		if (RaceOf(ARROW_TARGET) == "human")
		{
			ARROW_TARGET = "unset";
			exitSub = true;
		}
		if (exitSub)
			return;
		OnShootTarget();
	}

	// shoot_target
	void OnShootTarget()
	{
		SetMoveDest(ARROW_TARGET, 9999);
		PlayAnim("once", ANIM_ATTACK);
	}

	// shoot_arrow
	void OnShootArrow()
	{
		NPCATK_TARGET = ARROW_TARGET;
		Vector3 targOrg = OriginOf(NPCATK_TARGET);
		if (!IsPlayer(Text(targOrg)))
			targOrg.z += HeightOf(NPCATK_TARGET);
		float targDist = Divide(Distance(targOrg, MyOrigin()), 15.0f); // lower = higher arc
		SetAngle("add_view.pitch", targDist);

		// <projectile scriptname> <"view"|(src_origin)> <target|(targ_origin)|none> <speed> <damage> <cof> <skill|none> //Converted to use new tossprojectile //greatguys1@FEB2022
		TossProjectile("proj_arrow_npc", RelativePosition(Vector3(0, 0, 30)), "none", 400, ATTACK_DAMAGE, 0, "none"); // 0=10, for testing

		// callexternal $get(ent_lastprojectile,id) ext_lighten 0.4
		PlaySound(0, 10, SOUND_ATTACK);
	}

	// baseguard_tobattle
	void OnBaseguardTobattle(CBaseEntity@ enemy = null)
	{
		PlaySound(0, 10, SOUND_WARCRY);
	}

	// catapults_fire
	void OnCatapultsFire()
	{
		int rand = RandomInt(1, 100);
		if (rand > 60)
		{
			SetSayTextRange(1024);
			if (rand < 85)
				SayText("Take cover!");
			else
				SayText("Projectiles inbound!");
		}
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("npc/archer.mdl");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		HumanGuardTowerarcher_FirstThink();
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
		if (name == "baseguard_tobattle") { OnBaseguardTobattle(EntityParam(params, 0)); return true; }
		if (name == "catapults_fire") { OnCatapultsFire(); return true; }
		if (name == "game_struck") { OnGameStruck(Float(Param(params, 0)), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "scan_for_nme") { OnScanForNme(); return true; }
		if (name == "shoot_arrow") { OnShootArrow(); return true; }
		if (name == "shoot_target") { OnShootTarget(); return true; }
		return BaseMonsterNewScript::DispatchEvent(name, params);
	}
}
