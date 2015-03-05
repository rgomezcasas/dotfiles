#!/bin/sh -e

PROFILE=Default
CONF_TOOL=gconftool-2
CONF_PATH="/apps/gnome-terminal/profiles/$PROFILE"

$CONF_TOOL -s -t bool "$CONF_PATH/use_theme_colors" false
$CONF_TOOL -s -t bool "$CONF_PATH/bold_color_same_as_fg" false
$CONF_TOOL -s -t bool "$CONF_PATH/scrollback_unlimited" true
$CONF_TOOL -s -t bool "$CONF_PATH/use_custom_default_size" true

$CONF_TOOL -s -t bool "$CONF_PATH/allow_bold" true
$CONF_TOOL -s -t bool "$CONF_PATH/use_system_font" false
$CONF_TOOL -s -t string "$CONF_PATH/font" "Ubuntu Mono derivative Powerline 13"

$CONF_TOOL -s -t int "$CONF_PATH/default_size_columns" 120
$CONF_TOOL -s -t int "$CONF_PATH/default_size_rows" 34

$CONF_TOOL -s -t string "$CONF_PATH/background_type" transparent
$CONF_TOOL -s -t float "$CONF_PATH/background_darkness" 0.995
$CONF_TOOL -s -t string "$CONF_PATH/background_color" \#1B1B1B
$CONF_TOOL -s -t string "$CONF_PATH/foreground_color" \#d3d0c8
$CONF_TOOL -s -t string "$CONF_PATH/bold_color" \#d3d0c8
$CONF_TOOL -s -t string "$CONF_PATH/palette" \#2D2D2D2D2D2D:\#C0D93B243B24:\#A1A1B5B56C6C:\#FFFFCCCC6666:\#20204A4A8787:\#CCCC9999CCCC:\#6666CCCCCCCC:\#F2F2F0F0ECEC:\#747473736969:\#D8BE4E074E07:\#9999CCCC9999:\#FFFFCCCC6666:\#66669999CCCC:\#CCCC9999CCCC:\#6666CCCCCCCC:\#F2F2F0F0ECEC



