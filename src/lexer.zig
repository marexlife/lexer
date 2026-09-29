const std = @import("std");

pub const Token = union(enum) {
    Print,
    Comma,
    Indent: []u8,
};

pub fn lex(gpa: std.mem.Allocator, source_text: []const u8) !std.ArrayList(Token) {
    var tokens: std.ArrayList(Token) = .empty;
    var last_word: std.ArrayList(u8) = .empty;
    defer last_word.deinit(gpa);

    for (source_text) |source_text_char| {
        const maybe_token = createTokenFromChar(source_text_char);

        if (maybe_token) |token| {
            try pushLastWordAndToken(gpa, &tokens, last_word, token);

            continue;
        }

        switch (source_text_char) {
            ' ' => try pushLastWord(gpa, &tokens, last_word),
            else => try last_word.append(gpa, source_text_char),
        }
    }

    try pushLastWord(gpa, &tokens, last_word);

    return tokens;
}

fn pushLastWordAndToken(gpa: std.mem.Allocator, tokens: *std.ArrayList(Token), last_word: std.ArrayList(u8), token: Token) !void {
    try pushLastWord(gpa, tokens, last_word);
    try pushToken(gpa, tokens, token);
}

fn pushLastWord(gpa: std.mem.Allocator, tokens: *std.ArrayList(Token), last_word: std.ArrayList(u8)) !void {
    const token = try createTokenFromWord(gpa, last_word);

    try pushToken(gpa, tokens, token);
}

inline fn pushToken(gpa: std.mem.Allocator, tokens: *std.ArrayList(Token), token: Token) !void {
    try tokens.append(gpa, token);
}

inline fn createTokenFromChar(char: u8) ?Token {
    return switch (char) {
        ',' => Token.Comma,
        else => null,
    };
}

inline fn createTokenFromWord(gpa: std.mem.Allocator, last_word: std.ArrayList(u8)) !Token {
    if (std.mem.eql(u8, last_word.items, "print")) {
        return Token.Print;
    } else {
        const new_items = try last_word.clone(gpa);

        return Token{ .Indent = new_items.items };
    }
}
