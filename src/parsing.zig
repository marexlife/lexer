const std = @import("std");
const lexing = @import("lexing.zig");
const token_stream = @import("token_stream.zig");

const ParseError = token_stream.ParseError;
const TokenStream = token_stream.TokenStream;

const TokenKind = lexing.TokenKind;
const TokenTag = lexing.TokenTag;

pub const PrintNode = struct {
    const Self = PrintNode;

    target: []const u8,

    pub fn from(target: []const u8) Self {
        return Self{
            target,
        };
    }
};

pub fn parse(tokens: std.ArrayList(TokenKind)) ParseError!void {
    var stream = TokenStream.from(tokens);

    while (!stream.isAtEnd()) {
        defer stream.increase();

        switch (stream.kind()) {
            .Print => try parsePrint(&stream),
            else => return ParseError.MismatchedToken,
        }
    }
}

fn parsePrint(stream: *TokenStream) ParseError!void {
    const next_kind = try stream.tryNextKind();

    return switch (next_kind) {
        .Ident => PrintNode.from(.Ident),
        else => return ParseError.MismatchedToken,
    };
}
