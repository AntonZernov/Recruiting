public with sharing class CreateJobAppController {
    @AuraEnabled(cacheable=true)
    public static List<Candidate__c> getCandidates() {
        try {
            return CandidateHelper.getCandidates();
        } catch (Exception e) {
            System.debug(e.getTypeName());
            System.debug(e.getMessage());
            throw new AuraHandledException(e.getTypeName() + ' ' + e.getMessage());
        }
    }
}