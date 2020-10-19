public with sharing class PositionsTableController {

    @AuraEnabled(cacheable=true)
    public static List<Position__c> getPositions(String status, Integer positionsPerPage, Integer currentPage) {
        try {
            return PositionsHelper.getPositions(status, positionsPerPage, currentPage);
        } catch(Exception e) {
            System.debug(e.getTypeName());
            System.debug(e.getMessage());
            throw new AuraHandledException(e.getTypeName() + ' ' + e.getMessage());
        }
    }

    @AuraEnabled(cacheable=true)
    public static Integer getPositionsCount (String status) {
        try {
            return PositionsHelper.getPositionsCount(status);
        } catch (Exception e) {
            System.debug(e.getTypeName());
            System.debug(e.getMessage());
            throw new AuraHandledException(e.getTypeName() + ' ' + e.getMessage());
        }
    }
    
    @AuraEnabled
    public static void updatePositions(Position__c[] positions){
        try {
            PositionsHelper.updatePositions(positions);
        } catch (Exception e) {
            System.debug(e.getTypeName());
            System.debug(e.getMessage());
            throw new AuraHandledException(e.getTypeName() + ' ' + e.getMessage());
        }
    }
}