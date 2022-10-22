function image1=loadimage
% Boîte de dialogue pour ouvrir les fichiers d'empreintes digitales
[imagefile1 , pathname]= uigetfile('*.bmp;*.BMP;*.tif;*.TIF;*.jpg','Open An Fingerprint image'); 
if imagefile1 ~= 0 
cd(pathname);
image1=readimage(char(imagefile1));
image1=255-double(image1);

end;

