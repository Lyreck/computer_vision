function A = find_trans_Procuste1(P,Q)
    % Fonction qui prend deux ensembles de N points sous la forme d'une
    % matrice de Nx2, et renvoie le recalage affine A

    P_centre = P - mean(P);
    Q_centre = Q - mean(Q);

    % Décomposition en valeurs singulières
    % On utilise la synthaxe du cours (M = VSU') et pas celle de la
    % documentation (M = USV') pour dÃ©finir R comme dans le cours
    [V, ~, U] = svd(Q_centre'*P_centre);

    % Définition de R donnée dans le cours
    R = V*U';

    % Définition de T donnée dans le cours
    T = mean(Q)' - R*mean(P)';

    % Transformation rigide
    A_rigid = rigid2d(R, T');

    % Matrice de transformation affine 
    T_affine = [A_rigid.Rotation A_rigid.Translation';
                 0,        0,        1];

    % Transformation affine
    A = affine2d(T_affine');
end