%--------------------------------------------------------------------------
% Homework of array signal processing 1.f
% 
% Inputs:
% signalPara: signal parameters
%          -signalPara.sourceSig: source signal
%          -signalPara.doa: direction of arrival of source 
%          -signalPara.snr: signal to noise ratio of received signal
%          -signalPara.time: length of observed data in second.
%          -signalPara.f: frequency of source signal
%          -signalPara.fs: sampling frequency
%          -signalPara.steeringVec: steering vector
%          -signalPara.num: number of signal sources
%          -received signal = signalPara.steeringVec*signalPara.sourceSig
%                             +noise
%
% arrayPara:  configuration of array
%          -arrayPara.M: number of sensors
%          -arrayPara.phaseLag: lambda/c*2pi
%          -arrayPara.weight: weight types
%          -arrayPara.vec: to construct steering vector
% Author: Xianrui Wang
% Cneter of Intelligent Acoustics and Immersive Communications
%
% Contact: wangxianrui@mail.nwpu.edu.cn
%--------------------------------------------------------------------------
clear;clc;
%% Parameters initialize
arrayPara.M = 32;
arrayPara.vec=(0:(arrayPara.M-1)).';
arrayPara.phaseLag = pi;
arrayPara.weight = 'uniform';
signalPara.time = 0.4;
signalPara.f = 62.5';
signalPara.fs = 1e3;
sampleTime = (1:signalPara.fs*signalPara.time)'/signalPara.fs;
signalPara.doa = pi/3;
signalPara.num = length(signalPara.doa);
signalPara.snr = 10;
signalPara.sourceSignal = exp(1j*2*pi*signalPara.f*sampleTime);
%% Construct steering vector and search vector
signalPara.steeringVec = exp(-1j*arrayPara.phaseLag*arrayPara.vec*...
    cos(signalPara.doa));
searchRange=(0:1:180)/180*pi;
searchVec= exp(-1j*arrayPara.phaseLag*arrayPara.vec*...
    cos(searchRange))/arrayPara.M;
%% Input and output signal
for snrIndex = 1:length(signalPara.snr)
    snr = signalPara.snr(snrIndex);
    SNR = 10^(snr/10);
    sigma_v=1/SNR;
    noise =sqrt(sigma_v)*randn(arrayPara.M,length(signalPara.sourceSignal));
    for sourceIndex=1:signalPara.num
        d = signalPara.steeringVec(:,sourceIndex);
        receivedSig = d*signalPara.sourceSignal.'+noise;
    end
end
%% Scan power at different DOA
for doaIndex = 1:length(searchRange)
    outputSig = searchVec(:,doaIndex)'*receivedSig;
    outputPower(doaIndex) = 10*log10(outputSig*outputSig');
end
%% Figure plot
angle = 0:180;
for snrIndex = 1:length(signalPara.snr)
    figure
    plot(angle, outputPower);
    line([60,60],[0,30], 'Color', 'r','linewidth',1.2);
    xlim([0,180]);
end

