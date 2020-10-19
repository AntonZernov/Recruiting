@isTest
private class PositionsOptionsTest {
    @isTest 
    static void PositionsOptionsConstructorTest() {
        Test.startTest();
        PositionsOptions options = new PositionsOptions(RecruitingTestUtils.CLOSED, RecruitingTestUtils.TEST_TEXT_FIELD);
        Test.stopTest();
        System.assertEquals(RecruitingTestUtils.CLOSED, options.label);
        System.assertEquals(RecruitingTestUtils.TEST_TEXT_FIELD, options.value);
    }
}