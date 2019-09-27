list disk
select disk # Note: Select the disk you want to fix

list partition
select partition # EFI
assign letter=s

list partition
select partition # windows
assign letter=C
exit

bcdboot C:\windows /s S: