# karate-api-tests

Proyecto de pruebas de API con **Karate 2.1.4** (última versión estable) sobre **Java 21 LTS** y **JUnit 6**.

## Requisitos
- JDK 21 (Karate 2.x requiere Java 21 o superior)
- Maven 3.9+

## Estructura
```
src/test/java
├── karate-config.js          # configuración global (baseUrl, entornos, timeouts)
├── logback-test.xml          # logging
└── examples
    ├── ExamplesTest.java     # suite completa en paralelo
    ├── users
    │   ├── users.feature
    │   └── UsersRunner.java  # runner individual
    └── posts
        ├── posts.feature
        ├── create-post.json
        └── PostsRunner.java
```

## Ejecución
```bash
mvn test                                   # suite completa en paralelo
mvn test -Dkarate.env=qa                   # con entorno
mvn test -Dtest=UsersRunner                # un solo runner
mvn test -Dkarate.options="--tags @smoke"  # por tags
```

Reporte HTML: `target/karate-reports/karate-summary.html`

La API de ejemplo es https://jsonplaceholder.typicode.com — cambia `baseUrl` en `karate-config.js` por la tuya.
