#pragma context server

// Converted from monsters/morc_chief.script by msc_transpiler.
// Marogar (Polar) Chief, from Orc Warrior, by Thothie

#include "runtime/ScriptEntity.as"
#include "converted/monsters/orc_base_melee.as"
#include "converted/monsters/orc_base.as"

[script "monsters/morc_chief"]
class MorcChief : OrcBaseScript, OrcBaseMelee
{
	// Constants
	bool GOLD_BAGS = true;
	int GOLD_BAGS_PPLAYER = 5;
	int GOLD_PER_BAG = 50;
	int GOLD_RADIUS = 64;
	int GOLD_MAX_BAGS = 32;
	int SPEC_ATK_FREQ = 3;
	float BLIZARD_FREQ = 50.0f;
	string ATTACK_ACCURACY = "85%";
	float ATTACK_DMG_LOW = 400.0f;
	float ATTACK_DMG_HIGH = 800.0f;
	int ATTACK_SPECRANGE = 160;
	string SOUND_SWAT = "monsters/orc/battlecry.wav";
	string SOUND_KICK = "monsters/orc/attack3.wav";
	string SOUND_WARCRY = "monsters/troll/trollidle.wav";
	string SOUND_UPSWING = "monsters/orc/attack1.wav";
	string SOUND_SWINGHIT = "monsters/orc/pain.wav";
	string SOUND_SWINGMISS = "debris/bustmetal2.wav";
	string SOUND_SWIPEMISS = "zombie/claw_miss2.wav";
	string SOUND_BOOM = "monsters/bear/giantbearstep2.wav";

	// Variables (an unset .script variable reads as its own name)
	string ANIM_AXE = "ANIM_AXE";
	string ANIM_SWAT = "ANIM_SWAT";
	string ANIM_KICK = "ANIM_KICK";
	float SPEC_ATK_CNT = 0.0f;
	float ICE_SELECT_ATK = 0.0f;
	float STUCK_CHECK_FREQUENCY = 0.0f;
	bool DOING_SPEC_ATK = false;
	bool ICECHIEF_AXING = false;
	bool ICECHIEF_GO = false;

	// unnamed block (first think)
	void MorcChief_FirstThink()
	{
		if (ToLowerCase(MapName()) == "ms_snow")
			NPC_IS_BOSS = true;

		NPC_GIVE_EXP = 500.0f; // no multiplier because of parry

		ATTACK_RANGE = 104.0f;
		ATTACK_HITRANGE = 138.0f;
		MOVE_RANGE = "84";

		ANIM_ATTACK = "battleaxe_swing1_L";
		ANIM_AXE = "battleaxe_swing1_L";
		ANIM_SWAT = "swordswing1_L";
		ANIM_KICK = "kick";
		SPEC_ATK_CNT = 1.0f;
		ICE_SELECT_ATK = 0.0f;

		STUCK_CHECK_FREQUENCY = 4.1f; // I take a LONG time to swing, dun want anti-stuck to think I'm stuck
		MONSTER_WIDTH = 48;

		PrecacheFile("monsters/summon/summon_blizzard");
	}

	// orc_spawn
	void OnOrcSpawn()
	{
		OrcBaseMelee_OnOrcSpawn(); // monsters/orc_base_melee

		SetHealth(5000);
		// ov 359
		SetName("Talnorgah, Chief of Clan Marogar");
		if (ToLowerCase(MapName()) != "ms_snow")
			SetName("Marogar Giant");
		SetHearingSensitivity(10);
		SetStat("spellcasting", 30, 30, 30);
		SetDamageTaken("all", 0.8f);
		SetDamageTaken("fire", 2);
		SetDamageTaken("cold", 0);
		SetStat("parry", 90);
		SetWidth(48);
		SetHeight(96);
		SetRoam(false);
		SetModel("monsters/morc_big.mdl"); // overscale, make swing slow

		SetModelBody(0, 2); // Body 0=topless+skirt 1=topless+pants 2=brestplate 3=whitefurhide
		SetModelBody(1, 3); // Head 0=cap_shorthorn 1=cap_spike 2=wbuffo_skin 3=cheif_ramhorns 4=wletherhood
		SetModelBody(2, 5); // Weapon 0=fist 1=axe 2=wood_bow 3=icebow 4=icesword 5=iceaxe
	}

	// swing_axe
	void OnSwingAxe()
	{
		OrcBaseMelee_OnSwingAxe(); // monsters/orc_base_melee

		SPEC_ATK_CNT += 1.0f;
		ICECHIEF_AXING = true;
		PlaySound(Int(GetVar("CHAN_BODY")), 10, SOUND_SWINGMISS);
	}

	// npcatk_targetvalidate
	void OnNpcatkTargetvalidate(string target = "")
	{
		OrcBaseMelee_OnNpcatkTargetvalidate(target); // monsters/orc_base_melee
		BaseNpcAttackNew_OnNpcatkTargetvalidate(target); // monsters/base_npc_attack_new
		OrcBase_OnNpcatkTargetvalidate(target); // monsters/orc_base

		if (ICECHIEF_GO)
			return;

		SetRoam(true);

		CallEventDelayed(BLIZARD_FREQ, "throw_blizzard");

		ICECHIEF_GO = true;
	}

	// npc_selectattack
	void OnNpcSelectattack()
	{
		BaseAntiStuck_OnNpcSelectattack(); // monsters/base_anti_stuck
		BaseMonsterShared_OnNpcSelectattack(); // monsters/base_monster_shared

		// only use kick/swat attack once / 5 secs
		if (SPEC_ATK_CNT < SPEC_ATK_FREQ)
			ANIM_ATTACK = ANIM_AXE;

		// //dbg SpecAtkCounter SPEC_ATK_CNT
		if (!(SPEC_ATK_CNT >= SPEC_ATK_FREQ))
			return;

		if (DOING_SPEC_ATK)
			return;

		ICE_SELECT_ATK += 1.0f;

		if (ICE_SELECT_ATK == 1.0f)
			ANIM_ATTACK = ANIM_KICK;
		if (ICE_SELECT_ATK == 2.0f)
		{
			ANIM_ATTACK = ANIM_SWAT;
			ICE_SELECT_ATK = 0.0f;
		}

		DOING_SPEC_ATK = true;
	}

	// npc_death
	void OnNpcDeath()
	{
		OrcBase_OnNpcDeath(); // monsters/orc_base

		Effect("screenshake", RelativePosition(Vector3(0, 0, 0)), 190, 20, 1, 0);
		PlaySound(Int(GetVar("CHAN_ITEM")), 10, SOUND_BOOM);
	}

	// swing_dodamage
	// 1: Attack Hit (1/0)  2: Entity Attack hit  3:  Start Position  4:  End Position
	void OnSwingDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		if (!hit)
		{
			if (ANIM_ATTACK == ANIM_SWAT)
				PlaySound(Int(GetVar("CHAN_ITEM")), 10, SOUND_SWIPEMISS);
			if (ANIM_ATTACK == ANIM_KICK)
				PlaySound(Int(GetVar("CHAN_ITEM")), 10, SOUND_SWIPEMISS);
			ICECHIEF_AXING = false;
		}

		if (!hit)
			return;

		if (ICECHIEF_AXING)
			PlaySound(Int(GetVar("CHAN_ITEM")), 10, SOUND_SWINGHIT);
		if (ANIM_ATTACK == ANIM_SWAT)
			PlaySound(Int(GetVar("CHAN_ITEM")), 10, SOUND_SWINGHIT);
		ICECHIEF_AXING = false;

		if (!(RangeTo(target) <= ATTACK_HITRANGE))
			return;

		if (RandomInt(1, 2) != 1)
			return;

		ApplyEffect(target, "effects/dot_cold", RandomInt(5, 10), ENT_ME, RandomInt(40, 80));
	}

	// throw_blizzard
	void OnThrowBlizzard()
	{
		CallEventDelayed(BLIZARD_FREQ, "throw_blizzard");

		if (!CanSee("enemy"))
			return;

		OnNpcatkFaceattacker(NPCATK_TARGET);

		PlayAnim("critical", "warcry");

		PlaySound(Int(GetVar("CHAN_VOICE")), 10, SOUND_WARCRY);

		CallEventDelayed(1.5f, "create_blizzard");
	}

	// power_kick
	void OnPowerKick()
	{
		SPEC_ATK_CNT = 1.0f;
		DOING_SPEC_ATK = false;

		if (!CanSee("enemy"))
			return;

		OnNpcatkFaceattacker(NPCATK_TARGET);

		PlaySound(Int(GetVar("CHAN_VOICE")), 10, SOUND_KICK);
		if (!(RangeTo(ENT_LASTSTRUCKBYME) < ATTACK_SPECRANGE))
			return;
		ApplyEffect(EntityOf(ENT_LASTSTRUCKBYME), "effects/effect_push", 3, RelativeVelocity(Vector3(0, 400, 400)), 0);
	}

	// swing_sword
	void OnSwingSword()
	{
		SPEC_ATK_CNT = 1.0f;
		DOING_SPEC_ATK = false;

		if (!CanSee("enemy"))
			return;

		OnNpcatkFaceattacker(NPCATK_TARGET);

		PlaySound(Int(GetVar("CHAN_VOICE")), 10, SOUND_SWAT);
		if (!(RangeTo(ENT_LASTSTRUCKBYME) < ATTACK_SPECRANGE))
			return;
		ApplyEffect(EntityOf(ENT_LASTSTRUCKBYME), "effects/debuff_stun", 10, self);
	}

	// swing_start
	void OnSwingStart()
	{
		PlaySound(Int(GetVar("CHAN_VOICE")), 10, SOUND_UPSWING);
	}

	// create_blizzard
	void OnCreateBlizzard()
	{
		CreateNpc("monsters/summon/summon_blizzard", OriginOf(ENT_LASTSEEN), self, AnglesOf(ENT_ME).y, 50, 20);
	}

	// baseorc_yell
	void OnBaseorcYell()
	{
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files

	// my_target_died
	void OnMyTargetDied(string offender = "")
	{
		OrcBaseMelee_OnMyTargetDied(offender); // monsters/orc_base_melee
		BaseNpcAttackNew_OnMyTargetDied(offender); // monsters/base_npc_attack_new
	}

	void OnBlizardFreq() {} // BLIZARD_FREQ

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/morc_big.mdl");
		Precache("monsters/orc.mdl");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		MorcChief_FirstThink();
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
		if (name == "baseorc_yell") { OnBaseorcYell(); return true; }
		if (name == "create_blizzard") { OnCreateBlizzard(); return true; }
		if (name == "npc_death") { OnNpcDeath(); return true; }
		if (name == "npc_selectattack") { OnNpcSelectattack(); return true; }
		if (name == "npcatk_targetvalidate") { OnNpcatkTargetvalidate(Param(params, 0)); return true; }
		if (name == "orc_spawn") { OnOrcSpawn(); return true; }
		if (name == "power_kick") { OnPowerKick(); return true; }
		if (name == "swing_axe") { OnSwingAxe(); return true; }
		if (name == "swing_dodamage") { OnSwingDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5)); return true; }
		if (name == "swing_start") { OnSwingStart(); return true; }
		if (name == "swing_sword") { OnSwingSword(); return true; }
		if (name == "throw_blizzard") { OnThrowBlizzard(); return true; }
		return OrcBaseMelee_DispatchEvent(name, params)
			|| OrcBaseScript::DispatchEvent(name, params);
	}
}
