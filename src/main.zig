const std = @import("std");
const lexer = @import("lexer.zig");
const Token = lexer.Token;
const lex = lexer.lex;

pub fn main() !void {
    const source_text = "";
    const tokens_len = 100;

    const tokens = try lex(source_text, tokens_len);

    for (tokens) |token| {
        std.debug.print("{}", token);
    }
}
