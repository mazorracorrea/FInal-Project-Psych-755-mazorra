# title: "Mapping Polarization Around the 2024 U.S. Presidential Debates"
#subtitle: "LLM-Coded Evidence on Debate-Driven Polarization and Sentiment"
#author:"Diego A. Mazorra"
#email: "diego.mazorra@wisc.edu"
#affiliation: "University of Wisconsin Madison"

# Libraries
library(tidyverse)
library(ggplot2)
library(dplyr)
library(knitr)  
library(gt)


theme_set(theme_minimal(base_size = 14))

# Load df
df <- read_csv("/Users/diego/anaconda_projects/PSYCH 757 FINAL/data/processed/debate_tweets_with_polarization_and_sentiment.csv")

# Convert categorical variables into factors
df <- df %>%
  mutate(
    # Create a more descriptive 'debate_label' factor
    debate_label = factor(Debate,
                          levels = c(1, 2),
                          labels = c("Biden vs. Trump", "Harris vs. Trump")),
    
    # Ensure 'predicted_binary_label' is a factor
    ideology = factor(predicted_binary_label,
                      levels = c("left", "right")),
    
    # Create an ordered factor for 'predicted_polarization_level'
    polarization_level = factor(predicted_polarization_level,
                                levels = c("Low", "Medium", "High", "None"),
                                ordered = TRUE)
  )

# Create a filtered df that excludes "None" polarization
polarized_df <- df %>%
  filter(polarization_level %in% c("Low", "Medium", "High"))


# PART 1: DESCRIPTIVE ANALYSIS AND VISUALIZATION --------------------------
# Select key columns and the first 5 rows for the excerpt
df %>%
  select(
    "Tweet Text" = santext,
    "Debate" = debate_label,
    "Ideology" = ideology,
    "Polarization" = polarization_level,
    "Sentiment Score" = vader_compound
  ) %>%
  head(5) %>%
  gt() %>%
  fmt_number(
    columns = `Sentiment Score`,
    decimals = 3
  ) %>%
  tab_options(
    table.width = pct(100) # Make table fill the width
  )

cat("\n PART 1: DESCRIPTIVE STATISTICS \n")

# Distribution of Ideology and Polarization
cat("\nDistribution of Ideological Labels:\n")
df %>%
  count(ideology) %>%
  mutate(percentage = n / sum(n) * 100) %>%
  kable(caption = "Frequency of Ideological Labels", digits = 2)

cat("\nDistribution of Polarization Levels (excluding 'None'):\n")
polarized_df %>%
  count(polarization_level) %>%
  mutate(percentage = n / sum(n) * 100) %>%
  kable(caption = "Frequency of Polarization Levels", digits = 2)

# Comparison of the Two Debates
cat("\nPolarization Levels by Debate:\n")
# Stacked bar chart to show proportions
ggplot(polarized_df, aes(x = debate_label, fill = polarization_level)) +
  geom_bar(position = "fill") +
  labs(title = "Proportion of Polarization Levels by Debate",
       x = "Debate",
       y = "Proportion of Tweets",
       fill = "Polarization Level") +
  scale_y_continuous(labels = scales::percent)

# Sentiment Overview
cat("\nSummary Statistics for VADER Compound Sentiment Score:\n")
df %>%
  summarise(
    Mean = mean(vader_compound, na.rm = TRUE),
    Median = median(vader_compound, na.rm = TRUE),
    SD = sd(vader_compound, na.rm = TRUE),
    Min = min(vader_compound, na.rm = TRUE),
    Max = max(vader_compound, na.rm = TRUE)
  ) %>%
  kable(caption = "Overall Sentiment Summary", digits = 3)

# Histogram of VADER scores
ggplot(df, aes(x = vader_compound)) +
  geom_histogram(bins = 50, fill = "skyblue", color = "black") +
  labs(title = "Distribution of VADER Compound Sentiment Scores",
       x = "Compound Sentiment Score (-1 to +1)",
       y = "Number of Tweets")


# PART 2: INFERENTIAL STATISTICAL ANALYSIS --------------------------------


cat("\n PART 2: INFERENTIAL STATISTICS \n")

# Ideology Across Debates
cat("\nChi-Square Test: Association between Debate and Ideology\n")
ideology_debate_table <- table(df$debate_label, df$ideology)
print(ideology_debate_table)
print(chisq.test(ideology_debate_table))

# Polarization Across Debates
cat("\nChi-Square Test: Association between Debate and Polarization Level\n")
polarization_debate_table <- table(polarized_df$debate_label, polarized_df$polarization_level)
print(polarization_debate_table)
print(chisq.test(polarization_debate_table))

# Sentiment and Ideology
cat("\nIndependent T-test: Sentiment Scores by Ideological Label\n")
t_test_ideology <- t.test(vader_compound ~ ideology, data = df)
print(t_test_ideology)

# Box plot to visualize the difference
ggplot(df, aes(x = ideology, y = vader_compound, fill = ideology)) +
  geom_boxplot() +
  labs(title = "Sentiment Score by Ideological Label",
       x = "Ideological Label",
       y = "VADER Compound Score") +
  theme(legend.position = "none")

# Sentiment and Polarization Intensity
cat("\nANOVA: Sentiment Scores by Polarization Level\n")
anova_polarization <- aov(vader_compound ~ polarization_level, data = polarized_df)
print(summary(anova_polarization))

cat("\nTukey's HSD Post-Hoc Test:\n")
print(TukeyHSD(anova_polarization))

# Box plot to visualize the differences
ggplot(polarized_df, aes(x = polarization_level, y = vader_compound, fill = polarization_level)) +
  geom_boxplot() +
  labs(title = "Sentiment Score by Polarization Level",
       x = "Polarization Level",
       y = "VADER Compound Score") +
  theme(legend.position = "none")


# Dictionary --------------------------------------------------------------

data_dictionary <- tibble(
  Variable = c("debate_label", "ideology", "polarization_level", "vader_compound"),
  Description = c(
    "Indicates which of the two presidential debates the tweet is associated with.",
    "The predicted ideological leaning of the tweet, classified as 'left' or 'right'.",
    "The predicted intensity of polarization, classified as 'Low', 'Medium', or 'High'.",
    "The normalized compound sentiment score from VADER, ranging from -1 (most negative) to +1 (most positive)."
  ),
  Type = c("Categorical (Factor)", "Categorical (Factor)", "Ordinal (Ordered Factor)", "Continuous (Numeric)")
)

# table
gt(data_dictionary) %>%
  cols_label(
    Variable = "Variable Name",
    Description = "Description",
    Type = "Data Type"
  )
