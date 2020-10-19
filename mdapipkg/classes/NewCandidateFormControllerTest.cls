@isTest
private class NewCandidateFormControllerTest {
    @isTest
    static void getFieldSetValuesTest() {
        Test.startTest();
        List<String> fieldSetValues = NewCandidateFormController.getFieldNames();
        Test.stopTest();
        System.assert(fieldSetValues.size() == 6);
    }
}