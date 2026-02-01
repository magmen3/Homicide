// Created by Crowbar 0.74

$modelname "weapons\gleb\c_870.mdl"

$bodygroup "studio"
{
	studio "c_870.smd"
}


$surfaceprop "default"

$contents "solid"

$illumposition -6.714 -3.706 -8.115

$cdmaterials "models\weapons\v_models\shotgun\"

$attachment "1" "body" 0 -22.2 1.5 rotate 0 -90 0
$attachment "2" "body" 0 -6.6 1.2 rotate -5 -160 -180

$cbox 0 0 0 0 0 0

$bbox -10.127 -9.073 -9.944 21.406 7.28 -1.135

$hboxset "default"

$definebone "body" "" -1.94451 -2.498311 -2.991395 0 0 0 0 0 0 0 0 0
$definebone "l-upperarm-movement" "" 6 3.594951 -5.344038 24.346465 -63.264511 -15.811859 0 0 0 0 0 0
$definebone "l-upperarm" "l-upperarm-movement" 0 0 0 12.665866 -35.673214 143.234067 0 0 0 0 0 0
$definebone "l-forearm" "l-upperarm" 9.051098 -0.000001 -0.000001 0.388569 55.909111 15.099042 0 0 0 0 0 0
$definebone "lwrist" "l-forearm" 9.26733 -0.012917 -0.047795 -4.364345 -27.503698 -25.193752 0 0 0 0 0 0
$definebone "l-index-low" "lwrist" 3.720295 0.080504 -0.994914 -14.34429 7.267339 97.439199 0 0 0 0 0 0
$definebone "l-index-mid" "l-index-low" 1.279291 -0.000001 -0.000001 48.61731 0.647863 0.51805 0 0 0 0 0 0
$definebone "l-index-tip" "l-index-mid" 0.769877 0 0 58.8914 0.186807 0.154408 0 0 0 0 0 0
$definebone "l-middle-low" "lwrist" 3.819597 -0.171114 -0.271816 -14.870336 36.606163 77.150654 0 0 0 0 0 0
$definebone "l-middle-mid" "l-middle-low" 1.425536 -0.000006 0 82.16305 174.168349 173.951176 0 0 0 0 0 0
$definebone "l-middle-tip" "l-middle-mid" 0.831717 0.000001 0 -18.024688 -1.280832 1.537663 0 0 0 0 0 0
$definebone "l-ring-low" "lwrist" 3.610807 -0.040065 0.504236 -6.37285 63.57633 65.390715 0 0 0 0 0 0
$definebone "l-ring-mid" "l-ring-low" 1.310056 0.000002 0.000005 84.705725 16.155986 15.415785 0 0 0 0 0 0
$definebone "l-ring-tip" "l-ring-mid" 0.86659 0.000006 0 -23.500155 0.679839 0.344701 0 0 0 0 0 0
$definebone "l-pinky-low" "lwrist" 3.227354 0.282463 1.200264 15.251725 102.141306 64.281451 0 0 0 0 0 0
$definebone "l-pinky-mid" "l-pinky-low" 0.998022 -0.000007 -0.000013 32.522537 4.75023 4.644745 0 0 0 0 0 0
$definebone "l-pinky-tip" "l-pinky-mid" 0.721986 0 0 -27.956903 -0.054696 -0.465744 0 0 0 0 0 0
$definebone "l-thumb-low" "lwrist" 0.9929 0.886229 -0.993035 12.548574 8.698237 176.029616 0 0 0 0 0 0
$definebone "l-thumb-mid" "l-thumb-low" 1.656119 -0.000001 0 3.068824 -5.214657 -1.487959 0 0 0 0 0 0
$definebone "l-thumb-tip" "l-thumb-mid" 1.015353 0.000002 0.000002 -9.703952 1.594776 -1.18601 0 0 0 0 0 0
$definebone "l-forearm-twist" "l-forearm" 7.988214 0.070377 -0.005725 15.400869 86.937469 92.073853 0 0 0 0 0 0
$definebone "r-upperarm-movement" "" -1.261359 9.181879 -3.492088 24.390471 -116.725652 71.293658 0 0 0 0 0 0
$definebone "r-upperarm" "r-upperarm-movement" 0 0 0 -22.704596 -21.509017 159.585061 0 0 0 0 0 0
$definebone "r-forearm" "r-upperarm" 9.051081 0.000013 -0.000005 0.410991 -121.256048 -16.004428 0 0 0 0 0 0
$definebone "r-rist" "r-forearm" 9.26734 0.012915 -0.047796 -41.820371 69.989372 -40.217971 0 0 0 0 0 0
$definebone "r-index-low" "r-rist" 3.720286 -0.080501 -0.994921 3.006876 -29.641341 -96.963196 0 0 0 0 0 0
$definebone "r-index-mid" "r-index-low" 1.279293 0.000003 0 8.618721 -0.432989 -0.096772 0 0 0 0 0 0
$definebone "r-index-tip" "r-index-mid" 0.769871 0 0 33.891405 -0.09775 -0.009624 0 0 0 0 0 0
$definebone "r-pinky-low" "r-rist" 3.227345 -0.282455 1.20026 10.880642 -81.184448 -84.798834 0 0 0 0 0 0
$definebone "r-pinky-mid" "r-pinky-low" 0.998022 0.000003 -0.000013 57.397611 -8.39519 -7.284946 0 0 0 0 0 0
$definebone "r-pinky-tip" "r-pinky-mid" 0.721982 -0.000001 -0.000002 42.042734 0.06545 0.535763 0 0 0 0 0 0
$definebone "r-middle-low" "r-rist" 3.819591 0.171121 -0.271822 0.412757 -81.372149 -88.218191 0 0 0 0 0 0
$definebone "r-middle-mid" "r-middle-low" 1.425534 0.000005 -0.000002 62.787122 -1.190117 -1.540071 0 0 0 0 0 0
$definebone "r-middle-tip" "r-middle-mid" 0.831715 -0.000001 0.000001 31.951803 0.384756 -0.951576 0 0 0 0 0 0
$definebone "r-ring-low" "r-rist" 3.610795 0.04007 0.504236 6.129159 -86.432123 -86.080826 0 0 0 0 0 0
$definebone "r-ring-mid" "r-ring-low" 1.310058 0.000005 0 59.847456 -3.978085 -3.45788 0 0 0 0 0 0
$definebone "r-ring-tip" "r-ring-mid" 0.866595 -0.000007 0.000001 36.497997 -1.045065 -0.55056 0 0 0 0 0 0
$definebone "r-thumb-low" "r-rist" 0.992894 -0.88623 -0.993039 8.424137 -25.126791 154.057772 0 0 0 0 0 0
$definebone "r-thumb-mid" "r-thumb-low" 1.656121 0.000003 0.000002 18.063704 5.619878 1.562908 0 0 0 0 0 0
$definebone "r-thumb-tip" "r-thumb-mid" 1.01535 -0.000004 0.000002 15.290704 -1.075365 1.211921 0 0 0 0 0 0
$definebone "r-forearm-twist" "r-forearm" 7.988234 -0.07038 -0.005727 -14.580463 -85.866208 -92.065903 0 0 0 0 0 0
$definebone "Shell" "" -0.727241 9.352185 -9.657923 0 0 0 0 0 0 0 0 0
$definebone "trigger" "" -1.947479 -4.9878 -2.829453 0 0 0 0 0 0 0 0 0
$definebone "pump." "" -1.94451 -14.081695 -2.722886 0 0 0 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_UpperArm" "r-upperarm" 0 0 0 0 0.000001 0.000003 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Forearm" "r-forearm" 0 0 0 -0.000002 0 -0.000002 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Hand" "r-rist" 0 0 0 -0.000001 -0.000001 -0.000001 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Finger0" "r-thumb-low" 0 0 0 -0.000001 0.000003 -90.000009 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Finger01" "r-thumb-mid" 0 0 0 0.000003 0.000003 -90.000009 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Finger02" "r-thumb-tip" 0 0 0 0.000003 0.000008 -90.000009 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Finger1" "r-index-low" 0 0 0 0.000002 -0.000001 90.000009 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Finger11" "r-index-mid" 0 0 0 0 -0.000001 90.000009 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Finger12" "r-index-tip" 0 0 0 -0.000007 -0.000001 90.000009 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Finger2" "r-middle-low" 0 0 0 -0.000002 -0.000001 90.000003 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Finger21" "r-middle-mid" 0 0 0 0 0.000004 90.000003 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Finger22" "r-middle-tip" 0 0 0 0.000003 0.000005 90.000009 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Finger3" "r-ring-low" 0 0 0 -0.000001 -0.000001 90.000003 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Finger31" "r-ring-mid" 0 0 0 0 0.000003 90.000003 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Finger32" "r-ring-tip" 0 0 0 0.000005 0.000002 90.000003 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Finger4" "r-pinky-low" 0 0 0 -0.000002 0 90.000003 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Finger41" "r-pinky-mid" 0 0 0 0.000005 0.000001 90.000003 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Finger42" "r-pinky-tip" 0 0 0 0.000002 -0.000002 90.000003 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_UpperArm" "l-upperarm" 0 0.000001 0 -0.000003 0 0.000002 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Forearm" "l-forearm" 0 0 0 0 0.000002 -0.000003 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Hand" "lwrist" 0 0 0 -0.000002 0 -180.000005 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Finger0" "l-thumb-low" 0 0 0 0.000001 0 -90.000003 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Finger01" "l-thumb-mid" 0 0 0 0.000002 -0.000002 -90.000003 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Finger02" "l-thumb-tip" 0 0 0 0.000002 -0.000002 -90.000003 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Finger1" "l-index-low" 0 0 0 0.000002 0.000002 90.000003 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Finger11" "l-index-mid" 0 0 0 0.000003 0.000005 90.000003 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Finger12" "l-index-tip" 0 0 0 -0.000009 0.000004 90.000009 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Finger2" "l-middle-low" 0 0 0.000001 0.000008 0.000005 90.000003 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Finger21" "l-middle-mid" 0 0 0 -0.000009 0.000003 90.000009 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Finger22" "l-middle-tip" 0 0 0 -0.000004 0.000004 90.000003 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Finger3" "l-ring-low" 0 0 0 0.000003 0.000005 90.000003 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Finger31" "l-ring-mid" 0 0 0 -0.000002 0.000009 90.000003 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Finger32" "l-ring-tip" -0.000001 0 0 -0.000003 0.000011 90.000003 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Finger4" "l-pinky-low" 0 0 0 -0.000002 0.000002 90.000009 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Finger41" "l-pinky-mid" 0 0 0 0.000002 0.000003 90.000009 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Finger42" "l-pinky-tip" 0 0 0 -0.000008 0.000005 90.000009 0 0 0 0 0 0

$bonemerge "l-upperarm-movement"
$bonemerge "l-upperarm"
$bonemerge "l-forearm"
$bonemerge "lwrist"
$bonemerge "l-index-low"
$bonemerge "l-index-mid"
$bonemerge "l-index-tip"
$bonemerge "l-middle-low"
$bonemerge "l-middle-mid"
$bonemerge "l-middle-tip"
$bonemerge "l-ring-low"
$bonemerge "l-ring-mid"
$bonemerge "l-ring-tip"
$bonemerge "l-pinky-low"
$bonemerge "l-pinky-mid"
$bonemerge "l-pinky-tip"
$bonemerge "l-thumb-low"
$bonemerge "l-thumb-mid"
$bonemerge "l-thumb-tip"
$bonemerge "r-upperarm-movement"
$bonemerge "r-upperarm"
$bonemerge "r-forearm"
$bonemerge "r-rist"
$bonemerge "r-index-low"
$bonemerge "r-index-mid"
$bonemerge "r-index-tip"
$bonemerge "r-pinky-low"
$bonemerge "r-pinky-mid"
$bonemerge "r-pinky-tip"
$bonemerge "r-middle-low"
$bonemerge "r-middle-mid"
$bonemerge "r-middle-tip"
$bonemerge "r-ring-low"
$bonemerge "r-ring-mid"
$bonemerge "r-ring-tip"
$bonemerge "r-thumb-low"
$bonemerge "r-thumb-mid"
$bonemerge "r-thumb-tip"
$bonemerge "ValveBiped.Bip01_R_UpperArm"
$bonemerge "ValveBiped.Bip01_R_Forearm"
$bonemerge "ValveBiped.Bip01_R_Hand"
$bonemerge "ValveBiped.Bip01_R_Finger0"
$bonemerge "ValveBiped.Bip01_R_Finger01"
$bonemerge "ValveBiped.Bip01_R_Finger02"
$bonemerge "ValveBiped.Bip01_R_Finger1"
$bonemerge "ValveBiped.Bip01_R_Finger11"
$bonemerge "ValveBiped.Bip01_R_Finger12"
$bonemerge "ValveBiped.Bip01_R_Finger2"
$bonemerge "ValveBiped.Bip01_R_Finger21"
$bonemerge "ValveBiped.Bip01_R_Finger22"
$bonemerge "ValveBiped.Bip01_R_Finger3"
$bonemerge "ValveBiped.Bip01_R_Finger31"
$bonemerge "ValveBiped.Bip01_R_Finger32"
$bonemerge "ValveBiped.Bip01_R_Finger4"
$bonemerge "ValveBiped.Bip01_R_Finger41"
$bonemerge "ValveBiped.Bip01_R_Finger42"
$bonemerge "ValveBiped.Bip01_L_UpperArm"
$bonemerge "ValveBiped.Bip01_L_Forearm"
$bonemerge "ValveBiped.Bip01_L_Hand"
$bonemerge "ValveBiped.Bip01_L_Finger0"
$bonemerge "ValveBiped.Bip01_L_Finger01"
$bonemerge "ValveBiped.Bip01_L_Finger02"
$bonemerge "ValveBiped.Bip01_L_Finger1"
$bonemerge "ValveBiped.Bip01_L_Finger11"
$bonemerge "ValveBiped.Bip01_L_Finger12"
$bonemerge "ValveBiped.Bip01_L_Finger2"
$bonemerge "ValveBiped.Bip01_L_Finger21"
$bonemerge "ValveBiped.Bip01_L_Finger22"
$bonemerge "ValveBiped.Bip01_L_Finger3"
$bonemerge "ValveBiped.Bip01_L_Finger31"
$bonemerge "ValveBiped.Bip01_L_Finger32"
$bonemerge "ValveBiped.Bip01_L_Finger4"
$bonemerge "ValveBiped.Bip01_L_Finger41"
$bonemerge "ValveBiped.Bip01_L_Finger42"


$sequence "idle" {
	"c_870_anims\idle.smd"
	activity "ACT_VM_IDLE" 1
	fadein 0.2
	fadeout 0.2
	fps 12
}

$sequence "shoot1" {
	"c_870_anims\shoot1.smd"
	activity "ACT_VM_PRIMARYATTACK" 1
	{ event AE_MUZZLEFLASH 0 "357 1" }
	{ event AE_CLIENT_EFFECT_ATTACH 14 "......................." }
	{ event 5004 12 ".........." }
	fadein 0.2
	fadeout 0.2
	snap
	fps 30.32
}

$sequence "shoot2" {
	"c_870_anims\shoot2.smd"
	activity "ACT_VM_PRIMARYATTACK" 1
	{ event AE_MUZZLEFLASH 0 "357 1" }
	{ event AE_CLIENT_EFFECT_ATTACH 14 "......................." }
	{ event 5004 12 "............" }
	fadein 0.2
	fadeout 0.2
	snap
	fps 31.71
}

$sequence "insert" {
	"c_870_anims\insert.smd"
	activity "ACT_VM_RELOAD" 1
	{ event 5004 0 ".............." }
	fadein 0.2
	fadeout 0.2
	snap
	fps 51.21
}

$sequence "after_reload" {
	"c_870_anims\after_reload.smd"
	activity "ACT_SHOTGUN_RELOAD_FINISH" 1
	{ event 5004 10 ".........." }
	fadein 0.2
	fadeout 0.2
	snap
	fps 37.84
}

$sequence "start_reload" {
	"c_870_anims\start_reload.smd"
	activity "ACT_SHOTGUN_RELOAD_START" 1
	{ event 5004 1 "........" }
	fadein 0.2
	fadeout 0.2
	snap
	fps 35.29
}

$sequence "draw" {
	"c_870_anims\draw.smd"
	activity "ACT_VM_DRAW" 1
	{ event 5004 1 "........." }
	fadein 0.2
	fadeout 0.2
	fps 28.13
}
