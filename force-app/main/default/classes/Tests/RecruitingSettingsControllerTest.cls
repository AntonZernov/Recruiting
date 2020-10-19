@isTest
private class RecruitingSettingsControllerTest {
    @isTest
    static void recruitingSettingsControllerTest() {
        Test.startTest();
        RecruitingSettingsController controller = new RecruitingSettingsController();
        Test.stopTest();
        System.assert(controller.recruitingMetadata.Id != null);
        System.assert(controller.candidateFieldSetOptions.size() > 0);
        System.assert(controller.positionsCardsFieldSetOptions.size() > 0);
        System.assert(controller.positionFilterFieldSetOptions.size() > 0);
        System.assert(controller.positionDetailFieldSetOptions.size() > 0);
        System.assert(!controller.showInaccessibleFields);
    }
    @isTest
    static void getCandidateFieldsListTest() {
        Test.startTest();
        RecruitingSettingsController controller = new RecruitingSettingsController();
        List<PositionsFieldsWrapper> fieldsList = controller.getCandidateFieldsList();
        Test.stopTest();
        System.assert(fieldsList.size() == 6);
    }
    @isTest
    static void getCandidateFieldsListExceptionTest() {
        Test.startTest();
        RecruitingSettingsController controller = new RecruitingSettingsController();
        controller.recruitingMetadata.testtest123__Candidate_fieldset__c = RecruitingTestUtils.TEST_API_NAME;
        List<PositionsFieldsWrapper> fieldsList = controller.getCandidateFieldsList();
        Test.stopTest();
        Boolean caughtError = false;
        for(ApexPages.Message msg :  ApexPages.getMessages()) {
            if (msg.getSummary() == RecruitingSettingsController.ERROR_MESSAGE) {
                caughtError = true;
            }
        }
        System.assert(caughtError);
    }
    @isTest
    static void getPositionsCardsFieldsListTest() {
        Test.startTest();
        RecruitingSettingsController controller = new RecruitingSettingsController();
        List<PositionsFieldsWrapper> fieldsList = controller.getPositionsCardsFieldsList();
        Test.stopTest();
        System.assert(fieldsList.size() == 5);
    }

    @isTest
    static void getPositionsCardsFieldsListExceptionTest() {
        Test.startTest();
        RecruitingSettingsController controller = new RecruitingSettingsController();
        controller.recruitingMetadata.testtest123__Position_fieldset__c = RecruitingTestUtils.TEST_API_NAME;
        List<PositionsFieldsWrapper> fieldsList = controller.getPositionsCardsFieldsList();
        Test.stopTest();
        Boolean caughtError = false;
        for(ApexPages.Message msg :  ApexPages.getMessages()) {
            if (msg.getSummary() == RecruitingSettingsController.ERROR_MESSAGE) {
                caughtError = true;
            }
        }
        System.assert(caughtError);
    }
    @isTest
    static void getPositionFilterFieldsListTest() {
        Test.startTest();
        RecruitingSettingsController controller = new RecruitingSettingsController();
        List<PositionsFieldsWrapper> fieldsList = controller.getPositionFilterFieldsList();
        Test.stopTest();
        System.assert(fieldsList.size() == 5);
    }

    @isTest
    static void getPositionFilterFieldsListExceptionTest() {
        Test.startTest();
        RecruitingSettingsController controller = new RecruitingSettingsController();
        controller.recruitingMetadata.testtest123__Position_filter_fieldset__c = RecruitingTestUtils.TEST_API_NAME;
        List<PositionsFieldsWrapper> fieldsList = controller.getPositionFilterFieldsList();
        Test.stopTest();
        Boolean caughtError = false;
        for(ApexPages.Message msg :  ApexPages.getMessages()) {
            if (msg.getSummary() == RecruitingSettingsController.ERROR_MESSAGE) {
                caughtError = true;
            }
        }
        System.assert(caughtError);
    }
    @isTest
    static void getPositionDetailFieldsListTest() {
        Test.startTest();
        RecruitingSettingsController controller = new RecruitingSettingsController();
        List<PositionsFieldsWrapper> fieldsList = controller.getPositionDetailFieldsList();
        Test.stopTest();
        System.assert(fieldsList.size() == 10);
    }

    @isTest
    static void getPositionDetailFieldsListExceptionTest() {
        Test.startTest();
        RecruitingSettingsController controller = new RecruitingSettingsController();
        controller.recruitingMetadata.testtest123__Position_detail_fields__c = RecruitingTestUtils.TEST_API_NAME;
        List<PositionsFieldsWrapper> fieldsList = controller.getPositionDetailFieldsList();
        Test.stopTest();
        Boolean caughtError = false;
        for(ApexPages.Message msg :  ApexPages.getMessages()) {
            if (msg.getSummary() == RecruitingSettingsController.ERROR_MESSAGE) {
                caughtError = true;
            }
        }
        System.assert(caughtError);
    }


    @isTest
    static void saveTest() {
        Test.startTest();
        RecruitingSettingsController controller = new RecruitingSettingsController();
        controller.recruitingMetadata = null;
        controller.save();
        Test.stopTest();
        Boolean caughtError = false;
        for(ApexPages.Message msg :  ApexPages.getMessages()) {
            if (msg.getSummary() == RecruitingSettingsController.ERROR_MESSAGE) {
                caughtError = true;
            }
        }
        System.assert(caughtError, RecruitingTestUtils.EXCEPTION_NORMAL); 
    }
}