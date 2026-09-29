const std = @import("std");
const Token = @import("lexing.zig").Token;

pub const ParseError = error{
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

    pub fn try_increase(self: *Self) ParseError!void {
        if (!isAtEnd(self)) {
            self.increase();
        } else {
            return ParseError.OutOfBounds;
        }
    }

    pub inline fn increase(self: *Self) void {
        self.progress += 1;
    }

    pub inline fn isAtEnd(self: *Self) bool {
        return self.progress >= self.tokens.items.len;
    }
};

pub fn parse(tokens: std.ArrayList(Token)) ParseError!void {
    var token_stream = TokenStream.from(tokens);

    while (!token_stream.isAtEnd()) {
        token_stream.increase();
    }
}
