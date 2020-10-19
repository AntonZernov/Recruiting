@isTest
private class PostInstallClassTest {
    @isTest
    static void testInstallScript() {
        PostInstallClass postinstall = new PostInstallClass();
            Test.testInstall(postinstall, null);
            CronTrigger job = [SELECT Id FROM CronTrigger];
            System.assert(!(job.Id == null));
        }
}