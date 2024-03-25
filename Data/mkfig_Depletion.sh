#!/bin/bash


pltscript="
#==================================
# TERMINAL SETTINGS
#set terminal pngcairo enhanced dashed
#set output 'Fig_LvsR.png'

set terminal epslatex standalone size 13 cm,  7 cm
set output 'tmp_figure.tex'
#==================================


#==================================
# FUNCTIONS AND DEFINITIONS
#----------------------------------
FAC225=(1.0/0.021)**0.33 
FAC200=(1.0/0.045)**0.33 
FAC180=(1.0/0.128)**0.33
FAC176=(1.0/0.02)**0.33
FAC100=(1.0/0.128)**0.33
#==================================


#==================================
# MARGINS
#----------------------------------
set lmargin 8
set tmargin 0.5
set bmargin 3.6
set rmargin 1.2
#==================================


#==================================
# X AXIS
#----------------------------------
set xlabel '\huge Rubisco concentration (-), \$c_\mathrm{R,0}/c_\mathrm{L,0}\$'
set xrange [1e-4:1e2]
set xtics 1e-9,1e1, 1e6 format '\$10^{%%T}\$'
set log x
#set xtics 1e-7,10,0.1
#set format x '\$ 10^{%%T}\$'
#==================================


#==================================
# Y AXIS
#----------------------------------
set ylabel '\huge \$c_\mathrm{L}/c_\mathrm{L,0}\$'
#set yrange [8:100]
#set log y
# set ytics
set yrange [0:1]
#set format y \'\$ 10^{%%T}\$'
# set ytics 0,0.2,1 format '%%3.1g'
#==================================


#==================================
# KEY
#----------------------------------
#set nokey 
set key left bottom Left reverse 

#==================================


#==================================
# LABELS AND ARROWS
#----------------------------------


#set label 1 '\$ \\\varepsilon=$Evalues k_\mathrm{B}T\$' at 1000,2
#set label 2 '\$ l_\mathrm{K}=$lK\$ nm' at 1000,1

#set label '\\Large \\textcolor[rgb]\{0.7333,0,0\}\{\$-1/3$\}' at 1.6e-6, 70
#set label '\\Large \\textcolor[rgb]\{0,0.7333,0\}\{\$-1/4$\}' at 4e-4, 14
#set arrow from 2e-4,40 to 2e-4,2 lw 2 front
#==================================


#==================================
# PLOT
#----------------------------------
#set multiplot
#set grid

#set size 1,0.5
#set origin 0.0,0.5

KD=0.414 # millimolar
cR=0.010

plot \\
'LatticeCube/LinkerDepletion_lK0.88_E11.80.out' u (\$1==1.812695e-10? \$2/\$1 : 1/0):(\$3/\$1) w l lw 3 title '\\\\small{\$c_\mathrm{L,0}=0.01\$ \$\mu\$M}',\\
'LatticeCube/LinkerDepletion_lK0.88_E11.80.out' u (\$1==1.812695e-9? \$2/\$1 : 1/0):(\$3/\$1) w l lw 3 title '\\\\small{\$c_\mathrm{L,0}=0.1\$ \$\mu\$M}',\\
'LatticeCube/LinkerDepletion_lK0.88_E11.80.out' u (\$1==1.812695e-8? \$2/\$1 : 1/0):(\$3/\$1) w l lw 3 title '\\\\small{\$c_\mathrm{L,0}=1 \$ \$\mu\$M}',\\
'LatticeCube/LinkerDepletion_lK0.88_E11.80.out' u (\$1==1.812695e-7? \$2/\$1 : 1/0):(\$3/\$1) w l lw 3 title '\\\\small{\$c_\mathrm{L,0}=10\$ \$\mu\$M}',\\
'Experiments/HeEtAl.csv' u (10**\$1):( (\$2-38)/(62-38)) w p pt 7 ps 1.5 lc rgb 'black' title '\\\\small{He et al 2023; \$D=38\, \mu\mathrm{m}^2\$}' ,\\
'Experiments/HeEtAl.csv' u (10**\$1):( (\$2-42)/(62-42)) w p pt 8 ps 1.5 lc rgb 'black' title '\\\\small{He et al 2023; \$D=42\, \mu\mathrm{m}^2\$ }'
"

#'FCS_lK0.89_E11.60.out' u (KD*\$1/0.00001):2 w l lw 3 title '\$c_\mathrm{L,0}/K_\mathrm{d}=10^{-5}\$',\\
#'FCS_lK0.89_E11.60.out' u (KD*\$1/0.0001):4 w l  lw 3 title '\$c_\mathrm{L,0}/K_\mathrm{d}=10^{-4}\$',\\
#'FCS_lK0.89_E11.60.out' u (KD*\$1/0.001):6 w l  lw 3 title '\$c_\mathrm{L,0}/K_\mathrm{d}=10^{-3}\$',\\
#'FCS_lK0.89_E11.60.out' u (KD*\$1/0.01):7 w l  lw 3 title '\$c_\mathrm{L,0}/K_\mathrm{d}=10^{-2}\$',\\
#'FCS_lK0.89_E11.60.out' u (KD*\$1/0.1):8 w l  lw 3 title '\$c_\mathrm{L,0}/K_\mathrm{d}=10^{-1}\$',\\

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
mv tmp_figure.ps "Fig_Depletion.eps"

#pdflatex tmp_create_standalone.tex &>/dev/null
#mv tmp_create_standalone.pdf Fig_a4paper.pdf
rm tmp_* 

# done # end lK loop
#done # end Evalues loop

