class "ve_cinematic_tools"
local table = [[
{
	"CharacterLighting": {
	  "CharacterLightEnable": "true",
	  "FirstPersonEnable": "true",
	  "LockToCameraDirection": "true",
	  "CameraUpRotation": "20.0",
	  "CharacterLightingMode": "1",
	  "BlendFactor": "0.079999998211861",
	  "TopLight": "(1.0, 1.0, 1.0)",
	  "BottomLight": "(1.0, 1.0, 1.0)",
	  "TopLightDirX": "122.94499969482",
	  "TopLightDirY": "0.0"
	},
	"ColorCorrection": {
	  "Enable": "false",
	  "Brightness": "(1.0, 1.0, 1.0)",
	  "Contrast": "(1.2000000476837, 1.2000000476837, 1.2000000476837)",
	  "Saturation": "(0.64999997615814, 0.64999997615814, 0.69999998807907)",
	  "Hue": "0.0",
	  "ColorGradingEnable": "false"
	},
	"Dof": {
	  "Enable": "false",
	  "FocusDistance": "5.0",
	  "BlurFilter": "4",
	  "BlurFilterDeviation": "3.0",
	  "NearDistanceScale": "0.30000001192093",
	  "FarDistanceScale": "2.5",
	  "Scale": "1.0",
	  "BlurAdd": "0.0",
	  "DiffusionDofEnable": "false",
	  "DiffusionDofAperture": "5.0",
	  "DiffusionDofFocalLength": "0.20000000298023"
	},
	"DynamicAO": {
	  "Enable": "true",
	  "SsaoFade": "1.0",
	  "SsaoRadius": "1.0",
	  "SsaoMaxDistanceInner": "1.0",
	  "SsaoMaxDistanceOuter": "1.0",
	  "HbaoRadius": "25.0",
	  "HbaoAngleBias": "0.0",
	  "HbaoAttenuation": "2.0199999809265",
	  "HbaoContrast": "1.0",
	  "HbaoMaxFootprintRadius": "0.10000000149012",
	  "HbaoPowerExponent": "1.0"
	},
	"Enlighten": {
	  "Enable": "true",
	  "BounceScale": "0.29699999094009",
	  "SunScale": "2.2679998874664",
	  "TerrainColor": "(0.12899999320507, 0.14200000464916, 0.11999999731779)",
	  "CullDistance": "-1.0",
	  "SkyBoxEnable": "true",
	  "SkyBoxSkyColor": "(0.039000000804663, 0.1410000026226, 0.34900000691414)",
	  "SkyBoxGroundColor": "(0.11200000345707, 0.12999999523163, 0.098999999463558)",
	  "SkyBoxSunLightColor": "(3.0, 2.8980000019073, 2.7000000476837)",
	  "SkyBoxSunLightColorSize": "0.29699999094009",
	  "SkyBoxBackLightColor": "(0.29300001263618, 0.28999999165535, 0.24699999392033)",
	  "SkyBoxBackLightColorSize": "1.0",
	  "SkyBoxBackLightRotationX": "309.39300537109",
	  "SkyBoxBackLightRotationY": "3.7379999160767"
	},
	"FilmGrain": {
	  "Enable": "false",
	  "TextureScale": "(11.0, 11.0)",
	  "ColorScale": "(0.10000000149012, 0.10000000149012, 0.10000000149012)",
	  "LinearFilteringEnable": "false",
	  "RandomEnable": "true"
	},
	"Fog": {
	  "Enable": "true",
	  "FogDistanceMultiplier": "1.0",
	  "FogGradientEnable": "true",
	  "Start": "0.0",
	  "EndValue": "9000.0",
	  "Curve": "(1.6225094795227, -3.6395497322083, 2.6569254398346, -0.006206919439137)",
	  "FogColorEnable": "false",
	  "FogColor": "(0.061999998986721, 0.057000000029802, 0.03999999910593)",
	  "FogColorStart": "200.0",
	  "FogColorEnd": "8000.0",
	  "FogColorCurve": "(0.0, 0.0, 1.1084339618683, -0.026385668665171)",
	  "TransparencyFadeStart": "5000.0",
	  "TransparencyFadeEnd": "0.0",
	  "TransparencyFadeClamp": "1.0",
	  "HeightFogEnable": "false",
	  "HeightFogFollowCamera": "0.0",
	  "HeightFogAltitude": "0.0",
	  "HeightFogDepth": "100.0",
	  "HeightFogVisibilityRange": "100.0"
	},
	"LensScope": {
	  "Enable": "false",
	  "BlurScale": "0.9990000128746",
	  "BlurCenter": "(0.5, 0.5)",
	  "ChromaticAberrationColor1": "(0.0, 0.70700001716614, 0.70700001716614)",
	  "ChromaticAberrationColor2": "(0.70700001716614, 0.0, 0.70700001716614)",
	  "ChromaticAberrationStrengths": "(0.20000000298023, 0.20000000298023)",
	  "ChromaticAberrationDisplacement1": "(-0.0020000000949949, 0.0040000001899898)",
	  "ChromaticAberrationDisplacement2": "(0.0060000000521541, 0.0)",
	  "RadialBlendDistanceCoefficients": "(4.0, -0.5)"
	},
	"OutdoorLight": {
	  "Enable": "true",
	  "SunRotationX": "217.0",
	  "SunRotationY": "70.0",
	  "SunColor": "(1.7200000286102, 1.7200000286102, 1.7200000286102)",
	  "SkyColor": "(0.15299999713898, 0.23499999940395, 0.41499999165535)",
	  "GroundColor": "(0.13500000536442, 0.15399999916553, 0.12099999934435)",
	  "SkyLightAngleFactor": "1.0",
	  "SunSpecularScale": "0.0",
	  "SkyEnvmapShadowScale": "1.0",
	  "SunShadowHeightScale": "1.0",
	  "CloudShadowEnable": "true",
	  "CloudShadowSpeed": "(0.0, 0.0)",
	  "CloudShadowSize": "35000.0",
	  "CloudShadowCoverage": "1.0",
	  "CloudShadowExponent": "0.20000000298023",
	  "TranslucencyAmbient": "0.050000000745058",
	  "TranslucencyScale": "0.0",
	  "TranslucencyPower": "8.0",
	  "TranslucencyDistortion": "0.10000000149012"
	},
	"Sky": {
	  "Enable": "true",
	  "BrightnessScale": "1.1799999475479",
	  "SunSize": "0.014999999664724",
	  "SunScale": "0.20000000298023",
	  "PanoramicUVMinX": "0.0",
	  "PanoramicUVMaxX": "1.0",
	  "PanoramicUVMinY": "0.0",
	  "PanoramicUVMaxY": "1.0",
	  "PanoramicTileFactor": "1.0",
	  "PanoramicRotation": "0.013000000268221",
	  "CloudLayerSunColor": "(3.0, 2.8980000019073, 2.6979999542236)",
	  "CloudLayer1Altitude": "5000.0",
	  "CloudLayer1TileFactor": "0.20999999344349",
	  "CloudLayer1Rotation": "53.701999664307",
	  "CloudLayer1Speed": "0.0040000001899898",
	  "CloudLayer1SunLightIntensity": "3.0",
	  "CloudLayer1SunLightPower": "0.0",
	  "CloudLayer1AmbientLightIntensity": "8.0200004577637",
	  "CloudLayer1Color": "(1.0, 1.0, 1.0)",
	  "CloudLayer1AlphaMul": "0.0",
	  "CloudLayer2Altitude": "5000000.0",
	  "CloudLayer2TileFactor": "0.60000002384186",
	  "CloudLayer2Rotation": "237.07299804688",
	  "CloudLayer2Speed": "0.0080000003799796",
	  "CloudLayer2SunLightIntensity": "0.0",
	  "CloudLayer2SunLightPower": "0.0",
	  "CloudLayer2AmbientLightIntensity": "0.0",
	  "CloudLayer2Color": "(1.0, 1.0, 1.0)",
	  "CloudLayer2AlphaMul": "0.30000001192093",
	  "StaticEnvmapScale": "1.0",
	  "SkyEnvmap8BitTexScale": "0.25",
	  "CustomEnvmapScale": "1.0",
	  "CustomEnvmapAmbient": "0.050000000745058",
	  "SkyVisibilityExponent": "1.0"
	},
	"SunFlare": {
	  "Enable": "true",
	  "DebugDrawOccluder": "false",
	  "OccluderSize": "300.0",
	  "Element1Enable": "true",
	  "Element1RayDistance": "0.0",
	  "Element1Size": "(0.5, 0.5)",
	  "Element1SizeOccluderCurve": "(0.0, 0.0, -2.9710140228271, 3.5614490509033)",
	  "Element1SizeScreenPosCurve": "(0.0, 0.0, -0.46814399957657, 1.0458450317383)",
	  "Element1AlphaOccluderCurve": "(-0.16971899569035, -0.20320600271225, -0.13099400699139, 0.59626001119614)",
	  "Element1AlphaScreenPosCurve": "(0.0, 0.0, -0.26712301373482, 0.26113000512123)",
	  "Element2Enable": "true",
	  "Element2RayDistance": "0.0",
	  "Element2Size": "(0.5, 0.5)",
	  "Element2SizeOccluderCurve": "(0.0, 0.0, 0.0, 1.0049999952316)",
	  "Element2SizeScreenPosCurve": "(0.0, 0.0, 1.0464459657669, 0.0018579999450594)",
	  "Element2AlphaOccluderCurve": "(0.0, 0.0, -1.1333329677582, 0.10999999940395)",
	  "Element2AlphaScreenPosCurve": "(0.0, 0.0, -0.80561500787735, 0.89616602659225)",
	  "Element3Enable": "true",
	  "Element3RayDistance": "0.0",
	  "Element3Size": "(3.5, 3.5)",
	  "Element3SizeOccluderCurve": "(0.0, 0.0, 0.0, 1.0049999952316)",
	  "Element3SizeScreenPosCurve": "(0.0, 0.0, 0.74308401346207, 0.27843898534775)",
	  "Element3AlphaOccluderCurve": "(0.0, 0.0, -1.0618560314178, 1.0884540081024)",
	  "Element3AlphaScreenPosCurve": "(0.0, 0.0, -1.7658989429474, 2.1739640235901)",
	  "Element4Enable": "true",
	  "Element4RayDistance": "0.25",
	  "Element4Size": "(0.019999999552965, 0.019999999552965)",
	  "Element4SizeOccluderCurve": "(0.0, 0.0, 0.0, 1.0)",
	  "Element4SizeScreenPosCurve": "(0.0, 0.0, 0.0, 1.0299999713898)",
	  "Element4AlphaOccluderCurve": "(2.8459320068359, -6.4186000823975, 2.9373590946198, 0.30000001192093)",
	  "Element4AlphaScreenPosCurve": "(12.467783927917, -26.925582885742, 13.46854019165, 0.2123290002346)",
	  "Element5Enable": "false",
	  "Element5RayDistance": "1.0",
	  "Element5Size": "(0.20000000298023, 0.20000000298023)",
	  "Element5SizeOccluderCurve": "(0.0, 0.0, 0.0, 1.0)",
	  "Element5SizeScreenPosCurve": "(0.0, 0.0, 0.0, 0.81999999284744)",
	  "Element5AlphaOccluderCurve": "(0.0, 0.0, -1.1826930046082, 1.2612500190735)",
	  "Element5AlphaScreenPosCurve": "(0.0, 0.0, -1.6872110366821, 1.8024959564209)"
	},
	"Tonemap": {
	  "TonemapMethod": "2",
	  "MiddleGray": "1.0",
	  "MinExposure": "2.0",
	  "MaxExposure": "2.2999999523163",
	  "ExposureAdjustTime": "0.5",
	  "BloomScale": "(0.070000000298023, 0.050000000745058, 0.0)",
	  "ChromostereopsisEnable": "false",
	  "ChromostereopsisScale": "1.0",
	  "ChromostereopsisOffset": "1.0"
	},
	"Vignette": {
	  "Enable": "true",
	  "Scale": "(0.0, 1.2000000476837)",
	  "Exponent": "1.5",
	  "Color": "(0.0, 0.20000000298023, 0.20000000298023)",
	  "Opacity": "0.80000001192093"
	},
	"Wind": {
	  "WindDirection": "211.25799560547",
	  "WindStrength": "3.0"
	},
    "Name": "CinematicTools",
    "Priority": "10",
    "Visibility": "1"
}
]]

function ve_cinematic_tools:GetPreset()
  return table
end

return ve_cinematic_tools

