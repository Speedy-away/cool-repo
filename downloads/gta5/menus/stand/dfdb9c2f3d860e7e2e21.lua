--[[
CollectibleHelper by aaronlink127#0127
    Shows blips on the map for the following collectibles
    - Action Figures
    - Playing Cards
    - Signal Jammers
    - Los Santos Slasher Clues
    - Movie Props (exterior only)
    - LD Organics Product
]]--
util.require_natives("1640181023")

local tunable_base = 262145
local function getTunableValue(offset, type)
    local sg = memory.script_global(tunable_base+offset)
    local read_func = memory["read_%s":format(type ?? "int")]
    assert(read_func ~= nil, "invalid read type in getTunableValue")
    return read_func(sg)
end
local figures = {
    v3(-2557.405, 2315.502, 33.742),
    v3(2487.128, 3759.327, 42.317),
    v3(457.198, 5573.861, 780.184),
    v3(-1280.407, 2549.743, 17.534),
    v3(-107.722, -856.981, 38.261),
    v3(-1050.513, -522.612, 36.634),
    v3(693.306, 1200.583, 344.524),
    v3(2500.654, -389.482, 94.245),
    v3(483.4, -3110.621, 6.627),
    v3(-2169.277, 5192.986, 16.295),
    v3(177.674, 6394.054, 31.376),
    v3(2416.942, 4994.557, 45.239),
    v3(1702.9, 3291, 48.72),
    v3(-600.813, 2088.011, 132.336),
    v3(-3019.793, 41.9486, 10.2924),
    v3(-485.4648, -54.441, 38.9945),
    v3(-1350.785, -1547.089, 4.675),
    v3(379.535, -1509.398, 29.34),
    v3(2548.713, 385.386, 108.423),
    v3(-769.346, 877.307, 203.424),
    v3(-1513.54, 1517.184, 111.305),
    v3(-1023.899, 190.912, 61.282),
    v3(1136.355, -666.404, 57.044),
    v3(3799.76, 4473.048, 6.032),
    v3(1243.588, -2572.136, 42.603),
    v3(219.811, 97.162, 96.336),
    v3(-1545.826, -449.397, 40.318),
    v3(-928.683, -2938.691, 13.059),
    v3(-1647.926, -1094.716, 12.736),
    v3(-2185.939, 4249.814, 48.803),
    v3(-262.339, 4729.229, 137.329),
    v3(-311.701, 6315.024, 31.978),
    v3(3306.444, 5194.742, 17.432),
    v3(1389.886, 3608.834, 35.06),
    v3(852.846, 2166.327, 52.717),
    v3(-1501.96, 814.071, 181.433),
    v3(2634.972, 2931.061, 44.608),
    v3(660.57, 549.947, 129.157),
    v3(-710.626, -905.881, 19.015),
    v3(1207.701, -1479.537, 35.166),
    v3(-90.151, 939.849, 232.515),
    v3(-180.059, -631.866, 48.534),
    v3(-299.634, 2847.173, 55.485),
    v3(621.365, -409.254, -1.308),
    v3(-988.92, -102.669, 40.157),
    v3(63.999, 3683.868, 39.763),
    v3(-688.668, 5829.006, 16.775),
    v3(1540.435, 6323.453, 23.519),
    v3(2725.806, 4142.14, 43.293),
    v3(1297.977, 4306.744, 37.897),
    v3(1189.579, 2641.222, 38.413),
    v3(-440.796, 1596.48, 358.648),
    v3(-2237.557, 249.282, 175.352),
    v3(-1211.932, -959.965, 0.393),
    v3(153.845, -3077.341, 6.744),
    v3(-66.231, -1451.825, 31.164),
    v3(987.982, -136.863, 73.454),
    v3(-507.032, 393.905, 96.411),
    v3(172.1275, -564.1393, 22.145),
    v3(1497.202, -2133.147, 76.302),
    v3(-2958.706, 386.41, 14.434),
    v3(1413.963, 1162.483, 114.351),
    v3(-1648.058, 3018.313, 31.25),
    v3(-1120.2, 4977.292, 185.445),
    v3(1310.683, 6545.917, 4.798),
    v3(1714.573, 4790.844, 41.539),
    v3(1886.644, 3913.758, 32.039),
    v3(543.476, 3074.79, 40.324),
    v3(1408.045, 2157.34, 97.575),
    v3(-3243.858, 996.179, 12.486),
    v3(-1905.566, -709.6311, 8.766),
    v3(-1462.089, 182.089, 54.953),
    v3(86.997, 812.619, 211.062),
    v3(-886.554, -2096.579, 8.699),
    v3(367.684, -2113.475, 16.274),
    v3(679.009, -1522.824, 8.834),
    v3(1667.377, 0.119, 165.118),
    v3(-293.486, -342.485, 9.481),
    v3(462.664, -765.675, 26.358),
    v3(-57.784, 1939.74, 189.655),
    v3(2618.411, 1692.395, 31.9462),
    v3(-1894.554, 2043.517, 140.9093),
    v3(2221.858, 5612.785, 54.0631),
    v3(-551.3712, 5330.728, 73.9861),
    v3(-2171.406, 3441.188, 32.175),
    v3(1848.131, 2700.702, 63.008),
    v3(-1719.602, -232.886, 54.4441),
    v3(-55.3785, -2519.755, 7.2875),
    v3(874.8454, -2163.998, 32.3688),
    v3(-43.6983, -1747.961, 29.2778),
    v3(173.324, -1208.43, 29.6564),
    v3(2936.323, 4620.483, 48.767),
    v3(3514.655, 3754.687, 34.4766),
    v3(656.9, -1046.931, 21.5745),
    v3(-141.1536, 234.8366, 99.0008),
    v3(-1806.68, 427.6159, 131.765),
    v3(-908.9565, -1148.917, 2.3868),
    v3(387.9323, 2570.408, 43.299),
    v3(2399.505, 3062.746, 53.4703),
    v3(2394.721, 3062.689, 51.2379),
}
local jammers = {
    v3(1006.372, -2881.68, 30.422),
    v3(-980.242, -2637.703, 88.528),
    v3(-688.195, -1399.329, 23.331),
    v3(1120.696, -1539.165, 54.871),
    v3(2455.134, -382.585, 112.635),
    v3(793.878, -717.299, 48.083),
    v3(-168.3, -590.153, 210.936),
    v3(-1298.343, -435.8369, 108.129),
    v3(-2276.484, 335.0941, 195.723),
    v3(-667.25, 228.545, 154.051),
    v3(682.561, 567.5302, 153.895),
    v3(2722.561, 1538.103, 85.202),
    v3(758.539, 1273.687, 445.181),
    v3(-3079.258, 768.5189, 31.569),
    v3(-2359.338, 3246.831, 104.188),
    v3(1693.732, 2656.602, 60.84),
    v3(3555.018, 3684.98, 61.27),
    v3(1869.022, 3714.435, 117.068),
    v3(2902.552, 4324.699, 101.106),
    v3(-508.6141, 4426.661, 87.511),
    v3(-104.417, 6227.278, 63.696),
    v3(1607.501, 6437.315, 32.162),
    v3(2792.933, 5993.922, 366.867),
    v3(1720.613, 4822.467, 59.7),
    v3(-1661.01, -1126.742, 29.773),
    v3(-1873.49, 2058.357, 154.407),
    v3(2122.46, 1750.886, 138.114),
    v3(-417.424, 1153.143, 339.128),
    v3(3303.901, 5169.792, 28.735),
    v3(-1005.848, 4852.147, 302.025),
    v3(-306.627, 2824.859, 69.512),
    v3(1660.663, -28.07, 179.137),
    v3(754.647, 2584.067, 133.904),
    v3(-279.9081, -1915.608, 54.173),
    v3(-260.4421, -2411.807, 126.019),
    v3(552.132, -2221.853, 73),
    v3(394.3919, -1402.144, 76.267),
    v3(1609.791, -2243.767, 130.187),
    v3(234.2919, 220.771, 168.981),
    v3(-1237.121, -850.4969, 82.98),
    v3(-1272.732, 317.9532, 90.352),
    v3(0.088, -1002.404, 96.32),
    v3(470.5569, -105.049, 135.908),
    v3(-548.5471, -197.9911, 82.813),
    v3(2581.047, 461.9421, 115.095),
    v3(720.14, 4097.634, 38.075),
    v3(1242.471, 1876.068, 92.242),
    v3(2752.113, 3472.779, 67.911),
    v3(-2191.856, 4292.408, 55.013),
    v3(450.475, 5581.514, 794.0683),
}
local cards = {
    v3(1992.183, 3046.28, 47.125),
    v3(120.38, -1297.669, 28.705),
    v3(79.293, 3704.578, 40.945),
    v3(2937.738, 5325.846, 100.176),
    v3(727.153, 4189.818, 40.476),
    v3(-103.14, 369.008, 112.267),
    v3(99.959, 6619.539, 32.314),
    v3(-282.6689, 6226.274, 31.3554),
    v3(1707.556, 4921.021, 41.865),
    v3(-1581.86, 5204.295, 3.9093),
    v3(10.8264, -1101.157, 29.613),
    v3(1690.043, 3589.014, 35.5883),
    v3(1159.144, -316.5876, 69.5134),
    v3(2341.807, 2571.737, 47.6079),
    v3(-3048.193, 585.2986, 7.7708),
    v3(-3149.707, 1115.83, 20.7216),
    v3(-1840.641, -1235.319, 13.2937),
    v3(810.6056, -2978.741, 5.8116),
    v3(202.2747, -1645.225, 29.7679),
    v3(253.2056, 215.9778, 106.2848),
    v3(-1166.183, -233.9277, 38.262),
    v3(729.9886, 2514.713, 73.1663),
    v3(188.1851, 3076.332, 43.0447),
    v3(3687.914, 4569.073, 24.9397),
    v3(1876.975, 6410.034, 46.5982),
    v3(2121.146, 4784.687, 40.8114),
    v3(900.0845, 3558.156, 33.6258),
    v3(2695.272, 4324.496, 45.6516),
    v3(-1829.428, 798.4049, 138.0583),
    v3(-1203.725, -1558.866, 4.1736),
    v3(-73.2829, -2005.476, 18.2561),
    v3(-1154.201, -527.2959, 31.7117),
    v3(990.0786, -1800.391, 31.3781),
    v3(827.5513, -2158.744, 29.417),
    v3(-1512.08, -103.625, 54.2027),
    v3(-970.7493, 104.3396, 55.0431),
    v3(-428.6815, 1213.905, 325.9329),
    v3(-167.8387, -297.1122, 39.0353),
    v3(2747.322, 3465.12, 55.6336),
    v3(-1103.659, 2714.689, 19.4539),
    v3(549.4841, -189.3053, 54.4369),
    v3(-1287.689, -1118.818, 6.3057),
    v3(1131.428, -982.0297, 46.6521),
    v3(-1028.083, -2746.936, 13.3589),
    v3(-538.5779, -1278.542, 26.3437),
    v3(1326.449, -1651.263, 52.0964),
    v3(183.3252, -685.2661, 42.607),
    v3(1487.846, 1129.2, 114.3005),
    v3(-2305.538, 3387.973, 31.0201),
    v3(-522.632, 4193.459, 193.7517),
    v3(-748.9897, 5599.534, 41.5794),
    v3(-288.0628, 2545.21, 74.4223),
    v3(2565.326, 296.8703, 108.7367),
    v3(-408.2484, 585.783, 124.378),
}
local movie_prop = {
    v3(94.202, -1294.965, 29.067),
    v3(-1010.051, -502.175, 36.493),
    v3(2517.254, 3789.326, 53.698),
    v3(-2349.036, 3270.785, 32.968),
    v3(1165.416, 247.5531, -50.73),
    v3(-41.795, 2873.231, 59.625),
    v3(-1169.573, 4926.988, 223.7279),
}
local ld_product = {
    v3(-1002.254, 130.075, 55.519),
    v3(-1504.595, -36.351, 54.707),
    v3(-1677.41, -443.6646, 39.8968),
    v3(-842.328, -345.95, 38.501),
    v3(-430.64, 288.196, 86.174),
    v3(1575.068, -1732.029, 87.9448),
    v3(-2038.497, 539.83, 109.752),
    v3(-2973.772, 20.3182, 7.4278),
    v3(-3235.982, 1104.414, 2.602),
    v3(-2630.007, 1874.927, 160.251),
    v3(-1875.84, 2027.968, 139.838),
    v3(-1596.847, 3054.303, 33.12),
    v3(1740.868, 3327.709, 41.211),
    v3(1323.174, 3008.294, 44.09),
    v3(1766.628, 3916.891, 34.821),
    v3(2704.12, 3521.006, 61.773),
    v3(3608.93, 3625.699, 40.827),
    v3(2141.796, 4790.276, 40.7243),
    v3(439.911, 6455.761, 36.068),
    v3(1444.224, 6331.349, 23.806),
    v3(-581.923, 5368.024, 70.294),
    v3(497.611, 5606.312, 795.85),
    v3(1384.78, 4288.897, 36.391),
    v3(712.585, 4111.207, 31.65),
    v3(325.916, 4429.151, 64.688),
    v3(-214.4409, 3601.96, 61.6145),
    v3(66.001, 3760.242, 39.943),
    v3(98.651, 3601.149, 39.752),
    v3(-1147.729, 4949.988, 221.278),
    v3(-2511.306, 3613.96, 13.469),
    v3(-1936.931, 3329.973, 33.215),
    v3(2497.993, -429.74, 93.2676),
    v3(3818.776, 4488.587, 4.532),
    v3(96.5449, -255.7652, 47.0503),
    v3(-1393.931, -1445.899, 4.308),
    v3(-929.642, -746.513, 19.752),
    v3(154.263, 1098.689, 231.338),
    v3(2982.726, 6368.5, 2.311),
    v3(-512.5049, -1626.817, 17.4995),
    v3(-56.232, 80.423, 71.868),
    v3(431.973, -2910.015, 6.734),
    v3(664.98, 1284.782, 360.1198),
    v3(-452.9, 1079.414, 327.803),
    v3(-196.239, -2354.753, 9.478),
    v3(248.439, 128.028, 103.099),
    v3(2661.16, 1640.974, 24.654),
    v3(1668.438, -26.473, 184.91),
    v3(-37.931, 1937.999, 189.8),
    v3(-1591.535, 801.656, 186.161),
    v3(2193.213, 5593.691, 53.684),
    v3(1641.563, 2656.195, 54.855),
    v3(-1608.398, 5262.396, 3.966),
    v3(-937.037, -1044.216, 0.436),
    v3(-2200.313, 4237.116, 48.046),
    v3(-1263.321, -367.5901, 44.5355),
    v3(1018.407, 2457.103, 44.758),
    v3(-3091.239, 660.393, 1.701),
    v3(-193.708, 793.051, 197.758),
    v3(987.808, -105.7523, 74.1212),
    v3(-927.8402, -2934.034, 14.1399),
    v3(-1640.297, -3165.138, 40.8515),
    v3(-1011.272, -1491.967, 4.7604),
    v3(343.7568, 946.6004, 204.4755),
    v3(750.829, 196.948, 85.651),
    v3(-331.626, 6285.987, 34.8),
    v3(-311.981, -1626.432, 31.473),
    v3(819.625, -796.649, 35.338),
    v3(132.977, -576.783, 18.278),
    v3(-1442.642, 567.622, 121.601),
    v3(-363.567, 572.64, 127.044),
    v3(-763.812, 705.641, 144.732),
    v3(1902.373, 572.778, 176.627),
    v3(-672.715, 59.853, 61.902),
    v3(43.7134, 2791.532, 57.6598),
    v3(1220.985, 1902.975, 78.0406),
    v3(2517.942, 2615.929, 38.086),
    v3(3455.177, 5510.634, 18.769),
    v3(1500.862, -2513.839, 56.26),
    v3(1467.102, 1096.74, 113.988),
    v3(545.206, 2880.917, 42.441),
    v3(2612.129, 2782.483, 34.102),
    v3(-14.178, 6491.451, 37.251),
    v3(-788.846, -2086.048, 9.164),
    v3(981.079, -2583.384, 10.37),
    v3(964.371, -1811.011, 31.146),
    v3(511.737, -1335.028, 29.488),
    v3(-69.0361, -1229.77, 29.3137),
    v3(202.812, -1758.72, 33.229),
    v3(-328.378, -1372.415, 41.193),
    v3(-1635.991, -1031.127, 13.024),
    v3(955.454, 73.628, 112.592),
    v3(265.722, -1335.354, 36.17),
    v3(-1033.097, -825.029, 19.049),
    v3(-592.9804, -875.5658, 25.5693),
    v3(-246.484, -786.507, 30.531),
    v3(479.364, -574.451, 28.5),
    v3(1098.204, -1528.952, 34.475),
    v3(580.785, -2284.23, 6.491),
    v3(-295.973, -308.098, 9.511),
    v3(-117.05, -1025.36, 27.318),
}
local blaine_county_clues = {
    v3(1111.145, 3144.103, 36.1949),
    v3(-133.8088, 1912.384, 195.3329),
    v3(-679.3479, 5800.79, 15.337),
    v3(1904.175, 4912.89, 46.88321),
}
local blaine_county_final = {
    v3(2898.955, 3654.93, 42.84441),
    v3(2568.3, 1263.647, 42.62333),
    v3(-1568.47, 4423.41, 5.116028),
    v3(-1709.996, 2619.301, 1.110783),
    v3(2437.768, 5835.223, 56.75886),
}
local explr_mode = true
menu.toggle(menu.my_root(), "Explore Mode", {}, 'Essentially a "Spoiler-Free" mode.\nRather than show all collectibles on the map, this will only show very close ones, and flash your map when one is nearby.', function(st) explr_mode = st end, explr_mode)
local dbg = false
local function has_jammer(jam_id)
    if dbg then return false end
    if not util.is_session_started() then return true end
    local stat_id = 28099 + jam_id
    return STATS._GET_PACKED_STAT_BOOL(stat_id, -1)
end
local function has_action_figure(fig_id)
    if dbg then return false end
    if not util.is_session_started() then return true end
    local stat_id = 26811 + fig_id
    return STATS._GET_PACKED_STAT_BOOL(stat_id, -1)
end
local function has_playing_card(card_id)
    if dbg then return false end
    if not util.is_session_started() then return true end
    local stat_id = 26911 + card_id
    return STATS._GET_PACKED_STAT_BOOL(stat_id, -1)
end
local function has_movie_prop(movie_prop_id)
    if dbg then return false end
    if not util.is_session_started() then return true end
    local stat_id = 30230 + movie_prop_id
    return STATS._GET_PACKED_STAT_BOOL(stat_id, -1)
end
local function can_ld_product()
    if dbg then return true end
    if not util.is_session_started() then return false end
    return getTunableValue(32685) == 1
end
local function has_ld_product(prod_id)
    if dbg then return false end
    if not util.is_session_started() then return true end
    local stat_id = 34262 + prod_id
    return STATS._GET_PACKED_STAT_BOOL(stat_id, -1)
end
local function get_blaine_county_progress()
    if dbg then return 5 end
    if not util.is_session_started() then return -1 end
    local stat_id = 28149
    for i=1,5 do
        if not STATS._GET_PACKED_STAT_BOOL(stat_id+i, -1) then
            return i
        end
    end
    return -1
end
local jammer_blips = {}
local figure_blips = {}
local card_blips = {}
local movie_prop_blips = {}
local ld_product_blips = {}
local blaine_county_blip
util.on_stop(function()
    for k, blip in figure_blips do
        util.remove_blip(blip)
    end
    for k, blip in jammer_blips do
        util.remove_blip(blip)
    end
    for k, blip in card_blips do
        util.remove_blip(blip)
    end
    for k, blip in movie_prop_blips do
        util.remove_blip(blip)
    end
    for k, blip in ld_product_blips do
        util.remove_blip(blip)
    end
    if blaine_county_blip then
        util.remove_blip(blaine_county_blip)
    end
end)
local function create_collect_blip(pos,name,sprite,color)
    local blip = HUD.ADD_BLIP_FOR_COORD(v3.get(pos))
    HUD.SET_BLIP_SPRITE(blip, sprite)
    HUD.SET_BLIP_NAME_FROM_TEXT_FILE(blip, name)
    HUD.SET_BLIP_AS_SHORT_RANGE(blip, true)
    HUD.SET_BLIP_COLOUR(blip, color or 2)
    HUD.SET_BLIP_SCALE(blip, 0.8)
    if explr_mode then
        HUD.FLASH_MINIMAP_DISPLAY()
        HUD.SET_BLIP_FLASH_TIMER(blip, 2000)
    end
    return blip
end
local ply_pos = v3()
util.create_tick_handler(function()
    local ped = PLAYER.PLAYER_PED_ID()
    v3.set(ply_pos, ENTITY.GET_ENTITY_COORDS(ped, true))
    local action_figure_lockoff = false
    for k, v in ipairs(figures) do
        local dist = v3.distance(ply_pos, v)
        if action_figure_lockoff and k > 98 then
            break
        end
        if has_action_figure(k-1) or (explr_mode and dist > 120) then
            if figure_blips[k] ~= nil then
                util.remove_blip(figure_blips[k])
                figure_blips[k] = nil
            end
        else
            action_figure_lockoff = k < 99
            if figure_blips[k] == nil and (not explr_mode or dist < 70) then
                figure_blips[k] = create_collect_blip(v,"PIM_ACTIONFIG",671, 2)
            end
        end
    end
    for k, v in ipairs(jammers) do
        local dist = v3.distance(ply_pos, v)
        if has_jammer(k-1) or (explr_mode and dist > 150) then
            if jammer_blips[k] ~= nil then
                util.remove_blip(jammer_blips[k])
                jammer_blips[k] = nil
            end
        else
            if jammer_blips[k] == nil and (not explr_mode or dist < 100) then
                jammer_blips[k] = create_collect_blip(v,"PIM_SIGNAL",769, 1)
            end
        end
    end
    for k, v in ipairs(cards) do
        local dist = v3.distance(ply_pos, v)
        if has_playing_card(k-1) or (explr_mode and dist > 120) then
            if card_blips[k] ~= nil then
                util.remove_blip(card_blips[k])
                card_blips[k] = nil
            end
        else
            if card_blips[k] == nil and (not explr_mode or dist < 70) then
                card_blips[k] = create_collect_blip(v,"PIM_PLAYINGCAR",680, 27)
            end
        end
    end
    for k, v in ipairs(movie_prop) do
        local dist = v3.distance(ply_pos, v)
        if has_movie_prop(k-1) or (explr_mode and dist > 120) then
            if movie_prop_blips[k] ~= nil then
                util.remove_blip(movie_prop_blips[k])
                movie_prop_blips[k] = nil
            end
        else
            if movie_prop_blips[k] == nil then
                movie_prop_blips[k] = create_collect_blip(v,"PIM_FILM_COL",790)
            end
        end
    end
    local cant_ld_product = not can_ld_product()
    util.draw_debug_text(cant_ld_product)
    for k, v in ipairs(ld_product) do
        local dist = v3.distance(ply_pos, v)
        if cant_ld_product or has_ld_product(k-1) or (explr_mode and dist > 120) then
            if ld_product_blips[k] ~= nil then
                util.remove_blip(ld_product_blips[k])
                ld_product_blips[k] = nil
            end
        else
            if ld_product_blips[k] == nil then
                ld_product_blips[k] = create_collect_blip(v,"PIM_ORGANITR",140)
            end
        end
    end
    local blaine_county_progress = get_blaine_county_progress()
    if blaine_county_progress ~= -1 then
        if blaine_county_blip == nil then
            blaine_county_blip = HUD.ADD_BLIP_FOR_COORD(0,0,0)
            HUD.SET_BLIP_SPRITE(blaine_county_blip,484)
            HUD.SET_BLIP_COLOUR(blaine_county_blip, 76)
            HUD.SET_BLIP_NAME_FROM_TEXT_FILE(blaine_county_blip,"SERIALKILLBLIP")
        end
        if blaine_county_progress == 5 then
            local loc = memory.script_local("freemode", 17543+4)
            if loc ~= 0 then
                local finale_pos = memory.read_int(loc)
                HUD.SET_BLIP_COORDS(blaine_county_blip, v3.get(blaine_county_final[finale_pos+1]))
            end
        else
            HUD.SET_BLIP_COORDS(blaine_county_blip, v3.get(blaine_county_clues[blaine_county_progress]))
        end
    elseif blaine_county_blip then
        util.remove_blip(blaine_county_blip)
        blaine_county_blip = nil
    end
end)