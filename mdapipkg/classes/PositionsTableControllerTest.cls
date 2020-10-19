@isTest
private class PositionsTableControllerTest {
    @TestSetup
    static void makeData(){
        RecruitingTestUtils.createOpenedPositions(4);
        RecruitingTestUtils.createClosedPositions(2);
    }

    @isTest
    static void getPositionsAllFilterTest() {
        Test.startTest();
        List<Position__c> positions = PositionsTableController.getPositions(PositionsHelper.ALL, 3, 1);
        Test.stopTest();
        System.assertEquals(3, positions.size());
    }
    @isTest
    static void getPositionsExceptionTest() {
        Test.startTest();
        try {
            List<Position__c> positions = PositionsTableController.getPositions(PositionsHelper.ALL, -1, 1);
            System.assert(false);
        } catch (Exception e) {
            System.assert(true); 
        }
        Test.stopTest();
    }
    @isTest
    static void getPositionsOpenedSecondPageTest() {
        Test.startTest();
        List<Position__c> positions = PositionsTableController.getPositions(RecruitingTestUtils.OPENED, 2, 2);
        Test.stopTest();
        System.assertEquals(2, positions.size());
        System.assertEquals(RecruitingTestUtils.OPENED, positions[0].Status__c);
    }
    @isTest
    static void getPositionsCountAllTest() {
        Test.startTest();
        Integer positionsCount = PositionsTableController.getPositionsCount(PositionsHelper.ALL);
        Test.stopTest();
        System.assertEquals(6, positionsCount);
    }
    @isTest
    static void getPositionsCountOpenedTest() {
        Test.startTest();
        Integer positionsCount = PositionsTableController.getPositionsCount(RecruitingTestUtils.OPENED);
        Test.stopTest();
        System.assertEquals(4, positionsCount);
    }
    @isTest
    static void getPositionsCountExceptionTest() {
        Test.startTest();
        try {
            Integer positionsCount = PositionsTableController.getPositionsCount(RecruitingTestUtils.ERROR_STATUS);
            System.assert(false);
        } catch (Exception e) {
            System.assert(true); 
        }
        Test.stopTest();
    }

    @isTest
    static void updatePositionsTest() {
        Position__c [] positions = PositionsTableController.getPositions(PositionsHelper.ALL, 6, 1);
        for (Position__c position : positions) {
            position.Status__c = RecruitingTestUtils.CLOSED;
        }
        Test.startTest();
        PositionsTableController.updatePositions(positions);
        Test.stopTest();
        System.assertEquals(6, [SELECT COUNT() FROM Position__c WHERE Status__c =: RecruitingTestUtils.CLOSED]);
    }
    @isTest
    static void updatePositionsExceptionTest() {
        Position__c [] positions = PositionsTableController.getPositions(PositionsHelper.ALL, 6, 1);
        positions[0].Location__c = null;
        Test.startTest();
        try {
            PositionsTableController.updatePositions(positions);
            System.assert(false);
        } catch (Exception e) {
            System.assert(true);
        }
        Test.stopTest();
    }
}