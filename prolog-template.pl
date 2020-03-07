%% =============================================================================
%%
%%  CONCORDIA UNIVERSITY
%%  Department of Computer Science and Software Engineering
%%  SOEN 331-..:  Assignment ..
%%  Winter term, 2020
%%  Date submitted: March 6th, 2020
%%
%%  Authors:
%%
%%  Seungwoo Kim, 40000230, s_kim@encs.concordia.ca
%%  Amine Kihal, 40046046,
%%  Patrick Leduc, 40034182, }
%%  ...
%%
%% =============================================================================

%% =============================================================================
%%
%%  Facts
%%
%% =============================================================================

%% states list (top-level)
state('Idle').
state('Parked').
state('Manual').
state('Cruise').
state('Panic').
state('Turned Off').

%% states under manual
state('Driving mode').
state('Break mode').

%% states under 'Cruise'
state('Tailing').
state('Maintaining speed').
state('Avoid obstacles').
state('Navigation').
state('Changing lane').

%% states under Maintaining speed
state('Staying mode').
state('Speed up mode').
state('Speed down mode').

%% states under Avoid obstacles
state('Idle-obstacle').
state('Normal mode').
state('Tailgating').
state('Changing lane').

%% states under Navigation
state('Idle-navigation').
state('Changing lane').
state('Driving-navigation').

%% states under Changing lane
state('Idle-lane').
state('Left mode').
state('Right mode').
state('Cruise mode').

%% initial states: init_state(composite state, initial state)
init_state('Idle', null).
init_state('Manual','Driving mode').
init_state('Cruise','Tailing').
init_state('Maintaining speed', 'Staying mode').
init_state('Avoid obstacles', 'Idle-obstacle').
init_state('Navigation', 'Idle-navigation').
init_state('Changing lane', 'Idle-changing lane').

%% superstate facts: superstate(superstate, substate)
superstate('root','Idle').
superstate('root','Parked').
superstate('root','Manual').
superstate('root','Cruise').
superstate('root','Panic').
superstate('root','Turned Off').

superstate('Idle',null).
superstate('Turned Off',null).

superstate('Manual', 'Driving mode').
superstate('Manual', 'Break mode').

superstate('Cruise', 'Tailing').
superstate('Cruise', 'Maintaining speed').
superstate('Cruise', 'Avoid obstacles').
superstate('Cruise', 'Navigation').
superstate('Cruise', 'Changing lane').

superstate('Maintaining speed', 'Staying mode').
superstate('Maintaining speed', 'Speed up mode').
superstate('Maintaining speed', 'Speed down mode').

superstate('Avoid obstacles', 'Idle-obstacle').
superstate('Avoid obstacles', 'Normal mode').
superstate('Avoid obstacles', 'Tailgating').
superstate('Avoid obstacles', 'Changing lane').

superstate('Navigation', 'Driving-navigation').
superstate('Navigation', 'Changing lane').


superstate('Changing lane', 'Idle-lane').
superstate('Changing lane', 'Left mode').
superstate('Changing lane', 'Right mode').
superstate('Changing lane', 'Panic').

%% transition fact: trans(source, destination, event, guard, action).
trans('Idle', 'Parked', 'start the car', null, 'engine to idle; engine=idle; ready to drive').
trans('Parked', 'Parked', 'use navigation system', null, 'set the destination; destination is set').
trans('Parked', 'Manual', 'issue drive signal option', 'engine is idle', null).
trans('Parked', 'Cruise', 'initiate cruise mode', 'destination is set', null).
trans('Parked', 'Parked', 'issue manual drive option', 'destination is unset', 'beep').  
trans('Manual', 'Cruise', 'switch to cruise', 'destination is set', null).
trans('Manual', 'Cruise', 'switch to cruise', 'destination is unset', 'beep').
trans('Cruise', 'Manual', 'switch back to manual', 'destination is set' , null ).
trans('Manual', 'Parked', 'put car in parked', null ,'car is stopped'). 
trans('Cruise', 'Panic', 'unforeseen event', null, 'hazard signal on' ).  
trans('Cruise', 'Parked', 'arrived to the destination', null, 'car is stopped' ). 
trans('Cruise', 'Panic', 'turn on panic mode manually', null , 'hazard signal on' ).  
trans('Panic', 'Parked', 'switch off panic mode', null , 'hazard signal off' ).
trans('Parked', 'Turned Off' , 'shut off engine', null ,'engine is not idle' ). 

trans('Break Mode', 'Driving mode', 'accelerate', null, 'increase actualSpeed; car is run').
trans('Driving Mode', 'Driving Mode', 'accelerate', null, 'increase actualSpeed').
trans('Driving Mode', 'Driving Mode', 'decelerate', null, 'decrease actualSpeed').
trans('Driving Mode', 'Break mode', 'break', null, 'actualSpeed`=0; car is stopped').

trans('Tailing', 'Maintaining speed', null, '|actualSpeed-desiredSpeed|/desiredSpeed > 0.05', null).
trans('Maintaining speed', 'Tailing', null, '|actualSpeed-desiredSpeed|/desiredSpeed <= 0.05', null).
trans('Tailing', 'Avoiding obstacles', 'detecting an obstacle', null, null).
trans('Avoiding obstacles', 'Tailing', 'obstacle not found', null, null).
trans('Tailing', 'Navigation', null, 'destination is set', null).
trans('Tailing', 'Changing lane', null, 'currentLane != targetLane', null).
trans('Changing lane', 'Tailing', null, 'currentLane = targetLane', null).

trans('Staying mode', 'Speed down mode', 'issue accelerate', '(actualSpeed-desiredSpeed)/desiredSpeed > 0.05', 'decrease actualSpeed').
trans('Staying mode', 'Speed up mode', 'issue decelerate', '(actualSpeed-desiredSpeed)/desiredSpeed < -0.05', 'increase actualSpeed').

trans('Idle-obstacle', 'Normal mode', null, 'distance - distanceLimit > 0', null).
trans('Idle-obstacle', 'Tailgating', null, 'distance - distanceLimit <= 0; obstacle is not moving', 'decrease actualSpeed').
trans('Idle-obstacle', 'Changing lane', 'changing lane signal', 'distance - distanceLimit <= 0; obstacle is moving', null).
trans('Tailgating', 'Normal mode', null, 'distance - distanceLimit > 0; obstacle is moving', null).
trans('Normal mode', 'Tailgating', null, 'distance - distanceLimit <= 0; obstacle is moving] / decrease actualSpeed', null).
trans('Normal mode','Changing lane', 'changing lane signal', 'distance - distanceLimit <= 0; obstacle is not moving',null).

trans("Driving-navigation","Idle-navigation","after(1 sec)", null, null).
trans("Idle-navigation","Driving-navigation","Turn right",null,"car to turn right").
trans("Idle-navigation","Driving-navigation","Turn left",null,"car to turn left",).
trans("Idle-navigation","Driving-navigation","normal driving signal", null,).
trans("Idle-navigation","Changing Lane","Turn right-most lane ahead", null, "targetLane' = maximumLane").
trans("Idle-navigation","Changing Lane","Turn left-most lane ahead", null, "targetLane' = 1").
trans("Idle-navigation","Changing Lane","Destination ahead", null, "targetLane' = maximumLane").
trans("Driving-navigation","Arrived at destination state","after (1 sec)", null, "arrived at destination").
trans("Changing Lane","Driving-navigation",null,"targetLane = currentLane", null).

trans('Idle-lane' , 'Idle-lane', null, 'targetLane = currentLane', null).
trans('Idle-lane' , 'Left mode', null, 'targetLane < currentLane', null). 
trans('Idle-lane' , 'Right mode', null,  'targetLane > currentLane', null). 
trans('Left mode' , 'idle-lane', 'after(1 sec)', 'leftLaneInfo is open', 'currentLane`=currentLane-1'). 
trans('Right mode' , 'idle-lane', 'after(1 sec)', 'rightLaneInfo is open', 'currentLane`=currentLane+1'). 
trans('Left mode' , 'Left mode', 'after(1 sec)', 'leftLaneInfo is close', null). 
trans('Right mod' , 'Right mode', 'after(1 sec)', 'rightLaneInfo is close', null). 
trans('Idle-lane' , 'Right mode', 'obstacle found', 'distance - distanceLimit < 0; rightLaneInfo is open', null). 
trans('Idle-lane' , 'Left mode', 'obstacle found', 'distance - distanceLimit < 0; rightLaneInfo is close; leftLaneInfo is open', null). 
trans('Idle-lane' , 'Panic', 'obstacle found', 'distance - distanceLimit < 0; leftLaneInfo is close; rightLaneInfo is close', null).

%% =============================================================================
%%
%%  Rules
%%
%% =============================================================================

%% transition rule (receiving two statese, and returns transitions between them):
%% transition(state1, state2). (return <event, guard, action>

transition(S, D, L):- findall([E,G,A],
                        trans(S, D,E,G,A),
                        L).
%% interface rule (returns all state/event pairs): interface(). (return <state, event>)

interface(S):- findall([S,E],
                        trans(S,_,E,_,_),
                        L),
                        list_to_set(L,S).


%% eof.
