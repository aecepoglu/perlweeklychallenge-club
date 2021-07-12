#!/usr/local/bin/perl

use strict;

use warnings;
use feature qw(say);
use Test::More;
use Benchmark qw(cmpthese timethis);
use Data::Dumper qw(Dumper);
no warnings 'numeric';

my @TESTS = (
  [ '03:10', 35 ],
  [ '04:00', 120 ],
  [ '08:00', 120 ],
  [ '16:00', 120 ],
  [ '18:00', 180 ],
  [ '20:00', 120 ],
);

is( clock_angle($_->[0]), $_->[1] ) foreach @TESTS;
is( clock_angle_1_liner($_->[0]), $_->[1] ) foreach @TESTS;
is( clock_angle_fast($_->[0]), $_->[1] ) foreach @TESTS;
done_testing;

cmpthese( 1_000_000, {
  's' => sub { clock_angle($_->[0]) foreach @TESTS },
  '1' => sub { clock_angle_1_liner($_->[0]) foreach @TESTS },
  'f' => sub { clock_angle_fast($_->[0]) foreach @TESTS },
});

sub clock_angle {
## The difference is: hr*30+min/2 - min*12
## Modulo is int based so to avoid issue
## when min is even we multiply by 2 take
## modulus and then divide by 2.
## If value is > 180 then we subtract from
## 360....
  my($h,$m) = split /:/,shift;
  my $t = abs($h%12*30-$m*5.5);
  return $t > 180 ? 360-$t : $t;
}

sub clock_angle_1_liner {
  180-abs(abs((substr$_[0],0,2)%12*30-5.5*substr$_[0],3)-180);
}

sub clock_angle_fast {
  180-abs(abs($_[0]%12*30-5.5*substr$_[0],3)-180);
}
