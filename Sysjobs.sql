select job_id, count(*)

from sysjobschedules join

sysschedules on [sysjobschedules].[schedule_id]=[sysschedules].[schedule_id]
group by job_id
