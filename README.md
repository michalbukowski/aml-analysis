# aml-analysis
A collection of Jupyter notebooks for basic analysis of the data from the "BeatAML" study by Tyner et al. (2018)

Tyner JW, Tognon CE, Bottomly D, Wilmot B, Kurtz SE, Savage SL, Long N, Schultz AR, Traer E, Abel M, Agarwal A. Functional genomic landscape of acute myeloid leukaemia. Nature. 2018 Oct 25;562(7728):526-31.

### Contents
1. [Description of notebooks](#1)<br>
2. [Environment setup](#2)<br>
&nbsp;&nbsp;&nbsp;&nbsp;2.1. [Manual environment setup](#2.1)<br>
&nbsp;&nbsp;&nbsp;&nbsp;2.2. [Building and using a Docker image](#2.2)<br>

### <a name="1">1. Description of notebooks</a>
The collection contains 4 Jupyter notebooks, two written in R and two in Python. The purpose of each Jupyter notebook is described in the table below. The table provides a shor summary. The logic of designed analyses is described in details in the notebooks.

| No. | File name | Language | Purpose |
| - | - | - | - |
| 1. | `function_r.ipynb` | R | An implementation of a function that for Ensembl IDs (genes/transcripts/proteins/exons) returns gene names according to HUGO Gene Nomenclature Committee (HGNC names). The function is not utilised in this workflow, however it may be of use when reporting DGE results obtained in the notebook No. 2. |
| 2. | `function_py.ipynb` | Python | A Python version of the function implemented in 1. For comprison and testing purposes. |
| 3. | `dge.ipynb` | R | Differential gene expression (DGE) analysis for data from the "BeatAML" study. The analysis is undertaken for samples divided into two groups, that is samples from patients with or without NPM1 gene mutation. The analysis utilises DESeq2 library. |
| 4. | `analysis.ipnb` | Python | A simple and based on GO annotations functional analysis of genes differently expressed among samples analysed in the notebook No. 2. |

### <a name="2">2. Environment setup</a>
The notebooks were tested on linux-64 platform (Ubuntu 22.04) using Miniconda (conda 23.5.0), and utilise the following packages:
- python 3.11.4
- pandas 2.0.3
- jupyterlab 3.3.2
- r-irkernel 1.3.2
- r-base 4.2.3
- r-r.utils 2.12.2
- r-data.table 1.14.8
- bioconductor-deseq2 1.38.0
- bioconductor-apeglm 1.20.0
- cairo 1.16.0
- libxml2 2.11.4

On the top of those, _libtiff5_ and _libxt6_ must be installed in the operating system. Both libraries should be present in a standard Ubuntu installation

### <a name="2.1">2.1. Manual environment setup</a>
To recreate the conda environment use `conda/aml-env.yml` file:
```Bash
conda env create --name aml-env --file conda/aml-env.yml
```
To install _libtiff5_ and _libxt6_ in Ubuntu, run the following command:
```Bash
sudo apt install libtiff5 libxt6
```
Nevertheless, both libraries should be present in a standard Ubuntu installation. If you do not use Ubuntu, use a package installer typical for your OS.

Having the above done, activate the environment and run Jupyter Lab application from the main workflow directory:

```Bash
conda activate aml-env
jupyter lab
```

Jupyter Lab launched in this way will automatically open an internet browser window with the application interface. If that does not happen, use the link displayed by Jupyter (see the end of the next section). If you experience problems with recreating the environment, you may want to see the next section and learn how to prepare and use a Docker image with full environment setup.

### <a name="2.2">2.2. Building and using a Docker image</a>
To create a Docker image based on Ubuntu 22.04 with Miniconda installation, run the following command in the main directory of this workflow where the `Dockerfile` is present. In this step you will create an image based on `continuumio/miniconda3` from the Docker library, create a conda environment in it by using _conda/aml-env.yml_ file, and install necessary _libtiff5_ and _libxt6_ libraries. A user `amluser` (`uid=1000`) and a group `amlgroup` (`gid=1000`) are created by default. You may want to change `uid` and `gid` to those of your user by `--build-arg` argument:

```Bash
docker build -t --build-arg uid=$(id -u) --build-arg gid=$(id -g) aml-app ./
```

Then create and run a container using the following command whilst still being in the main workflow directory:

```Bash
docker run --rm -it -p 8888:8888 -v ./:/app aml-app
```

In case you wish to run the container as root, simply add the argument `--user 0:0` to the command:

```Bash
docker run --user 0:0 --rm -it -p 8888:8888 -v ./:/app aml-app
```

It will run a container in the interactive mode (`-it`). The container will be instantenously removed once it is no longer used (`-rm`). The 8888 port inside the container will be mapped to 8888 port in your system (`-p 8888:8888`). You may choose another port for your system, e.g. 8889 or higher by changig the first number. The port 8888 will be used inside the container by Jypyter Lab server. Finally the current location (the main workflow directory) will be mapped to `/app` location inside the container. That will let you run the notebooks present in the main directory from inside the container.

The container will automatically run Jupyter Lab application on port 8888. You need to simply copy the address returned by Jupyter that, except the token value, will look like this:

```Bash
http://127.0.0.1:8888/lab?token=61dd1c363941d373e0e172148d563d2e27944b9a53ac5685
```

Copy and paste it to you internet browser (if you chose a different port name in the previous step, change 8888 to that number).

Now you can open and run provided Jupyter notebooks. Remeber that `analysis.ipynb` requires output generated by `dge.ipynb`.
