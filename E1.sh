#!/bin/bash

# Define colors for enhanced output formatting
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

while true; do
    clear
    echo -e "${YELLOW}===== File Management Script =====${NC}"
    echo "Options:"
    echo "  l                        : List files in the current directory"
    echo "  c <directory_path>       : Change directory and list its contents"
    echo "  n <file_name>            : Create a new file"
    echo "  r <old_name> <new_name>  : Rename a file"
    echo "  d <file_name>            : Delete a file"
    echo "  q                        : Quit"
    echo -e "${YELLOW}==================================${NC}"
    
    read -p "Enter your choice and arguments: " choice args
    clear

    case $choice in
        l)
            if [ -n "$args" ]; then
                echo -e "${RED}Error: 'l' command does not accept arguments.${NC}"
            else
                echo "Files in the current directory:"
                ls -1
            fi
            ;;
        c)
            if [ -z "$args" ]; then
                echo -e "${RED}Error: 'c' command requires a directory path.${NC}"
            elif [ -d "$args" ]; then
                if cd "$args" 2>/dev/null; then
                    echo -e "${GREEN}Changed to directory '$args'. Listing contents:${NC}"
                    ls -1
                else
                    echo -e "${RED}Error: Unable to change directory to '$args'.${NC}"
                fi
            else
                echo -e "${RED}Error: Directory '$args' does not exist.${NC}"
            fi
            ;;
        n)
            if [ -z "$args" ]; then
                echo -e "${RED}Error: 'n' command requires a file name.${NC}"
            elif [ -e "$args" ]; then
                read -p "File '$args' already exists. Overwrite? (y/N): " overwrite
                overwrite=${overwrite:-n}
                if [ "$overwrite" != "y" ]; then
                    echo "File creation canceled."
                else
                    touch "$args"
                    echo -e "${GREEN}File '$args' created successfully.${NC}"
                fi
            else
                touch "$args"
                echo -e "${GREEN}File '$args' created successfully.${NC}"
            fi
            ;;
        r)
            read -r old_name new_name <<< "$args"
            if [ -z "$old_name" ] || [ -z "$new_name" ]; then
                echo -e "${RED}Error: 'r' command requires both old and new file names.${NC}"
            elif [ -e "$old_name" ]; then
                if [ -e "$new_name" ]; then
                    read -p "File '$new_name' already exists. Overwrite? (y/N): " overwrite
                    overwrite=${overwrite:-n}
                    if [ "$overwrite" != "y" ]; then
                        echo "File rename canceled."
                    else
                        mv "$old_name" "$new_name"
                        echo -e "${GREEN}File renamed from '$old_name' to '$new_name'.${NC}"
                    fi
                else
                    mv "$old_name" "$new_name"
                    echo -e "${GREEN}File renamed from '$old_name' to '$new_name'.${NC}"
                fi
            else
                echo -e "${RED}Error: File '$old_name' does not exist.${NC}"
            fi
            ;;
        d)
            if [ -z "$args" ]; then
                echo -e "${RED}Error: 'd' command requires a file name.${NC}"
            elif [ -e "$args" ]; then
                read -p "Are you sure you want to delete '$args'? (Y/n): " confirm
                confirm=${confirm:-y}
                if [ "$confirm" = "y" ] || [ "$confirm" = "Y" ]; then
                    rm "$args"
                    echo -e "${GREEN}File '$args' has been deleted.${NC}"
                else
                    echo "File deletion canceled."
                fi
            else
                echo -e "${RED}Error: File '$args' does not exist.${NC}"
            fi
            ;;
        q)
            echo "Exiting the script. Goodbye!"
            break
            ;;
        *)
            echo -e "${RED}Invalid option. Please try again.${NC}"
            ;;
    esac

    echo
    read -p "Press Enter to continue..."
done
