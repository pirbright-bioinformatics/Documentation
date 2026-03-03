---
layout: default      
title: Migrate to Mamba 
parent: Guides 
nav_order: 4          
---
# ** Migration from Conda to Mamba or Micromamba**

---

## 1. Purpose

This is a guide for migrating from Conda to either:

* Mamba
* Micromamba

on the Institute HPC cluster.

---

## 2. Background (Why Migration Might be Needed on HPC)

Conda can become slow and resource-intensive on HPC systems when the base environment accumulates hundreds of packages. It can also happen when
users repeatedly install/remove packages in the same environment or multiple channels are mixed. These situations might lead conda to resolve large numbers of dependancies.

Mamba and Micromamba can be helpful for faster installations. If you are having issues with conda due to the solver taking a long time (maybe even hours), or think your conda management has got out of control, you might want to migrate. Mamba and Micromamba uses a fast solver written in C++, and is much faster than conda's python solver. While mamba is to be used in conjuction with conda, Micromamba is cleaner and does not require a heavy base environment. 

---


## 4 General  Best Practices for Conda
The following good practices will ensure that your conda environment will not go out of control.
*  Do not install project software into the Conda base environment
*  Use one environment per project
*  Use strict channel priority setting in conda (See [Part B, Step 2](#step-2--configure-channels))
*  Use mamba for package installations 

In the following sections we give you guidance on how to migrate to Mamba or Micromamba. *Part A* is for those users who still want to use conda, but want to make it more efficient. *Part B* is for those who find their conda environment bloated to a point of being unmanageable, or for those who wish to have a cleaner package management system. 
---

# PART A — Minimal Disruption Upgrade (Conda → Mamba)


## 5. Procedure: Install Mamba

### Step 1 — Update Conda
Depending on how old your conda installation is, you may wish to start by updating your conda installation.
```bash
conda update -n base conda
```

### Step 2 — Install Mamba
You can install Mamba directly from the conda environment.

```bash
conda install -n base -c conda-forge mamba
```

### Step 3 — Replace Commands
You can generally replace familiar conda commands with mamba by just replacing `mamba` with `conda`.
For example, Use:

```bash
mamba install package_name
mamba create -n myenv python=3.11
```

Instead of:

```bash
conda install package_name
conda create -n myenv python=3.11
```

---

## 6. Notes for Mamba usage

* Do not alternate between conda and mamba in the same environment.
* Do not install packages in to base unless you have a very good reason
* You can generally install packages with mamba into environments created with conda, and this was a suggested way for older mamba versions as conda create was considered more stable. However, it is better to stick to one manager for all the processes as mamba has improved a lot since it's early days. 

---

# PART B — Recommended HPC Standard (Micromamba)

---

## 7. Advantages for Local Installs in the HPC
Micromamba is a standalone binary with no base environment and no dependency on a central Conda installation. It provides fast dependency resolution using a high-performance solver while maintaining a minimal filesystem footprint.

---

## 8. Installation Procedure 

### Step 1 — Install Micromamba 

Go to your home directory and type

```bash
curl -L micro.mamba.pm/install.sh | bash
```

Restart the shell. You can verify the installation by running:


```bash
micromamba --version
```

---

### Step 2 — Configure Channels 
You can setup your common channels and set a strict priority of selecting them to avoid problems mentioned in Section 4.

```bash
micromamba config append channels conda-forge
micromamba config append channels bioconda
micromamba config set channel_priority strict
```

Channel order in this case will be:

1. conda-forge
2. bioconda

Strict priority prevents dependency conflicts.

---

## 9. Creating Bioinformatics Environments
You can follow your usual conda commands, replacing `conda` with `micromamba`.
For example:

```bash
micromamba create -n rnaseq_env \
  python=3.11 \
  fastqc \
  multiqc \
  samtools \
  bcftools
```
will create the environment `rna_seq`, which you can then activate with:

```bash
micromamba activate rnaseq_env
```

---

## 10. Migrating Existing Environments

You can export existing Conda environment as follows:
```bash
conda env export -n old_env > old_env.yml
```
Now, recreate the same environment with Micromamba using the `old_env.yml` file,

```bash
micromamba create -n old_env -f old_env.yml
```
Be sure to validate the new environment before deleting old environment.

---

# 11. Comparison Summary

| Feature                              | Conda   | Mamba    | Micromamba |
| ------------------------------------ | ------- | -------- | ---------- |
| Solver speed                         | Slow    | Fast     | Very Fast  |
| Base environment dependency          | Yes     | Yes      | No         |
| Standalone binary                    | No      | No       | Yes        |

---

# 12. Risk Management

| Risk                | Mitigation                   |
| ------------------- | ---------------------------- |
| Broken environments | Export YAML before migration |
| Channel conflicts   | Use strict priority          |
| Mixed tool usage    | Use one tool per environment |

---

# 13. Summary 

* New users can start using Micromamba instead of conda
* Existing Conda users can either install Mamba or migrate gradually to Micromamba
* Do not install large packages into base
* Use one environment per project
* Use strict channel priority

Migration is strongly recommended when:

* Base environment exceeds several hundred packages
* Solver performance degrades

Micromamba provides the most stable, scalable solution for conda packages.
