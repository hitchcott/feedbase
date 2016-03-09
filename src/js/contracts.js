var web3 = window.web3 = new Web3();

// TODO mist integration
var providerUrl = 'http://localhost:8545';

// connect to local node
web3.setProvider(new web3.providers.HttpProvider(providerUrl));

// initialize dapple contracts
dapple.class(web3);

// set default account
web3.eth.defaultAccount = web3.eth.accounts[0];