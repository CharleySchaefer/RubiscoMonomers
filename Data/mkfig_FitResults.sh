#!/bin/bash

#for Evalues in 0 5 10 15 20  ; do
#for lK in 0.36 1.00 ; do



pltscript="
#==================================
# TERMINAL SETTINGS
#set terminal pngcairo enhanced dashed
#set output 'Fig_LvsR.png'

set terminal epslatex standalone #size 10 cm,  4 cm
set output 'tmp_figure.tex'
#==================================


#==================================
# FUNCTIONS AND DEFINITIONS
#----------------------------------

KD=3.09 # millimolar
cR=0.000

# define the viridis palette
set palette model RGB defined (0 '#440154', 0.25 '#3e4989', 0.5 '#21908dff', 0.75 '#5dc963', 1 '#fde725')
#==================================


#==================================
# MARGINS
#----------------------------------
set lmargin 7.0
set tmargin 1.5
set bmargin 3.3
set rmargin 1.3
#==================================


#==================================
# X AXIS
#----------------------------------

unset xlabel #'\huge \$c_\mathrm{L}/K_\mathrm{d}\$'
set xrange [1e-9:1e3]
set xtics 1e-6,1e3, 1e6 format ''
set log x
#set xtics 1e-7,10,0.1
#set format x '\$ 10^{%%T}\$'
#==================================


#==================================
# Y AXIS
#----------------------------------
set ylabel '\huge \$\\\langle M \\\rangle\$'
#set yrange [8:100]
#set log y
#set ytics 0,2,8 format '%%1g'
#set format y \'\$ 10^{%%T}\$'
 set ytics 0,2,8 format '%%1g'
#==================================


#==================================
# KEY
#----------------------------------
#set nokey 
set key left Left reverse 

#==================================


#==================================
# LABELS AND ARROWS
#----------------------------------


#set label 1 '\$ \\\varepsilon=$Ebind \, k_\mathrm{B}T\$' at 2e-9,3
#set label 3 '\$ K_\mathrm{d}=3\$ mM' at 2e-9,4

#set label 4 '\Large \$S\$' at 100,4
#set arrow 1 from 1.1,6.3 to 100,4.5 ls 1 lw 4 lc rgb 'black' front
#set arrow 2 from 3e-2,1.1 to 0.5e-3,1.1 ls 1 lw 4 lc rgb 'black' front

#set label '\\Large \\textcolor[rgb]\{0.7333,0,0\}\{\$-1/3$\}' at 1.6e-6, 70
#set label '\\Large \\textcolor[rgb]\{0,0.7333,0\}\{\$-1/4$\}' at 4e-4, 14
#set arrow from 2e-4,40 to 2e-4,2 lw 4 front
#==================================


#==================================
# PLOT
#----------------------------------
set multiplot
set grid xtics ytics
#set mytics 2           # set the spacing for the mytics
set grid # ytics mytics  # draw lines for each ytics and mytics

set xtics 1e-9,1e3, 1e6 format '' #\$10^{%%T}\$'


#set key at screen 0.05,1 maxrows 3
unset colorbox

unset grid

set size 1,0.5
set origin 0.0,0.5
unset log xy

set key left top Left reverse spacing 1.25

set xrange [0:2]
set xtics 0,0.2,2 format '\$%%.1f\$'
set xlabel '\Large \$l_\mathrm{K}\$ (nm)'
set yrange [-25:0]
set ytics -25,5,25
set ylabel '\Large \$\\\\varepsilon/k_\mathrm{B}T\$'
set key
plot \
'FitResults/curve_fit_ZS3and5_err.txt' u 1:(-\$2):3 w e pt 6 lc rgb '#FF9999' notitle 'Curve fits',\
'FitResults/curve_fit_ZS2.txt' u 1:(-\$2):3 w e pt 6 lc rgb '#9999FF' notitle 'Curve fits',\
-11*x**-0.45 w l lw 3 lc rgb 'red' title  '\$S=3,5\$; \$\\\\varepsilon=-11l_\mathrm{K}^{-0.45}\$',\
-13*x**-0.55 w l lw 3 lc rgb 'blue' title  '\$S=2\$; \$\\\\varepsilon=-13l_\mathrm{K}^{-0.55}\$ '

#-12*x**-0.45 w l lw 3 lc rgb 'red' title  '\$S=5\$; \$-12l_\mathrm{K}^{-0.45}\$',\
#-16*x**-0.45 w l lw 3 lc rgb 'blue' title  '\$S=2\$; \$-16l_\mathrm{K}^{-0.45}\$ '

unset key
#set size 0.5,0.6
set origin 0.0,0.0

unset key
set xrange [0:2]
set xtics 0,0.2,2 format '\$%%.1f\$'
set xlabel '\Large \$l_\mathrm{K}\$ (nm)'
set yrange [0.9:1]
set ytics 0.9,0.02,1 format '\$%%.2f\$'
set ylabel '\Large \$R^2\$' offset 1,0

plot \
'FitResults/curve_fit_ZS3and5_err.txt' u 1:4 w p pt 6 lc rgb 'red' title 'Curve fits',\
'FitResults/curve_fit_ZS2.txt' u 1:4 w p pt 6 lc rgb 'blue' title 'Curve fits',\
#'curve_fit_ZS3and5.txt' u 1:4 w p pt 6 lc rgb 'black' title 'Curve fits',\
#'curve_fit_ZS3and5_err.txt' u 1:4 w p pt 6 lc rgb 'cyan' title 'Curve fits'
#'curve_fit_ZS3.txt' u 1:4 w p pt 6 lc rgb 'green' title 'Curve fits'#,\

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
#printf "$pltscript"
printf "$pltscript" | gnuplot

latex tmp_figure.tex
dvips tmp_figure.dvi -o tmp_figure.ps
mv tmp_figure.ps "Fig_FitResults.eps"

#pdflatex tmp_create_standalone.tex &>/dev/null
#mv tmp_create_standalone.pdf Fig_a4paper.pdf
rm tmp_* 

# done # end lK loop
#done # end Evalues loop

