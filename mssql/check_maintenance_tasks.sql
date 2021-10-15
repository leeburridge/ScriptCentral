SELECT
    mp.name AS [MTX Plan Name],
    msp.subplan_name AS [Sub Plan Name],    
    mpl.start_time AS [JobStart],
    mpl.end_time AS [JobEnd],
    mpl.succeeded AS [JobSucceeded]
FROM
    msdb.dbo.sysmaintplan_plans mp
    INNER JOIN msdb.dbo.sysmaintplan_subplans msp ON mp.id = msp.plan_id
    INNER JOIN msdb.dbo.sysmaintplan_log mpl ON msp.subplan_id = mpl.subplan_id
        AND mpl.task_detail_id = -- Get the most recent run for this database
            (SELECT TOP 1 ld.task_detail_id 
            FROM msdb.dbo.sysmaintplan_logdetail ld
            WHERE ld.command LIKE ('%['+db_name()+']%')
            ORDER BY ld.start_time DESC)
