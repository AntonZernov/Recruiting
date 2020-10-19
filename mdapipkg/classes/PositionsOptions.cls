public with sharing class PositionsOptions {
    @AuraEnabled
    public String label;
    @AuraEnabled
    public String value;

    public PositionsOptions(String label, String value) {
        this.label = label;
        this.value = value;
    }
}