/*
========================================================================================================================
Create Database and Schemas
=========================================================================================================================
Script purpose:
    This script is meant to setup three schemas(Bronze,Silver,Gold) within the database which has already been created.

  
# Create 'Datawarehouse' Database
  This project is being ran in PostgreSQL which is being ran in a docker container and accessed through DBvear GUI.
  So the database has already been created.
*/

-- Create Datawarehouse schemas

create schema Bronze;
create schema Silver;
create schema Gold;
