const std = @import("std");
const lexing = @import("lexing.zig");
const Token = lexing.Token;
const TokenKind = lexing.TokenKind;

pub const ParseError = error{
    OutOfBounds,
    MismatchedToken,
};

pub const TokenStream = struct {
    const Self = TokenStream;

    tokens: std.ArrayList(Token),
    progress: usize,

    pub inline fn from(tokens: std.ArrayList(Token)) Self {
        return Self{
            .tokens = tokens,
            .progress = 0,
        };
    }

    pub inline fn current(self: *Self) *Token {
        return self.tokens.items[self.progress];
    }

    pub inline fn matches(self: *Self, token: TokenKind) bool {
        return self.tokens.items[self.progress] == token;
    }

    pub inline fn advanceIfMatches(self: *Self, token: Token) bool {
        const matched = self.matches(token);

        self.progress += 1;

        return matched;
    }

    pub inline fn advanceIfMatchesOrError(self: *Self, token: Token) ParseError!void {
        const matched = self.matches(token);

        self.progress += 1;

        return switch (matched) {
            true => {},
            false => ParseError.MismatchedToken,
        };
    }

    pub inline fn next(self: *Self) *Token {
        const next_progress = self.progress + 1;

        return self.tokens.items[next_progress];
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

        if (token_stream.advanceIfMatches(Token.Print)) {}
    }
}
