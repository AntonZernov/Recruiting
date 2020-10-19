public without sharing class PositionTriggerHandler {
    public void setDateClosed(List<Position__c> newPositions, List<Position__c> oldPositions) {
        for (Integer i = 0; i < newPositions.size(); i++) {
            if (newPositions[i].Status__c == PositionsHelper.CLOSED && 
                oldPositions[i].Status__c != PositionsHelper.CLOSED &&
                newPositions[i].Date_Closed__c != Date.today()) {
                    newPositions[i].Date_Closed__c = Date.today();
            }

        }
    }
}