-- RNG value at 0x000008 in EWRAM

-- Branches:
-- RARE DROP: 		803146C  0F D2          BCS $0803148E
-- COMMON DROP:		80314BA  15 D2          BCS $080314E8
-- In both cases, the branch is only taken if the drop does *not* happen.
-- Therefore, if we want a rare drop, we need to change 803146C to a no-op (00 B0) instead.
-- If we want a common drop, we need to change 80314BA to a no-op as well as change 803146C to always branch (BAL), 0F E0

function enable_rare()
	memory.write_u16_le(0x03146C, 0xB000, "ROM")
	memory.write_u16_le(0x0314BA, 0xD215, "ROM")
end

function enable_common()
	memory.write_u16_le(0x03146C, 0xE00F, "ROM")
	memory.write_u16_le(0x0314BA, 0xB000, "ROM")
end

function disable()
	memory.write_u16_le(0x03146C, 0xD20F, "ROM")
	memory.write_u16_le(0x0314BA, 0xD215, "ROM")
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