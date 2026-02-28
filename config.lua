tnConfig = {}

tnConfig.detector = {
    prop = 'w_am_digiscanner',
    item = 'metaldetector',
    animation = {'mini@golf', 'iron_idle_b'}, --when holding the detector
    scenario = 'WORLD_HUMAN_GARDENER_PLANT' --when digging
}

tnConfig.soundVolume = 0.5
tnConfig.diggingTime = 6000

tnConfig.zones = {
    ['banham1'] = {
        radius = 35.0, -- Don't put this under 20.0
        coords = vector3(-3266.0652, 1145.1849, 2.5562),
        items = {
            {name = 'nothing', quantity = 0, chance = 2},
            {name = 'money', quantity = function() return math.random(1, 60) end, chance = 5},
            {name = 'sunglasses', quantity = 1, chance = 4},
            {name = 'advancedlockpick', quantity = 1, chance = 2},
            {name = 'carlockpick', quantity = 1, chance = 2},
        }
    },
    ['banham2'] = {
        radius = 60.0, -- Don't put this under 20.0
        coords = vector3(-3164.5654, 749.4137, 2.7224),
        items = {
            {name = 'nothing', quantity = 0, chance = 2},
            {name = 'money', quantity = function() return math.random(1, 60) end, chance = 5},
            {name = 'sunglasses', quantity = 1, chance = 4},
            {name = 'advancedlockpick', quantity = 1, chance = 2},
            {name = 'carlockpick', quantity = 1, chance = 2},
        }
    },
    ['elburro'] = {
        radius = 55.0, -- Don't put this under 20.0
        coords = vector3(1095.7291, -2648.1765, 8.2946),
        items = {
            {name = 'nothing', quantity = 0, chance = 2},
            {name = 'money', quantity = function() return math.random(1, 60) end, chance = 5},
            {name = 'sunglasses', quantity = 1, chance = 4},
            {name = 'advancedlockpick', quantity = 1, chance = 2},
            {name = 'carlockpick', quantity = 1, chance = 2},
        }
    },
}

tnConfig.strings = {
    not_in_zone = 'Vous n\'êtes pas dans une zone de détection',
    stop_detection = 'Vous avez arrêté la détection',
    near_exit_zone = 'Vous êtes entrain de sortir de la zone de détection',
    exit_zone = 'Vous êtes trop loin de la zone de détection, le détecteur va s\'éteindre',
    switch_weapon = 'Vous avez changé d\'arme, le détecteur va s\'éteindre',
    press_to_dig = 'Appuyez sur ~INPUT_CONTEXT~ pour commencer à creuser',
    digging = 'Fouille...',
    found_nothing = 'Vous n\'avez rien trouvé d\'intéressant'
}