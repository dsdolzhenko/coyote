target remote :1234

set height 0
set width 0

define q
	monitor quit
end

define reg
	monitor info registers
end

define reset
	monitor system_reset
end
