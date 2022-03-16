# azure-data-engineer-DP200

A repo with notes and examples of the resources encapsulated in the Azure Data Engineer (DP-200) course.

## Basic Concepts

### ETL vs. ELT

- Extract Transform Load
  - Transform data before it is persisted to data store.
  - Not good for big data, especially if not all the data needs to be analyzed and transformed.
  - Generally used with SQL Server, possibly also with Azure Synase Data Pool (Azure SQL DW)
- Extract Load Transform
  - Get data in its raw state into a storage zone, then analyze and transform only the data needed for a report, decision model, etc...
  - When you want to store exabytes of data for latter analysis and unknown purposes.
  - Generally used with Azure Data Factory & Azure Data Lake Gen 2.  USe Data Factory's 90+ data source providers to move data from source into Data Lake into the Raw data zone.  Then use Data Factory and/or Data Bricks to transform and place into the Bronze, Silver, and Gold zones and hierarchies.

### The CAP Theorem

In theoretical computer science, the CAP theorem, also named Brewer's theorem after computer scientist Eric Brewer, states that any distributed data store can only provide two of the following three guarantees:

- Consistency
  - Every read receives the most recent write or an error.
- Availibility
  - Every request receives a (non-error) response, without the guarantee that it contains the most recent write.
- Partition Tolerance
  - The system continues to operate despite an arbitrary number of messages being dropped (or delayed) by the network between nodes.

When a network partition failure happens, it must be decided whether to:
  
- cancel the operation and thus decrease the availability but ensure consistency 
or
- proceed with the operation and thus provide availability but risk inconsistency

Thus, if there is a network partition, one has to choose between consistency and availability. Note that consistency as defined in the CAP theorem is quite different from the consistency guaranteed in ACID database transactions.

Eric Brewer argues that the often-used "two out of three" concept can be somewhat misleading because system designers only need to sacrifice consistency or availability in the presence of partitions, but that in many systems partitions are rare.

## Batch Processing

A method for running high volume, repetetive jobs.

![Batch Processing Overview](images/databricks/batch-processing-overview.png)

## Stream Processing

![Streaming Overview](images/stream-analytics/streaming-overview.png)
