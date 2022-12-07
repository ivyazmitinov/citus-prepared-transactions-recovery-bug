Example of a bug in Citus 11.1.4 and earlier with 2PC transactions recovery.

In order to run you need the `docker-compose` and `psql installed`.

Steps to reproduce:

1. Invoke
    ```shell
    ./reproduce.sh
    ```

2. Observe logs from the coordinator and prepared transactions on the worker
    ```shell
    docker logs -ft citus-prepared-transactions-recovery-bug-coordinator
    ```
   ```shell
   docker exec -it citus-prepared-transactions-recovery-bug-worker psql -P pager=off -c " SELECT * FROM pg_prepared_xacts ;" 
   ```