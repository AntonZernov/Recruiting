public with sharing class PositionsFieldsWrapper {
    @AuraEnabled
    public String name;
    @AuraEnabled
    public Id positionId;
    @AuraEnabled
    public List<Object> fields;
    @AuraEnabled
    public String createdByName;
    @AuraEnabled
    public String createdByPhotoURL;
    @AuraEnabled
    public String lastModifiedByName;
    @AuraEnabled
    public String lastModifiedByPhotoURL;
    public String fieldLabel{get; set;}
    public Boolean fieldAccessible{get; set;}

    public PositionsFieldsWrapper() {
        fields = new List<Object>();
    }
    public PositionsFieldsWrapper(String name, Id positionId) {
        this.name = name;
        this.positionId = positionId;
        fields = new List<Object>();
    }
}