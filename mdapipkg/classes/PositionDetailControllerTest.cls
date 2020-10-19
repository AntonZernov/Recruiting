@isTest
private class PositionDetailControllerTest {
    @TestSetup
    static void makeData(){
        RecruitingTestUtils.createOpenedPositions(1);
        RecruitingTestUtils.createCandidates(1);
    }

    @isTest
    static void getPositionFieldsTest() {
        Position__c position = [SELECT Id FROM Position__c LIMIT 1].get(0);
        Test.startTest();
            PositionsFieldsWrapper wrapper = PositionDetailController.getPositionFields(position.Id);
        Test.stopTest();
        System.assertEquals(7, wrapper.fields.size());
    }
    @isTest
    static void getPositionFieldsExceptionTest() {
        Test.startTest();
            try {
                PositionsFieldsWrapper wrapper = PositionDetailController.getPositionFields(null);
                System.assert(false);
            } catch (Exception e) {
                System.assert(true);
            }
        Test.stopTest();
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
        List<JobApp__c> jobApps = PositionDetailController.getJobApps(position[0].Id);
        Test.stopTest();
        System.assertEquals(1, jobApps.size());
    }
    @isTest
    static void getJobAppsExceptionTest() {
        Test.startTest();
        try {
            List<JobApp__c> jobApps = PositionDetailController.getJobApps(RecruitingTestUtils.TEST_TEXT_FIELD);
            System.assert(false);
        } catch (Exception e) {
            System.assert(true);
        }
        Test.stopTest();
    }
    @isTest
    static void getPositionClosedStatusTest() {
        Test.startTest();
            String statusClosed = PositionDetailController.getPositionClosedStatus();
            Test.stopTest();
            System.assertEquals(PositionsHelper.CLOSED, statusClosed);
    }
}