package props;

import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

public class Version {
    public static String Version() {
        return (String)readProperties("version.txt").get("version");
    }

    public static Properties readProperties(String name) {
        Properties prop = new Properties();

        InputStream x = Thread.currentThread().getContextClassLoader().getResourceAsStream("version.txt");
        try {
            prop.load(x);
        } catch (IOException e) {
            e.printStackTrace();
            throw new RuntimeException("Cannot read file " + name);
        }
        return prop;
    }
}
