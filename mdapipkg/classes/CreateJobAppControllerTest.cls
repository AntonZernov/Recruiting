@isTest
private class CreateJobAppControllerTest {
    @TestSetup
    static void makeData(){
        RecruitingTestUtils.createCandidates(5);
    }
    @isTest
    static void getCandidatesTest() {
        Test.startTest();
        List<Candidate__c> candidates = CreateJobAppController.getCandidates();
        Test.stopTest();
        System.assertEquals(5, candidates.size());
    }

}