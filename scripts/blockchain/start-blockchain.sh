#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
ACCOUNT_PASSWORD="$(cat "${DIR}/password")"

# TODO randomize the network?

# create start scripts
baseCommand="geth \
--datadir=${DIR}/tmp/ --logfile=${DIR}/tmp/blockchain.log \
--rpc --rpcaddr localhost --rpccorsdomain \"*\" \
--networkid 58554 \
--genesis=${DIR}/genesis.json \
--maxpeers 1 --password ${DIR}/password"
# append account details
accountList="${baseCommand} account list"
accountNew="${baseCommand} account new"

# create temp directory and empty log file
mkdir -p "${DIR}/tmp/" && touch "${DIR}/tmp/blockchain.log"

# check if we have any accounts
if [[ "$(${accountList})" =~ \{([^}]*)\} ]]; then
  ETH_ACCOUNT="${BASH_REMATCH[1]}"
else
  echo "No Accounts found, creating a new one"
  eval $accountNew
  # try agian
  if [[ "$(${accountList})" =~ \{([^}]*)\} ]]; then
    ETH_ACCOUNT="${BASH_REMATCH[1]}"
  else
    echo "Failed creating account"
    exit
  fi
fi

# create minin command
miningScript="${baseCommand} --unlock ${ETH_ACCOUNT} js ${DIR}/miner.js"
echo $miningScript

# start the mining script
eval $miningScript
