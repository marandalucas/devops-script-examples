#!/bin/bash

# colors
red="\033[1;31m"
green="\033[1;32m"
yellow="\033[1;33m"
blue="\033[1;34m"
nc='\033[0m' # No Color

function checkPodStatus () {
	listPods=$(kubectl -n $namespace get po | awk 'NR>1{print $1}')

	for i in ${listPods[@]}
	do
	echo -ne "$i ... "
	status=$(kubectl -n $namespace get po $i | grep $i | awk '{print $3}')
	restart=$(kubectl -n $namespace get po $i | grep $i | awk '{print $4}')
		if [[ $status =~ ^Running$|^Completed$  ]] ; then
			echo -e "${green}OK Running/Completed State!${nc}"
			let running=running+1
			if [[ $restart -gt 0  ]] ; then
				echo -e "${yellow}The previous pod was restarted -> $restart!${nc}"
				let podrestart=podrestart+1
				if [[ $forcerestart == "forcerestart"  ]] ; then
					kubectl -n $namespace delete po --force $i
				fi
			fi
		elif [[ $status =~ ^Evicted$  ]] ; then
			echo -e "${red}FAILED!! Evicted State!${nc}"
			let evicted=evicted+1
		elif [[ $status =~ ^Error$  ]] ; then
			echo -e "${red}FAILED!! Error State!${nc}"
			let error=error+1
		elif [[ $status =~ ^CrashLoopBackOff$  ]] ; then
			echo -e "${red}FAILED!! CrashLoopBackOff State!${nc}"
			let crashloopbackoff=crashloopbackoff+1
		elif [[ $status =~ ^ImagePullBackOff$  ]] ; then
			echo -e "${red}FAILED!! ImagePullBackOff State!${nc}"
			let imagepullbackoff=imagepullbackoff+1
		else
			echo -e "${yellow}FAILED!! $status UNKNOWN STATE!${nc}"
			let unknown=unknown+1
		fi
	done
}

function printPodStatus () {
	echo -e "\nPOD STATUS RESUME:\n"
	echo "+------------------+---------------+---------------+------------------+------------------+---------------+---------------+"
	printf  "|$green%-18s$nc|$red%-15s$nc|$red%-15s$nc|$red%-18s$nc|$red%-18s$nc|$red%-15s$nc|$red%-15s$nc|\n" "Running/Completed" "Evicted" "Error" "CrashLoopBackOff" "ImagePullBackOff" "Podrestart" "Unknown"
	echo "+------------------+---------------+---------------+------------------+------------------+---------------+---------------+"
	printf  "|%-18s|%-15s|%-15s|%-18s|%-18s|%-15s|%-15s|\n" "$running" "$evicted" "$error" "$crashloopbackoff" "$imagepullbackoff" "$podrestart" "$unknown"
	echo "+------------------+---------------+---------------+------------------+------------------+---------------+---------------+"
	echo -e "\n"
}

# Vars
namespace=$1
forcerestart=$2
running=0
evicted=0
error=0
crashloopbackoff=0
imagepullbackoff=0
podrestart=0
unknown=0

echo -e "\nCheking the status of the pods in the namespace -> $namespace:\n"
# Call to Check the Pods Status in a specific namespace
checkPodStatus "$namespace" "$forcerestart"

# Call to Print the Pods Status
printPodStatus