%% Time it takes for electric motorcycle to go 1/4 mile

%% Constants
dist = 0.25; % miles
dist = dist*1.60934*1000; % meters
g = 9.81;
thetag = 0; % assume perfectly flat ground

%% Chassis Specs (Honda 2005/2006 VTX1300)
dryWeight = 669; % lbs
passengerWeight = 150; % lbs
meq = dryWeight+passengerWeight; % lbs
meq = meq*0.453592; % kg
A = 29.66; % nt
C = 0.0317; % nt/(km/hr)^2
C = C*0.277778*0.277778; % nt/(m/s)^2
B = 1; % EPA parameters list does not include B paramter
wheelDiameter = 17; % inches
rw = 0.5*wheelDiameter*0.0254; % meters 
Ngb = 3;
ngb = 0.9;

%% GM42BLF 40-128-H Motor Specs
ratedSpeed = 3000; % RPM
ratedSpeed = rw*2*pi/60*ratedSpeed; % m/s
ratedTorque = 8.9; % Ounce/in
ratedTorque = 3.06284781131666638; % Newton meters
ratedPower = 20000; % Watts (increased from rated 20 Watts)
Jax = 2.4e-6; % kg.m^2

%% Vehicle Acceleration
Vm = zeros(1, 400);
Vm(1) = 0;
for i = 2:1:400
    if (Vm(i) < ratedSpeed)
        Tr(i) = ratedTorque;
    else
        Tr(i) = ratedPower*rw/Vm(i);
    end
    % time vector is in seconds, time difference between calculated
    % velocities = 1 second
    Vm(i) = Vm(i-1) + (Ngb*ngb*Tr(i-1)-rw*(A+meq*g*sind(thetag)+B*(Vm(i-1))+C*(Vm(i-1)^2)))/(rw*meq + Jax/rw); % m/s
end

time = [1:1:400];
plot(time, Vm)
title('Velocity Versus Time')
ylabel('Velocity (m/s)')
xlabel('Time (seconds)')

% Integrate velocity over time to determine distance traveled
for i = 2:1:400
    distance(i) = trapz(time(1:i), Vm(1:i));
end

indexOfDistance = find(abs(dist - (distance))==min(abs(dist - (distance))));
distanceActuallyTraveled = distance(indexOfDistance); % in meters

timeToTravelDistance = time(indexOfDistance); % in seconds
