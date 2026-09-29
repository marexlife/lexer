const std = @import("std");
const Token = @import("lexing.zig").Token;

pub const ParserError = error{
    OutOfBounds,
};

pub const TokenStream = struct {
    const Self = TokenStream;

    tokens: std.ArrayList(Token),
    progress: i32,

    pub inline fn from(tokens: std.ArrayList(Token)) Self {
        return Self{
            .tokens = tokens,
            .progress = 0,
        };
    }

    pub inline fn current(self: *Self) *Token {
        return self.tokens[self.progress];
    }

    pub fn try_increase(self: *Self) ParserError!void {
        if (!isAtEnd(self)) {
            self.increase();
        } else {
            return ParserError.OutOfBounds;
        }
    }

    pub inline fn increase(self: *Self) void {
        self.progress += 1;
    }

    pub inline fn isAtEnd(self: *Self) bool {
        return self.progress >= self.tokens.items.len;
    }
};

pub fn parse(tokens: std.ArrayList(Token)) ParserError!void {
    var token_stream = TokenStream.from(tokens);

    while (!token_stream.isAtEnd()) {
        token_stream.increase();
    }
}
