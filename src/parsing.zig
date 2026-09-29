const std = @import("std");
const lexing = @import("lexing.zig");
const TokenContent = lexing.TokenContent;
const TokenKind = lexing.TokenKind;
const TokenStream = @import("token_stream.zig").TokenStream;

pub fn parse(tokens: std.ArrayList(TokenContent)) ParseError!void {
    var token_stream = TokenStream.from(tokens);

    while (!token_stream.isAtEnd()) {
        token_stream.increase();
    }
}

pub const ParseError = error{
    OutOfBounds,
    MismatchedToken,
};
