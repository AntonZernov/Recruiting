@isTest
private class PositionsPicklistFieldsTest {
    @isTest
    static void PositionsPicklistFieldsConstructorTest() {
        Test.startTest();
        PositionsPicklistFields fields = new PositionsPicklistFields(RecruitingTestUtils.TEST_TEXT_FIELD);
        Test.stopTest();
        System.assertEquals(RecruitingTestUtils.TEST_TEXT_FIELD, fields.name);
    }
}