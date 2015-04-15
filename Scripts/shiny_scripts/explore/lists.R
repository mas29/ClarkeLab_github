# Get list of compounds
compounds <- as.character(sort(unique(data_wide$Compound)))
compound_list <- as.list(setNames(compounds, compounds))

# Get list of targets
targets <- as.character(sort(unique(data_wide$Target.class..11Mar15.)))
target_list <- as.list(setNames(targets, targets))

# Get list of pathways
pathways <- as.character(sort(unique(data_wide$Pathway)))
pathway_list <- as.list(setNames(pathways, pathways))

# Get list of metrics
metrics <- c("delta_min_max", "time_to_max", "time_x_distance.upper", "time_to_most_positive_slope", "mean", "min", "AUC_trapezoidal_integration")
metric_names <- c("Delta (max-min)", "Time To Max", "Time*Distance", "Time To Most Positive Slope", "Mean", "Min", "AUC (trapezoidal integration)")
metrics <- setNames(metrics, metric_names)
metric_list <- as.list(setNames(metric_names, metric_names))

# Above or below
above_or_below <- c("Above Negative Control Upperbound", "Below Negative Control Lowerbound")
above_or_below_list <- as.list(setNames(above_or_below, above_or_below))