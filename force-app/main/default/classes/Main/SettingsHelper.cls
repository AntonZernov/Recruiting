public inherited sharing class SettingsHelper {
    public static final String RECRUITING_SETTINGS_NAME = 'Recruiting_Settings';
    public static final String RECRUITING_SETTINGS_LABEL = 'Recruiting Settings';
    public static final String RECRUITING_METADATA_FULLNAME = 
        'testtest123__Recruiting_Settings__mdt.testtest123__Recruiting_Settings';
    public static final String CANDIDATE_FIELDSET = 'testtest123__Candidate_fieldset__c';
    public static final String POSITIONS_CARDS_FIELDSET = 'testtest123__Position_fieldset__c';
    public static final String POSITION_FILTER_FIELDSET = 'testtest123__Position_filter_fieldset__c';
    public static final String POSITION_DETAIL_FIELDSET = 'testtest123__Position_detail_fields__c';
    public static final String IS_USER_PHOTO_VISIBLE = 'testtest123__Show_user_photo__c';


    public static Recruiting_Settings__mdt getRecruitingMetadata() {
        return [SELECT Candidate_fieldset__c, Position_fieldset__c, 
        Position_filter_fieldset__c, Position_detail_fields__c, 
        Show_user_photo__c FROM Recruiting_Settings__mdt 
                WHERE DeveloperName =: RECRUITING_SETTINGS_NAME];
    }
    
    
    public static void updateRecruitingMetadata(Recruiting_Settings__mdt recruitingMetadata) {
        MetadataDeployCallback callback = new MetadataDeployCallback();
        Metadata.DeployContainer mdContainer = createMetadataContainer(recruitingMetadata);
        Metadata.Operations.enqueueDeployment(mdContainer, callback);
    }

    @testVisible
    private static Metadata.DeployContainer createMetadataContainer(Recruiting_Settings__mdt recruitingMetadata) {
        Metadata.DeployContainer mdContainer = new Metadata.DeployContainer();
        mdContainer.addMetadata(createCustomMetadata(recruitingMetadata));
        return mdContainer;
    }

    @testVisible
    private static Metadata.CustomMetadata createCustomMetadata(Recruiting_Settings__mdt recruitingMetadata) {
        List<String> metadataFullName = new List<String>();
        metadataFullName.add(RECRUITING_METADATA_FULLNAME);
        List<Metadata.Metadata> metadataRecords = 
            Metadata.Operations.retrieve(Metadata.MetadataType.CustomMetadata, metadataFullName);

        Metadata.CustomMetadata customMetadata = (Metadata.CustomMetadata) metadataRecords.get(0);
        // Metadata.CustomMetadata customMetadata = new Metadata.CustomMetadata();
        // customMetadata.fullName = RECRUITING_METADATA_FULLNAME;
        // customMetadata.label = RECRUITING_SETTINGS_LABEL;

        Metadata.CustomMetadataValue candidateFieldSet = new Metadata.CustomMetadataValue();
    	candidateFieldSet.field = CANDIDATE_FIELDSET;
        candidateFieldSet.value = recruitingMetadata.testtest123__Candidate_fieldset__c;

        Metadata.CustomMetadataValue positionsCardsFieldSet = new Metadata.CustomMetadataValue();
    	positionsCardsFieldSet.field = POSITIONS_CARDS_FIELDSET;
        positionsCardsFieldSet.value = recruitingMetadata.testtest123__Position_fieldset__c;

        Metadata.CustomMetadataValue positionFilterFieldSet = new Metadata.CustomMetadataValue();
    	positionFilterFieldSet.field = POSITION_FILTER_FIELDSET;
        positionFilterFieldSet.value = recruitingMetadata.testtest123__Position_filter_fieldset__c;

        Metadata.CustomMetadataValue positionDetailFieldSet = new Metadata.CustomMetadataValue();
    	positionDetailFieldSet.field = POSITION_DETAIL_FIELDSET;
        positionDetailFieldSet.value = recruitingMetadata.testtest123__Position_detail_fields__c;

        Metadata.CustomMetadataValue showUserPhoto = new Metadata.CustomMetadataValue();
    	showUserPhoto.field = IS_USER_PHOTO_VISIBLE;
        showUserPhoto.value = recruitingMetadata.testtest123__Show_user_photo__c;

        customMetadata.values.add(candidateFieldSet);
        customMetadata.values.add(positionsCardsFieldSet);
        customMetadata.values.add(positionFilterFieldSet);
        customMetadata.values.add(positionDetailFieldSet);
        customMetadata.values.add(showUserPhoto);
        return customMetadata;
    }
}