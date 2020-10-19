@isTest
private class NewJobAppFormControllerTest {
    @TestSetup
    static void makeData(){
        RecruitingTestUtils.createOpenedPositions(4);
        RecruitingTestUtils.createClosedPositions(2);
    }
    @isTest
    static void getOpenedPositionsTest() {
        Test.startTest();
        List<Position__c> positions = NewJobAppFormController.getOpenedPositions();
        Test.stopTest();
        System.assertEquals(4, positions.size());
    }
}