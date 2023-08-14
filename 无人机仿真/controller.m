function [F, M] = controller(t, state, des_state, params)
%CONTROLLER  Controller for the quadrotor
%
%   state: The current state of the robot with the following fields:
%   state.pos = [x; y; z], state.vel = [x_dot; y_dot; z_dot],
%   state.rot = [phi; theta; psi], state.omega = [p; q; r]
%
%   des_state: The desired states are:
%   des_state.pos = [x; y; z], des_state.vel = [x_dot; y_dot; z_dot],
%   des_state.acc = [x_ddot; y_ddot; z_ddot], des_state.yaw,
%   des_state.yawdot
%
%   params: robot parameters

%   Using these current and desired states, you have to compute the desired
%   controls


% =================== Your code goes here ===================

% Thrust
kp = [300;300;300];
ki = [0;0;0];
kd = [15;15;15];

kp_val = kp.*(des_state.pos-state.pos);
ki_val = [0;0;0];
kd_val = kd.*(des_state.vel-state.vel);

rdes_ddot = des_state.acc + kp_val + ki_val + kd_val;
F = params.mass * (params.gravity + rdes_ddot(3));

% Moment
M = zeros(3,1);
kp_ang = [100;100;100];
ki_ang = [0;0;0];
kd_ang = [2;2;2];
phi_des = ( rdes_ddot(1)*sin(des_state.yaw) - rdes_ddot(2)*cos(des_state.yaw))/params.gravity;
theta_des = (rdes_ddot(1)*cos(des_state.yaw) + rdes_ddot(2)*sin(des_state.yaw))/params.gravity;
rot_des=[phi_des;theta_des;des_state.yaw];
omega_des=[0;0;des_state.yawdot];

M = kp_ang.*(rot_des - state.rot) + ki_ang + kd_ang.*(omega_des - state.omega);

if F>params.maxF
    F=params.maxF;
end
% =================== Your code ends here ===================

end
