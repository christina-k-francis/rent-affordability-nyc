"""
Functions for the Gentrification Machine Learning Analysis
"""

# data organization + calculation
import pandas as pd
import numpy as np
# estimators/models
from sklearn.cluster import KMeans, DBSCAN
from sklearn.decomposition import PCA
from sklearn.ensemble import IsolationForest
# preprocessing & engineering
from sklearn.preprocessing import StandardScaler, MinMaxScaler
# model scoring
from sklearn.metrics import silhouette_score

def engineer_gentrification_features(df):
    """
    Description:
       This FX creates features that capture gentrification patterns
    Input:
        df: pandas dataframe with rent and income data, including these specific column names:
            - yoy_change_pct_all
            - yoy_change_pct_all_hhs
            - yoy_change_pct_1bdr
            - yoy_change_pct_singles
            - yoy_change_pct_3bdr
            - yoy_change_pct_other_kids
            - yoy_change_pct_married_kids
            - avg_median_all_apts
            - avg_median_1bdr_apts
            - avg_median_3bdr_apts
            - median_all_hhs
            - median_singles
            - median_other_kids
            - median_married_kids
            - year
    """
    features_df = df.groupby('neighborhood').agg({
        'yoy_change_pct_all': [
            'mean', 'std', 'max', 'min',
            lambda x: len([i for i in x if i > 10]),  # years with >10% increase
            lambda x: len([i for i in x if i > 15]),  # years with >15% increase
        ],
        'yoy_change_pct_all_hhs': ['mean', 'std', 'max', 'min'],
        'yoy_change_pct_1bdr': [
            'mean', 'std', 'max', 'min',
            lambda x: len([i for i in x if i > 10]),  # years with >10% increase
            lambda x: len([i for i in x if i > 15]),  # years with >15% increase
        ],
        'yoy_change_pct_singles': ['mean', 'std', 'max', 'min'],
        'yoy_change_pct_3bdr': [
            'mean', 'std', 'max', 'min',
            lambda x: len([i for i in x if i > 10]),  # years with >10% increase
            lambda x: len([i for i in x if i > 15]),  # years with >15% increase
        ],
        'yoy_change_pct_other_kids': ['mean', 'std', 'max', 'min'],
        'yoy_change_pct_married_kids': ['mean', 'std', 'max', 'min'],
        
        # Originally, these are monthly median rent data averaged across all months in each year. 
        # Calculating the mean transforms this into an average of monthly median rent across all years of data
        'avg_median_all_apts': ['mean', 'std', 'max', 'min'],  
        'avg_median_1bdr_apts': ['mean', 'std', 'max', 'min'],
        'avg_median_3bdr_apts': ['mean', 'std', 'max', 'min'],
        
        'median_all_hhs': ['mean', 'std', 'max', 'min'], 
        'median_singles': ['mean', 'std', 'max', 'min'],
        'median_other_kids': ['mean', 'std', 'max', 'min'],
        'median_married_kids': ['mean', 'std', 'max', 'min'],
        'year': 'count'  # number of years of data
    }).reset_index()
    
    # define column names
    features_df.columns = [
        'neighborhood',
        'all_yoy_rent_change_mean', 'all_yoy_rent_change_std', 'all_yoy_rent_change_max', 'all_yoy_rent_change_min',
        'all_years_high_increase', 'all_years_extreme_increase',
        'all_yoy_income_change_mean', 'all_yoy_income_change_std', 'all_yoy_income_change_max', 'all_yoy_income_change_min',
        
        '1bdr_yoy_rent_change_mean', '1bdr_yoy_rent_change_std', '1bdr_yoy_rent_change_max', '1bdr_yoy_rent_change_min',
        '1bdr_years_high_increase', '1bdr_years_extreme_increase',
        'singles_yoy_income_change', 'singles_yoy_income_change_std', 'singles_yoy_income_change_max', 'singles_yoy_income_change_min',
        
        '3bdr_yoy_rent_change_mean', '3bdr_yoy_rent_change_std', '3bdr_yoy_rent_change_max', '3bdr_yoy_rent_change_min',
        '3bdr_years_high_increase', '3bdr_years_extreme_increase',
        'other_kids_yoy_income_change_mean', 'other_kids_yoy_income_change_std', 'other_kids_yoy_income_change_max', 'other_kids_yoy_income_change_min',
        'married_kids_yoy_income_change_mean', 'married_kids_yoy_income_change_std', 'married_kids_yoy_income_change_max', 'married_kids_income_change_min',

        'all_avg_median_rent', 'all_rent_volatility', 'all_avg_median_rent_max', 'all_avg_median_rent_min',
        '1bdr_avg_median_rent', '1bdr_rent_volatility', '1bdr_avg_median_rent_max', '1bdr_avg_median_rent_min',
        '3bdr_avg_median_rent', '3bdr_rent_volatility', '3bdr_avg_median_rent_max', '3bdr_avg_median_rent_min',

        'all_avg_median_income', 'all_income_volatility', 'all_median_income_max', 'all_median_income_min',
        'singles_avg_median_income', 'singles_income_volatility', 'singles_median_income_max', 'singles_median_income_min',
        'other_kids_avg_median_income', 'other_kids_income_volatility', 'other_kids_median_income_max', 'other_kids_median_income_min',
        'married_kids_avg_median_income', 'married_kids_income_volatility', 'married_kids_median_income_max', 'married_kids_median_income_min',

        'years_data'
    ]
    
    # Total Rent Change across period
    features_df['all_total_rent_change'] = features_df['all_avg_median_rent_max'] - features_df['all_avg_median_rent_min']
    features_df['1bdr_total_rent_change'] = features_df['1bdr_avg_median_rent_max'] - features_df['1bdr_avg_median_rent_min']
    features_df['3bdr_total_rent_change'] = features_df['3bdr_avg_median_rent_max'] - features_df['3bdr_avg_median_rent_min']
    
    # Total income change across period
    features_df['all_total_income_change'] = features_df['all_median_income_max'] - features_df['all_median_income_min']
    features_df['singles_total_income_change'] = features_df['singles_median_income_max'] - features_df['singles_median_income_min']
    features_df['other_kids_total_income_change'] = features_df['other_kids_median_income_max'] - features_df['other_kids_median_income_min']
    features_df['married_kids_total_income_change'] = features_df['married_kids_median_income_max'] - features_df['married_kids_median_income_min']

    # Rent-to-Income Ratio - features
    features_df['all_rent_income_ratio'] = features_df['all_avg_median_rent'] / (features_df['all_avg_median_income']/12)
    features_df['singles_rent_income_ratio'] = features_df['1bdr_avg_median_rent'] / (features_df['singles_avg_median_income']/12)
    features_df['other_kids_rent_income_ratio'] = features_df['3bdr_avg_median_rent'] / (features_df['other_kids_avg_median_income']/12)
    features_df['married_kids_rent_income_ratio'] = features_df['3bdr_avg_median_rent'] / (features_df['married_kids_avg_median_income']/12)

    # Gentrification Intensity - features
    features_df['all_gentrification_intensity'] = (
        features_df['all_years_high_increase'] / features_df['years_data'] * 
        (features_df['all_avg_median_rent_max']/features_df['all_avg_median_rent_min'])
    )
    features_df['1bdr_gentrification_intensity'] = (
        features_df['1bdr_years_high_increase'] / features_df['years_data'] * 
        (features_df['1bdr_avg_median_rent_max']/features_df['1bdr_avg_median_rent_min'])
    )
    features_df['3bdr_gentrification_intensity'] = (
        features_df['3bdr_years_high_increase'] / features_df['years_data'] * 
        (features_df['3bdr_avg_median_rent_max']/features_df['3bdr_avg_median_rent_min'])
    )

    # Rent price acceleration - features
    features_df['all_price_acceleration'] = features_df['all_yoy_rent_change_max'] - features_df['all_yoy_rent_change_mean']
    features_df['1bdr_price_acceleration'] = features_df['1bdr_yoy_rent_change_max'] - features_df['1bdr_yoy_rent_change_mean']
    features_df['3bdr_price_acceleration'] = features_df['3bdr_yoy_rent_change_max'] - features_df['3bdr_yoy_rent_change_mean']
    
    return features_df

def analyze_temporal_patterns(df):
    """
    Description:
        This function identifies neighborhoods with consecutive years of high rent increases
        for all apartments, 1 bedroom apartments, and 3+ bedroom apartments. 'High' increases
        include Year-over-Year changes of 8%, 12%, 15%, or higher.
    """
    def consecutive_increases(series, threshold=5):
        """Counting maximum consecutive years above percentage threshold"""
        above_threshold = (series > threshold).astype(int)
        max_consecutive = 0
        current_consecutive = 0
        
        for val in above_threshold:
            if val == 1:
                current_consecutive += 1
                max_consecutive = max(max_consecutive, current_consecutive)
            else:
                current_consecutive = 0
        return max_consecutive
    
    temporal_features = df.groupby('neighborhood').agg({
        'yoy_change_pct_all': [
            lambda x: consecutive_increases(x, 8),
            lambda x: consecutive_increases(x, 12),
            lambda x: consecutive_increases(x, 15),
        ],
        'yoy_change_pct_1bdr': [
            lambda x: consecutive_increases(x, 8),
            lambda x: consecutive_increases(x, 12),
            lambda x: consecutive_increases(x, 15),
        ],
        'yoy_change_pct_3bdr': [
            lambda x: consecutive_increases(x, 8),
            lambda x: consecutive_increases(x, 12),
            lambda x: consecutive_increases(x, 15),
        ],
    }).reset_index()
    
    temporal_features.columns = [
        'neighborhood', 
        'all_consec_8pct', 'all_consec_12pct', 'all_consec_15pct',
        '1bdr_consec_8pct', '1bdr_consec_12pct', '1bdr_consec_15pct',
        '3bdr_consec_8pct', '3bdr_consec_12pct', '3bdr_consec_15pct'
    ]
    
    return temporal_features

def detect_anomalies(features_df, anomaly_features, 
                     anomaly_score='anomaly_score', is_anomaly='is_anomaly'):
    """
    Description:
        This functions uses Isolation Forest to detect anomalous gentrification patterns.

    Input:
        features_df: pandas dataframe of rent change, gentrification intensity, and other columns
        from earlier analyses
        anomaly_features: list of columns that will be utilized for anomaly detection.
            (e.g. 'rent_change_mean', 'years_high_increase', 'gentrification_intensity',
                 'price_acceleration', 'rent_income_ratio', 'total_rent_change', etc.)
        anomaly_score: string that will be used for labelling the anomaly score column
        is_anomaly: string that will be used to label column with binary "is anomaly" variable
    Output:
        features_df: Original dataframe updated with data scored and labelled based on anomaly detection
    """
    # Select features for anomaly detection    
    X_anomaly = features_df[anomaly_features].fillna(0)
    
    # Standardize features
    scaler = StandardScaler()
    X_scaled = scaler.fit_transform(X_anomaly)
    
    # Isolation Forest for anomaly detection
    iso_forest = IsolationForest(contamination=0.1, random_state=42)
    anomaly_labels = iso_forest.fit_predict(X_scaled)
    
    features_df[f'{anomaly_score}'] = iso_forest.decision_function(X_scaled)
    features_df[f'{is_anomaly}'] = (anomaly_labels == -1)
    
    return features_df

def cluster_gentrification_stages(features_df, cluster_features):
    """
    Description:
        This function K-means clustering to identify gentrification stages

    Input:
        features_df: pandas dataframe of rent change, gentrification intensity, and other columns
        from earlier analyses
        cluster_features: list of columns that will be utilized for clustering the data.
            (e.g. 'rent_change_mean', 'years_high_increase', 'gentrification_intensity',
                  'price_acceleration', 'rent_income_ratio', 'total_rent_change',
                  'consec_8pct', 'consec_12pct')
        gentrification stage: string that will be used for labelling the column with clustering results
    Output:
        features_df: Original dataframe updated with a column containing gentrification clustering results
        kmeans_final: The KMeans Estimator Object, containing the results of the model
        scalar.fit(): Scalar object fitted to cluster data, containing standardized mean and stdev
        
    
    """
    # Select features for clustering
    X_cluster = features_df[cluster_features].fillna(0)
    
    # Standardize features
    scaler = StandardScaler()
    X_scaled = scaler.fit_transform(X_cluster)
    
    # Find optimal number of clusters using elbow method and silhouette score
    inertias = []
    silhouette_scores = []
    k_range = range(2, 8)
    
    for k in k_range:
        kmeans = KMeans(n_clusters=k, random_state=42, n_init=10)
        cluster_labels = kmeans.fit_predict(X_scaled)
        inertias.append(kmeans.inertia_)
        silhouette_scores.append(silhouette_score(X_scaled, cluster_labels))
    
    # Choosing the optimal k 
    optimal_k = k_range[np.argmax(silhouette_scores)]
    #print(f'{silhouette_scores} \n {k_range} \n {np.argmax(silhouette_scores)}')
    print(f"Optimal number of clusters: {optimal_k}")
    
    # Final clustering
    kmeans_final = KMeans(n_clusters=optimal_k, random_state=42, n_init=10)
    features_df['gentrification_stage'] = kmeans_final.fit_predict(X_scaled)
    
    return features_df, kmeans_final, scaler.fit(X_cluster)