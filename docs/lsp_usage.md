## LSP requirements
### Clangd
- Every c/cpp project will need a compile_commands.json file for clangd. 
- Easy way to generate, based on the makefile you'll use, is using `bear` command:
```bash
sudo apt install bear
bear -- make
```
