---
layout: default      
title: Cluster Resources and Allocation Guide    
parent: HPC 
nav_order: 2          
---
# Cluster Resources and Allocation 

This document describes the **hardware layout of the cluster** and provides **practical guidance** on requesting SLURM resources **for single-task jobs**.

---

## 1. Cluster Overview

The cluster consists of **9 compute nodes**:

```
compute001, compute002, ..., compute009
```

All compute nodes have identical hardware.

---

## 2. Hardware per Node

Each node contains:

- **2** CPUs per node
- **64** physical cores per CPU
- **2** hardware threads per core 
- **2 TB** of memory


```
+--------------------------------------------------+
|                  Compute Node                    |
+--------------------------------------------------+
|                  2 TB Memory                     |
+--------------------------------------------------+
|  CPU 0                     CPU 1                 |
|  ---------                 ---------             |
|  64 cores                  64 cores              |
|  (128 threads)             (128 threads)         |
|                                                  |
|  Total per node:                                 |
|    - 128 physical cores                          |
|    - 256 hardware threads (SLURM CPUs)           |
+--------------------------------------------------+
```
While threads and CPU's are different concepts, SLURM will in practice treat everything as CPU's. Therefore, When you request CPUs using SLURM, you are requesting **threads from this pool**.


---

## 3. What You Should Request 

Since you are running **single-task programs**, you only need:

- `--cpus-per-task`
- `--mem`
- `--time`

SLURM automatically assumes **one task**. If your case requires more than one task, look up the **--ntasks** option.

---

## 4. How `--cpus-per-task` Maps to Hardware

Examples:

```bash
#SBATCH --cpus-per-task=1
```
→ 1 hardware thread

```bash
#SBATCH --cpus-per-task=8
```
→ 8 hardware threads (≈ 4 physical cores)

```bash
#SBATCH --cpus-per-task=256
```
→ Entire node

---

## 5. How Much Should I Request? (Decision Table)

Use this table as a **rule of thumb**.

| What are you running? | `--cpus-per-task` | Typical memory | Notes |
|----------------------|------------------|---------------|------|
| Quick test / debug | 1 | 1–2 GB | Fastest queue time |
| Simple Python / R script | 1 | 2–4 GB | Default starting point |
| Multithreaded | 4–8 | 8–16 GB | Set thread variables |
| Heavy CPU computation | 16–64 | 32–128 GB | Test scaling first |
| Full-node job | 256 | All node memory | Longest wait time |


Note that while some programs are multithreaded, they might not scale well as you add more threads. For example, BLAST might not perform twice as fast if you increase the number of processors from 5 to 10, whereas BWA aligner will scale very well as you add more threads. Best way is to do a small experiment to see how each of your multithreaded tools will scale before assigning a very large thread count.

---

## 6. Memory Requests

Memory is requested **per job**, not per CPU.

Example:

```bash
#SBATCH --cpus-per-task=16
#SBATCH --mem=64G
```

This allows your single program to:

- Use up to 16 CPU threads
- Use up to 64 GB RAM

If your program exceeds memory, it may be killed with an **OOM (Out Of Memory)** error.

---

## 7. Queue Wait Time vs Resource Size (Very Important)

The more resources you request, the **longer your job may wait** in the queue,
 since SLURM must find **free resources at the same time on the same node**.

Examples:

- **1 CPU job** → can run almost anywhere → starts quickly
- **8 CPU job** → needs a small block → moderate wait
- **256 CPU job** → needs an *entire node* → may wait a long time

### Rule of Thumb

> Request the **smallest amount of resources** that lets your job finish in reasonable time.

Over-requesting:

-  Increases queue wait time
-  Reduces cluster fairness
-  Does *not* guarantee faster results

---

## 8. Bad vs Good Request Examples

This section shows **common mistakes** and how to fix them.

---

### 8.1 Small Script (Single-threaded)

** Bad request**

```bash
#SBATCH --cpus-per-task=64
#SBATCH --mem=128G
```

Problems:
- Requests half a node
- Long queue wait
- No speed-up for single-threaded code

** Good request**

```bash
#SBATCH --cpus-per-task=1
#SBATCH --mem=2G
```

---

### 8.2 Multithreaded 

** (possibly) Bad request**

```bash
#SBATCH --cpus-per-task=256
#SBATCH --mem=16G
```

Problems:
- Blocks entire node
- Memory might be too low for many threads
- Wastes resources if the program cannot scale well with processors

** Good request**

```bash
#SBATCH --cpus-per-task=8
#SBATCH --mem=16G

```

---

### 8.3 Memory-Heavy Job

** Bad request**

```bash
#SBATCH --cpus-per-task=4
#SBATCH --mem=4G
```

Problem:
- Likely to fail with OOM error

** Good request**

```bash
#SBATCH --cpus-per-task=4
#SBATCH --mem=32G
```

---

## 9. Memory-per-Core Heuristic 

If you are unsure of the nature of your program,

> **Request 1 GB of memory per CPU thread**

and request a maximum of  **10 GB**. 

Increase memory if:
- You see **OOM (Out Of Memory)** errors
- Your program loads large datasets
- You use in-memory caching

Decrease memory if:
- Your job finishes successfully
- Memory usage stays low in monitoring tools

---

## 10. Recommended Scaling Strategy

1. Start with **1 CPU** and **2–4 GB RAM**
2. Measure runtime and memory usage
3. Increase CPUs gradually (4 → 8 → 16)
4. Increase memory using the heuristic above
5. Stop scaling when speed-up no longer improves


## 11. Summary

If you allocate resources sufficient for your task to run, and specify the estimated time for a job to finish, you have a higher chance of getting through the queue. Considerate resource allocation will help both you and other users, and over-allocation of resources will increase everyone's wait time.

---

