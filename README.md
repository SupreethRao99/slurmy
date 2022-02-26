# SLURMy
![1*AyI7PEpEwbafV0m8t5abiQ](https://user-images.githubusercontent.com/55043035/155833159-7e191076-d894-477b-8087-ef37567b2a31.jpeg)

__SLURM__ : Simple Linux Utility for Resource Management, is a simple resouce manager developed for Linux clusters at Lawrence Livermore National Laboratory (LLNL) in 2002.
It has evolved into a capable job scheduler through the use of optional plugins. SLURM supports AIX, Linux, Solaris and other Linux distributions.

## Goals
- Learn the basics of SLURM's architecture, daemons and commands
- Learn how to use a basic set of commands 
  
## Agenda
- Role of a resouce manager and job scheduler
- SLURM design and architecture 
- SLURM commands
  
## Role of a Resource Manager
A resource manager acts as the "glue" for a parallel computer to execute parallel jobs. In theory, it should make a parallel computer almost as easy to use as a personal computer. MPI (Message Passing Interface) would typically be used to manage communications within the parallel program

A Resource Manager
- Allocates resources within a cluster. Resources are divided up into nodes (identified with a unique IP address). A node would typically ential
  - NUMA boards
    - Sockets (eg: Intel(R) Xeon(R) CPU E5-2698)
      - Cores (eg: 64 cores)
        - Hyperthreads (eg: 2 hyper threads per core)
    - Memory (eg: 4096 GB of RAM)
    - Interconnect/Switch resources (eg: Infiniband, NVSwitch)
  - Licences (eg: Product Keys etc)
- Launches and otherwise manage jobs

## Role of a Job Scheduler
When there is more work than resources, A job scheduler manages queue's of work by
- Supporting complex scheduling algorithms that are optimized network topology, fair share scheduling, advanced reservations, preemption, gang scheduling (time-slicing jobs) etc .
- Supports resrouce limits (by queue, user, group, etc ...)

## SLURM Entities
- __Jobs__ : Resource allocation requests
- __Job Steps__ : Set of typically parallel task
- __Partitions__: Job queues with limits and access controls
- __Nodes__ : A unit of the slurm cluster, consists of NUMA boards, Memory, Generic Resources (eg GPU's)

## SLURM Commands 
Manual pages are available for all commands, daemons and configuration files. eg `man squeue` gives the man page for the `squeue` command.
- `--help` option prints a brief description of all options
- `--usage` option prints a list of the options

Commands can be run on a particular node or a subset of nodes in a cluster. Any failure will result in a non-zero exit code.

Almost all options have two formats
- A single letter option (eg: `-p dgx-4G` selects the partition `dgx-4G`)
- A verbose option (eg: `--partition=dgx-4G`)

Time is formatted using the `days-hours:minutes:seconds` convention 

Almost all commands support verbose logging with `-v` option and more `v` can be used for more verbosity `-vvvv`

Many environments can be used to establish site specific and/or user-specific defaults, For example, `SQUEUE_STATES=all` for the `squeue` command to display jobs in any state, including `COMPLETED` or `CANCELLED`

### SLURM Job/Step Allocation
<table>
    <tr>
        <th> Command </td>
        <th> Description </td>
    </tr>
    <tr>
        <td> sbatch </td>
        <td> Submit script for later execution (batch mode) </td>
    </tr>
    <tr>
        <td> salloc </td>
        <td> Create job allocation and start a shell to use it (interactive mode) </td>
    </tr>
    <tr>
        <td> srun </td>
        <td> Create a job allocation (if needed) and launch a job step (typically an MPI job) </td>
    </tr>
    <tr>
        <td> sattach </td>
        <td> Connect stdin/out/err for an existing job or job step </td>
    </tr>
</table>


#### Example
```
> sbatch --ntasks=1 --time=0:10:0 test_job.sh
Submitted batch job 5004

> srun --nnodes=2 --exclusive --label hostname
0: tux123
1: tux124
```


### SLURM System Information
<table>
    <tr>
        <th> Command </th>
        <th> Description </th>
    </tr>
    <tr>
        <td> sinfo </td>
        <td>Report system status (nodes, queues, etc) </td>
    </tr>
    <tr>
        <td> squeue </td>
        <td> Report job and job step status </td>
    </tr>
    <tr>
        <td> smap </td>
        <td> Report system, job or step status with topology, less functional than sview </td>
    </tr>
    <tr>
        <td> sview </td>
        <td> Report and/or update system, job, step, partition or reservation status with topology </td>
    </tr>
    <tr>
        <td> scancel </td>
        <td> Signal/Cancel jobs or job steps </td>
    </tr>
</table>

### `sinfo` Command
Reports status nodes or partitions in a partition oriented format. It gives us complete control over filtering, sorting and output format.
```
> sinfo
PARTITION   AVAIL  TIMELIMIT  NODES  STATE NODELIST
q_1day-1G      up 1-00:00:00      1    mix nvidia-dgx1
q_2day-1G      up 2-00:00:00      1    mix nvidia-dgx1
q_1day-2G      up 1-00:00:00      1    mix nvidia-dgx1
q_2day-2G      up 2-00:00:00      1    mix nvidia-dgx1
q_1day-4G      up 1-00:00:00      1    mix nvidia-dgx1
q_2day-4G      up 2-00:00:00      1    mix nvidia-dgx1
hpq_2day_4G    up 2-00:00:00      1    mix nvidia-dgx1

> sinfo -p q_1day-1G
PARTITION AVAIL  TIMELIMIT  NODES  STATE NODELIST
q_1day-1G    up 1-00:00:00      1    mix nvidia-dgx1
```
### `squeue` Command
Reports status of recent jobs and/or steps in slurmctld daemon/s records. Almost complete control over filtering, sorting and output format is available
```
> squeue
JOBID PARTITION     NAME     USER ST       TIME  NODES NODELIST(REASON)
5010 q_2day-2G    yyyyy    xxxxxx PD       0:00      1 (AssocMaxJobsLimit)
4995 q_2day-2G      yyy    xxxxxx  R 1-12:18:59      1 nvidia-dgx1
4998 q_2day-2G     ytyx  Supreeth  R 1-00:20:39      1 nvidia-dgx1
5005 q_2day-2G      yyy xxxxxxxxx  R    3:54:01      1 nvidia-dgx1

> squeue -u Supreeth -t all
JOBID PARTITION     NAME     USER ST       TIME  NODES NODELIST(REASON) 
4998 q_2day-2G    ytyyy  Supreeth  R 1-00:20:39      1 nvidia-dgx1
```
### SLURM Command: Accounting
- __sacct__ - Report accounting information by individual job and job step
- __sstat__ - Report accounting information about currently running jobs and job steps (more detailed than sacct)
- __sreport__ - Report resource usage by cluster, partition, user, account, etc .

# Examples
To view sample scripts, go to `/examples` directory on this repo.

# Resources
- [SLURM Workload Manager](https://www.open-mpi.org/video/slurm/Slurm_EMC_Dec2012.pdf)
- [Docker on Nvidia DGX-1](https://www.iitr.ac.in/dgx/more.html)
- [Nvidia DGX-1 User guide](https://www.old.iitr.ac.in/dgx/docs/IITR_DGX%20User%20Document.pdf) 
