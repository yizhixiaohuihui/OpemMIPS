.org 0x0                     # program address start from 0x0 
.global _start              # define global symbol '_start'
.set noat                    # permit use reg '$1' freely
_start:
  ori $1, $0, 0x1100   # $1 = $0 | 0x1100 = 0x1100
  ori $2, $0, 0x0020   # $2 = $0 | 0x0020 = 0x0020
  ori $3, $0, 0xff00     # $3 = $0 | 0xff00 = 0xff00
  ori $4, $0, 0xffff       # $4 = $0 | 0xffff = 0xffff

