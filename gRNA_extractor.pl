#!/usr/bin/perl
use strict;
use Getopt::Long;
if($#ARGV<0){
        print "\nperl $0 \\\n" .
                " --genomeFa genome.fa \\\n" .
                " --chrId chr1 \\\n" .
                " --regBeg 101 \\\n" .
                " --regEnd 188 \\\n" .
                " --outSgRNAs sgRNAs.seq.txt\n";
        exit;
}
my ($regionSeq, $outSgRNAs, $regBeg, $regEnd, $chrId, $strand, $genomeFa);

GetOptions(
        'genomeFa=s'=>\$genomeFa,
        'chrId=s'=>\$chrId,
        'regBeg=s'=>\$regBeg,
        'regEnd=s'=>\$regEnd,
        'outSgRNAs=s'=>\$outSgRNAs,
);
my (%refSeq, @id, $id, $line);
open FF, "<$genomeFa";
while($line = <FF>){
        chomp($line);
        if($line=~/>(.*)/){
                @id = split(/ /, $1);
                $id = $id[0];
        }else{
                $refSeq{$id} .= $line;
        }
}
close FF;

$regionSeq = substr($refSeq{$chrId}, $regBeg-1, $regEnd - $regBeg + 1);
$regionSeq = uc($regionSeq);

open WW, ">$outSgRNAs";
my ($start, $chrPosStart, $chrPosStop);
$regionSeq = uc($regionSeq);
while ($regionSeq =~ /(?=(GG))/g) {
        my $position = pos($regionSeq);
        if($position >= 21){
                $start = $position - 21;
                $chrPosStart = $regBeg + $start;
                $chrPosStop = $regBeg + $start + 22;
                print WW ">" . $chrId . "_P_" . $chrPosStart . "_" . $chrPosStop . "\n";
                print WW substr($regionSeq, $start, 23) . "\n";
        }
}
$regionSeq = reverse($regionSeq);
$regionSeq =~tr/ACGT/TGCA/;
#print $regionSeq . "\n";
while ($regionSeq =~ /(?=(GG))/g) {
        my $position = pos($regionSeq);
        if($position >= 21){
                $start = $position - 21;
                $chrPosStart = $regEnd - $start - 22;
                $chrPosStop = $regEnd - $start;
                print WW ">" . $chrId . "_M_" . $chrPosStart . "_" . $chrPosStop . "\n";
                print WW substr($regionSeq, $start, 23) . "\n";
        }
}
close WW;
