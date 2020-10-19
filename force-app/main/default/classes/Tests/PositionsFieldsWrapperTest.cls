@isTest
private class PositionsFieldsWrapperTest {
    @TestSetup
    static void makeData(){
        RecruitingTestUtils.createOpenedPositions(1);
    }
    @isTest 
    static void PositionsFieldsWrapperEmptyConstructorTest() {
        Test.startTest();
        PositionsFieldsWrapper wrapper = new PositionsFieldsWrapper();
        Test.stopTest();
        System.assert(wrapper.fields.size() == 0);
    }
    @isTest 
    static void PositionsFieldsWrapperConstructorTest() {
        Position__c position = [SELECT Name FROM Position__c];
        Test.startTest();
        PositionsFieldsWrapper wrapper = new PositionsFieldsWrapper(position.Name, position.Id);
        Test.stopTest();
        System.assertEquals(position.Id, wrapper.positionId);
        System.assertEquals(position.Name, wrapper.name);
    }
}