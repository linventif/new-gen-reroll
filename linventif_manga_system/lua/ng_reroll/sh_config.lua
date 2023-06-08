// -- // -- // -- // -- // -- // -- // -- //
//                                        //
//           General Settings             //
//                                        //
// -- // -- // -- // -- // -- // -- // -- //

// General Settings
NGReroll.Config.Language = "french" // Language (french) you can add your own language in sh_language.lua
NGReroll.Config.Admin = { // Admins
    ["superadmin"] = true,
    ["admin"] = true
}

// NPC Settings
NGReroll.Config.NPCName = "Reroll" // Name of the NPC
NGReroll.Config.ModelPath = "models/Humans/Group02/Female_03.mdl" // Path of the model of the NPC
NGReroll.Config.SoundPath = "vo/npc/Barney/ba_laugh04.wav" // Path of the sound of the NPC ("" to disable)

// HUD Settings
NGReroll.Config.ShowBar = true // Show the mana bar
NGReroll.Config.BarColor = Color(69, 129, 197) // Color of the mana bar
NGReroll.Config.BarBackColor = Color(50, 92, 139) // Color of the mana bar background
NGReroll.Config.BarBackColor2 = Color(61, 61, 61) // Color of the mana bar background

// Menu Seetings
NGReroll.Config.MenuBackColor = Color(10, 70, 80) // Color of the menu background
NGReroll.Config.MenuBackColorElement = Color(40, 45, 55) // Color of the menu background element
NGReroll.Config.MenuSelectColor = Color(225, 150, 35, 128) // Color of the menu selection
NGReroll.Config.MenuHoverColor = Color(150, 104, 24) // Color of the menu button when the player is hovering
NGReroll.Config.Information = {
    [1] = "Ligne n°1",
    [2] = "Ligne n°2",
    [3] = "Ligne n°3",
    [4] = "Ligne n°4",
    [5] = "Ligne n°5"
}
NGReroll.Config.AdminCommands = { // Admin commands to open the menu
    ["/admin_reroll"] = true,
    ["!admin_reroll"] = true
}
NGReroll.Config.UserCommands = { // User commands to open the menu
    ["/reroll"] = true,
    ["!reroll"] = true
}
NGReroll.Config.AdminActions = { // Admin actions
    ["edit_mana"] = {
        ["name"] = "Modifier la mana",
        ["actif"] = true
    },
    ["set_mana"] = {
        ["name"] = "Définir la mana",
        ["actif"] = true
    },
    ["edit_reroll"] = {
        ["name"] = "Modifier le reroll",
        ["actif"] = true
    },
    ["set_reroll"] = {
        ["name"] = "Définir le reroll",
        ["actif"] = true
    },
    ["set_nature"] = {
        ["name"] = "Modifier la nature",
        ["actif"] = true
    },
    ["inspect"] = {
        ["name"] = "Inspecter",
        ["actif"] = true
    },
    ["delete_data"] = {
        ["name"] = "Supprimer les données",
        ["actif"] = true
    }
}
NGReroll.Config.AdminDefaultValue = {
    ["edit_mana"] = {
        [1] = -1000,
        [2] = -100,
        [3] = 100,
        [4] = 1000
    },
    ["set_mana"] = {
        [1] = 0,
        [2] = 100,
        [3] = 1000,
        [4] = 10000
    },
    ["edit_reroll"] = {
        [1] = -5,
        [2] = -1,
        [3] = 1,
        [4] = 5
    },
    ["set_reroll"] = {
        [1] = 0,
        [2] = 5,
        [3] = 10,
        [4] = 100
    },
    ["set_nature"] = {
        [1] = "soil",
        [2] = "water",
        [3] = "fire",
        [4] = "wind"
    }
}

// Mana Settings
NGReroll.Config.ManaDefault = 100 // Default mana of the player
NGReroll.Config.ManaGiveKill = 10 // Mana given to the player when he kills someone (-1 to disable)
NGReroll.Config.ShakeForce = 3 // Force of the screen shake when the don't have enough mana
NGReroll.Config.ShakeTime = 0.5 // Time of the screen shake when the don't have enough mana
NGReroll.Config.ManaGiveDelay = 300 // Delay between each mana (-1 to disable)
NGReroll.Config.ManaGive = { // Mana given to the player
    ["user"] = 10,
    ["vip"] = 20,
    ["admin"] = 30,
    ["superadmin"] = 40
}
NGReroll.Config.ManaRegenDelay = 5 // Delay between each mana regen (-1 to disable)
NGReroll.Config.ManaRegenDefault = 10 // Default mana regen of the player
NGReroll.Config.ManaRegen = { // Mana regen in percent
    ["user"] = 10,
    ["vip"] = 15,
    ["admin"] = 20,
    ["superadmin"] = 20
}

// Reroll Settings
NGReroll.Config.RerollDefault = 2 // Default reroll of the player
NGReroll.Config.Nature = {
    ["eaudivine"] = {
        ["name"] = "Eau Divine", // Name
        ["drop"] = 15, // Drop Chance (0 - 100)
        ["color"] = Color(138, 85, 36), // Color
        ["level"] = {
            [1] = {
                ["name"] = "Level I", // Name
                ["color"] = Color(138, 85, 36), // Color
                ["mana_min"] = 0, // The minimum mana required to use this level
                ["mana_max"] = 1000, // The maximum mana required to use this level
                ["weapons"] = { // Weapons
                    ["lorazi_eau_1"] = true
                }
            },
            [2] = {
                ["name"] = "Level II",
                ["color"] = Color(172, 106, 44),
                ["mana_min"] = 1000,
                ["mana_max"] = 5000,
                ["weapons"] = {
                    ["lorazi_eau_1"] = true,
                    ["lorazi_eau_2"] = true
                }
            },
            [3] = {
                ["name"] = "Level III",
                ["color"] = Color(199, 120, 46),
                ["mana_min"] = 5001,
                ["mana_max"] = 14999,
                ["weapons"] = {
                    ["lorazi_eau_1"] = true,
                    ["lorazi_eau_2"] = true,
                    ["lorazi_eau_3"] = true
                }
            },
            [4] = {
                ["name"] = "Level IV",
                ["color"] = Color(199, 120, 46),
                ["mana_min"] = 15000,
                ["mana_max"] = 999999,
                ["weapons"] = {
                    ["lorazi_eau_1"] = true,
                    ["lorazi_eau_2"] = true,
                    ["lorazi_eau_3"] = true,
                    ["lorazi_eau_4"] = true
                }
            }
        }
    },
    ["explosion"] = {
        ["name"] = "Explosion", // Name
        ["drop"] = 5, // Drop Chance (0 - 100)
        ["color"] = Color(138, 85, 36), // Color
        ["level"] = {
            [1] = {
                ["name"] = "Level I", // Name
                ["color"] = Color(138, 85, 36), // Color
                ["mana_min"] = 0, // The minimum mana required to use this level
                ["mana_max"] = 1000, // The maximum mana required to use this level
                ["weapons"] = { // Weapons
                    ["lorazi_explosion_1"] = true
                }
            },
            [2] = {
                ["name"] = "Level II",
                ["color"] = Color(172, 106, 44),
                ["mana_min"] = 1000,
                ["mana_max"] = 5000,
                ["weapons"] = {
                    ["lorazi_explosion_1"] = true,
                    ["lorazi_explosion_2"] = true
                }
            },
            [3] = {
                ["name"] = "Level III",
                ["color"] = Color(199, 120, 46),
                ["mana_min"] = 5001,
                ["mana_max"] = 14999,
                ["weapons"] = {
                    ["lorazi_explosion_1"] = true,
                    ["lorazi_explosion_2"] = true,
                    ["lorazi_explosion_3"] = true
                }
            },
            [4] = {
                ["name"] = "Level IV",
                ["color"] = Color(199, 120, 46),
                ["mana_min"] = 15000,
                ["mana_max"] = 999999,
                ["weapons"] = {
                    ["lorazi_explosion_1"] = true,
                    ["lorazi_explosion_2"] = true,
                    ["lorazi_explosion_3"] = true,
                    ["lorazi_explosion_4"] = true
                }
            }
        }
    },
    ["feusacre"] = {
        ["name"] = "Feu Sacré", // Name
        ["drop"] = 15, // Drop Chance (0 - 100)
        ["color"] = Color(138, 85, 36), // Color
        ["level"] = {
            [1] = {
                ["name"] = "Level I", // Name
                ["color"] = Color(138, 85, 36), // Color
                ["mana_min"] = 0, // The minimum mana required to use this level
                ["mana_max"] = 1000, // The maximum mana required to use this level
                ["weapons"] = { // Weapons
                    ["lorazi_feu_1"] = true
                }
            },
            [2] = {
                ["name"] = "Level II",
                ["color"] = Color(172, 106, 44),
                ["mana_min"] = 1000,
                ["mana_max"] = 5000,
                ["weapons"] = {
                    ["lorazi_feu_1"] = true,
                    ["lorazi_feu_2"] = true
                }
            },
            [3] = {
                ["name"] = "Level III",
                ["color"] = Color(199, 120, 46),
                ["mana_min"] = 5001,
                ["mana_max"] = 14999,
                ["weapons"] = {
                    ["lorazi_feu_1"] = true,
                    ["lorazi_feu_2"] = true,
                    ["lorazi_feu_3"] = true
                }
            },
            [4] = {
                ["name"] = "Level IV",
                ["color"] = Color(199, 120, 46),
                ["mana_min"] = 15000,
                ["mana_max"] = 999999,
                ["weapons"] = {
                    ["lorazi_feu_1"] = true,
                    ["lorazi_feu_3"] = true,
                    ["lorazi_feu_2"] = true,
                    ["lorazi_feu_4"] = true
                }
            }
        }
    },
    ["desintegration"] = {
        ["name"] = "Désintégration", // Name
        ["drop"] = 1, // Drop Chance (0 - 100)
        ["color"] = Color(138, 85, 36), // Color
        ["level"] = {
            [1] = {
                ["name"] = "Level I", // Name
                ["color"] = Color(138, 85, 36), // Color
                ["mana_min"] = 0, // The minimum mana required to use this level
                ["mana_max"] = 1000, // The maximum mana required to use this level
                ["weapons"] = { // Weapons
                    ["lorazi_foudre_1"] = true
                }
            },
            [2] = {
                ["name"] = "Level II",
                ["color"] = Color(172, 106, 44),
                ["mana_min"] = 1000,
                ["mana_max"] = 5000,
                ["weapons"] = {
                    ["lorazi_foudre_1"] = true,
                    ["lorazi_foudre_2"] = true
                }
            },
            [3] = {
                ["name"] = "Level III",
                ["color"] = Color(199, 120, 46),
                ["mana_min"] = 5001,
                ["mana_max"] = 14999,
                ["weapons"] = {
                    ["lorazi_foudre_1"] = true,
                    ["lorazi_foudre_2"] = true,
                    ["lorazi_foudre_3"] = true
                }
            },
            [4] = {
                ["name"] = "Level IV",
                ["color"] = Color(199, 120, 46),
                ["mana_min"] = 15000,
                ["mana_max"] = 999999,
                ["weapons"] = {
                    ["lorazi_foudre_1"] = true,
                    ["lorazi_foudre_2"] = true,
                    ["lorazi_foudre_3"] = true,
                    ["lorazi_foudre_4"] = true
                }
            }
        }
    },
    ["futur"] = {
        ["name"] = "Futur", // Name
        ["drop"] = 5, // Drop Chance (0 - 100)
        ["color"] = Color(138, 85, 36), // Color
        ["level"] = {
            [1] = {
                ["name"] = "Level I", // Name
                ["color"] = Color(138, 85, 36), // Color
                ["mana_min"] = 0, // The minimum mana required to use this level
                ["mana_max"] = 1000, // The maximum mana required to use this level
                ["weapons"] = { // Weapons
                    ["futur_1"] = true
                }
            },
            [2] = {
                ["name"] = "Level II",
                ["color"] = Color(172, 106, 44),
                ["mana_min"] = 1000,
                ["mana_max"] = 5000,
                ["weapons"] = {
                    ["futur_1"] = true,
                    ["futur_2"] = true
                }
            },
            [3] = {
                ["name"] = "Level III",
                ["color"] = Color(199, 120, 46),
                ["mana_min"] = 5001,
                ["mana_max"] = 14999,
                ["weapons"] = {
                    ["futur_2"] = true,
                    ["futur_1"] = true,
                    ["futur_3"] = true
                }
            },
            [4] = {
                ["name"] = "Level IV",
                ["color"] = Color(199, 120, 46),
                ["mana_min"] = 15000,
                ["mana_max"] = 999999,
                ["weapons"] = {
                    ["futur_2"] = true,
                    ["futur_1"] = true,
                    ["futur_3"] = true,
                    ["futur_5"] = true
                }
            }
        }
    },
    ["muscle"] = {
        ["name"] = "Muscle", // Name
        ["drop"] = 23, // Drop Chance (0 - 100)
        ["color"] = Color(138, 85, 36), // Color
        ["level"] = {
            [1] = {
                ["name"] = "Level I", // Name
                ["color"] = Color(138, 85, 36), // Color
                ["mana_min"] = 0, // The minimum mana required to use this level
                ["mana_max"] = 1000, // The maximum mana required to use this level
                ["weapons"] = { // Weapons
                    ["muscle_1"] = true
                }
            },
            [2] = {
                ["name"] = "Level II",
                ["color"] = Color(172, 106, 44),
                ["mana_min"] = 1000,
                ["mana_max"] = 5000,
                ["weapons"] = {
                    ["muscle_1"] = true,
                    ["muscle_2"] = true
                }
            },
            [3] = {
                ["name"] = "Level III",
                ["color"] = Color(199, 120, 46),
                ["mana_min"] = 5001,
                ["mana_max"] = 14999,
                ["weapons"] = {
                    ["muscle_1"] = true,
                    ["muscle_2"] = true,
                    ["muscle_3"] = true
                }
            },
            [4] = {
                ["name"] = "Level IV",
                ["color"] = Color(199, 120, 46),
                ["mana_min"] = 15000,
                ["mana_max"] = 999999,
                ["weapons"] = {
                    ["muscle_1"] = true,
                    ["muscle_2"] = true,
                    ["muscle_3"] = true,
                    ["muscle_4"] = true
                }
            }
        }
    },
    ["nature"] = {
        ["name"] = "Nature", // Name
        ["drop"] = 23, // Drop Chance (0 - 100)
        ["color"] = Color(138, 85, 36), // Color
        ["level"] = {
            [1] = {
                ["name"] = "Level I", // Name
                ["color"] = Color(138, 85, 36), // Color
                ["mana_min"] = 0, // The minimum mana required to use this level
                ["mana_max"] = 1000, // The maximum mana required to use this level
                ["weapons"] = { // Weapons
                    ["lorazi_nature_1"] = true
                }
            },
            [2] = {
                ["name"] = "Level II",
                ["color"] = Color(172, 106, 44),
                ["mana_min"] = 1000,
                ["mana_max"] = 5000,
                ["weapons"] = {
                    ["lorazi_nature_1"] = true,
                    ["lorazi_nature_2"] = true
                }
            },
            [3] = {
                ["name"] = "Level III",
                ["color"] = Color(199, 120, 46),
                ["mana_min"] = 5001,
                ["mana_max"] = 14999,
                ["weapons"] = {
                    ["lorazi_nature_1"] = true,
                    ["lorazi_nature_2"] = true,
                    ["lorazi_nature_3"] = true
                }
            },
            [4] = {
                ["name"] = "Level IV",
                ["color"] = Color(199, 120, 46),
                ["mana_min"] = 15000,
                ["mana_max"] = 999999,
                ["weapons"] = {
                    ["lorazi_nature_1"] = true,
                    ["lorazi_nature_2"] = true,
                    ["lorazi_nature_3"] = true,
                    ["lorazi_nature_4"] = true
                }
            }
        }
    },
    ["portail"] = {
        ["name"] = "Portail", // Name
        ["drop"] = 15, // Drop Chance (0 - 100)
        ["color"] = Color(138, 85, 36), // Color
        ["level"] = {
            [1] = {
                ["name"] = "Level I", // Name
                ["color"] = Color(138, 85, 36), // Color
                ["mana_min"] = 0, // The minimum mana required to use this level
                ["mana_max"] = 1000, // The maximum mana required to use this level
                ["weapons"] = { // Weapons
                    ["portail_2"] = true
                }
            },
            [2] = {
                ["name"] = "Level II",
                ["color"] = Color(172, 106, 44),
                ["mana_min"] = 1000,
                ["mana_max"] = 5000,
                ["weapons"] = {
                    ["portail_2"] = true,
                    ["portail_1"] = true
                }
            },
            [3] = {
                ["name"] = "Level III",
                ["color"] = Color(199, 120, 46),
                ["mana_min"] = 5001,
                ["mana_max"] = 14999,
                ["weapons"] = {
                    ["portail_2"] = true,
                    ["portail_1"] = true,
                    ["portail_4"] = true
                }
            },
            [4] = {
                ["name"] = "Level IV",
                ["color"] = Color(199, 120, 46),
                ["mana_min"] = 15000,
                ["mana_max"] = 17000,
                ["weapons"] = {
                    ["portail_2"] = true,
                    ["portail_1"] = true,
                    ["portail_4"] = true,
                    ["portail_5"] = true
                }
            },
            [5] = {
                ["name"] = "Level V",
                ["color"] = Color(199, 120, 46),
                ["mana_min"] = 17001,
                ["mana_max"] = 999999,
                ["weapons"] = {
                    ["portail_2"] = true,
                    ["portail_1"] = true,
                    ["portail_4"] = true,
                    ["portail_5"] = true,
                    ["portail_6"] = true
                },
            }
        }
    },
    ["sang"] = {
        ["name"] = "Sang", // Name
        ["drop"] = 1, // Drop Chance (0 - 100)
        ["color"] = Color(138, 85, 36), // Color
        ["level"] = {
            [1] = {
                ["name"] = "Level I", // Name
                ["color"] = Color(138, 85, 36), // Color
                ["mana_min"] = 0, // The minimum mana required to use this level
                ["mana_max"] = 1000, // The maximum mana required to use this level
                ["weapons"] = { // Weapons
                    ["sang_5"] = true
                }
            },
            [2] = {
                ["name"] = "Level II",
                ["color"] = Color(172, 106, 44),
                ["mana_min"] = 1000,
                ["mana_max"] = 5000,
                ["weapons"] = {
                    ["sang_5"] = true,
                    ["sang_4"] = true
                }
            },
            [3] = {
                ["name"] = "Level III",
                ["color"] = Color(199, 120, 46),
                ["mana_min"] = 5001,
                ["mana_max"] = 14999,
                ["weapons"] = {
                    ["sang_5"] = true,
                    ["sang_4"] = true,
                    ["sang_3"] = true
                }
            },
            [4] = {
                ["name"] = "Level IV",
                ["color"] = Color(199, 120, 46),
                ["mana_min"] = 15000,
                ["mana_max"] = 999999,
                ["weapons"] = {
                    ["sang_5"] = true,
                    ["sang_4"] = true,
                    ["sang_3"] = true,
                    ["sang_6"] = true
                }
            }
        }
    },
    ["glacete"] = {
        ["name"] = "Glace Éternelle", // Name
        ["drop"] = 1, // Drop Chance (0 - 100)
        ["color"] = Color(138, 85, 36), // Color
        ["level"] = {
            [1] = {
                ["name"] = "Level I", // Name
                ["color"] = Color(138, 85, 36), // Color
                ["mana_min"] = 0, // The minimum mana required to use this level
                ["mana_max"] = 1000, // The maximum mana required to use this level
                ["weapons"] = { // Weapons
                    ["pact_icedevil_low1"] = true
                }
            },
            [2] = {
                ["name"] = "Level II",
                ["color"] = Color(172, 106, 44),
                ["mana_min"] = 1000,
                ["mana_max"] = 5000,
                ["weapons"] = {
                    ["pact_icedevil_low1"] = true,
                    ["pact_icedevil_low2"] = true
                }
            },
            [3] = {
                ["name"] = "Level III",
                ["color"] = Color(199, 120, 46),
                ["mana_min"] = 5001,
                ["mana_max"] = 14999,
                ["weapons"] = {
                    ["pact_icedevil_low1"] = true,
                    ["pact_icedevil_low2"] = true,
                    ["pact_icedevil_medium1"] = true
                }
            },
            [4] = {
                ["name"] = "Level IV",
                ["color"] = Color(199, 120, 46),
                ["mana_min"] = 15000,
                ["mana_max"] = 17000,
                ["weapons"] = {
                    ["pact_icedevil_low1"] = true,
                    ["pact_icedevil_low2"] = true,
                    ["pact_icedevil_medium1"] = true,
                    ["pact_icedevil_medium2"] = true
                }
            },
            [5] = {
                ["name"] = "Level V",
                ["color"] = Color(199, 120, 46),
                ["mana_min"] = 17001,
                ["mana_max"] = 20000,
                ["weapons"] = {
                    ["pact_icedevil_low1"] = true,
                    ["pact_icedevil_low2"] = true,
                    ["pact_icedevil_medium1"] = true,
                    ["pact_icedevil_medium2"] = true,
                    ["pact_icedevil_strong1"] = true
                }
            },
            [6] = {
                ["name"] = "Level VI",
                ["color"] = Color(199, 120, 46),
                ["mana_min"] = 20000,
                ["mana_max"] = 999999,
                ["weapons"] = {
                    ["pact_icedevil_low1"] = true,
                    ["pact_icedevil_low2"] = true,
                    ["pact_icedevil_medium1"] = true,
                    ["pact_icedevil_medium2"] = true,
                    ["pact_icedevil_strong1"] = true,
                    ["pact_icedevil_strong2"] = true
                }
            }
        }
    },

    ["sismique"] = {
        ["name"] = "Sismique", // Name
        ["drop"] = 1, // Drop Chance (0 - 100)
        ["color"] = Color(138, 85, 36), // Color
        ["level"] = {
            [1] = {
                ["name"] = "Level I", // Name
                ["color"] = Color(138, 85, 36), // Color
                ["mana_min"] = 0, // The minimum mana required to use this level
                ["mana_max"] = 1000, // The maximum mana required to use this level
                ["weapons"] = { // Weapons
                    ["pacte_stone1"] = true
                }
            },
            [2] = {
                ["name"] = "Level II",
                ["color"] = Color(172, 106, 44),
                ["mana_min"] = 1000,
                ["mana_max"] = 5000,
                ["weapons"] = {
                    ["pacte_stone1"] = true,
                    ["pacte_stone2"] = true
                }
            },
            [3] = {
                ["name"] = "Level III",
                ["color"] = Color(199, 120, 46),
                ["mana_min"] = 5001,
                ["mana_max"] = 14999,
                ["weapons"] = {
                    ["pacte_stone1"] = true,
                    ["pacte_stone2"] = true,
                    ["pacte_stone3"] = true
                }
            },
            [4] = {
                ["name"] = "Level IV",
                ["color"] = Color(199, 120, 46),
                ["mana_min"] = 15000,
                ["mana_max"] = 17000,
                ["weapons"] = {
                    ["pacte_stone1"] = true,
                    ["pacte_stone2"] = true,
                    ["pacte_stone3"] = true,
                    ["pacte_stone4"] = true
                }
            },
            [5] = {
                ["name"] = "Level V",
                ["color"] = Color(199, 120, 46),
                ["mana_min"] = 17001,
                ["mana_max"] = 20000,
                ["weapons"] = {
                    ["pacte_stone1"] = true,
                    ["pacte_stone2"] = true,
                    ["pacte_stone3"] = true,
                    ["pacte_stone4"] = true,
                    ["pacte_stone5"] = true
                }
            },
            [6] = {
                ["name"] = "Level VI",
                ["color"] = Color(199, 120, 46),
                ["mana_min"] = 20000,
                ["mana_max"] = 999999,
                ["weapons"] = {
                    ["pacte_stone1"] = true,
                    ["pacte_stone2"] = true,
                    ["pacte_stone3"] = true,
                    ["pacte_stone4"] = true,
                    ["pacte_stone5"] = true,
                    ["pacte_stone6"] = true
                }
            }
        }
    },

    ["enfer"] = {
        ["name"] = "Enfer", // Name
        ["drop"] = 0, // Drop Chance (0 - 100)
        ["color"] = Color(138, 85, 36), // Color
        ["level"] = {
            [1] = {
                ["name"] = "Level I", // Name
                ["color"] = Color(138, 85, 36), // Color
                ["mana_min"] = 0, // The minimum mana required to use this level
                ["mana_max"] = 1000, // The maximum mana required to use this level
                ["weapons"] = { // Weapons
                    ["pouvoir_un"] = true
                }
            },
            [2] = {
                ["name"] = "Level II",
                ["color"] = Color(172, 106, 44),
                ["mana_min"] = 1000,
                ["mana_max"] = 5000,
                ["weapons"] = {
                    ["pouvoir_un"] = true,
                    ["pouvoir_deux"] = true
                }
            },
            [3] = {
                ["name"] = "Level III",
                ["color"] = Color(199, 120, 46),
                ["mana_min"] = 5001,
                ["mana_max"] = 14999,
                ["weapons"] = {
                    ["pouvoir_un"] = true,
                    ["pouvoir_deux"] = true,
                    ["pouvoir_trois"] = true
                }
            },
            [4] = {
                ["name"] = "Level IV",
                ["color"] = Color(199, 120, 46),
                ["mana_min"] = 15000,
                ["mana_max"] = 17000,
                ["weapons"] = {
                    ["pouvoir_un"] = true,
                    ["pouvoir_deux"] = true,
                    ["pouvoir_trois"] = true,
                    ["pouvoir_quatre"] = true
                }
            },
            [5] = {
                ["name"] = "Level V",
                ["color"] = Color(199, 120, 46),
                ["mana_min"] = 17001,
                ["mana_max"] = 20000,
                ["weapons"] = {
                    ["pouvoir_un"] = true,
                    ["pouvoir_deux"] = true,
                    ["pouvoir_trois"] = true,
                    ["pouvoir_quatre"] = true,
                    ["pouvoir_cinque"] = true
                }
            },
            [6] = {
                ["name"] = "Level VI",
                ["color"] = Color(199, 120, 46),
                ["mana_min"] = 20000,
                ["mana_max"] = 999999,
                ["weapons"] = {
                    ["pouvoir_un"] = true,
                    ["pouvoir_deux"] = true,
                    ["pouvoir_trois"] = true,
                    ["pouvoir_quatre"] = true,
                    ["pouvoir_cinque"] = true,
                    ["pouvoir_six"] = true
                }
            }
        }
    }
}

NGReroll.Config.Weapons = { // Weapons Custom Name
    ["weapon_pistol"] = "Pistol",
    ["weapon_357"] = "357",
    ["weapon_smg1"] = "SMG1"
}

/*

    Add this line in the weapon how you want to use the mana
    change cost to the cost of the weapon add minus before cost to give mana

    if !NGRUseWep(self, cost) then return end

    Example for weapon_fists.lua use 100 mana to attack:
        [...]
        function SWEP:PrimaryAttack( right )
            if !NGRUseWep(self, 100) then return end
        [...]

*/