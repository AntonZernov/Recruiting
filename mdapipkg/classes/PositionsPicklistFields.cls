public with sharing class PositionsPicklistFields {
    @AuraEnabled
    public String name;
    @AuraEnabled
    public List<PositionsOptions> options;

    public PositionsPicklistFields(String name) {
        this.name = name;
        options = new List<PositionsOptions>();
    }
}