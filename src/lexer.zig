const std = @import("std");

pub const Token = union(enum) {
    Print,
    Indent: []u8,
};

pub fn lex(source_text: []const u8, gpa: std.mem.Allocator) !std.ArrayList(Token) {
    var tokens: std.ArrayList(Token) = .empty;
    var last_word: std.ArrayList(u8) = .empty;
    defer last_word.deinit(gpa);

    for (source_text) |source_text_char| {
        switch (source_text_char) {
            ' ' => {
                const token = try createToken(last_word, gpa);
                try tokens.append(gpa, token);
            },
            else => try last_word.append(gpa, source_text_char),
        }
    }

    const token = try createToken(last_word, gpa);
    try tokens.append(gpa, token);

    return tokens;
}

fn createToken(text: std.ArrayList(u8), gpa: std.mem.Allocator) !Token {
    if (std.mem.eql(u8, text.items, "print")) {
        return Token.Print;
    } else {
        const new_items = try text.clone(gpa);

        return Token{ .Indent = new_items.items };
    }
}
