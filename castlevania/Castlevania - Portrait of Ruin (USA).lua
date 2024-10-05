-- RNG value at 0x0F627C in Main RAM

-- The item drop function calls RNG two times (possibly three, but the third doesn't seem to affect anything)
-- 1. Compare at 21D9758, followed by a series of "cc" (carry clear) conditional instructions.
--    If the conditional moves succeed, a common item will drop. Otherwise, a rare item will drop. (Might be the other way around)
-- 2. Branch at 21D9798. If the branch is NOT taken, then an item will drop, which will be either a rare or common drop based on RNG call 1.

-- All instructions/values are little endian.

INST_ITEM = 0x1D9758
INST_DROP = 0x1D9798

NOP = 0xE1A00000

function enable_common()
	memory.write_u32_le(INST_ITEM, 0xE3500000, "Main RAM") -- cmp r0,0h
	memory.write_u32_le(INST_DROP, NOP, "Main RAM")
end

function enable_rare()
	memory.write_u32_le(INST_ITEM, 0xE3700000, "Main RAM") -- cmn r0,0h
	memory.write_u32_le(INST_DROP, NOP, "Main RAM")
end

function disable()
	memory.write_u32_le(INST_ITEM, 0xE1500009, "Main RAM") -- cmp r0,r9
	memory.write_u32_le(INST_DROP, 0xAA000013, "Main RAM") -- bge 21D97ECh
end

event.onexit(disable)
while true do
	local keys = input.get()
	if keys['I'] then
		enable_common()
	end
	if keys['O'] then
		enable_rare()
	end
	if keys['P'] then
		disable()
	end
	emu.frameadvance()
end
