clear all, clc, close all

resol= 0.05;
rsize= 2.0;
rspace= -rsize:resol:rsize;
[xx yy] = meshgrid(rspace, rspace);
sig_cen= 0.3;
sig_sur= 1.5;
Ncoef= 5;
RFcen = 1/(2*pi*sig_cen^2) * exp(-(xx.^2+yy.^2)/2/sig_cen^2);
RFsur= -Ncoef/(2*pi*sig_sur^2) * exp(-(xx.^2+yy.^2)/2/sig_sur^2);
RFs = RFcen+ RFsur;
RFs = RFs ./abs(sum(RFs, "all"));

figure()
subplot(1,3,1)
pcolor(xx,yy,RFcen)
subplot(1,3,2)
pcolor(xx,yy,RFsur)
subplot(1,3,3)
pcolor(xx,yy,RFs)
colormap default
colorbar

figure()
surf(xx, yy, RFs);
% other options: plot3, mesh
