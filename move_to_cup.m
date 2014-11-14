cup_number=1%taken as input - the cup number we are filling

time=getseconds()-%time at start
time=time+7 % time for robot to move and wait for cup
cupsattime=predictPositions(cupsordered, omega, time, x_centerMetric,y_centerMetric)
arm_pos=cupsattime(cup_number).x_y;
arm_alpha=cupsattime(cup_number).Theta_R(1);


%%%robot
%go to position
%%%

time=getseconds()-%time at start
cupsattime=predictPositions(cupsordered, omega, time, x_centerMetric,y_centerMetric)
current_alpha=cupsattime(cup_number).Theta_R(1);


tol=%angle tolerance to decide it is close enough to drop
while (arm_alpha-current_alpha)<tol
    time=getseconds()-%time at start
    cupsattime=predictPositions(cupsordered, omega, time, x_centerMetric,y_centerMetric)
    current_alpha=cupsattime(cup_number).Theta_R(1);
end

%%%robot
%drop sachet
%%%




