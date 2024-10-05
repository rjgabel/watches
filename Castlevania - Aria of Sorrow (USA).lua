-- RNG value at 0x000008 in EWRAM

-- The item drop function calls RNG three times.
-- 1. RNG call at 80684E0, branch at 80684F0. If the branch is NOT taken, then a soul drops and we skip the other two RNG calls.
-- 2. RNG call at 806856A, branch at 806857A. If the branch is NOT taken, then if an item drops, it will be a rare drop. If it IS taken, then any item drop will be a COMMON drop.
-- 3. RNG call at 80685B2, branch at 80685C2. If the branch is NOT taken, then an item will drop, which will be either a rare or common drop based on RNG call 2.

-- 80684F0  1C D2          BCS $0806852C
-- 806857A  04 D2          BCS $08068586
-- 80685C2  1B D2          BCS $080685FC

function enable_common()
	memory.write_u16_le(0x0684F0, 0xE01C, "ROM")
	memory.write_u16_le(0x06857A, 0xE004, "ROM")
	memory.write_u16_le(0x0685C2, 0xB000, "ROM")
end

function enable_rare()
	memory.write_u16_le(0x0684F0, 0xE01C, "ROM")
	memory.write_u16_le(0x06857A, 0xB000, "ROM")
	memory.write_u16_le(0x0685C2, 0xB000, "ROM")
end

function enable_soul()
	memory.write_u16_le(0x0684F0, 0xB000, "ROM")
	memory.write_u16_le(0x06857A, 0xD204, "ROM")
	memory.write_u16_le(0x0685C2, 0xD21B, "ROM")
end

function disable()
	memory.write_u16_le(0x0684F0, 0xD21C, "ROM")
	memory.write_u16_le(0x06857A, 0xD204, "ROM")
	memory.write_u16_le(0x0685C2, 0xD21B, "ROM")
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
		enable_soul()
	end
	emu.frameadvance()
end