# Vivado_Scripts
Final_Project_Capgemini_Paunchici_Andrei

This is my final project made for the end of Capgemini internship : UVM testing enviroment made from 0 for a aithmetic unit named AFVIP. (Software used for testing : Vivado)
This project includes :



rtl - This is the DUT(device under test). This module implements an arithmetic unit configurable and controllable through APB interface. Supports only Addition and Multiplication operations.

tb - The UVM testbench ( agents, interfaces, items, scoreboard, sequencers ...)

VivadoCompile - This script is used to build/simulate a verification enviroment using Vivado TCL console
PrjFileBuilder - This module is used by VivadoCompile.py to build a dependecy tree based on the file includes
regr.py - This imports VivadoCompile

