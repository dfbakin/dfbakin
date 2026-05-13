# latexmk configuration for the bilingual CV.
#
# Usage:
#   latexmk            # build both CVs (en + ru); copies them to repo root
#   latexmk -c         # remove aux files (keep PDFs)
#   latexmk -C         # remove aux files and the build/ PDFs
#
# Aux/log files land in build/; the final PDFs are also copied to
# CV_eng.pdf / CV_rus.pdf at the repo root for direct viewing/sharing.

@default_files = ('cv_src/main_en.tex', 'cv_src/main_ru.tex');

$pdf_mode  = 1;
$pdflatex  = 'pdflatex -interaction=nonstopmode -halt-on-error -file-line-error %O %S';
$out_dir   = 'build';

# Map per-source PDFs (build/main_en.pdf / build/main_ru.pdf) to canonical
# names at the repo root after a successful compile.
my %cv_pdf_map = (
    'main_en.pdf' => 'CV_eng.pdf',
    'main_ru.pdf' => 'CV_rus.pdf',
);

sub copy_cv_pdf {
    my $src = shift;
    for my $key (keys %cv_pdf_map) {
        if ($src =~ /\Q$key\E\z/) {
            my $dst = $cv_pdf_map{$key};
            if (system('cp', $src, $dst) == 0) {
                print "latexmk: wrote $dst\n";
            } else {
                warn "latexmk: failed to copy $src -> $dst\n";
            }
            last;
        }
    }
    return 0;
}

$success_cmd = 'internal copy_cv_pdf %D';
