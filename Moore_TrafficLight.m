%% Model a Traffic Light by Using Moore Semantics
% This example shows how to use Moore semantics to model a traffic light.

% Copyright 2008-2019 The MathWorks, Inc.

%% 

% Set up charts with white background
set_param(0,'ExportBackgroundColorMode','white');

model = 'sf_moore_traffic_light';
open_system(model);
open_system([model '/Light_Controller'])

%% Logic of the Moore Traffic Light
% In this example, the traffic light model contains a Moore chart called
% Light_Controller, which operates in five traffic states. Each state
% represents the color of the traffic light in two opposite directions,
% North-South and East-West, and the duration of the current color. The
% name of each state represents the operation of the light viewed from the
% North-South direction.

%%
% This chart uses temporal logic to regulate state transitions. The |after|
% operator implements a countdown timer, which initializes when the source
% state is entered. By default, the timer provides a longer green light in
% the East-West direction than in the North-South direction because the
% volume of traffic is greater on the East-West road. The green light in
% the East-West direction stays on for at least 20 clock ticks, but it can
% remain green as long as no traffic arrives in the North-South direction.
% A sensor detects whether cars are waiting at the red light in the
% North-South direction. If so, the light turns green in the North-South
% direction to keep traffic moving.

%%
% The Light_Controller chart behaves like a Moore machine because it
% updates its outputs based on current state before transitioning to a new
% state:

%%
% *When initial state |Stop| is active.*  Traffic light is red for
% North-South, green for East-West.
%
% * Sets output |y1 = RED| (North-South) based on current state.
% * Sets output |y2 = GREEN| (East-West) based on current state.
% * After 20 clock ticks, active state becomes |StopForTraffic|.

%%
% *In active state |StopForTraffic|.*  Traffic light has been red for
% North-South, green for East-West for at least 20 clock ticks.
% 
% * Sets output |y1 = RED| (North-South) based on current state.
% * Sets output |y2 = GREEN| (East-West) based on current state.
% * Checks sensor.
% * If sensor indicates cars are waiting (|[sens]| is true) in the
% North-South direction, active state becomes |StopToGo|.
%
%%
% *In active state |StopToGo|.*  Traffic light must reverse traffic flow in
% response to sensor.
% 
% * Sets output |y1 = RED| (North-South) based on current state.
% * Sets output |y2 = YELLOW| (East-West) based on current state.
% * After 3 clock ticks, active state becomes |Go|.
%
%%
% *In active state |Go|.*  Traffic light has been red for North-South,
% yellow for East-West for 3 clock ticks.
% 
% * Sets output |y1 = GREEN| (North-South) based on current state.
% * Sets output |y2 = RED| (East-West) based on current state.
% * After 10 clock ticks, active state becomes |GoToStop|.
%
%%
% *In active state |GoToStop|.*  Traffic light has been green for
% North-South, red for East-West for 10 clock ticks.
% 
% * Sets output |y1 = YELLOW| (North-South) based on current state.
% * Sets output |y2 = RED| (East-West) based on current state.
% * After 3 clock ticks, active state becomes |Stop|.
%
%% Design Rules in Moore Traffic Light
% This example of a Moore traffic light illustrates these Moore design
% rules:
% 
% * The chart computes outputs in state actions.
% * The chart tests inputs in conditions on transitions.
% * The chart uses temporal logic, but no asynchronous events.
% * The chart defines chart inputs (|sens|) and outputs (|y1| and |y2|).
