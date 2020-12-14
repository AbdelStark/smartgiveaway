[![smartgiveaway Actions Status](https://github.com/abdelhamidbakhta/smartgiveaway/workflows/smartgiveaway-ci/badge.svg)](https://github.com/abdelhamidbakhta/smartgiveaway/actions)
[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://github.com/abdelhamidbakhta/smartgiveaway/blob/master/LICENSE)
[![sonar-quality-gate][sonar-quality-gate]][sonar-url]  [![sonar-bugs][sonar-bugs]][sonar-url] [![sonar-vulnerabilities][sonar-vulnerabilities]][sonar-url]

# Smart Giveaway
[Build On XDai: Applications & Bridges GR8 Hackathon](https://gitcoin.co/issue/xdaichain/site/9/100024347)

As part of the Gitcoin Hackathon we are building a Giveaway platform (similar to twitter giveaways).

This is a Proof Of Concept aiming to use `xDai` technology to build innovative features on top of an Ethereum smart contract solution.

## Use case

An operator can create give away with on-chain winner selection.
In order to achieve that we are using the xDai on-chain RNG based on `RANDAO`.
For the demonstration we target `RandomAuRaProxy` deployed at `0x5870b0527DeDB1cFBD9534343Feda1a41Ce47766`.

The `GiveAway` contract uses `IPOSDAORandom` to select the winner among the candidates.
A seed is retrieved with `currentSeed` method, allowing us to have a verifiable random number generated on chain.

## Architecture

We have 3 main components:
- SmartGiveaway smart contract
- Front-End web application
- Back-End service

### SmartGiveAway smart contract

Project is using [OpenZeppelin CLI](https://docs.openzeppelin.com/cli/2.7/) and is fully compatible with Truffle based projects.

#### Compile

```shell script
npx oz compile
```

### Front-End web application

#### Project setup
```
npm install
```

#### Compiles and hot-reloads for development
```
npm run serve
```

#### Compiles and minifies for production
```
npm run build
# Static site is generate to: ./dist
```

#### Lints and fixes files
```
npm run lint
```

#### Customize configuration
See [Configuration Reference](https://cli.vuejs.org/config/).

### Back-End service
[See instructions.](https://github.com/abdelhamidbakhta/smartgiveaway-backend)

[Online Open API specification](https://smartgiveaway.herokuapp.com/)

[sonar-url]: https://sonarcloud.io/dashboard?id=abdelhamidbakhta_smartgiveaway
[sonar-quality-gate]: https://sonarcloud.io/api/project_badges/measure?project=abdelhamidbakhta_smartgiveaway&metric=alert_status
[sonar-bugs]: https://sonarcloud.io/api/project_badges/measure?project=abdelhamidbakhta_smartgiveaway&metric=bugs
[sonar-vulnerabilities]: https://sonarcloud.io/api/project_badges/measure?project=abdelhamidbakhta_smartgiveaway&metric=vulnerabilities