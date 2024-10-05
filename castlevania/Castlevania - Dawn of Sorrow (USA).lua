-- RNG value at 0x0C07E4 in Main RAM

-- The item drop function calls RNG three times.
-- 1. Branch at 21C3AC0. If the branch is NOT taken, then a soul drops. Unlike in Aria, a soul and an item can drop simultaneously.
-- 2. Compare at 21C3BB0, followed by a series of "lt" (less than) conditional moves.
--    If the conditional moves succeed, a rare item will drop. Otherwise, a common item will drop.
-- 3. Branch at 21C3BF0. If the branch is NOT taken, then an item will drop, which will be either a rare or common drop based on RNG call 2.

-- All instructions/values are little endian.

-- NB: we use the absolutely insane instruction cmp r14,r14,lsl 1h to always ensure the lt (less than) conditional moves succeed.
-- r14 is the link register, and this compares r14 to r14 shifted left by one, so this will always succeed if the link register is
-- nonzero and does not have the MSB set (likely always true in this scenario)
-- using r15 (pc) for this is apparently verboten according to https://developer.arm.com/documentation/dui0473/m/arm-and-thumb-instructions/cmp-and-cmn

INST_SOUL = 0x1C3AC0
INST_RARE = 0x1C3BB0
INST_ITEM = 0x1C3BF0

NOP = 0xE1A00000

function enable_common()
	disable()
	memory.write_u32_le(INST_RARE, 0xE1500000, "Main RAM") -- cmp r0,r0
	memory.write_u32_le(INST_ITEM, NOP, "Main RAM")
end

function enable_rare()
	disable()
	memory.write_u32_le(INST_RARE, 0xE15E008E, "Main RAM") -- cmp r14,r14,lsl 1h
	memory.write_u32_le(INST_ITEM, NOP, "Main RAM")
end

function enable_soul()
	disable()
	memory.write_u32_le(INST_SOUL, NOP, "Main RAM")
end

function disable()
	memory.write_u32_le(INST_SOUL, 0xCA000007, "Main RAM") -- bgt 21C3AE4h
	memory.write_u32_le(INST_RARE, 0xE1500006, "Main RAM") -- cmp r0,r6
	memory.write_u32_le(INST_ITEM, 0xAA000015, "Main RAM") -- bge 21C3C4Ch
end

event.onexit(disable)
while true do
	local keys = input.get()
	if keys['U'] then
		enable_common()
	end
	if keys['I'] then
		enable_rare()
	end
	if keys['O'] then
		enable_soul()
	end
	if keys['P'] then
		disable()
	end
	emu.frameadvance()
end
