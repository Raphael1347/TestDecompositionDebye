clear
clc
close all

% Frequences des mesures synthetiques
f=logspace(-3,4,50);
w=f.*(2*pi); % frequences angulaires associees

% Parametres pour la modelisation ColeCole 
% Modifier la fonction ColeCole pour prendre les arguments sous cette forme
Ro = 1000;
m = [0.25, 0.75];
c = [0.5, 1.0];
tau = [10.^-2, 10.^-5];

% Aller chercher Z (complexe) de la fonction ColeCole
% Il serait bien que la fonction ColeCole prenne comme arguments:
% w, Z0, m, c, tau
Z = ColeCole(w);


% Zo pour inversion Debye
Zo=1000;
% Liste des tau a utiliser
% J'ai change les bornes pour aller de -6 a 4 (1 micro sec � 10000 sec)
% floor(log10(min(1./w))-1) : prend l'inverse des frequences angulaires, va
% un ordre de gradeur en dessous et arrondi vers le bas
% ceil(log10(max(1./w))+1) : prend l'inverse des frequences angulaires, va
% un ordre de gradeur en haut et arrondi vers le haut
% De cette facon les tau dependent toujours des frequences
t=logspace(floor(log10(min(1./w))-1), ceil(log10(max(1./w))+1), 1000).'; 



% Normalisation de Z pour inversion Debye
Zn=(Zo-Z)./Zo; 
 
% Placer les parties reelles et imaginaires de Z dans un seul vecteur
Zn=[real(Zn) imag(Zn)].';


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Tout ce block pourrait etre mis dans une fonction a part
% Calcul de la matrice d'inversion 
A1=(t*w).^2./(1+(t*w).^2);
A2=(t*w)./(1+(t*w).^2);
A=[A1 A2].';
mk=lsqnonneg(A,Zn);
% Reconstruction du data synthetique a partir des resultats (mk) de
% l'inversion Debye
Znr2=mk.'*((t*w).^2./(1+(t*w).^2));
Zni2=mk.'*((t*w)./(1+(t*w).^2));
Zn2 = complex(Znr2, Zni2);
% enlever la normalisation du data reconstruit
Z2 = -((Zo*Zn2)-Zo);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure(1)

subplot(2,2,1)
plot(real(Z),-imag(Z),'xb')
hold on
plot(real(Z2), -imag(Z2), '-r')
xlabel('Z''')
ylabel('Z''''')
legend('Cole-Cole','Inversion debye')

subplot(2,2,2)
Amp=abs(Z);
Amp2=abs(Z2);
semilogx(f,Amp,'xb')
hold on
semilogx(f,Amp2, '-r')
xlabel('Frequence')
ylabel('Amplitude de Z*')
legend('Cole-Cole','Inversion debye')

subplot(2,2,3)
Phase=angle(Z);
Phase2=angle(Z2);
loglog(f,-Phase,'xb')
hold on
loglog(f,-Phase2, '-r')
xlabel('Frequence')
ylabel('Phase')
legend('Cole-Cole','Inversion debye')

% figure(2)
% 
% subplot(2,2,1)
% plot(Znr2,-Zni2)
% xlabel('Partie réel de Z*')
% ylabel('Partie imaginaire de Z*')
% 
% subplot(2,2,2)
% semilogx(f,Amp2)
% xlabel('Fréquence angulaire')
% ylabel('Amplitude de Z*')
% 
% subplot(2,2,3)
% loglog(f,-Phase2)
% 
% xlabel('Fréquence angulaire')
% ylabel('Phase')

