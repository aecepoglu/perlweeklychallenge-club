#!/usr/bin/perl
use strict;

#Usage: ch-2.pl STRING

sub is_pali {
    my $w = $_[0];           #word
    if (length $w == 1) {return 0;} #single not counted
    my $mid = (int (length $w) / 2) - 1 ;
    my @c = split //, $w;    #characters
    my @stack = map {$c[$_]} (0..$mid);
    my $pointer;
    if ( (length $w) % 2 == 1) {        
        $pointer = $mid+2;     #e.g.  length $w = 3, $mid = 0, $pointer = 2 
    }
    else {
        $pointer = $mid+1;     #e.g.  length $w = 6, $mid = 2, $pointer = 3
    }
    while ($c[$pointer] eq $stack[$#stack]) {
        pop @stack;
        $pointer++;
        last if @stack == ();
    }
    if (@stack == ()) {
        return 1;
    }
    else {
        return 0;
    }
}


my $S = "abaaba";   #default setting
$S = $ARGV[0] if $ARGV[0];


sub part_func {         #partitions, generated by binary strings 
    my $word = $_[0];
    my $bstring = sprintf "%b", $_[1];
    my @warray = split //, $word;
    my @b = split //, $bstring;
    my @ans = ();
    my $temp = "";
    for my $k (0..$#warray) {
        if ($b[$k] == 1) {
            $temp .= $warray[$k];
       } else {
            push @ans,$temp;
            $temp = $warray[$k];
        }
    }
    push @ans, $temp;
    return @ans;
}

my %hresult;
my $n = length $S;

for my $seperator (2**($n-1)+1..2**$n) {
    my @p = grep {is_pali $_} part_func($S, $seperator);
    my $r = join ",", @p unless @p == ();
    $hresult{$r} = 1;
}


sub need_to_remove_subsequence {
    if (
      index($_[0], ",".$_[1]) == -1
        and
      index($_[0], $_[1].",") == -1
    ) {
        return 0;
    }
    else {
        return 1;
    }
}


#remove_subsequence
my @aresult = keys %hresult;
for my $peter (@aresult) {
    for my $pierre (@aresult) {
        unless ($peter eq $pierre or $peter eq $S) {
            if (need_to_remove_subsequence($peter,$pierre)) {
                delete $hresult{$pierre};
            }
        }
    }
}

#print answer

print "string: ", $S,"\n\n";
print join "\n", sort keys %hresult;
print "\n";

#
# abaaba -> 
# aa
# baab
# aba, aba
# abaaba
#
# aabaab -> #Example 1
# aabaa
## aa, baab
# aba
#
# abbaba -> #Example 2
# abba
# bb, aba
# bab
