function [newXY] = MinuOriginTransRidge(real_end,k,ridgeMap)
%  MinuOrigin(real_end,k,ridgeMap)
%  Définir la k-ième minutie comme origine et aligner sa direction sur zéro (le long de x)
%  Puis accueillir tous les autres points de crête reliant le miniutia au nouveau système de coordonnées
%
%  Notez que le système de coordination et l'angle sont différents :
%  ---------------------->y
%  |\
%  | \
%  |  \
%  |   \   
%  |thet\a
%  x
%  La valeur de la position vers le bas, la droite est positive.
%  La valeur de l'angle est dans le sens inverse des aiguilles d'une montre
% du bas vers le haut de l'axe des x à droite, dans les limites de [0,pi]
		
        %construct the affine transform matrix	
		% cos(theta)  -sin(theta)
		% sin(theta)   cos(thea)
		% to rotate angle theta
      
      theta = real_end(k,3);
      if theta <0
		theta1=2*pi+theta;
		end;

		theta1=pi/2-theta;

      rotate_mat=[cos(theta1),-sin(theta1);sin(theta1),cos(theta1)];
      
      % localisez tous les points de crête se connectant à la miniutia et transposez-le sous la forme :
      %x1 x2 x3...
      %y1 y2 y3...
      pathPointForK = find(ridgeMap(:,3)== k);
      toBeTransformedPointSet = ridgeMap(min(pathPointForK):max(pathPointForK),1:2)';
      
      %translater la position de la minutie (x,y) en (0,0)
      %translater tous les autres points de crête selon la base 
      tonyTrickLength = size(toBeTransformedPointSet,2);
      pathStart = real_end(k,1:2)';
      translatedPointSet = toBeTransformedPointSet - pathStart(:,ones(1,tonyTrickLength));
      
      %faire pivoter les ensembles de points
      newXY = rotate_mat*translatedPointSet;