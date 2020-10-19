public class PositionsAutoCloseOldHandler {
    public static final Integer OLD_POSITIONS_QUERY_LIMIT = 10000;
    public static final Integer DAYS_EXPIRED = 90;
    public static final String CLOSED = 'Closed';
    public static final String OPENED = 'Opened';
    
    public void closeOldPositions() {
        List<testtest123__Position__c> positions = [SELECT testtest123__Status__c, testtest123__Date_Opened__c 
            FROM testtest123__Position__c WHERE (testtest123__Status__c =: OPENED 
            AND testtest123__Date_Opened__c <: (Date.today() - DAYS_EXPIRED)) 
        LIMIT : OLD_POSITIONS_QUERY_LIMIT];
        for (testtest123__Position__c position : positions) {
            position.Status__c = CLOSED;
            position.Date_Closed__c = Date.today();
        }
        update positions;
    }

}