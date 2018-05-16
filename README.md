# Assembly for Brainfuck
## bf-asm
## Ideas:
[] Add absolute cell linking
[] Add inserts of BF
[] Add if-then-else operation
[] Add Macroses

## Instructions:
```@ k``` -> shift for k cells
```zero``` -> set value of current cell to zero
```set k``` -> set value of current cell to k
```add k``` -> add value of current cell to (current cell + k) cell
```mov k``` -> move value of current cell to (current cell + k) cell
```copy k t``` -> copy value of current cell to (current cell + k) cell, using (current cell + k + t) cell as temporary
