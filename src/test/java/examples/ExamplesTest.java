package examples;

import io.karatelabs.core.Runner;
import io.karatelabs.core.SuiteResult;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;

/**
 * Ejecuta todos los .feature bajo classpath:examples en paralelo.
 * Reporte HTML: target/karate-reports
 */
class ExamplesTest {

    @Test
    void testParallel() {
        SuiteResult result = Runner.path("classpath:examples")
                .tags("~@ignore")
                .outputCucumberJson(true)
                .outputJunitXml(true)
                .parallel(5);
        assertEquals(0, result.getScenarioFailedCount(), "Hay escenarios fallidos");
    }
}
