@isTest
private class PositionsHelperTest {
    @TestSetup
    static void makeData(){
        RecruitingTestUtils.createOpenedPositions(4);
        RecruitingTestUtils.createClosedPositions(2);
    }
    @isTest
    static void getPositionsOneArgAllTest() {
        Test.startTest();
        List<Position__c> positions = PositionsHelper.getPositions(PositionsHelper.ALL);
        Test.stopTest();
        System.assertEquals(6, positions.size());
    }
    @isTest
    static void getPositionsOneArgOpenedTest() {
        Test.startTest();
        List<Position__c> positions = PositionsHelper.getPositions(RecruitingTestUtils.OPENED);
        Test.stopTest();
        System.assertEquals(4, positions.size());
    }
    @isTest
    static void getPositionsOneArgErrorStatusTest() {
        Test.startTest();
        try {
            List<Position__c> positions = PositionsHelper.getPositions(RecruitingTestUtils.ERROR_STATUS);
        } catch (Exception e) {
            System.assertEquals(PositionsHelper.STATUS_VALUE_ERROR, e.getMessage());
            System.assertEquals(RecruitingTestUtils.ILLEGAL_ARGUMENT_EXCEPTION, e.getTypeName());
        }
        Test.stopTest();
    }
    @isTest
    static void getPositionsAllFilterTest() {
        Test.startTest();
        List<testtest123__Position__c> positions = PositionsHelper.getPositions(PositionsHelper.ALL, 3, 1);
        Test.stopTest();
        System.assertEquals(3, positions.size());
    }

    @isTest
    static void getPositionsOpenedSecondPageTest() {
        Test.startTest();
        List<Position__c> positions = PositionsHelper.getPositions(RecruitingTestUtils.OPENED, 2, 2);
        Test.stopTest();
        System.assertEquals(2, positions.size());
        System.assertEquals(RecruitingTestUtils.OPENED, positions[0].Status__c);
    }
    @isTest
    static void getPositionsErrorStatusTest() {
        Test.startTest();
        try {
            List<Position__c> positions = PositionsHelper.getPositions(RecruitingTestUtils.ERROR_STATUS, 1, 1);
        } catch (Exception e) {
            System.assertEquals(PositionsHelper.STATUS_VALUE_ERROR, e.getMessage());
            System.assertEquals(RecruitingTestUtils.ILLEGAL_ARGUMENT_EXCEPTION, e.getTypeName());
        }
        Test.stopTest();
    }
    @isTest
    static void getPositionsNegativePositionsPerPageTest() {
        Test.startTest();
        try {
            List<Position__c> positions = PositionsHelper.getPositions(PositionsHelper.ALL, -1, 1);
        } catch (Exception e) {
            System.assertEquals(PositionsHelper.NEGATIVE_RECORDS_PER_PAGE_ERROR, e.getMessage());
            System.assertEquals(RecruitingTestUtils.ILLEGAL_ARGUMENT_EXCEPTION, e.getTypeName());
        }
        Test.stopTest();
    }
    @isTest
    static void getPositionsTooMuchPositionsPerPageTest() {
        Test.startTest();
        try {
            List<Position__c> positions = PositionsHelper.getPositions(PositionsHelper.ALL, 50001, 1);
        } catch (Exception e) {
            System.assertEquals(PositionsHelper.TOO_MUCH_RECORDS_PER_PAGE_ERROR, e.getMessage());
            System.assertEquals(RecruitingTestUtils.ILLEGAL_ARGUMENT_EXCEPTION, e.getTypeName());
        }
        Test.stopTest();
    }
    @isTest
    static void getPositionsErrorCurrentPageTest() {
        Test.startTest();
        try {
            List<Position__c> positions = PositionsHelper.getPositions(PositionsHelper.ALL, 1, 0);
        } catch (Exception e) {
            System.assertEquals(PositionsHelper.CURRENT_PAGE_ERROR, e.getMessage());
            System.assertEquals(RecruitingTestUtils.ILLEGAL_ARGUMENT_EXCEPTION, e.getTypeName());
        }
        Test.stopTest();
    }
    @isTest
    static void updatePositionsTest() {
        Position__c [] positions = PositionsHelper.getPositions(PositionsHelper.ALL, 6, 1);
        for (Position__c position : positions) {
            position.Status__c = RecruitingTestUtils.CLOSED;
        }
        Test.startTest();
        PositionsTableController.updatePositions(positions);
        Test.stopTest();
        System.assertEquals(6, [SELECT COUNT() FROM Position__c WHERE Status__c =: RecruitingTestUtils.CLOSED]);
    }
    @isTest
    static void getPositionsCountAllTest() {
        Test.startTest();
        Integer positionsCount = PositionsHelper.getPositionsCount(PositionsHelper.ALL);
        Test.stopTest();
        System.assertEquals(6, positionsCount);
    }
    @isTest
    static void getPositionsCountOpenedTest() {
        Test.startTest();
        Integer positionsCount = PositionsHelper.getPositionsCount(RecruitingTestUtils.OPENED);
        Test.stopTest();
        System.assertEquals(4, positionsCount);
    }
    @isTest
    static void getPositionsCountErrorStatusTest() {
        Test.startTest();
        try {
            Integer positionsCount = PositionsHelper.getPositionsCount(RecruitingTestUtils.ERROR_STATUS);
        } catch (Exception e) {
            System.assertEquals(PositionsHelper.STATUS_VALUE_ERROR, e.getMessage());
            System.assertEquals(RecruitingTestUtils.ILLEGAL_ARGUMENT_EXCEPTION, e.getTypeName());
        }
        Test.stopTest();
    }
    @isTest
    static void getFilterOptionsTest() {
        Test.startTest();
        List<SelectOption> filterList = PositionsHelper.getFilterOptions();
        Test.stopTest();
        Schema.DescribeFieldResult fieldResult = Position__c.Status__c.getDescribe();
        List<Schema.PicklistEntry> picklistEntry = fieldResult.getPicklistValues();
        System.assertEquals(picklistEntry.size()+1, filterList.size());
    }
    @isTest
    static void hasEditAccessExceptionTest() {
        List<String> fields = new List<String>();
        fields.add(RecruitingTestUtils.UNEDITABLE_FIELD);
        Test.startTest();
            System.assert(!PositionsHelper.hasEditAccess(PositionsHelper.POSITION_OBJECT, fields));
        Test.stopTest();
    }
    @isTest
    static void getPicklistOptionsTest() {
        List<PositionsPicklistFields> fields = new List<PositionsPicklistFields>();
        Test.startTest();
            fields = PositionsHelper.getPicklistOptions();
        Test.stopTest();
        System.assertEquals(3, fields.size());
    }
    @isTest
    static void getPositionDetailFieldsTest() {
        Position__c position = [SELECT Id FROM Position__c LIMIT 1].get(0);
        Test.startTest();
            PositionsFieldsWrapper wrapper = PositionsHelper.getPositionDetailFields(position.Id);
        Test.stopTest();
        System.assertEquals(7, wrapper.fields.size());
    }
    @isTest
    static void getPositionsFilteredOpenedTest() {
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
    static void getPositionsFilteredSearchTest() {
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
                locationList, skillsList, 4, 1, RecruitingTestUtils.TEST_ORDER, 
                RecruitingTestUtils.TEST_LONG_SEARCH_STRING, RecruitingTestUtils.TEST_SEARCH_MODE);
        Test.stopTest();
        System.assertEquals(4, positions.size());
    }
    @isTest
    static void getPositionsFilteredNoClausesTest() {
        List<String> statusList = new List<String>();
        List<String> locationList = new List<String>();
        List<String> skillsList = new List<String>();
        Test.startTest();
        List<PositionsFieldsWrapper> positions = PositionsHelper.getPositionsFiltered(statusList, 
        locationList, skillsList, 10, 1, RecruitingTestUtils.TEST_ORDER, 
        RecruitingTestUtils.TEST_SHORT_SEARCH_STRING, RecruitingTestUtils.TEST_SEARCH_MODE);
        Test.stopTest();
        System.assertEquals(6, positions.size());
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
            Integer positionsCount = PositionsHelper.getPositionsCount(statusList, locationList, 
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
            Integer positionsCount = PositionsHelper.getPositionsCount(statusList, locationList, 
                skillsList);
        Test.stopTest();
        System.assertEquals(6, positionsCount);
    }
    @isTest
    static void getPositionsFilteredSOQLOpenedTest() {
        List<String> statusList = new List<String>();
        List<String> locationList = new List<String>();
        List<String> skillsList = new List<String>();
        statusList.add(RecruitingTestUtils.OPENED);
        locationList.add(RecruitingTestUtils.TEST_LOCATION);
        skillsList.add(RecruitingTestUtils.TEST_SKILL);
        Test.startTest();
            List<Position__c> positions = PositionsHelper.getPositionsFilteredSOQL(statusList, 
                locationList, skillsList, 4, 1, RecruitingTestUtils.TEST_ORDER);
        Test.stopTest();
        System.assertEquals(4, positions.size());
    }
    @isTest
    static void getPositionsFilteredSOQLNoClausesTest() {
        List<String> statusList = new List<String>();
        List<String> locationList = new List<String>();
        List<String> skillsList = new List<String>();
        Test.startTest();
        List<Position__c> positions = PositionsHelper.getPositionsFilteredSOQL(statusList, 
        locationList, skillsList, 10, 1, RecruitingTestUtils.TEST_ORDER);
        Test.stopTest();
        System.assertEquals(6, positions.size());
    }
    @isTest
    static void searchPositionsTest() {
        List<String> statusList = new List<String>();
        List<String> locationList = new List<String>();
        List<String> skillsList = new List<String>();
        statusList.add(RecruitingTestUtils.OPENED);
        statusList.add(RecruitingTestUtils.CLOSED);
        locationList.add(RecruitingTestUtils.TEST_LOCATION);
        skillsList.add(RecruitingTestUtils.TEST_SKILL);
        List<Id> fixedSearchResults= new List<Id>();
        for (testtest123__Position__c position : [SELECT Id FROM testtest123__Position__c]) {
            fixedSearchResults.add(position.Id);
        }
        Test.setFixedSearchResults(fixedSearchResults);
        Test.startTest();
            List<testtest123__Position__c> positions = PositionsHelper.searchPositions(RecruitingTestUtils.TEST_LONG_SEARCH_STRING, 
                RecruitingTestUtils.TEST_SEARCH_MODE,statusList, locationList, skillsList,RecruitingTestUtils.TEST_ORDER);
        Test.stopTest();
        System.assertEquals(4, positions.size());
    }

}