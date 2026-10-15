#pragma context server

// Converted from desert_temple/thuldahr.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/orc_base_melee.as"
#include "converted/monsters/sorc_base.as"

[script "desert_temple/thuldahr"]
class DesertTempleThuldahr : SorcBaseScript, OrcBaseMelee
{
	// Constants
	string ANIM_SWING = "gglowswing";
	string ANIM_KICK = "kick";
	string SOUND_DRAW_WEAPON = "weapons/swords/sworddraw.wav";
	string SOUND_SWING = "weapons/swinghuge.wav";
	int ATTACH_IDX_AXE = 2;
	float FREQ_SPECIAL = 0.0f;
	int N_SPECIALS = 3;
	float FREQ_KICK = 0.0f;
	int DMG_SWING = 400;
	float DMG_ZAP = 300.0f;
	float DOT_ZAP = 100.0f;

	// Variables (an unset .script variable reads as its own name)
	bool NPC_BATTLE_ALLY = false;
	bool CYCLES_ON = false;
	float SPECIAL_DURATION = 0.0f;
	string ZAP_TARGETS = "ZAP_TARGETS";
	string ZAP_INDEXES = "ZAP_INDEXES";
	string REPULSE_TARGETS = "REPULSE_TARGETS";
	bool KICK_ATTACK = false;
	float NEXT_KICK = 0.0f;

	// Variables declared by included files, with the value they start with in this script
	DesertTempleThuldahr()
	{
		NPC_FIGHTS_NPCS = true;
		SORC_LRESIST = 0.0f;
		SORC_PRESIST = 1.25f;
	}

	// unnamed block (first think)
	void DesertTempleThuldahr_FirstThink()
	{
		NPC_NO_PLAYER_DMG = true; // don't take damage from players
		NPC_BATTLE_ALLY = true; // lets player view current health

		ANIM_KNEEL = "kneel"; // this has to be a vard as the base script uses it too
		ANIM_ATTACK = "gglowswing";

		SORC_NO_TELE = true;
	}

	// orc_spawn
	void DesertTempleThuldahr_OnOrcSpawn()
	{
		SetModel("monsters/thuldahr.mdl");
		SetWidth(64);
		SetHeight(128);
		SetModelBody(2, 1); // 0=unarmed 1=hugeaxe 2=greataxe 3=beef 4=smith 5=mug

		SetName("Thuldahr");
		SetHealth(15000);
		SetRace("human");
		SetDamageTaken("all", 0.5f);
		SetDamageTaken("lightning", 0);
		SetDamageTaken("poison", 1.2f);
		SetDamageTaken("acid", 1.5f);

		SetWidth(48);
		SetHeight(128);

		NO_STUCK_CHECKS = "1";
	}

	// game_precache
	void OnGamePrecache()
	{
	}

	// orc_spawn
	void OnOrcSpawn()
	{
		DesertTempleThuldahr_OnOrcSpawn();
		OrcBaseMelee_OnOrcSpawn(); // monsters/orc_base_melee
	}

	// npc_targetsighted
	void OnNpcTargetsighted(string target = "")
	{
		BaseMonsterShared_OnNpcTargetsighted(target); // monsters/base_monster_shared
		SorcBase_OnNpcTargetsighted(target); // monsters/sorc_base
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
		if (RelationshipOf(curTarg, ENT_ME) != "enemy")
			return;
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
		DesertTempleThuldahr_FirstThink();
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
		if (name == "do_special") { OnDoSpecial(); return true; }
		if (name == "frame_kick_land") { OnFrameKickLand(); return true; }
		if (name == "frame_kick_start") { OnFrameKickStart(); return true; }
		if (name == "frame_swing") { OnFrameSwing(); return true; }
		if (name == "game_precache") { OnGamePrecache(); return true; }
		if (name == "lstrikes_affect_targets") { OnLstrikesAffectTargets(); return true; }
		if (name == "lstrikes_go") { OnLstrikesGo(); return true; }
		if (name == "npc_targetsighted") { OnNpcTargetsighted(Param(params, 0)); return true; }
		if (name == "orc_spawn") { OnOrcSpawn(); return true; }
		if (name == "repulse_affect_targets") { OnRepulseAffectTargets(); return true; }
		if (name == "repulse_go") { OnRepulseGo(); return true; }
		return OrcBaseMelee_DispatchEvent(name, params)
			|| SorcBaseScript::DispatchEvent(name, params);
	}
}
