A Python version of this code is available at https://github.com/dubajicmilos/LocalOctaTilt-Python.

# LocalOctaTilt
MATLAB code for the phenomenological model in the publication "Dynamic nanodomains dictate macroscopic properties in lead halide perovskites". The code was written in MATLAB R2018b, so some functions may not be compatible with newer releases. Some of the calculations run on the GPU, and some CUDA libraries may be incompatible with newer GPUs; in that case, the calculations may be slower.

Use `Simulation_QEDS.m` to simulate the S(q) that arises from local I4/mcm or P4/mbm nanodomains in cubic perovskite structures.
Running the file as provided computes S(q) with the parameters determined from the experimental data and reproduces the S(q) shown in Fig. 1 of the paper. The simulation needs structure factor .txt files; these are in the `Structure_Factor_Files` folder and were generated with SingleCrystal (https://crystalmaker.com/singlecrystal/). Diffuse scattering for other nanodomain symmetries can, in principle, be simulated by generating the corresponding structure factor files in SingleCrystal.

The main functions that the code needs are in the `functions` folder.


`just_plot_MD.m` loads S(q,E) from molecular dynamics (MD) simulations and reproduces the MD data in Fig. 1.

`plot_A_cation_orientations.m` reproduces the A-cation orientations shown in Fig. 1.

<img width="698" height="676" alt="image" src="https://github.com/user-attachments/assets/99827a9b-ced9-49cd-a425-47b0e671a453" />
