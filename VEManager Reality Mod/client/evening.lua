class "evening"
local table = [[
{
    "CharacterLighting": {
        "CharacterLightEnable": "true",
        "FirstPersonEnable": "true",
        "LockToCameraDirection": "true",
        "CameraUpRotation": "27.482999801636",
        "CharacterLightingMode": "1",
        "BlendFactor": "0.02",
        "TopLight": "1:1:1:",
        "BottomLight": "1:1:1:",
        "TopLightDirX": "0",
        "TopLightDirY": "0.0"
    },
    "ColorCorrection": {
        "Realm": "0",
        "Enable": "true",
        "Brightness": "1:1:1:",
        "Contrast": "1.0:1.0:1.02:",
        "Saturation": "0.7275:0.7725:0.9225:",
        "Hue": "0.0",
        "ColorGradingEnable": "false"
    },
    "DynamicAO": {
        "Realm": "0",
        "Enable": "true",
        "SsaoFade": "1.0",
        "SsaoRadius": "1.0",
        "SsaoMaxDistanceInner": "1.0",
        "SsaoMaxDistanceOuter": "1.0",
        "HbaoRadius": "1.0",
        "HbaoAngleBias": "1.0",
        "HbaoAttenuation": "1.0",
        "HbaoContrast": "1.0",
        "HbaoMaxFootprintRadius": "1",
        "HbaoPowerExponent": "1.0"
    },
    "Enlighten": {
        "Realm": "0",
        "Enable": "false",
        "BounceScale": "0.1",
        "SunScale": "0",
        "TerrainColor": "(0.0, 0.0, 0.0)",
        "CullDistance": "-1.0",
        "SkyBoxEnable": "true",
        "SkyBoxSkyColor": "(0.022000, 0.078000, 0.177000)",
        "SkyBoxGroundColor": "(0.085000, 0.206000, 0.394000)",
        "SkyBoxSunLightColor": "(0.282000, 0.991000, 3.000000)",
        "SkyBoxSunLightColorSize": "0.0",
        "SkyBoxBackLightColor": "(0.022000, 0.078000, 0.177000)",
        "SkyBoxBackLightColorSize": "0.1",
        "SkyBoxBackLightRotationX": "171.95899963379",
        "SkyBoxBackLightRotationY": "26.563999176025"
    },
    "Fog": {
        "Realm": "0",
        "Enable": "true",
        "FogDistanceMultiplier": "1.0",
        "FogGradientEnable": "true",
        "Start": "15",
        "EndValue": "225.0",
        "Curve": "0.4:-0.77:1.3:-0.01:",
        "FogColorEnable": "true",
        "FogColor": "0.02:0.05:0.11:",
        "FogColorStart": "0",
        "FogColorEnd": "5000",
        "FogColorCurve": "6.1:-11.7:5.62:-0.18:",
        "TransparencyFadeStart": "5000",
        "TransparencyFadeEnd": "0",
        "TransparencyFadeClamp": "0.9",
        "HeightFogEnable": "false",
        "HeightFogFollowCamera": "0.0",
        "HeightFogAltitude": "0.0",
        "HeightFogDepth": "100.0",
        "HeightFogVisibilityRange": "100.0"
    },
    "OutdoorLight": {
        "Realm": "0",
        "Enable": "true",
        "SunColor": "(1, 0.16, 0.06)",
        "SkyColor": "(0.3, 0.3, 0.3)",
        "GroundColor": "(0.01, 0.01, 0.01)"
    },
    "Sky": {
        "Realm": "0",
        "Enable": "true",
        "BrightnessScale": "0.3",
        "SunSize": "0.01",
        "SunScale": "15"
    },
    "Tonemap": {
        "Realm": "0",
        "TonemapMethod": "2",
        "MiddleGray": "0.25",
        "MinExposure": "0.8",
        "MaxExposure": "3.5",
        "ExposureAdjustTime": "0.5",
        "BloomScale": "0.3:0.3:0.3:",
        "ChromostereopsisEnable": "false",
        "ChromostereopsisScale": "1.0",
        "ChromostereopsisOffset": "1.0"
    },
    "Wind": {
        "Realm": "0",
        "WindDirection": "211.25799560547",
        "WindStrength": "1.7"
    },
    "Name": "Testing4",
    "Type": "Evening",
    "Priority": "100001",
    "Visibility": "1"
}
]]

function evening:GetPreset()
  return table
end

return evening

