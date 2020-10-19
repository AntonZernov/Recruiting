@isTest
private class JobAppTriggerTest {
    @TestSetup
    static void makeData(){
        RecruitingTestUtils.createJobApps(201);
    }

    @isTest
    static void closePositionsTest() {
        List<JobApp__c> jobApps = [SELECT Id, Stage__c FROM JobApp__c];
        Boolean isAllPositionsClosed = true;
        for (JobApp__c jobApp : jobApps) {
            jobApp.Stage__c = PositionsHelper.HIRED;
        }
        Test.startTest();
        update jobApps;
        Test.stopTest();
        List<Position__c> positions = [SELECT Status__c FROM Position__c];
        for (Position__c position : positions) {
            if (position.Status__c != PositionsHelper.CLOSED) {
                isAllPositionsClosed = false;
            }
        }
        System.assert(isAllPositionsClosed);
    }

}