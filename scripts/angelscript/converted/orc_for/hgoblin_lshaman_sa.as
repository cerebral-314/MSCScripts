#pragma context server

// Converted from orc_for/hgoblin_lshaman_sa.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/orc_for/goblin_base.as"

[script "orc_for/hgoblin_lshaman_sa"]
class HgoblinLshamanSa : GoblinBaseScript
{
	// Constants
	string ANIM_AIM = "zap_aim";
	string ANIM_CAGE_SUSTAIN = "zap_cycle";
	float FREQ_CAGE = 30.0f;
	int DOT_CAGE = 60;
	float FREQ_REPEL = 0.0f;
	int AOE_ZAP = 128;
	float DUR_ZAP = 10.0f;
	float DMG_ZAP = 40.0f;
	string ATTACH_HAND = "0";
	string CL_SCRIPT = "monsters/djinn_lightning_lesser_cl";
	float FREQ_FX_REFRESH = 15.0f;
	string SOUND_BEAM_START = "magic/bolt_start.wav";
	string SOUND_BEAM_LOOP = "magic/bolt_loop.wav";
	string SOUND_CAGE_PREP = "magic/lightning_powerup.wav";
	string SOUND_GIGGLE = "monsters/goblin/c_goblinwiz_bat1.wav";

	// Variables (an unset .script variable reads as its own name)
	string ATTACK_HITCHANCE = "ATTACK_HITCHANCE";
	bool DID_INIT = false;
	float NEXT_REPEL = 0.0f;
	float NEXT_CAGE = 0.0f;
	string CL_SCRIPT_IDX = "CL_SCRIPT_IDX";
	float NEXT_CL_REFRESH = 0.0f;
	bool DOING_REPEL = false;
	string CAGE_TARGET = "CAGE_TARGET";
	bool AIMING_CAGE = false;
	bool DID_WARN = false;
	bool SUSTAINING_CAGE = false;
	float NEXT_UPDATE_LOOP_SOUND = 0.0f;
	string CUR_BEAM = "CUR_BEAM";
	string CL_IDX_ZAP_AURA = "CL_IDX_ZAP_AURA";
	string ZAP_TARGS = "ZAP_TARGS";
	bool SWIPE_ATTACK = false;

	// Variables declared by included files, with the value they start with in this script
	HgoblinLshamanSa()
	{
		NPC_SELF_ADJUST = true;
		NPC_ADJ_TIERS = "0;750;1500;2000;3000;5000";
		NPC_ADJ_DMG_MUTLI_TOKENS = "1.0;1.5;2.0;5.0;7.5;10.0;";
		NPC_ADJ_HP_MUTLI_TOKENS = "1.0;2.0;3.0;5.0;7.5;10.0;";
		NPC_BASE_EXP = "300";
		DMG_CLUB = 20;
		DMG_AXE = 30.0f;
		DMG_SWORD = 15.0f;
		GOB_JUMPER = false;
		GOB_CHARGER = false;
	}

	// unnamed block (first think)
	void HgoblinLshamanSa_FirstThink()
	{
		ANIM_ATTACK = "swordswing1_L";
	}

	// unnamed block (first think)
	void HgoblinLshamanSa_FirstThink2()
	{
		NPC_SELF_ADJUST = true;

		ATTACK_HITCHANCE = "90%";
	}

	// game_dodamage
	string HgoblinLshamanSa_OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";
		if (SWIPE_ATTACK && hit)
		{
			DebugPrint("game_dodamage " + Text(DMG_ZAP));
			ApplyEffect(target, "effects/dot_lightning", 5.0f, self, DMG_ZAP);
		}
		SWIPE_ATTACK = false;
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
		if (CL_SCRIPT_IDX != "CL_SCRIPT_IDX")
			ClientEvent("update", "all", CL_SCRIPT_IDX, "remove_fx");

		if (SUSTAINING_CAGE)
		{
			if (HasEffect(CAGE_TARGET, "dot_lightning_cage"))
				LegacyCommand("removeeffect", CAGE_TARGET, "dot_lightning_cage");
			Effect("beam", "update", CUR_BEAM, "remove", 0.1f);
			ServerPlaySound(2, 0, SOUND_BEAM_LOOP);

			CBaseEntity@ theRescuer = EntityOf(ENT_LASTSTRUCK);
			DebugPrint("rescuer_name " + NameOf(theRescuer));
			if (EntityId(theRescuer) != CAGE_TARGET && IsPlayer(CAGE_TARGET) && IsPlayer(theRescuer))
			{
				DebugPrint("sending_bonus");
				string bonusMsg = "for freeing " + NameOf(CAGE_TARGET);
				CallExternal(theRescuer, "ext_dmgpoint_bonus", 1000, bonusMsg);
			}
		}
		if (DOING_REPEL)
		{
			ClientEvent("update", "all", CL_IDX_ZAP_AURA, "end_fx");
			ServerPlaySound(2, 0, SOUND_BEAM_LOOP);
		}
	}

	// npcatk_hunt
	void OnNpcatkHunt()
	{
		BaseNpcAttackNew_OnNpcatkHunt(); // monsters/base_npc_attack_new
		BaseAntiStuck_OnNpcatkHunt(); // monsters/base_anti_stuck
		GoblinBase_OnNpcatkHunt(); // orc_for/goblin_base

		if (!SUSPEND_AI)
			return;
		if (!IsAlive(ENT_ME))
			return;
		if (GameTime() > NEXT_CL_REFRESH)
		{
			if (CL_SCRIPT_IDX != "CL_SCRIPT_IDX")
				ClientEvent("update", "all", CL_SCRIPT_IDX, "remove_fx");
			ClientEvent("new", "all", CL_SCRIPT, IndexOf(ENT_ME), FREQ_FX_REFRESH);
			CL_SCRIPT_IDX = LastClientScriptId();
			NEXT_CL_REFRESH = GameTime() + FREQ_FX_REFRESH;
		}
	}

	// game_dodamage
	string OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";
		result = AppendResult(result, BaseNpcAttackNew_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BaseAntiStuck_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BaseMonsterShared_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, HgoblinLshamanSa_OnGameDodamage(hit, target, start, end, damageType, damageText));
		return result;
	}

	// npc_targetsighted
	void OnNpcTargetsighted(string target = "")
	{
		BaseMonsterShared_OnNpcTargetsighted(target); // monsters/base_monster_shared
		bool willDoRepel = false;
		bool exitSub = false;

		if (!DID_INIT)
		{
			DID_INIT = true;
			NEXT_REPEL = GameTime() + FREQ_REPEL;

			NEXT_CAGE = GameTime() + 10.0f;
		}

		if (GameTime() > NEXT_CL_REFRESH)
		{
			if (CL_SCRIPT_IDX != "CL_SCRIPT_IDX")
				ClientEvent("update", "all", CL_SCRIPT_IDX, "remove_fx");
			ClientEvent("new", "all", CL_SCRIPT, IndexOf(ENT_ME), FREQ_FX_REFRESH);
			CL_SCRIPT_IDX = LastClientScriptId();
			NEXT_CL_REFRESH = GameTime() + FREQ_FX_REFRESH;
		}

		if (AIMING_CAGE)
			return;
		if (SUSTAINING_CAGE)
			return;

		if (DOING_REPEL)
			return;

		if (GameTime() > NEXT_REPEL)
		{
			if (IsAlive(ENT_LASTSTRUCK) && RangeTo(ENT_LASTSTRUCK) < 128.0f)
				willDoRepel = true;
			if (RangeTo(NPCATK_TARGET) < 128.0f)
				willDoRepel = true;
			if (willDoRepel)
			{
				NEXT_REPEL = GameTime() + FREQ_REPEL;
				DOING_REPEL = true;
				OnDoRepel();
				exitSub = true;
			}
		}
		if (exitSub)
			return;

		if (!(GameTime() > NEXT_CAGE))
			return;
		NEXT_CAGE = GameTime() + FREQ_CAGE;

		CAGE_TARGET = NPCATK_TARGET;
		AIMING_CAGE = true;
		OnNpcatkSuspendAi();
		OnNpcatkSuspendMovement(ANIM_AIM);
		OnTrackingLoop();
		CallEventDelayed(3.0f, "do_cage");
		PlaySound(2, 10, SOUND_CAGE_PREP);
		PlaySound(1, 10, SOUND_GIGGLE);
		ClientEvent("update", "all", CL_SCRIPT_IDX, "hand_powerup", 0);

		if (!DID_WARN)
		{
			DID_WARN = true;
			InfoMessage(CAGE_TARGET, "Goblin Lightning Shaman", "Beware, if the shaman traps you in a force cage, you'll have to be rescued!");
		}
	}

	// goblin_spawn
	void OnGoblinSpawn()
	{
		GoblinBase_OnGoblinSpawn(); // orc_for/goblin_base
		SetName("Hobgoblin Lightning Shaman");
		SetModel("monsters/goblin_new.mdl");
		SetHealth(400);
		SetWidth(24);
		SetHeight(50);
		SetRace("goblin");
		SetBlood("green");
		SetRoam(true);
		SetHearingSensitivity(2);
		SetModelBody(0, 0); // body: 0-Bare 1-Quiver&Strap
		SetModelBody(1, 0); // head: 0-Bare 1-Horns 2-Animal 3-Chief 4-Rag
		SetModelBody(2, 0); // weapon: 0-Unarmed 1-Axe 2-wbow 3-sbow 4-sword 5-rAxe 6-sword&shield 7-club 8-knife
		SetModelBody(3, 0); // arrow: On/off

		SetProp(ENT_ME, "skin", 4);

		SetDamageTaken("lightning", 0);
		SetDamageTaken("acid", 2);
		SetDamageTaken("poison", 1.25f);

		SetIdleAnim(ANIM_IDLE);
		SetMoveAnim(ANIM_WALK);
	}

	// swing_sword
	void OnSwingSword()
	{
		GoblinBase_OnSwingSword(); // orc_for/goblin_base
		Vector3 attackStart = AttachmentPositionOf(ENT_ME, ATTACH_HAND);
		Vector3 targOrg = OriginOf(NPCATK_TARGET);
		Vector3 angToTarg = Angles3DTo(attackStart, targOrg);
		angToTarg.x = -angToTarg.x;
		ClientEvent("update", "all", CL_SCRIPT_IDX, "hand_sprite", angToTarg, ATTACH_HAND);

		float targRange = RangeTo(NPCATK_TARGET);
		if (!(targRange < ATTACK_HITRANGE))
			return;
		targRange = Divide(targRange, ATTACK_HITRANGE);
		float delayDmg = Ratio(targRange, 0.1f, 1);
		CallEventDelayed(delayDmg, "swing_sword_delay_dmg");
	}

	// goblin_pre_spawn
	void OnGoblinPreSpawn()
	{
		ATTACK_RANGE = 128.0f;
		ATTACK_HITRANGE = 256.0f;
		ATTACK_MOVERANGE = 96.0f;
		MOVE_RANGE = "96";
	}

	// tracking_loop
	void OnTrackingLoop()
	{
		if (!AIMING_CAGE)
			return;
		SetMoveDest(CAGE_TARGET, 9999);
		CallEventDelayed(0.1f, "tracking_loop");
	}

	// do_cage
	void OnDoCage()
	{
		bool exitSub = false;
		if (Truthy(ScriptVarOf(CAGE_TARGET, "PLAYING_DEAD")))
		{
			// target invalidated
			AIMING_CAGE = false;
			NEXT_CAGE = GameTime() + 10.0f;
			OnNpcatkResumeAi();
			OnNpcatkResumeMovement();
			exitSub = true;
		}
		if (exitSub)
			return;

		if (CanSee(CAGE_TARGET))
		{
			AIMING_CAGE = false;
			SUSTAINING_CAGE = true;
			OnDoCage2();
		}
		else
		{
			AIMING_CAGE = false;
			NEXT_CAGE = GameTime() + 10.0f;
			OnNpcatkResumeAi();
			OnNpcatkResumeMovement();
		}
	}

	// do_cage2
	void OnDoCage2()
	{
		ServerPlaySound(2, 10, SOUND_BEAM_LOOP);
		NEXT_UPDATE_LOOP_SOUND = GameTime() + 10.0f;
		ApplyEffect(CAGE_TARGET, "effects/dot_lightning_cage", 0, self, DOT_CAGE);
		InfoMessage("all", NameOf(CAGE_TARGET), "Has been trapped by a Lightning Shaman!");

		Effect("beam", "ents", "lgtning.spr", 30, ENT_ME, 1, CAGE_TARGET, 0, Vector3(255, 255, 0), 200, 20, -1);
		CUR_BEAM = EntityId(EntityOf(ENT_LASTCREATED));
		OnNpcatkResumeMovement();
		OnNpcatkSuspendMovement(ANIM_CAGE_SUSTAIN);
		PlayAnim("critical", ANIM_CAGE_SUSTAIN);
		OnSustainCage();
	}

	// sustain_cage
	void OnSustainCage()
	{
		if (!HasEffect(CAGE_TARGET, "dot_lightning_cage"))
		{
			OnExtEndCage();
			return;
		}

		PlayAnim("once", ANIM_CAGE_SUSTAIN);
		CallEventDelayed(1.0f, "sustain_cage");
		if (!(GameTime() > NEXT_UPDATE_LOOP_SOUND))
			return;
		NEXT_UPDATE_LOOP_SOUND = GameTime() + 10.0f;
		ServerPlaySound(2, 10, SOUND_BEAM_LOOP);
	}

	// ext_end_cage
	void OnExtEndCage()
	{
		ServerPlaySound(2, 0, SOUND_BEAM_LOOP);
		SUSTAINING_CAGE = false;
		Effect("beam", "update", CUR_BEAM, "remove", 0.1f);
		OnNpcatkResumeMovement();
		OnNpcatkResumeAi();
		NEXT_CAGE = GameTime() + FREQ_CAGE;
		OnLeapForward();
	}

	// do_repel
	void OnDoRepel(CBaseEntity@ target = null)
	{
		ServerPlaySound(2, 10, SOUND_BEAM_LOOP);
		PlaySound(1, 10, SOUND_BEAM_START);
		OnNpcatkSuspendAi();
		OnNpcatkSuspendMovement(ANIM_WARCRY);
		Vector3 zapAuraOrg = OriginOf(ENT_ME);
		zapAuraOrg.z += 32.0f;
		ClientEvent("new", "all", "effects/sfx_zap_aura", IndexOf(ENT_ME), AOE_ZAP, DUR_ZAP);
		CL_IDX_ZAP_AURA = LastClientScriptId();
		OnDoRepelLoop();
		CallEventDelayed(DUR_ZAP, "end_repel");
	}

	// do_repel_loop
	void OnDoRepelLoop()
	{
		if (!DOING_REPEL)
			return;
		PlayAnim("once", ANIM_WARCRY);
		CallEventDelayed(0.25f, "do_repel_loop");
		ZAP_TARGS = FindInSphere("enemy", AOE_ZAP);
		if (ZAP_TARGS == "none")
			return;
		int count = GetTokenCount(ZAP_TARGS);
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnRepelAffectTargets();
		}
	}

	// repel_affect_targets
	void OnRepelAffectTargets()
	{
		CBaseEntity@ curTarg = FindEntity(GetToken(ZAP_TARGS, loopIteration));
		DoDamage(curTarg, "direct", DMG_ZAP, "100%", ENT_ME, "lightning_effect");
		Vector3 targetOrg = OriginOf(curTarg);
		float targAng = AnglesTo(MyOrigin(), targetOrg);
		int newYaw = int(targAng);
		AddVelocity(curTarg, RelativeVelocity(Vector3(0, newYaw, 0), Vector3(0, 800, 110)));
	}

	// end_repel
	void OnEndRepel()
	{
		ServerPlaySound(2, 0, SOUND_BEAM_LOOP);
		OnNpcatkResumeAi();
		OnNpcatkResumeMovement();
		DOING_REPEL = false;
		OnLeapForward();

		NEXT_REPEL = GameTime() + FREQ_REPEL;

		// don't go straight from repel to cage, tis cruel
		if (!(GameTime() > NEXT_CAGE))
			return;
		NEXT_CAGE = GameTime() + 5.0f;
	}

	// swing_sword_delay_dmg
	void OnSwingSwordDelayDmg()
	{
		SWIPE_ATTACK = true;
		DoDamage(NPCATK_TARGET, ATTACK_HITRANGE, DMG_ZAP, ATTACK_HITCHANCE, "lightning_effect");
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files
	void OnDelayDmg() {} // DELAY_DMG
	void OnDurZap() {} // DUR_ZAP

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/goblin_new.mdl");
		Precache("magic/bolt_loop.wav");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		HgoblinLshamanSa_FirstThink();
		HgoblinLshamanSa_FirstThink2();
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
		if (name == "do_cage") { OnDoCage(); return true; }
		if (name == "do_cage2") { OnDoCage2(); return true; }
		if (name == "do_repel") { OnDoRepel(EntityParam(params, 0)); return true; }
		if (name == "do_repel_loop") { OnDoRepelLoop(); return true; }
		if (name == "end_repel") { OnEndRepel(); return true; }
		if (name == "ext_end_cage") { OnExtEndCage(); return true; }
		if (name == "game_death") { OnGameDeath(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_dodamage") { Return(OnGameDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5))); return true; }
		if (name == "goblin_pre_spawn") { OnGoblinPreSpawn(); return true; }
		if (name == "goblin_spawn") { OnGoblinSpawn(); return true; }
		if (name == "npc_targetsighted") { OnNpcTargetsighted(Param(params, 0)); return true; }
		if (name == "npcatk_hunt") { OnNpcatkHunt(); return true; }
		if (name == "repel_affect_targets") { OnRepelAffectTargets(); return true; }
		if (name == "sustain_cage") { OnSustainCage(); return true; }
		if (name == "swing_sword") { OnSwingSword(); return true; }
		if (name == "swing_sword_delay_dmg") { OnSwingSwordDelayDmg(); return true; }
		if (name == "tracking_loop") { OnTrackingLoop(); return true; }
		return GoblinBaseScript::DispatchEvent(name, params);
	}
}
