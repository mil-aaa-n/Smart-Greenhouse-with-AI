clearvars;
clc;

greenhouse_parameters;

load('greenhouse_AI_models_v4.mat');

N = 16;

allData = table();

rng(1);

for k = 1:N

    fprintf('Running simulation %d of %d...\n', k, N);

    in = Simulink.SimulationInput('SmartGreenhouse_V4_Baseline');

    switch k

        % NORMAL CONDITIONS
        case 1
            T_bias = 25;
            T_amp = 5;
            Solar_bias = 500;
            Solar_amp = 300;
            RH_bias = 60;
            RH_amp = 10;
            T0 = 25;
            RH0 = 60;
            M0 = 60;
        case 2
            T_bias = 26;
            T_amp = 4;
            Solar_bias = 600;
            Solar_amp = 300;
            RH_bias = 65;
            RH_amp = 10;
            T0 = 26;
            RH0 = 65;
            M0 = 60;

        % HOT CONDITIONS
        case 3
            T_bias = 32;
            T_amp = 5;
            Solar_bias = 800;
            Solar_amp = 300;
            RH_bias = 50;
            RH_amp = 10;
            T0 = 32;
            RH0 = 50;
            M0 = 60;
        case 4
            T_bias = 35;
            T_amp = 4;
            Solar_bias = 900;
            Solar_amp = 300;
            RH_bias = 45;
            RH_amp = 10;
            T0 = 34;
            RH0 = 45;
            M0 = 60;

        % COLD CONDITIONS
       case 5
            T_bias = 16;
            T_amp = 2;
            Solar_bias = 250;
            Solar_amp = 100;
            RH_bias = 75;
            RH_amp = 5;
            T0 = 16;
            RH0 = 75;
            M0 = 60;
        case 6
            T_bias = 14;
            T_amp = 2;
            Solar_bias = 150;
            Solar_amp = 75;
            RH_bias = 80;
            RH_amp = 5;
            T0 = 14;
            RH0 = 80;
            M0 = 60;

        % DRY CONDITIONS
        case 7
            T_bias = 29;
            T_amp = 5;
            Solar_bias = 800;
            Solar_amp = 300;
            RH_bias = 40;
            RH_amp = 5;
            T0 = 29;
            RH0 = 40;
            M0 = 25;
        case 8
            T_bias = 31;
            T_amp = 5;
            Solar_bias = 900;
            Solar_amp = 300;
            RH_bias = 35;
            RH_amp = 5;
            T0 = 31;
            RH0 = 35;
            M0 = 20;

        % WET CONDITIONS
        case 9
            T_bias = 25;
            T_amp = 3;

            Solar_bias = 400;
            Solar_amp = 200;

            RH_bias = 85;
            RH_amp = 5;

            T0 = 25;
            RH0 = 85;
            M0 = 60;
        case 10
            T_bias = 27;
            T_amp = 3;

            Solar_bias = 500;
            Solar_amp = 200;

            RH_bias = 90;
            RH_amp = 5;

            T0 = 27;
            RH0 = 90;
            M0 = 60;
        case 11
            T_bias = 23;
            T_amp = 3;

            Solar_bias = 300;
            Solar_amp = 150;

            RH_bias = 88;
            RH_amp = 6;

            T0 = 23;
            RH0 = 88;
            M0 = 60;
        case 12
            T_bias = 29;
            T_amp = 3;

            Solar_bias = 600;
            Solar_amp = 250;

            RH_bias = 85;
            RH_amp = 5;

            T0 = 29;
            RH0 = 85;
            M0 = 60;

        % MIXED CONDITIONS
        case 13
            T_bias = 29;
            T_amp = 7;
            Solar_bias = 650;
            Solar_amp = 350;
            RH_bias = 55;
            RH_amp = 15;
            T0 = 25;
            RH0 = 55;
            M0 = 45;

        case 14
            T_bias = 23;
            T_amp = 10;
            Solar_bias = 500;
            Solar_amp = 300;
            RH_bias = 60;
            RH_amp = 15;
            T0 = 25;
            RH0 = 60;
            M0 = 45;

        case 15
            T_bias = 27;
            T_amp = 8;
            Solar_bias = 750;
            Solar_amp = 350;
            RH_bias = 50;
            RH_amp = 15;
            T0 = 27;
            RH0 = 50;
            M0 = 38;

        case 16
            T_bias = 24;
            T_amp = 9;
            Solar_bias = 550;
            Solar_amp = 300;
            RH_bias = 65;
            RH_amp = 15;
            T0 = 24;
            RH0 = 65;
            M0 = 42;
    end

    in = in.setVariable('T_bias', T_bias);
    in = in.setVariable('T_amp', T_amp);

    in = in.setVariable('Solar_bias', Solar_bias);
    in = in.setVariable('Solar_amp', Solar_amp);

    in = in.setVariable('RH_bias', RH_bias);
    in = in.setVariable('RH_amp', RH_amp);

    in = in.setVariable('T0', T0);
    in = in.setVariable('RH0', RH0);
    in = in.setVariable('M0', M0);

    simOut = sim(in);

    logs = simOut.logsout;

    temperature = logs.get('temperature');
    humidity = logs.get('humidity');
    soil = logs.get('soil moisture');
    solar = logs.get('solar');

    fan = logs.get('fan');
    heater = logs.get('heater');
    pump = logs.get('pump');

    t = temperature.Values.Time;

    T = temperature.Values.Data;
    RH = humidity.Values.Data;
    M = soil.Values.Data;
    S = solar.Values.Data;

    F = fan.Values.Data;
    H = heater.Values.Data;
    P = pump.Values.Data;

    RH_i = interp1(humidity.Values.Time, RH, t, ...
        'linear', 'extrap');

    M_i = interp1(soil.Values.Time, M, t, ...
        'linear', 'extrap');

    S_i = interp1(solar.Values.Time, S, t, ...
        'linear', 'extrap');

    F_i = interp1(fan.Values.Time, double(F), t, ...
    'previous', 'extrap');

    H_i = interp1(heater.Values.Time, double(H), t, ...
        'previous', 'extrap');
    
    P_i = interp1(pump.Values.Time, double(P), t, ...
        'previous', 'extrap');

    scenario = repmat(k,length(t),1);

    tempTable = table( ...
        t, ...
        T, ...
        RH_i, ...
        M_i, ...
        S_i, ...
        F_i, ...
        H_i, ...
        P_i, ...
        scenario, ...
        'VariableNames', { ...
        'Time', ...
        'Temperature', ...
        'Humidity', ...
        'SoilMoisture', ...
        'Solar', ...
        'Fan', ...
        'Heater', ...
        'Pump', ...
        'Simulation'});

    allData = [allData; tempTable];

end

writetable(allData,'greenhouse_training_data.csv');

save('greenhouse_training_data.mat','allData');

fprintf('\n=====================================\n');
fprintf('Training data generation complete.\n');
fprintf('Total samples: %d\n',height(allData));
fprintf('=====================================\n');


fprintf('\nFan distribution:\n');
tabulate(allData.Fan);

fprintf('\nHeater distribution:\n');
tabulate(allData.Heater);

fprintf('\nPump distribution:\n');
tabulate(allData.Pump);