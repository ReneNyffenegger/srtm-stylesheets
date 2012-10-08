-- This file is licensed CC0 by Andrew Harvey <andrew.harvey4@gmail.com>
--
-- To the extent possible under law, the person who associated CC0
-- with this work has waived all copyright and related or neighboring
-- rights to this work.
-- http://creativecommons.org/publicdomain/zero/1.0/

-- create materialised tables for different elevation levels

-- note that they will be overlapping. so for example the 10m contours
-- will still contain the 100m contours; they are present in both.

-- drop the id column from the table as we don't need it
ALTER TABLE srtm3 DROP COLUMN id;

-- drop any existing tables
DROP TABLE IF EXISTS srtm3_contours_10m;
DROP TABLE IF EXISTS srtm3_contours_50m;
DROP TABLE IF EXISTS srtm3_contours_250m;

-- create the pyramid
CREATE TABLE srtm3_contours_10m AS (
  SELECT * FROM srtm3 WHERE ((ele % 10) = 0)
);

CREATE TABLE srtm3_contours_50m AS (
  SELECT * FROM srtm3_contours_10m WHERE ((ele % 50) = 0)
);

CREATE TABLE srtm3_contours_250m AS (
  SELECT * FROM srtm3_contours_50m WHERE ((ele % 250) = 0)
);

-- create geometry indexes
CREATE INDEX srtm3_contours_10m_geom_idx
  ON srtm3_contours_10m
  USING gist
  (wkb_geometry);

CREATE INDEX srtm3_contours_50m_geom_idx
  ON srtm3_contours_50m
  USING gist
  (wkb_geometry);

CREATE INDEX srtm3_contours_250m_geom_idx
  ON srtm3_contours_250m
  USING gist
  (wkb_geometry);

-- cleanup
VACUUM ANALYZE srtm3_contours_10m;
VACUUM ANALYZE srtm3_contours_50m;
VACUUM ANALYZE srtm3_contours_250m;

-- ensure we have the proper PostGIS metadata for these tables
INSERT INTO geometry_columns(f_table_catalog, f_table_schema, f_table_name, f_geometry_column, coord_dimension, srid, "type") VALUES ('', 'public', 'srtm3_contours_10m', 'wkb_geometry', 2, 900916, 'LINESTRING');
INSERT INTO geometry_columns(f_table_catalog, f_table_schema, f_table_name, f_geometry_column, coord_dimension, srid, "type") VALUES ('', 'public', 'srtm3_contours_50m', 'wkb_geometry', 2, 900916, 'LINESTRING');
INSERT INTO geometry_columns(f_table_catalog, f_table_schema, f_table_name, f_geometry_column, coord_dimension, srid, "type") VALUES ('', 'public', 'srtm3_contours_250m', 'wkb_geometry', 2, 900916, 'LINESTRING');

-- this table isn't really needed anymore more
-- if you are planning to use it for other things though you may want to
-- keep it
DROP TABLE srtm3;

