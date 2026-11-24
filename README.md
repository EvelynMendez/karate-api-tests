# karate-api-tests

Proyecto de pruebas de API con **Karate 2.1.4** (última versión estable) sobre **Java 21 LTS** y **JUnit 6**.

**Repositorio:** https://github.com/EvelynMendez/karate-api-tests

## Clonar
```bash
git clone https://github.com/EvelynMendez/karate-api-tests.git
cd karate-api-tests
```

## Requisitos
- JDK 21 (Karate 2.x requiere Java 21 o superior)
- Maven 3.9+

## Estructura
```
run-tests.sh                  # wrapper: ejecuta la suite, muestra resumen y avisa por voz (macOS)
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

### Script `run-tests.sh`
```bash
./run-tests.sh                # entorno qa, todos los escenarios
./run-tests.sh dev            # otro entorno (dev | qa | prod)
./run-tests.sh qa @smoke      # entorno + tags
```

- Usa `qa` por defecto (a diferencia de `mvn test`, que usa `dev`).
- Ejecuta solo `ExamplesTest` y, en macOS, fija `JAVA_HOME` a un JDK 21.
- Al terminar imprime un resumen (pasados/fallidos y tiempo total), calculado a partir de `target/karate-reports/junit-xml/*.xml`, y lo anuncia por voz con `say` en macOS.

## Reportes
- HTML: `target/karate-reports/karate-summary.html`
- También se generan Cucumber JSON y JUnit XML en `target/karate-reports/`
- Log completo: `target/karate.log`

## Notas sobre la API
La API de ejemplo es https://jsonplaceholder.typicode.com — cambia `baseUrl` en `karate-config.js` por la tuya.

- Las pruebas usan la API real, así que necesitas conexión a internet.
- jsonplaceholder **simula las escrituras**: los POST, PUT y DELETE responden con éxito pero no guardan nada. No encadenes escenarios que dependan de datos creados antes.
