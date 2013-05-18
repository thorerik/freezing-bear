declare @job_id uniqueidentifier
,@cmd nvarchar(max)
,@step_id int
,@step_name nvarchar(300)
,@description nvarchar(max)
 
declare job_cursor cursor for select job_id from sysjobs;
 
OPEN job_cursor;
 
FETCH NEXT FROM job_cursor
INTO @job_id;
 
WHILE @@FETCH_STATUS = 0
BEGIN
 
--select * from sysjobschedules where job_id=@job_id
 
select @cmd='------------------------------------------begin job script -----------------------------


BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]]    Script Date: 06/17/2011 13:57:48 ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N''[Uncategorized (Local)]'' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N''JOB'', @type=N''LOCAL'', @name=N''[Uncategorized (Local)]''
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
END
 
DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N''' + [sysjobs].[name]  + ''',
            @enabled=1,
            @notify_level_eventlog=0,
            @notify_level_email=0,
            @notify_level_netsend=0,
            @notify_level_page=0,
            @delete_level=0,
            @description=N''' + [description] + ''',
            @category_name=N''[Uncategorized (Local)]'',
            @owner_login_name=N''sa'', @job_id = @jobid OUTPUT
  '
from
[dbo].[sysjobsteps]INNER JOIN [dbo].[sysjobs]
ON [dbo].[sysjobsteps].[job_id] = [dbo].[sysjobs].[job_id]
where  [dbo].[sysjobs].[job_id]=@job_id
 
print  @cmd
set @cmd=''
declare step_cursor cursor for select step_id from sysjobsteps where job_id=@job_id
open step_cursor
 
fetch next from step_cursor into @step_id
while @@fetch_status=0
begin
 select @cmd='
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N''' +[step_name] + ''',
            @step_id= ' + cast(step_id as varchar(4)) + ' ,
            @cmdexec_success_code=' + cast(cmdexec_success_code as varchar(3)) +  ',
            @on_success_action=' + cast (on_success_action as varchar(2))+',
            @on_success_step_id= ' +cast (on_success_step_id as varchar(2)) +',
            @on_fail_action= ' + cast(on_fail_action as varchar(2)) +',
            @on_fail_step_id=' + cast(on_fail_step_id as varchar(2))+',
            @retry_attempts=' + cast(retry_attempts as varchar(2))+',
            @retry_interval=' + cast(retry_interval as varchar(2))+',
            @os_run_priority=' + cast(os_run_priority as varchar(2))+',  @subsystem=N''' + subsystem +''',
            @command=N''' + command + ''',
            @database_name=N''' + database_name +''',
            @flags=' + cast(flags as varchar(2))+'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:'
from
[dbo].[sysjobsteps]INNER JOIN [dbo].[sysjobs]
ON [dbo].[sysjobsteps].[job_id] = [dbo].[sysjobs].[job_id]
where  [dbo].[sysjobs].[job_id]=@job_id
  
 fetch next from step_cursor
 into @step_id
 
 end
set  @cmd = @cmd + '
------------------------------------------------end of job script-----------------------------------
'
print @cmd
set @cmd=''
close step_cursor
deallocate step_cursor
 
FETCH NEXT FROM job_cursor
INTO @job_id;
 
END

close job_cursor;
deallocate job_cursor