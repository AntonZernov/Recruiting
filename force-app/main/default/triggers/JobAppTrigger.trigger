trigger JobAppTrigger on JobApp__c (after update) {
    JobAppTriggerHandler handler = new JobAppTriggerHandler();
        handler.closePositions(Trigger.new, Trigger.old); 
}