function [Csec, Cquarte] = innerDerivative(eC)
    %calculer C'' et C'''' à tous les points de eC (EXTENDED curve) avec la méthode des différences
    %finies.

    Csec = eC(:,2:end-3) - 2.*eC(:,3:end-2) + eC(:,4:end-1);
    Cquarte = eC(:,1:end-4) - 4.*eC(:,2:end-3) + 6.*eC(:,3:end-2) - 4.*eC(:,4:end-1) + eC(:,5:end);