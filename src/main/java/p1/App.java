/*
 * This Java source file was generated by the Gradle 'init' task.
 */
package p1;

import props.Version;

import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

public class App {
    public String getGreeting() {
        return "Hello world.";
    }

    public static void main(String[] args) {
        App app = new App();
        System.out.println("hello world");
        System.out.println("Greeting = " + app.getGreeting());
        System.out.println("Version = " + Version.Version());
    }
}
