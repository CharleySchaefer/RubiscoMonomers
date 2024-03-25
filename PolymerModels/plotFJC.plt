set terminal pngcairo enhanced
set output 'test.png'

b=0.36
lK=0.36
kT=4;

lmax(N)=sqrt(N)
Re(N)=b*sqrt(N)

set xrange [0:1]
set yrange [0.0:150]
#set log y



NK(N,lK)=N*b/lK

FFJC(z,N,lK) = 3*kT/( lK**2*NK(N,lK) )*(   ((3*(b*N)**2-z**2)/((b*N)**2-z**2))/((3*NK(N,lK)-1)/(NK(N,lK)-1))  )*z
GFJC(z,N,lK) = (b*N/lK)*( 0.5*(z/(b*N))**2 - log(1.0-(z/(b*N))**2) )

forceWLC(r, N,Lp)=(kT/(4*Lp))*( (1-r)**(-2) - 1 + 4*r )
GWLC(z,N,lK) = (b*N/(4*lK))*( 1.0/(1-z/(b*N)) + 2*(z/(b*N))**2 - z/(b*N)  )

N=100

set samples 1000

set key left top Left reverse

set multiplot
set size 1,0.5

set origin 0.0, 0.5
set xlabel 'z/bN'
set ylabel 'F [pN]'
plot \
FFJC(x*(b*N),N,  b) w l lw 1 lc rgb 'red' notitle,\
FFJC(x*(b*N),N,2*b) w l lw 2 lc rgb 'red' notitle,\
FFJC(x*(b*N),N,4*b) w l lw 3 lc rgb 'red' title 'FJC',\
forceWLC(x,N, b) w l dt 1 lw 1 lc rgb 'green' notitle,\
forceWLC(x,N,2*b) w l dt 1 lw 2 lc rgb 'green' notitle,\
forceWLC(x,N,4*b) w l dt 1 lw 3 lc rgb 'green' title 'WLC'


set origin 0.0, 0.0

set ylabel 'G/kT'
set yrange [0.1:100]
set log y
set grid 
plot \
GFJC(x*(b*N),N,  b) w l lw 1 lc rgb 'red' notitle,\
GFJC(x*(b*N),N,2*b) w l lw 2 lc rgb 'red' notitle,\
GFJC(x*(b*N),N,4*b) w l lw 3 lc rgb 'red' notitle,\
GWLC(x*(b*N),N,  b) w l lw 1 lc rgb 'green' notitle,\
GWLC(x*(b*N),N,2*b) w l lw 2 lc rgb 'green' notitle,\
GWLC(x*(b*N),N,4*b) w l lw 3 lc rgb 'green' notitle


unset multiplot

