public with sharing class PositionDetailController {

    @AuraEnabled(cacheable=true)
    public static PositionsFieldsWrapper getPositionFields(Id positionId) {
        try {
            return PositionsHelper.getPositionDetailFields(positionId);
        } catch(Exception e) {
            System.debug(e.getTypeName());
            System.debug(e.getMessage());
            throw new AuraHandledException(e.getTypeName() + ' ' + e.getMessage());
        }
    }

    @AuraEnabled(cacheable=true)
    public static List<JobApp__c> getJobApps (Id positionId) {
        try {
            return JobAppHelper.getJobApps(positionId);
        } catch (Exception e) {
            System.debug(e.getTypeName());
            System.debug(e.getMessage());
            throw new AuraHandledException(e.getTypeName() + ' ' + e.getMessage());
        }
    }

    @AuraEnabled(cacheable=true)
    public static String getPositionClosedStatus () {
        try {
            return PositionsHelper.CLOSED;
        } catch (Exception e) {
            System.debug(e.getTypeName());
            System.debug(e.getMessage());
            throw new AuraHandledException(e.getTypeName() + ' ' + e.getMessage());
        }
    }
}