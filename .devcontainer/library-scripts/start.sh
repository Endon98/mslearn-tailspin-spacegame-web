#start.sh
#!/bin/bash

#Script modified from https://github.com/Pwd9000-ML/GitHub-Codespaces-Lab/tree/master/.devcontainer/codespaceADOagent

if [! -f /home/vscode/azure-pipelines/vsts-agent-linux-${ARCH}-${AGENT_VERSION}.tar.gz]; then
    echo "Downloading Azure Pipelines agent..."
    curl -O -L https://vstsagentpackage.azureedge.net/agent/${AGENT_VERSION}/vsts-agent-linux-${ARCH}-${AGENT_VERSION}.tar.gz \
    tar xzf /home/vscode/azure-pipelines/vsts-agent-linux-${ARCH}-${AGENT_VERSION}.tar.gz \
    ./bin/installdependencies.sh
fi

#GitHub Codespace secrets
ADO_ORG=$ADO_ORG
ADO_PAT=$ADO_PAT
ADO_POOL_NAME=$ADO_POOL_NAME

# Derived environment variables
HOSTNAME=$(hostname)
AGENT_SUFFIX="ADO-agent"
AGENT_NAME="${HOSTNAME}-${AGENT_SUFFIX}"
ADO_URL="https://dev.azure.com/${ADO_ORG}"

export VSO_AGENT_IGNORE=ADO_PAT,GH_TOKEN,GITHUB_CODESPACE_TOKEN,GITHUB_TOKEN

/home/vscode/azure-pipelines/config.sh --unattended \
--agent "${AGENT_NAME}" \
--url "${ADO_URL}" \
--auth PAT \
--token "${ADO_PAT}" \
--pool "${ADO_POOL_NAME:-Default}" \
--replace \
--acceptTeeEula

/home/vscode/azure-pipelines/run.sh
