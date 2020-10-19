public inherited sharing class JobAppHelper {
    public static List<JobApp__c> getJobApps(Id positionId) {
            return  [SELECT Name FROM JobApp__c WHERE JobApp__c.Position__c =: positionId 
                WITH SECURITY_ENFORCED ORDER BY CreatedDate LIMIT : PositionsHelper.MAX_QUERY_LIMIT];
    }
}