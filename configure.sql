ALTER SYSTEM SET log_line_prefix = '[ %q%u@%d:%h ][ %Q ]';
SELECT * FROM run_command_on_workers($cmd$ALTER SYSTEM SET log_line_prefix = '[ %q%u@%d:%h ][ %Q ]';$cmd$);
ALTER SYSTEM SET max_worker_processes = 200;
SELECT run_command_on_workers('ALTER SYSTEM SET max_worker_processes = 200;');
SELECT run_command_on_workers('ALTER SYSTEM SET MAX_PREPARED_TRANSACTIONS = 1500;');