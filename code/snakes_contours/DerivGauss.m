function [Gx,Gy] = DerivGauss(HSIZE, SIGMA)
%obtenir les deux noyaux de convolution (HSIZE est la demi-taille du noyau, qui aura donc une taille 2*HSIZE+1, et SIGMA est l'écart-type du noyau gaussien)
   [x,y] = meshgrid(-HSIZE:HSIZE,-HSIZE:HSIZE);
   G=fspecial('gaussian',2*HSIZE+1,SIGMA);
   Gx = - x/(SIGMA*SIGMA) .* G;
   Gy = - y/(SIGMA*SIGMA) .* G;
end