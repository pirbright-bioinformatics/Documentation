# Guide: Freezing, Exporting, and Sharing Environments

This guide explains how to turn your working environment into a reproducible package for sharing or archiving.

---

## Conda

### Export to YAML
```bash
conda env export --from-history > environment.yml
```

### Rebuild Environment
```bash
conda env create -f environment.yml
```

---

## Python

### Export to requirements.txt
```bash
pip freeze > requirements.txt
```

### Rebuild Environment
```bash
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
```

---

## R

### Snapshot to renv.lock
```R
renv::snapshot()
```

### Restore Environment
```R
renv::restore()
```

---

## Example Files

### `environment.yml` (Conda)
```yaml
name: myenv
channels:
  - defaults
dependencies:
  - python=3.10
  - numpy=1.24.2
  - pandas=1.5.3
  - pip
  - pip:
      - requests==2.31.0
```

### `requirements.txt` (Python)
```text
numpy==1.24.2
pandas==1.5.3
requests==2.31.0
```

### `renv.lock` (R, excerpt)
```json
{
  "R": {
    "Version": "4.3.1",
    "Repositories": [
      { "Name": "CRAN", "URL": "https://cran.rstudio.com" }
    ]
  },
  "Packages": {
    "dplyr": {
      "Package": "dplyr",
      "Version": "1.1.2",
      "Source": "Repository",
      "Repository": "CRAN"
    }
  }
}
```

---

## Packaging Checklist
- [ ] Export lockfile (`environment.yml`, `requirements.txt`, `renv.lock`)  
- [ ] Commit lockfile to Git  
- [ ] Record interpreter version (Python 3.10, R 4.3, etc.)  
- [ ] Add rebuild instructions in `README.md`  
- [ ] (Optional) Package inside a Dockerfile for containerized reproducibility  
