package Parser;

use strict;
use warnings;

sub parse {
    my $instruction = shift;
    return $instruction if $instruction =~ /^\s+$/;
    return $instruction if $instruction =~ s/LD\s(\d+)/\$register = $1;/;
    return $instruction if $instruction =~ s/LD\s(%\S+)/\$register = plc_read("$1");/;
    return $instruction if $instruction =~ s/ST\s(%\S+)/plc_write("$1", \$register);/;
    return $instruction if $instruction =~ s/AND\s(\d+)/\$register = \$register && $1;/;
    return $instruction if $instruction =~ s/AND\s(%\S+)/\$register = \$register && plc_read("$1");/;
    return $instruction if $instruction =~ s/OR\s(\d+)/\$register = \$register || $1;/;
    return $instruction if $instruction =~ s/OR\s(%\S+)/\$register = \$register || plc_read("$1");/;
    return $instruction if $instruction =~ s/ADD\s(\d+)/\$register = \$register += $1;/;
    return $instruction if $instruction =~ s/ADD\s(%\S+)/\$register = \$register += plc_read("$1");/;
    return $instruction if $instruction =~ s/SUB\s(\d+)/\$register = \$register -= $1;/;
    return $instruction if $instruction =~ s/SUB\s(%\S+)/\$register = \$register -= plc_read("$1");/;
    return $instruction if $instruction =~ s/MUL\s(\d+)/\$register = \$register *= $1;/;
    return $instruction if $instruction =~ s/MUL\s(%\S+)/\$register = \$register *= plc_read("$1");/;
    return $instruction if $instruction =~ s/DIV\s(\d+)/\$register = \$register \/= $1;/;
    return $instruction if $instruction =~ s/DIV\s(%\S+)/\$register = \$register \/= plc_read("$1");/;
    die "Can't parse $instruction";
}

sub parse_file {
    my @scripts = ();
    
    open(my $instructions,  "<",  shift) or die "Can't open $!";
    while(<$instructions>) {
        my $script = parse($_);
        push @scripts, $script;
    }

    open(my $out,  ">",  "step.pl")  or die "Can't open $!";
    print $out @scripts;

    close $instructions or die "$instructions: $!";
    close $out or die "$out: $!";
}

1;
