#pragma context server

// Converted from lodagond/maldora.script by msc_transpiler.
// Maldora Himself

#include "runtime/ScriptEntity.as"
#include "converted/lodagond/maldora_fragment.as"

[script "lodagond/maldora"]
class LodagondMaldora : MaldoraFragmentScript
{
	// Variables declared by included files, with the value they start with in this script
	LodagondMaldora()
	{
		LIGHT_RAD = 256;
		WAND_DOT = 40;
		NPC_BOSS_REGEN_RATE = 0.02f;
		NPC_BOSS_RESTORATION = 0.25f;
		NUM_SPELLS = 8;
		AM_UBER = true;
		MINION_SCRIPT = "monsters/maldora_gminion_random";
		MINION_LIMIT = 4;
		FREQ_SOUND = 10.0f;
		NPC_PROX_ACTIVATE = true;
		NOT_FRAGMENT = true;
		FIN_EXP = 20000;
		NPC_PROXACT_RANGE = "640";
		NPC_PROXACT_IFSEEN = true;
		NPC_PROXACT_EVENT = "combat_go";
		DMG_SHOCK = 100.0f;
	}

	// unnamed block (first think)
	void LodagondMaldora_FirstThink()
	{
		if (StartsWith(ToLowerCase(MapName()), "lodagond"))
			NPC_IS_BOSS = true;

		BASE_MOVESPEED = 2.0f;

		IS_UNHOLY = true;

		DMG_BARRIER = 400.0f;
	}

	// game_precache
	void LodagondMaldora_OnGamePrecache()
	{
		PrecacheFile("monsters/sorc_chief2");
		PrecacheFile("ms_wicardoven/maldora_dead");
		PrecacheFile("lodagond/maldora_fragment");
		PrecacheFile("monsters/summon/rock_storm");
		PrecacheFile("monsters/maldora_gminion_random");
		PrecacheFile("ms_wicardoven/maldora_image");
	}

	// game_precache
	void OnGamePrecache()
	{
		LodagondMaldora_OnGamePrecache();
		MaldoraFragment_OnGamePrecache(); // lodagond/maldora_fragment
	}

	// game_death
	void OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		DqMonsterExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // dq/externals/dq_monster_externals
		MonstersExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/externals
		BaseSelfAdjust_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_self_adjust
		BaseNpc_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseMonsterShared_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared
		MaldoraFragment_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // lodagond/maldora_fragment

		CallExternal("players", "ext_clear_valid_gauntlets");
		ME_DEAD = true;
		CallExternal("all", "maldoraf_died");
		ServerPlaySound(2, 0, "ambience/alienvoices1.wav");
		SetProp(ENT_ME, "renderamt", 0);
		if (SORC_SPAWNED)
			WAND_TYPE = "-1";
		CreateNpc("ms_wicardoven/maldora_dead", RelativePosition(Vector3(0, 0, 0)), "crow_final", WAND_TYPE);
		SetSolid("none");
		SetOrigin(ENT_ME, Vector3(20000, 20000, 20000));
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
		MaldoraFragment_OnNpcPostSpawn(); // lodagond/maldora_fragment
		SetGlobal("G_MALDORA_PRESENT", 1);
		ClientEvent("persist", "all", "effects/sfx_motionblur_perm", IndexOf(ENT_ME), 0);
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseNpcAttackNew_OnNpcSpawn(npc); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck
		MaldoraFragment_OnNpcSpawn(npc); // lodagond/maldora_fragment

		SetName("Maldora");
		SetHealth(10000);
		SetRace("demon");
		SetWidth(32);
		SetHeight(86);

		ServerPlaySound(2, 0, "ambience/alienvoices1.wav");

		SetMoveSpeed(2);

		NPC_GIVE_EXP = FIN_EXP;

		SetRoam(false);

		WAND_TARGET = "unset";

		SetHearingSensitivity(11);

		SetInvincible(true);

		SetIdleAnim(ANIM_IDLE);
		SetMoveAnim(ANIM_IDLE); // remember to set back on resume
		PlayAnim("once", ANIM_IDLE);

		SetDamageTaken("all", 0.35f);

		SetDamageTaken("fire", 0);
		SetDamageTaken("poison", 0);
		SetDamageTaken("cold", 0);
		SetDamageTaken("magic", 0);
		SetDamageTaken("lightning", 0);
		SetDamageTaken("acid", 0);
		SetDamageTaken("dark", 0.65f);
		SetDamageTaken("holy", 1);
		SetDamageTaken("stun", 0);

		SetModel(MONSTER_MODEL);

		SetProp(ENT_ME, "rendermode", 2);
		SetProp(ENT_ME, "renderamt", 0);

		OnNpcatkSuspendAi();

		IMAGES_ALIVE = 0.0f;
		MINIONS_ALIVE = 0.0f;

		SetSayTextRange(2048);

		PlaySound(0, 10, "magic/spawn_loud.wav");
		CallEventDelayed(0.1f, "fade_me_in");

		SetProp(ENT_ME, "skin", AXESKIN_NULL);

		OnCombatGo();

		if (!Truthy(GetVar("G_SHAD_ORC")))
			return;
		CallEventDelayed(0.1f, "spawn_shad");
	}

	// remove_me
	void OnRemoveMe(string caller = "")
	{
		DeleteEntity(ENT_ME);
	}

	// fade_me_in
	void OnFadeMeIn()
	{
		CallExternal(GetVar("GAME_MASTER"), "gm_fade_in", self, 2);
	}

	// fade_in_done
	void OnFadeInDone()
	{
		SetProp(ENT_ME, "rendermode", 0);
		SetProp(ENT_ME, "renderamt", 255);
	}

	// reset_props
	void OnResetProps()
	{
		CallEventDelayed(FREQ_SOUND, "reset_props");
		if (ME_DEAD)
			return;
		ClientEvent("new", "all", "effects/sfx_follow_glow_cl", IndexOf(ENT_ME), LIGHT_COLOR, LIGHT_RAD, FREQ_SOUND);
		ServerPlaySound(2, 0, "ambience/alienvoices1.wav");
		CallEventDelayed(0.1f, "sound_loop");
	}

	// sound_loop
	void OnSoundLoop()
	{
		ServerPlaySound(2, 8, "ambience/alienvoices1.wav");
	}

	// reset_effect_delay
	void OnResetEffectDelay()
	{
		EFFECT_DELAY = 0;
	}

	// pick_spell
	void OnPickSpell()
	{
		bool exitSub = false;

		SPELL_CHOICE = RandomInt(1, NUM_SPELLS);

		// setvard SPELL_CHOICE 7 //developer
		if (BEAM_ON)
			exitSub = true;
		if (CHAIN_ON)
			exitSub = true;
		if (exitSub)
			CallEventDelayed(0.5f, "pick_spell");
		if (exitSub)
			return;

		if (G_DEVELOPER > 0)
		{
			SPELL_CHOICE = G_DEVELOPER;
			G_DEVELOPER = 0;
		}

		if (RangeTo(SPELL_TARGET) > 2048.0f)
			SPELL_CHOICE = 0;
		if (!IsAlive(SPELL_TARGET))
			SPELL_CHOICE = 0;
		if (RelationshipOf(SPELL_TARGET, ENT_ME) == "ally")
			SPELL_CHOICE = 0;
		if (SPELL_SUSPEND)
			SPELL_CHOICE = 0;

		if (SPELL_CHOICE == 0)
		{
			exitSub = true;
			if (!BARRIER_ON)
			{
				if (NO_MOVE)
					OnResumeMoving();
				exitSub = true;
			}
		}
		if (exitSub)
			CallEventDelayed(0.5f, "pick_spell");
		if (exitSub)
			return;

		if (SPELL_CHOICE == 1)
		{
			if (BARRIER_DELAY)
			{
				SPELL_CHOICE = RandomInt(2, NUM_SPELLS);
				DebugPrint("barrier_no_go - barrier delay");
				exitSub = true;
			}
			if (!BARRIER_DELAY)
			{
				BARRIER_DELAY = true;
				CallEventDelayed(BARRIER_FREQ, "reset_barrier_delay");

				CallEventDelayed(0.1f, "raise_barrier");
			}
		}
		if (exitSub)
			CallEventDelayed(0.5f, "pick_spell");
		if (exitSub)
			return;

		if (SPELL_CHOICE == 2)
		{
			BEAM_ON = true;
			OnFaceTarget(SPELL_TARGET);
			PlayAnim("critical", ANIM_BOLT);
			BEAM_COUNT = 0.0f;
			APPLIED_BEAM = false;
			BEAM_TARGET = SPELL_TARGET;

			// clientevent update all CL_BEAM_IDX dbeam_color (1,1,0) 20
			CallEventDelayed(0.1f, "beam_push");
		}

		if (SPELL_CHOICE == 3)
		{
			CHAIN_ON = true;
			CUR_CHAIN_TARGET = false;
			OnFaceTarget(SPELL_TARGET);
			PlayAnim("critical", ANIM_CAST);
			CHAIN_COUNT = 0.0f;
			// clientevent update all CL_BEAM_IDX dbeam_color (1,1,1) 10
			CallEventDelayed(0.1f, "chain_lightning");
		}

		if (SPELL_CHOICE == 4)
		{
			if (Truthy(GetVar("G_MAL_ROCK_STORMS")))
			{
				// dbg MALDORA: Can't summon rock storm, still exists
				CallEventDelayed(0.2f, "pick_spell");
				exitSub = true;
			}
			if (!exitSub)
			{
				SetGlobal("G_MAL_ROCK_STORMS", 1);

				PlayAnim("critical", ANIM_CAST);
				int numRocks = PlayerCount();
				if (numRocks > 4)
				{
					int numRucks = 4;
				}
				CreateNpc("monsters/summon/rock_storm", RelativePosition(Vector3(0, 0, 0)), self, numRocks, DMG_ROCKS, 64, 90); // <Owner> <#Rocks> <Dmg> <FX_Radius> <Letivtate_Height>
			}
		}
		// setvard ROCK_STORM_ID $get(ent_lastcreated,id)
		if (exitSub)
			return;

		if (SPELL_CHOICE == 5)
		{
			if (BARRIER_ON)
			{
				// no summoning inside barriers as it means you have to leap out of them
				CallEventDelayed(0.2f, "pick_spell");
				exitSub = true;
			}
			if (!BARRIER_ON)
			{
				if (IMAGES_ALIVE >= 1.0f)
					SPELL_CHOICE = RandomInt(6, NUM_SPELLS);
				if (IMAGES_ALIVE == 0.0f)
				{
					if (RandomInt(1, 3) == 1 && !AM_UBER)
					{
						SayText("Shadows of my shadow...");
						PlaySound(0, 10, "voices/lodagond-4/maldora_summoning.wav");
					}
					CallEventDelayed(2.7f, "laugh_it_up");
					OnStopMoving();
					PlayAnim("critical", ANIM_CAST);
					PlaySound(0, 10, "magic/spawn.wav");
					Effect("glow", ENT_ME, Vector3(255, 255, 255), 128, 2, 2);
					// setsolid none
					CreateNpc(SHADOW_SCRIPT, RelativePosition(Vector3(0, 64, -35)), self, SPELL_TARGET, 45, AM_UBER);
					CallEventDelayed(0.1f, "make_shadow2");
					if (AM_UBER)
					{
						CallEventDelayed(0.2f, "make_shadow3");
						CallEventDelayed(0.4f, "make_shadow4");
					}

					IMAGES_ALIVE = 2.0f;
					// callevent repulse_blast //stop players from getting stuck inside of me
					CallEventDelayed(1.0f, "resume_solid");
					CallEventDelayed(3.0f, "resume_moving");
				}
			}
		}

		if (SPELL_CHOICE == 6)
		{
			if (BARRIER_ON)
			{
				// no summoning inside barriers as it means you have to leap out of them
				CallEventDelayed(0.2f, "pick_spell");
				exitSub = true;
			}
			if (MINIONS_ALIVE >= MINION_LIMIT)
				SPELL_CHOICE = RandomInt(7, NUM_SPELLS);
			if (MINIONS_ALIVE < MINION_LIMIT)
			{
				MINIONS_ALIVE += 1.0f;
				PlayAnim("critical", ANIM_CAST);
				PlaySound(0, 10, "monsters/skeleton/calrain3.wav");
				Effect("glow", ENT_ME, Vector3(255, 255, 255), 128, 2, 2);
				CreateNpc(MINION_SCRIPT, RelativePosition(Vector3(0, 0, -64)), self, SPELL_TARGET);
				OnStopMoving(0.9f);
				CallEventDelayed(1.0f, "leap_away");
			}
		}

		if (SPELL_CHOICE == 7)
		{
			float lastAxePick = LAST_AXE_PICK + 20.0f; // min delay between axe changes is 20 seconds
			if (GameTime() < lastAxePick)
			{
				exitSub = true;
				CallEventDelayed(0.2f, "pick_spell");
			}
			if (GameTime() > lastAxePick)
			{
				OnSelectAxe();
				LAST_AXE_PICK = GameTime();
			}
		}
		if (exitSub)
			return;

		if (SPELL_CHOICE == 8) // last spell slot means no spell selected, try again
		{
			CallEventDelayed(0.2f, "pick_spell");
			exitSub = true;
		}
		if (exitSub)
			return;

		CallEventDelayed(SPELL_FREQ, "pick_spell");
	}

	// select_axe
	void OnSelectAxe()
	{
		Vector3 wandColor = Vec("WAND_COLOR");

		RND_AXE += 1.0f;
		SetProp(ENT_ME, "skin", AXESKIN_WHITE);

		SPELL_SUSPEND = true;
		NO_MOVE = true;

		Effect("glow", ENT_ME, Vector3(255, 255, 255), 256, 2, 2);
		PlaySound(0, 10, "magic/spawn_loud.wav");

		if (RND_AXE == 5.0f)
			RND_AXE = 0.0f;

		if (RND_AXE == 0.0f)
		{
			wandColor = Vector3(255, 0, 0);
			WAND_TYPE = Text(AXESKIN_FIRE);
		}
		if (RND_AXE == 1.0f)
		{
			wandColor = Vector3(255, 255, 255);
			WAND_TYPE = Text(AXESKIN_DARK);
		}
		if (RND_AXE == 2.0f)
		{
			wandColor = Vector3(64, 64, 255);
			WAND_TYPE = AXESKIN_COLD;
		}
		if (RND_AXE == 3.0f)
		{
			wandColor = Vector3(0, 255, 0);
			WAND_TYPE = AXESKIN_POISON;
		}
		if (RND_AXE == 4.0f)
		{
			wandColor = Vector3(255, 255, 0);
			WAND_TYPE = AXESKIN_LIGHTNING;
		}

		// beam where the sword will be
		Vector3 beamStart = AttachmentPositionOf(ENT_ME, 1);
		beamStart.z += 1024.0f;
		Effect("beam", "end", "lgtning.spr", 200, beamStart, self, 1, wandColor, 255, 100, 2.0f);
		CallEventDelayed(1.5f, "select_axe2");
	}

	// select_axe2
	void OnSelectAxe2()
	{
		SPELL_SUSPEND = false;
		NO_MOVE = false;
		SetProp(ENT_ME, "skin", WAND_TYPE);
	}

	// wand_strike_dmg
	// param1 = target struck (from dodamage)
	void OnWandStrikeDmg(CBaseEntity@ target = null)
	{
		WAND_ATK = false;
		if (WAND_TYPE == "WAND_TYPE")
		{
			// bare fisted
			if (RandomInt(1, 5) == 1)
				ApplyEffect(target, "effects/debuff_stun", 3.0f, self);
		}
	}

	// strike_wand
	// model event
	void OnStrikeWand()
	{
		string dmgType = "DMG_TYPE";
		string effectType = "EFFECT_TYPE";
		AS_ATTACKING = GameTime();

		if (!(RangeTo(WAND_TARGET) < ATTACK_HITRANGE))
			return;
		WAND_ATK = true;
		if (Float(WAND_TYPE) == (AXESKIN_FIRE ? 1.0f : 0.0f))
		{
			dmgType = "fire";
			effectType = WAND_FIRE_EFFECT;
		}
		if (Float(WAND_TYPE) == (AXESKIN_DARK ? 1.0f : 0.0f))
		{
			dmgType = "magic";
			effectType = WAND_DARK_EFFECT;
		}
		if (Float(WAND_TYPE) == AXESKIN_COLD)
		{
			dmgType = "cold";
			effectType = WAND_COLD_EFFECT;
		}
		if (Float(WAND_TYPE) == AXESKIN_POISON)
		{
			dmgType = "poison";
			effectType = WAND_POISON_EFFECT;
		}
		if (Float(WAND_TYPE) == AXESKIN_LIGHTNING)
		{
			dmgType = "lightning";
			effectType = WAND_LIGHTNING_EFFECT;
		}

		if (WAND_TYPE == "WAND_TYPE")
		{
			dmgType = "blunt";
			effectType = "none";
		}
		DoDamage(WAND_TARGET, ATTACK_HITRANGE, DMG_WAND, "80%", "blunt");

		if (effectType == WAND_DARK_EFFECT)
			ApplyEffect(WAND_TARGET, WAND_DARK_EFFECT, 10.0f, 0, 1);
		else if (effectType != "none")
			ApplyEffect(WAND_TARGET, effectType, 5.0f, self, WAND_DOT);
	}

	// spawn_shad
	void OnSpawnShad()
	{
		SORC_SPAWNED = true;
		SetGlobal("G_SHAD_ORC", 0);
		CreateNpc("monsters/sorc_chief2", RelativePosition(Vector3(0, 64, 0)), self);
		CallEventDelayed(4.0f, "spawn_shad2");
	}

	// spawn_shad2
	void OnSpawnShad2()
	{
		SayText("It'll take more than a renegade orc and a couple of wayward humans to defeat me!");
		PlaySound(0, 10, "voices/lodagond-4/maldora_orcspot.wav");
		CallEventDelayed(5.9f, "laugh_it_up");
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/maldora.mdl");
		Precache("monsters/skeleton_boss1.mdl");
		Precache("rockgibs.mdl");
		Precache("ambience/alienvoices1.wav");
		CallEventDelayed(FREQ_SOUND, "reset_props");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		LodagondMaldora_FirstThink();
		MaldoraFragment_FirstThink();
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
		if (name == "fade_in_done") { OnFadeInDone(); return true; }
		if (name == "fade_me_in") { OnFadeMeIn(); return true; }
		if (name == "game_death") { OnGameDeath(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_precache") { OnGamePrecache(); return true; }
		if (name == "npc_post_spawn") { OnNpcPostSpawn(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "pick_spell") { OnPickSpell(); return true; }
		if (name == "remove_me") { OnRemoveMe(Param(params, 0)); return true; }
		if (name == "reset_effect_delay") { OnResetEffectDelay(); return true; }
		if (name == "reset_props") { OnResetProps(); return true; }
		if (name == "select_axe") { OnSelectAxe(); return true; }
		if (name == "select_axe2") { OnSelectAxe2(); return true; }
		if (name == "sound_loop") { OnSoundLoop(); return true; }
		if (name == "spawn_shad") { OnSpawnShad(); return true; }
		if (name == "spawn_shad2") { OnSpawnShad2(); return true; }
		if (name == "strike_wand") { OnStrikeWand(); return true; }
		if (name == "wand_strike_dmg") { OnWandStrikeDmg(EntityParam(params, 0)); return true; }
		return MaldoraFragmentScript::DispatchEvent(name, params);
	}
}
