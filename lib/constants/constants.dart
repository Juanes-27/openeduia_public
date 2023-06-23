library globals;

import 'package:flutter/material.dart';

int sumTwoDimensionalList(List<List<int>> list, int column, int row) {
  int sum = 0;

  for (int i = 0; i < column; i++) {
    for (int j = 0; j <= list[i].length - 1; j++) {
      sum += list[i][j];
    }
  }
  for (int y = 0; y <= row && y <= list[column].length; y++) {
    sum += list[column][y];
  }
  return sum;
}

List<List<String>> videosURLs = [[]];
List<int> worldIndexSubsections = [2, 5, 4, 1, 1, 1, 4];
List<String> worldsNames = [
  "Introducción a la Inteligencia Artificial",
  "Lógica Proposicional y de Primer Orden",
  "Búsqueda y Planificación",
  "Aprendizaje Automático (Machine Learning)",
  "Procesamiento del Lenguaje Natural",
  "Visión Computacional",
  "Python Enfocado en IA"
];
List<List<int>> valuesPointsSubsectionsperWorld = [
  [100, 100],
  [200, 200, 200, 200, 200],
  [300, 300, 300, 300, 300],
  [400],
  [500],
  [600]
];
int totalpointsSubsections = 4200;
List<List<String>> subsectionsName = [
  ["Introducción", "Agentes Inteligentes"],
  [
    "Introducción a la Lógica Proposicional",
    "Inferencia en la Lógica Proposicional",
    "Representación del Conocimiento en la Lógica de Primer Orden",
    "Razonamiento en lógica de primer orden",
    "Lógica de Descripción"
  ],
  [
    "Introducción a la búsqueda en Inteligencia Artificial",
    "Búsqueda informada(heurística) y búsqueda no informada (ciega).",
    "Algoritmos de búsqueda",
    "Introducción a la Planificación",
  ],
  ["Introducción al Aprendizaje Automático"],
  [
    "Introducción al Procesamiento del Lenguaje Natural",
  ],
  [
    "Introducción a la Visión Computacional",
  ],
  [
    "Fundamentos de Python",
    "Control de Flujo",
    "Funciones",
    "Listas",
  ]
];
int numberWorlds = 7;
List<int> worldsLearningGoals = [4, 5, 3, 2, 2, 1, 4];
List<String> subsectionsIcons = [
  'subsection_01.png',
  'subsection_02.png',
  'subsection_03.png',
  'subsection_04.png',
  'subsection_05.png',
  'subsection_06.png',
  'subsection_07.png',
  'subsection_08.png',
  'subsection_09.png',
  'subsection_10.png',
  'subsection_11.png',
  'subsection_12.png'
];
int numbershowComments = 5;
Color pinkColor = Colors.purpleAccent.shade100;

List<int> numberChallengesWorlds = [1, 1];
int totalChallenges = 2;
List<int> numberRewardsByChallengeWorlds = [
  3,
  4,
];
int rewardsTotalPoints = 7;
List<String> namesChallenges = ["Pacman Retro", "Juego Memoria"];
List<String> numbersChallengesIndex = [
  '1.png',
  '2.png',
  '3.png',
  '4.png',
  '5.png',
  '6.png',
  '7.png',
  '8.png',
  '9.png'
];
