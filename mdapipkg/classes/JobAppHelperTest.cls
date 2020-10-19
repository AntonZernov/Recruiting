@isTest
private class JobAppHelperTest {
    @TestSetup
    static void makeData(){
        RecruitingTestUtils.createOpenedPositions(1);
        RecruitingTestUtils.createCandidates(1);
    }

    @isTest
    static void getJobAppsTest() {
        List<Position__c> position = [SELECT Id FROM Position__c];
        List<Candidate__c> candidade = [SELECT Id FROM Candidate__c];
        JobApp__c jobApp = new JobApp__c();
        jobApp.Stage__c = RecruitingTestUtils.FIRST_STAGE;
        jobApp.Resume__c = RecruitingTestUtils.TEST_URL;
        jobApp.Candidate__c = candidade[0].Id;
        jobApp.Position__c = position[0].Id;
        insert jobApp;
        Test.startTest();
        List<JobApp__c> jobApps = JobAppHelper.getJobApps(position[0].Id);
        Test.stopTest();
        System.assertEquals(1, jobApps.size());
    }

}