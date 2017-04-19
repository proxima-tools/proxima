package template.load.test;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.InputStream;

import org.junit.Test;

public class TemplateLoadTest {
    @Test
    public void testTemplate() throws FileNotFoundException {
        File template = new File("templates\\processtemplate");
        InputStream inputStream = new FileInputStream(template);

        System.out.println(inputStream);
    }
}
