const std = @import("std");
const lexer = @import("lexer.zig");
const Token = lexer.Token;
const lex = lexer.lex;

pub fn main() !void {
    const source_text = "print test";
    const tokens = try lex(source_text, std.heap.page_allocator);

    for (tokens.items) |token| {
        std.debug.print("{}", .{token});
    }
}
