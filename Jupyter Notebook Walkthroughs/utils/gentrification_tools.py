"""
Functions for the Gentrification Machine Learning Analysis
"""

# data organization + calculation
import pandas as pd
import numpy as np
# estimators/models
from sklearn.impute import KNNImputer
from sklearn.cluster import KMeans
from sklearn.decomposition import PCA
from sklearn.ensemble import IsolationForest
# preprocessing & engineering
from sklearn.feature_selection import VarianceThreshold
from sklearn.preprocessing import StandardScaler
# model scoring
from sklearn.metrics import silhouette_score

def engineer_gentrification_features(df):
    """
    Description:
        This function creates features that capture gentrification patterns.
        Flexibly handles different column availability based on input data.
    
    Input:
        df: pandas dataframe with rent and income data. Must contain:
            - neighborhood (required)
            - year (required)
            
        Optional columns (function adapts based on availability):
            YoY change columns: yoy_change_pct_all_apts, yoy_change_pct_all_hhs,
                                yoy_change_pct_1bdr, yoy_change_pct_singles,
                                yoy_change_pct_3bdr, yoy_change_pct_other_kids,
                                yoy_change_pct_married_kids
            Rent columns: avg_median_all_apts, avg_median_1bdr_apts, avg_median_3bdr_apts
            Income columns: median_all_hhs, median_singles, median_other_kids, median_married_kids
            Sale price columns: median_sale
    
    Output:
        Pandas DataFrame with engineered features aggregated by neighborhood
    """
    
    # define column groups with their expected names
    column_groups = {
        'yoy_rent': ['yoy_change_pct_all_apts', 'yoy_change_pct_1bdr', 'yoy_change_pct_3bdr'],
        'yoy_income': ['yoy_change_pct_all_hhs', 'yoy_change_pct_singles', 
                       'yoy_change_pct_other_kids', 'yoy_change_pct_married_kids'],
        'rent': ['avg_median_all_apts', 'avg_median_1bdr_apts', 'avg_median_3bdr_apts'],
        'income': ['median_all_hhs', 'median_singles', 'median_other_kids', 'median_married_kids'],
        'sale_price': ['median_sale']
    }
    
    # identifying which columns are actually present in the dataframe
    available_columns = {}
    for group_name, col_list in column_groups.items():
        available_columns[group_name] = [col for col in col_list if col in df.columns]
    
    # let's build the agg dict dynamically
    agg_dict = {}
    
    # YoY rent change stats (with spike counts)
    for col in available_columns['yoy_rent']:
        agg_dict[col] = [
            'mean', 'std', 'max', 'min',
            lambda x: len([i for i in x if i > 10]),  # years with >10% increase
            lambda x: len([i for i in x if i > 15]),  # years with >15% increase
        ]
    
    # YoY income change
    for col in available_columns['yoy_income']:
        agg_dict[col] = ['mean', 'std', 'max', 'min']
    
    # Rent stats
    for col in available_columns['rent']:
        agg_dict[col] = ['mean', 'std', 'max', 'min']
    
    # Income stats
    for col in available_columns['income']:
        agg_dict[col] = ['mean', 'std', 'max', 'min']
    
    # sale price stats
    for col in available_columns['sale_price']:
        agg_dict[col] = ['mean', 'std', 'max', 'min']
    
    # always include the year count
    agg_dict['year'] = 'count'
    
    # performing aggregation
    features_df = df.groupby('neighborhood').agg(agg_dict).reset_index()
    
    # flatten the multi-level column names
    features_df.columns = ['_'.join(col).strip('_') for col in features_df.columns.values]
    
    # now, let's calculate derived gentrification + affordability metrics
    
    # 1. TOTAL RENT CHANGE (range across period)
    rent_mapping = {
        'avg_median_all_apts': 'all',
        'avg_median_1bdr_apts': '1bdr',
        'avg_median_3bdr_apts': '3bdr'
    }
    
    for orig_col, prefix in rent_mapping.items():
        if orig_col in available_columns['rent']:
            max_col = f'{orig_col}_max'
            min_col = f'{orig_col}_min'
            features_df[f'{prefix}_total_rent_change'] = features_df[max_col] - features_df[min_col]
    
    # 2. TOTAL INCOME CHANGE (range across period)
    income_mapping = {
        'median_all_hhs': 'all',
        'median_singles': 'singles',
        'median_other_kids': 'other_kids',
        'median_married_kids': 'married_kids'
    }
    
    for orig_col, prefix in income_mapping.items():
        if orig_col in available_columns['income']:
            max_col = f'{orig_col}_max'
            min_col = f'{orig_col}_min'
            features_df[f'{prefix}_total_income_change'] = features_df[max_col] - features_df[min_col]
    
    # 3. RENT-TO-INCOME RATIO 
    # mapping rent columns to their corresponding income columns
    rent_income_pairs = [
        ('avg_median_all_apts', 'median_all_hhs', 'all'),
        ('avg_median_1bdr_apts', 'median_singles', 'singles'),
        ('avg_median_3bdr_apts', 'median_other_kids', 'other_kids'),
        ('avg_median_3bdr_apts', 'median_married_kids', 'married_kids')
    ]
    
    for rent_col, income_col, prefix in rent_income_pairs:
        if rent_col in available_columns['rent'] and income_col in available_columns['income']:
            rent_mean_col = f'{rent_col}_mean'
            income_mean_col = f'{income_col}_mean'
            # dividing by 12 to convert annual income to monthly, avoid division by zero
            features_df[f'{prefix}_rent_income_ratio'] = (
                features_df[rent_mean_col] / 
                (features_df[income_mean_col].replace(0, np.nan) / 12)
            )
    
    # 4. GENTRIFICATION INTENSITY
    # (proportion of high-spike years) * (max/min rent ratio)
    intensity_mapping = {
        'yoy_change_pct_all_apts': ('avg_median_all_apts', 'all'),
        'yoy_change_pct_1bdr': ('avg_median_1bdr_apts', '1bdr'),
        'yoy_change_pct_3bdr': ('avg_median_3bdr_apts', '3bdr')
    }
    
    for yoy_col, (rent_col, prefix) in intensity_mapping.items():
        if yoy_col in available_columns['yoy_rent'] and rent_col in available_columns['rent']:
            spike_col = f'{yoy_col}_<lambda_0>'  # >10% spike count
            max_rent_col = f'{rent_col}_max'
            min_rent_col = f'{rent_col}_min'
            
            # avoiding division by zero in both denominators
            features_df[f'{prefix}_gentrification_intensity'] = (
                features_df[spike_col] / features_df['year_count'].replace(0, np.nan) *
                (features_df[max_rent_col] / features_df[min_rent_col].replace(0, np.nan))
            )
    
    # 5. RENT PRICE ACCELERATION (max YoY change - mean YoY change)
    accel_mapping = {
        'yoy_change_pct_all_apts': 'all',
        'yoy_change_pct_1bdr': '1bdr',
        'yoy_change_pct_3bdr': '3bdr'
    }
    
    for yoy_col, prefix in accel_mapping.items():
        if yoy_col in available_columns['yoy_rent']:
            max_col = f'{yoy_col}_max'
            mean_col = f'{yoy_col}_mean'
            features_df[f'{prefix}_price_acceleration'] = features_df[max_col] - features_df[mean_col]
    
    # 6. SALE PRICE CHANGE (range across period)
    if 'median_sale' in available_columns['sale_price']:
        features_df['total_sale_price_change'] = (
            features_df['median_sale_max'] - features_df['median_sale_min']
        )
    
    return features_df

def analyze_temporal_patterns(df, thresholds=[8, 12, 15]):
    """
    Description:
        This function identifies neighborhoods with consecutive years of high rent increases 
        for all apartments, 1 bedroom apartments, and 3+ bedroom apartments. It flexibly handles 
        different column availability based on input data.
    
    Input:
        df: pandas DataFrame with YoY rent change data. Must contain:
            - neighborhood (required)
            
        Optional columns:
            - yoy_change_pct_all_apts
            - yoy_change_pct_1bdr
            - yoy_change_pct_3bdr
            
        thresholds: list of percentage thresholds to check for consecutive increases
                   (default: [8, 12, 15])
    
    Output:
        DataFrame with consecutive increase counts for each available column and threshold
    """
    
    def consecutive_increases(series, threshold=5):
        """Counting maximum consecutive years above percentage threshold"""
        # Handle NaN values by treating them as not above threshold
        above_threshold = (series > threshold).fillna(False).astype(int)
        max_consecutive = 0
        current_consecutive = 0
        
        for val in above_threshold:
            if val == 1:
                current_consecutive += 1
                max_consecutive = max(max_consecutive, current_consecutive)
            else:
                current_consecutive = 0
        return max_consecutive
    
    # available YoY rent columns
    yoy_rent_columns = {
        'yoy_change_pct_all_apts': 'all',
        'yoy_change_pct_1bdr': '1bdr',
        'yoy_change_pct_3bdr': '3bdr'
    }
    
    # identifying which columns are present
    available_yoy_cols = {col: prefix for col, prefix in yoy_rent_columns.items() 
                          if col in df.columns}
    
    if not available_yoy_cols:
        raise ValueError("No YoY rent change columns found in dataframe.")
    
    # building agg dict dynamically
    agg_dict = {}
    for col in available_yoy_cols.keys():
        agg_dict[col] = [lambda x, t=thresh: consecutive_increases(x, t) 
                         for thresh in thresholds]
    
    # performing aggregation
    temporal_features = df.groupby('neighborhood').agg(agg_dict).reset_index()
    
    # creating resultant columns
    new_columns = ['neighborhood']
    for col, prefix in available_yoy_cols.items():
        for thresh in thresholds:
            new_columns.append(f'{prefix}_consec_{thresh}pct')
    
    temporal_features.columns = new_columns
    
    return temporal_features

def check_column_availability(df):
    """
    Description:
        Helper  function that checks which column groups are available in the dataframe.
        Useful for understanding what features will be engineered.
    
    Input:
        df: pandas DataFrame
    
    Output:
        dict with available columns by group
    """
    column_groups = {
        'yoy_rent': ['yoy_change_pct_all_apts', 'yoy_change_pct_1bdr', 'yoy_change_pct_3bdr'],
        'yoy_income': ['yoy_change_pct_all_hhs', 'yoy_change_pct_singles', 
                       'yoy_change_pct_other_kids', 'yoy_change_pct_married_kids'],
        'rent': ['avg_median_all_apts', 'avg_median_1bdr_apts', 'avg_median_3bdr_apts'],
        'income': ['median_all_hhs', 'median_singles', 'median_other_kids', 'median_married_kids'],
        'sale_price': ['median_sale']
    }
    
    availability = {}
    
    for group_name, col_list in column_groups.items():
        available = [col for col in col_list if col in df.columns]
        missing = [col for col in col_list if col not in df.columns]
        availability[group_name] = available
    
    return availability

def select_clustering_features(features_df, neighborhood_col='neighborhood', 
                                variance_threshold=0.01, correlation_threshold=0.95,
                                verbose=True):
    """
    Description:
        Selects features for clustering by removing low variance and highly correlated features.
    
    Input:
        - features_df: DataFrame with engineered features (output from engineer_gentrification_features)
        - neighborhood_col: Name of the neighborhood identifier column (excluded from analysis)
        - variance_threshold: Remove features with variance below this threshold (default: 0.01)
                          Set to 0 to remove only constant features
        - correlation_threshold: Remove one feature from pairs with correlation above this (default: 0.95)
        
    Output:
        tuple: (selected_features_df, removed_features_dict)
            - selected_features_df: DataFrame with only selected features
            - removed_features_dict: Dictionary tracking removed features and reasons
    """
    
    if neighborhood_col not in features_df.columns:
        raise ValueError(f"Neighborhood column '{neighborhood_col}' not found in dataframe")
    
    neighborhoods = features_df[neighborhood_col].copy()
    feature_cols = [col for col in features_df.columns if col != neighborhood_col]
    df = features_df[feature_cols].copy()
    
    removed_features = {
        'low_variance': [],
        'high_correlation': [],
        'infinite_values': []
    }
    
    # 1. Checking for  infinite values
    inf_cols = []
    for col in df.columns:
        if np.isinf(df[col]).any():
            inf_cols.append(col)
            removed_features['infinite_values'].append(col)
    
    if inf_cols:
        df = df.drop(columns=inf_cols)
    
    # 2: Standardizing features (for a meaning variance threshold)
    scaler = StandardScaler()
    df_scaled = pd.DataFrame(
        scaler.fit_transform(df),
        columns=df.columns,
        index=df.index
    )
    
    # 3: Removing low variance features
    selector = VarianceThreshold(threshold=variance_threshold)
    selector.fit(df_scaled)
    
    low_var_mask = selector.get_support()
    low_var_features = df_scaled.columns[~low_var_mask].tolist()
    removed_features['low_variance'] = low_var_features
    
    df_scaled = df_scaled.loc[:, low_var_mask]
    df = df.loc[:, low_var_mask]
    
    # 4: Removing highly correlated features
    corr_matrix = df_scaled.corr().abs()
    
    # getting the upper triangle of correlation matrix to avoid duplicate pairs
    upper_tri = corr_matrix.where(
        np.triu(np.ones(corr_matrix.shape), k=1).astype(bool)
    )
    
    # finding features with correlation above threshold
    high_corr_features = []
    high_corr_pairs = []
    for column in upper_tri.columns:
        correlated_features = upper_tri.index[upper_tri[column] > correlation_threshold].tolist()
        if correlated_features:
            for corr_feature in correlated_features:
                high_corr_pairs.append((column, corr_feature, upper_tri.loc[corr_feature, column]))
                # keeping the first feature, removing the second (arbitrary but consistent)
                if corr_feature not in high_corr_features:
                    high_corr_features.append(corr_feature)
    
    removed_features['high_correlation'] = high_corr_features
    
    df = df.drop(columns=high_corr_features)
    
    # 5: Creating finalized DF with neighborhood column
    selected_df = pd.concat([neighborhoods, df], axis=1)
    
    return selected_df, removed_features


def get_feature_importance_for_correlation(features_df, neighborhood_col='neighborhood'):
    """
    Description:
        Calculates which features are most important based on variance and correlation structure.
        Useful for understanding which features to prioritize for the Unsupervised Learning analysis.
    
    Input:
        - features_df: DataFrame with engineered features
        - neighborhood_col: Name of the neighborhood identifier column
    
    Output:
        - pandas dataFrame with feature importance scores sorted by importance
    """
    feature_cols = [col for col in features_df.columns if col != neighborhood_col]
    df = features_df[feature_cols].copy()
    
    # removing infinite values
    df = df.replace([np.inf, -np.inf], np.nan)
    df = df.dropna(axis=1, how='all')
    
    # Standardize
    scaler = StandardScaler()
    df_scaled = pd.DataFrame(
        scaler.fit_transform(df),
        columns=df.columns
    )
    
    # calculating importance metrics
    importance_df = pd.DataFrame({
        'feature': df.columns,
        'variance': df_scaled.var().values,
        'mean_abs_correlation': df_scaled.corr().abs().mean().values
    })
    
    # creating col of the combined importance score 
    # cols with high variance + low correlation with others is best
    importance_df['importance_score'] = (
        importance_df['variance'] * (1 - importance_df['mean_abs_correlation'])
    )
    
    importance_df = importance_df.sort_values('importance_score', ascending=False)
    
    return importance_df


def cluster_gentrification_groups(features_df, cluster_features, k_range = range(3, 6)):
    """
    Description:
        This function K-means clustering to identify gentrification groups
    Input:
        features_df: pandas dataframe of rent change, gentrification intensity, and other columns
        from earlier analyses
        cluster_features: list of columns that will be utilized for clustering the data.
            (e.g. 'rent_change_mean', 'years_high_increase', 'gentrification_intensity',
                  'price_acceleration', 'rent_income_ratio', 'total_rent_change',
                  'consec_8pct', 'consec_12pct')
        gentrification group: string that will be used for labelling the column with clustering results
    Output:
        features_df: Original dataframe updated with a column containing gentrification clustering results
        kmeans_final: The KMeans Estimator Object, containing the results of the model
        scalar.fit(): Scalar object fitted to cluster data, containing standardized mean and stdev
        
    
    """
    # Let's fill NaNs using the KNN Method
    imputer = KNNImputer(n_neighbors=2)

    # Impute and Select features for clustering
    X_cluster = pd.DataFrame(
        imputer.fit_transform(features_df[cluster_features]),
        columns=cluster_features,
        index=features_df.index
    )
    
    # Standardize features
    scaler = StandardScaler()
    X_scaled = scaler.fit_transform(X_cluster)
    
    # Find optimal number of clusters using elbow method and silhouette score
    inertias = []
    silhouette_scores = []
    
    for k in k_range:
        kmeans = KMeans(n_clusters=k, random_state=42, n_init=50)
        cluster_labels = kmeans.fit_predict(X_scaled)
        inertias.append(kmeans.inertia_)
        silhouette_scores.append(silhouette_score(X_scaled, cluster_labels))
    
    # Choosing the optimal k 
    optimal_k = k_range[np.argmax(silhouette_scores)]
    #print(f'{silhouette_scores} \n {k_range} \n {np.argmax(silhouette_scores)}')
    print(f"Optimal number of clusters: {optimal_k}")
    
    # Final clustering
    kmeans_final = KMeans(n_clusters=optimal_k, random_state=42, n_init=10)
    features_df['gentrification_group'] = kmeans_final.fit_predict(X_scaled)
    X_cluster['gentrification_group'] = kmeans_final.fit_predict(X_scaled)
    
    return features_df, kmeans_final, scaler.fit(X_cluster), X_cluster

def detect_anomalies(features_df, anomaly_features, 
                     anomaly_score='anomaly_score', is_anomaly='is_anomaly'):
    """
    Description:
        This functions uses Isolation Forest to detect anomalous gentrification patterns.

    Input:
        - features_df: pandas dataframe of rent change, gentrification intensity, and other columns 
          from earlier analyses
        - anomaly_features: list of columns that will be utilized for anomaly detection.
          (e.g. 'rent_change_mean', 'years_high_increase', 'gentrification_intensity',
                 'price_acceleration', 'rent_income_ratio', 'total_rent_change', etc.)
        - anomaly_score: string that will be used for labelling the anomaly score column
        - is_anomaly: string that will be used to label column with binary "is anomaly" variable
    Output:
        - features_df: Original dataframe updated with data scored and labelled based on anomaly detection
    """
    # Let's fill NaNs using the KNN Method
    imputer = KNNImputer(n_neighbors=2)

    # Impute and Select features for anomaly detection
    X_anomaly = pd.DataFrame(
        imputer.fit_transform(features_df[anomaly_features]),
        columns=anomaly_features,
        index=features_df.index
    )
    
    # Standardize features
    scaler = StandardScaler()
    X_scaled = scaler.fit_transform(X_anomaly)
    
    # Isolation Forest for anomaly detection
    iso_forest = IsolationForest(contamination=0.1, random_state=42)
    anomaly_labels = iso_forest.fit_predict(X_scaled)
    
    features_df[f'{anomaly_score}'] = iso_forest.decision_function(X_scaled)
    features_df[f'{is_anomaly}'] = (anomaly_labels == -1)
    
    return features_df

