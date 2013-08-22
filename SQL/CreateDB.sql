USE master;
GO
CREATE DATABASE test
ON
( NAME = test_dat,
	FILENAME = 'C:\data\testdat.mdf',
	SIZE = 10,
	MAXSIZE = 50,
	FILEGROWTH = 5 )
	LOG ON
( NAME = test_log,
	FILENAME = 'C:\data\testlog.ldf',
	SIZE = 5MB,
	MAXSIZE = 25MB,
	FILEGROWTH = 5MB );
GO