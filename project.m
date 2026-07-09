clear;
clc;
close all;

System.Ts = 0.001;

% BASE PARAMETERS
Base.m = 100;
Base.cm = [0, 0.220, 0.0];
Base.rgb = [0.2, 0.2, 0.2];


% PILLAR PARAMETERS
Pillar.cs = [0.00, 0.00; 0.10, 0.00; 0.29,0.04; 0.29,0.24; 0.10,0.34; -0.07, 1.38;-0.27,1.38; -0.27,1.18; -0.10,0.00];
Pillar.l = 0.2; 
Pillar.m = 110;
Pillar.cm = [-0.07, 0.56, 0.00];
Pillar.rgb = [0.2, 0.2, 0.2];

% LIFT PARAMETERS
Lift.cs = [0.10, -0.10 ; 0.20, 0.00 ; 0.30, -0.10; 0.50, -0.10; 0.60, 0.00; 3.69, 0.18; 3.69, 0.38; 2.23, 0.38; 2.13, 0.65; 1.93, 0.65; 1.83, 0.38; 0.20,0.40; -0.10, 0.10; -0.10, -0.10];
Lift.l =  0.2;
Lift.m = 370;
Lift.cm = [1.40, 0.25, 0];
Lift.rgb = [0.2, 0.2, 0.2];
Lift.j = [-0.18, 1.274, 0];

% tilt parameters
Tilt.cs = [0, 0; 0.5, 0; 0.5, -0.2; 0.7, -0.2; 0.7, 0; 1.45, 0; 1.45, 0.12; 0.2, 0.12; 0.2, 0.22; 0.05, 0.22; 0.05, 0.12; 0, 0.12]*2;
Tilt.l = 0.2;
Tilt.m = 170;
Tilt.cm = [0.5, 0.45, 0.00];
Lift.rgb = [0.2, 0.2, 0.2];

%fourbar 1
Fourbar_1.m = 15;
Fourbar_1.cm = [0.215, 0 , 0];

%fourbar 2
Fourbar_2.m = 15;
Fourbar_2.cm = [0.226, 0 , 0];


% Piston parameters
Piston.r = 0.035;
Piston.l = 0.92;
Piston.m = 25;
Piston.cm = [0, 0, 0];
Piston.rgb = [0.8, 0.8, 0.8];
Piston.pos = [0.19, 0.14, 0];

% Piston 3 parameters 
Piston_3.r = 0.035;
Piston_3.l = 1.068;
Piston_3.m = 25;
Piston_3.cm = [0, 0, 0];
Piston_3.rgb = [0.8, 0.8, 0.8];

% Piston 4 parameters
Piston_4.r = 0.03;
Piston_4.l = 2.640;
Piston_4.m = 25;
Piston_4.cm = [0, 0, 0];
Piston_4.rgb = [0.8, 0.8, 0.8];

%extension 1
Extension_1.m =  90;
Extension_1.cm = [-1.215, 0 , 0 ];
Extension_1.cs = [0, 0 ; Piston_4.l + 0.2, 0 ; Piston_4.l + 0.2, 0.30 ; 2.70, 0.30 ; 2.70, 0.12 ; 0, 0.12];
Extension_1.l = 1.870;

%extension 2
Extension_2.m =  90;
Extension_2.cm = [-1.215, 0 , 0 ];
Extension_2.cs = [0, 0 ; 0.2, 0; 0.2, 0.11; 0, 0.11];
Extension_2.l = 0.9;

% Cylinder_2 parameters - min lenght 920
Cylinder.r = 0.06;
Cylinder.l = 0.92; 
Cylinder.m = 72;
Cylinder.cm = [0, 0, 0];
Cylinder.rgb = [0.2, 0.2, 0.2];
Cylinder.pos = [-0.4, 0.016, 0];


%cylinder_3 parameters - min lenght 1068
Cylinder_3.r = 0.06;
Cylinder_3.l = 1.068; 
Cylinder_3.m = 65;
Cylinder_3.cm = [0, 0, 0];
Cylinder_3.rgb = [0.2, 0.2, 0.2];

%cylinder_4 parameters - min lenght 2640
Cylinder_4.r = 0.04;
Cylinder_4.l = 2.640; 
Cylinder_4.m = 50;
Cylinder_4.cm = [0, 0, 0];
Cylinder_4.rgb = [0.2, 0.2, 0.2];



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % hydraulic part 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%% 2 nd cylinder %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Offset = 0.92;
Cylinder.x0 = 0.2; % Initial position of the piston [m] 
Valve.QN = 40/60000; % Nominal volume flow [m^3/s] 
Valve.dpN =3.5e6; % Nominal pressure difference [Pa]
Valve.ptr = Valve.dpN * 0.005; % Transition pressure from laminar to turbulent flow [Pa]
System.pS = 21.5e6; % Supply pressure [Pa]
System.pT = 0; % Tank pressure [Pa]


Cylinder.D = 0.120; % Piston diameter [m]
Cylinder.d = 0.070; % Piston rod diameter [m]
Cylinder.stroke = 0.610; % Cylinder stroke length [m]

Cylinder.A_A = pi*(Cylinder.D/2)^2 ; % Piston area at A-side [m^2]
Cylinder.A_B =  Cylinder.A_A - pi*(Cylinder.d/2)^2 ;% Piston area at B-side [m^2]
Cylinder.V0_A = 0.02*Cylinder.A_A; % Dead volume at A-side [m^3]
Cylinder.V0_B = 0.02*Cylinder.A_B; % Dead volume at B-side [m^3]
Cylinder.p0_A = 9.45e6; % Initial pressure at A-side [Pa]
Cylinder.p0_B = 5.55e6; % Initial pressure at B-side [Pa]
Cylinder.B = 900e6; % Effective bulk modulus [Pa]
Cylinder.Fs = 0.1*(System.pS*Cylinder.A_A); % Static friction force [N]
Cylinder.b = Cylinder.Fs; % Viscous friction coefficient [Ns/m]



%maximum force of the cylinder (hydraulic part)
p_max = System.pS * Cylinder.A_A;
%maximum allowed displacement
delta_x = 0.01; 
%spring constant
K_end = p_max / delta_x;
% damping term
b_end = 0.5*(K_end * (Lift.m + Tilt.m + Cylinder_3.m + Extension_2.m + Extension_1.m + Cylinder_4.m))^0.5;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%% 3 rd cylinder %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Offset_3 = 1.068;
Cylinder_3.x0 = 0.2; % Initial position of the piston [m]
Valve_3.QN = 50/60000; % Nominal volume flow [m^3/s] 
Valve_3.dpN =3.5e6; % Nominal pressure difference [Pa]
Valve_3.ptr = Valve_3.dpN * 0.005; % Transition pressure from laminar to turbulent flow [Pa]
System_3.pS = 21.5e6; % Supply pressure [Pa]
System_3.pT = 0; % Tank pressure [Pa]


Cylinder_3.D = 0.115; % Piston diameter [m]
Cylinder_3.d = 0.060; % Piston rod diameter [m]
Cylinder_3.stroke = 0.725; % Cylinder stroke length [m]

Cylinder_3.A_A = pi*(Cylinder_3.D/2)^2 ; % Piston area at A-side [m^2]
Cylinder_3.A_B =  Cylinder_3.A_A - pi*(Cylinder_3.d/2)^2 ;% Piston area at B-side [m^2]
Cylinder_3.V0_A = 0.02*Cylinder_3.A_A; % Dead volume at A-side [m^3]
Cylinder_3.V0_B = 0.02*Cylinder_3.A_B; % Dead volume at B-side [m^3]
Cylinder_3.p0_A = 5.95e6; % Initial pressure at A-side [Pa]
Cylinder_3.p0_B = 9.6e6; % Initial pressure at B-side [Pa]
Cylinder_3.B = 900e6; % Effective bulk modulus [Pa]
Cylinder_3.Fs = 0.1*(System.pS*Cylinder_3.A_A); % Static friction force [N]
Cylinder_3.b = Cylinder_3.Fs; % Viscous friction coefficient [Ns/m]



%maximum force of the cylinder (hydraulic part)
p_max_3 = System.pS * Cylinder_3.A_A;
%maximum allowed displacement
delta_x_3 = 0.005;  %0.01-0.005
%spring constant
K_end_3 = p_max_3 / delta_x_3;
% damping term
b_end_3 = 0.5*(K_end_3 * (Tilt.m + Extension_2.m + Extension_1.m + Cylinder_4.m))^0.5;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%% 4 th cylinder %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Offset_4 = 2.640;
Cylinder_4.x0 = 0.2; % Initial position of the piston [m]
Valve_4.QN = 80/60000; % Nominal volume flow [m^3/s] 
Valve_4.dpN =3.5e6; % Nominal pressure difference [Pa]
Valve_4.ptr = Valve_4.dpN * 0.005; % Transition pressure from laminar to turbulent flow [Pa]
System_4.pT = 0; % Tank pressure [Pa]
System_4.pS = 21.5e6;


Cylinder_4.D = 0.07; % Piston diameter [m]
Cylinder_4.d = 0.045; % Piston rod diameter [m]
Cylinder_4.stroke = 1.850; % Cylinder stroke length [m]

Cylinder_4.A_A = pi*(Cylinder_4.D/2)^2 ; % Piston area at A-side [m^2]
Cylinder_4.A_B =  Cylinder_4.A_A - pi*(Cylinder_4.d/2)^2 ;% Piston area at B-side [m^2]
Cylinder_4.V0_A = 0.02*Cylinder_4.A_A; % Dead volume at A-side [m^3]
Cylinder_4.V0_B = 0.02*Cylinder_4.A_B; % Dead volume at B-side [m^3]
Cylinder_4.p0_A = 2.9e5; % Initial pressure at A-side [Pa]
Cylinder_4.p0_B = 1.1e6; % Initial pressure at B-side [Pa]
Cylinder_4.B = 900e6; % Effective bulk modulus [Pa]
Cylinder_4.Fs = 0.1*(System.pS*Cylinder_4.A_A); % Static friction force [N]
Cylinder_4.b = Cylinder_4.Fs; % Viscous friction coefficient [Ns/m]


%maximum force of the cylinder (hydraulic part)
p_max_4 = System.pS * Cylinder_4.A_A;
%maximum allowed displacement
delta_x_4 = 0.01; 
%spring constant
K_end_4 = p_max_4 / delta_x_4;
% damping term
b_end_4 = 0.5*(K_end_4 * (Extension_2.m + Extension_1.m))^0.5; %%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%% BASE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % pinion parameters
Pinion.radius = 0.1; % Pinion radius
Pinion.thickness = 0.525; % Pinion thickness
Pinion.mass = 5;
Pinion.rgb = [0.8, 0.4, 0];


%%%%%%%%%% hydraulic part of the base %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Cylinder_1.r = 0.025;
Cylinder_1.l = 0.72; 
Cylinder_1.m = 100;
Cylinder_1.rgb = [0.2, 0.2, 0.2];


Valve_1.QN = 30/60000; % Nominal volume flow [m^3/s] 
Valve_1.dpN =3.5e6; % Nominal pressure difference [Pa]
Valve_1.ptr = Valve_1.dpN * 0.005; % Transition pressure from laminar to turbulent flow [Pa]
System_1.pS = 21.5e6; % Supply pressure [Pa]
System_1.pT = 0; % Tank pressure [Pa]


Cylinder_1.D = 0.115; % Piston diameter [m]
Cylinder_1.d = 0.045; % Piston rod diameter [m]
Cylinder_1.stroke = 0.720; % Cylinder stroke length [m]

Cylinder_1.A_A = pi*(Cylinder_1.D/2)^2*2 ; % Piston area at A-side [m^2]
Cylinder_1.A_B =  Cylinder_1.A_A ;% Piston area at B-side [m^2
Cylinder_1.V0_A = 0.02*Cylinder_1.A_A; % Dead volume at A-side [m^3]
Cylinder_1.V0_B = 0.02*Cylinder_1.A_B; % Dead volume at B-side [m^3]
Cylinder_1.p0_A = 9.2e5; % Initial pressure at A-side [Pa]
Cylinder_1.p0_B = 1.08e6; % Initial pressure at B-side [Pa]
Cylinder_1.B = 900e6; % Effective bulk modulus [Pa]
Cylinder_1.Fs = 0.1*(System.pS*Cylinder_1.A_A); % Static friction force [N]
Cylinder_1.b = Cylinder_1.Fs; % Viscous friction coefficient [Ns/m]

Offset_1 = 0.72;
%maximum force of the cylinder (hydraulic part)
p_max_1 = System.pS * Cylinder_1.A_A;
%maximum allowed displacement
delta_x_1 = 1e-2; 
%spring constant
K_end_1 = p_max_1 / delta_x_1;
% damping term
b_end_1 = 0.5*(K_end_1 * (Lift.m + Pillar.m + Cylinder.m + Tilt.m + Cylinder_4.m + Cylinder_3.m + Extension_1.m + Extension_2.m))^0.5; 
%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% simulink model

% out = sim("simulinkProject.slx");
% t = out.valve_values.time; % Time vector (assuming valve_values and positions have the same time vector)
% valves_values = out.valve_values.signals.values; % Valve values
% positions = out.positions.signals.values; % Positions
% 
% % Plot the data
% figure;
% plot(t, valves_values, '--', 'LineWidth', 2);
% hold on;
% plot(t, positions, '-', 'LineWidth', 2);
% xlabel('Time');
% ylabel('Values');
% legend('Valve 2', 'Valve 3', 'Valve 4', 'Position 2', 'Position 3', 'Position 4');
% title('Valve Values and Positions over Time');
% grid on;