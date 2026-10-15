#pragma context server

// Converted from monsters/morc_shaman_ice.script by msc_transpiler.
// Orc Ice Shamman, from Orc Sniper by Thothie

#include "runtime/ScriptEntity.as"
#include "converted/monsters/orc_base_ranged.as"
#include "converted/monsters/orc_base.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class MorcShamanIce
{
	// Constants
	int ATTACK_SPEED = 300;
	int ATTACK_CONE_OF_FIRE = 2;
	int MELE_RANGE = 96;
	int MELE_HITRANGE = 128;
	string ATTACK_ACCURACY = "80";
	string ANIM_SWIPE = "swordswing1_L";
	string ANIM_FIRE = "swordswing1_L";
	string ANIM_WARCRY = "warcry";
	string ANIM_KICK = "kick";
	string SWIPE_DAMAGE = "$rand(25,65)";
	string SOUND_MELEMISS = "zombie/claw_miss1.wav";
	string SOUND_MELEHIT = "zombie/claw_strike3.wav";
	string SOUND_ICESHOOT = "magic/ice_strike.wav";
	string SOUND_DEATH_SHOOT = "magic/spawn.wav";
	string SOUND_WARCRY1 = "monsters/orc/attack1.wav";
	string SOUND_WARCRY2 = "monsters/orc/attack3.wav";
	string SOUND_MAKEBLIZZ = "magic/heal_powerup.wav";
	string FROST_BOLT_DAMAGE = "$rand(10,50)";
	string FROST_STRIKE_DAMAGE = "$rand(10,20)";
	float FROST_BOLT_FREQ = 1.0f;
	float BLIZZARD_DELAY = 20.0f;
	string DEATH_SCRIPT = "monsters/summon/ice_blast";

	// Variables (an unset .script variable reads as its own name)
	string ANIM_IDLE = "idle1";
	int DROP_GOLD = 0;
	float DROP_GOLD_AMT = 0.0f;
	float NPC_GIVE_EXP = 0.0f;
	string ANIM_ATTACK = "ANIM_ATTACK";
	string FLINCH_CHANCE = "FLINCH_CHANCE";
	string MOVE_RANGE = "MOVE_RANGE";
	float ATTACK_RANGE = 0.0f;
	bool FROST_BOLT_DELAY = false;
	bool DID_WARCRY = false;
	bool SWIPE_SOUNDS = false;
	bool MADE_BLIZZARD = false;
	bool IS_FLEEING = false;
	bool PURE_FLEE = false;

	// unnamed block (first think)
	void MorcShamanIce_FirstThink()
	{
		DROP_GOLD = 1; // Gold Drop
		DROP_GOLD_AMT = RandomInt(15, 30);
		NPC_GIVE_EXP = 100.0f;

		// setvard DROP_ITEM1 scroll2_frost_xolt //hanled through monsters/base_monster
		// setvard DROP_ITEM1_CHANCE 5%	  //hanled through by monsters/base_monster
		ANIM_ATTACK = "swordswing1_L"; // Attack animation
		FLINCH_CHANCE = "45%";

		MOVE_RANGE = "256";
		ATTACK_RANGE = 2000.0f;
		ANIM_IDLE = "idle1";

		// Ice Blast Precache (crap I shouldn't have to do)
		// const DEATH_SCRIPT monsters/summon/ice_blast
		// const XBLAST_MODEL weapons/magic/iceball.mdl
		// const SOUND_FREEZE magic/freeze.wav
		// const XSOUND_HOVERLOOP ambience/alienwind1.wav
		// const XSOUND_HITWALL ambience/alienlaser1.wav
		// const XLIGHTNING_SPRITE lgtning.spr
		// const SOUND_ICEBLAST magic/temple.wav
		// precache XBLAST_MODEL
		// precache XSOUND_FREEZE
		// precache XSOUND_HOVERLOOP
		// precache XSOUND_HITWALL
		// precache XLIGHTNING_SPRITE
		PrecacheFile("monsters/summon/summon_blizzard");
		PrecacheFile(DEATH_SCRIPT);
	}

	// orc_spawn
	void MorcShamanIce_OnOrcSpawn()
	{
		SetHealth(320);
		// ov 180
		SetName("Marogar Ice Shaman");
		SetRace("orc");
		SetHearingSensitivity(8);
		SetStat("parry", 30);
		SetDamageTaken("all", 0.8f);
		SetDamageTaken("fire", 1.5f);
		SetDamageTaken("cold", 0);
		SetStat("spellcasting", 30, 30, 30, 30, 30, 30, 30); // ><
		SetModel("monsters/morc.mdl");

		CallEventDelayed(BLIZZARD_DELAY, "make_blizzard");

		SetModelBody(0, 0); // Body 0=topless+skirt 1=topless+pants 2=brestplate 3=whitefurhide
		SetModelBody(1, 2); // Head 0=cap_shorthorn 1=cap_spike 2=wbuffo_skin 3=cheif_ramhorns 4=wletherhood
		SetModelBody(2, 0); // Weapon 0=fist 1=axe 2=wood_bow 3=icebow 4=icesword 5=iceaxe
	}

	// npc_selectattack
	void MorcShamanIce_OnNpcSelectattack()
	{
		float nmeRange = RangeTo(ENT_LASTSEEN);
		if (FROST_BOLT_DELAY && nmeRange > MELE_HITRANGE)
			ANIM_ATTACK = ANIM_FIRE;
		if (!FROST_BOLT_DELAY)
			ANIM_ATTACK = ANIM_FIRE;
		if (nmeRange < MELE_HITRANGE && RandomInt(1, 4) == 1)
			ANIM_ATTACK = ANIM_KICK;
	}

	// swing_sword
	// called by modeanim swordswing1_L at frame 14
	void MorcShamanIce_OnSwingSword()
	{
		bool exitSub = false;

		if (Truthy(LegacyFunction("cansee", "enemy", MELE_RANGE)))
		{
			// dbg Can See NME in range
			ANIM_ATTACK = ANIM_SWIPE;
			OnSwipeAttack(EntityOf(ENT_LASTSEEN));
			exitSub = true;
		}
		if (exitSub)
			return;

		if (CanSee("enemy"))
		{
			// prevents shamman from moving closer to target than needed
			if (!Truthy(LegacyFunction("cansee", "enemy", MOVE_RANGE)))
				ANIM_ATTACK = ANIM_RUN;
		}

		// if ( $cansee(enemy,MOVE_RANGE) ) setvard ANIM_ATTACK ANIM_WARCRY
		// if !FROST_BOLT_DELAY
		ANIM_ATTACK = ANIM_FIRE;
		OnThrowFrostbolt();
	}

	// throw_frostbolt
	void MorcShamanIce_OnThrowFrostbolt()
	{
		if (!CanSee("enemy"))
			return;

		CallEventDelayed(FROST_BOLT_FREQ, "reset_frostbolt");

		PlaySound(0, 10, SOUND_ICESHOOT);

		float finalDamage = Float(FROST_BOLT_DAMAGE);
		if (EXT_DAMAGE_ADJUSTMENT != "EXT_DAMAGE_ADJUSTMENT") // for future use
			finalDamage += Float(EXT_DAMAGE_ADJUSTMENT);

		// <projectile scriptname> <"view"|(src_origin)> <target|(targ_origin)|none> <speed> <damage> <cof> <skill|none> //Converted to use new tossprojectile //greatguys1@FEB2022
		TossProjectile("proj_ice_bolt", RelativePosition(Vector3(0, 48, 18)), "none", ATTACK_SPEED, finalDamage, ATTACK_CONE_OF_FIRE, "none");
		FROST_BOLT_DELAY = true;
	}

	// reset_frostbolt
	void MorcShamanIce_OnResetFrostbolt()
	{
		ANIM_ATTACK = ANIM_FIRE;
		DID_WARCRY = false;
		FROST_BOLT_DELAY = false;
	}

	// npc_death
	void MorcShamanIce_OnNpcDeath()
	{
		SetSolid("none");
		SetBoundingBox("none");
		Vector3 ballDest = RelativePosition(Vector3(0, 0, 2000));
		PlaySound(0, 10, SOUND_DEATH_SHOOT);
		CreateNpc(DEATH_SCRIPT, RelativePosition(Vector3(0, 0, 32)), self, 10.0f, ballDest);
	}

	// swipe_attack
	// PARAM1 = enemy struck
	void MorcShamanIce_OnSwipeAttack(CBaseEntity@ enemy = null)
	{
		SWIPE_SOUNDS = true;
		float finalDamage = Float(SWIPE_DAMAGE);
		if (EXT_DAMAGE_ADJUSTMENT != "EXT_DAMAGE_ADJUSTMENT") // for future use
			finalDamage += Float(EXT_DAMAGE_ADJUSTMENT);
		if (!(RangeTo(ENT_LASTSTRUCKBYME) <= MELE_HITRANGE))
			return;
		OnNpcatkDodamage(EntityId(enemy), Text(MELE_HITRANGE), Text(finalDamage), ATTACK_ACCURACY);
		ApplyEffect(enemy, "effects/dot_cold", RandomInt(5, 10), ENT_ME, FROST_STRIKE_DAMAGE);
	}

	// game_dodamage
	// 1: Attack Hit (1/0)  2: Entity Attack hit  3:  Start Position  4:  End Position
	string MorcShamanIce_OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";

		if (!SWIPE_SOUNDS)
			return result;

		if (!hit)
			PlaySound(0, 10, SOUND_MELEMISS);

		if (hit)
			PlaySound(0, 10, SOUND_MELEHIT);

		SWIPE_SOUNDS = false;
		return result;
	}

	// npc_struck
	void MorcShamanIce_OnNpcStruck(float damage = 0.0f)
	{
		if (!(RangeTo(ENT_LASTSTRUCK) < MELE_RANGE))
			return;
		// setvard ANIM_ATTACK ANIM_KICK
		OnNpcatkSettarget(EntityId(EntityOf(ENT_LASTSTRUCK)));
	}

	// make_blizzard
	void MorcShamanIce_OnMakeBlizzard()
	{
		if (MADE_BLIZZARD)
			return;

		if (!CanSee("enemy"))
			CallEventDelayed(BLIZZARD_DELAY, "make_blizzard");

		if (!CanSee("enemy"))
			return;
		OnNpcatkFaceattacker(NPCATK_TARGET);

		PlayAnim("critical", ANIM_WARCRY);
		PlaySound(0, 10, SOUND_WARCRY1);

		MADE_BLIZZARD = true;
		IS_FLEEING = true;
		PURE_FLEE = true;

		Effect("glow", ENT_ME, Vector3(128, 128, 255), 128, 3, 3);

		CallEventDelayed(1.5f, "really_make_blizzard");
	}

	// really_make_blizzard
	void MorcShamanIce_OnReallyMakeBlizzard()
	{
		string effectScript = "monsters/summon/summon_blizzard";
		int setDamage = 20;
		int setDuration = 10;

		PlaySound(0, 10, SOUND_MAKEBLIZZ);

		CreateNpc(effectScript, OriginOf(ENT_LASTSEEN), self, AnglesOf(ENT_ME).y, setDamage, setDuration);
	}

	// warcry_done
	// called from model anim warcry @ frame 29
	void MorcShamanIce_OnWarcryDone()
	{
		IS_FLEEING = false;
		PURE_FLEE = false;
	}

	// kick_land
	// called from model anim kick @ frame 9
	void MorcShamanIce_OnKickLand()
	{
		SWIPE_SOUNDS = true;
		ANIM_ATTACK = ANIM_SWIPE;
		float finalDamage = Float(SWIPE_DAMAGE);
		if (EXT_DAMAGE_ADJUSTMENT != "EXT_DAMAGE_ADJUSTMENT") // for future use
			finalDamage += Float(EXT_DAMAGE_ADJUSTMENT);
		OnNpcatkDodamage(ENT_LASTSTRUCKBYME, Text(MELE_HITRANGE), Text(finalDamage), ATTACK_ACCURACY);
		if (!(RangeTo(ENT_LASTSTRUCKBYME) <= MELE_HITRANGE))
			return;
		ApplyEffect(ENT_LASTSTRUCKBYME, "effects/effect_push", 3, RelativeVelocity(Vector3(0, 400, 50)), 0);
		PURE_FLEE = true;
		OnNpcatkFlee(ENT_LASTSEEN, "800", "5");
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)

	// orc_spawn
	void OnOrcSpawn()
	{
		OrcBaseRanged_OnOrcSpawn(); // monsters/orc_base_ranged
		MorcShamanIce_OnOrcSpawn();
	}

	// npc_targetsighted
	void OnNpcTargetsighted(string target = "")
	{
		OrcBaseRanged_OnNpcTargetsighted(target); // monsters/orc_base_ranged
		BaseMonsterShared_OnNpcTargetsighted(target); // monsters/base_monster_shared
	}

	// game_dodamage
	string OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";
		result = AppendResult(result, BaseNpcAttackNew_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BaseAntiStuck_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BaseMonsterShared_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, MorcShamanIce_OnGameDodamage(hit, target, start, end, damageType, damageText));
		return result;
	}

	// npc_selectattack
	void OnNpcSelectattack()
	{
		BaseAntiStuck_OnNpcSelectattack(); // monsters/base_anti_stuck
		BaseMonsterShared_OnNpcSelectattack(); // monsters/base_monster_shared
		MorcShamanIce_OnNpcSelectattack();
	}

	// npc_death
	void OnNpcDeath()
	{
		OrcBase_OnNpcDeath(); // monsters/orc_base
		MorcShamanIce_OnNpcDeath();
	}

	// npc_struck
	void OnNpcStruck(float damage = 0.0f)
	{
		OrcBase_OnNpcStruck(damage); // monsters/orc_base
		MorcShamanIce_OnNpcStruck(damage);
	}

	void OnSwingSword() { MorcShamanIce_OnSwingSword(); } // swing_sword
	void OnThrowFrostbolt() { MorcShamanIce_OnThrowFrostbolt(); } // throw_frostbolt
	void OnResetFrostbolt() { MorcShamanIce_OnResetFrostbolt(); } // reset_frostbolt
	void OnSwipeAttack(CBaseEntity@ enemy = null) { MorcShamanIce_OnSwipeAttack(enemy); } // swipe_attack
	void OnMakeBlizzard() { MorcShamanIce_OnMakeBlizzard(); } // make_blizzard
	void OnReallyMakeBlizzard() { MorcShamanIce_OnReallyMakeBlizzard(); } // really_make_blizzard
	void OnWarcryDone() { MorcShamanIce_OnWarcryDone(); } // warcry_done
	void OnKickLand() { MorcShamanIce_OnKickLand(); } // kick_land
	void OnBlizzardDelay() {} // BLIZZARD_DELAY
	void OnFrostBoltFreq() {} // FROST_BOLT_FREQ

	// This file's events and timers by their .script names
	bool MorcShamanIce_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "game_dodamage") { Return(OnGameDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5))); return true; }
		if (name == "kick_land") { OnKickLand(); return true; }
		if (name == "make_blizzard") { OnMakeBlizzard(); return true; }
		if (name == "npc_death") { OnNpcDeath(); return true; }
		if (name == "npc_selectattack") { OnNpcSelectattack(); return true; }
		if (name == "npc_struck") { OnNpcStruck(Float(Param(params, 0))); return true; }
		if (name == "orc_spawn") { OnOrcSpawn(); return true; }
		if (name == "really_make_blizzard") { OnReallyMakeBlizzard(); return true; }
		if (name == "reset_frostbolt") { OnResetFrostbolt(); return true; }
		if (name == "swing_sword") { OnSwingSword(); return true; }
		if (name == "swipe_attack") { OnSwipeAttack(EntityParam(params, 0)); return true; }
		if (name == "throw_frostbolt") { OnThrowFrostbolt(); return true; }
		if (name == "warcry_done") { OnWarcryDone(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "monsters/morc_shaman_ice"]
shared class MorcShamanIceScript : OrcBaseScript, MorcShamanIce, OrcBaseRanged
{
	// Variables declared by included files, with the value they start with in this script
	MorcShamanIceScript()
	{
		SOUND_WARCRY1 = "monsters/orc/attack1.wav";
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("snow1.spr");
		Precache("monsters/orc.mdl");
		Precache("monsters/morc.mdl");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		MorcShamanIce_FirstThink();
		OrcBaseRanged_FirstThink();
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
		return MorcShamanIce_DispatchEvent(name, params)
			|| OrcBaseRanged_DispatchEvent(name, params)
			|| OrcBaseScript::DispatchEvent(name, params);
	}
}
