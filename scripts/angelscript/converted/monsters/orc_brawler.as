#pragma context server

// Converted from monsters/orc_brawler.script by msc_transpiler.
// Orc Brawler from Orc Berserker by Thothie
// - A really, big, angry, orc - stun attacks galor

#include "runtime/ScriptEntity.as"
#include "converted/monsters/orc_base_melee.as"
#include "converted/monsters/orc_base.as"

[script "monsters/orc_brawler"]
class OrcBrawler : OrcBaseScript, OrcBaseMelee
{
	// Constants
	string ANIM_SMASH = "battleaxe_swing1_L";
	string ANIM_SWIPE1 = "swordswing1_L";
	string ANIM_SLAP = "deflectcounter";
	string ANIM_KICK = "kick";
	string ANIM_WARCRY = "warcry";
	float KICK_DMG_DELAY = 0.5f;
	float SLAP_DMG_DELAY = 0.5f;
	string ATTACK_ACCURACY = "70%";
	float ATTACK_DMG_LOW = 10.0f;
	float ATTACK_DMG_HIGH = 20.0f;
	string SOUND_KICK = "zombie/claw_miss1.wav";
	string SOUND_SLAP = "zombie/claw_miss2.wav";
	string SOUND_KICKHIT = "zombie/claw_strike2.wav";
	string SOUND_SLAPHIT = "zombie/claw_strike3.wav";
	string SOUND_WARCRY = "monsters/troll/trollidle.wav";
	string SOUND_CHARGE = "garg/gar_alert3.wav";
	float STUCK_CHECK_FREQUENCY = 2.0f;

	// Variables (an unset .script variable reads as its own name)
	string DROP_ITEM1 = "DROP_ITEM1";
	string ANIM_ATTACK1 = "ANIM_ATTACK1";
	string ATTACK_DAMAGE = "ATTACK_DAMAGE";
	string ATTACK_PUSH = "ATTACK_PUSH";
	string ATTACK_TYPE = "ATTACK_TYPE";
	bool ATTACKING = false;
	float NEXT_ATTACK = 0.0f;
	bool DID_WARCRY = false;
	bool DONE_WARCRY = false;
	bool CHARGE_DELAY = false;

	// Variables declared by included files, with the value they start with in this script
	OrcBrawler()
	{
		ZORC_DMG_MULTI = 4.0f;
		ZORC_HP_MULTI = 3.0f;
	}

	// unnamed block (first think)
	void OrcBrawler_FirstThink()
	{
		DROP_GOLD = 1; // Gold Drops
		DROP_GOLD_AMT = RandomInt(30, 60);
		NPC_GIVE_EXP = 200.0f;
		DROP_ITEM1 = "blunt_gauntlets"; // Used by base_monster
		DROP_ITEM1_CHANCE = "20%"; // Used by base_monster

		ANIM_ATTACK1 = "swordswing1_L"; // Attack animation 1

		FLINCH_CHANCE = "45%";

		ATTACK_DAMAGE = RandomInt(50, 100);

		ATTACK_RANGE = 100.0f;
		ATTACK_HITRANGE = 150.0f;
		ATTACK_MOVERANGE = 50.0f;
		MOVE_RANGE = "50";
	}

	// game_dodamage
	// 1: Attack Hit (1/0)  2: Entity Attack hit  3:  Start Position  4:  End
	string OrcBrawler_OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";

		ATTACKING = false;

		if (!hit)
			return result;

		if (Float(ATTACK_TYPE) == 1.0f && RandomInt(1, 5) == 1)
			ApplyEffect(ENT_LASTSTRUCKBYME, "effects/debuff_stun", RandomInt(5, 10), self);

		if (Float(ATTACK_TYPE) == 2.0f && RandomInt(1, 10) == 1)
			ApplyEffect(ENT_LASTSTRUCKBYME, "effects/debuff_stun", RandomInt(5, 10), self);

		if (Float(ATTACK_TYPE) == 3.0f)
		{
			PlaySound(0, 10, SOUND_SLAPHIT);
			if (RandomInt(1, 10) == 1)
				ApplyEffect(ENT_LASTSTRUCKBYME, "effects/debuff_stun", RandomInt(5, 10), self);
		}

		if (Float(ATTACK_TYPE) == 4.0f)
		{
			PlaySound(0, 10, SOUND_KICKHIT);
			if (RandomInt(1, 2) == 1)
				ApplyEffect(ENT_LASTSTRUCKBYME, "effects/effect_push", 3, RelativeVelocity(Vector3(0, 200, 30)));
			ApplyEffect(ENT_LASTSTRUCKBYME, "effects/debuff_stun", RandomInt(5, 10), self);
		}
		return result;
	}

	// orc_spawn
	void OnOrcSpawn()
	{
		OrcBaseMelee_OnOrcSpawn(); // monsters/orc_base_melee

		if (Truthy(GetVar("G_SHAD_PRESENT")))
			CallEventDelayed(0.1f, "bo_zombie_mode");

		SetHealth(1000);
		// ov 180
		if (ToLowerCase(MapName()) == "mscave")
			SetWidth(32);
		if (ToLowerCase(MapName()) != "mscave")
			SetWidth(38);
		SetHeight(72);
		SetName("Orcish Brawler");
		SetHearingSensitivity(8);
		SetModel("monsters/orc_big.mdl");

		SetMoveSpeed(2);

		SetModelBody(0, 0); // Body 0=naked 1=leather 2=plate 3=green-hide
		SetModelBody(1, 1); // Head 0=cap_shorthorn 1=cap_nohorn 2=buffo_skin 3=cheif_ramhorns 4=green_hood
		SetModelBody(2, 0); // Weapon 0=fist 1=axe 2=bow_weak 3=bow_strng 4=sword 5=bloodyaxe 6=sword&sheild
	}

	// npcatk_targetvalidate
	void OnNpcatkTargetvalidate(string target = "")
	{
		OrcBaseMelee_OnNpcatkTargetvalidate(target); // monsters/orc_base_melee
		BaseNpcAttackNew_OnNpcatkTargetvalidate(target); // monsters/base_npc_attack_new
		OrcBase_OnNpcatkTargetvalidate(target); // monsters/orc_base
		bool exitSub = false;

		if (!DID_WARCRY && IsPlayer(ENT_LASTSEEN))
		{
			PlayAnim("critical", ANIM_WARCRY);
			PlaySound(0, 10, SOUND_WARCRY);
			DID_WARCRY = true;
			DONE_WARCRY = false;
			CallEventDelayed(3.0f, "warcry_over");
			exitSub = true;
		}

		if (exitSub)
			return;

		if (!DONE_WARCRY)
			return;

		float nmeRange = RangeTo(ENT_LASTSEEN);

		// //dbg NME_RANGE  donewc DONE_WARCRY exit EXIT_SUB
		if (!(nmeRange > 200.0f))
			return;
		// dbg delay CHARGE_DELAY
		if (CHARGE_DELAY)
			return;
		OnStartCharge();
	}

	// freeze_solid_end
	void OnFreezeSolidEnd(int unfrozeEarly = 0)
	{
		MonstersExternals_OnFreezeSolidEnd(unfrozeEarly); // monsters/externals

		SetMoveSpeed(2);
	}

	// game_dodamage
	string OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";
		result = AppendResult(result, BaseNpcAttackNew_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BaseAntiStuck_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BaseMonsterShared_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, OrcBrawler_OnGameDodamage(hit, target, start, end, damageType, damageText));
		return result;
	}

	// npc_selectattack
	void OnNpcSelectattack()
	{
		BaseAntiStuck_OnNpcSelectattack(); // monsters/base_anti_stuck
		BaseMonsterShared_OnNpcSelectattack(); // monsters/base_monster_shared

		ATTACK_PUSH = "none";

		if (ATTACKING)
			return;

		if (Text(NEXT_ATTACK) == "NEXT_ATTACK")
			ATTACK_TYPE = RandomInt(1, 4);

		if (Text(NEXT_ATTACK) != "NEXT_ATTACK")
			ATTACK_TYPE = Text(NEXT_ATTACK);

		ATTACKING = true;

		if (Float(ATTACK_TYPE) == 1.0f)
		{
			ATTACK_PUSH = Text(RelativeVelocity(Vector3(-200, 230, 220)));
			ATTACK_DAMAGE = RandomInt(50, 150);
			ANIM_ATTACK = ANIM_SMASH;
			PlayAnim("critical", ANIM_SMASH);
			ATTACK_TYPE = RandomInt(1, 4);
		}

		if (Float(ATTACK_TYPE) == 2.0f)
		{
			ATTACK_DAMAGE = RandomInt(25, 100);
			ATTACK_PUSH = Text(RelativeVelocity(Vector3(-100, 130, 120)));
			ANIM_ATTACK = ANIM_SWIPE1;
			PlayAnim("critical", ANIM_SWIPE1);
			ATTACK_TYPE = RandomInt(1, 4);
		}

		if (Float(ATTACK_TYPE) == 3.0f)
		{
			ATTACK_DAMAGE = RandomInt(25, 50);
			ATTACK_PUSH = Text(RelativeVelocity(Vector3(-10, 13, 12)));
			ANIM_ATTACK = ANIM_SLAP;
			PlayAnim("critical", ANIM_SLAP);
			PlaySound(0, 10, SOUND_SLAP);
			CallEventDelayed(SLAP_DMG_DELAY, "slap_damage");
			NEXT_ATTACK = 1.0f;
		}

		if (Float(ATTACK_TYPE) == 4.0f)
		{
			ATTACK_DAMAGE = RandomInt(50, 100);
			ATTACK_PUSH = Text(RelativeVelocity(Vector3(-300, 330, 320)));
			ANIM_ATTACK = ANIM_KICK;
			PlayAnim("critical", ANIM_KICK);
			PlaySound(0, 10, SOUND_KICK);
			CallEventDelayed(KICK_DMG_DELAY, "kick_damage");
			if (!I_R_FROZEN)
				SetMoveSpeed(2);
			NEXT_ATTACK = 1.0f;
		}
	}

	// bo_zombie_mode
	void OnBoZombieMode()
	{
		OrcBase_OnBoZombieMode(); // monsters/orc_base
		// too lazy to remake the zombie skin for this orc
		OnNpcSuicide();
	}

	// kick_damage
	void OnKickDamage()
	{
		OnNpcatkDodamage(EntityId(EntityOf(ENT_LASTSEEN)), Text(ATTACK_HITRANGE), ATTACK_DAMAGE, ATTACK_ACCURACY);
		ATTACKING = false;
	}

	// slap_damage
	void OnSlapDamage()
	{
		OnNpcatkDodamage(EntityId(EntityOf(ENT_LASTSEEN)), Text(ATTACK_HITRANGE), ATTACK_DAMAGE, ATTACK_ACCURACY);
		ATTACKING = false;
	}

	// swing_axe
	void OnSwingAxe()
	{
		OnNpcatkDodamage(EntityId(EntityOf(ENT_LASTSEEN)), Text(ATTACK_HITRANGE), ATTACK_DAMAGE, ATTACK_ACCURACY);
		OnBaseorcYell();
		ATTACKING = false;
	}

	// swing_sword
	void OnSwingSword()
	{
		OnNpcatkDodamage(EntityId(EntityOf(ENT_LASTSEEN)), Text(ATTACK_HITRANGE), ATTACK_DAMAGE, ATTACK_ACCURACY);
		OnBaseorcYell();
		ATTACKING = false;
	}

	// start_charge
	void OnStartCharge()
	{
		// dbg Doing Charge!
		ApplyEffect(ENT_ME, "effects/sfx_motionblur", self, 0);
		if (!I_R_FROZEN)
			SetMoveSpeed(5);
		PlaySound(0, 10, SOUND_CHARGE);
		NEXT_ATTACK = 4.0f;
		CHARGE_DELAY = true;
		CallEventDelayed(3.0f, "charge_out");
		CallEventDelayed(10.0f, "charge_reset");
	}

	// charge_out
	void OnChargeOut()
	{
		if (!I_R_FROZEN)
			SetMoveSpeed(2);
	}

	// charge_reset
	void OnChargeReset()
	{
		CHARGE_DELAY = false;
	}

	// warcry_over
	void OnWarcryOver()
	{
		DONE_WARCRY = true;
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files

	// my_target_died
	void OnMyTargetDied(string offender = "")
	{
		OrcBaseMelee_OnMyTargetDied(offender); // monsters/orc_base_melee
		BaseNpcAttackNew_OnMyTargetDied(offender); // monsters/base_npc_attack_new
	}

	void OnBaseorcYell() { OrcBase_OnBaseorcYell(); } // baseorc_yell
	void OnKickDmgDelay() {} // KICK_DMG_DELAY
	void OnSlapDmgDelay() {} // SLAP_DMG_DELAY

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/orc.mdl");
		Precache("monsters/orc_big.mdl");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		OrcBrawler_FirstThink();
		OrcBaseMelee_FirstThink();
		OrcBase_FirstThink();
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
		if (name == "bo_zombie_mode") { OnBoZombieMode(); return true; }
		if (name == "charge_out") { OnChargeOut(); return true; }
		if (name == "charge_reset") { OnChargeReset(); return true; }
		if (name == "freeze_solid_end") { OnFreezeSolidEnd(Int(Param(params, 0))); return true; }
		if (name == "game_dodamage") { Return(OnGameDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5))); return true; }
		if (name == "kick_damage") { OnKickDamage(); return true; }
		if (name == "npc_selectattack") { OnNpcSelectattack(); return true; }
		if (name == "npcatk_targetvalidate") { OnNpcatkTargetvalidate(Param(params, 0)); return true; }
		if (name == "orc_spawn") { OnOrcSpawn(); return true; }
		if (name == "slap_damage") { OnSlapDamage(); return true; }
		if (name == "start_charge") { OnStartCharge(); return true; }
		if (name == "swing_axe") { OnSwingAxe(); return true; }
		if (name == "swing_sword") { OnSwingSword(); return true; }
		if (name == "warcry_over") { OnWarcryOver(); return true; }
		return OrcBaseMelee_DispatchEvent(name, params)
			|| OrcBaseScript::DispatchEvent(name, params);
	}
}
