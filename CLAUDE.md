# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Proyecto

Pruebas de API con **Karate 2.1.4** sobre **Java 21** y **JUnit 6** (`karate-junit6`), construido con Maven 3.9+. No hay código de producción: todo vive en `src/test/java`. La API de ejemplo es https://jsonplaceholder.typicode.com.

## Comandos

```bash
mvn test                                   # suite completa en paralelo (ExamplesTest)
mvn test -Dkarate.env=qa                   # seleccionar entorno (dev por defecto)
mvn test -Dtest=UsersRunner                # un solo runner / feature
mvn test -Dkarate.options="--tags @smoke"  # filtrar por tags
./run-tests.sh [env] [tags]                # wrapper zsh: ExamplesTest + resumen y aviso por voz (macOS)
```

`run-tests.sh` usa `qa` por defecto (no `dev` como `mvn test`), fuerza `JAVA_HOME` a un JDK 21 vía `/usr/libexec/java_home -v 21` y calcula el resumen leyendo `target/karate-reports/junit-xml/*.xml`, que borra antes de cada ejecución. Si cambias la ruta o el formato de los reportes JUnit, actualiza también el script.

Las pruebas golpean la API real, así que requieren red. jsonplaceholder simula las escrituras (POST/PUT/DELETE responden con éxito pero no persisten): no encadenes escenarios que dependan de datos creados previamente.

Reportes: `target/karate-reports/karate-summary.html` (más Cucumber JSON y JUnit XML). Log completo: `target/karate.log`.

## Arquitectura

- **Los recursos viven junto al código Java.** `pom.xml` declara `src/test/java` como `testResource` (excluyendo `*.java`), así que `.feature`, `.json` y `.js` se colocan en el mismo paquete que sus runners y se leen con rutas relativas (p. ej. `read('create-post.json')`). No uses `src/test/resources`.
- **Configuración global:** `src/test/java/karate-config.js` se ejecuta antes de cada escenario y expone variables globales (`baseUrl`, `env`) y timeouts. Los `baseUrl` por entorno (`qa`, `prod`) se definen ahí —hoy están comentados, así que todos los entornos apuntan a jsonplaceholder—; los features hacen `* url baseUrl` en el `Background`.
- **Dos tipos de runner:**
  - `examples/ExamplesTest.java` — usa `Runner.path("classpath:examples")` con 5 hilos, excluye `@ignore` y falla si hay escenarios fallidos. Es el **único** incluido por Surefire por defecto (`<includes>` en `pom.xml`), por eso `mvn test` no ejecuta los runners individuales dos veces.
  - `*Runner.java` por paquete (`UsersRunner`, `PostsRunner`) — usan `@Karate.Test` + `Karate.run("<feature>").relativeTo(getClass())`; solo se ejecutan con `-Dtest=...`.
- **Agregar un dominio nuevo:** crear `src/test/java/examples/<dominio>/` con su `.feature`, payloads JSON y, opcionalmente, un `<Dominio>Runner.java`. `ExamplesTest` lo detecta automáticamente por estar bajo `classpath:examples`.
- **Tags:** `@smoke` marca escenarios de humo; `@ignore` los excluye de la suite paralela.
- `karate.env` se pasa al JVM de pruebas mediante `systemPropertyVariables` de Surefire.
