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
state(idle).
state(parked).
state(manual).
state(cruise).
state(panic).

%% states under manual
state('Driving mode').
state('Break mode').

%% states under cruise
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
state('Idle obstacle').
state('Normal mode').
state('Avoid mode').
state('Changing lane').
state('Exit avoid obstacle mode').

%% states under Navigation
state('Idle navigation').
state('Changing lane').
state('Arrived at Destination').

%% states under Changing lane
state('Idle changing lane').
state('Left mode').
state('Right mode').
state('Cruise mode').
state('Panic mode').

%% initial states: init_state(composite state, initial state)
init_state(idle, null).
init_state(manual,'Driving mode').
init_state(cruise,'Tailing').
init_state('Maintaining speed', 'Staying mode').
init_state('Avoid obstacles', 'Idle obstacle').
init_state('Navigation', 'Idle navigation').
init_state('Changing lane', 'Idle changing lane').

%% superstate: superstate(superstate, substate)
superstate(idle,null)

superstate(manual, 'Driving mode').
superstate(manual, 'Break mode').

superstate(cruise, 'Tailing').
superstate(cruise, 'Maintaining speed').
superstate(cruise, 'Avoid obstacles').
superstate(cruise, 'Navigation').
superstate(cruise, 'Changing lane').

superstate('Maintaining speed', 'Staying mode').
superstate('Maintaining speed', 'Speed up mode').
superstate('Maintaining speed', 'Speed down mode').

superstate('Avoid obstacles', 'Idle obstacle').
superstate('Avoid obstacles', 'Normal mode').
superstate('Avoid obstacles', 'Avoid mode').
superstate('Avoid obstacles', 'Changing lane').
superstate('Avoid obstacles', 'Exit avoid obstacle mode').

superstate('Navigation', 'Idle navigation').
superstate('Navigation', 'Changing lane').
superstate('Navigation', 'Arrived at Destination').

superstate('Changing lane', 'Idle changing lane').
superstate('Changing lane', 'Left mode').
superstate('Changing lane', 'Right mode').
superstate('Changing lane', 'Cruise mode').
superstate('Changing lane', 'Panic mode').

%% transitions: transition(source, destination, event, guard, action).



%% =============================================================================
%%
%%  Rules
%%
%% =============================================================================

%% transition rule (receiving two statese, and returns transitions between them):
%% transition(state1, state2) -> (return <event, guard, action>

connected(X,Y) :- superstate(X,Y) ; superstate(Y,X).

transition(X,Y) :- connected(X,Y).

transition(X,Y,Path) :-
       travel(X,Y,[X],Q), 
       reverse(Q,Path).

travel(X,Y,P,[Y|P]) :- 
       connected(X,Y).

travel(X,Y,Visited,Path) :-
       connected(X,Z),           
       Z \== Y,
       \+member(Z,Visited),
       travel(Z,Y,[Z|Visited],Path).



%% interface rule (returns all state/event pairs): interface() -> (return <state, event>)

%% eof.