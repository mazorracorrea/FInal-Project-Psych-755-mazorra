# PSYCHOLOGY-775-_-FINAL-
Repo with the final project for PSYCH 775

# Step 1: Data 
File: 01_Data_Ingestion_and_Cleaning.ipynb
This step ingests raw tweet data from multiple CSV files and merges them into a single dataset. The script cleans the data by removing duplicates and irrelevant entries, then creates a sanitized text column (santext) for further analysis. A sample of 1000 tweets is also generated for manual/AI annotation.


# Step 2: AI CODERS and data annotation
Files: 02a_Annotation_GPT4.ipynb, 02b_Annotation_Gemma.ipynb
To generate labeled data for model training, two large language models are used:
	•	02a – GPT-4 Annotation: Uses the OpenAI API to send the 1,000-tweet sample to GPT-4, which classifies each tweet according to a detailed polarization codebook.
	•	02b – Gemma Annotation: Replicates the process with a locally-run gemma3:12b model via Ollama, enabling performance comparisons between the two LLMs.

# Step 3: Reliability analysis (optional experiment)
File: 03_Inter-Coder_Reliability_Analysis.ipynb
Evaluates the agreement between GPT-4 and Gemma annotations using Krippendorff’s alpha to measure inter-coder reliability between the AI-generated labels.

# Step 4: Model evaluation  (optional experiment)
Files: 04a_Baseline_Model_Evaluation.ipynb, 04b_Champion_Model_BERT_LGBM.ipynb
Two levels of classification modeling are explored:
	•	04a – Baseline Models: Tests traditional algorithms (Logistic Regression, Naive Bayes) for binary (left vs. right) and multi-class (polarization score) classification.
	•	04b – Champion Model: Uses distilBERT to embed tweet text, then trains a LightGBM classifier, achieving the highest performance.

# Step 5: Fine-Tuning  (optional experiment)
File: 05_Experiment_Fine_Tuning_Gemma.ipynb
Explores fine-tuning a smaller, more efficient model (gemma3:4b) for political tweet classification, aiming to improve domain-specific performance while keeping computation costs low.

# Step 6: Sentiment analysis
File: 06_Sentiment_Analysis_VADER.ipynb
Adds sentiment scores to the dataset using VADER (Valence Aware Dictionary and sEntiment Reasoner). Calculates negative, neutral, positive, and compound sentiment values for each tweet’s sanitized text.

# Step 7: Final Database and prelimianr analysis
File: 07_Final_Analysis_and_Visualization.ipynb
Integrates all processed data into one dataset, combining original tweet information with polarization and sentiment results. Performs final exploratory data analysis, including visualizations of:
	•	Tweet volume over time
	•	Sentiment distribution
	•	Polarization patterns


# Appendix: Polarization Codebook
File: APPENDIX_A_Polarization_Codebook.ipynb
Contains the detailed 15-point political polarization scale (–7 = extreme left to +7 = extreme right). This codebook guided all annotation steps and ensured consistent labeling criteria across models.
