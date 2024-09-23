# Peak-Persistence Diagrams (PPD)

This repository contains MATLAB code accompanying the paper:

[Peak-Persistence Diagrams for Estimating Shapes and Functions from Noisy Data](https://arxiv.org/abs/2305.04826)

The code provides a simple illustration of the Peak-Persistence Diagrams (PPD) method for estimating unknown shapes and functions from noisy data using MATLAB. It includes:

- Function Files: Located in the `/functions` folder.
- Computational Examples: Explored in the `main.m` script.
- 3 Examples: Basic signal estimations using PPD on synthetic noisy data.

Abstract:

Addressing the fundamental challenge of signal estimation from noisy data is a crucial aspect of signal processing and data analysis. Existing literature offers various estimators based on distinct observation models and criteria for estimation. This paper introduces an innovative framework that leverages topological and geometric features of the data for signal estimation. The proposed approach introduces a topological tool -- *peak-persistence diagram* (PPD) -- to analyze prominent peaks within potential solutions. Initially, the PPD estimates the unknown shape, incorporating details such as the number of internal peaks and valleys. Subsequently, a shape-constrained optimization strategy is employed to estimate the signal. This approach strikes a balance between two prior approaches: signal averaging without alignment and signal averaging with complete elastic alignment. Importantly, the proposed method provides an estimator within a statistical model where the signal is affected by both additive and warping noise. A computationally efficient procedure for implementing this solution is presented, and its effectiveness is demonstrated through simulations and real-world examples, including applications to COVID rate curves and household electricity consumption curves. The results showcase superior performance of the proposed approach compared to several current state-of-the-art techniques.

