CREATE EXTENSION dblink;
ALTER SYSTEM SET citus.recover_2pc_interval TO -1;

SELECT pg_reload_conf();


SELECT * FROM run_command_on_workers($cmd$SELECT pg_reload_conf();$cmd$);

DO
$$
    DECLARE
        i       INTEGER;
        j       INTEGER;
        db_name TEXT;
    BEGIN
        FOR i IN 1..10
            LOOP
                db_name = format('db%s', i);
                RAISE NOTICE 'Preparing database %', db_name;
                PERFORM dblink_exec('dbname=postgres', format('CREATE DATABASE %s', db_name));
                PERFORM dblink_exec('dbname=postgres host=citus-prepared-transactions-recovery-bug-worker', format('CREATE DATABASE %s', db_name));

                PERFORM dblink_exec(format('dbname=%s', db_name), 'CREATE EXTENSION citus;');
                PERFORM dblink_exec(format('dbname=%s host=%s', db_name, 'citus-prepared-transactions-recovery-bug-worker'),
                                    'CREATE EXTENSION citus;');

                PERFORM dblink_exec(format('dbname=%s', db_name),
                                    $cmd$SELECT * FROM citus_add_node('citus-prepared-transactions-recovery-bug-worker', 5432);
                                    COMMIT;
                                    $cmd$);

                PERFORM pg_sleep_for('1 SECONDS'::INTERVAL);

                FOR j IN 1..100
                    LOOP
                        PERFORM dblink_exec(format('dbname=%s host=%s', db_name, 'citus-prepared-transactions-recovery-bug-worker'),
                                            format($cmd$
                                BEGIN;
                                CREATE TABLE should_abort_%2$s (value int);
                                PREPARE TRANSACTION 'citus_0_%1$s_%2$s_should_abort';
                    $cmd$, db_name, j));
                    END LOOP;
                RAISE NOTICE 'Database % is ready!', db_name;
            END LOOP;
    END;
$$;

SELECT pg_sleep_for('5 SECONDS'::INTERVAL);

ALTER SYSTEM SET citus.recover_2pc_interval TO '5s';