const std = @import("std");
const lexing = @import("lexing.zig");
const parsing = @import("parsing.zig");

const TokenKind = lexing.TokenKind;
const lex = lexing.lex;
const parse = parsing.parse;

pub fn main(init: std.process.Init) !void {
    const source_text = "print test, 2";

    var tokens = try lexing.lex(init.gpa, source_text);
    defer tokens.clearAndFree(init.gpa);

    try parse(tokens);
}
