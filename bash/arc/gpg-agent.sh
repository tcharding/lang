# start gpg-agent
eval $(gpg-agent --daemon --enable-ssh-support --write-env-file "${HOME}/.gnupg/gpg-agent-info")

# Create the necessary environment variables
if [ -f "${HOME}/.gnupg/gpg-agent-info" ]; then
    source "${HOME}/.gnupg/gpg-agent-info"
    export GPG_AGENT_INFO
    export SSH_AUTH_SOCK
    export SSH_AGENT_PID
fi

