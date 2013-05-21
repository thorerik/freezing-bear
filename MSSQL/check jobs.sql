use <msdb_name>
go
declare @job_id uniqueidentifier
declare job_cursor cursor for select job_id from sysjobs;

OPEN job_cursor;

FETCH NEXT FROM job_cursor
INTO @job_id;
WHILE @@FETCH_STATUS = 0
BEGIN


SELECT [sysjobs].[name] AS N'job_name',
[sysjobsteps].step_id
,[sysjobsteps].[step_name],[sysjobsteps].[command] AS N'step_command'
,[sysjobsteps].[database_name],[sysjobsteps].[output_file_name],[sysjobsteps].[last_run_date]
,[sysjobsteps].[last_run_time]FROM [dbo].[sysjobsteps]INNER JOIN [dbo].[sysjobs]
ON [dbo].[sysjobsteps].[job_id] = [dbo].[sysjobs].[job_id]
where  [dbo].[sysjobs].[job_id]=@job_id

select * from sysjobschedules where job_id=@job_id

FETCH NEXT FROM job_cursor
INTO @job_id;

END
close job_cursor;
deallocate job_cursor
