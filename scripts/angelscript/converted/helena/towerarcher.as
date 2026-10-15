#pragma context server

// Converted from helena/towerarcher.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_npc_attack.as"

[script "helena/towerarcher"]
class Towerarcher : BaseNpcAttackScript
{
	// Constants
	int ARROW_DAMAGE_LOW = 8;
	int ARROW_DAMAGE_HIGH = 12;

	// Variables (an unset .script variable reads as its own name)
	string SND_STRUCK1 = "body/flesh1.wav";
	string SND_STRUCK2 = "body/flesh2.wav";
	string SND_STRUCK3 = "body/flesh3.wav";
	string SOUND_PAINYELL = "voices/human/male_hit1.wav";
	string SOUND_WARCRY1 = "voices/human/male_guard_shout.wav";
	string SOUND_WARCRY2 = "voices/human/male_guard_shout2.wav";
	string SND_ATTACK1 = "voices/human/male_hit1.wav";
	string SND_ATTACK2 = "voices/human/male_hit2.wav";
	string SND_ATTACK3 = "voices/human/male_hit3.wav";
	string SND_BOW = "weapons/bow/bow.wav";
	string ANIM_ATTACK = "shootorcbow";
	int ATTACK_SPEED = 900;
	int ATTACK_CONE_OF_FIRE = 4;

	// Variables declared by included files, with the value they start with in this script
	Towerarcher()
	{
		SOUND_DEATH = "voices/human/male_die.wav";
		CAN_FLINCH = "1";
		ANIM_RUN = "run";
		ANIM_WALK = "walk";
		MOVE_RANGE = "600";
		ATTACK_RANGE = 1500.0f;
		FLINCH_DELAY = "4";
		CAN_FLEE = "0";
		CAN_HUNT = "1";
		HUNT_AGRO = "1";
	}

	// unnamed block (first think)
	void Towerarcher_FirstThink()
	{
		SND_STRUCK1 = "body/flesh1.wav";
		SND_STRUCK2 = "body/flesh2.wav";
		SND_STRUCK3 = "body/flesh3.wav";
		SOUND_PAINYELL = "voices/human/male_hit1.wav";
		SOUND_WARCRY1 = "voices/human/male_guard_shout.wav";
		SOUND_WARCRY2 = "voices/human/male_guard_shout2.wav";
		SND_ATTACK1 = "voices/human/male_hit1.wav";
		SND_ATTACK2 = "voices/human/male_hit2.wav";
		SND_ATTACK3 = "voices/human/male_hit3.wav";
		SND_BOW = "weapons/bow/bow.wav";
		ANIM_RUN = "run";
		ANIM_WALK = "walk";
		ANIM_ATTACK = "shootorcbow";
		MOVE_RANGE = "600";
		ATTACK_RANGE = 1500.0f;
		ATTACK_SPEED = 900;
		ATTACK_CONE_OF_FIRE = 4; // Cone of fire
		FLINCH_DELAY = "4";
		CAN_FLEE = "0";
		CAN_HUNT = "1";
		HUNT_AGRO = "1";
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		SetHealth(120);
		SetFieldOfView(180);
		SetWidth(32);
		SetHeight(85);
		SetRace("hguard");
		SetName("Watchtower Archer");
		SetRoam(false);
		SetSkillLevel(30);
		SetGold(RandomInt(6, 10));
		SetHearingSensitivity(5);
		SetModel("npc/archer.mdl");
		SetDamageTaken("all", 0.8f);
		SetModelBody(2, 2);
		SetIdleAnim("idle1");
		SetMoveAnim("walk");
		GiveItem("proj_arrow_iron", 30);
		SetStat("parry", 2, 2, 2);
		SetAngle("face", Vector3(0, 90, 0));

		PLAYING_DEAD = "1"; // monsters ignore me cuz they can't hit me
	}

	// grab_arrow
	void OnGrabArrow()
	{
		SetModelBody(3, 1);
	}

	// shoot_arrow
	void OnShootArrow()
	{
		// Deal damage
		float aimAngle = Divide(DistanceTo(ENT_LASTSEEN), 50.0f); // Aim up a bit
		SetAngle("add_view.x", aimAngle);

		int lclAtkdmg = RandomInt(ARROW_DAMAGE_LOW, ARROW_DAMAGE_HIGH);
		// <projectile scriptname> <"view"|(src_origin)> <target|(targ_origin)> <speed> <damage> <cof> <skill|none>
		TossProjectile("proj_arrow_npc", RelativePosition(Vector3(0, 0, 5)), "none", ATTACK_SPEED, lclAtkdmg, ATTACK_CONE_OF_FIRE, "none"); // Converted to use new tossprojectile //greatguys1@FEB2022
		SetModelBody(3, 0); // Hide arrow
		PlaySound(2, 10, SND_BOW);
	}

	// npc_struck
	// Hit by someone
	void OnNpcStruck(float damage = 0.0f)
	{
		SetVolume(10);
		PlayRandomSound(2, SOUND_PAINYELL, SND_STRUCK2, SOUND_PAINYELL);
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("npc/archer.mdl");
		CallEventDelayed(Float(CYCLE_TIME), "hunting_mode_go");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		Towerarcher_FirstThink();
		BaseNpcAttack_FirstThink();
		BaseNpc_FirstThink();
		MonstersExternals_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "grab_arrow") { OnGrabArrow(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "npc_struck") { OnNpcStruck(Float(Param(params, 0))); return true; }
		if (name == "shoot_arrow") { OnShootArrow(); return true; }
		return BaseNpcAttackScript::DispatchEvent(name, params);
	}
}
