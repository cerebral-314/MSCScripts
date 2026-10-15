#pragma context server

// Converted from monsters/sorc_brawler.script by msc_transpiler.
// Orc Brawler from Orc Berserker by Thothie
// - A really, big, angry, orc - stun attacks galor

#include "runtime/ScriptEntity.as"
#include "converted/monsters/orc_base_melee.as"
#include "converted/monsters/sorc_base.as"

[script "monsters/sorc_brawler"]
class SorcBrawler : SorcBaseScript, OrcBaseMelee
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
	string SOUND_ZAP1 = "debris/beamstart14.wav";
	string SOUND_ZAP2 = "debris/beamstart14.wav";
	string SOUND_ZAP3 = "debris/zap1.wav";
	string SOUND_WALK1 = "monsters/troll/step1.wav";
	string SOUND_WALK2 = "monsters/troll/step2.wav";
	string SOUND_TELE = "magic/teleport.wav";
	float STUCK_CHECK_FREQUENCY = 2.0f;

	// Variables (an unset .script variable reads as its own name)
	string ANIM_ATTACK1 = "ANIM_ATTACK1";
	string ATTACK_DAMAGE = "ATTACK_DAMAGE";
	string ATTACK_PUSH = "ATTACK_PUSH";
	string ATTACK_TYPE = "ATTACK_TYPE";
	bool ATTACKING = false;
	float NEXT_ATTACK = 0.0f;
	bool DID_WARCRY = false;
	bool DONE_WARCRY = false;
	string MY_SCRIPT_IDX = "MY_SCRIPT_IDX";
	bool CHARGE_DELAY = false;

	// unnamed block (first think)
	void SorcBrawler_FirstThink()
	{
		DROP_GOLD = 1; // Gold Drops
		DROP_GOLD_AMT = RandomInt(100, 200);
		NPC_GIVE_EXP = 500.0f;

		BASE_MOVESPEED = 2.0f;

		ANIM_ATTACK1 = "swordswing1_L"; // Attack animation 1

		FLINCH_CHANCE = "45%";

		ATTACK_DAMAGE = RandomInt(50, 100);

		ATTACK_RANGE = 150.0f;
		ATTACK_HITRANGE = 200.0f;
		ATTACK_MOVERANGE = 50.0f;
		MOVE_RANGE = "50";
	}

	// game_dodamage
	// 1: Attack Hit (1/0)  2: Entity Attack hit  3:  Start Position  4:  End
	string SorcBrawler_OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
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
			if (RandomInt(1, 20) == 1)
			{
				PlayRandomSound(0, 10, SOUND_ZAP1, SOUND_ZAP2, SOUND_ZAP3);
				Effect("glow", ENT_ME, Vector3(255, 255, 0), 128, 1, 1);
				Effect("screenfade", @target, 3, 1, Vector3(255, 255, 255), 255, "fadein");
			}
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

		SetHealth(4000);
		SetWidth(38);
		SetHeight(96);
		SetName("Shadahar Thunderfist");
		SetHearingSensitivity(8);
		SetModel("monsters/sorc_big.mdl");

		SetMoveSpeed(2);

		SetModelBody(0, 0); // body: 0=bare 1=bloody_shirt 2=gold_armor 3=archer
		SetModelBody(1, 1); // head: 0=hat_horns 1=hat_spiked 2=lizardskin_horned 3=gold_Chieftain 4=lizard_cap
		SetModelBody(2, 0); // weapon: 0=unarmed 1=axe 2=bow 3=steel_bow 4=sword 5=great_axe 6=sword_sheild 8=yellow_axe 9=blooddrinker
	}

	// npcatk_targetvalidate
	void OnNpcatkTargetvalidate(string target = "")
	{
		OrcBaseMelee_OnNpcatkTargetvalidate(target); // monsters/orc_base_melee
		BaseNpcAttackNew_OnNpcatkTargetvalidate(target); // monsters/base_npc_attack_new
		SorcBase_OnNpcatkTargetvalidate(target); // monsters/sorc_base
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

	// npc_post_spawn
	void OnNpcPostSpawn()
	{
		MonstersExternals_OnNpcPostSpawn(); // monsters/externals
		MonstersExternals_OnNpcPostSpawn_2(); // monsters/externals
		MonstersExternals_OnNpcPostSpawn_3(); // monsters/externals
		BaseSelfAdjust_OnNpcPostSpawn(); // monsters/base_self_adjust
		BaseNpc_OnNpcPostSpawn(); // monsters/base_npc
		BaseMonsterShared_OnNpcPostSpawn(); // monsters/base_monster_shared
		SorcBase_OnNpcPostSpawn(); // monsters/sorc_base
		SorcBase_OnNpcPostSpawn_2(); // monsters/sorc_base
		ATTACK_MOVERANGE = 86.0f;
		ATTACK_RANGE = 110.0f;
		ATTACK_HITRANGE = 175.0f;
	}

	// game_dodamage
	string OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";
		result = AppendResult(result, BaseNpcAttackNew_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BaseAntiStuck_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BaseMonsterShared_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, SorcBrawler_OnGameDodamage(hit, target, start, end, damageType, damageText));
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
			if (!I_R_FROZEN)
				SetMoveSpeed(2);
			NEXT_ATTACK = 1.0f;
		}
	}

	// kick_land
	// model event
	void OnKickLand()
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
		ClientEvent("new", "all", "effects/sfx_motionblur_perm", IndexOf(ENT_ME), 0);
		MY_SCRIPT_IDX = LastClientScriptId();
		NPC_FORCED_MOVEDEST = true;
		SetMoveDest(NPCATK_TARGET, ATTACK_MOVERANGE);
		if (!I_R_FROZEN)
			SetMoveSpeed(5);
		SetProp(ENT_ME, "rendermode", 5);
		SetProp(ENT_ME, "renderamt", 255);
		NEXT_ATTACK = 4.0f;
		CHARGE_DELAY = true;
		CallEventDelayed(0.1f, "boost_me");
		CallEventDelayed(0.5f, "render_norm");
		CallEventDelayed(3.0f, "charge_out");
		CallEventDelayed(10.0f, "charge_reset");
	}

	// boost_me
	void OnBoostMe()
	{
		PlaySound(0, 10, SOUND_TELE);
		AddVelocity(ENT_ME, RelativeVelocity(Vector3(0, 1000, 110)));
	}

	// render_norm
	void OnRenderNorm()
	{
		SetProp(ENT_ME, "rendermode", 0);
		SetProp(ENT_ME, "renderamt", 255);
	}

	// charge_out
	void OnChargeOut()
	{
		ClientEvent("remove", "all", MY_SCRIPT_IDX);

		if (I_R_FROZEN)
			return;
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

	// run_step1
	void OnRunStep1()
	{
		PlaySound(2, 8, SOUND_WALK2);
		Effect("screenshake", RelativePosition(Vector3(0, 0, 0)), 128, 10, 1, 128);
	}

	// run_step2
	void OnRunStep2()
	{
		PlaySound(2, 8, SOUND_WALK1);
		Effect("screenshake", RelativePosition(Vector3(0, 0, 0)), 128, 10, 1, 128);
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files

	// my_target_died
	void OnMyTargetDied(string offender = "")
	{
		OrcBaseMelee_OnMyTargetDied(offender); // monsters/orc_base_melee
		BaseNpcAttackNew_OnMyTargetDied(offender); // monsters/base_npc_attack_new
	}

	void OnBaseorcYell() { SorcBase_OnBaseorcYell(); } // baseorc_yell
	void OnSlapDmgDelay() {} // SLAP_DMG_DELAY

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/sorc_big.mdl");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		SorcBrawler_FirstThink();
		OrcBaseMelee_FirstThink();
		SorcBase_FirstThink();
		BaseNpc_FirstThink();
		MonstersExternals_FirstThink();
		BaseNpcAttackNew_FirstThink();
		BaseMonsterShared_FirstThink();
		SorcBase_FirstThink2();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "boost_me") { OnBoostMe(); return true; }
		if (name == "charge_out") { OnChargeOut(); return true; }
		if (name == "charge_reset") { OnChargeReset(); return true; }
		if (name == "freeze_solid_end") { OnFreezeSolidEnd(Int(Param(params, 0))); return true; }
		if (name == "game_dodamage") { Return(OnGameDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5))); return true; }
		if (name == "kick_land") { OnKickLand(); return true; }
		if (name == "npc_post_spawn") { OnNpcPostSpawn(); return true; }
		if (name == "npc_selectattack") { OnNpcSelectattack(); return true; }
		if (name == "npcatk_targetvalidate") { OnNpcatkTargetvalidate(Param(params, 0)); return true; }
		if (name == "orc_spawn") { OnOrcSpawn(); return true; }
		if (name == "render_norm") { OnRenderNorm(); return true; }
		if (name == "run_step1") { OnRunStep1(); return true; }
		if (name == "run_step2") { OnRunStep2(); return true; }
		if (name == "slap_damage") { OnSlapDamage(); return true; }
		if (name == "start_charge") { OnStartCharge(); return true; }
		if (name == "swing_axe") { OnSwingAxe(); return true; }
		if (name == "swing_sword") { OnSwingSword(); return true; }
		if (name == "warcry_over") { OnWarcryOver(); return true; }
		return OrcBaseMelee_DispatchEvent(name, params)
			|| SorcBaseScript::DispatchEvent(name, params);
	}
}
