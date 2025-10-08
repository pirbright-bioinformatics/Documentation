---
layout: default      
title: Introduction to Environments
parent: Guides 
nav_order: 2          
---
# Introduction to Environments: Creating and Using Environments

The cluster is designed with the philosophy that each user is responsible for their own work environment. Accordingly, we maintain only a minimal set of software and libraries to enable common tasks. Users are advised not to rely on these shared tools or expect them to remain static or be regularly updated. Regular updates can break existing pipelines due to deprecation or changes in functionality. Conversely, if vulnerabilities or licensing issues arise, we may need to update, downgrade, or remove software. The key takeaway is that users should build their own software environments when conducting any serious analysis.

This guide explains how to create environments for the most commonly used languages on the server—Python and R. It also demonstrates how to create Conda environments for projects that require multiple languages or diverse software tools.
Instructions on how to save and share your environment are given in the guide [Advanced Reproducibility](02_advanced_reproducibility.md).

# Workflow for Reproducible Research using Environments
## Why is Reproducibility Important?
Bioinformatics research depends on complex computational pipelines — often involving dozens of tools, R and Python packages, and system dependencies. Results that seem stable today can become irreproducible tomorrow if a package updates, an interpreter changes version, or a dependency disappears.  
Reproducibility is not just good practice — it’s critical for:  
- **Scientific integrity** – your peers (and your future self) must be able to repeat analyses.  
- **Collaboration** – collaborators can reproduce results without hours of setup.  
- **Longevity** – research outputs remain usable even years later, regardless of software changes.  

## How Can Environments Help ?
Isolated environments (Conda, `renv`, `venv`, Docker) provide a **snapshot of your computational world**:  
- They **lock down interpreter versions** (e.g., R 4.3, Python 3.10).  
- They **freeze library versions** so the same code produces the same results.  
- They are **shareable** through files (`environment.yml`, `renv.lock`, `requirements.txt`) so colleagues and reviewers can rebuild your setup.  
- They **separate projects** so tools and dependencies don’t clash across analyses.  

The workflow for creating environments and sharing them can be as follows:
- **Create**  
  Start a new environment with a clean interpreter.  

- **Activate**  
  Enter the environment so all package operations apply only inside it.  

- **Install**  
  Add the packages needed for your project.  

- **Freeze**  
  Capture the exact state of the environment for reproducibility.  

- **Rebuild**  
  Recreate the environment on another machine (or later in time).  

- **Share**  
  Commit the lock/spec files to version control and distribute with your project so others can reproduce your setup. 

We will describe the steps of creating and activating an environment, and installing software and packages into them in this guide.

---

## Conda

### Create and Activate Environment
The basic way to create a conda environment named *myenv* and to activate it is: 
```bash
conda create -n myenv 
conda activate myenv
```
If you want to have a specific version of Python or R you can try the following. 
```bash
conda create -n myenv python=3.10 r-base=4.3
```
When you activate the conda environment, the prompt will show the environment name. 

### Install Packages
Now software and packages can be installed using conda install, whenever they are available in a conda repository. To install the program *samtools* and the Python package *numpy* you can run 
```bash
conda install samtools numpy 
```
You can also use native R and Python methods (i.e. *install.packages* and *pip*) to install libraries.

### Deactivate
After your work is done, you can come out of the environment with the command
```bash
conda deactivate
```

---

## Python (venv)

### Create Environment
To create a Python environment using the built-in `venv` module (recommended for Python 3.5+), first make a project directory and navigate into it. Then run:
```bash
python3 -m venv my_venv
```
This command creates a new environment called *my_venv* in a directory named *my_venv* within your project folder. All environment files will be stored there. The convention is to use the name *venv* for virtual environments, so for the instructions that follow, we will assume an environment has been created with the command
```bash
python3 -m venv venv
```


### Activate / Deactivate
To activate the environment use the following command:
```bash
source venv/bin/activate
```
This will show you a prompt with your environment's name. To deactivate the environment use:
```bash
deactivate
```


### Install Packages
Packages can be installed with pip, or Python's pip module in one of the following ways.
```bash
pip install numpy pandas
python -m pip install numpy pandas
```

---

## R (renv)
Creating R environments is done within R itself using the `renv` package. First, install `renv`:
```R
install.packages("renv")
```
Next, start R in your project directory and initialize the environment:
```R
renv::init()
```
This will set up an isolated R environment for your project in the current directory.

### Activate / Deactivate
There is no need to explicitly activate and deactivate R projects. When you launch R from your project directory, the environment will automaticall be loaded. This happens via the changes made to the *.Rprofile* file by the *renv::init()* command. When you exit R, the environment will no longer be in effect.
### Install Packages
You can install packages using the normal R mechanism *install.packages*. For example,
```R
install.packages("dplyr")
```
will install the package *dplyr*

---

## Tips 
1. Always **activate the environment** before installing packages (except for R which automatically does this).  
2. Keep one environment **per project**.  
3. Delete and recreate environments if they break — they are disposable.  
