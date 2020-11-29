%% Time it takes for electric motorcycle to go 1/4 mile

%% Constants
raceDist = 0.25; % miles
raceDist = raceDist*1.60934*1000; % meters
g = 9.81;
thetag = 0; % assume perfectly flat ground

%% Chassis Specs (Honda 2005/2006 VTX1300)
dryWeight = 669; % lbs
passengerWeight = 150; % lbs
meq = dryWeight+passengerWeight; % lbs
meq = meq*0.453592; % kg
A = 29.66; % nt
C = 0.0317; % nt/(km/hr)^2
C = C*3.6*3.6; % nt/(m/s)^2
B = 0; % EPA parameters list does not include B parameter
wheelDiameter = 17; % inches
rw = 0.5*wheelDiameter*0.0254; % meters 
Ngb = 3;
ngb = 0.9;

%% EMRAX 208 SM Motor Specs
ratedSpeed = 4410/Ngb; % RPM
ratedSpeed = rw*2*pi/60*ratedSpeed; % m/s
ratedTorque = 130; % Newton meters
ratedPower = 60000; % Watts 
Jax = 2.4e-6; % kg.m^2

%%Initialize Quarter Mile Simulation
% torque = zeros();
% power = zeros();
% time = zeros();
% v = zeros();

dt = 0.001;
time(1) = 0; %Initial time (s)
v(1) = 0; %Initial speed (m/s)
distance = 0; %Initial distance travelled (m)
i = 1;



while(distance < raceDist)
    if(v(i) < ratedSpeed) %Below rated speed, constant torque mode
        v(i+1) = v(i) + (Ngb*ngb*ratedTorque - rw*(A+C*(v(i))^2))*(1/(rw*meq+Jax/rw))*dt;
         torque(i+1) = ratedTorque;
         power(i+1) = ratedTorque*v(i+1)*Ngb*(1/rw);
    else
        v(i+1) = v(i) + (ngb*(ratedPower*rw*(1/v(i))) - rw*(A+C*(v(i))^2))*(1/(rw*meq+Jax/rw))*dt;
         power(i+1) = ratedPower;
         torque(i+1) = ratedPower*rw/(v(i+1)*Ngb);
    end
    time(i+1) = time(i) + 0.001;
    distance = distance + v(i+1)*dt;
    i = i + 1;
end

%% Plot drive
figure
plot(time, v*3.6)
title("Speed vs. Time")
xlabel('Time [s]')
ylabel('Velocity [km/h]')
fprintf("The motorcycle completes the quarter-mile in %3f seconds", max(time)) %time it takes to complete the quarter mile

%% Plot Power and Torque Curves
figure
yyaxis right
plot(v*3.6,power/1000)
title("Power and Torque vs. Speed")
xlabel('Speed [km/h]')
ylabel('Power [kW]')
yyaxis left
plot(v*3.6,torque)
ylabel('Torque [N-m]')
