const std = @import("std");

pub const LexError = error{
    OutOfMemory,
};

pub const Token = union(enum) {
    Print,
    Indent: []u8,
};

pub fn lex(source_text: []const u8) LexError!std.ArrayList(Token) {
    const heap = std.heap.page_allocator;

    var tokens: std.ArrayList(Token) = .empty;
    var last_word: std.ArrayList(u8) = .empty;
    defer last_word.deinit(heap);

    for (source_text) |source_text_char| {
        switch (source_text_char) {
            ' ' => {
                const token = try createToken(last_word);
                try tokens.append(heap, token);
            },
            else => try last_word.append(heap, source_text_char),
        }
    }

    const token = try createToken(last_word);
    try tokens.append(heap, token);

    return tokens;
}

fn createToken(text: std.ArrayList(u8)) !Token {
    const heap = std.heap.page_allocator;

    if (std.mem.eql(u8, text.items, "print")) {
        return Token.Print;
    } else {
        const new_items = try text.clone(heap);

        return Token{ .Indent = new_items.items };
    }
}
