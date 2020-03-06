%% =============================================================================
%%
%%  CONCORDIA UNIVERSITY
%%  Department of Computer Science and Software Engineering
%%  SOEN 331-..:  Assignment ..
%%  Winter term, 2020
%%  Date submitted: March 3rd, 2020
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
state('Arrived at Destination').

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

%% superstate: superstate(superstate, substate)
superstate(null,'Idle').
superstate(null,'Parked').
superstate(null,'Manual').
superstate(null,'Cruise').
superstate(null,'Panic').
superstate(null,'Turned Off').

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
superstate('Avoid obstacles', 'Exit avoid obstacle mode').

superstate('Navigation', 'Idle-navigation').
superstate('Navigation', 'Changing lane').
superstate('Navigation', 'Arrived at Destination').

superstate('Changing lane', 'Idle-lane').
superstate('Changing lane', 'Left mode').
superstate('Changing lane', 'Right mode').
superstate('Changing lane', 'Cruise mode').

%% transitions: trans(source, destination, event, guard, action).
trans('Idle', 'Parked', 'start the car', null, 'engine to idle, engine=idle, ready to drive').
trans('Parked', 'Parked', 'use navigation system', null, 'set the destination; destination is set').
trans('Parked', 'Manual', 'issue drive signal option', 'engine is idle', null).
trans('Parked', 'Cruise', 'initiate cruise mode', 'destination is set', null).
trans('Parked', 'Parked', 'issue manual drive option', 'destination is unset', 'beep').  
trans('Manual', 'Cruise', 'switch to cruise', 'destination is set', null).
trans('Manual', 'Cruise', 'switch to cruise', 'destination is unset', 'beep').
trans('Cruise', 'Manual', 'switch back to manual', 'destination is set' , null ).
trans('Manual', 'Parked', 'put car in parked', null ,'car is stopped'). 
trans('Cruise', 'Panic', 'unforseen event', null, 'hazard signal on' ).  
trans('Cruise', 'Parked', 'arrived to the destination', null, 'car is stopped' ). 
trans('Cruise', 'Panic', 'turn on panic mode manually', null , 'hazard signal on' ).  
trans('Panic', 'Parked', 'switch off panic mode', null , 'hazard signal off' ).
trans('Parked', 'Turned Off' , 'shut off engine', null ,'engine is not idle' ). 

%% =============================================================================
%%
%%  Rules
%%
%% =============================================================================

%% transition rule (receiving two statese, and returns transitions between them):
%% transition(state1, state2). (return <event, guard, action>

connected(X,Y) :- superstate(X,Y) ; superstate(Y,X).

transition(S, D):- findall([E,G,A],
                        trans(S, D,E,G,A),
                        L),
    		        list_to_set(L,S).

interface(S):- findall([S,E],
                        trans(S,_,E,_,_),
                        L),
                        list_to_set(L,S).

%% interface rule (returns all state/event pairs): interface(). (return <state, event>)

%% eof.
