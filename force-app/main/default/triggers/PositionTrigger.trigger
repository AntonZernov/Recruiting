trigger PositionTrigger on Position__c (before update) {
    PositionTriggerHandler handler = new PositionTriggerHandler();
    handler.setDateClosed(Trigger.new, Trigger.old);
}