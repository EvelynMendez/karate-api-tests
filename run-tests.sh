#!/bin/zsh
# Ejecuta la suite de Karate y avisa en voz alta (macOS) si pasó o falló.
#
# Uso: ./run-tests.sh [ambiente] [tags]
#   ambiente: dev | qa | prod  (por defecto: qa)
#   tags:     tags de Karate, p. ej. @smoke  (opcional)

set -o pipefail

ENV="${1:-qa}"
TAGS="${2:-}"
RUNNER="ExamplesTest"   # examples.ExamplesTest (suite en paralelo)
RATE=150                # palabras por minuto de la voz (la normal es ~180)

cd "${0:A:h}" || exit 1

# El proyecto requiere Java 21; ~/.zshenv puede fijar otra versión en JAVA_HOME.
if [[ "$(uname)" == "Darwin" ]] && JDK21=$(/usr/libexec/java_home -v 21 2>/dev/null); then
  export JAVA_HOME="$JDK21"
fi

START=$SECONDS

mvn_args=(test "-Dtest=${RUNNER}" "-Dkarate.env=${ENV}")
if [[ -n "$TAGS" ]]; then
  mvn_args+=("-Dkarate.options=--tags ${TAGS}")
fi

JUNIT_DIR="target/karate-reports/junit-xml"
rm -rf "$JUNIT_DIR"   # evita contar resultados de una ejecución anterior

echo "▶ mvn ${mvn_args[*]}"
mvn "${mvn_args[@]}"
EXIT_CODE=$?

# Cuenta escenarios a partir de los JUnit XML de Karate (un archivo por feature)
TOTAL=0
FAILED=0
for xml in "$JUNIT_DIR"/*.xml(N); do
  suite=$(grep -o '<testsuite [^>]*>' "$xml" | head -1)
  [[ $suite =~ ' tests="([0-9]+)"' ]]    && (( TOTAL  += match[1] ))
  [[ $suite =~ ' failures="([0-9]+)"' ]] && (( FAILED += match[1] ))
  [[ $suite =~ ' errors="([0-9]+)"' ]]   && (( FAILED += match[1] ))
done
PASSED=$(( TOTAL - FAILED ))

if (( TOTAL == 0 )); then
  MSG="Evelyn, the tests could not run"
  ICON="⚠️ "
elif (( FAILED == 0 && EXIT_CODE == 0 )); then
  MSG="Evelyn, all tests passed"
  ICON="✅"
elif (( PASSED == 0 )); then
  MSG="Evelyn, all tests failed"
  ICON="❌"
else
  MSG="Evelyn, some tests passed and some tests failed"
  ICON="🟡"
fi
echo "${ICON} ${MSG} [${ENV}] — ${PASSED}/${TOTAL} passed, ${FAILED} failed (exit code ${EXIT_CODE})"

speak() {
  [[ "$(uname)" == "Darwin" ]] || return 0
  command -v say >/dev/null 2>&1 || return 0
  if say -v '?' 2>/dev/null | grep -q '^Samantha '; then
    say -v Samantha -r "$RATE" "$1" || true
  else
    say -r "$RATE" "$1" || true
  fi
}
speak "$MSG"

ELAPSED=$(( SECONDS - START ))
printf '⏱  Tiempo total: %dm %02ds\n' $(( ELAPSED / 60 )) $(( ELAPSED % 60 ))

exit $EXIT_CODE
