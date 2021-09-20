%
%   TWISTR_main.m
%   Calvin Boyle - 2021
%   Carnegie Mellon University
%
%   Run this script to begin the TWISTR control program. TWISTR and arduino
%   must be fully connected for program to start.
%
%   This program requies the installation of the "MATLAB® Support Package
%   for Arduino® Hardware"
%

clear *;
close all;

%load HEBI dependencies
startup();

%start control
TWISTR_application();