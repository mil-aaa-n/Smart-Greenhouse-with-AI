clc;
clearvars;

greenhouse_parameters;

load('greenhouse_AI_models_v4.mat');

disp(' ');
disp('======================================');
disp(' Smart Greenhouse Project Loaded');
disp('======================================');

whos fanModel heaterModel pumpModel
whos mu_fan sigma_fan mu_heater sigma_heater mu_pump sigma_pump

model = 'greenhouse_final';

if ~bdIsLoaded(model)
    load_system(model);
end

open_system(model);

scenarioScript = 'run_all_scenarios.m';

if isfile(scenarioScript)
    edit(scenarioScript);
else
    warning('run_all_scenarios.m was not found in the current folder.');
end

disp(' ');
disp('======================================');
disp(' Simulink model and scenario script');
disp(' are ready.');
disp('======================================');