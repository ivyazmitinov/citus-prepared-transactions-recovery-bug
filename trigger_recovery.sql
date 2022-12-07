WITH databases as (SELECT datname FROM pg_database
                   WHERE datname NOT IN ('template1', 'template0'))
SELECT dblink_exec(format('dbname=%s', datname), $cmd$
SELECT recover_prepared_transactions();
COMMIT;
$cmd$)
FROM databases;