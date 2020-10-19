@isTest
private class PositionsCardsControllerTest {
    @TestSetup
    static void makeData(){
        RecruitingTestUtils.createOpenedPositions(4);
        RecruitingTestUtils.createClosedPositions(4);
    }

    @isTest
    static void getPositionsOpenedTest() {
        List<String> statusList = new List<String>();
        List<String> locationList = new List<String>();
        List<String> skillsList = new List<String>();
        statusList.add(RecruitingTestUtils.OPENED);
        locationList.add(RecruitingTestUtils.TEST_LOCATION);
        skillsList.add(RecruitingTestUtils.TEST_SKILL);
        Test.startTest();
            List<PositionsFieldsWrapper> positions = PositionsHelper.getPositionsFiltered(statusList, 
            locationList, skillsList, 4, 1, RecruitingTestUtils.TEST_ORDER, 
            RecruitingTestUtils.TEST_SHORT_SEARCH_STRING, RecruitingTestUtils.TEST_SEARCH_MODE);
        Test.stopTest();
        System.assertEquals(4, positions.size());
    }
    @isTest
    static void getPositionsNoClausesTest() {
        List<String> statusList = new List<String>();
        List<String> locationList = new List<String>();
        List<String> skillsList = new List<String>();
        Test.startTest();
            List<PositionsFieldsWrapper> positions = PositionsHelper.getPositionsFiltered(statusList, 
            locationList, skillsList, 10, 1, RecruitingTestUtils.TEST_ORDER, 
            RecruitingTestUtils.TEST_SHORT_SEARCH_STRING, RecruitingTestUtils.TEST_SEARCH_MODE);
        Test.stopTest();
        System.assertEquals(8, positions.size());
    }
    @isTest
    static void getPositionsSearchTest() {
        List<String> statusList = new List<String>();
        List<String> locationList = new List<String>();
        List<String> skillsList = new List<String>();
        statusList.add(RecruitingTestUtils.OPENED);
        statusList.add(RecruitingTestUtils.CLOSED);
        locationList.add(RecruitingTestUtils.TEST_LOCATION);
        skillsList.add(RecruitingTestUtils.TEST_SKILL);
        List<Id> fixedSearchResults= new List<Id>();
        for (Position__c position : [SELECT Id FROM Position__c]) {
            fixedSearchResults.add(position.Id);
        }
        Test.setFixedSearchResults(fixedSearchResults);
        Test.startTest();
            List<PositionsFieldsWrapper> positions = PositionsHelper.getPositionsFiltered(statusList, 
                locationList, skillsList, 10, 1, RecruitingTestUtils.TEST_ORDER, 
                RecruitingTestUtils.TEST_LONG_SEARCH_STRING, RecruitingTestUtils.TEST_SEARCH_MODE);
        Test.stopTest();
        System.assertEquals(4, positions.size());
    }

    @isTest
    static void getPositionsExceptionTest() {
        Test.startTest();
        try {
            List<PositionsFieldsWrapper> positions = PositionsCardsController.getPositions(null, 
                null, null, null, null, null, null, null);
            System.assert(false);
        } catch (Exception e) {
            System.assert(true);
        }
        Test.stopTest();
    }
    @isTest
    static void getPositionsCountTest() {
        List<String> statusList = new List<String>();
        List<String> locationList = new List<String>();
        List<String> skillsList = new List<String>();
        statusList.add(RecruitingTestUtils.OPENED);
        locationList.add(RecruitingTestUtils.TEST_LOCATION);
        skillsList.add(RecruitingTestUtils.TEST_SKILL);
        Test.startTest();
            Integer positionsCount = PositionsCardsController.getPositionsCount(statusList, locationList, 
                skillsList);
        Test.stopTest();
        System.assertEquals(4, positionsCount);
    }
    @isTest
    static void getPositionsCountNoClausesTest() {
        List<String> statusList = new List<String>();
        List<String> locationList = new List<String>();
        List<String> skillsList = new List<String>();
        Test.startTest();
            Integer positionsCount = PositionsCardsController.getPositionsCount(statusList, locationList, 
                skillsList);
        Test.stopTest();
        System.assertEquals(8, positionsCount);
    }
    @isTest
    static void getPositionsCountExceptionTest() {
        Test.startTest();
        try {
            Integer positionsCount = PositionsCardsController.getPositionsCount(null, 
                null, null);
            System.assert(false);
        } catch (Exception e) {
            System.assert(true);
        }
        Test.stopTest();
    }
}