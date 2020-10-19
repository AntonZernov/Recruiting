@isTest
private  class PositionTriggerTest {
    @TestSetup
    static void makeData(){
        RecruitingTestUtils.createOpenedPositions(201);
    }
    @isTest
    static void setDateClosedTest() {
        Boolean isAllDatesCorrect = true;
        List<Position__c> positions = [SELECT Status__c FROM Position__c WHERE Status__c =:RecruitingTestUtils.OPENED];
        for (Position__c position : positions) {
            position.Status__c = RecruitingTestUtils.CLOSED;
        }
        Test.startTest();
        PositionsHelper.updatePositions(positions);
        Test.stopTest();
        positions = [SELECT Date_Closed__c FROM Position__c WHERE Status__c =:RecruitingTestUtils.CLOSED];
        for (Position__c position : positions) {
            if (position.Date_Closed__c != Date.today()) {
                isAllDatesCorrect = false;
            }
        }
        System.assert(isAllDatesCorrect);
    }
}