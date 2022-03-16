# Azure SQL Server

## Data Masking

- Real-time data masking, underlying data in the table on disk is not changed.
- Limit sensitive data exposure by masking it to non-privileged users
- Masking Logic:
  - Default - all the data will be replaced by X's or 0's
  - Email - first letter, rest will be X's followed by the .com (or whatever domain it is)
  - Random - used for numeric, take a set of numbers and replace them with a random string.
  - Credit Card

### Warning

Users can still discern what the data could be by using WHERE clause to search for ranges, say for Salary.
