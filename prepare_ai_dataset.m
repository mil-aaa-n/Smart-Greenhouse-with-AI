clear;
clc;

allData = readtable('greenhouse_training_data.csv');

FanPrev    = zeros(height(allData),1);
HeaterPrev = zeros(height(allData),1);
PumpPrev   = zeros(height(allData),1);

for sim = 1:16

    idx = find(allData.Simulation == sim);

    if isempty(idx)
        continue;
    end

    FanPrev(idx(1))    = 0;
    HeaterPrev(idx(1)) = 0;
    PumpPrev(idx(1))   = 0;

    if length(idx) > 1

        FanPrev(idx(2:end)) = ...
            allData.Fan(idx(1:end-1));

        HeaterPrev(idx(2:end)) = ...
            allData.Heater(idx(1:end-1));

        PumpPrev(idx(2:end)) = ...
            allData.Pump(idx(1:end-1));

    end
end

X_fan = [
    allData.Temperature ...
    allData.Humidity ...
    FanPrev
];

X_heater = [
    allData.Temperature ...
    HeaterPrev
];

X_pump = [
    allData.SoilMoisture ...
    PumpPrev
];

Y_fan    = allData.Fan;
Y_heater = allData.Heater;
Y_pump   = allData.Pump;

trainIdx = ismember(allData.Simulation,1:12);
valIdx   = ismember(allData.Simulation,13:14);
testIdx  = ismember(allData.Simulation,15:16);

X_fan_train = X_fan(trainIdx,:);
X_fan_val   = X_fan(valIdx,:);
X_fan_test  = X_fan(testIdx,:);

Y_fan_train = Y_fan(trainIdx);
Y_fan_val   = Y_fan(valIdx);
Y_fan_test  = Y_fan(testIdx);

X_heater_train = X_heater(trainIdx,:);
X_heater_val   = X_heater(valIdx,:);
X_heater_test  = X_heater(testIdx,:);

Y_heater_train = Y_heater(trainIdx);
Y_heater_val   = Y_heater(valIdx);
Y_heater_test  = Y_heater(testIdx);

X_pump_train = X_pump(trainIdx,:);
X_pump_val   = X_pump(valIdx,:);
X_pump_test  = X_pump(testIdx,:);

Y_pump_train = Y_pump(trainIdx);
Y_pump_val   = Y_pump(valIdx);
Y_pump_test  = Y_pump(testIdx);

mu_fan = mean(X_fan_train,1);
sigma_fan = std(X_fan_train,0,1);
sigma_fan(sigma_fan == 0) = 1;

X_fan_train_n = (X_fan_train - mu_fan)./sigma_fan;
X_fan_val_n   = (X_fan_val   - mu_fan)./sigma_fan;
X_fan_test_n  = (X_fan_test  - mu_fan)./sigma_fan;

mu_heater = mean(X_heater_train,1);
sigma_heater = std(X_heater_train,0,1);
sigma_heater(sigma_heater == 0) = 1;

X_heater_train_n = (X_heater_train - mu_heater)./sigma_heater;
X_heater_val_n   = (X_heater_val   - mu_heater)./sigma_heater;
X_heater_test_n  = (X_heater_test  - mu_heater)./sigma_heater;

mu_pump = mean(X_pump_train,1);
sigma_pump = std(X_pump_train,0,1);
sigma_pump(sigma_pump == 0) = 1;

X_pump_train_n = (X_pump_train - mu_pump)./sigma_pump;
X_pump_val_n   = (X_pump_val   - mu_pump)./sigma_pump;
X_pump_test_n  = (X_pump_test  - mu_pump)./sigma_pump;

save('AI_train_test_data_v4.mat', ...
    'X_fan_train_n','X_fan_val_n','X_fan_test_n', ...
    'Y_fan_train','Y_fan_val','Y_fan_test', ...
    'mu_fan','sigma_fan', ...
    'X_heater_train_n','X_heater_val_n','X_heater_test_n', ...
    'Y_heater_train','Y_heater_val','Y_heater_test', ...
    'mu_heater','sigma_heater', ...
    'X_pump_train_n','X_pump_val_n','X_pump_test_n', ...
    'Y_pump_train','Y_pump_val','Y_pump_test', ...
    'mu_pump','sigma_pump');

fprintf('\nDataset preparation complete.\n');

fprintf('\nFan AI inputs:    %d\n',size(X_fan_train_n,2));
fprintf('Heater AI inputs: %d\n',size(X_heater_train_n,2));
fprintf('Pump AI inputs:   %d\n',size(X_pump_train_n,2));

fprintf('\nTraining samples:   %d\n',sum(trainIdx));
fprintf('Validation samples: %d\n',sum(valIdx));
fprintf('Test samples:       %d\n',sum(testIdx));