function [R,receivedSig]=generate_signal(inputPara)
%--------------------------------------------------------------------------
% generate signal for homework 2
% 
% Inputs:
% signalPara: signal parameters
%          -signalPara.sourceSig1: source signal 1
%          -signalPara.sourceSig2: source signal 2
%          -signalPara.doa1: direction of arrival of source 1
%          -signalPara.doa2: direction of arrival of source 2
%          -signalPara.snr1: signal to noise ratio of received signal 1
%          -signalPara.snr2: signal to noise ratio of received signal 2
%          -signalPara.time: length of observed data in second.
%          -signalPara.f1: frequency of source signal 1
%          -signalPara.f1: frequency of source signal 2
%          -signalPara.fs: sampling frequency
%          -signalPara.steeringVec1: steering vector of source 1
%          -signalPara.steeringVec2: steering vector of source 2
%          -received signal = signalPara.steeringVec*signalPara.sourceSig
%                             +noise
% arrayPara: array configuration
%           -arrayPara.M : number of sensors
%           -arrayPara.phaseLag: phase lag
%
% Notice the length of noise sample is limited, the variance doesn't equal
% to 1, but it's ok to think so.
%
% Author: Xianrui Wang
% Cneter of Intelligent Acoustics and Immersive Communications
%
% Contact: wangxianrui@mail.nwpu.edu.cn
%--------------------------------------------------------------------------
%% Unmount parameters
signalPara.f1=inputPara.f1;  
signalPara.f2=inputPara.f2; 
signalPara.snr1=inputPara.snr1;
signalPara.snr2=inputPara.snr2;
signalPara.doa1=inputPara.doa1;
signalPara.doa2=inputPara.doa2;
arrayPara.phaseLag=inputPara.phaseLag;
arrayPara.M=inputPara.M ;
arrayPara.vec=inputPara.vec;
%% General parameters
arrayPara.M=10;    
arrayPara.vec=(0:(arrayPara.M-1))';
signalPara.fs=8192;
signalPara.time=1;  
sampleTime=(1:signalPara.fs*signalPara.time)/signalPara.fs;
%% Generate signals
[b,a]=cheby2(6,40,20/(signalPara.fs/2),'low'); 
s1=randn(1,length(sampleTime));
s2=randn(1,length(sampleTime));
s1=filter(b,a,s1); 
s2=filter(b,a,s2); 
signalPara.sourceSig1=s1.*exp(1j*(2*pi*signalPara.f1*sampleTime+2*pi*...
    rand(1,length(sampleTime)))); 
signalPara.sourceSig2=s2.*exp(1j*(2*pi*signalPara.f2*sampleTime+2*pi*...
    rand(1,length(sampleTime)))); 
signalPara.steeringVec1=exp(-1j*arrayPara.phaseLag*signalPara.f2/1000*...
    arrayPara.vec*cos(signalPara.doa1));
signalPara.steeringVec2=exp(-1j*arrayPara.phaseLag*signalPara.f1/1000*...
    arrayPara.vec*cos(signalPara.doa2));
%% Create noise and control snr
noise = randn(arrayPara.M,length(sampleTime));
sigma_v = (noise(1,:)*noise(1,:)')/length(sampleTime);
sigma_1 = (signalPara.sourceSig1*signalPara.sourceSig1')/...
    length(sampleTime);
sigma_2 = (signalPara.sourceSig2*signalPara.sourceSig2')/...
    length(sampleTime);
SNR1 = 10^(signalPara.snr1/10);
scale1 = sqrt(SNR1/sigma_1);
SNR2 = 10^(signalPara.snr2/10);
scale2 = sqrt(SNR2/sigma_2);
signalPara.sourceSig1 = scale1*signalPara.sourceSig1;
signalPara.sourceSig2 = scale2*signalPara.sourceSig2;
%% Create recevied signal
receivedSig = (signalPara.steeringVec1*signalPara.sourceSig1+...
    signalPara.steeringVec2*signalPara.sourceSig2+noise);
R = (receivedSig*receivedSig')/length(sampleTime);


