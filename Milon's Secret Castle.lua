--https://github.com/spannerisms/milondasm

memory.usememorydomain("PRG ROM")

-- Cheese bonus game
memory.write_u8(0x157A, 0xA9)
memory.write_u8(0x157B, 0xFF)
memory.write_u8(0x157C, 0xEA)

-- Prevent damage
memory.write_u8(0x5236, 0x60)

addrs = {
	0x69F7, -- 01 - ROOM 01
	0x6A24, -- 02 - ROOM 02
	0x6A50, -- 03 - ROOM 04
	0x6A7E, -- 04 - ROOM 05
	0x6AAB, -- 05 - ROOM 06
	-- 06 - ROOM 08 (handled separately)
	0x6B03, -- 07 - ROOM 07
	-- 08 - ROOM 09, ROOM 15, ROOM 16, ROOM 17, ROOM 18 (handled separately)
	0x6B4D, -- 09 - ROOM 0A, ROOM 13, ROOM 14
	-- 0A - ROOM 0B, ROOM 12 (handled separately)
	-- 0B - ROOM 0C (handled separately)
	-- 0C - ROOM 0D (handles separetely)
	-- 0D - ROOM 0E, ROOM 10 (handled separately)
	-- 0E - ROOM 0F (handled separately)
}
for i,v in ipairs(addrs) do
	memory.write_u8(v, 0xFF)
	a = memory.read_u8(v+1)
	a = a | 0x0F
	memory.write_u8(v+1, a)
end

-- 06 - ROOM 08
memory.write_u8(0x6AD9, 0x51)
memory.write_u8(0x6ADA, 0x25)

-- 08 - ROOM 09, ROOM 15, ROOM 16, ROOM 17, ROOM 18
memory.write_u8(0x6B27, 0xFF)
-- (only 0x1B total tiles)

-- 0A - ROOM 0B, ROOM 12
memory.write_u8(0x6B78, 0x55)
memory.write_u8(0x6B79, 0x55)

-- 0B - ROOM 0C
-- 0C - ROOM 0D
memory.write_u8(0x6BA0, 0xAA)
memory.write_u8(0x6BA1, 0x2A)

-- 0D - ROOM 0E, ROOM 10
memory.write_u8(0x6BC8, 0xAA)
memory.write_u8(0x6BC9, 0xAA)

-- 0E - ROOM 0F
memory.write_u8(0x6BF0, 0x55)
memory.write_u8(0x6BF1, 0x55)