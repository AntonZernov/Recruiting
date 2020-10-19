public without sharing class JobAppTriggerHandler {
    public void closePositions(List<JobApp__c> newJobApps, List<JobApp__c> oldJobApps) {
        Set<Id> positionsIds = new Set<Id>();
        for (Integer i = 0; i < newJobApps.size(); i++) {
            if (newJobApps[i].Stage__c == PositionsHelper.HIRED && 
                oldJobApps[i].Stage__c != PositionsHelper.HIRED) {
                    positionsIds.add(newJobApps[i].Position__c);
            }
        }
        
        List<Position__c> positions = [SELECT Id, Name, Status__c FROM Position__c 
                                        WHERE (Id IN : positionsIds AND Status__c =: PositionsHelper.OPENED)];
        for (Position__c position : positions) {
                position.Status__c = PositionsHelper.CLOSED;
        }
        update positions;
    }
}