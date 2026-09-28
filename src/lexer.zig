const std = @import("std");

pub const LexError = error{
    OutOfMemory,
};

pub const Token = union(enum) {
    Print,
    Indent: []u8,
};

pub fn lex(source_text: []u8, init_token_len: usize) LexError![]Token {
    const heap = std.heap.page_allocator;
    const last_word_expected_size: usize = 100;

    var chars_pushed: usize = 0;

    var tokens: []Token = try heap.alloc(Token, init_token_len);
    var tokens_pushed: usize = 0;

    const last_word: []u8 = try heap.alloc(u8, last_word_expected_size);
    defer heap.free(last_word);

    for (source_text) |element| {
        switch (element) {
            ' ' => {
                tokens_pushed += 1;

                if (tokens_pushed > tokens.len) {
                    tokens.len *= 2;
                    tokens.ptr = try heap.realloc(u8, tokens.len);
                    (*tokens) = createToken(last_word);
                }
            },
            else => {
                chars_pushed += 1;

                if (chars_pushed > last_word.len) {
                    last_word.len *= 2;

                    last_word.ptr = try heap.realloc(last_word, last_word.len);
                    (*last_word) = *source_text;
                }
            },
        }
    }

    return tokens;
}

fn createToken(text: []u8) Token {
    if (std.mem.eql(u8, text, "print")) {
        return Token.Print;
    } else {
        return Token.Ident(text);
    }
}
