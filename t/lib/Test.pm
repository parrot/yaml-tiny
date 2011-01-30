# There is no "export" in nqp. So avoid putting subs into Test namespace.
#module Test;

our sub yaml_ok($yaml, $expected, $description, *%adverbs) {
    my $parser := YAML::Tiny.new;
    try {
        my $result := $parser.read_string($yaml);
        #print("result: "); _dumper($result);
        #print("expected: "); _dumper($expected);
        is_deeply($expected, $result, $description, todo => %adverbs<todo> ?? $description !! 0);

        CATCH {
            nok(1, "Parse failed '{ $! }'", %adverbs<todo> ?? $description !! 0);
        }
    }
}

# NQP semantic doesn't handle fatarrow well. We can have quoted keys.
# So, use special helper for tests.
our sub myhash(*@pos, *%named) {
    for @pos -> $k, $v {
        %named{$k} := $v;
    }
    %named;
}

Q:PIR {
    # We want Test::More features for testing. Not NQP's builtin.
    .include "test_more.pir"
    load_bytecode "dumper.pbc"
}

# vim: ft=perl6
