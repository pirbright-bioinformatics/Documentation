---
layout: default      
title: Passing Environments
parent: Guides 
nav_order: 2          
---
# Reproducibility of Environments

To enable reproducible research, you need to do more than creating environments. You must **freeze**, **document**, and sometimes **package** them so they can be rebuilt exactly. The following are guides on how to freeze and share your environments.

---

## Conda

In conda either the complete environment or just the modifications made to the environment can be saved.
```bash
# Full export (all packages and versions)
conda env export > environment.yml

# Cleaner (only explicitly installed)
conda env export --from-history > environment.yml
```
Now you can pass the *environment.yml* file to duplicate the environment in another machine. The reciever of the file can run the command
```bash
conda env create -f environment.yml
```
to replicate the environment.

---

## Python (pip / venv)

For a pip environment, we can get a list of packages installed with
```bash
pip freeze > requirements.txt
```
Now, you can pass the *requirements.txt* file and replicate the environment with the commands
```bash
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
```
Above commands will re-create the frozen environment in to a virtual environment named *venv*. 

#### Advanced Tools
If you want to have cleaner, minimal files to reproduce your environment you can use *pip-tools*. However, the most modern way to create, package and install environment is using *poetry*. These will not be covered in this guide.

---

## R (renv)
In *renv* you can run the command
```R
renv::snapshot()   # creates renv.lock
```
to create a snapshot of the current environment. The snapshot will be saved to the file *renv.lock*. This file can be saved on a new location, and
```R
renv::restore()    
```
will re-create the original environment.

---

## Additional Best Practices

1. **Pin interpreter versions** (Python 3.10, R 4.3, etc.).  
2. **Commit lock files** (`environment.yml`, `requirements.txt`, `renv.lock`) into version control.  
3. **Record computational context**:  
   - R: `sessionInfo()`  
   - Python: `python --version && pip list`  
   - Conda: `conda info`  
4. Write a `README.md` with clear rebuild instructions.  
