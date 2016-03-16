# Feedbase Dapp

### A Dapple-Enriched Smart Contract

This is a simple data feed contract which lets you publish small pieces of data that can be updated at any time. Each time a feed is updated with a new value you may set an expiration date for that value. You are also able to put a price on your feed which must be paid by the first person who wants to read its value (for each update).

## Usage (for Users)

Ensure you have a locally running ethereum node.

Visit: `TODO: add deployment url / IPFS hash`

## Installation (for Developers)

Requirements:

* geth
* node.js 5.x

Dependencies:

```bash
npm install -g dapple
npm install -g gulp
git clone https://github.com/hitchcott/feedbase/
cd feedbase
git submodule update --init --recursive
npm install
```


## Usage (for Developers)

There is a helpful blockchain script for development, which will use a clever mining script similar to Embark. This is entirely optional; you can use any testnet config via RPC on port 8545 and deploy via dapple as normal.

To start the blockchain script:

```bash
npm run blockchain
```

In a new terminal window, you can then build and deploy the dapp:

```bash
npm run deploy
```

This will generate the latest build in `./dist`, open up `index.html` to play around.

If you find that dapple is deploying to evm rather than than geth, please modify `~/.dapplerc`:

```yaml
environments:
  default:
    # comment out default config
    # ethereum: internal
    # replace with real ethereum node
    ethereum:
      host: localhost
      port: '8545'
```

For development you can use the watching script:

```bash
npm run watch
```

This will automatically rebuild (but not deploy) contracts and run tests (in EVM) against them if they are changed. It will automatically rebuild all frontend files when they are changed, and uses liveReload to refresh the browser.

You can use `npm run deploy` whilst the watcher is running.

For standalone EVM testing use:

```bash
npm run test
```

**NB** Currently all tests are ignored in `dappfile` becuase dapple attempts to deploy them, so you will manually have to toggle the `ignore` value when testing between testing and deployment.

## TODOs

```
- Handle UI Events for transaction pending
- URL Routing
```

## vNext
```
- Estimate gas properly
- IPFS Hash Get
- Configurable Currency
- Mist integration
- IPFS Deploy
- Frontend testing
```
