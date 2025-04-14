# TODO

- [ ] ignore all files on .gitignore on cwd
- [ ] find a way to receive the process PID
- [ ] understand why colors are gone ;-;

# Optional
- [ ] run on beam with ATOM VM?

# commands

`gleam run -t js --runtime=bun`
`bun build ./src/watcher.mjs --target bun --compile --outfile watcher`

CI?
`gleam run`
`bun build --compile --minify --sourcemap build/dev/javascript/watchexec_wasm/gleam.main.mjs`
https://bun.sh/docs/bundler/executables

bun shell
https://bun.sh/blog/the-bun-shell

# watchexec_wasm

[![Package Version](https://img.shields.io/hexpm/v/watchexec_wasm)](https://hex.pm/packages/watchexec_wasm)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/watchexec_wasm/)

```sh
gleam add watchexec_wasm@1
```
```gleam
import watchexec_wasm

pub fn main() {
  // TODO: An example of the project in use
}
```

Further documentation can be found at <https://hexdocs.pm/watchexec_wasm>.

## Development

```sh
gleam run   # Run the project
gleam test  # Run the tests
```


