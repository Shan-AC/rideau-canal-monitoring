-- Generated with the assistance of AI Gemini

-- Query 1: Calculate metrics and send to Cosmos DB for the real-time dashboard
-- Using a 5-minute Tumbling Window as required by the project specifications
SELECT
    location,
    -- Generate a unique 'id' required by Cosmos DB (Location + Timestamp)
    CONCAT(location, '-', CAST(System.Timestamp() AS nvarchar(max))) AS id,
    System.Timestamp() AS windowEnd,
    AVG(ice_thickness) AS avg_ice_thickness,
    MIN(ice_thickness) AS min_ice_thickness,
    MAX(ice_thickness) AS max_ice_thickness,
    AVG(surface_temperature) AS avg_surface_temp,
    MIN(surface_temperature) AS min_surface_temp,
    MAX(surface_temperature) AS max_surface_temp,
    MAX(snow_accumulation) AS max_snow_accumulation,
    AVG(external_temperature) AS avg_external_temp,
    COUNT(*) AS reading_count
INTO
    [CosmosDBOutput]
FROM
    [IoTHubInput] TIMESTAMP BY timestamp
GROUP BY
    location,
    TumblingWindow(minute, 5)

-- Query 2: Send the exact same aggregated data to Blob Storage for historical archiving
SELECT
    location,
    System.Timestamp() AS windowEnd,
    AVG(ice_thickness) AS avg_ice_thickness,
    MIN(ice_thickness) AS min_ice_thickness,
    MAX(ice_thickness) AS max_ice_thickness,
    AVG(surface_temperature) AS avg_surface_temp,
    MIN(surface_temperature) AS min_surface_temp,
    MAX(surface_temperature) AS max_surface_temp,
    MAX(snow_accumulation) AS max_snow_accumulation,
    AVG(external_temperature) AS avg_external_temp,
    COUNT(*) AS reading_count
INTO
    [BlobStorageOutput]
FROM
    [IoTHubInput] TIMESTAMP BY timestamp
GROUP BY
    location,
    TumblingWindow(minute, 5)