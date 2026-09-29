const std = @import("std");
const lexer = @import("lexer.zig");
const Token = lexer.Token;
const lex = lexer.lex;

pub fn main() !void {
    const allocator = std.heap.page_allocator;
    const source_text = "print test, 2";

    const tokens = try lex(allocator, source_text);

    for (tokens.items) |token| {
        std.debug.print("{}", .{token});
    }
}
