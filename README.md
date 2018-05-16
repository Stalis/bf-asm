# Assembly for Brainfuck
## bf-asm
## Ideas:
[] Add absolute cell linking
[] Add inserts of BF
[] Add if-then-else operation
[] Add Macroses

## Comments:
```; This in one-line comment```

## Instructions:
```@ k``` -> shift for ```k``` cells right or ```-k``` cells left

```inc k``` -> increment value of current cell ```k``` times

```dec k``` -> decrement value of current cell ```k``` times

```print k``` -> print ```k``` symbols

```scan k``` -> scan ```k``` symbols

```zero``` -> set value of current cell to zero

```set k``` -> set value of current cell to ```k```

```add k``` -> add value of current cell to ```(current cell + k)``` cell

```mov k``` -> move value of current cell to ```(current cell + k)``` cell

```copy k t``` -> copy value of current cell to ```(current cell + k)``` cell, using ```(current cell + k + t)``` cell as temporary

## Directives:
```
#loop       ; runs while value of current cell not 0
; body
#endloop
```
```
#ifzero k       ; using (current cell + k) as temporary
; true branch   ; if value of current cell = 0
#else
; false branch  ; if value of current cell != 0
#end
```
```
#using k        ; shift for k cells
; body
#end            ; return for k cells back
```
```
#inline
; inline brainfuck code
#end
```
