#!/usr/bin/perl -w

use strict;

use Test::More tests => 36;
use BSSolv;

sub dodiff {
  my ($a1, $a2, $x, $msg) = @_;
  my $n1 = BSSolv::diffdepth_meta($a1, $a2);
  is($n1, $x, "$msg - normal");
  my $n2 = BSSolv::diffdepth_meta($a1, join("\n", @$a2).(@$a2 ? "\n" : ''));
  is($n2, $x, "$msg - joined");
  $n1 = BSSolv::diffdepth_meta($a2, $a1);
  is($n1, $x, "$msg - normal reversed");
  $n2 = BSSolv::diffdepth_meta($a2, join("\n", @$a1).(@$a1 ? "\n" : ''));
  is($n2, $x, "$msg - joined reversed");
}

my @m1;
my @m2;

dodiff(\@m1, \@m2, 0, 'empty1');
push @m1, 'bbb1f01d98683e5cad6f396ae49ce66c  dwz';
dodiff(\@m1, \@m2, 1, 'empty2');
push @m2, 'bbb1f01d98683e5cad6f396ae49ce66c  dwz';
dodiff(\@m1, \@m2, 0, 'identical1');
@m1 = ();
dodiff(\@m1, \@m2, 1, 'empty3');

@m1 = split("\n", <<'EOF');
bbb1f01d98683e5cad6f396ae49ce66c  dwz
bbb1f01d98683e5cad6f396ae49ce66c  aaa
EOF
@m2 = split("\n", <<'EOF');
bbb1f01d98683e5cad6f396ae49ce66c  dwz
EOF
dodiff(\@m1, \@m2, 2, 'one aaa');

@m2 = @m1;
dodiff(\@m1, \@m2, 0, 'identical aaa');

@m1 = split("\n", <<'EOF');
bbb1f01d98683e5cad6f396ae49ce66c  dwz
bbb1f01d98683e5cad6f396ae49ce66c  aba
EOF
dodiff(\@m1, \@m2, 2, 'different aaa');

@m1 = split("\n", <<'EOF');
bbb1f01d98683e5cad6f396ae49ce66c  dwz
bbb1f01d98683e5cad6f396ae49ce66c  aaa
bbb1f01d98683e5cad6f396ae49ce66c  aaa/xx
EOF
dodiff(\@m1, \@m2, 3, 'different aaa/xx');

push @m1, 'bbb1f01d98683e5cad6f396ae49ce66c  aaa/yy';
push @m2, 'bbb1f01d98683e5cad6f396ae49ce66c  aaa/yy';
dodiff(\@m1, \@m2, 3, 'different aaa/xx 2');


