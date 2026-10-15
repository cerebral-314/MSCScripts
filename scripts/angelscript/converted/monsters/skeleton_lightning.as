#pragma context server

// Converted from monsters/skeleton_lightning.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/skeleton_base.as"

[script "monsters/skeleton_lightning"]
class SkeletonLightning : SkeletonBaseScript
{
	// Constants
	string ANIM_CAST = "castspell";
	bool GOLD_BAGS = true;
	int GOLD_BAGS_PPLAYER = 1;
	int GOLD_PER_BAG = 50;
	int GOLD_RADIUS = 64;
	int GOLD_MAX_BAGS = 4;
	string SOUND_LAUGH = "monsters/skeleton/cal_laugh.wav";
	string SOUND_WARCRY = "monsters/skeleton/calrain3.wav";
	float ATTACK_DAMAGE_LOW = 15.5f;
	float ATTACK_DAMAGE_HIGH = 25.5f;
	float DMG_ZAP = 0.0f;
	float DOT_ZAP = 10.0f;
	float DUR_ZAP = 5.0f;
	float DMG_BARRIER = 10.0f;
	int BARRIER_RAD = 96;
	float ZAP_FREQ = 0.0f;
	int ZAP_RANGE = 1024;
	bool ATTACH_WAND = false;
	float FREQ_ZAP = 30.0f;
	string SOUND_BARRIER_REPELL = "doors/aliendoor3.wav";
	string SOUND_BARRIER_SPAWN = "magic/spawn.wav";

	// Variables (an unset .script variable reads as its own name)
	bool DID_WARCRY = false;
	string ZAP_LIST = "ZAP_LIST";
	string BARRIER_ID = "BARRIER_ID";
	bool ZAP_ACTIVE = false;

	// Variables declared by included files, with the value they start with in this script
	SkeletonLightning()
	{
		ANIM_RUN = "run";
		SKEL_HP = 1000;
		ATTACK_HITCHANCE = "85%";
	}

	// unnamed block (first think)
	void SkeletonLightning_FirstThink()
	{
		ANIM_RUN = "run";
	}

	// unnamed block (first think)
	void SkeletonLightning_FirstThink2()
	{
		NPC_GIVE_EXP = 400.0f;
	}

	// game_death
	void OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		DqMonsterExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // dq/externals/dq_monster_externals
		MonstersExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/externals
		BaseSelfAdjust_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_self_adjust
		BaseNpc_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseMonsterShared_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared
		if (!ZAP_ACTIVE)
			return;
		ClientEvent("update", "all", BARRIER_ID, "end_fx");
	}

	// npcatk_targetvalidate
	void OnNpcatkTargetvalidate(string target = "")
	{
		BaseNpcAttack_OnNpcatkTargetvalidate(target); // monsters/base_npc_attack

		if (!DID_WARCRY)
		{
			DID_WARCRY = true;
			PlaySound(0, 10, SOUND_LAUGH);
		}
	}

	// skeleton_spawn
	void OnSkeletonSpawn()
	{
		SetName("Lightning Forged Skeleton");
		SetRace("undead");
		SetRoam(true);
		SetDamageTaken("all", 0.7f);
		SetModel("monsters/skeleton_enraged.mdl");
		SetHearingSensitivity(8);
		SetModelBody(0, 6); // 0=standard 1=ash 2=green 3=bloody 4=decayed 5=ice 6=gold 7=stone 8=crystal 9=weirdgel
		SetModelBody(1, 8); // 0=Unarmed 1=darkmace 2=sword 3=hammahs 4=bigsword+shield 5=iceclubs 6=fireclubs 7=highsword 8=wand

		if (ToLowerCase(MapName()) == "thanatos")
			SET_GREEK = true;
		if (SET_GREEK)
			SetModelBody(0, 10);

		SetMoveAnim("sitstand");
		SetIdleAnim("sitstand");

		SetDamageTaken("lightning", 0);

		Vector3 mySky = MyOrigin() + Vector3(0, 0, 4096);
		Vector3 myCenter = OriginOf(ENT_ME) + Vector3(0, 0, -48);
		// fearing sticky client events
		// clientevent new all_in_sight effects/sfx_lightning MY_CENTER MY_SKY 1 1
		// <spritename> <width> <startpos> <endpos> <(r,g,b)> <brightness> <noise> <duration>
		PlaySound(0, 10, "weather/lightning.wav");
		Effect("beam", "point", "lgtning.spr", 120, myCenter, mySky, Vector3(128, 64, 255), 200, 3.0f, 1.0f);
		CallEventDelayed(ZAP_FREQ, "zap_check");
		CallEventDelayed(2.0f, "stand_complete");
	}

	// stand_complete
	void OnStandComplete()
	{
		SetIdleAnim("idle1");
		if (CYCLED_UP)
			return;
		SetMoveAnim(ANIM_WALK);
	}

	// zap_check
	void OnZapCheck()
	{
		if (!IsAlive(ENT_ME))
			return;
		if (NPCATK_TARGET == "unset")
			return;
		ZAP_LIST = FindInSphere("enemy", ZAP_RANGE);
		if (ZAP_LIST == "none")
			return;
		PlaySound(3, 10, SOUND_WARCRY);
		PlaySound(1, 10, SOUND_BARRIER_SPAWN);
		OnNpcatkSuspendAi();
		OnNpcatkSuspendMovement(ANIM_CAST);
		// clientevent new all effects/sfx_barrier $get(ent_me,index) BARRIER_RAD (255,0,0) DUR_ZAP 1 1
		ClientEvent("new", "all", "monsters/skeleton_lightning_cl", IndexOf(ENT_ME), BARRIER_RAD, Vector3(255, 0, 0), DUR_ZAP, 1, 1);
		BARRIER_ID = LastClientScriptId();

		ZAP_ACTIVE = true;
		CallEventDelayed(DUR_ZAP, "stop_zapping");
		CallEventDelayed(1.0f, "zap_scan_loop");
		CallEventDelayed(ZAP_FREQ, "zap_check");
	}

	// zap_scan_loop
	void OnZapScanLoop()
	{
		if (!ZAP_ACTIVE)
			return;
		if (!IsAlive(ENT_ME))
			return;
		CallEventDelayed(1.0f, "zap_scan_loop");
		Vector3 zapOrg = OriginOf(ENT_ME);
		zapOrg.z += 32.0f;
		ClientEvent("update", "all", BARRIER_ID, "clear_beams");
		DoDamageEx(zapOrg, ZAP_RANGE, DMG_ZAP, 0, ENT_ME, ENT_ME, "none", "lightning_effect", "dmgevent:zap");
	}

	// zap_dodamage
	void OnZapDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		if (!hit)
			return;
		if (RelationshipOf(target, ENT_ME) != "enemy")
			return;

		ApplyEffect(target, "effects/dot_lightning", 5.0f, self, DOT_ZAP);

		Vector3 targOrg = OriginOf(target);

		// local L_RND_SND $rand(1,3)
		// if ( L_RND_SND == 1 ) local L_SOUND SOUND_SHOCK1
		// if ( L_RND_SND == 2 ) local L_SOUND SOUND_SHOCK2
		// if ( L_RND_SND == 3 ) local L_SOUND SOUND_SHOCK3
		// svsound.play3d L_SOUND 10 TARG_ORG 0.8 0 $rand(80,120)
		ClientEvent("update", "all", BARRIER_ID, "add_beam", IndexOf(target));

		Vector3 myOrg = OriginOf(ENT_ME);
		float targAng = AnglesTo(myOrg, targOrg);

		if (RangeTo(target) > BARRIER_RAD)
		{
			AddVelocity(target, RelativeVelocity(Vector3(0, targAng, 0), Vector3(0, 500, 0)));
		}
		else
		{
			SetVelocity(target, RelativeVelocity(Vector3(0, targAng, 0), Vector3(10, 1000, 110)));
			PlaySound(1, 10, SOUND_BARRIER_REPELL);
		}
	}

	// stop_zapping
	void OnStopZapping()
	{
		ZAP_ACTIVE = false;
		ClientEvent("update", "all", BARRIER_ID, "end_fx");
		OnNpcatkResumeAi();
		OnNpcatkResumeMovement();
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files
	void OnDurZap() {} // DUR_ZAP
	void OnZapFreq() {} // ZAP_FREQ

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/skeleton.mdl");
		Precache("monsters/skeleton_enraged.mdl");
		CallEventDelayed(Float(CYCLE_TIME), "hunting_mode_go");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		SkeletonLightning_FirstThink();
		SkeletonLightning_FirstThink2();
		SkeletonBase_FirstThink();
		SkeletonBase_FirstThink2();
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
		if (name == "game_death") { OnGameDeath(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "npcatk_targetvalidate") { OnNpcatkTargetvalidate(Param(params, 0)); return true; }
		if (name == "skeleton_spawn") { OnSkeletonSpawn(); return true; }
		if (name == "stand_complete") { OnStandComplete(); return true; }
		if (name == "stop_zapping") { OnStopZapping(); return true; }
		if (name == "zap_check") { OnZapCheck(); return true; }
		if (name == "zap_dodamage") { OnZapDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5)); return true; }
		if (name == "zap_scan_loop") { OnZapScanLoop(); return true; }
		return SkeletonBaseScript::DispatchEvent(name, params);
	}
}
