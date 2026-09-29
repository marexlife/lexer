const std = @import("std");
const Token = @import("lexing.zig").Token;

pub const ParserError = error{
    OutOfRange,
};

pub const TokenStream = struct {
    const Self = TokenStream;

    tokens: std.ArrayList(Token),
    progress: i32,

    pub fn from(tokens: std.ArrayList(Token)) Self {
        return Self{
            .tokens = tokens,
            .progress = 0,
        };
    }

    pub fn current(self: *Self) ParserError!*Token {
        return if (self.progress > 0) {
            self.tokens[self.progress];
        } else {
            ParserError.OutOfRange;
        };
    }

    pub fn increase(self: *Self) !void {
        self.progress += 1;
    }
};

pub fn parse(tokens: std.ArrayList(Token)) !void {
    var token_stream = TokenStream.from(tokens);

    try token_stream.increase();
}
