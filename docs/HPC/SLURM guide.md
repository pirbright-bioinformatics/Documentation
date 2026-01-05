---
layout: default      
title: SLURM Guide    
parent: HPC 
nav_order: 2          
---
# README.md – Getting Started with SLURM (Beginner-Friendly)

This is a guide to using **SLURM (Simple Linux Utility for Resource Management)** on an HPC (High Performance Computing) cluster. No prior HPC experience is assumed.

---

## 1. What is SLURM?

SLURM is a system that:

- Manages **shared computing resources** (CPUs, memory, nodes)
- Places jobs from many users into a **queue**
- Decides **when and where** each job runs

You **do not run heavy programs directly** on the cluster login node. Instead, you submit jobs to SLURM and let it run them for you. If you can provide good estimates of the resources your program needs, SLURM will run your jobs by allocating the cluster resources in the most efficient way.

---

## 2. Basic HPC Workflow

1. Log in to the cluster
2. Prepare your code or script
3. Write a SLURM job script
4. Submit the job using `sbatch`
5. Monitor progress
6. View results in output files

There are ways to run commands or scripts directly on the cluster as well.

---

## 3. What Is a Job?

A **job** is a request that tells SLURM:

- What program to run
- How long it may run
- How many CPUs and how much memory it needs

Jobs wait in a **queue** until the requested resources are available.

---

## 4. Your First SLURM Job

### 4.1 Example Job Script (Minimal)

Create a file called `job.slurm`:

```bash
#!/bin/bash
#SBATCH --job-name=example
#SBATCH --output=slurm-%j.out
#SBATCH --time=00:10:00
#SBATCH --ntasks=1
#SBATCH --mem=1G

# Print hostname and date
echo "Running on $(hostname)"
date
```

### 4.2 Submit the Job

```bash
sbatch job.slurm
```

SLURM will respond with a **job ID**, for example:

```
Submitted batch job 123456
```

---
## 5. Understanding the SLURM Parameters in the Example Script

Below is the example SLURM script used earlier, followed by a detailed explanation of each parameter.

```bash
#!/bin/bash
#SBATCH --job-name=example
#SBATCH --output=slurm-%j.out
#SBATCH --time=00:10:00
#SBATCH --cpus-per-task=1
#SBATCH --mem=1G

# Print hostname and date
echo "Running on $(hostname)"
date
```

- `#!/bin/bash`

This line tells the system to run the script using the **Bash shell**. Almost all SLURM scripts start with this line.

- `#SBATCH --job-name=example`

This will set a **human-readable name** for your job that appears in the  `squeue` output. Use short, meaningful names (e.g. `FMDV_assembly`, `BWA_Alignment`).

 - `#SBATCH --output=slurm-%j.out`

Specifies where the job output is written to. `%j` is automatically replaced with the **job ID**. This file contains both normal output and error messages.

 - `#SBATCH --time=00:10:00`

Maximum **wall-clock time** the job is allowed to run in `HH:MM:SS` format.
If the job exceeds this limit, SLURM will **terminate it automatically**.

 - `#SBATCH ----cpus-per-task=1`

Number of processors/threads to allocate for the program to run. If your program uses more than one thread, set this parameter.

 - `#SBATCH --mem=1G`

Total memory requested for the job, Units can be `M` (MB) or `G` (GB).
If your program exceeds this amount, it may fail with an **out-of-memory error**.

All lines **after** the `#SBATCH` directives are regular shell commands.

In this example:

```bash
echo "Running on $(hostname)"
date
```

They simply print the node name and current time, which is useful for testing.

## 5.1 Alternate Way to Run This Script

You can prepare your script to run separately and save it as say `example.sh`.
```bash
#!/bin/bash
  
# Print hostname and date
echo "Running on $(hostname)"
date
```
Then, you can run it using the following command.

```bash
sbatch \
  --job-name=hello \
  --time=00:05:00 \
  --cpus-per-task=1 \
  --mem=1G \
  example.sh
```

This can be shortened to a one-liner as:
```
sbatch  -J hello  -t 00:05:00 -c 1 --mem=1G example.sh
```
where the correspondence between the longer parameters and shortened ones are obvious.  
---


## 6. Monitoring Jobs

### 6.1 View Your Jobs

```bash
squeue -u your_username
```

Job states you may see:

- `PENDING` – waiting for resources
- `RUNNING` – currently running
- `COMPLETED` – finished successfully
- `FAILED` – error occurred

### 6.2 Check Cluster Status

```bash
sinfo
```

This shows which nodes are idle, busy, or unavailable.

---

## 7. Job Output Files

SLURM writes program output to a file named:

```
slurm-<job_id>.out
```

This file contains:

- Output from `print`, `echo`, etc.
- Error messages if something went wrong

Always check this file first if your job fails.

---

## 8. Cancelling Jobs

Cancel a single job:

```bash
scancel <job_id>
```

Cancel all your jobs:

```bash
scancel -u your_username
```

---

## 9. Common SLURM Errors and How to Fix Them

### 9.1 Job Stuck in PENDING State

**Possible reasons:**

- Requested too many resources
- Requested time too long
- Cluster is busy

**What to do:**

- Reduce `--time`, `--mem`, or CPU requests
- Check `squeue -j <job_id>` for the reason

---

### 9.2 "sbatch: command not found"

**Reason:**

You might not loaded the slurm module, possibly due to changed startup file or a change of environment.

**Fix:**

- type `module load slurm` 

---

### 9.3 Job Fails Immediately

**Possible reasons:**

- Script has syntax errors
- Missing modules or software

**What to do:**

- Check `slurm-<job_id>.out`
- Run commands manually on the login node (small tests only)

---

### 9.4 "Out of Memory" (OOM) Error

**Reason:**

Your program used more memory than requested.

**Fix:**

- Increase memory request:

```bash
#SBATCH --mem=4G
```

---

### 9.4 Your Script Runs on the Login Node, Not in the Cluster 

**Reason:**

The script runs some software only available in the login node.

**Fix:**

- If a module provides the tool, load it before submitting to the queue.
- Install the software to your home/bin directory
- Add the full path to the software in your script 

---


## 10. Best Practices for Beginners

- Start with **short test jobs**
- Request **minimal resources** first
- Always check output files
- Avoid running heavy jobs on login nodes
- Keep job scripts simple and well-commented

---

## 11. Useful Commands Summary

| Command | Description |
|-------|-------------|
| `sbatch` | Submit a job |
| `squeue` | Check job status |
| `sinfo` | Check cluster status |
| `scancel` | Cancel jobs |

---

## 12. Getting Help

If something goes wrong:

1. Check the output file
2. Verify resource requests are reasonable
3. Note the **job ID**


