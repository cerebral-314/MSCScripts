#pragma context server

// Converted from sorc_palace/thuldahr.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/orc_base_melee.as"
#include "converted/monsters/sorc_base.as"

[script "sorc_palace/thuldahr"]
class SorcPalaceThuldahr : SorcBaseScript, OrcBaseMelee
{
	// Constants
	string ANIM_SWING = "gglowswing";
	string ANIM_KICK = "kick";
	int ATTACH_IDX_AXE = 2;
	float FREQ_SPECIAL = 0.0f;
	int N_SPECIALS = 3;
	float FREQ_KICK = 0.0f;
	int DMG_SWING = 400;
	float DMG_ZAP = 300.0f;
	float DOT_ZAP = 100.0f;
	string SOUND_DRAW_WEAPON = "weapons/swords/sworddraw.wav";
	string SOUND_SWING = "weapons/swinghuge.wav";

	// Variables (an unset .script variable reads as its own name)
	bool CYCLES_ON = false;
	float SPECIAL_DURATION = 0.0f;
	string ZAP_TARGETS = "ZAP_TARGETS";
	string ZAP_INDEXES = "ZAP_INDEXES";
	string REPULSE_TARGETS = "REPULSE_TARGETS";
	bool KICK_ATTACK = false;
	float NEXT_KICK = 0.0f;
	bool CONFIRMED_ORDER = false;
	bool DOUBLE_REDUNDANT = false;

	// unnamed block (first think)
	void SorcPalaceThuldahr_FirstThink()
	{
		ANIM_KNEEL = "kneel"; // this has to be a vard as the base script uses it too
		ANIM_ATTACK = "gglowswing";
	}

	// unnamed block (first think)
	void SorcPalaceThuldahr_FirstThink2()
	{
		if (ToLowerCase(MapName()) == "shad_palace")
		{
			NPC_IS_BOSS = true;
			NPC_GIVE_EXP = 10000.0f;
			GiveItem("axes_gthunder11");
		}
		else
		{
			NPC_GIVE_EXP = 1000.0f;
		}

		SORC_NO_TELE = true;
	}

	// game_damaged
	string SorcPalaceThuldahr_OnGameDamaged(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float accuracyRoll = 0.0f, CBaseEntity@ inflictor = null, string skill = "")
	{
		string result = "";

		if (!KNEEL_MODE)
			return result;
		result = AppendResult(result, "0");
		return result;
	}

	// game_dodamage
	string SorcPalaceThuldahr_OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";
		if (KICK_ATTACK && hit)
			ApplyEffect(target, "effects/debuff_stun", 8.0f, self);
		KICK_ATTACK = false;
		return result;
	}

	// orc_spawn
	void OnOrcSpawn()
	{
		OrcBaseMelee_OnOrcSpawn(); // monsters/orc_base_melee
		SetModel("monsters/thuldahr.mdl");
		SetModelBody(2, 1); // 0=unarmed 1=hugeaxe 2=greataxe 3=beef 4=smith 5=mug

		SetName("Thuldahr");
		SetHealth(15000);
		SetRace("orc");
		SetDamageTaken("all", 0.5f);
		SetDamageTaken("lightning", 0);
		SetDamageTaken("poison", 1.2f);
		SetDamageTaken("acid", 1.5f);

		SetWidth(48);
		SetHeight(128);

		@CHIEF_ID = FindByName("the_warchief");

		if (Truthy(GetVar("G_SORC_CHIEF_PRESENT")))
		{
			KNEEL_MODE = true;
			SetIdleAnim(ANIM_KNEEL);
			SetMoveAnim(ANIM_KNEEL);
			OnNpcatkSuspendAi();
			SetRoam(false);
			SetInvincible(true);
		}
		else
		{
			SetRoam(true);
			SetMoveAnim(ANIM_WALK);
			SetIdleAnim(ANIM_IDLE);
		}
	}

	// game_death
	void OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		DqMonsterExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // dq/externals/dq_monster_externals
		MonstersExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/externals
		BaseSelfAdjust_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_self_adjust
		BaseNpc_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseMonsterShared_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared
		SorcBase_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/sorc_base
		CallExternal(CHIEF_ID, "thuld_died");
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
		ATTACK_MOVERANGE = 96.0f;
		ATTACK_RANGE = 128.0f;
		ATTACK_HITRANGE = 200.0f;
	}

	// game_dodamage
	string OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";
		result = AppendResult(result, BaseNpcAttackNew_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BaseAntiStuck_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BaseMonsterShared_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, SorcPalaceThuldahr_OnGameDodamage(hit, target, start, end, damageType, damageText));
		return result;
	}

	// game_damaged - Return a damage multiplier to scale the damage
	string OnGameDamaged(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float accuracyRoll = 0.0f, CBaseEntity@ inflictor = null, string skill = "")
	{
		string result = "";
		result = AppendResult(result, BaseAntiStuck_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, BaseMonsterShared_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, BaseMonsterShared_OnGameDamaged_2(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, SorcPalaceThuldahr_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		return result;
	}

	// sorcs_confirm_order
	// //debug, remove
	// { npcatk_hunt
	// local BEAM_START $get(ent_me,attachpos,0)
	// local BEAM_END $get(ent_me,attachpos,ATTACH_IDX_AXE)
	// effect beam point lgtning.spr 100 BEAM_START BEAM_END (255,0,255) 255 0 CYCLE_TIME
	// }
	void OnSorcsConfirmOrder()
	{
		SorcBase_OnSorcsConfirmOrder(); // monsters/sorc_base
		if (CONFIRMED_ORDER)
			return;
		CONFIRMED_ORDER = true;
		CallEventDelayed(1.0f, "thuld_confirm"); // thuldahr confirms last
	}

	// ext_chief_orders_attack
	void OnExtChiefOrdersAttack()
	{
		SorcBase_OnExtChiefOrdersAttack(); // monsters/sorc_base
		SetSayTextRange(1024);
		SetModelBody(2, 0);
		SetMoveAnim(ANIM_WALK);
		SetIdleAnim(ANIM_IDLE);
		SayText("Yes, warchief! They shall die like dogs!");
		Say("[.16]", "[.32]", "[.32]", "[.16]");
		PlayAnim("critical", "nod_yes");
		CallEventDelayed(Random(1, 2), "combat_mode_go"); // delay randomized to desync the various orcs in the area
	}

	// combat_mode_go
	void OnCombatModeGo()
	{
		KNEEL_MODE = false;
		OnNpcatkResumeAi();
		SetRoam(true);
		SetModelBody(2, 1);
		PlaySound(0, 10, SOUND_DRAW_WEAPON);
		SetInvincible(false);
		if (CYCLES_ON)
			return;
		CYCLES_ON = true;
		CallEventDelayed(FREQ_SPECIAL, "do_special");
	}

	// do_special
	void OnDoSpecial()
	{
		int rndSpecial = RandomInt(1, N_SPECIALS);

		if (rndSpecial == 1)
		{
			OnLstrikesGo();
			SPECIAL_DURATION = 5.0f;
		}

		if (rndSpecial == 2)
		{
			OnRepulseGo();
			SPECIAL_DURATION = 5.0f;
		}

		float specialDelay = FREQ_SPECIAL + SPECIAL_DURATION;
		CallEventDelayed(specialDelay, "do_special");
	}

	// lstrikes_go
	void OnLstrikesGo()
	{
		PlayAnim("critical", "warcry");
		OnNpcatkSuspendAi();
		CallEventDelayed(3.0f, "npcatk_resume_ai");
		ZAP_TARGETS = FindInSphere("enemy", 1024);
		if (ZAP_TARGETS == "none")
			return;
		ZAP_INDEXES = "";
		int nZapTargets = GetTokenCount(ZAP_TARGETS);
		for (int i = 0; i < nZapTargets; i++)
		{
			loopIteration = i;
			OnLstrikesAffectTargets();
		}
		ClientEvent("new", "all", "effects/sfx_multi_lightning", ZAP_INDEXES);
	}

	// lstrikes_affect_targets
	void OnLstrikesAffectTargets()
	{
		CBaseEntity@ curTarg = FindEntity(GetToken(ZAP_TARGETS, loopIteration));
		ZAP_INDEXES = TokenAdd(ZAP_INDEXES, Text(IndexOf(curTarg)));
		DoDamage(curTarg, "direct", DMG_ZAP, "100%", ENT_ME, "lightning");
		ApplyEffect(curTarg, "effects/dot_lightning", 5.0f, self, DOT_ZAP);
	}

	// repulse_go
	void OnRepulseGo()
	{
		PlayAnim("critical", "warcry");
		OnNpcatkSuspendAi();
		CallEventDelayed(3.0f, "npcatk_resume_ai");
		ClientEvent("new", "all", "effects/sfx_shock_burst", OriginOf(ENT_ME), 256, 1, Vector3(255, 255, 0));
		REPULSE_TARGETS = FindInSphere("enemy", 512);
		if (REPULSE_TARGETS == "none")
			return;
		int count = GetTokenCount(REPULSE_TARGETS);
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnRepulseAffectTargets();
		}
	}

	// repulse_affect_targets
	void OnRepulseAffectTargets()
	{
		CBaseEntity@ curTarg = FindEntity(GetToken(REPULSE_TARGETS, loopIteration));
		ApplyEffect(curTarg, "effects/dot_lightning", 5.0f, self, DOT_ZAP);
		Vector3 targOrg = OriginOf(curTarg);
		float targAng = AnglesTo(MyOrigin(), targOrg);
		SetVelocity(curTarg, RelativeVelocity(Vector3(0, targAng, 0), Vector3(10, 2000, 110)));
	}

	// frame_swing
	// add event
	void OnFrameSwing()
	{
		PlaySound(0, 10, SOUND_SWING);
		Vector3 axePos = AttachmentPositionOf(ENT_ME, ATTACH_IDX_AXE);
		DoDamageEx(axePos, 200, DMG_SWING, 0, ENT_ME, ENT_ME, "none", "slash");
		if (!(GameTime() > NEXT_KICK))
			return;
		ANIM_ATTACK = ANIM_KICK;
	}

	// frame_kick_start
	// add event
	void OnFrameKickStart()
	{
		OnBaseorcYell();
	}

	// frame_kick_land
	// add event
	void OnFrameKickLand()
	{
		PlaySound(0, 10, "SOUND_KICK");
		KICK_ATTACK = true;
		DoDamage(NPCATK_TARGET, ATTACK_HITRANGE, "DMG_KICK", "100%", "blunt");
		ANIM_ATTACK = ANIM_SWING;
		NEXT_KICK = GameTime() + FREQ_KICK;
	}

	// thuld_confirm
	void OnThuldConfirm()
	{
		if (DOUBLE_REDUNDANT)
			return;
		DOUBLE_REDUNDANT = true; // weird ass shit going on here, suspect menu related, like captain ron
		SayText("Yes, warchief.");
		Say("[.16]", "[.32]", "[.32]", "[.16]");
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files

	// npcatk_targetvalidate
	void OnNpcatkTargetvalidate(string target = "")
	{
		OrcBaseMelee_OnNpcatkTargetvalidate(target); // monsters/orc_base_melee
		BaseNpcAttackNew_OnNpcatkTargetvalidate(target); // monsters/base_npc_attack_new
		SorcBase_OnNpcatkTargetvalidate(target); // monsters/sorc_base
	}

	// my_target_died
	void OnMyTargetDied(string offender = "")
	{
		OrcBaseMelee_OnMyTargetDied(offender); // monsters/orc_base_melee
		BaseNpcAttackNew_OnMyTargetDied(offender); // monsters/base_npc_attack_new
	}

	void OnBaseorcYell() { SorcBase_OnBaseorcYell(); } // baseorc_yell
	void OnFreqSpecial() {} // FREQ_SPECIAL
	void OnSpecialDelay() {} // SPECIAL_DELAY

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/thuldahr.mdl");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		SorcPalaceThuldahr_FirstThink();
		SorcPalaceThuldahr_FirstThink2();
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
		if (name == "combat_mode_go") { OnCombatModeGo(); return true; }
		if (name == "do_special") { OnDoSpecial(); return true; }
		if (name == "ext_chief_orders_attack") { OnExtChiefOrdersAttack(); return true; }
		if (name == "frame_kick_land") { OnFrameKickLand(); return true; }
		if (name == "frame_kick_start") { OnFrameKickStart(); return true; }
		if (name == "frame_swing") { OnFrameSwing(); return true; }
		if (name == "game_damaged") { Return(OnGameDamaged(EntityParam(params, 0), Float(Param(params, 1)), Param(params, 2), Float(Param(params, 3)), EntityParam(params, 4), Param(params, 5))); return true; }
		if (name == "game_death") { OnGameDeath(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_dodamage") { Return(OnGameDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5))); return true; }
		if (name == "lstrikes_affect_targets") { OnLstrikesAffectTargets(); return true; }
		if (name == "lstrikes_go") { OnLstrikesGo(); return true; }
		if (name == "npc_post_spawn") { OnNpcPostSpawn(); return true; }
		if (name == "orc_spawn") { OnOrcSpawn(); return true; }
		if (name == "repulse_affect_targets") { OnRepulseAffectTargets(); return true; }
		if (name == "repulse_go") { OnRepulseGo(); return true; }
		if (name == "sorcs_confirm_order") { OnSorcsConfirmOrder(); return true; }
		if (name == "thuld_confirm") { OnThuldConfirm(); return true; }
		return OrcBaseMelee_DispatchEvent(name, params)
			|| SorcBaseScript::DispatchEvent(name, params);
	}
}
