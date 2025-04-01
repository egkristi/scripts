#!/bin/bash
# init.sh - Script to initialize the sbin directory in PATH

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
    local profile_file="$1"
    local already_added=false
    
    # Check if already added to profile
    if [ -f "$profile_file" ]; then
        if grep -q "# Added by sbin init script" "$profile_file"; then
            already_added=true
        fi
    fi
    
    if [ "$already_added" = false ]; then
        echo -e "\n# Added by sbin init script on $(date)" >> "$profile_file"
        echo "source \"${SCRIPT_DIR}/init.sh\"" >> "$profile_file"
        echo "Added to $profile_file. Changes will take effect in new terminal sessions."
    else
        echo "Already added to $profile_file."
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

# Check if script is being sourced
if [[ "${BASH_SOURCE[0]}" != "${0}" ]]; then
    # Sourced: just add to current session and list scripts
    SCRIPT_DIR=$(dirname "$0")
    SBIN_DIR="${SCRIPT_DIR}/sbin"
    sbin_exists
    add_to_current_session
    
else
    # Executed directly: add to profile and source for current session
    SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
    SBIN_DIR="${SCRIPT_DIR}/sbin"
    sbin_exists
    profile_file=$(select_profile_file)
    
    if [ -z "$profile_file" ]; then
        echo "Unsupported shell: $(basename "$SHELL")"
        echo "Please add the following line to your shell profile manually:"
        echo "source \"${SCRIPT_DIR}/init.sh\""
    else
        echo "Setting up automatic initialization..."
        add_to_profile "$profile_file"
        
        # Source the script for the current session
        export PATH="${SBIN_DIR}:$PATH"
        echo "Added ${SBIN_DIR} to PATH for current session"
           
        echo
        echo "Setup complete! The scripts will be available in this and all future sessions."
    fi
fi