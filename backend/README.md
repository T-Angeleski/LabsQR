## Local Development with H2

To run the application with H2:

```bash
./backend.sh h2
```

Access the H2 console at [http://localhost:8080/h2-console](http://localhost:8080/h2-console) and
use `jdbc:h2:mem:timski` as the JDBC URL.

## Running with PostgreSQL

To run the application with PostgreSQL:

```bash
./backend.sh
```

This will use Docker Compose to start the backend and database.
