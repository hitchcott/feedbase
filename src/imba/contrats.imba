extern Web3
extern dapple

var web3 = window:web3 = Web3.new

# TODO mist integration
var providerUrl = 'http://localhost:8545'

# connect to local node
web3:setProvider(web3:providers:HttpProvider.new(providerUrl))

# initialize dapple contracts
dapple.class(web3)

# set default account
web3:eth:defaultAccount = web3:eth:accounts[0]