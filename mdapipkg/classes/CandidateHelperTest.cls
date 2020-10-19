@isTest
private class CandidateHelperTest {
    @TestSetup
    static void makeData(){
        RecruitingTestUtils.createCandidates(5);
        
    }

    @isTest
    static void getCandidatesTest() {
        Test.startTest();
        List<testtest123__Candidate__c> candidates = CandidateHelper.getCandidates();
        Test.stopTest();
        System.assertEquals(5, candidates.size());
    }


    @isTest
    static void getFieldNamesTest() {
        Test.startTest();
        List<String> namesList = CandidateHelper.getFieldNames();
        Test.stopTest();
        System.assert(namesList.size() == 6);
    }
    @isTest
    static void getFieldLabelsAllTest() {
        String fieldSetApiName = 
            SettingsHelper.getRecruitingMetadata().testtest123__Candidate_fieldset__c;
        Test.startTest();
        List<PositionsFieldsWrapper> labelsList = CandidateHelper.getFieldLabels(fieldSetApiName, false);
        Test.stopTest();
        System.assert(labelsList.size() == 6);
    }
    @isTest
    static void getFieldSetMemberListTest() {
        String fieldSetApiName = 
            SettingsHelper.getRecruitingMetadata().testtest123__Candidate_fieldset__c;
        Test.startTest();
        List<Schema.FieldSetMember> fieldSetMembersList = CandidateHelper.getFieldSetMemberList(fieldSetApiName);
        Test.stopTest();
        System.assert(fieldSetMembersList.size() == 6);
    }
    @isTest
    static void getFieldSetSelectOptionsTest() {
        Test.startTest();
        List<SelectOption> optionsList = CandidateHelper.getFieldSetSelectOptions();
        Test.stopTest();
        System.assert(optionsList.size() > 0);
    }
    public static testMethod void isFieldAccessibleTest() {
        Boolean isNameAccessible;
        Boolean isBirthDateAccessible;
        User standardEmployee = RecruitingTestUtils.createStandartEmployee();
 
        System.runAs(standardEmployee) {
            Test.startTest();
                isNameAccessible = CandidateHelper.isFieldAccessible(RecruitingTestUtils.CANDIDATE_OBJECT, 
                    RecruitingTestUtils.NAME_FIELD);
                isBirthDateAccessible = CandidateHelper.isFieldAccessible(RecruitingTestUtils.CANDIDATE_OBJECT, 
                RecruitingTestUtils.BIRTH_DATE_FIELD);
            Test.stopTest();
          }
        System.assert(isNameAccessible);
        System.assert(!isBirthDateAccessible);
    }

    public static testMethod void getFieldLabelsAccesibleTest() {
        String fieldSetApiName = 
            SettingsHelper.getRecruitingMetadata().testtest123__Candidate_fieldset__c;
        List<PositionsFieldsWrapper> labelsList = new List<PositionsFieldsWrapper>();
        User standardEmployee = RecruitingTestUtils.createStandartEmployee();
 
        System.runAs(standardEmployee) {
            Test.startTest();
                labelsList = CandidateHelper.getFieldLabels(fieldSetApiName, true);
            Test.stopTest();
          }
        System.assertEquals(4, labelsList.size());
    }
}