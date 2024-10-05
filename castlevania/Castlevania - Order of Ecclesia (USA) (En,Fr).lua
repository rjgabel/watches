-- RNG value at 0x1389C0 in Main RAM

-- Treasure chest items are determined via two RNG calls per chest:
-- 1. Call at 221AC94. Determines if the chest is "common" (brown) or "rare" (green) based on whether r0 (the returned RNG value) is less than r9.
--    r0 is a random value in a constant range
-- 2. Call at 221AD0C. Generates a random number from 0 to 3 inclusive. Used to index into the map-specific treasure table.

-- The item drop function calls RNG two times
-- 1. Call at 205C740, determines if a common or rare item drops
-- 2. Call at 205C7F8. If the branch is NOT taken, then an item will drop, which will be either a rare or common drop based on RNG call 1.

-- All instructions/values are little endian.

INST_DROP_RARE   = 0x05C740
INST_DROP_ITEM   = 0x05C7F8
INST_GLYPH       = 0x06DF94
INST_CHEST_RARE  = 0x21AC94
INST_CHEST_INDEX = 0x21AD0C

function enable_drop_common()
	memory.write_u32_le(INST_DROP_RARE, 0xE1A0000A, "Main RAM") -- mov r0,r10
	memory.write_u32_le(INST_DROP_ITEM, 0xE3A00000, "Main RAM") -- mov r0,0h
end

function enable_drop_rare()
	memory.write_u32_le(INST_DROP_RARE, 0xE3A00000, "Main RAM") -- mov r0,0h
	memory.write_u32_le(INST_DROP_ITEM, 0xE3A00000, "Main RAM") -- mov r0,0h
end

function disable_drop()
	memory.write_u32_le(INST_DROP_RARE, 0xEBFF5AE6, "Main RAM") -- bl 20332E0h
	memory.write_u32_le(INST_DROP_ITEM, 0xEBFF5AB8, "Main RAM") -- bl 20332E0h
end

function enable_glyph()
	memory.write_u32_le(INST_GLYPH, 0xE3A00000, "Main RAM") -- mov r0,0h
end

function disable_glyph()
	memory.write_u32_le(INST_GLYPH, 0xEBFF14D1, "Main RAM") -- bl 20332E0h
end

function enable_chest_common()
	memory.write_u32_le(INST_CHEST_RARE,  0xE1A00009, "Main RAM") -- mov r0,r9
	memory.write_u32_le(INST_CHEST_INDEX, 0xE3A00000, "Main RAM") -- mov r0,0h
end

function enable_chest_rare()
	memory.write_u32_le(INST_CHEST_RARE,  0xE3A00000, "Main RAM") -- mov r0,0h
	memory.write_u32_le(INST_CHEST_INDEX, 0xE3A00000, "Main RAM") -- mov r0,0h
end

function disable_chest()
	memory.write_u32_le(INST_CHEST_RARE,  0xEBF86191, "Main RAM") -- bl 20332E0h
	memory.write_u32_le(INST_CHEST_INDEX, 0xEBF86173, "Main RAM") -- bl 20332E0h
end

function disable()
	disable_drop()
	disable_glyph()
	disable_chest()
end

event.onexit(disable)
while true do
	local keys = input.get()
	if keys['U'] then
		disable_drop()
		enable_glyph()
		disable_chest()
	end
	if keys['I'] then
		enable_drop_common()
		disable_glyph()
		enable_chest_common()
	end
	if keys['O'] then
		enable_drop_rare()
		disable_glyph()
		enable_chest_rare()
	end
	if keys['P'] then
		disable()
	end
	emu.frameadvance()
end
