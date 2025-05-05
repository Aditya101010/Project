-- Create the database for the Thermal Monitoring System
CREATE DATABASE ThermalMonitoring;

-- Use the database
USE ThermalMonitoring;

-- Create a table to store solar panel information
CREATE TABLE Panels (
    PanelID INT PRIMARY KEY AUTO_INCREMENT,
    Location VARCHAR(255) NOT NULL,
    Model VARCHAR(100),
    InstallationDate DATE,
    Status VARCHAR(50) -- e.g., Active, Inactive
);

-- Create a table to store temperature readings for each solar panel
CREATE TABLE TemperatureReadings (
    ReadingID INT PRIMARY KEY AUTO_INCREMENT,
    PanelID INT,
    CellID INT, -- Unique ID for each solar cell on the panel
    Timestamp DATETIME,
    Temperature DECIMAL(5, 2), -- Temperature in Celsius
    FOREIGN KEY (PanelID) REFERENCES Panels(PanelID)
);

-- Create a table to store the panel's calculated statistics
CREATE TABLE PanelStatistics (
    PanelID INT PRIMARY KEY,
    NumberOfCells INT,
    HighestTemperature DECIMAL(5, 2),
    LowestTemperature DECIMAL(5, 2),
    AvgTemperature DECIMAL(5, 2),
    TempDeviation DECIMAL(5, 2), -- Deviation of highest from lowest
    HotspotFound BOOLEAN,
    HotspotTemperature DECIMAL(5, 2), -- Temperature of the hotspot (if found)
    FOREIGN KEY (PanelID) REFERENCES Panels(PanelID)
);

-- Example: Insert panel data
INSERT INTO Panels (Location, Model, InstallationDate, Status)
VALUES
    ('Roof - Sector 1', 'SolarPro 3000', '2022-03-15', 'Active'),
    ('Roof - Sector 2', 'SolarPro 3000', '2022-04-01', 'Active');

-- Example: Insert temperature readings for a panel's cells
INSERT INTO TemperatureReadings (PanelID, CellID, Timestamp, Temperature)
VALUES
    (1, 1, '2025-05-01 10:00:00', 35.5),
    (1, 2, '2025-05-01 10:00:00', 36.0),
    (1, 3, '2025-05-01 10:00:00', 38.0),
    (1, 4, '2025-05-01 10:00:00', 37.5),
    (2, 1, '2025-05-01 10:30:00', 40.0),
    (2, 2, '2025-05-01 10:30:00', 42.0),
    (2, 3, '2025-05-01 10:30:00', 41.0);

-- Example: Calculate panel statistics (highest, lowest, avg temperature, deviation)
INSERT INTO PanelStatistics (PanelID, NumberOfCells, HighestTemperature, LowestTemperature, AvgTemperature, TempDeviation, HotspotFound, HotspotTemperature)
SELECT 
    p.PanelID,
    COUNT(t.CellID) AS NumberOfCells,
    MAX(t.Temperature) AS HighestTemperature,
    MIN(t.Temperature) AS LowestTemperature,
    AVG(t.Temperature) AS AvgTemperature,
    MAX(t.Temperature) - MIN(t.Temperature) AS TempDeviation,
    CASE WHEN MAX(t.Temperature) > 40 THEN TRUE ELSE FALSE END AS HotspotFound,
    CASE WHEN MAX(t.Temperature) > 40 THEN MAX(t.Temperature) ELSE NULL END AS HotspotTemperature
FROM 
    TemperatureReadings t
JOIN 
    Panels p ON t.PanelID = p.PanelID
GROUP BY 
    p.PanelID;

-- Example: Query to retrieve all panel statistics (Highest, Lowest, Deviation, Hotspot info)
SELECT 
    p.Location, 
    ps.HighestTemperature, 
    ps.LowestTemperature, 
    ps.TempDeviation, 
    ps.AvgTemperature, 
    ps.HotspotFound, 
    ps.HotspotTemperature
FROM 
    PanelStatistics ps
JOIN 
    Panels p ON ps.PanelID = p.PanelID;
