if memory.read_int(memory.script_global(1835502 + 4 + 1 + (players.user() * 3))) == 1 then 
    memory.write_int(memory.script_global(2815059 + 1856 + 17), -1)
    memory.write_int(memory.script_global(2359296 + 1 + 5149 + 13), 2880000)
else
    util.toast("You don't currently have a bounty.")
end