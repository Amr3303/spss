﻿* Encoding: UTF-8.
BEGIN PROGRAM.
import spss
import spssdata

def load_data():
    """Load data from SPSS into a Python list and convert it to wide format."""
    dataset = spssdata.Spssdata()
    data = []
    for row in dataset:
        data.append([row[0], row[1], row[2]])  # Assuming columns A, B, and values (index 0, 1, 2)
    dataset.close()
    
    # Convert long format data to wide format
    wide_table, row_labels, col_labels = long_to_wide(data)
    return wide_table, row_labels, col_labels

def long_to_wide(data):
    """Convert long format data to wide format."""
    # Step 1: Get all unique row and column labels
    row_labels = sorted(set(entry[0] for entry in data))  # Sort row labels numerically or lexicographically
    col_labels = sorted(set(entry[1] for entry in data))

    # Step 2: Create lookup dictionary for fast access
    lookup = {(row, col): val for row, col, val in data}

    # Step 3: Build wide-format list of lists
    wide_table = []
    for row in row_labels:
        row_data = []
        for col in col_labels:
            value = lookup.get((row, col), None)
            row_data.append(value)
        wide_table.append(row_data)
    
    return wide_table, row_labels, col_labels

def compute_missing_value(data, missing_row, missing_col):
    """Compute the missing value using the formula."""
    
    # Count the total number of rows
    r = len(data)
    print("Total rows (r):", r)    
    
    # Count the total number of columns
    c = len(data[0]) if data else 0
    print("Total columns (c):", c)
        
    # Compute row and column totals (R and C), and grand total (G)
    R = sum(data[missing_row][j] for j in range(len(data[0])) if data[missing_row][j] is not None)
    print("R sum = ", R)
    
    C = sum(data[i][missing_col] for i in range(len(data)) if data[i][missing_col] is not None)
    print("C sum = ", C)
    
    G = sum(sum(value for value in data[i] if value is not None) for i in range(len(data)))  # Grand total, ignoring None
    print("G sum = ", G)
    
    # Compute the missing value using the formula
    if (r - 1) * (c - 1) != 0:  # Avoid division by zero
        x_hat = (r * R + c * C - G) / ((r - 1) * (c - 1))
        print("x_hat = ", x_hat)
    else:
        x_hat = None  # Return None if division by zero occurs
    
    return x_hat
 
def main():
    
    # Load the data and convert it to wide format
    data, row_labels, col_labels = load_data()
    print("Wide Format Data: ")
    print(data)
    
    # Find the missing value position if exists
    missing_row, missing_col = find_missing_value(data)
    
    # Make sure to check first if there is a missing value or no
    if missing_row is None:
        print("No missing values are found.")
        return
     
    print("Missing Row: ", missing_row , " Missing Column: ", missing_col)
    
    # Compute the missing value
    estimated_value = compute_missing_value(data, missing_row, missing_col)
    
    if estimated_value is not None: 
        print("The estimated value = ", estimated_value)
    else:
        print("Unable to compute the missing value, boo hoo")
        
main()
END PROGRAM.
