function [o] = adaptiveThres(a,W,noShow);
% Adaptive thresholding (Le seuillage adaptatif) est réalisé en segmentant l'image a

[w,h] = size(a);
o = zeros(w,h);

% le séparer du bloc W
% faire un pas à w avec step length W

for i=1:W:w
for j=1:W:h
mean_thres = 0;

% le blanc est la crête -> large

if i+W-1 <= w & j+W-1 <= h
   	mean_thres = mean2(a(i:i+W-1,j:j+W-1));
   	% la de threshold valeur est choisie
      mean_thres = 0.8*mean_thres;
      % Avant binarization :
      % ridges sont noir, petite valeur d'intensité -> 1 (crête blanche)
      % le fond et les vallées sont blancs, grande valeur d'intensité -> 0 (noir)
      o(i:i+W-1,j:j+W-1) = a(i:i+W-1,j:j+W-1) < mean_thres;
end;
   
end;
end;


if nargin == 2
imagesc(o);
colormap(gray);
end;