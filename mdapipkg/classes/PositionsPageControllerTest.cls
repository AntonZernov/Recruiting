@isTest
private class PositionsPageControllerTest {
    @TestSetup
    static void makeData(){
        RecruitingTestUtils.createOpenedPositions(2);
        RecruitingTestUtils.createClosedPositions(2);
    }

    @isTest
    static void positionsPageControllerTest() {
        Test.startTest();
        PositionsPageController posPageCtrl = new PositionsPageController();
        Test.stopTest();
        System.assert(posPageCtrl.filter == PositionsHelper.ALL);
        System.assertEquals(4, posPageCtrl.positionsList.size());
        System.assertEquals(3, posPageCtrl.filterList.size());
    }

    @isTest
    static void changePositionsListTest() {
        PositionsPageController posPageCtrl = new PositionsPageController();
        Test.startTest();
        posPageCtrl.filter = RecruitingTestUtils.OPENED;
        posPageCtrl.changePositionsList();
        Test.stopTest();
        System.assertEquals(2, posPageCtrl.positionsList.size());
        System.assertEquals(RecruitingTestUtils.OPENED, posPageCtrl.positionsList.get(0).Status__c);
    }
    @isTest
    static void changePositionsListExceptionTest() {
        PositionsPageController posPageCtrl = new PositionsPageController();
        Test.startTest();
            posPageCtrl.filter = RecruitingTestUtils.ERROR_STATUS;
            posPageCtrl.changePositionsList();
        Test.stopTest();
        Boolean caughtError = false;
        for(ApexPages.Message msg :  ApexPages.getMessages()) {
            if (msg.getSummary() == PositionsPageController.ERROR_MESSAGE) {
                caughtError = true;
            }
        }
        System.assert(caughtError);

    }
    @isTest
    static void saveTest() {
        PositionsPageController posPageCtrl = new PositionsPageController();
        for (Position__c pos : posPageCtrl.positionsList) {
            pos.Status__c = RecruitingTestUtils.CLOSED;
        }
        Test.startTest();
        posPageCtrl.save();
        Test.stopTest();
        for (Position__c pos : [SELECT Status__c FROM Position__c]) {
            System.assertEquals(RecruitingTestUtils.CLOSED, pos.Status__c);
        }
        System.assertEquals(PositionsPageController.SUCCESS_MESSAGE, ApexPages.getMessages().get(0).getSummary());
    }
    @isTest
    static void saveExceptionTest() {
        PositionsPageController posPageCtrl = new PositionsPageController();
        posPageCtrl.positionsList.get(0).Location__c = null;
        Test.startTest();
        posPageCtrl.save();
        Test.stopTest();
        Boolean caughtError = false;
        for(ApexPages.Message msg :  ApexPages.getMessages()) {
            if (msg.getSummary() == PositionsPageController.ERROR_MESSAGE) {
                caughtError = true;
            }
        }
        System.assert(caughtError);
    }
}