%--------------------------------------------------------------------------
% Homework of array signal processing 1.a
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
signalPara.doa = [0 10 30 70 85 86 90]/180*pi;
signalPara.num = length(signalPara.doa);
signalPara.sourceSignal = exp(1j*2*pi*signalPara.f*sampleTime);
%% Construct steering vector
signalPara.steeringVec = exp(-1j*arrayPara.phaseLag*arrayPara.vec*...
    cos(signalPara.doa));
%% Weight vector
if arrayPara.weight == 'uniform'
    h = ones(1,arrayPara.M)/arrayPara.M;
end
%% Input and output signal
for sourceIndex=1:signalPara.num
    d = signalPara.steeringVec(:,sourceIndex);
    outputSignal(:,sourceIndex) = real((h*d)*signalPara.sourceSignal);
end
%% Figure plot
fig=figure('position',[0 0 1000 1000]);
set(gcf,'DefaultTextInterpreter','latex');
subplot('position', [0.05 0.8 0.4 0.18]);
plot(sampleTime,outputSignal(:,1));
xlabel('time(s)');
ylabel('amplitude');
ylim([-1 1])
legend('DOA=0^\circ');
subplot('position', [0.55 0.8 0.4 0.18]);
plot(sampleTime,outputSignal(:,2));
xlabel('time(s)');
ylabel('amplitude');
ylim([-1 1])
legend('DOA=10^\circ');
subplot('position', [0.05 0.55 0.4 0.18]);
plot(sampleTime,outputSignal(:,3));
xlabel('time(s)');
ylabel('amplitude');
ylim([-1 1])
legend('DOA=30^\circ');
subplot('position', [0.55 0.55 0.4 0.18]);
plot(sampleTime,outputSignal(:,4));
xlabel('time(s)');
ylabel('amplitude');
ylim([-1 1])
legend('DOA=70^\circ');
subplot('position', [0.05 0.3 0.4 0.18]);
plot(sampleTime,outputSignal(:,5));
xlabel('time(s)');
ylabel('amplitude');
ylim([-1 1])
legend('DOA=85^\circ');
subplot('position', [0.55 0.3 0.4 0.18]);
plot(sampleTime,outputSignal(:,6));
xlabel('time(s)');
ylabel('amplitude');
ylim([-1 1])
legend('DOA=86^\circ');
subplot('position', [0.05 0.05 0.4 0.18]);
plot(sampleTime,outputSignal(:,7));
xlabel('time(s)');
ylabel('amplitude');
ylim([-1 1])
legend('DOA=90^\circ');
subplot('position', [0.55 0.05 0.4 0.18]);
plot(sampleTime,real(signalPara.sourceSignal));
ylim([-1 1])
legend('Source signal');
xlabel('time(s)');
ylabel('amplitude');