package props;

public class FeatureFlags {
    public static boolean IsFlagSet(String featureFlag) {
        String s =  (String)Version.readProperties("feature-flags.txt").get(featureFlag);
        return Boolean.parseBoolean(s);
    }
}
