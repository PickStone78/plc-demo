package tp_step;

use strict;
use warnings;
use Sys::HostAddr;

use tp_io;

our @scripts;
our $register;
my $interface = Sys::HostAddr->new(ipv => '4', interface => 'wlp3s0');
my $local_ip = $interface->main_ip;

sub parse {
    my $tmp = shift;

    if($tmp =~ /(\S+)\s(.+)/) {
        my $tmpcmd = $1;
        my $tmpvars = $2;

        if($tmpvars =~ /\S+/) {
            if($tmpvars =~ /%(I|O)\S+@\S+/) {
                if(not exists $tp_io::variables{$tmpvars}) {
                    my $value = 0;
                    my $flag;
                    if($1 eq 'I') {
                        $flag = 2;
                    }
                    else {
                        $flag = 3;
                    }
                    $tp_io::variables{$tmpvars} = [$flag, $value];
                }
            }
            elsif($tmpvars =~ /%(I|O)\S+/) {
                $tmpvars = join('@', $tmpvars, $local_ip);
                if(not exists $tp_io::variables{$tmpvars}) {
                    my $value = 0;
                    my $flag;
                    if($1 eq 'I') {
                        $flag = 0;
                    }
                    else {
                        $flag = 1;
                    }
                    $tp_io::variables{$tmpvars} = [$flag, $value];
                }
            }
            else {
            }
        }
  
        if($tmpcmd eq "LD" and $tmpvars =~ /\S+/) {
            if($tmpvars =~ /\d+/) {
                push(@scripts, "\$register = $tmpvars;");
            }
            elsif($tmpvars =~ /%\S+/) {
                push(@scripts, "\$register = \$tp_io::variables{\'$tmpvars\'}->[1];");
            }
            else {
            }
        }
        elsif($tmpcmd eq "ST" and $tmpvars =~ /\S+/) {
            if($tmpvars =~ /%\S+/) {
                push(@scripts, "\$tp_io::variables{\'$tmpvars\'}->[1] = \$register;");
            }
            else {
            }
        }
        elsif($tmpcmd eq "AND") {
            if($tmpvars =~ /\d+/) {
                push(@scripts, "\$register = \$register && $tmpvars;");
            }
            elsif($tmpvars =~ /%\S+/) {
                push(@scripts, "\$register = \$register && \$tp_io::variables{\'$tmpvars\'}->[1];");
            }
            else {
            }
        }
        elsif($tmpcmd eq "OR") {
            if($tmpvars =~ /\d+/) {
                push(@scripts, "\$register = \$register || $tmpvars;");
            }
            elsif($tmpvars =~ /%\S+/) {
                push(@scripts, "\$register = \$register || \$tp_io::variables{\'$tmpvars\'}->[1];");
            }
            else {
            }
        }
        elsif($tmpcmd eq "ADD") {
            if($tmpvars =~ /\d+/) {
                push(@scripts, "\$register += $tmpvars;");
            }
            elsif($tmpvars =~ /%\S+/) {
                push(@scripts, "\$register += \$tp_io::variables{\'$tmpvars\'}->[1];");
            }
            else {
            }
        }
        elsif($tmpcmd eq "SUB") {
            if($tmpvars =~ /\d+/) {
                push(@scripts, "\$register -= $tmpvars;");
            }
            elsif($tmpvars =~ /%\S+/) {
                push(@scripts, "\$register -= \$tp_io::variables{\'$tmpvars\'}->[1];");
            }
            else {
            }
        }
        elsif($tmpcmd eq "MUL") {
            if($tmpvars =~ /\d+/) {
                push(@scripts, "\$register *= $tmpvars;");
            }
            elsif($tmpvars =~ /%\S+/) {
                push(@scripts, "\$register *= \$tp_io::variables{\'$tmpvars\'}->[1];");
            }
            else {
            }
        }
        elsif($tmpcmd eq "DIV") {
            if($tmpvars =~ /\d+/) {
                push(@scripts, "\$register /= $tmpvars;");
            }
            elsif($tmpvars =~ /%\S+/) {
                push(@scripts, "\$register /= \$tp_io::variables{\'$tmpvars\'}->[1];");
            }
            else {
            }
        }
        else {
        }
    }
}

sub step {
    tp_io::read_global();

    while(my $cmd = shift @scripts) {
        eval $cmd;
    }

    tp_io::write_global();
}

1;
