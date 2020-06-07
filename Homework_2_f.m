%--------------------------------------------------------------------------
% Homework of array signal processing 2.f
% 
% Parameters, in genrate_signal.m
% Author: Xianrui Wang
% Cneter of Intelligent Acoustics and Immersive Communications
%
% Contact: wangxianrui@mail.nwpu.edu.cn
%--------------------------------------------------------------------------
clear;clc;
inputPara.f1=1000;  
inputPara.f2=1000; 
inputPara.snr1=0;
inputPara.snr2=0;
inputPara.phaseLag=pi;
inputPara.doa1=85/180*pi;
inputPara.doa2=95/180*pi;
inputPara.M = 10;
inputPara.vec=(0:(inputPara.M-1))';
[R, receivedSig] = generate_signal(inputPara);
searchRange = (0:180)/180*pi;
%% Matrix decomposition 
[U,Lambada]=eig(R);
[eigVal,idx]=sort(diag(Lambada),'descend');
Lambada=diag(eigVal);
U=U(:,idx);
Vn=U(:,3:end);  
%% scan 
for doaIndex = 1:length(searchRange)
    doa = searchRange(doaIndex);
    d=exp(-1j*inputPara.phaseLag*inputPara.vec*...
    cos(doa));
    DS=d/inputPara.M;
    MVDR = R\d/(d'/R*d);
    outputSig_ds = DS'*receivedSig;
    outputSig_mvdr = MVDR'*receivedSig;
    outputPower_ds(doaIndex) =  outputSig_ds*outputSig_ds';
    outputPower_mvdr(doaIndex) = outputSig_mvdr*outputSig_mvdr';
    outputPower_music(doaIndex)= 1/real(d'*(Vn*Vn')*d);
end
%% Normalize
outputPower_ds=10*log10(outputPower_ds/max(outputPower_ds));
outputPower_mvdr=10*log10(outputPower_mvdr/max(outputPower_mvdr));
outputPower_music=10*log10(outputPower_music/max(outputPower_music));
figure
plot(outputPower_ds,'-b','linewidth',1.2);
hold on;
plot(outputPower_mvdr,'-r','linewidth',1.2);
hold on;
plot(outputPower_music,'-k','linewidth',1.2);
legend('CBF','MVDR','MUSIC','linewidth',1.2);
xlim([0,180]);