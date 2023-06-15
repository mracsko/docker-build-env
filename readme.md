# Usage
## Build
`docker build -t devenv .`

## Usage
`docker run -it --rm devenv`

### Neovide
https://neovide.dev/
`docker run -p 6666:6666 -it --rm devenv nvim --headless --listen localhost:6666`
`neovide --server=localhost:6666`

# TODO
* autocomplete

# Tools
## OpenSUSE Tumbleweed
* wget
* git
* jq
* ripgrep
* exa
* cmake
* gcc
* gcc-c++
* gzip
* xz
* unzip
* openssl
* libopenssl-devel
* mc
* python311
* python311-pip

## Development
* rust
  * targets
    * wasm32-unknown-unknown
  * cargo-audit
  * trunk
  * rust-analyzer
* java
  * 8
  * 11
  * 17
  * 18
  * 19
  * 20
* node
* python (see OpenSUSE Tumbleweed dependencies)

## Tools
* nushell
* zellij
* dust
* bat
* fd
* procs
* starship

## IDE
* neovim
* lazyvim