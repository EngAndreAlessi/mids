# mids
This repository contains my work on the MIDS problem.

In mids/data/source, we have:
* instances.csv: The name and dataset of all instances used in this work
* literature_results.csv: Information on the performance of other literature methods for the MIDS problem, as reported in Pan et al (2023).

In mids/data/dimacs and mids/data/bhoslib, we have the instances used in this work. We got them in 3 different places: the network repository <https://networkrepository.com/>, this website with some DIMACS instances <https://iridia.ulb.ac.be/~fmascia/maximum_clique/> and this for the BHOSLIB <https://iridia.ulb.ac.be/~fmascia/maximum_clique/BHOSLIB-benchmark>

Some utility function we made:
mids/scripts
* mids_lower_bound.R: Computes the theoretical lower bound of an instance
* greedy.R: Our greedy algorithm to find solutions for the MIDS problem for dense graphs

mids/scripts/compute_instances_info.R loads the instances as an igraph object and computes some useful information (order, number of edges, density, etc.)
* The results are stored in mids/data/results/instances_info.csv

mids/scripts/test_all_instances_log.R test the greedy algorithm for all instances once. This is for us to find any anomalies before the true experiment.
* log is created at mids/logs/log/test.log

mids/scripts/experiment.R performs the experiment for our greedy algorithm. 30 runs for each instance, order randomized.
* log is created at mids/logs/log/experiment.log
* Raw results are stored at mids/data/results/results-raw.csv

mids/scripts/results_analysis.R perform the statistical analysis of the results data
* log is created at mids/logs/log/results_analysis.log
* Some cleaned tables are stored at mids/data/results/
* Some plots are saved at mids/data/plots
