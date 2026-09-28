const std = @import("std");
const lexer = @import("lexer.zig");
const Token = lexer.Token;
const lex = lexer.lex;

pub fn main() !void {
    const source_text = "print test";
    const tokens = try lex(source_text);

    for (tokens) |token| {
        std.debug.print("{}", .{token});
    }
}
