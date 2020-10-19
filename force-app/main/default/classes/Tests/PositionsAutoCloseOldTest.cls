@isTest
private class PositionsAutoCloseOldTest {
    @TestSetup
    static void makeData(){
        Date dateOpened = Date.today() - RecruitingTestUtils.DAYS_EXPIRED;
        RecruitingTestUtils.createOpenedPositions(5000, dateOpened);
        RecruitingTestUtils.createOpenedPositions(5);
    }
    @isTest
    static void positionsAutoCloseOldTest() {
        Test.startTest();
        String jobId = System.schedule(RecruitingTestUtils.CLOSE_OLD_POSITIONS_TEST,
        PositionsAutoCloseOld.EVERY_DAY, new PositionsAutoCloseOld());
        CronTrigger ct = [SELECT NextFireTime FROM CronTrigger WHERE id = :jobId];
        Test.stopTest();
        DateTime dt = DateTime.newInstance(Date.today() + 1, Time.newInstance(0, 0, 0, 0));
        System.assertEquals(dt, ct.NextFireTime);
        List<Position__c> closedPositions = [SELECT Date_Closed__c FROM Position__c WHERE 
                                        Status__c =: PositionsAutoCloseOldHandler.CLOSED];
        Integer openedPositionsCount = [SELECT COUNT() FROM Position__c WHERE 
                                        Status__c =: PositionsAutoCloseOldHandler.OPENED];
        Boolean isAllDatesCorrect = true;
        for (Position__c position : closedPositions) {
            if (position.Date_Closed__c != Date.today()) {
                isAllDatesCorrect = false;
            }
        }
        System.assertEquals(5000, closedPositions.size());
        System.assertEquals(5, openedPositionsCount);
        System.assert(isAllDatesCorrect);
    }
}