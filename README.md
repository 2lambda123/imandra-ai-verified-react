# VerifiedReact

[![Build Status](https://github.com/2lambda123/imandra-ai-verified-react/actions/workflows/build.yml/badge.svg?branch=master)](https://github.com/2lambda123/imandra-ai-verified-react/actions)

Welcome to VerifiedReact! This is work in progress - stay in touch via [@VerifiedByAI](https://www.twitter.com/verifiedbyai), or come chat with us on [Discord](https://discord.gg/byQApJ3).

For an overview, read our Medium post [Introducing Verified React](https://medium.com/imandra/introducing-verified-react-9c2ef03f821b).

![Verified React logo](/verified-react-logo.png)

## Ideas, aims and progress so far

- [x] Stage 1  (Counter, TicTacToe)
  - [x] Simpler automation of Imandra:
    - added `imandra-http-server` as an alternative to `imandra-repl` to allow automation via an HTTP api, bundled with the [Imandra installer](https://docs.imandra.ai/imandra-docs/notebooks/installation-simple/). Previously you could automate our `imandra-repl` process via stdin/stdout, but having an HTTP interface to the Imandra client naturally makes life a lot easier. `imandra-http-server` is built using our `Imandra_client` OCaml library, which we're hoping to make available as an `opam` package in the future, so OCaml users can use the Imandra client directly from their code.
    - added [`bs-imandra-client`](https://github.com/AestheticIntegration/bs-imandra-client) - bucklescript bindings to that HTTP api to be used when running on Node
  - [x] Allow export of export of core logic verified with Imandra to code that can be compiled to executable JS
    - Imandra comes with a prelude of pre-verified functions for use from `.iml` (Imandra-ml) or `.ire` (Imandra-reason) code. When you're done reasoning and want to compile the verified module into a larger program, you need a `.ml` version of the prelude to compile alongside your module. Previously this was available to compile as native OCaml package, but we've now also included an initial amended version that compiles to javascript via the bucklescript compiler too, which can be `npm installed` from the [`imandra-prelude`](https://github.com/AestheticIntegration/imandra-prelude) repo.
  - [x] Automation of verification goals via `jest`, via `imandra-http-server`. See:
    - `examples/simple/__tests__/Counter_Goals.ml`
    - `examples/tictactoe/__tests__/TicTacToe_Logic_Goals.re`
    - `examples/todomvc/__tests__/TodoMvc_Model_Goals.re`
  - [x] Hook verified state machine up to React reducer component. See:
    - `examples/tictactoe/TicTacToe.re`

- [x] Stage 2
  - [x] [Viewing instances](#viewing-instances) - also see [our blog post](https://medium.com/imandra/constraint-solving-your-uis-8933f4cf8927)
  - [x] TodoMVC as a larger example
  - [ ] Decomposition visualisation

-  [ ] Stage 3
  - [ ] Collecting React reducer events from React unit test runs
  - [ ] Map reducer events back to state machine events, and visualise coverage on the decomposition
  - [ ] Coverage report of state space as hit by your jest tests

## Setup

Make sure you have the latest version of `imandra-repl` installed via the [Imandra Installer](https://docs.imandra.ai/imandra-docs/notebooks/installation/), then run

    imandra-repl

and make sure it starts up successfully (i.e. all updates are installed). Once it's started, quit it again with Ctrl-D. Next:

    npm install

to install the bucklescript compiler, `imandra-prelude` and Imandra client bindings for bucklescript. Then:

    npm run watch

You may see a few errors the first time you run watch - this I believe is due to an issue with `components` in `bsb.exe` as they are a WIP. However, if you run `npm run watch` multiple times, you should stop seeing errors after a few builds, and from then on incremental compilation will work sucessfully.

## The compilation chain

For runtime:

- `.iml` and `.ire` files are compiled to `.ml` files using `imandra-extract` (which is bundled with the [Imandra Installer](https://docs.imandra.ai/imandra-docs/notebooks/installation/)), and integrated into the build via `bsb` components.
- `.ml` and `.re` files are compiled to `.bs.js` via `bsb` itself.
- `Imandra_prelude` is available automatically inside `imandra-http-server`
- When compiling to javascript, `Imandra_prelude` is provided by [imandra-prelude](https://github.com/AestheticIntegration/imandra-prelude), added as an npm/bucklescript dependency.

## Verification tests:

- Tests are run via Jest on node.js using the compiled runtime JS files.
- As part of the test run, the Imandra client bucklescript bindings (`bs-imandra-client`) are used to spin up `imandra-http-server` (which is bundled as part of the [Imandra Installer](https://docs.imandra.ai/imandra-docs/notebooks/installation/)), which is an OCaml binary talking to Imandra's reasoning engine in the cloud.
- The HTTP Imandra client API is used to load `.iml` and `.ire` files into the running `imandra-http-server` OCaml process, and perform verification statements.
- The verification results are obtained by using Imandra client bucklescript bindings to spin up imandra-http-server. The HTTP Imandra client API is then used to load .iml and .ire files into the running imandra-http-server OCaml process, and perform verification statements. The verification results are then captured and reported back as part of the Jest test run.

To run the verification goals, execute the following command:

    npm run test

## Viewing and Querying Instances

[Read our post about viewing instances in your UIs with Imandra](https://medium.com/imandra/constraint-solving-your-uis-8933f4cf8927).

- To start the Imandra HTTP server with `reason` syntax loaded, run the following command from the `verified-react` repo root:

    imandra-http-server -reason

to start Imandra's http server with `reason` syntax loaded. Then for bucklescript compilation, (in another terminal) run:

    npm install
    npm run watch

Then, to start the parcel.js dev server, (in another terminal) run:

    npm run watch-tictactoe

- To start the parcel.js dev server and be able to visit `http://localhost:1234` to see/play the TicTacToe game (verified via the `npm run test` Jest tests) and query for instances from Imandra, run the following command from the `verified-react` repo root:

### Viewing Instances Summary

The TicTacToe UI is [wrapped in an InstanceBrowser component](./examples/tictactoe/Index.re), which loads the game logic into Imandra (along with some JSON encoders and decoders) via [`examples/tictactoe/Setup.ire`](examples/tictactoe/Setup.ire).

The TicTacToe UI component has been edited slightly to allow a default intial state to be passed from its parent via the `customInitialLogicState` prop.
## Running Tests

To run the verification goals, execute the following command:

    npm run test

This command will run the Jest tests on the compiled runtime JS files. The Imandra client bucklescript bindings (`bs-imandra-client`) will be used to spin up `imandra-http-server`, which is an OCaml binary that communicates with Imandra's reasoning engine in the cloud. The HTTP Imandra client API will be used to load `.iml` and `.ire` files into the running `imandra-http-server` OCaml process and perform verification statements. The verification results will be captured and reported back as part of the Jest test run.
When the instance query box's contents change, the query is sent to `imandra-http-server`'s `/instance/by-src` endpoint as a lambda expression, `x : game_state => <constraint>`, so an instance of type `game_state` matching the constraint is returned, printed to a JSON string via a serialisation function (`instancePrinterFn`).

This returned instance is then passed to the `customInitialLogicState` prop and rendered by the UI component.
