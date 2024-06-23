#!/bin/bash

#############################
#Author: Venkanna
#Date: 21/06/2024
#
#Version: v1
#
#This Script will print no of commits done by the user in the github repository
#############################

#Debug mode is on
set -x
#Handles errors
set -e
set -o pipefail

#Handles undefined variables
set -u

function process_parameters {
  required_params=2
  if [ $# -ne "$required_params" ]; then
  echo "Supplied parameters are not correct"
  echo "Expected arguments ownername & reponame"
  fi
}

process_parameters "$@"

ownername=$1
reponame=$2

username=$user
tokenname=$token

function github_url {
  local endpoint="$1"
  local url="https://api.github.com/repos/${endpoint}"
  curl -u -s "${username}:${tokenname}" "${url}"
}

function process_response {
  local endpoint="${ownername}/${reponame}/commits"
  commits="$(github_url "$endpoint"| jq -r '.[] | {Author: .commit.author.name, CommitDate: .commit.author.date, Message: .commit.message}')"
  if [ -z "$commits" ];
  then
  echo "commits is empty"
  else
  echo "${commits}"
  fi
}

process_response
