```mermaid

graph TD
    %% Data Generation Layer
    subgraph "Data Generation (Local/Edge)"
        PythonSim["Python Sensor Simulator<br/>(Dows Lake, Fifth Avenue, NAC)"]
    end

    %% Cloud Ingestion and Processing Layer
    subgraph "Azure Cloud Platform"
        IoTHub["Azure IoT Hub<br/>(Data Ingestion)"]
        StreamAnalytics["Azure Stream Analytics<br/>(5-min Tumbling Window Aggregation)"]
        
        %% Storage Layer
        CosmosDB[("Azure Cosmos DB<br/>(Real-time Metadata)")]
        BlobStorage["Azure Blob Storage<br/>(Historical Archive JSON)"]
    end

    %% Presentation Layer
    subgraph "Presentation Layer"
        AppService["Azure App Service<br/>(Node.js Backend)"]
        Dashboard["Web Dashboard<br/>(HTML/JS Frontend)"]
    end

    %% Data Flow Connections
    PythonSim -->|JSON via MQTT| IoTHub
    IoTHub --> StreamAnalytics
    StreamAnalytics -->|Aggregated Data| CosmosDB
    StreamAnalytics -->|Raw/Aggregated JSON| BlobStorage
    CosmosDB <-->|Query API| AppService
    AppService --- Dashboard

    ```