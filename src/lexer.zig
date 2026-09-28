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
    var tokens = std.ArrayList(Token){};

    var last_word = std.ArrayList(u8){};
    defer last_word.deinit(heap);

    for (source_text) |source_text_char| {
        switch (source_text_char) {
            ' ' => {
                const token = createToken(last_word);

                tokens.append(heap, token);
            },
            else => {
                last_word.append(heap, source_text_char);
            },
        }
    }

    return tokens;
}

fn createToken(text: std.ArrayList(u8)) Token {
    if (std.mem.eql(u8, text, "print")) {
        return Token.Print;
    } else {
        return Token{ .Indent = text };
    }
}
