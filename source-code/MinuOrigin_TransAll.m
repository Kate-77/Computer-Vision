function [newXY] = MinuOrigin_TransAll(real_end,k)
%  MinuOrigin_all(real_end,k)
%  Définir la k-ième minutie comme origine et aligner sa direction sur zéro (le long de x)
%  Puis adapter tous les autres points minutieux de l'empreinte digitale anouvelle origine

%  La différence entre MinuOrigin et MinuOrigin_all est que l'orientation de chaque minutie est également ajusté avec la minutie d'origine

theta = real_end(k,3);

if theta <0
	theta1=2*pi+theta;
end;

theta1=pi/2-theta;


rotate_mat=[cos(theta1),-sin(theta1),0;sin(theta1),cos(theta1),0;0,0,1];

      toBeTransformedPointSet = real_end';
      
      tonyTrickLength = size(toBeTransformedPointSet,2);
      
      pathStart = real_end(k,:)';
      
      translatedPointSet = toBeTransformedPointSet - pathStart(:,ones(1,tonyTrickLength));
      
      newXY = rotate_mat*translatedPointSet;
      
      %La direction doit etre dans le domaine[-pi,pi]
      
      for i=1:tonyTrickLength
         if or(newXY(3,i)>pi,newXY(3,i)<-pi)
            newXY(3,i) = 2*pi - sign(newXY(3,i))*newXY(3,i);
         end;
      end;
      
		