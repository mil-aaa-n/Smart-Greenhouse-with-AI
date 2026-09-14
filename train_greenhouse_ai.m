clear;
clc;

load('AI_train_test_data_v4.mat');

rng(1);

% FAN AI
% Inputs: Temperature, Humidity, FanPrev
n0 = sum(Y_fan_train == 0);
n1 = sum(Y_fan_train == 1);

Wfan = zeros(size(Y_fan_train));
Wfan(Y_fan_train == 0) = 0.5/n0;
Wfan(Y_fan_train == 1) = 0.5/n1;

fanModel = fitcnet( ...
    X_fan_train_n, ...
    Y_fan_train, ...
    'LayerSizes',[16 8], ...
    'Weights',Wfan, ...
    'ClassNames',[0 1]);

% HEATER AI
% Inputs: Temperature, HeaterPrev
n0 = sum(Y_heater_train == 0);
n1 = sum(Y_heater_train == 1);

Wheater = zeros(size(Y_heater_train));
Wheater(Y_heater_train == 0) = 0.5/n0;
Wheater(Y_heater_train == 1) = 0.5/n1;

heaterModel = fitcnet( ...
    X_heater_train_n, ...
    Y_heater_train, ...
    'LayerSizes',[16 8], ...
    'Weights',Wheater, ...
    'ClassNames',[0 1]);

% PUMP AI
% Inputs: SoilMoisture, PumpPrev
n0 = sum(Y_pump_train == 0);
n1 = sum(Y_pump_train == 1);

Wpump = zeros(size(Y_pump_train));
Wpump(Y_pump_train == 0) = 0.5/n0;
Wpump(Y_pump_train == 1) = 0.5/n1;

pumpModel = fitcnet( ...
    X_pump_train_n, ...
    Y_pump_train, ...
    'LayerSizes',[16 8], ...
    'Weights',Wpump, ...
    'ClassNames',[0 1]);

%% ============================================================
% PREDICTIONS, ACCURACY AND SAVING THE MODEL
% ============================================================

fanValPred = double(predict(fanModel,X_fan_val_n));
fanTestPred = double(predict(fanModel,X_fan_test_n));

heaterValPred = double(predict(heaterModel,X_heater_val_n));
heaterTestPred = double(predict(heaterModel,X_heater_test_n));

pumpValPred = double(predict(pumpModel,X_pump_val_n));
pumpTestPred = double(predict(pumpModel,X_pump_test_n));

fanValAcc = mean(fanValPred == Y_fan_val)*100;
fanTestAcc = mean(fanTestPred == Y_fan_test)*100;

heaterValAcc = mean(heaterValPred == Y_heater_val)*100;
heaterTestAcc = mean(heaterTestPred == Y_heater_test)*100;

pumpValAcc = mean(pumpValPred == Y_pump_val)*100;
pumpTestAcc = mean(pumpTestPred == Y_pump_test)*100;

fprintf('\n=============================\n');
fprintf('V4 AI RESULTS\n');
fprintf('=============================\n');

fprintf('\nFan AI\n');
fprintf('Validation Accuracy = %.2f %%\n',fanValAcc);
fprintf('Test Accuracy       = %.2f %%\n',fanTestAcc);

fprintf('\nHeater AI\n');
fprintf('Validation Accuracy = %.2f %%\n',heaterValAcc);
fprintf('Test Accuracy       = %.2f %%\n',heaterTestAcc);

fprintf('\nPump AI\n');
fprintf('Validation Accuracy = %.2f %%\n',pumpValAcc);
fprintf('Test Accuracy       = %.2f %%\n',pumpTestAcc);

figure;
confusionchart(Y_fan_test,fanTestPred);
title('Fan AI - Test Confusion Matrix');

figure;
confusionchart(Y_heater_test,heaterTestPred);
title('Heater AI - Test Confusion Matrix');

figure;
confusionchart(Y_pump_test,pumpTestPred);
title('Pump AI - Test Confusion Matrix');

save('greenhouse_AI_models_v4.mat', ...
    'fanModel', ...
    'heaterModel', ...
    'pumpModel', ...
    'mu_fan','sigma_fan', ...
    'mu_heater','sigma_heater', ...
    'mu_pump','sigma_pump');

fprintf('\nModels saved as greenhouse_AI_models_v4.mat\n');