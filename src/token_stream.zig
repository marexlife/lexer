const std = @import("std");
const lexing = @import("lexing.zig");
const Token = lexing.Token;
const TokenTag = lexing.TokenTag;
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

    pub inline fn kind(self: *Self) TokenTag {
        return self.tokens.items[self.progress].kind;
    }

    pub inline fn matches(self: *Self, token: TokenTag) bool {
        return self.tokens.items[self.progress] == token;
    }

    pub inline fn advanceIfMatches(self: *Self, token: TokenTag) bool {
        const matched = self.matches(token);

        self.progress += 1;

        return matched;
    }

    pub inline fn advanceIfMatchesOrError(self: *Self, token: TokenTag) ParseError!void {
        const matched = self.matches(token);

        self.progress += 1;

        return switch (matched) {
            true => {},
            false => ParseError.MismatchedToken,
        };
    }

    pub inline fn next(self: *Self) *Token {
        return self.tokens.items[self.progress + 1];
    }

    pub fn tryNext(self: *Self) ParseError!*Token {
        const next_progress = self.progress + 1;

        if (next_progress > self.tokens.items.len) {
            return ParseError.OutOfBounds;
        }

        return self.tokens.items[next_progress];
    }

    pub inline fn nextKind(self: *Self) TokenKind {
        return self.next().kind;
    }

    pub inline fn tryNextKind(self: *Self) !TokenKind {
        const next_token = try self.tryNext();

        return next_token.kind;
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
