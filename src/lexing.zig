const std = @import("std");

pub const TokenTag = enum {
    Print,
    Comma,
    Ident,
};

pub const TokenKind = union(TokenTag) {
    Print,
    Comma,
    Ident: []u8,
};

pub const SourcePos = struct {
    line: usize,
    column: usize,
};

pub const Token = struct {
    const Self = Token;

    kind: TokenKind,
    source_pos: SourcePos,

    pub inline fn from(content: TokenKind, source_pos: SourcePos) Self {
        return Self{
            content,
            source_pos,
        };
    }

    pub inline fn getContent(self: *Self) TokenKind {
        return self.kind;
    }
};

pub fn lex(gpa: std.mem.Allocator, source_text: []const u8) !std.ArrayList(TokenKind) {
    var tokens: std.ArrayList(TokenKind) = .empty;
    var last_word: std.ArrayList(u8) = .empty;
    var last_was_flushable = false;

    defer last_word.deinit(gpa);

    for (source_text) |source_text_char| {
        var this_is_flushable = false;
        defer last_was_flushable = this_is_flushable;

        const maybe_token = createTokenFromChar(source_text_char);

        if (maybe_token) |token| {
            try pushLastWordAndToken(gpa, &tokens, last_word, token, last_was_flushable);

            continue;
        }

        switch (source_text_char) {
            ' ' => try pushLastWord(gpa, &tokens, last_word, last_was_flushable),
            else => {
                this_is_flushable = true;

                try last_word.append(gpa, source_text_char);
            },
        }
    }

    try pushLastWord(gpa, &tokens, last_word, last_was_flushable);

    return tokens;
}

fn pushLastWordAndToken(gpa: std.mem.Allocator, tokens: *std.ArrayList(TokenKind), last_word: std.ArrayList(u8), token: TokenKind, last_was_flushable: bool) !void {
    try pushLastWord(gpa, tokens, last_word, last_was_flushable);

    try pushToken(gpa, tokens, token);
}

fn pushLastWord(gpa: std.mem.Allocator, tokens: *std.ArrayList(TokenKind), last_word: std.ArrayList(u8), last_was_flushable: bool) !void {
    if (!last_was_flushable) {
        return;
    }

    const token = try createTokenFromWord(gpa, last_word);

    try pushToken(gpa, tokens, token);
}

inline fn pushToken(gpa: std.mem.Allocator, tokens: *std.ArrayList(TokenKind), token: TokenKind) !void {
    try tokens.append(gpa, token);
}

inline fn createTokenFromChar(char: u8) ?TokenKind {
    return switch (char) {
        ',' => TokenKind.Comma,
        else => null,
    };
}

inline fn createTokenFromWord(gpa: std.mem.Allocator, last_word: std.ArrayList(u8)) !TokenKind {
    if (std.mem.eql(u8, last_word.items, "print")) {
        return TokenKind.Print;
    } else {
        const new_items = try last_word.clone(gpa);

        return TokenKind{ .Ident = new_items.items };
    }
}
