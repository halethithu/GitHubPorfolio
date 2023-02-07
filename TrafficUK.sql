USE TrafficUK;
GO

/* other way for schema check, explore later
IF NOT EXISTS
(
SELECT SCHEMA_NAME
FROM TrafficUK.INFORMATION_SCHEMA.SCHEMATA
WHERE name = 'stg'
)
exec('CREATE SCHEMA [stg]')
;
GO
*/


--- CREATE schemas
IF NOT EXISTS
(
SELECT * FROM sys.schemas
WHERE name = 'stg'
)
exec('CREATE SCHEMA [stg]')
;
GO

IF NOT EXISTS
(
SELECT * FROM sys.schemas
WHERE name = 'err'
)
exec('CREATE SCHEMA [err]')
;
GO

IF NOT EXISTS
(
SELECT * FROM sys.schemas
WHERE name = 'rpt'
)
exec('CREATE SCHEMA [rpt]')
;
GO

IF NOT EXISTS
(
SELECT * FROM sys.schemas
WHERE name = 'dim'
)
exec('CREATE SCHEMA [dim]')
;
GO

IF NOT EXISTS
(
SELECT * FROM sys.schemas
WHERE name = 'fact'
)
exec('CREATE SCHEMA [fact]')
;
GO
/*
--- Create Table

IF NOT EXISTS (SELECT TABLE_NAME 
      FROM [TrafficUK].INFORMATION_SCHEMA.TABLES 
            WHERE TABLE_TYPE = 'BASE TABLE' and TABLE_NAME = 'RawData'
   )
   exec('
  CREATE TABLE [stg].[RawData] (
     [Count_point_id] int,
    [Direction_of_travel] varchar(50),
    [Year] smallint,
    [Count_date] datetime,
    [hour] smallint,
    [Region_id] smallint,
    [Region_name] varchar(255),
    [Region_ons_code] varchar(255),
    [Local_authority_id] smallint,
    [Local_authority_name] varchar(255),
    [Local_authority_code] varchar(255),
    [Road_name] varchar(100),
    [Road_category] varchar(50),
    [Road_type] varchar(5),
    [Start_junction_road_name] varchar(255),
    [End_junction_road_name] varchar(255),
    [Easting]  varchar(50),
    [Northing] varchar(50),
    [Latitude] varchar(50),
    [Longitude] varchar(50),
    [Link_length_km] real,
    [Link_length_miles] real,
    [Pedal_cycles] bigint,
    [Two_wheeled_motor_vehicles] bigint,
    [Cars_and_taxis] smallint,
    [Buses_and_coaches] bigint,
    [LGVs] smallint,
    [HGVs_2_rigid_axle] bigint,
    [HGVs_3_rigid_axle] bigint,
    [HGVs_4_or_more_rigid_axle] bigint,
    [HGVs_3_or_4_articulated_axle] bigint,
    [HGVs_5_articulated_axle] bigint,
    [HGVs_6_articulated_axle] bigint,
    [All_HGVs] bigint,
    [All_motor_vehicles] bigint
)'

);
GO



TRUNCATE TABLE [stg].[RawData];
GO



--- Create Stg.Traffic
IF NOT EXISTS (SELECT TABLE_NAME 
      FROM [TrafficUK].INFORMATION_SCHEMA.TABLES 
            WHERE TABLE_TYPE = 'BASE TABLE' and TABLE_NAME = 'Traffic'
   )
   exec('
  
	CREATE TABLE [stg].[Traffic](
	[Count_point_id] [int] NULL,
	[Direction_of_travel] [varchar](50) NULL,
	[Year] [smallint] NULL,
	[Count_date] [datetime] NULL,
	[hour] [smallint] NULL,
	[Region_id] [smallint] NULL,
	[Region_name] [varchar](255) NULL,
	[Region_ons_code] [varchar](255) NULL,
	[Local_authority_id] [smallint] NULL,
	[Local_authority_name] [varchar](255) NULL,
	[Local_authority_code] [varchar](255) NULL,
	--[Road_name] [varchar](100) NULL,
	[Road_category] [varchar](50) NULL,
	[Road_type] [varchar](5) NULL,
	[Latitude] [float] NULL,
	[Longitude] [float] NULL,
	[Pedal_cycles] [smallint] NULL,
	[Two_wheeled_motor_vehicles] [smallint] NULL,
	[Cars_and_taxis] [smallint] NOT NULL,
	[Buses_and_coaches] [smallint] NOT NULL,
	[LGVs] [smallint] NULL,
	[HGVs_2_rigid_axle] [bigint] NOT NULL,
	[HGVs_3_rigid_axle] [bigint] NOT NULL,
	[HGVs_4_or_more_rigid_axle] [bigint] NOT NULL,
	[HGVs_3_or_4_articulated_axle] [bigint] NOT NULL,
	[HGVs_5_articulated_axle] [bigint] NOT NULL,
	[HGVs_6_articulated_axle] [bigint] NOT NULL
	)'
);
GO

TRUNCATE TABLE [stg].[Traffic];
GO

INSERT INTO stg.Traffic

SELECT [Count_point_id]
      ,[Direction_of_travel]
      ,[Year]
      ,[Count_date]
      ,[hour]
      ,[Region_id]
      ,[Region_name]
      ,[Region_ons_code]
      ,[Local_authority_id]
      ,[Local_authority_name]
      ,[Local_authority_code]
 --     ,[Road_name]
      ,[Road_category]
      ,[Road_type]
      ,ISNULL([Latitude],0) as [Latitude]
      ,ISNULL([Longitude],0) as [Longitude]
      ,ISNULL([Pedal_cycles],0) as [Pedal_cycles]
      ,ISNULL([Two_wheeled_motor_vehicles],0) as [Two_wheeled_motor_vehicles]
      ,ISNULL([Cars_and_taxis],0) as [Cars_and_taxis]
      ,ISNULL([Buses_and_coaches],0) as [Buses_and_coaches]
      ,ISNULL([LGVs],0) as [LGVs]
      ,ISNULL([HGVs_2_rigid_axle],0) as [HGVs_2_rigid_axle]
      ,ISNULL([HGVs_3_rigid_axle],1) as [HGVs_3_rigid_axle]
      ,ISNULL([HGVs_4_or_more_rigid_axle],0) as [HGVs_4_or_more_rigid_axle]
      ,ISNULL([HGVs_3_or_4_articulated_axle],0) as [HGVs_3_or_4_articulated_axle]
      ,ISNULL([HGVs_5_articulated_axle],0) as [HGVs_5_articulated_axle]
      ,ISNULL([HGVs_6_articulated_axle],0) as [HGVs_6_articulated_axle]
  --INTO stg.Traffic
  FROM [TrafficUK].[stg].[RawData]
  ;
  GO
*/

/*
--- dim Regions
--ScrRegions
IF NOT EXISTS (SELECT TABLE_NAME 
      FROM [TrafficUK].INFORMATION_SCHEMA.TABLES 
            WHERE TABLE_TYPE = 'BASE TABLE' and TABLE_NAME = 'Regions'
   )
   exec('
  
   CREATE TABLE [dim].[Regions](
	[Region_id] [smallint] NULL,
	[Region_name] [varchar](255) NULL,
	[Region_ons_code] [varchar](255) NULL
	--CONSTRAINT PK_Regions PRIMARY KEY ([Region_id])
	)'

);
GO
--Destination Regions:
SELECT distinct [Region_id]
	, [Region_name]
	, [Region_ons_code]
--INTO dim.Regions
FROM [stg].[Traffic]
--ORDER BY 1
*/
--- Local Authority
-- scr Local Au

IF NOT EXISTS (SELECT TABLE_NAME 
      FROM [TrafficUK].INFORMATION_SCHEMA.TABLES 
            WHERE TABLE_TYPE = 'BASE TABLE' and TABLE_NAME = 'Local_Authority'
   )
   exec('
	CREATE TABLE dim.Local_Authority (
	[pk_Local_AuthorityID] [smallint] NOT NULL,
	[Region_id] [smallint] NULL,
	[Region_name] [varchar](255) NULL,
	[Region_ons_code] [varchar](255) NULL,
	[Local_authority_id] [smallint] NULL,
	[Local_authority_name] [varchar](255) NULL,
	[Local_authority_code] [varchar](255) NULL
	CONSTRAINT PK_Local_Authority PRIMARY KEY (pk_Local_AuthorityID)
	)'

);
GO
TRUNCATE TABLE [dim].[Local_Authority];
GO

INSERT INTO dim.Local_Authority

SELECT DISTINCT [Local_authority_id] as pk_Local_AuthorityID
	,[Region_id]
	,[Region_name]
	,[Region_ons_code]
	,[Local_authority_id]
	,[Local_authority_name]
	,[Local_authority_code]
--INTO dim.Local_Authority
FROM [stg].[Traffic]
;
GO

-- Dim Directions

IF NOT EXISTS (SELECT TABLE_NAME 
      FROM [TrafficUK].INFORMATION_SCHEMA.TABLES 
            WHERE TABLE_TYPE = 'BASE TABLE' and TABLE_NAME = 'Directions'
   )
   exec('
	CREATE TABLE [dim].[Directions](
	[Direction_ID] [bigint] NOT NULL,
	[Direction_of_travel] [varchar](50) NULL,
	[Direction_Name] [varchar](8) NOT NULL
	CONSTRAINT PK_Directions PRIMARY KEY (Direction_ID)
	)'

);
GO

TRUNCATE TABLE [dim].[Directions];
GO

WITH DirectionCTE
AS
(
	SELECT DISTINCT [Direction_of_travel]
	,CASE
	WHEN [Direction_of_travel]  in ('C','J') THEN 'Combined'
	WHEN [Direction_of_travel] = 'E' THEN 'East'
	WHEN [Direction_of_travel] = 'W' THEN 'West'
	WHEN [Direction_of_travel] = 'S' THEN 'South'
	WHEN [Direction_of_travel] = 'N' THEN 'North'
	ELSE 'err'
	END as Direction_Name
FROM [stg].[Traffic]
)
--INSERT INTO dim.Directions
SELECT ROW_NUMBER() OVER (ORDER BY [Direction_of_travel] ASC) + 100 as Direction_ID
	,*
--INTO dim.Directions
FROM DirectionCTE
;
GO

--- DIm Hours

IF NOT EXISTS (SELECT TABLE_NAME 
      FROM [TrafficUK].INFORMATION_SCHEMA.TABLES 
            WHERE TABLE_TYPE = 'BASE TABLE' and TABLE_NAME = 'Hours'
   )
   exec('
CREATE TABLE [dim].[Hours](
	[Hour_ID] [bigint] NOT NULL,
	[Hour] [smallint] NULL,
	[Hour_Of_Day] [varchar](9) NOT NULL
	CONSTRAINT PK_Hours PRIMARY KEY ([Hour_ID])
	)'
);

GO

TRUNCATE TABLE [dim].[Hours];
GO

WITH hourCTE
as 
(
SELECT distinct [hour]
	, CASE
	WHEN  [hour] = 0 THEN 'mid-1am'
	WHEN  [hour] = 1 THEN '1am-2am'
	WHEN  [hour] = 2 THEN '2am-3am'
	WHEN  [hour] = 3 THEN '3am-4am'
	WHEN  [hour] = 4 THEN '4am-5am'
	WHEN  [hour] = 5 THEN '5am-6am'
	WHEN  [hour] = 6 THEN '6am-7am'
	WHEN  [hour] = 7 THEN '7am-8am'
	WHEN  [hour] = 8 THEN '8am-9am'
	WHEN  [hour] = 9 THEN '9am-10am'
	WHEN  [hour] = 10 THEN '10am-11am'
	WHEN  [hour] = 11 THEN '11am-noon'
	WHEN  [hour] = 12 THEN 'noon-1pm'
	WHEN  [hour] = 13 THEN '1pm-2pm'
	WHEN  [hour] = 14 THEN '2pm-3pm'
	WHEN  [hour] = 15 THEN '3pm-4pm'
	WHEN  [hour] = 16 THEN '4pm-5pm'
	WHEN  [hour] = 17 THEN '5pm-6pm'
	WHEN  [hour] = 18 THEN '6pm-7pm'
	WHEN  [hour] = 19 THEN '7pm-8pm'
	WHEN  [hour] = 20 THEN '8pm-9pm'
	WHEN  [hour] = 21 THEN '9pm-10pm'
	WHEN  [hour] = 22 THEN '10pm-11pm'
	WHEN  [hour] = 23 THEN '11pm-mid'
	ELSE 'err'
	END as Hour_Of_Day
FROM [stg].[Traffic]
)

-- INSERT INTO dim.[Hours]

SELECT ROW_NUMBER() OVER (ORDER BY hour ASC) + 100 as Hour_ID
	,*
--INTO dim.[Hours]
FROM hourCTE
;
GO

--- Dim Road Cat

IF NOT EXISTS (SELECT TABLE_NAME 
      FROM [TrafficUK].INFORMATION_SCHEMA.TABLES 
            WHERE TABLE_TYPE = 'BASE TABLE' and TABLE_NAME = 'Road_Category'
   )
   exec('
	CREATE TABLE [dim].[Road_Category](
	[Road_Category_ID] [bigint] NOT NULL,
	[Road_category] [varchar](50) NULL,
	[Road_cat_name] [varchar](31) NOT NULL,
	[Road_type] [varchar](5) NULL
	CONSTRAINT PK_Road_Category PRIMARY KEY ([Road_Category_ID])
	)'
);
GO

TRUNCATE TABLE [dim].[Road_Category];
GO

WITH RoadCTE
AS
(
	SELECT distinct [Road_category]
	, CASE
		WHEN [Road_category]  = 'PA' THEN 'Class A Principle Road'
		WHEN [Road_category]  = 'TA' THEN 'Class A Truck Road'
		WHEN [Road_category]  = 'MB' THEN 'Class B Road'
		WHEN [Road_category]  = 'MCU' THEN 'Class C or Unclassified Road'
		WHEN [Road_category]  = 'PM' THEN 'M or Class A Principle Motorway'
		WHEN [Road_category]  = 'TM' THEN 'M or Class A Trunk Motorway'
		ELSE 'err'
	END as Road_cat_name
	, [Road_type]
	FROM [stg].[Traffic]
	)

--INSERT INTO dim.Road_Category

SELECT ROW_NUMBER() OVER (ORDER BY [Road_category] ASC) + 1000 as Road_Category_ID
	,*
--INTO dim.Road_Category
FROM RoadCTE
;
GO

-- DIm Calendar
IF NOT EXISTS (SELECT TABLE_NAME 
      FROM [TrafficUK].INFORMATION_SCHEMA.TABLES 
            WHERE TABLE_TYPE = 'BASE TABLE' and TABLE_NAME = 'Calendar'
   )
   exec('

	CREATE TABLE [dim].[Calendar](
	[DateKey] [int] NOT NULL,
	[Date] [date] NOT NULL,
	[Year] [int] NULL,
	[Quarter] [int] NULL,
	[Month] [int] NULL,
	[MonthName] [nvarchar](30) NULL,
	[MonthAbbrev] [nvarchar](3) NULL,
	[DayName] [nvarchar](30) NULL
	)'
);
GO


ALTER TABLE [dim].[Calendar]
DROP CONSTRAINT if exists [PK_Calendar] ;
GO

TRUNCATE TABLE [dim].[Calendar];
GO

ALTER TABLE [dim].[Calendar]
ADD CONSTRAINT PK_Calendar PRIMARY KEY ([DateKey]);
GO

WITH calCTE (d)
as
(
SELECT cast('20000101' as Date) -- Start date
UNION ALL
SELECT DATEADD(DAY,1,d)
FROM calCTE
WHERE d < cast('20221231' as Date) -- End date
)
INSERT INTO dim.Calendar 
SELECT 
		DateKey		 = CAST(REPLACE(CONVERT(varchar(10), d),'-','') as INT),
		[Date]			= d,
		Year         = DATEPART(YEAR,      d),
		Quarter      = DATEPART(Quarter,   d),
		Month        = DATEPART(MONTH,     d),
		MonthName    = DATENAME(MONTH,     d),
		MonthAbbrev  = LEFT(DATENAME(MONTH, d),3),
		DayName      = DATENAME(WEEKDAY,   d)
--INTO dim.Calendar 
FROM calCTE
ORDER BY d ASC
OPTION (MAXRECURSION 0)
;

----Fact Table

IF NOT EXISTS (SELECT TABLE_NAME 
      FROM [TrafficUK].INFORMATION_SCHEMA.TABLES 
            WHERE TABLE_TYPE = 'BASE TABLE' and TABLE_NAME = 'fTraffic'
   )
   exec('
CREATE TABLE [fact].[fTraffic](
	[Count_point_id] [int] NULL,
	[Direction_ID] [bigint]  NULL,
	[DateKey] [int]  NULL,
	[Hour_ID] [bigint]  NULL,
	[pk_Local_AuthorityID] [smallint]  NULL,
	[Road_Category_ID] [bigint]  NULL,
	[Latitude] [float]  NULL,
	[Longitude] [float]  NULL,
	[Pedal_cycles] [smallint]  NULL,
	[Two_wheeled_motor_vehicles] [smallint]  NULL,
	[Cars_and_taxis] [smallint]  NULL,
	[Buses_and_coaches] [smallint]  NULL,
	[LGVs] [smallint]  NULL,
	[HGVs_2_rigid_axle] [bigint]  NULL,
	[HGVs_3_rigid_axle] [bigint]  NULL,
	[HGVs_4_or_more_rigid_axle] [bigint]  NULL,
	[HGVs_3_or_4_articulated_axle] [bigint]  NULL,
	[HGVs_5_articulated_axle] [bigint]  NULL,
	[HGVs_6_articulated_axle] [bigint]  NULL
	)'
);
GO 

--- Drop FK
GO

ALTER TABLE [fact].[fTraffic]
DROP CONSTRAINT if exists [FK_Date] ;
GO
ALTER TABLE [fact].[fTraffic]
DROP CONSTRAINT if exists [FK_Direction] ;
GO
ALTER TABLE [fact].[fTraffic]
DROP CONSTRAINT if exists [FK_Hours] ;
GO
ALTER TABLE [fact].[fTraffic]
DROP CONSTRAINT if exists [FK_Local_Authority] ;
GO
ALTER TABLE [fact].[fTraffic]
DROP CONSTRAINT if exists [FK_Road_Category] ;
GO

TRUNCATE TABLE [fact].[fTraffic];
GO

INSERT INTO [fact].[fTraffic]


SELECT [Count_point_id]
	, d.Direction_ID
	, cal.DateKey
	, h.Hour_ID
	, la.pk_Local_AuthorityID
	, r.Road_Category_ID
      ,f.[Latitude]
      ,f.[Longitude]
      ,f.[Pedal_cycles]
      ,f.[Two_wheeled_motor_vehicles]
      ,f.[Cars_and_taxis]
      ,f.[Buses_and_coaches]
      ,f.[LGVs]
      ,f.[HGVs_2_rigid_axle]
      ,f.[HGVs_3_rigid_axle]
      ,f.[HGVs_4_or_more_rigid_axle]
      ,f.[HGVs_3_or_4_articulated_axle]
      ,f.[HGVs_5_articulated_axle]
      ,f.[HGVs_6_articulated_axle]
---INTO fact.fTraffic
FROM [stg].[Traffic] f -- 4,657,464
	INNER JOIN [dim].[Calendar] cal
	ON f.Count_date = cal.Date
	INNER JOIN [dim].[Directions] d
	ON f.Direction_of_travel = d.Direction_of_travel
	INNER JOIN [dim].[Hours] h
	ON f.hour = h.hour
	INNER JOIN [dim].[Local_Authority] la
	ON f.Local_authority_id = la.Local_authority_id
	INNER JOIN [dim].[Road_Category] r
	ON f.Road_category = r.Road_category
;
GO


---Create FK Transactions

GO
ALTER TABLE [fact].[fTraffic]
ADD CONSTRAINT FK_Date
FOREIGN KEY ([DateKey]) REFERENCES [dim].[Calendar] ([DateKey]);
GO

ALTER TABLE [fact].[fTraffic]
ADD CONSTRAINT FK_Direction
FOREIGN KEY ([Direction_ID]) REFERENCES [dim].[Directions] ([Direction_ID]);
GO

ALTER TABLE [fact].[fTraffic]
ADD CONSTRAINT FK_Hours
FOREIGN KEY ([Hour_ID]) REFERENCES [dim].[Hours] ([Hour_ID]);
GO

ALTER TABLE [fact].[fTraffic]
ADD CONSTRAINT FK_Local_Authority
FOREIGN KEY ([pk_Local_AuthorityID]) REFERENCES [dim].[Local_Authority] ([pk_Local_AuthorityID]);
GO

ALTER TABLE [fact].[fTraffic]
ADD CONSTRAINT FK_Road_Category
FOREIGN KEY ([Road_Category_ID]) REFERENCES  [dim].[Road_Category] ([Road_Category_ID]);
GO


