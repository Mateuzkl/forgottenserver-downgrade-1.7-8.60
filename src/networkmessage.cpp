// Copyright 2023 The Forgotten Server Authors. All rights reserved.
// Use of this source code is governed by the GPL-2.0 License that can be found in the LICENSE file.

#include "otpch.h"

#include "networkmessage.h"

#include "container.h"
#include "creature.h"

std::string_view NetworkMessage::getString(uint16_t stringLen /* = 0*/)
{
	if (stringLen == 0) {
		stringLen = get<uint16_t>();
	}

	if (!canRead(stringLen)) {
		return "";
	}

	auto it = buffer.data() + info.position;
	info.position += stringLen;
	return {reinterpret_cast<char*>(it), stringLen};
}

Position NetworkMessage::getPosition()
{
	Position pos;
	pos.x = get<uint16_t>();
	pos.y = get<uint16_t>();
	pos.z = getByte();
	return pos;
}

static std::string utf8_to_latin1(std::string_view utf8_string) {
	std::string latin1_string;
	latin1_string.reserve(utf8_string.length());
	
	for (size_t i = 0; i < utf8_string.length(); ++i) {
		unsigned char c = utf8_string[i];
		
		// ASCII characters (0-127) are the same in UTF-8 and Latin-1
		if (c < 128) {
			latin1_string += c;
		}
		// Handle 2-byte UTF-8 sequence
		else if ((c & 0xE0) == 0xC0 && i + 1 < utf8_string.length()) {
			unsigned char c2 = utf8_string[i + 1];
			// Check if the second byte is a valid continuation byte
			if ((c2 & 0xC0) == 0x80) {
				int unicode = ((c & 0x1F) << 6) | (c2 & 0x3F);
				if (unicode <= 0xFF) {
					latin1_string += static_cast<char>(unicode);
				} else {
					latin1_string += '?';
				}
				i++; // Skip second byte
			} else {
				// Invalid continuation byte: treat 'c' as a raw Latin-1 char
				latin1_string += c;
			}
		}
		// Handle 3-byte or 4-byte sequences (handled as generic 'not latin1' or invalid fallback)
		else if ((c & 0xF0) == 0xE0 || (c & 0xF8) == 0xF0) {
			// Basic check for valid start of multi-byte sequence
			size_t extra_bytes = (c & 0xF0) == 0xE0 ? 2 : 3;
			bool valid_sequence = (i + extra_bytes < utf8_string.length());
			
			if (valid_sequence) {
				// Verify continuation bytes
				for (size_t j = 1; j <= extra_bytes; ++j) {
					if ((static_cast<unsigned char>(utf8_string[i + j]) & 0xC0) != 0x80) {
						valid_sequence = false;
						break;
					}
				}
			}

			if (valid_sequence) {
				// It is a valid UTF-8 sequence, but results in > 255 codepoint (not Latin-1)
				latin1_string += '?'; 
				i += extra_bytes;
			} else {
				// Invalid sequence or incomplete: treat 'c' as raw Latin-1 char
				latin1_string += c;
			}
		}
		else {
			// Any other byte (e.g. invalid start byte like 10xxxxxx without context), keep as is
			latin1_string += c;
		}
	}
	
	return latin1_string;
}

void NetworkMessage::addString(std::string_view value)
{
	// Convert UTF-8 to Latin-1 before sending to client
	std::string latin1Value = utf8_to_latin1(value);
	
	size_t stringLen = latin1Value.length();
	if (!canAdd(stringLen + 2) || stringLen > 8192) {
		return;
	}

	add<uint16_t>(stringLen);
	std::memcpy(buffer.data() + info.position, latin1Value.data(), stringLen);
	info.position += stringLen;
	info.length += stringLen;
}

void NetworkMessage::addDouble(double value, uint8_t precision /* = 2*/)
{
	addByte(precision);
	add<uint32_t>(static_cast<uint32_t>((value * std::pow(static_cast<float>(10), precision)) +
	                                    std::numeric_limits<int32_t>::max()));
}

void NetworkMessage::addBytes(const char* bytes, size_t size)
{
	if (!canAdd(size) || size > 8192) {
		return;
	}

	std::memcpy(buffer.data() + info.position, bytes, size);
	info.position += size;
	info.length += size;
}

void NetworkMessage::addPaddingBytes(size_t n)
{
	if (!canAdd(n)) {
		return;
	}

	std::fill_n(buffer.data() + info.position, n, 0x33);
	info.length += n;
}

void NetworkMessage::addPosition(const Position& pos)
{
	add<uint16_t>(pos.x);
	add<uint16_t>(pos.y);
	addByte(pos.z);
}

void NetworkMessage::addItemId(uint16_t itemId)
{
	const ItemType& it = Item::items[itemId];
	uint16_t clientId = it.clientId;

	add<uint16_t>(clientId);
}

void NetworkMessage::addItem(uint16_t id, uint8_t count)
{
	addItemId(id);

	const ItemType& it = Item::items[id];
	if (it.stackable) {
		addByte(count);
	} else if (it.isSplash() || it.isFluidContainer()) {
		addByte(fluidMap[count & 7]);
	}
}

void NetworkMessage::addItem(const Item* item)
{
	addItemId(item->getID());

	const ItemType& it = Item::items[item->getID()];
	if (it.stackable) {
		addByte(static_cast<uint8_t>(std::min<uint16_t>(0xFF, item->getItemCount())));
	} else if (it.isSplash() || it.isFluidContainer()) {
		addByte(fluidMap[item->getFluidType() & 7]);
	}
}
