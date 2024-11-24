#!/bin/bash

playerhealth=30
maxplayerhealth=30
monsterhealth=30
playercp=20
playerdamage=0
monsterdamage=0
playercritrate=20
monstercritrate=20
potnum=1
bpotnum=1
kills=0

while [[ 1 -eq 1 ]]; do
	monsterlevel=$(($kills/5))
	monsterhealth=$((30+($monsterlevel*10)))
	monsterdamage=$(($monsterlevel*2))
	if [[ $monstercritrate -gt 10 ]]; then
		monstercritrate=$((20-($monsterlevel*2)))
	fi
	echo "A monster appeared!"
	echo "What will you do?"
	echo "(Attack) (Magic) (Items) (Run)"

	while [[ $monsterhealth -gt 0 ]]; do
		read action
		if [[ $action =~ ^[aA]ttack$ ]]; then
			crit=$(($RANDOM%$playercritrate))
			if [[ $crit -eq 0 ]]; then
				damage=$((($RANDOM%5+1+$playerdamage)*2))
				echo "CRITICAL HIT!"
			else	
				damage=$(($RANDOM%5+1+$playerdamage))
			fi
			monsterhealth=$(($monsterhealth-$damage))
			echo "You did $damage damage."
		elif [[ $action =~ ^[mM]agic$ ]]; then
			echo "You have $playercp CP"
			echo "Which spell will you use?"
			echo "(Fireball 5CP) (Freezeray 5CP)"
			read spell
			if [[ $spell =~ ^[fF]ireball$ ]]; then
				if [[ $playercp -ge 5 ]]; then
					playercp=$(($playercp-5))
					echo "You used Fireball"
					echo "You did 10 damage" 
					echo "You have $playercp CP remaining"
					monsterhealth=$(($monsterhealth-10))
				else
					echo "You do not have enough CP"
					echo "What will you do?"
					echo "(Attack) (Magic) (Items) (Run)"
					continue
				fi
			elif [[ $spell =~ ^[fF]reezeray$ ]]; then
				if [[ $playercp -ge 5 ]]; then
					playercp=$(($playercp-5))
					echo "You used Freezeray"
					echo "You did 5 damage" 
					echo "You have $playercp CP remaining"
					monsterhealth=$(($monsterhealth-5))
					freeze=$(($RANDOM%2))
					if [[ $freeze -eq 1 ]]; then
						sleep 3 
						echo ""
						echo "The monster was frozen"
						echo ""
						echo "What will you do?"
						echo "(Attack) (Magic) (Items) (Run)"
						continue
					fi
				else
					echo "You do not have enough CP"
					echo "What will you do?"
					echo "(Attack) (Magic) (Items) (Run)"
					continue
				fi
			else
				echo "That is not a spell"
				echo "What will you do?"
				echo "(Attack) (Magic) (Items) (Run)"
					continue
			fi
		elif [[ $action =~ ^[iI]tems?$ ]]; then
			echo "Which item will you use?"
			echo "(potion x$potnum) (bigpotion x$bpotnum)"
			read item
			if [[ $item =~ ^[pP]otions?$ ]]; then
				if [[ $potnum -ne 0 ]]; then
					potnum=$(($potnum-1))
					playerhealth=$(($playerhealth+15))
					if [[ $playerhealth -gt $maxplayerhealth ]]; then
						echo "You used potion"
						echo "You healed $(($maxplayerhealth-($playerhealth-10))) HP"
						playerhealth=$maxplayerhealth
					else
						echo "You used potion"
						echo "You healed 15 HP"
					fi
					echo "You now have $playerhealth HP"
				else
					echo "You are out of this item"
					echo "What do you do?"
					echo "(Attack) (Magic) (Items) (Run)"
					continue
				fi
			elif [[ $item =~ ^[bB]ig[pP]otions?$ ]]; then
				if [[ $bpotnum -ne 0 ]]; then
					bpotnum=$(($bpotnum-1))
					echo "You used big potion"
					echo "You healed $(($maxplayerhealth-$playerhealth)) HP"
					playerhealth=$maxplayerhealth
					echo "You now have $playerhealth HP"
				else
					echo "You are out of this item"
					echo "What do you do?"
					echo "(Attack) (Items) (Run)"
					continue
				fi
			else
				echo "That is not an item"
				echo "What do you do?"
				echo "(Attack) (Magic) (Items) (Run)"
				continue
			fi
		elif [[ $action =~ ^[rR]un$ ]]; then
			runchance=$(($RANDOM%4))
			if [[ $runchance -eq 0 ]]; then
				echo "You got away"
				break
			else
				echo "You were unable to get away"
			fi
		else
			echo "That is not a vaild action"
			echo "What will you do?"
			echo "(Attack) (Magic) (Items) (Run)"
			continue 
		fi
		if [[ $monsterhealth -gt 0 ]]; then
			echo "Monster has $monsterhealth HP remaining"
		else
			echo "Monster has 0 HP remaining"
			echo "You have defeated the monster"
			reward=1
			kills=$(($kills+1))
			if [[ $kills -eq 1 ]]; then
				echo "You have defeated 1 monster"
			else
				echo "You have defeated $kills monsters"
			fi
			sleep 5
			continue
		fi
		echo ""
		

		sleep 3
		if [[ $freeze -eq 1 ]]; then
			freeze=$(($RANDOM%2))
			if [[ $freeze -eq 1 ]]; then
				echo "The monster is still frozen"
				echo ""
				echo "What will you do?"
				echo "(Attack) (Magic) (Items) (Run)"
				continue
			fi
		fi


		monsteraction=$(($RANDOM%10))
		if [[ $monsteraction -eq 0 ]]; then
			echo "The monster breathed fire"
			crit=$(($RANDOM%$monstercritrate))
			if [[ $crit -eq 0 ]]; then
				damage=$(((10+$monsterdamage)*2))
				echo "CRITICAL HIT!"
			else	
				damage=$((10+$monsterdamage))
			fi
		else
			echo "The monster attacks"
			crit=$(($RANDOM%$monstercritrate))
			if [[ $crit -eq 0 ]]; then
				damage=$((($RANDOM%5+1+$monsterdamage)*2))
				echo "CRITICAL HIT!"
			else	
				damage=$(($RANDOM%5+1+$monsterdamage))
			fi
		fi
		playerhealth=$(($playerhealth-$damage))
		echo "Monster did $damage damage."
		if [[ $playerhealth -gt 0 ]]; then
			echo "You have $playerhealth HP remaining"
		else
			echo "You have 0 HP remaining"
			echo "You have been defeated by the monster"
			sleep 5
			echo "GAME OVER"
			echo "You defeated $kills monsters"
			sleep 5
			exit
		fi
		echo ""
		echo "What will you do?"
		echo "(Attack) (Magic) (Items) (Run)"
	done

  freeze=0
	echo ""
	if [[ $reward -eq 1 ]]; then
		reward=$(($RANDOM%7))
		if [[ $reward -eq 0 ]]; then
			echo "You recieve max health upgrade"
			maxplayerhealth=$(($maxplayerhealth+10))
		elif [[ $reward -eq 1 ]]; then
			echo "You recieved two big potions"
			bpotnum=$(($bpotnum+2))
		elif [[ $reward -eq 2 ]]; then
			echo "You recieve sword"
			playerdamage=$(($playerdamage+3))
		elif [[ $reward -eq 3 ]]; then
			if [[ $playercritrate -gt 5 ]]; then
				echo "You recieve lucky charm"
				playercritrate=$(($playercritrate-5))
			else
				echo "You recieved two big potions"
				bpotnum=$(($bpotnum+2))
			fi
		else
			echo "You recieved three potions"
			potnum=$(($potnum+3))
		fi
		reward=0
	fi


	sleep 5
	echo ""
	echo "You took a rest and restored $((($maxplayerhealth-$playerhealth)/2)) HP and 10 CP"
	playerhealth=$(($playerhealth+(0+($maxplayerhealth-$playerhealth)/2)))
	playercp=$(($playercp+10))
	echo "You now have $playerhealth HP and $playercp CP"
	echo ""
	sleep 3
done
