## Assembly for Brainfuck
# bf-asm
# Ideas:
[] Add absolute cell linking
[] Add inserts of BF
[] Add if-then-else operation
[] Add Macroses

# Commands:
```@(k) or shift(k)``` -> shift for k cells
zero -> set value of current cell to zero
set(k) -> set value of current cell to k
add(k) -> add value of current cell to (current cell + k) cell
mov(k) -> move value of current cell to (current cell + k) cell
copy(k, t) -> copy value of current cell to (current cell + k) cell, using (current cell + k + t) cell as temporary


# May be next variation of asm:
mov cell_number new_value
mov 3 5 ==> >>>+++++<<<

clr cell_number
clr 3 ==> >>>[-]<<<

add cell_number_1 res_cell
add 3 5 ==> >>>[>>+<<-]<<<

sub cell_number_1 res_cell
sub 3 5 ==> >>>[>>-<<-]<<<

chp cell_number
chp 3 ==> >>>.<<<

chr cell_number
chr 3 ==> >>>,<<<