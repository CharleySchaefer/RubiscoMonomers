#!/bin/bash

#for Evalues in 0 5 10 15 20  ; do
#for lK in 0.36 1.00 ; do




pltscript="
#==================================
# TERMINAL SETTINGS
#set terminal pngcairo enhanced dashed
#set output 'Fig_LvsR.png'

set terminal epslatex standalone size 10 cm,  5 cm
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
set lmargin 5.0
set tmargin 0.5
#set bmargin 2.3
set rmargin 1.3
#==================================


#==================================
# X AXIS
#----------------------------------

#unset xlabel #'\huge \$c_\mathrm{L}/K_\mathrm{d}\$'
set xlabel '\large Linker concentration, \$c_\mathrm{L}\$ (\$\mu\$M)'
set xrange [1.01e-4:0.8e4]
set xtics 1e-4,1e4, 1e1 format '\$10^{%%T}\$'
set log x
#set xtics 1e-7,10,0.1
#set format x '\$ 10^{%%T}\$'
#==================================


#==================================
# Y AXIS
#----------------------------------
set ylabel '\large \$\\\langle M \\\rangle\$'
set yrange [0:8]
#set log y
#set ytics 0,2,8 format '%%1g'
#set format y \'\$ 10^{%%T}\$'
# set ytics 0,0.2,1 format '%%3.1g'
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


set label 3 '\small \$ K_\mathrm{d}=414\$ \$\mu\$M' at 2e-4,2.6
set label 1 '\small \$ \\\varepsilon=-11.8 \, k_\mathrm{B}T\$' at 2e-4,1.8
set label 2 '\small \$ l_\mathrm{K}=0.88\$ nm' at 2e-4,1

#set label 4 '\Large \$S\$' at 100,4
#set arrow 1 from 1.1,6.3 to 100,4.5 ls 1 lw 4 lc rgb 'black' front
#set arrow 2 from 3e-2,1.1 to 0.5e-3,1.1 ls 1 lw 4 lc rgb 'black' front

#set label '\\Large \\textcolor[rgb]\{0.7333,0,0\}\{\$-1/3$\}' at 1.6e-6, 70
#set label '\\Large \\textcolor[rgb]\{0,0.7333,0\}\{\$-1/4$\}' at 4e-4, 14
#set arrow from 2e-4,40 to 2e-4,2 lw 2 front
#==================================


#==================================
# PLOT
#----------------------------------
set multiplot
set grid xtics ytics
#set mytics 2           # set the spacing for the mytics
unset grid # ytics mytics  # draw lines for each ytics and mytics

set xtics 1e-4,1e1, 8e3 format '\$10^{%%T}\$'
#set size 1,0.5
#set origin 0.0,0.5

KD=3.09 # millimolar
KD_he=3090 # micromolar
KD=414 # micromolar
cR=0.5
set key
plot \
8*(x)/(KD_he+x)             w l ls 1 dt 2  lw 2 lc rgb 'grey' notitle '\$S=1\$' ,\
'Experiments/He_bindingcurve.csv' u (\$1*1000):(\$2*8/775) w p pt 3 ps 1.2 lw 4 lc rgb 'grey' title '\\\\small \$S=1\$; [He et al 2020]',\
8*(x)/(KD+x)             w l ls 1 dt 1  lw 4 lc rgb 'black' notitle '\$S=1\$' ,\
'Experiments/231208_SPR_S=1_3reps.txt' u (\$1):(  8*((\$2+\$3+\$4)/3-18)/1541 ):( sqrt( (\$2-(\$2+\$3+\$4)/3)**2 + (\$3-(\$2+\$3+\$4)/3)**2 + (\$4-(\$2+\$3+\$4)/3)**2)/sqrt(2)*8/1541)  w e pt 4 ps 1.4 lw 3 lc rgb 'black' title '\\\\small \$S=1\$',\
'LatticeCube/titration_FJC_ZS2_0.88.out' u (KD*exp(\$1)*exp(\$2)):4 w l ls 2 lw 3 dt 1 lc rgb 'green'  notitle,\
'LatticeCube/titration_FJC_ZS2_1.00.out' u (KD*exp(\$1)*exp(\$2)):4 w l ls 2 lw 3 dt 3 lc rgb 'green'  notitle,\
'Experiments/231208_SPR_S=2_3reps.txt' u (\$1):(  ((\$2+\$3+\$4)/3-18)/787 ):( sqrt( (\$2-(\$2+\$3+\$4)/3)**2 + (\$3-(\$2+\$3+\$4)/3)**2 + (\$4-(\$2+\$3+\$4)/3)**2)/sqrt(2)/787)   w e pt 6 ps 1.4 lw 3 lc rgb 'green' title '\\\\small \$S=2\$',\
'LatticeCube/titration_FJC_ZS3_0.88.out' u (KD*exp(\$1)*exp(\$2)):4 w l ls 2 lw 3 dt 1 lc rgb 'blue' notitle,\
'Experiments/Slimfield_S=3.txt' u (\$1*1e-3):(\$2):(\$3):(\$4) w ye pt 8 ps 1.4 lw 3 lc rgb 'blue' title '\\\\small \$S=3\$-GFP',\
'LatticeCube/titration_FJC_ZS5_0.88.out' u (KD*exp(\$1)*exp(\$2)):4 w l ls 2 lw 3 dt 1 lc rgb 'red' notitle,\
'Experiments/Slimfield_S=5.txt' u (\$1*1e-3):(\$2):(\$3):(\$4) w ye pt 10 ps 1.4 lw 3 lc rgb 'red' title '\\\\small \$S=5\$-GFP'
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
\usepackage{color,soul}
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
mv tmp_figure.ps "Fig_titration.eps"

#pdflatex tmp_create_standalone.tex &>/dev/null
#mv tmp_create_standalone.pdf Fig_a4paper.pdf
rm tmp_* 

# done # end lK loop
#done # end Evalues loop

