#!perl -Tw

use warnings;
use strict;
use Test::More tests => 3;

BEGIN {
    use_ok( 'HTML::Tidy' );
}

my $html = do { local $/; <DATA> };

my @expected_messages = split /\n/, q{
DATA (3:1) Error: <neck> is not recognized!
DATA (8:1) Error: <x> is not recognized!
DATA (9:1) Error: <y> is not recognized!
};

chomp @expected_messages;
shift @expected_messages; # First one's blank

my $tidy = new HTML::Tidy({config_file => 't/cfg-for-parse.cfg' });
isa_ok( $tidy, 'HTML::Tidy' );

$tidy->parse( 'DATA', $html );

my @returned = map { $_->as_string } $tidy->messages;
s/[\r\n]+\z// for @returned;
is_deeply( \@returned, \@expected_messages, 'Matching errors' );


__DATA__
<HTML>
<HEAD>
<NECK>...</NECK>
<TITLE>Foo
</HEAD>
<BODY>
</B>
<X>
<Y>
</I>
</BODY>
