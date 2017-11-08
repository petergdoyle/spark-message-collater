#!/bin/sh

# Black        0;30     Dark Gray     1;30
# Red          0;31     Light Red     1;31
# Green        0;32     Light Green   1;32
# Brown/Orange 0;33     Yellow        1;33
# Blue         0;34     Light Blue    1;34
# Purple       0;35     Light Purple  1;35
# Cyan         0;36     Light Cyan    1;36
# Light Gray   0;37     White         1;37

RESET="\033[0m"
BOLD="\033[1m"
YELLOW="\033[38;5;11m"
GREEN="\033[1,32m"
BLUE="\033[1;36m"
VIOLET="\033[1;34m"
RED="\033[1;31m"
ORANGE="\033[0,33m"
# ORANGE=$'\e[33;40m'

function display_info() {
  local msg="$1"
  echo -e $BOLD$BLUE"[info] $msg"$RESET
}

function display_error() {
  local msg="$1"
  echo -e $BOLD$RED"[error] $msg"$RESET
}

function display_warn() {
  local msg="$1"
  echo -e $BOLD$ORANGE"[warn] $msg"$RESET
}

function display_H1() {
  local msg="$1"
  echo -e $BOLD$VIOLET"[info] $msg"$RESET
}

function display_break() {
  echo -e ""
}

function display_command() {
  local cmd="$1"
  echo -e $BOLD$VIOLET"[info] $cmd"$RESET
}
