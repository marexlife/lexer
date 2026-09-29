const std = @import("std");
const lexing = @import("lexing.zig");
const parsing = @import("parsing.zig");

const Token = lexing.Token;
const lex = lexing.lex;
const parse = parsing.parse;

pub fn main() !void {
    const allocator = std.heap.page_allocator;
    const source_text = "print test, 2";

    const tokens = try lexing.lex(allocator, source_text);

    try parse(tokens);
}
