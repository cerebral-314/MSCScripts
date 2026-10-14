"""How .script commands, $functions, $get properties and engine events look in AngelScript.

This table is the single source of truth: the transpiler uses it to write call sites, and
`runtime_gen.py` uses it to write the matching wrappers in scripts/angelscript/runtime/.
Each wrapper forwards to the engine's own command/function handler through ScriptHost, so a
converted call behaves exactly like the .script line it replaces.

Commands not listed here are still converted, as LegacyCommand("name", {...}), which is
equally correct but less readable. Add an entry to promote one to a typed wrapper.

Types used below:
  string, int, float, bool, Vector3 - AngelScript types
  entity - an entity reference as .script passes it (an id such as "PentP(4,1234)" or a
           name such as "ent_me"); stored in AngelScript as a string
  text   - trailing words joined with spaces (the handler joins its remaining parameters)
"""

from __future__ import annotations

from dataclasses import dataclass, field


@dataclass
class Param:
    name: str
    type: str
    optional: bool = False


@dataclass
class CommandSpec:
    method: str
    params: list[Param]
    doc: str
    # The .script parameters the command receives are the wrapper parameters in order;
    # a trailing "text" parameter takes all remaining tokens joined by spaces.


def P(spec: str) -> list[Param]:
    """'int channel, float volume, string sound, [float attenuation]' -> params"""
    params = []
    for part in [p.strip() for p in spec.split(",") if p.strip()]:
        optional = part.startswith("[")
        part = part.strip("[]")
        type_, name = part.split()
        params.append(Param(name, type_, optional))
    return params


COMMANDS: dict[str, CommandSpec] = {
    # --- identity, model, appearance ---------------------------------------------------
    "name": CommandSpec("SetName", P("text name"), "Display name; `prefix|name` sets the prefix too"),
    "name_prefix": CommandSpec("SetNamePrefix", P("string prefix"), "Name prefix (a, an, the ...)"),
    "name_unique": CommandSpec("SetUniqueName", P("string name"), "Unique name used by $get_by_name"),
    "desc": CommandSpec("SetDescription", P("text description"), "Description text (max 96 characters)"),
    "race": CommandSpec("SetRace", P("string race"), "Race / faction"),
    "setmodel": CommandSpec("SetModel", P("string model"), "World model (relative to models/)"),
    "setmodelbody": CommandSpec("SetModelBody", P("int group, int submodel"), "Body group"),
    "setworldmodel": CommandSpec("SetWorldModel", P("string model"), "Item world model"),
    "setviewmodel": CommandSpec("SetViewModel", P("string model"), "Item view model"),
    "setpmodel": CommandSpec("SetPlayerModel", P("string model"), "Item model held by players"),
    "setidleanim": CommandSpec("SetIdleAnim", P("string anim"), "Idle animation"),
    "setmoveanim": CommandSpec("SetMoveAnim", P("string anim"), "Movement animation"),
    "setanimext": CommandSpec("SetAnimExtension", P("string torso, [string legs]"), "Player animation extension while held"),
    "sethudsprite": CommandSpec("SetHudSprite", P("string slot, string frame"), "Item HUD sprite (hand|trade)"),
    "width": CommandSpec("SetWidth", P("float width"), "Bounding width"),
    "height": CommandSpec("SetHeight", P("float height"), "Bounding height"),
    "weight": CommandSpec("SetWeight", P("float weight"), "Item weight"),
    "size": CommandSpec("SetSize", P("float size"), "Item size"),
    "value": CommandSpec("SetValue", P("int value"), "Item value in gold"),
    "gravity": CommandSpec("SetGravity", P("float gravity"), "Gravity multiplier"),
    "hp": CommandSpec("SetHealth", P("float health, [float maxHealth]"), "Health (and max health)"),
    "gold": CommandSpec("SetGold", P("int gold"), "Gold carried"),
    "roam": CommandSpec("SetRoam", P("bool roam"), "Wander when idle"),
    "invincible": CommandSpec("SetInvincible", P("bool invincible"), "Ignore damage"),
    "fly": CommandSpec("SetFly", P("bool fly"), "Flying movement"),
    "blood": CommandSpec("SetBlood", P("string color"), "Blood type: red, green or none"),
    "skilllevel": CommandSpec("SetSkillLevel", P("float level"), "Experience granted on kill"),
    "hearingsensitivity": CommandSpec("SetHearingSensitivity", P("float sensitivity"), "How well sounds are heard"),
    "movespeed": CommandSpec("SetMoveSpeed", P("float ratio"), "Movement speed multiplier"),
    "stepsize": CommandSpec("SetStepSize", P("float height"), "Max stair height"),
    "volume": CommandSpec("SetVolume", P("float volume"), "Default sound volume (0-10)"),
    "nopush": CommandSpec("SetNoPush", P("bool noPush"), "Ignore pushes"),
    "setbbox": CommandSpec("SetBoundingBox", P("... box"), "npcsize, animsize or `mins maxs`"),
    "setsolid": CommandSpec("SetSolid", P("string solid"), "none, box, slidebox or trigger"),
    "setalive": CommandSpec("SetAlive", P("bool alive"), "1 revives (fires game_fake_death)"),
    # --- animation -----------------------------------------------------------------------
    "playanim": CommandSpec("PlayAnim", P("... anim"), "`once|hold|loop|critical|break name` (monsters) or `name` (items)"),
    "playowneranim": CommandSpec("PlayOwnerAnim", P("... anim"), "Animation on the item's owner"),
    "playviewanim": CommandSpec("PlayViewAnim", P("int anim"), "View model animation"),
    "setviewmodelprop": CommandSpec("SetViewModelProp", P("entity item, ... prop"), "View model property"),
    # --- movement / position ---------------------------------------------------------------
    "setorigin": CommandSpec("SetOrigin", P("entity target, Vector3 origin"), "Move an entity"),
    "addorigin": CommandSpec("AddOrigin", P("entity target, Vector3 offset"), "Offset an entity's origin"),
    "setvelocity": CommandSpec("SetVelocity", P("entity target, Vector3 velocity, [string override]"), "Velocity (respects nopush unless `override`)"),
    "addvelocity": CommandSpec("AddVelocity", P("entity target, Vector3 velocity, [string override]"), "Add velocity"),
    "setangle": CommandSpec("SetAngle", P("... args"), "`face|view|... value`"),
    "setmovedest": CommandSpec("SetMoveDest", P("... args"), "`none|<target>|<origin> <distance> [flee]`"),
    "setprop": CommandSpec("SetProp", P("entity target, string prop, ... value"), "Raw entity property (pev)"),
    "deleteent": CommandSpec("DeleteEntity", P("entity target, [text how]"), "Remove an entity (optionally fade)"),
    "deleteme": CommandSpec("DeleteMe", P(""), "Remove this entity (fires game_deleted)"),
    "removescript": CommandSpec("RemoveScript", P(""), "Remove this script from the entity"),
    # --- sound -------------------------------------------------------------------------------
    "playsound": CommandSpec("PlaySound", P("int channel, ... args"), "`<channel> [volume] <sound> [attenuation] [pitch]`"),
    "playrandomsound": CommandSpec("PlayRandomSound", P("int channel, ... args"), "`<channel> [volume] <sound> <sound> ...`"),
    "svplaysound": CommandSpec("ServerPlaySound", P("int channel, ... args"), "Server-side sound"),
    "say": CommandSpec("Say", P("... args"), "Speak a sound from npc/"),
    # --- messages ------------------------------------------------------------------------------
    "saytext": CommandSpec("SayText", P("text message"), "Chat bubble text"),
    "infomsg": CommandSpec("InfoMessage", P("entity player, string title, text message"), "Info popup (player or `all`)"),
    "playermessage": CommandSpec("PlayerMessage", P("entity player, text message"), "Message to a player"),
    "rplayermessage": CommandSpec("PlayerMessageRed", P("entity player, text message"), "Red message to a player"),
    "gplayermessage": CommandSpec("PlayerMessageGreen", P("entity player, text message"), "Green message to a player"),
    "bplayermessage": CommandSpec("PlayerMessageBlue", P("entity player, text message"), "Blue message to a player"),
    "yplayermessage": CommandSpec("PlayerMessageYellow", P("entity player, text message"), "Yellow message to a player"),
    "dplayermessage": CommandSpec("PlayerMessageDark", P("entity player, text message"), "Dark message to a player"),
    "consolemsg": CommandSpec("ConsoleMessage", P("entity player, text message"), "Console message to a player"),
    "messageall": CommandSpec("MessageAll", P("string color, text message"), "Message to every player"),
    "helptip": CommandSpec("HelpTip", P("entity player, string tip, string title, ... message"), "Help tip popup"),
    "dbg": CommandSpec("DebugPrint", P("text message"), "Debug output (dev builds)"),
    "debugprint": CommandSpec("DebugPrint", P("text message"), "Debug output (dev builds)"),
    "chatlog": CommandSpec("ChatLog", P("text message"), "Write to the chat log"),
    # --- combat ------------------------------------------------------------------------------
    "dodamage": CommandSpec("DoDamage", P("entity target, ... args"), "`<target|origin> <range|direct> <damage> <hitchance> [type...]`"),
    "xdodamage": CommandSpec("DoDamageEx", P("... args"), "Extended damage (see ms.stx)"),
    "takedmg": CommandSpec("SetDamageTaken", P("string damageType, float ratio"), "Damage-taken multiplier for a type (or `all`)"),
    "applyeffect": CommandSpec("ApplyEffect", P("entity target, string effect, ... params"), "Apply an effect script"),
    "givehp": CommandSpec("GiveHealth", P("... args"), "`[entity] <amount>`"),
    "givemp": CommandSpec("GiveMana", P("... args"), "`[entity] <amount>`"),
    "dmgmulti": CommandSpec("SetDamageMultiplier", P("float ratio"), "Outgoing damage multiplier"),
    "hitmulti": CommandSpec("SetHitMultiplier", P("entity target, float ratio"), "Hit chance multiplier"),
    "cancelattack": CommandSpec("CancelAttack", P(""), "Abort the current attack"),
    "attackprop": CommandSpec("SetAttackProp", P("entity item, int attack, string prop, ... value"), "Item attack property"),
    "setstat": CommandSpec("SetStat", P("string stat, ... value"), "Stat / skill value"),
    # --- creation ------------------------------------------------------------------------------
    "createnpc": CommandSpec("CreateNpc", P("string script, Vector3 origin, ... params"), "Spawn an NPC (fires game_dynamically_created)"),
    "createitem": CommandSpec("CreateItem", P("string script, Vector3 origin, ... params"), "Spawn an item"),
    "giveitem": CommandSpec("GiveItem", P("string item, [int quantity]"), "Give an item to this NPC"),
    "usetrigger": CommandSpec("UseTrigger", P("... targets"), "Fire map triggers"),
    # --- store / menus --------------------------------------------------------------------------
    "addstoreitem": CommandSpec("AddStoreItem", P("string store, string item, ... args"), "`<store> <item> [quantity cost sellratio bundle]`"),
    "menu.open": CommandSpec("OpenMenu", P("entity player"), "Open this NPC's menu for a player"),
    "menu.autoopen": CommandSpec("SetMenuAutoOpen", P("bool autoOpen"), "Open the menu when used"),
    "catchspeech": CommandSpec("CatchSpeech", P("string event, ... phrases"), "Run <event> when a player says one of the words"),
    # --- quests / misc -----------------------------------------------------------------------------
    "quest": CommandSpec("Quest", P("string action, entity player, ... args"), "`set|unset|clear <player> <name> [data]`"),
    "servercmd": CommandSpec("ServerCommand", P("text command"), "Run a server console command"),
    "clientcmd": CommandSpec("ClientCommand", P("entity player, text command"), "Run a client console command"),
    "precachefile": CommandSpec("PrecacheFile", P("... script"), "Precache another script's resources"),
    # --- effects (multi-format commands keep their arguments as text) ---------------------------
    "cleffect": CommandSpec("ClientEffect", P("... args"), "Client effect (see Scripting_AllDocs.txt)"),
    "clientevent": CommandSpec("ClientEvent", P("string action, entity target, ... args"),
                               "new|update|persist|remove <target|all> <script|id> [event] [params]"),
    "effect": CommandSpec("Effect", P("... args"), "Server-side effect: beam, tempent, screenshake, screenfade, glow, decal"),
    "clearfx": CommandSpec("ClearEffects", P(""), "Remove every applied effect"),
    "setenv": CommandSpec("SetEnvironment", P("string prop, ... value"), "World environment (client)"),
    "sound.play3d": CommandSpec("PlaySound3D", P("string sound, float volume, Vector3 origin, ... args"),
                                "<sound> <volume> <origin> [attenuation] [channel] [pitch]"),
    "playmp3": CommandSpec("PlayMusic", P("entity player, string mode, ... file"), "<player|all> <system|combat|stop> <file>"),
    "hud.addstatusicon": CommandSpec("AddStatusIcon", P("entity player, ... args"), "<icon> <name> <duration> [tga]"),
    # --- NPC behaviour ----------------------------------------------------------------------------
    "saytextrange": CommandSpec("SetSayTextRange", P("... range"), "Range at which speech is heard (or default)"),
    "tossprojectile": CommandSpec("TossProjectile", P("string projectile, ... args"),
                                  "<projectile> <view|origin> <target|origin|none> <speed> <damage> <cof> <skill|none>"),
    "offer": CommandSpec("Offer", P("entity target, ... what"), "Give a target an item or gold <amount>"),
    "recvoffer": CommandSpec("ReceiveOffer", P("string response"), "accept, reject or decline the current offer"),
    "setanim.framerate": CommandSpec("SetAnimFrameRate", P("float rate"), "Animation playback rate"),
    "setanim.movespeed": CommandSpec("SetAnimMoveSpeed", P("float speed"), "Movement speed of the current animation"),
    "setcallback": CommandSpec("SetCallback", P("string callback, string state"), "touch|think|blocked|render enable|disable"),
    "setmonsterclip": CommandSpec("SetMonsterClip", P("bool obey"), "Obey monster clip brushes"),
    "fov": CommandSpec("SetFieldOfView", P("float fov"), "Field of view"),
    "look": CommandSpec("Look", P("... args"), "Look for targets"),
    "npcmove": CommandSpec("NpcMove", P("entity target"), "Test/perform a move using reg.npcmove.* (results in game.ret.npcmove.*)"),
    "scriptflags": CommandSpec("ScriptFlags", P("entity target, ... args"), "add|edit|remove|cleartype|clearall|remove_expired ..."),
    "registerrace": CommandSpec("RegisterRace", P(""), "Register a race from reg.race.*"),
    "registertitle": CommandSpec("RegisterTitle", P("... args"), "<name> [skills]"),
    "menuitem.register": CommandSpec("RegisterMenuItemLocals", P(""), "Register a menu item from reg.mitem.*"),
    # --- items ------------------------------------------------------------------------------------
    "sethand": CommandSpec("SetHand", P("string hand"), "left, right, any, both or undroppable"),
    "splayviewanim": CommandSpec("PlayItemViewAnim", P("entity item, int anim"), "View animation of a specific item"),
    "registerattack": CommandSpec("RegisterAttack", P(""), "Register an attack from reg.attack.*"),
    "wearable": CommandSpec("SetWearable", P("... args"), "<0|1> <slot;slot...>"),
    "groupable": CommandSpec("SetGroupable", P("int count"), "Item stacks in multiples of this"),
    "setdmg": CommandSpec("SetDamageInfo", P("string field, ... value"), "hit|dmg|type <value> while handling damage"),
    "setwearpos": CommandSpec("SetWearPosition", P("... args"), "<position> <slots>"),
    "callclitemevent": CommandSpec("CallClientItemEvent", P("entity item, string event, ... params"), "Event on the owner's client copy of an item"),
    # --- named arrays (stored on the entity, addressed by name) -----------------------------------
    "array.create": CommandSpec("ArrayCreate", P("... args"), "[entity] <name>"),
    "array.add": CommandSpec("ArrayAdd", P("... args"), "[entity] <name> <value>"),
    "array.add_unique": CommandSpec("ArrayAddUnique", P("... args"), "[entity] <name> <value>"),
    "array.set": CommandSpec("ArraySet", P("... args"), "[entity] <name> <index> <value>"),
    "array.del": CommandSpec("ArrayRemoveAt", P("... args"), "[entity] <name> <index>"),
    "array.erase": CommandSpec("ArrayErase", P("... args"), "[entity] <name>"),
    "array.clear": CommandSpec("ArrayClear", P("... args"), "[entity] <name>"),
    "g_array.create": CommandSpec("GlobalArrayCreate", P("string name"), "Global named array"),
    "g_array.add": CommandSpec("GlobalArrayAdd", P("string name, ... value"), "Append to a global array"),
    "g_array.set": CommandSpec("GlobalArraySet", P("string name, int index, ... value"), "Set an element of a global array"),
    "g_array.erase": CommandSpec("GlobalArrayErase", P("string name"), "Delete a global array"),
}

# Item scripts: the item's own command replaces the global one with the same name
ITEM_COMMANDS: dict[str, CommandSpec] = {
    "playermessage": CommandSpec("OwnerMessage", P("text message"), "Message to the item's owner"),
    "playermessagecl": CommandSpec("OwnerMessageClient", P("text message"), "Client message to the item's owner"),
}

# Commands that write their result into the variable named by their first parameter
OUTPUT_COMMANDS: dict[str, tuple[str, str]] = {
    "getplayers": ("GetPlayers", "string"),          # ;-list of every player
    "getplayersnb": ("GetActivePlayers", "string"),   # ;-list of players who are not AFK
}

# Commands lowered to plain AngelScript (assignments, control flow) - never wrapped.
NATIVE_COMMANDS = {
    "setvar", "setvard", "setvarg", "local", "const", "add", "subtract", "subract", "multiply", "divide",
    "inc", "incvar", "dec", "decvar", "mod", "capvar", "stradd", "strconc", "vectoradd", "vectormultiply",
    "vectorscale", "vectorset", "callevent", "calleventtimed", "calleventloop", "callexternal", "exitevent",
    "return", "repeatdelay", "if", "if()", "breakloop", "resetloop", "eventname", "precache",
}


@dataclass
class FunctionSpec:
    returns: str
    method: str | None = None      # wrapper name; None = native template
    template: str | None = None    # native AngelScript with {0}, {1}... argument slots
    params: list[str] = field(default_factory=list)   # argument types for the wrapper/template
    doc: str = ""
    components: bool = False       # the engine wants a single vector argument as x,y,z


FUNCTIONS: dict[str, FunctionSpec] = {
    # native math/string/vector
    "$rand": FunctionSpec("int", template="RandomInt({0}, {1})", params=["int", "int"], doc="Inclusive random integer"),
    "$randf": FunctionSpec("float", template="Random({0}, {1})", params=["float", "float"], doc="Random float"),
    "$int": FunctionSpec("int", template="int({0})", params=["float"]),
    "$neg": FunctionSpec("float", template="-{0}", params=["float"]),
    "$vec": FunctionSpec("Vector3", template="Vector3({0}, {1}, {2})", params=["float", "float", "float"]),
    "$vec.x": FunctionSpec("float", template="{0}.x", params=["Vector3"]),
    "$vec.y": FunctionSpec("float", template="{0}.y", params=["Vector3"]),
    "$vec.z": FunctionSpec("float", template="{0}.z", params=["Vector3"]),
    "$vec.pitch": FunctionSpec("float", template="{0}.x", params=["Vector3"]),
    "$vec.yaw": FunctionSpec("float", template="{0}.y", params=["Vector3"]),
    "$vec.roll": FunctionSpec("float", template="{0}.z", params=["Vector3"]),
    "$veclen": FunctionSpec("float", template="{0}.Length()", params=["Vector3"]),
    "$veclen2d": FunctionSpec("float", template="{0}.Length2D()", params=["Vector3"]),
    "$dist": FunctionSpec("float", template="Distance({0}, {1})", params=["Vector3", "Vector3"]),
    "$len": FunctionSpec("int", template="int({0}.length())", params=["string"]),
    "$lcase": FunctionSpec("string", method="ToLowerCase", params=["string"]),
    "$ucase": FunctionSpec("string", method="ToUpperCase", params=["string"]),
    "$stradd": FunctionSpec("string", template="{0} + {1}", params=["string", "string"]),
    "$pass": FunctionSpec("string", template="{0}", params=["string"]),
    # wrappers over the engine's $function handlers (same results as .script)
    "$get_token": FunctionSpec("string", method="GetToken", params=["string", "int"], doc="Entry of a ;-separated list"),
    "$get_token_amt": FunctionSpec("int", method="GetTokenCount", params=["string"], doc="Number of entries in a ;-separated list"),
    "$get_find_token": FunctionSpec("int", method="FindToken", params=["string", "string"], doc="Index of the last matching entry, or -1"),
    "$get_random_token": FunctionSpec("string", method="GetRandomToken", params=["string"]),
    "$get_array": FunctionSpec("string", method="GetArray", params=["string", "string"], doc="Element of this entity's named array"),
    "$get_array_amt": FunctionSpec("int", method="GetArrayCount", params=["string"]),
    "$get_quest_data": FunctionSpec("string", method="GetQuestData", params=["entity", "string"]),
    "$get_by_name": FunctionSpec("entity", method="FindByName", params=["string"]),
    "$get_tsphere": FunctionSpec("string", method="FindInSphere", params=["string", "float"], doc="`;`-list of entity ids in range, or `none`"),
    "$get_ground_height": FunctionSpec("float", method="GroundHeight", params=["Vector3"]),
    "$cansee": FunctionSpec("bool", method="CanSee", params=["string"], doc="Sets ent_lastseen"),
    # One vector: an offset from this entity along its angles. Two: the offset rotated by the
    # given angles, from the world origin. (The engine reads the one-vector form as x,y,z.)
    "$relpos": FunctionSpec("Vector3", method="RelativePosition", params=["Vector3"], components=True,
                            doc="offset from this entity, along its angles"),
    "$relpos/2": FunctionSpec("Vector3", method="RelativePosition", params=["Vector3", "Vector3"],
                              doc="offset rotated by angles, from the world origin"),
    "$relvel": FunctionSpec("Vector3", method="RelativeVelocity", params=["Vector3"], components=True,
                            doc="velocity along this entity's angles"),
    "$relvel/2": FunctionSpec("Vector3", method="RelativeVelocity", params=["Vector3", "Vector3"],
                              doc="velocity along the given angles"),
    "$item_exists": FunctionSpec("string", method="ItemExists", params=["entity", "string"]),
    "$angles": FunctionSpec("float", method="AnglesTo", params=["Vector3", "Vector3"], doc="2D yaw from one point to another"),
    "$dir": FunctionSpec("Vector3", method="DirectionTo", params=["Vector3", "Vector3"]),
    "$get_traceline": FunctionSpec("string", method="TraceLine", params=["Vector3", "Vector3"]),
    "$timestamp": FunctionSpec("string", method="Timestamp", params=[]),
    "$get_takedmg": FunctionSpec("float", method="DamageTakenOf", params=["entity", "string"], doc="Damage-taken multiplier for a type"),
    "$ratio": FunctionSpec("float", method="Ratio", params=["float", "float", "float"], doc="Value between min and max at a 0-1 ratio"),
    "$within_cone2d": FunctionSpec("bool", method="WithinCone2D", params=["Vector3", "Vector3", "Vector3", "float"]),
    "$angles3d": FunctionSpec("Vector3", method="Angles3DTo", params=["Vector3", "Vector3"]),
    "$get_scriptflag": FunctionSpec("string", method="ScriptFlag", params=["entity", "string", "string"]),
    "$sort_entlist": FunctionSpec("string", method="SortEntities", params=["string", "string"]),
    "$left": FunctionSpec("string", method="Left", params=["string", "int"]),
    "$right": FunctionSpec("string", method="Right", params=["string", "int"]),
    "$search_string": FunctionSpec("int", template="{0}.findFirst({1})", params=["string", "string"]),
    "$get_arrayfind": FunctionSpec("int", method="ArrayFind", params=["string", "string"], doc="Index of a value in a named array, or -1"),
    "$g_get_array": FunctionSpec("string", method="GetGlobalArray", params=["string", "string"]),
    "$g_get_array_amt": FunctionSpec("int", method="GetGlobalArrayCount", params=["string"]),
    "$anim_exists": FunctionSpec("int", method="AnimIndex", params=["string"], doc="Sequence index of an animation, or -1"),
    "$can_damage": FunctionSpec("bool", method="CanDamage", params=["entity"]),
    "$map_exists": FunctionSpec("bool", method="MapExists", params=["string"]),
    "$get_insphere": FunctionSpec("string", method="FindOneInSphere", params=["string", "float"]),
    "$get_tbox": FunctionSpec("string", method="FindInBox", params=["string", "float"]),
    "$get_sky_height": FunctionSpec("float", method="SkyHeight", params=["Vector3"]),
    "$anglediff": FunctionSpec("float", method="AngleDifference", params=["float", "float"]),
}

# $get(<entity>, <property>) - typed helpers (ScriptEntity methods); others use GetProp(e, "prop")
GET_PROPERTIES: dict[str, tuple[str, str]] = {
    "id": ("IdOf", "entity"),
    "origin": ("OriginOf", "Vector3"),
    "angles": ("AnglesOf", "Vector3"),
    "velocity": ("VelocityOf", "Vector3"),
    "range": ("RangeTo", "float"),
    "dist": ("DistanceTo", "float"),
    "isalive": ("IsAlive", "bool"),
    "alive": ("IsAlive", "bool"),
    "exists": ("Exists", "bool"),
    "isplayer": ("IsPlayer", "bool"),
    "name": ("NameOf", "string"),
    "index": ("IndexOf", "int"),
    "hp": ("HealthOf", "float"),
    "maxhp": ("MaxHealthOf", "float"),
    "mp": ("ManaOf", "float"),
    "race": ("RaceOf", "string"),
    "owner": ("OwnerOf", "entity"),
    "height": ("HeightOf", "float"),
    "width": ("WidthOf", "float"),
    "itemname": ("ItemNameOf", "string"),
    "scriptname": ("ScriptNameOf", "string"),
    "steamid": ("SteamIdOf", "string"),
    "quantity": ("QuantityOf", "int"),
    "quality": ("QualityOf", "int"),
    "onground": ("IsOnGround", "bool"),
    "inwater": ("IsInWater", "bool"),
    "canattack": ("CanAttack", "bool"),
    "viewangles": ("ViewAnglesOf", "Vector3"),
    "eyepos": ("EyePositionOf", "Vector3"),
    "maxmp": ("MaxManaOf", "float"),
    "gender": ("GenderOf", "string"),
    "is_worn": ("IsWorn", "bool"),
    "inhand": ("IsInHand", "bool"),
    "target": ("TargetOf", "entity"),
    "name.full": ("FullNameOf", "string"),
    "dmgmulti": ("DamageMultiplierOf", "float"),
    "range2d": ("Range2DTo", "float"),
    "speed": ("SpeedOf", "float"),
    "nopush": ("IsNoPush", "bool"),
    "anim.index": ("AnimIndexOf", "int"),
    "active_item": ("ActiveItemOf", "entity"),
    "is_projectile": ("IsProjectile", "bool"),
    "xp": ("ExperienceOf", "float"),
}
# $get(<entity>, <vector property>.<component>) -> helper(entity).component
GET_VECTOR_COMPONENTS = {"origin": "OriginOf", "angles": "AnglesOf", "velocity": "VelocityOf",
                         "viewangles": "ViewAnglesOf", "eyepos": "EyePositionOf"}
COMPONENTS = {"x": "x", "y": "y", "z": "z", "pitch": "x", "yaw": "y", "roll": "z"}
# $get(<entity>, skill.<name>) / stat.<name>
GET_PREFIXED = {"skill.": ("SkillOf", "float"), "stat.": ("StatOf", "float")}
# Two-argument properties: $get(e, prop, arg)
GET_PROPERTIES_ARG: dict[str, tuple[str, str]] = {
    "scriptvar": ("ScriptVarOf", "string"),
    "relationship": ("RelationshipOf", "string"),
    "haseffect": ("HasEffect", "bool"),
    "keydown": ("IsKeyDown", "bool"),
    "attachpos": ("AttachmentPositionOf", "Vector3"),
    "svbonepos": ("BonePositionOf", "Vector3"),
}

# game.* values with a readable accessor; anything else is host.Eval("game....")
BUILTINS: dict[str, tuple[str, str]] = {
    "game.time": ("GameTime()", "float"),
    "game.serverside": ("true", "bool"),
    "game.clientside": ("false", "bool"),
    "game.map.name": ("MapName()", "string"),
    "game.pvp": ("IsPvp()", "bool"),
    "game.players": ("PlayerCount()", "int"),
    "game.playersnb": ("ActivePlayerCount()", "int"),
    "game.monster.origin": ("MyOrigin()", "Vector3"),
    "game.monster.angles": ("MyAngles()", "Vector3"),
    "game.monster.hp": ("MyHealth()", "float"),
    "game.monster.maxhp": ("MyMaxHealth()", "float"),
    "game.item.hand_index": ("ItemHandIndex()", "int"),
    "game.script.last_sent_id": ("LastClientScriptId()", "string"),
}

# Entity names the engine resolves relative to the calling entity (ScriptHost::FindEntity)
ENTITY_NAMES = {
    "ent_me", "ent_owner", "ent_lastseen", "ent_lastheard", "ent_lastspoke", "ent_lastoffered", "ent_lastgave",
    "ent_laststole", "ent_lastused", "ent_laststruck", "ent_laststruckbyme", "ent_lastprojectile",
    "ent_lastcreated", "ent_creationowner", "ent_target", "ent_expowner", "ent_localplayer", "ent_currentplayer",
}


@dataclass
class EventSpec:
    params: list[Param]
    doc: str = ""


def E(spec: str, doc: str = "") -> EventSpec:
    return EventSpec(P(spec), doc)


# Events the engine fires, with the parameters it passes (see the interpreter notes in the review)
ENGINE_EVENTS: dict[str, EventSpec] = {
    "game_spawn": E(""), "spawn": E(""), "game_precache": E(""), "game_death": E(""), "game_predeath": E(""),
    "game_postspawn": E("string title, string damageMultiplier, string healthMultiplier, string params"),
    # createnpc passes its own extra arguments on: what they are depends on the script (data/param_names.json)
    "game_dynamically_created": E(""),
    "game_damaged": E("entity attacker, float damage, string damageType, float accuracyRoll, entity inflictor, string skill",
                      "Return a damage multiplier to scale the damage"),
    "game_damaged_other": E("entity target, float damage, string damageType, string damageEvent"),
    "game_struck": E("float damage"),
    "game_attacked": E("entity attacker, float damage, string damageType"),
    "game_dodamage": E("string hit, entity target, Vector3 start, Vector3 end, string damageType, float damage"),
    "game_heardsound": E("string soundType, Vector3 origin, float dangerRadius"),
    "game_heardtext": E("string text, entity speaker"),
    "game_menu_getoptions": E("entity player"),
    "game_menu_cancel": E("entity player"),
    "game_playerused": E("entity player"),
    "game_touch": E("entity other"),
    "game_blocked": E("entity other"),
    "game_restricted": E("entity player"),
    "game_targeted_by_player": E("entity player"),
    "game_killed_player": E("entity player"),
    "game_gave_player": E("entity player, entity item"),
    "game_projectile_hitnpc": E("entity target"),
    "game_wear": E("string race, string gender, string source"),
    "game_parry": E("entity attacker, float damage, string damageType, float parryRoll, float accuracyRoll, float parryValue"),
    "game_movingto_dest": E("Vector3 angles"),
    "game_learnskill": E("string skill, string subSkill, float value"),
    "game_xpgain": E("float xp, entity monster"),
    "game_hitground": E("float fallVelocity"),
    "game_takedamage": E("entity attacker, entity inflictor, float damage, string damageType"),
    "game_protect": E("entity attacker, float damage, string damageType"),
    # passed by whatever fires it (use triggers, other scripts): named in data/param_names.json
    "game_activate": E(""),
}
