bindkey "^[[1;5D" backward-word
bindkey "^[[1;5C" forward-word

# bitwarden functions

bw-login () {
    export BW_SESSION="$(bw login | grep -E -oh 'export BW_SESSION="(.+==)"' | cut -c20-107)"
}

bw-lock () {
    bw lock
}

bw-unlock () {
    export BW_SESSION="$(bw unlock | grep -E -oh 'export BW_SESSION="(.+==)"' | cut -c20-107)"
}

bw-get-pass () {
    bw get item "Proxmox Root" | jq -r '.login.password'
}
