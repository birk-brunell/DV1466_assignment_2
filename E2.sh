#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

display_welcome() {
    clear
    echo -e "${YELLOW}===== Dice Roll Generator =====${NC}"
    echo -e "${BLUE}How to use:${NC}"
    echo -e "Enter your dice rolls in the format '${CYAN}xdys${NC}', where:"
    echo -e "  ${CYAN}x${NC} = number of dice to roll (1 to 100)"
    echo -e "  ${CYAN}y${NC} = number of sides on each die (1 to 1000)"
    echo -e "  ${CYAN}s${NC} = optional flag to sum the results"
    echo
    echo "You can roll multiple dice at once by separating them with spaces."
    echo -e "Example: '${CYAN}2d10s 5d20${NC}'"
    echo
    echo "If you press Enter without input, only the animation will play without any dice results."
    echo -e "Enter '${RED}q${NC}' to quit the script."
    echo -e "${YELLOW}===============================${NC}"
    echo
}

display_dice_animation() {
    frames=(
        "
+-------+
|       |
|   *   |
|       |
+-------+
        "
        "
+-------+
| *     |
|       |
|     * |
+-------+
        "
        "
+-------+
| *     |
|   *   |
|     * |
+-------+
        "
        "
+-------+
| *   * |
|       |
| *   * |
+-------+
        "
        "
+-------+
| *   * |
|   *   |
| *   * |
+-------+
        "
        "
+-------+
| *   * |
| *   * |
| *   * |
+-------+
        "
    )

    for i in {0..5}; do
        clear
        echo -e "${YELLOW}${frames[i]}${NC}"
        sleep 0.2
    done
}


roll_dice() {
    local dice_count=$1
    local dice_sides=$2
    local sum_flag=$3
    local results=()
    local total_sum=0

    for ((i = 1; i <= dice_count; i++)); do
        roll_result=$(( (RANDOM % dice_sides) + 1 ))
        results+=($roll_result)
        if [[ $sum_flag == true ]]; then
            total_sum=$((total_sum + roll_result))
        fi
    done

    echo -e "${GREEN}Rolling ${CYAN}$dice_count d$dice_sides${NC}:"
    echo -n "Results: "
    echo -e "${YELLOW}$(printf "%s " "${results[@]}")${NC}"

    if [[ $sum_flag == true ]]; then
        echo -e "${CYAN}Sum: ${GREEN}$total_sum${NC}"
    fi
    echo -e "${BLUE}----------------------------------------${NC}"
}

while true; do
    display_welcome

    echo -en "Enter your rolls: "
    read user_input

    if [[ $user_input == "q" ]]; then
        echo -e "${RED}Goodbye!${NC}"
        break
    fi

    if [[ -z $user_input ]]; then
        display_dice_animation
        continue
    fi

    valid_input=true
    for roll in $user_input; do
        if [[ $roll =~ ^([1-9][0-9]{0,1})d([1-9][0-9]{0,2})(s?)$ ]]; then
            dice_count=${BASH_REMATCH[1]}
            dice_sides=${BASH_REMATCH[2]}
            sum_flag=false

            if [[ ${BASH_REMATCH[3]} == "s" ]]; then
                sum_flag=true
            fi

            if ! (( dice_count >= 1 && dice_count <= 100 && dice_sides >= 1 && dice_sides <= 1000 )); then
                valid_input=false
                echo -e "${RED}Error: Invalid roll '${roll}'. x must be 1-100 and y must be 1-1000.${NC}"
                break
            fi
        else
            valid_input=false
            echo -e "${RED}Error: Invalid format '${roll}'. Expected format is 'xdys' (e.g., 2d10s).${NC}"
            break
        fi
    done

    if $valid_input; then
        display_dice_animation

        for roll in $user_input; do
            if [[ $roll =~ ^([1-9][0-9]{0,1})d([1-9][0-9]{0,2})(s?)$ ]]; then
                dice_count=${BASH_REMATCH[1]}
                dice_sides=${BASH_REMATCH[2]}
                sum_flag=false

                if [[ ${BASH_REMATCH[3]} == "s" ]]; then
                    sum_flag=true
                fi

                roll_dice "$dice_count" "$dice_sides" "$sum_flag"
            fi
        done
    fi

    echo
    read -p "Press Enter to continue..."
done
