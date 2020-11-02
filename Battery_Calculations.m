%% Battery calculations
% Number of cells in series/parallel
Torque_pk = 140; % N*m, based on electric motor rating
Power_pk = 68; % kW @ 6000 RPM, based on electric motor rating
Vcell_nom = 3.6; % V, from battery datasheet
Vbat_max = 600; % V, DC bus
Icell_max = 20; % Amps, from battery datasheet

Ncells_series = round(Vbat_max/Vcell_nom); % Number of battery cells in series
P_cell = Vcell_nom*Icell_max; % Peak power produced per cell
P_string = Ncells_series*P_cell; % Peak power produced per string
Ncells_parallel = round(Power_pk*1000/P_string); % Number of series strings in parallel
Ncells_total = Ncells_series*Ncells_parallel;

% Mass of battery cells 
mass_per_cell = 0.047; % kg
mass_battery = mass_per_cell*Ncells_total;

% Volume/space needed for battery cells
cell_dia = 18.6*0.0393701; % mm to inches, from battery datasheet
cell_rad = cell_dia/2;
cell_height = 65.2*0.0393701; % mm to inches, from battery datasheet
cell_volume = pi*cell_rad^2*cell_height;
battery_volume = cell_volume * Ncells_total;

chassis_height = 15.43+4.25; % inches
chassis_length_top = 28.15+18.74; % inches
chassis_length_bottom = 14.21; % inches
chassis_width = 6.87; % inches
chassis_volume = chassis_height*(chassis_length_top+chassis_length_bottom)/2*chassis_width; % inches^3
volume_for_battery = 0.85*chassis_volume; % inches^3