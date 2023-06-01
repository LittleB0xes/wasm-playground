# Let's play with WASM, by hand

But why ? 

On m'a toujours dit que le wasm n'était pas fait pour être écrit à la main, qu'il fallait passer par un language intermédiaire (comme Rust, C, Go, ....)... Ok ... Mais franchement, avce quelques outils et un bon éditeur de texte, il doit bien y avoir moyen de s'amuser un peu non ?

Ce repo est une sorte de journal de mon voyage avec wasm, les mains dans le cambouis


# A minimal setup
- A text editor
- Some tools to compile `.wat`file to `./wasm` file, like [WABT](https://github.com/WebAssembly/wabt)
- Node
- And in some case, a local server to run the wasm in browser

# Step 0 - An Empty Module
