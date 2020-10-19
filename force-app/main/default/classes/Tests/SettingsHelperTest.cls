@isTest
private class SettingsHelperTest {
    @isTest
    static void getRecruitingMetadataTest() {
        Test.startTest();
        testtest123__Recruiting_Settings__mdt recruitingMetadata = 
            SettingsHelper.getRecruitingMetadata();
        Test.stopTest();
        System.assert(recruitingMetadata.Id != null);
    }
    @isTest
    static void createCustomMetadataTest() {
        testtest123__Recruiting_Settings__mdt recruitingMetadata = 
            SettingsHelper.getRecruitingMetadata();
        Test.startTest();
        Metadata.CustomMetadata customMetadata = SettingsHelper.createCustomMetadata(recruitingMetadata);
        Test.stopTest();
        System.assertEquals(SettingsHelper.RECRUITING_METADATA_FULLNAME, customMetadata.fullName);
    }
    @isTest
    static void createMetadataContainerTest() {
        testtest123__Recruiting_Settings__mdt recruitingMetadata = 
            SettingsHelper.getRecruitingMetadata();
        Test.startTest();
        Metadata.DeployContainer container = SettingsHelper.createMetadataContainer(recruitingMetadata);
        Test.stopTest();
        List<Metadata.Metadata> contents = container.getMetadata();
        Metadata.Metadata customMetadata = contents.get(0);
        System.assert(contents.size() == 1);
        System.assertEquals(SettingsHelper.RECRUITING_METADATA_FULLNAME, customMetadata.fullName);
    }
}