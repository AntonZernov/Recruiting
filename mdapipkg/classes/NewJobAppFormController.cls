public with sharing class NewJobAppFormController {

    @AuraEnabled(cacheable=true)
    public static List<Position__c> getOpenedPositions() {
        try {
            return PositionsHelper.getPositions(PositionsHelper.OPENED);
        } catch (Exception e) {
            System.debug(e.getTypeName());
            System.debug(e.getMessage());
            throw new AuraHandledException(e.getTypeName() + ' ' + e.getMessage());
        }
    }
}