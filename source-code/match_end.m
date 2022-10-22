function [percent_match]=match_end(template1,template2,edgeWidth,noShow)
% MATCH_END Fingerprint Minutia Matcher basé sur l'alignement de la crête(Ridge Alignment)

%	 match_end(template1,template2) accepte les deux fichiers modèles
%    et renvoie la certitude similaire maximale des deux empreintes digitales
%    Le fichier de modèle stocke une matrice Nx3 avec le format spécifié suivant : 

%     -------------------------------------------------------------------

%		minutia_1_position_x  minutia_2_position_y  minutia_1_orientation
%		...                   ...                   ...
%     minutia_n_position_x  minutia_n_position_y  minutia_n_orientation
%     ridge_1_point_1_posx    ridge_1_point_1_posy    ridge_ID(1)
%     ...                     ...                     ...     
%     ridge_1_point_m_posx    ridge_1_point_m_posy    ridge_ID(1)
%     ridge_2_point_1_posx    ridge_2_point_1_posy    ridge_ID(2)
%     ...                     ...                     ...     
%     ridge_n_point_1_posx    ridge_n_point_1_posy    ridge_ID(n)
%     ...                     ...                     ...     
%     ridge_n_point_m_posx    ridge_n_point_m_posy    ridge_ID(n)
%
%		n fait référence au nombre total de miniutia
%       m est fixé à la valeur de la largeur moyenne inter-crête

%     ------------------------------------------------------------------

%	 match_end(template1,template2,noShow) accepte également le drapeau 'noShow' pour désactiver le
%    boîte de dialogue contextuelle affichant le pourcentage de correspondance final. 
%    La valeur peut être simplement définie sur 0.
%    Cette fonction est utilisée pour le traitement par lots.

%   Décomposer le fichier de modèle en minutes et matrices de crête séparément
if or(edgeWidth == 0,isempty(edgeWidth))
   edgeWidth=10;
end;

if or(isempty(template1), isempty(template2))
   percent_match = -1;
else
length1 = size(template1,1);
minu1 = template1(length1,3);
real_end1 = template1(1:minu1,:);
ridgeMap1= template1(minu1+1:length1,:);

length2 = size(template2,1);
minu2 = template2(length2,3);
real_end2 = template2(1:minu2,:);
ridgeMap2= template2(minu2+1:length2,:);

ridgeNum1 = minu1; 
minuNum1 = minu1;
ridgeNum2 = minu2;
minuNum2 = minu2;


max_percent=zeros(1,3);
      
for k1 = 1:minuNum1
      %minuNum2
      
      % calculer les similarités entre ridgeMap1(k1) et ridgeMap(k2)
      % choisissez les deux minuties actuelles comme origines et ajustez les autres minuties
      % basé sur la minutie d'origine.
      
      newXY1 = MinuOriginTransRidge(real_end1,k1,ridgeMap1);
   for k2 = 1:minuNum2

      newXY2 = MinuOriginTransRidge(real_end2,k2,ridgeMap2);
      
      % choisir la longueur de crete minimale
      compareL = min(size(newXY1,2),size(newXY2,2));
      % comparer la certitude de similarité de deux crêtes
      eachPairP = newXY1(1,1:compareL).*newXY2(1,1:compareL);
      pairPSquare = eachPairP.*eachPairP;
      temp = sum(pairPSquare);
      
      ridgeSimCoef = 0;
      
      if temp > 0
      ridgeSimCoef = sum(eachPairP)/( temp^.5 );
      end;
      
if ridgeSimCoef > 0.8
   		% transférer toutes les minuties en deux empreintes digitales basées sur
        % la paire de minutie de référence
         fullXY1=MinuOrigin_TransAll(real_end1,k1);
         fullXY2=MinuOrigin_TransAll(real_end2,k2);
         
         minuN1 = size(fullXY1,2);
         minuN2 = size(fullXY2,2);
         xyrange=edgeWidth;
         num_match = 0;
         
        % si deux minuties se trouvent dans une boîte de largeur 20 et hauteur 20,
        % ils ont une petite variation de direction pi/3
        % puis les considérer comme une paire assortie
         
for i=1:minuN1 
   for j=1:minuN2  
      if (abs(fullXY1(1,i)-fullXY2(1,j))<xyrange & abs(fullXY1(2,i)-fullXY2(2,j))<xyrange)
         angle = abs(fullXY1(3,i) - fullXY2(3,j) );
         if or (angle < pi/3, abs(angle-pi)<pi/6)
         num_match=num_match+1;     
         break;
         end;
      end;   
   end;
end;

% obtenir le plus grand score de correspondance (matching score)
current_match_percent=num_match;
if current_match_percent > max_percent(1,1);
   max_percent(1,1) = current_match_percent;
   max_percent(1,2) = k1;
   max_percent(1,3) = k2;
end;
num_match = 0;

end;
end;
end;

percent_match = max_percent(1,1)*100/minuNum1;
end;

% si la fonction est appelée en mode graphique, affiche la boîte de message
% pour le résultat final
if nargin == 3
   text=strcat('The max matching percentage is  ',num2str(percent_match),'%');
msgbox(text);
end;