% tp06.m
% 
% Description : 
% Ce script exécute les simulations pour la cavité vide et chargée
% afin de générer les fichiers de résultats.

clear all;
close all;
clc;

fprintf('Lancement de la simulation pour la cavité vide...\n');
tp04();

fprintf('\nLancement de la simulation pour la cavité chargée...\n');
tp05();