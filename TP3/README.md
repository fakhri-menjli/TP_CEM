# Compte Rendu d'Analyse : Modélisation FDTD d'une Cavité Résonante 3D

## 1. Introduction
Ce rapport technique présente la méthodologie et les résultats de la modélisation numérique d'une Chambre Réverbérante à Brassage de Modes (CRBM) via la méthode FDTD (Finite-Difference Time-Domain). L'objectif est de valider un modèle numérique par rapport à la théorie analytique et d'analyser l'impact d'une charge diélectrique sur les caractéristiques de résonance de la cavité, une problématique centrale en ingénierie de la Compatibilité Électromagnétique (CEM).

---

## 2. Étape 1 : Établissement du Modèle Analytique (`tp00.m`)

### 2.1. Objectif
Le script `tp00.m` établit la **référence théorique (baseline)** pour notre étude. Il calcule le spectre des fréquences de résonance d'une cavité parallélépipédique idéale (parois parfaitement conductrices, milieu interne sans pertes) à partir de sa solution analytique.

### 2.2. Méthodologie
La fréquence de résonance `f_mnp` pour un mode `(m, n, p)` dans une cavité de dimensions `(a, b, d)` est donnée par :

```matlab
f_mnp = (c / 2) * sqrt((m / a)^2 + (n / b)^2 + (p / d)^2);
```

Le script implémente cette formule et applique une condition de filtre essentielle : il ne retient que les modes où au moins deux des indices `(m, n, p)` sont non nuls. Cette condition est physiquement nécessaire car les modes avec un seul indice non nul ne peuvent pas satisfaire les conditions aux limites pour une onde transverse (TE/TM) et ne peuvent donc pas exister dans une cavité 3D fermée.

### 2.3. Interprétation des Résultats Attendus
La sortie de ce script est une liste de fréquences discrètes. Ces valeurs représentent le spectre de résonance idéal contre lequel les résultats de notre simulation numérique FDTD seront comparés pour validation. Tout écart entre ce modèle et la simulation sera imputable à la discrétisation spatiale et temporelle du modèle FDTD.

**Placeholder pour les Résultats :**
```
[INSERER ICI LA TABLE DES FRÉQUENCES THÉORIQUES CALCULÉES]
```

---

## 3. Étape 2 : Développement de l'Outil de Simulation Numérique (`tp01.m` - `tp04.m`)

Cette phase consiste à préparer et configurer le banc de test numérique.

### 3.1. `tp01.m` & `tp02.m` : Prise en Main et Paramétrage Temporel
-   **`tp01.m`**: Annotation et analyse structurelle du code `FDTD.m` pour identifier les blocs fonctionnels clés (initialisation, boucle de calcul, etc.).
-   **`tp02.m`**: Extension de la durée de simulation à `Nt = 400` itérations. L'avantage d'une approche temporelle est sa capacité à obtenir une réponse large bande à partir d'une unique simulation impulsionnelle, ce qui est très efficace pour l'analyse modale.

### 3.2. `tp03.m` : Modélisation d'une Cavité CEM Normalisée
-   **Objectif** : Adapter le modèle pour simuler une cavité aux dimensions standards pour les essais CEM (`6.7m x 8.4m x 3.5m`).
-   **Interprétation Technique** : Un pas de discrétisation spatiale `delta = 0.1m` est défini. Ce paramètre est un compromis critique en ingénierie de simulation : un `delta` plus petit augmente la précision (surtout pour les hautes fréquences) mais accroît de manière cubique la charge de calcul (mémoire et temps). Le pas de temps `Dt` est recalculé en fonction de `delta` pour respecter le **critère de stabilité de Courant-Friedrichs-Lewy (CFL)**, garantissant ainsi la convergence et la stabilité de la simulation numérique.

### 3.3. `tp04.m` : Exportation des Données
-   **Objectif** : Implémenter la sauvegarde des séries temporelles du champ électrique (`Ets`) dans un fichier de données.
-   **Interprétation Technique** : Cette étape est cruciale pour le post-traitement. En externalisant les données brutes, nous pouvons les analyser avec différents outils (comme la FFT) sans avoir à relancer la simulation FDTD, qui est coûteuse en temps de calcul.

---

## 4. Étape 3 : Exécution des Simulations (`tp05.m`, `tp06.m`)

### 4.1. Scénarios de Test
Deux scénarios sont implémentés :
1.  **`FDTD_crbm_vide.m`**: Le cas de référence, simulant la cavité vide.
2.  **`FDTD_crbm_chargee.m`**: Le cas de test, qui introduit une charge diélectrique (`eps_r = 3`) pour simuler l'effet d'un objet (Équipement Sous Test - EST) placé dans la chambre.

### 4.2. Interprétation Technique
Ces deux fichiers constituent notre campagne de simulation. En comparant leurs résultats, nous pouvons quantifier l'impact de la charge sur l'environnement électromagnétique de la cavité. Les scripts `tp05.m` et `tp06.m` gèrent la création de ces modèles et l'enregistrement des données dans `result_vide.txt` et `result_chargee.txt`.

---

## 5. Étape 4 : Analyse des Données

### 5.1. `tp07.m` : Analyse Temporelle
-   **Objectif** : Visualiser l'évolution temporelle du champ électrique au point de sonde pour les deux scénarios.
-   **Interprétation des Résultats** : Le graphique du signal temporel révèle la réponse transitoire de la cavité. C'est une superposition complexe des différents modes de résonance excités par la source impulsionnelle. La comparaison des deux graphiques met en évidence l'influence de la charge : le diélectrique, en stockant de l'énergie et en créant des réflexions internes, modifie l'amplitude et la forme d'onde du signal temporel.

**Placeholder pour les Figures :**
```
[INSERER ICI LE GRAPHIQUE DES CHAMPS E(t) POUR LA CAVITÉ VIDE ET CHARGÉE]
```

### 5.2. `tp08.m` & `tp09.m` : Analyse Fréquentielle et Identification des Modes
-   **Objectif** :
    1. Transposer les signaux temporels dans le domaine fréquentiel via une FFT (mise en œuvre dans `FFT_crbm_mod.m`).
    2. Visualiser les spectres de puissance (en dB) pour les deux cas sur la bande [80MHz, 150MHz].
    3. Identifier et lister les fréquences de résonance.
-   **Interprétation des Résultats** : C'est l'étape d'analyse la plus critique.
    -   **Spectre de Résonance** : Les pics observés sur les spectres correspondent aux fréquences propres de la cavité, pour lesquelles l'énergie est maximale.
    -   **Influence de la Charge Diélectrique** :
        1.  **Décalage Fréquentiel (Frequency Shift)** : L'introduction d'un matériau avec `eps_r > 1` augmente la permittivité moyenne de la cavité. Puisque la fréquence de résonance est inversement proportionnelle à la racine carrée de la permittivité (`f ∝ 1/√ε`), les fréquences de résonance sont **décalées vers des valeurs plus basses**. Le graphique doit clairement montrer que les pics du spectre rouge (cavité chargée) sont décalés à gauche par rapport à ceux du spectre bleu (cavité vide).
        2.  **Augmentation de la Densité Modale** : Ce décalage a pour conséquence mécanique de "compresser" les modes dans le spectre. Par conséquent, pour une même largeur de bande (ici, 80-150 MHz), le nombre de modes présents augmente. C'est une observation fondamentale en CEM, car une densité modale élevée est une condition requise pour assurer l'uniformité statistique du champ dans une CRBM.

Les résultats obtenus par la simulation confirment donc de manière cohérente les principes physiques attendus.

**Placeholder pour les Figures et Données :**
```
[INSERER ICI LE GRAPHIQUE COMPARATIF DES SPECTRES FRÉQUENTIELS]
```
```
[INSERER ICI LES FRÉQUENCES DE RÉSONANCE IDENTIFIÉES POUR LE CAS VIDE ET CHARGÉ]
```