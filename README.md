# Feedbase Dapp

This is a simple data feed dapp which lets you publish small pieces of data that can be updated at any time. Each time a feed is updated with a new value you may set an expiration date for that value. You are also able to put a price on your feed which must be paid by the first person who wants to read its value (for each update).

## Overview

This was a small project to attempt to combine `imba` and `dapple` in the search towards a reasonable boilerplate dapp. As I would typically use Meteor for dapps I wanted to try something different. The main things worked on here were:

* Gulp Script (with bower for frontend libs + browserify for dapple)
* Blockchain Script (ultra stripped down version of embark with modified mining script)
* An attempt to work with contracts the 'imba' way (check `app.imba` for the model)

## Usage (for Users)

Ensure you have a locally running ethereum node.

Visit: `TODO: add deployment url / IPFS hash`

## Installation (for Developers)

Requriements:

* geth
* node.js 5.x

Dependenceies:

```bash
npm install -g dapple
npm install -g gulp
git clone https://github.com/hitchcott/feedbase/
cd feedbase
git submodule update --init --recursive
npm i
```


## Usage (for Developers)

There is a helpful blockchain script for devleopment, which will use a clever mining script similar to Embark. This is entirely optional; you can use any testnet config via RPC on port 8545 and deploy via dapple as normal.

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

This will autoamtically rebuild (but not deploy) contracts and run tests (in EVm) against them if they are changed. It will automatically rebuild all frontend files when they are changed, and uses liveReload to refresh the browser.

You can use `npm run deploy` whilst the watcher is running.

For standalone EVM testing use:

```bash
npm run test
```

**NB** Currently all tests are ignored in `dappfile` becuasae dapple attempts to deploy them, so you will manually have to toggle the `ignore` value when testing between testing and deployment.

## TODOs

```
- Implement Maker User
- URL Routing
- IPFS Hash Get
- Fix the blockchain script for linux
```

## vNext
```
- Browser-baed Ethersim Option for Demos
- Estimate gas properly
- Configurable Currency
- Mist integration
- IPFS Deploy
- Frontend testing
```