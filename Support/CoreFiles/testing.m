%% Timing Script:
clear all; %#ok<*CLALL>
clc;
%% Part 0: Create .mat file:
clear all;
clc;
[arrSound1, arrBitRate1] = audioread('Start.mp3'); %#ok<*ASGLU>
[arrSound2, arrBitRate2] = audioread('Pass1.mp3');
[arrSound3, arrBitRate3] = audioread('Pass2.mp3');
[arrSound4, arrBitRate4] = audioread('Pass3.mp3');
[arrSound5, arrBitRate5] = audioread('Pass4.mp3');
[arrSound6, arrBitRate6] = audioread('Fail1.mp3');
[arrSound7, arrBitRate7] = audioread('Fail2.mp3');
[arrSound8, arrBitRate8] = audioread('Fail3.mp3');
[arrSound9, arrBitRate9] = audioread('Error1.mp3');
[arrSound10, arrBitRate10] = audioread('Error2.mp3');
[arrSound11, arrBitRate11] = audioread('Error3.mp3');
save('audio.mat');
%% Part I: Time how long it takes to read in the mp3 files raw:
clear all;
clc;
tic;
[arrSound1, arrBitRate1] = audioread('Start.mp3');
[arrSound2, arrBitRate2] = audioread('Pass1.mp3');
[arrSound3, arrBitRate3] = audioread('Pass2.mp3');
[arrSound4, arrBitRate4] = audioread('Pass3.mp3');
[arrSound5, arrBitRate5] = audioread('Pass4.mp3');
[arrSound6, arrBitRate6] = audioread('Fail1.mp3');
[arrSound7, arrBitRate7] = audioread('Fail2.mp3');
[arrSound8, arrBitRate8] = audioread('Fail3.mp3');
[arrSound9, arrBitRate9] = audioread('Error1.mp3');
[arrSound10, arrBitRate10] = audioread('Error2.mp3');
[arrSound11, arrBitRate11] = audioread('Error3.mp3');
t1 = toc;
%% Part II: Time how long it takes to read in the .mat file:
clear all;
clc;
tic;
load('audio.mat');
t2 = toc;
%%