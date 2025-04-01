#!/bin/bash
# init.sh - Script to initialize the sbin directory in PATH

REPO_URL="https://github.com/egkristi/shell-scripts.git"
REPO_NAME="shell-scripts"

# Ensure the sbin directory exists
sbin_exists(){
  if [ ! -d "$SBIN_DIR" ]; then
    echo "Error: sbin directory not found at ${SBIN_DIR}"
    return 1 2>/dev/null || exit 1  # Return if sourced, exit otherwise
  fi
}

# Function to check if a directory is in PATH
is_in_path() {
    local dir_to_check="$1"
    echo "$PATH" | grep -E "(^|:)${dir_to_check}(:|$)" > /dev/null
}

# Add to PATH for current session if not already there
add_to_current_session() {
    if ! is_in_path "$SBIN_DIR"; then
        export PATH="${SBIN_DIR}:$PATH"
    else
        echo "${SBIN_DIR} is already in PATH"
    fi
}

# Add to shell profile for permanent use
add_to_profile() {
    local profile_file=$(select_profile_file)
    
    if [ -z "$profile_file" ]; then
        echo "Unsupported shell: $(basename "$SHELL")"
        echo "Please add the following line to your shell profile manually:"
        echo "source \"${SCRIPT_DIR}/init.sh\""
        exit 1
    fi

    #echo "Check if already added to profile"
    if [ -f "$profile_file" ]; then
        if grep -q "# Added by ${REPO_NAME} init.sh script on" "$profile_file"; then
            #echo "Sed find line that starts with source and ends with shell-scripts/init.sh"          
            sed -i -e 's|^# Added by '"${REPO_NAME}"' init.sh script on.*|# Added by '"${REPO_NAME}"' init.sh script on '"$(date)"'"|g' $profile_file
            sed -i -e 's|^source.*shell-scripts/init\.sh"|source "'"${SCRIPT_DIR}/init.sh"'"|g' $profile_file
            #rm -f "$profile_file.bak"
        else
            echo -e "\n# Added by ${REPO_NAME} init.sh script on $(date)" >> "$profile_file"
            echo "source \"${SCRIPT_DIR}/init.sh\"" >> "$profile_file"
            echo "Added to $profile_file. Changes will take effect in new terminal sessions."
        fi
    fi
}

# Select appropriate profile file based on shell
select_profile_file() {
    shell_name="$(basename "$SHELL")"
    case "$shell_name" in
        bash)
            if [ -f "$HOME/.bash_profile" ]; then
                echo "$HOME/.bash_profile"
            else
                echo "$HOME/.bashrc"
            fi
            ;;
        zsh)
            echo "$HOME/.zshrc"
            ;;
        *)
            echo ""
            ;;
    esac
}

# if curl execution, ask user to clone repo to current folder
clone_repo() {
    if [ -d "$REPO_NAME" ]; then
        echo "Directory $REPO_NAME already exists. To use execute:"
        echo "./${REPO_NAME}/init.sh"
        exit 1
    fi
    #prompt user to clone
    read -p "Would you like to clone the repository now? (y/n): " clone_choice
    if [[ "$clone_choice" == "y" || "$clone_choice" == "Y" ]]; then
        #if target directory exists, prompt user to continue
        git clone "${REPO_URL}"
        echo "Repository cloned to $(pwd)/${REPO_NAME}"
    else
        echo "Please clone the repository manually."
        echo "git clone ${REPO_URL}"
        echo "Exiting without cloning."
        exit 1
    fi
}

#if ${BASH_SOURCE[0]} is empty and ${0} is not empty, and ${0} ends with script name, then the script is executed from local installation
if [[ "${BASH_SOURCE##*/}" == "init.sh" && "${0##*/}" == "init.sh" ]]; then
    echo "Script is being executed locally"
    SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
    SBIN_DIR="${SCRIPT_DIR}/sbin"
    sbin_exists
    add_to_profile
    add_to_current_session
elif [[ -z "${BASH_SOURCE[0]}" && "${0}" == "bash" ]]; then
    echo "Script is being executed from curl"
    clone_repo
    SCRIPT_DIR="$(pwd)/$REPO_NAME"
    SBIN_DIR="${SCRIPT_DIR}/sbin"
    sbin_exists
    add_to_profile
    add_to_current_session
elif [[ -z "${BASH_SOURCE##*/}" && "${0##*/}" == "init.sh" ]]; then
    #echo "Script is being sourced: just add to current session and list scripts"
    SCRIPT_DIR=$(dirname "$0")
    SBIN_DIR="${SCRIPT_DIR}/sbin"
    sbin_exists
    add_to_current_session
else
    echo "Script is being executed from an unknown source"
fi