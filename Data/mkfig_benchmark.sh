#!/bin/bash

pltscript="
#==================================
# TERMINAL SETTINGS
#set terminal pngcairo enhanced dashed
#set output 'Fig_LvsR.png'

set terminal epslatex standalone #size 10 cm,  4 cm
set output 'tmp_figure.tex'
#==================================
set xlabel '\Large \$\\\\varepsilon/k_\mathrm{B}T\$'
set ylabel '\Large \$P_{1,B}\$'

Espring=2

Z(x)=9*exp(-x) + 18*exp(-2*x-Espring) + 6*exp(-3*x-2*Espring)


# define the viridis palette
set palette model RGB defined (0 '#440154', 0.25 '#3e4989', 0.5 '#21908dff', 0.75 '#5dc963', 1 '#fde725')

set xrange [0:20]
set ytics 0,0.2,1

set key above Left width -0.8
set grid 
unset colorbox
set cbrange [0:5]

plot \
\"Simulations/summary.txt\" u (-\$1):6:(1) w p ls 1 ps 2 pt 7 lc palette title '\$B=1\$', \
\"\" u (-\$1):7:(2) w p ls 2 ps 2 pt 7 lc palette  title '\$B=2\$', \
\"\" u (-\$1):8:(3) w p ls 3 ps 2 pt 7 lc palette  title '\$B=3\$', \
\"\" u (-\$1):9:(4) w p ls 4 ps 2 pt 7 lc palette  title '\$B=4\$', \
\"\" u (-\$1):10:(5) w p ls 5 ps 2 pt 7 lc palette  title '\$B=5\$',\
\"LatticeCube/prow_FJC_EPYC1_5RBM_1.00_1.out\" u 1:2:(1)  w l  ls 1 lw 2 lc palette notitle,\
\"LatticeCube/prow_FJC_EPYC1_5RBM_1.00_1.out\" u 1:3:(2)  w l  ls 2 lw 2 lc palette notitle,\
\"LatticeCube/prow_FJC_EPYC1_5RBM_1.00_1.out\" u 1:4:(3)  w l  ls 3 lw 2 lc palette notitle,\
\"LatticeCube/prow_FJC_EPYC1_5RBM_1.00_1.out\" u 1:5:(4)  w l  ls 4 lw 2 lc palette notitle,\
\"LatticeCube/prow_FJC_EPYC1_5RBM_1.00_1.out\" u 1:6:(5) w l  ls 5 lw 2 lc palette notitle

"



pltscript="$pltscript
unset multiplot
"

echo "% \documentclass[a5paper, landscape, 10 pt]{article}
\documentclass[a4paper, 10 pt]{article}
\usepackage[pdftex]{graphicx}
\usepackage{epstopdf}			% Use eps figures

\usepackage[english]{babel}
\usepackage[latin1]{inputenc}
\usepackage{a4wide}
\usepackage{amsmath}
\usepackage{amssymb}
\usepackage{amsthm}
\usepackage{ctable}
\usepackage{wrapfig}
\usepackage{graphicx}
\usepackage{amsfonts}
\usepackage[small,bf]{caption}
\usepackage{cite}
\usepackage[T1]{fontenc}
\usepackage{ae,aecompl}
%\usepackage{eurosym}	% Euro symbol
\usepackage{url} 		% URL formatting package
\usepackage{hyperref}
\usepackage{float}
\usepackage{varioref}
\usepackage{ifthen}
\usepackage{color}
%\usepackage{times}

%\setlength{\parindent}{0cm}

%\bibliographystyle{unsrt} % Style for the References Section.
\bibliographystyle{unsrturl}
%\bibliographystyle{nprlrtn}


\begin{document}

\begin{figure}[h]
    \includegraphics*{Fig_cropped.eps}
\end{figure}


\end{document}
" > tmp_create_standalone.tex

rm -f tmp_create_standalone.pdf
printf "$pltscript"
printf "$pltscript" | gnuplot

latex tmp_figure.tex
dvips tmp_figure.dvi -o tmp_figure.ps
mv tmp_figure.ps "Fig_MonomerM1.eps"

#pdflatex tmp_create_standalone.tex &>/dev/null
#mv tmp_create_standalone.pdf Fig_a4paper.pdf
rm tmp_* 



