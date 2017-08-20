--------------------------------------------------------------------------------------------------------

/*
	
Akcelerant Software Framework Create Database Script

Before running, replace the following strings with proper values:
	
	DB_NAME
	DB_DATAPATH_TYPE  (DEFAULT or PATH)
	DB_DATAFILEPATH	  (Last character must be a slash)
	DB_LOGFILEPATH	  (Last character must be a slash)

*/

--------------------------------------------------------------------------------------------------------


	IF 'DB_DATAPATH_TYPE' = 'DEFAULT'
	BEGIN
		CREATE DATABASE [DB_NAME] 	
	END
	ELSE
	BEGIN	
		CREATE DATABASE [DB_NAME] 
		ON PRIMARY (NAME = N'DB_NAME', FILENAME = N'DB_DATAFILEPATHDB_NAME.mdf')
		LOG ON (NAME = N'DB_NAME_log',  FILENAME = N'DB_LOGFILEPATHDB_NAME_log.ldf')
	END

	exec sp_dboption N'DB_NAME', N'trunc. log on chkpt.', N'true'
	exec sp_dboption N'DB_NAME', N'autoclose', N'false'
	exec sp_dboption N'DB_NAME', N'bulkcopy', N'false'
	exec sp_dboption N'DB_NAME', N'torn page detection', N'true'
	exec sp_dboption N'DB_NAME', N'read only', N'false'
	exec sp_dboption N'DB_NAME', N'dbo use', N'false'
	exec sp_dboption N'DB_NAME', N'single', N'false'
	exec sp_dboption N'DB_NAME', N'autoshrink', N'false'
	exec sp_dboption N'DB_NAME', N'ANSI null default', N'false'
	exec sp_dboption N'DB_NAME', N'recursive triggers', N'false'
	exec sp_dboption N'DB_NAME', N'ANSI nulls', N'false'
	exec sp_dboption N'DB_NAME', N'concat null yields null', N'false'
	exec sp_dboption N'DB_NAME', N'cursor close on commit', N'false'
	exec sp_dboption N'DB_NAME', N'default to local cursor', N'false'
	exec sp_dboption N'DB_NAME', N'quoted identifier', N'false'
	exec sp_dboption N'DB_NAME', N'ANSI warnings', N'false'
	exec sp_dboption N'DB_NAME', N'auto create statistics', N'true'
	exec sp_dboption N'DB_NAME', N'auto update statistics', N'true'
	
	ALTER DATABASE [DB_NAME] SET RECOVERY SIMPLE

	GO
	SET NUMERIC_ROUNDABORT OFF
	GO
	SET ANSI_PADDING, ANSI_WARNINGS, CONCAT_NULL_YIELDS_NULL, ARITHABORT, QUOTED_IDENTIFIER, ANSI_NULLS ON
	GO
