tnConfig = {}

tnConfig.DetectorObject = 'w_am_digiscanner'
tnConfig.DetectorItem = 'metaldetector'

tnConfig.SoundVolume = 0.5
tnConfig.DiggingTime = 6000

tnConfig.Zones = {
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