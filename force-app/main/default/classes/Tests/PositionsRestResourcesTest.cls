@isTest
private class PositionsRestResourcesTest {
    @TestSetup
    static void makeData(){
        RecruitingTestUtils.createOpenedPositions(2);
        RecruitingTestUtils.createClosedPositions(3);
    }
    @isTest
    static void getPositionsTest() {
        Test.startTest();
        List<Position__c> positions = PositionsRestResource.getPositions('All', 5, 1);
        Test.stopTest();
        System.assertEquals(5, positions.size());
    }

    @isTest
    static void positionsCountTest() {
        RestRequest request = new RestRequest();
        request.requestUri = URL.getOrgDomainUrl() + '/services/apexrest/Positions/' + 'All';
        request.httpMethod = 'GET';
        RestContext.request = request;
        Test.startTest();
        Integer positionsCount = PositionsRestResource.getPositionsCount();
        Test.stopTest();
        System.assertEquals(5, positionsCount);
    }

    @isTest
    static void positionsUpdateTest() {
        List<Position__c> positions = [SELECT Status__c FROM Position__c];
        for (Position__c position : positions) {
            position.Status__c = 'Closed';
        }
        Test.startTest();
        PositionsRestResource.updatePositions(positions);
        positions = [SELECT Id FROM Position__c WHERE Status__c = 'Closed'];
        System.assertEquals(5, positions.size());

    }
}