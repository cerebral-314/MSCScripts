#pragma context server

// Converted from keledrosprelude/metalboar.script by msc_transpiler.
// This is an older script and may have some bad conventions as a result.
// Boss in the dark caves

#include "runtime/ScriptEntity.as"
#include "converted/monsters/boar_hard.as"

[script "keledrosprelude/metalboar"]
class Metalboar : MonstersBoarHardScript
{
	// Constants
	string ATTACK_HITPERCENT = "85%";

	// Variables (an unset .script variable reads as its own name)
	float HIT_COUNT = 0.0f;
	bool CAN_STTACK = false;

	// Variables declared by included files, with the value they start with in this script
	Metalboar()
	{
		NPC_BOSS_REGEN_RATE = 0.0f;
		NPC_BOSS_RESTORATION = 0.0f;
		GORE_FORWARD_DAMAGE = 15.0f;
		GORE_SIDE_DAMAGE = "8.5";
		BOAR_CHARGE_DMG = "25";
		NPC_BASE_EXP = "200";
		SOUND_STRUCK1 = "weapons/axemetal1.wav";
		SOUND_STRUCK2 = "weapons/axemetal2.wav";
		SOUND_STRUCK3 = "doors/doorstop5.wav";
	}

	// unnamed block (first think)
	void Metalboar_FirstThink()
	{
		if (StartsWith(ToLowerCase(MapName()), "keledros"))
			NPC_IS_BOSS = true;
		NPC_GIVE_EXP = 500.0f;

		IMMUNE_VAMPIRE = true;

		DROP_ITEM1_CHANCE = "0%";
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
		SetDamageTaken("holy", 2);
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck
		BoarBase_OnNpcSpawn(npc); // monsters/boar_base
		Boar_OnNpcSpawn(npc); // monsters/boar
		MonstersBoarHard_OnNpcSpawn(npc); // monsters/boar_hard

		SetHealth(650);
		SetDamageTaken("all", 0.35f);
		SetDamageTaken("pierce", 0.15f);
		SetDamageTaken("fire", 0.05f);
		SetDamageTaken("lightning", 2);
		SetDamageTaken("poison", 0);
		SetName("Boar made of metal");
		SetHearingSensitivity(9);
		SetModel("monsters/stoneboar.mdl");

		HIT_COUNT = 0.0f;

		// Set this here, to override base scripts
		CAN_FLEE = "0"; // base_npc_attack - Whether I run away at low health (changes for boar)
	}

	// npc_struck
	void OnNpcStruck(float damage = 0.0f)
	{
		BoarBase_OnNpcStruck(damage); // monsters/boar_base

		HIT_COUNT += 1.0f;
		if (HIT_COUNT >= 10.0f)
		{
			// back off for charge attack
			// ov 360
			SetHearingSensitivity(100);
			CBaseEntity@ myAttacker = EntityOf(ENT_LASTSTRUCK);
			OnNpcatkFlee(EntityId(myAttacker), "640", "2");
			HIT_COUNT = 0.0f;
		}
	}

	// boar_charge_hit
	void OnBoarChargeHit()
	{
		ApplyEffect(ENT_LASTSTRUCKBYME, "effects/effect_push", 3, RelativeVelocity(Vector3(0, 600, 600)), 0);
		ApplyEffect(ENT_LASTSTRUCKBYME, "effects/debuff_stun", 6, self);
	}

	// gore_forward
	void OnGoreForward()
	{
		ApplyEffect(ENT_ME, "effects/specialattack_haste", 2);

		PUSH_VEL = Text(Vector3(0, 0, 0));
		if (RandomInt(1, 10) == 1)
			ApplyEffect(ENT_LASTSTRUCKBYME, "effects/effect_push", 3, RelativeVelocity(Vector3(0, 400, 400)), 0);
		DoDamage(ENT_LASTSEEN, ATTACK_HITRANGE, GORE_FORWARD_DAMAGE, ATTACK_HITCHANCE);
	}

	// gore_left
	// Deal side damage
	void OnGoreLeft()
	{
		ApplyEffect(ENT_ME, "effects/specialattack_haste", 2);

		PUSH_VEL = Text(RelativeVelocity(Vector3(200, 100, 20)));
		if (RandomInt(1, 10) == 1)
			ApplyEffect(ENT_LASTSTRUCKBYME, "effects/effect_push", 3, RelativeVelocity(Vector3(200, 400, 400)), 0);
		DoDamage(ENT_LASTSEEN, ATTACK_HITRANGE, GORE_SIDE_DAMAGE, ATTACK_HITCHANCE);
	}

	// gore_right
	void OnGoreRight()
	{
		ApplyEffect(ENT_ME, "effects/specialattack_haste", 2);

		PUSH_VEL = Text(RelativeVelocity(Vector3(-200, 100, 20)));
		if (RandomInt(1, 10) == 1)
			ApplyEffect(ENT_LASTSTRUCKBYME, "effects/effect_push", 3, RelativeVelocity(Vector3(-200, 400, 400)), 0);
		DoDamage(ENT_LASTSEEN, ATTACK_HITRANGE, GORE_SIDE_DAMAGE, ATTACK_HITCHANCE);
	}

	// npcatk_flee
	// PARAM1: Threatning Entity  2: Dist to flee  3: Time to stop fleeing (optional)
	void OnNpcatkFlee(string threatEntity = "", string fleeDistance = "", string fleeDuration = "")
	{
		PlayAnim("break");
		SetMoveDest(threatEntity, fleeDistance, "flee");
		SetMoveAnim(ANIM_CHARGE);

		IS_FLEEING = true;
		NPCATK_FLEE_RESTORETARGET = IS_HUNTING;
		CallEventOrDelay(fleeDuration, "npcatk_stopflee");
	}

	// npcatk_stopflee
	void OnNpcatkStopflee()
	{
		CAN_STTACK = true;
		IS_FLEEING = false;
		CAN_FLEE = "0";

		SetMoveAnim(ANIM_RUN);
		if (NPCATK_FLEE_RESTORETARGET)
			OnNpcatkFaceattacker(HUNT_LASTTARGET);
		OnNpcStopflee();
		CallEventDelayed(1.0f, "boar_charge");
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/stoneboar.mdl");
		Precache("monsters/boar.mdl");
		Precache("monsters/boar1.mdl");
		CallEventDelayed(Float(Eval("$rand(10,25)")), "BoarBase_Timer");
		CallEventDelayed(Float(Eval("$rand(8,12)")), "BoarBase_Timer2");
		CallEventDelayed(0.1f, "BoarBase_Timer3");
		CallEventDelayed(Float(CYCLE_TIME), "hunting_mode_go");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		Metalboar_FirstThink();
		MonstersBoarHard_FirstThink();
		Boar_FirstThink();
		BoarBase_FirstThink();
		BaseNpcAttack_FirstThink();
		BaseNpc_FirstThink();
		MonstersExternals_FirstThink();
		BaseMonsterShared_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "boar_charge_hit") { OnBoarChargeHit(); return true; }
		if (name == "gore_forward") { OnGoreForward(); return true; }
		if (name == "gore_left") { OnGoreLeft(); return true; }
		if (name == "gore_right") { OnGoreRight(); return true; }
		if (name == "npc_post_spawn") { OnNpcPostSpawn(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "npc_struck") { OnNpcStruck(Float(Param(params, 0))); return true; }
		if (name == "npcatk_flee") { OnNpcatkFlee(Param(params, 0), Param(params, 1), Param(params, 2)); return true; }
		if (name == "npcatk_stopflee") { OnNpcatkStopflee(); return true; }
		return MonstersBoarHardScript::DispatchEvent(name, params);
	}
}
