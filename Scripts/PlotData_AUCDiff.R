#Find the AUC difference between each treatment curve and the mean negative control curve AUC

#get mean of sytoxG negative control AUC 
mean_sytoxG_neg_control_AUC <- mean(sytoxG_data[sytoxG_data$empty=="Negative Control",]$AUC_trapezoidal_integration)
sd_sytoxG_neg_control_AUC <- sd(sytoxG_data[sytoxG_data$empty=="Negative Control",]$AUC_trapezoidal_integration)

#get treatments only
sytoxG_data_treatment_only <- sytoxG_data %>%
  filter(empty == "Treatment")

#calculate AUC difference between treatment curve AUC and mean negative control AUC
sytoxG_data_treatment_only <- 
  transform(sytoxG_data_treatment_only, 
            AUC_diff_to_mean_neg_control = AUC_trapezoidal_integration - mean_sytoxG_neg_control_AUC)

#get positive (+ X SD of neg.control AUC) AUC diffs only
sytoxG_data_treatment_only <- sytoxG_data_treatment_only %>%
  filter(AUC_diff_to_mean_neg_control > 2*sd_sytoxG_neg_control_AUC)

ggplot(sytoxG_data_treatment_only, 
       aes(x=as.numeric(time_elapsed), y=as.numeric(phenotype_value), group=Compound,
           text=Compound)) +
  geom_line() +
  xlab("Time Elapsed") +
  ylab("Sytox Green") +
  ggtitle("Sytox Green") +
  facet_wrap(~Targets, scales = "fixed") +
  theme(panel.grid = element_blank(),
        axis.ticks.length = unit(0, "cm"),
        panel.background = element_rect(fill = "white"),
        strip.text.x = element_text(size=6),
        axis.text.x = element_blank())

ggplot(sytoxG_data_treatment_only, 
       aes(x=as.numeric(time_elapsed), y=as.numeric(phenotype_value), group=Compound,
           text=Compound)) +
  geom_line() +
  xlab("Time Elapsed") +
  ylab("Sytox Green") +
  ggtitle("Sytox Green") +
  facet_wrap(~Pathway, scales = "fixed") +
  theme(panel.grid = element_blank(),
        axis.ticks.length = unit(0, "cm"),
        panel.background = element_rect(fill = "white"),
        strip.text.x = element_text(size=6),
        axis.text.x = element_blank())

ggplot(sytoxG_data_treatment_only, 
       aes(x=as.numeric(time_elapsed), y=as.numeric(phenotype_value), group=Compound,
           text=Compound, colour = Pathway)) +
  geom_line() +
  xlab("Time Elapsed") +
  ylab("Sytox Green") +
  ggtitle("Sytox Green") +
  theme(panel.grid = element_blank(),
        axis.ticks.length = unit(0, "cm"),
        panel.background = element_rect(fill = "white"),
        strip.text.x = element_text(size=6),
        axis.text.x = element_blank())