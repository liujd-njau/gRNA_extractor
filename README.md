# gRNA_extractor
Customized Perl script for extracting gRNAs used in the CRISPR module

gRNA_extractor.pl is a customized Perl script for extracting 23-bp CRISPR/Cas9 gRNA candidates (20 bp protospacer + NGG PAM) from a specified genomic region.
The script scans both the positive and negative strands and outputs all candidate gRNAs with genomic coordinates.

Input Requirements

1. Genome FASTA

A standard FASTA file containing chromosome or scaffold sequences:
>Chr01
ACGTACGT...
>Chr02
...

2. Genomic region

The script extracts gRNAs from the region defined by:

--chrId : chromosome ID (must match FASTA header before any whitespace)

--regBeg : 1-based start position

--regEnd : 1-based end position

Output

A FASTA-format file listing all candidate gRNAs:

23-bp sequence (protospacer + PAM)

Coordinates automatically computed

Strand indicated as:

P for positive strand

M for minus (reverse-complement) strand
Example header format:
>Chr01_P_105_127
>Chr01_M_210_232


Usage
Command
perl gRNA_extractor.pl \
  --genomeFa genome.fa \
  --chrId chr1 \
  --regBeg 101 \
  --regEnd 188 \
  --outSgRNAs sgRNAs.seq.txt

Command-line Options
| Option        | Description                           | Required |
| ------------- | ------------------------------------- | -------- |
| `--genomeFa`  | Genome FASTA file                     | Yes      |
| `--chrId`     | Chromosome/scaffold name (e.g., chr1) | Yes      |
| `--regBeg`    | Start position (1-based)              | Yes      |
| `--regEnd`    | End position (1-based)                | Yes      |
| `--outSgRNAs` | Output FASTA file                     | Yes      |

Output Description
For each gRNA, the script prints:
>ChrID_[P/M]_GenomicStart_GenomicEnd
23bp_sequence

Example:
>chr1_P_105_127
ACGTACGTACGTACGTACGTGGG
>chr1_M_210_232
TTGACGTACTGACTGACTACGGG

Positive-strand search identifies sequences ending with GG

Negative-strand search identifies sequences where reverse complement contains GG

Coordinates are mapped back to the original genome positions

Notes

The script extracts 23-bp windows where the last two bases are "GG" (NGG PAM).

For minus-strand hits, sequences are reverse-complemented automatically.

FASTA headers are parsed only up to the first space; ensure chromosome names match exactly.
