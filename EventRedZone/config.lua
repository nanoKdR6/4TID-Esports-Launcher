local sec = 1000
local green = 56108
local grey = 8421504
local red = 16711680
local orange = 16744192
local blue = 2061822
local purple = 11750815

Config = {}
Config.Key = {
    ESC = 322, F1 = 288, F2 = 289, F3 = 170, F5 = 166, F6 = 167, F7 = 168, F8 = 169, F9 = 56, F10 = 57,
    ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, BACKSPACE = 177,
    TAB = 37, Q = 44, W = 32, E = 38, R = 45, T = 245, Y = 246, U = 303, P = 199, ["["] = 39, ["]"] = 40, ENTER = 18,
    CAPS = 137, A = 34, S = 8, D = 9, F = 23, G = 47, H = 74, K = 311, L = 182,
    LEFTSHIFT = 21, Z = 20, X = 73, C = 26, V = 0, B = 29, N = 249, M = 244, [","] = 82, ["."] = 81,
    LEFTCTRL = 36, LEFTALT = 19, SPACE = 22, RIGHTCTRL = 70,
    HOME = 213, PAGEUP = 10, PAGEDOWN = 11, DELETE = 178,
    LEFT = 174, RIGHT = 175, TOP = 27, DOWN = 173,
    NENTER = 201, N4 = 108, N5 = 60, N6 = 107, ["N+"] = 96, ["N-"] = 97, N7 = 117, N8 = 61, N9 = 118
}

Config.Zone = {
    Pos = {
        x = -426.35,
        y = 1140.98,
        z = 325.91
    },
    Blips = {
        Id = 383,
        Color = 45,
        Size = 1.0,
        Text = '<font face="ThaiFont">งานวงแดง</font>'
    },
}

Config.Time = 4 * sec
Config.TimeW = 2 * sec
Config.TimerStart = 60 * 60

Config.Timeonline = {
    { Times = '01:00:00' },
    { Times = '07:00:00' },
    { Times = '13:00:00' },
    { Times = '19:00:00' },
}

Config.itemname = 'dmuncut'
Config.ItemCount = { 1, 1 }
Config.SpawnObjects = 15
Config.stress = false
Config.count = 100000

Config.ItemBonus = {
    {
        ItemName = "goldbar",
        ItemCount = 1,
        Percent = 100
    },
    {
        ItemName = "steelblack",
        ItemCount = 1,
        Percent = 100
    },
    {
        ItemName = "fashioncoin",
        ItemCount = 1,
        Percent = 5
    },
}

Config.Zoneteleport = {
    coords = vector3(360.6199951171875, -591.6599731445312, 43.31999969482422),
    coords2 = vector3(341.6099853515625, -1397.4599609375, 32.5099983215332),
}

function PickedUp()
    TriggerEvent("mythic_progbar:client:progress", {
        name = "PickedUp",
        duration = Config.Time,
        label = "กำลังขุดไอเทมพิเศษ",
        useWhileDead = false,
        canCancel = false,
        controlDisables = {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = false,
        },
        animation = {
            animDict = "melee@large_wpn@streamed_core_fps",
            anim = "ground_attack_on_spot",
        },
    })
end

function NotificationNoinventoryfull()
    TriggerEvent("PorNotify:SendNotification", {
        text = " กระเป้าของคุณเต็ม ",
        layout = "centerLeft",
        type = "alert",
        theme = "gta",
        timeout = 5000,
    })
end
