%% ============================================================
% MATRIX SMART GREENHOUSE
% AI CONTROLLER - SELECT ONE SCENARIO
%
% Change ONLY:
%
%       scenario = 1;
%
% Available scenarios:
%   1 = Hot Greenhouse
%   2 = Cold Greenhouse
%   3 = Dry Soil
%   4 = Wet Soil
%   5 = Normal Greenhouse
%   6 = 24-Hour Mixed Weather
%
% ============================================================

clc

%% ============================================================
% SELECT SCENARIO
% ============================================================

scenario = 6;


%% ============================================================
% CODE
% ============================================================

greenhouse_parameters

load('greenhouse_AI_models_v4.mat')

model = 'greenhouse_final';

load_system(model)

set_param(model,'SolverType','Fixed-step')
set_param(model,'FixedStep','Ts')

switch scenario

    case 1

        scenarioName = 'Hot Greenhouse';

        T_bias = 31;
        T_amp  = 7;

        Solar_bias = 700;
        Solar_amp  = 600;

        RH_bias = 50;
        RH_amp  = 10;

        T0  = 30;
        RH0 = 55;
        M0  = 60;

        StopTime = 86400;

    case 2

        scenarioName = 'Cold Greenhouse';

        T_bias = 18;
        T_amp  = 5;

        Solar_bias = 150;
        Solar_amp  = 100;

        RH_bias = 70;
        RH_amp  = 10;

        T0  = 18;
        RH0 = 70;
        M0  = 60;

        StopTime = 86400;

    case 3

        scenarioName = 'Dry Soil';

        T_bias = 30;
        T_amp  = 6;

        Solar_bias = 800;
        Solar_amp  = 600;

        RH_bias = 40;
        RH_amp  = 10;

        T0  = 28;
        RH0 = 50;
        M0  = 35;

        StopTime = 86400;

    case 4

        scenarioName = 'Wet Soil';

        T_bias = 25;
        T_amp = 4;
        
        Solar_bias = 400;
        Solar_amp = 200;
        
        RH_bias = 85;
        RH_amp = 8;
        
        T0 = 25;
        RH0 = 85;
        M0 = 60;
        
        StopTime = 86400;

    case 5

        scenarioName = 'Normal Greenhouse';

        T_bias = 25;
        T_amp  = 5;

        Solar_bias = 500;
        Solar_amp  = 300;

        RH_bias = 60;
        RH_amp  = 10;

        T0  = 25;
        RH0 = 60;
        M0  = 60;

        StopTime = 86400;

    case 6

        scenarioName = '24-Hour Mixed Weather';

        T_bias = 29;
        T_amp  = 7;

        Solar_bias = 650;
        Solar_amp  = 350;

        RH_bias = 55;
        RH_amp  = 15;

        T0  = 25;
        RH0 = 55;
        M0  = 45;

        StopTime = 86400;

    otherwise

        error('Invalid scenario. Choose a number from 1 to 6.');

end

fprintf('\n');
fprintf('============================================================\n');
fprintf('       MATRIX SMART GREENHOUSE - AI TEST\n');
fprintf('============================================================\n');

fprintf('\nSelected Scenario: %d\n',scenario);
fprintf('Scenario: %s\n',scenarioName);

fprintf('\n--- Weather Conditions ---\n');

fprintf('Temperature bias    : %.1f °C\n',T_bias);
fprintf('Temperature amplitude: %.1f °C\n',T_amp);

fprintf('Solar bias          : %.1f\n',Solar_bias);
fprintf('Solar amplitude     : %.1f\n',Solar_amp);

fprintf('Humidity bias       : %.1f %%\n',RH_bias);
fprintf('Humidity amplitude  : %.1f %%\n',RH_amp);

fprintf('\n--- Initial Conditions ---\n');

fprintf('Temperature  : %.1f °C\n',T0);
fprintf('Humidity     : %.1f %%\n',RH0);
fprintf('Soil Moisture: %.1f %%\n',M0);

fprintf('\nSimulation time: %.0f seconds\n',StopTime);

in = Simulink.SimulationInput(model);

in = in.setVariable('T_bias',T_bias);
in = in.setVariable('T_amp',T_amp);

in = in.setVariable('Solar_bias',Solar_bias);
in = in.setVariable('Solar_amp',Solar_amp);

in = in.setVariable('RH_bias',RH_bias);
in = in.setVariable('RH_amp',RH_amp);

in = in.setVariable('T0',T0);
in = in.setVariable('RH0',RH0);
in = in.setVariable('M0',M0);

in = in.setModelParameter( ...
    'StopTime',num2str(StopTime));

fprintf('\nRunning AI controller...\n');

simOut = sim(in);

fprintf('Simulation complete.\n');

logs = simOut.logsout;

Temperature = logs.get('temperature').Values;

Humidity = logs.get('humidity').Values;

SoilMoisture = logs.get('soil moisture').Values;

Fan = logs.get('fan').Values;

Heater = logs.get('heater').Values;

Pump = logs.get('pump').Values;

fprintf('\n');
fprintf('============================================================\n');
fprintf('                 SIMULATION RESULTS\n');
fprintf('============================================================\n');

fprintf('\nTemperature:\n');
fprintf('Minimum = %.2f °C\n',min(Temperature.Data));
fprintf('Maximum = %.2f °C\n',max(Temperature.Data));

fprintf('\nHumidity:\n');
fprintf('Minimum = %.2f %%\n',min(Humidity.Data));
fprintf('Maximum = %.2f %%\n',max(Humidity.Data));

fprintf('\nSoil Moisture:\n');
fprintf('Minimum = %.2f %%\n',min(SoilMoisture.Data));
fprintf('Maximum = %.2f %%\n',max(SoilMoisture.Data));

fprintf('\nActuator states:\n');

fprintf('Fan    : ');
fprintf('%g ',unique(Fan.Data));
fprintf('\n');

fprintf('Heater : ');
fprintf('%g ',unique(Heater.Data));
fprintf('\n');

fprintf('Pump   : ');
fprintf('%g ',unique(Pump.Data));
fprintf('\n');

Result.scenario = scenario;

Result.name = scenarioName;

Result.temperature = Temperature;

Result.humidity = Humidity;

Result.soil = SoilMoisture;

Result.fan = Fan;

Result.heater = Heater;

Result.pump = Pump;

fprintf('\n');
fprintf('============================================================\n');
fprintf('Scenario %d completed successfully.\n',scenario);
fprintf('%s\n',scenarioName);
fprintf('============================================================\n');