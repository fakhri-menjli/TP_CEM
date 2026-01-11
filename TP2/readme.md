# Compte Rendu de Travaux Pratiques: Simulation FDTD pour la CEM

## Objectif

Ce rapport synthétise une série de simulations numériques basées sur la méthode FDTD (Finite-Difference Time-Domain) en une dimension. L'objectif est de modéliser et d'analyser des phénomènes électromagnétiques fondamentaux, cruciaux dans le domaine de la Compatibilité Électromagnétique (CEM). Les simulations couvrent la propagation d'onde, l'impact des conditions aux limites, l'interaction onde-matière (diélectrique) et les phénomènes de résonance.

## 1. Principes de la simulation FDTD 1D

### `scriptFDTD01.m`

Ce script implémente l'algorithme de Yee pour résoudre les équations de Maxwell en 1D. Une source d'excitation impulsionnelle (gaussienne), de type "hard source", est introduite au centre d'un domaine de calcul terminé par des conditions aux limites de type Conducteur Électrique Parfait (CEP).


<img width="687" height="491" alt="image" src="https://github.com/user-attachments/assets/edde9dfc-15ad-454b-be67-979a41649914" />
<img width="677" height="496" alt="image" src="https://github.com/user-attachments/assets/a4217092-760e-4c2b-b871-694cba6f695a" />


**Figure 1: Propagation et réflexion sur des CEP**


**Interprétation:** La figure illustre la propagation d'une impulsion et sa réflexion totale sur les bords du domaine. La réflexion s'accompagne d'une inversion de phase du champ électrique, caractéristique d'une condition de réflexion sur un conducteur parfait (coefficient de réflexion R = -1). Ce scénario est analogue à la réflexion d'une onde sur une surface métallique, un cas d'école en CEM pour l'analyse du blindage.

### `scriptFDTD02.m`

Cette simulation explore l'utilisation d'une "soft source" (source additive), qui s'ajoute au champ électrique existant.
<img width="678" height="489" alt="image" src="https://github.com/user-attachments/assets/c6122f62-be81-44bd-901b-30b46b59fe50" />
<img width="677" height="483" alt="image" src="https://github.com/user-attachments/assets/1091f6b4-6542-4af6-9b66-779cec24c651" />


**Figure 2: Simulation avec une "soft source"**


**Interprétation:** Contrairement à la "hard source" qui impose une valeur de champ, la "soft source" injecte de l'énergie de manière plus douce, ce qui est physiquement plus réaliste pour modéliser des sources de courant ou de tension. Le comportement en propagation et en réflexion reste identique, mais cette technique de source est fondamentale pour des simulations plus complexes où plusieurs sources peuvent interagir.

## 2. Types de Sources d'Excitation

### `scriptFDTD3.m`

Ce script utilise une "source spatiale" qui définit l'état initial du champ électrique sur l'ensemble du domaine.


<img width="700" height="489" alt="image" src="https://github.com/user-attachments/assets/f7febdef-18f2-49f7-b3bf-dc0716ce6c3f" />
<img width="668" height="487" alt="image" src="https://github.com/user-attachments/assets/e46f0f30-f134-4c63-8c97-d7e523ef5804" />

<img width="688" height="494" alt="image" src="https://github.com/user-attachments/assets/4dcd19d8-bd45-41cf-9461-cab46ad79781" />
<img width="681" height="490" alt="image" src="https://github.com/user-attachments/assets/bbd5bdb4-dab2-4b81-bc31-7dcce4ccd2e4" />
**Figure 3: Simulation avec une source spatiale**



**Interprétation:** Il s'agit d'un problème à valeur initiale. La distribution de champ initiale se décompose en deux ondes contre-propagatives. Cette méthode est moins courante pour simuler des sources localisées mais peut être utile pour analyser la réponse d'un système à une distribution de champ préexistante (par exemple, un champ électrostatique).

## 3. Conditions aux Limites Absorbantes (ABC)

### `scriptFDTD4.m`

Ce script met en œuvre des conditions aux limites absorbantes (Absorbing Boundary Conditions - ABC) basées sur la technique du "magic time step".

<img width="698" height="491" alt="image" src="https://github.com/user-attachments/assets/8cf26656-9e61-4755-8342-f0f00a812cf6" />
<img width="666" height="489" alt="image" src="https://github.com/user-attachments/assets/93d93ae8-be9e-467f-b9d3-c34ae2d168b1" />

**Figure 4: Simulation en espace libre avec des ABC**


**Interprétation:** Les ABC sont essentielles pour simuler des problèmes en "espace libre", comme le rayonnement d'une antenne ou le couplage entre deux circuits. La figure doit montrer que l'onde se propage et quitte le domaine de simulation sans réflexion parasite sur les bords. L'efficacité des ABC est un critère de qualité majeur pour une simulation CEM.

## 4. Interaction Onde-Matière

### `scriptFDTD05.m` et `scriptFDTD06.m`

Ces simulations introduisent un matériau diélectrique dans le domaine, créant une interface entre deux milieux d'impédances différentes.
<img width="683" height="490" alt="image" src="https://github.com/user-attachments/assets/507f11a0-8c2a-4ee5-bf05-09f22a633dbf" />
<img width="692" height="487" alt="image" src="https://github.com/user-attachments/assets/67e25cbf-22b1-418b-9850-89013adba5a1" />
<img width="684" height="484" alt="image" src="https://github.com/user-attachments/assets/ad276afa-e664-46d4-8461-9d1edf63d4f2" />




**Figure 5: Propagation à travers un diélectrique**


**Interprétation:** L'introduction du diélectrique crée une rupture d'impédance. On doit observer une onde réfléchie à l'interface et une onde transmise. Au sein du diélectrique, la vitesse de propagation de l'onde diminue et sa longueur d'onde est réduite. Ce phénomène est fondamental pour comprendre l'effet des matériaux (boîtiers plastiques, PCB, etc.) sur la propagation des signaux.

### `coff_ref.m`

Ce script calcule les coefficients de réflexion (R) et de transmission (T) théoriques à l'interface d'un diélectrique.

**Interprétation:** La confrontation des valeurs de R et T théoriques avec les amplitudes des ondes simulées constitue une étape de validation essentielle. Elle garantit que la simulation représente correctement la physique du problème, une démarche indispensable dans tout processus de conception et de validation par la simulation.

## 5. Phénomènes de Résonance

### `scriptFDTD07.m`

Cette simulation modélise une cavité résonnante 1D excitée par une source sinusoïdale.
<img width="670" height="488" alt="image" src="https://github.com/user-attachments/assets/c0aade19-8b34-4ba7-9a6c-bd83148fd62f" />
<img width="670" height="490" alt="image" src="https://github.com/user-attachments/assets/52570b91-f558-4afc-85c2-edf3cfaaccad" />



**Figure 6: Résonance dans une cavité 1D**


**Interprétation:** La figure doit mettre en évidence la formation d'ondes stationnaires dans la cavité. Lorsque la fréquence d'excitation coïncide avec une fréquence de résonance de la cavité (déterminée par ses dimensions), l'amplitude du champ électrique peut atteindre des niveaux très élevés. C'est un phénomène redouté en CEM, car une structure, même non intentionnellement, peut se comporter comme une cavité et amplifier des champs à des niveaux qui peuvent perturber le fonctionnement de systèmes électroniques.

## Conclusion Générale

Cette série de simulations FDTD a permis de mettre en évidence des concepts électromagnétiques fondamentaux qui sont au cœur des problématiques de Compatibilité Électromagnétique. La maîtrise de la propagation des ondes, de leur réflexion sur des obstacles ou des interfaces, de leur interaction avec les matériaux et des phénomènes de résonance est indispensable pour l'ingénieur CEM.

La simulation numérique, lorsqu'elle est menée avec rigueur (validation, conditions aux limites appropriées, etc.), se révèle un outil puissant pour prédire, analyser et résoudre des problèmes de CEM, que ce soit pour la conception de blindages, le routage de cartes électroniques, ou l'analyse de couplages parasites. Ces simulations simples en 1D, bien que non représentatives de la complexité des problèmes réels en 3D, constituent une base solide et indispensable pour la compréhension de ces phénomènes.
