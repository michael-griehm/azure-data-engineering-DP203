# Cosmos DB

## Consistency

The ability of the data to be read once it has been written.

Cosmos DB has 5 different consistency settings, going from strong consistency to weak consistency:

- Strong
- Bounded staleness
- Session
- Consistent prefix
- Eventual

Choice of consistenyc level comes down to cost & availability.

Most other commercial distributed databases only offer Strong and Eventual.

## Partitions

2 types in CosmosDB.

- Logical
- Physical

### Partition Key

Set on the Container and drives how data is stored in the Partitions within the Container.

Distributes the requests and data volume.

## Request Units

The currency for throuput.  A compination of  the CPU, Internal Operations, and Memory needed to complete an operation.

Set on the Containter.

From 400 to 1,000,000 per container.

## APIs

Must be defined at instance creation time.

- Core (SQL) API
  - SQL like
  - Still a non-relational database.
  - No scrict schema.
  - Utilizes JavaScript type, expression evaluation, and function invocation.
  - Provides a Document data model.
- MongoDB API
  - Supports Wire protocol.
  - Use if you already have MongoDB instance and you want to support in Azure.  Otherwise choose Core (SQL) API.
- Cassandra API
  - Provides a columnar data model:
    - Differs from traditional NoSQL in that we can define a data schema up front.
    - Data stored in column orientation.
    - Uses Cassandra Query Language.
- Azure Table API
  - Key-Value model
- Gremlin (graph) API
  - Edges and Nodes (also called Vertex)
  - Useful for:
    - Product-based recommendations
    - User information

## Implementing Security

### Layers of Security

- Network Security
  - Firewalls
- Access Management
  - Azure AD
- Threat Protection
  - Advanced Threat Protection
  - Alerts and Logs
- Information Protection
  - Is the data encrypted?
- Customer Data

### Specifics of CosmosDB Security

- Keys
  - Secure access to Cosmos DB account resources
    - Primary and Secondary Read-Write keys
    - Primary and Secondary Read-Only keys
- Locks
  - Protects environment from accidental deletion or edits
- Advanced Threat Protection
  - Only for Core (SQL) API
  - Detects unusual or harmful attempts to exploit Cosmos DB
  - Integrated with Defender for Cloud
- Alerts and Logs
  - Quicky detect abnormal behavior using your own logic
- Firewalls
  - All Azure Resources
  - IP Ranges
  - Selected VNets
  - Private Endpoints
- Encryption Data and Rest and In-Motion
  - On by default and cannot be turned off

 
