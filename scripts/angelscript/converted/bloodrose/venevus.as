#pragma context server

// Converted from bloodrose/venevus.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_npc.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class Venevus
{
	// Constants
	float NPC_BOSS_REGEN_RATE = 0.1f;
	float NPC_BOSS_RESTORATION = 0.5f;
	string MAX_RANGE = "2048";
	string ANIM_CAST = "castspell";
	string ANIM_DEAD = "lying_on_stomach";
	float SPELL_FREQ = 6.0f;
	float POISON_ALL_FREQ = 200.0f;
	string SOUND_LAUGH = "monsters/skeleton/cal_laugh.wav";
	string SOUND_POWERUP = "ambience/particle_suck2.wav";
	string SOUND_STEAM = "ambience/steamburst1.wav";
	string SOUND_BOOM = "ambience/flameburst1.wav";
	string SOUND_ACID_CHARGE = "bullchicken/bc_attack1.wav";
	string SOUND_STRUCK1 = "zombie/zo_pain2.wav";
	string SOUND_STRUCK2 = "zombie/zo_pain2.wav";
	string SOUND_STRUCK3 = "zombie/zo_pain2.wav";
	string SOUND_SHOCK1 = "debris/zap8.wav";
	string SOUND_SHOCK2 = "debris/zap3.wav";
	string SOUND_SHOCK3 = "debris/zap4.wav";
	string SOUND_SNOWBALL = "zombie/claw_miss1.wav";
	string SOUND_ICEBLAST = "magic/temple.wav";
	string SOUND_THROW = "debris/beamstart5.wav";
	string SOUND_FIRE_WALL = "magic/fireball_strike.wav";
	float POISON_CLOUD_DAMAGE = 40.0f;
	float POISON_CLOUD_DURATION = 0.0f;
	int AIM_RATIO = 50;
	int OFFSET_LIGHTNING = 100;
	int OFFSET_POISON = 100;
	int OFFSET_ICE = 100;
	int OFFSET_FIRE = 100;
	int ACID_BOLT_DAMAGE = 600;
	int LIGHTNING_BOLT_DAMAGE = 40;
	int SHOCK_DAMAGE = 30;
	int SHOCK_DURATION = 1;
	int BEING_SPLOITED_THRESHOLD = 500;
	bool I_AM_TURNABLE = false;
	string MONSTER_MODEL = "monsters/venevus.mdl";
	string LIGHTNING_SPRITE = "lgtning.spr";

	// Variables (an unset .script variable reads as its own name)
	bool IS_UNHOLY = true;
	string ANIM_RUN = "walk";
	string ANIM_WALK = "walk";
	string ANIM_IDLE = "idle1";
	float NPC_GIVE_EXP = 0.0f;
	bool NPC_IS_BOSS = false;
	string ANIM_DEATH = "ANIM_DEATH";
	float SNOWBALL_DURATION = 0.0f;
	string NO_STUCK_CHECKS = "NO_STUCK_CHECKS";
	float SPELL_SELECT = 0.0f;
	float THROW_CHANCE = 0.0f;
	float ACTIVE_VOLCANO = 0.0f;
	int DMG_VOLCANO = 0;
	Vector3 NPC_SPAWN_LOC = Vector3();
	Vector3 LAST_STUCK_CHECK_POS = Vector3();
	int MAX_TELE_RANGE = 0;
	string OUT_SPELL = "OUT_SPELL";
	int POISON_EM = 0;
	float NEXT_SPELL = 0.0f;
	bool CASTING_SPELL_DELAY = false;
	string CKN_MY_OLD_POS = "CKN_MY_OLD_POS";
	string SPELL_TARGET = "SPELL_TARGET";
	bool DID_ALE_INTRO = false;
	string FIRE_AT = "FIRE_AT";
	bool POISON_SITE = false;
	bool SPOTTING = false;
	float DO_DAMAGE_SITE = 0.0f;
	bool DO_ACID_BOLTS = false;
	bool DO_LIGHTNING = false;
	string OUTSPELL = "OUTSPELL";
	bool BOLT_DELAY = false;
	bool IR_DEADSKI = false;
	CBaseEntity@ STATUE_ID = null;
	Vector3 MOVE_LASTPOS = Vector3();
	float BEING_SPLOITED_DMG = 0.0f;
	bool MURDER_A_PLAYER = false;
	float STRUCK_BY_HOLY = 0.0f;
	bool DO_HOLY_MSG = false;
	bool PRESET_TARGET = false;
	CBaseEntity@ HOLY_OFFENDER = null;
	bool SPLOITED_CHECKED = false;
	bool TELED_OUT = false;
	int KILLED_A_PLAYER = 0;
	CBaseEntity@ THIS_MUST_DIE = null;
	bool CHANGE_RETURN_POINT = false;
	string BEAM_ID = "BEAM_ID";

	// unnamed block (first think)
	void Venevus_FirstThink()
	{
		IS_UNHOLY = true;

		if (ToLowerCase(MapName()) == "bloodrose")
		{
			NPC_GIVE_EXP = 3000.0f;
			NPC_IS_BOSS = true;
		}
		else if (ToLowerCase(MapName()) == "aleyesu")
		{
			NPC_GIVE_EXP = 5000.0f;
			NPC_IS_BOSS = true;
		}
		else
		{
			NPC_GIVE_EXP = 1000.0f;
		}
		ANIM_RUN = "walk";
		ANIM_WALK = "walk";
		ANIM_IDLE = "idle1";
		ANIM_DEATH = "castspell";
		SNOWBALL_DURATION = 10.0f; // read by proj_snow_ball

		NO_STUCK_CHECKS = "1";
	}

	// npc_spawn
	void Venevus_OnNpcSpawn(string npc = "")
	{
		if (!AM_GENERIC)
			SetName("Venevus, the Corruptor");
		if (AM_GENERIC)
			SetName("Evil Necromancer");
		SetHealth(3000);
		SetFieldOfView(359);
		SetWidth(40);
		SetHeight(80);
		SetRoam(false);
		SetRace("demon");
		SetModel(MONSTER_MODEL);
		SetIdleAnim(ANIM_IDLE);
		SetMoveAnim(ANIM_WALK);
		SetGold(200);

		// make sure these are all weapon damage types
		SetDamageTaken("all", 0.4f);
		SetDamageTaken("slash", 0);
		SetDamageTaken("pierce", 0);
		SetDamageTaken("blunt", 0);
		SetDamageTaken("fire", 0.25f);
		SetDamageTaken("holy", 2);
		SetDamageTaken("dark", 0.5f);
		SetDamageTaken("acid", 0.25f); // Added acid reduct, poison immune. greatguys1@April2018
		SetDamageTaken("poison", 0);
		SetDamageTaken("lightning", 1.2f);

		SPELL_SELECT = 0.0f;

		THROW_CHANCE = 0.0f;

		CallEventDelayed(1.1f, "post_spawn_props");

		// callevent npcatk_suspend_ai
		if (!AM_GENERIC)
			OnScanForIntro();
		if (AM_GENERIC)
			CallEventDelayed(0.1f, "pre_mortal_kombat");

		if (!AM_GENERIC) // invincible until intro over
			SetInvincible(true);

		CallEventDelayed(0.1f, "init_beam");

		ACTIVE_VOLCANO = 0.0f;

		DMG_VOLCANO = 50;
	}

	// post_spawn_props
	void Venevus_OnPostSpawnProps()
	{
		SetDamageTaken("holy", 2); // setting post-spawn to override default demon settings
		NPC_SPAWN_LOC = MyOrigin();
		LAST_STUCK_CHECK_POS = MyOrigin();

		if (Contains(ToLowerCase(MapName()), "aleyesu"))
			MAX_TELE_RANGE = 768;
		else
			MAX_TELE_RANGE = 2048;
	}

	// scan_for_intro
	void Venevus_OnScanForIntro()
	{
		bool exitSub = false;

		if (Truthy(LegacyFunction("cansee", "enemy", 600)))
		{
			SetSayTextRange(2048);
			SetMoveDest(ENT_LASTSEEN, 9999);
			SayText("My my, so you've shown your faces after all...");
			CallEventDelayed(3.0f, "pre_mortal_kombat");
			exitSub = true;
		}
		if (exitSub)
			return;

		CallEventDelayed(0.5f, "scan_for_intro");
	}

	// pre_mortal_kombat
	void Venevus_OnPreMortalKombat()
	{
		SetSayTextRange(2048);
		if (!AM_GENERIC)
			SayText("And here I took you for cowards... But obviously...");
		CallEventDelayed(3.0f, "let_mortal_kombat_begin");
		CallEventDelayed(2.0f, "green_blast");
	}

	// let_mortal_kombat_begin
	void Venevus_OnLetMortalKombatBegin()
	{
		PlaySound(0, 10, SOUND_LAUGH);
		SetSayTextRange(2048);
		if (!AM_GENERIC)
			SayText("...You are simply FOOLS!");
		SetInvincible(false);
		SetRoam(true);
		CallEventDelayed(5.0f, "select_random_spell");
		CallEventDelayed(10.0f, "stuck_checks");
	}

	// green_blast
	void Venevus_OnGreenBlast()
	{
		PlayAnim("critical", ANIM_CAST);
		PlaySound(0, 10, SOUND_POWERUP);
		OUT_SPELL = "poison_all";
		Effect("glow", ENT_ME, Vector3(0, 255, 0), 100, 5, 5);
		CallEventDelayed(POISON_ALL_FREQ, "poison_all_again");
	}

	// poison_all_again
	void Venevus_OnPoisonAllAgain()
	{
		POISON_EM = 1;
	}

	// select_random_spell
	void Venevus_OnSelectRandomSpell()
	{
		// select spell and cast timer here
		// poison cloud
		// volcano
		// lightning
		// fire wall
		// snow ball
		// freezing sphere
		// acid bolt (+ when struck by turn_undead)
		// poison all (every 200 secs)
		// local SPELL_SELECT $rand(1,7)
		SPELL_SELECT += 1.0f;
		if (SPELL_SELECT > 7.0f)
			SPELL_SELECT = 1.0f;

		if (SPELL_SELECT == 1.0f)
			NEXT_SPELL = 0.0f;
		if (SPELL_SELECT == 2.0f)
			NEXT_SPELL = 0.0f;
		if (SPELL_SELECT == 3.0f)
			NEXT_SPELL = 0.0f;
		if (SPELL_SELECT == 4.0f)
			NEXT_SPELL = 0.0f;
		if (SPELL_SELECT == 5.0f)
			NEXT_SPELL = 0.0f;
		if (SPELL_SELECT == 6.0f)
			NEXT_SPELL = 0.0f;
		if (SPELL_SELECT == 7.0f)
			NEXT_SPELL = 0.0f;
		if (POISON_EM == 1)
			NEXT_SPELL = 0.0f;

		// if ( MURDER_A_PLAYER == 1 ) setvard NEXT_SPELL kill //Insta kill move is kinda bs, and the "anti-cheat" is just guessing and never works as intended. -greatguys1 SEP2021
		CallEventDelayed(SPELL_FREQ, "select_random_spell");
		CallEventDelayed(SPELL_FREQ, "setup_spell");
	}

	// setup_spell
	void Venevus_OnSetupSpell()
	{
		bool exitSub = false;

		// //dbg temp Setup Deadski IR_DEADSKI Teled TELED_OUT
		if (IR_DEADSKI)
			return;
		if (TELED_OUT)
			return;

		CASTING_SPELL_DELAY = true;
		CKN_MY_OLD_POS = "0";

		if (Text(NEXT_SPELL) == "poison_all")
		{
			OnGreenBlast();
			exitSub = true;
		}
		if (exitSub)
			return;

		// dbg Casting NEXT_SPELL
		OUT_SPELL = Text(NEXT_SPELL);
		PlayAnim("critical", ANIM_CAST);

		if (CanSee("enemy"))
		{
			SPELL_TARGET = EntityId(EntityOf(ENT_LASTSEEN));
			SetMoveDest(SPELL_TARGET, 9999);
		}

		if (OUT_SPELL == "poison_cloud")
		{
			Effect("glow", ENT_ME, Vector3(0, 255, 0), 100, 5, 5);
			CreateNpc("monsters/companion/spell_maker_affliction", RelativePosition(Vector3(0, 0, 40)), self, "none", "none", OFFSET_POISON);
		}

		if (OUT_SPELL == "volcano")
		{
			Effect("glow", ENT_ME, Vector3(255, 0, 0), 256, 5, 5);
			CreateNpc("monsters/companion/spell_maker_fire", RelativePosition(Vector3(0, 0, 40)), self, "none", "none", OFFSET_FIRE);
		}

		if (OUT_SPELL == "fire_wall")
		{
			Effect("glow", ENT_ME, Vector3(255, 80, 80), 100, 5, 5);
			CreateNpc("monsters/companion/spell_maker_fire", RelativePosition(Vector3(0, 0, 40)), self, "none", "none", OFFSET_FIRE);
		}

		if (OUT_SPELL == "snow_ball")
		{
			Effect("glow", ENT_ME, Vector3(80, 80, 255), 100, 5, 5);
			CreateNpc("monsters/companion/spell_maker_ice", RelativePosition(Vector3(0, 0, 40)), self, "none", "none", OFFSET_ICE);
		}

		if (OUT_SPELL == "freezing_sphere")
		{
			Effect("glow", ENT_ME, Vector3(128, 128, 255), 512, 5, 5);
			CreateNpc("monsters/companion/spell_maker_ice", RelativePosition(Vector3(0, 0, 40)), self, "none", "none", OFFSET_ICE);
		}

		if (OUT_SPELL == "acid_bolt")
		{
			Effect("glow", ENT_ME, Vector3(0, 255, 0), 200, 5, 5);
			PlaySound(0, 10, SOUND_ACID_CHARGE);
		}

		if (OUT_SPELL == "chain_lightning")
		{
			Effect("glow", ENT_ME, Vector3(255, 255, 0), 200, 5, 5);
			CreateNpc("monsters/companion/spell_maker_lightning", RelativePosition(Vector3(0, 0, 40)), self, "none", "none", OFFSET_LIGHTNING);
		}

		if (OUT_SPELL == "kill")
		{
			Effect("glow", ENT_ME, Vector3(255, 255, 255), 200, 5, 5);
			PlaySound(0, 10, SOUND_POWERUP);
		}
	}

	// castspell
	// called from model anim castspell
	void Venevus_OnCastspell()
	{
		Vector3 spellTarg = Vec("SPELL_TARG");
		Vector3 pos = Vec("pos");
		float temp = 0.0f;
		float x = 0.0f;
		float y = 0.0f;

		if (!DID_ALE_INTRO)
		{
			DID_ALE_INTRO = true;
			if (Contains(ToLowerCase(MapName()), "aleyesu"))
				OnDoAleIntro();
		}

		if (IR_DEADSKI)
			return;

		SetMoveDest(SPELL_TARGET, 9999);

		if (OUT_SPELL == "poison_all")
		{
			PlaySound(0, 10, SOUND_BOOM);
			Effect("screenfade", "all", 3, 1, Vector3(0, 255, 0), 255, "fadein");
			FIRE_AT = "unset";
			POISON_SITE = true;
			SPOTTING = true;
			DO_DAMAGE_SITE = 1.0f;
			OnSpotTargets();
			CallEventDelayed(1.0f, "stop_spotting");
			CallEventDelayed(1.0f, "reset_poison_site");
			POISON_EM = 0;
		}

		if (OUT_SPELL == "kill")
		{
			PlaySound(0, 10, SOUND_LAUGH);
			Effect("screenfade", "all", 3, 1, Vector3(255, 255, 255), 255, "fadein");
			CallEventDelayed(0.1f, "kill_a_player");
		}

		if (OUT_SPELL == "poison_cloud")
		{
			if (CanSee("enemy"))
				spellTarg = OriginOf(ENT_LASTSEEN);
			if (RelationshipOf(ENT_LASTSEEN, ENT_ME) == "enemy")
			{
				string nmePos = "get(ent_lastseen,origin)";
				float nmeDist = Distance(Vec(nmePos), MyOrigin());
				if (nmeDist < Float(MAX_RANGE))
					spellTarg = OriginOf(ENT_LASTSEEN);
				if (nmeDist > Float(MAX_RANGE))
					spellTarg = RelativePosition(Vector3(0, 200, 0));
			}
			if (Text(spellTarg) == "SPELL_TARG")
				spellTarg = RelativePosition(Vector3(0, 10, 50));
			// PARAM1=Owner PARAM2=Angles PARAM3=Damage PARAM4=Duration
			PlaySound(0, 10, SOUND_STEAM);
			CreateNpc("monsters/summon/npc_poison_cloud2", spellTarg, self, POISON_CLOUD_DAMAGE, POISON_CLOUD_DURATION);
		}

		if (OUT_SPELL == "snow_ball")
		{
			if (CanSee("enemy"))
				spellTarg = OriginOf(ENT_LASTSEEN);
			if (Text(spellTarg) == "SPELL_TARG")
				spellTarg = RelativePosition(Vector3(0, 640, 0));
			float aimAngle = Divide(Distance(MyOrigin(), spellTarg), AIM_RATIO);
			SetAngle("add_view.x", aimAngle);
			PlaySound(0, 10, SOUND_SNOWBALL);
			// <projectile scriptname> <"view"|(src_origin)> <target|(targ_origin)> <speed> <damage> <cof> <skill|none>
			TossProjectile("proj_snow_ball", RelativePosition(Vector3(0, 52, 8)), spellTarg, 300, "SNOWBALL_DAMAGE", 2, "none"); // Converted to use new tossprojectile //greatguys1@FEB2022 untested
		}

		if (OUT_SPELL == "freezing_sphere")
		{
			Vector3 ballDest = RelativePosition(Vector3(0, 2000, 0));
			PlaySound(0, 10, SOUND_ICEBLAST);
			CreateNpc("monsters/summon/ice_blast", RelativePosition(Vector3(0, 64, 32)), self, 10.0f, ballDest);
		}

		if (OUT_SPELL == "volcano")
		{
			if (CanSee("enemy"))
				pos = OriginOf(ENT_LASTSEEN);
			if (RelationshipOf(ENT_LASTSEEN, ENT_ME) == "enemy")
				pos = OriginOf(ENT_LASTSEEN);
			if (!CanSee("enemy") && Distance(MyOrigin(), pos) > Float(MAX_RANGE))
			{
				pos = Vec(LegacyFunction("vec", MyOrigin()));
				pos += RelativePosition(Vector3(0, 0, 0), Vector3(0, 500, 0));
				pos = Vec(LegacyFunction("get_traceline", MyOrigin(), pos, "worldonly"));
			}
			temp = GroundHeight(pos);
			x = pos.x;
			y = pos.y;
			pos = Vector3(x, y, temp);
			SetGlobal("VOLCANO_DMG", 2);
			float volcanoDuration = SPELL_FREQ * 6.0f;
			CreateNpc("monsters/summon/npc_volcano", pos, self, 150, volcanoDuration);
			ACTIVE_VOLCANO += 1.0f;
			CallEventDelayed(volcanoDuration, "reset_active_volcano");
		}

		if (OUT_SPELL == "fire_wall")
		{
			if (CanSee("enemy"))
				pos = OriginOf(ENT_LASTSEEN);
			if (RelationshipOf(ENT_LASTSEEN, ENT_ME) == "enemy")
				pos = OriginOf(ENT_LASTSEEN);
			if (!CanSee("enemy") && Distance(pos, MyOrigin()) > Float(MAX_RANGE))
				pos = RelativePosition(Vector3(0, 256, 0));
			PlaySound(0, 10, SOUND_FIRE_WALL);
			// local pos $get(ent_lastseen,origin)
			temp = GroundHeight(pos);
			x = pos.x;
			y = pos.y;
			pos = Vector3(x, y, temp);
			int setDamage = 80;
			float setDuration = SPELL_FREQ;
			CreateNpc("monsters/summon/keledros_fire_wall", pos, self, AnglesOf(ENT_ME).y, setDamage, setDuration);
		}

		if (OUT_SPELL == "acid_bolt")
		{
			FIRE_AT = "unset";
			DO_ACID_BOLTS = true;
			SPOTTING = true;
			DO_DAMAGE_SITE = 0.0f;
			OnSpotTargets();
			CallEventDelayed(2.0f, "stop_spotting");
			CallEventDelayed(2.0f, "reset_acid_bolt");
		}

		if (OUT_SPELL == "chain_lightning")
		{
			FIRE_AT = "unset";
			DO_LIGHTNING = true;
			SPOTTING = true;
			DO_DAMAGE_SITE = 0.0f;
			OnSpotTargets();
			// effect beam update BEAM_ID end_target ent_me 2
			Effect("beam", "update", BEAM_ID, "brightness", 150);
			CallEventDelayed(3.0f, "stop_spotting");
			CallEventDelayed(3.0f, "reset_lightning");
		}

		CASTING_SPELL_DELAY = false;
		OUTSPELL = "unset";
	}

	// reset_lightning
	void Venevus_OnResetLightning()
	{
		DO_LIGHTNING = false;
		Effect("beam", "update", BEAM_ID, "brightness", 0);
		Effect("beam", "update", BEAM_ID, "end_target", ENT_ME, 2);
	}

	// reset_acid_bolt
	void Venevus_OnResetAcidBolt()
	{
		DO_ACID_BOLTS = false;
	}

	// stop_spotting
	void Venevus_OnStopSpotting()
	{
		SPOTTING = false;
	}

	// reset_poison_site
	void Venevus_OnResetPoisonSite()
	{
		POISON_SITE = false;
	}

	// spot_targets
	void Venevus_OnSpotTargets()
	{
		if (!SPOTTING)
			return;
		CallEventDelayed(0.1f, "spot_targets");

		DO_DAMAGE_SITE += 1.0f;
		if (DO_DAMAGE_SITE > 10.0f)
			DoDamage(Text(RelativePosition(Vector3(0, 0, 0))), 2048, 0, "100%", 0, "reflective");

		if (!CanSee("enemy"))
			return;

		// if ( $get(ent_lastseen,id) isnot $get(FIRE_AT,id) )
		// {
		// if ( game.players == 1 ) setvard FIRE_AT unset
		// local EXIT_SUB 1
		// }
		// if !EXIT_SUB
		string oldFireAt = FIRE_AT;
		FIRE_AT = EntityId(EntityOf(ENT_LASTSEEN));
		if (DO_ACID_BOLTS)
			OnThrowAcidBolt();
		if (DO_LIGHTNING)
		{
			OnThrowLightning();
			if (oldFireAt != FIRE_AT)
			{
				DebugPrint("spot_targets beam [ " + BEAM_ID + " ] @ " + NameOf(FIRE_AT));
				Effect("beam", "update", BEAM_ID, "end_target", @EntityOf(FIRE_AT), 1);
				Effect("beam", "update", BEAM_ID, "brightness", 255);
			}
		}
		if (POISON_SITE)
			ApplyEffect(FIRE_AT, "effects/dot_poison", 90.0f, self, 1.0f);
	}

	// throw_lightning
	void Venevus_OnThrowLightning()
	{
		// //dbg temp LightningTo $get(FIRE_AT,name)
		if (BOLT_DELAY)
			return;
		BOLT_DELAY = true;
		CallEventDelayed(0.1f, "reset_bolt_delay");

		PlayRandomSound(0, 10, SOUND_SHOCK1, SOUND_SHOCK2, SOUND_SHOCK3);
		Vector3 beamEnd = OriginOf(FIRE_AT);
		// effects beam LIGHTNING_SPRITE 80 $relpos(0,0,22) BEAM_END (255,255,255) 150 100 1.5
		// effect beam point LIGHTNING_SPRITE 80 $relpos(0,0,42) BEAM_END (255,255,255) 150 50 0.2
		// effect beam point LIGHTNING_SPRITE 80 $relpos(-22,0,22) BEAM_END (255,255,255) 150 50 1.5
		// effect beam point LIGHTNING_SPRITE 80 $relpos(22,0,22) BEAM_END (255,255,255) 150 50 1.5
		if (DamageTakenOf(FIRE_AT, "lightning") == 0.0f)
			return;
		DoDamage(FIRE_AT, "direct", LIGHTNING_BOLT_DAMAGE, "100%", ENT_ME);
		if (HasEffect(FIRE_AT, "DOT_lightning"))
			return;
		ApplyEffect(FIRE_AT, "effects/dot_lightning", SHOCK_DURATION, self, SHOCK_DAMAGE);
	}

	// throw_acid_bolt
	void Venevus_OnThrowAcidBolt()
	{
		if (BOLT_DELAY)
			return;
		BOLT_DELAY = true;
		CallEventDelayed(0.2f, "reset_bolt_delay");

		// <projectile scriptname> <"view"|(src_origin)> <target|(targ_origin)> <speed> <damage> <cof> <skill|none>
		TossProjectile("proj_poison_spit2", RelativePosition(Vector3(0, 10, 10)), @EntityOf(FIRE_AT), 300, ACID_BOLT_DAMAGE, 1, "none"); // Converted to use new tossprojectile //greatguys1@FEB2022 untested
	}

	// reset_bolt_delay
	void Venevus_OnResetBoltDelay()
	{
		BOLT_DELAY = false;
	}

	// game_dodamage
	string Venevus_OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		CBaseEntity@ checkTarg = null;
		string result = "";

		if (POISON_SITE)
			ApplyEffect(target, "effects/dot_poison", 90.0f, self, 1.0f);

		if (DO_ACID_BOLTS)
		{
			@checkTarg = target;
			// if CHECK_TARG isnot FIRE_AT
			FIRE_AT = EntityId(checkTarg);
			OnThrowAcidBolt();
		}
		if (DO_LIGHTNING)
		{
			@checkTarg = target;
			// if CHECK_TARG isnot FIRE_AT
			FIRE_AT = EntityId(checkTarg);
		}
		return result;
	}

	// game_death
	void Venevus_OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		Effect("beam", "update", BEAM_ID, "remove", 0);

		if (AM_GENERIC)
		{
			SetAnimFrameRate(0.1f);
			PlayAnim("critical", "dieforward");
			PlaySound(0, 10, "x/x_die1.wav");
		}
		if (AM_GENERIC)
			return;

		IR_DEADSKI = true;
		SetAlive(true);
		SetInvincible(true);
		SetSolid("none");
		SetBoundingBox("none");
		// playanim critical ANIM_DEATH
		SetIdleAnim(ANIM_CAST);
		SetMoveAnim(ANIM_CAST);
		SetFly(true);
		@STATUE_ID = FindByName("atholo_statue");
		Effect("glow", @STATUE_ID, Vector3(255, 0, 0), 255, 5, 5);
		SetProp(ENT_ME, "solid", 0);
		SetProp(ENT_ME, "movetype", Eval("const.movetype.noclip"));
		SetAnimMoveSpeed(200);
		SetMoveDest(@STATUE_ID, 10);

		// dbg Moving to $get(STATUE_ID,origin)
		SetSayTextRange(2048);
		SayText("I sacrifice my wretched life to release the greatest evil in this world...");
		MOVE_LASTPOS = MyOrigin();
		CallEventDelayed(0.1f, "cycle_move");
		CallEventDelayed(6.0f, "game_over");
	}

	// cycle_move
	void Venevus_OnCycleMove()
	{
		SetMoveDest(@STATUE_ID, 10);
		SetAnimMoveSpeed(200);

		AddVelocity(ENT_ME, RelativeVelocity(Vector3(-1, 100, 40)));
		CallEventDelayed(0.2f, "cycle_move");
	}

	// game_over
	void Venevus_OnGameOver()
	{
		SetSayTextRange(2048);
		PlaySound(0, 10, SOUND_LAUGH);
		CallExternal(STATUE_ID, "spawn_atholo", @EntityOf(ENT_LASTSTRUCK));
		SayText("With my blood I bring you the legendary evil! ATHOLO!");
		UseTrigger("atholo_door");
		SetAlive(false);
		DeleteEntity(ENT_ME, "fade");
	}

	// reset_active_volcano
	void Venevus_OnResetActiveVolcano()
	{
		ACTIVE_VOLCANO -= 1.0f;
	}

	// game_damaged
	// PARAM1=attacker PARAM2=Damage PARAM3=DamageType
	string Venevus_OnGameDamaged(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float accuracyRoll = 0.0f, CBaseEntity@ inflictor = null, string skill = "")
	{
		bool didThrow = false;
		string result = "";

		// dbg MyHp game.monster.hp
		if (RelationshipOf(attacker, ENT_ME) != "enemy")
			return result;

		float incDmg = damage;

		BEING_SPLOITED_DMG += incDmg;

		incDmg *= 0.15f;
		THROW_CHANCE += incDmg;

		if (MyHealth() < 500.0f && KILLED_A_PLAYER == 0)
		{
			// dbg temp MurderCalled because Im low on HP
			MURDER_A_PLAYER = true;
		}

		if (damageType == "holy")
		{
			// throw players when struck by holy, regardless of distance
			didThrow = true;
			SetMoveDest(ENT_LASTSTRUCK, 9999);
			PlaySound(0, 10, SOUND_THROW);
			AddVelocity(ENT_LASTSTRUCK, RelativeVelocity(Vector3(0, 500, 200)));
			THROW_CHANCE = 0.0f;
			if (incDmg > 200.0f)
			{
				STRUCK_BY_HOLY += 1.0f;

				// if struck for a fair amount of holy damage 3 times, tele attack
				if (STRUCK_BY_HOLY > 2.0f)
				{
					STRUCK_BY_HOLY = 0.0f;
					DO_HOLY_MSG = true;
					MURDER_A_PLAYER = true;
					PRESET_TARGET = true;
					@HOLY_OFFENDER = EntityOf(ENT_LASTSTRUCK);
				}
			}
		}

		if (RandomInt(1, 100) <= THROW_CHANCE && !didThrow && RangeTo(ENT_LASTSTRUCK) < 200.0f)
		{
			SetMoveDest(ENT_LASTSTRUCK, 9999);
			PlaySound(0, 10, SOUND_THROW);
			AddVelocity(ENT_LASTSTRUCK, RelativeVelocity(Vector3(0, 500, 200)));
			THROW_CHANCE = 0.0f;
		}

		if (SPLOITED_CHECKED)
			return result;
		SPLOITED_CHECKED = true;
		CallEventDelayed(5.0f, "check_if_sploited");
		return result;
	}

	// check_if_sploited
	void Venevus_OnCheckIfSploited()
	{
		if (BEING_SPLOITED_DMG > BEING_SPLOITED_THRESHOLD)
		{
			// I've taken over 500 dmg in 5 seconds, somoene is probably sticking me on a volcano or somethin
			// dbg temp Murder called because BEING_SPLOITED_DMG > BEING_SPLOITED_THRESHOLD
			MURDER_A_PLAYER = true;
		}
		BEING_SPLOITED_DMG = 0.0f;
		SPLOITED_CHECKED = false;
	}

	// kill_a_player
	void Venevus_OnKillAPlayer()
	{
		TELED_OUT = true;
		KILLED_A_PLAYER = 1;
		PlaySound(0, 10, SOUND_BOOM);
		SayText("Oh me oh my, where did he go...");
		SetOrigin(ENT_ME, Vector3(20000, 20000, 20000));
		if (!PRESET_TARGET)
			@THIS_MUST_DIE = EntityOf(ENT_LASTSTRUCK);
		if (PRESET_TARGET)
		{
			@THIS_MUST_DIE = HOLY_OFFENDER;
			PRESET_TARGET = false;
		}
		CHANGE_RETURN_POINT = false;
		CallEventDelayed(8.0f, "murder_return");
		OnScanForDeath();
	}

	// scan_for_death
	void Venevus_OnScanForDeath()
	{
		if (!TELED_OUT)
			return;
		if (!IsAlive(THIS_MUST_DIE))
		{
			// dbg temp target died while I was out
			CHANGE_RETURN_POINT = true;
		}
		Vector3 killTargOrigin = OriginOf(THIS_MUST_DIE);
		if (Distance(killTargOrigin, NPC_SPAWN_LOC) > MAX_TELE_RANGE)
			CHANGE_RETURN_POINT = true;
		if (CHANGE_RETURN_POINT)
			return;
		CallEventDelayed(0.1f, "scan_for_death");
	}

	// murder_return
	void Venevus_OnMurderReturn()
	{
		TELED_OUT = false;
		MURDER_A_PLAYER = false;
		SPELL_SELECT = 0.0f;
		// callevent select_random_spell
		if (DO_HOLY_MSG)
		{
			DO_HOLY_MSG = false;
			InfoMessage("all", "BEWARE!", "Venevus uses death magic to counter holy magic!");
		}
		PlaySound(0, 10, SOUND_BOOM);
		Effect("screenfade", "all", 3, 1, Vector3(255, 255, 255), 255, "fadein");
		Vector3 returnPoint = OriginOf(THIS_MUST_DIE);
		if (CHANGE_RETURN_POINT)
		{
			// if target died while I was out, return to spawn origin instead
			returnPoint = NPC_SPAWN_LOC;
		}
		if (!CHANGE_RETURN_POINT)
			CallEventDelayed(0.1f, "kill_target");
		SetOrigin(ENT_ME, returnPoint);
		CallEventDelayed(0.2f, "murder_done");
	}

	// murder_done
	void Venevus_OnMurderDone()
	{
		SetSayTextRange(2048);
		SayText("Who's next?");
		PlaySound(0, 10, SOUND_LAUGH);
	}

	// kill_target
	void Venevus_OnKillTarget()
	{
		Vector3 targetOrg = OriginOf(THIS_MUST_DIE);
		if (!(Distance(MyOrigin(), targetOrg) < 100.0f))
			return;
		if (!IsAlive(THIS_MUST_DIE))
			return;
		DoDamage(THIS_MUST_DIE, "direct", 10000, "100%", ENT_ME);
		CallEventDelayed(0.11f, "kill_target");
	}

	// stuck_checks
	void Venevus_OnStuckChecks()
	{
		// note moved for 25 seconds, time to tele
		if (Distance(MyOrigin(), LAST_STUCK_CHECK_POS) == 0.0f)
		{
			// dbg MurderCalled due to Stuck too long
			MURDER_A_PLAYER = true;
		}
		LAST_STUCK_CHECK_POS = MyOrigin();
		CallEventDelayed(25.0f, "stuck_checks");
	}

	// init_beam
	void Venevus_OnInitBeam()
	{
		Effect("beam", "ents", LIGHTNING_SPRITE, 80, ENT_ME, 1, ENT_ME, 2, Vector3(255, 255, 255), 0, 50, -1);
		BEAM_ID = EntityId(EntityOf(ENT_LASTCREATED));
	}

	// die_fast
	void Venevus_OnDieFast()
	{
		SetHealth(10);
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)

	// game_death
	void OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		DqMonsterExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // dq/externals/dq_monster_externals
		MonstersExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/externals
		BaseSelfAdjust_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_self_adjust
		BaseNpc_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		Venevus_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4);
	}

	void OnNpcSpawn(string npc = "") { Venevus_OnNpcSpawn(npc); } // npc_spawn
	void OnPostSpawnProps() { Venevus_OnPostSpawnProps(); } // post_spawn_props
	void OnScanForIntro() { Venevus_OnScanForIntro(); } // scan_for_intro
	void OnPreMortalKombat() { Venevus_OnPreMortalKombat(); } // pre_mortal_kombat
	void OnLetMortalKombatBegin() { Venevus_OnLetMortalKombatBegin(); } // let_mortal_kombat_begin
	void OnGreenBlast() { Venevus_OnGreenBlast(); } // green_blast
	void OnPoisonAllAgain() { Venevus_OnPoisonAllAgain(); } // poison_all_again
	void OnSelectRandomSpell() { Venevus_OnSelectRandomSpell(); } // select_random_spell
	void OnSetupSpell() { Venevus_OnSetupSpell(); } // setup_spell
	void OnCastspell() { Venevus_OnCastspell(); } // castspell
	void OnResetLightning() { Venevus_OnResetLightning(); } // reset_lightning
	void OnResetAcidBolt() { Venevus_OnResetAcidBolt(); } // reset_acid_bolt
	void OnStopSpotting() { Venevus_OnStopSpotting(); } // stop_spotting
	void OnResetPoisonSite() { Venevus_OnResetPoisonSite(); } // reset_poison_site
	void OnSpotTargets() { Venevus_OnSpotTargets(); } // spot_targets
	void OnThrowLightning() { Venevus_OnThrowLightning(); } // throw_lightning
	void OnThrowAcidBolt() { Venevus_OnThrowAcidBolt(); } // throw_acid_bolt
	void OnResetBoltDelay() { Venevus_OnResetBoltDelay(); } // reset_bolt_delay
	string OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "") { return Venevus_OnGameDodamage(hit, target, start, end, damageType, damageText); } // game_dodamage
	void OnCycleMove() { Venevus_OnCycleMove(); } // cycle_move
	void OnGameOver() { Venevus_OnGameOver(); } // game_over
	void OnResetActiveVolcano() { Venevus_OnResetActiveVolcano(); } // reset_active_volcano
	string OnGameDamaged(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float accuracyRoll = 0.0f, CBaseEntity@ inflictor = null, string skill = "") { return Venevus_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill); } // game_damaged
	void OnCheckIfSploited() { Venevus_OnCheckIfSploited(); } // check_if_sploited
	void OnKillAPlayer() { Venevus_OnKillAPlayer(); } // kill_a_player
	void OnScanForDeath() { Venevus_OnScanForDeath(); } // scan_for_death
	void OnMurderReturn() { Venevus_OnMurderReturn(); } // murder_return
	void OnMurderDone() { Venevus_OnMurderDone(); } // murder_done
	void OnKillTarget() { Venevus_OnKillTarget(); } // kill_target
	void OnStuckChecks() { Venevus_OnStuckChecks(); } // stuck_checks
	void OnInitBeam() { Venevus_OnInitBeam(); } // init_beam
	void OnDieFast() { Venevus_OnDieFast(); } // die_fast
	void OnPoisonAllFreq() {} // POISON_ALL_FREQ
	void OnSpellFreq() {} // SPELL_FREQ
	void OnVolcanoDuration() {} // VOLCANO_DURATION
	void OnDoAleIntro() {} // do_ale_intro

	// This file's events and timers by their .script names
	bool Venevus_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "castspell") { OnCastspell(); return true; }
		if (name == "check_if_sploited") { OnCheckIfSploited(); return true; }
		if (name == "cycle_move") { OnCycleMove(); return true; }
		if (name == "die_fast") { OnDieFast(); return true; }
		if (name == "game_damaged") { Return(OnGameDamaged(EntityParam(params, 0), Float(Param(params, 1)), Param(params, 2), Float(Param(params, 3)), EntityParam(params, 4), Param(params, 5))); return true; }
		if (name == "game_death") { OnGameDeath(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_dodamage") { Return(OnGameDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5))); return true; }
		if (name == "game_over") { OnGameOver(); return true; }
		if (name == "green_blast") { OnGreenBlast(); return true; }
		if (name == "init_beam") { OnInitBeam(); return true; }
		if (name == "kill_a_player") { OnKillAPlayer(); return true; }
		if (name == "kill_target") { OnKillTarget(); return true; }
		if (name == "let_mortal_kombat_begin") { OnLetMortalKombatBegin(); return true; }
		if (name == "murder_done") { OnMurderDone(); return true; }
		if (name == "murder_return") { OnMurderReturn(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "poison_all_again") { OnPoisonAllAgain(); return true; }
		if (name == "post_spawn_props") { OnPostSpawnProps(); return true; }
		if (name == "pre_mortal_kombat") { OnPreMortalKombat(); return true; }
		if (name == "reset_acid_bolt") { OnResetAcidBolt(); return true; }
		if (name == "reset_active_volcano") { OnResetActiveVolcano(); return true; }
		if (name == "reset_bolt_delay") { OnResetBoltDelay(); return true; }
		if (name == "reset_lightning") { OnResetLightning(); return true; }
		if (name == "reset_poison_site") { OnResetPoisonSite(); return true; }
		if (name == "scan_for_death") { OnScanForDeath(); return true; }
		if (name == "scan_for_intro") { OnScanForIntro(); return true; }
		if (name == "select_random_spell") { OnSelectRandomSpell(); return true; }
		if (name == "setup_spell") { OnSetupSpell(); return true; }
		if (name == "spot_targets") { OnSpotTargets(); return true; }
		if (name == "stop_spotting") { OnStopSpotting(); return true; }
		if (name == "stuck_checks") { OnStuckChecks(); return true; }
		if (name == "throw_acid_bolt") { OnThrowAcidBolt(); return true; }
		if (name == "throw_lightning") { OnThrowLightning(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "bloodrose/venevus"]
shared class VenevusScript : BaseNpcScript, Venevus
{
	// Variables every script that includes this file declares
	bool AM_GENERIC = false;

	// Variables declared by included files, with the value they start with in this script
	VenevusScript()
	{
		ANIM_RUN = "walk";
		ANIM_WALK = "walk";
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/venevus.mdl");
		Precache("lgtning.spr");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		Venevus_FirstThink();
		BaseNpc_FirstThink();
		MonstersExternals_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return Venevus_DispatchEvent(name, params)
			|| BaseNpcScript::DispatchEvent(name, params);
	}
}
