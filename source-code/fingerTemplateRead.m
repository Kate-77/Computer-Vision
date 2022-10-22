function template=fingerTemplateRead
% Boîte de dialogue pour ouvrir les fichiers d'empreintes digitales

[templatefile , pathname]= uigetfile('*.dat','Open An Fingerprint template file'); 
if templatefile ~= 0 
cd(pathname);
template=load(char(templatefile));
end;