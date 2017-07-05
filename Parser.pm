package Parser;

use strict;
use warnings;

my @stacks;
our $acc = 0;

sub il_ld {
    my ($not_flag, $register, $operand) = @_;
    my $trans = "$register = ";
    if ($operand =~ /^\d+/) {
        $trans = $trans . "$operand";
    } elsif ($operand =~ /^%\S+/) {
        $trans = $trans . "LocalIO::read(\"$operand\")";
    } else {
        die "Can't parse $operand";
    }
    if ($not_flag) {
        $trans = $trans . " ? 0 : 1";
    }
    $trans = $trans . ";\n";
    return $trans;
}

sub il_st {
    my ($not_flag, $register, $operand) = @_;
    my $trans = "LocalIO::write(";
    if ($operand =~ /^%\S+/) {
        $trans = $trans . "\"$operand\", ";
    } else {
        die "Can't parse $operand";
    }
    $trans = $trans . "$register";
    if ($not_flag) {
        $trans = $trans . " ? 0 : 1";
    }
    $trans = $trans . ");\n";
    return $trans;
}

sub il_and {
    my ($not_flag, $register, $operand) = @_;
    my $trans = "$register = $register && ";
    if ($operand =~ /^\d+/) {
        $trans = $trans . "$operand";
    } elsif ($operand =~ /^%\S+/) {
        $trans = $trans . "LocalIO::read(\"$operand\")";
    } else {
        die "Can't parse $operand";
    }
    if ($not_flag) {
        $trans = $trans . " ? 0 : 1";
    }
    $trans = $trans . ";\n";
    return $trans;
}

sub il_or {
    my ($not_flag, $register, $operand) = @_;
    my $trans = "$register = $register || ";
    if ($operand =~ /^\d+|register/) {
        $trans = $trans . "$operand";
    } elsif ($operand =~ /^%\S+/) {
        $trans = $trans . "LocalIO::read(\"$operand\")";
    } else {
        die "Can't parse $operand";
    }
    if ($not_flag) {
        $trans = $trans . " ? 0 : 1";
    }
    $trans = $trans . ";\n";
    return $trans;
}

sub il_add {
    my ($not_flag, $register, $operand) = @_;
    my $trans = "$register += ";
    if ($operand =~ /^\d+/) {
        $trans = $trans . "$operand";
    } elsif ($operand =~ /^%\S+/) {
        $trans = $trans . "LocalIO::read(\"$operand\")";
    } else {
        die "Can't parse $operand";
    }
    if ($not_flag) {
        $trans = $trans . " ? 0 : 1";
    }
    $trans = $trans . ";\n";
    return $trans;
}

sub il_sub {
    my ($not_flag, $register, $operand) = @_;
    my $trans = "$register -= ";
    if ($operand =~ /^\d+/) {
        $trans = $trans . "$operand";
    } elsif ($operand =~ /^%\S+/) {
        $trans = $trans . "LocalIO::read(\"$operand\")";
    } else {
        die "Can't parse $operand";
    }
    if ($not_flag) {
        $trans = $trans . " ? 0 : 1";
    }
    $trans = $trans . ";\n";
    return $trans;
}

sub il_mul {
    my ($not_flag, $register, $operand) = @_;
    my $trans = "$register *= ";
    if ($operand =~ /^\d+/) {
        $trans = $trans . "$operand";
    } elsif ($operand =~ /^%\S+/) {
        $trans = $trans . "LocalIO::read(\"$operand\")";
    } else {
        die "Can't parse $operand";
    }
    if ($not_flag) {
        $trans = $trans . " ? 0 : 1";
    }
    $trans = $trans . ";\n";
    return $trans;
}

sub il_div {
    my ($not_flag, $register, $operand) = @_;
    my $trans = "$register /= ";
    if ($operand =~ /^\d+/) {
        $trans = $trans . "$operand";
    } elsif ($operand =~ /^%\S+/) {
        $trans = $trans . "LocalIO::read(\"$operand\")";
    } else {
        die "Can't parse $operand";
    }
    if ($not_flag) {
        $trans = $trans . " ? 0 : 1";
    }
    $trans = $trans . ";\n";
    return $trans;
}

sub parse {
    my $instruction = shift;
    my $trans;
    die "Can't parse $instruction" unless ($instruction =~ /^(\w+:)|(\))|(\w+)(\()?\s+(\S+)|\s+/);
    my ($label, $ret, $cmd, $cal, $operand) = ($1, $2, $3, $4, $5);

    if ($label) {
        $trans = "$label";
    }

    if ($ret) {
        shift @stacks;
    }
    
    if ($cmd) {
        if ($cal) {
            $acc++;
            unshift @stacks, "\$register$acc";
            unshift @stacks, $cmd;
            unshift @stacks, "\$register$acc";
            unshift @stacks, $operand;
            unshift @stacks, "LD";
        } else {
            unshift @stacks, $operand;
            unshift @stacks, $cmd;
        }
    }
     
    if ($cmd or $ret) {
        my $now_cmd = shift @stacks;
        my $now_operand = shift @stacks;
        my $now_register = shift @stacks;
        if ($now_cmd =~ /^LD(N)?/) {
            $trans = il_ld($1 ? 1 : 0, $now_register, $now_operand);
            unshift @stacks, $now_register;
        } elsif ($now_cmd =~ /^ST(N)?/) {
            $trans = il_st($1 ? 1 : 0, $now_register, $now_operand);
            unshift @stacks, $now_register;
        } elsif ($now_cmd =~ /^AND(N)?/) {
            $trans = il_and($1 ? 1 : 0, $now_register, $now_operand);
            unshift @stacks, $now_register;
        } elsif ($now_cmd =~ /^OR(N)?/) {
            $trans = il_or($1 ? 1 : 0, $now_register, $now_operand);
            unshift @stacks, $now_register;
        } elsif ($now_cmd =~ /^ADD(N)?/) {
            $trans = il_add($1 ? 1 : 0, $now_register, $now_operand);
            unshift @stacks, $now_register;
        } elsif ($now_cmd =~ /^SUB(N)?/) {
            $trans = il_sub($1 ? 1 : 0, $now_register, $now_operand);
            unshift @stacks, $now_register;
        } elsif ($cmd =~ /^MUL(N)?/) {
            $trans = il_mul($1 ? 1 : 0, $now_register, $now_operand);
            unshift @stacks, $now_register;
        } elsif ($cmd =~ /^DIV(N)?/) {
            $trans = il_div($1 ? 1 : 0, $now_register, $now_operand);
            unshift @stacks, $now_register;
        } else {
            die "Can't parse $instruction";
        }
    }

    return $trans;
}

sub parse_file {
    my @scripts = ();
    
    open(my $instructions,  "<",  shift) or die "Can't open $!";
    unshift @stacks, "\$register$acc";
    while(<$instructions>) {
        my $trans = parse($_);
        push @scripts, "$trans" if $trans;
    }
    push @scripts, "}\n";

    for (my $i = 0; $i <= $acc; $i++) {
        unshift @scripts, "my \$register$i;\n";
    }
    unshift @scripts, "sub step {\n";
    unshift @scripts, "use LocalIO;\n";
    unshift @scripts, "use warnings;\n";
    unshift @scripts, "use strict;\n";
    unshift @scripts, "package Step;\n";
    push @scripts, "1;";
    
    open(my $out,  ">",  "Step.pm")  or die "Can't open $!";
    print $out @scripts;

    close $instructions or die "$instructions: $!";
    close $out or die "$out: $!";
}

1;
